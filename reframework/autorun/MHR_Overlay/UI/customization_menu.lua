local this = {};

local utils;
local config;
local screen;
local players;
local large_monster;
local small_monster;
local env_creature;
local language;
local part_names;
local time_UI;
local keyboard;
local non_players;
local quest_status;
local buffs;

local label_customization;
local bar_customization;
local large_monster_UI_customization;

local label_customization;
local bar_customization;
local health_customization;
local stamina_customization;
local rage_customization;
local body_parts_customization;
local ailments_customization;
local ailment_buildups_customization;
local module_visibility_customization;

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

this.font = nil;
this.full_font_range = {0x1, 0xFFFF, 0};
this.is_opened = false;
this.status = "OK";

this.window_position = Vector2f.new(480, 200);
this.window_pivot = Vector2f.new(0, 0);
this.window_size = Vector2f.new(720, 720);
this.window_flags = 0x10120;
this.color_picker_flags = 327680;
this.decimal_input_flags = 33;

this.orientation_types = {};
this.displayed_orientation_types = {};

this.anchor_types = {};
this.displayed_anchor_types = {};

this.monster_UI_sorting_types = {};
this.displayed_monster_UI_sorting_types = {};

this.buff_UI_sorting_types = {};
this.displayed_buff_UI_sorting_types = {};

this.damage_meter_UI_highlighted_entity_types = {};
this.displayed_damage_meter_UI_highlighted_entity_types = {};

this.damage_meter_UI_damage_bar_relative_types = {};
this.displayed_damage_meter_UI_damage_bar_relative_types = {};

this.damage_meter_UI_my_damage_bar_location_types = {};
this.displayed_damage_meter_UI_my_damage_bar_location_types = {};

this.damage_meter_UI_total_damage_location_types = {};
this.displayed_damage_meter_UI_total_damage_location_types = {};

this.damage_meter_UI_sorting_types = {};
this.displayed_damage_meter_UI_sorting_types = {};

this.damage_meter_UI_dps_modes = {};
this.displayed_damage_meter_UI_dps_modes = {};

this.auto_highlight_modes = {};
this.displayed_auto_highlight_modes = {};

this.fonts = {"Arial", "Arial Black", "Bahnschrift", "Calibri", "Cambria", "Cambria Math", "Candara",
                            "Comic Sans MS", "Consolas", "Constantia", "Corbel", "Courier New", "Ebrima",
                            "Franklin Gothic Medium", "Gabriola", "Gadugi", "Georgia", "HoloLens MDL2 Assets", "Impact",
                            "Ink Free", "Javanese Text", "Leelawadee UI", "Lucida Console", "Lucida Sans Unicode",
                            "Malgun Gothic", "Marlett", "Microsoft Himalaya", "Microsoft JhengHei",
                            "Microsoft New Tai Lue", "Microsoft PhagsPa", "Microsoft Sans Serif", "Microsoft Tai Le",
                            "Microsoft YaHei", "Microsoft Yi Baiti", "MingLiU-ExtB", "Mongolian Baiti", "MS Gothic",
                            "MV Boli", "Myanmar Text", "Nirmala UI", "Palatino Linotype", "Segoe MDL2 Assets",
                            "Segoe Print", "Segoe Script", "Segoe UI", "Segoe UI Historic", "Segoe UI Emoji",
                            "Segoe UI Symbol", "SimSun", "Sitka", "Sylfaen", "Symbol", "Tahoma", "Times New Roman",
                            "Trebuchet MS", "Verdana", "Webdings", "Wingdings", "Yu Gothic"
};

this.all_UI_waiting_for_key = false;
this.small_monster_UI_waiting_for_key = false;
this.large_monster_UI_waiting_for_key = false;
this.large_monster_dynamic_UI_waiting_for_key = false;
this.large_monster_static_UI_waiting_for_key = false;
this.large_monster_highlighted_UI_waiting_for_key = false;
this.time_UI_waiting_for_key = false;
this.damage_meter_UI_waiting_for_key = false;
this.endemic_life_UI_waiting_for_key = false;
this.menu_font_changed = false;

this.config_name_input = "";

