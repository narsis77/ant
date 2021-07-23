local ecs = ...
local world = ecs.world
local w = world.w

local s = ecs.system "luaecs_sync_system"

local evCreate = world:sub {"component_register", "scene_entity"}
local evUpdateEntity = world:sub {"luaecs", "update_entity"}

local function isRenderObject(e)
	local rc = e._rendercache
	return rc.entity_state and rc.fx and rc.vb and rc.fx and rc.state
end

local function isCamera(e)
	return e.camera ~= nil
end

local function findEntity(eid)
    for v in w:select "eid:in" do
        if v.eid == eid then
            return v
        end
    end
end

function s:init()
    w:register {
        name = "initializing",
    }

	-- RenderObject
    w:register {
        name = "render_object_update",
    }
    w:register {
        name = "eid",
        type = "int",
    }
    w:register {
        name = "render_object",
        type = "lua",
    }
    w:register {
        name = "filter_material",
        type = "lua",
    }

	-- Camera
    w:register {
        name = "camera",
        type = "lua",
    }

	-- SceneObject
	w:register {
		name = "scene_node",
		type = "lua",
		ref = true,
	}
	w:register {
		name = "scene_id",
		type = "int",
	}
	w:register {
		name = "transform",
		type = "lua",
	}
end

function s:luaecs_sync()
	for _, _, eid in evCreate:unpack() do
		local e = world[eid]
		local initargs = { eid = eid, initializing = true }
		local rc = e._rendercache
		local parent
		if e.parent and world[e.parent].scene_entity then
			parent = e.parent
		end
		local scene_node = {
			srt = rc.srt,
			lock_target = e.lock_target,
			bounding = e._bounding,
			initializing = eid,
			_parent = parent,
		}
		local id = w:ref("scene_node", scene_node)
		initargs.scene_id = id
		e._scene_id = id

		if isRenderObject(e) then
			initargs.render_object = rc
			initargs.render_object_update = true
			initargs.filter_material = {}
		end
		if isCamera(e) then
			initargs.camera = {
				frustum     = e.frustum,
				clip_range  = e.clip_range,
				dof         = e.dof,
				rendercache = rc, -- TODO?
			}
		end
		w:new(initargs)
	end
	for _, _, eid in evUpdateEntity:unpack() do
		local e = world[eid]
		if isRenderObject(e) then
			local v = findEntity(eid)
			if v then
				v.render_object = e._rendercache
				v.render_object_update = true
				w:sync("eid render_object:out render_object_update:temp", v)
			end
		end
	end
	for _, eid in world:each "removed" do
		local e = world[eid]
		if e.scene_entity then
			local v = findEntity(eid)
			if v then
				w:remove(v)
				break
			end
		end
	end
end

function s:luaecs_sync_done()
	w:clear "initializing"
end
