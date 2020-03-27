local ecs = ...
local world = ecs.world

local render = import_package "ant.render"
local computil = render.components

local filterutil = require "filter.util"

local assetpkg = import_package "ant.asset"
local assetmgr = assetpkg.mgr

local math3d = require "math3d"

local filter_properties = ecs.system "filter_properties"
filter_properties.require_singleton "render_properties"
filter_properties.require_interface "ant.render|uniforms"

function filter_properties:init()
	local render_properties = world:singleton "render_properties"
	
end

function filter_properties:load_render_properties()
	local render_properties = world:singleton "render_properties"
	filterutil.load_lighting_properties(world, render_properties)
	filterutil.load_shadow_properties(world, render_properties)
	filterutil.load_postprocess_properties(world, render_properties)
end

local primitive_filter_sys = ecs.system "primitive_filter_system"

primitive_filter_sys.require_system "filter_properties"
primitive_filter_sys.require_singleton "hierarchy_transform_result"

--luacheck: ignore self
local function reset_results(results)
	for k, result in pairs(results) do
		result.n = 0
	end
end

--[[	!NOTICE!
	the material component defined with 'multiple' property which mean:
	1. there is only one material, the 'material' component reference this material item;
	2. there are more than one material, the 'material' component itself keep the first material item 
		other items will store in array, start from 1 to n -1;
	examples:
	...
	world:create_entity {
		...
		material = {
			ref_path=def_path1,
		}
	}
	...
	this entity's material component itself represent 'def_path1' material item, and NO any array item

	...
	world:create_entity {
		...
		material = {
			ref_path=def_path1,
			{ref_path=def_path2},
		}
	}
	entity's material component same as above, but it will stay a array, and array[1] is 'def_path2' material item
	
	About the 'prim.material' field
	prim.material field it come from glb data, it's a index start from [0, n-1] with n elements

	Here 'primidx' stand for primitive index in mesh, it's a lua index, start from [1, n] with n elements
]]
local function get_material(prim, primidx, materialcomp, material_refs)
	local materialidx
	if material_refs then
		local idx = material_refs[primidx] or material_refs[1]
		materialidx = idx - 1
	else
		materialidx = prim.material or primidx - 1
	end

	return materialcomp[materialidx] or materialcomp
end

local function is_visible(meshname, submesh_refs)
	if submesh_refs == nil then
		return true
	end

	if submesh_refs then
		local ref = submesh_refs[meshname]
		if ref then
			return ref.visible
		end
		return true
	end
end

local function get_material_refs(meshname, submesh_refs)
	if submesh_refs then
		local ref = submesh_refs[meshname]
		if ref then
			return ref.material_refs
		end
	end
end

local function add_result(eid, group, materialinfo, properties, worldmat, aabb, result)
	local idx = result.n + 1
	local r = result[idx]
	if r == nil then
		r = {
			mgroup 		= group,
			material 	= assert(materialinfo),
			properties 	= properties,
			worldmat 	= worldmat,
			aabb		= aabb,
			eid 		= eid,
		}
		result[idx] = r
	else
		r.mgroup 	= group
		r.material 	= assert(materialinfo)
		r.properties= properties
		r.worldmat 	= worldmat
		r.aabb		= aabb
		r.eid 		= eid
	end
	result.n = idx
	return r
end

local function insert_primitive(eid, group, material, worldmat, aabb, filter)
	local refkey = material.ref_path
	local mi = assert(assetmgr.get_resource(refkey))
	local resulttarget = assert(filter.result[mi.fx.surface_type.transparency])
	add_result(eid, group, mi, material.properties, worldmat, aabb, resulttarget)
end

local function filter_element(eid, rendermesh, etrans, materialcomp, filter)
	local meshscene = assetmgr.get_resource(rendermesh.reskey)

	local sceneidx = computil.scene_index(rendermesh.lodidx, meshscene)

	local scenes = meshscene.scenes[sceneidx]
	local submesh_refs = rendermesh.submesh_refs
	for _, meshnode in ipairs(scenes) do
		local name = meshnode.meshname
		if is_visible(name, submesh_refs) then
			local localtrans = meshnode.transform
			local material_refs = get_material_refs(name, submesh_refs)

			for groupidx, group in ipairs(meshnode) do
				local material = get_material(group, groupidx, materialcomp, material_refs)
				-- worldtrans is etrans * localtrans
				local aabb, worldtrans = math3d.aabb_transform(etrans, group.bounding and group.bounding.aabb or nil, localtrans)
				insert_primitive(eid, group, material, worldtrans, aabb, filter)
			end
		end
	end
end

-- TODO: we should optimize this code, it's too inefficient!
local function is_entity_prepared(e)
	local rm = e.rendermesh
	if assetmgr.get_resource(rm.reskey) == nil then
		return false
	end

	for _, m in world:each_component(e.material) do
		if assetmgr.get_resource(m.ref_path) == nil then
			return false
		end

		local p = m.properties
		if p then
			local t = p.textures
			if t then
				for k, tex in pairs(t) do
					if assetmgr.get_resource(tex.ref_path) == nil then
						return false
					end
				end
			end
		end
	end
	
	return true
end

local function update_entity_transform(hierarchy_cache, eid)
	local e = world[eid]

	local transform = e.transform
	
	if e.hierarchy then
		return transform.world
	end

	local srt = transform.srt
	local peid = transform.parent
	
	if peid then
		local worldmat = transform.world
		local parentresult = hierarchy_cache[peid]
		if parentresult then
			local parentmat = parentresult.world
			local hie_result = parentresult.hierarchy
			local slotname = transform.slotname

			if hie_result and slotname then
				local hiemat = hie_result[slotname]
				worldmat.m = math3d.mul(parentmat, math3d.mul(hiemat, srt))
			else
				worldmat.m = math3d.mul(parentmat, srt)
			end
		end
		return worldmat
	end
	return srt
end

local function reset_hierarchy_transform_result(hierarchy_cache)
	for k in pairs(hierarchy_cache) do
		hierarchy_cache[k] = nil
	end
end

function primitive_filter_sys:filter_primitive()
	local hierarchy_cache = world:singleton "hierarchy_transform_result"
	for _, prim_eid in world:each "primitive_filter" do
		local e = world[prim_eid]
		local filter = e.primitive_filter
		reset_results(filter.result)
		local filtertag = filter.filter_tag

		for _, eid in world:each(filtertag) do
			local ce = world[eid]
			if is_entity_prepared(ce) then
				local worldmat = update_entity_transform(hierarchy_cache, eid)
				filter_element(eid, ce.rendermesh, worldmat, ce.material, filter)
			end
		end
	end

	reset_hierarchy_transform_result(hierarchy_cache)
end

