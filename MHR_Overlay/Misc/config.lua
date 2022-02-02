local config = {};
local table_helpers;

config.current_config = nil;
config.config_file_name = "MHR Overlay/config.json";

config.default_config = {
	global_settings = {
		module_visibility = {
			during_quest = {
				small_monster_UI = true,
				large_monster_UI = true,
				time_UI = true,
				damage_meter_UI = true
			},
	
			quest_summary_Screen = {
				time_UI = true,
				damage_meter_UI = true
			},
	
			training_area = {
				large_monster_UI = true,
				damage_meter_UI = true
			}
		},
		
		font = {
			family = "Consolas",
			size = 13,
			bold = true,
			italic = false
		},
	},

	small_monster_UI = {
		enabled = true,

		spacing = {
			x = 110,
			y = 40
		},

		settings = {
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

		sorting = {
			type = "Normal",
			reversed_order = false
		},

		position = {
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
			text_label = {
				visibility = false,
				text = "HP:",
				offset = {
					x = -25,
					y = 12
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
					y = 25
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
					x = 55,
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
					y = 17
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
			text_label = {
				visibility = false,
				text = "Stamina:",
				offset = {
					x = 15,
					y = 37
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
					x = 15,
					y = 54
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
					x = 55,
					y = 64
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
				visibility = false,
				offset = {
					x = 10,
					y = 54
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
		}
	},

	large_monster_UI = {
		enabled = true,

		spacing = {
			x = 220,
			y = 40,
		},

		settings = {
			orientation = "Horizontal"
		},

		dynamic_positioning = {
			enabled = true,
			max_distance = 300,
			opacity_falloff = true,

			world_offset = {
				x = 0,
				y = 6,
				z = 0
			},

			viewport_offset = {
				x = -100,
				y = 0
			}
		},

		sorting = {
			type = "Normal",
			reversed_order = false
		},

		position = {
			x = 525,
			y = 125,--y = 44,
			anchor = "Top-Left"
		},

		monster_name_label = {
			visibility = true,
			text = "%s",

			include = {
				monster_name = true,
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
			text_label = {
				visibility = false,
				text = "HP:",
				offset = {
					x = -25,
					y = 19
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
					y = 19
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
					y = 19
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
					width = 200,
					height = 20
				},

				colors = {
					foreground = 0xB974A653,
					background = 0xB9000000,
					capture ={
						foreground = 0xB9CCCC33,
						background = 0x88000000
					}
				}
			}
		},

		stamina = {
			text_label = {
				visibility = true,
				text = "Stamina:",
				offset = {
					x = 15,
					y = 37
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
					x = 55,
					y = 54
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
					x = 145,
					y = 54
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
					x = 10,
					y = 54
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
			text_label = {
				visibility = true,
				text = "Rage:",
				offset = {
					x = 15,
					y = 61
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
					x = 55,
					y = 78
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
					x = 145,
					y = 78
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
					x = 10,
					y = 78
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
			monster_damage = true
		}, -- note that installations during narwa fight are counted as monster damage

		spacing = {
			x = 270,
			y = 24
		},

		settings = {
			orientation = "Vertical", -- "Vertical" or "Horizontal"

			hide_module_if_total_damage_is_zero = false,
			hide_player_if_player_damage_is_zero = false,
			total_damage_offset_is_relative = true,

			highlighted_bar = "Me",
			damage_bar_relative_to = "Top Damage", -- "total damage" or "top damage"
			my_damage_bar_location = "First" -- "normal" or "first" or "last"
		},

		sorting = {
			type = "Damage", -- "normal" or "damage"
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
					hunter_rank = true,
					word_player = false,
					player_id = false,
					player_name = true
				},

				others = {
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

		damage_value_label = {
			visibility = true,
			text = "%.0f",
			offset = {
				x = 145,
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

		total_damage_label = {
			visibility = true,
			text = "Total Damage",
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

		total_damage_value_label = {
			visibility = true,
			text = "%.0f",
			offset = {
				x = 145,
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
				width = 250,
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
				width = 250,
				height = 5
			},

			colors = {
				foreground = 0xA7F4D5A3,
				background = 0xA7000000
			}
		}
	}
};

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
	config.load();
	config.current_config.version = "v1.7";
end

return config;