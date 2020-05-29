--This file is auto generated by editor,do not modify!
return {
	pickup = {
		blit_viewid = 0,
		blit_buffer = {
			rb_idx = 0,
		},
		pickup_cache = {
			last_pick = -1,
			pick_ids = 0
		}
	},
	entityid = -1,
	vector = {
		[1] = 0.0,
		[2] = 0.0,
		[3] = 0.0,
		[4] = 0.0
	}, 
	shadow = {
		bias = 0.003,
		depth_type = "linear",
		normal_offset = 0,
		shadowmap_size = 1024
	},
	view_mode = "",
	matrix = {
		[1] = 0.0,
		[2] = 0.0,
		[3] = 0.0,
		[4] = 0.0,
		[5] = 0.0,
		[6] = 0.0,
		[7] = 0.0,
		[8] = 0.0,
		[9] = 0.0,
		[10] = 0.0,
		[11] = 0.0,
		[12] = 0.0,
		[13] = 0.0,
		[14] = 0.0,
		[15] = 0.0,
		[16] = 0.0
	},
	postprocess_input = {
		fb_idx = 0
	},
	rotation = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 1
	},
	procedural_sky = {
		turbidity = 2.15,
		grid_height = 1,
		attached_sun_light = -1,
		month = "June",
		latitude = 0.87266462599716,
		grid_width = 1,
		which_hour = 12
	},
	material = ""
	pass = {
		name = "",
		output = {
			fb_idx = 0
		},
		viewport = {
			rect = {
				w = 1,
				h = 1,
				y = 0,
				x = 0
			},
			clear_state = {
				clear = "all",
				stencil = 0,
				color = 808464639,
				depth = 1
			}
		},
		material = ""
	},
	attach = -1,
	box_shape = {
		size = 0.0,
		origin = {
			[1] = 0.0,
			[2] = 0.0,
			[3] = 0.0
		}
	},
	camera = {
		frustum = {
			f = 10000,
			t = 1,
			ortho = false,
			type = "mat",
			n = 0.1,
			l = -1,
			aspect = 1,
			b = -1,
			fov = 1,
			r = 1
		},
		updir = {
			[1] = 0.0,
			[2] = 0.0,
			[3] = 0.0,
			[4] = 0.0
		},
		eyepos = {
			[1] = 0.0,
			[2] = 0.0,
			[3] = 0.0,
			[4] = 0.0
		},
		viewdir = {
			[1] = 0.0,
			[2] = 0.0,
			[3] = 0.0,
			[4] = 0.0
		}
	},
	ik_tracker = {
		leg = ""
	},
	boolean = false,
	light = "",
	viewport = {
		rect = {
			w = 1,
			h = 1,
			y = 0,
			x = 0
		},
		clear_state = {
			clear = "all",
			stencil = 0,
			color = 808464639,
			depth = 1
		}
	},
	frame_stat = {
		bgfx_frames = 0,
		frame_num = 0
	},
	technique = {
		name = "",
		passes = {
			name = "",
			output = {
				fb_idx = 0
			},
			viewport = {
				rect = {
					w = 1,
					h = 1,
					y = 0,
					x = 0
				},
				clear_state = {
					clear = "all",
					stencil = 0,
					color = 808464639,
					depth = 1
				}
			},
			material = ""
		}
	},
	animation = {
		anilist = {
			resource = "",
			scale = 1,
			looptimes = 0
		}
	},
	quaternion = {
		[1] = 0.0,
		[2] = 0.0,
		[3] = 0.0,
		[4] = 0.0
	},
	postprocess = {
		techniques = 0
	},
	primitive_filter = world.component "primitive_filter" {
		filter_tag = "can_render"
	},
	blit_queue = true,
	position = {
		[1] = 0.0,
		[2] = 0.0,
		[3] = 0.0
	},
	physic_state = {
		velocity = 0.0
	},
	csm_split_config = {
		max_ratio = 1.0,
		pssm_lambda = 1.0,
		ratios = 0.0,
		min_ratio = 0.0,
		num_split = 4
	},
	submesh_ref = {
		visible = false
	},
	state_machine = {
		nodes = {
			transmits = {
				duration = 0.0
			}
		},
		current = ""
	},
	color = {
		[1] = 1,
		[2] = 1,
		[3] = 1,
		[4] = 1
	},
	ambient_light = {
		groundcolor = {
			[1] = 1,
			[2] = 1,
			[3] = 1,
			[4] = 1
		},
		dirty = true,
		skycolor = {
			[1] = 1,
			[2] = 1,
			[3] = 1,
			[4] = 1
		},
		mode = "color",
		midcolor = {
			[1] = 1,
			[2] = 1,
			[3] = 1,
			[4] = 1
		},
		factor = 0.3
	},
	animation_birth = "",
	postprocess_output = {
		fb_idx = 0
	},
	character_height_raycast = {
		dir = 0
	},
	hierarchy = {
	},
	technique_order = {
		orders = ""
	},
	rect = {
		w = 1,
		h = 1,
		y = 0,
		x = 0
	},
	fb_index = 0,
	directional_light = {
		dirty = true,
		intensity = 50,
		color = {
			[1] = 1,
			[2] = 1,
			[3] = 1,
			[4] = 1
		}
	},
	camera_eid = -1,
	mesh = {
	},
	spot_light = {
		angle = 60,
		intensity = 50,
		color = {
			[1] = 1,
			[2] = 1,
			[3] = 1,
			[4] = 1
		},
		dirty = true,
		range = 100
	},
	test_component = false,
	terrain_collider = {
		shape = {
			height_scaling = 1,
			origin = {
				[1] = 0.0,
				[2] = 0.0,
				[3] = 0.0
			},
			scaling = 1
		}
	},
	collider = {
	},
	editor_watching = true,
	point_light = {
		dirty = true,
		intensity = 50,
		color = {
			[1] = 1,
			[2] = 1,
			[3] = 1,
			[4] = 1
		},
		range = 100
	},
	real = 0.0,
	rb_index = 0,
	outline_entity = true,
	dynamic_object = true,
	blit_buffer = {
		rb_idx = 0,
	},
	visible = true,
	frustum = {
		f = 10000,
		t = 1,
		ortho = false,
		type = "mat",
		n = 0.1,
		l = -1,
		aspect = 1,
		b = -1,
		fov = 1,
		r = 1
	},
	transform = {
		srt = {
			s = {
				[1] = 1,
				[2] = 1,
				[3] = 1,
				[4] = 0
			},
			r = {
				[1] = 0,
				[2] = 0,
				[3] = 0,
				[4] = 1
			},
			t = {
				[1] = 0.0,
				[2] = 0.0,
				[3] = 0.0
			}
		},

	},
	string = "",
	terrain = {
		element_size = 7,
		tile_height = 2,
		tile_width = 2,
		section_size = 2,
		grid_unit = 1
	},
	render_properties = {
		postprocess = {
		},
		shadow = {
		},
		lighting = {
		}
	},
	copy_pass = {
		name = "",
		output = {
			fb_idx = 0
		},
		viewport = {
			rect = {
				w = 1,
				h = 1,
				y = 0,
				x = 0
			},
			clear_state = {
				clear = "all",
				stencil = 0,
				color = 808464639,
				depth = 1
			}
		},
		material = ""
	},
	editor = true,
	blit_viewid = 0,
	ik_data = {
		joints = {
		},
		pole_vector = {
			[1] = 0,
			[2] = 0,
			[3] = 0,
			[4] = 0
		},
		forward = {
			[1] = 0,
			[2] = 0,
			[3] = 1,
			[4] = 0
		},
		weight = 0.0,
		type = "aim",
		mid_axis = {
			[1] = 0,
			[2] = 0,
			[3] = 1,
			[4] = 0
		},
		offset = {
			[1] = 0,
			[2] = 0,
			[3] = 0,
			[4] = 0
		},
		up_axis = {
			[1] = 0,
			[2] = 1,
			[3] = 0,
			[4] = 0
		},
		twist_angle = 0.0,
		target = {
			[1] = 0,
			[2] = 0,
			[3] = 0,
			[4] = 1
		},
		soften = 0.0
	},
	pickup_viewtag = false,
	target_entity = -1,
	editable_hierarchy = "",
	rendermesh = {
		lodidx = 1
	},
	ignore_parent_scale = false,
	texture = {
		name = "",
		ref_path = "",
		stage = 0,
		type = ""
	},
	name = "",
	tag = true,
	filter_tag = "",
	shadow_quad = true,
	uniform = {
		name = "",
		value = {
		},
		type = ""
	},
	uniformdata = {
	},
	parent = -1,
	properties = {
	},
	can_render = true,
	sphere_shape = {
		radius = 0.0,
		origin = {
			[1] = 0.0,
			[2] = 0.0,
			[3] = 0.0
		}
	},
	can_select = true,
	can_cast = true,
	blit_render = true,
	gizmo_object = {
	},
	shadow_debug = true,
	scale = {
		[1] = 1,
		[2] = 1,
		[3] = 1,
		[4] = 0
	},
	ik = {
		jobs = {
			joints = {
			},
			pole_vector = {
				[1] = 0,
				[2] = 0,
				[3] = 0,
				[4] = 0
			},
			forward = {
				[1] = 0,
				[2] = 0,
				[3] = 1,
				[4] = 0
			},
			weight = 0.0,
			type = "aim",
			mid_axis = {
				[1] = 0,
				[2] = 0,
				[3] = 1,
				[4] = 0
			},
			offset = {
				[1] = 0,
				[2] = 0,
				[3] = 0,
				[4] = 0
			},
			up_axis = {
				[1] = 0,
				[2] = 1,
				[3] = 0,
				[4] = 0
			},
			twist_angle = 0.0,
			target = {
				[1] = 0,
				[2] = 0,
				[3] = 0,
				[4] = 1
			},
			soften = 0.0
		}
	},
	lock_target = {
		type = "",
		target = -1
	},
	capsule_shape = {
		origin = {
			[1] = 0.0,
			[2] = 0.0,
			[3] = 0.0
		},
		radius = 0.0,
		height = 0.0
	},
	skeleton = "",
	resource = "",
	terrain_shape = {
		height_scaling = 1,
		origin = {
			[1] = 0.0,
			[2] = 0.0,
			[3] = 0.0
		},
		scaling = 1
	},
	int = 0,
	render_target = {
		viewport = {
			rect = {
				w = 1,
				h = 1,
				y = 0,
				x = 0
			},
			clear_state = {
				clear = "all",
				stencil = 0,
				color = 808464639,
				depth = 1
			}
		}
	},
	clear_state = {
		clear = "all",
		stencil = 0,
		color = 808464639,
		depth = 1
	},
	character = {
		movespeed = 1.0
	},
	hierarchy_visible = false,
	main_queue = true,
	show_operate_gizmo = true,
	csm = {
		index = 0,
		split_ratios = 0.0,
		stabilize = true
	},
	postprocess_slot = {
		fb_idx = 0
	},
	viewid = 0,
	foot_ik_raycast = {
		trackers = {
			leg = ""
		},
		cast_dir = 0,
		foot_height = 0
	},
	state_machine_node = {
		transmits = {
			duration = 0.0
		}
	},
	state_machine_transmits = {
		duration = 0.0
	},
	point = {
		[1] = 0.0,
		[2] = 0.0,
		[3] = 0.0,
		[4] = 0.0
	},
	animation_content = {
		resource = "",
		scale = 1,
		looptimes = 0
	},
	pickup_cache = {
		last_pick = -1,
		pick_ids = 0
	},
}