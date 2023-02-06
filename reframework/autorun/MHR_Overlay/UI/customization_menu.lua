local customization_menu = {};

local table_helpers;
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

customization_menu.font = nil;
customization_menu.font_range = {0x1, 0xFFFF, 0};
customization_menu.is_opened = false;
customization_menu.status = "OK";

customization_menu.window_position = Vector2f.new(480, 200);
customization_menu.window_pivot = Vector2f.new(0, 0);
customization_menu.window_size = Vector2f.new(720, 720);
customization_menu.window_flags = 0x10120;
customization_menu.color_picker_flags = 327680;
customization_menu.decimal_input_flags = 33;

customization_menu.displayed_orientation_types = {};
customization_menu.displayed_anchor_types = {};
customization_menu.displayed_outline_styles = {};

customization_menu.displayed_monster_UI_sorting_types = {};
customization_menu.displayed_monster_UI_parts_sorting_types = {};
customization_menu.displayed_ailments_sorting_types = {};
customization_menu.displayed_ailment_buildups_sorting_types = {};
customization_menu.displayed_highlighted_buildup_bar_types = {};
customization_menu.displayed_buildup_bar_relative_types = {};

customization_menu.displayed_damage_meter_UI_highlighted_entity_types = {};
customization_menu.displayed_damage_meter_UI_damage_bar_relative_types = {};
customization_menu.displayed_damage_meter_UI_my_damage_bar_location_types = {};
customization_menu.displayed_damage_meter_UI_total_damage_location_types = {};
customization_menu.displayed_damage_meter_UI_sorting_types = {};
customization_menu.displayed_damage_meter_UI_dps_modes = {};

customization_menu.displayed_auto_highlight_modes = {};

customization_menu.orientation_types = {};
customization_menu.anchor_types = {};
customization_menu.outline_styles = {};

customization_menu.monster_UI_sorting_types = {};
customization_menu.ailments_sorting_types = {};
customization_menu.ailment_buildups_sorting_types = {};
customization_menu.highlighted_buildup_bar_types = {};
customization_menu.buildup_bar_relative_types = {};

customization_menu.damage_meter_UI_highlighted_entity_types = {};
customization_menu.damage_meter_UI_damage_bar_relative_types = {};
customization_menu.damage_meter_UI_my_damage_bar_location_types = {};
customization_menu.damage_meter_UI_total_damage_location_types = {};
customization_menu.damage_meter_UI_sorting_types = {};
customization_menu.damage_meter_UI_dps_modes = {};

customization_menu.auto_highlight_modes = {};

