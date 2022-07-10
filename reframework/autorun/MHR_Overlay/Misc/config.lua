local config = {};
local table_helpers;
local language;

config.current_config = nil;
config.config_file_name = "MHR Overlay/config.json";

config.default_config = {};

function config.init()
	config.default_config = {
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
				prioritize_large_monsters = false,
			},
	
			module_visibility = {
				during_quest = {
					small_monster_UI = true,
					large_monster_dynamic_UI = true,
					large_monster_static_UI = true,
					large_monster_highlighted_UI = true,
					time_UI = true,
					damage_meter_UI = true,
					endemic_life_UI = true,
				},
		
				quest_result_screen = {
					small_monster_UI = false,
					large_monster_dynamic_UI = false,
					large_monster_static_UI = true,
					large_monster_highlighted_UI = true,
					time_UI = true,
					damage_meter_UI = true,
					endemic_life_UI = false
				},
		
				training_area = {
					large_monster_dynamic_UI = true,
					large_monster_static_UI = true,
					large_monster_highlighted_UI = true,
					damage_meter_UI = true,
					endemic_life_UI = true
				}
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
				text = "%s",
	
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
					text = "%s",
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
					text = "%.0f/%.0f", -- current_health/max_health
					offset = {
						x = 50,
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
					text = "%5.1f%%",
		
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
					offset = {
						x = 0,
						y = 0
					},
		
					size = {
						width = 100,
						height = 7
					},
		
					colors = {
						foreground = 0xB974A652,
						background = 0xB9000000,
						capture_health = 0xB9CCCC33
					}
				}
			},
	
			stamina = {
				visibility = false,

				offset = {
					x = 10,
					y = 30
				},
	
				text_label = {
					visibility = true,
					text = "%s",
					offset = {
						x = 5,
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
					text = "%.0f/%.0f", -- current_health/max_health
					offset = {
						x = 25,
						y = 16
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
				
				percentage_label = {
					visibility = false,
					text = "%5.1f%%",
	
					offset = {
						x = 45,
						y = 29
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
	
				bar = {
					visibility = true,
					offset = {
						x = 0,
						y = 17
					},
	
					size = {
						width = 90,
						height = 4
					},
	
					colors = {
						foreground = 0xB966CCC5,
						background = 0x88000000
					}
				}
			},

			ailments = {
				visibility = false,

				offset = {
					x = 10,
					y = 75
				},
				
				spacing = {
					x = 0,
					y = 24,
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
	
				ailment_name_label = {
					visibility = true,
					text = "%s",
		
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
					text = language.current_language.UI.buildup,
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
					text = "%.0f/%.0f", -- current_buildup/max_buildup
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
					text = "%5.1f%%",
	
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
					text = "%2.0f:%02.0f",
	
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
					offset = {
						x = 0,
						y = 14
					},
	
					size = {
						width = 90,
						height = 4
					},
	
					colors = {
						foreground = 0xA7ff80ce,
						background = 0xA7000000
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
					blast = true,
				},
		
				sorting = {
					type = "Buildup",
					reversed_order = false
				},

				ailment_name_label = {
					visibility = true,
		
					include = {
						ailment_name = true,
						activation_count = true
					},

					text = "%s",
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
		
					text = "%s",
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
					text = "%.0f",
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
					text = "%5.1f%%",
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
					text = "%s",
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
					text = "%.0f",
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
					offset = {
						x = 0,
						y = 17
					},
		
					size = {
						width = 200,
						height = 5
					},
		
					colors = {
						foreground = 0xA796cfe5,
						background = 0xA7000000
					}
				},

				highlighted_buildup_bar = {
					visibility = true,
					offset = {
						x = 0,
						y = 17
					},
		
					size = {
						width = 200,
						height = 5
					},
		
					colors = {
						foreground = 0xA7F4D5A3,
						background = 0xA7000000
					}
				}
			},
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
					text = "%s",
		
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
						text = "%s",
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
						text = "%.0f/%.0f", -- current_health/max_health
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
						text = "%5.1f%%",
		
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
						offset = {
							x = 0,
							y = 0
						},
		
						size = {
							width = 200,
							height = 20
						},

						normal_colors = {
							foreground = 0xB974A653,
							background = 0xB9000000,
						},
						
						capture_colors = {
							foreground = 0xB9CCCC33,
							background = 0x88000000
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
					},
				},
		
				stamina = {
					visibility = true,

					offset = {
						x = 10,
						y = 37
					},
	
					text_label = {
						visibility = true,
						text = "%s",
						offset = {
							x = 15-10,
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
						text = "%.0f/%.0f", -- current_health/max_health
						offset = {
							x = 55-10,
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
						text = "%5.1f%%",
		
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
						text = "%2.0f:%02.0f",
		
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
						offset = {
							x = 10-10,
							y = 17
						},
		
						size = {
							width = 185,
							height = 7
						},
		
						colors = {
							foreground = 0xB966CCC5,
							background = 0x88000000
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
						text = "%s",
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
						text = "%.0f/%.0f", -- current_health/max_health
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
						text = "%5.1f%%",
		
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
						text = "%2.0f:%02.0f",
		
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
						offset = {
							x = 0,
							y = 17
						},
		
						size = {
							width = 185,
							height = 7
						},
		
						colors = {
							foreground = 0xB9CC6666,
							background = 0x88000000
						}
					}
				},
		
				body_parts = {
					visibility = false,
	
					offset = {
						x = 10,
						y = 111
					},
					
					spacing = {
						x = 0,
						y = 33,
					},
	
					settings = {
						hide_undamaged_parts = true,
						time_limit = 15
					},
	
					sorting = {
						type = "Normal",
						reversed_order = false
					},

					part_name_label = {
						visibility = true,
						text = "%s",
			
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
							text = language.current_language.UI.HP,
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
							text = "%11s", -- current_health/max_health
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
							text = "%5.1f%%",
			
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
							offset = {
								x = 0,
								y = 6
							},
			
							size = {
								width = 185,
								height = 5
							},
			
							colors = {
								foreground = 0xB9ca85cc,
								background = 0x88000000
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
							text = language.current_language.UI.part_break,
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
							text = "%-9s",
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
							text = "%5.1f%%",
			
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
							offset = {
								x = 0,
								y = 7
							},
			
							size = {
								width = 92,
								height = 5
							},
			
							colors = {
								foreground = 0xB999bfff,
								background = 0x88000000
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
							text = language.current_language.UI.part_sever,
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
							text = "%11s",
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
							text = "%5.1f%%",
			
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
							offset = {
								x = 0,
								y = 7
							},
			
							size = {
								width = 91,
								height = 5
							},
			
							colors = {
								foreground = 0xB9e57386,
								background = 0x88000000
							}
						}
					},

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
						y = 24,
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
		
					ailment_name_label = {
						visibility = true,
						text = "%s",
			
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
						text = language.current_language.UI.buildup,
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
						text = "%.0f/%.0f", -- current_buildup/max_buildup
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
						text = "%5.1f%%",
		
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
						text = "%2.0f:%02.0f",
		
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
						offset = {
							x = 0,
							y = 14
						},
		
						size = {
							width = 185,
							height = 5
						},
		
						colors = {
							foreground = 0xA7ff80ce,
							background = 0xA7000000
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
						blast = true,
					},
			
					sorting = {
						type = "Buildup",
						reversed_order = false
					},

					ailment_name_label = {
						visibility = true,
			
						include = {
							ailment_name = true,
							activation_count = true
						},

						text = "%s",
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
			
						text = "%s",
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
						text = "%.0f",
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
						text = "%5.1f%%",
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
						text = "%s",
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
						text = "%.0f",
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
						offset = {
							x = 0,
							y = 17
						},
			
						size = {
							width = 200,
							height = 5
						},
			
						colors = {
							foreground = 0xA796cfe5,
							background = 0xA7000000
						}
					},

					highlighted_buildup_bar = {
						visibility = true,
						offset = {
							x = 0,
							y = 17
						},
			
						size = {
							width = 200,
							height = 5
						},
			
						colors = {
							foreground = 0xA7F4D5A3,
							background = 0xA7000000
						}
					}
				},
			},
	
			static = {
				enabled = true,
	
				spacing = {
					x = 250,
					y = 40,
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
					y = 47,
					anchor = "Bottom-Left"
				},
		
				monster_name_label = {
					visibility = true,
					text = "%s",
		
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
						text = "%s",
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
						text = "%.0f/%.0f", -- current_health/max_health
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
						text = "%5.1f%%",
		
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
						offset = {
							x = 0,
							y = 0
						},
		
						size = {
							width = 200,
							height = 20
						},

						normal_colors = {
							foreground = 0xB974A653,
							background = 0xB9000000,
						},
						
						capture_colors = {
							foreground = 0xB9CCCC33,
							background = 0x88000000
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
						text = "%s",
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
						text = "%.0f/%.0f", -- current_health/max_health
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
						text = "%5.1f%%",
		
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
						text = "%2.0f:%02.0f",
		
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
						offset = {
							x = 0,
							y = 0
						},
		
						size = {
							width = 200,
							height = 5
						},
		
						colors = {
							foreground = 0xB966CCC5,
							background = 0x88000000
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
						text = "%s",
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
						text = "%.0f/%.0f", -- current_health/max_health
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
						text = "%5.1f%%",
		
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
						text = "%2.0f:%02.0f",
		
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
						offset = {
							x = 0,
							y = 0
						},
		
						size = {
							width = 200,
							height = 5
						},
		
						colors = {
							foreground = 0xB9CC6666,
							background = 0x88000000
						}
					}
				},
		
				body_parts = {
					visibility = false,
	
					offset = {
						x = 10,
						y = 60
					},
					
					spacing = {
						x = 0,
						y = 33,
					},
	
					settings = {
						hide_undamaged_parts = true,
						time_limit = 15
					},
	
					sorting = {
						type = "Normal",
						reversed_order = false
					},

					part_name_label = {
						visibility = true,
						text = "%s",
			
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
							text = language.current_language.UI.HP,
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
							text = "%11s", -- current_health/max_health
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
							text = "%5.1f%%",
			
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
							offset = {
								x = 0,
								y = 6
							},
			
							size = {
								width = 185,
								height = 5
							},
			
							colors = {
								foreground = 0xB9ca85cc,
								background = 0x88000000
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
							text = language.current_language.UI.part_break,
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
							text = "%-9s",
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
							text = "%5.1f%%",
			
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
							offset = {
								x = 0,
								y = 7
							},
			
							size = {
								width = 92,
								height = 5
							},
			
							colors = {
								foreground = 0xB999bfff,
								background = 0x88000000
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
							text = language.current_language.UI.part_sever,
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
							text = "%11s",
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
							text = "%5.1f%%",
			
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
							offset = {
								x = 0,
								y = 7
							},
			
							size = {
								width = 91,
								height = 5
							},
			
							colors = {
								foreground = 0xB9e57386,
								background = 0x88000000
							}
						}
					},

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
						y = 24,
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
		
					ailment_name_label = {
						visibility = true,
						text = "%s",
			
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
						text = language.current_language.UI.buildup,
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
						text = "%.0f/%.0f", -- current_buildup/max_buildup
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
						text = "%5.1f%%",
		
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
						text = "%2.0f:%02.0f",
		
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
						offset = {
							x = 0,
							y = 14
						},
		
						size = {
							width = 185,
							height = 5
						},
		
						colors = {
							foreground = 0xA7ff80ce,
							background = 0xA7000000
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
						blast = true,
					},
			
					sorting = {
						type = "Buildup",
						reversed_order = false
					},

					ailment_name_label = {
						visibility = true,
			
						include = {
							ailment_name = true,
							activation_count = true
						},

						text = "%s",
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
			
						text = "%s",
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
						text = "%.0f",
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
						text = "%5.1f%%",
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
						text = "%s",
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
						text = "%.0f",
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
						offset = {
							x = 0,
							y = 17
						},
			
						size = {
							width = 200,
							height = 5
						},
			
						colors = {
							foreground = 0xA796cfe5,
							background = 0xA7000000
						}
					},

					highlighted_buildup_bar = {
						visibility = true,
						offset = {
							x = 0,
							y = 17
						},
			
						size = {
							width = 200,
							height = 5
						},
			
						colors = {
							foreground = 0xA7F4D5A3,
							background = 0xA7000000
						}
					}
				},
			},

			highlighted = {
				enabled = true,
		
				position = {
					x = 615,
					y = 25,--y = 44,
					anchor = "Top-Right"
				},
		
				monster_name_label = {
					visibility = true,
					text = "%s",
		
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
						text = "%s",
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
						text = "%.0f/%.0f", -- current_health/max_health
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
						text = "%5.1f%%",
		
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
						offset = {
							x = 0,
							y = 0
						},
		
						size = {
							width = 200,
							height = 20
						},

						normal_colors = {
							foreground = 0xB974A653,
							background = 0xB9000000,
						},
						
						capture_colors = {
							foreground = 0xB9CCCC33,
							background = 0x88000000
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
					},
				},
		
				stamina = {
					visibility = true,

					offset = {
						x = 10,
						y = 37
					},
	
					text_label = {
						visibility = true,
						text = "%s",
						offset = {
							x = 15-10,
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
						text = "%.0f/%.0f", -- current_health/max_health
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
						text = "%5.1f%%",
		
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
						text = "%2.0f:%02.0f",
		
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
						offset = {
							x = 10-10,
							y = 17
						},
		
						size = {
							width = 185,
							height = 7
						},
		
						colors = {
							foreground = 0xB966CCC5,
							background = 0x88000000
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
						text = "%s",
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
						text = "%.0f/%.0f", -- current_health/max_health
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
						text = "%5.1f%%",
		
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
						text = "%2.0f:%02.0f",
		
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
						offset = {
							x = 0,
							y = 17
						},
		
						size = {
							width = 185,
							height = 7
						},
		
						colors = {
							foreground = 0xB9CC6666,
							background = 0x88000000
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
						y = 33,
					},
	
					settings = {
						hide_undamaged_parts = true,
						time_limit = 15
					},
	
					sorting = {
						type = "Normal",
						reversed_order = false
					},

					part_name_label = {
						visibility = true,
						text = "%s",
			
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
							text = language.current_language.UI.HP,
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
							text = "%11s", -- current_health/max_health
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
							text = "%5.1f%%",
			
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
							offset = {
								x = 0,
								y = 6
							},
			
							size = {
								width = 185,
								height = 5
							},
			
							colors = {
								foreground = 0xB9ca85cc,
								background = 0x88000000
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
							text = language.current_language.UI.part_break,
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
							text = "%-9s",
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
							text = "%5.1f%%",
			
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
							offset = {
								x = 0,
								y = 7
							},
			
							size = {
								width = 92,
								height = 5
							},
			
							colors = {
								foreground = 0xB999bfff,
								background = 0x88000000
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
							text = language.current_language.UI.part_sever,
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
							text = "%11s",
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
							text = "%5.1f%%",
			
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
							offset = {
								x = 0,
								y = 7
							},
			
							size = {
								width = 91,
								height = 5
							},
			
							colors = {
								foreground = 0xB9e57386,
								background = 0x88000000
							}
						}
					},

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
						y = 24,
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
		
					ailment_name_label = {
						visibility = true,
						text = "%s",
			
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
						text = language.current_language.UI.buildup,
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
						text = "%.0f/%.0f", -- current_buildup/max_buildup
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
						text = "%5.1f%%",
		
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
						text = "%2.0f:%02.0f",
		
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
						offset = {
							x = 0,
							y = 14
						},
		
						size = {
							width = 185,
							height = 5
						},
		
						colors = {
							foreground = 0xA7ff80ce,
							background = 0xA7000000
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
						blast = true,
					},
			
					sorting = {
						type = "Buildup",
						reversed_order = false
					},

					ailment_name_label = {
						visibility = true,
			
						include = {
							ailment_name = true,
							activation_count = true
						},

						text = "%s",
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
			
						text = "%s",
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
						text = "%.0f",
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
						text = "%5.1f%%",
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
						text = "%s",
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
						text = "%.0f",
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
						offset = {
							x = 0,
							y = 17
						},
			
						size = {
							width = 200,
							height = 5
						},
			
						colors = {
							foreground = 0xA796cfe5,
							background = 0xA7000000
						}
					},

					highlighted_buildup_bar = {
						visibility = true,
						offset = {
							x = 0,
							y = 17
						},
			
						size = {
							width = 200,
							height = 5
						},
			
						colors = {
							foreground = 0xA7F4D5A3,
							background = 0xA7000000
						}
					}
				},
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
				text = "%02d:%06.3f",
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
				player_damage = true,
				bomb_damage = true,
				kunai_damage = true,
				installation_damage = true, -- hunting_installations like ballista, cannon, etc.
				otomo_damage = true,
				wyvern_riding_damage = true,
				poison_damage = true,
				blast_damage = true,
				endemic_life_damage = true,
				other_damage = true  -- note that installations during narwa fight are counted as other damage
			}, 
	
			spacing = {
				x = 300,
				y = 24
			},
	
			settings = {
				orientation = "Vertical", -- "Vertical" or "Horizontal"
	
				hide_module_if_total_damage_is_zero = false,
				hide_player_if_player_damage_is_zero = false,
				hide_total_if_total_damage_is_zero = false,
				total_damage_offset_is_relative = true,
	
				highlighted_bar = "Me",
				damage_bar_relative_to = "Top Damage", -- "total damage" or "top damage"
				my_damage_bar_location = "First", -- "normal" or "first" or "last"
				dps_mode = "First Hit",

				hide_myself = false,
				hide_other_players = false,
				hide_total_damage = false,

				player_name_size_limit = 150
			},
	
			sorting = {
				type = "Damage", -- "normal" or "damage" or "dps"
				reversed_order = false
			},
	
			position = {
				x = 525,
				y = 225,
				-- Possible values: "Top-Left", "Top-Right", "Bottom-Left", "Bottom-Right"
				anchor = "Bottom-Left"
			},
	
			player_name_label = {
				visibility = true,
	
				include = {
					myself = {
						master_rank = true,
						hunter_rank = true,
						word_player = false,
						player_id = false,
						player_name = true
					},
	
					others = {
						master_rank = true,
						hunter_rank = true,
						word_player = false,
						player_id = false,
						player_name = true
					}
				},
	
				text = "%s",
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

			master_hunter_rank_label = {
				visibility = false,
	
				include = {
					myself = {
						master_rank = true,
						hunter_rank = true
					},
	
					others = {
						master_rank = true,
						hunter_rank = true
					}
				},
	
				text = "[%s]",
				offset = {
					x = -65,
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

			dps_label = {
				visibility = true,
				text = "%.1f",

				offset = {
					x = 155,
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
	
			damage_value_label = {
				visibility = true,
				text = "%.0f",
				offset = {
					x = 205,
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
	
			damage_percentage_label = {
				visibility = true,
				text = "%5.1f%%",
				offset = {
					x = 262,
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
	
			total_damage_label = {
				visibility = true,
				text = "%s",
				offset = {
					x = 5,
					y = 0
				},
				color = 0xFFFF7373,
	
				shadow = {
					visibility = true,
					offset = {
						x = 1,
						y = 1
					},
					color = 0xFF000000
				}
			},

			total_dps_label = {
				visibility = true,
				text = "%.1f",

				offset = {
					x = 155,
					y = 0
				},
				color = 0xFFFF7373,
	
				shadow = {
					visibility = true,
					offset = {
						x = 1,
						y = 1
					},
					color = 0xFF000000
				}
			},
	
			total_damage_value_label = {
				visibility = true,
				text = "%.0f",
				offset = {
					x = 205,
					y = 0
				},
				color = 0xFFFF7373,
	
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
				offset = {
					x = 0,
					y = 17
				},
	
				size = {
					width = 310,
					height = 5
				},
	
				colors = {
					foreground = 0xA7CCA3F4,
					background = 0xA7000000
				}
			},
	
			highlighted_damage_bar = {
				visibility = true,
				offset = {
					x = 0,
					y = 17
				},
	
				size = {
					width = 310,
					height = 5
				},
	
				colors = {
					foreground = 0xA7F4D5A3,
					background = 0xA7000000
				}
			}
		},

		endemic_life_UI = {
			enabled = false,
	
			settings = {
				hide_inactive_creatures = true,
				max_distance = 300,
				opacity_falloff = true,
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
				text = "%s",
	
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
			},
		}
	};
end

function config.load()
    local loaded_config = json.load_file(config.config_file_name);
	if loaded_config ~= nil then
		log.info('[MHR Overlay] config.json loaded successfully');
		config.current_config = table_helpers.merge(config.default_config, loaded_config);
	else
		log.error('[MHR Overlay] Failed to load config.json');
		config.current_config = table_helpers.deep_copy(config.default_config);
	end
end

function config.save()
	-- save current config to disk, replacing any existing file
	local success = json.dump_file(config.config_file_name, config.current_config);
	if success then
		log.info('[MHR Overlay] config.json saved successfully');
	else
		log.error('[MHR Overlay] Failed to save config.json');
	end
end

function config.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	language = require("MHR_Overlay.Misc.language");

	config.init();
	config.load();
	config.current_config.version = "v2.0";

	language.update(table_helpers.find_index(language.language_names, config.current_config.global_settings.language, false));

end

return config;