local ecs = ...
local world = ecs.world
local w = world.w

local math3d = require "math3d"

----iscenespace----
local m = ecs.action "mount"
function m.init(prefab, i, value)
	local e = world[prefab[i]]
    e.parent = prefab[value]
end

local iss = ecs.interface "iscenespace"
function iss.set_parent(eid, peid)
	local e = world[eid]
	e.parent = peid
	if e.scene_entity then
		if peid == nil or world[peid].scene_entity then
			world:pub {"component_changed", "parent", eid}
		end
	end
end

----scenespace_system----
local s = ecs.system "scenespace_system"

local evChangedParent = world:sub {"component_changed", "parent"}

local hie_scene = require "hierarchy.scene"
local scenequeue = hie_scene.queue()

local function inherit_entity_state(e)
	local state = e.state or 0
	local pe = world[e.parent]
	local pstate = pe.state
	if pstate then
		local MASK <const> = (1 << 32) - 1
		e.state = ((state>>32) | state | pstate) & MASK
	end
end

local function inherit_material(e)
	local pe = world[e.parent]
	local p_rc = pe._rendercache
	local rc = e._rendercache
	if rc.fx == nil then
		rc.fx = p_rc.fx
	end
	if rc.state == nil then
		rc.state = p_rc.state
	end
	if rc.properties == nil then
		rc.properties = p_rc.properties
	end
end

local function mount_scene_node(scene_id)
	local scene_node = w:object("scene_node", scene_id)
	if scene_node._parent then
		local parent = world[scene_node._parent]._scene_id
		assert(parent)
		scene_node.parent = parent
		scene_node._parent = nil
		scenequeue:mount(scene_id, parent)
	else
		scenequeue:mount(scene_id, 0)
	end
end

local function update_scene_node(node)
	if node.srt == nil and node.parent == nil then
		return
	end
	node.worldmat = node.srt and math3d.matrix(node.srt) or nil
	if node.parent and node.lock_target == nil then
		local pnode = w:object("scene_node", node.parent)
		if pnode.worldmat then
			node.worldmat = node.worldmat and math3d.mul(pnode.worldmat, node.worldmat) or math3d.matrix(pnode.worldmat)
		end
	end
	if node.worldmat == nil or node.bounding == nil then
		node.aabb = nil
	else
		node.aabb = math3d.aabb_transform(node.worldmat, node.bounding.aabb)
	end
end

local function sync_scene_node()
	w:clear "scene_sorted"
	for _, id in ipairs(scenequeue) do
		w:new {
			scene_sorted = id,
		}
	end
end

function s:init()
	w:register {
		name = "scene_sorted",
		type = "int"
	}
end

function s:luaecs_init_entity()
	local needsync = false

	for v in w:select "initializing scene_id:in" do
		mount_scene_node(v.scene_id)
		needsync = true
	end

	for _, _, eid in evChangedParent:unpack() do
		local e = world[eid]
		local id = e._scene_id
		if e.parent then
			local scene_node = w:object("scene_node", id)
			scene_node._parent = e.parent
		end
		mount_scene_node(id)
		needsync = true
	end

	if needsync then
		sync_scene_node()
		for v in w:select "scene_node(scene_sorted):in" do
			local node = v.scene_node
			if node.initializing then
				local eid = node.initializing
				local e = world[eid]
				if e.parent then
					inherit_entity_state(e)
					inherit_material(e)
				end
				node.initializing = nil
			end
		end
	end
end

function s:update_hierarchy()
end

function s:update_transform()
	for v in w:select "scene_node(scene_sorted):in" do
		update_scene_node(v.scene_node)
	end
	for v in w:select "render_object:in scene_node(scene_id):in" do
		local r, n = v.render_object, v.scene_node
		r.aabb = n.aabb
		r.worldmat = n.worldmat
	end
	for v in w:select "camera:in scene_node(scene_id):in" do
		local r, n = v.camera.rendercache, v.scene_node
		r.worldmat = n.worldmat
	end
end

function s:end_frame()
	local removed = {}
	for v in w:select "REMOVED scene_id:in" do
		local id = v.scene_id
		removed[id] = true
		w:release("scene_node", id)
	end
	if next(removed) then
		for v in w:select "scene_sorted:in" do
			local id = v.scene_sorted
			if removed[id] then
				scenequeue:mount(id)
			else
				local node = w:object("scene_node", id)
				if node.parent and removed[node.parent] then
					--TODO: remove parent in old ecs?
					scenequeue:mount(id, 0)
					node.parent = nil
				end
			end
		end
		scenequeue:clear()
		sync_scene_node()
	end
end