customization_menu.fonts = {"Arial", "Arial Black", "Bahnschrift", "Calibri", "Cambria", "Cambria Math", "Candara",
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

customization_menu.all_UI_waiting_for_key = false;
customization_menu.small_monster_UI_waiting_for_key = false;
customization_menu.large_monster_UI_waiting_for_key = false;
customization_menu.large_monster_dynamic_UI_waiting_for_key = false;
customization_menu.large_monster_static_UI_waiting_for_key = false;
customization_menu.large_monster_highlighted_UI_waiting_for_key = false;
customization_menu.time_UI_waiting_for_key = false;
customization_menu.damage_meter_UI_waiting_for_key = false;
customization_menu.endemic_life_UI_waiting_for_key = false;
customization_menu.menu_font_changed = false;

customization_menu.config_name_input = "";

function customization_menu.reload_font(pop_push)
	customization_menu.font = imgui.load_font(language.current_language.font_name,
		config.current_config.global_settings.menu_font.size, customization_menu.font_range);

	if pop_push then
		imgui.pop_font();
		imgui.push_font(customization_menu.font);
	end
end

function customization_menu.init()
	customization_menu.displayed_orientation_types = {language.current_language.customization_menu.horizontal,
                                                   language.current_language.customization_menu.vertical};
	customization_menu.displayed_anchor_types = {language.current_language.customization_menu.top_left,
                                              language.current_language.customization_menu.top_right,
                                              language.current_language.customization_menu.bottom_left,
                                              language.current_language.customization_menu.bottom_right};

	customization_menu.displayed_outline_styles = {language.current_language.customization_menu.inside,
                                                language.current_language.customization_menu.center,
                                                language.current_language.customization_menu.outside};
	customization_menu.displayed_monster_UI_sorting_types = {language.current_language.customization_menu.normal,
                                                          language.current_language.customization_menu.health,
                                                          language.current_language.customization_menu.health_percentage,
                                                          language.current_language.customization_menu.distance};

	customization_menu.displayed_monster_UI_parts_sorting_types =
		{language.current_language.customization_menu.normal, language.current_language.customization_menu.health,
   language.current_language.customization_menu.health_percentage,
   language.current_language.customization_menu.flinch_count, language.current_language.customization_menu.break_health,
   language.current_language.customization_menu.break_health_percentage,
   language.current_language.customization_menu.break_count, language.current_language.customization_menu.loss_health,
   language.current_language.customization_menu.loss_health_percentage};

	customization_menu.displayed_ailments_sorting_types = {language.current_language.customization_menu.normal,
                                                        language.current_language.customization_menu.buildup,
                                                        language.current_language.customization_menu.buildup_percentage};
	customization_menu.displayed_ailment_buildups_sorting_types =
		{language.current_language.customization_menu.normal, language.current_language.customization_menu.buildup,
   language.current_language.customization_menu.buildup_percentage};
	customization_menu.displayed_highlighted_buildup_bar_types =
		{language.current_language.customization_menu.me, language.current_language.customization_menu.top_buildup,
   language.current_language.customization_menu.none};

	customization_menu.displayed_buildup_bar_relative_types = {language.current_language.customization_menu.total_buildup,
                                                            language.current_language.customization_menu.top_buildup};
	customization_menu.displayed_damage_meter_UI_highlighted_entity_types =
		{language.current_language.customization_menu.top_damage,
   language.current_language.customization_menu.top_dps, language.current_language.customization_menu.none};

	customization_menu.displayed_damage_meter_UI_damage_bar_relative_types =
		{language.current_language.customization_menu.total_damage, language.current_language.customization_menu.top_damage};
	
		customization_menu.displayed_damage_meter_UI_my_damage_bar_location_types = {language.current_language
		.customization_menu.normal, language.current_language.customization_menu.first,
                                                                              language.current_language
		.customization_menu.last};

	customization_menu.displayed_damage_meter_UI_total_damage_location_types = {
		language.current_language.customization_menu.first,
    	language.current_language.customization_menu.last};

	customization_menu.displayed_damage_meter_UI_sorting_types =
		{language.current_language.customization_menu.normal, language.current_language.customization_menu.damage,
   language.current_language.customization_menu.dps};
	customization_menu.displayed_damage_meter_UI_dps_modes = {language.current_language.customization_menu.first_hit,
                                                           language.current_language.customization_menu.quest_time,
                                                           language.current_language.customization_menu.join_time};

	customization_menu.displayed_auto_highlight_modes = {language.current_language.customization_menu.closest,
												language.current_language.customization_menu.farthest,
												language.current_language.customization_menu.lowest_health,
												language.current_language.customization_menu.highest_health,
												language.current_language.customization_menu.lowest_health_percentage,
												language.current_language.customization_menu.highest_health_percentage};

	customization_menu.orientation_types = {language.default_language.customization_menu.horizontal,
                                         language.default_language.customization_menu.vertical};
	customization_menu.anchor_types = {language.default_language.customization_menu.top_left,
                                    language.default_language.customization_menu.top_right,
                                    language.default_language.customization_menu.bottom_left,
                                    language.default_language.customization_menu.bottom_right};

	customization_menu.outline_styles = {language.default_language.customization_menu.inside,
                                      language.default_language.customization_menu.center,
                                      language.default_language.customization_menu.outside};
	customization_menu.monster_UI_sorting_types = {language.default_language.customization_menu.normal,
                                                language.default_language.customization_menu.health,
                                                language.default_language.customization_menu.health_percentage,
                                                language.default_language.customization_menu.distance};

	customization_menu.large_monster_UI_parts_sorting_types = {language.default_language.customization_menu.normal,
                                                            language.default_language.customization_menu.health,
                                                            language.default_language.customization_menu
		.health_percentage, language.default_language.customization_menu.flinch_count,
                                                            language.default_language.customization_menu.break_health,
                                                            language.default_language.customization_menu
		.break_health_percentage, language.default_language.customization_menu.break_count,
                                                            language.default_language.customization_menu.loss_health,
                                                            language.default_language.customization_menu
		.loss_health_percentage};

	customization_menu.ailments_sorting_types = {language.default_language.customization_menu.normal,
                                              language.default_language.customization_menu.buildup,
                                              language.default_language.customization_menu.buildup_percentage};
	customization_menu.ailment_buildups_sorting_types = {language.default_language.customization_menu.normal,
                                                      language.default_language.customization_menu.buildup,
                                                      language.default_language.customization_menu.buildup_percentage};
	customization_menu.highlighted_buildup_bar_types = {language.default_language.customization_menu.me,
                                                     language.default_language.customization_menu.top_buildup,
                                                     language.default_language.customization_menu.none};
	customization_menu.buildup_bar_relative_types = {language.default_language.customization_menu.total_buildup,
                                                  language.default_language.customization_menu.top_buildup};

	customization_menu.damage_meter_UI_highlighted_entity_types = {language.default_language.customization_menu.top_damage,
                                                             language.default_language.customization_menu.top_dps,
                                                             language.default_language.customization_menu.none};
	customization_menu.damage_meter_UI_damage_bar_relative_types =
		{language.default_language.customization_menu.total_damage, language.default_language.customization_menu.top_damage};

	customization_menu.damage_meter_UI_my_damage_bar_location_types =
		{language.default_language.customization_menu.normal, language.default_language.customization_menu.first,
   language.default_language.customization_menu.last};

	customization_menu.damage_meter_UI_total_damage_location_types = {
		language.current_language.customization_menu.first,
		language.current_language.customization_menu.last};

	customization_menu.damage_meter_UI_sorting_types = {language.default_language.customization_menu.normal,
                                                     language.default_language.customization_menu.damage,
                                                     language.default_language.customization_menu.dps};
	customization_menu.damage_meter_UI_dps_modes = {language.default_language.customization_menu.first_hit,
                                                 language.default_language.customization_menu.quest_time,
                                                 language.default_language.customization_menu.join_time};

	customization_menu.auto_highlight_modes = {language.default_language.customization_menu.closest,
                                                 language.default_language.customization_menu.farthest,
                                                 language.default_language.customization_menu.lowest_health,
                                                 language.default_language.customization_menu.highest_health,
                                                 language.default_language.customization_menu.lowest_health_percentage,
                                                 language.default_language.customization_menu.highest_health_percentage};
end

function customization_menu.draw()
	imgui.set_next_window_pos(customization_menu.window_position, 1 << 3, customization_menu.window_pivot);
	imgui.set_next_window_size(customization_menu.window_size, 1 << 3);
	
	customization_menu.is_opened = imgui.begin_window(
		language.current_language.customization_menu.mod_name .. " v" .. config.current_config.version, customization_menu.is_opened,
		customization_menu.window_flags);

	if not customization_menu.is_opened then
		imgui.end_window();
		return;
	end

	imgui.push_font(customization_menu.font);

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
	local apply_font_requested = false;

	local status_string = tostring(customization_menu.status);

	imgui.text(language.current_language.customization_menu.status .. ": " .. status_string);

	config_changed, apply_font_requested = customization_menu.draw_config();
	modules_changed = customization_menu.draw_modules();
	customization_menu.draw_hotkeys();
	global_settings_changed, modifiers_changed, apply_font_requested, language_changed = customization_menu.draw_global_settings(apply_font_requested, config_changed);
	small_monster_UI_changed = customization_menu.draw_small_monster_UI();

	if imgui.tree_node(language.current_language.customization_menu.large_monster_UI) then
		large_monster_dynamic_UI_changed = customization_menu.draw_large_monster_dynamic_UI()
		large_monster_static_UI_changed = customization_menu.draw_large_monster_static_UI()
		large_monster_highlighted_UI_changed = customization_menu.draw_large_monster_highlighted_UI()
		imgui.tree_pop();
	end

	time_UI_changed = customization_menu.draw_time_UI();
	damage_meter_UI_changed = customization_menu.draw_damage_meter_UI();
	endemic_life_UI_changed = customization_menu.draw_endemic_life_UI()

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

	if customization_menu.menu_font_changed and (apply_font_requested or config_changed) then
		customization_menu.menu_font_changed = false;
		customization_menu.reload_font(false);
	end

	if modules_changed or global_settings_changed or small_monster_UI_changed or large_monster_dynamic_UI_changed or
		large_monster_static_UI_changed or large_monster_highlighted_UI_changed or time_UI_changed or damage_meter_UI_changed or
		endemic_life_UI_changed or modifiers_changed or config_changed then
		config.save_current();
	end
end

function customization_menu.draw_config()
	local index = 1;
	local changed = false;
	local config_changed = false;
	local apply_font_requested = false;
	
	if imgui.tree_node(language.current_language.customization_menu.config) then
		
		changed, index = imgui.combo(language.current_language.customization_menu.config,
			table_helpers.find_index(config.config_names, config.current_config_name), config.config_names);
		config_changed = config_changed or changed;

		if changed then
			config.current_config_name = config.config_names[index];
			config.update(index);

			language.update(table_helpers.find_index(language.language_names, config.current_config.global_settings.language, false));
			
			customization_menu.init();

			customization_menu.menu_font_changed = true;
			apply_font_requested = true;
		end
			
		changed, customization_menu.config_name_input = imgui.input_text(language.current_language.customization_menu.config_name, customization_menu.config_name_input);

		changed = imgui.button(language.current_language.customization_menu.new);
		if changed then
			if customization_menu.config_name_input ~= "" then
				config.new(customization_menu.config_name_input);
				config_changed = config_changed or changed;

				language.update(table_helpers.find_index(language.language_names, config.current_config.global_settings.language, false));
			
				customization_menu.init();

				customization_menu.menu_font_changed = true;
				apply_font_requested = true;
			end
			
		end

		imgui.same_line();

		changed =	imgui.button(language.current_language.customization_menu.duplicate);
		if changed then
			if customization_menu.config_name_input ~= "" then
				config.duplicate(customization_menu.config_name_input);
				config_changed = config_changed or changed;

				language.update(table_helpers.find_index(language.language_names, config.current_config.global_settings.language, false));
			
				customization_menu.init();

				customization_menu.menu_font_changed = true;
				apply_font_requested = true;
			end
			
		end

		imgui.same_line();

		changed = imgui.button(language.current_language.customization_menu.reset);
		config_changed = config_changed or changed;
		if changed then
				config.reset();

				language.update(table_helpers.find_index(language.language_names, config.current_config.global_settings.language, false));
			
				customization_menu.init();

				customization_menu.menu_font_changed = true;
				apply_font_requested = true;
			end

		imgui.tree_pop();
	end

	return config_changed, apply_font_requested;
end

function customization_menu.draw_modules()
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
		imgui.tree_pop();
	end

	return config_changed;
end

function customization_menu.draw_hotkeys()
	if imgui.tree_node(language.current_language.customization_menu.hotkeys) then
		if customization_menu.all_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.all_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.all_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.all_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.all_UI.alt = false;
				customization_menu.all_UI_waiting_for_key = false;
			end

		elseif imgui.button(language.current_language.customization_menu.all_UI) then
			local is_any_other_waiting = customization_menu.small_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_dynamic_UI_waiting_for_key or
				                             customization_menu.large_monster_static_UI_waiting_for_key or
				                             customization_menu.large_monster_highlighted_UI_waiting_for_key or
				                             customization_menu.time_UI_waiting_for_key or
				                             customization_menu.damage_meter_UI_waiting_for_key or
				                             customization_menu.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				customization_menu.all_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.all_UI));
		if customization_menu.small_monster_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI.alt = false;
				customization_menu.small_monster_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.small_monster_UI) then
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key or
				                             customization_menu.large_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_dynamic_UI_waiting_for_key or
				                             customization_menu.large_monster_static_UI_waiting_for_key or
				                             customization_menu.large_monster_highlighted_UI_waiting_for_key or
				                             customization_menu.time_UI_waiting_for_key or
				                             customization_menu.damage_meter_UI_waiting_for_key or
				                             customization_menu.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				customization_menu.small_monster_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI));
		if customization_menu.large_monster_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI.alt = false;
				customization_menu.large_monster_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_UI) then
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key or
				                             customization_menu.small_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_dynamic_UI_waiting_for_key or
				                             customization_menu.large_monster_static_UI_waiting_for_key or
				                             customization_menu.large_monster_highlighted_UI_waiting_for_key or
				                             customization_menu.time_UI_waiting_for_key or
				                             customization_menu.damage_meter_UI_waiting_for_key or
				                             customization_menu.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				customization_menu.large_monster_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI));
		if customization_menu.large_monster_dynamic_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI.alt = false;
				customization_menu.large_monster_dynamic_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_dynamic_UI) then
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key or
				                             customization_menu.small_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_static_UI_waiting_for_key or
				                             customization_menu.large_monster_highlighted_UI_waiting_for_key or
				                             customization_menu.time_UI_waiting_for_key or
				                             customization_menu.damage_meter_UI_waiting_for_key or
				                             customization_menu.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				customization_menu.large_monster_dynamic_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers
			                                    .large_monster_dynamic_UI));
		if customization_menu.large_monster_static_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.alt = false;
				customization_menu.large_monster_static_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_static_UI) then
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key or
				                             customization_menu.small_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_dynamic_UI_waiting_for_key or
				                             customization_menu.large_monster_highlighted_UI_waiting_for_key or
				                             customization_menu.time_UI_waiting_for_key or
				                             customization_menu.damage_meter_UI_waiting_for_key or
				                             customization_menu.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				customization_menu.large_monster_static_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers
			                                    .large_monster_static_UI));
		if customization_menu.large_monster_highlighted_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.alt = false;
				customization_menu.large_monster_highlighted_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_highlighted_UI) then
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key or
				                             customization_menu.small_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_dynamic_UI_waiting_for_key or
				                             customization_menu.large_monster_static_UI_waiting_for_key or
				                             customization_menu.time_UI_waiting_for_key or
				                             customization_menu.damage_meter_UI_waiting_for_key or
				                             customization_menu.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				customization_menu.large_monster_highlighted_UI_waiting_for_key = true;
			end
		end
		imgui.same_line();
		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers
			                                    .large_monster_highlighted_UI));
		if customization_menu.time_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.alt = false;
				customization_menu.time_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.time_UI) then
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key or
				                             customization_menu.small_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_dynamic_UI_waiting_for_key or
				                             customization_menu.large_monster_static_UI_waiting_for_key or
				                             customization_menu.large_monster_highlighted_UI_waiting_for_key or
				                             customization_menu.damage_meter_UI_waiting_for_key or
				                             customization_menu.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				customization_menu.time_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.time_UI));
		if customization_menu.damage_meter_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI.alt = false;
				customization_menu.damage_meter_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.damage_meter_UI) then
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key or
				                             customization_menu.small_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_dynamic_UI_waiting_for_key or
				                             customization_menu.large_monster_static_UI_waiting_for_key or
				                             customization_menu.large_monster_highlighted_UI_waiting_for_key or
				                             customization_menu.time_UI_waiting_for_key or
				                             customization_menu.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				customization_menu.damage_meter_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI));
		if customization_menu.endemic_life_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI.alt = false;
				customization_menu.endemic_life_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.endemic_life_UI) then
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key or
				                             customization_menu.small_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_UI_waiting_for_key or
				                             customization_menu.large_monster_dynamic_UI_waiting_for_key or
				                             customization_menu.large_monster_static_UI_waiting_for_key or
				                             customization_menu.large_monster_highlighted_UI_waiting_for_key or
				                             customization_menu.time_UI_waiting_for_key or
				                             customization_menu.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				customization_menu.endemic_life_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI));
		imgui.tree_pop();
	end
