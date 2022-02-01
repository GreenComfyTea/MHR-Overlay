--------------------CUSTOMIZATION SECTION--------------------
-- #region
local default_config = {
	global_settings = {
		module_visibility = {
			during_quest = {
				small_monster_UI = true,
				large_monster_UI = true,
				time_UI = true,
				damage_meter_UI = true
			},
	
			quest_summary_screen = {
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
-- #endregion
----------------------CUSTOMIZATION END----------------------

--------------------FUNCTION DEFINITIONS---------------------
-- #region
local init;
local init_singletons;
local init_message_manager;
local init_enemy_manager;
local init_lobby_manager;
local init_progress_manager;
local init_quest_manager;
local init_player_manager;
local init_village_area_manager;

local table_deep_copy;
local table_find_index;
local table_merge;

local save_config;
local load_config;

local customization_ui;

local get_window_size;
local calculate_screen_coordinates;

local update_player_position;
local is_in_training_area;

local color_to_rgba;
local argb_to_color;
local scale_color_opacity;
local scale_bar_opacity;
local scale_label_opacity;

local draw_label;
local draw_bar;
local old_draw_label;
local old_draw_bar;

local init_monster;
local update_monster;
local small_monster_data;
local large_monster_data;

local quest_time;

local init_player;
local merge_damage;
local get_player;
local update_player_damage;
local update_player_display;
local damage_meter;
-- #endregion
--------------------FUNCTION DEFINITIONS---------------------

--------------------VARIABLE DEFINITIONS---------------------
-- #region
local version = "v1.6";

local config_file_name;
local config;

local font;
local fonts;
local selected_font_index;

local is_customization_window_opened;
local color_picker_flags;

local status;
local x;

local screen_size;

local quest_status;

local large_monsters;
local small_monsters;
local players;
local total;
local is_quest_online;
local last_displayed_players;
local master_player_id;
local myself_player_position;

-- Singletons
local message_manager;
local enemy_manager;
local lobby_manager;
local progress_manager;
local quest_manager;
local player_manager;
local village_area_manager;
-- #endregion
--------------------VARIABLE DEFINITIONS---------------------

-----------------------TABLE HELPERS-------------------------
-- #region
table_deep_copy = function(original, copies)
	copies = copies or {};
	local original_type = type(original);
	local copy;
	if original_type == 'table' then
		if copies[original] then
			copy = copies[original];
		else
			copy = {};
			copies[original] = copy;
			for original_key, original_value in next, original, nil do
				copy[table_deep_copy(original_key, copies)] = table_deep_copy(original_value, copies);
			end
			setmetatable(copy, table_deep_copy(getmetatable(original), copies));
		end
	else -- number, string, boolean, etc
		copy = original;
	end
	return copy;
end

table_find_index = function(table, value, nullable)
	for i = 1, #table do
		if table[i] == value then
			return i;
		end
	end

	if not nullable then
		return 1;
	end

	return nil;
end

table_merge = function(...)
	local tables_to_merge = {...};
	assert(#tables_to_merge > 1, "There should be at least two tables to merge them");

	for key, table in ipairs(tables_to_merge) do
		assert(type(table) == "table", string.format("Expected a table as function parameter %d", key));
	end

	local result = table_deep_copy(tables_to_merge[1]);

	for i = 2, #tables_to_merge do
		local from = tables_to_merge[i];
		for key, value in pairs(from) do
			if type(value) == "table" then
				result[key] = result[key] or {};
				assert(type(result[key]) == "table", string.format("Expected a table: '%s'", key));
				result[key] = table_merge(result[key], value);
			else
				result[key] = value;
			end
		end
	end

	return result;
end

table_tostring = function(table)
	local cache, stack, output = {}, {}, {};
	local depth = 1;
	local output_string = "{\n";

	while true do
		local size = 0;
		for key, value in pairs(table) do
			size = size + 1;
		end

		local current_index = 1;
		for key, value in pairs(table) do
			if (cache[table] == nil) or (current_index >= cache[table]) then

				if (string.find(output_string, "}", output_string:len())) then
					output_string = output_string .. ",\n";
				elseif not (string.find(output_string, "\n",output_stringr:len())) then
					output_string = output_string .. "\n";
				end

				-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
				table.insert(output, output_string);
				output_string = "";

				local key;
				if (type(key) == "number" or type(key) == "boolean") then
					key = "[" .. tostring(key) .. "]";
				else
					key = "['" .. tostring(key) .. "']";
				end

				if (type(value) == "number" or type(value) == "boolean") then
					output_string = output_string .. string.rep('\t', depth) .. key .. " = " .. tostring(value);
				elseif (type(value) == "table") then
					output_string = output_string .. string.rep('\t', depth) .. key .. " = {\n";
					table.insert(stack, table);
					table.insert(stack, value);
					cache[table] = current_index + 1;
					break
				else
					output_string = output_string .. string.rep('\t', depth) .. key .. " = '" .. tostring(value) .. "'";
				end

				if (current_index == size) then
					output_string = output_string .. "\n" .. string.rep('\t', depth - 1) .. "}";
				else
					output_string = output_string .. ",";
				end
			else
				-- close the table
				if (current_index == size) then
					output_string = output_string .. "\n" .. string.rep('\t', depth - 1) .. "}";
				end
			end

			current_index = current_index + 1;
		end

		if (size == 0) then
			output_string = output_string .. "\n" .. string.rep('\t', depth - 1) .. "}";
		end

		if (#stack > 0) then
			table = stack[#stack];
			stack[#stack] = nil;
			depth = cache[table] == nil and depth + 1 or depth - 1;
		else
			break;
		end
	end

	-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
	table.insert(output, output_string);
	output_string = table.concat(output);

	return output_string;
end
-- #endregion
-----------------------TABLE HELPERS-------------------------

----------------------CONFIG LOAD/SAVE-----------------------
-- #region
load_config = function()
	local loaded_config = json.load_file(config_file_name);
	if loaded_config ~= nil then
		log.info('[MHR Overlay] config.json loaded successfully');
		config = table_merge(config, loaded_config);
	end
end

save_config = function()
	-- save current config to disk, replacing any existing file
	local success = json.dump_file(config_file_name, config);
	if success then
		log.info('[MHR Overlay] config.json saved successfully');
	else
		log.error('[MHR Overlay] Failed to save config.json');
	end
end
-- #endregion
----------------------CONFIG LOAD/SAVE-----------------------

----------------------------INIT-----------------------------
-- #region
config_file_name = 'MHR Overlay/config.json';

init = function()
	config = table_deep_copy(default_config);
	load_config();

	init_singletons();

	color_picker_flags = 327680;
	
	status = "OK";
	x = "";

	quest_status = 0;
	if quest_manager ~= nil then
		local _quest_status = quest_manager:call("getStatus");
		if _quest_status == nil then
			status = "No quest status";
		else
			quest_status = _quest_status;
		end
	end

	screen_size = {
		width = 1920,
		height = 1080
	};

	myself_player_position = {
		x = 0,
		y = 0
	}

	large_monsters = {};
	small_monsters = {};

	players = {};
	total = init_player(0, "Total", 0);
	is_quest_online = false;
	last_displayed_players = {};
	master_player_id = 0;

	log.info("[MHR Overlay] loaded");

	orientation_types = {"Horizontal", "Vertical"};

	monster_UI_orientation_index = table_find_index(orientation_types, config.large_monster_UI.settings.orientation, false);

	monster_UI_sort_types = {"Normal", "Health", "Health Percentage"};
	monster_UI_sort_type_index = table_find_index(monster_UI_sort_types, config.large_monster_UI.sorting.type, false);

	damage_meter_UI_orientation_index = table_find_index(orientation_types, config.damage_meter_UI.settings.orientation,
		false);

	damage_meter_UI_highlighted_bar_types = {"Me", "Top Damage", "None"};
	damage_meter_UI_highlighted_bar_index = table_find_index(damage_meter_UI_highlighted_bar_types,
		config.damage_meter_UI.settings.highlighted_bar, false);

	damage_meter_UI_damage_bar_relative_types = {"Total Damage", "Top Damage"};
	damage_meter_UI_damage_bar_relative_index = table_find_index(damage_meter_UI_damage_bar_relative_types,
		config.damage_meter_UI.settings.damage_bar_relative_to, false);

	damage_meter_UI_my_damage_bar_location_types = {"Normal", "First", "Last"};
	damage_meter_UI_my_damage_bar_location_index = table_find_index(damage_meter_UI_my_damage_bar_location_types,
		config.damage_meter_UI.settings.my_damage_bar_location, false);

	damage_meter_UI_sort_types = {"Normal", "Damage"};
	damage_meter_UI_sort_type_index = table_find_index(damage_meter_UI_sort_types, config.damage_meter_UI.sorting.type,
		false);

	is_customization_window_opened = false;

	fonts = {"Arial", "Arial Black", "Bahnschrift", "Calibri", "Cambria", "Cambria Math", "Candara", "Comic Sans MS",
          "Consolas", "Constantia", "Corbel", "Courier New", "Ebrima", "Franklin Gothic Medium", "Gabriola", "Gadugi",
          "Georgia", "HoloLens MDL2 Assets", "Impact", "Ink Free", "Javanese Text", "Leelawadee UI", "Lucida Console",
          "Lucida Sans Unicode", "Malgun Gothic", "Marlett", "Microsoft Himalaya", "Microsoft JhengHei",
          "Microsoft New Tai Lue", "Microsoft PhagsPa", "Microsoft Sans Serif", "Microsoft Tai Le", "Microsoft YaHei",
          "Microsoft Yi Baiti", "MingLiU-ExtB", "Mongolian Baiti", "MS Gothic", "MV Boli", "Myanmar Text", "Nirmala UI",
          "Palatino Linotype", "Segoe MDL2 Assets", "Segoe Print", "Segoe Script", "Segoe UI", "Segoe UI Historic",
          "Segoe UI Emoji", "Segoe UI Symbol", "SimSun", "Sitka", "Sylfaen", "Symbol", "Tahoma", "Times New Roman",
          "Trebuchet MS", "Verdana", "Webdings", "Wingdings", "Yu Gothic"};
	selected_font_index = table_find_index(fonts, config.global_settings.font.family, false);

	return true;
end

init_singletons = function()
	init_message_manager();
	init_enemy_manager();
	init_lobby_manager()
	init_progress_manager();
	init_quest_manager();
	init_player_manager();
	init_village_area_manager();
end

init_message_manager = function()
	if message_manager ~= nil then
		return;
	end

	message_manager = sdk.get_managed_singleton("snow.gui.MessageManager");
	if message_manager == nil then
		log.error("[MHR Overlay] No message manager");
	end
end

init_enemy_manager = function()
	if enemy_manager ~= nil then
		return;
	end

	enemy_manager = sdk.get_managed_singleton("snow.enemy.EnemyManager");
	if enemy_manager == nil then
		log.error("[MHR Overlay] No enemy manager");
	end
end

init_lobby_manager = function()
	if lobby_manager ~= nil then
		return;
	end

	lobby_manager = sdk.get_managed_singleton("snow.LobbyManager");
	if lobby_manager == nil then
		log.error("[MHR Overlay] No lobby manager");
		return false;
	end
end

init_progress_manager = function()
	if progress_manager ~= nil then
		return;
	end

	progress_manager = sdk.get_managed_singleton("snow.progress.ProgressManager");
	if progress_manager == nil then
		log.error("[MHR Overlay] No progress manager");
		return false;
	end
end

init_quest_manager = function()
	if quest_manager ~= nil then
		return;
	end

	quest_manager = sdk.get_managed_singleton("snow.QuestManager");
	if quest_manager == nil then
		log.error("[MHR Overlay] No quest manager");
	end
end

init_player_manager = function()
	if player_manager ~= nil then
		return;
	end

	player_manager = sdk.get_managed_singleton("snow.player.PlayerManager");
	if player_manager == nil then
		log.error("[MHR Overlay] No player manager");
	end
end

init_village_area_manager = function()
	if village_area_manager ~= nil then
		return;
	end

	village_area_manager = sdk.get_managed_singleton("snow.VillageAreaManager");
	if village_area_manager == nil then
		log.error("[MHR Overlay] No village manager");
	end
end
-- #endregion
----------------------------INIT-----------------------------

--------------------------RE_IMGUI---------------------------
-- #region
re.on_draw_ui(function()
	if imgui.button("MHR Overlay " .. version) then
		is_customization_window_opened = not is_customization_window_opened;
	end
end);

re.on_frame(function()
	if not reframework:is_drawing_ui() then
		is_customization_window_opened = false;
	end

	if is_customization_window_opened then
		customization_ui();
	end

	--draw.text("x: " .. tostring(x), 450, 50, 0xFFFFFFFF);
end);
-- #endregion
--------------------------RE_IMGUI---------------------------

----------------------------D2D------------------------------
-- #region
d2d.register(function()
	font = d2d.create_font(config.global_settings.font.family, config.global_settings.font.size, config.global_settings.font.bold, config.global_settings.font.italic);
end, function()
	status = "OK";
	get_window_size();
	init_singletons();

	update_player_position();

	if quest_status < 2 then
		if is_in_training_area() then
			if config.large_monster_UI.enabled and config.global_settings.module_visibility.training_area.large_monster_UI then
				large_monster_data();
			end
	
			if config.damage_meter_UI.enabled and config.global_settings.module_visibility.training_area.damage_meter_UI then
				damage_meter();
			end
		end
		
	elseif quest_status == 2 then
		if config.small_monster_UI.enabled and config.global_settings.module_visibility.during_quest.small_monster_UI then
			small_monster_data();
		end

		if config.large_monster_UI.enabled and config.global_settings.module_visibility.during_quest.large_monster_UI then
			large_monster_data();
		end

		if config.time_UI.enabled and config.global_settings.module_visibility.during_quest.time_UI then
			quest_time();
		end

		if config.damage_meter_UI.enabled and config.global_settings.module_visibility.during_quest.damage_meter_UI then
			damage_meter();
		end
	elseif quest_status > 2 then
		if config.time_UI.enabled and config.global_settings.module_visibility.quest_summary_screen.time_UI then
			quest_time();
		end

		if config.damage_meter_UI.enabled and config.global_settings.module_visibility.quest_summary_screen.damage_meter_UI then
			damage_meter();
		end
	end
end);

calculate_screen_coordinates = function (position)
	if position.anchor == "Top-Left" then
		return {x = position.x, y = position.y};
	end

	if position.anchor == "Top-Right" then
		local screen_x = screen_size.width - position.x;
		return {x = screen_x, y = position.y};
	end

	if position.anchor == "Bottom-Left" then
		local screen_y = screen_size.height - position.y;
		return {x = position.x, y = screen_y};
	end

	if position.anchor == "Bottom-Right" then
		local screen_x = screen_size.width - position.x;
		local screen_y = screen_size.height - position.y;
		return {x = screen_x, y = screen_y};
	end

	return {x = position.x, y = position.y};
end

get_window_size = function()
	local width, height = d2d.surface_size();

	if width ~= nil then
		screen_size.width = width;
	end

	if height ~= nil then
		screen_size.height = height;
	end
end
-- #endregion
----------------------------D2D------------------------------

----------------------CUSTOMIZATION UI-----------------------
-- #region
customization_ui = function()
	is_customization_window_opened = imgui.begin_window("MHR Overlay " .. version, is_customization_window_opened, 0x10120);

	if not is_customization_window_opened then
		return;
	end

	local config_changed = false;
	local changed;
	local status_string = tostring(status);
	imgui.text("Status: " .. status_string);

	if imgui.tree_node("Modules") then
		changed, config.small_monster_UI.enabled = imgui.checkbox("Small Monster UI", config.small_monster_UI.enabled);
		config_changed = config_changed or changed;
		imgui.same_line();

		changed, config.large_monster_UI.enabled = imgui.checkbox("Large Monster UI", config.large_monster_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.time_UI.enabled = imgui.checkbox("Time UI", config.time_UI.enabled);
		config_changed = config_changed or changed;
		imgui.same_line();

		changed, config.damage_meter_UI.enabled = imgui.checkbox("Damage Meter UI", config.damage_meter_UI.enabled);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	if imgui.tree_node("Global Settings") then
		if imgui.tree_node("Module Visibility on Different Screens") then
			
			if imgui.tree_node("During Quest") then
				changed, config.global_settings.module_visibility.during_quest.small_monster_UI = imgui.checkbox("Small Monster UI", config.global_settings.module_visibility.during_quest.small_monster_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.global_settings.module_visibility.during_quest.large_monster_UI = imgui.checkbox("Large Monster UI", config.global_settings.module_visibility.during_quest.large_monster_UI);
				config_changed = config_changed or changed;

				changed, config.global_settings.module_visibility.during_quest.time_UI = imgui.checkbox("Time UI", config.global_settings.module_visibility.during_quest.time_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.global_settings.module_visibility.during_quest.damage_meter_UI = imgui.checkbox("Damage Meter UI", config.global_settings.module_visibility.during_quest.damage_meter_UI);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Quest Summary Screen") then
				changed, config.global_settings.module_visibility.quest_summary_screen.time_UI = imgui.checkbox("Time UI", config.global_settings.module_visibility.quest_summary_screen.time_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.global_settings.module_visibility.quest_summary_screen.damage_meter_UI = imgui.checkbox("Damage Meter UI", config.global_settings.module_visibility.quest_summary_screen.damage_meter_UI);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end
	
			if imgui.tree_node("Training Area") then
				changed, config.global_settings.module_visibility.training_area.large_monster_UI = imgui.checkbox("Large Monster UI", config.global_settings.module_visibility.training_area.large_monster_UI);
				config_changed = config_changed or changed;
				imgui.same_line();
				
				changed, config.global_settings.module_visibility.training_area.damage_meter_UI = imgui.checkbox("Damage Meter UI", config.global_settings.module_visibility.training_area.damage_meter_UI);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Font") then
			imgui.text("Any changes to the font require script reload!");
	
			changed, selected_font_index = imgui.combo("Family", selected_font_index, fonts);
			config_changed = config_changed or changed;
			if changed then
				config.global_settings.font.family = fonts[selected_font_index];
			end
	
			changed, config.global_settings.font.size = imgui.slider_int("Size", config.global_settings.font.size, 1, 100);
			config_changed = config_changed or changed;
	
			changed, config.global_settings.font.bold = imgui.checkbox("Bold", config.global_settings.font.bold);
			config_changed = config_changed or changed;
	
			changed, config.global_settings.font.italic = imgui.checkbox("Italic", config.global_settings.font.italic);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Small Monster UI") then
		changed, config.small_monster_UI.enabled = imgui.checkbox("Enabled", config.small_monster_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node("Spacing") then
			changed, config.small_monster_UI.spacing.y = imgui.drag_float("X",
				config.small_monster_UI.spacing.y, 0.1, 0, screen_size.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.small_monster_UI.spacing.y = imgui.drag_float("Y",
				config.small_monster_UI.spacing.y, 0.1, 0, screen_size.width, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Settings") then
			changed, monster_UI_orientation_index = imgui.combo("Orientation", monster_UI_orientation_index, orientation_types);
			config_changed = config_changed or changed;
			if changed then
				config.small_monster_UI.settings.orientation = orientation_types[monster_UI_orientation_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Dynamic Positioning") then
			changed, config.small_monster_UI.dynamic_positioning.enabled =
				imgui.checkbox("Enabled", config.small_monster_UI.dynamic_positioning.enabled);
			config_changed = config_changed or changed;

			changed, config.small_monster_UI.dynamic_positioning.opacity_falloff = imgui.checkbox("Opacity Falloff", config.small_monster_UI.dynamic_positioning.opacity_falloff);
			config_changed = config_changed or changed;

			changed, config.small_monster_UI.dynamic_positioning.max_distance = imgui.drag_float("Max Distance",
					config.small_monster_UI.dynamic_positioning.max_distance, 1, 0, 10000, "%.0f");
				config_changed = config_changed or changed;

			if imgui.tree_node("World Offset") then
				changed, config.small_monster_UI.dynamic_positioning.world_offset.x = imgui.drag_float("X",
					config.small_monster_UI.dynamic_positioning.world_offset.x, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				changed, config.small_monster_UI.dynamic_positioning.world_offset.y = imgui.drag_float("Y",
					config.small_monster_UI.dynamic_positioning.world_offset.y, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				changed, config.small_monster_UI.dynamic_positioning.world_offset.z = imgui.drag_float("Z",
					config.small_monster_UI.dynamic_positioning.world_offset.z, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Viewport Offset") then
				changed, config.small_monster_UI.dynamic_positioning.viewport_offset.x = imgui.drag_float("X",
					config.small_monster_UI.dynamic_positioning.viewport_offset.x, 0.1, 0, screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.small_monster_UI.dynamic_positioning.viewport_offset.y = imgui.drag_float("Y",
					config.small_monster_UI.dynamic_positioning.viewport_offset.y, 0.1, 0, screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Position") then
			changed, config.small_monster_UI.position.x = imgui.drag_float("X", config.small_monster_UI.position.x, 0.1, 0,
				screen_size.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.small_monster_UI.position.y = imgui.drag_float("Y", config.small_monster_UI.position.y, 0.1, 0,
				screen_size.height, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Sorting") then
			changed, monster_UI_sort_type_index = imgui.combo("Type", monster_UI_sort_type_index, monster_UI_sort_types);
			config_changed = config_changed or changed;
			if changed then
				config.small_monster_UI.sorting.type = monster_UI_sort_types[monster_UI_sort_type_index];
			end

			changed, config.small_monster_UI.sorting.reversed_order = imgui.checkbox("Reversed Order",
				config.small_monster_UI.sorting.reversed_order);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Monster Name Label") then
			changed, config.small_monster_UI.monster_name_label.visibility =
				imgui.checkbox("Visible", config.small_monster_UI.monster_name_label.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Offset") then
				changed, config.small_monster_UI.monster_name_label.offset.x =
					imgui.drag_float("X", config.small_monster_UI.monster_name_label.offset.x, 0.1, -screen_size.width,
						screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.small_monster_UI.monster_name_label.offset.y =
					imgui.drag_float("Y", config.small_monster_UI.monster_name_label.offset.y, 0.1, -screen_size.height,
						screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.small_monster_UI.monster_name_label.color = imgui.color_picker_argb("", config.small_monster_UI.monster_name_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.small_monster_UI.monster_name_label.shadow.visibility = imgui.checkbox("Enable",
					config.small_monster_UI.monster_name_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.small_monster_UI.monster_name_label.shadow.offset.x = imgui.drag_float("X",
						config.small_monster_UI.monster_name_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.small_monster_UI.monster_name_label.shadow.offset.y = imgui.drag_float("Y",
						config.small_monster_UI.monster_name_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.small_monster_UI.monster_name_label.shadow.color = imgui.color_picker_argb("", config.small_monster_UI.monster_name_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end
		end

		if imgui.tree_node("Health") then
			if imgui.tree_node("Text Label") then
				changed, config.small_monster_UI.health.text_label.visibility =
					imgui.checkbox("Visible", config.small_monster_UI.health.text_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.small_monster_UI.health.text_label.offset.x =
						imgui.drag_float("X", config.small_monster_UI.health.text_label.offset.x, 0.1, -screen_size.width, screen_size.width,
							"%.1f");
					config_changed = config_changed or changed;
	
					changed, config.small_monster_UI.health.text_label.offset.y =
						imgui.drag_float("Y", config.small_monster_UI.health.text_label.offset.y, 0.1, -screen_size.height, screen_size.height,
							"%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.small_monster_UI.health.text_label.color = imgui.color_picker_argb("", config.small_monster_UI.health.text_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.small_monster_UI.health.text_label.shadow.visibility =
						imgui.checkbox("Enable", config.small_monster_UI.health.text_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.small_monster_UI.health.text_label.shadow.offset.x =
							imgui.drag_float("X", config.small_monster_UI.health.text_label.shadow.offset.x, 0.1, -screen_size.width,
								screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.small_monster_UI.health.text_label.shadow.offset.y =
							imgui.drag_float("Y", config.small_monster_UI.health.text_label.shadow.offset.y, 0.1, -screen_size.width,
								screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.small_monster_UI.health.text_label.shadow.color = imgui.color_picker_argb("", config.small_monster_UI.health.text_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Value Label") then
				changed, config.small_monster_UI.health.value_label.visibility =
					imgui.checkbox("Visible", config.small_monster_UI.health.value_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.small_monster_UI.health.value_label.offset.x =
						imgui.drag_float("X", config.small_monster_UI.health.value_label.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.small_monster_UI.health.value_label.offset.y =
						imgui.drag_float("Y", config.small_monster_UI.health.value_label.offset.y, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.small_monster_UI.health.value_label.color = imgui.color_picker_argb("", config.small_monster_UI.health.value_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.small_monster_UI.health.value_label.shadow.visibility = imgui.checkbox("Enable",
						config.small_monster_UI.health.value_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.small_monster_UI.health.value_label.shadow.offset.x = imgui.drag_float("X",
							config.small_monster_UI.health.value_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.small_monster_UI.health.value_label.shadow.offset.y = imgui.drag_float("Y",
							config.small_monster_UI.health.value_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.small_monster_UI.health.value_label.shadow.color = imgui.color_picker_argb("", config.small_monster_UI.health.value_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Percentage Label") then
				changed, config.small_monster_UI.health.percentage_label.visibility = imgui.checkbox("Visible",
					config.small_monster_UI.health.percentage_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.small_monster_UI.health.percentage_label.offset.x =
						imgui.drag_float("X", config.small_monster_UI.health.percentage_label.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.small_monster_UI.health.percentage_label.offset.y =
						imgui.drag_float("Y", config.small_monster_UI.health.percentage_label.offset.y, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.small_monster_UI.health.percentage_label.color = imgui.color_picker_argb("", config.small_monster_UI.health.percentage_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.small_monster_UI.health.percentage_label.shadow.visibility = imgui.checkbox("Enable",
						config.small_monster_UI.health.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.small_monster_UI.health.percentage_label.shadow.offset.x = imgui.drag_float("X",
							config.small_monster_UI.health.percentage_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width,
							"%.1f");
						config_changed = config_changed or changed;
	
						changed, config.small_monster_UI.health.percentage_label.shadow.offset.y = imgui.drag_float("Y",
							config.small_monster_UI.health.percentage_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height,
							"%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.small_monster_UI.health.percentage_label.shadow.color = imgui.color_picker_argb("", config.small_monster_UI.health.percentage_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Bar") then
				changed, config.small_monster_UI.health.bar.visibility = imgui.checkbox("Visible", config.small_monster_UI.health.bar
					.visibility);
				config_changed = config_changed or changed;
	
				if imgui.tree_node("Offset") then
					changed, config.small_monster_UI.health.bar.offset.x = imgui.drag_float("X", config.small_monster_UI.health.bar
						.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.small_monster_UI.health.bar.offset.y = imgui.drag_float("Y", config.small_monster_UI.health.bar
						.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Size") then
					changed, config.small_monster_UI.health.bar.size.width =
						imgui.drag_float("Width", config.small_monster_UI.health.bar.size.width, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.small_monster_UI.health.bar.size.height =
						imgui.drag_float("Height", config.small_monster_UI.health.bar.size.height, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Colors") then
					if imgui.tree_node("Foreground") then
						--changed, config.small_monster_UI.health.bar.colors.foreground = imgui.color_picker_argb("", config.small_monster_UI.health.bar.colors.foreground, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Background") then
					--	changed, config.small_monster_UI.health.bar.colors.background = imgui.color_picker_argb("", config.small_monster_UI.health.bar.colors.background, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Stamina (Pointless: small monsters don't get tired)") then
			if imgui.tree_node("Text Label") then
				changed, config.small_monster_UI.stamina.text_label.visibility =
					imgui.checkbox("Visible", config.small_monster_UI.stamina.text_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.small_monster_UI.stamina.text_label.offset.x =
						imgui.drag_float("X", config.small_monster_UI.stamina.text_label.offset.x, 0.1, -screen_size.width, screen_size.width,
							"%.1f");
					config_changed = config_changed or changed;
	
					changed, config.small_monster_UI.stamina.text_label.offset.y =
						imgui.drag_float("Y", config.small_monster_UI.stamina.text_label.offset.y, 0.1, -screen_size.height, screen_size.height,
							"%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.small_monster_UI.stamina.text_label.color = imgui.color_picker_argb("", config.small_monster_UI.stamina.text_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.small_monster_UI.stamina.text_label.shadow.visibility =
						imgui.checkbox("Enable", config.small_monster_UI.stamina.text_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.small_monster_UI.stamina.text_label.shadow.offset.x =
							imgui.drag_float("X", config.small_monster_UI.stamina.text_label.shadow.offset.x, 0.1, -screen_size.width,
								screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.small_monster_UI.stamina.text_label.shadow.offset.y =
							imgui.drag_float("Y", config.small_monster_UI.stamina.text_label.shadow.offset.y, 0.1, -screen_size.width,
								screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.small_monster_UI.stamina.text_label.shadow.color = imgui.color_picker_argb("", config.small_monster_UI.stamina.text_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Value Label") then
				changed, config.small_monster_UI.stamina.value_label.visibility =
					imgui.checkbox("Visible", config.small_monster_UI.stamina.value_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.small_monster_UI.stamina.value_label.offset.x =
						imgui.drag_float("X", config.small_monster_UI.stamina.value_label.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.small_monster_UI.stamina.value_label.offset.y =
						imgui.drag_float("Y", config.small_monster_UI.stamina.value_label.offset.y, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.small_monster_UI.stamina.value_label.color = imgui.color_picker_argb("", config.small_monster_UI.stamina.value_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.small_monster_UI.stamina.value_label.shadow.visibility = imgui.checkbox("Enable",
						config.small_monster_UI.stamina.value_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.small_monster_UI.stamina.value_label.shadow.offset.x = imgui.drag_float("X",
							config.small_monster_UI.stamina.value_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.small_monster_UI.stamina.value_label.shadow.offset.y = imgui.drag_float("Y",
							config.small_monster_UI.stamina.value_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.small_monster_UI.stamina.value_label.shadow.color = imgui.color_picker_argb("", config.small_monster_UI.stamina.value_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Percentage Label") then
				changed, config.small_monster_UI.stamina.percentage_label.visibility = imgui.checkbox("Visible",
					config.small_monster_UI.stamina.percentage_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.small_monster_UI.stamina.percentage_label.offset.x =
						imgui.drag_float("X", config.small_monster_UI.stamina.percentage_label.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.small_monster_UI.stamina.percentage_label.offset.y =
						imgui.drag_float("Y", config.small_monster_UI.stamina.percentage_label.offset.y, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.small_monster_UI.stamina.percentage_label.color = imgui.color_picker_argb("", config.small_monster_UI.stamina.percentage_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.small_monster_UI.stamina.percentage_label.shadow.visibility = imgui.checkbox("Enable",
						config.small_monster_UI.stamina.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.small_monster_UI.stamina.percentage_label.shadow.offset.x = imgui.drag_float("X",
							config.small_monster_UI.stamina.percentage_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width,
							"%.1f");
						config_changed = config_changed or changed;
	
						changed, config.small_monster_UI.stamina.percentage_label.shadow.offset.y = imgui.drag_float("Y",
							config.small_monster_UI.stamina.percentage_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height,
							"%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.small_monster_UI.stamina.percentage_label.shadow.color = imgui.color_picker_argb("", config.small_monster_UI.stamina.percentage_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Bar") then
				changed, config.small_monster_UI.stamina.bar.visibility = imgui.checkbox("Visible", config.small_monster_UI.stamina.bar
					.visibility);
				config_changed = config_changed or changed;
	
				if imgui.tree_node("Offset") then
					changed, config.small_monster_UI.stamina.bar.offset.x = imgui.drag_float("X", config.small_monster_UI.stamina.bar
						.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.small_monster_UI.stamina.bar.offset.y = imgui.drag_float("Y", config.small_monster_UI.stamina.bar
						.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Size") then
					changed, config.small_monster_UI.stamina.bar.size.width =
						imgui.drag_float("Width", config.small_monster_UI.stamina.bar.size.width, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.small_monster_UI.stamina.bar.size.height =
						imgui.drag_float("Height", config.small_monster_UI.stamina.bar.size.height, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Colors") then
					if imgui.tree_node("Foreground") then
						--changed, config.small_monster_UI.stamina.bar.colors.foreground = imgui.color_picker_argb("", config.small_monster_UI.stamina.bar.colors.foreground, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Background") then
						--changed, config.small_monster_UI.stamina.bar.colors.background = imgui.color_picker_argb("", config.small_monster_UI.stamina.bar.colors.background, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Large Monster UI") then
		changed, config.large_monster_UI.enabled = imgui.checkbox("Enabled", config.large_monster_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node("Spacing") then
			changed, config.large_monster_UI.spacing.x = imgui.drag_float("X",
				config.large_monster_UI.spacing.x, 0.1, 0, screen_size.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.large_monster_UI.spacing.y = imgui.drag_float("Y",
				config.large_monster_UI.spacing.y, 0.1, 0, screen_size.width, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Settings") then
			changed, monster_UI_orientation_index = imgui.combo("Orientation", monster_UI_orientation_index, orientation_types);
			config_changed = config_changed or changed;
			if changed then
				config.large_monster_UI.settings.orientation = orientation_types[monster_UI_orientation_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Dynamic Positioning") then
			changed, config.large_monster_UI.dynamic_positioning.enabled =
				imgui.checkbox("Enabled", config.large_monster_UI.dynamic_positioning.enabled);
			config_changed = config_changed or changed;

			changed, config.large_monster_UI.dynamic_positioning.opacity_falloff = imgui.checkbox("Opacity Falloff", config.large_monster_UI.dynamic_positioning.opacity_falloff);
			config_changed = config_changed or changed;

			changed, config.large_monster_UI.dynamic_positioning.max_distance = imgui.drag_float("Max Distance",
					config.large_monster_UI.dynamic_positioning.max_distance, 1, 0, 10000, "%.0f");
				config_changed = config_changed or changed;

			if imgui.tree_node("World Offset") then
				changed, config.large_monster_UI.dynamic_positioning.world_offset.x = imgui.drag_float("X",
					config.large_monster_UI.dynamic_positioning.world_offset.x, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				changed, config.large_monster_UI.dynamic_positioning.world_offset.y = imgui.drag_float("Y",
					config.large_monster_UI.dynamic_positioning.world_offset.y, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				changed, config.large_monster_UI.dynamic_positioning.world_offset.z = imgui.drag_float("Z",
					config.large_monster_UI.dynamic_positioning.world_offset.z, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Viewport Offset") then
				changed, config.large_monster_UI.dynamic_positioning.viewport_offset.x = imgui.drag_float("X",
					config.large_monster_UI.dynamic_positioning.viewport_offset.x, 0.1, 0, screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.large_monster_UI.dynamic_positioning.viewport_offset.y = imgui.drag_float("Y",
					config.large_monster_UI.dynamic_positioning.viewport_offset.y, 0.1, 0, screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Position") then
			changed, config.large_monster_UI.position.x = imgui.drag_float("X", config.large_monster_UI.position.x, 0.1, 0,
				screen_size.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.large_monster_UI.position.y = imgui.drag_float("Y", config.large_monster_UI.position.y, 0.1, 0,
				screen_size.height, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Sorting") then
			changed, monster_UI_sort_type_index = imgui.combo("Type", monster_UI_sort_type_index, monster_UI_sort_types);
			config_changed = config_changed or changed;
			if changed then
				config.large_monster_UI.sorting.type = monster_UI_sort_types[monster_UI_sort_type_index];
			end

			changed, config.large_monster_UI.sorting.reversed_order = imgui.checkbox("Reversed Order",
				config.large_monster_UI.sorting.reversed_order);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Monster Name Label") then
			changed, config.large_monster_UI.monster_name_label.visibility =
				imgui.checkbox("Visible", config.large_monster_UI.monster_name_label.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Include") then
				changed, config.large_monster_UI.monster_name_label.include.monster_name =
					imgui.checkbox("Monster Name", config.large_monster_UI.monster_name_label.include.monster_name);
				config_changed = config_changed or changed;

				changed, config.large_monster_UI.monster_name_label.include.crown =
					imgui.checkbox("Crown", config.large_monster_UI.monster_name_label.include.crown);
				config_changed = config_changed or changed;

				changed, config.large_monster_UI.monster_name_label.include.size =
					imgui.checkbox("Size", config.large_monster_UI.monster_name_label.include.size);
				config_changed = config_changed or changed;

				changed, config.large_monster_UI.monster_name_label.include.scrown_thresholds = imgui.checkbox(
					"Crown Thresholds", config.large_monster_UI.monster_name_label.include.scrown_thresholds);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Offset") then
				changed, config.large_monster_UI.monster_name_label.offset.x =
					imgui.drag_float("X", config.large_monster_UI.monster_name_label.offset.x, 0.1, -screen_size.width,
						screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.large_monster_UI.monster_name_label.offset.y =
					imgui.drag_float("Y", config.large_monster_UI.monster_name_label.offset.y, 0.1, -screen_size.height,
						screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.large_monster_UI.monster_name_label.color = imgui.color_picker_argb("", config.large_monster_UI.monster_name_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.large_monster_UI.monster_name_label.shadow.visibility = imgui.checkbox("Enable",
					config.large_monster_UI.monster_name_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.monster_name_label.shadow.offset.x = imgui.drag_float("X",
						config.large_monster_UI.monster_name_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.large_monster_UI.monster_name_label.shadow.offset.y = imgui.drag_float("Y",
						config.large_monster_UI.monster_name_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.large_monster_UI.monster_name_label.shadow.color = imgui.color_picker_argb("", config.large_monster_UI.monster_name_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Health") then
			if imgui.tree_node("Text Label") then
				changed, config.large_monster_UI.health.text_label.visibility =
					imgui.checkbox("Visible", config.large_monster_UI.health.text_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.health.text_label.offset.x =
						imgui.drag_float("X", config.large_monster_UI.health.text_label.offset.x, 0.1, -screen_size.width, screen_size.width,
							"%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.health.text_label.offset.y =
						imgui.drag_float("Y", config.large_monster_UI.health.text_label.offset.y, 0.1, -screen_size.height, screen_size.height,
							"%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.large_monster_UI.health.text_label.color = imgui.color_picker_argb("", config.large_monster_UI.health.text_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.large_monster_UI.health.text_label.shadow.visibility =
						imgui.checkbox("Enable", config.large_monster_UI.health.text_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.large_monster_UI.health.text_label.shadow.offset.x =
							imgui.drag_float("X", config.large_monster_UI.health.text_label.shadow.offset.x, 0.1, -screen_size.width,
								screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.large_monster_UI.health.text_label.shadow.offset.y =
							imgui.drag_float("Y", config.large_monster_UI.health.text_label.shadow.offset.y, 0.1, -screen_size.width,
								screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.large_monster_UI.health.text_label.shadow.color = imgui.color_picker_argb("", config.large_monster_UI.health.text_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Value Label") then
				changed, config.large_monster_UI.health.value_label.visibility =
					imgui.checkbox("Visible", config.large_monster_UI.health.value_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.health.value_label.offset.x =
						imgui.drag_float("X", config.large_monster_UI.health.value_label.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.health.value_label.offset.y =
						imgui.drag_float("Y", config.large_monster_UI.health.value_label.offset.y, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.large_monster_UI.health.value_label.color = imgui.color_picker_argb("", config.large_monster_UI.health.value_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.large_monster_UI.health.value_label.shadow.visibility = imgui.checkbox("Enable",
						config.large_monster_UI.health.value_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.large_monster_UI.health.value_label.shadow.offset.x = imgui.drag_float("X",
							config.large_monster_UI.health.value_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.large_monster_UI.health.value_label.shadow.offset.y = imgui.drag_float("Y",
							config.large_monster_UI.health.value_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.large_monster_UI.health.value_label.shadow.color = imgui.color_picker_argb("", config.large_monster_UI.health.value_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Percentage Label") then
				changed, config.large_monster_UI.health.percentage_label.visibility = imgui.checkbox("Visible",
					config.large_monster_UI.health.percentage_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.health.percentage_label.offset.x =
						imgui.drag_float("X", config.large_monster_UI.health.percentage_label.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.health.percentage_label.offset.y =
						imgui.drag_float("Y", config.large_monster_UI.health.percentage_label.offset.y, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.large_monster_UI.health.percentage_label.color = imgui.color_picker_argb("", config.large_monster_UI.health.percentage_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.large_monster_UI.health.percentage_label.shadow.visibility = imgui.checkbox("Enable",
						config.large_monster_UI.health.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.large_monster_UI.health.percentage_label.shadow.offset.x = imgui.drag_float("X",
							config.large_monster_UI.health.percentage_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width,
							"%.1f");
						config_changed = config_changed or changed;
	
						changed, config.large_monster_UI.health.percentage_label.shadow.offset.y = imgui.drag_float("Y",
							config.large_monster_UI.health.percentage_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height,
							"%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.large_monster_UI.health.percentage_label.shadow.color = imgui.color_picker_argb("", config.large_monster_UI.health.percentage_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Bar") then
				changed, config.large_monster_UI.health.bar.visibility = imgui.checkbox("Visible", config.large_monster_UI.health.bar
					.visibility);
				config_changed = config_changed or changed;
	
				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.health.bar.offset.x = imgui.drag_float("X", config.large_monster_UI.health.bar
						.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.health.bar.offset.y = imgui.drag_float("Y", config.large_monster_UI.health.bar
						.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Size") then
					changed, config.large_monster_UI.health.bar.size.width =
						imgui.drag_float("Width", config.large_monster_UI.health.bar.size.width, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.health.bar.size.height =
						imgui.drag_float("Height", config.large_monster_UI.health.bar.size.height, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Colors") then
					if imgui.tree_node("Foreground") then
						--changed, config.large_monster_UI.health.bar.colors.foreground = imgui.color_picker_argb("", config.large_monster_UI.health.bar.colors.foreground, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Background") then
						--changed, config.large_monster_UI.health.bar.colors.background = imgui.color_picker_argb("", config.large_monster_UI.health.bar.colors.background, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Monster can be captured") then
						if imgui.tree_node("Foreground") then
							--changed, config.large_monster_UI.health.bar.colors.capture.foreground = imgui.color_picker_argb("", config.large_monster_UI.health.bar.colors.capture.foreground, color_picker_flags);
							config_changed = config_changed or changed;
							
							imgui.tree_pop();
						end
		
						if imgui.tree_node("Background") then
							--changed, config.large_monster_UI.health.bar.colors.capture.background = imgui.color_picker_argb("", config.large_monster_UI.health.bar.colors.capture.background, color_picker_flags);
							config_changed = config_changed or changed;
							
							imgui.tree_pop();
						end
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Stamina") then
			if imgui.tree_node("Text Label") then
				changed, config.large_monster_UI.stamina.text_label.visibility =
					imgui.checkbox("Visible", config.large_monster_UI.stamina.text_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.stamina.text_label.offset.x =
						imgui.drag_float("X", config.large_monster_UI.stamina.text_label.offset.x, 0.1, -screen_size.width, screen_size.width,
							"%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.stamina.text_label.offset.y =
						imgui.drag_float("Y", config.large_monster_UI.stamina.text_label.offset.y, 0.1, -screen_size.height, screen_size.height,
							"%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.large_monster_UI.stamina.text_label.color = imgui.color_picker_argb("", config.large_monster_UI.stamina.text_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.large_monster_UI.stamina.text_label.shadow.visibility =
						imgui.checkbox("Enable", config.large_monster_UI.stamina.text_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.large_monster_UI.stamina.text_label.shadow.offset.x =
							imgui.drag_float("X", config.large_monster_UI.stamina.text_label.shadow.offset.x, 0.1, -screen_size.width,
								screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.large_monster_UI.stamina.text_label.shadow.offset.y =
							imgui.drag_float("Y", config.large_monster_UI.stamina.text_label.shadow.offset.y, 0.1, -screen_size.width,
								screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.large_monster_UI.stamina.text_label.shadow.color = imgui.color_picker_argb("", config.large_monster_UI.stamina.text_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Value Label") then
				changed, config.large_monster_UI.stamina.value_label.visibility =
					imgui.checkbox("Visible", config.large_monster_UI.stamina.value_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.stamina.value_label.offset.x =
						imgui.drag_float("X", config.large_monster_UI.stamina.value_label.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.stamina.value_label.offset.y =
						imgui.drag_float("Y", config.large_monster_UI.stamina.value_label.offset.y, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.large_monster_UI.stamina.value_label.color = imgui.color_picker_argb("", config.large_monster_UI.stamina.value_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.large_monster_UI.stamina.value_label.shadow.visibility = imgui.checkbox("Enable",
						config.large_monster_UI.stamina.value_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.large_monster_UI.stamina.value_label.shadow.offset.x = imgui.drag_float("X",
							config.large_monster_UI.stamina.value_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.large_monster_UI.stamina.value_label.shadow.offset.y = imgui.drag_float("Y",
							config.large_monster_UI.stamina.value_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.large_monster_UI.stamina.value_label.shadow.color = imgui.color_picker_argb("", config.large_monster_UI.stamina.value_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Percentage Label") then
				changed, config.large_monster_UI.stamina.percentage_label.visibility = imgui.checkbox("Visible",
					config.large_monster_UI.stamina.percentage_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.stamina.percentage_label.offset.x =
						imgui.drag_float("X", config.large_monster_UI.stamina.percentage_label.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.stamina.percentage_label.offset.y =
						imgui.drag_float("Y", config.large_monster_UI.stamina.percentage_label.offset.y, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.large_monster_UI.stamina.percentage_label.color = imgui.color_picker_argb("", config.large_monster_UI.stamina.percentage_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.large_monster_UI.stamina.percentage_label.shadow.visibility = imgui.checkbox("Enable",
						config.large_monster_UI.stamina.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.large_monster_UI.stamina.percentage_label.shadow.offset.x = imgui.drag_float("X",
							config.large_monster_UI.stamina.percentage_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width,
							"%.1f");
						config_changed = config_changed or changed;
	
						changed, config.large_monster_UI.stamina.percentage_label.shadow.offset.y = imgui.drag_float("Y",
							config.large_monster_UI.stamina.percentage_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height,
							"%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.large_monster_UI.stamina.percentage_label.shadow.color = imgui.color_picker_argb("", config.large_monster_UI.stamina.percentage_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Bar") then
				changed, config.large_monster_UI.stamina.bar.visibility = imgui.checkbox("Visible", config.large_monster_UI.stamina.bar
					.visibility);
				config_changed = config_changed or changed;
	
				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.stamina.bar.offset.x = imgui.drag_float("X", config.large_monster_UI.stamina.bar
						.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.stamina.bar.offset.y = imgui.drag_float("Y", config.large_monster_UI.stamina.bar
						.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Size") then
					changed, config.large_monster_UI.stamina.bar.size.width =
						imgui.drag_float("Width", config.large_monster_UI.stamina.bar.size.width, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.stamina.bar.size.height =
						imgui.drag_float("Height", config.large_monster_UI.stamina.bar.size.height, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Colors") then
					if imgui.tree_node("Foreground") then
						--changed, config.large_monster_UI.stamina.bar.colors.foreground = imgui.color_picker_argb("", config.large_monster_UI.stamina.bar.colors.foreground, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Background") then
						--changed, config.large_monster_UI.stamina.bar.colors.background = imgui.color_picker_argb("", config.large_monster_UI.stamina.bar.colors.background, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Rage") then
			if imgui.tree_node("Text Label") then
				changed, config.large_monster_UI.rage.text_label.visibility =
					imgui.checkbox("Visible", config.large_monster_UI.rage.text_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.rage.text_label.offset.x =
						imgui.drag_float("X", config.large_monster_UI.rage.text_label.offset.x, 0.1, -screen_size.width, screen_size.width,
							"%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.rage.text_label.offset.y =
						imgui.drag_float("Y", config.large_monster_UI.rage.text_label.offset.y, 0.1, -screen_size.height, screen_size.height,
							"%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.large_monster_UI.rage.text_label.color = imgui.color_picker_argb("", config.large_monster_UI.rage.text_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.large_monster_UI.rage.text_label.shadow.visibility =
						imgui.checkbox("Enable", config.large_monster_UI.rage.text_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.large_monster_UI.rage.text_label.shadow.offset.x =
							imgui.drag_float("X", config.large_monster_UI.rage.text_label.shadow.offset.x, 0.1, -screen_size.width,
								screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.large_monster_UI.rage.text_label.shadow.offset.y =
							imgui.drag_float("Y", config.large_monster_UI.rage.text_label.shadow.offset.y, 0.1, -screen_size.width,
								screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.large_monster_UI.rage.text_label.shadow.color = imgui.color_picker_argb("", config.large_monster_UI.rage.text_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Value Label") then
				changed, config.large_monster_UI.rage.value_label.visibility =
					imgui.checkbox("Visible", config.large_monster_UI.rage.value_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.rage.value_label.offset.x =
						imgui.drag_float("X", config.large_monster_UI.rage.value_label.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.rage.value_label.offset.y =
						imgui.drag_float("Y", config.large_monster_UI.rage.value_label.offset.y, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.large_monster_UI.rage.value_label.color = imgui.color_picker_argb("", config.large_monster_UI.rage.value_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.large_monster_UI.rage.value_label.shadow.visibility = imgui.checkbox("Enable",
						config.large_monster_UI.rage.value_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.large_monster_UI.rage.value_label.shadow.offset.x = imgui.drag_float("X",
							config.large_monster_UI.rage.value_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.large_monster_UI.rage.value_label.shadow.offset.y = imgui.drag_float("Y",
							config.large_monster_UI.rage.value_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.large_monster_UI.rage.value_label.shadow.color = imgui.color_picker_argb("", config.large_monster_UI.rage.value_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Percentage Label") then
				changed, config.large_monster_UI.rage.percentage_label.visibility = imgui.checkbox("Visible",
					config.large_monster_UI.rage.percentage_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.rage.percentage_label.offset.x =
						imgui.drag_float("X", config.large_monster_UI.rage.percentage_label.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.rage.percentage_label.offset.y =
						imgui.drag_float("Y", config.large_monster_UI.rage.percentage_label.offset.y, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.large_monster_UI.rage.percentage_label.color = imgui.color_picker_argb("", config.large_monster_UI.rage.percentage_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.large_monster_UI.rage.percentage_label.shadow.visibility = imgui.checkbox("Enable",
						config.large_monster_UI.rage.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.large_monster_UI.rage.percentage_label.shadow.offset.x = imgui.drag_float("X",
							config.large_monster_UI.rage.percentage_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width,
							"%.1f");
						config_changed = config_changed or changed;
	
						changed, config.large_monster_UI.rage.percentage_label.shadow.offset.y = imgui.drag_float("Y",
							config.large_monster_UI.rage.percentage_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height,
							"%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.large_monster_UI.rage.percentage_label.shadow.color = imgui.color_picker_argb("", config.large_monster_UI.rage.percentage_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Bar") then
				changed, config.large_monster_UI.rage.bar.visibility = imgui.checkbox("Visible", config.large_monster_UI.rage.bar
					.visibility);
				config_changed = config_changed or changed;
	
				if imgui.tree_node("Offset") then
					changed, config.large_monster_UI.rage.bar.offset.x = imgui.drag_float("X", config.large_monster_UI.rage.bar
						.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.rage.bar.offset.y = imgui.drag_float("Y", config.large_monster_UI.rage.bar
						.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Size") then
					changed, config.large_monster_UI.rage.bar.size.width =
						imgui.drag_float("Width", config.large_monster_UI.rage.bar.size.width, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.large_monster_UI.rage.bar.size.height =
						imgui.drag_float("Height", config.large_monster_UI.rage.bar.size.height, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Colors") then
					if imgui.tree_node("Foreground") then
						--changed, config.large_monster_UI.rage.bar.colors.foreground = imgui.color_picker_argb("", config.large_monster_UI.rage.bar.colors.foreground, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Background") then
						--changed, config.large_monster_UI.rage.bar.colors.background = imgui.color_picker_argb("", config.large_monster_UI.rage.bar.colors.background, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Time UI") then
		changed, config.time_UI.enabled = imgui.checkbox("Enabled", config.time_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node("Position") then
			changed, config.time_UI.position.x = imgui.drag_float("X", config.time_UI.position.x, 0.1, 0, screen_size.width,
				"%.1f");
			config_changed = config_changed or changed;

			changed, config.time_UI.position.y = imgui.drag_float("Y", config.time_UI.position.y, 0.1, 0, screen_size.height,
				"%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Time Label") then
			changed, config.time_UI.time_label.visibility = imgui.checkbox("Visible", config.time_UI.time_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.time_UI.time_label.offset.x = imgui.drag_float("X", config.time_UI.time_label.offset.x, 0.1,
					-screen_size.width, screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.time_UI.time_label.offset.y = imgui.drag_float("Y", config.time_UI.time_label.offset.y, 0.1,
					-screen_size.height, screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.time_UI.time_label.color = imgui.color_picker_argb("", config.time_UI.time_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.time_UI.time_label.shadow.visibility = imgui.checkbox("Enable",
					config.time_UI.time_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.time_UI.time_label.shadow.offset.x = imgui.drag_float("X",
						config.time_UI.time_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.time_UI.time_label.shadow.offset.y = imgui.drag_float("Y",
						config.time_UI.time_label.shadow.offset.y, 0.1, -screen_size.width, screen_size.width, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.time_UI.time_label.shadow.color = imgui.color_picker_argb("", config.time_UI.time_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end
			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Damage Meter UI") then
		changed, config.damage_meter_UI.enabled = imgui.checkbox("Enabled", config.damage_meter_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node("Settings") then
			changed, config.damage_meter_UI.settings.hide_module_if_total_damage_is_zero = imgui.checkbox(
				"Hide Module if Total Damage is 0", config.damage_meter_UI.settings.hide_module_if_total_damage_is_zero);
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero = imgui.checkbox(
				"Hide Player if Player Damage is 0", config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero);
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.settings.total_damage_offset_is_relative = imgui.checkbox(
				"Total Damage Offset is Relative", config.damage_meter_UI.settings.total_damage_offset_is_relative);
			config_changed = config_changed or changed;

			changed, damage_meter_UI_orientation_index = imgui.combo("Orientation", damage_meter_UI_orientation_index,
				orientation_types);
			config_changed = config_changed or changed;
			if changed then
				config.damage_meter_UI.settings.orientation = orientation_types[damage_meter_UI_orientation_index];
			end

			changed, damage_meter_UI_highlighted_bar_index = imgui.combo("Highlighted Bar",
				damage_meter_UI_highlighted_bar_index, damage_meter_UI_highlighted_bar_types);
			config_changed = config_changed or changed;
			if changed then
				config.damage_meter_UI.settings.highlighted_bar =
					damage_meter_UI_highlighted_bar_types[damage_meter_UI_highlighted_bar_index];
			end

			changed, damage_meter_UI_damage_bar_relative_index = imgui.combo("Damage Bars are Relative to",
				damage_meter_UI_damage_bar_relative_index, damage_meter_UI_damage_bar_relative_types);
			config_changed = config_changed or changed;
			if changed then
				config.damage_meter_UI.settings.damage_bar_relative_to =
					damage_meter_UI_damage_bar_relative_types[damage_meter_UI_damage_bar_relative_index];
			end

			changed, damage_meter_UI_my_damage_bar_location_index = imgui.combo("My Damage Bar Location",
				damage_meter_UI_my_damage_bar_location_index, damage_meter_UI_my_damage_bar_location_types);
			config_changed = config_changed or changed;
			if changed then
				config.damage_meter_UI.settings.my_damage_bar_location =
					damage_meter_UI_my_damage_bar_location_types[damage_meter_UI_my_damage_bar_location_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Tracked Monster Types") then
			local tracked_monster_types_changed = false;
			changed, config.damage_meter_UI.tracked_monster_types.small_monsters =
				imgui.checkbox("Small Monsters", config.damage_meter_UI.tracked_monster_types.small_monsters);
			config_changed = config_changed or changed;
			tracked_monster_types_changed = tracked_monster_types_changed or changed;

			changed, config.damage_meter_UI.tracked_monster_types.large_monsters =
				imgui.checkbox("Large Monsters", config.damage_meter_UI.tracked_monster_types.large_monsters);
			config_changed = config_changed or changed;
			tracked_monster_types_changed = tracked_monster_types_changed or changed;

			if tracked_monster_types_changed then
				for player_id, player in pairs(players) do
					update_player_display(player);
				end
				update_player_display(total);
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Tracked Damage Types") then
			local tracked_damage_types_changed = false;
			changed, config.damage_meter_UI.tracked_damage_types.player_damage =
				imgui.checkbox("Player Damage", config.damage_meter_UI.tracked_damage_types.player_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.damage_meter_UI.tracked_damage_types.bomb_damage = imgui.checkbox("Bomb Damage",
				config.damage_meter_UI.tracked_damage_types.bomb_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.damage_meter_UI.tracked_damage_types.kunai_damage =
				imgui.checkbox("Kunai Damage", config.damage_meter_UI.tracked_damage_types.kunai_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.damage_meter_UI.tracked_damage_types.installation_damage =
				imgui.checkbox("Installation Damage", config.damage_meter_UI.tracked_damage_types.installation_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.damage_meter_UI.tracked_damage_types.otomo_damage =
				imgui.checkbox("Otomo Damage", config.damage_meter_UI.tracked_damage_types.otomo_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.damage_meter_UI.tracked_damage_types.monster_damage =
				imgui.checkbox("Monster Damage", config.damage_meter_UI.tracked_damage_types.monster_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			if tracked_damage_types_changed then
				for player_id, player in pairs(players) do
					update_player_display(player);
				end
				update_player_display(total);
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Spacing") then
			changed, config.damage_meter_UI.spacing.x = imgui.drag_float("X",
				config.damage_meter_UI.spacing.x, 0.1, 0, screen_size.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.spacing.y = imgui.drag_float("Y",
				config.damage_meter_UI.spacing.y, 0.1, 0, screen_size.width, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Position") then
			changed, config.damage_meter_UI.position.x = imgui.drag_float("X", config.damage_meter_UI.position.x, 0.1, 0,
				screen_size.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.position.y = imgui.drag_float("Y", config.damage_meter_UI.position.y, 0.1, 0,
				screen_size.height, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Sorting") then
			changed, damage_meter_UI_sort_type_index = imgui.combo("Type", damage_meter_UI_sort_type_index,
				damage_meter_UI_sort_types);
			config_changed = config_changed or changed;
			if changed then
				config.damage_meter_UI.sorting.type = damage_meter_UI_sort_types[damage_meter_UI_sort_type_index];
			end

			changed, config.damage_meter_UI.sorting.reversed_order = imgui.checkbox("Reversed Order",
				config.damage_meter_UI.sorting.reversed_order);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Player Name Label") then
			changed, config.damage_meter_UI.player_name_label.visibility =
				imgui.checkbox("Visible", config.damage_meter_UI.player_name_label.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Include") then
				if imgui.tree_node("Me") then
					changed, config.damage_meter_UI.player_name_label.include.myself.hunter_rank = imgui.checkbox("Hunter Rank",
						config.damage_meter_UI.player_name_label.include.myself.hunter_rank);
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.player_name_label.include.myself.word_player =
						imgui.checkbox("Word \"Player\"", config.damage_meter_UI.player_name_label.include.myself.word_player);
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.player_name_label.include.myself.player_id = imgui.checkbox("Player ID",
						config.damage_meter_UI.player_name_label.include.myself.player_id);
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.player_name_label.include.myself.player_name = imgui.checkbox("Player Name",
						config.damage_meter_UI.player_name_label.include.myself.player_name);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Other Players") then
					changed, config.damage_meter_UI.player_name_label.include.others.hunter_rank = imgui.checkbox("Hunter Rank",
						config.damage_meter_UI.player_name_label.include.others.hunter_rank);
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.player_name_label.include.others.word_player =
						imgui.checkbox("Word \"Player\"", config.damage_meter_UI.player_name_label.include.others.word_player);
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.player_name_label.include.others.player_id = imgui.checkbox("Player ID",
						config.damage_meter_UI.player_name_label.include.others.player_id);
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.player_name_label.include.others.player_name = imgui.checkbox("Player Name",
						config.damage_meter_UI.player_name_label.include.others.player_name);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.player_name_label.offset.x =
					imgui.drag_float("X", config.damage_meter_UI.player_name_label.offset.x, 0.1, -screen_size.width,
						screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.player_name_label.offset.y =
					imgui.drag_float("Y", config.damage_meter_UI.player_name_label.offset.y, 0.1, -screen_size.height,
						screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.damage_meter_UI.player_name_label.color = imgui.color_picker_argb("", config.damage_meter_UI.player_name_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.damage_meter_UI.player_name_label.shadow.visibility = imgui.checkbox("Enable",
					config.damage_meter_UI.player_name_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.damage_meter_UI.player_name_label.shadow.offset.x =
						imgui.drag_float("X", config.damage_meter_UI.player_name_label.shadow.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.player_name_label.shadow.offset.y =
						imgui.drag_float("Y", config.damage_meter_UI.player_name_label.shadow.offset.y, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.damage_meter_UI.player_name_label.shadow.color = imgui.color_picker_argb("", config.damage_meter_UI.player_name_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Damage Value Label") then
			changed, config.damage_meter_UI.damage_value_label.visibility =
				imgui.checkbox("Visible", config.damage_meter_UI.damage_value_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.damage_value_label.offset.x =
					imgui.drag_float("X", config.damage_meter_UI.damage_value_label.offset.x, 0.1, -screen_size.width,
						screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.damage_value_label.offset.y =
					imgui.drag_float("Y", config.damage_meter_UI.damage_value_label.offset.y, 0.1, -screen_size.height,
						screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.damage_meter_UI.damage_value_label.color = imgui.color_picker_argb("", config.damage_meter_UI.damage_value_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.damage_meter_UI.damage_value_label.shadow.visibility = imgui.checkbox("Enable",
					config.damage_meter_UI.damage_value_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.damage_meter_UI.damage_value_label.shadow.offset.x =
						imgui.drag_float("X", config.damage_meter_UI.damage_value_label.shadow.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.damage_value_label.shadow.offset.y =
						imgui.drag_float("Y", config.damage_meter_UI.damage_value_label.shadow.offset.y, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.damage_meter_UI.damage_value_label.shadow.color = imgui.color_picker_argb("", config.damage_meter_UI.damage_value_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Damage Percentage Label") then
			changed, config.damage_meter_UI.damage_percentage_label.visibility =
				imgui.checkbox("Visible", config.damage_meter_UI.damage_percentage_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.damage_percentage_label.offset.x =
					imgui.drag_float("X", config.damage_meter_UI.damage_percentage_label.offset.x, 0.1, -screen_size.width,
						screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.damage_percentage_label.offset.y =
					imgui.drag_float("Y", config.damage_meter_UI.damage_percentage_label.offset.y, 0.1, -screen_size.height,
						screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.damage_meter_UI.damage_percentage_label.color = imgui.color_picker_argb("", config.damage_meter_UI.damage_percentage_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.damage_meter_UI.damage_percentage_label.shadow.visibility = imgui.checkbox("Enable",
					config.damage_meter_UI.damage_percentage_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.damage_meter_UI.damage_percentage_label.shadow.offset.x = imgui.drag_float("X",
						config.damage_meter_UI.damage_percentage_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.damage_percentage_label.shadow.offset.y = imgui.drag_float("Y",
						config.damage_meter_UI.damage_percentage_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height,
						"%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.damage_meter_UI.damage_percentage_label.shadow.color = imgui.color_picker_argb("", config.damage_meter_UI.damage_percentage_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Total Damage Label") then
			changed, config.damage_meter_UI.total_damage_label.visibility =
				imgui.checkbox("Visible", config.damage_meter_UI.total_damage_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.total_damage_label.offset.x =
					imgui.drag_float("X", config.damage_meter_UI.total_damage_label.offset.x, 0.1, -screen_size.width,
						screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.total_damage_label.offset.y =
					imgui.drag_float("Y", config.damage_meter_UI.total_damage_label.offset.y, 0.1, -screen_size.height,
						screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.damage_meter_UI.total_damage_label.color = imgui.color_picker_argb("", config.damage_meter_UI.total_damage_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.damage_meter_UI.total_damage_label.shadow.visibility = imgui.checkbox("Enable",
					config.damage_meter_UI.total_damage_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.damage_meter_UI.total_damage_label.shadow.offset.x =
						imgui.drag_float("X", config.damage_meter_UI.total_damage_label.shadow.offset.x, 0.1, -screen_size.width,
							screen_size.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.total_damage_label.shadow.offset.y =
						imgui.drag_float("Y", config.damage_meter_UI.total_damage_label.shadow.offset.y, 0.1, -screen_size.height,
							screen_size.height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.damage_meter_UI.total_damage_label.shadow.color = imgui.color_picker_argb("", config.damage_meter_UI.total_damage_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Total Damage Value Label") then
			changed, config.damage_meter_UI.total_damage_value_label.visibility = imgui.checkbox("Visible",
				config.damage_meter_UI.total_damage_value_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.total_damage_value_label.offset.x =
					imgui.drag_float("X", config.damage_meter_UI.total_damage_value_label.offset.x, 0.1, -screen_size.width,
						screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.total_damage_value_label.offset.y =
					imgui.drag_float("Y", config.damage_meter_UI.total_damage_value_label.offset.y, 0.1, -screen_size.height,
						screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.damage_meter_UI.total_damage_value_label.color = imgui.color_picker_argb("", config.damage_meter_UI.total_damage_value_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.damage_meter_UI.total_damage_value_label.shadow.visibility = imgui.checkbox("Enable",
					config.damage_meter_UI.total_damage_value_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.damage_meter_UI.total_damage_value_label.shadow.offset.x = imgui.drag_float("X",
						config.damage_meter_UI.total_damage_value_label.shadow.offset.x, 0.1, -screen_size.width, screen_size.width,
						"%.1f");
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.total_damage_value_label.shadow.offset.y = imgui.drag_float("Y",
						config.damage_meter_UI.total_damage_value_label.shadow.offset.y, 0.1, -screen_size.height, screen_size.height,
						"%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.damage_meter_UI.total_damage_value_label.shadow.color = imgui.color_picker_argb("", config.damage_meter_UI.total_damage_value_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Damage Bar") then
			changed, config.damage_meter_UI.damage_bar.visibility = imgui.checkbox("Visible",
				config.damage_meter_UI.damage_bar.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.damage_bar.offset.x = imgui.drag_float("X",
					config.damage_meter_UI.damage_bar.offset.x, 0.1, -screen_size.width, screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.damage_bar.offset.y = imgui.drag_float("Y",
					config.damage_meter_UI.damage_bar.offset.y, 0.1, -screen_size.height, screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Size") then
				changed, config.damage_meter_UI.damage_bar.size.width = imgui.drag_float("Width", config.damage_meter_UI.damage_bar
					.size.width, 0.1, -screen_size.width, screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.damage_bar.size.height =
					imgui.drag_float("Height", config.damage_meter_UI.damage_bar.size.height, 0.1, -screen_size.height,
						screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Colors") then
				if imgui.tree_node("Foreground") then
					--changed, config.damage_meter_UI.damage_bar.colors.foreground = imgui.color_picker_argb("", config.damage_meter_UI.damage_bar.colors.foreground, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				if imgui.tree_node("Background") then
					--changed, config.damage_meter_UI.damage_bar.colors.background = imgui.color_picker_argb("", config.damage_meter_UI.damage_bar.colors.background, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Highlighted Damage Bar") then
			changed, config.damage_meter_UI.highlighted_damage_bar.visibility =
				imgui.checkbox("Visible", config.damage_meter_UI.highlighted_damage_bar.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.highlighted_damage_bar.offset.x =
					imgui.drag_float("X", config.damage_meter_UI.highlighted_damage_bar.offset.x, 0.1, -screen_size.width,
						screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.highlighted_damage_bar.offset.y =
					imgui.drag_float("Y", config.damage_meter_UI.highlighted_damage_bar.offset.y, 0.1, -screen_size.height,
						screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Size") then
				changed, config.damage_meter_UI.highlighted_damage_bar.size.width = imgui.drag_float("Width", config.damage_meter_UI.highlighted_damage_bar
					.size.width, 0.1, -screen_size.width, screen_size.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.highlighted_damage_bar.size.height =
					imgui.drag_float("Height", config.damage_meter_UI.highlighted_damage_bar.size.height, 0.1, -screen_size.height,
						screen_size.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Colors") then
				if imgui.tree_node("Foreground") then
					--changed, config.damage_meter_UI.highlighted_damage_bar.colors.foreground = imgui.color_picker_argb("", config.damage_meter_UI.highlighted_damage_bar.colors.foreground, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				if imgui.tree_node("Background") then
					--changed, config.damage_meter_UI.highlighted_damage_bar.colors.background = imgui.color_picker_argb("", config.damage_meter_UI.highlighted_damage_bar.colors.background, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	imgui.end_window();

	if config_changed then
		save_config();
	end
end
-- #endregion
----------------------CUSTOMIZATION UI-----------------------

------------------------DRAW HELPERS-------------------------
-- #region
color_to_rgba = function(color)
	local alpha = (color >> 24) & 0xFF;
	local red = (color >> 16) & 0xFF;
	local green = (color >> 8) & 0xFF;
	local blue = color & 0xFF;

	return red, green, blue, alpha;
end

argb_to_color = function(red, green, blue, alpha)
    return 0x1000000 * alpha + 0x10000 * red + 0x100 * green + blue;
end

scale_color_opacity = function(color, scale)
	local red, green, blue, alpha = color_to_rgba(color);

	local new_alpha = math.floor(alpha * scale);
	if new_alpha < 0 then new_alpha = 0; end
	if new_alpha > 255 then new_alpha = 255; end

	return argb_to_color(red, green, blue, new_alpha);
end

scale_bar_opacity = function(bar, scale)
	if bar == nil or scale == nil then
		return;
	end

	if not bar.visibility then
		return;
	end
	
	bar.colors.foreground = scale_color_opacity(bar.colors.foreground, scale);
	bar.colors.background = scale_color_opacity(bar.colors.background, scale);
end

scale_label_opacity = function(label, scale)
	if label == nil or scale == nil then
		return;
	end

	if not label.visibility then
		return;
	end

	label.color = scale_color_opacity(label.color, scale);
	label.shadow.color = scale_color_opacity(label.shadow.color, scale);
end

draw_label = function(label, position, ...)
	if label == nil or not label.visibility then
		return;
	end
	
	local text = string.format(label.text, table.unpack({...}));
	if label.shadow.visibility then
		d2d.text(font, text, position.x + label.offset.x + label.shadow.offset.x,
			position.y + label.offset.y + label.shadow.offset.y, label.shadow.color);
	end
	d2d.text(font, text, position.x + label.offset.x, position.y + label.offset.y, label.color);
end

draw_bar = function(bar, position, percentage)
	if bar == nil then
		return;
	end

	if not bar.visibility then
		return;
	end

	if percentage > 1 then 
		percentage = 1;
	end

	local foreground_width = bar.size.width * percentage;
	local background_width = bar.size.width - foreground_width;

	-- foreground
	d2d.fill_rect(position.x + bar.offset.x, position.y + bar.offset.y, foreground_width, bar.size.height,
		bar.colors.foreground);

	-- background
	d2d.fill_rect(position.x + foreground_width + bar.offset.x, position.y + bar.offset.y, background_width,
		bar.size.height, bar.colors.background);
end

old_draw_label = function(label, position, ...)
	if label == nil then
		return;
	end

	if not label.visibility then
		return;
	end

	local text = string.format(label.text, table.unpack({...}));
	if label.shadow.visibility then
		draw.text(text, position.x + label.offset.x + label.shadow.offset.x,
			position.y + label.offset.y + label.shadow.offset.y, label.shadow.color);
	end
	draw.text(text, position.x + label.offset.x, position.y + label.offset.y, label.color);
end

old_draw_bar = function(bar, position, percentage)
	if bar == nil then
		return;
	end

	if not bar.visibility then
		return;
	end

	local foreground_width = bar.size.width * percentage;
	local background_width = bar.size.width - foreground_width;

	-- foreground
	draw.filled_rect(position.x + bar.offset.x, position.y + bar.offset.y, foreground_width, bar.size.height,
		bar.colors.foreground);

	-- background
	draw.filled_rect(position.x + foreground_width + bar.offset.x, position.y + bar.offset.y, background_width,
		bar.size.height, bar.colors.background);
end
-- #endregion
------------------------DRAW HELPERS-------------------------

------------------------QUEST STATUS-------------------------
-- #region
local quest_manager_type_definition = sdk.find_type_definition("snow.QuestManager");
local on_changed_game_status = quest_manager_type_definition:get_method("onChangedGameStatus");

sdk.hook(on_changed_game_status, function(args)
	local new_quest_status = sdk.to_int64(args[3]);
	if new_quest_status ~= nil then
		if (quest_status < 2 and new_quest_status == 2) or
		new_quest_status <2 then
			players = {};
			total = init_player(0, "Total", 0);
			small_monsters = {};
			large_monsters = {};
		end

		quest_status = new_quest_status;
	end

end, function(retval)
	return retval;
end);
-- #endregion
------------------------QUEST STATUS-------------------------

------------------------VILLAGE AREA-------------------------
-- #region
is_in_training_area = function()
	if village_area_manager == nil then
		status = "No village area manager";
		return false;
	end

	local is_training_area = village_area_manager:call("checkCurrentArea_TrainingArea");
	if is_training_area ~= nil then
		return is_training_area;
	end

	return false;
end
-- #endregion
------------------------VILLAGE AREA-------------------------

----------------------PLAYER POSITION------------------------
-- #region
update_player_position = function()
	if player_manager == nil then 
		status = "No player manager";
		return;
	end

	local master_player = player_manager:call("findMasterPlayer")
	if master_player == nil then
		status = "No master player";
		return;
	end

	local master_player_game_object = master_player:call("get_GameObject")
	if master_player_game_object == nil then
		status = "No master player game object";
		return;
	end

	local master_player_transform = master_player_game_object:call("get_Transform")
	if not master_player_transform then
		status = "No master player transform";
		return;
	end

	local _master_player_position = master_player_transform:call("get_Position")
	if _master_player_position == nil then
		status = "No masterplayer position";
		return;
	end

	myself_player_position = _master_player_position;
end
-- #endregion
----------------------PLAYER POSITION------------------------

------------------------MONSTER HOOK-------------------------
-- #region
local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_type_def_update_method = enemy_character_base_type_def:get_method("update");

sdk.hook(enemy_character_base_type_def_update_method, function(args)
	update_monster(sdk.to_managed_object(args[2]));
end, function(retval)
	return retval;
end);

init_monster = function(is_large)
	monster = {};
	monster.is_large = is_large;

	monster.health = 0;
	monster.max_health = 999999;
	monster.health_percentage = 0;
	monster.missing_health = 0;
	monster.capture_health = 0;

	monster.stamina = 0;
	monster.max_stamina = 1000;
	monster.stamina_percentage = 0;
	monster.missing_stamina = 0;

	monster.is_in_rage = false;
	monster.rage_point = 0;
	monster.rage_limit = 2001;
	monster.rage_timer = 0;
	monster.rage_duration = 600;
	monster.rage_count = 0;
	monster.rage_percentage = 0;

	monster.rage_total_seconds_left = 0;
	monster.rage_minutes_left = 0;
	monster.rage_seconds_left = 0;
	monster.rage_timer_percentage = 0;

	monster.position = {
		x = 0,
		y = 0
	};

	monster.name = "";
	monster.size = 1;
	monster.small_border = 0;
	monster.big_border = 5;
	monster.king_border = 10;
	monster.crown = "";

	return monster;
end

update_monster = function(enemy)
	if enemy == nil then
		return;
	end

	local is_boss_enemy = enemy:call("get_isBossEnemy");
	if is_boss_enemy == nil then
		return;
	end

	local physical_param = enemy:get_field("<PhysicalParam>k__BackingField");
	if physical_param == nil then
		status = "No physical param";
		return;
	end

	local status_param = enemy:get_field("<StatusParam>k__BackingField");
	if status_param == nil then
		status = "No status param";
		return;
	end

	local anger_param = enemy:get_field("<AngerParam>k__BackingField");
	if anger_param == nil then
		status = "No anger param";
		return;
	end

	local stamina_param = enemy:get_field("<StaminaParam>k__BackingField");
	if stamina_param == nil then
		status = "No stamina param";
		return;
	end

	local vital_param = physical_param:call("getVital", 0, 0);
	if vital_param == nil then
		status = "No vital param";
		return;
	end

	local health = vital_param:call("get_Current");
	local max_health = vital_param:call("get_Max");
	local capture_health = physical_param:call("get_CaptureHpVital");

	local stamina = stamina_param:call("getStamina");
	local max_stamina = stamina_param:call("getMaxStamina");

	local is_in_rage = anger_param:call("isAnger");
	local rage_point = anger_param:call("get_AngerPoint");
	local rage_limit = anger_param:call("get_LimitAnger");
	local rage_timer = anger_param:call("get_Timer");
	local rage_duration = anger_param:call("get_TimerAnger");
	local rage_count = anger_param:call("get_CountAnger");

	local enemy_game_object = enemy:call("get_GameObject");
	if enemy_game_object == nil then
		status = "No enemy game object";
		return;
	end

	local enemy_transform = enemy_game_object:call("get_Transform");
	if enemy_transform == nil then
		status = "No enemy transform";
		return;
	end

	local position = enemy_transform:call("get_Position");
	if not position then
		status = "No enemy position";
		return;
	end

	local monster_list = large_monsters;
	if not is_boss_enemy then
		monster_list = small_monsters;
	end

	local monster = monster_list[enemy];

	if monster == nil then
		monster = init_monster(is_boss_enemy);

		monster_list[enemy] = monster;

		local enemy_type = enemy:get_field("<EnemyType>k__BackingField");
		if enemy_type == nil then
			status = "No enemy type";
			return;
		end

		local enemy_name = message_manager:call("getEnemyNameMessage", enemy_type);
		if enemy_name ~= nil then
			monster.name = enemy_name;
		end

		if is_boss_enemy then
			local size_info = enemy_manager:call("findEnemySizeInfo", enemy_type);
			if size_info ~= nil then
				local small_border = size_info:call("get_SmallBorder");
				local big_border = size_info:call("get_BigBorder");
				local king_border = size_info:call("get_KingBorder");

				local size = enemy:call("get_MonsterListRegisterScale");

				if small_border ~= nil then
					monster.small_border = small_border;
				end

				if big_border ~= nil then
					monster.big_border = big_border;
				end

				if king_border ~= nil then
					monster.king_border = king_border;
				end


				if size ~= nil then
					monster.size = size;
				end

				if monster.size <= monster.small_border then
					monster.crown = "Mini";
				elseif monster.size >= monster.king_border then
					monster.crown = "Gold";
				elseif monster.size >= monster.big_border then
					monster.crown = "Silver";
				end
			end
		end
	end

	if health ~= nil then
		monster.health = health;
	end

	if max_health ~= nil then
		monster.max_health = max_health;
	end

	if capture_health ~= nil then
		monster.capture_health = capture_health;
	end

	if max_health ~= nil and health ~= nil then
		monster.missing_health = max_health - health;
		if max_health ~= 0 then
			monster.health_percentage = health / max_health;
		end
	end

	if position ~= nil then
		monster.position = position;
	end

	if stamina ~= nil then
		monster.stamina = stamina;
	end

	if max_stamina ~= nil then
		monster.max_stamina = max_stamina;
	end

	if max_stamina ~= nil and stamina ~= nil then
		monster.missing_stamina = max_stamina - stamina;
		if max_stamina  ~= 0 then
			monster.stamina_percentage = stamina / max_stamina;
		end
	end

	if is_in_rage ~= nil then
		monster.is_in_rage = is_in_rage;
	end

	if rage_point ~= nil then
		monster.rage_point = rage_point;
	end

	if rage_limit ~= nil then
		monster.rage_limit = rage_limit;
	end

	if rage_point ~= nil and rage_limit ~= nil then
		if rage_limit ~= 0 then
			monster.rage_percentage = rage_point / rage_limit;
		end
	end

	if rage_timer ~= nil then
		monster.rage_timer = rage_timer;
	end

	if rage_duration ~= nil then
		monster.rage_duration = rage_duration;
	end

	if rage_timer ~= nil and rage_duration ~= nil and monster.is_in_rage then
		monster.rage_total_seconds_left = rage_duration - rage_timer;
		if monster.rage_total_seconds_left < 0 then
			monster.rage_total_seconds_left = 0;
		end

		monster.rage_minutes_left = math.floor(monster.rage_total_seconds_left / 60);
		monster.rage_seconds_left = monster.rage_total_seconds_left - 60 * monster.rage_minutes_left;
		if rage_duration ~= 0 then
			monster.rage_timer_percentage = monster.rage_total_seconds_left / rage_duration;
		end
	end

	if rage_count ~= nil then
		monster.rage_count = rage_count;
	end
end
-- #endregion
------------------------MONSTER HOOK-------------------------

----------------------SMALL MONSTER UI-----------------------
-- #region
small_monster_data = function()
	if enemy_manager == nil then
		status = "No enemy manager";
		return;
	end

	local displayed_monsters = {};

	local enemy_count = enemy_manager:call("getZakoEnemyCount");
	if enemy_count == nil then
		status = "No enemy count";
		return;
	end

	for i = 0, enemy_count - 1 do
		local enemy = enemy_manager:call("getZakoEnemy", i);
		if enemy == nil then
			status = "No enemy";
			break
		end

		local monster = small_monsters[enemy];
		if monster == nil then
			status = "No monster hp entry";
			break
		end

		table.insert(displayed_monsters, monster);
	end

	if not config.small_monster_UI.dynamic_positioning.enabled then
		-- sort here
		if config.small_monster_UI.sorting.type == "Normal" and config.small_monster_UI.sorting.reversed_order then
			local reversed_monsters = {};
			for i = #displayed_monsters, 1, -1 do
				table.insert(reversed_monsters, displayed_monsters[i]);
			end
			displayed_monsters = reversed_monsters;

		elseif config.small_monster_UI.sorting.type == "Health" then
			if config.small_monster_UI.sorting.reversed_order then
				table.sort(displayed_monsters, function(left, right)
					return left.health > right.health;
				end);
			else
				table.sort(displayed_monsters, function(left, right)
					return left.health < right.health;
				end);
			end

		elseif config.small_monster_UI.sorting.type == "Health Percentage" then
			if config.small_monster_UI.sorting.reversed_order then
				table.sort(displayed_monsters, function(left, right)
					return left.health_percentage > right.health_percentage;
				end);
			else
				table.sort(displayed_monsters, function(left, right)
					return left.health_percentage < right.health_percentage;
				end);
			end
		end
	end

	x = "";
	local i = 0;
	for _, monster in ipairs(displayed_monsters) do
		local position_on_screen;
	
		if config.small_monster_UI.dynamic_positioning.enabled then
			local world_offset = Vector3f.new(config.small_monster_UI.dynamic_positioning.world_offset.x, config.small_monster_UI.dynamic_positioning.world_offset.y, config.small_monster_UI.dynamic_positioning.world_offset.z);

			position_on_screen = draw.world_to_screen(monster.position + world_offset);

			if position_on_screen == nil then
				goto continue
			end

			position_on_screen.x = position_on_screen.x + config.small_monster_UI.dynamic_positioning.viewport_offset.x;
			position_on_screen.y = position_on_screen.y + config.small_monster_UI.dynamic_positioning.viewport_offset.y;
		else
			position_on_screen = calculate_screen_coordinates(config.small_monster_UI.position);
			if config.small_monster_UI.settings.orientation == "Horizontal" then
				position_on_screen.x = position_on_screen.x + config.small_monster_UI.spacing.x * i;

			else
				position_on_screen.y = position_on_screen.y + config.small_monster_UI.spacing.y * i;
			end
		end

		local monster_name_label = config.small_monster_UI.monster_name_label;

		local health_bar = config.small_monster_UI.health.bar;
		local health_label = config.small_monster_UI.health.text_label;
		local health_value_label = config.small_monster_UI.health.value_label;
		local health_percentage_label = config.small_monster_UI.health.percentage_label;

		local stamina_bar = config.small_monster_UI.stamina.bar;
		local stamina_label = config.small_monster_UI.stamina.text_label;
		local stamina_value_label = config.small_monster_UI.stamina.value_label;
		local stamina_percentage_label = config.small_monster_UI.stamina.percentage_label;

		if config.small_monster_UI.dynamic_positioning.enabled then
			if config.small_monster_UI.dynamic_positioning.max_distance == 0 then
				return;
			end

			local distance = (myself_player_position - monster.position):length();

			if distance > config.small_monster_UI.dynamic_positioning.max_distance then
				goto continue;
			end
			
			if config.small_monster_UI.dynamic_positioning.opacity_falloff then
				local opacity_falloff = 1 - (distance / config.small_monster_UI.dynamic_positioning.max_distance);

				monster_name_label = table_deep_copy(config.small_monster_UI.monster_name_label);

				health_bar = table_deep_copy(config.small_monster_UI.health.bar);
				health_label = table_deep_copy(config.small_monster_UI.health.text_label);
				health_value_label = table_deep_copy(config.small_monster_UI.health.value_label);
				health_percentage_label = table_deep_copy(config.small_monster_UI.health.percentage_label);

				stamina_bar = table_deep_copy(config.small_monster_UI.stamina.bar);
				stamina_label = table_deep_copy(config.small_monster_UI.stamina.text_label);
				stamina_value_label = table_deep_copy(config.small_monster_UI.stamina.value_label);
				stamina_percentage_label = table_deep_copy(config.small_monster_UI.stamina.percentage_label);

				scale_bar_opacity(health_bar, opacity_falloff);
				scale_bar_opacity(stamina_bar, opacity_falloff)

				scale_label_opacity(monster_name_label, opacity_falloff);

				scale_label_opacity(health_label, opacity_falloff);
				scale_label_opacity(health_value_label, opacity_falloff);
				scale_label_opacity(health_percentage_label, opacity_falloff);

				scale_label_opacity(stamina_label, opacity_falloff);
				scale_label_opacity(stamina_value_label, opacity_falloff);
				scale_label_opacity(stamina_percentage_label, opacity_falloff);
			end
		end
	
		draw_bar(health_bar, position_on_screen, monster.health_percentage);
		draw_bar(stamina_bar, position_on_screen, monster.stamina_percentage);

		draw_label(monster_name_label, position_on_screen, monster.name);

		draw_label(health_label, position_on_screen);
		draw_label(health_value_label, position_on_screen, monster.health, monster.max_health);
		draw_label(health_percentage_label, position_on_screen, 100 * monster.health_percentage);

		draw_label(stamina_label, position_on_screen);
		draw_label(stamina_value_label, position_on_screen, monster.stamina, monster.max_stamina);
		draw_label(stamina_percentage_label, position_on_screen, 100 * monster.stamina_percentage);

		i = i + 1;
		::continue::
	end
end
-- #endregion
----------------------SMALL MONSTER UI-----------------------

----------------------LARGE MONSTER UI-----------------------
-- #region
large_monster_data = function()
	if enemy_manager == nil then
		status = "No enemy manager";
		return;
	end

	local displayed_monsters = {};

	local enemy_count = enemy_manager:call("getBossEnemyCount");
	if enemy_count == nil then
		status = "No enemy count";
		return;
	end

	for i = 0, enemy_count - 1 do
		local enemy = enemy_manager:call("getBossEnemy", i);
		if enemy == nil then
			status = "No enemy";
			break
		end

		local monster = large_monsters[enemy];
		if monster == nil then
			status = "No monster hp entry";
			break
		end

		table.insert(displayed_monsters, monster);
	end

	if not config.large_monster_UI.dynamic_positioning.enabled then
		-- sort here

		if config.large_monster_UI.sorting.type == "Normal" and config.large_monster_UI.sorting.reversed_order then
			local reversed_monsters = {};
			for i = #displayed_monsters, 1, -1 do
				table.insert(reversed_monsters, displayed_monsters[i]);
			end
			
			displayed_monsters = reversed_monsters;

		elseif config.large_monster_UI.sorting.type == "Health" then
			if config.large_monster_UI.sorting.reversed_order then
				table.sort(displayed_monsters, function(left, right)
					return left.health > right.health;
				end);
			else
				table.sort(displayed_monsters, function(left, right)
					return left.health < right.health;
				end);
			end
		elseif config.large_monster_UI.sorting.type == "Health Percentage" then
			if config.large_monster_UI.sorting.reversed_order then
				table.sort(displayed_monsters, function(left, right)
					return left.health_percentage > right.health_percentage;
				end);
			else
				table.sort(displayed_monsters, function(left, right)
					return left.health_percentage < right.health_percentage;
				end);
			end
		end
	end

	local i = 0;
	for _, monster in ipairs(displayed_monsters) do
		local position_on_screen;
		
		if config.large_monster_UI.dynamic_positioning.enabled then
			local world_offset = Vector3f.new(config.large_monster_UI.dynamic_positioning.world_offset.x, config.large_monster_UI.dynamic_positioning.world_offset.y, config.large_monster_UI.dynamic_positioning.world_offset.z);

			position_on_screen = draw.world_to_screen(monster.position + world_offset);

			if position_on_screen == nil then
				goto continue
			end

			position_on_screen.x = position_on_screen.x + config.large_monster_UI.dynamic_positioning.viewport_offset.x;
			position_on_screen.y = position_on_screen.y + config.large_monster_UI.dynamic_positioning.viewport_offset.y;
		else
			position_on_screen = calculate_screen_coordinates(config.large_monster_UI.position);
			
			if config.large_monster_UI.settings.orientation == "Horizontal" then
				position_on_screen.x = position_on_screen.x + config.large_monster_UI.spacing.x * i;
			else
				position_on_screen.y = position_on_screen.y + config.large_monster_UI.spacing.y * i;
			end
			
		end

		local monster_name_label = config.large_monster_UI.monster_name_label;

		local health_bar = table_deep_copy(config.large_monster_UI.health.bar);
		local health_label = config.large_monster_UI.health.text_label;
		local health_value_label = config.large_monster_UI.health.value_label;
		local health_percentage_label = config.large_monster_UI.health.percentage_label;

		local stamina_bar = config.large_monster_UI.stamina.bar;
		local stamina_label = config.large_monster_UI.stamina.text_label;
		local stamina_value_label = config.large_monster_UI.stamina.value_label;
		local stamina_percentage_label = config.large_monster_UI.stamina.percentage_label;

		local rage_bar = config.large_monster_UI.rage.bar;
		local rage_label = config.large_monster_UI.rage.text_label;
		local rage_value_label = table_deep_copy(config.large_monster_UI.rage.value_label);
		local rage_percentage_label = table_deep_copy(config.large_monster_UI.rage.percentage_label);

		if monster.health <= monster.capture_health then
			health_bar.colors = health_bar.colors.capture;
		end

		local monster_name_text = "";
		if config.large_monster_UI.monster_name_label.include.monster_name then
			monster_name_text = string.format("%s ", monster.name);
		end

		if config.large_monster_UI.monster_name_label.include.crown and monster.crown ~= "" then
			monster_name_text = monster_name_text .. string.format("%s ", monster.crown);
		end
		if config.large_monster_UI.monster_name_label.include.size then
			monster_name_text = monster_name_text .. string.format("#%.0f ", 100 * monster.size);
		end

		if config.large_monster_UI.monster_name_label.include.scrown_thresholds then
			monster_name_text = monster_name_text ..
				                    string.format("<=%.0f >=%.0f >=%.0f", 100 * monster.small_border,
					100 * monster.big_border, 100 * monster.king_border);
		end

		local rage_bar_percentage = monster.rage_percentage;
		if monster.is_in_rage then
			rage_bar_percentage = monster.rage_timer_percentage;
		end

		if config.large_monster_UI.dynamic_positioning.enabled then
			if config.large_monster_UI.dynamic_positioning.max_distance == 0 then
				return;
			end

			local distance = (myself_player_position - monster.position):length();

			if distance > config.large_monster_UI.dynamic_positioning.max_distance then
				goto continue;
			end

			if config.large_monster_UI.dynamic_positioning.opacity_falloff then
				local opacity_falloff = 1 - (distance / config.large_monster_UI.dynamic_positioning.max_distance);

				monster_name_label = table_deep_copy(config.large_monster_UI.monster_name_label);

				health_label = table_deep_copy(config.large_monster_UI.health.text_label);
				health_value_label = table_deep_copy(config.large_monster_UI.health.value_label);
				health_percentage_label = table_deep_copy(config.large_monster_UI.health.percentage_label);

				stamina_bar = table_deep_copy(config.large_monster_UI.stamina.bar);
				stamina_label = table_deep_copy(config.large_monster_UI.stamina.text_label);
				stamina_value_label = table_deep_copy(config.large_monster_UI.stamina.value_label);
				stamina_percentage_label = table_deep_copy(config.large_monster_UI.stamina.percentage_label);

				rage_bar = table_deep_copy(config.large_monster_UI.rage.bar);
				rage_label = table_deep_copy(config.large_monster_UI.rage.text_label);
		
				scale_label_opacity(monster_name_label, opacity_falloff);

				scale_bar_opacity(health_bar, opacity_falloff);
				scale_label_opacity(health_label, opacity_falloff);
				scale_label_opacity(health_value_label, opacity_falloff);
				scale_label_opacity(health_percentage_label, opacity_falloff);

				scale_bar_opacity(stamina_bar, opacity_falloff);
				scale_label_opacity(stamina_label, opacity_falloff);
				scale_label_opacity(stamina_value_label, opacity_falloff);
				scale_label_opacity(stamina_percentage_label, opacity_falloff);

				scale_bar_opacity(rage_bar, opacity_falloff);
				scale_label_opacity(rage_label, opacity_falloff);
				scale_label_opacity(rage_value_label, opacity_falloff);
				scale_label_opacity(rage_percentage_label, opacity_falloff);
			end
		end

		if monster.is_in_rage then
			rage_value_label.visibility = false;
			rage_percentage_label.text = "%.0f:%04.1f";
		end

		draw_bar(health_bar, position_on_screen, monster.health_percentage);
		draw_bar(stamina_bar, position_on_screen, monster.stamina_percentage);
		draw_bar(rage_bar, position_on_screen, rage_bar_percentage);

		draw_label(monster_name_label, position_on_screen, monster_name_text);

		draw_label(health_label, position_on_screen);
		draw_label(health_value_label, position_on_screen, monster.health, monster.max_health);
		draw_label(health_percentage_label, position_on_screen, 100 * monster.health_percentage);

		draw_label(stamina_label, position_on_screen);
		draw_label(stamina_value_label, position_on_screen, monster.stamina, monster.max_stamina);
		draw_label(stamina_percentage_label, position_on_screen, 100 * monster.stamina_percentage);

		draw_label(rage_label, position_on_screen);
		draw_label(rage_value_label, position_on_screen, monster.rage_point, monster.rage_limit);

		if monster.is_in_rage then
			draw_label(rage_percentage_label, position_on_screen, monster.rage_minutes_left, monster.rage_seconds_left);
		else
			draw_label(rage_percentage_label, position_on_screen, 100 * monster.rage_percentage);
		end

		i = i + 1;
		::continue::
	end
end
-- #endregion
----------------------LARGE MONSTER UI-----------------------

---------------------------TIME UI---------------------------
-- #region
quest_time = function()
	if quest_manager == nil then
		status = "No quest manager";
		return;
	end

	local quest_time_elapsed_minutes = quest_manager:call("getQuestElapsedTimeMin");
	if quest_time_elapsed_minutes == nil then
		status = "No quest time elapsed minutes";
		return;
	end

	local quest_time_total_elapsed_seconds = quest_manager:call("getQuestElapsedTimeSec");
	if quest_time_total_elapsed_seconds == nil then
		status = "No quest time total elapsed seconds";
		return;
	end

	if quest_time_total_elapsed_seconds == 0 then
		return;
	end

	local quest_time_elapsed_seconds = quest_time_total_elapsed_seconds - quest_time_elapsed_minutes * 60;

	local position_on_screen = calculate_screen_coordinates(config.time_UI.position);

	draw_label(config.time_UI.time_label, position_on_screen, quest_time_elapsed_minutes, quest_time_elapsed_seconds);
end
-- #endregion
---------------------------TIME UI---------------------------

-------------------------DAMAGE HOOK-------------------------
-- #region
local enemy_character_base_after_calc_damage_damage_side = enemy_character_base_type_def:get_method(
	"afterCalcDamage_DamageSide");

sdk.hook(enemy_character_base_after_calc_damage_damage_side, function(args)
	local enemy = sdk.to_managed_object(args[2]);
	if enemy == nil then
		return;
	end

	local is_large_monster = enemy:call("get_isBossEnemy");
	if is_large_monster == nil then
		return;
	end

	local dead_or_captured = enemy:call("checkDie");
	if dead_or_captured == nil then
		return;
	end

	if dead_or_captured then
		return;
	end

	local enemy_calc_damage_info = sdk.to_managed_object(args[3]); -- snow.hit.EnemyCalcDamageInfo.AfterCalcInfo_DamageSide
	local attacker_id = enemy_calc_damage_info:call("get_AttackerID");
	local attacker_type = enemy_calc_damage_info:call("get_DamageAttackerType");

	if attacker_id >= 100 then
		return;
	end

	-- 4 is virtual player in singleplayer that 'owns' 2nd otomo
	if not is_quest_online and attacker_id == 4 then
		attacker_id = master_player_id;
	end

	local damage_object = {}
	damage_object.total_damage = enemy_calc_damage_info:call("get_TotalDamage");
	damage_object.physical_damage = enemy_calc_damage_info:call("get_PhysicalDamage");
	damage_object.elemental_damage = enemy_calc_damage_info:call("get_ElementDamage");
	damage_object.ailment_damage = enemy_calc_damage_info:call("get_ConditionDamage");

	-- -1 - bombs
	--  0 - player
	--  9 - kunai
	-- 11 - wyverblast
	-- 12 - ballista
	-- 13 - cannon
	-- 14 - machine cannon
	-- 16 - defender ballista/cannon
	-- 17 - wyvernfire artillery
	-- 18 - dragonator
	-- 19 - otomo
	-- 23 - monster

	local damage_source_type = tostring(attacker_type);
	if attacker_type == 0 then
		damage_source_type = "player";
	elseif attacker_type == 1 then
		damage_source_type = "bomb";
	elseif attacker_type == 9 then
		damage_source_type = "kunai";
	elseif attacker_type == 11 then
		damage_source_type = "wyvernblast";
	elseif attacker_type == 12 or attacker_type == 13 or attacker_type == 14 or attacker_type == 18 then
		damage_source_type = "installation";
	elseif attacker_type == 19 then
		damage_source_type = "otomo";
	elseif attacker_type == 23 then
		damage_source_type = "monster";
	end

	local player = get_player(attacker_id);
	if player == nil then
		return;
	end

	-- x = x.. string.format("[attacker] %d [type] %s [dmg] %d", attacker_id, damage_source_type, damage_object.total_damage);

	update_player_damage(total, damage_source_type, is_large_monster, damage_object);
	update_player_damage(player, damage_source_type, is_large_monster, damage_object);
end, function(retval)
	return retval;
end);

init_player = function(player_id, player_name, player_hunter_rank)
	local player = {};
	player.id = player_id;
	player.name = player_name;
	player.hunter_rank = player_hunter_rank;

	player.small_monsters = {};

	player.small_monsters.total_damage = 0;
	player.small_monsters.physical_damage = 0;
	player.small_monsters.elemental_damage = 0;
	player.small_monsters.ailment_damage = 0;

	player.small_monsters.bombs = {};
	player.small_monsters.bombs.total_damage = 0;
	player.small_monsters.bombs.physical_damage = 0;
	player.small_monsters.bombs.elemental_damage = 0;
	player.small_monsters.bombs.ailment_damage = 0;

	player.small_monsters.kunai = {};
	player.small_monsters.kunai.total_damage = 0;
	player.small_monsters.kunai.physical_damage = 0;
	player.small_monsters.kunai.elemental_damage = 0;
	player.small_monsters.kunai.ailment_damage = 0;

	player.small_monsters.installations = {};
	player.small_monsters.installations.total_damage = 0;
	player.small_monsters.installations.physical_damage = 0;
	player.small_monsters.installations.elemental_damage = 0;
	player.small_monsters.installations.ailment_damage = 0;

	player.small_monsters.otomo = {};
	player.small_monsters.otomo.total_damage = 0;
	player.small_monsters.otomo.physical_damage = 0;
	player.small_monsters.otomo.elemental_damage = 0;
	player.small_monsters.otomo.ailment_damage = 0;

	player.small_monsters.monster = {};
	player.small_monsters.monster.total_damage = 0;
	player.small_monsters.monster.physical_damage = 0;
	player.small_monsters.monster.elemental_damage = 0;
	player.small_monsters.monster.ailment_damage = 0;

	player.large_monsters = {};

	player.large_monsters.total_damage = 0;
	player.large_monsters.physical_damage = 0;
	player.large_monsters.elemental_damage = 0;
	player.large_monsters.ailment_damage = 0;

	player.large_monsters.bombs = {};
	player.large_monsters.bombs.total_damage = 0;
	player.large_monsters.bombs.physical_damage = 0;
	player.large_monsters.bombs.elemental_damage = 0;
	player.large_monsters.bombs.ailment_damage = 0;

	player.large_monsters.kunai = {};
	player.large_monsters.kunai.total_damage = 0;
	player.large_monsters.kunai.physical_damage = 0;
	player.large_monsters.kunai.elemental_damage = 0;
	player.large_monsters.kunai.ailment_damage = 0;

	player.large_monsters.installations = {};
	player.large_monsters.installations.total_damage = 0;
	player.large_monsters.installations.physical_damage = 0;
	player.large_monsters.installations.elemental_damage = 0;
	player.large_monsters.installations.ailment_damage = 0;

	player.large_monsters.otomo = {};
	player.large_monsters.otomo.total_damage = 0;
	player.large_monsters.otomo.physical_damage = 0;
	player.large_monsters.otomo.elemental_damage = 0;
	player.large_monsters.otomo.ailment_damage = 0;

	player.large_monsters.monster = {};
	player.large_monsters.monster.total_damage = 0;
	player.large_monsters.monster.physical_damage = 0;
	player.large_monsters.monster.elemental_damage = 0;
	player.large_monsters.monster.ailment_damage = 0;

	player.display = {};
	player.display.total_damage = 0;
	player.display.physical_damage = 0;
	player.display.elemental_damage = 0;
	player.display.ailment_damage = 0;

	return player;
end

get_player = function(player_id)
	if players[player_id] == nil then
		return nil;
	end

	return players[player_id];
end

update_player_damage = function(player, damage_source_type, is_large_monster, damage_object)
	if player == nil then
		return;
	end

	local player_monster_type = player.small_monsters;
	if is_large_monster then
		player_monster_type = player.large_monsters;
	end

	if damage_source_type == "player" then
		merge_damage(player_monster_type, damage_object);
	elseif damage_source_type == "bomb" then
		merge_damage(player_monster_type.bombs, damage_object);
	elseif damage_source_type == "kunai" then
		merge_damage(player_monster_type.kunai, damage_object);
	elseif damage_source_type == "wyvernblast" then
		merge_damage(player_monster_type, damage_object);
	elseif damage_source_type == "installation" then
		merge_damage(player_monster_type.installations, damage_object);
	elseif damage_source_type == "otomo" then
		merge_damage(player_monster_type.otomo, damage_object);
	elseif damage_source_type == "monster" then
		merge_damage(player_monster_type.monster, damage_object);
	else
		merge_damage(player, damage_object);
	end

	update_player_display(player);
end

update_player_display = function(player)
	if player == nil then
		return;
	end

	player.display.total_damage = 0;
	player.display.physical_damage = 0;
	player.display.elemental_damage = 0;
	player.display.ailment_damage = 0;

	if config.damage_meter_UI.tracked_monster_types.small_monsters then
		if config.damage_meter_UI.tracked_damage_types.player_damage then
			merge_damage(player.display, player.small_monsters);
		end
	
		if config.damage_meter_UI.tracked_damage_types.bomb_damage then
			merge_damage(player.display, player.small_monsters.bombs);
	
		end
	
		if config.damage_meter_UI.tracked_damage_types.kunai_damage then
			merge_damage(player.display, player.small_monsters.kunai);
		end
	
		if config.damage_meter_UI.tracked_damage_types.installation_damage then
			merge_damage(player.display, player.small_monsters.installations);
		end
	
		if config.damage_meter_UI.tracked_damage_types.otomo_damage then
			merge_damage(player.display, player.small_monsters.otomo);
		end
	
		if config.damage_meter_UI.tracked_damage_types.monster_damage then
			merge_damage(player.display, player.small_monsters.monster);
		end
	end

	if config.damage_meter_UI.tracked_monster_types.large_monsters then
		if config.damage_meter_UI.tracked_damage_types.player_damage then
			merge_damage(player.display, player.large_monsters);
		end
	
		if config.damage_meter_UI.tracked_damage_types.bomb_damage then
			merge_damage(player.display, player.large_monsters.bombs);
	
		end
	
		if config.damage_meter_UI.tracked_damage_types.kunai_damage then
			merge_damage(player.display, player.large_monsters.kunai);
		end
	
		if config.damage_meter_UI.tracked_damage_types.installation_damage then
			merge_damage(player.display, player.large_monsters.installations);
		end
	
		if config.damage_meter_UI.tracked_damage_types.otomo_damage then
			merge_damage(player.display, player.large_monsters.otomo);
		end
	
		if config.damage_meter_UI.tracked_damage_types.monster_damage then
			merge_damage(player.display, player.large_monsters.monster);
		end
	end
end

merge_damage = function(first, second)
	first.total_damage = first.total_damage + second.total_damage;
	first.physical_damage = first.physical_damage + second.physical_damage;
	first.elemental_damage = first.elemental_damage + second.elemental_damage;
	first.ailment_damage = first.ailment_damage + second.ailment_damage;
end
-- #endregion
-------------------------DAMAGE HOOK-------------------------

-----------------------DAMAGE METER UI-----------------------
-- #region
damage_meter = function()
	if total.display.total_damage == 0 and config.damage_meter_UI.settings.hide_module_if_total_damage_is_zero then
		return;
	end

	if lobby_manager == nil then
		status = "No lobby manager";
		return;
	end

	if progress_manager == nil then
		status = "No progress manager";
		return;
	end

	is_quest_online = lobby_manager:call("IsQuestOnline");
	if is_quest_online == nil then
		is_quest_online = false;
	end

	-- myself player
	local myself_player_info = lobby_manager:get_field("_myHunterInfo");
	if myself_player_info == nil then
		status = "No myself player info list";
		return;
	end

	local myself_player_name = myself_player_info:get_field("_name");
	if myself_player_name == nil then
		status = "No myself player name";
		return;
	end

	master_player_id = 0;
	if is_quest_online then
		master_player_id = lobby_manager:get_field("_myselfQuestIndex");
		if master_player_id == nil then
			status = "No myself player id";
			return;
		end
	else
		master_player_id = lobby_manager:get_field("_myselfIndex");
		if master_player_id == nil then
			status = "No myself player id";
			return;
		end
	end

	local myself_hunter_rank = progress_manager:call("get_HunterRank");
	if myself_hunter_rank == nil then
		status = "No myself hunter rank";
		myself_hunter_rank = 0;
	end

	if players[master_player_id] == nil then
		players[master_player_id] = init_player(master_player_id, myself_player_name, myself_hunter_rank);
	end
	local quest_players = {};

	if quest_status > 2 then
		quest_players = last_displayed_players;
	else
		-- other players
		local player_info_list = lobby_manager:get_field("_questHunterInfo");
		if player_info_list == nil then
			status = "No player info list";
		end

		local count = player_info_list:call("get_Count");
		if count == nil then
			status = "No player info list count";
			return;
		end

		for i = 0, count - 1 do
			local player_info = player_info_list:call("get_Item", i);
			if player_info == nil then

				goto continue
			end

			local player_id = player_info:get_field("_memberIndex");
			if player_id == nil then

				goto continue
			end

			local player_hunter_rank = player_info:get_field("_hunterRank");
			if player_hunter_rank == nil then
				goto continue
			end

			if player_id == master_player_id and config.damage_meter_UI.settings.my_damage_bar_location ~= "Normal" then
				players[master_player_id].hunter_rank = player_hunter_rank;
				goto continue
			end

			local player_name = player_info:get_field("_name");
			if player_name == nil then
				goto continue
			end

			if players[player_id] == nil then
				players[player_id] = init_player(player_id, player_name, player_hunter_rank);
			elseif players[player_id].name ~= player_name then
				players[player_id] = init_player(player_id, player_name, player_hunter_rank);
			end

			table.insert(quest_players, players[player_id]);

			::continue::
		end

		-- sort here
		if config.damage_meter_UI.sorting.type == "Normal" and config.damage_meter_UI.sorting.reversed_order then

			local reversed_quest_players = {};
			for i = #quest_players, 1, -1 do
				table.insert(reversed_quest_players, quest_players[i]);
			end
			quest_players = reversed_quest_players;
		elseif config.damage_meter_UI.sorting.type == "Damage" then
			if config.damage_meter_UI.sorting.reversed_order then
				table.sort(quest_players, function(left, right)
					return left.display.total_damage < right.display.total_damage;
				end);
			else
				table.sort(quest_players, function(left, right)
					return left.display.total_damage > right.display.total_damage;
				end);
			end
		end

		if config.damage_meter_UI.settings.my_damage_bar_location == "First" then
			table.insert(quest_players, 1, players[master_player_id]);
		elseif config.damage_meter_UI.settings.my_damage_bar_location == "Last" then
			table.insert(quest_players, #quest_players + 1, players[master_player_id]);
		elseif #quest_players == 0 then
			table.insert(quest_players, 1, players[master_player_id]);
		end

		last_displayed_players = quest_players;
	end

	local top_damage = 0;
	for _, player in ipairs(quest_players) do
		if player.display.total_damage > top_damage then
			top_damage = player.display.total_damage;
		end
	end

	-- draw
	local position_on_screen = calculate_screen_coordinates(config.damage_meter_UI.position);
	for _, player in ipairs(quest_players) do

		if player.display.total_damage == 0 and config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero then
			goto continue1
		end

		local player_damage_percentage = 0;
		if total.display.total_damage ~= 0 then
			player_damage_percentage = player.display.total_damage / total.display.total_damage;
		end

		local player_damage_bar_percentage = 0;
		if config.damage_meter_UI.settings.damage_bar_relative_to == "Total Damage" then
			if total.display.total_damage ~= 0 then
				player_damage_bar_percentage = player.display.total_damage / total.display.total_damage;
			end
		else
			if top_damage ~= 0 then
				player_damage_bar_percentage = player.display.total_damage / top_damage;
			end
		end
		
		if player.id == master_player_id and config.damage_meter_UI.settings.highlighted_bar == "Me" then
			draw_bar(config.damage_meter_UI.highlighted_damage_bar, position_on_screen, player_damage_bar_percentage);
		elseif config.damage_meter_UI.settings.highlighted_bar == "Top Damage" and player.display.total_damage == top_damage then
			draw_bar(config.damage_meter_UI.highlighted_damage_bar, position_on_screen, player_damage_bar_percentage);
		else
			draw_bar(config.damage_meter_UI.damage_bar, position_on_screen, player_damage_bar_percentage);
		end

		local player_name_text = "";
		local player_include = config.damage_meter_UI.player_name_label.include.others;
		if player.id == master_player_id then
			player_include = config.damage_meter_UI.player_name_label.include.myself;
		end

		if player_include.hunter_rank then
			player_name_text = string.format("[%d] ", player.hunter_rank);
		end

		if player_include.word_player then
			player_name_text = player_name_text .. "Player ";
		end

		if player_include.player_id then
			player_name_text = player_name_text .. string.format("%d ", player.id);
		end

		if player_include.player_name then
			player_name_text = player_name_text .. player.name;
		end

		draw_label(config.damage_meter_UI.player_name_label, position_on_screen, player_name_text);
		draw_label(config.damage_meter_UI.damage_value_label, position_on_screen, player.display.total_damage);
		draw_label(config.damage_meter_UI.damage_percentage_label, position_on_screen, 100 * player_damage_percentage);

		if config.damage_meter_UI.settings.orientation == "Horizontal" then
			position_on_screen.x = position_on_screen.x + config.damage_meter_UI.spacing.x;
		else
			position_on_screen.y = position_on_screen.y + config.damage_meter_UI.spacing.y;
		end

		::continue1::

	end

	-- draw total damage
	if not config.damage_meter_UI.settings.total_damage_offset_is_relative then
		position_on_screen = calculate_screen_coordinates(config.damage_meter_UI.position);
	end

	draw_label(config.damage_meter_UI.total_damage_label, position_on_screen);
	draw_label(config.damage_meter_UI.total_damage_value_label, position_on_screen, total.display.total_damage);

end
-- #endregion
-----------------------DAMAGE METER UI-----------------------
-- #region
if not init() then
	return;
end
-- #endregion