function this.reload_font(pop_push)
	local cached_language = language.current_language;

	local font_range = cached_language.unicode_glyph_ranges;

	if cached_language.font_name == "" then
		font_range = nil;

	elseif cached_language.unicode_glyph_ranges == nil
	or utils.table.is_empty(cached_language.unicode_glyph_ranges)
	or #cached_language.unicode_glyph_ranges == 1
	or not utils.number.is_odd(#cached_language.unicode_glyph_ranges) then

		font_range = this.full_font_range;
	end
	
	this.font = imgui.load_font(cached_language.font_name, config.current_config.global_settings.menu_font.size, font_range);

	if pop_push then
		imgui.pop_font();
		imgui.push_font(this.font);
	end
end

function this.init()
	local default = language.default_language.customization_menu;
	local current = language.current_language.customization_menu;

	bar_customization.init();
	ailments_customization.init();
	ailment_buildups_customization.init();
	body_parts_customization.init();

	this.orientation_types = 
	{
		default.horizontal,
		default.vertical
	};

	this.displayed_orientation_types =
	{
		current.horizontal,
		current.vertical
	};

	this.anchor_types =
	{
		default.top_left,
		default.top_right,
		default.bottom_left,
		default.bottom_right
	};

	this.displayed_anchor_types =
	{
		current.top_left,
		current.top_right,
		current.bottom_left,
		current.bottom_right
	};

	this.monster_UI_sorting_types =
	{
		default.normal,
		default.health,
		default.health_percentage,
		default.distance
	};									

	this.displayed_monster_UI_sorting_types =
	{
		current.normal,
		current.health,
		current.health_percentage,
		current.distance
	};

	this.buff_UI_sorting_types =
	{
		default.name,
		default.timer,
		default.duration
	};

	this.displayed_buff_UI_sorting_types =
	{
		current.name,
		current.timer,
		current.duration
	};

	this.damage_meter_UI_highlighted_entity_types =
	{
		default.top_damage,
		default.top_dps,
		default.none
	};

	this.displayed_damage_meter_UI_highlighted_entity_types =
	{
		current.top_damage,
		current.top_dps,
		current.none
	};

	this.damage_meter_UI_damage_bar_relative_types =
	{
		default.total_damage,
		default.top_damage
	};

	this.displayed_damage_meter_UI_damage_bar_relative_types =
	{
		current.total_damage,
		current.top_damage
	};

	this.damage_meter_UI_my_damage_bar_location_types =
	{
		default.normal,
		default.first,
		default.last
	};
	
	this.displayed_damage_meter_UI_my_damage_bar_location_types =
	{
		current.normal,
		current.first,
		current.last
	};

	this.damage_meter_UI_total_damage_location_types =
	{
		default.first,
		default.last
	};

	this.displayed_damage_meter_UI_total_damage_location_types =
	{
		current.first,
		current.last
	};

	this.damage_meter_UI_sorting_types =
	{
		default.normal,
		default.damage,
		default.dps
	};

	this.displayed_damage_meter_UI_sorting_types =
	{
		current.normal,
		current.damage,
		current.dps
	};

	this.damage_meter_UI_dps_modes =
	{
		default.first_hit,
		default.quest_time,
		default.join_time
	};

	this.displayed_damage_meter_UI_dps_modes =
	{
		current.first_hit,
		current.quest_time,
		current.join_time
	};

	this.auto_highlight_modes =
	{
		default.closest,
		default.farthest,
		default.lowest_health,
		default.highest_health,
		default.lowest_health_percentage,
		default.highest_health_percentage
	};

	this.displayed_auto_highlight_modes =
	{
		current.closest,
		current.farthest,
		current.lowest_health,
		current.highest_health,
		current.lowest_health_percentage,
		current.highest_health_percentage
	};
end

function this.draw()
	imgui.set_next_window_pos(this.window_position, 1 << 3, this.window_pivot);
	imgui.set_next_window_size(this.window_size, 1 << 3);
	
	imgui.push_font(this.font);

	this.is_opened = imgui.begin_window(
		language.current_language.customization_menu.mod_name .. " v" .. config.current_config.version, this.is_opened,
		this.window_flags);

	if not this.is_opened then
		imgui.pop_font();
		imgui.end_window();
		return;
	end

	local config_changed = false;
	local language_changed = false;
	local modifiers_changed = false;
	local modules_changed = false;
	local global_settings_changed = false;
	local small_monster_UI_changed = false;
	local large_monster_dynamic_UI_changed = false;
	local large_monster_static_UI_changed = false;
	local large_monster_highlighted_UI_changed = false;
	local time_UI_changed = false;
	local damage_meter_UI_changed = false;
	local endemic_life_UI_changed = false;
	local buff_UI_changed = false;
	local apply_font_requested = false;

	local status_string = tostring(this.status);

	imgui.text(language.current_language.customization_menu.status .. ": " .. status_string);

	config_changed, apply_font_requested = this.draw_config();
	modules_changed = this.draw_modules();
	this.draw_hotkeys();
	global_settings_changed, modifiers_changed, apply_font_requested, language_changed = this.draw_global_settings(apply_font_requested, config_changed);
	small_monster_UI_changed = this.draw_small_monster_UI();

	if imgui.tree_node(language.current_language.customization_menu.large_monster_UI) then
		large_monster_dynamic_UI_changed = this.draw_large_monster_dynamic_UI()
		large_monster_static_UI_changed = this.draw_large_monster_static_UI()
		large_monster_highlighted_UI_changed = this.draw_large_monster_highlighted_UI()
		imgui.tree_pop();
	end

	time_UI_changed = this.draw_time_UI();
	damage_meter_UI_changed = this.draw_damage_meter_UI();
	endemic_life_UI_changed = this.draw_endemic_life_UI()
	buff_UI_changed = this.draw_buff_UI();

	imgui.pop_font();
	imgui.end_window();

	if small_monster_UI_changed or modifiers_changed or config_changed then
		for _, monster in pairs(small_monster.list) do
			small_monster.init_UI(monster);
		end
	end

	if large_monster_dynamic_UI_changed or modifiers_changed or config_changed then
		for _, monster in pairs(large_monster.list) do
			large_monster.init_UI(monster, monster.dynamic_UI, config.current_config.large_monster_UI.dynamic);
		end
	end

	if large_monster_static_UI_changed or modifiers_changed or config_changed then
		for _, monster in pairs(large_monster.list) do
			large_monster.init_UI(monster, monster.static_UI, config.current_config.large_monster_UI.static);
		end
	end

	if large_monster_highlighted_UI_changed or modifiers_changed or config_changed then
		for _, monster in pairs(large_monster.list) do
			large_monster.init_UI(monster, monster.highlighted_UI, config.current_config.large_monster_UI.highlighted);
		end
	end

	if time_UI_changed or modifiers_changed or config_changed then
		time_UI.init_UI();
	end

	if damage_meter_UI_changed or modifiers_changed or config_changed then
		
		for _, player in pairs(players.list) do
			players.init_UI(player);
			
		end

		for _, servant in pairs(non_players.servant_list) do
			non_players.init_UI(servant);
		end

		for _, otomo in pairs(non_players.otomo_list) do
			non_players.init_UI(otomo);
		end

		
		players.init_UI(players.total);
		players.init_highlighted_UI();
	end

	if endemic_life_UI_changed or modifiers_changed or config_changed then
		for _, creature in pairs(env_creature.list) do
			env_creature.init_UI(creature);
		end
	end

	if buff_UI_changed or modifiers_changed or config_changed then
		for _, buff in pairs(buffs.list) do
			buffs.init_UI(buff);
		end
	end

	if this.menu_font_changed and (apply_font_requested or config_changed) then
		this.menu_font_changed = false;
		this.reload_font();
	end

	if modules_changed or global_settings_changed or small_monster_UI_changed or large_monster_dynamic_UI_changed or
		large_monster_static_UI_changed or large_monster_highlighted_UI_changed or time_UI_changed or damage_meter_UI_changed or
		endemic_life_UI_changed or buff_UI_changed or modifiers_changed or config_changed then
		config.save_current();
	end
end

function this.draw_config()
	local index = 1;
	local changed = false;
	local config_changed = false;
	local apply_font_requested = false;
	
	if imgui.tree_node(language.current_language.customization_menu.config) then
		
		changed, index = imgui.combo(language.current_language.customization_menu.config,
			utils.table.find_index(config.config_names, config.current_config_name), config.config_names);
		config_changed = config_changed or changed;

		if changed then
			config.current_config_name = config.config_names[index];
			config.update(index);

			language.update(utils.table.find_index(language.language_names, config.current_config.global_settings.language, false));
			
			this.init();

			this.menu_font_changed = true;
			apply_font_requested = true;
		end
			
		changed, this.config_name_input = imgui.input_text(language.current_language.customization_menu.config_name, this.config_name_input);

		changed = imgui.button(language.current_language.customization_menu.new);
		if changed then
			if this.config_name_input ~= "" then
				config.new(this.config_name_input);
				config_changed = config_changed or changed;

				language.update(utils.table.find_index(language.language_names, config.current_config.global_settings.language, false));
			
				this.init();

				this.menu_font_changed = true;
				apply_font_requested = true;
			end
			
		end

		imgui.same_line();

		changed =	imgui.button(language.current_language.customization_menu.duplicate);
		if changed then
			if this.config_name_input ~= "" then
				config.duplicate(this.config_name_input);
				config_changed = config_changed or changed;

				language.update(utils.table.find_index(language.language_names, config.current_config.global_settings.language, false));
			
				this.init();

				this.menu_font_changed = true;
				apply_font_requested = true;
			end
			
		end

		imgui.same_line();

		changed = imgui.button(language.current_language.customization_menu.reset);
		config_changed = config_changed or changed;
		if changed then
				config.reset();

				language.update(utils.table.find_index(language.language_names, config.current_config.global_settings.language, false));
			
				this.init();

				this.menu_font_changed = true;
				apply_font_requested = true;
			end

		imgui.tree_pop();
	end

	return config_changed, apply_font_requested;
end

function this.draw_modules()
	local changed = false;
	local config_changed = false;

	if imgui.tree_node(language.current_language.customization_menu.modules) then
		changed, config.current_config.small_monster_UI.enabled = imgui.checkbox(
			language.current_language.customization_menu.small_monster_UI, config.current_config.small_monster_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.large_monster_UI.dynamic.enabled =
			imgui.checkbox(language.current_language.customization_menu.large_monster_dynamic_UI,
				config.current_config.large_monster_UI.dynamic.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.large_monster_UI.static.enabled =
			imgui.checkbox(language.current_language.customization_menu.large_monster_static_UI,
				config.current_config.large_monster_UI.static.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.large_monster_UI.highlighted.enabled =
			imgui.checkbox(language.current_language.customization_menu.large_monster_highlighted_UI,
				config.current_config.large_monster_UI.highlighted.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.time_UI.enabled = imgui.checkbox(language.current_language.customization_menu.time_UI,
			config.current_config.time_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.damage_meter_UI.enabled = imgui.checkbox(
			language.current_language.customization_menu.damage_meter_UI, config.current_config.damage_meter_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.endemic_life_UI.enabled = imgui.checkbox(
			language.current_language.customization_menu.endemic_life_UI, config.current_config.endemic_life_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.buff_UI.enabled = imgui.checkbox(
			language.current_language.customization_menu.buff_UI, config.current_config.buff_UI.enabled);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_hotkeys()
	if imgui.tree_node(language.current_language.customization_menu.hotkeys) then
		if this.all_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.all_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.all_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.all_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.all_UI.alt = false;
				this.all_UI_waiting_for_key = false;
			end

		elseif imgui.button(language.current_language.customization_menu.all_UI) then
			local is_any_other_waiting = this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.all_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.all_UI));
		if this.small_monster_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI.alt = false;
				this.small_monster_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.small_monster_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.small_monster_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI));
		if this.large_monster_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI.alt = false;
				this.large_monster_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.large_monster_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI));
		if this.large_monster_dynamic_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI.alt = false;
				this.large_monster_dynamic_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_dynamic_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.large_monster_dynamic_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers
			                                    .large_monster_dynamic_UI));
		if this.large_monster_static_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.alt = false;
				this.large_monster_static_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_static_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.large_monster_static_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers
			                                    .large_monster_static_UI));
		if this.large_monster_highlighted_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.alt = false;
				this.large_monster_highlighted_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_highlighted_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.large_monster_highlighted_UI_waiting_for_key = true;
			end
		end
		imgui.same_line();
		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers
			                                    .large_monster_highlighted_UI));
		if this.time_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.alt = false;
				this.time_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.time_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.time_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.time_UI));
		if this.damage_meter_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI.alt = false;
				this.damage_meter_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.damage_meter_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.damage_meter_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI));
		if this.endemic_life_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI.alt = false;
				this.endemic_life_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.endemic_life_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.endemic_life_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI));
		imgui.tree_pop();
	end