end

function customization_menu.draw_global_settings(apply_font_requested, language_changed)
	local changed = false;
	local config_changed = false;
	local modifiers_changed = false;

	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.global_settings) then
		local cached_config = config.current_config.global_settings;

		imgui.text(language.current_language.customization_menu.menu_font_change_disclaimer);

		changed, index = imgui.combo(language.current_language.customization_menu.language .. "*",
			table_helpers.find_index(language.language_names, cached_config.language), language.language_names);
		config_changed = config_changed or changed;

		if changed then
			cached_config.language = language.language_names[index];
			language.update(index);
			customization_menu.init();

			language_changed = true;
			customization_menu.menu_font_changed = true;
			modifiers_changed = true;
			apply_font_requested = true;
		end

		if imgui.tree_node(language.current_language.customization_menu.menu_font) then
			local new_value = cached_config.menu_font.size;
			changed, new_value = imgui.input_text(" ", cached_config.menu_font.size, customization_menu.decimal_input_flags);
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
			customization_menu.menu_font_changed = customization_menu.menu_font_changed or changed;

			imgui.same_line();

			changed = imgui.button("-");
			config_changed = config_changed or changed;

			imgui.same_line();

			if changed then
				cached_config.menu_font.size = cached_config.menu_font.size - 1;

				if cached_config.menu_font.size < 5 then
					cached_config.menu_font.size = 5;
				else
					customization_menu.menu_font_changed = customization_menu.menu_font_changed or changed;
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
					customization_menu.menu_font_changed = customization_menu.menu_font_changed or changed;
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
				table_helpers.find_index(customization_menu.fonts, cached_config.UI_font.family), customization_menu.fonts);
			config_changed = config_changed or changed;

			if changed then
				cached_config.UI_font.family = customization_menu.fonts[index];
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

