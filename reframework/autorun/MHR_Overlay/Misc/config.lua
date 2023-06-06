local this = {};

local utils;
local language;

local sdk = sdk;
local tostring = tostring;
local pairs = pairs;
local ipairs = ipairs;
local tonumber = tonumber;
local require = require;
local pcall = pcall;
local table = table;
local string = string;
local Vector3f = Vector3f;
local d2d = d2d;
local math = math;
local json = json;
local log = log;
local fs = fs;
local next = next;
local type = type;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local assert = assert;
local select = select;
local coroutine = coroutine;
local utf8 = utf8;
local re = re;
local imgui = imgui;
local draw = draw;
local Vector2f = Vector2f;
local reframework = reframework;
local os = os;
local ValueType = ValueType;
local package = package;

this.version = "2.5";

this.config_folder = "MHR Overlay\\configs\\";
this.current_config_value_file_name = "MHR Overlay\\config.json";

this.current_config_name = nil;
this.current_config = nil;

this.config_names = {};
this.configs = {};

this.default_config = nil;

local is_old_config_transferred = false;

function this.init_default() 
	this.default_config = {
		version = this.version,

		global_settings = {
			language = "default",
	
			menu_font = {
				size = 17
			},
	
			UI_font = {
				family = "Consolas",
				size = 13,
				bold = true,
				italic = false
			},
	
			modifiers = {
				global_position_modifier = 1,
				global_scale_modifier = 1
			},
	
			performance = {
				max_monster_updates_per_tick = 2,
				prioritize_large_monsters = false
			},
	
			renderer = {
				use_d2d_if_available = true
			},
	
			module_visibility = {
				in_training_area = {
					large_monster_dynamic_UI = true,
					large_monster_static_UI = true,
					large_monster_highlighted_UI = true,
					damage_meter_UI = true,
					endemic_life_UI = true,
					--buff_UI = true
				},
	
				cutscene = {
					small_monster_UI = false,
					large_monster_dynamic_UI = false,
					large_monster_static_UI = false,
					large_monster_highlighted_UI = false,
					time_UI = false,
					damage_meter_UI = false,
					endemic_life_UI = false,
					--buff_UI = false
				},
	
				loading_quest = {
					small_monster_UI = false,
					large_monster_dynamic_UI = false,
					large_monster_static_UI = false,
					large_monster_highlighted_UI = false,
					time_UI = false,
					damage_meter_UI = false,
					endemic_life_UI = false,
					--buff_UI = false
				},
	
				quest_start_animation = {
					small_monster_UI = true,
					large_monster_dynamic_UI = true,
					large_monster_static_UI = true,
					large_monster_highlighted_UI = true,
					time_UI = true,
					damage_meter_UI = true,
					endemic_life_UI = true,
					--buff_UI = true
				},
	
				playing_quest = {
					small_monster_UI = true,
					large_monster_dynamic_UI = true,
					large_monster_static_UI = true,
					large_monster_highlighted_UI = true,
					time_UI = true,
					damage_meter_UI = true,
					endemic_life_UI = true,
					--buff_UI = true
				},
	
				killcam = {
					small_monster_UI = true,
					large_monster_dynamic_UI = true,
					large_monster_static_UI = true,
					large_monster_highlighted_UI = true,
					time_UI = true,
					damage_meter_UI = true,
					endemic_life_UI = true,
					--buff_UI = true
				},
	
				quest_end_timer = {
					small_monster_UI = true,
					large_monster_dynamic_UI = true,
					large_monster_static_UI = true,
					large_monster_highlighted_UI = true,
					time_UI = true,
					damage_meter_UI = true,
					endemic_life_UI = true,
					--buff_UI = true
				},
	
				quest_end_animation = {
					small_monster_UI = false,
					large_monster_dynamic_UI = false,
					large_monster_static_UI = false,
					large_monster_highlighted_UI = false,
					time_UI = false,
					damage_meter_UI = false,
					endemic_life_UI = false,
					--buff_UI = false
				},
	
				quest_end_screen = {
					small_monster_UI = false,
					large_monster_dynamic_UI = false,
					large_monster_static_UI = false,
					large_monster_highlighted_UI = false,
					time_UI = false,
					damage_meter_UI = false,
					endemic_life_UI = false,
					--buff_UI = false
				},
	
				reward_screen = {
					small_monster_UI = false,
					large_monster_dynamic_UI = false,
					large_monster_static_UI = true,
					large_monster_highlighted_UI = true,
					time_UI = true,
					damage_meter_UI = true,
					endemic_life_UI = false,
					--buff_UI = false
				},
	
				summary_screen = {
					small_monster_UI = false,
					large_monster_dynamic_UI = false,
					large_monster_static_UI = true,
					large_monster_highlighted_UI = true,
					time_UI = true,
					damage_meter_UI = true,
					endemic_life_UI = false,
					--buff_UI = false
				},
			},
	
			hotkeys_with_modifiers = {
				all_UI = {
					shift = false,
					ctrl = false,
					alt = false,
					key = 0
				},
	
				small_monster_UI = {
					shift = false,
					ctrl = false,
					alt = false,
					key = 0
				},
	
				large_monster_UI = {
					shift = false,
					ctrl = false,
					alt = false,
					key = 0
				},
	
				large_monster_dynamic_UI = {
					shift = false,
					ctrl = false,
					alt = false,
					key = 0
				},
	
				large_monster_static_UI = {
					shift = false,
					ctrl = false,
					alt = false,
					key = 0
				},
	
				large_monster_highlighted_UI = {
					shift = false,
					ctrl = false,
					alt = false,
					key = 0
				},
	
				time_UI = {
					shift = false,
					ctrl = false,
					alt = false,
					key = 0
				},
	
				damage_meter_UI = {
					shift = false,
					ctrl = false,
					alt = false,
					key = 0
				},
	
				endemic_life_UI = {
					shift = false,
					ctrl = false,
					alt = false,
					key = 0
				}
			}
		},
	
		small_monster_UI = {
			enabled = true,
	
			settings = {
				hide_dead_or_captured = true,
				orientation = "Horizontal"
			},
	
			dynamic_positioning = {
				enabled = true,
				max_distance = 300,
				opacity_falloff = true,
	
				world_offset = {
					x = 0,
					y = 3,
					z = 0
				},
	
				viewport_offset = {
					x = -50,
					y = 0
				}
			},
	
			static_spacing = {
				x = 110,
				y = 40
			},
	
			static_sorting = {
				type = "Normal",
				reversed_order = false
			},
	
			static_position = {
				x = 0,
				y = 0,
				anchor = "Top-Left"
			},
	
			monster_name_label = {
				visibility = true,

				settings = {
					right_alignment_shift = 0
				},

				text_formatting = "%s",
	
				offset = {
					x = 5,
					y = 0
				},

				color = 0xFFCCF4E1,
	
				shadow = {
					visibility = true,

					offset = {
						x = 1,
						y = 1
					},

					color = 0xFF000000
				}
			},
	
			health = {
				visibility = true,
	
				offset = {
					x = 0,
					y = 17
				},
	
				text_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",
					
					offset = {
						x = -22,
						y = -5
					},
					color = 0xFFCCF4E1,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				value_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s", -- current_health/max_health

					include = {
						current_value = true,
						max_value = true
					},

					offset = {
						x = 32,
						y = 0
					},

					color = 0xFFCCF4E1,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				percentage_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 6
					},

					text_formatting = "%.1f%%",
	
					offset = {
						x = -5,
						y = 0
					},

					color = 0xFFCCF4E1,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				bar = {
					visibility = true,

					settings = {
						fill_direction = "Left to Right"
					},

					offset = {
						x = 0,
						y = 0
					},
	
					size = {
						width = 100,
						height = 7
					},
	
					outline = {
						visibility = true,
						thickness = 1,
						offset = 0,
						style = "Center"
					},
	
					colors = {
						foreground = 0xB974A652,
						background = 0xB9000000,
						outline = 0xC0000000,
						capture_health = 0xB9CCCC33
					}
	
				}
			},
	
			ailments = {
				visibility = false,
	
				offset = {
					x = 10,
					y = 40
				},
	
				spacing = {
					x = 0,
					y = 24
				},
	
				settings = {
					hide_ailments_with_zero_buildup = true,
					hide_inactive_ailments_with_no_buildup_support = true,
					hide_all_inactive_ailments = false,
					hide_all_active_ailments = false,
					hide_disabled_ailments = true,
					time_limit = 15
				},
	
				sorting = {
					type = "Normal",
					reversed_order = false
				},
	
				filter = {
					paralysis = true,
					sleep = true,
					stun = true,
					flash = true,
					poison = true,
					blast = true,
					exhaust = true,
					ride = true,
					waterblight = true,
					fireblight = true,
					iceblight = true,
					thunderblight = true,
	
					fall_trap = true,
					shock_trap = true,
					tranq_bomb = true,
					dung_bomb = true,
					steel_fang = true,
					quick_sand = true,
					fall_otomo_trap = true,
					shock_otomo_trap = true
				},
	
				ailment_name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",
	
					include = {
						ailment_name = true,
						activation_count = true
					},
	
					offset = {
						x = 5,
						y = 0
					},

					color = 0xFFffb2e2,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				text_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = language.current_language.UI.buildup,

					offset = {
						x = -60,
						y = 6
					},

					color = 0xF1F4A3CC,
	
					shadow = {
						visibility = true,
						
						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				value_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s", -- current_buildup/max_buildup

					include = {
						current_value = true,
						max_value = true
					},

					offset = {
						x = 60,
						y = 13
					},

					color = 0xFFFFFFFF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				percentage_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 6
					},

					text_formatting = "%.1f%%",
	
					offset = {
						x = 0,
						y = 13
					},

					color = 0xFFFFFFFF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				timer_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%2.0f:%02.0f",
	
					offset = {
						x = 140,
						y = 13
					},

					color = 0xFFFFFFFF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				bar = {
					visibility = true,

					settings = {
						fill_direction = "Left to Right"
					},

					offset = {
						x = 0,
						y = 14
					},
	
					size = {
						width = 90,
						height = 4
					},
	
					outline = {
						visibility = true,
						thickness = 1,
						offset = 0,
						style = "Center"
					},
	
					colors = {
						foreground = 0xA7ff80ce,
						background = 0xA7000000,
						outline = 0xC0000000
					}
				}
			},
	
			ailment_buildups = {
				visibility = false,
	
				offset = {
					x = 115,
					y = 17
				},
	
				player_spacing = {
					x = 0,
					y = 24
				},
	
				ailment_spacing = {
					x = 0,
					y = 17
				},
	
				settings = {
					buildup_bar_relative_to = "Top Buildup",
					highlighted_bar = "Me",
					time_limit = 15
				},
	
				filter = {
					stun = true,
					poison = true,
					blast = true
				},
	
				sorting = {
					type = "Buildup",
					reversed_order = false
				},
	
				ailment_name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",
	
					include = {
						ailment_name = true,
						activation_count = true
					},

					offset = {
						x = 5,
						y = -17
					},

					color = 0xFF7cdbff,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				player_name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},
	
					text_formatting = "%s",

					offset = {
						x = 5,
						y = 0
					},

					color = 0xFFb5dded,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				buildup_value_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.0f",

					offset = {
						x = 115,
						y = 0
					},

					color = 0xFFb5dded,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				buildup_percentage_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 6
					},

					text_formatting = "%.1f%%",

					offset = {
						x = 152,
						y = 0
					},

					color = 0xFFb5dded,
	
					shadow = {
						visibility = true,
						offset = {
							x = 1,
							y = 1
						},
						color = 0xFF000000
					}
				},
	
				total_buildup_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",

					offset = {
						x = 5,
						y = 0
					},

					color = 0xFFFF9393,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				total_buildup_value_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.0f",

					offset = {
						x = 115,
						y = 0
					},

					color = 0xFFFF9393,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				buildup_bar = {
					visibility = true,

					settings = {
						fill_direction = "Left to Right"
					},

					offset = {
						x = 0,
						y = 17
					},
	
					size = {
						width = 200,
						height = 5
					},
	
					outline = {
						visibility = true,
						thickness = 1,
						offset = 0,
						style = "Center"
					},
	
					colors = {
						foreground = 0xA796CFE5,
						background = 0xA7000000,
						outline = 0xC0000000
					}
				},
	
				highlighted_buildup_bar = {
					visibility = true,

					settings = {
						fill_direction = "Left to Right"
					},

					offset = {
						x = 0,
						y = 17
					},
	
					size = {
						width = 200,
						height = 5
					},
	
					outline = {
						visibility = true,
						thickness = 1,
						offset = 0,
						style = "Center"
					},
	
					colors = {
						foreground = 0xA7F4D5A3,
						background = 0xA7000000,
						outline = 0xC0000000
					}
				}
			}
		},
	
		large_monster_UI = {
			dynamic = {
				enabled = true,
	
				settings = {
					hide_dead_or_captured = true,
					render_highlighted_monster = true,
					render_not_highlighted_monsters = true,
					max_distance = 300,
					opacity_falloff = true,
					time_limit = 15
				},
	
				world_offset = {
					x = 0,
					y = 6,
					z = 0
				},
	
				viewport_offset = {
					x = -100,
					y = 0
				},
	
				monster_name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",
	
					include = {
						monster_name = true,
						monster_id = false,
						crown = true,
						size = true,
						crown_thresholds = false
					},
	
					offset = {
						x = 5,
						y = 0
					},

					color = 0xFFCCF4E1,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				health = {
					visibility = true,
	
					offset = {
						x = 0,
						y = 17
					},
	
					text_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",

						offset = {
							x = -25,
							y = 2
						},

						color = 0xFFCCF4E1,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					value_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s", -- current_health/max_health

						include = {
							current_value = true,
							max_value = true
						},

						offset = {
							x = 5,
							y = 2
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					percentage_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",
	
						offset = {
							x = 150,
							y = 2
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 0
						},
	
						size = {
							width = 200,
							height = 7
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						normal_colors = {
							foreground = 0xB974A653,
							background = 0xB9000000,
							outline = 0xC0000000
						},
	
						capture_colors = {
							foreground = 0xB9CCCC33,
							background = 0x88000000,
							outline = 0xC0000000
						},
	
						capture_line = {
							visibility = true,
							offset = {
								x = 0,
								y = -3
							},
	
							size = {
								width = 2,
								height = 8
							},
	
							color = 0xB9000000
						}
					}
				},
	
				stamina = {
					visibility = false,
	
					offset = {
						x = 10,
						y = 7
					},
	
					text_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",

						offset = {
							x = -70,
							y = 0
						},

						color = 0xFFA3F5F0,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					value_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s", -- current_current/max_stamina

						include = {
							current_value = true,
							max_value = true
						},
						
						offset = {
							x = 45,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},
							color = 0xFF000000
						}
					},
	
					percentage_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",
	
						offset = {
							x = 135,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					timer_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%2.0f:%02.0f",
	
						offset = {
							x = 140,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 17
						},
	
						size = {
							width = 185,
							height = 6
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xB966CCC5,
							background = 0x88000000,
							outline = 0xC0000000
						}
					}
				},
	
				rage = {
					visibility = false,
	
					offset = {
						x = 10,
						y = 13
					},
	
					text_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",

						offset = {
							x = -70,
							y = 0
						},

						color = 0xFFA3F5F0,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					value_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s", -- current_rage/max_rage

						include = {
							current_value = true,
							max_value = true
						},

						offset = {
							x = 45,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					percentage_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",
	
						offset = {
							x = 135,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					timer_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%2.0f:%02.0f",
	
						offset = {
							x = 140,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 17
						},
	
						size = {
							width = 185,
							height = 6
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xB966CCC5,
							background = 0x88000000,
							outline = 0xC0000000
						}
					}
				},
	
				body_parts = {
					visibility = true,
	
					offset = {
						x = 10,
						y = 111
					},
	
					spacing = {
						x = 0,
						y = 33
					},
	
					settings = {
						render_inactive_anomaly_cores = false, 
						hide_undamaged_parts = true,
						filter_mode = "Current State",
						time_limit = 15
					},
	
					sorting = {
						type = "Normal",
						reversed_order = false
					},
	
					filter = {
						health_break_sever_anomaly = true,

						health_break_sever = true,
						health_break_anomaly = true,
						health_sever_anomaly = true,
						break_sever_anomaly = true,

						health_break = true,
						health_sever = true,
						health_anomaly = true,

						break_sever = true,
						break_anomaly = true,
						sever_anomaly = true,

						health = true,
						break_ = true,
						sever = true,
						anomaly = true
					},
	
					part_name_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",
	
						include = {
							part_name = true,
							flinch_count = false,
							break_count = true,
							break_max_count = true
						},
	
						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFf9d9ff,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},
							
							color = 0xFF000000
						}
					},
	
					part_health = {
						visibility = true,
	
						offset = {
							x = 0,
							y = 9
						},
	
						text_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = language.current_language.UI.HP,

							offset = {
								x = 100,
								y = -5
							},

							color = 0xFFF4A3CC,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						value_label = {
							visibility = true,

							settings = {
								right_alignment_shift = 11
							},

							text_formatting = "%s", -- current_health/max_health

							include = {
								current_value = true,
								max_value = false
							},

							offset = {
								x = 100,
								y = -5
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						percentage_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 6
							},

							text_formatting = "%.1f%%",
	
							offset = {
								x = 190,
								y = -5
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						bar = {
							visibility = true,

							settings = {
								fill_direction = "Left to Right"
							},

							offset = {
								x = 0,
								y = 6
							},
	
							size = {
								width = 185,
								height = 5
							},
	
							outline = {
								visibility = true,
								thickness = 1,
								offset = 0,
								style = "Center"
							},
	
							colors = {
								foreground = 0xB9CA85CC,
								background = 0x88000000,
								outline = 0xC0000000
							}
						}
					},
	
					part_break = {
						visibility = true,
	
						offset = {
							x = 0,
							y = 15
						},
	
						text_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = language.current_language.UI.part_break,

							offset = {
								x = -42,
								y = 6
							},

							color = 0xFFb2d0ff,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						value_label = {
							visibility = true,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = "%s",

							include = {
								current_value = true,
								max_value = false
							},

							offset = {
								x = 5,
								y = 6
	
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						percentage_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 6
							},

							text_formatting = "%.1f%%",
	
							offset = {
								x = 5,
								y = 17
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						bar = {
							visibility = true,

							settings = {
								fill_direction = "Left to Right"
							},

							offset = {
								x = 0,
								y = 7
							},
	
							size = {
								width = 92,
								height = 5
							},
	
							outline = {
								visibility = true,
								thickness = 1,
								offset = 0,
								style = "Center"
							},
	
							colors = {
								foreground = 0xB999BFFF,
								background = 0x88000000,
								outline = 0xC0000000
							}
						}
					},
	
					part_loss = {
						visibility = true,
	
						offset = {
							x = 94,
							y = 15
						},
	
						text_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = language.current_language.UI.part_sever,

							offset = {
								x = 97,
								y = 5
							},

							color = 0xFFff8095,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						value_label = {
							visibility = true,
							
							settings = {
								right_alignment_shift = 11
							},

							text_formatting = "%s",

							include = {
								current_value = true,
								max_value = false
							},

							offset = {
								x = 6,
								y = 6
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						percentage_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 6
							},

							text_formatting = "%.1f%%",
	
							offset = {
								x = 41,
								y = 17
							},
							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},
								
								color = 0xFF000000
							}
						},
	
						bar = {
							visibility = true,

							settings = {
								fill_direction = "Left to Right"
							},

							offset = {
								x = 0,
								y = 7
							},
	
							size = {
								width = 91,
								height = 5
							},
	
							outline = {
								visibility = true,
								thickness = 1,
								offset = 0,
								style = "Center"
							},
	
							colors = {
								foreground = 0xB9E57386,
								background = 0x88000000,
								outline = 0xC0000000
							}
						}
					},

					part_anomaly = {
						visibility = true,
	
						offset = {
							x = -10,
							y = 0
						},
	
						text_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = language.current_language.UI.part_anomaly_core,

							offset = {
								x = -90,
								y = 1
							},

							color = 0xFFFF6680,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						value_label = {
							visibility = true,

							settings = {
								right_alignment_shift = 11
							},

							text_formatting = "%s",

							include = {
								current_value = true,
								max_value = false
							},

							offset = {
								x = -84,
								y = 12
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						percentage_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 6
							},

							text_formatting = "%.1f%%",
	
							offset = {
								x = -48,
								y = 24
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						bar = {
							visibility = true,

							settings = {
								fill_direction = "Bottom to Top"
							},

							offset = {
								x = 0,
								y = 9
							},
	
							size = {
								width = 5,
								height = 24
							},
	
							outline = {
								visibility = true,
								thickness = 1,
								offset = 0,
								style = "Center"
							},
	
							colors = {
								foreground = 0xB9E53956,
								background = 0x88000000,
								outline = 0xC0000000
							}
						}
					}
				},
	
				ailments = {
					visibility = false,
	
					offset = {
						x = 10,
						y = 111
					},
	
					relative_offset = {
						x = 0,
						y = 45
					},
	
					spacing = {
						x = 0,
						y = 24
					},
	
					settings = {
						hide_ailments_with_zero_buildup = true,
						hide_inactive_ailments_with_no_buildup_support = true,
						hide_all_inactive_ailments = false,
						hide_all_active_ailments = false,
						hide_disabled_ailments = true,
						offset_is_relative_to_parts = true,
						time_limit = 15
					},
	
					sorting = {
						type = "Normal",
						reversed_order = false
					},
	
					filter = {
						paralysis = true,
						sleep = true,
						stun = true,
						flash = true,
						poison = true,
						blast = true,
						exhaust = true,
						ride = true,
						waterblight = true,
						fireblight = true,
						iceblight = true,
						thunderblight = true,
	
						fall_trap = true,
						shock_trap = true,
						tranq_bomb = true,
						dung_bomb = true,
						steel_fang = true,
						quick_sand = true,
						fall_otomo_trap = true,
						shock_otomo_trap = true
					},
	
					ailment_name_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",
	
						include = {
							ailment_name = true,
							activation_count = true
						},
	
						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFffb2e2,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					text_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = language.current_language.UI.buildup,

						offset = {
							x = -60,
							y = 7
						},

						color = 0xFFffb2e2,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s", -- current_buildup/max_buildup

						include = {
							current_value = true,
							max_value = true
						},

						offset = {
							x = 45,
							y = 13
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					percentage_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",
	
						offset = {
							x = 135,
							y = 13
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					timer_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%2.0f:%02.0f",
	
						offset = {
							x = 140,
							y = 13
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 14
						},
	
						size = {
							width = 185,
							height = 5
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xA7ff80ce,
							background = 0xA7000000,
							outline = 0xC0000000
						}
					}
				},
	
				ailment_buildups = {
					visibility = false,
	
					offset = {
						x = 220,
						y = 17
					},
	
					player_spacing = {
						x = 0,
						y = 24
					},
	
					ailment_spacing = {
						x = 0,
						y = 17
					},
	
					settings = {
						buildup_bar_relative_to = "Top Buildup",
						highlighted_bar = "Me",
						time_limit = 15
					},
	
					filter = {
						stun = true,
						poison = true,
						blast = true
					},
	
					sorting = {
						type = "Buildup",
						reversed_order = false
					},
	
					ailment_name_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

							
						text_formatting = "%s",
	
						include = {
							ailment_name = true,
							activation_count = true
						},

						offset = {
							x = 5,
							y = -17
						},

						color = 0xFF7cdbff,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					player_name_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},
	
						text_formatting = "%s",

						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFB5DDED,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},
							
							color = 0xFF000000
						}
					},
	
					buildup_value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%.0f",

						offset = {
							x = 115,
							y = 0
						},

						color = 0xFFB5DDED,
	
						shadow = {
							visibility = true,
							
							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					buildup_percentage_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",

						offset = {
							x = 152,
							y = 0
						},

						color = 0xFFB5DDED,
	
						shadow = {
							visibility = true,
							offset = {
								x = 1,
								y = 1
							},
							
							color = 0xFF000000
						}
					},
	
					total_buildup_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",

						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFF27979,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					total_buildup_value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%.0f",

						offset = {
							x = 115,
							y = 0
						},

						color = 0xFFF27979,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					buildup_bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 17
						},
	
						size = {
							width = 200,
							height = 5
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xA796CFE5,
							background = 0xA7000000,
							outline = 0xC0000000
						}
					},
	
					highlighted_buildup_bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 17
						},
	
						size = {
							width = 200,
							height = 5
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xA7FDC689,
							background = 0xA7000000,
							outline = 0xC0000000
						}
					}
				}
			},
	
			static = {
				enabled = true,
	
				spacing = {
					x = 250,
					y = 40
				},
	
				settings = {
					hide_dead_or_captured = true,
					render_highlighted_monster = true,
					render_not_highlighted_monsters = true,
					highlighted_monster_location = "Normal",
					orientation = "Horizontal",
					time_limit = 15
				},
	
				sorting = {
					type = "Normal",
					reversed_order = false
				},
	
				position = {
					x = 525,
					y = 50,
					anchor = "Bottom-Left"
				},
	
				monster_name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",
	
					include = {
						monster_name = true,
						monster_id = false,
						crown = true,
						size = true,
						crown_thresholds = false
					},
	
					offset = {
						x = 5,
						y = 0
					},

					color = 0xFFCCF4E1,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				health = {
					visibility = true,
	
					offset = {
						x = 0,
						y = 17
					},
	
					text_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",

						offset = {
							x = -25,
							y = 2
						},

						color = 0xFFCCF4E1,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s", -- current_health/max_health

						include = {
							current_value = true,
							max_value = true
						},
					
						offset = {
							x = 5,
							y = 2
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					percentage_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",
	
						offset = {
							x = 150,
							y = 2
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 0
						},
	
						size = {
							width = 200,
							height = 20
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						normal_colors = {
							foreground = 0xB974A653,
							background = 0xB9000000,
							outline = 0xC0000000
						},
	
						capture_colors = {
							foreground = 0xB9CCCC33,
							background = 0x88000000,
							outline = 0xC0000000
						},
	
						capture_line = {
							visibility = true,
							offset = {
								x = 0,
								y = -3
							},
	
							size = {
								width = 2,
								height = 8
							},
	
							color = 0xB9000000
						}
					}
				},
	
				stamina = {
					visibility = true,
	
					offset = {
						x = 0,
						y = 37
					},
	
					text_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",

						offset = {
							x = 15,
							y = 0
						},

						color = 0xFFA3F5F0,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					value_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s", -- current_stamina/max_stamina

						include = {
							current_value = true,
							max_value = true
						},

						offset = {
							x = 55,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					percentage_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",
	
						offset = {
							x = 145,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					timer_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%2.0f:%02.0f",
	
						offset = {
							x = 140,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 0
						},
	
						size = {
							width = 200,
							height = 5
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xB966CCC5,
							background = 0x88000000,
							outline = 0xC0000000
						}
					}
				},
	
				rage = {
					visibility = true,
	
					offset = {
						x = 0,
						y = 42
					},
	
					text_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",

						offset = {
							x = 15,
							y = 19
						},

						color = 0xFFFF9393,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					value_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s", -- current_rage/max_rage

						include = {
							current_value = true,
							max_value = true
						},

						offset = {
							x = 55,
							y = 36
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					percentage_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",
	
						offset = {
							x = 150,
							y = -9
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					timer_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%2.0f:%02.0f",
	
						offset = {
							x = 157,
							y = -9
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 0
						},
	
						size = {
							width = 200,
							height = 5
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xB9CC6666,
							background = 0x88000000,
							outline = 0xC0000000
						}
					}
				},
	
				body_parts = {
					visibility = true,
	
					offset = {
						x = 10,
						y = 111
					},
	
					spacing = {
						x = 0,
						y = 33
					},
	
					settings = {
						render_inactive_anomaly_cores = false, 
						hide_undamaged_parts = true,
						filter_mode = "Current State",
						time_limit = 15
					},
	
					sorting = {
						type = "Normal",
						reversed_order = false
					},
	
					filter = {
						health_break_sever_anomaly = true,

						health_break_sever = true,
						health_break_anomaly = true,
						health_sever_anomaly = true,
						break_sever_anomaly = true,

						health_break = true,
						health_sever = true,
						health_anomaly = true,

						break_sever = true,
						break_anomaly = true,
						sever_anomaly = true,

						health = true,
						break_ = true,
						sever = true,
						anomaly = true
					},
	
					part_name_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",
	
						include = {
							part_name = true,
							flinch_count = false,
							break_count = true,
							break_max_count = true
						},
	
						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFf9d9ff,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					part_health = {
						visibility = true,
	
						offset = {
							x = 0,
							y = 9
						},
	
						text_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = language.current_language.UI.HP,

							offset = {
								x = 100,
								y = -5
							},

							color = 0xFFF4A3CC,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						value_label = {
							visibility = true,

							settings = {
								right_alignment_shift = 11
							},

							text_formatting = "%s", -- current_health/max_health

							include = {
								current_value = true,
								max_value = false
							},

							offset = {
								x = 100,
								y = -5
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						percentage_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 6
							},

							text_formatting = "%.1f%%",
	
							offset = {
								x = 190,
								y = -5
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						bar = {
							visibility = true,

							settings = {
								fill_direction = "Left to Right"
							},

							offset = {
								x = 0,
								y = 6
							},
	
							size = {
								width = 185,
								height = 5
							},
	
							outline = {
								visibility = true,
								thickness = 1,
								offset = 0,
								style = "Center"
							},
	
							colors = {
								foreground = 0xB9CA85CC,
								background = 0x88000000,
								outline = 0xC0000000
							}
						}
					},
	
					part_break = {
						visibility = true,
	
						offset = {
							x = 0,
							y = 15
						},
	
						text_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = language.current_language.UI.part_break,

							offset = {
								x = -42,
								y = 6
							},

							color = 0xFFb2d0ff,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						value_label = {
							visibility = true,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = "%s",

							include = {
								current_value = true,
								max_value = false
							},

							offset = {
								x = 5,
								y = 6
	
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						percentage_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 6
							},

							text_formatting = "%.1f%%",
	
							offset = {
								x = 5,
								y = 17
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						bar = {
							visibility = true,

							settings = {
								fill_direction = "Left to Right"
							},

							offset = {
								x = 0,
								y = 7
							},
	
							size = {
								width = 92,
								height = 5
							},
	
							outline = {
								visibility = true,
								thickness = 1,
								offset = 0,
								style = "Center"
							},
	
							colors = {
								foreground = 0xB999BFFF,
								background = 0x88000000,
								outline = 0xC0000000
							}
						}
					},
	
					part_loss = {
						visibility = true,
	
						offset = {
							x = 94,
							y = 15
						},
	
						text_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = language.current_language.UI.part_sever,

							offset = {
								x = 97,
								y = 5
							},

							color = 0xFFff8095,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						value_label = {
							visibility = true,

							settings = {
								right_alignment_shift = 11
							},

							text_formatting = "%s",

							include = {
								current_value = true,
								max_value = false
							},

							offset = {
								x = 6,
								y = 6
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						percentage_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 6
							},

							text_formatting = "%.1f%%",
	
							offset = {
								x = 41,
								y = 17
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						bar = {
							visibility = true,

							settings = {
								fill_direction = "Left to Right"
							},

							offset = {
								x = 0,
								y = 7
							},
	
							size = {
								width = 91,
								height = 5
							},
	
							outline = {
								visibility = true,
								thickness = 1,
								offset = 0,
								style = "Center"
							},
	
							colors = {
								foreground = 0xB9E57386,
								background = 0x88000000,
								outline = 0xC0000000
							}
						}
					},

					part_anomaly = {
						visibility = true,
	
						offset = {
							x = -10,
							y = 0
						},
	
						text_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = language.current_language.UI.part_anomaly_core,

							offset = {
								x = -90,
								y = 1
							},

							color = 0xFFFF6680,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						value_label = {
							visibility = true,

							settings = {
								right_alignment_shift = 11
							},

							text_formatting = "%s",

							include = {
								current_value = true,
								max_value = false
							},

							offset = {
								x = -84,
								y = 12
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						percentage_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 6
							},

							text_formatting = "%.1f%%",
	
							offset = {
								x = -48,
								y = 24
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						bar = {
							visibility = true,

							settings = {
								fill_direction = "Bottom to Top"
							},

							offset = {
								x = 0,
								y = 9
							},
	
							size = {
								width = 5,
								height = 24
							},
	
							outline = {
								visibility = true,
								thickness = 1,
								offset = 0,
								style = "Center"
							},
	
							colors = {
								foreground = 0xB9E53956,
								background = 0x88000000,
								outline = 0xC0000000
							}
						}
					}
				},
	
				ailments = {
					visibility = false,
	
					offset = {
						x = 10,
						y = 73
					},
	
					relative_offset = {
						x = 0,
						y = 45
					},
	
					spacing = {
						x = 0,
						y = 24
					},
	
					settings = {
						hide_ailments_with_zero_buildup = true,
						hide_inactive_ailments_with_no_buildup_support = true,
						hide_all_inactive_ailments = false,
						hide_all_active_ailments = false,
						hide_disabled_ailments = true,
	
						offset_is_relative_to_parts = true,
						time_limit = 15
					},
	
					sorting = {
						type = "Normal",
						reversed_order = false
					},
	
					filter = {
						paralysis = true,
						sleep = true,
						stun = true,
						flash = true,
						poison = true,
						blast = true,
						exhaust = true,
						ride = true,
						waterblight = true,
						fireblight = true,
						iceblight = true,
						thunderblight = true,
	
						fall_trap = true,
						shock_trap = true,
						tranq_bomb = true,
						dung_bomb = true,
						steel_fang = true,
						quick_sand = true,
						fall_otomo_trap = true,
						shock_otomo_trap = true
					},
	
					ailment_name_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",
	
						include = {
							ailment_name = true,
							activation_count = true
						},
	
						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFffb2e2,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					text_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = language.current_language.UI.buildup,

						offset = {
							x = -60,
							y = 7
						},

						color = 0xFFffb2e2,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s", -- current_buildup/max_buildup

						include = {
							current_value = true,
							max_value = true
						},

						offset = {
							x = 45,
							y = 13
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					percentage_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",
	
						offset = {
							x = 135,
							y = 13
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					timer_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%2.0f:%02.0f",
	
						offset = {
							x = 140,
							y = 13
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},
							
							color = 0xFF000000
						}
					},
	
					bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 14
						},
	
						size = {
							width = 185,
							height = 5
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xA7FF80CE,
							background = 0xA7000000,
							outline = 0xC0000000
						}
					}
				},
	
				ailment_buildups = {
					visibility = false,
	
					offset = {
						x = 220,
						y = 17
					},
	
					player_spacing = {
						x = 0,
						y = 24
					},
	
					ailment_spacing = {
						x = 0,
						y = 17
					},
	
					settings = {
						buildup_bar_relative_to = "Top Buildup",
						highlighted_bar = "Me",
						time_limit = 15
					},
	
					filter = {
						stun = true,
						poison = true,
						blast = true
					},
	
					sorting = {
						type = "Buildup",
						reversed_order = false
					},
	
					ailment_name_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",
	
						include = {
							ailment_name = true,
							activation_count = true
						},


						offset = {
							x = 5,
							y = -17
						},

						color = 0xFF7cdbff,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					player_name_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},
	
						text_formatting = "%s",

						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFb5dded,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					buildup_value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%.0f",

						offset = {
							x = 115,
							y = 0
						},

						color = 0xFFb5dded,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					buildup_percentage_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",

						offset = {
							x = 152,
							y = 0
						},

						color = 0xFFb5dded,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					total_buildup_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",

						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFFF9393,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},
							
							color = 0xFF000000
						}
					},
	
					total_buildup_value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%.0f",

						offset = {
							x = 115,
							y = 0
						},

						color = 0xFFFF9393,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					buildup_bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 17
						},
	
						size = {
							width = 200,
							height = 5
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xA796CFE5,
							background = 0xA7000000,
							outline = 0xC0000000
						}
					},
	
					highlighted_buildup_bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 17
						},
	
						size = {
							width = 200,
							height = 5
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xA7F4D5A3,
							background = 0xA7000000,
							outline = 0xC0000000
						}
					}
				}
			},
	
			highlighted = {
				enabled = true,

				position = {
					x = 615,
					y = 25, -- y = 44,
					anchor = "Top-Right"
				},
	
				auto_highlight = {
					enabled = false,
					mode = "Closest"
				},
	
				monster_name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",
	
					include = {
						monster_name = true,
						monster_id = false,
						crown = true,
						size = true,
						crown_thresholds = false
					},
	
					offset = {
						x = 5,
						y = 0
					},

					color = 0xFFCCF4E1,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				health = {
					visibility = true,
	
					offset = {
						x = 0,
						y = 17
					},
	
					text_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",

						offset = {
							x = -25,
							y = 2
						},

						color = 0xFFCCF4E1,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s", -- current_health/max_health

						include = {
							current_value = true,
							max_value = true
						},

						offset = {
							x = 5,
							y = 2
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					percentage_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",
	
						offset = {
							x = 150,
							y = 2
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 0
						},
	
						size = {
							width = 200,
							height = 20
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						normal_colors = {
							foreground = 0xB974A653,
							background = 0xB9000000,
							outline = 0xC0000000
						},
	
						capture_colors = {
							foreground = 0xB9CCCC33,
							background = 0x88000000,
							outline = 0xC0000000
						},
	
						capture_line = {
							visibility = true,
							offset = {
								x = 0,
								y = -3
							},
	
							size = {
								width = 2,
								height = 8
							},
	
							color = 0xB9000000
						}
					}
				},
	
				stamina = {
					visibility = true,
	
					offset = {
						x = 10,
						y = 37
					},
	
					text_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",

						offset = {
							x = 15 - 10,
							y = 0
						},

						color = 0xFFA3F5F0,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s", -- current_stamina/max_stamina

						include = {
							current_value = true,
							max_value = true
						},

						offset = {
							x = 45,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					percentage_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",
	
						offset = {
							x = 135,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					timer_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%2.0f:%02.0f",
	
						offset = {
							x = 140,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 10 - 10,
							y = 17
						},
	
						size = {
							width = 185,
							height = 7
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xB966CCC5,
							background = 0x88000000,
							outline = 0xC0000000
						}
					}
				},
	
				rage = {
					visibility = true,
	
					offset = {
						x = 10,
						y = 61
					},
	
					text_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",

						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFFF9393,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s", -- current_rage/max_rage

						include = {
							current_value = true,
							max_value = true
						},

						offset = {
							x = 45,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					percentage_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",
	
						offset = {
							x = 135,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					timer_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%2.0f:%02.0f",
	
						offset = {
							x = 140,
							y = 17
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 17
						},
	
						size = {
							width = 185,
							height = 7
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xB9CC6666,
							background = 0x88000000,
							outline = 0xC0000000
						}
					}
				},
	
				body_parts = {
					visibility = true,
	
					offset = {
						x = 10,
						y = 111
					},
	
					spacing = {
						x = 0,
						y = 33
					},
	
					settings = {
						render_inactive_anomaly_cores = false, 
						hide_undamaged_parts = true,
						filter_mode = "Current State",
						time_limit = 15
					},
	
					sorting = {
						type = "Normal",
						reversed_order = false
					},
	
					filter = {
						health_break_sever_anomaly = true,

						health_break_sever = true,
						health_break_anomaly = true,
						health_sever_anomaly = true,
						break_sever_anomaly = true,

						health_break = true,
						health_sever = true,
						health_anomaly = true,

						break_sever = true,
						break_anomaly = true,
						sever_anomaly = true,

						health = true,
						break_ = true,
						sever = true,
						anomaly = true
					},
	
					part_name_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",
	
						include = {
							part_name = true,
							flinch_count = false,
							break_count = true,
							break_max_count = true
						},
	
						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFf9d9ff,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					part_health = {
						visibility = true,
	
						offset = {
							x = 0,
							y = 9
						},
	
						text_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = language.current_language.UI.HP,

							offset = {
								x = 100,
								y = -5
							},

							color = 0xFFF4A3CC,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						value_label = {
							visibility = true,

							settings = {
								right_alignment_shift = 11
							},

							text_formatting = "%s", -- current_health/max_health

							include = {
								current_value = true,
								max_value = false
							},

							offset = {
								x = 100,
								y = -5
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						percentage_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 6
							},

							text_formatting = "%.1f%%",
	
							offset = {
								x = 190,
								y = -5
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						bar = {
							visibility = true,

							settings = {
								fill_direction = "Left to Right"
							},

							offset = {
								x = 0,
								y = 6
							},
	
							size = {
								width = 185,
								height = 5
							},
	
							outline = {
								visibility = true,
								thickness = 1,
								offset = 0,
								style = "Center"
							},
	
							colors = {
								foreground = 0xB9CA85CC,
								background = 0x88000000,
								outline = 0xC0000000
							}
						}
					},
	
					part_break = {
						visibility = true,
	
						offset = {
							x = 0,
							y = 15
						},
	
						text_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = language.current_language.UI.part_break,

							offset = {
								x = -42,
								y = 6
							},

							color = 0xFFb2d0ff,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						value_label = {
							visibility = true,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = "%s",

							include = {
								current_value = true,
								max_value = false
							},

							offset = {
								x = 5,
								y = 6
	
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						percentage_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 6
							},

							text_formatting = "%.1f%%",
	
							offset = {
								x = 5,
								y = 17
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						bar = {
							visibility = true,

							settings = {
								fill_direction = "Left to Right"
							},

							offset = {
								x = 0,
								y = 7
							},
	
							size = {
								width = 92,
								height = 5
							},
	
							outline = {
								visibility = true,
								thickness = 1,
								offset = 0,
								style = "Center"
							},
	
							colors = {
								foreground = 0xB999BFFF,
								background = 0x88000000,
								outline = 0xC0000000
							}
						}
					},
	
					part_loss = {
						visibility = true,
	
						offset = {
							x = 94,
							y = 15
						},
	
						text_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = language.current_language.UI.part_sever,

							offset = {
								x = 97,
								y = 5
							},

							color = 0xFFff8095,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						value_label = {
							visibility = true,

							settings = {
								right_alignment_shift = 11
							},

							text_formatting = "%s",

							include = {
								current_value = true,
								max_value = false
							},

							offset = {
								x = 6,
								y = 6
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},
								
								color = 0xFF000000
							}
						},
	
						percentage_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 6
							},

							text_formatting = "%.1f%%",
	
							offset = {
								x = 41,
								y = 17
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						bar = {
							visibility = true,

							settings = {
								fill_direction = "Left to Right"
							},

							offset = {
								x = 0,
								y = 7
							},
	
							size = {
								width = 91,
								height = 5
							},
	
							outline = {
								visibility = true,
								thickness = 1,
								offset = 0,
								style = "Center"
							},
	
							colors = {
								foreground = 0xB9E57386,
								background = 0x88000000,
								outline = 0xC0000000
							}
						}
					},

					part_anomaly = {
						visibility = true,
	
						offset = {
							x = -10,
							y = 0
						},
	
						text_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 0
							},

							text_formatting = language.current_language.UI.part_anomaly_core,

							offset = {
								x = -90,
								y = 1
							},

							color = 0xFFFF6680,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						value_label = {
							visibility = true,

							settings = {
								right_alignment_shift = 11
							},

							text_formatting = "%s",

							include = {
								current_value = true,
								max_value = false
							},

							offset = {
								x = -84,
								y = 12
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						percentage_label = {
							visibility = false,

							settings = {
								right_alignment_shift = 6
							},

							text_formatting = "%.1f%%",
	
							offset = {
								x = -48,
								y = 24
							},

							color = 0xFFFFFFFF,
	
							shadow = {
								visibility = true,

								offset = {
									x = 1,
									y = 1
								},

								color = 0xFF000000
							}
						},
	
						bar = {
							visibility = true,

							settings = {
								fill_direction = "Bottom to Top"
							},

							offset = {
								x = 0,
								y = 9
							},
	
							size = {
								width = 5,
								height = 24
							},
	
							outline = {
								visibility = true,
								thickness = 1,
								offset = 0,
								style = "Center"
							},
	
							colors = {
								foreground = 0xB9E53956,
								background = 0x88000000,
								outline = 0xC0000000
							}
						}
					}
				},
	
				ailments = {
					visibility = true,
	
					offset = {
						x = 10,
						y = 111
					},
	
					relative_offset = {
						x = 0,
						y = 45
					},
	
					spacing = {
						x = 0,
						y = 24
					},
	
					settings = {
						hide_ailments_with_zero_buildup = true,
						hide_inactive_ailments_with_no_buildup_support = true,
						hide_all_inactive_ailments = false,
						hide_all_active_ailments = false,
						hide_disabled_ailments = true,
						offset_is_relative_to_parts = true,
						time_limit = 15
					},
	
					sorting = {
						type = "Normal",
						reversed_order = false
					},
	
					filter = {
						paralysis = true,
						sleep = true,
						stun = true,
						flash = true,
						poison = true,
						blast = true,
						exhaust = true,
						ride = true,
						waterblight = true,
						fireblight = true,
						iceblight = true,
						thunderblight = true,
	
						fall_trap = true,
						shock_trap = true,
						tranq_bomb = true,
						dung_bomb = true,
						steel_fang = true,
						quick_sand = true,
						fall_otomo_trap = true,
						shock_otomo_trap = true
					},
	
					ailment_name_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",
	
						include = {
							ailment_name = true,
							activation_count = true
						},
	
						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFffb2e2,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					text_label = {
						visibility = false,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = language.current_language.UI.buildup,

						offset = {
							x = -60,
							y = 7
						},

						color = 0xFFffb2e2,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s", -- current_buildup/max_buildup

						include = {
							current_value = true,
							max_value = true
						},

						offset = {
							x = 45,
							y = 13
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					percentage_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",
	
						offset = {
							x = 135,
							y = 13
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					timer_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%2.0f:%02.0f",
	
						offset = {
							x = 140,
							y = 13
						},

						color = 0xFFFFFFFF,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 14
						},
	
						size = {
							width = 185,
							height = 5
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xA7FF80CE,
							background = 0xA7000000,
							outline = 0xC0000000
						}
					}
				},
	
				ailment_buildups = {
					visibility = false,
	
					offset = {
						x = 220,
						y = 167
					},
	
					player_spacing = {
						x = 0,
						y = 24
					},
	
					ailment_spacing = {
						x = 0,
						y = 17
					},
	
					settings = {
						buildup_bar_relative_to = "Top Buildup",
						highlighted_bar = "Me",
						time_limit = 15
					},
	
					filter = {
						stun = true,
						poison = true,
						blast = true
					},
	
					sorting = {
						type = "Buildup",
						reversed_order = false
					},
	
					ailment_name_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",
	
						include = {
							ailment_name = true,
							activation_count = true
						},

						offset = {
							x = 5,
							y = -17
						},

						color = 0xFF7cdbff,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					player_name_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},
	
						text_formatting = "%s",

						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFb5dded,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					buildup_value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%.0f",

						offset = {
							x = 115,
							y = 0
						},

						color = 0xFFb5dded,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					buildup_percentage_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 6
						},

						text_formatting = "%.1f%%",

						offset = {
							x = 152,
							y = 0
						},

						color = 0xFFb5dded,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					total_buildup_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%s",

						offset = {
							x = 5,
							y = 0
						},

						color = 0xFFFF9393,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					total_buildup_value_label = {
						visibility = true,

						settings = {
							right_alignment_shift = 0
						},

						text_formatting = "%.0f",

						offset = {
							x = 115,
							y = 0
						},

						color = 0xFFFF9393,
	
						shadow = {
							visibility = true,

							offset = {
								x = 1,
								y = 1
							},

							color = 0xFF000000
						}
					},
	
					buildup_bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 17
						},
	
						size = {
							width = 200,
							height = 5
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xA796CFE5,
							background = 0xA7000000,
							outline = 0xC0000000
						}
					},
	
					highlighted_buildup_bar = {
						visibility = true,

						settings = {
							fill_direction = "Left to Right"
						},

						offset = {
							x = 0,
							y = 17
						},
	
						size = {
							width = 200,
							height = 5
						},
	
						outline = {
							visibility = true,
							thickness = 1,
							offset = 0,
							style = "Center"
						},
	
						colors = {
							foreground = 0xA7F4D5A3,
							background = 0xA7000000,
							outline = 0xC0000000
						}
					}
				}
			}
		},
	
		time_UI = {
			enabled = true,
	
			position = {
				x = 65,
				y = 189,
				anchor = "Top-Left"
			},
	
			time_label = {
				visibility = true,

				settings = {
					right_alignment_shift = 0
				},

				text_formatting = "%02d:%06.3f",

				offset = {
					x = 0,
					y = 0
				},

				color = 0xFFCCF4E1,
	
				shadow = {
					visibility = true,

					offset = {
						x = 1,
						y = 1
					},

					color = 0xFF000000
				}
			}
		},
	
		damage_meter_UI = {
			enabled = true,
	
			tracked_monster_types = {
				small_monsters = true,
				large_monsters = true
			},
	
			tracked_damage_types = {
				players = true,
				bombs = true,
				kunai = true,
				installations = true, -- hunting_installations like ballista, cannon, etc.
				otomos = true,
				wyvern_riding = true,
				poison = true,
				blast = true,
				endemic_life = true,
				mystery_cores = true,
				other = true -- note that installations during narwa fight are counted as other damage
			},
	
			spacing = {
				x = 300,
				y = -24
			},
	
			settings = {
	
				hide_myself = false,
				hide_other_players = false,
				hide_servants = false,
				hide_total_damage = false,
	
				hide_module_if_total_damage_is_zero = false,
				hide_player_if_player_damage_is_zero = false,
				hide_total_if_total_damage_is_zero = false,
				total_damage_offset_is_relative = true,
	
				freeze_dps_on_quest_end = true,
				
				show_my_otomos_separately = true,
				show_other_player_otomos_separately = true,
				show_servant_otomos_separately = true,
				
	
	
				orientation = "Vertical", -- "Vertical" or "Horizontal"
				highlight = "Top Damage",
				damage_bar_relative_to = "Top Damage", -- "total damage" or "top damage"
				my_damage_bar_location = "Last", -- "normal" or "first" or "last"
				total_damage_location = "First",
				dps_mode = "First Hit",
	
				player_name_size_limit = 150
			},
	
			sorting = {
				type = "Damage", -- "normal" or "damage" or "dps"
				reversed_order = true
			},
	
			position = {
				x = 525,
				y = 120,
				-- Possible values: "Top-Left", "Top-Right", "Bottom-Left", "Bottom-Right"
				anchor = "Bottom-Left"
			},
	
			myself = {
				name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",
	
					include = {
						master_rank = true,
						hunter_rank = true,
						cart_count = false,
						type = false,
						id = false,
						name = true
					},

					offset = {
						x = 5,
						y = 0
					},

					color = 0xFFF59FC4,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				hunter_rank_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "[%s]",
	
					include = {
						master_rank = true,
						hunter_rank = true
					},

					offset = {
						x = -65,
						y = 0
					},

					color = 0xFFF59FC4,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				cart_count_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 0
					},
	
					text_formatting = "%d",

					offset = {
						x = 315,
						y = 0
					},

					color = 0xFFF59FC4,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				dps_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.1f",
	
					offset = {
						x = 155,
						y = 0
					},

					color = 0xFFF59FC4,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_value_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.0f",

					offset = {
						x = 205,
						y = 0
					},
					color = 0xFFF59FC4,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_percentage_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 6
					},

					text_formatting = "%.1f%%",

					offset = {
						x = 262,
						y = 0
					},

					color = 0xFFF59FC4,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_bar = {
					visibility = true,

					settings = {
						fill_direction = "Left to Right"
					},

					offset = {
						x = 0,
						y = 17
					},
	
					size = {
						width = 310,
						height = 5
					},
	
					outline = {
						visibility = true,
						thickness = 1,
						offset = 0,
						style = "Center"
					},
	
					colors = {
						foreground = 0xA7F49AC1,
						background = 0xA7000000,
						outline = 0xC0000000
					}
				}
			},
	
			other_players = {
				name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",
	
					include = {
						master_rank = true,
						hunter_rank = true,
						cart_count = false,
						type = false,
						id = false,
						name = true
					},

					offset = {
						x = 5,
						y = 0
					},
					color = 0xFF99E2FF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				hunter_rank_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "[%s]",
	
					include = {
						master_rank = true,
						hunter_rank = true
					},

					offset = {
						x = -65,
						y = 0
					},

					color = 0xFF99E2FF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				cart_count_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 0
					},
	
					text_formatting = "%d",

					offset = {
						x = 315,
						y = 0
					},

					color = 0xFF99E2FF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				dps_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.1f",
	
					offset = {
						x = 155,
						y = 0
					},

					color = 0xFF99E2FF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_value_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.0f",

					offset = {
						x = 205,
						y = 0
					},

					color = 0xFF99E2FF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_percentage_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 6
					},

					text_formatting = "%.1f%%",

					offset = {
						x = 262,
						y = 0
					},

					color = 0xFF99E2FF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_bar = {
					visibility = true,

					settings = {
						fill_direction = "Left to Right"
					},

					offset = {
						x = 0,
						y = 17
					},
	
					size = {
						width = 310,
						height = 5
					},
	
					outline = {
						visibility = true,
						thickness = 1,
						offset = 0,
						style = "Center"
					},
	
					colors = {
						foreground = 0xA799E2FF,
						background = 0xA7000000,
						outline = 0xC0000000
					}
				}
			},
	
			servants = {
				name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",
	
					include = {
						type = false,
						id = false,
						name = true
					},

					offset = {
						x = 5,
						y = 0
					},

					color = 0xFFCDAAF2,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				dps_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.1f",
	
					offset = {
						x = 155,
						y = 0
					},

					color = 0xFFCDAAF2,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_value_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.0f",

					offset = {
						x = 205,
						y = 0
					},

					color = 0xFFCDAAF2,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_percentage_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 6
					},

					text_formatting = "%.1f%%",

					offset = {
						x = 262,
						y = 0
					},

					color = 0xFFCDAAF2,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_bar = {
					visibility = true,

					settings = {
						fill_direction = "Left to Right"
					},

					offset = {
						x = 0,
						y = 17
					},
	
					size = {
						width = 310,
						height = 5
					},
	
					outline = {
						visibility = true,
						thickness = 1,
						offset = 0,
						style = "Center"
					},
	
					colors = {
						foreground = 0xA7CCA3F4,
						background = 0xA7000000,
						outline = 0xC0000000
					}
				}
			},
	
			my_otomos = {
				name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",
	
					include = {
						level = true,
						type = false,
						id = false,
						name = true
					},

					offset = {
						x = 5,
						y = 0
					},

					color = 0xFFF59FC4,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				hunter_rank_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 0
					},
	
					text_formatting = "[%s]",

					offset = {
						x = -30,
						y = 0
					},

					color = 0xFFF59FC4,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				dps_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.1f",
	
					offset = {
						x = 155,
						y = 0
					},

					color = 0xFFF59FC4,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_value_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.0f",

					offset = {
						x = 205,
						y = 0
					},
					
					color = 0xFFF59FC4,
	
					shadow = {
						visibility = true,
						
						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_percentage_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 6
					},

					text_formatting = "%.1f%%",

					offset = {
						x = 262,
						y = 0
					},

					color = 0xFFF59FC4,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_bar = {
					visibility = true,

					settings = {
						fill_direction = "Left to Right"
					},

					offset = {
						x = 0,
						y = 17
					},
	
					size = {
						width = 310,
						height = 5
					},
	
					outline = {
						visibility = true,
						thickness = 1,
						offset = 0,
						style = "Center"
					},
	
					colors = {
						foreground = 0xA7B20E42,
						background = 0xA7000000,
						outline = 0xC0000000
					}
				}
			},
	
			other_player_otomos = {
				name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",
	
					include = {
						level = true,
						type = false,
						id = false,
						name = true
					},

					offset = {
						x = 5,
						y = 0
					},

					color = 0xFF99E2FF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				hunter_rank_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 0
					},
	
					text_formatting = "[%s]",

					offset = {
						x = -30,
						y = 0
					},

					color = 0xFF99E2FF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				dps_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.1f",
	
					offset = {
						x = 155,
						y = 0
					},

					color = 0xFF99E2FF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_value_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.0f",

					offset = {
						x = 205,
						y = 0
					},

					color = 0xFF99E2FF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_percentage_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 6
					},

					text_formatting = "%.1f%%",

					offset = {
						x = 262,
						y = 0
					},

					color = 0xFF99E2FF,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_bar = {
					visibility = true,

					settings = {
						fill_direction = "Left to Right"
					},

					offset = {
						x = 0,
						y = 17
					},
	
					size = {
						width = 310,
						height = 5
					},
	
					outline = {
						visibility = true,
						thickness = 1,
						offset = 0,
						style = "Center"
					},
	
					colors = {
						foreground = 0xA71288B2,
						background = 0xA7000000,
						outline = 0xC0000000
					}
				}
			},
	
			servant_otomos = {
				name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%s",
	
					include = {
						level = true,
						type = false,
						id = false,
						name = true
					},

					offset = {
						x = 5,
						y = 0
					},

					color = 0xFFCDAAF2,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},
						color = 0xFF000000
					}
				},
	
				hunter_rank_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 0
					},
	
					text_formatting = "[%s]",

					offset = {
						x = -30,
						y = 0
					},
					color = 0xFFCDAAF2,
	
					shadow = {
						visibility = true,
						offset = {
							x = 1,
							y = 1
						},
						color = 0xFF000000
					}
				},
	
				dps_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.1f",
	
					offset = {
						x = 155,
						y = 0
					},
					color = 0xFFCDAAF2,
	
					shadow = {
						visibility = true,
						offset = {
							x = 1,
							y = 1
						},
						color = 0xFF000000
					}
				},
	
				damage_value_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.0f",

					offset = {
						x = 205,
						y = 0
					},

					color = 0xFFCDAAF2,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_percentage_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%6.1f%%",

					offset = {
						x = 262,
						y = 0
					},

					color = 0xFFCDAAF2,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_bar = {
					visibility = true,

					settings = {
						fill_direction = "Left to Right"
					},

					offset = {
						x = 0,
						y = 17
					},
	
					size = {
						width = 310,
						height = 5
					},
	
					outline = {
						visibility = true,
						thickness = 1,
						offset = 0,
						style = "Center"
					},
	
					colors = {
						foreground = 0xA7662D91,
						background = 0xA7000000,
						outline = 0xC0000000
					}
				}
			},
	
			total = {
				name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},
	
					text_formatting = "%s",

					offset = {
						x = 5,
						y = 0
					},
					color = 0xFFF27979,
	
					shadow = {
						visibility = true,
						offset = {
							x = 1,
							y = 1
						},
						color = 0xFF000000
					}
				},
	
				cart_count_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 0
					},
	
					text_formatting = "%d/%d",

					offset = {
						x = 315,
						y = 0
					},

					color = 0xFFF27979,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				dps_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.1f",
	
					offset = {
						x = 155,
						y = 0
					},

					color = 0xFFF27979,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},
						
						color = 0xFF000000
					}
				},
	
				damage_value_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},
					
					text_formatting = "%.0f",

					offset = {
						x = 205,
						y = 0
					},

					color = 0xFFF27979,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
			},
	
			highlighted = {
				name_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},
	
					text_formatting = "%s",

					offset = {
						x = 5,
						y = 0
					},

					color = 0xFFF7BEAD,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				hunter_rank_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 0
					},
	
					text_formatting = "[%s]",

					offset = {
						x = -65,
						y = 0
					},

					color = 0xFFF7BEAD,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				cart_count_label = {
					visibility = false,

					settings = {
						right_alignment_shift = 0
					},
	
					text_formatting = "%d",

					offset = {
						x = 315,
						y = 0
					},

					color = 0xFFF7BEAD,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				dps_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.1f",
	
					offset = {
						x = 155,
						y = 0
					},

					color = 0xFFF7BEAD,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_value_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 0
					},

					text_formatting = "%.0f",

					offset = {
						x = 205,
						y = 0
					},

					color = 0xFFF7BEAD,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_percentage_label = {
					visibility = true,

					settings = {
						right_alignment_shift = 6
					},

					text_formatting = "%.1f%%",

					offset = {
						x = 262,
						y = 0
					},

					color = 0xFFF7BEAD,
	
					shadow = {
						visibility = true,

						offset = {
							x = 1,
							y = 1
						},

						color = 0xFF000000
					}
				},
	
				damage_bar = {
					visibility = true,

					settings = {
						fill_direction = "Left to Right"
					},

					offset = {
						x = 0,
						y = 17
					},
	
					size = {
						width = 310,
						height = 5
					},
	
					outline = {
						visibility = true,
						thickness = 1,
						offset = 0,
						style = "Center"
					},
	
					colors = {
						foreground = 0xA7FDC689,
						background = 0xA7000000,
						outline = 0xC0000000
					}
				}
			}
		},
	
		endemic_life_UI = {
			enabled = false,
	
			settings = {
				hide_inactive_creatures = true,
				max_distance = 300,
				opacity_falloff = true
			},
	
			world_offset = {
				x = 0,
				y = 1,
				z = 0
			},
	
			viewport_offset = {
				x = 0,
				y = 0
			},
	
			creature_name_label = {
				visibility = true,

				settings = {
					right_alignment_shift = 0
				},

				text_formatting = "%s",
	
				offset = {
					x = 0,
					y = 0
				},

				color = 0xFFf4f3ab,
	
				shadow = {
					visibility = true,

					offset = {
						x = 1,
						y = 1
					},

					color = 0xFF000000
				}
			}
		},

		--[[buff_UI = {
			enabled = true,

			settings = {
				hide_bar_for_infinite_buffs = true,
				hide_timer_for_infinite_buffs = true,
				orientation = "Vertical", -- "Vertical" or "Horizontal"
			},

			spacing = {
				x = 260,
				y = -24
			},

			position = {
				x = 10,
				y = 30,
				-- Possible values: "Top-Left", "Top-Right", "Bottom-Left", "Bottom-Right"
				anchor = "Bottom-Left"
			},
	
			sorting = {
				type = "Name", -- "Name" or "Timer" or "Duration"
				reversed_order = true
			},

			name_label = {
				visibility = true,

				settings = {
					right_alignment_shift = 0
				},

				text_formatting = "%s",

				offset = {
					x = 5,
					y = 0
				},

				color = 0xFFFEFF88,

				shadow = {
					visibility = true,

					offset = {
						x = 1,
						y = 1
					},

					color = 0xFF000000
				}
			},

			timer_label = {
				visibility = true,

				settings = {
					right_alignment_shift = 0
				},

				text_formatting = "%2.0f:%02.0f",

				offset = {
					x = 200,
					y = 0
				},

				color = 0xFFFFBF81,

				shadow = {
					visibility = true,

					offset = {
						x = 1,
						y = 1
					},
					
					color = 0xFF000000
				}
			},

			bar = {
				visibility = true,

				settings = {
					fill_direction = "Left to Right"
				},

				offset = {
					x = 0,
					y = 17
				},

				size = {
					width = 240,
					height = 5
				},

				outline = {
					visibility = true,
					thickness = 1,
					offset = 0,
					style = "Center"
				},

				colors = {
					foreground = 0xA76FD456,
					background = 0xA7000000,
					outline = 0xC0000000
				}
			}
		}]]
	};
