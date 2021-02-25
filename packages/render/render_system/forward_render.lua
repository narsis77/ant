local ecs = ...
local world = ecs.world

local bgfx = require "bgfx"
local ipf = world:interface "ant.scene|iprimitive_filter"
local irq = world:interface "ant.render|irenderqueue"
local irender = world:interface "ant.render|irender"
local default_comp 	= import_package "ant.general".default
local icamera	= world:interface "ant.camera|camera"
local vpt = ecs.transform "visible_primitive_transform"
local function parse_rc(rc)
	local state = bgfx.parse_state(rc.state)
	local wm = state.WRITE_MASK:gsub("Z", "")
	if wm ~= state.WRITE_MASK then
		state.DEPTH_TEST = "EQUAL"
		state.WRITE_MASK = wm
		return setmetatable({
			state = bgfx.make_state(state)
		}, {__index=rc})
	end
	return rc
end

function vpt.process_entity(e)
	local f = e.primitive_filter
	f.insert_item = function (filter, fxtype, eid, rc)
		local items = filter.result[fxtype].items
		if rc then
			rc.eid = eid
			ipf.add_item(items, eid, parse_rc(rc))
		else
			ipf.remove_item(items, eid)
		end
	end
end

local fr_sys = ecs.system "forward_render_system"
local pd_mbs = {}
local function watch_main_queue(meid, deid)
	local mq = world[meid]
	local callbacks = {
		view_rect = function (m)
			local vr = mq.render_target.view_rect
			irq.set_view_rect(deid, vr)
		end,
		camera_eid = function (m)
			irq.set_camera(deid, mq.camera_eid)
		end,
		framebuffer = function (m)
			error "not implement"
		end,
	}

	for n, cb in pairs(callbacks) do
		pd_mbs[n] = {
			mb = world:sub{"component_changed", n, meid},
			cb = cb
		}
	end
end

function fr_sys:init()
	local vr = {w=world.args.width,h=world.args.height}
	local camera_eid = icamera.create{
		eyepos  = {0, 0, 0, 1},
		viewdir = {0, 0, 1, 0},
		frustum = default_comp.frustum(vr.w/vr.h),
        name = "default_camera",
	}
	local deid = irender.create_pre_depth_queue(vr, camera_eid)
	local meid = irender.create_main_queue(vr, camera_eid)

	watch_main_queue(meid, deid)
end

function fr_sys:data_changed()
	for _, d in pairs(pd_mbs) do
		local cb = d.cb
		for msg in d.mb:each() do
			cb(msg)
		end
	end
end