function customization_menu.draw_small_monster_UI()
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
				table_helpers.find_index(customization_menu.orientation_types, cached_config.settings.orientation),
				customization_menu.displayed_orientation_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.orientation = customization_menu.orientation_types[index];
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

			changed, index = imgui.combo(language.current_language.customization_menu.anchor, table_helpers.find_index(
				customization_menu.anchor_types, cached_config.static_position.anchor), customization_menu.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.static_position.anchor = customization_menu.anchor_types[index];
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
			changed, index = imgui.combo(language.current_language.customization_menu.type, table_helpers.find_index(
				customization_menu.monster_UI_sorting_types, cached_config.static_sorting.type),
				customization_menu.displayed_monster_UI_sorting_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.static_sorting.type = customization_menu.monster_UI_sorting_types[index];
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

function customization_menu.draw_large_monster_dynamic_UI()
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

function customization_menu.draw_large_monster_static_UI()
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
				table_helpers.find_index(customization_menu.damage_meter_UI_my_damage_bar_location_types, cached_config.settings.highlighted_monster_location),
				customization_menu.displayed_damage_meter_UI_my_damage_bar_location_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.highlighted_monster_location = customization_menu.damage_meter_UI_my_damage_bar_location_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.orientation,
				table_helpers.find_index( customization_menu.orientation_types, cached_config.settings.orientation),
				customization_menu.displayed_orientation_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.orientation = customization_menu.orientation_types[index];
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
				table_helpers.find_index(customization_menu.anchor_types, cached_config.position.anchor),
				customization_menu.displayed_anchor_types);
			
			config_changed = config_changed or changed;
			
			if changed then
				cached_config.position.anchor = customization_menu.anchor_types[index];
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
				table_helpers.find_index(customization_menu.monster_UI_sorting_types, cached_config.sorting.type),
				customization_menu.displayed_monster_UI_sorting_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = customization_menu.monster_UI_sorting_types[index];
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

function customization_menu.draw_large_monster_highlighted_UI()
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
				table_helpers.find_index(customization_menu.anchor_types, cached_config.position.anchor),
				customization_menu.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.position.anchor = customization_menu.anchor_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.auto_highlight) then
			changed, cached_config.auto_highlight.enabled = imgui.checkbox(
				language.current_language.customization_menu.enabled, cached_config.auto_highlight.enabled);
	
			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.mode,
				table_helpers.find_index(customization_menu.auto_highlight_modes, cached_config.auto_highlight.mode),
				customization_menu.displayed_auto_highlight_modes);

			config_changed = config_changed or changed;

			if changed then
				cached_config.auto_highlight.mode = customization_menu.auto_highlight_modes[index];
			end

			imgui.tree_pop();
		end

		changed = large_monster_UI_customization.draw(cached_config);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function customization_menu.draw_time_UI()
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
				table_helpers.find_index(customization_menu.anchor_types, cached_config.position.anchor),
				customization_menu.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.position.anchor = customization_menu.anchor_types[index];
			end

			imgui.tree_pop();
		end

		changed = label_customization.draw(language.current_language.customization_menu.time_label, cached_config.time_label);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function customization_menu.draw_damage_meter_UI()
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
				table_helpers.find_index(customization_menu.orientation_types, cached_config.settings.orientation),
				customization_menu.displayed_orientation_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.orientation = customization_menu.orientation_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.highlighted,
				table_helpers.find_index(customization_menu.damage_meter_UI_highlighted_entity_types, cached_config.settings.highlighted_bar),
				customization_menu.displayed_damage_meter_UI_highlighted_entity_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.highlighted_bar = customization_menu.damage_meter_UI_highlighted_entity_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.damage_bars_are_relative_to,
				table_helpers.find_index(customization_menu.damage_meter_UI_damage_bar_relative_types, cached_config.settings.damage_bar_relative_to),
				customization_menu.displayed_damage_meter_UI_damage_bar_relative_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.damage_bar_relative_to = customization_menu.damage_meter_UI_damage_bar_relative_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.my_damage_bar_location,
				table_helpers.find_index(customization_menu.damage_meter_UI_my_damage_bar_location_types, cached_config.settings.my_damage_bar_location),
				customization_menu.displayed_damage_meter_UI_my_damage_bar_location_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.my_damage_bar_location = customization_menu.damage_meter_UI_my_damage_bar_location_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.total_damage_location,
				table_helpers.find_index(customization_menu.damage_meter_UI_total_damage_location_types, cached_config.settings.total_damage_location),
				customization_menu.displayed_damage_meter_UI_total_damage_location_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.total_damage_location = customization_menu.damage_meter_UI_total_damage_location_types[index];
			end

			changed, index = imgui.combo(language.current_language.customization_menu.dps_mode, 
				table_helpers.find_index(customization_menu.damage_meter_UI_dps_modes, cached_config.settings.dps_mode),
				customization_menu.displayed_damage_meter_UI_dps_modes);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.dps_mode = customization_menu.damage_meter_UI_dps_modes[index];
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

			changed, cached_config.tracked_damage_types.player_damage = imgui.checkbox(
				language.current_language.customization_menu.player_damage, cached_config.tracked_damage_types.player_damage);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.bomb_damage = imgui.checkbox(
				language.current_language.customization_menu.bomb_damage, cached_config.tracked_damage_types.bomb_damage);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.kunai_damage = imgui.checkbox(
				language.current_language.customization_menu.kunai_damage, cached_config.tracked_damage_types.kunai_damage);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.installation_damage = imgui.checkbox(
				language.current_language.customization_menu.installation_damage, cached_config.tracked_damage_types.installation_damage);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.otomo_damage = imgui.checkbox(
				language.current_language.customization_menu.otomo_damage, cached_config.tracked_damage_types.otomo_damage);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.wyvern_riding_damage = imgui.checkbox(
				language.current_language.customization_menu.wyvern_riding_damage, cached_config.tracked_damage_types.wyvern_riding_damage);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.poison_damage = imgui.checkbox(
				language.current_language.customization_menu.poison_damage, cached_config.tracked_damage_types.poison_damage);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.blast_damage = imgui.checkbox(
				language.current_language.customization_menu.blast_damage, cached_config.tracked_damage_types.blast_damage);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.endemic_life_damage = imgui.checkbox(
				language.current_language.customization_menu.endemic_life_damage, cached_config.tracked_damage_types.endemic_life_damage);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.other_damage = imgui.checkbox(
				language.current_language.customization_menu.other_damage, cached_config.tracked_damage_types.other_damage);

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
				table_helpers.find_index(customization_menu.anchor_types, cached_config.position.anchor),
				customization_menu.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.position.anchor = customization_menu.anchor_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(
				language.current_language.customization_menu.type,
				table_helpers.find_index(customization_menu.damage_meter_UI_sorting_types, cached_config.sorting.type),
				customization_menu.displayed_damage_meter_UI_sorting_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = customization_menu.damage_meter_UI_sorting_types[index];
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

function customization_menu.draw_endemic_life_UI()
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

function customization_menu.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
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

	customization_menu.init();
	customization_menu.reload_font(false);
end

return customization_menu;