end

function this.load_current_config_value()
	local loaded_config = json.load_file(this.current_config_value_file_name);
	if loaded_config ~= nil then
		if loaded_config.config == nil then
			log.info("[MHR Overlay] old config.json loaded successfully");

			local config_save = {
				config = this.current_config_name
			};

			this.current_config_name = "old_config";
			this.current_config = utils.table.merge(this.default_config, loaded_config);
			this.current_config.version = this.version;

			this.save(this.config_folder .. "old_config.json", this.current_config);
			this.save_current_config_name();

			table.insert(this.config_names, "old_config");
			table.insert(this.configs, this.current_config);

			is_old_config_transferred = true;
		else
			log.info("[MHR Overlay] config.json loaded successfully");
			this.current_config_name = loaded_config.config;
		end
	else
		log.error("[MHR Overlay] Failed to load config.json");
	end
end

function this.load_configs()
	local config_files = fs.glob([[MHR Overlay\\configs\\.*json]]);

	if config_files == nil then
		return;
	end

	for i, config_file_name in ipairs(config_files) do

		local config_name = config_file_name:gsub(this.config_folder, ""):gsub(".json","");

		if config_name == "old_config" and is_old_config_transferred then
			goto continue;
		end

		local loaded_config = json.load_file(config_file_name);
		if loaded_config ~= nil then
			log.info("[MHR Overlay] " .. config_name .. ".json loaded successfully");
			

			local merged_config = utils.table.merge(this.default_config, loaded_config);
			merged_config.version = this.version;
			
			table.insert(this.config_names, config_name);
			table.insert(this.configs, merged_config);

			this.save(config_file_name, merged_config);

			if config_name == this.current_config_name then
				this.current_config = merged_config;
			end
		else
			log.error("[MHR Overlay] Failed to load " .. config_name .. ".json");
		end

		::continue::
	end

	if this.current_config == nil then
		if #this.configs > 0 then
			this.current_config_name = this.config_names[1];
			this.current_config = this.configs[1];
		else
			this.current_config_name = "default";
			this.current_config = utils.table.deep_copy(this.default_config);
	
			table.insert(this.config_names, this.current_config_name);
			table.insert(this.configs, this.current_config);
	
			this.save(this.current_config_name, this.current_config);
		end

		this.save_current_config_name();
	end
