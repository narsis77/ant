local util = {}; util.__index = util

local ms = import_package "ant.math".stack
local renderpkg = import_package "ant.render"
local camerautil= renderpkg.camera

local function update_uniforms(uniforms, properties)
	for k, v in pairs(properties) do
		assert(type(v) == "table")
		local value = v.value
		local n = #value
		if n > 0 then
			value.n = #value
			uniforms[k] = v
		end
	end
end

local function add_directional_light_properties(world, uniform_properties)
	local dlight_info = {
		directional_lightdir = {name="Light Direction", type="v4", value={}},
		directional_color = {name="Light Color", type="color", value={}},
		directional_intensity = {name="Light Intensity", type="v4",value={}},
	}

	local dlight = world:first_entity "directional_light"
	if dlight then		
		local l = dlight.directional_light

		-- point from vertex position to light position
		local lightdir = ms:ref"vector" 
		ms(lightdir, dlight.rotation, "di=")
		table.insert(dlight_info.directional_lightdir.value, 	lightdir)
		table.insert(dlight_info.directional_color.value, 		l.color)
		table.insert(dlight_info.directional_intensity.value, 	{l.intensity, 0.28, 0, 0})
	end

	
	update_uniforms(uniform_properties, dlight_info)
end

local mode_type = {
	factor = 0,
	color = 1,
	gradient = 2,
}

--add ambient properties
local function add_ambient_light_propertices(world, uniform_properties)		
	local ambient_data = {		
		ambient_mode = {name ="ambient_mode",type="v4",value ={}},
		ambient_skycolor = {name ="ambient_skycolor",type="color",value={}},
		ambient_midcolor = {name ="ambient_midcolor",type="color",value={}},
		ambient_groundcolor = {name ="ambient_groundcolor",type="color",value={}},
	}

	for _,l_eid in world:each("ambient_light") do 
		local  am_ent = world[l_eid]
		local  l = am_ent.ambient_light 

		table.insert( ambient_data.ambient_mode.value, 			{mode_type[l.mode], l.factor, 0, 0})
		table.insert( ambient_data.ambient_skycolor.value,  	l.skycolor)
		table.insert( ambient_data.ambient_midcolor.value, 		l.midcolor)
		table.insert( ambient_data.ambient_groundcolor.value, 	l.groundcolor)
	end 

	update_uniforms(uniform_properties, ambient_data)
end 

function util.load_lighting_properties(world, render_properties)
	local lighting_properties = assert(render_properties.lighting.uniforms)

	add_directional_light_properties(world, lighting_properties)
	add_ambient_light_propertices(world, lighting_properties)

	local mq = world:first_entity "main_queue"
	if mq then
		local camera = camerautil.get_camera(world, mq.camera_tag)
		lighting_properties["u_eyepos"] = {name = "Eye Position", type="v4", value=camera.eyepos}
	end
end

local shadowmap_sampler_names = {}
for ii=1, 4 do
	shadowmap_sampler_names[ii] = "s_shadowmap" .. ii - 1
end

function util.load_shadow_properties(world, render_properties)
	local shadow_properties = render_properties.shadow
	local uniforms, textures = shadow_properties.uniforms, shadow_properties.textures
	local csm_stage_start_idx = 4
	local csm_matrixs = {n=nil, nil, nil, nil, nil}
	for _, eid in world:each "shadow" do
		local se = world[eid]
		local shadow = se.shadow
		local csm = shadow.csm

		local camera = camerautil.get_camera(world, se.camera_tag)

		local idx = csm.index
		local sm_name = shadowmap_sampler_names[idx]
		textures[sm_name] = {type="texture", stage = csm_stage_start_idx+idx-1, name = sm_name, 
							handle = se.render_target.frame_buffer.render_buffers[1].handle}

		local _, _, vp = ms:view_proj(camera, camera.frustum, true)
		csm_matrixs[csm.index] = vp
	end

	csm_matrixs.n = #csm_matrixs
	uniforms["u_csm_matrix"] = {type="m4", name="csm matrix", value=csm_matrixs}

	--TODO: currently, all the shadow entity have the samle shadow config
	-- we should move shadow config to a single entity using unique tag to reference it.
	local shadowentity = world:first_entity "shadow"
	local shadow = shadowentity.shadow
	uniforms["u_shadow_param1"] = {type="v4", name="x=[shadow bias],y=[normal offset],z=[texel size],w=[not use]", 
		value={shadow.bias, shadow.normal_offset, 1/shadow.shadowmap_size, 0}}
	local shadowcolor = shadow.color or {0, 0, 0}
	uniforms["u_shadow_param2"] = {type="v4", name="xyz=[shadow color],w=[not use]", 
		value={shadowcolor[1], shadowcolor[2], shadowcolor[3], 0}}
end

function util.load_postprocess_properties(world, render_properties)
	local mq = assert(world:first_entity("main_queue"))
	local postprocess = render_properties.postprocess
	local fb = mq.render_target.frame_buffer
	if fb then
		local rendertex = fb.render_buffers[1].handle
		postprocess.textures["s_mianview"] = {
			name = "Main view render texture", type = "texture",
			stage = 0, handle = rendertex,
		}
	end
end

function util.create_primitve_filter(viewtag, filtertag)
	return {
		view_tag = viewtag,
		filter_tag = filtertag,
	}
end

function util.update_render_entity_transform(world, eid, hierarchy_cache)
	local e = world[eid]
	local transform = e.transform
	local peid = transform.parent
	local localmat = ms:srtmat(transform)
	if peid then
		local parentresult = hierarchy_cache[peid]
		local parentmat = parentresult.world
		if parentmat then
			local hie_result = parentresult.hierarchy
			local slotname = transform.slotname
			if hie_result and slotname then
				local hiemat = ms:matrix(hie_result[slotname])
				localmat = ms(parentmat, hiemat, localmat, "**P")
			else
				localmat = ms(parentmat, localmat, "*P")
			end
		end
	end

	local w = transform.world
	ms(w, localmat, "=")
	return w
end
return util