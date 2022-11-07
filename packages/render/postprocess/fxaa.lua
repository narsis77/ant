local ecs   = ...
local world = ecs.world
local w     = world.w

local setting = import_package "ant.settings".setting
local ENABLE_FXAA<const> = setting:data().graphic.postprocess.fxaa.enable
local renderutil = require "util"
local fxaasys = ecs.system "fxaa_system"

if not ENABLE_FXAA then
    renderutil.default_system(fxaasys, "init", "init_world", "fxaa", "data_changed")
    return
end

local mu        = import_package "ant.math".util
local fbmgr     = require "framebuffer_mgr"
local viewidmgr = require "viewid_mgr"
local util      = ecs.require "postprocess.util"

local imaterial = ecs.import.interface "ant.asset|imaterial"
local irender   = ecs.import.interface "ant.render|irender"
local irq       = ecs.import.interface "ant.render|irenderqueue"

function fxaasys:init()
    util.create_quad_drawer("fxaa_drawer", "/pkg/ant.resources/materials/postprocess/fxaa.material")
end

local fxaa_viewid<const> = viewidmgr.get "fxaa"

function fxaasys:init_world()
    util.create_queue(fxaa_viewid, mu.copy_viewrect(world.args.viewport), nil, "fxaa_queue", "fxaa_queue")
end

local vp_changed_mb = world:sub{"world_viewport_changed"}

function fxaasys:data_changed()
    for _, vp in vp_changed_mb:unpack() do
        irq.set_view_rect("fxaa_queue", vp)
        break
    end
end

function fxaasys:fxaa()
    local tme = w:first "tonemapping_queue render_target:in"
    local sceneldr_handle = fbmgr.get_rb(tme.render_target.fb_idx, 1).handle

    local fd = w:first "fxaa_drawer filter_material:in"
    imaterial.set_property(fd, "s_scene_ldr_color", sceneldr_handle)

    irender.draw(fxaa_viewid, "fxaa_drawer")
end