end

function this.save_current_config_name()
	this.save(this.current_config_value_file_name, { config = this.current_config_name });
end

function this.save(file_name, config_table)
	-- save current config to disk, replacing any existing file
	local success = json.dump_file(file_name, config_table);
	if success then
		log.info("[MHR Overlay] " .. file_name .. " saved successfully");
	else
		log.error("[MHR Overlay] Failed to save " .. file_name);
	end
end

function this.save_current()
	this.save(this.config_folder .. this.current_config_name .. ".json", this.current_config);
end

function this.create_new(config_file_name, config_table)
	table.insert(this.config_names, config_file_name);
	table.insert(this.configs, config_table);

	this.save(this.config_folder .. config_file_name .. ".json", config_table);

	this.current_config_name = config_file_name;
	this.current_config = config_table;

	this.save_current_config_name();
end

function this.new(config_name)
	if config_name == "" then
		return;
	end

	local new_config = utils.table.deep_copy(this.default_config);
	
	this.create_new(config_name, new_config);
end

function this.duplicate(config_name)
	if config_name == "" then
		return;
	end

	local new_config = utils.table.deep_copy(this.current_config);
	
	this.create_new(config_name, new_config);
end

function this.reset()
	this.current_config = utils.table.deep_copy(this.default_config);

	local index = utils.table.find_index(this.config_names, this.current_config_name);
	this.configs[index] = this.current_config;
end

function this.update(index)
	this.current_config = this.configs[index];
	this.save_current_config_name();
end

function this.init_module()
	utils = require("MHR_Overlay.Misc.utils");
	language = require("MHR_Overlay.Misc.language");

	this.init_default();
	this.load_current_config_value();
	this.load_configs();

	language.update(utils.table.find_index(language.language_names, this.current_config.global_settings.language, false));
end

return this;