end

function this.draw_global_settings(apply_font_requested, language_changed)
	local changed = false;
	local config_changed = false;
	local modifiers_changed = false;

	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.global_settings) then
		local cached_config = config.current_config.global_settings;

		imgui.text(language.current_language.customization_menu.menu_font_change_disclaimer);

		changed, index = imgui.combo(language.current_language.customization_menu.language .. "*",
			utils.table.find_index(language.language_names, cached_config.language), language.language_names);
		config_changed = config_changed or changed;

		if changed then
			cached_config.language = language.language_names[index];
			language.update(index);
			part_names.init();
			this.init();

			language_changed = true;
			this.menu_font_changed = true;
			modifiers_changed = true;
			apply_font_requested = true;
		end

		if imgui.tree_node(language.current_language.customization_menu.menu_font) then
			local new_value = cached_config.menu_font.size;
			changed, new_value = imgui.input_text(" ", cached_config.menu_font.size, this.decimal_input_flags);
			new_value = tonumber(new_value);

			if new_value ~= nil then
				if new_value < 5 then
					new_value = 5;
				elseif new_value > 100 then
					new_value = 100;
				end

				cached_config.menu_font.size = math.floor(new_value);
			end

			config_changed = config_changed or changed;
			this.menu_font_changed = this.menu_font_changed or changed;

			imgui.same_line();

			changed = imgui.button("-");
			config_changed = config_changed or changed;

			imgui.same_line();

			if changed then
				cached_config.menu_font.size = cached_config.menu_font.size - 1;

				if cached_config.menu_font.size < 5 then
					cached_config.menu_font.size = 5;
				else
					this.menu_font_changed = this.menu_font_changed or changed;
				end
			end

			changed = imgui.button("+");
			config_changed = config_changed or changed;

			imgui.same_line();

			if changed then
				cached_config.menu_font.size = cached_config.menu_font.size + 1;

				if cached_config.menu_font.size > 100 then
					cached_config.menu_font.size = 100;
				else
					this.menu_font_changed = this.menu_font_changed or changed;
				end
			end

			imgui.text(language.current_language.customization_menu.size .. "*");

			if imgui.button(language.current_language.customization_menu.apply) then
				apply_font_requested = true;
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.UI_font) then
			imgui.text(language.current_language.customization_menu.UI_font_notice);

			changed, index = imgui.combo(language.current_language.customization_menu.family,
				utils.table.find_index(this.fonts, cached_config.UI_font.family), this.fonts);
			config_changed = config_changed or changed;

			if changed then
				cached_config.UI_font.family = this.fonts[index];
			end

			changed, cached_config.UI_font.size = imgui.slider_int(language.current_language.customization_menu.size,
				cached_config.UI_font.size, 1, 100);
			config_changed = config_changed or changed;

			changed, cached_config.UI_font.bold = imgui.checkbox(language.current_language.customization_menu.bold,
				cached_config.UI_font.bold);
			config_changed = config_changed or changed;

			changed, cached_config.UI_font.italic = imgui.checkbox(language.current_language.customization_menu.italic,
				cached_config.UI_font.italic);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.modifiers) then
			changed, cached_config.modifiers.global_position_modifier =
				imgui.drag_float(language.current_language.customization_menu.global_position_modifier,
					cached_config.modifiers.global_position_modifier, 0.01, 0.01, 10, "%.1f");

			config_changed = config_changed or changed;
			modifiers_changed = modifiers_changed or changed;

			changed, cached_config.modifiers.global_scale_modifier = imgui.drag_float(language.current_language
				                                                                          .customization_menu.global_scale_modifier,
				cached_config.modifiers.global_scale_modifier, 0.01, 0.01, 10, "%.1f");

			config_changed = config_changed or changed;
			modifiers_changed = modifiers_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.performance) then
			changed, cached_config.performance.max_monster_updates_per_tick =
				imgui.slider_int(language.current_language.customization_menu.max_monster_updates_per_tick,
					cached_config.performance.max_monster_updates_per_tick, 1, 150);

			config_changed = config_changed or changed;

			changed, cached_config.performance.prioritize_large_monsters =
				imgui.checkbox(language.current_language.customization_menu.prioritize_large_monsters,
					cached_config.performance.prioritize_large_monsters);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.renderer) then
			changed, cached_config.renderer.use_d2d_if_available =
				imgui.checkbox(language.current_language.customization_menu.use_d2d_if_available,
					cached_config.renderer.use_d2d_if_available);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.module_visibility_based_on_game_state) then

			if imgui.tree_node(language.current_language.customization_menu.in_training_area) then

				changed, cached_config.module_visibility.in_training_area.large_monster_dynamic_UI = imgui.checkbox(
					language.current_language.customization_menu.large_monster_dynamic_UI,
					cached_config.module_visibility.in_training_area.large_monster_dynamic_UI);

				config_changed = config_changed or changed;

				changed, cached_config.module_visibility.in_training_area.large_monster_static_UI = imgui.checkbox(
					language.current_language.customization_menu.large_monster_static_UI,
					cached_config.module_visibility.in_training_area.large_monster_static_UI);

				config_changed = config_changed or changed;

				changed, cached_config.module_visibility.in_training_area.large_monster_highlighted_UI = imgui.checkbox(
					language.current_language.customization_menu.large_monster_highlighted_UI,
					cached_config.module_visibility.in_training_area.large_monster_highlighted_UI);

				config_changed = config_changed or changed;

				changed, cached_config.module_visibility.in_training_area.damage_meter_UI = imgui.checkbox(
					language.current_language.customization_menu.damage_meter_UI,
					cached_config.module_visibility.in_training_area.damage_meter_UI);

				config_changed = config_changed or changed;

				changed, cached_config.module_visibility.in_training_area.endemic_life_UI = imgui.checkbox(
					language.current_language.customization_menu.endemic_life_UI,
					cached_config.module_visibility.in_training_area.endemic_life_UI);

				config_changed = config_changed or changed;

				changed, cached_config.module_visibility.in_training_area.buff_UI = imgui.checkbox(
					language.current_language.customization_menu.buff_UI,
					cached_config.module_visibility.in_training_area.buff_UI);

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.cutscene) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.cutscene);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.loading_quest) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.loading_quest);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.quest_start_animation) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.quest_start_animation);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.playing_quest) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.playing_quest);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.killcam) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.killcam);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.quest_end_timer) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.quest_end_timer);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.quest_end_animation) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.quest_end_animation);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.quest_end_screen) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.quest_end_screen);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.reward_screen) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.reward_screen);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.summary_screen) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.summary_screen);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	return config_changed, modifiers_changed, apply_font_requested, language_changed;
end

