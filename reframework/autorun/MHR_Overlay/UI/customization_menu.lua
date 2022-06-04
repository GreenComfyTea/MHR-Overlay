local customization_menu = {};

local table_helpers;
local config;
local screen;
local player;
local large_monster;
local small_monster;
local env_creature;
local language;
local part_names;
local time_UI;
local keyboard;

customization_menu.font = nil;
customization_menu.font_range = { 0x1, 0xFFFF, 0 };

customization_menu.is_opened = false;
customization_menu.status = "OK";

customization_menu.window_position = Vector2f.new(480, 200);
customization_menu.window_pivot = Vector2f.new(0, 0);
customization_menu.window_size = Vector2f.new(720, 720);
customization_menu.window_flags = 0x10120;

customization_menu.color_picker_flags = 327680;

customization_menu.selected_language_index = 1;

customization_menu.displayed_orientation_types = {};
customization_menu.displayed_anchor_types = {};
customization_menu.displayed_ailments_sorting_types = {};

customization_menu.displayed_monster_UI_sorting_types = {};
customization_menu.displayed_monster_UI_parts_sorting_types = {};

customization_menu.displayed_ailment_buildups_sorting_types = {};
customization_menu.displayed_highlighted_buildup_bar_types = {};
customization_menu.displayed_buildup_bar_relative_types = {};

customization_menu.displayed_damage_meter_UI_highlighted_bar_types = {};
customization_menu.displayed_damage_meter_UI_damage_bar_relative_types = {};
customization_menu.displayed_damage_meter_UI_my_damage_bar_location_types = {};
customization_menu.displayed_damage_meter_UI_sorting_types = {};

customization_menu.orientation_types = {};
customization_menu.anchor_types = {};

customization_menu.monster_UI_sorting_types = {};
customization_menu.ailments_sorting_types = {};

customization_menu.ailment_buildups_sorting_types = {};
customization_menu.highlighted_buildup_bar_types = {};
customization_menu.buildup_bar_relative_types = {};

customization_menu.damage_meter_UI_highlighted_bar_types = {};
customization_menu.damage_meter_UI_damage_bar_relative_types = {};
customization_menu.damage_meter_UI_my_damage_bar_location_types = {};
customization_menu.damage_meter_UI_sorting_types = {};
customization_menu.damage_meter_UI_dps_modes = {};

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
                            "Trebuchet MS", "Verdana", "Webdings", "Wingdings", "Yu Gothic"};

customization_menu.small_monster_UI_orientation_index = 1;
customization_menu.small_monster_UI_sorting_type_index = 1;
customization_menu.small_monster_UI_ailments_sorting_type_index = 1;
customization_menu.small_monster_UI_ailment_buildups_sorting_type_index = 1;
customization_menu.small_monster_UI_highlighted_buildup_bar_index = 1;
customization_menu.small_monster_UI_buildup_bar_relative_index = 1;

customization_menu.large_monster_UI_orientation_index = 1;
customization_menu.large_monster_UI_sorting_type_index = 1;
customization_menu.large_monster_UI_highlighted_monster_location_index = 1;

customization_menu.large_monster_dynamic_UI_parts_sorting_type_index = 1;
customization_menu.large_monster_static_UI_parts_sorting_type_index = 1;
customization_menu.large_monster_highlighted_UI_parts_sorting_type_index = 1;

customization_menu.large_monster_dynamic_UI_ailments_sorting_type_index = 1;
customization_menu.large_monster_static_UI_ailments_sorting_type_index = 1;
customization_menu.large_monster_highlighted_UI_ailments_sorting_type_index = 1;

customization_menu.large_monster_dynamic_UI_ailment_buildups_sorting_type_index = 1;
customization_menu.large_monster_static_UI_ailment_buildups_sorting_type_index = 1;
customization_menu.large_monster_highlighted_UI_ailment_buildups_sorting_type_index = 1;

customization_menu.large_monster_dynamic_UI_highlighted_buildup_bar_index = 1;
customization_menu.large_monster_static_UI_highlighted_buildup_bar_index = 1;
customization_menu.large_monster_highlighted_UI_highlighted_buildup_bar_index = 1;

customization_menu.large_monster_dynamic_UI_buildup_bar_relative_index = 1;
customization_menu.large_monster_static_UI_buildup_bar_relative_index = 1;
customization_menu.large_monster_highlighted_UI_buildup_bar_relative_index = 1;

customization_menu.damage_meter_UI_orientation_index = 1;
customization_menu.damage_meter_UI_sorting_type_index = 1;
customization_menu.damage_meter_UI_highlighted_bar_index = 1;
customization_menu.damage_meter_UI_damage_bar_relative_index = 1;
customization_menu.damage_meter_UI_my_damage_bar_location_index = 1;
customization_menu.damage_meter_UI_dps_mode_index = 1;

customization_menu.small_monster_UI_anchor_index = 1;
customization_menu.large_monster_UI_anchor_index = 1;
customization_menu.time_UI_anchor_index = 1;
customization_menu.damage_meter_UI_anchor_index = 1;

customization_menu.selected_UI_font_index = 9;

customization_menu.all_UI_waiting_for_key = false;

customization_menu.small_monster_UI_waiting_for_key = false;

customization_menu.large_monster_UI_waiting_for_key = false;
customization_menu.large_monster_dynamic_UI_waiting_for_key = false;
customization_menu.large_monster_static_UI_waiting_for_key = false;
customization_menu.large_monster_highlighted_UI_waiting_for_key = false;

customization_menu.time_UI_waiting_for_key = false;
customization_menu.damage_meter_UI_waiting_for_key = false;
customization_menu.endemic_life_UI_waiting_for_key = false;

function customization_menu.reload_font(pop_push)
	local success, new_font = pcall(imgui.load_font, language.current_language.font_name, config.current_config.global_settings.menu_font.size, customization_menu.font_range);
	if success then
		if pop_push then
			imgui.pop_font(customization_menu.font);
		end

		customization_menu.font = new_font;

		if pop_push then
			imgui.push_font(customization_menu.font);
		end
	end
end

function customization_menu.init()
	customization_menu.reload_font(false);

	customization_menu.selected_language_index = table_helpers.find_index(language.language_names, config.current_config.global_settings.language, false);

	customization_menu.displayed_orientation_types = {language.current_language.customization_menu.horizontal, language.current_language.customization_menu.vertical};
	customization_menu.displayed_anchor_types = {language.current_language.customization_menu.top_left, language.current_language.customization_menu.top_right, language.current_language.customization_menu.bottom_left, language.current_language.customization_menu.bottom_right};
	
	customization_menu.displayed_monster_UI_sorting_types = {language.current_language.customization_menu.normal, language.current_language.customization_menu.health, language.current_language.customization_menu.health_percentage, language.current_language.customization_menu.distance};
	customization_menu.displayed_monster_UI_parts_sorting_types = {language.current_language.customization_menu.normal, language.current_language.customization_menu.health, language.current_language.customization_menu.health_percentage};
	customization_menu.displayed_ailments_sorting_types = {language.current_language.customization_menu.normal, language.current_language.customization_menu.buildup, language.current_language.customization_menu.buildup_percentage};


	customization_menu.displayed_ailment_buildups_sorting_types = {language.current_language.customization_menu.normal, language.current_language.customization_menu.buildup, language.current_language.customization_menu.buildup_percentage};
	customization_menu.displayed_highlighted_buildup_bar_types = {language.current_language.customization_menu.me, language.current_language.customization_menu.top_buildup,language.current_language.customization_menu.none};
	customization_menu.displayed_buildup_bar_relative_types =  {language.current_language.customization_menu.total_buildup, language.current_language.customization_menu.top_buildup};


	customization_menu.displayed_damage_meter_UI_highlighted_bar_types = {language.current_language.customization_menu.me, language.current_language.customization_menu.top_damage, language.current_language.customization_menu.top_dps, language.current_language.customization_menu.none};
	customization_menu.displayed_damage_meter_UI_damage_bar_relative_types = {language.current_language.customization_menu.total_damage, language.current_language.customization_menu.top_damage};
	customization_menu.displayed_damage_meter_UI_my_damage_bar_location_types = {language.current_language.customization_menu.normal, language.current_language.customization_menu.first, language.current_language.customization_menu.last};
	customization_menu.displayed_damage_meter_UI_sorting_types = {language.current_language.customization_menu.normal, language.current_language.customization_menu.damage, language.current_language.customization_menu.dps};
	customization_menu.displayed_damage_meter_UI_dps_modes = {language.current_language.customization_menu.first_hit, language.current_language.customization_menu.quest_time, language.current_language.customization_menu.join_time};




	customization_menu.orientation_types = {language.default_language.customization_menu.horizontal, language.default_language.customization_menu.vertical};
	customization_menu.anchor_types = {language.default_language.customization_menu.top_left, language.default_language.customization_menu.top_right, language.default_language.customization_menu.bottom_left, language.default_language.customization_menu.bottom_right};
	
	customization_menu.monster_UI_sorting_types = {language.default_language.customization_menu.normal, language.default_language.customization_menu.health, language.default_language.customization_menu.health_percentage, language.default_language.customization_menu.distance};
	customization_menu.large_monster_UI_parts_sorting_types = {language.default_language.customization_menu.normal, language.default_language.customization_menu.health, language.default_language.customization_menu.health_percentage};
	customization_menu.ailments_sorting_types = {language.default_language.customization_menu.normal, language.default_language.customization_menu.buildup, language.default_language.customization_menu.buildup_percentage};
	

	customization_menu.ailment_buildups_sorting_types = {language.default_language.customization_menu.normal, language.default_language.customization_menu.buildup, language.default_language.customization_menu.buildup_percentage};
	customization_menu.highlighted_buildup_bar_types = {language.default_language.customization_menu.me, language.default_language.customization_menu.top_buildup,language.default_language.customization_menu.none};
	customization_menu.buildup_bar_relative_types = {language.default_language.customization_menu.total_buildup, language.default_language.customization_menu.top_buildup};

	customization_menu.damage_meter_UI_highlighted_bar_types = {language.default_language.customization_menu.me, language.default_language.customization_menu.top_damage, language.default_language.customization_menu.top_dps, language.default_language.customization_menu.none};
	customization_menu.damage_meter_UI_damage_bar_relative_types = {language.default_language.customization_menu.total_damage, language.default_language.customization_menu.top_damage};
	customization_menu.damage_meter_UI_my_damage_bar_location_types = {language.default_language.customization_menu.normal, language.default_language.customization_menu.first, language.default_language.customization_menu.last};
	customization_menu.damage_meter_UI_sorting_types = {language.default_language.customization_menu.normal, language.default_language.customization_menu.damage, language.default_language.customization_menu.dps};
	customization_menu.damage_meter_UI_dps_modes = {language.default_language.customization_menu.first_hit, language.default_language.customization_menu.quest_time, language.default_language.customization_menu.join_time};



	customization_menu.selected_UI_font_index = table_helpers.find_index(customization_menu.fonts, config.current_config.global_settings.UI_font.family, false);

	customization_menu.small_monster_UI_orientation_index = table_helpers.find_index(customization_menu.orientation_types,
		config.current_config.small_monster_UI.settings.orientation, false);

	customization_menu.small_monster_UI_sorting_type_index = table_helpers.find_index(customization_menu.monster_UI_sorting_types,
	config.current_config.small_monster_UI.static_sorting.type, false);

	customization_menu.small_monster_UI_ailments_sorting_type_index = table_helpers.find_index(customization_menu.ailments_sorting_types,
	config.current_config.small_monster_UI.ailments.sorting.type, false);

	customization_menu.small_monster_UI_ailment_buildups_sorting_type_index = table_helpers.find_index(customization_menu.ailment_buildups_sorting_types,
	config.current_config.small_monster_UI.ailment_buildups.sorting.type, false);
	customization_menu.small_monster_UI_highlighted_buildup_bar_index = table_helpers.find_index(customization_menu.highlighted_buildup_bar_types,
	config.current_config.small_monster_UI.ailment_buildups.settings.highlighted_bar, false);
	customization_menu.small_monster_UI_buildup_bar_relative_index = table_helpers.find_index(customization_menu.buildup_bar_relative_types,
	config.current_config.small_monster_UI.ailment_buildups.settings.buildup_bar_relative_to, false);


	customization_menu.large_monster_UI_orientation_index = table_helpers.find_index(customization_menu.orientation_types,
		config.current_config.large_monster_UI.static.settings.orientation, false);

	customization_menu.large_monster_UI_sorting_type_index = table_helpers.find_index(
		customization_menu.monster_UI_sorting_types, config.current_config.large_monster_UI.static.sorting.type, false);

	customization_menu.large_monster_UI_highlighted_monster_location_index = table_helpers.find_index(
		customization_menu.damage_meter_UI_my_damage_bar_location_types, config.current_config.large_monster_UI.static.settings.highlighted_monster_location, false);

	customization_menu.large_monster_dynamic_UI_parts_sorting_type_index = table_helpers.find_index(
		customization_menu.large_monster_UI_parts_sorting_types,
		config.current_config.large_monster_UI.dynamic.parts.sorting.type, false);

	customization_menu.large_monster_static_UI_parts_sorting_type_index = table_helpers.find_index(
		customization_menu.large_monster_UI_parts_sorting_types,
		config.current_config.large_monster_UI.static.parts.sorting.type, false);

	customization_menu.large_monster_highlighted_UI_parts_sorting_type_index = table_helpers.find_index(
		customization_menu.large_monster_UI_parts_sorting_types,
		config.current_config.large_monster_UI.highlighted.parts.sorting.type, false);



	customization_menu.large_monster_dynamic_UI_ailments_sorting_type_index = table_helpers.find_index(
		customization_menu.ailments_sorting_types,
		config.current_config.large_monster_UI.dynamic.ailments.sorting.type, false);

	customization_menu.large_monster_static_UI_ailments_sorting_type_index = table_helpers.find_index(
		customization_menu.ailments_sorting_types,
		config.current_config.large_monster_UI.static.ailments.sorting.type, false);

	customization_menu.large_monster_highlighted_UI_ailments_sorting_type_index = table_helpers.find_index(
		customization_menu.ailments_sorting_types,
		config.current_config.large_monster_UI.highlighted.ailments.sorting.type, false);	



	customization_menu.large_monster_dynamic_UI_ailment_buildups_sorting_type_index = table_helpers.find_index(customization_menu.ailment_buildups_sorting_types,
	config.current_config.large_monster_UI.dynamic.ailment_buildups.sorting.type, false);
	customization_menu.large_monster_static_UI_ailment_buildups_sorting_type_index = table_helpers.find_index(customization_menu.ailment_buildups_sorting_types,
	config.current_config.large_monster_UI.static.ailment_buildups.sorting.type, false);
	customization_menu.large_monster_highlighted_UI_ailment_buildups_sorting_type_index = table_helpers.find_index(customization_menu.ailment_buildups_sorting_types,
	config.current_config.large_monster_UI.highlighted.ailment_buildups.sorting.type, false);


	customization_menu.large_monster_dynamic_UI_highlighted_buildup_bar_index = table_helpers.find_index(customization_menu.highlighted_buildup_bar_types,
	config.current_config.large_monster_UI.dynamic.ailment_buildups.settings.highlighted_bar, false);
	customization_menu.large_monster_static_UI_highlighted_buildup_bar_index = table_helpers.find_index(customization_menu.highlighted_buildup_bar_types,
	config.current_config.large_monster_UI.static.ailment_buildups.settings.highlighted_bar, false);
	customization_menu.large_monster_highlighted_UI_highlighted_buildup_bar_index = table_helpers.find_index(customization_menu.highlighted_buildup_bar_types,
	config.current_config.large_monster_UI.highlighted.ailment_buildups.settings.highlighted_bar, false);

	customization_menu.large_monster_dynamic_UI_buildup_bar_relative_index = table_helpers.find_index(customization_menu.buildup_bar_relative_types,
	config.current_config.large_monster_UI.dynamic.ailment_buildups.settings.buildup_bar_relative_to, false);
	customization_menu.large_monster_static_UI_buildup_bar_relative_index = table_helpers.find_index(customization_menu.buildup_bar_relative_types,
	config.current_config.large_monster_UI.static.ailment_buildups.settings.buildup_bar_relative_to, false);
	customization_menu.large_monster_highlighted_UI_buildup_bar_relative_index = table_helpers.find_index(customization_menu.buildup_bar_relative_types,
	config.current_config.large_monster_UI.highlighted.ailment_buildups.settings.buildup_bar_relative_to, false);



	customization_menu.damage_meter_UI_orientation_index = table_helpers.find_index(customization_menu.orientation_types,
		config.current_config.damage_meter_UI.settings.orientation, false);

	customization_menu.damage_meter_UI_highlighted_bar_index = table_helpers.find_index(
		customization_menu.damage_meter_UI_highlighted_bar_types,
		config.current_config.damage_meter_UI.settings.highlighted_bar, false);

	customization_menu.damage_meter_UI_damage_bar_relative_index = table_helpers.find_index(
		customization_menu.damage_meter_UI_damage_bar_relative_types,
		config.current_config.damage_meter_UI.settings.damage_bar_relative_to, false);

	customization_menu.damage_meter_UI_my_damage_bar_location_index = table_helpers.find_index(
		customization_menu.damage_meter_UI_my_damage_bar_location_types,
		config.current_config.damage_meter_UI.settings.my_damage_bar_location, false);

	customization_menu.damage_meter_UI_sorting_type_index = table_helpers.find_index(
		customization_menu.damage_meter_UI_sorting_types, config.current_config.damage_meter_UI.sorting.type, false);

	customization_menu.damage_meter_UI_dps_mode_index = table_helpers.find_index(
		customization_menu.damage_meter_UI_dps_modes, config.current_config.damage_meter_UI.settings.dps_mode, false);
	


	customization_menu.selected_font_index = table_helpers.find_index(customization_menu.fonts,
		config.current_config.global_settings.UI_font.family, false);

	customization_menu.small_monster_UI_anchor_index = table_helpers.find_index(customization_menu.anchor_types,
		config.current_config.small_monster_UI.static_position.anchor, false);

	customization_menu.large_monster_UI_anchor_index = table_helpers.find_index(customization_menu.anchor_types,
		config.current_config.large_monster_UI.static.position.anchor, false);

	customization_menu.time_UI_anchor_index = table_helpers.find_index(customization_menu.anchor_types,
		config.current_config.time_UI.position.anchor, false);

	customization_menu.damage_meter_UI_anchor_index = table_helpers.find_index(customization_menu.anchor_types,
		config.current_config.damage_meter_UI.position.anchor, false);

