--------------------CUSTOMIZATION SECTION--------------------
--#region
local config = {
	font = {
		family = "Consolas",
		size = 13,
		bold = true,
		italic = false
	},

	monster_UI = {
		enabled = true,
	
		settings =  {
			spacing = 220,
			orientation = "Horizontal"
		},

		sorting = {
			type = "Normal",
			reversed_order = false,
		},
		
		position = {
			x = 525,
			y = 44,
			anchor = "Bottom-Left"
		},
	
		monster_name_label = {
			visibility = true,
			text = "%s",

			include = {
				monster_name = true,
				crown = true,
				size = true,
				silver_crown_threshold = false,
				gold_crown_threshold = false
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
	
		health_label = {
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
	
		health_value_label = {
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
	
		health_percentage_label = {
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
	
		health_bar = {
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
				foreground = 0xB974A652,
				background = 0xB9000000,
				capture_health = 0xB9CCCC33
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
			monster_damage = true
		}, -- note that installations during narwa fight are counted as monster damage
	
		settings = {
			spacing = 24,
			orientation = "Vertical", -- "Vertical" or "Horizontal"

			hide_module_if_total_damage_is_zero = false,
			hide_player_if_player_damage_is_zero = false,
			total_damage_offset_is_relative = true,

			highlighted_bar = "Me",
			damage_bar_relative_to = "Top Damage", -- "total damage" or "top damage"
			my_damage_bar_location = "First", --"normal" or "first" or "last"
		},
		
		sorting = {
			type = "Damage", -- "normal" or "damage"
			reversed_order = false,
		},
		
		position = {
			x = 525,
			y = 225,
			--Possible values: "Top-Left", "Top-Right", "Bottom-Left", "Bottom-Right"
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
				background = 0xB9000000
			},
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
				background = 0xB9000000
			},
		}
	}
};
--#endregion
----------------------CUSTOMIZATION END----------------------





--------------------FUNCTION DEFINITIONS---------------------
--#region
local init;
local init_singletons;
local init_scene_manager;
local init_message_manager;
local init_enemy_manager;
local init_lobby_manager;
local init_progress_manager;
local init_quest_manager;

local customization_ui;

local save_config;
local load_config;

local get_window_size;
local calculate_screen_coordinates;
local table_find_index;

local draw_label;
local draw_bar;

local update_monster;
local monster_health;

local quest_time;


local init_player;
local merge_damage;
local get_player;
local update_player;
local damage_meter;
--#endregion
--------------------FUNCTION DEFINITIONS---------------------





--------------------VARIABLE DEFINITIONS---------------------
--#region
local config_file_name;

local font;
local fonts = {};
local selected_font_index;

local is_customization_window_opened;

local status;
local x;

local screen_width;
local screen_height;
local scene_view;

local quest_status;

local large_monsters;
local small_monsters;
local players;
local total;
local is_quest_online;
local last_displayed_players;
local myself_player_id;

--Singletons
local scene_manager;
local message_manager;
local enemy_manager;
local lobby_manager;
local progress_manager;
local quest_manager;
--#endregion
--------------------VARIABLE DEFINITIONS---------------------





----------------------CONFIG LOAD/SAVE-----------------------
--#region
load_config = function()
	local loaded_config = json.load_file(config_file_name);
	if loaded_config ~= nil then
		log.info('[MHR Overlay] config.json loaded successfully');
		config = loaded_config;
	end
end

save_config = function ()
	-- save current config to disk, replacing any existing file
	local success = json.dump_file(config_file_name, config);
	if success then
		log.info('[MHR Overlay] config.json saved successfully');
	else
		log.error('[MHR Overlay] Failed to save config.json');
	end
end
--#endregion
----------------------CONFIG LOAD/SAVE-----------------------





----------------------------INIT-----------------------------
--#region
config_file_name = 'MHR Overlay/config.json';
load_config();

init = function()
	init_singletons();

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

	screen_width = 0;
	screen_height = 0;
	if scene_manager ~= nil then
		scene_view = sdk.call_native_func(scene_manager, sdk.find_type_definition("via.SceneManager"), "get_MainView");

		if scene_view == nil then
			log.error("[MHR Overlay] No main view");
			return false;
		else
			get_window_size();
		end
	end

	large_monsters = {};
	small_monsters = {};

	players = {};
	total = init_player(0, "Total", 0);
	is_quest_online = false;
	last_displayed_players = {};
	myself_player_id = 0;

	log.info("[MHR Overlay] loaded");

	orientation_types = {"Horizontal", "Vertical"};

	monster_UI_orientation_index = table_find_index(orientation_types, config.monster_UI.settings.orientation, false);

	monster_UI_sort_types = {"Normal", "Health", "Health Percentage", "Distance"};
	monster_UI_sort_type_index = table_find_index(monster_UI_sort_types, config.monster_UI.sorting.type, false);

	damage_meter_UI_orientation_index = table_find_index(orientation_types, config.damage_meter_UI.settings.orientation, false);

	damage_meter_UI_highlighted_bar_types = {"Me", "Top Damage", "None"};
	damage_meter_UI_highlighted_bar_index = table_find_index(damage_meter_UI_highlighted_bar_types, config.damage_meter_UI.settings.highlighted_bar, false);

	damage_meter_UI_damage_bar_relative_types = {"Total Damage", "Top Damage"};
	damage_meter_UI_damage_bar_relative_index = table_find_index(damage_meter_UI_damage_bar_relative_types, config.damage_meter_UI.settings.damage_bar_relative_to, false);

	damage_meter_UI_my_damage_bar_location_types = {"Normal", "First", "Last"};
	damage_meter_UI_my_damage_bar_location_index = table_find_index(damage_meter_UI_my_damage_bar_location_types, config.damage_meter_UI.settings.my_damage_bar_location, false);

	damage_meter_UI_sort_types = {"Normal", "Damage"};
	damage_meter_UI_sort_type_index = table_find_index(damage_meter_UI_sort_types, config.damage_meter_UI.sorting.type, false);

	is_customization_window_opened = false;

	fonts = {"Arial", "Arial Black", "Bahnschrift", "Calibri", "Cambria", "Cambria Math", "Candara", "Comic Sans MS", "Consolas", "Constantia", "Corbel", "Courier New", "Ebrima", "Franklin Gothic Medium", "Gabriola", "Gadugi", "Georgia", "HoloLens MDL2 Assets", "Impact", "Ink Free", "Javanese Text", "Leelawadee UI", "Lucida Console", "Lucida Sans Unicode", "Malgun Gothic", "Marlett", "Microsoft Himalaya", "Microsoft JhengHei", "Microsoft New Tai Lue", "Microsoft PhagsPa", "Microsoft Sans Serif", "Microsoft Tai Le", "Microsoft YaHei", "Microsoft Yi Baiti", "MingLiU-ExtB", "Mongolian Baiti", "MS Gothic", "MV Boli", "Myanmar Text", "Nirmala UI", "Palatino Linotype", "Segoe MDL2 Assets", "Segoe Print", "Segoe Script", "Segoe UI", "Segoe UI Historic", "Segoe UI Emoji", "Segoe UI Symbol", "SimSun", "Sitka", "Sylfaen", "Symbol", "Tahoma", "Times New Roman", "Trebuchet MS", "Verdana", "Webdings", "Wingdings", "Yu Gothic"};
	selected_font_index = table_find_index(fonts, config.font.family, false);

	return true;
end

init_singletons = function()
	init_scene_manager();
	init_message_manager();
	init_enemy_manager();
	init_lobby_manager()
	init_progress_manager();
	init_quest_manager();
end

init_scene_manager = function()
	if scene_manager ~= nil then
		return;
	end
		
	scene_manager = sdk.get_native_singleton("via.SceneManager");
	if scene_manager == nil then
		log.error("[MHR Overlay] No scene manager");
	end
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
--#endregion
----------------------------INIT-----------------------------





--------------------------D2D---------------------------
d2d.register(function()
    font = d2d.create_font(config.font.family, config.font.size, config.font.bold, config.font.italic);
end,
function()
	status = "OK";
	get_window_size();
	init_singletons();

	if config.monster_UI.enabled then
		monster_health();
	end

	if config.time_UI.enabled then
		quest_time();
	end

	if config.damage_meter_UI.enabled then
		damage_meter();
	end
end)
--------------------------D2D---------------------------



----------------------CUSTOMIZATION UI-----------------------
--#region
customization_ui = function()
	is_customization_window_opened = imgui.begin_window("MHR Overlay", is_customization_window_opened, 0x10120);

	if not is_customization_window_opened then
		return;
	end
	
	local config_changed = false;
	local changed;
	local status_string = tostring(status);
	imgui.text("Status: " .. status_string);

	if imgui.tree_node("Font") then
		imgui.text("Any changes to the font require script reload!");

		changed, selected_font_index = imgui.combo("Family", selected_font_index, fonts);
		config_changed = config_changed or changed;
		if changed then
			config.font.family = fonts[selected_font_index];
		end

		changed, config.font.size = imgui.slider_int("Size", config.font.size, 1, 100);
		config_changed = config_changed or changed;
		
		changed, config.font.bold = imgui.checkbox("Bold", config.font.bold);
		config_changed = config_changed or changed;
		
		changed, config.font.italic = imgui.checkbox("Italic", config.font.italic);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	if imgui.tree_node("Modules") then
		changed, config.monster_UI.enabled = imgui.checkbox("Monster UI", config.monster_UI.enabled);
		config_changed = config_changed or changed;
		imgui.same_line();

		changed, config.time_UI.enabled = imgui.checkbox("Time UI", config.time_UI.enabled);
		config_changed = config_changed or changed;
		imgui.same_line();
		
		changed, config.damage_meter_UI.enabled = imgui.checkbox("Damage Meter UI", config.damage_meter_UI.enabled);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	if imgui.tree_node("Monster UI") then
		changed, config.monster_UI.enabled = imgui.checkbox("Enabled", config.monster_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node("Settings") then
			changed, config.monster_UI.settings.spacing = imgui.drag_float("Spacing", config.monster_UI.settings.spacing, 0.1, 0, screen_width, "%.1f");
			config_changed = config_changed or changed;

			changed, monster_UI_orientation_index = imgui.combo("Orientation", monster_UI_orientation_index, orientation_types);
			config_changed = config_changed or changed;
			if changed then
				config.monster_UI.settings.orientation = orientation_types[monster_UI_orientation_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Position") then
			changed, config.monster_UI.position.x = imgui.drag_float("X", config.monster_UI.position.x, 0.1, 0, screen_width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.monster_UI.position.y = imgui.drag_float("Y", config.monster_UI.position.y, 0.1, 0, screen_height, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end
		
		if imgui.tree_node("Sorting") then
			changed, monster_UI_sort_type_index = imgui.combo("Type", monster_UI_sort_type_index, monster_UI_sort_types);
			config_changed = config_changed or changed;
			if changed then
				config.monster_UI.sorting.type = monster_UI_sort_types[monster_UI_sort_type_index];
			end
					
			changed, config.monster_UI.reversed_order = imgui.checkbox("Reversed Order", config.monster_UI.reversed_order);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Monster Name Label") then
			changed, config.monster_UI.monster_name_label.visibility = imgui.checkbox("Visible", config.monster_UI.monster_name_label.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Include") then
				changed, config.monster_UI.monster_name_label.include.monster_name = imgui.checkbox("Monster Name", config.monster_UI.monster_name_label.include.monster_name);
				config_changed = config_changed or changed;

				changed, config.monster_UI.monster_name_label.include.crown = imgui.checkbox("Crown", config.monster_UI.monster_name_label.include.crown);
				config_changed = config_changed or changed;

				changed, config.monster_UI.monster_name_label.include.size = imgui.checkbox("Size", config.monster_UI.monster_name_label.include.size);
				config_changed = config_changed or changed;

				changed, config.monster_UI.monster_name_label.include.silver_crown_threshold = imgui.checkbox("Silver Crown Threshold", config.monster_UI.monster_name_label.include.silver_crown_threshold);
				config_changed = config_changed or changed;

				changed, config.monster_UI.monster_name_label.include.gold_crown_threshold = imgui.checkbox("Gold Crown Threshold", config.monster_UI.monster_name_label.include.gold_crown_threshold);
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			if imgui.tree_node("Offset") then
				changed, config.monster_UI.monster_name_label.offset.x = imgui.drag_float("X", config.monster_UI.monster_name_label.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.monster_UI.monster_name_label.offset.y = imgui.drag_float("Y", config.monster_UI.monster_name_label.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			--color picker?

			if imgui.tree_node("Shadow") then
				changed, config.monster_UI.monster_name_label.shadow.visibility = imgui.checkbox("Enable", config.monster_UI.monster_name_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.monster_UI.monster_name_label.shadow.offset.x = imgui.drag_float("X", config.monster_UI.monster_name_label.shadow.offset.x, 0.1, -screen_width, screen_width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.monster_UI.monster_name_label.shadow.offset.y = imgui.drag_float("Y", config.monster_UI.monster_name_label.shadow.offset.y, 0.1, -screen_height, screen_height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				--color picker
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Health Label") then
			changed, config.monster_UI.health_label.visibility = imgui.checkbox("Visible", config.monster_UI.health_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.monster_UI.health_label.offset.x = imgui.drag_float("X", config.monster_UI.health_label.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.monster_UI.health_label.offset.y = imgui.drag_float("Y", config.monster_UI.health_label.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			--color picker?

			if imgui.tree_node("Shadow") then
				changed, config.monster_UI.health_label.shadow.visibility = imgui.checkbox("Enable", config.monster_UI.health_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.monster_UI.health_label.shadow.offset.x = imgui.drag_float("X", config.monster_UI.health_label.shadow.offset.x, 0.1, -screen_width, screen_width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.monster_UI.health_label.shadow.offset.y = imgui.drag_float("Y", config.monster_UI.health_label.shadow.offset.y, 0.1, -screen_width, screen_width, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Health Value Label") then
			changed, config.monster_UI.health_value_label.visibility = imgui.checkbox("Visible", config.monster_UI.health_value_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.monster_UI.health_value_label.offset.x = imgui.drag_float("X", config.monster_UI.health_value_label.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.monster_UI.health_value_label.offset.y = imgui.drag_float("Y", config.monster_UI.health_value_label.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			--color picker?

			if imgui.tree_node("Shadow") then
				changed, config.monster_UI.health_value_label.shadow.visibility = imgui.checkbox("Enable", config.monster_UI.health_value_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.monster_UI.health_value_label.shadow.offset.x = imgui.drag_float("X", config.monster_UI.health_value_label.shadow.offset.x, 0.1, -screen_width, screen_width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.monster_UI.health_value_label.shadow.offset.y = imgui.drag_float("Y", config.monster_UI.health_value_label.shadow.offset.y, 0.1, -screen_height, screen_height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Health Percentage Label") then
			changed, config.monster_UI.health_percentage_label.visibility = imgui.checkbox("Visible", config.monster_UI.health_percentage_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.monster_UI.health_percentage_label.offset.x = imgui.drag_float("X", config.monster_UI.health_percentage_label.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.monster_UI.health_percentage_label.offset.y = imgui.drag_float("Y", config.monster_UI.health_percentage_label.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			--color picker?

			if imgui.tree_node("Shadow") then
				changed, config.monster_UI.health_percentage_label.shadow.visibility = imgui.checkbox("Enable", config.monster_UI.health_percentage_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.monster_UI.health_percentage_label.shadow.offset.x = imgui.drag_float("X", config.monster_UI.health_percentage_label.shadow.offset.x, 0.1, -screen_width, screen_width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.monster_UI.health_percentage_label.shadow.offset.y = imgui.drag_float("Y", config.monster_UI.health_percentage_label.shadow.offset.y, 0.1, -screen_height, screen_height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Health Bar") then
			changed, config.monster_UI.health_bar.visibility = imgui.checkbox("Visible", config.monster_UI.health_bar.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Offset") then
				changed, config.monster_UI.health_bar.offset.x = imgui.drag_float("X", config.monster_UI.health_bar.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.monster_UI.health_bar.offset.y = imgui.drag_float("Y", config.monster_UI.health_bar.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			if imgui.tree_node("Size") then
				changed, config.monster_UI.health_bar.size.width = imgui.drag_float("Width", config.monster_UI.health_bar.size.width, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.monster_UI.health_bar.size.height = imgui.drag_float("Height", config.monster_UI.health_bar.size.height, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			if imgui.tree_node("Colors") then
				-- color pickers?
	
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
			changed, config.time_UI.position.x = imgui.drag_float("X", config.time_UI.position.x, 0.1, 0, screen_width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.time_UI.position.y = imgui.drag_float("Y", config.time_UI.position.y, 0.1, 0, screen_height, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end


		if imgui.tree_node("Time Label") then
			changed, config.time_UI.time_label.visibility = imgui.checkbox("Visible", config.time_UI.time_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.time_UI.time_label.offset.x = imgui.drag_float("X", config.time_UI.time_label.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.time_UI.time_label.offset.y = imgui.drag_float("Y", config.time_UI.time_label.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			--color picker?

			if imgui.tree_node("Shadow") then
				changed, config.time_UI.time_label.shadow.visibility = imgui.checkbox("Enable", config.time_UI.time_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.time_UI.time_label.shadow.offset.x = imgui.drag_float("X", config.time_UI.time_label.shadow.offset.x, 0.1, -screen_width, screen_width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.time_UI.time_label.shadow.offset.y = imgui.drag_float("Y", config.time_UI.time_label.shadow.offset.y, 0.1, -screen_width, screen_width, "%.1f");
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
			changed, config.damage_meter_UI.settings.hide_module_if_total_damage_is_zero = imgui.checkbox("Hide Module if Total Damage is 0", config.damage_meter_UI.settings.hide_module_if_total_damage_is_zero);
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero = imgui.checkbox("Hide Player if Player Damage is 0", config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero);
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.settings.total_damage_offset_is_relative = imgui.checkbox("Total Damage Offset is Relative", config.damage_meter_UI.settings.total_damage_offset_is_relative);
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.settings.spacing = imgui.drag_float("Spacing", config.damage_meter_UI.settings.spacing, 0.1, 0, screen_width, "%.1f");
			config_changed = config_changed or changed;

			changed, damage_meter_UI_orientation_index = imgui.combo("Orientation", damage_meter_UI_orientation_index, orientation_types);
			config_changed = config_changed or changed;
			if changed then
				config.damage_meter_UI.settings.orientation = orientation_types[damage_meter_UI_orientation_index];
			end

			changed, damage_meter_UI_highlighted_bar_index = imgui.combo("Highlighted Bar", damage_meter_UI_highlighted_bar_index, damage_meter_UI_highlighted_bar_types);
			config_changed = config_changed or changed;
			if changed then
				config.damage_meter_UI.settings.highlighted_bar = damage_meter_UI_highlighted_bar_types[damage_meter_UI_highlighted_bar_index];
			end

			changed, damage_meter_UI_damage_bar_relative_index = imgui.combo("Damage Bars are Relative to", damage_meter_UI_damage_bar_relative_index, damage_meter_UI_damage_bar_relative_types);
			config_changed = config_changed or changed;
			if changed then
				config.damage_meter_UI.settings.damage_bar_relative_to = damage_meter_UI_damage_bar_relative_types[damage_meter_UI_damage_bar_relative_index];
			end

			changed, damage_meter_UI_my_damage_bar_location_index = imgui.combo("My Damage Bar Location", damage_meter_UI_my_damage_bar_location_index, damage_meter_UI_my_damage_bar_location_types);
			config_changed = config_changed or changed;
			if changed then
				config.damage_meter_UI.settings.my_damage_bar_location = damage_meter_UI_my_damage_bar_location_types[damage_meter_UI_my_damage_bar_location_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Tracked Monster Types") then
			changed, config.damage_meter_UI.tracked_monster_types.small_monsters = imgui.checkbox("Small Monsters", config.damage_meter_UI.tracked_monster_types.small_monsters);
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.tracked_monster_types.large_monsters = imgui.checkbox("Large Monsters", config.damage_meter_UI.tracked_monster_types.large_monsters);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Tracked Damage Types") then
			changed, config.damage_meter_UI.tracked_damage_types.player_damage = imgui.checkbox("Player Damage", config.damage_meter_UI.tracked_damage_types.player_damage);
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.tracked_damage_types.bomb_damage = imgui.checkbox("Bomb Damage", config.damage_meter_UI.tracked_damage_types.bomb_damage);
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.tracked_damage_types.kunai_damage = imgui.checkbox("Kunai Damage", config.damage_meter_UI.tracked_damage_types.kunai_damage);
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.tracked_damage_types.installation_damage = imgui.checkbox("Installation Damage", config.damage_meter_UI.tracked_damage_types.installation_damage);
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.tracked_damage_types.otomo_damage = imgui.checkbox("Otomo Damage", config.damage_meter_UI.tracked_damage_types.otomo_damage);
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.tracked_damage_types.monster_damage = imgui.checkbox("Monster Damage", config.damage_meter_UI.tracked_damage_types.monster_damage);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Position") then
			changed, config.damage_meter_UI.position.x = imgui.drag_float("X", config.damage_meter_UI.position.x, 0.1, 0, screen_width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.damage_meter_UI.position.y = imgui.drag_float("Y", config.damage_meter_UI.position.y, 0.1, 0, screen_height, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end
		
		if imgui.tree_node("Sorting") then
			changed, damage_meter_UI_sort_type_index = imgui.combo("Type", damage_meter_UI_sort_type_index, damage_meter_UI_sort_types);
			config_changed = config_changed or changed;
			if changed then
				config.damage_meter_UI.sorting.type = damage_meter_UI_sort_types[damage_meter_UI_sort_type_index];
			end
					
			changed, config.damage_meter_UI.reversed_order = imgui.checkbox("Reversed Order", config.damage_meter_UI.reversed_order);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Player Name Label") then
			changed, config.damage_meter_UI.player_name_label.visibility = imgui.checkbox("Visible", config.damage_meter_UI.player_name_label.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Include") then
				if imgui.tree_node("Me") then
					changed, config.damage_meter_UI.player_name_label.include.myself.hunter_rank = imgui.checkbox("Hunter Rank", config.damage_meter_UI.player_name_label.include.myself.hunter_rank);
					config_changed = config_changed or changed;
	
					changed, config.damage_meter_UI.player_name_label.include.myself.word_player = imgui.checkbox("Word \"Player\"", config.damage_meter_UI.player_name_label.include.myself.word_player);
					config_changed = config_changed or changed;
	
					changed, config.damage_meter_UI.player_name_label.include.myself.player_id = imgui.checkbox("Player ID", config.damage_meter_UI.player_name_label.include.myself.player_id);
					config_changed = config_changed or changed;
		
					changed, config.damage_meter_UI.player_name_label.include.myself.player_name = imgui.checkbox("Player Name", config.damage_meter_UI.player_name_label.include.myself.player_name);
					config_changed = config_changed or changed;
		
					imgui.tree_pop();
				end

				if imgui.tree_node("Other Players") then
					changed, config.damage_meter_UI.player_name_label.include.others.hunter_rank = imgui.checkbox("Hunter Rank", config.damage_meter_UI.player_name_label.include.others.hunter_rank);
					config_changed = config_changed or changed;
	
					changed, config.damage_meter_UI.player_name_label.include.others.word_player = imgui.checkbox("Word \"Player\"", config.damage_meter_UI.player_name_label.include.others.word_player);
					config_changed = config_changed or changed;
	
					changed, config.damage_meter_UI.player_name_label.include.others.player_id = imgui.checkbox("Player ID", config.damage_meter_UI.player_name_label.include.others.player_id);
					config_changed = config_changed or changed;
		
					changed, config.damage_meter_UI.player_name_label.include.others.player_name = imgui.checkbox("Player Name", config.damage_meter_UI.player_name_label.include.others.player_name);
					config_changed = config_changed or changed;
		
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

		

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.player_name_label.offset.x = imgui.drag_float("X", config.damage_meter_UI.player_name_label.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.player_name_label.offset.y = imgui.drag_float("Y", config.damage_meter_UI.player_name_label.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			--color picker?

			if imgui.tree_node("Shadow") then
				changed, config.damage_meter_UI.player_name_label.shadow.visibility = imgui.checkbox("Enable", config.damage_meter_UI.player_name_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.damage_meter_UI.player_name_label.shadow.offset.x = imgui.drag_float("X", config.damage_meter_UI.player_name_label.shadow.offset.x, 0.1, -screen_width, screen_width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.player_name_label.shadow.offset.y = imgui.drag_float("Y", config.damage_meter_UI.player_name_label.shadow.offset.y, 0.1, -screen_height, screen_height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				--color picker
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Damage Value Label") then
			changed, config.damage_meter_UI.damage_value_label.visibility = imgui.checkbox("Visible", config.damage_meter_UI.damage_value_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.damage_value_label.offset.x = imgui.drag_float("X", config.damage_meter_UI.damage_value_label.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.damage_value_label.offset.y = imgui.drag_float("Y", config.damage_meter_UI.damage_value_label.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			--color picker?

			if imgui.tree_node("Shadow") then
				changed, config.damage_meter_UI.damage_value_label.shadow.visibility = imgui.checkbox("Enable", config.damage_meter_UI.damage_value_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.damage_meter_UI.damage_value_label.shadow.offset.x = imgui.drag_float("X", config.damage_meter_UI.damage_value_label.shadow.offset.x, 0.1, -screen_width, screen_width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.damage_value_label.shadow.offset.y = imgui.drag_float("Y", config.damage_meter_UI.damage_value_label.shadow.offset.y, 0.1, -screen_width, screen_width, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Damage Percentage Label") then
			changed, config.damage_meter_UI.damage_percentage_label.visibility = imgui.checkbox("Visible", config.damage_meter_UI.damage_percentage_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.damage_percentage_label.offset.x = imgui.drag_float("X", config.damage_meter_UI.damage_percentage_label.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.damage_percentage_label.offset.y = imgui.drag_float("Y", config.damage_meter_UI.damage_percentage_label.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			--color picker?

			if imgui.tree_node("Shadow") then
				changed, config.damage_meter_UI.damage_percentage_label.shadow.visibility = imgui.checkbox("Enable", config.damage_meter_UI.damage_percentage_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.damage_meter_UI.damage_percentage_label.shadow.offset.x = imgui.drag_float("X", config.damage_meter_UI.damage_percentage_label.shadow.offset.x, 0.1, -screen_width, screen_width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.damage_percentage_label.shadow.offset.y = imgui.drag_float("Y", config.damage_meter_UI.damage_percentage_label.shadow.offset.y, 0.1, -screen_height, screen_height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Total Damage Label") then
			changed, config.damage_meter_UI.total_damage_label.visibility = imgui.checkbox("Visible", config.damage_meter_UI.total_damage_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.total_damage_label.offset.x = imgui.drag_float("X", config.damage_meter_UI.total_damage_label.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.total_damage_label.offset.y = imgui.drag_float("Y", config.damage_meter_UI.total_damage_label.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			--color picker?

			if imgui.tree_node("Shadow") then
				changed, config.damage_meter_UI.total_damage_label.shadow.visibility = imgui.checkbox("Enable", config.damage_meter_UI.total_damage_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.damage_meter_UI.total_damage_label.shadow.offset.x = imgui.drag_float("X", config.damage_meter_UI.total_damage_label.shadow.offset.x, 0.1, -screen_width, screen_width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.total_damage_label.shadow.offset.y = imgui.drag_float("Y", config.damage_meter_UI.total_damage_label.shadow.offset.y, 0.1, -screen_height, screen_height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Total Damage Value Label") then
			changed, config.damage_meter_UI.total_damage_value_label.visibility = imgui.checkbox("Visible", config.damage_meter_UI.total_damage_value_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.total_damage_value_label.offset.x = imgui.drag_float("X", config.damage_meter_UI.total_damage_value_label.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.total_damage_value_label.offset.y = imgui.drag_float("Y", config.damage_meter_UI.total_damage_value_label.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			--color picker?

			if imgui.tree_node("Shadow") then
				changed, config.damage_meter_UI.total_damage_value_label.shadow.visibility = imgui.checkbox("Enable", config.damage_meter_UI.total_damage_value_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.damage_meter_UI.total_damage_value_label.shadow.offset.x = imgui.drag_float("X", config.damage_meter_UI.total_damage_value_label.shadow.offset.x, 0.1, -screen_width, screen_width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.damage_meter_UI.total_damage_value_label.shadow.offset.y = imgui.drag_float("Y", config.damage_meter_UI.total_damage_value_label.shadow.offset.y, 0.1, -screen_height, screen_height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Damage Bar") then
			changed, config.damage_meter_UI.damage_bar.visibility = imgui.checkbox("Visible", config.damage_meter_UI.damage_bar.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.damage_bar.offset.x = imgui.drag_float("X", config.damage_meter_UI.damage_bar.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.damage_bar.offset.y = imgui.drag_float("Y", config.damage_meter_UI.damage_bar.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			if imgui.tree_node("Size") then
				changed, config.damage_meter_UI.damage_bar.size.width = imgui.drag_float("Width", config.damage_meter_UI.damage_bar.size.width, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.damage_bar.size.height = imgui.drag_float("Height", config.damage_meter_UI.damage_bar.size.height, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			if imgui.tree_node("Colors") then
				-- color pickers?
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Highlighted Damage Bar") then
			changed, config.damage_meter_UI.highlighted_damage_bar.visibility = imgui.checkbox("Visible", config.damage_meter_UI.highlighted_damage_bar.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Offset") then
				changed, config.damage_meter_UI.highlighted_damage_bar.offset.x = imgui.drag_float("X", config.damage_meter_UI.highlighted_damage_bar.offset.x, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.highlighted_damage_bar.offset.y = imgui.drag_float("Y", config.damage_meter_UI.highlighted_damage_bar.offset.y, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			if imgui.tree_node("Size") then
				changed, config.damage_meter_UI.damage_bar.size.width = imgui.drag_float("Width", config.damage_meter_UI.damage_bar.size.width, 0.1, -screen_width, screen_width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.damage_meter_UI.damage_bar.size.height = imgui.drag_float("Height", config.damage_meter_UI.damage_bar.size.height, 0.1, -screen_height, screen_height, "%.1f");
				config_changed = config_changed or changed;
	
				imgui.tree_pop();
			end

			if imgui.tree_node("Colors") then
				-- color pickers?
	
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
--#endregion
----------------------CUSTOMIZATION UI-----------------------





---------------------------GLOBAL----------------------------
--#region
re.on_draw_ui(function()
	if imgui.button('MHR Overlay') then
		is_customization_window_opened = not is_customization_window_opened;
	end
end);

re.on_frame(function()
	if is_customization_window_opened then
		customization_ui();
	end
end);

get_window_size = function ()
	local size = scene_view:call("get_Size");
	if size == nil then
		log.error("[MHR Overlay] No scene view size");
		return
	end

	screen_width = size:get_field("w");
	if screen_width == nil then
		log.error("[MHR Overlay] No screen width");
		return
	end

	screen_height = size:get_field("h");
	if screen_height == nil then
		log.error("[MHR Overlay] No screen height");
		return
	end
end

calculate_screen_coordinates = function (position)
	if position.anchor == "Top-Left" then
		return {x = position.x, y = position.y};
	end

	if position.anchor == "Top-Right" then
		local screen_x = screen_width - position.x;
		return {x = screen_x, y = position.y};
	end

	if position.anchor == "Bottom-Left" then
		local screen_y = screen_height - position.y;
		return {x = position.x, y = screen_y};
	end

	if position.anchor == "Bottom-Right" then
		local screen_x = screen_width - position.x;
		local screen_y = screen_height - position.y;
		return {x = screen_x, y = screen_y};
	end

	return {x = position.x, y = position.y};
end

table_find_index = function (table, value, nullable)
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
--#endregion
---------------------------GLOBAL----------------------------





------------------------DRAW HELPERS-------------------------
--#region
draw_label = function(label, position, ...)
	if label == nil then
		return;
	end

	if not label.visibility then
		return;
	end

	local text = string.format(label.text, table.unpack({...}));
	if label.shadow.visibility then
		d2d.text(font, text, position.x + label.offset.x + label.shadow.offset.x, position.y + label.offset.y + label.shadow.offset.y, label.shadow.color);
	end
	d2d.text(font, text, position.x + label.offset.x, position.y + label.offset.y, label.color);
end

draw_bar = function (bar, position, percentage)
	if bar == nil then
		return;
	end

	if not bar.visibility then
		return;
	end

	local foreground_width = bar.size.width * percentage;
	local background_width = bar.size.width - foreground_width;

	--foreground
	d2d.fill_rect(position.x + bar.offset.x, position.y + bar.offset.y, foreground_width, bar.size.height, bar.colors.foreground);

	--background
	d2d.fill_rect(position.x + foreground_width + bar.offset.x, position.y + bar.offset.y, background_width, bar.size.height, bar.colors.background);
end
--#endregion
------------------------DRAW HELPERS-------------------------





------------------------QUEST STATUS-------------------------
--#region
local quest_manager_type_definition = sdk.find_type_definition("snow.QuestManager");
local on_changed_game_status = quest_manager_type_definition:get_method("onChangedGameStatus");

sdk.hook(on_changed_game_status, function(args)
	local status = sdk.to_int64(args[3]);
	if status ~= nil then
		quest_status = status;
	end

end, function(retval) return retval; end);
--#endregion
------------------------QUEST STATUS-------------------------





------------------------MONSTER HOOK-------------------------
--#region
local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_type_def_update_method = enemy_character_base_type_def:get_method("update");

sdk.hook(enemy_character_base_type_def_update_method, function(args)
    update_monster(sdk.to_managed_object(args[2]));
end, function(retval) return retval; end);

update_monster = function (enemy)
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

    local vital_param = physical_param:call("getVital", 0, 0);
    if vital_param == nil then
        status = "No vital param";
        return;
    end

    local health = vital_param:call("get_Current");
    local max_health = vital_param:call("get_Max");
	local missing_health = max_health - health;
	local capture_health = physical_param:call("get_CaptureHpVital");

	local health_percentage = 1;
	if max_health ~= 0 then
		health_percentage = health / max_health;
	end

	local monster_list = large_monsters;
	if not is_boss_enemy then
		monster_list = small_monsters;
	end

    local monster = monster_list[enemy];

    if monster == nil then
        monster = {};
		monster_list[enemy] = monster;

        local enemy_type = enemy:get_field("<EnemyType>k__BackingField");
        if enemy_type == nil then
            status = "No enemy type";
            return;
        end

        local enemy_name = message_manager:call("getEnemyNameMessage", enemy_type);
        monster.name = enemy_name;

		local size_info = enemy_manager:call("findEnemySizeInfo", enemy_type);
		monster.small_border = size_info:call("get_SmallBorder");
		monster.big_border = size_info:call("get_KingBorder");
		monster.size = enemy:call("get_MonsterListRegisterScale");

		if monster.size < monster.small_border then
			monster.crown = "Silver";
		elseif monster.size > monster.big_border then
			monster.crown = "Gold";
		else
			monster.crown = "";
		end
    end

    monster.health = health;
    monster.max_health = max_health;
	monster.health_percentage = health_percentage;
	monster.missing_health = missing_health;
	monster.capture_health = capture_health;

end
--#endregion
------------------------MONSTER HOOK-------------------------





----------------------LARGE MONSTER UI-----------------------
--#region
monster_health = function()
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
            break;
        end

        local monster = large_monsters[enemy];
        if monster == nil then
            status = "No monster hp entry";
            break;
		end

		table.insert(displayed_monsters, monster);
    end

	--sort here
	if config.monster_UI.sort_type == "Normal" and config.monster_UI.reversed_order then
		local reversed_monsters = {};

		for i = #displayed_monsters, 1, -1 do
			table.insert(reversed_monsters, large_monsters[i]);
		end
		displayed_monsters = reversed_monsters;

	elseif config.monster_UI.sort_type == "Health" then
		table.sort(displayed_monsters, function(left, right)
			local result = left.health > right.health;

			if config.monster_UI.reversed_order then
				result = not result;
			end

			return result;
		end);
	elseif config.monster_UI.sort_type == "Health Percentage" then
		table.sort(displayed_monsters, function(left, right)
			local result = left.health_percentage < right.health_percentage;

			if config.monster_UI.reversed_order then
				result = not result;
			end

			return result;
		end);
	end

	local i = 0;
	for _, monster in ipairs(displayed_monsters) do
		local position_on_screen = calculate_screen_coordinates(config.monster_UI.position);

		if config.monster_UI.settings.orientation == "Horizontal" then
			position_on_screen.x = position_on_screen.x + config.monster_UI.settings.spacing * i;
		else
			position_on_screen.y = position_on_screen.y + config.monster_UI.settings.spacing * i;
		end

		--remaining health
		--[[
		if monster.health <= monster.capture_health then
			remaining_health_color = monster_UI.colors.health_bar.capture_health
		else
			remaining_health_color = monster_UI.colors.health_bar.remaining_health
		end
		--]]

		draw_bar(config.monster_UI.health_bar, position_on_screen, monster.health_percentage);

		local monster_name_text = "";
		if config.monster_UI.monster_name_label.include.monster_name then
			monster_name_text = string.format("%s ", monster.name);
		end
		if config.monster_UI.monster_name_label.include.crown and monster.crown ~= "" then
			monster_name_text = monster_name_text .. string.format("%s ", monster.crown);
		end
		if config.monster_UI.monster_name_label.include.size then
			monster_name_text = monster_name_text .. string.format("#%.0f ", 100 * monster.size);
		end

		if config.monster_UI.monster_name_label.include.silver_crown_threshold and config.monster_UI.monster_name_label.include.gold_crown_threshold then
			monster_name_text = monster_name_text .. string.format("(Silver: <%.0f, Gold: >%.0f)", 100 * monster.small_border, 100 * monster.big_border);
		elseif config.monster_UI.monster_name_label.include.silver_crown_threshold then
			monster_name_text = monster_name_text .. string.format("(Silver: <%.0f)", 100 * monster.small_border);
		elseif config.monster_UI.monster_name_label.include.gold_crown_threshold then
			monster_name_text = monster_name_text .. string.format("(Gold: >%.0f)", 100 * monster.big_border);
		end

		draw_label(config.monster_UI.monster_name_label, position_on_screen, monster_name_text);
		draw_label(config.monster_UI.health_label, position_on_screen);
		draw_label(config.monster_UI.health_value_label, position_on_screen, monster.health, monster.max_health);
		draw_label(config.monster_UI.health_percentage_label, position_on_screen, 100 * monster.health_percentage);

		i = i + 1;
	end
end
--#endregion
----------------------LARGE MONSTER UI-----------------------





---------------------------TIME UI---------------------------
--#region
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
--#endregion
---------------------------TIME UI---------------------------





-----------------------DAMAGE METER UI-----------------------
--#region
local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_after_calc_damage_damage_side = enemy_character_base_type_def:get_method("afterCalcDamage_DamageSide");

sdk.hook(enemy_character_base_after_calc_damage_damage_side, function(args)
	local enemy = sdk.to_managed_object(args[2]);
	if enemy == nil then
		return;
	end

	local is_boss_enemy = enemy:call("get_isBossEnemy");
	if is_boss_enemy == nil then
		return;
	end

	if not config.damage_meter_UI.tracked_monster_types.small_monsters and not is_boss_enemy then
		return;
	end

	if not config.damage_meter_UI.tracked_monster_types.large_monsters and not is_boss_enemy then
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
		attacker_id = myself_player_id;
	end

	local damage_object = {}
	damage_object.total_damage = enemy_calc_damage_info:call("get_TotalDamage");;
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

	--x = x.. string.format("[attacker] %d [type] %s [dmg] %d", attacker_id, damage_source_type, damage_object.total_damage);

	update_player(total, damage_source_type, damage_object);
	update_player(player, damage_source_type, damage_object);
end, function(retval) return retval; end);

init_player = function(player_id, player_name, player_hunter_rank)
	player = {};
	player.id = player_id;
	player.name = player_name;
	player.hunter_rank = player_hunter_rank;

	player.total_damage = 0;
	player.physical_damage = 0;
	player.elemental_damage = 0;
	player.ailment_damage = 0;

	player.bombs = {};
	player.bombs.total_damage = 0;
	player.bombs.physical_damage = 0;
	player.bombs.elemental_damage = 0;
	player.bombs.ailment_damage = 0;

	player.kunai = {};
	player.kunai.total_damage = 0;
	player.kunai.physical_damage = 0;
	player.kunai.elemental_damage = 0;
	player.kunai.ailment_damage = 0;

	player.installations = {};
	player.installations.total_damage = 0;
	player.installations.physical_damage = 0;
	player.installations.elemental_damage = 0;
	player.installations.ailment_damage = 0;

	player.otomo = {};
	player.otomo.total_damage = 0;
	player.otomo.physical_damage = 0;
	player.otomo.elemental_damage = 0;
	player.otomo.ailment_damage = 0;

	player.monster = {};
	player.monster.total_damage = 0;
	player.monster.physical_damage = 0;
	player.monster.elemental_damage = 0;
	player.monster.ailment_damage = 0;

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

update_player = function(player, damage_source_type, damage_object)
	if player == nil then
		return;
	end

	if damage_source_type == "player" then
		merge_damage(player, damage_object);
	elseif damage_source_type == "bomb" then
		merge_damage(player.bombs, damage_object);
	elseif damage_source_type == "kunai" then
		merge_damage(player.kunai, damage_object);
	elseif damage_source_type == "wyvernblast" then
		merge_damage(player, damage_object);
	elseif damage_source_type == "installation" then
		merge_damage(player.installations, damage_object);
	elseif damage_source_type == "otomo" then
		merge_damage(player.otomo, damage_object);
	elseif damage_source_type == "monster" then
		merge_damage(player.monster, damage_object);
	else
		merge_damage(player, damage_object);
	end

	player.display.total_damage = 0;
	player.display.physical_damage = 0;
	player.display.elemental_damage = 0;
	player.display.ailment_damage = 0;

	if config.damage_meter_UI.tracked_damage_types.player_damage then
		merge_damage(player.display, player);
	end

	if config.damage_meter_UI.tracked_damage_types.bomb_damage then
		merge_damage(player.display, player.bombs);

	end

	if config.damage_meter_UI.tracked_damage_types.kunai_damage then
		merge_damage(player.display, player.kunai);
	end

	if config.damage_meter_UI.tracked_damage_types.installation_damage then
		merge_damage(player.display, player.installations);
	end

	if config.damage_meter_UI.tracked_damage_types.otomo_damage then
		merge_damage(player.display, player.otomo);
	end

	if config.damage_meter_UI.tracked_damage_types.monster_damage then
		merge_damage(player.display, player.monster);
	end
end

merge_damage = function(first, second)
	first.total_damage = first.total_damage + second.total_damage;
	first.physical_damage =  first.physical_damage + second.physical_damage;
	first.elemental_damage = first.elemental_damage + second.elemental_damage;
	first.ailment_damage = first.ailment_damage + second.ailment_damage;
end

damage_meter = function()
	if quest_status < 2 then
		players = {};
		total = init_player(0, "Total", 0);
		return;
	end

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

	--myself player
	local myself_player_info = lobby_manager:get_field("_myHunterInfo");
	if  myself_player_info == nil then
        status = "No myself player info list";
		return;
    end

	local myself_player_name = myself_player_info:get_field("_name");
	if myself_player_name == nil then
		status = "No myself player name";
		return;
	end

	myself_player_id = 0;
	if is_quest_online then
		myself_player_id = lobby_manager:get_field("_myselfQuestIndex");
		if myself_player_id == nil then
			status = "No myself player id";
			return;
		end
	else
		myself_player_id = lobby_manager:get_field("_myselfIndex");
		if myself_player_id == nil then
			status = "No myself player id";
			return;
		end
	end

	local myself_hunter_rank = progress_manager:call("get_HunterRank");
	if myself_hunter_rank == nil then
        status = "No myself hunter rank";
		myself_hunter_rank = 0;
    end

	if players[myself_player_id] == nil then
		players[myself_player_id] = init_player(myself_player_id, myself_player_name, myself_hunter_rank);
	end
	local quest_players = {};

	if quest_status > 2 then
		quest_players = last_displayed_players;
	else
		--other players
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

				goto continue;
			end

			local player_id = player_info:get_field("_memberIndex");
			if player_id == nil then
				
				goto continue;
			end
			
			local player_hunter_rank = player_info:get_field("_hunterRank");
			if player_hunter_rank == nil then
				goto continue;
			end

			if player_id == myself_player_id and config.damage_meter_UI.settings.my_damage_bar_location ~= "Normal" then
				players[myself_player_id].hunter_rank = player_hunter_rank;
				goto continue;
			end

			local player_name = player_info:get_field("_name");
			if player_name == nil then
				goto continue;
			end

			if players[player_id] == nil then
				players[player_id] = init_player(player_id, player_name, player_hunter_rank);
			elseif players[player_id].name ~= player_name then
				players[player_id] = init_player(player_id, player_name, player_hunter_rank);
			end

			table.insert(quest_players, players[player_id]);

			::continue::
		end

		--sort here
		if config.damage_meter_UI.sort_type == "normal" and config.damage_meter_UI.reverse_order then
			local reversed_quest_players = {};

			for i = #quest_players, 1, -1 do
				table.insert(reversed_quest_players, quest_players[i]);
			end
			quest_players = reversed_quest_players;

		elseif config.damage_meter_UI.sort_type == "damage" then
			table.sort(quest_players, function(left, right)
				local result = left.display.total_damage > right.display.total_damage;
				if config.damage_meter_UI.reverse_order then
					result = not result;
				end

				return result;
			end);
		end

		if config.damage_meter_UI.settings.my_damage_bar_location == "First" then
			table.insert(quest_players, 1, players[myself_player_id]);
		elseif config.damage_meter_UI.settings.my_damage_bar_location == "Last" then
			table.insert(quest_players, #quest_players + 1, players[myself_player_id]);
		elseif #quest_players == 0 then
			table.insert(quest_players, 1, players[myself_player_id]);
		end

		last_displayed_players = quest_players;
	end

	local top_damage = 0;
	for _, player in ipairs(quest_players) do
		if player.display.total_damage > top_damage then
			top_damage = player.display.total_damage;
		end
	end

	--draw
	local position_on_screen = calculate_screen_coordinates(config.damage_meter_UI.position);
	for _, player in ipairs(quest_players) do
		
		if player.display.total_damage == 0 and config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero then
			goto continue1;
		end	
		
		local player_damage_percentage = 0;
		if total.display.total_damage ~= 0 then
			player_damage_percentage = player.display.total_damage / total.display.total_damage;
		end

		if config.damage_meter_UI.settings.highlighted_bar == "Me" then
			if player.id == myself_player_id then
				draw_bar(config.damage_meter_UI.highlighted_damage_bar, position_on_screen, player_damage_percentage);
			end
		elseif config.damage_meter_UI.settings.highlighted_bar == "Top Damage" then
			if player.display.total_damage == top_damage then
				draw_bar(config.damage_meter_UI.highlighted_damage_bar, position_on_screen, player_damage_percentage);
			end
		else
			draw_bar(config.damage_meter_UI.damage_bar, position_on_screen, player_damage_percentage);
		end

		local player_name_text = "";
		local player_include = config.damage_meter_UI.player_name_label.include.others;
		if player.id == myself_player_id then
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

		draw_label(config.damage_meter_UI.player_name_label, position_on_screen, player_name_text)
		draw_label(config.damage_meter_UI.damage_value_label, position_on_screen, player.display.total_damage);
		draw_label(config.damage_meter_UI.damage_percentage_label, position_on_screen, 100 * player_damage_percentage);

		if config.damage_meter_UI.settings.orientation == "Horizontal" then
			position_on_screen.x = position_on_screen.x + config.damage_meter_UI.settings.spacing;
		else
			position_on_screen.y = position_on_screen.y + config.damage_meter_UI.settings.spacing;
		end

		::continue1::

	end

	--draw total damage
	draw_label(config.damage_meter_UI.total_damage_label, position_on_screen);
	draw_label(config.damage_meter_UI.total_damage_value_label, position_on_screen, total.display.total_damage);

end
--#endregion
-----------------------DAMAGE METER UI-----------------------
--#region
if not init() then
	return;
end
--#endregion