function this.draw_small_monster_UI()
	local changed = false;
	local config_changed = false;
	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.small_monster_UI) then
		local cached_config = config.current_config.small_monster_UI;

		changed, cached_config.enabled = imgui.checkbox(language.current_language.customization_menu.enabled,
			config.current_config.small_monster_UI.enabled);

		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_dead_or_captured = imgui.checkbox(
				language.current_language.customization_menu.hide_dead_or_captured,
				config.current_config.small_monster_UI.settings.hide_dead_or_captured);

			config_changed = config_changed or changed;

			changed, index = imgui.combo(language.current_language.customization_menu.static_orientation,
				utils.table.find_index(this.orientation_types, cached_config.settings.orientation),
				this.displayed_orientation_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.orientation = this.orientation_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.dynamic_positioning) then
			changed, cached_config.dynamic_positioning.enabled = imgui.checkbox(
				language.current_language.customization_menu.enabled, cached_config.dynamic_positioning.enabled);

			config_changed = config_changed or changed;

			changed, cached_config.dynamic_positioning.opacity_falloff =
				imgui.checkbox(language.current_language.customization_menu.opacity_falloff,
					cached_config.dynamic_positioning.opacity_falloff);

			config_changed = config_changed or changed;

			changed, cached_config.dynamic_positioning.max_distance =
				imgui.drag_float(language.current_language.customization_menu.max_distance,
					cached_config.dynamic_positioning.max_distance, 1, 0, 10000, "%.0f");

			config_changed = config_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.world_offset) then
				changed, cached_config.dynamic_positioning.world_offset.x =
					imgui.drag_float(language.current_language.customization_menu.x, cached_config.dynamic_positioning.world_offset.x,
						0.1, -100, 100, "%.1f");

				config_changed = config_changed or changed;

				changed, cached_config.dynamic_positioning.world_offset.y =
					imgui.drag_float(language.current_language.customization_menu.y, cached_config.dynamic_positioning.world_offset.y,
						0.1, -100, 100, "%.1f");

				config_changed = config_changed or changed;

				changed, cached_config.dynamic_positioning.world_offset.z =
					imgui.drag_float(language.current_language.customization_menu.z, cached_config.dynamic_positioning.world_offset.z,
						0.1, -100, 100, "%.1f");

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.viewport_offset) then
				changed, cached_config.dynamic_positioning.viewport_offset.x =
					imgui.drag_float(language.current_language.customization_menu.x,
						cached_config.dynamic_positioning.viewport_offset.x, 0.1, -screen.width, screen.width, "%.1f");

				config_changed = config_changed or changed;

				changed, cached_config.dynamic_positioning.viewport_offset.y =
					imgui.drag_float(language.current_language.customization_menu.y,
						cached_config.dynamic_positioning.viewport_offset.y, 0.1, -screen.height, screen.height, "%.1f");

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.static_position) then
			changed, cached_config.static_position.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.static_position.x, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.static_position.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.static_position.y, 0.1, 0, screen.height, "%.1f");

			config_changed = config_changed or changed;

			changed, index = imgui.combo(language.current_language.customization_menu.anchor, utils.table.find_index(
				this.anchor_types, cached_config.static_position.anchor), this.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.static_position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.static_spacing) then
			changed, cached_config.static_spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.static_spacing.x, 0.1, -screen.width, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.static_spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.static_spacing.y, 0.1, -screen.height, screen.height, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.static_sorting) then
			changed, index = imgui.combo(language.current_language.customization_menu.type, utils.table.find_index(
				this.monster_UI_sorting_types, cached_config.static_sorting.type),
				this.displayed_monster_UI_sorting_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.static_sorting.type = this.monster_UI_sorting_types[index];
			end

			changed, cached_config.static_sorting.reversed_order = imgui.checkbox(
				language.current_language.customization_menu.reversed_order, cached_config.static_sorting.reversed_order);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		changed = label_customization.draw(language.current_language.customization_menu.monster_name_label,
			cached_config.monster_name_label);

		config_changed = config_changed or changed;

		changed = health_customization.draw(cached_config.health);
		config_changed = config_changed or changed;

		changed = ailments_customization.draw(cached_config.ailments);
		config_changed = config_changed or changed;

		changed = ailment_buildups_customization.draw(cached_config.ailment_buildups);
		config_changed = config_changed or changed;

		imgui.tree_pop();

	end

	return config_changed;
end

function this.draw_large_monster_dynamic_UI()
	local changed = false;
	local config_changed = false;
	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.dynamically_positioned) then
		local cached_config = config.current_config.large_monster_UI.dynamic;

		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);
		
		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_dead_or_captured = imgui.checkbox(
				language.current_language.customization_menu.hide_dead_or_captured, cached_config.settings.hide_dead_or_captured);
			
			config_changed = config_changed or changed;

			changed, cached_config.settings.render_highlighted_monster = imgui.checkbox(
				language.current_language.customization_menu.render_highlighted_monster, cached_config.settings.render_highlighted_monster);
			
			config_changed = config_changed or changed;
	
			changed, cached_config.settings.render_not_highlighted_monsters = imgui.checkbox(
				language.current_language.customization_menu.render_not_highlighted_monsters, cached_config.settings.render_not_highlighted_monsters);
			
				config_changed = config_changed or changed;

			changed, cached_config.settings.opacity_falloff = imgui.checkbox(
				language.current_language.customization_menu.opacity_falloff, cached_config.settings.opacity_falloff);
			
			config_changed = config_changed or changed;

			changed, cached_config.settings.max_distance = imgui.drag_float(
				language.current_language.customization_menu.max_distance, cached_config.settings.max_distance, 1, 0, 10000, "%.0f");
			
				config_changed = config_changed or changed;
			
			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.world_offset) then
			changed, cached_config.world_offset.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.world_offset.x, 0.1, -100, 100, "%.1f");
			
			config_changed = config_changed or changed;
			
			changed, cached_config.world_offset.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.world_offset.y, 0.1, -100, 100, "%.1f");
			
			config_changed = config_changed or changed;
			
			changed, cached_config.world_offset.z = imgui.drag_float(
				language.current_language.customization_menu.z, cached_config.world_offset.z, 0.1, -100, 100, "%.1f");
			
			config_changed = config_changed or changed;
			
			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.viewport_offset) then
			changed, cached_config.viewport_offset.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.viewport_offset.x, 0.1, -screen.width, screen.width, "%.1f");
			
			config_changed = config_changed or changed;

			changed, cached_config.viewport_offset.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.viewport_offset.y, 0.1, -screen.height, screen.height, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		changed = large_monster_UI_customization.draw(cached_config);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_large_monster_static_UI()
	local changed = false;
	local config_changed = false;
	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.statically_positioned) then
		local cached_config = config.current_config.large_monster_UI.static;

		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_dead_or_captured = imgui.checkbox(
				language.current_language.customization_menu.hide_dead_or_captured, cached_config.settings.hide_dead_or_captured);

			config_changed = config_changed or changed;

			changed, cached_config.settings.render_highlighted_monster = imgui.checkbox(
				language.current_language.customization_menu.render_highlighted_monster, cached_config.settings.render_highlighted_monster);

			config_changed = config_changed or changed;

			changed, cached_config.settings.render_not_highlighted_monsters = imgui.checkbox(
				language.current_language.customization_menu.render_not_highlighted_monsters, cached_config.settings.render_not_highlighted_monsters);

			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.highlighted_monster_location,
				utils.table.find_index(this.damage_meter_UI_my_damage_bar_location_types, cached_config.settings.highlighted_monster_location),
				this.displayed_damage_meter_UI_my_damage_bar_location_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.highlighted_monster_location = this.damage_meter_UI_my_damage_bar_location_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.orientation,
				utils.table.find_index( this.orientation_types, cached_config.settings.orientation),
				this.displayed_orientation_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.orientation = this.orientation_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.position.x, 0.1, 0, screen.width, "%.1f");
			
			config_changed = config_changed or changed;

			changed, cached_config.position.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.position.y, 0.1, 0, screen.height, "%.1f");
			
			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.anchor,
				utils.table.find_index(this.anchor_types, cached_config.position.anchor),
				this.displayed_anchor_types);
			
			config_changed = config_changed or changed;
			
			if changed then
				cached_config.position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.spacing) then
			changed, cached_config.spacing.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
			
				config_changed = config_changed or changed;

			changed, cached_config.spacing.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
			
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(
				language.current_language.customization_menu.type,
				utils.table.find_index(this.monster_UI_sorting_types, cached_config.sorting.type),
				this.displayed_monster_UI_sorting_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = this.monster_UI_sorting_types[index];
			end

			changed, cached_config.sorting.reversed_order = imgui.checkbox(
				language.current_language.customization_menu.reversed_order, cached_config.sorting.reversed_order);
			
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		changed = large_monster_UI_customization.draw(cached_config);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_large_monster_highlighted_UI()
	local changed = false;
	local config_changed = false;
	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.highlighted_targeted) then
		local cached_config = config.current_config.large_monster_UI.highlighted;
		
		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.position.x, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.position.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.position.y, 0.1, 0, screen.height, "%.1f");
			
			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.anchor,
				utils.table.find_index(this.anchor_types, cached_config.position.anchor),
				this.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.auto_highlight) then
			changed, cached_config.auto_highlight.enabled = imgui.checkbox(
				language.current_language.customization_menu.enabled, cached_config.auto_highlight.enabled);
	
			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.mode,
				utils.table.find_index(this.auto_highlight_modes, cached_config.auto_highlight.mode),
				this.displayed_auto_highlight_modes);

			config_changed = config_changed or changed;

			if changed then
				cached_config.auto_highlight.mode = this.auto_highlight_modes[index];
			end

			imgui.tree_pop();
		end

		changed = large_monster_UI_customization.draw(cached_config);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_time_UI()
	local changed = false;
	local config_changed = false;
	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.time_UI) then
		local cached_config = config.current_config.time_UI;

		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.position.x, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.position.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.position.y, 0.1, 0, screen.height, "%.1f");

			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.anchor,
				utils.table.find_index(this.anchor_types, cached_config.position.anchor),
				this.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		changed = label_customization.draw(language.current_language.customization_menu.time_label, cached_config.time_label);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_damage_meter_UI()
	local changed = false;
	local config_changed = false;
	local damage_display_changed = false;
	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.damage_meter_UI) then
		local cached_config = config.current_config.damage_meter_UI;

		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_myself = imgui.checkbox(
				language.current_language.customization_menu.hide_myself, cached_config.settings.hide_myself);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_other_players = imgui.checkbox(
				language.current_language.customization_menu.hide_other_players, cached_config.settings.hide_other_players);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_servants = imgui.checkbox(
				language.current_language.customization_menu.hide_servants, cached_config.settings.hide_servants);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_total_damage = imgui.checkbox(
				language.current_language.customization_menu.hide_total_damage, cached_config.settings.hide_total_damage);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_module_if_total_damage_is_zero = imgui.checkbox(
				language.current_language.customization_menu.hide_module_if_total_damage_is_zero, cached_config.settings.hide_module_if_total_damage_is_zero);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_player_if_player_damage_is_zero = imgui.checkbox(
				language.current_language.customization_menu.hide_player_if_player_damage_is_zero, cached_config.settings.hide_player_if_player_damage_is_zero);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_total_if_total_damage_is_zero = imgui.checkbox(
				language.current_language.customization_menu.hide_total_if_total_damage_is_zero, cached_config.settings.hide_total_if_total_damage_is_zero);

			config_changed = config_changed or changed;

			changed, cached_config.settings.total_damage_offset_is_relative = imgui.checkbox(
				language.current_language.customization_menu.total_damage_offset_is_relative, cached_config.settings.total_damage_offset_is_relative);

			config_changed = config_changed or changed;

			changed, cached_config.settings.freeze_dps_on_quest_end = imgui.checkbox(
				language.current_language.customization_menu.freeze_dps_on_quest_end, cached_config.settings.freeze_dps_on_quest_end);

			config_changed = config_changed or changed;

			changed, cached_config.settings.show_my_otomos_separately = imgui.checkbox(
				language.current_language.customization_menu.show_my_otomos_separately, cached_config.settings.show_my_otomos_separately);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.settings.show_other_player_otomos_separately = imgui.checkbox(
				language.current_language.customization_menu.show_other_player_otomos_separately, cached_config.settings.show_other_player_otomos_separately);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.settings.show_servant_otomos_separately = imgui.checkbox(
				language.current_language.customization_menu.show_servant_otomos_separately, cached_config.settings.show_servant_otomos_separately);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.orientation,
				utils.table.find_index(this.orientation_types, cached_config.settings.orientation),
				this.displayed_orientation_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.orientation = this.orientation_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.highlighted,
				utils.table.find_index(this.damage_meter_UI_highlighted_entity_types, cached_config.settings.highlighted_bar),
				this.displayed_damage_meter_UI_highlighted_entity_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.highlighted_bar = this.damage_meter_UI_highlighted_entity_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.damage_bars_are_relative_to,
				utils.table.find_index(this.damage_meter_UI_damage_bar_relative_types, cached_config.settings.damage_bar_relative_to),
				this.displayed_damage_meter_UI_damage_bar_relative_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.damage_bar_relative_to = this.damage_meter_UI_damage_bar_relative_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.my_damage_bar_location,
				utils.table.find_index(this.damage_meter_UI_my_damage_bar_location_types, cached_config.settings.my_damage_bar_location),
				this.displayed_damage_meter_UI_my_damage_bar_location_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.my_damage_bar_location = this.damage_meter_UI_my_damage_bar_location_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.total_damage_location,
				utils.table.find_index(this.damage_meter_UI_total_damage_location_types, cached_config.settings.total_damage_location),
				this.displayed_damage_meter_UI_total_damage_location_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.total_damage_location = this.damage_meter_UI_total_damage_location_types[index];
			end

			changed, index = imgui.combo(language.current_language.customization_menu.dps_mode, 
				utils.table.find_index(this.damage_meter_UI_dps_modes, cached_config.settings.dps_mode),
				this.displayed_damage_meter_UI_dps_modes);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.dps_mode = this.damage_meter_UI_dps_modes[index];
			end

			changed, cached_config.settings.player_name_size_limit = imgui.drag_float(
				language.current_language.customization_menu.player_name_size_limit, cached_config.settings.player_name_size_limit, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.tracked_monster_types) then
			local tracked_monster_types_changed = false;

			changed, cached_config.tracked_monster_types.small_monsters = imgui.checkbox(
				language.current_language.customization_menu.small_monsters, cached_config.tracked_monster_types.small_monsters);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_monster_types.large_monsters = imgui.checkbox(
				language.current_language.customization_menu.large_monsters, cached_config.tracked_monster_types.large_monsters);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.tracked_damage_types) then

			changed, cached_config.tracked_damage_types.players = imgui.checkbox(
				language.current_language.customization_menu.players, cached_config.tracked_damage_types.players);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.bombs = imgui.checkbox(
				language.current_language.customization_menu.bombs, cached_config.tracked_damage_types.bombs);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.kunai = imgui.checkbox(
				language.current_language.customization_menu.kunai, cached_config.tracked_damage_types.kunai);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.installations = imgui.checkbox(
				language.current_language.customization_menu.installations, cached_config.tracked_damage_types.installations);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.otomos = imgui.checkbox(
				language.current_language.customization_menu.otomos, cached_config.tracked_damage_types.otomos);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.wyvern_riding = imgui.checkbox(
				language.current_language.customization_menu.wyvern_riding, cached_config.tracked_damage_types.wyvern_riding);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.poison = imgui.checkbox(
				language.current_language.customization_menu.poison, cached_config.tracked_damage_types.poison);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.blast = imgui.checkbox(
				language.current_language.customization_menu.blast, cached_config.tracked_damage_types.blast);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.endemic_life = imgui.checkbox(
				language.current_language.customization_menu.endemic_life, cached_config.tracked_damage_types.endemic_life);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.anomaly_cores = imgui.checkbox(
				language.current_language.customization_menu.anomaly_cores, cached_config.tracked_damage_types.anomaly_cores);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.other = imgui.checkbox(
				language.current_language.customization_menu.other, cached_config.tracked_damage_types.other);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.spacing) then
			changed, cached_config.spacing.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.spacing.x, 0.1, -screen.width, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.spacing.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.spacing.y, 0.1, -screen.height, screen.height, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.position.x, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.position.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.position.y, 0.1, 0, screen.height, "%.1f");

			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.anchor,
				utils.table.find_index(this.anchor_types, cached_config.position.anchor),
				this.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(
				language.current_language.customization_menu.type,
				utils.table.find_index(this.damage_meter_UI_sorting_types, cached_config.sorting.type),
				this.displayed_damage_meter_UI_sorting_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = this.damage_meter_UI_sorting_types[index];
			end

			changed, cached_config.sorting.reversed_order = imgui.checkbox(
				language.current_language.customization_menu.reversed_order, cached_config.sorting.reversed_order);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.myself) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.myself.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.hunter_rank_label, cached_config.myself.hunter_rank_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.cart_count_label, cached_config.myself.cart_count_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.myself.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.myself.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.myself.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.myself.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.other_players) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.other_players.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.hunter_rank_label, cached_config.other_players.hunter_rank_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.cart_count_label, cached_config.other_players.cart_count_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.other_players.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.other_players.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.other_players.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.other_players.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.servants) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.servants.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.servants.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.servants.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.servants.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.servants.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.my_otomos) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.my_otomos.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.level_label, cached_config.my_otomos.hunter_rank_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.my_otomos.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.my_otomos.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.my_otomos.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.my_otomos.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.other_player_otomos) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.other_player_otomos.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.level_label, cached_config.other_player_otomos.hunter_rank_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.other_player_otomos.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.other_player_otomos.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.other_player_otomos.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.other_player_otomos.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.servant_otomos) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.servant_otomos.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.level_label, cached_config.servant_otomos.hunter_rank_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.servant_otomos.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.servant_otomos.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.servant_otomos.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.servant_otomos.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.total) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.total.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.cart_count_label, cached_config.total.cart_count_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.total.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.total.damage_value_label);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.highlighted) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.highlighted.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.hunter_rank_label, cached_config.highlighted.hunter_rank_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.highlighted.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.highlighted.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.highlighted.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.highlighted.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if config_changed then
			local is_on_quest = quest_status.flow_state ~= quest_status.flow_states.IN_LOBBY and quest_status.flow_state ~= quest_status.flow_states.IN_TRAINING_AREA;

			players.display_list = {};
			players.update_player_list(is_on_quest);
			non_players.update_servant_list();
			non_players.update_otomo_list(is_on_quest, quest_status.is_online);
		end

		if damage_display_changed then
			for _, player in pairs(players.list) do
				players.update_display(player);
			end

			for _, servant in pairs(non_players.servant_list) do
				players.update_display(servant);
			end

			for _, otomo in pairs(non_players.otomo_list) do
				players.update_display(otomo);
			end

			players.update_display(players.total);
			players.update_dps(true);
		end

		if config_changed then
			players.sort_players();
		end

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_endemic_life_UI()
	local changed = false;
	local config_changed = false;

	if imgui.tree_node(language.current_language.customization_menu.endemic_life_UI) then
		local cached_config = config.current_config.endemic_life_UI;

		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_inactive_creatures = imgui.checkbox(
				language.current_language.customization_menu.hide_inactive_creatures, cached_config.settings.hide_inactive_creatures);

			config_changed = config_changed or changed;

			changed, cached_config.settings.opacity_falloff = imgui.checkbox(
				language.current_language.customization_menu.opacity_falloff, cached_config.settings.opacity_falloff);

			config_changed = config_changed or changed;

			changed, cached_config.settings.max_distance = imgui.drag_float(
				language.current_language.customization_menu.max_distance, cached_config.settings.max_distance, 1, 0, 10000, "%.0f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.world_offset) then
			changed, cached_config.world_offset.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.world_offset.x, 0.1, -100, 100, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.world_offset.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.world_offset.y, 0.1, -100, 100, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.world_offset.z = imgui.drag_float(
				language.current_language.customization_menu.z, cached_config.world_offset.z, 0.1, -100, 100, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.viewport_offset) then
			changed, cached_config.viewport_offset.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.viewport_offset.x, 0.1, -screen.width, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.viewport_offset.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.viewport_offset.y, 0.1, -screen.height, screen.height, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		changed = label_customization.draw(
			language.current_language.customization_menu.creature_name_label, cached_config.creature_name_label.visibility);

		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_buff_UI()
	local changed = false;
	local config_changed = false;
	local index = 0;

	if imgui.tree_node(language.current_language.customization_menu.buff_UI) then
		local cached_config = config.current_config.buff_UI;

		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;	

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_bar_for_infinite_buffs = imgui.checkbox(
				language.current_language.customization_menu.hide_bar_for_infinite_buffs, cached_config.settings.hide_bar_for_infinite_buffs);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_timer_for_infinite_buffs = imgui.checkbox(
				language.current_language.customization_menu.hide_timer_for_infinite_buffs, cached_config.settings.hide_timer_for_infinite_buffs);

			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.orientation,
				utils.table.find_index(this.orientation_types, cached_config.settings.orientation),
				this.displayed_orientation_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.orientation = this.orientation_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.spacing) then
			changed, cached_config.spacing.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.spacing.x, 0.1, -screen.width, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.spacing.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.spacing.y, 0.1, -screen.height, screen.height, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.position.x, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.position.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.position.y, 0.1, 0, screen.height, "%.1f");

			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.anchor,
				utils.table.find_index(this.anchor_types, cached_config.position.anchor),
				this.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(
				language.current_language.customization_menu.type,
				utils.table.find_index(this.buff_UI_sorting_types, cached_config.sorting.type),
				this.displayed_buff_UI_sorting_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = this.buff_UI_sorting_types[index];
			end

			changed, cached_config.sorting.reversed_order = imgui.checkbox(
				language.current_language.customization_menu.reversed_order, cached_config.sorting.reversed_order);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.name_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.timer_label, cached_config.timer_label);
		config_changed = config_changed or changed;

		changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.bar);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.init_module()
	utils = require("MHR_Overlay.Misc.utils");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
	screen = require("MHR_Overlay.Game_Handler.screen");
	players = require("MHR_Overlay.Damage_Meter.players");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	part_names = require("MHR_Overlay.Misc.part_names");
	time_UI = require("MHR_Overlay.UI.Modules.time_UI");
	keyboard = require("MHR_Overlay.Game_Handler.keyboard");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	buffs = require("MHR_Overlay.Buffs.buffs");

	label_customization = require("MHR_Overlay.UI.Customizations.label_customization");
	bar_customization = require("MHR_Overlay.UI.Customizations.bar_customization");
	large_monster_UI_customization = require("MHR_Overlay.UI.Customizations.large_monster_UI_customization");

	health_customization = require("MHR_Overlay.UI.Customizations.health_customization");
	stamina_customization = require("MHR_Overlay.UI.Customizations.stamina_customization");
	rage_customization = require("MHR_Overlay.UI.Customizations.rage_customization");
	body_parts_customization = require("MHR_Overlay.UI.Customizations.body_parts_customization");
	ailments_customization = require("MHR_Overlay.UI.Customizations.ailments_customization");
	ailment_buildups_customization = require("MHR_Overlay.UI.Customizations.ailment_buildups_customization");
	module_visibility_customization = require("MHR_Overlay.UI.Customizations.module_visibility_customization");

	this.init();
	this.reload_font();
end

return this;