end

function customization_menu.draw()
	imgui.set_next_window_pos(customization_menu.window_position, 1 << 3, customization_menu.window_pivot);
	imgui.set_next_window_size(customization_menu.window_size, 1 << 3);

	imgui.push_font(customization_menu.font);
	
	customization_menu.is_opened = imgui.begin_window(language.current_language.customization_menu.mod_name .. " " .. config.current_config.version, customization_menu.is_opened, customization_menu.window_flags);

	if not customization_menu.is_opened then
		return;
	end

	local config_changed = false;
	local changed = false;

	local modifiers_changed = false;
	local small_monster_UI_changed = false;
	local large_monster_dynamic_UI_changed = false;
	local large_monster_static_UI_changed = false;
	local large_monster_highlighted_UI_changed = false;
	local time_UI_changed = false;
	local damage_meter_UI_changed = false;
	local endemic_life_UI_changed = false;

	local status_string = tostring(customization_menu.status);
	imgui.text(language.current_language.customization_menu.status .. ": " .. status_string);

	if imgui.tree_node(language.current_language.customization_menu.modules) then
		changed, config.current_config.small_monster_UI.enabled = imgui.checkbox(language.current_language.customization_menu.small_monster_UI, config.current_config
			.small_monster_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.large_monster_UI.dynamic.enabled =
			imgui.checkbox(language.current_language.customization_menu.large_monster_dynamic_UI, config.current_config.large_monster_UI.dynamic.enabled);
		config_changed = config_changed or changed;

		

		changed, config.current_config.large_monster_UI.static.enabled =
			imgui.checkbox(language.current_language.customization_menu.large_monster_static_UI, config.current_config.large_monster_UI.static.enabled);
		config_changed = config_changed or changed;

		
		changed, config.current_config.large_monster_UI.highlighted.enabled =
			imgui.checkbox(language.current_language.customization_menu.large_monster_highlighted_UI, config.current_config.large_monster_UI.highlighted.enabled);
		config_changed = config_changed or changed;

	

		changed, config.current_config.time_UI.enabled = imgui.checkbox(language.current_language.customization_menu.time_UI, config.current_config.time_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.damage_meter_UI.enabled = imgui.checkbox(language.current_language.customization_menu.damage_meter_UI,
			config.current_config.damage_meter_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.endemic_life_UI.enabled = imgui.checkbox(language.current_language.customization_menu.endemic_life_UI,
			config.current_config.endemic_life_UI.enabled);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

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
			local is_any_other_waiting = customization_menu.small_monster_UI_waiting_for_key
			or customization_menu.large_monster_UI_waiting_for_key
			or customization_menu.large_monster_dynamic_UI_waiting_for_key
			or customization_menu.large_monster_static_UI_waiting_for_key
			or customization_menu.large_monster_highlighted_UI_waiting_for_key
			or customization_menu.time_UI_waiting_for_key
			or customization_menu.damage_meter_UI_waiting_for_key
			or customization_menu.endemic_life_UI_waiting_for_key;

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
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key
			or customization_menu.large_monster_UI_waiting_for_key
			or customization_menu.large_monster_dynamic_UI_waiting_for_key
			or customization_menu.large_monster_static_UI_waiting_for_key
			or customization_menu.large_monster_highlighted_UI_waiting_for_key
			or customization_menu.time_UI_waiting_for_key
			or customization_menu.damage_meter_UI_waiting_for_key
			or customization_menu.endemic_life_UI_waiting_for_key;

			

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
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key
			or customization_menu.small_monster_UI_waiting_for_key
			or customization_menu.large_monster_dynamic_UI_waiting_for_key
			or customization_menu.large_monster_static_UI_waiting_for_key
			or customization_menu.large_monster_highlighted_UI_waiting_for_key
			or customization_menu.time_UI_waiting_for_key
			or customization_menu.damage_meter_UI_waiting_for_key
			or customization_menu.endemic_life_UI_waiting_for_key;

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
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key
			or customization_menu.small_monster_UI_waiting_for_key
			or customization_menu.large_monster_UI_waiting_for_key
			or customization_menu.large_monster_static_UI_waiting_for_key
			or customization_menu.large_monster_highlighted_UI_waiting_for_key
			or customization_menu.time_UI_waiting_for_key
			or customization_menu.damage_meter_UI_waiting_for_key
			or customization_menu.endemic_life_UI_waiting_for_key;

			if not is_any_other_waiting then 
				customization_menu.large_monster_dynamic_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();
		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI));



		if customization_menu.large_monster_static_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.alt = false;
				customization_menu.large_monster_static_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_static_UI) then
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key
			or customization_menu.small_monster_UI_waiting_for_key
			or customization_menu.large_monster_UI_waiting_for_key
			or customization_menu.large_monster_dynamic_UI_waiting_for_key
			or customization_menu.large_monster_highlighted_UI_waiting_for_key
			or customization_menu.time_UI_waiting_for_key
			or customization_menu.damage_meter_UI_waiting_for_key
			or customization_menu.endemic_life_UI_waiting_for_key;

			if not is_any_other_waiting then 
				customization_menu.large_monster_static_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();
		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI));



		if customization_menu.large_monster_highlighted_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.alt = false;
				customization_menu.large_monster_highlighted_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_highlighted_UI) then
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key
			or customization_menu.small_monster_UI_waiting_for_key
			or customization_menu.large_monster_UI_waiting_for_key
			or customization_menu.large_monster_dynamic_UI_waiting_for_key
			or customization_menu.large_monster_static_UI_waiting_for_key
			or customization_menu.time_UI_waiting_for_key
			or customization_menu.damage_meter_UI_waiting_for_key
			or customization_menu.endemic_life_UI_waiting_for_key;

			if not is_any_other_waiting then 
				customization_menu.large_monster_highlighted_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();
		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI));



		if customization_menu.time_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.alt = false;
				customization_menu.time_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.time_UI) then
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key
			or customization_menu.small_monster_UI_waiting_for_key
			or customization_menu.large_monster_UI_waiting_for_key
			or customization_menu.large_monster_dynamic_UI_waiting_for_key
			or customization_menu.large_monster_static_UI_waiting_for_key
			or customization_menu.large_monster_highlighted_UI_waiting_for_key
			or customization_menu.damage_meter_UI_waiting_for_key
			or customization_menu.endemic_life_UI_waiting_for_key;

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
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key
			or customization_menu.small_monster_UI_waiting_for_key
			or customization_menu.large_monster_UI_waiting_for_key
			or customization_menu.large_monster_dynamic_UI_waiting_for_key
			or customization_menu.large_monster_static_UI_waiting_for_key
			or customization_menu.large_monster_highlighted_UI_waiting_for_key
			or customization_menu.time_UI_waiting_for_key
			or customization_menu.endemic_life_UI_waiting_for_key;

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
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key
			or customization_menu.small_monster_UI_waiting_for_key
			or customization_menu.large_monster_UI_waiting_for_key
			or customization_menu.large_monster_dynamic_UI_waiting_for_key
			or customization_menu.large_monster_static_UI_waiting_for_key
			or customization_menu.large_monster_highlighted_UI_waiting_for_key
			or customization_menu.time_UI_waiting_for_key
			or customization_menu.endemic_life_UI_waiting_for_key;

			if not is_any_other_waiting then 
				customization_menu.endemic_life_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();
		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI));



		imgui.tree_pop();
	end

	if imgui.tree_node(language.current_language.customization_menu.global_settings) then
		changed, customization_menu.selected_language_index = imgui.combo(language.current_language.customization_menu.language, customization_menu.selected_language_index, language.language_names);
		config_changed = config_changed or changed;
		if changed then
			config.current_config.global_settings.language = language.language_names[customization_menu.selected_language_index];
			language.update(customization_menu.selected_language_index);

			imgui.pop_font(customization_menu.font);
			customization_menu.init();
			imgui.push_font(customization_menu.font);

			part_names.init();
			large_monster.init_list();

			for _, monster in pairs(small_monster.list) do
				small_monster.init_UI(monster);
			end

			for _, _player in pairs(player.list) do
				player.init_UI(_player);
			end
		end

		if imgui.tree_node(language.current_language.customization_menu.menu_font) then
			changed, config.current_config.global_settings.menu_font.size =
			imgui.slider_int(" ", config.current_config.global_settings.menu_font.size, 5, 100);
			config_changed = config_changed or changed;
			imgui.same_line();

			if changed then
				customization_menu.reload_font(true);
			end

			changed = imgui.button("-");
			config_changed = config_changed or changed;
			imgui.same_line();

			if changed then
				config.current_config.global_settings.menu_font.size = config.current_config.global_settings.menu_font.size - 1;
				if config.current_config.global_settings.menu_font.size < 5 then
					config.current_config.global_settings.menu_font.size = 5;
				else
					customization_menu.reload_font(true);
				end	
			end

			changed = imgui.button("+");
			config_changed = config_changed or changed;
			imgui.same_line();

			if changed then
				config.current_config.global_settings.menu_font.size = config.current_config.global_settings.menu_font.size + 1;
				if config.current_config.global_settings.menu_font.size > 100 then
					config.current_config.global_settings.menu_font.size = 100;
				else
					customization_menu.reload_font(true);
				end
			end

			imgui.text(language.current_language.customization_menu.size);

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.UI_font) then
			imgui.text(language.current_language.customization_menu.UI_font_notice);

			changed, customization_menu.selected_UI_font_index = imgui.combo(language.current_language.customization_menu.family, customization_menu.selected_UI_font_index,
				customization_menu.fonts);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.global_settings.UI_font.family = customization_menu.fonts[customization_menu.selected_UI_font_index];
			end

			changed, config.current_config.global_settings.UI_font.size =
				imgui.slider_int(language.current_language.customization_menu.size, config.current_config.global_settings.UI_font.size, 1, 100);
			config_changed = config_changed or changed;

			changed, config.current_config.global_settings.UI_font.bold =
				imgui.checkbox(language.current_language.customization_menu.bold, config.current_config.global_settings.UI_font.bold);
			config_changed = config_changed or changed;

			changed, config.current_config.global_settings.UI_font.italic =
				imgui.checkbox(language.current_language.customization_menu.italic, config.current_config.global_settings.UI_font.italic);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end
		
		if imgui.tree_node(language.current_language.customization_menu.modifiers) then
			changed, config.current_config.global_settings.modifiers.global_position_modifier =
			imgui.drag_float(language.current_language.customization_menu.global_position_modifier, config.current_config.global_settings.modifiers.global_position_modifier, 0.01, 0.01, 10, "%.1f");
			config_changed = config_changed or changed;
			modifiers_changed = modifiers_changed or changed;

			changed, config.current_config.global_settings.modifiers.global_scale_modifier =
			imgui.drag_float(language.current_language.customization_menu.global_scale_modifier, config.current_config.global_settings.modifiers.global_scale_modifier, 0.01, 0.01, 10, "%.1f");
			config_changed = config_changed or changed;
			modifiers_changed = modifiers_changed or changed;

			imgui.tree_pop();
		end
	
		if imgui.tree_node(language.current_language.customization_menu.performance) then
			changed, config.current_config.global_settings.performance.max_monster_updates_per_tick =
				imgui.slider_int(language.current_language.customization_menu.max_monster_updates_per_tick, config.current_config.global_settings.performance.max_monster_updates_per_tick, 1, 150);
			config_changed = config_changed or changed;

			changed, config.current_config.global_settings.performance.prioritize_large_monsters = imgui.checkbox(
				language.current_language.customization_menu.prioritize_large_monsters, config.current_config.global_settings.performance.prioritize_large_monsters);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end
		

		if imgui.tree_node(language.current_language.customization_menu.module_visibility_on_different_screens) then

			if imgui.tree_node(language.current_language.customization_menu.during_quest) then
				changed, config.current_config.global_settings.module_visibility.during_quest.small_monster_UI = imgui.checkbox(
					language.current_language.customization_menu.small_monster_UI, config.current_config.global_settings.module_visibility.during_quest.small_monster_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.during_quest.large_monster_dynamic_UI =
					imgui.checkbox(language.current_language.customization_menu.large_monster_dynamic_UI,
						config.current_config.global_settings.module_visibility.during_quest.large_monster_dynamic_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.during_quest.large_monster_static_UI =
					imgui.checkbox(language.current_language.customization_menu.large_monster_static_UI,
						config.current_config.global_settings.module_visibility.during_quest.large_monster_static_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.during_quest.large_monster_highlighted_UI =
					imgui.checkbox(language.current_language.customization_menu.large_monster_highlighted_UI,
						config.current_config.global_settings.module_visibility.during_quest.large_monster_highlighted_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.during_quest.time_UI = imgui.checkbox(language.current_language.customization_menu.time_UI,
					config.current_config.global_settings.module_visibility.during_quest.time_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.during_quest.damage_meter_UI = imgui.checkbox(
					language.current_language.customization_menu.damage_meter_UI, config.current_config.global_settings.module_visibility.during_quest.damage_meter_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.during_quest.endemic_life_UI = imgui.checkbox(
					language.current_language.customization_menu.endemic_life_UI, config.current_config.global_settings.module_visibility.during_quest.endemic_life_UI);
				config_changed = config_changed or changed;


				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.quest_result_screen) then
				changed, config.current_config.global_settings.module_visibility.quest_result_screen.small_monster_UI =
					imgui.checkbox(language.current_language.customization_menu.small_monster_UI,
						config.current_config.global_settings.module_visibility.quest_result_screen.small_monster_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.quest_result_screen.large_monster_dynamic_UI =
					imgui.checkbox(language.current_language.customization_menu.large_monster_dynamic_UI, config.current_config.global_settings.module_visibility
						.quest_result_screen.large_monster_dynamic_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.quest_result_screen.large_monster_static_UI =
					imgui.checkbox(language.current_language.customization_menu.large_monster_static_UI, config.current_config.global_settings.module_visibility
						.quest_result_screen.large_monster_static_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.quest_result_screen.large_monster_highlighted_UI =
					imgui.checkbox(language.current_language.customization_menu.large_monster_highlighted_UI, config.current_config.global_settings.module_visibility
						.quest_result_screen.large_monster_highlighted_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.quest_result_screen.time_UI = imgui.checkbox(
					language.current_language.customization_menu.time_UI, config.current_config.global_settings.module_visibility.quest_result_screen.time_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.quest_result_screen.damage_meter_UI =
					imgui.checkbox(language.current_language.customization_menu.damage_meter_UI,
						config.current_config.global_settings.module_visibility.quest_result_screen.damage_meter_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.during_quest.endemic_life_UI = imgui.checkbox(
					language.current_language.customization_menu.endemic_life_UI, config.current_config.global_settings.module_visibility.during_quest.endemic_life_UI);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.training_area) then
				changed, config.current_config.global_settings.module_visibility.training_area.large_monster_dynamic_UI =
					imgui.checkbox(language.current_language.customization_menu.large_monster_dynamic_UI,
						config.current_config.global_settings.module_visibility.training_area.large_monster_dynamic_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.training_area.large_monster_static_UI =
					imgui.checkbox(language.current_language.customization_menu.large_monster_static_UI,
						config.current_config.global_settings.module_visibility.training_area.large_monster_static_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.training_area.damage_meter_UI = imgui.checkbox(
					language.current_language.customization_menu.damage_meter_UI, config.current_config.global_settings.module_visibility.training_area.damage_meter_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.during_quest.endemic_life_UI = imgui.checkbox(
					language.current_language.customization_menu.endemic_life_UI, config.current_config.global_settings.module_visibility.during_quest.endemic_life_UI);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node(language.current_language.customization_menu.small_monster_UI) then
		changed, config.current_config.small_monster_UI.enabled = imgui.checkbox(language.current_language.customization_menu.enabled, config.current_config
			.small_monster_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, config.current_config.small_monster_UI.settings.hide_dead_or_captured = imgui.checkbox(language.current_language.customization_menu.hide_dead_or_captured, config.current_config
			.small_monster_UI.settings.hide_dead_or_captured);
			config_changed = config_changed or changed;

			changed, customization_menu.small_monster_UI_orientation_index =
				imgui.combo(language.current_language.customization_menu.static_orientation, customization_menu.small_monster_UI_orientation_index,
					customization_menu.displayed_orientation_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.small_monster_UI.settings.orientation =
					customization_menu.orientation_types[customization_menu.small_monster_UI_orientation_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.dynamic_positioning) then
			changed, config.current_config.small_monster_UI.dynamic_positioning.enabled = imgui.checkbox(language.current_language.customization_menu.enabled,
				config.current_config.small_monster_UI.dynamic_positioning.enabled);
			config_changed = config_changed or changed;

			changed, config.current_config.small_monster_UI.dynamic_positioning.opacity_falloff = imgui.checkbox(
				language.current_language.customization_menu.opacity_falloff, config.current_config.small_monster_UI.dynamic_positioning.opacity_falloff);
			config_changed = config_changed or changed;

			changed, config.current_config.small_monster_UI.dynamic_positioning.max_distance =
				imgui.drag_float(language.current_language.customization_menu.max_distance, config.current_config.small_monster_UI.dynamic_positioning.max_distance, 1, 0,
					10000, "%.0f");
			config_changed = config_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.world_offset) then
				changed, config.current_config.small_monster_UI.dynamic_positioning.world_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.small_monster_UI.dynamic_positioning.world_offset.x, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.small_monster_UI.dynamic_positioning.world_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.small_monster_UI.dynamic_positioning.world_offset.y, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.small_monster_UI.dynamic_positioning.world_offset.z = imgui.drag_float(language.current_language.customization_menu.z,
					config.current_config.small_monster_UI.dynamic_positioning.world_offset.z, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.viewport_offset) then
				changed, config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.x, 0.1, -screen.width, screen.width,
					"%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.y, 0.1, -screen.height, screen.height,
					"%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.static_position) then
			changed, config.current_config.small_monster_UI.static_position.x =
				imgui.drag_float(language.current_language.customization_menu.x, config.current_config.small_monster_UI.static_position.x, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.small_monster_UI.static_position.y =
				imgui.drag_float(language.current_language.customization_menu.y, config.current_config.small_monster_UI.static_position.y, 0.1, 0, screen.height, "%.1f");
			config_changed = config_changed or changed;

			changed, customization_menu.small_monster_UI_anchor_index = imgui.combo(language.current_language.customization_menu.anchor,
				customization_menu.small_monster_UI_anchor_index, customization_menu.displayed_anchor_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.small_monster_UI.static_position.anchor =
					customization_menu.anchor_types[customization_menu.small_monster_UI_anchor_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.static_spacing) then
			changed, config.current_config.small_monster_UI.static_spacing.x =
				imgui.drag_float(language.current_language.customization_menu.x, config.current_config.small_monster_UI.static_spacing.x, 0.1, -screen.width, screen.width,
					"%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.small_monster_UI.static_spacing.y =
				imgui.drag_float(language.current_language.customization_menu.y, config.current_config.small_monster_UI.static_spacing.y, 0.1, -screen.height, screen.height,
					"%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.static_sorting) then
			changed, customization_menu.small_monster_UI_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
				customization_menu.small_monster_UI_sorting_type_index, customization_menu.displayed_monster_UI_sorting_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.small_monster_UI.static_sorting.type =
					customization_menu.monster_UI_sorting_types[customization_menu.small_monster_UI_sorting_type_index];
			end

			changed, config.current_config.small_monster_UI.static_sorting.reversed_order =
				imgui.checkbox(language.current_language.customization_menu.reversed_order, config.current_config.small_monster_UI.static_sorting.reversed_order);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.monster_name_label) then
			changed, config.current_config.small_monster_UI.monster_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.small_monster_UI.monster_name_label.visibility);
			config_changed = config_changed or changed;
			small_monster_UI_changed = small_monster_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.small_monster_UI.monster_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.small_monster_UI.monster_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				changed, config.current_config.small_monster_UI.monster_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.small_monster_UI.monster_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, config.current_config.small_monster_UI.monster_name_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.monster_name_label.color, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, config.current_config.small_monster_UI.monster_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.monster_name_label.shadow.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.monster_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.monster_name_label.shadow.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.monster_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.monster_name_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.monster_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.monster_name_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.health) then
			changed, config.current_config.small_monster_UI.health.visibility =
				imgui.checkbox(language.current_language.customization_menu.visible, config.current_config.small_monster_UI.health.visibility);
			config_changed = config_changed or changed;
			small_monster_UI_changed = small_monster_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.text_label) then
				changed, config.current_config.small_monster_UI.health.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.health.text_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.health.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.health.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.health.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.health.text_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.health.text_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.text_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.health.text_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.small_monster_UI.health.text_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.health.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.small_monster_UI.health.text_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.health.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.small_monster_UI.health.text_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.health.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.text_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.value_label) then
				changed, config.current_config.small_monster_UI.health.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.health.value_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.health.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.health.value_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.health.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.health.value_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.health.value_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.value_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.health.value_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.small_monster_UI.health.value_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.health.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.small_monster_UI.health.value_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.health.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.small_monster_UI.health.value_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.health.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.value_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
				changed, config.current_config.small_monster_UI.health.percentage_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.health.percentage_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.health.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.health.percentage_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.health.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.health.percentage_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.health.percentage_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.percentage_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.health.percentage_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.health.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.health.percentage_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.small_monster_UI.health.percentage_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.health.percentage_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.small_monster_UI.health.percentage_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.health.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.percentage_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.bar) then
				changed, config.current_config.small_monster_UI.health.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.health.bar.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.health.bar.offset.x =
						imgui.drag_float(language.current_language.customization_menu.x, config.current_config.small_monster_UI.health.bar.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.health.bar.offset.y =
						imgui.drag_float(language.current_language.customization_menu.y, config.current_config.small_monster_UI.health.bar.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.size) then
					changed, config.current_config.small_monster_UI.health.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
						config.current_config.small_monster_UI.health.bar.size.width, 0.1, 0, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.health.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
						config.current_config.small_monster_UI.health.bar.size.height, 0.1, 0, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.colors) then
					if imgui.tree_node(language.current_language.customization_menu.foreground) then
						changed, config.current_config.small_monster_UI.health.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.bar.colors.foreground, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.background) then
						changed, config.current_config.small_monster_UI.health.bar.colors.background = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.bar.colors.background, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.stamina) then
			changed, config.current_config.small_monster_UI.stamina.visibility =
				imgui.checkbox(language.current_language.customization_menu.visible, config.current_config.small_monster_UI.stamina.visibility);
			config_changed = config_changed or changed;
			small_monster_UI_changed = small_monster_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.text_label) then
				changed, config.current_config.small_monster_UI.stamina.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.stamina.text_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.stamina.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.stamina.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.stamina.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.stamina.text_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.stamina.text_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.text_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.stamina.text_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.small_monster_UI.stamina.text_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.stamina.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.small_monster_UI.stamina.text_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.stamina.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.small_monster_UI.stamina.text_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.stamina.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.text_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.value_label) then
				changed, config.current_config.small_monster_UI.stamina.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.stamina.value_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.stamina.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.stamina.value_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.stamina.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.stamina.value_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.stamina.value_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.value_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.stamina.value_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.small_monster_UI.stamina.value_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.stamina.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.small_monster_UI.stamina.value_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.stamina.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.small_monster_UI.stamina.value_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.stamina.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.value_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
				changed, config.current_config.small_monster_UI.stamina.percentage_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.stamina.percentage_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.stamina.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.stamina.percentage_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.stamina.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.stamina.percentage_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.stamina.percentage_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.percentage_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.stamina.percentage_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.stamina.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.stamina.percentage_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.small_monster_UI.stamina.percentage_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.stamina.percentage_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.small_monster_UI.stamina.percentage_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.stamina.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.percentage_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.bar) then
				changed, config.current_config.small_monster_UI.stamina.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.stamina.bar.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.stamina.bar.offset.x =
						imgui.drag_float(language.current_language.customization_menu.x, config.current_config.small_monster_UI.stamina.bar.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.stamina.bar.offset.y =
						imgui.drag_float(language.current_language.customization_menu.y, config.current_config.small_monster_UI.stamina.bar.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.size) then
					changed, config.current_config.small_monster_UI.stamina.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
						config.current_config.small_monster_UI.stamina.bar.size.width, 0.1, 0, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.stamina.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
						config.current_config.small_monster_UI.stamina.bar.size.height, 0.1, 0, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.colors) then
					if imgui.tree_node(language.current_language.customization_menu.foreground) then
						changed, config.current_config.small_monster_UI.stamina.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.bar.colors.foreground, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.background) then
						changed, config.current_config.small_monster_UI.stamina.bar.colors.background = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.bar.colors.background, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.ailments) then
			changed, config.current_config.small_monster_UI.ailments.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.small_monster_UI.ailments.visibility);
			config_changed = config_changed or changed;
			small_monster_UI_changed = small_monster_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.small_monster_UI.ailments.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.small_monster_UI.ailments.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				changed, config.current_config.small_monster_UI.ailments.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.small_monster_UI.ailments.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.spacing) then
				changed, config.current_config.small_monster_UI.ailments.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.small_monster_UI.ailments.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				changed, config.current_config.small_monster_UI.ailments.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.small_monster_UI.ailments.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, config.current_config.small_monster_UI.ailments.settings.hide_ailments_with_zero_buildup = imgui.checkbox(
					language.current_language.customization_menu.hide_ailments_with_zero_buildup, config.current_config.small_monster_UI.ailments.settings.hide_ailments_with_zero_buildup);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				changed, config.current_config.small_monster_UI.ailments.settings.hide_inactive_ailments_with_no_buildup_support = imgui.checkbox(
					language.current_language.customization_menu.hide_inactive_ailments_with_no_buildup_support, config.current_config.small_monster_UI.ailments.settings.hide_inactive_ailments_with_no_buildup_support);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				changed, config.current_config.small_monster_UI.ailments.settings.hide_all_inactive_ailments = imgui.checkbox(
					language.current_language.customization_menu.hide_all_inactive_ailments, config.current_config.small_monster_UI.ailments.settings.hide_all_inactive_ailments);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				changed, config.current_config.small_monster_UI.ailments.settings.hide_all_active_ailments = imgui.checkbox(
					language.current_language.customization_menu.hide_all_active_ailments, config.current_config.small_monster_UI.ailments.settings.hide_all_active_ailments);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				changed, config.current_config.small_monster_UI.ailments.settings.hide_disabled_ailments = imgui.checkbox(
					language.current_language.customization_menu.hide_disabled_ailments, config.current_config.small_monster_UI.ailments.settings.hide_disabled_ailments);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				changed, config.current_config.small_monster_UI.ailments.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit,
				config.current_config.small_monster_UI.ailments.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, customization_menu.small_monster_UI_ailments_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
					customization_menu.small_monster_UI_ailments_sorting_type_index,
					customization_menu.ailments_sorting_types);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;
				if changed then
					config.current_config.small_monster_UI.ailments.sorting.type =
						customization_menu.ailments_sorting_types[customization_menu.small_monster_UI_ailments_sorting_type_index];
				end

				changed, config.current_config.small_monster_UI.ailments.sorting.reversed_order = imgui.checkbox(
					language.current_language.customization_menu.reversed_order, config.current_config.small_monster_UI.ailments.sorting.reversed_order);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
				changed, config.current_config.small_monster_UI.ailments.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.ailments.ailment_name_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, config.current_config.small_monster_UI.ailments.ailment_name_label.include.ailment_name = imgui.checkbox(
						language.current_language.customization_menu.ailment_name, config.current_config.small_monster_UI.ailments.ailment_name_label.include.ailment_name);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailments.ailment_name_label.include.activation_count = imgui.checkbox(
						language.current_language.customization_menu.activation_count, config.current_config.small_monster_UI.ailments.ailment_name_label.include.activation_count);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailments.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailments.ailment_name_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailments.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailments.ailment_name_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.ailments.ailment_name_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailments.ailment_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.ailments.ailment_name_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailments.ailment_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.ailments.ailment_name_label.shadow.offset.x = imgui.drag_float(
							language.current_language.customization_menu.x, config.current_config.small_monster_UI.ailments.ailment_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.ailments.ailment_name_label.shadow.offset.y = imgui.drag_float(
							language.current_language.customization_menu.y, config.current_config.small_monster_UI.ailments.ailment_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.ailments.ailment_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailments.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.text_label) then
				changed, config.current_config.small_monster_UI.ailments.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.ailments.text_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailments.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailments.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailments.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailments.text_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.ailments.text_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailments.text_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.ailments.text_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailments.text_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.ailments.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.small_monster_UI.ailments.text_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.ailments.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.small_monster_UI.ailments.text_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.ailments.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailments.text_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.value_label) then
				changed, config.current_config.small_monster_UI.ailments.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.ailments.value_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailments.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailments.value_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailments.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailments.value_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.ailments.value_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailments.value_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.ailments.value_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailments.value_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.ailments.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.small_monster_UI.ailments.value_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.ailments.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.small_monster_UI.ailments.value_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.ailments.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailments.value_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
				changed, config.current_config.small_monster_UI.ailments.percentage_label.visibility = imgui.checkbox(
					language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailments.percentage_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailments.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailments.percentage_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailments.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailments.percentage_label.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.ailments.percentage_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailments.percentage_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.ailments.percentage_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailments.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.ailments.percentage_label.shadow.offset.x = imgui.drag_float(
							language.current_language.customization_menu.x, config.current_config.small_monster_UI.ailments.percentage_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.ailments.percentage_label.shadow.offset.y = imgui.drag_float(
							language.current_language.customization_menu.y, config.current_config.small_monster_UI.ailments.percentage_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.ailments.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailments.percentage_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.timer_label) then
				changed, config.current_config.small_monster_UI.ailments.timer_label.visibility = imgui.checkbox(
					language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailments.timer_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailments.timer_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailments.timer_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailments.timer_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailments.timer_label.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.ailments.timer_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailments.timer_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.ailments.timer_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailments.timer_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.ailments.timer_label.shadow.offset.x = imgui.drag_float(
							language.current_language.customization_menu.x, config.current_config.small_monster_UI.ailments.timer_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.ailments.timer_label.shadow.offset.y = imgui.drag_float(
							language.current_language.customization_menu.y, config.current_config.small_monster_UI.ailments.timer_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.ailments.timer_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailments.timer_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.bar) then
				changed, config.current_config.small_monster_UI.ailments.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.ailments.bar.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailments.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailments.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailments.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailments.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.size) then
					changed, config.current_config.small_monster_UI.ailments.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
						config.current_config.small_monster_UI.ailments.bar.size.width, 0.1, 0, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailments.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
						config.current_config.small_monster_UI.ailments.bar.size.height, 0.1, 0, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.colors) then
					if imgui.tree_node(language.current_language.customization_menu.foreground) then
						changed, config.current_config.small_monster_UI.ailments.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailments.bar.colors.foreground, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.background) then
						changed, config.current_config.small_monster_UI.ailments.bar.colors.background = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailments.bar.colors.background, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.ailment_buildups) then
			changed, config.current_config.small_monster_UI.ailment_buildups.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.small_monster_UI.ailments.visibility);
			config_changed = config_changed or changed;
			small_monster_UI_changed = small_monster_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.small_monster_UI.ailment_buildups.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.small_monster_UI.ailment_buildups.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				changed, config.current_config.small_monster_UI.ailment_buildups.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.small_monster_UI.ailment_buildups.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.players_spacing) then
				changed, config.current_config.small_monster_UI.ailment_buildups.players_spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.small_monster_UI.ailment_buildups.players_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				changed, config.current_config.small_monster_UI.ailment_buildups.players_spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.small_monster_UI.ailment_buildups.players_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.ailments_spacing) then
				changed, config.current_config.small_monster_UI.ailment_buildups.ailments_spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.small_monster_UI.ailment_buildups.ailments_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				changed, config.current_config.small_monster_UI.ailment_buildups.ailments_spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.small_monster_UI.ailment_buildups.ailments_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, customization_menu.small_monster_UI_highlighted_buildup_bar_index =
				imgui.combo(language.current_language.customization_menu.highlighted_bar, customization_menu.small_monster_UI_highlighted_buildup_bar_index,
					customization_menu.displayed_highlighted_buildup_bar_types);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;
				if changed then
					config.current_config.small_monster_UI.ailment_buildups.settings.highlighted_bar =
						customization_menu.highlighted_buildup_bar_types[customization_menu.small_monster_UI_highlighted_buildup_bar_index];
				end

				changed, customization_menu.small_monster_UI_buildup_bar_relative_index =
				imgui.combo(language.current_language.customization_menu.buildup_bars_are_relative_to, customization_menu.small_monster_UI_buildup_bar_relative_index,
					customization_menu.displayed_buildup_bar_relative_types);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if changed then
					config.current_config.small_monster_UI.ailment_buildups.settings.buildup_bar_relative_to =
						customization_menu.displayed_buildup_bar_relative_types[customization_menu.small_monster_UI_damage_bar_relative_index];
				end
				
				changed, config.current_config.small_monster_UI.ailment_buildups.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit,
				config.current_config.small_monster_UI.ailment_buildups.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.filter) then
				changed, config.current_config.small_monster_UI.ailment_buildups.filter.stun = imgui.checkbox(language.current_language.ailments.stun,
				config.current_config.small_monster_UI.ailment_buildups.filter.stun);

				changed, config.current_config.small_monster_UI.ailment_buildups.filter.poison = imgui.checkbox(language.current_language.ailments.poison,
				config.current_config.small_monster_UI.ailment_buildups.filter.poison);

				changed, config.current_config.small_monster_UI.ailment_buildups.filter.blast = imgui.checkbox(language.current_language.ailments.blast,
				config.current_config.small_monster_UI.ailment_buildups.filter.blast);

				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, customization_menu.small_monster_UI_ailment_buildups_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
					customization_menu.small_monster_UI_ailment_buildups_sorting_type_index,
					customization_menu.ailment_buildups_sorting_types);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if changed then
					config.current_config.small_monster_UI.ailment_buildups.sorting.type =
						customization_menu.ailment_buildups_sorting_types[customization_menu.small_monster_UI_ailment_buildups_sorting_type_index];
				end

				changed, config.current_config.small_monster_UI.ailment_buildups.sorting.reversed_order = imgui.checkbox(
					language.current_language.customization_menu.reversed_order, config.current_config.small_monster_UI.ailment_buildups.sorting.reversed_order);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
				changed, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.include.ailment_name = imgui.checkbox(
						language.current_language.customization_menu.ailment_name, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.include.ailment_name);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.include.activation_count = imgui.checkbox(
						language.current_language.customization_menu.activation_count, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.include.activation_count);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.shadow.offset.x = imgui.drag_float(
							language.current_language.customization_menu.x, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.shadow.offset.y = imgui.drag_float(
							language.current_language.customization_menu.y, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.player_name_label) then
				changed, config.current_config.small_monster_UI.ailment_buildups.player_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.ailment_buildups.player_name_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailment_buildups.player_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailment_buildups.player_name_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailment_buildups.player_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailment_buildups.player_name_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.ailment_buildups.player_name_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.player_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.ailment_buildups.player_name_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailment_buildups.player_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.ailment_buildups.player_name_label.shadow.offset.x = imgui.drag_float(
							language.current_language.customization_menu.x, config.current_config.small_monster_UI.ailment_buildups.player_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.ailment_buildups.player_name_label.shadow.offset.y = imgui.drag_float(
							language.current_language.customization_menu.y, config.current_config.small_monster_UI.ailment_buildups.player_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.ailment_buildups.player_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.player_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.buildup_value_label) then
				changed, config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.buildup_value_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.buildup_percentage_label) then
				changed, config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.visibility = imgui.checkbox(
					language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.shadow.offset.x = imgui.drag_float(
							language.current_language.customization_menu.x, config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.shadow.offset.y = imgui.drag_float(
							language.current_language.customization_menu.y, config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.buildup_percentage_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.total_buildup_label) then
				changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.visibility = imgui.checkbox(
					language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.shadow.offset.x = imgui.drag_float(
							language.current_language.customization_menu.x, config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.shadow.offset.y = imgui.drag_float(
							language.current_language.customization_menu.y, config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.total_buildup_value_label) then
				changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.visibility = imgui.checkbox(
					language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.shadow.offset.x = imgui.drag_float(
							language.current_language.customization_menu.x, config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.shadow.offset.y = imgui.drag_float(
							language.current_language.customization_menu.y, config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.small_monster_UI.ailment_buildups.total_buildup_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.total_buildup_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.buildup_bar) then
				changed, config.current_config.small_monster_UI.ailment_buildups.buildup_bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.ailment_buildups.buildup_bar.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailment_buildups.buildup_bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailment_buildups.buildup_bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailment_buildups.buildup_bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailment_buildups.buildup_bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.size) then
					changed, config.current_config.small_monster_UI.ailment_buildups.buildup_bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
						config.current_config.small_monster_UI.ailment_buildups.buildup_bar.size.width, 0.1, 0, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailment_buildups.buildup_bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
						config.current_config.small_monster_UI.ailment_buildups.buildup_bar.size.height, 0.1, 0, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.colors) then
					if imgui.tree_node(language.current_language.customization_menu.foreground) then
						changed, config.current_config.small_monster_UI.ailment_buildups.buildup_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.buildup_bar.colors.foreground, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.background) then
						changed, config.current_config.small_monster_UI.ailment_buildups.buildup_bar.colors.background = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.buildup_bar.colors.background, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.highlighted_buildup_bar) then
				changed, config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.size) then
					changed, config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
						config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.size.width, 0.1, 0, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
						config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.size.height, 0.1, 0, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.colors) then
					if imgui.tree_node(language.current_language.customization_menu.foreground) then
						changed, config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.colors.foreground, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.background) then
						changed, config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.colors.background = imgui.color_picker_argb("", config.current_config.small_monster_UI.ailment_buildups.highlighted_buildup_bar.colors.background, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

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

	if imgui.tree_node(language.current_language.customization_menu.large_monster_UI) then
		if imgui.tree_node(language.current_language.customization_menu.dynamically_positioned) then
			changed, config.current_config.large_monster_UI.dynamic.enabled =
				imgui.checkbox(language.current_language.customization_menu.enabled, config.current_config.large_monster_UI.dynamic.enabled);
			config_changed = config_changed or changed;
			large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, config.current_config.large_monster_UI.dynamic.settings.hide_dead_or_captured = imgui.checkbox(language.current_language.customization_menu.hide_dead_or_captured, config.current_config.
				large_monster_UI.dynamic.settings.hide_dead_or_captured);
				config_changed = config_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic.settings.render_highlighted_monster = imgui.checkbox(language.current_language.customization_menu.render_highlighted_monster, config.current_config.
				large_monster_UI.dynamic.settings.render_highlighted_monster);
				config_changed = config_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic.settings.render_not_highlighted_monsters = imgui.checkbox(language.current_language.customization_menu.render_not_highlighted_monsters, config.current_config.
				large_monster_UI.dynamic.settings.render_not_highlighted_monsters);
				config_changed = config_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic.settings.opacity_falloff =
					imgui.checkbox(language.current_language.customization_menu.opacity_falloff, config.current_config.large_monster_UI.dynamic.settings.opacity_falloff);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic.settings.max_distance =
					imgui.drag_float(language.current_language.customization_menu.max_distance, config.current_config.large_monster_UI.dynamic.settings.max_distance, 1, 0, 10000,
						"%.0f");
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.world_offset) then
				changed, config.current_config.large_monster_UI.dynamic.world_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.large_monster_UI.dynamic.world_offset.x, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic.world_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.large_monster_UI.dynamic.world_offset.y, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic.world_offset.z = imgui.drag_float(language.current_language.customization_menu.z,
					config.current_config.large_monster_UI.dynamic.world_offset.z, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.viewport_offset) then
				changed, config.current_config.large_monster_UI.dynamic.viewport_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.large_monster_UI.dynamic.viewport_offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic.viewport_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.large_monster_UI.dynamic.viewport_offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.monster_name_label) then
				changed, config.current_config.large_monster_UI.dynamic.monster_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.dynamic.monster_name_label.visibility);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.include.monster_name = imgui.checkbox(
						language.current_language.customization_menu.monster_name, config.current_config.large_monster_UI.dynamic.monster_name_label.include.monster_name);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.include.crown = imgui.checkbox(language.current_language.customization_menu.crown,
						config.current_config.large_monster_UI.dynamic.monster_name_label.include.crown);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.include.size = imgui.checkbox(language.current_language.customization_menu.size,
						config.current_config.large_monster_UI.dynamic.monster_name_label.include.size);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.include.scrown_thresholds =
						imgui.checkbox(language.current_language.customization_menu.crown_thresholds,
							config.current_config.large_monster_UI.dynamic.monster_name_label.include.scrown_thresholds);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.dynamic.monster_name_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.dynamic.monster_name_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.monster_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.health) then
				changed, config.current_config.large_monster_UI.dynamic.health.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.dynamic.health.visibility);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.dynamic.health.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.dynamic.health.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.health.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.dynamic.health.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.dynamic.health.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.health.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.health.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.health.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.health.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.health.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.health.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.health.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.health.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.health.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.dynamic.health.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.health.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.dynamic.health.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.health.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.dynamic.health.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.health.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.health.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.health.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.health.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.health.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.health.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.health.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.health.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.health.value_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.health.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.health.value_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.health.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.health.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.health.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.health.percentage_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.health.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.visibility =
							imgui.checkbox(language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.offset.x =
								imgui.drag_float(language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.offset.x,
									0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.offset.y =
								imgui.drag_float(language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.offset.y,
									0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.dynamic.health.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.health.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.health.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.health.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.health.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.health.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.dynamic.health.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.dynamic.health.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.health.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.dynamic.health.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.dynamic.health.bar.normal_colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.bar.normal_colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.dynamic.health.bar.normal_colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.bar.normal_colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.monster_can_be_captured) then
							if imgui.tree_node(language.current_language.customization_menu.foreground) then
								changed, config.current_config.large_monster_UI.dynamic.health.bar.capture_colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.bar.capture_colors.foreground, customization_menu.color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

								imgui.tree_pop();
							end

							if imgui.tree_node(language.current_language.customization_menu.background) then
								changed, config.current_config.large_monster_UI.dynamic.health.bar.capture_colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.bar.capture_colors.background, customization_menu.color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

								imgui.tree_pop();
							end

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.capture_line) then
						changed, config.current_config.large_monster_UI.dynamic.health.bar.capture_line.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
							config.current_config.large_monster_UI.dynamic.health.bar.capture_line.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.health.bar.capture_line.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.dynamic.health.bar.capture_line.offset.x, 0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.health.bar.capture_line.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.dynamic.health.bar.capture_line.offset.y, 0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.size) then
							changed, config.current_config.large_monster_UI.dynamic.health.bar.capture_line.size.width = imgui.drag_float(language.current_language.customization_menu.width,
								config.current_config.large_monster_UI.dynamic.health.bar.capture_line.size.width, 0.1, 0, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.health.bar.capture_line.size.height = imgui.drag_float(language.current_language.customization_menu.height,
								config.current_config.large_monster_UI.dynamic.health.bar.capture_line.size.height, 0.1, 0, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.health.bar.capture_line.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.bar.capture_line.color, customization_menu.color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.stamina) then
				changed, config.current_config.large_monster_UI.dynamic.stamina.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.dynamic.stamina.visibility);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.dynamic.stamina.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.dynamic.stamina.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.stamina.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.dynamic.stamina.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.stamina.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.stamina.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.stamina.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.stamina.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.stamina.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.stamina.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.stamina.percentage_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.stamina.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.visibility =
							imgui.checkbox(language.current_language.customization_menu.visible,
								config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.offset.x =
								imgui.drag_float(language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.offset.x,
									0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.offset.y =
								imgui.drag_float(language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.offset.y,
									0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.dynamic.stamina.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.stamina.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.stamina.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.stamina.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.stamina.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.stamina.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.dynamic.stamina.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.dynamic.stamina.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.stamina.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.dynamic.stamina.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.dynamic.stamina.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.dynamic.stamina.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.rage) then
				changed, config.current_config.large_monster_UI.dynamic.rage.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.dynamic.rage.visibility);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.dynamic.rage.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.dynamic.rage.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.rage.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.dynamic.rage.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.dynamic.rage.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.rage.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.rage.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.rage.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.rage.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.rage.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.rage.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.dynamic.rage.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.rage.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.rage.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.rage.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.rage.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.rage.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.rage.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.rage.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.rage.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.rage.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.timer_label) then
					changed, config.current_config.large_monster_UI.dynamic.rage.timer_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.rage.timer_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.rage.timer_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.rage.timer_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.rage.timer_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.rage.timer_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.rage.timer_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.timer_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.rage.timer_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.rage.timer_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.rage.timer_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.rage.timer_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.rage.timer_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.rage.timer_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.rage.timer_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.timer_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.dynamic.rage.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.rage.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.rage.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.rage.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.rage.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.rage.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.dynamic.rage.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.dynamic.rage.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.rage.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.dynamic.rage.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.dynamic.rage.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.dynamic.rage.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.body_parts) then
				changed, config.current_config.large_monster_UI.dynamic.parts.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.dynamic.parts.visibility);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.dynamic.parts.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.dynamic.parts.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.parts.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.dynamic.parts.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.spacing) then
					changed, config.current_config.large_monster_UI.dynamic.parts.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.dynamic.parts.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.parts.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.dynamic.parts.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.settings) then
					changed, config.current_config.large_monster_UI.dynamic.parts.settings.hide_undamaged_parts = imgui.checkbox(
						language.current_language.customization_menu.hide_undamaged_parts, config.current_config.large_monster_UI.dynamic.parts.settings.hide_undamaged_parts);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.parts.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit,
					config.current_config.large_monster_UI.dynamic.parts.settings.time_limit, 0.1, 0, 99999, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.sorting) then
					changed, customization_menu.large_monster_dynamic_UI_parts_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
						customization_menu.large_monster_dynamic_UI_parts_sorting_type_index,
						customization_menu.displayed_monster_UI_parts_sorting_types);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
					if changed then
						config.current_config.large_monster_UI.dynamic.parts.sorting.type =
							customization_menu.large_monster_UI_parts_sorting_types[customization_menu.large_monster_dynamic_UI_parts_sorting_type_index];
					end

					changed, config.current_config.large_monster_UI.dynamic.parts.sorting.reversed_order = imgui.checkbox(
						language.current_language.customization_menu.reversed_order, config.current_config.large_monster_UI.dynamic.parts.sorting.reversed_order);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.part_name_label) then
					changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.parts.part_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.include) then
						changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.include.part_name = imgui.checkbox(
							language.current_language.customization_menu.part_name, config.current_config.large_monster_UI.dynamic.parts.part_name_label.include.part_name);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.include.flinch_count =
							imgui.checkbox(language.current_language.customization_menu.flinch_count,
								config.current_config.large_monster_UI.dynamic.parts.part_name_label.include.flinch_count);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.parts.part_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.parts.part_name_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.part_name_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.dynamic.parts.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.parts.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.parts.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.parts.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.parts.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.parts.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.dynamic.parts.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.parts.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.parts.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.parts.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.parts.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.parts.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.parts.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.parts.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.parts.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.offset.x =
								imgui.drag_float(language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.offset.x,
									0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.offset.y =
								imgui.drag_float(language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.offset.y,
									0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.dynamic.parts.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.parts.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.parts.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.parts.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.parts.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.dynamic.parts.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.dynamic.parts.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.dynamic.parts.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.dynamic.parts.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.dynamic.parts.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.ailments) then
				changed, config.current_config.large_monster_UI.dynamic.ailments.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.dynamic.ailments.visibility);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.dynamic.ailments.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.dynamic.ailments.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.dynamic.ailments.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.dynamic.ailments.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.relative_offset) then
					changed, config.current_config.large_monster_UI.dynamic.ailments.relative_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.dynamic.ailments.relative_offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.dynamic.ailments.relative_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.dynamic.ailments.relative_offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.spacing) then
					changed, config.current_config.large_monster_UI.dynamic.ailments.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.dynamic.ailments.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.dynamic.ailments.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.dynamic.ailments.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.settings) then
					changed, config.current_config.large_monster_UI.dynamic.ailments.settings.hide_ailments_with_zero_buildup = imgui.checkbox(
						language.current_language.customization_menu.hide_ailments_with_zero_buildup, config.current_config.large_monster_UI.dynamic.ailments.settings.hide_ailments_with_zero_buildup);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.dynamic.ailments.settings.hide_inactive_ailments_with_no_buildup_support = imgui.checkbox(
						language.current_language.customization_menu.hide_inactive_ailments_with_no_buildup_support, config.current_config.large_monster_UI.dynamic.ailments.settings.hide_inactive_ailments_with_no_buildup_support);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.dynamic.ailments.settings.hide_all_inactive_ailments = imgui.checkbox(
						language.current_language.customization_menu.hide_all_inactive_ailments, config.current_config.large_monster_UI.dynamic.ailments.settings.hide_all_inactive_ailments);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.dynamic.ailments.settings.hide_all_active_ailments = imgui.checkbox(
						language.current_language.customization_menu.hide_all_active_ailments, config.current_config.large_monster_UI.dynamic.ailments.settings.hide_all_active_ailments);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.dynamic.ailments.settings.hide_disabled_ailments = imgui.checkbox(
						language.current_language.customization_menu.hide_disabled_ailments, config.current_config.large_monster_UI.dynamic.ailments.settings.hide_disabled_ailments);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.ailments.settings.offset_is_relative_to_parts = imgui.checkbox(
						language.current_language.customization_menu.offset_is_relative_to_parts, config.current_config.large_monster_UI.dynamic.ailments.settings.offset_is_relative_to_parts);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.dynamic.ailments.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit,
					config.current_config.large_monster_UI.dynamic.ailments.settings.time_limit, 0.1, 0, 99999, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.sorting) then
					changed, customization_menu.small_monster_UI_ailments_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
						customization_menu.small_monster_UI_ailments_sorting_type_index,
						customization_menu.ailments_sorting_types);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
					if changed then
						config.current_config.large_monster_UI.dynamic.ailments.sorting.type =
							customization_menu.ailments_sorting_types[customization_menu.small_monster_UI_ailments_sorting_type_index];
					end
	
					changed, config.current_config.large_monster_UI.dynamic.ailments.sorting.reversed_order = imgui.checkbox(
						language.current_language.customization_menu.reversed_order, config.current_config.large_monster_UI.dynamic.ailments.sorting.reversed_order);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
					changed, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.include) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.include.ailment_name = imgui.checkbox(
							language.current_language.customization_menu.ailment_name, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.include.ailment_name);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.include.activation_count = imgui.checkbox(
							language.current_language.customization_menu.activation_count, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.include.activation_count);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.dynamic.ailments.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.ailments.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailments.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailments.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailments.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailments.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailments.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.ailments.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.dynamic.ailments.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.ailments.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.dynamic.ailments.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.ailments.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailments.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.dynamic.ailments.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.ailments.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailments.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailments.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailments.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailments.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailments.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.ailments.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.dynamic.ailments.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.ailments.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.dynamic.ailments.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.ailments.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailments.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.dynamic.ailments.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailments.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailments.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailments.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailments.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailments.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailments.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.ailments.percentage_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.ailments.percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.ailments.percentage_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.ailments.percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.ailments.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailments.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.timer_label) then
					changed, config.current_config.large_monster_UI.dynamic.ailments.timer_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailments.timer_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.timer_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailments.timer_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailments.timer_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailments.timer_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.timer_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailments.timer_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.timer_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailments.timer_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.ailments.timer_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.ailments.timer_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.ailments.timer_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.ailments.timer_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.ailments.timer_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailments.timer_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.dynamic.ailments.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.ailments.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailments.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailments.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailments.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.dynamic.ailments.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.dynamic.ailments.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailments.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.dynamic.ailments.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.dynamic.ailments.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailments.bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.dynamic.ailments.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailments.bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.ailment_buildups) then
				changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.dynamic.ailments.visibility);
				config_changed = config_changed or changed;
				large_monster_UI_changed = large_monster_UI_changed or changed;
	
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.dynamic.ailment_buildups.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.dynamic.ailment_buildups.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.players_spacing) then
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.players_spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.dynamic.ailment_buildups.players_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.players_spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.dynamic.ailment_buildups.players_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.ailments_spacing) then
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailments_spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.dynamic.ailment_buildups.ailments_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailments_spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.dynamic.ailment_buildups.ailments_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.settings) then
					changed, customization_menu.large_monster_dynamic_UI_highlighted_buildup_bar_index =
					imgui.combo(language.current_language.customization_menu.highlighted_bar, customization_menu.large_monster_dynamic_UI_highlighted_buildup_bar_index,
						customization_menu.displayed_highlighted_buildup_bar_types);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
					if changed then
						config.current_config.large_monster_UI.dynamic.ailment_buildups.settings.highlighted_bar =
							customization_menu.highlighted_buildup_bar_types[customization_menu.large_monster_dynamic_UI_highlighted_buildup_bar_index];
					end
	
					changed, customization_menu.large_monster_dynamic_UI_buildup_bar_relative_index =
					imgui.combo(language.current_language.customization_menu.buildup_bars_are_relative_to, customization_menu.large_monster_dynamic_UI_buildup_bar_relative_index,
						customization_menu.displayed_buildup_bar_relative_types);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if changed then
						config.current_config.large_monster_UI.dynamic.ailment_buildups.settings.buildup_bar_relative_to =
							customization_menu.displayed_buildup_bar_relative_types[customization_menu.large_monster_dynamic_UI_damage_bar_relative_index];
					end
					
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit,
					config.current_config.large_monster_UI.dynamic.ailment_buildups.settings.time_limit, 0.1, 0, 99999, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.filter) then
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.filter.stun = imgui.checkbox(language.current_language.ailments.stun,
					config.current_config.large_monster_UI.dynamic.ailment_buildups.filter.stun);
	
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.filter.poison = imgui.checkbox(language.current_language.ailments.poison,
					config.current_config.large_monster_UI.dynamic.ailment_buildups.filter.poison);
	
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.filter.blast = imgui.checkbox(language.current_language.ailments.blast,
					config.current_config.large_monster_UI.dynamic.ailment_buildups.filter.blast);
	
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.sorting) then
					changed, customization_menu.large_monster_dynamic_UI_ailment_buildups_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
						customization_menu.large_monster_dynamic_UI_ailment_buildups_sorting_type_index,
						customization_menu.ailment_buildups_sorting_types);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if changed then
						config.current_config.large_monster_UI.dynamic.ailment_buildups.sorting.type =
							customization_menu.ailment_buildups_sorting_types[customization_menu.large_monster_dynamic_UI_ailment_buildups_sorting_type_index];
					end
	
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.sorting.reversed_order = imgui.checkbox(
						language.current_language.customization_menu.reversed_order, config.current_config.large_monster_UI.dynamic.ailment_buildups.sorting.reversed_order);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.include) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.include.ailment_name = imgui.checkbox(
							language.current_language.customization_menu.ailment_name, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.include.ailment_name);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.include.activation_count = imgui.checkbox(
							language.current_language.customization_menu.activation_count, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.include.activation_count);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.player_name_label) then
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.player_name_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.buildup_value_label) then
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.buildup_percentage_label) then
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.total_buildup_label) then
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.total_buildup_value_label) then
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.total_buildup_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.buildup_bar) then
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.buildup_bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.highlighted_buildup_bar) then
					changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.ailment_buildups.highlighted_buildup_bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
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

		if imgui.tree_node(language.current_language.customization_menu.statically_positioned) then
			changed, config.current_config.large_monster_UI.static.enabled =
				imgui.checkbox(language.current_language.customization_menu.enabled, config.current_config.large_monster_UI.static.enabled);
			config_changed = config_changed or changed;
			large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, config.current_config.large_monster_UI.static.settings.hide_dead_or_captured = imgui.checkbox(language.current_language.customization_menu.hide_dead_or_captured, config.current_config.
				large_monster_UI.static.settings.hide_dead_or_captured);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				changed, config.current_config.large_monster_UI.static.settings.render_highlighted_monster = imgui.checkbox(language.current_language.customization_menu.render_highlighted_monster, config.current_config.
				large_monster_UI.static.settings.render_highlighted_monster);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				changed, config.current_config.large_monster_UI.static.settings.render_not_highlighted_monsters = imgui.checkbox(language.current_language.customization_menu.render_not_highlighted_monsters, config.current_config.
				large_monster_UI.static.settings.render_not_highlighted_monsters);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				changed, customization_menu.large_monster_UI_highlighted_monster_location_index =
				imgui.combo(language.current_language.customization_menu.highlighted_monster_location, customization_menu.large_monster_UI_highlighted_monster_location_index,
					customization_menu.displayed_damage_meter_UI_my_damage_bar_location_types);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
				if changed then
					config.current_config.large_monster_UI.static.settings.highlighted_monster_location =
						customization_menu.damage_meter_UI_my_damage_bar_location_types[customization_menu.large_monster_UI_highlighted_monster_location_index];
				end

				changed, customization_menu.large_monster_UI_orientation_index = imgui.combo(language.current_language.customization_menu.orientation,
					customization_menu.large_monster_UI_orientation_index, customization_menu.displayed_orientation_types);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
				if changed then
					config.current_config.large_monster_UI.static.settings.orientation =
						customization_menu.orientation_types[customization_menu.large_monster_UI_orientation_index];
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.position) then
				changed, config.current_config.large_monster_UI.static.position.x =
					imgui.drag_float(language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.position.x, 0.1, 0, screen.width, "%.1f");
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				changed, config.current_config.large_monster_UI.static.position.y =
					imgui.drag_float(language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.position.y, 0.1, 0, screen.height, "%.1f");
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				changed, customization_menu.large_monster_UI_anchor_index = imgui.combo(language.current_language.customization_menu.anchor,
					customization_menu.large_monster_UI_anchor_index, customization_menu.displayed_anchor_types);
				config_changed = config_changed or changed;
				if changed then
					config.current_config.large_monster_UI.static.position.anchor =
						customization_menu.anchor_types[customization_menu.large_monster_UI_anchor_index];
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.spacing) then
				changed, config.current_config.large_monster_UI.static.spacing.x =
					imgui.drag_float(language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.spacing.x, 0.1, -screen.width, screen.width,
						"%.1f");
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				changed, config.current_config.large_monster_UI.static.spacing.y =
					imgui.drag_float(language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.spacing.y, 0.1, -screen.height, screen.height,
						"%.1f");
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, customization_menu.large_monster_UI_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
					customization_menu.large_monster_UI_sorting_type_index, customization_menu.displayed_monster_UI_sorting_types);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
				if changed then
					config.current_config.large_monster_UI.static.sorting.type =
						customization_menu.monster_UI_sorting_types[customization_menu.large_monster_UI_sorting_type_index];
				end

				changed, config.current_config.large_monster_UI.static.sorting.reversed_order =
					imgui.checkbox(language.current_language.customization_menu.reversed_order, config.current_config.large_monster_UI.static.sorting.reversed_order);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.monster_name_label) then
				changed, config.current_config.large_monster_UI.static.monster_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.static.monster_name_label.visibility);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, config.current_config.large_monster_UI.static.monster_name_label.include.monster_name = imgui.checkbox(
						language.current_language.customization_menu.monster_name, config.current_config.large_monster_UI.static.monster_name_label.include.monster_name);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.monster_name_label.include.crown = imgui.checkbox(language.current_language.customization_menu.crown,
						config.current_config.large_monster_UI.static.monster_name_label.include.crown);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.monster_name_label.include.size = imgui.checkbox(language.current_language.customization_menu.size,
						config.current_config.large_monster_UI.static.monster_name_label.include.size);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.monster_name_label.include.scrown_thresholds =
						imgui.checkbox(language.current_language.customization_menu.crown_thresholds,
							config.current_config.large_monster_UI.static.monster_name_label.include.scrown_thresholds);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.static.monster_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.static.monster_name_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.monster_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.static.monster_name_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.large_monster_UI.static.monster_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.monster_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.large_monster_UI.static.monster_name_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.monster_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.monster_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.monster_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.monster_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.monster_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.monster_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.monster_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.health) then
				changed, config.current_config.large_monster_UI.static.health.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.static.health.visibility);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.static.health.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.static.health.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.health.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.static.health.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.static.health.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.health.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.health.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.health.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.health.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.health.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.health.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.health.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.health.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.health.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.static.health.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.health.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.static.health.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.health.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.static.health.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.health.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.health.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.health.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.health.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.health.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.health.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.health.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.health.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.health.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.static.health.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.health.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.static.health.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.health.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.static.health.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.health.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.health.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.health.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.health.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.health.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.health.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.health.percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.health.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.health.percentage_label.shadow.offset.x =
								imgui.drag_float(language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.health.percentage_label.shadow.offset.x,
									0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.health.percentage_label.shadow.offset.y =
								imgui.drag_float(language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.health.percentage_label.shadow.offset.y,
									0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.health.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.static.health.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.health.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.health.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.health.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.health.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.health.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.static.health.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.static.health.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.health.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.static.health.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.static.health.bar.normal_colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.bar.normal_colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.static.health.bar.normal_colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.bar.normal_colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.monster_can_be_captured) then
							if imgui.tree_node(language.current_language.customization_menu.foreground) then
								changed, config.current_config.large_monster_UI.static.health.bar.capture_colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.bar.capture_colors.foreground, customization_menu.color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

								imgui.tree_pop();
							end

							if imgui.tree_node(language.current_language.customization_menu.background) then
								changed, config.current_config.large_monster_UI.static.health.bar.capture_colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.bar.capture_colors.background, customization_menu.color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

								imgui.tree_pop();
							end

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.capture_line) then
						changed, config.current_config.large_monster_UI.static.health.bar.capture_line.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
							config.current_config.large_monster_UI.static.health.bar.capture_line.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.health.bar.capture_line.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.static.health.bar.capture_line.offset.x, 0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.health.bar.capture_line.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.static.health.bar.capture_line.offset.y, 0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.size) then
							changed, config.current_config.large_monster_UI.static.health.bar.capture_line.size.width = imgui.drag_float(language.current_language.customization_menu.width,
								config.current_config.large_monster_UI.static.health.bar.capture_line.size.width, 0.1, 0, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.health.bar.capture_line.size.height = imgui.drag_float(language.current_language.customization_menu.height,
								config.current_config.large_monster_UI.static.health.bar.capture_line.size.height, 0.1, 0, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.health.bar.capture_line.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.bar.capture_line.color, customization_menu.color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.stamina) then
				changed, config.current_config.large_monster_UI.static.stamina.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.static.stamina.visibility);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.static.stamina.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.static.stamina.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.stamina.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.static.stamina.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.static.stamina.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.stamina.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.stamina.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.stamina.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.stamina.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.stamina.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.stamina.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.stamina.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.stamina.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.stamina.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.static.stamina.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.stamina.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.static.stamina.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.stamina.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.static.stamina.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.stamina.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.stamina.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.stamina.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.stamina.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.stamina.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.stamina.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.stamina.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.stamina.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.stamina.value_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.stamina.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.stamina.value_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.stamina.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.stamina.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.static.stamina.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.stamina.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.stamina.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.stamina.percentage_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.stamina.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.stamina.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.stamina.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.visibility =
							imgui.checkbox(language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.offset.x =
								imgui.drag_float(language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.offset.x,
									0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.offset.y =
								imgui.drag_float(language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.offset.y,
									0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.static.stamina.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.stamina.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.stamina.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.stamina.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.stamina.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.stamina.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.static.stamina.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.static.stamina.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.stamina.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.static.stamina.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.static.stamina.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.static.stamina.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.rage) then
				changed, config.current_config.large_monster_UI.static.rage.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.static.rage.visibility);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.static.rage.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.static.rage.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.rage.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.static.rage.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.static.rage.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.rage.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.rage.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.rage.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.rage.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.rage.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.rage.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.rage.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.rage.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.rage.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.static.rage.text_label.shadow.offset.x, 0.1, -screen.width, screen.width,
								"%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.rage.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.static.rage.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.rage.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.static.rage.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.rage.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.rage.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.rage.value_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.rage.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.rage.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.rage.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.rage.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.rage.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.rage.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.static.rage.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.rage.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.static.rage.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.rage.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.static.rage.percentage_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.rage.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.rage.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.rage.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.rage.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.rage.percentage_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.rage.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.rage.percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.rage.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.rage.percentage_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.rage.percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.rage.percentage_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.rage.percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.rage.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.timer_label) then
					changed, config.current_config.large_monster_UI.static.rage.timer_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.rage.timer_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.rage.timer_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.rage.timer_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.rage.timer_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.rage.timer_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.rage.timer_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.timer_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.rage.timer_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.rage.timer_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.rage.timer_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.rage.timer_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.rage.timer_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.rage.timer_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.rage.timer_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.timer_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.static.rage.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.rage.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.rage.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.rage.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.rage.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.rage.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.static.rage.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.static.rage.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.rage.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.static.rage.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.static.rage.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.static.rage.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.body_parts) then
				changed, config.current_config.large_monster_UI.static.parts.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.static.parts.visibility);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.static.parts.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.static.parts.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.parts.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.static.parts.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.spacing) then
					changed, config.current_config.large_monster_UI.static.parts.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.static.parts.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.parts.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.static.parts.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.settings) then
					changed, config.current_config.large_monster_UI.static.parts.settings.hide_undamaged_parts = imgui.checkbox(
						language.current_language.customization_menu.hide_undamaged_parts, config.current_config.large_monster_UI.static.parts.settings.hide_undamaged_parts);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.parts.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit,
					config.current_config.large_monster_UI.static.parts.settings.time_limit, 0.1, 0, 99999, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.sorting) then
					changed, customization_menu.large_monster_static_UI_parts_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
						customization_menu.large_monster_static_UI_parts_sorting_type_index,
						customization_menu.displayed_monster_UI_parts_sorting_types);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
					if changed then
						config.current_config.large_monster_UI.static.parts.sorting.type =
							customization_menu.large_monster_UI_parts_sorting_types[customization_menu.large_monster_static_UI_parts_sorting_type_index];
					end

					changed, config.current_config.large_monster_UI.static.parts.sorting.reversed_order = imgui.checkbox(
						language.current_language.customization_menu.reversed_order, config.current_config.large_monster_UI.static.parts.sorting.reversed_order);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.part_name_label) then
					changed, config.current_config.large_monster_UI.static.parts.part_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.parts.part_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.include) then
						changed, config.current_config.large_monster_UI.static.parts.part_name_label.include.part_name = imgui.checkbox(
							language.current_language.customization_menu.part_name, config.current_config.large_monster_UI.static.parts.part_name_label.include.part_name);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.part_name_label.include.flinch_count = imgui.checkbox(
							language.current_language.customization_menu.flinch_count, config.current_config.large_monster_UI.static.parts.part_name_label.include.flinch_count);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.parts.part_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.parts.part_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.part_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.parts.part_name_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.parts.part_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.part_name_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.parts.part_name_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.parts.part_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.parts.part_name_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.parts.part_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.parts.part_name_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.parts.part_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.parts.part_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.part_name_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.static.parts.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.parts.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.parts.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.parts.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.parts.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.parts.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.parts.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.parts.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.parts.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.static.parts.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.parts.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.static.parts.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.parts.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.static.parts.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.parts.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.parts.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.parts.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.parts.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.parts.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.parts.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.parts.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.parts.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.static.parts.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.parts.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.static.parts.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.parts.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.static.parts.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.parts.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.parts.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.parts.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.parts.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.parts.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.parts.percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.parts.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.parts.percentage_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.parts.percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.parts.percentage_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.parts.percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.parts.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.static.parts.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.parts.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.parts.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.parts.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.parts.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.static.parts.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.static.parts.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.static.parts.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.static.parts.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.static.parts.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.ailments) then
				changed, config.current_config.large_monster_UI.static.ailments.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.static.ailments.visibility);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.static.ailments.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.static.ailments.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.static.ailments.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.static.ailments.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.relative_offset) then
					changed, config.current_config.large_monster_UI.static.ailments.relative_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.static.ailments.relative_offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.static.ailments.relative_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.static.ailments.relative_offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.spacing) then
					changed, config.current_config.large_monster_UI.static.ailments.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.static.ailments.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.static.ailments.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.static.ailments.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.settings) then
					changed, config.current_config.large_monster_UI.static.ailments.settings.hide_ailments_with_zero_buildup = imgui.checkbox(
						language.current_language.customization_menu.hide_ailments_with_zero_buildup, config.current_config.large_monster_UI.static.ailments.settings.hide_ailments_with_zero_buildup);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.static.ailments.settings.hide_inactive_ailments_with_no_buildup_support = imgui.checkbox(
						language.current_language.customization_menu.hide_inactive_ailments_with_no_buildup_support, config.current_config.large_monster_UI.static.ailments.settings.hide_inactive_ailments_with_no_buildup_support);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.static.ailments.settings.hide_all_inactive_ailments = imgui.checkbox(
						language.current_language.customization_menu.hide_all_inactive_ailments, config.current_config.large_monster_UI.static.ailments.settings.hide_all_inactive_ailments);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.static.ailments.settings.hide_all_active_ailments = imgui.checkbox(
						language.current_language.customization_menu.hide_all_active_ailments, config.current_config.large_monster_UI.static.ailments.settings.hide_all_active_ailments);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.static.ailments.settings.hide_disabled_ailments = imgui.checkbox(
						language.current_language.customization_menu.hide_disabled_ailments, config.current_config.large_monster_UI.static.ailments.settings.hide_disabled_ailments);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.ailments.settings.offset_is_relative_to_parts = imgui.checkbox(
						language.current_language.customization_menu.offset_is_relative_to_parts, config.current_config.large_monster_UI.static.ailments.settings.offset_is_relative_to_parts);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.static.ailments.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit,
					config.current_config.large_monster_UI.static.ailments.settings.time_limit, 0.1, 0, 99999, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.sorting) then
					changed, customization_menu.small_monster_UI_ailments_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
						customization_menu.small_monster_UI_ailments_sorting_type_index,
						customization_menu.ailments_sorting_types);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
					if changed then
						config.current_config.large_monster_UI.static.ailments.sorting.type =
							customization_menu.ailments_sorting_types[customization_menu.small_monster_UI_ailments_sorting_type_index];
					end
	
					changed, config.current_config.large_monster_UI.static.ailments.sorting.reversed_order = imgui.checkbox(
						language.current_language.customization_menu.reversed_order, config.current_config.large_monster_UI.static.ailments.sorting.reversed_order);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
					changed, config.current_config.large_monster_UI.static.ailments.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.ailments.ailment_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.include) then
						changed, config.current_config.large_monster_UI.static.ailments.ailment_name_label.include.ailment_name = imgui.checkbox(
							language.current_language.customization_menu.ailment_name, config.current_config.large_monster_UI.static.ailments.ailment_name_label.include.ailment_name);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailments.ailment_name_label.include.activation_count = imgui.checkbox(
							language.current_language.customization_menu.activation_count, config.current_config.large_monster_UI.static.ailments.ailment_name_label.include.activation_count);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailments.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailments.ailment_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailments.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailments.ailment_name_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.ailments.ailment_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailments.ailment_name_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.ailments.ailment_name_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailments.ailment_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.ailments.ailment_name_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.ailments.ailment_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.ailments.ailment_name_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.ailments.ailment_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.ailments.ailment_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailments.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.static.ailments.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.ailments.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailments.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailments.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailments.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailments.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.ailments.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailments.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.ailments.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailments.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.ailments.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.static.ailments.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.ailments.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.static.ailments.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.ailments.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailments.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.static.ailments.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.ailments.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailments.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailments.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailments.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailments.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.ailments.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailments.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.ailments.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailments.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.ailments.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.static.ailments.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.ailments.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.static.ailments.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.ailments.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailments.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.static.ailments.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailments.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailments.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailments.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailments.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailments.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.ailments.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailments.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.ailments.percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailments.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.ailments.percentage_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.ailments.percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.ailments.percentage_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.ailments.percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.ailments.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailments.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.timer_label) then
					changed, config.current_config.large_monster_UI.static.ailments.timer_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailments.timer_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailments.timer_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailments.timer_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailments.timer_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailments.timer_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.ailments.timer_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailments.timer_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.ailments.timer_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailments.timer_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.ailments.timer_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.ailments.timer_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.ailments.timer_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.ailments.timer_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.ailments.timer_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailments.timer_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.static.ailments.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.ailments.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailments.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailments.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailments.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailments.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.static.ailments.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.static.ailments.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailments.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.static.ailments.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.static.ailments.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailments.bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.static.ailments.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailments.bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.ailment_buildups) then
				changed, config.current_config.large_monster_UI.static.ailment_buildups.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.static.ailments.visibility);
				config_changed = config_changed or changed;
				large_monster_UI_changed = large_monster_UI_changed or changed;
	
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.static.ailment_buildups.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.static.ailment_buildups.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.static.ailment_buildups.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.static.ailment_buildups.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.players_spacing) then
					changed, config.current_config.large_monster_UI.static.ailment_buildups.players_spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.static.ailment_buildups.players_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.static.ailment_buildups.players_spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.static.ailment_buildups.players_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.ailments_spacing) then
					changed, config.current_config.large_monster_UI.static.ailment_buildups.ailments_spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.static.ailment_buildups.ailments_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.static.ailment_buildups.ailments_spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.static.ailment_buildups.ailments_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.settings) then
					changed, customization_menu.large_monster_static_UI_highlighted_buildup_bar_index =
					imgui.combo(language.current_language.customization_menu.highlighted_bar, customization_menu.large_monster_static_UI_highlighted_buildup_bar_index,
						customization_menu.displayed_highlighted_buildup_bar_types);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
					if changed then
						config.current_config.large_monster_UI.static.ailment_buildups.settings.highlighted_bar =
							customization_menu.highlighted_buildup_bar_types[customization_menu.large_monster_static_UI_highlighted_buildup_bar_index];
					end
	
					changed, customization_menu.large_monster_static_UI_buildup_bar_relative_index =
					imgui.combo(language.current_language.customization_menu.buildup_bars_are_relative_to, customization_menu.large_monster_static_UI_buildup_bar_relative_index,
						customization_menu.displayed_buildup_bar_relative_types);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if changed then
						config.current_config.large_monster_UI.static.ailment_buildups.settings.buildup_bar_relative_to =
							customization_menu.displayed_buildup_bar_relative_types[customization_menu.large_monster_static_UI_damage_bar_relative_index];
					end
					
					changed, config.current_config.large_monster_UI.static.ailment_buildups.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit,
					config.current_config.large_monster_UI.static.ailment_buildups.settings.time_limit, 0.1, 0, 99999, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.filter) then
					changed, config.current_config.large_monster_UI.static.ailment_buildups.filter.stun = imgui.checkbox(language.current_language.ailments.stun,
					config.current_config.large_monster_UI.static.ailment_buildups.filter.stun);
	
					changed, config.current_config.large_monster_UI.static.ailment_buildups.filter.poison = imgui.checkbox(language.current_language.ailments.poison,
					config.current_config.large_monster_UI.static.ailment_buildups.filter.poison);
	
					changed, config.current_config.large_monster_UI.static.ailment_buildups.filter.blast = imgui.checkbox(language.current_language.ailments.blast,
					config.current_config.large_monster_UI.static.ailment_buildups.filter.blast);
	
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.sorting) then
					changed, customization_menu.large_monster_static_UI_ailment_buildups_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
						customization_menu.large_monster_static_UI_ailment_buildups_sorting_type_index,
						customization_menu.ailment_buildups_sorting_types);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if changed then
						config.current_config.large_monster_UI.static.ailment_buildups.sorting.type =
							customization_menu.ailment_buildups_sorting_types[customization_menu.large_monster_static_UI_ailment_buildups_sorting_type_index];
					end
	
					changed, config.current_config.large_monster_UI.static.ailment_buildups.sorting.reversed_order = imgui.checkbox(
						language.current_language.customization_menu.reversed_order, config.current_config.large_monster_UI.static.ailment_buildups.sorting.reversed_order);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
					changed, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.include) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.include.ailment_name = imgui.checkbox(
							language.current_language.customization_menu.ailment_name, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.include.ailment_name);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.include.activation_count = imgui.checkbox(
							language.current_language.customization_menu.activation_count, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.include.activation_count);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.player_name_label) then
					changed, config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.player_name_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.buildup_value_label) then
					changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.buildup_value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.buildup_percentage_label) then
					changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.buildup_percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.total_buildup_label) then
					changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.total_buildup_value_label) then
					changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.total_buildup_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.buildup_bar) then
					changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.buildup_bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.highlighted_buildup_bar) then
					changed, config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.ailment_buildups.highlighted_buildup_bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
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

		if imgui.tree_node(language.current_language.customization_menu.highlighted) then
			changed, config.current_config.large_monster_UI.highlighted.enabled =
				imgui.checkbox(language.current_language.customization_menu.enabled, config.current_config.large_monster_UI.highlighted.enabled);
			config_changed = config_changed or changed;
			large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.position) then
				changed, config.current_config.large_monster_UI.highlighted.position.x =
					imgui.drag_float(language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.position.x, 0.1, 0, screen.width, "%.1f");
				config_changed = config_changed or changed;
				large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

				changed, config.current_config.large_monster_UI.highlighted.position.y =
					imgui.drag_float(language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.position.y, 0.1, 0, screen.height, "%.1f");
				config_changed = config_changed or changed;
				large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

				changed, customization_menu.large_monster_UI_anchor_index = imgui.combo(language.current_language.customization_menu.anchor,
					customization_menu.large_monster_UI_anchor_index, customization_menu.displayed_anchor_types);
				config_changed = config_changed or changed;
				if changed then
					config.current_config.large_monster_UI.highlighted.position.anchor =
						customization_menu.anchor_types[customization_menu.large_monster_UI_anchor_index];
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.monster_name_label) then
				changed, config.current_config.large_monster_UI.highlighted.monster_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.highlighted.monster_name_label.visibility);
				config_changed = config_changed or changed;
				large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, config.current_config.large_monster_UI.highlighted.monster_name_label.include.monster_name = imgui.checkbox(
						language.current_language.customization_menu.monster_name, config.current_config.large_monster_UI.highlighted.monster_name_label.include.monster_name);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					changed, config.current_config.large_monster_UI.highlighted.monster_name_label.include.crown = imgui.checkbox(language.current_language.customization_menu.crown,
						config.current_config.large_monster_UI.highlighted.monster_name_label.include.crown);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					changed, config.current_config.large_monster_UI.highlighted.monster_name_label.include.size = imgui.checkbox(language.current_language.customization_menu.size,
						config.current_config.large_monster_UI.highlighted.monster_name_label.include.size);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					changed, config.current_config.large_monster_UI.highlighted.monster_name_label.include.scrown_thresholds =
						imgui.checkbox(language.current_language.customization_menu.crown_thresholds,
							config.current_config.large_monster_UI.highlighted.monster_name_label.include.scrown_thresholds);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.highlighted.monster_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.highlighted.monster_name_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					changed, config.current_config.large_monster_UI.highlighted.monster_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.highlighted.monster_name_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.large_monster_UI.highlighted.monster_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.monster_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, config.current_config.large_monster_UI.highlighted.monster_name_label.shadow.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.monster_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.monster_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.monster_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.monster_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.monster_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.monster_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.monster_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.health) then
				changed, config.current_config.large_monster_UI.highlighted.health.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.highlighted.health.visibility);
				config_changed = config_changed or changed;
				large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.highlighted.health.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.highlighted.health.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					changed, config.current_config.large_monster_UI.highlighted.health.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.highlighted.health.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.highlighted.health.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.health.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.health.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.health.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.health.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.health.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.health.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.health.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.health.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.health.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.health.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.highlighted.health.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.health.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.highlighted.health.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.health.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.health.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.highlighted.health.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.health.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.health.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.health.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.health.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.health.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.health.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.health.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.health.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.health.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.health.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.highlighted.health.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.health.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.highlighted.health.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.health.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.health.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.highlighted.health.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.health.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.health.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.health.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.health.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.health.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.health.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.health.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.health.percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.health.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.health.percentage_label.shadow.offset.x =
								imgui.drag_float(language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.health.percentage_label.shadow.offset.x,
									0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.health.percentage_label.shadow.offset.y =
								imgui.drag_float(language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.health.percentage_label.shadow.offset.y,
									0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.health.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.health.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.highlighted.health.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.health.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.health.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.health.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.health.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.health.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.highlighted.health.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.highlighted.health.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.health.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.highlighted.health.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.highlighted.health.bar.normal_colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.health.bar.normal_colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.highlighted.health.bar.normal_colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.health.bar.normal_colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.monster_can_be_captured) then
							if imgui.tree_node(language.current_language.customization_menu.foreground) then
								changed, config.current_config.large_monster_UI.highlighted.health.bar.capture_colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.health.bar.capture_colors.foreground, customization_menu.color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

								imgui.tree_pop();
							end

							if imgui.tree_node(language.current_language.customization_menu.background) then
								changed, config.current_config.large_monster_UI.highlighted.health.bar.capture_colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.health.bar.capture_colors.background, customization_menu.color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

								imgui.tree_pop();
							end

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.capture_line) then
						changed, config.current_config.large_monster_UI.highlighted.health.bar.capture_line.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
							config.current_config.large_monster_UI.highlighted.health.bar.capture_line.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.health.bar.capture_line.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.highlighted.health.bar.capture_line.offset.x, 0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.health.bar.capture_line.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.highlighted.health.bar.capture_line.offset.y, 0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.size) then
							changed, config.current_config.large_monster_UI.highlighted.health.bar.capture_line.size.width = imgui.drag_float(language.current_language.customization_menu.width,
								config.current_config.large_monster_UI.highlighted.health.bar.capture_line.size.width, 0.1, 0, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.health.bar.capture_line.size.height = imgui.drag_float(language.current_language.customization_menu.height,
								config.current_config.large_monster_UI.highlighted.health.bar.capture_line.size.height, 0.1, 0, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.health.bar.capture_line.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.health.bar.capture_line.color, customization_menu.color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.stamina) then
				changed, config.current_config.large_monster_UI.highlighted.stamina.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.highlighted.stamina.visibility);
				config_changed = config_changed or changed;
				large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.highlighted.stamina.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.highlighted.stamina.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					changed, config.current_config.large_monster_UI.highlighted.stamina.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.highlighted.stamina.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.highlighted.stamina.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.stamina.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.stamina.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.stamina.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.stamina.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.stamina.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.stamina.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.stamina.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.stamina.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.stamina.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.stamina.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.highlighted.stamina.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.stamina.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.highlighted.stamina.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.stamina.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.stamina.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.highlighted.stamina.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.stamina.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.stamina.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.stamina.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.stamina.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.stamina.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.stamina.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.stamina.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.stamina.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.stamina.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.stamina.value_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.stamina.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.stamina.value_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.stamina.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.stamina.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.stamina.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.highlighted.stamina.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.stamina.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.stamina.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.stamina.percentage_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.stamina.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.stamina.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.stamina.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.stamina.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.stamina.percentage_label.shadow.visibility =
							imgui.checkbox(language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.stamina.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.stamina.percentage_label.shadow.offset.x =
								imgui.drag_float(language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.stamina.percentage_label.shadow.offset.x,
									0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.stamina.percentage_label.shadow.offset.y =
								imgui.drag_float(language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.stamina.percentage_label.shadow.offset.y,
									0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.stamina.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.stamina.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.highlighted.stamina.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.stamina.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.stamina.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.stamina.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.stamina.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.stamina.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.highlighted.stamina.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.highlighted.stamina.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.stamina.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.highlighted.stamina.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.highlighted.stamina.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.stamina.bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.highlighted.stamina.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.stamina.bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.rage) then
				changed, config.current_config.large_monster_UI.highlighted.rage.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.highlighted.rage.visibility);
				config_changed = config_changed or changed;
				large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.highlighted.rage.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.highlighted.rage.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					changed, config.current_config.large_monster_UI.highlighted.rage.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.highlighted.rage.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.highlighted.rage.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.rage.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.rage.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.rage.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.rage.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.rage.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.rage.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.rage.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.rage.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.rage.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.rage.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.highlighted.rage.text_label.shadow.offset.x, 0.1, -screen.width, screen.width,
								"%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.rage.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.highlighted.rage.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.rage.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.rage.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.highlighted.rage.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.rage.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.rage.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.rage.value_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.rage.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.rage.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.rage.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.rage.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.rage.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.rage.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.rage.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.highlighted.rage.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.rage.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.highlighted.rage.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.rage.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.rage.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.highlighted.rage.percentage_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.rage.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.rage.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.rage.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.rage.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.rage.percentage_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.rage.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.rage.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.rage.percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.rage.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.rage.percentage_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.rage.percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.rage.percentage_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.rage.percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.rage.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.rage.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.timer_label) then
					changed, config.current_config.large_monster_UI.highlighted.rage.timer_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.rage.timer_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.rage.timer_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.rage.timer_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.rage.timer_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.rage.timer_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.rage.timer_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.rage.timer_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.rage.timer_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.rage.timer_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.rage.timer_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.rage.timer_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.rage.timer_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.rage.timer_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.rage.timer_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.rage.timer_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.highlighted.rage.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.rage.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.rage.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.rage.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.rage.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.rage.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.highlighted.rage.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.highlighted.rage.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.rage.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.highlighted.rage.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.highlighted.rage.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.rage.bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.highlighted.rage.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.rage.bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.body_parts) then
				changed, config.current_config.large_monster_UI.highlighted.parts.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.highlighted.parts.visibility);
				config_changed = config_changed or changed;
				large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.highlighted.parts.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.highlighted.parts.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					changed, config.current_config.large_monster_UI.highlighted.parts.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.highlighted.parts.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.spacing) then
					changed, config.current_config.large_monster_UI.highlighted.parts.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.highlighted.parts.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					changed, config.current_config.large_monster_UI.highlighted.parts.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.highlighted.parts.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.settings) then
					changed, config.current_config.large_monster_UI.highlighted.parts.settings.hide_undamaged_parts = imgui.checkbox(
						language.current_language.customization_menu.hide_undamaged_parts, config.current_config.large_monster_UI.highlighted.parts.settings.hide_undamaged_parts);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					changed, config.current_config.large_monster_UI.highlighted.parts.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit,
					config.current_config.large_monster_UI.highlighted.parts.settings.time_limit, 0.1, 0, 99999, "%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.sorting) then
					changed, customization_menu.large_monster_highlighted_UI_parts_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
						customization_menu.large_monster_highlighted_UI_parts_sorting_type_index,
						customization_menu.displayed_monster_UI_parts_sorting_types);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
					if changed then
						config.current_config.large_monster_UI.highlighted.parts.sorting.type =
							customization_menu.large_monster_UI_parts_sorting_types[customization_menu.large_monster_highlighted_UI_parts_sorting_type_index];
					end

					changed, config.current_config.large_monster_UI.highlighted.parts.sorting.reversed_order = imgui.checkbox(
						language.current_language.customization_menu.reversed_order, config.current_config.large_monster_UI.highlighted.parts.sorting.reversed_order);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.part_name_label) then
					changed, config.current_config.large_monster_UI.highlighted.parts.part_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.parts.part_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.include) then
						changed, config.current_config.large_monster_UI.highlighted.parts.part_name_label.include.part_name = imgui.checkbox(
							language.current_language.customization_menu.part_name, config.current_config.large_monster_UI.highlighted.parts.part_name_label.include.part_name);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.parts.part_name_label.include.flinch_count = imgui.checkbox(
							language.current_language.customization_menu.flinch_count, config.current_config.large_monster_UI.highlighted.parts.part_name_label.include.flinch_count);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.parts.part_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.parts.part_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.parts.part_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.parts.part_name_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.parts.part_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.parts.part_name_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.parts.part_name_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.parts.part_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.parts.part_name_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.parts.part_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.parts.part_name_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.parts.part_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.parts.part_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.parts.part_name_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.highlighted.parts.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.parts.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.parts.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.parts.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.parts.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.parts.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.parts.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.parts.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.parts.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.parts.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.parts.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.highlighted.parts.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.parts.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.highlighted.parts.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.parts.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.parts.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.highlighted.parts.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.parts.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.parts.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.parts.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.parts.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.parts.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.parts.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.parts.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.parts.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.parts.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.parts.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.highlighted.parts.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.parts.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.highlighted.parts.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.parts.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.parts.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.highlighted.parts.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.parts.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					-- add text format

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.parts.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.parts.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.parts.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.parts.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.parts.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.parts.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.parts.percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.parts.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.parts.percentage_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.parts.percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							changed, config.current_config.large_monster_UI.highlighted.parts.percentage_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.parts.percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.parts.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.parts.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.highlighted.parts.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.parts.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.parts.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.parts.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.parts.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.parts.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.highlighted.parts.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.highlighted.parts.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						changed, config.current_config.large_monster_UI.highlighted.parts.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.highlighted.parts.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.highlighted.parts.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.parts.bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.highlighted.parts.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.parts.bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.ailments) then
				changed, config.current_config.large_monster_UI.highlighted.ailments.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.highlighted.ailments.visibility);
				config_changed = config_changed or changed;
				large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.highlighted.ailments.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.highlighted.ailments.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.highlighted.ailments.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.highlighted.ailments.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.relative_offset) then
					changed, config.current_config.large_monster_UI.highlighted.ailments.relative_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.highlighted.ailments.relative_offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.highlighted.ailments.relative_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.highlighted.ailments.relative_offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.spacing) then
					changed, config.current_config.large_monster_UI.highlighted.ailments.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.highlighted.ailments.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.highlighted.ailments.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.highlighted.ailments.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.settings) then
					changed, config.current_config.large_monster_UI.highlighted.ailments.settings.hide_ailments_with_zero_buildup = imgui.checkbox(
						language.current_language.customization_menu.hide_ailments_with_zero_buildup, config.current_config.large_monster_UI.highlighted.ailments.settings.hide_ailments_with_zero_buildup);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.highlighted.ailments.settings.hide_inactive_ailments_with_no_buildup_support = imgui.checkbox(
						language.current_language.customization_menu.hide_inactive_ailments_with_no_buildup_support, config.current_config.large_monster_UI.highlighted.ailments.settings.hide_inactive_ailments_with_no_buildup_support);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.highlighted.ailments.settings.hide_all_inactive_ailments = imgui.checkbox(
						language.current_language.customization_menu.hide_all_inactive_ailments, config.current_config.large_monster_UI.highlighted.ailments.settings.hide_all_inactive_ailments);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.highlighted.ailments.settings.hide_all_active_ailments = imgui.checkbox(
						language.current_language.customization_menu.hide_all_active_ailments, config.current_config.large_monster_UI.highlighted.ailments.settings.hide_all_active_ailments);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.highlighted.ailments.settings.hide_disabled_ailments = imgui.checkbox(
						language.current_language.customization_menu.hide_disabled_ailments, config.current_config.large_monster_UI.highlighted.ailments.settings.hide_disabled_ailments);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;

					changed, config.current_config.large_monster_UI.highlighted.ailments.settings.offset_is_relative_to_parts = imgui.checkbox(
						language.current_language.customization_menu.offset_is_relative_to_parts, config.current_config.large_monster_UI.highlighted.ailments.settings.offset_is_relative_to_parts);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.highlighted.ailments.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit,
					config.current_config.large_monster_UI.highlighted.ailments.settings.time_limit, 0.1, 0, 99999, "%.1f");
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.sorting) then
					changed, customization_menu.small_monster_UI_ailments_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
						customization_menu.small_monster_UI_ailments_sorting_type_index,
						customization_menu.ailments_sorting_types);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
					if changed then
						config.current_config.large_monster_UI.highlighted.ailments.sorting.type =
							customization_menu.ailments_sorting_types[customization_menu.small_monster_UI_ailments_sorting_type_index];
					end
	
					changed, config.current_config.large_monster_UI.highlighted.ailments.sorting.reversed_order = imgui.checkbox(
						language.current_language.customization_menu.reversed_order, config.current_config.large_monster_UI.highlighted.ailments.sorting.reversed_order);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
					changed, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.include) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.include.ailment_name = imgui.checkbox(
							language.current_language.customization_menu.ailment_name, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.include.ailment_name);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.include.activation_count = imgui.checkbox(
							language.current_language.customization_menu.activation_count, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.include.activation_count);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.text_label) then
					changed, config.current_config.large_monster_UI.highlighted.ailments.text_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.ailments.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.text_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailments.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailments.text_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailments.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailments.text_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.text_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailments.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.ailments.text_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.highlighted.ailments.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.ailments.text_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.highlighted.ailments.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.ailments.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailments.text_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.value_label) then
					changed, config.current_config.large_monster_UI.highlighted.ailments.value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.ailments.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailments.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailments.value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailments.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailments.value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailments.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.ailments.value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.highlighted.ailments.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.ailments.value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.highlighted.ailments.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.ailments.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailments.value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.percentage_label) then
					changed, config.current_config.large_monster_UI.highlighted.ailments.percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailments.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailments.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailments.percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailments.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailments.percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailments.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.ailments.percentage_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.ailments.percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.ailments.percentage_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.ailments.percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.ailments.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailments.percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.timer_label) then
					changed, config.current_config.large_monster_UI.highlighted.ailments.timer_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailments.timer_label.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.timer_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailments.timer_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailments.timer_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailments.timer_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.timer_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailments.timer_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.timer_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailments.timer_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.ailments.timer_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.ailments.timer_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.ailments.timer_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.ailments.timer_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.ailments.timer_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailments.timer_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.bar) then
					changed, config.current_config.large_monster_UI.highlighted.ailments.bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.ailments.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailments.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailments.bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailments.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.highlighted.ailments.bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.highlighted.ailments.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailments.bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.highlighted.ailments.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.highlighted.ailments.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailments.bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.highlighted.ailments.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailments.bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_highlighted_UI_changed = large_monster_highlighted_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.ailment_buildups) then
				changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.large_monster_UI.highlighted.ailments.visibility);
				config_changed = config_changed or changed;
				large_monster_UI_changed = large_monster_UI_changed or changed;
	
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.highlighted.ailment_buildups.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.highlighted.ailment_buildups.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.players_spacing) then
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.players_spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.highlighted.ailment_buildups.players_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.players_spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.highlighted.ailment_buildups.players_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.ailments_spacing) then
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailments_spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.large_monster_UI.highlighted.ailment_buildups.ailments_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailments_spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.large_monster_UI.highlighted.ailment_buildups.ailments_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.settings) then
					changed, customization_menu.large_monster_highlighted_UI_highlighted_buildup_bar_index =
					imgui.combo(language.current_language.customization_menu.highlighted_bar, customization_menu.large_monster_highlighted_UI_highlighted_buildup_bar_index,
						customization_menu.displayed_highlighted_buildup_bar_types);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
					if changed then
						config.current_config.large_monster_UI.highlighted.ailment_buildups.settings.highlighted_bar =
							customization_menu.highlighted_buildup_bar_types[customization_menu.large_monster_highlighted_UI_highlighted_buildup_bar_index];
					end
	
					changed, customization_menu.large_monster_highlighted_UI_buildup_bar_relative_index =
					imgui.combo(language.current_language.customization_menu.buildup_bars_are_relative_to, customization_menu.large_monster_highlighted_UI_buildup_bar_relative_index,
						customization_menu.displayed_buildup_bar_relative_types);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if changed then
						config.current_config.large_monster_UI.highlighted.ailment_buildups.settings.buildup_bar_relative_to =
							customization_menu.displayed_buildup_bar_relative_types[customization_menu.large_monster_highlighted_UI_damage_bar_relative_index];
					end
					
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit,
					config.current_config.large_monster_UI.highlighted.ailment_buildups.settings.time_limit, 0.1, 0, 99999, "%.1f");
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.filter) then
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.filter.stun = imgui.checkbox(language.current_language.ailments.stun,
					config.current_config.large_monster_UI.highlighted.ailment_buildups.filter.stun);
	
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.filter.poison = imgui.checkbox(language.current_language.ailments.poison,
					config.current_config.large_monster_UI.highlighted.ailment_buildups.filter.poison);
	
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.filter.blast = imgui.checkbox(language.current_language.ailments.blast,
					config.current_config.large_monster_UI.highlighted.ailment_buildups.filter.blast);
	
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.sorting) then
					changed, customization_menu.large_monster_highlighted_UI_ailment_buildups_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
						customization_menu.large_monster_highlighted_UI_ailment_buildups_sorting_type_index,
						customization_menu.ailment_buildups_sorting_types);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if changed then
						config.current_config.large_monster_UI.highlighted.ailment_buildups.sorting.type =
							customization_menu.ailment_buildups_sorting_types[customization_menu.large_monster_highlighted_UI_ailment_buildups_sorting_type_index];
					end
	
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.sorting.reversed_order = imgui.checkbox(
						language.current_language.customization_menu.reversed_order, config.current_config.large_monster_UI.highlighted.ailment_buildups.sorting.reversed_order);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.include) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.include.ailment_name = imgui.checkbox(
							language.current_language.customization_menu.ailment_name, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.include.ailment_name);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.include.activation_count = imgui.checkbox(
							language.current_language.customization_menu.activation_count, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.include.activation_count);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.player_name_label) then
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.player_name_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.buildup_value_label) then
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
								config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
								config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_value_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.buildup_percentage_label) then
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_percentage_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.total_buildup_label) then
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.total_buildup_value_label) then
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.visibility = imgui.checkbox(
						language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					-- add text format
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.shadow) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.shadow.visibility = imgui.checkbox(
							language.current_language.customization_menu.visible, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						if imgui.tree_node(language.current_language.customization_menu.offset) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.shadow.offset.x = imgui.drag_float(
								language.current_language.customization_menu.x, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.shadow.offset.y = imgui.drag_float(
								language.current_language.customization_menu.y, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.color) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.total_buildup_label.shadow.color, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.buildup_bar) then
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.buildup_bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node(language.current_language.customization_menu.highlighted_buildup_bar) then
					changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
						config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.visibility);
					config_changed = config_changed or changed;
					large_monster_UI_changed = large_monster_UI_changed or changed;
	
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.size) then
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
							config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_UI_changed = large_monster_UI_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node(language.current_language.customization_menu.colors) then
						if imgui.tree_node(language.current_language.customization_menu.foreground) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.colors.foreground, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
							imgui.tree_pop();
						end
	
						if imgui.tree_node(language.current_language.customization_menu.background) then
							changed, config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.highlighted.ailment_buildups.highlighted_buildup_bar.colors.background, customization_menu.color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_UI_changed = large_monster_UI_changed or changed;
	
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

		imgui.tree_pop();
	end

	if imgui.tree_node(language.current_language.customization_menu.time_UI) then
		changed, config.current_config.time_UI.enabled = imgui.checkbox(language.current_language.customization_menu.enabled, config.current_config.time_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, config.current_config.time_UI.position.x = imgui.drag_float(language.current_language.customization_menu.x, config.current_config.time_UI.position.x,
				0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.time_UI.position.y = imgui.drag_float(language.current_language.customization_menu.y, config.current_config.time_UI.position.y,
				0.1, 0, screen.height, "%.1f");
			config_changed = config_changed or changed;

			changed, customization_menu.time_UI_anchor_index = imgui.combo(language.current_language.customization_menu.anchor, customization_menu.time_UI_anchor_index,
				customization_menu.displayed_anchor_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.time_UI.position.anchor =
					customization_menu.anchor_types[customization_menu.time_UI_anchor_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.time_label) then
			changed, config.current_config.time_UI.time_label.visibility =
				imgui.checkbox(language.current_language.customization_menu.visible, config.current_config.time_UI.time_label.visibility);
			config_changed = config_changed or changed;
			time_UI_changed = time_UI_changed or changed;

			-- add text format

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.time_UI.time_label.offset.x =
					imgui.drag_float(language.current_language.customization_menu.x, config.current_config.time_UI.time_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				time_UI_changed = time_UI_changed or changed;

				changed, config.current_config.time_UI.time_label.offset.y =
					imgui.drag_float(language.current_language.customization_menu.y, config.current_config.time_UI.time_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				time_UI_changed = time_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, config.current_config.time_UI.time_label.color = imgui.color_picker_argb("", config.current_config.time_UI.time_label.color, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				time_UI_changed = time_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, config.current_config.time_UI.time_label.shadow.visibility =
					imgui.checkbox(language.current_language.customization_menu.visible, config.current_config.time_UI.time_label.shadow.visibility);
				config_changed = config_changed or changed;
				time_UI_changed = time_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.time_UI.time_label.shadow.offset.x =
						imgui.drag_float(language.current_language.customization_menu.x, config.current_config.time_UI.time_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
					config_changed = config_changed or changed;
					time_UI_changed = time_UI_changed or changed;

					changed, config.current_config.time_UI.time_label.shadow.offset.y =
						imgui.drag_float(language.current_language.customization_menu.y, config.current_config.time_UI.time_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
					time_UI_changed = time_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.time_UI.time_label.shadow.color = imgui.color_picker_argb("", config.current_config.time_UI.time_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					time_UI_changed = time_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end
			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node(language.current_language.customization_menu.damage_meter_UI) then
		changed, config.current_config.damage_meter_UI.enabled = imgui.checkbox(language.current_language.customization_menu.enabled,
			config.current_config.damage_meter_UI.enabled);
		config_changed = config_changed or changed;
		damage_meter_UI_changed = damage_meter_UI_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, config.current_config.damage_meter_UI.settings.hide_module_if_total_damage_is_zero = imgui.checkbox(
				language.current_language.customization_menu.hide_module_if_total_damage_is_zero,
				config.current_config.damage_meter_UI.settings.hide_module_if_total_damage_is_zero);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			changed, config.current_config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero = imgui.checkbox(
				language.current_language.customization_menu.hide_player_if_player_damage_is_zero,
				config.current_config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			changed, config.current_config.damage_meter_UI.settings.hide_total_if_total_damage_is_zero = imgui.checkbox(
				language.current_language.customization_menu.hide_total_if_total_damage_is_zero, config.current_config.damage_meter_UI.settings.hide_total_if_total_damage_is_zero);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			changed, config.current_config.damage_meter_UI.settings.total_damage_offset_is_relative = imgui.checkbox(
				language.current_language.customization_menu.total_damage_offset_is_relative, config.current_config.damage_meter_UI.settings.total_damage_offset_is_relative);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			changed, customization_menu.damage_meter_UI_orientation_index = imgui.combo(language.current_language.customization_menu.orientation,
				customization_menu.damage_meter_UI_orientation_index, customization_menu.displayed_orientation_types);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.orientation =
					customization_menu.orientation_types[customization_menu.damage_meter_UI_orientation_index];
			end

			changed, customization_menu.damage_meter_UI_highlighted_bar_index =
				imgui.combo(language.current_language.customization_menu.highlighted_bar, customization_menu.damage_meter_UI_highlighted_bar_index,
					customization_menu.displayed_damage_meter_UI_highlighted_bar_types);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.highlighted_bar =
					customization_menu.damage_meter_UI_highlighted_bar_types[customization_menu.damage_meter_UI_highlighted_bar_index];
			end

			changed, customization_menu.damage_meter_UI_damage_bar_relative_index =
				imgui.combo(language.current_language.customization_menu.damage_bars_are_relative_to, customization_menu.damage_meter_UI_damage_bar_relative_index,
					customization_menu.displayed_damage_meter_UI_damage_bar_relative_types);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.damage_bar_relative_to =
					customization_menu.damage_meter_UI_damage_bar_relative_types[customization_menu.damage_meter_UI_damage_bar_relative_index];
			end

			changed, customization_menu.damage_meter_UI_my_damage_bar_location_index =
				imgui.combo(language.current_language.customization_menu.my_damage_bar_location, customization_menu.damage_meter_UI_my_damage_bar_location_index,
					customization_menu.displayed_damage_meter_UI_my_damage_bar_location_types);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.my_damage_bar_location =
					customization_menu.damage_meter_UI_my_damage_bar_location_types[customization_menu.damage_meter_UI_my_damage_bar_location_index];
			end

			changed, customization_menu.damage_meter_UI_dps_mode_index =
				imgui.combo(language.current_language.customization_menu.dps_mode, customization_menu.damage_meter_UI_dps_mode_index,
					customization_menu.displayed_damage_meter_UI_dps_modes);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.dps_mode =
					customization_menu.damage_meter_UI_dps_modes[customization_menu.damage_meter_UI_dps_mode_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.tracked_monster_types) then
			local tracked_monster_types_changed = false;
			changed, config.current_config.damage_meter_UI.tracked_monster_types.small_monsters = imgui.checkbox(
				language.current_language.customization_menu.small_monsters, config.current_config.damage_meter_UI.tracked_monster_types.small_monsters);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			tracked_monster_types_changed = tracked_monster_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_monster_types.large_monsters = imgui.checkbox(
				language.current_language.customization_menu.large_monsters, config.current_config.damage_meter_UI.tracked_monster_types.large_monsters);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			tracked_monster_types_changed = tracked_monster_types_changed or changed;

			if tracked_monster_types_changed then
				for player_id, _player in pairs(player.list) do
					_player.update_display(player);
				end
				player.update_display(player.total);
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.tracked_damage_types) then
			local tracked_damage_types_changed = false;
			changed, config.current_config.damage_meter_UI.tracked_damage_types.player_damage =
				imgui.checkbox(language.current_language.customization_menu.player_damage, config.current_config.damage_meter_UI.tracked_damage_types.player_damage);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.bomb_damage = imgui.checkbox(language.current_language.customization_menu.bomb_damage,
				config.current_config.damage_meter_UI.tracked_damage_types.bomb_damage);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.kunai_damage =
				imgui.checkbox(language.current_language.customization_menu.kunai_damage, config.current_config.damage_meter_UI.tracked_damage_types.kunai_damage);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.installation_damage = imgui.checkbox(
				language.current_language.customization_menu.installation_damage, config.current_config.damage_meter_UI.tracked_damage_types.installation_damage);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.otomo_damage =
				imgui.checkbox(language.current_language.customization_menu.otomo_damage, config.current_config.damage_meter_UI.tracked_damage_types.otomo_damage);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.monster_damage =
				imgui.checkbox(language.current_language.customization_menu.monster_damage, config.current_config.damage_meter_UI.tracked_damage_types.monster_damage);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.poison_damage =
				imgui.checkbox(language.current_language.customization_menu.poison_damage, config.current_config.damage_meter_UI.tracked_damage_types.poison_damage);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.blast_damage =
				imgui.checkbox(language.current_language.customization_menu.blast_damage, config.current_config.damage_meter_UI.tracked_damage_types.blast_damage);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			if tracked_damage_types_changed then
				for player_id, _player in pairs(player.list) do
					player.update_display(_player);
				end
				player.update_display(player.total);
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.spacing) then
			changed, config.current_config.damage_meter_UI.spacing.x =
				imgui.drag_float(language.current_language.customization_menu.x, config.current_config.damage_meter_UI.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			changed, config.current_config.damage_meter_UI.spacing.y =
				imgui.drag_float(language.current_language.customization_menu.y, config.current_config.damage_meter_UI.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, config.current_config.damage_meter_UI.position.x =
				imgui.drag_float(language.current_language.customization_menu.x, config.current_config.damage_meter_UI.position.x, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			changed, config.current_config.damage_meter_UI.position.y =
				imgui.drag_float(language.current_language.customization_menu.y, config.current_config.damage_meter_UI.position.y, 0.1, 0, screen.height, "%.1f");
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			changed, customization_menu.damage_meter_UI_anchor_index = imgui.combo(language.current_language.customization_menu.anchor,
				customization_menu.damage_meter_UI_anchor_index, customization_menu.displayed_anchor_types);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.position.anchor =
					customization_menu.anchor_types[customization_menu.damage_meter_UI_anchor_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, customization_menu.damage_meter_UI_sorting_type_index = imgui.combo(language.current_language.customization_menu.type,
			customization_menu.damage_meter_UI_sorting_type_index, customization_menu.displayed_damage_meter_UI_sorting_types);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.sorting.type =
					customization_menu.damage_meter_UI_sorting_types[customization_menu.damage_meter_UI_sorting_type_index];
			end

			changed, config.current_config.damage_meter_UI.sorting.reversed_order =
				imgui.checkbox(language.current_language.customization_menu.reversed_order, config.current_config.damage_meter_UI.sorting.reversed_order);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.player_name_label) then
			changed, config.current_config.damage_meter_UI.player_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.damage_meter_UI.player_name_label.visibility);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.include) then
				if imgui.tree_node(language.current_language.customization_menu.me) then
					changed, config.current_config.damage_meter_UI.player_name_label.include.myself.hunter_rank = imgui.checkbox(
						language.current_language.customization_menu.hunter_rank, config.current_config.damage_meter_UI.player_name_label.include.myself.hunter_rank);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.myself.word_player = imgui.checkbox(
						language.current_language.customization_menu.word_player, config.current_config.damage_meter_UI.player_name_label.include.myself.word_player);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.myself.player_id = imgui.checkbox(
						language.current_language.customization_menu.player_id, config.current_config.damage_meter_UI.player_name_label.include.myself.player_id);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.myself.player_name = imgui.checkbox(
						language.current_language.customization_menu.player_name, config.current_config.damage_meter_UI.player_name_label.include.myself.player_name);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.other_players) then
					changed, config.current_config.damage_meter_UI.player_name_label.include.others.hunter_rank = imgui.checkbox(
						language.current_language.customization_menu.hunter_rank, config.current_config.damage_meter_UI.player_name_label.include.others.hunter_rank);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.others.word_player = imgui.checkbox(
						language.current_language.customization_menu.word_player, config.current_config.damage_meter_UI.player_name_label.include.others.word_player);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.others.player_id = imgui.checkbox(
						language.current_language.customization_menu.player_id, config.current_config.damage_meter_UI.player_name_label.include.others.player_id);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.others.player_name = imgui.checkbox(
						language.current_language.customization_menu.player_name, config.current_config.damage_meter_UI.player_name_label.include.others.player_name);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.damage_meter_UI.player_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.damage_meter_UI.player_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.player_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.damage_meter_UI.player_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, config.current_config.damage_meter_UI.player_name_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.player_name_label.color, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, config.current_config.damage_meter_UI.player_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.damage_meter_UI.player_name_label.shadow.visibility);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.damage_meter_UI.player_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.damage_meter_UI.player_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.damage_meter_UI.player_name_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.damage_meter_UI.player_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.player_name_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.hunter_rank_label) then
			changed, config.current_config.damage_meter_UI.hunter_rank_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.damage_meter_UI.hunter_rank_label.visibility);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.enable_for) then
				changed, config.current_config.damage_meter_UI.hunter_rank_label.enable_for.me = imgui.checkbox(
					language.current_language.customization_menu.me, config.current_config.damage_meter_UI.hunter_rank_label.enable_for.me);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.hunter_rank_label.enable_for.other_players = imgui.checkbox(
					language.current_language.customization_menu.other_players, config.current_config.damage_meter_UI.hunter_rank_label.enable_for.other_players);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;


				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.damage_meter_UI.hunter_rank_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.damage_meter_UI.hunter_rank_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.hunter_rank_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.damage_meter_UI.hunter_rank_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, config.current_config.damage_meter_UI.hunter_rank_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.hunter_rank_label.color, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, config.current_config.damage_meter_UI.hunter_rank_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.damage_meter_UI.hunter_rank_label.shadow.visibility);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.damage_meter_UI.hunter_rank_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.damage_meter_UI.hunter_rank_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.hunter_rank_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.damage_meter_UI.hunter_rank_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.damage_meter_UI.hunter_rank_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.hunter_rank_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.dps_label) then
			changed, config.current_config.damage_meter_UI.dps_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.damage_meter_UI.dps_label.visibility);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			-- add text format

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.damage_meter_UI.dps_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.damage_meter_UI.dps_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.dps_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.damage_meter_UI.dps_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, config.current_config.damage_meter_UI.dps_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.dps_label.color, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, config.current_config.damage_meter_UI.dps_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.damage_meter_UI.dps_label.shadow.visibility);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.damage_meter_UI.dps_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.damage_meter_UI.dps_label.shadow.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.dps_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.damage_meter_UI.dps_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.damage_meter_UI.dps_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.dps_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.damage_value_label) then
			changed, config.current_config.damage_meter_UI.damage_value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.damage_meter_UI.damage_value_label.visibility);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			-- add text format

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.damage_meter_UI.damage_value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.damage_meter_UI.damage_value_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.damage_value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.damage_meter_UI.damage_value_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, config.current_config.damage_meter_UI.damage_value_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_value_label.color, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, config.current_config.damage_meter_UI.damage_value_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.damage_meter_UI.damage_value_label.shadow.visibility);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.damage_meter_UI.damage_value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.damage_meter_UI.damage_value_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.damage_value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.damage_meter_UI.damage_value_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.damage_meter_UI.damage_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_value_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.damage_percentage_label) then
			changed, config.current_config.damage_meter_UI.damage_percentage_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.damage_meter_UI.damage_percentage_label.visibility);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			-- add text format

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.damage_meter_UI.damage_percentage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.damage_meter_UI.damage_percentage_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.damage_percentage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.damage_meter_UI.damage_percentage_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, config.current_config.damage_meter_UI.damage_percentage_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_percentage_label.color, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, config.current_config.damage_meter_UI.damage_percentage_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.damage_meter_UI.damage_percentage_label.shadow.visibility);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.damage_meter_UI.damage_percentage_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.damage_meter_UI.damage_percentage_label.shadow.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.damage_percentage_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.damage_meter_UI.damage_percentage_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.damage_meter_UI.damage_percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_percentage_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.total_damage_label) then
			changed, config.current_config.damage_meter_UI.total_damage_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.damage_meter_UI.total_damage_label.visibility);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			-- add text format

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.damage_meter_UI.total_damage_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.damage_meter_UI.total_damage_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.total_damage_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.damage_meter_UI.total_damage_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, config.current_config.damage_meter_UI.total_damage_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_damage_label.color, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, config.current_config.damage_meter_UI.total_damage_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.damage_meter_UI.total_damage_label.shadow.visibility);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.damage_meter_UI.total_damage_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.damage_meter_UI.total_damage_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.total_damage_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.damage_meter_UI.total_damage_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.damage_meter_UI.total_damage_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_damage_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.total_dps_label) then
			changed, config.current_config.damage_meter_UI.total_dps_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.damage_meter_UI.total_dps_label.visibility);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			-- add text format

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.damage_meter_UI.total_dps_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.damage_meter_UI.total_dps_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.total_dps_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.damage_meter_UI.total_dps_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, config.current_config.damage_meter_UI.total_dps_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_dps_label.color, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, config.current_config.damage_meter_UI.total_dps_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.damage_meter_UI.total_dps_label.shadow.visibility);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.damage_meter_UI.total_dps_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.damage_meter_UI.total_dps_label.shadow.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.total_dps_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.damage_meter_UI.total_dps_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.damage_meter_UI.total_dps_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_dps_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.total_damage_value_label) then
			changed, config.current_config.damage_meter_UI.total_damage_value_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.damage_meter_UI.total_damage_value_label.visibility);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			-- add text format

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.damage_meter_UI.total_damage_value_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.damage_meter_UI.total_damage_value_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.total_damage_value_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.damage_meter_UI.total_damage_value_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, config.current_config.damage_meter_UI.total_damage_value_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_damage_value_label.color, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, config.current_config.damage_meter_UI.total_damage_value_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
					config.current_config.damage_meter_UI.total_damage_value_label.shadow.visibility);
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.damage_meter_UI.total_damage_value_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.damage_meter_UI.total_damage_value_label.shadow.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					changed, config.current_config.damage_meter_UI.total_damage_value_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.damage_meter_UI.total_damage_value_label.shadow.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.damage_meter_UI.total_damage_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_damage_value_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.damage_bar) then
			changed, config.current_config.damage_meter_UI.damage_bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.damage_meter_UI.damage_bar.visibility);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.damage_meter_UI.damage_bar.offset.x =
					imgui.drag_float(language.current_language.customization_menu.x, config.current_config.damage_meter_UI.damage_bar.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.damage_bar.offset.y =
					imgui.drag_float(language.current_language.customization_menu.y, config.current_config.damage_meter_UI.damage_bar.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.size) then
				changed, config.current_config.damage_meter_UI.damage_bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
					config.current_config.damage_meter_UI.damage_bar.size.width, 0.1, 0, screen.width, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.damage_bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
					config.current_config.damage_meter_UI.damage_bar.size.height, 0.1, 0, screen.height, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.colors) then
				if imgui.tree_node(language.current_language.customization_menu.foreground) then
					changed, config.current_config.damage_meter_UI.damage_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_bar.colors.foreground, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.background) then
					changed, config.current_config.damage_meter_UI.damage_bar.colors.background = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_bar.colors.background, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.highlighted_damage_bar) then
			changed, config.current_config.damage_meter_UI.highlighted_damage_bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.damage_meter_UI.highlighted_damage_bar.visibility);
			config_changed = config_changed or changed;
			damage_meter_UI_changed = damage_meter_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.damage_meter_UI.highlighted_damage_bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.damage_meter_UI.highlighted_damage_bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.highlighted_damage_bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.damage_meter_UI.highlighted_damage_bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.size) then
				changed, config.current_config.damage_meter_UI.highlighted_damage_bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
					config.current_config.damage_meter_UI.highlighted_damage_bar.size.width, 0.1, 0, screen.width, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				changed, config.current_config.damage_meter_UI.highlighted_damage_bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
					config.current_config.damage_meter_UI.highlighted_damage_bar.size.height, 0.1, 0, screen.height, "%.1f");
				config_changed = config_changed or changed;
				damage_meter_UI_changed = damage_meter_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.colors) then
				if imgui.tree_node(language.current_language.customization_menu.foreground) then
					changed, config.current_config.damage_meter_UI.highlighted_damage_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.damage_meter_UI.highlighted_damage_bar.colors.foreground, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.background) then
					changed, config.current_config.damage_meter_UI.highlighted_damage_bar.colors.background = imgui.color_picker_argb("", config.current_config.damage_meter_UI.highlighted_damage_bar.colors.background, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					damage_meter_UI_changed = damage_meter_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node(language.current_language.customization_menu.endemic_life_UI) then
		changed, config.current_config.endemic_life_UI.enabled =
			imgui.checkbox(language.current_language.customization_menu.enabled, config.current_config.endemic_life_UI.enabled);
		config_changed = config_changed or changed;
		endemic_life_UI_changed = endemic_life_UI_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, config.current_config.endemic_life_UI.settings.hide_inactive_creatures = imgui.checkbox(language.current_language.customization_menu.hide_inactive_creatures, config.current_config.
			endemic_life_UI.settings.hide_inactive_creatures);
			config_changed = config_changed or changed;

			changed, config.current_config.endemic_life_UI.settings.opacity_falloff =
				imgui.checkbox(language.current_language.customization_menu.opacity_falloff, config.current_config.endemic_life_UI.settings.opacity_falloff);
			config_changed = config_changed or changed;
			endemic_life_UI_changed = endemic_life_UI_changed or changed;

			changed, config.current_config.endemic_life_UI.settings.max_distance =
				imgui.drag_float(language.current_language.customization_menu.max_distance, config.current_config.endemic_life_UI.settings.max_distance, 1, 0, 10000,
					"%.0f");
			config_changed = config_changed or changed;
			endemic_life_UI_changed = endemic_life_UI_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.world_offset) then
			changed, config.current_config.endemic_life_UI.world_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
				config.current_config.endemic_life_UI.world_offset.x, 0.1, -100, 100, "%.1f");
			config_changed = config_changed or changed;
			endemic_life_UI_changed = endemic_life_UI_changed or changed;

			changed, config.current_config.endemic_life_UI.world_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
				config.current_config.endemic_life_UI.world_offset.y, 0.1, -100, 100, "%.1f");
			config_changed = config_changed or changed;
			endemic_life_UI_changed = endemic_life_UI_changed or changed;

			changed, config.current_config.endemic_life_UI.world_offset.z = imgui.drag_float(language.current_language.customization_menu.z,
				config.current_config.endemic_life_UI.world_offset.z, 0.1, -100, 100, "%.1f");
			config_changed = config_changed or changed;
			endemic_life_UI_changed = endemic_life_UI_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.viewport_offset) then
			changed, config.current_config.endemic_life_UI.viewport_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
				config.current_config.endemic_life_UI.viewport_offset.x, 0.1, -screen.width, screen.width, "%.1f");
			config_changed = config_changed or changed;
			endemic_life_UI_changed = endemic_life_UI_changed or changed;

			changed, config.current_config.endemic_life_UI.viewport_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
				config.current_config.endemic_life_UI.viewport_offset.y, 0.1, -screen.height, screen.height, "%.1f");
			config_changed = config_changed or changed;
			endemic_life_UI_changed = endemic_life_UI_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.creature_name_label) then
			changed, config.current_config.endemic_life_UI.creature_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				config.current_config.endemic_life_UI.creature_name_label.visibility);
			config_changed = config_changed or changed;
			endemic_life_UI_changed = endemic_life_UI_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, config.current_config.endemic_life_UI.creature_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					config.current_config.endemic_life_UI.creature_name_label.offset.x, 0.1, -screen.width, screen.width,
					"%.1f");
				config_changed = config_changed or changed;
				endemic_life_UI_changed = endemic_life_UI_changed or changed;

				changed, config.current_config.endemic_life_UI.creature_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					config.current_config.endemic_life_UI.creature_name_label.offset.y, 0.1, -screen.height, screen.height,
					"%.1f");
				config_changed = config_changed or changed;
				endemic_life_UI_changed = endemic_life_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, config.current_config.endemic_life_UI.creature_name_label.color = imgui.color_picker_argb("", config.current_config.endemic_life_UI.creature_name_label.color, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				endemic_life_UI_changed = endemic_life_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, config.current_config.endemic_life_UI.creature_name_label.shadow.visibility = imgui.checkbox(
					language.current_language.customization_menu.visible, config.current_config.endemic_life_UI.creature_name_label.shadow.visibility);
				config_changed = config_changed or changed;
				endemic_life_UI_changed = endemic_life_UI_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, config.current_config.endemic_life_UI.creature_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
						config.current_config.endemic_life_UI.creature_name_label.shadow.offset.x, 0.1, -screen.width,
						screen.width, "%.1f");
					config_changed = config_changed or changed;
					endemic_life_UI_changed = endemic_life_UI_changed or changed;

					changed, config.current_config.endemic_life_UI.creature_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
						config.current_config.endemic_life_UI.creature_name_label.shadow.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
					config_changed = config_changed or changed;
					endemic_life_UI_changed = endemic_life_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, config.current_config.endemic_life_UI.creature_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.endemic_life_UI.creature_name_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					endemic_life_UI_changed = endemic_life_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	imgui.end_window();
	imgui.pop_font(customization_menu.font);

	if small_monster_UI_changed  or modifiers_changed then
		for _, monster in pairs(small_monster.list) do
			small_monster.init_UI(monster);
		end
	end

	if large_monster_dynamic_UI_changed or modifiers_changed then
		for _, monster in pairs(large_monster.list) do
			large_monster.init_dynamic_UI(monster);
		end
	end

	if large_monster_static_UI_changed or modifiers_changed then
		for _, monster in pairs(large_monster.list) do
			large_monster.init_static_UI(monster);
		end
	end

	if large_monster_highlighted_UI_changed or modifiers_changed then
		for _, monster in pairs(large_monster.list) do
			large_monster.init_highlighted_UI(monster);
		end
	end

	if time_UI_changed or modifiers_changed then
		time_UI.init_UI();
	end

	if damage_meter_UI_changed or modifiers_changed then
		for _, _player in pairs(player.list) do
			player.init_UI(_player);
			player.init_total_UI(player.total);
		end
	end

	if endemic_life_UI_changed or modifiers_changed then
		for _, creature in pairs(env_creature.list) do
			env_creature.init_UI(creature);
		end
	end

	if config_changed then
		config.save();
	end
end

function customization_menu.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
	screen = require("MHR_Overlay.Game_Handler.screen");
	player = require("MHR_Overlay.Damage_Meter.player");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	part_names = require("MHR_Overlay.Misc.part_names");
	time_UI = require("MHR_Overlay.UI.Modules.time_UI");
	keyboard = require("MHR_Overlay.Game_Handler.keyboard");

	customization_menu.init();
end

return customization_menu;
