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
local label_customization;
local bar_customization;

customization_menu.font = nil;
customization_menu.font_range = { 0x1, 0xFFFF, 0 };
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

customization_menu.displayed_damage_meter_UI_highlighted_bar_types = {};
customization_menu.displayed_damage_meter_UI_damage_bar_relative_types = {};
customization_menu.displayed_damage_meter_UI_my_damage_bar_location_types = {};
customization_menu.displayed_damage_meter_UI_sorting_types = {};
customization_menu.displayed_damage_meter_UI_dps_modes = {};

customization_menu.orientation_types = {};
customization_menu.anchor_types = {};
customization_menu.outline_styles = {};

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

customization_menu.fonts = { "Arial", "Arial Black", "Bahnschrift", "Calibri", "Cambria", "Cambria Math", "Candara",
	"Comic Sans MS", "Consolas", "Constantia", "Corbel", "Courier New", "Ebrima", "Franklin Gothic Medium", "Gabriola",
	"Gadugi", "Georgia", "HoloLens MDL2 Assets", "Impact", "Ink Free", "Javanese Text", "Leelawadee UI", "Lucida Console",
	"Lucida Sans Unicode", "Malgun Gothic", "Marlett", "Microsoft Himalaya", "Microsoft JhengHei", "Microsoft New Tai Lue",
	"Microsoft PhagsPa", "Microsoft Sans Serif", "Microsoft Tai Le", "Microsoft YaHei", "Microsoft Yi Baiti", "MingLiU-ExtB",
	"Mongolian Baiti", "MS Gothic", "MV Boli", "Myanmar Text", "Nirmala UI", "Palatino Linotype", "Segoe MDL2 Assets",
	"Segoe Print", "Segoe Script", "Segoe UI", "Segoe UI Historic", "Segoe UI Emoji", "Segoe UI Symbol", "SimSun", "Sitka",
	"Sylfaen", "Symbol", "Tahoma", "Times New Roman", "Trebuchet MS", "Verdana", "Webdings", "Wingdings", "Yu Gothic" };

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

function customization_menu.reload_font(pop_push)
	customization_menu.font = imgui.load_font(language.current_language.font_name,
		config.current_config.global_settings.menu_font.size, customization_menu.font_range);
	if pop_push then
		imgui.pop_font();
		imgui.push_font(customization_menu.font);
	end
end

function customization_menu.init()
	customization_menu.displayed_orientation_types = { language.current_language.customization_menu.horizontal,
		language.current_language.customization_menu.vertical };
	customization_menu.displayed_anchor_types = { language.current_language.customization_menu.top_left,
		language.current_language.customization_menu.top_right, language.current_language.customization_menu.bottom_left,
		language.current_language.customization_menu.bottom_right };

	customization_menu.displayed_outline_styles = { language.current_language.customization_menu.inside,
		language.current_language.customization_menu.center, language.current_language.customization_menu.outside };
	customization_menu.displayed_monster_UI_sorting_types = { language.current_language.customization_menu.normal,
		language.current_language.customization_menu.health, language.current_language.customization_menu.health_percentage,
		language.current_language.customization_menu.distance };

	customization_menu.displayed_monster_UI_parts_sorting_types = { language.current_language.customization_menu.normal,
		language.current_language.customization_menu.health, language.current_language.customization_menu.health_percentage,
		language.current_language.customization_menu.flinch_count, language.current_language.customization_menu.break_health,
		language.current_language.customization_menu.break_health_percentage,
		language.current_language.customization_menu.break_count, language.current_language.customization_menu.loss_health,
		language.current_language.customization_menu.loss_health_percentage };

	customization_menu.displayed_ailments_sorting_types = { language.current_language.customization_menu.normal,
		language.current_language.customization_menu.buildup, language.current_language.customization_menu.buildup_percentage };
	customization_menu.displayed_ailment_buildups_sorting_types = { language.current_language.customization_menu.normal,
		language.current_language.customization_menu.buildup, language.current_language.customization_menu.buildup_percentage };
	customization_menu.displayed_highlighted_buildup_bar_types = { language.current_language.customization_menu.me,
		language.current_language.customization_menu.top_buildup, language.current_language.customization_menu.none };
	customization_menu.displayed_buildup_bar_relative_types = { language.current_language.customization_menu.total_buildup,
		language.current_language.customization_menu.top_buildup };
	customization_menu.displayed_damage_meter_UI_highlighted_bar_types = { language.current_language.customization_menu.me,
		language.current_language.customization_menu.top_damage, language.current_language.customization_menu.top_dps,
		language.current_language.customization_menu.none };

	customization_menu.displayed_damage_meter_UI_damage_bar_relative_types = { language.current_language.customization_menu
		.total_damage, language.current_language.customization_menu.top_damage };
	customization_menu.displayed_damage_meter_UI_my_damage_bar_location_types = { language.current_language.customization_menu
		.normal, language.current_language.customization_menu.first, language.current_language.customization_menu.last };
	customization_menu.displayed_damage_meter_UI_sorting_types = { language.current_language.customization_menu.normal,
		language.current_language.customization_menu.damage, language.current_language.customization_menu.dps };
	customization_menu.displayed_damage_meter_UI_dps_modes = { language.current_language.customization_menu.first_hit,
		language.current_language.customization_menu.quest_time, language.current_language.customization_menu.join_time };

	customization_menu.orientation_types = { language.default_language.customization_menu.horizontal,
		language.default_language.customization_menu.vertical };
	customization_menu.anchor_types = { language.default_language.customization_menu.top_left,
		language.default_language.customization_menu.top_right, language.default_language.customization_menu.bottom_left,
		language.default_language.customization_menu.bottom_right };

	customization_menu.outline_styles = { language.default_language.customization_menu.inside,
		language.default_language.customization_menu.center, language.default_language.customization_menu.outside };
	customization_menu.monster_UI_sorting_types = { language.default_language.customization_menu.normal,
		language.default_language.customization_menu.health, language.default_language.customization_menu.health_percentage,
		language.default_language.customization_menu.distance };

	customization_menu.large_monster_UI_parts_sorting_types = { language.default_language.customization_menu.normal,
		language.default_language.customization_menu.health, language.default_language.customization_menu.health_percentage,
		language.default_language.customization_menu.flinch_count, language.default_language.customization_menu.break_health,
		language.default_language.customization_menu.break_health_percentage,
		language.default_language.customization_menu.break_count, language.default_language.customization_menu.loss_health,
		language.default_language.customization_menu.loss_health_percentage };

	customization_menu.ailments_sorting_types = { language.default_language.customization_menu.normal,
		language.default_language.customization_menu.buildup, language.default_language.customization_menu.buildup_percentage };
	customization_menu.ailment_buildups_sorting_types = { language.default_language.customization_menu.normal,
		language.default_language.customization_menu.buildup, language.default_language.customization_menu.buildup_percentage };
	customization_menu.highlighted_buildup_bar_types = { language.default_language.customization_menu.me,
		language.default_language.customization_menu.top_buildup, language.default_language.customization_menu.none };
	customization_menu.buildup_bar_relative_types = { language.default_language.customization_menu.total_buildup,
		language.default_language.customization_menu.top_buildup };

	customization_menu.damage_meter_UI_highlighted_bar_types = { language.default_language.customization_menu.me,
		language.default_language.customization_menu.top_damage, language.default_language.customization_menu.top_dps,
		language.default_language.customization_menu.none };
	customization_menu.damage_meter_UI_damage_bar_relative_types = { language.default_language.customization_menu.total_damage,
		language.default_language.customization_menu.top_damage };

	customization_menu.damage_meter_UI_my_damage_bar_location_types = { language.default_language.customization_menu.normal,
		language.default_language.customization_menu.first, language.default_language.customization_menu.last };
	customization_menu.damage_meter_UI_sorting_types = { language.default_language.customization_menu.normal,
		language.default_language.customization_menu.damage, language.default_language.customization_menu.dps };
	customization_menu.damage_meter_UI_dps_modes = { language.default_language.customization_menu.first_hit,
		language.default_language.customization_menu.quest_time, language.default_language.customization_menu.join_time };
end

function customization_menu.draw()
	imgui.set_next_window_pos(customization_menu.window_position, 1 << 3, customization_menu.window_pivot);
	imgui.set_next_window_size(customization_menu.window_size, 1 << 3);
	imgui.push_font(customization_menu.font);

	customization_menu.is_opened = imgui.begin_window(language.current_language.customization_menu.mod_name ..
		" " .. config.current_config.version, customization_menu.is_opened, customization_menu.window_flags);

	if not customization_menu.is_opened then
		imgui.end_window();
		imgui.pop_font();
		return;
	end

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

	modules_changed = customization_menu.draw_modules();

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
				customization_menu.large_monster_UI_waiting_for_key or customization_menu.large_monster_dynamic_UI_waiting_for_key or
				customization_menu.large_monster_static_UI_waiting_for_key or
				customization_menu.large_monster_highlighted_UI_waiting_for_key or customization_menu.time_UI_waiting_for_key or
				customization_menu.damage_meter_UI_waiting_for_key or customization_menu.endemic_life_UI_waiting_for_key;
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
				customization_menu.large_monster_UI_waiting_for_key or customization_menu.large_monster_dynamic_UI_waiting_for_key or
				customization_menu.large_monster_static_UI_waiting_for_key or
				customization_menu.large_monster_highlighted_UI_waiting_for_key or customization_menu.time_UI_waiting_for_key or
				customization_menu.damage_meter_UI_waiting_for_key or customization_menu.endemic_life_UI_waiting_for_key;
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
				customization_menu.small_monster_UI_waiting_for_key or customization_menu.large_monster_dynamic_UI_waiting_for_key or
				customization_menu.large_monster_static_UI_waiting_for_key or
				customization_menu.large_monster_highlighted_UI_waiting_for_key or customization_menu.time_UI_waiting_for_key or
				customization_menu.damage_meter_UI_waiting_for_key or customization_menu.endemic_life_UI_waiting_for_key;
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
				customization_menu.small_monster_UI_waiting_for_key or customization_menu.large_monster_UI_waiting_for_key or
				customization_menu.large_monster_static_UI_waiting_for_key or
				customization_menu.large_monster_highlighted_UI_waiting_for_key or customization_menu.time_UI_waiting_for_key or
				customization_menu.damage_meter_UI_waiting_for_key or customization_menu.endemic_life_UI_waiting_for_key;
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
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key or
				customization_menu.small_monster_UI_waiting_for_key or customization_menu.large_monster_UI_waiting_for_key or
				customization_menu.large_monster_dynamic_UI_waiting_for_key or
				customization_menu.large_monster_highlighted_UI_waiting_for_key or customization_menu.time_UI_waiting_for_key or
				customization_menu.damage_meter_UI_waiting_for_key or customization_menu.endemic_life_UI_waiting_for_key;
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
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key or
				customization_menu.small_monster_UI_waiting_for_key or customization_menu.large_monster_UI_waiting_for_key or
				customization_menu.large_monster_dynamic_UI_waiting_for_key or
				customization_menu.large_monster_static_UI_waiting_for_key or customization_menu.time_UI_waiting_for_key or
				customization_menu.damage_meter_UI_waiting_for_key or customization_menu.endemic_life_UI_waiting_for_key;
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
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key or
				customization_menu.small_monster_UI_waiting_for_key or customization_menu.large_monster_UI_waiting_for_key or
				customization_menu.large_monster_dynamic_UI_waiting_for_key or
				customization_menu.large_monster_static_UI_waiting_for_key or
				customization_menu.large_monster_highlighted_UI_waiting_for_key or customization_menu.damage_meter_UI_waiting_for_key
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
			local is_any_other_waiting = customization_menu.all_UI_waiting_for_key or
				customization_menu.small_monster_UI_waiting_for_key or customization_menu.large_monster_UI_waiting_for_key or
				customization_menu.large_monster_dynamic_UI_waiting_for_key or
				customization_menu.large_monster_static_UI_waiting_for_key or
				customization_menu.large_monster_highlighted_UI_waiting_for_key or customization_menu.time_UI_waiting_for_key or
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
				customization_menu.small_monster_UI_waiting_for_key or customization_menu.large_monster_UI_waiting_for_key or
				customization_menu.large_monster_dynamic_UI_waiting_for_key or
				customization_menu.large_monster_static_UI_waiting_for_key or
				customization_menu.large_monster_highlighted_UI_waiting_for_key or customization_menu.time_UI_waiting_for_key or
				customization_menu.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				customization_menu.endemic_life_UI_waiting_for_key = true;
			end
		end
		imgui.same_line();
		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI));
		imgui.tree_pop();
	end

	global_settings_changed, modifiers_changed, apply_font_requested = customization_menu.draw_global_settings();
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

	imgui.end_window();
	imgui.pop_font();

	if small_monster_UI_changed or modifiers_changed then
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
		end
		player.init_total_UI(player.total);
	end
	if endemic_life_UI_changed or modifiers_changed then
		for _, creature in pairs(env_creature.list) do
			env_creature.init_UI(creature);
		end
	end
	if customization_menu.menu_font_changed and apply_font_requested then
		customization_menu.menu_font_changed = false;
		customization_menu.reload_font(false);
	end
	if modules_changed or global_settings_changed or small_monster_UI_changed or large_monster_dynamic_UI_changed or
		large_monster_static_UI_changed or large_monster_highlighted_UI_changed or time_UI_changed or damage_meter_UI_changed
		or endemic_life_UI_changed then
		config.save();
	end
end

function customization_menu.draw_modules()
	local changed = false;
	local config_changed = false;
	if imgui.tree_node(language.current_language.customization_menu.modules) then
		changed, config.current_config.small_monster_UI.enabled = imgui.checkbox(language.current_language.customization_menu.small_monster_UI
			, config.current_config.small_monster_UI.enabled);
		config_changed = config_changed or changed;
		changed, config.current_config.large_monster_UI.dynamic.enabled = imgui.checkbox(language.current_language.customization_menu
			.large_monster_dynamic_UI, config.current_config.large_monster_UI.dynamic.enabled);
		config_changed = config_changed or changed;
		changed, config.current_config.large_monster_UI.static.enabled = imgui.checkbox(language.current_language.customization_menu
			.large_monster_static_UI, config.current_config.large_monster_UI.static.enabled);
		config_changed = config_changed or changed;
		changed, config.current_config.large_monster_UI.highlighted.enabled = imgui.checkbox(language.current_language.customization_menu
			.large_monster_highlighted_UI, config.current_config.large_monster_UI.highlighted.enabled);
		config_changed = config_changed or changed;
		changed, config.current_config.time_UI.enabled = imgui.checkbox(language.current_language.customization_menu.time_UI,
			config.current_config.time_UI.enabled);
		config_changed = config_changed or changed;
		changed, config.current_config.damage_meter_UI.enabled = imgui.checkbox(language.current_language.customization_menu.damage_meter_UI
			, config.current_config.damage_meter_UI.enabled);
		config_changed = config_changed or changed;
		changed, config.current_config.endemic_life_UI.enabled = imgui.checkbox(language.current_language.customization_menu.endemic_life_UI
			, config.current_config.endemic_life_UI.enabled);
		config_changed = config_changed or changed;
		imgui.tree_pop();
	end
	return config_changed;
end

function customization_menu.draw_global_settings()
	local changed = false;
	local config_changed = false;
	local modifiers_changed = false;
	local apply_font_requested = false;
	local index = 1;
	if imgui.tree_node(language.current_language.customization_menu.global_settings) then
		local cached_config = config.current_config.global_settings;
		imgui.text(language.current_language.customization_menu.menu_font_change_disclaimer);
		changed, index = imgui.combo(language.current_language.customization_menu.language .. "*",
			table_helpers.find_index(language.language_names, ached_config.language), language.language_names);
		config_changed = config_changed or changed;
		if changed then
			cached_config.language = language.language_names[index];
			language.update(index);
			customization_menu.init();
			apply_font_requested = true;
			customization_menu.menu_font_changed = true;
			part_names.init();
			small_monster.init_list();
			large_monster.init_list();
			env_creature.init_list();
			player.init_UI(player.myself);
			player.init_UI(player.total);
			for _, _player in pairs(player.list) do
				player.init_UI(_player);
			end
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
			changed, cached_config.modifiers.global_position_modifier = imgui.drag_float(language.current_language.customization_menu
				.global_position_modifier, cached_config.modifiers.global_position_modifier, 0.01, 0.01, 10, "%.1f");
			config_changed = config_changed or changed;
			modifiers_changed = modifiers_changed or changed;
			changed, cached_config.modifiers.global_scale_modifier = imgui.drag_float(language.current_language.customization_menu
				.global_scale_modifier, cached_config.modifiers.global_scale_modifier, 0.01, 0.01, 10, "%.1f");
			config_changed = config_changed or changed;
			modifiers_changed = modifiers_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.performance) then
			changed, cached_config.performance.max_monster_updates_per_tick = imgui.slider_int(language.current_language.customization_menu
				.max_monster_updates_per_tick, cached_config.performance.max_monster_updates_per_tick, 1, 150);
			config_changed = config_changed or changed;
			changed, cached_config.performance.prioritize_large_monsters = imgui.checkbox(language.current_language.customization_menu
				.prioritize_large_monsters, cached_config.performance.prioritize_large_monsters);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.module_visibility_on_different_screens) then
			if imgui.tree_node(language.current_language.customization_menu.during_quest) then
				changed, cached_config.module_visibility.during_quest.small_monster_UI = imgui.checkbox(language.current_language.customization_menu
					.small_monster_UI, cached_config.module_visibility.during_quest.small_monster_UI);
				config_changed = config_changed or changed;
				changed, cached_config.module_visibility.during_quest.large_monster_dynamic_UI = imgui.checkbox(language.current_language
					.customization_menu.large_monster_dynamic_UI,
					cached_config.module_visibility.during_quest.large_monster_dynamic_UI);
				config_changed = config_changed or changed;
				imgui.same_line();
				changed, cached_config.module_visibility.during_quest.large_monster_static_UI = imgui.checkbox(language.current_language
					.customization_menu.large_monster_static_UI, cached_config.module_visibility.during_quest.large_monster_static_UI);
				config_changed = config_changed or changed;
				changed, cached_config.module_visibility.during_quest.large_monster_highlighted_UI = imgui.checkbox(language.current_language
					.customization_menu.large_monster_highlighted_UI,
					cached_config.module_visibility.during_quest.large_monster_highlighted_UI);
				config_changed = config_changed or changed;
				changed, cached_config.module_visibility.during_quest.time_UI = imgui.checkbox(language.current_language.customization_menu
					.time_UI, cached_config.module_visibility.during_quest.time_UI);
				config_changed = config_changed or changed;
				imgui.same_line();
				changed, cached_config.module_visibility.during_quest.damage_meter_UI = imgui.checkbox(language.current_language.customization_menu
					.damage_meter_UI, cached_config.module_visibility.during_quest.damage_meter_UI);
				config_changed = config_changed or changed;
				changed, cached_config.module_visibility.during_quest.endemic_life_UI = imgui.checkbox(language.current_language.customization_menu
					.endemic_life_UI, cached_config.module_visibility.during_quest.endemic_life_UI);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.quest_result_screen) then
				changed, cached_config.module_visibility.quest_result_screen.small_monster_UI = imgui.checkbox(language.current_language
					.customization_menu.small_monster_UI, cached_config.module_visibility.quest_result_screen.small_monster_UI);
				config_changed = config_changed or changed;
				changed, cached_config.module_visibility.quest_result_screen.large_monster_dynamic_UI = imgui.checkbox(language.current_language
					.customization_menu.large_monster_dynamic_UI,
					cached_config.module_visibility.quest_result_screen.large_monster_dynamic_UI);
				config_changed = config_changed or changed;
				imgui.same_line();
				changed, cached_config.module_visibility.quest_result_screen.large_monster_static_UI = imgui.checkbox(language.current_language
					.customization_menu.large_monster_static_UI,
					cached_config.module_visibility.quest_result_screen.large_monster_static_UI);
				config_changed = config_changed or changed;
				changed, cached_config.module_visibility.quest_result_screen.large_monster_highlighted_UI = imgui.checkbox(language.current_language
					.customization_menu.large_monster_highlighted_UI,
					cached_config.module_visibility.quest_result_screen.large_monster_highlighted_UI);
				config_changed = config_changed or changed;
				changed, cached_config.module_visibility.quest_result_screen.time_UI = imgui.checkbox(language.current_language.customization_menu
					.time_UI, cached_config.module_visibility.quest_result_screen.time_UI);
				config_changed = config_changed or changed;
				imgui.same_line();
				changed, cached_config.module_visibility.quest_result_screen.damage_meter_UI = imgui.checkbox(language.current_language
					.customization_menu.damage_meter_UI, cached_config.module_visibility.quest_result_screen.damage_meter_UI);
				config_changed = config_changed or changed;
				changed, cached_config.module_visibility.during_quest.endemic_life_UI = imgui.checkbox(language.current_language.customization_menu
					.endemic_life_UI, cached_config.module_visibility.during_quest.endemic_life_UI);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.training_area) then
				changed, cached_config.module_visibility.training_area.large_monster_dynamic_UI = imgui.checkbox(language.current_language
					.customization_menu.large_monster_dynamic_UI,
					cached_config.module_visibility.training_area.large_monster_dynamic_UI);
				config_changed = config_changed or changed;
				imgui.same_line();
				changed, cached_config.module_visibility.training_area.large_monster_static_UI = imgui.checkbox(language.current_language
					.customization_menu.large_monster_static_UI, cached_config.module_visibility.training_area.large_monster_static_UI);
				config_changed = config_changed or changed;
				changed, cached_config.module_visibility.training_area.damage_meter_UI = imgui.checkbox(language.current_language.customization_menu
					.damage_meter_UI, cached_config.module_visibility.training_area.damage_meter_UI);
				config_changed = config_changed or changed;
				changed, cached_config.module_visibility.during_quest.endemic_life_UI = imgui.checkbox(language.current_language.customization_menu
					.endemic_life_UI, cached_config.module_visibility.during_quest.endemic_life_UI);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			imgui.tree_pop();
		end
		imgui.tree_pop();
	end
	return config_changed, modifiers_changed, apply_font_requested;
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
			changed, cached_config.settings.hide_dead_or_captured = imgui.checkbox(language.current_language.customization_menu.hide_dead_or_captured
				, config.current_config.small_monster_UI.settings.hide_dead_or_captured);
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
			changed, cached_config.dynamic_positioning.enabled = imgui.checkbox(language.current_language.customization_menu.enabled
				, cached_config.dynamic_positioning.enabled);
			config_changed = config_changed or changed;
			changed, cached_config.dynamic_positioning.opacity_falloff = imgui.checkbox(language.current_language.customization_menu
				.opacity_falloff, cached_config.dynamic_positioning.opacity_falloff);
			config_changed = config_changed or changed;
			changed, cached_config.dynamic_positioning.max_distance = imgui.drag_float(language.current_language.customization_menu
				.max_distance, cached_config.dynamic_positioning.max_distance, 1, 0, 10000, "%.0f");
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.world_offset) then
				changed, cached_config.dynamic_positioning.world_offset.x = imgui.drag_float(language.current_language.customization_menu
					.x, cached_config.dynamic_positioning.world_offset.x, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.dynamic_positioning.world_offset.y = imgui.drag_float(language.current_language.customization_menu
					.y, cached_config.dynamic_positioning.world_offset.y, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.dynamic_positioning.world_offset.z = imgui.drag_float(language.current_language.customization_menu
					.z, cached_config.dynamic_positioning.world_offset.z, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.viewport_offset) then
				changed, cached_config.dynamic_positioning.viewport_offset.x = imgui.drag_float(language.current_language.customization_menu
					.x, cached_config.dynamic_positioning.viewport_offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.dynamic_positioning.viewport_offset.y = imgui.drag_float(language.current_language.customization_menu
					.y, cached_config.dynamic_positioning.viewport_offset.y, 0.1, -screen.height, screen.height, "%.1f");
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
			changed, index = imgui.combo(language.current_language.customization_menu.anchor,
				table_helpers.find_index(customization_menu.anchor_types, cached_config.static_position.anchor),
				customization_menu.displayed_anchor_types);
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
			changed, index = imgui.combo(language.current_language.customization_menu.type,
				table_helpers.find_index(customization_menu.monster_UI_sorting_types, cached_config.static_sorting.type),
				customization_menu.displayed_monster_UI_sorting_types);
			config_changed = config_changed or changed;
			if changed then
				cached_config.static_sorting.type = customization_menu.monster_UI_sorting_types[index];
			end
			changed, cached_config.static_sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu.reversed_order
				, cached_config.static_sorting.reversed_order);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		changed = label_customization.draw(language.current_language.customization_menu.monster_name_label,
			cached_config.monster_name_label);
		config_changed = config_changed or changed;
		config_changed = config_changed or changed;
		if imgui.tree_node(language.current_language.customization_menu.health) then
			changed, cached_config.health.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.health.visibility);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.health.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.health.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.health.percentage_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.health.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.ailments) then
			changed, cached_config.ailments.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.ailments.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.ailments.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailments.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailments.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailments.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.spacing) then
				changed, cached_config.ailments.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailments.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailments.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailments.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, cached_config.ailments.settings.hide_ailments_with_zero_buildup = imgui.checkbox(language.current_language.customization_menu
					.hide_ailments_with_zero_buildup, cached_config.ailments.settings.hide_ailments_with_zero_buildup);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_inactive_ailments_with_no_buildup_support = imgui.checkbox(language.current_language
					.customization_menu.hide_inactive_ailments_with_no_buildup_support,
					cached_config.ailments.settings.hide_inactive_ailments_with_no_buildup_support);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_all_inactive_ailments = imgui.checkbox(language.current_language.customization_menu
					.hide_all_inactive_ailments, cached_config.ailments.settings.hide_all_inactive_ailments);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_all_active_ailments = imgui.checkbox(language.current_language.customization_menu
					.hide_all_active_ailments, cached_config.ailments.settings.hide_all_active_ailments);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_disabled_ailments = imgui.checkbox(language.current_language.customization_menu
					.hide_disabled_ailments, cached_config.ailments.settings.hide_disabled_ailments);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit
					, cached_config.ailments.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, index = imgui.combo(language.current_language.customization_menu.type,
					table_helpers.find_index(customization_menu.ailments_sorting_types, cached_config.ailments.sorting.type),
					customization_menu.displayed_ailments_sorting_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailments.sorting.type = customization_menu.ailments_sorting_types[index];
				end
				changed, cached_config.ailments.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu
					.reversed_order, cached_config.ailments.sorting.reversed_order);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.filter) then
				changed, cached_config.ailments.filter.paralysis = imgui.checkbox(language.current_language.ailments.paralysis,
					cached_config.ailments.filter.paralysis);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.sleep = imgui.checkbox(language.current_language.ailments.sleep,
					cached_config.ailments.filter.sleep);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.stun = imgui.checkbox(language.current_language.ailments.stun,
					cached_config.ailments.filter.stun);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.flash = imgui.checkbox(language.current_language.ailments.flash,
					cached_config.ailments.filter.flash);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.poison = imgui.checkbox(language.current_language.ailments.poison,
					cached_config.ailments.filter.poison);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.blast = imgui.checkbox(language.current_language.ailments.blast,
					cached_config.ailments.filter.blast);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.exhaust = imgui.checkbox(language.current_language.ailments.exhaust,
					cached_config.ailments.filter.exhaust);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.ride = imgui.checkbox(language.current_language.ailments.ride,
					cached_config.ailments.filter.ride);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.waterblight = imgui.checkbox(language.current_language.ailments.waterblight,
					cached_config.ailments.filter.waterblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.fireblight = imgui.checkbox(language.current_language.ailments.fireblight,
					cached_config.ailments.filter.fireblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.iceblight = imgui.checkbox(language.current_language.ailments.iceblight,
					cached_config.ailments.filter.iceblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.thunderblight = imgui.checkbox(language.current_language.ailments.thunderblight
					, cached_config.ailments.filter.thunderblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.fall_trap = imgui.checkbox(language.current_language.ailments.fall_trap,
					cached_config.ailments.filter.fall_trap);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.shock_trap = imgui.checkbox(language.current_language.ailments.shock_trap,
					cached_config.ailments.filter.shock_trap);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.tranq_bomb = imgui.checkbox(language.current_language.ailments.tranq_bomb,
					cached_config.ailments.filter.tranq_bomb);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.dung_bomb = imgui.checkbox(language.current_language.ailments.dung_bomb,
					cached_config.ailments.filter.dung_bomb);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.steel_fang = imgui.checkbox(language.current_language.ailments.steel_fang,
					cached_config.ailments.filter.steel_fang);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.quick_sand = imgui.checkbox(language.current_language.ailments.quick_sand,
					cached_config.ailments.filter.quick_sand);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.fall_otomo_trap = imgui.checkbox(language.current_language.ailments.fall_otomo_trap
					, cached_config.ailments.filter.fall_otomo_trap);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.shock_otomo_trap = imgui.checkbox(language.current_language.ailments.shock_otomo_trap
					, cached_config.ailments.filter.shock_otomo_trap);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
				changed, cached_config.ailments.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.ailments.ailment_name_label.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, cached_config.ailments.ailment_name_label.include.ailment_name = imgui.checkbox(language.current_language.customization_menu
						.ailment_name, cached_config.ailments.ailment_name_label.include.ailment_name);
					config_changed = config_changed or changed;
					changed, cached_config.ailments.ailment_name_label.include.activation_count = imgui.checkbox(language.current_language
						.customization_menu.activation_count, cached_config.ailments.ailment_name_label.include.activation_count);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.ailments.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.ailments.ailment_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.ailments.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.ailments.ailment_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.ailments.ailment_name_label.color = imgui.color_picker_argb("",
						cached_config.ailments.ailment_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, cached_config.ailments.ailment_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu
						.visible, cached_config.ailments.ailment_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, cached_config.ailments.ailment_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu
							.x, cached_config.ailments.ailment_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						changed, cached_config.ailments.ailment_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu
							.y, cached_config.ailments.ailment_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, cached_config.ailments.ailment_name_label.shadow.color = imgui.color_picker_argb("",
							cached_config.ailments.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.ailments.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.ailments.value_label.visibility);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.ailments.percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.timer_label,
				cached_config.ailments.timer_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.ailments.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.ailment_buildups) then
			changed, cached_config.ailment_buildups.visibility = imgui.checkbox(language.current_language.customization_menu.visible
				, cached_config.ailment_buildups.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.ailment_buildups.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailment_buildups.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailment_buildups.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailment_buildups.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.player_spacing) then
				changed, cached_config.ailment_buildups.player_spacing.x = imgui.drag_float(language.current_language.customization_menu
					.x, cached_config.ailment_buildups.player_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailment_buildups.player_spacing.y = imgui.drag_float(language.current_language.customization_menu
					.y, cached_config.ailment_buildups.player_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.ailment_spacing) then
				changed, cached_config.ailment_buildups.ailment_spacing.x = imgui.drag_float(language.current_language.customization_menu
					.x, cached_config.ailment_buildups.ailment_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailment_buildups.ailment_spacing.y = imgui.drag_float(language.current_language.customization_menu
					.y, cached_config.ailment_buildups.ailment_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, index = imgui.combo(language.current_language.customization_menu.highlighted_bar,
					table_helpers.find_index(customization_menu.highlighted_buildup_bar_types,
						cached_config.ailment_buildups.settings.highlighted_bar),
					customization_menu.displayed_highlighted_buildup_bar_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailment_buildups.settings.highlighted_bar = customization_menu.highlighted_buildup_bar_types[index];
				end
				changed, index = imgui.combo(language.current_language.customization_menu.buildup_bars_are_relative_to,
					table_helpers.find_index(customization_menu.displayed_buildup_bar_relative_types,
						cached_config.ailment_buildups.settings.buildup_bar_relative_to),
					customization_menu.displayed_buildup_bar_relative_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailment_buildups.settings.buildup_bar_relative_to = customization_menu.displayed_buildup_bar_relative_types
						[index];
				end
				changed, cached_config.ailment_buildups.settings.time_limit = imgui.drag_float(language.current_language.customization_menu
					.time_limit, cached_config.ailment_buildups.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.filter) then
				changed, cached_config.ailment_buildups.filter.stun = imgui.checkbox(language.current_language.ailments.stun,
					cached_config.ailment_buildups.filter.stun);
				changed, cached_config.ailment_buildups.filter.poison = imgui.checkbox(language.current_language.ailments.poison,
					cached_config.ailment_buildups.filter.poison);
				changed, cached_config.ailment_buildups.filter.blast = imgui.checkbox(language.current_language.ailments.blast,
					cached_config.ailment_buildups.filter.blast);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, index = imgui.combo(language.current_language.customization_menu.type,
					table_helpers.find_index(customization_menu.ailment_buildups_sorting_types,
						cached_config.ailment_buildups.sorting.type), customization_menu.displayed_ailment_buildups_sorting_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailment_buildups.sorting.type = customization_menu.ailment_buildups_sorting_types[index];
				end
				changed, cached_config.ailment_buildups.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu
					.reversed_order, cached_config.ailment_buildups.sorting.reversed_order);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
				changed, cached_config.ailment_buildups.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.ailment_buildups.ailment_name_label.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, cached_config.ailment_buildups.ailment_name_label.include.ailment_name = imgui.checkbox(language.current_language
						.customization_menu.ailment_name, cached_config.ailment_buildups.ailment_name_label.include.ailment_name);
					config_changed = config_changed or changed;
					changed, cached_config.ailment_buildups.ailment_name_label.include.activation_count = imgui.checkbox(language.current_language
						.customization_menu.activation_count, cached_config.ailment_buildups.ailment_name_label.include.activation_count);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.ailment_buildups.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.ailment_buildups.ailment_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.ailment_buildups.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.ailment_buildups.ailment_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.ailment_buildups.ailment_name_label.color = imgui.color_picker_argb("",
						cached_config.ailment_buildups.ailment_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end


				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, cached_config.ailment_buildups.ailment_name_label.shadow.visibility = imgui.checkbox(language.current_language
						.customization_menu.visible, cached_config.ailment_buildups.ailment_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, cached_config.ailment_buildups.ailment_name_label.shadow.offset.x = imgui.drag_float(language.current_language
							.customization_menu.x, cached_config.ailment_buildups.ailment_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						changed, cached_config.ailment_buildups.ailment_name_label.shadow.offset.y = imgui.drag_float(language.current_language
							.customization_menu.y, cached_config.ailment_buildups.ailment_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, cached_config.ailment_buildups.ailment_name_label.shadow.color = imgui.color_picker_argb("",
							cached_config.ailment_buildups.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.player_name_label,
				cached_config.ailment_buildups.player_name_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.buildup_value_label,
				cached_config.ailment_buildups.buildup_value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.buildup_percentage_label,
				cached_config.ailment_buildups.buildup_percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.total_buildup_label,
				cached_config.ailment_buildups.total_buildup_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.total_buildup_value_label,
				cached_config.ailment_buildups.total_buildup_value_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.buildup_bar,
				cached_config.ailment_buildups.buildup_bar);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.highlighted_buildup_bar,
				cached_config.ailment_buildups.highlighted_buildup_bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
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
		changed, cached_config.enabled = imgui.checkbox(language.current_language.customization_menu.enabled,
			cached_config.enabled);
		config_changed = config_changed or changed;
		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_dead_or_captured = imgui.checkbox(language.current_language.customization_menu.hide_dead_or_captured
				, cached_config.settings.hide_dead_or_captured);
			config_changed = config_changed or changed;
			changed, cached_config.settings.render_highlighted_monster = imgui.checkbox(language.current_language.customization_menu
				.render_highlighted_monster, cached_config.settings.render_highlighted_monster);
			config_changed = config_changed or changed;
			changed, cached_config.settings.render_not_highlighted_monsters = imgui.checkbox(language.current_language.customization_menu
				.render_not_highlighted_monsters, cached_config.settings.render_not_highlighted_monsters);
			config_changed = config_changed or changed;
			changed, cached_config.settings.opacity_falloff = imgui.checkbox(language.current_language.customization_menu.opacity_falloff
				, cached_config.settings.opacity_falloff);
			config_changed = config_changed or changed;
			changed, cached_config.settings.max_distance = imgui.drag_float(language.current_language.customization_menu.max_distance
				, cached_config.settings.max_distance, 1, 0, 10000, "%.0f");
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.world_offset) then
			changed, cached_config.world_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.world_offset.x, 0.1, -100, 100, "%.1f");
			config_changed = config_changed or changed;
			changed, cached_config.world_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.world_offset.y, 0.1, -100, 100, "%.1f");
			config_changed = config_changed or changed;
			changed, cached_config.world_offset.z = imgui.drag_float(language.current_language.customization_menu.z,
				cached_config.world_offset.z, 0.1, -100, 100, "%.1f");
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.viewport_offset) then
			changed, cached_config.viewport_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.viewport_offset.x, 0.1, -screen.width, screen.width, "%.1f");
			config_changed = config_changed or changed;
			changed, cached_config.viewport_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.viewport_offset.y, 0.1, -screen.height, screen.height, "%.1f");
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.monster_name_label) then
			changed, cached_config.monster_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible
				, cached_config.monster_name_label.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.include) then
				changed, cached_config.monster_name_label.include.monster_name = imgui.checkbox(language.current_language.customization_menu
					.monster_name, cached_config.monster_name_label.include.monster_name);
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.include.monster_id = imgui.checkbox(language.current_language.customization_menu
					.monster_id, cached_config.monster_name_label.include.monster_id);
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.include.crown = imgui.checkbox(language.current_language.customization_menu
					.crown, cached_config.monster_name_label.include.crown);
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.include.size = imgui.checkbox(language.current_language.customization_menu
					.size, cached_config.monster_name_label.include.size);
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.include.scrown_thresholds = imgui.checkbox(language.current_language.customization_menu
					.crown_thresholds, cached_config.monster_name_label.include.scrown_thresholds);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.monster_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x
					, cached_config.monster_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y
					, cached_config.monster_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, cached_config.monster_name_label.color = imgui.color_picker_argb("", cached_config.monster_name_label.color
					, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, cached_config.monster_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.monster_name_label.shadow.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.monster_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.monster_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.monster_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.monster_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.monster_name_label.shadow.color = imgui.color_picker_argb("",
						cached_config.monster_name_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.health) then
			changed, cached_config.health.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.health.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.health.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.health.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.health.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.health.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.health.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.health.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.health.percentage_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.health.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.stamina) then
			changed, cached_config.stamina.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.stamina.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.stamina.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.stamina.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.stamina.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.stamina.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.stamina.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.stamina.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.stamina.percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.timer_label,
				cached_config.stamina.timer_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.stamina.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.rage) then
			changed, cached_config.rage.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.rage.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.rage.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.rage.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.rage.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.rage.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.rage.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.rage.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.rage.percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.timer_label,
				cached_config.rage.timer_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.rage.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.body_parts) then
			changed, cached_config.body_parts.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.body_parts.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.body_parts.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.body_parts.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.body_parts.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.spacing) then
				changed, cached_config.body_parts.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.body_parts.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.body_parts.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, cached_config.body_parts.settings.hide_undamaged_parts = imgui.checkbox(language.current_language.customization_menu
					.hide_undamaged_parts, cached_config.body_parts.settings.hide_undamaged_parts);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.settings.time_limit = imgui.drag_float(language.current_language.customization_menu
					.time_limit, cached_config.body_parts.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, index = imgui.combo(language.current_language.customization_menu.type,
					table_helpers.find_index(customization_menu.large_monster_UI_parts_sorting_types,
						cached_config.body_parts.sorting.type), customization_menu.displayed_monster_UI_parts_sorting_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.body_parts.sorting.type = customization_menu.large_monster_UI_parts_sorting_types[index];
				end
				changed, cached_config.body_parts.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu
					.reversed_order, cached_config.body_parts.sorting.reversed_order);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.filter) then
				changed, cached_config.body_parts.filter.health_break_severe = imgui.checkbox(language.current_language.customization_menu
					.health_break_severe_filter, cached_config.body_parts.filter.health_break_severe);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.health_break = imgui.checkbox(language.current_language.customization_menu.health_break_filter
					, cached_config.body_parts.filter.health_break);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.health_severe = imgui.checkbox(language.current_language.customization_menu
					.health_severe_filter, cached_config.body_parts.filter.health_severe);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.health = imgui.checkbox(language.current_language.customization_menu.health_filter
					, cached_config.body_parts.filter.health);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.break_severe = imgui.checkbox(language.current_language.customization_menu.break_severe_filter
					, cached_config.body_parts.filter.break_severe);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.break_ = imgui.checkbox(language.current_language.customization_menu.break_filter
					, cached_config.body_parts.filter.break_);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.severe = imgui.checkbox(language.current_language.customization_menu.severe_filter
					, cached_config.body_parts.filter.severe);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.part_name_label) then
				changed, cached_config.body_parts.part_name_label.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.body_parts.part_name_label.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, cached_config.body_parts.part_name_label.include.part_name = imgui.checkbox(language.current_language.customization_menu
						.part_name, cached_config.body_parts.part_name_label.include.part_name);
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_name_label.include.flinch_count = imgui.checkbox(language.current_language.customization_menu
						.flinch_count, cached_config.body_parts.part_name_label.include.flinch_count);
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_name_label.include.break_count = imgui.checkbox(language.current_language.customization_menu
						.break_count, cached_config.body_parts.part_name_label.include.break_count);
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_name_label.include.break_max_count = imgui.checkbox(language.current_language
						.customization_menu.break_max_count, cached_config.body_parts.part_name_label.include.break_max_count);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.body_parts.part_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.body_parts.part_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.body_parts.part_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.body_parts.part_name_label.color = imgui.color_picker_argb("",
						cached_config.body_parts.part_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, cached_config.body_parts.part_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu
						.visible, cached_config.body_parts.part_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, cached_config.body_parts.part_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu
							.x, cached_config.body_parts.part_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						changed, cached_config.body_parts.part_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu
							.y, cached_config.body_parts.part_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, cached_config.body_parts.part_name_label.shadow.color = imgui.color_picker_argb("",
							cached_config.body_parts.part_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.part_health) then
				changed, cached_config.body_parts.part_health.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.body_parts.part_health.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.body_parts.part_health.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.body_parts.part_health.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_health.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.body_parts.part_health.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				changed = label_customization.draw(language.current_language.customization_menu.text_label,
					cached_config.body_parts.part_health.text_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.value_label,
					cached_config.body_parts.part_health.value_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
					cached_config.body_parts.part_health.percentage_label);
				config_changed = config_changed or changed;
				changed = bar_customization.draw(language.current_language.customization_menu.bar,
					cached_config.body_parts.part_health.bar);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.break_health) then
				changed, cached_config.body_parts.part_break.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.body_parts.part_break.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.body_parts.part_break.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.body_parts.part_break.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_break.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.body_parts.part_break.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				changed = label_customization.draw(language.current_language.customization_menu.text_label,
					cached_config.body_parts.part_break.text_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.value_label,
					cached_config.body_parts.part_break.value_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
					cached_config.body_parts.part_break.percentage_label);
				config_changed = config_changed or changed;
				changed = bar_customization.draw(language.current_language.customization_menu.bar,
					cached_config.body_parts.part_break.bar);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.loss_health) then
				changed, cached_config.body_parts.part_loss.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.body_parts.part_loss.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.body_parts.part_loss.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.body_parts.part_loss.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_loss.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.body_parts.part_loss.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				changed = label_customization.draw(language.current_language.customization_menu.text_label,
					cached_config.body_parts.part_loss.text_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.value_label,
					cached_config.body_parts.part_loss.value_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
					cached_config.body_parts.part_loss.percentage_label);
				config_changed = config_changed or changed;
				changed = bar_customization.draw(language.current_language.customization_menu.bar,
					cached_config.body_parts.part_loss.bar);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.ailments) then
			changed, cached_config.ailments.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.ailments.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.ailments.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailments.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailments.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailments.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.relative_offset) then
				changed, cached_config.ailments.relative_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailments.relative_offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailments.relative_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailments.relative_offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.spacing) then
				changed, cached_config.ailments.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailments.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailments.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailments.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, cached_config.ailments.settings.hide_ailments_with_zero_buildup = imgui.checkbox(language.current_language.customization_menu
					.hide_ailments_with_zero_buildup, cached_config.ailments.settings.hide_ailments_with_zero_buildup);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_inactive_ailments_with_no_buildup_support = imgui.checkbox(language.current_language
					.customization_menu.hide_inactive_ailments_with_no_buildup_support,
					cached_config.ailments.settings.hide_inactive_ailments_with_no_buildup_support);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_all_inactive_ailments = imgui.checkbox(language.current_language.customization_menu
					.hide_all_inactive_ailments, cached_config.ailments.settings.hide_all_inactive_ailments);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_all_active_ailments = imgui.checkbox(language.current_language.customization_menu
					.hide_all_active_ailments, cached_config.ailments.settings.hide_all_active_ailments);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_disabled_ailments = imgui.checkbox(language.current_language.customization_menu
					.hide_disabled_ailments, cached_config.ailments.settings.hide_disabled_ailments);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.offset_is_relative_to_parts = imgui.checkbox(language.current_language.customization_menu
					.offset_is_relative_to_parts, cached_config.ailments.settings.offset_is_relative_to_parts);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit
					, cached_config.ailments.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, index = imgui.combo(language.current_language.customization_menu.type,
					table_helpers.find_index(customization_menu.ailments_sorting_types, cached_config.ailments.sorting.type),
					customization_menu.displayed_ailments_sorting_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailments.sorting.type = customization_menu.ailments_sorting_types[index];
				end
				changed, cached_config.ailments.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu
					.reversed_order, cached_config.ailments.sorting.reversed_order);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.filter) then
				changed, cached_config.ailments.filter.paralysis = imgui.checkbox(language.current_language.ailments.paralysis,
					cached_config.ailments.filter.paralysis);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.sleep = imgui.checkbox(language.current_language.ailments.sleep,
					cached_config.ailments.filter.sleep);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.stun = imgui.checkbox(language.current_language.ailments.stun,
					cached_config.ailments.filter.stun);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.flash = imgui.checkbox(language.current_language.ailments.flash,
					cached_config.ailments.filter.flash);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.poison = imgui.checkbox(language.current_language.ailments.poison,
					cached_config.ailments.filter.poison);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.blast = imgui.checkbox(language.current_language.ailments.blast,
					cached_config.ailments.filter.blast);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.exhaust = imgui.checkbox(language.current_language.ailments.exhaust,
					cached_config.ailments.filter.exhaust);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.ride = imgui.checkbox(language.current_language.ailments.ride,
					cached_config.ailments.filter.ride);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.waterblight = imgui.checkbox(language.current_language.ailments.waterblight,
					cached_config.ailments.filter.waterblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.fireblight = imgui.checkbox(language.current_language.ailments.fireblight,
					cached_config.ailments.filter.fireblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.iceblight = imgui.checkbox(language.current_language.ailments.iceblight,
					cached_config.ailments.filter.iceblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.thunderblight = imgui.checkbox(language.current_language.ailments.thunderblight
					, cached_config.ailments.filter.thunderblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.fall_trap = imgui.checkbox(language.current_language.ailments.fall_trap,
					cached_config.ailments.filter.fall_trap);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.shock_trap = imgui.checkbox(language.current_language.ailments.shock_trap,
					cached_config.ailments.filter.shock_trap);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.tranq_bomb = imgui.checkbox(language.current_language.ailments.tranq_bomb,
					cached_config.ailments.filter.tranq_bomb);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.dung_bomb = imgui.checkbox(language.current_language.ailments.dung_bomb,
					cached_config.ailments.filter.dung_bomb);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.steel_fang = imgui.checkbox(language.current_language.ailments.steel_fang,
					cached_config.ailments.filter.steel_fang);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.quick_sand = imgui.checkbox(language.current_language.ailments.quick_sand,
					cached_config.ailments.filter.quick_sand);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.fall_otomo_trap = imgui.checkbox(language.current_language.ailments.fall_otomo_trap
					, cached_config.ailments.filter.fall_otomo_trap);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.shock_otomo_trap = imgui.checkbox(language.current_language.ailments.shock_otomo_trap
					, cached_config.ailments.filter.shock_otomo_trap);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
				changed, cached_config.ailments.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.ailments.ailment_name_label.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, cached_config.ailments.ailment_name_label.include.ailment_name = imgui.checkbox(language.current_language.customization_menu
						.ailment_name, cached_config.ailments.ailment_name_label.include.ailment_name);
					config_changed = config_changed or changed;
					changed, cached_config.ailments.ailment_name_label.include.activation_count = imgui.checkbox(language.current_language
						.customization_menu.activation_count, cached_config.ailments.ailment_name_label.include.activation_count);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.ailments.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.ailments.ailment_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.ailments.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.ailments.ailment_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.ailments.ailment_name_label.color = imgui.color_picker_argb("",
						cached_config.ailments.ailment_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, cached_config.ailments.ailment_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu
						.visible, cached_config.ailments.ailment_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, cached_config.ailments.ailment_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu
							.x, cached_config.ailments.ailment_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						changed, cached_config.ailments.ailment_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu
							.y, cached_config.ailments.ailment_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, cached_config.ailments.ailment_name_label.shadow.color = imgui.color_picker_argb("",
							cached_config.ailments.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.ailments.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.ailments.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.ailments.percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.timer_label,
				cached_config.ailments.timer_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.ailments.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.ailment_buildups) then
			changed, cached_config.ailment_buildups.visibility = imgui.checkbox(language.current_language.customization_menu.visible
				, cached_config.ailment_buildups.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.ailment_buildups.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailment_buildups.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailment_buildups.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailment_buildups.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.player_spacing) then
				changed, cached_config.ailment_buildups.player_spacing.x = imgui.drag_float(language.current_language.customization_menu
					.x, cached_config.ailment_buildups.player_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailment_buildups.player_spacing.y = imgui.drag_float(language.current_language.customization_menu
					.y, cached_config.ailment_buildups.player_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.ailment_spacing) then
				changed, cached_config.ailment_buildups.ailment_spacing.x = imgui.drag_float(language.current_language.customization_menu
					.x, cached_config.ailment_buildups.ailment_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailment_buildups.ailment_spacing.y = imgui.drag_float(language.current_language.customization_menu
					.y, cached_config.ailment_buildups.ailment_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, index = imgui.combo(language.current_language.customization_menu.highlighted_bar,
					table_helpers.find_index(customization_menu.highlighted_buildup_bar_types,
						cached_config.ailment_buildups.settings.highlighted_bar),
					customization_menu.displayed_highlighted_buildup_bar_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailment_buildups.settings.highlighted_bar = customization_menu.highlighted_buildup_bar_types[index];
				end
				changed, index = imgui.combo(language.current_language.customization_menu.buildup_bars_are_relative_to,
					table_helpers.find_index(customization_menu.displayed_buildup_bar_relative_types,
						cached_config.ailment_buildups.settings.buildup_bar_relative_to),
					customization_menu.displayed_buildup_bar_relative_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailment_buildups.settings.buildup_bar_relative_to = customization_menu.displayed_buildup_bar_relative_types
						[index];
				end
				changed, cached_config.ailment_buildups.settings.time_limit = imgui.drag_float(language.current_language.customization_menu
					.time_limit, cached_config.ailment_buildups.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, index = imgui.combo(language.current_language.customization_menu.type,
					table_helpers.find_index(customization_menu.ailment_buildups_sorting_types,
						cached_config.ailment_buildups.sorting.type), customization_menu.displayed_ailment_buildups_sorting_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailment_buildups.sorting.type = customization_menu.ailment_buildups_sorting_types[index];
				end
				changed, cached_config.ailment_buildups.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu
					.reversed_order, cached_config.ailment_buildups.sorting.reversed_order);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.filter) then
				changed, cached_config.ailment_buildups.filter.stun = imgui.checkbox(language.current_language.ailments.stun,
					cached_config.ailment_buildups.filter.stun);
				changed, cached_config.ailment_buildups.filter.poison = imgui.checkbox(language.current_language.ailments.poison,
					cached_config.ailment_buildups.filter.poison);
				changed, cached_config.ailment_buildups.filter.blast = imgui.checkbox(language.current_language.ailments.blast,
					cached_config.ailment_buildups.filter.blast);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
				changed, cached_config.ailment_buildups.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.ailment_buildups.ailment_name_label.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, cached_config.ailment_buildups.ailment_name_label.include.ailment_name = imgui.checkbox(language.current_language
						.customization_menu.ailment_name, cached_config.ailment_buildups.ailment_name_label.include.ailment_name);
					config_changed = config_changed or changed;
					changed, cached_config.ailment_buildups.ailment_name_label.include.activation_count = imgui.checkbox(language.current_language
						.customization_menu.activation_count, cached_config.ailment_buildups.ailment_name_label.include.activation_count);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.ailment_buildups.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.ailment_buildups.ailment_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.ailment_buildups.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.ailment_buildups.ailment_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.ailment_buildups.ailment_name_label.color = imgui.color_picker_argb("",
						cached_config.ailment_buildups.ailment_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, cached_config.ailment_buildups.ailment_name_label.shadow.visibility = imgui.checkbox(language.current_language
						.customization_menu.visible, cached_config.ailment_buildups.ailment_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, cached_config.ailment_buildups.ailment_name_label.shadow.offset.x = imgui.drag_float(language.current_language
							.customization_menu.x, cached_config.ailment_buildups.ailment_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						changed, cached_config.ailment_buildups.ailment_name_label.shadow.offset.y = imgui.drag_float(language.current_language
							.customization_menu.y, cached_config.ailment_buildups.ailment_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, cached_config.ailment_buildups.ailment_name_label.shadow.color = imgui.color_picker_argb("",
							cached_config.ailment_buildups.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.player_name_label,
				cached_config.ailment_buildups.player_name_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.buildup_value_label,
				cached_config.ailment_buildups.buildup_value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.buildup_percentage_label,
				cached_config.ailment_buildups.buildup_percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.total_buildup_label,
				cached_config.ailment_buildups.total_buildup_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.total_buildup_value_label,
				cached_config.ailment_buildups.total_buildup_value_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.buildup_bar,
				cached_config.ailment_buildups.buildup_bar);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.highlighted_buildup_bar,
				cached_config.ailment_buildups.highlighted_buildup_bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		imgui.tree_pop();
	end
	return config_changed;
end

function customization_menu.draw_large_monster_static_UI()
	local changed = false;
	local config_changed = false;
	if imgui.tree_node(language.current_language.customization_menu.statically_positioned) then
		local cached_config = config.current_config.large_monster_UI.static;
		changed, cached_config.enabled = imgui.checkbox(language.current_language.customization_menu.enabled,
			cached_config.enabled);
		config_changed = config_changed or changed;
		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_dead_or_captured = imgui.checkbox(language.current_language.customization_menu.hide_dead_or_captured
				, cached_config.settings.hide_dead_or_captured);
			config_changed = config_changed or changed;
			changed, cached_config.settings.render_highlighted_monster = imgui.checkbox(language.current_language.customization_menu
				.render_highlighted_monster, cached_config.settings.render_highlighted_monster);
			config_changed = config_changed or changed;
			changed, cached_config.settings.render_not_highlighted_monsters = imgui.checkbox(language.current_language.customization_menu
				.render_not_highlighted_monsters, cached_config.settings.render_not_highlighted_monsters);
			config_changed = config_changed or changed;
			changed, index = imgui.combo(language.current_language.customization_menu.highlighted_monster_location,
				table_helpers.find_index(customization_menu.damage_meter_UI_my_damage_bar_location_types,
					cached_config.settings.highlighted_monster_location),
				customization_menu.displayed_damage_meter_UI_my_damage_bar_location_types);
			config_changed = config_changed or changed;
			if changed then
				cached_config.settings.highlighted_monster_location = customization_menu.damage_meter_UI_my_damage_bar_location_types
					[index];
			end
			changed, index = imgui.combo(language.current_language.customization_menu.orientation,
				table_helpers.find_index(customization_menu.orientation_types, cached_config.settings.orientation),
				customization_menu.displayed_orientation_types);
			config_changed = config_changed or changed;
			if changed then
				cached_config.settings.orientation = customization_menu.orientation_types[index];
			end
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.position.x, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;
			changed, cached_config.position.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.position.y, 0.1, 0, screen.height, "%.1f");
			config_changed = config_changed or changed;
			changed, index = imgui.combo(language.current_language.customization_menu.anchor,
				table_helpers.find_index(customization_menu.anchor_types, cached_config.position.anchor),
				customization_menu.displayed_anchor_types);
			config_changed = config_changed or changed;
			if changed then
				cached_config.position.anchor = customization_menu.anchor_types[index];
			end
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.spacing) then
			changed, cached_config.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
			config_changed = config_changed or changed;
			changed, cached_config.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(language.current_language.customization_menu.type,
				table_helpers.find_index(customization_menu.monster_UI_sorting_types, cached_config.sorting.type),
				customization_menu.displayed_monster_UI_sorting_types);
			config_changed = config_changed or changed;
			if changed then
				cached_config.sorting.type = customization_menu.monster_UI_sorting_types[index];
			end
			changed, cached_config.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu.reversed_order
				, cached_config.sorting.reversed_order);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.monster_name_label) then
			changed, cached_config.monster_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible
				, cached_config.monster_name_label.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.include) then
				changed, cached_config.monster_name_label.include.monster_name = imgui.checkbox(language.current_language.customization_menu
					.monster_name, cached_config.monster_name_label.include.monster_name);
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.include.monster_id = imgui.checkbox(language.current_language.customization_menu
					.monster_id, cached_config.monster_name_label.include.monster_id);
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.include.crown = imgui.checkbox(language.current_language.customization_menu
					.crown, cached_config.monster_name_label.include.crown);
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.include.size = imgui.checkbox(language.current_language.customization_menu
					.size, cached_config.monster_name_label.include.size);
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.include.scrown_thresholds = imgui.checkbox(language.current_language.customization_menu
					.crown_thresholds, cached_config.monster_name_label.include.scrown_thresholds);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.monster_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x
					, cached_config.monster_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y
					, cached_config.monster_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, cached_config.monster_name_label.color = imgui.color_picker_argb("", cached_config.monster_name_label.color
					, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, cached_config.monster_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.monster_name_label.shadow.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.monster_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.monster_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.monster_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.monster_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.monster_name_label.shadow.color = imgui.color_picker_argb("",
						cached_config.monster_name_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.health) then
			changed, cached_config.health.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.health.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.health.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.health.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.health.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.health.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.health.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.health.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.health.percentage_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.health.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.stamina) then
			changed, cached_config.stamina.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.stamina.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.stamina.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.stamina.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.stamina.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.stamina.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.stamina.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.stamina.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.stamina.percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.timer_label,
				cached_config.stamina.timer_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.stamina.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.rage) then
			changed, cached_config.rage.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.rage.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.rage.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.rage.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.rage.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.rage.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.rage.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.rage.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.rage.percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.timer_label,
				cached_config.rage.timer_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.rage.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.body_parts) then
			changed, cached_config.body_parts.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.body_parts.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.body_parts.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.body_parts.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.body_parts.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.spacing) then
				changed, cached_config.body_parts.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.body_parts.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.body_parts.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, cached_config.body_parts.settings.hide_undamaged_parts = imgui.checkbox(language.current_language.customization_menu
					.hide_undamaged_parts, cached_config.body_parts.settings.hide_undamaged_parts);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.settings.time_limit = imgui.drag_float(language.current_language.customization_menu
					.time_limit, cached_config.body_parts.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, index = imgui.combo(language.current_language.customization_menu.type,
					table_helpers.find_index(customization_menu.large_monster_UI_parts_sorting_types,
						cached_config.body_parts.sorting.type), customization_menu.displayed_monster_UI_parts_sorting_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.body_parts.sorting.type = customization_menu.large_monster_UI_parts_sorting_types[index];
				end
				changed, cached_config.body_parts.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu
					.reversed_order, cached_config.body_parts.sorting.reversed_order);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.filter) then
				changed, cached_config.body_parts.filter.health_break_severe = imgui.checkbox(language.current_language.customization_menu
					.health_break_severe_filter, cached_config.body_parts.filter.health_break_severe);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.health_break = imgui.checkbox(language.current_language.customization_menu.health_break_filter
					, cached_config.body_parts.filter.health_break);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.health_severe = imgui.checkbox(language.current_language.customization_menu
					.health_severe_filter, cached_config.body_parts.filter.health_severe);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.health = imgui.checkbox(language.current_language.customization_menu.health_filter
					, cached_config.body_parts.filter.health);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.break_severe = imgui.checkbox(language.current_language.customization_menu.break_severe_filter
					, cached_config.body_parts.filter.break_severe);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.break_ = imgui.checkbox(language.current_language.customization_menu.break_filter
					, cached_config.body_parts.filter.break_);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.severe = imgui.checkbox(language.current_language.customization_menu.severe_filter
					, cached_config.body_parts.filter.severe);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.part_name_label) then
				changed, cached_config.body_parts.part_name_label.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.body_parts.part_name_label.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, cached_config.body_parts.part_name_label.include.part_name = imgui.checkbox(language.current_language.customization_menu
						.part_name, cached_config.body_parts.part_name_label.include.part_name);
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_name_label.include.flinch_count = imgui.checkbox(language.current_language.customization_menu
						.flinch_count, cached_config.body_parts.part_name_label.include.flinch_count);
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_name_label.include.break_count = imgui.checkbox(language.current_language.customization_menu
						.break_count, cached_config.body_parts.part_name_label.include.break_count);
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_name_label.include.break_max_count = imgui.checkbox(language.current_language
						.customization_menu.break_max_count, cached_config.body_parts.part_name_label.include.break_max_count);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.body_parts.part_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.body_parts.part_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.body_parts.part_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.body_parts.part_name_label.color = imgui.color_picker_argb("",
						cached_config.body_parts.part_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, cached_config.body_parts.part_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu
						.visible, cached_config.body_parts.part_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, cached_config.body_parts.part_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu
							.x, cached_config.body_parts.part_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						changed, cached_config.body_parts.part_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu
							.y, cached_config.body_parts.part_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, cached_config.body_parts.part_name_label.shadow.color = imgui.color_picker_argb("",
							cached_config.body_parts.part_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.part_health) then
				changed, cached_config.body_parts.part_health.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.body_parts.part_health.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.body_parts.part_health.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.body_parts.part_health.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_health.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.body_parts.part_health.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				changed = label_customization.draw(language.current_language.customization_menu.text_label,
					cached_config.body_parts.part_health.text_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.value_label,
					cached_config.body_parts.part_health.value_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
					cached_config.body_parts.part_health.percentage_label);
				config_changed = config_changed or changed;
				changed = bar_customization.draw(language.current_language.customization_menu.bar,
					cached_config.body_parts.part_health.bar);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.break_health) then
				changed, cached_config.body_parts.part_break.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.body_parts.part_break.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.body_parts.part_break.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.body_parts.part_break.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_break.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.body_parts.part_break.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				changed = label_customization.draw(language.current_language.customization_menu.text_label,
					cached_config.body_parts.part_break.text_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.value_label,
					cached_config.body_parts.part_break.value_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
					cached_config.body_parts.part_break.percentage_label);
				config_changed = config_changed or changed;
				changed = bar_customization.draw(language.current_language.customization_menu.bar,
					cached_config.body_parts.part_break.bar);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.loss_health) then
				changed, cached_config.body_parts.part_loss.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.body_parts.part_loss.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.body_parts.part_loss.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.body_parts.part_loss.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_loss.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.body_parts.part_loss.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				changed = label_customization.draw(language.current_language.customization_menu.text_label,
					cached_config.body_parts.part_loss.text_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.value_label,
					cached_config.body_parts.part_loss.value_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
					cached_config.body_parts.part_loss.percentage_label);
				config_changed = config_changed or changed;
				changed = bar_customization.draw(language.current_language.customization_menu.bar,
					cached_config.body_parts.part_loss.bar);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.ailments) then
			changed, cached_config.ailments.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.ailments.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.ailments.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailments.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailments.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailments.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.relative_offset) then
				changed, cached_config.ailments.relative_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailments.relative_offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailments.relative_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailments.relative_offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.spacing) then
				changed, cached_config.ailments.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailments.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailments.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailments.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, cached_config.ailments.settings.hide_ailments_with_zero_buildup = imgui.checkbox(language.current_language.customization_menu
					.hide_ailments_with_zero_buildup, cached_config.ailments.settings.hide_ailments_with_zero_buildup);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_inactive_ailments_with_no_buildup_support = imgui.checkbox(language.current_language
					.customization_menu.hide_inactive_ailments_with_no_buildup_support,
					cached_config.ailments.settings.hide_inactive_ailments_with_no_buildup_support);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_all_inactive_ailments = imgui.checkbox(language.current_language.customization_menu
					.hide_all_inactive_ailments, cached_config.ailments.settings.hide_all_inactive_ailments);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_all_active_ailments = imgui.checkbox(language.current_language.customization_menu
					.hide_all_active_ailments, cached_config.ailments.settings.hide_all_active_ailments);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_disabled_ailments = imgui.checkbox(language.current_language.customization_menu
					.hide_disabled_ailments, cached_config.ailments.settings.hide_disabled_ailments);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.offset_is_relative_to_parts = imgui.checkbox(language.current_language.customization_menu
					.offset_is_relative_to_parts, cached_config.ailments.settings.offset_is_relative_to_parts);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit
					, cached_config.ailments.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, index = imgui.combo(language.current_language.customization_menu.type,
					table_helpers.find_index(customization_menu.ailments_sorting_types, cached_config.ailments.sorting.type),
					customization_menu.displayed_ailments_sorting_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailments.sorting.type = customization_menu.ailments_sorting_types[index];
				end
				changed, cached_config.ailments.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu
					.reversed_order, cached_config.ailments.sorting.reversed_order);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.filter) then
				changed, cached_config.ailments.filter.paralysis = imgui.checkbox(language.current_language.ailments.paralysis,
					cached_config.ailments.filter.paralysis);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.sleep = imgui.checkbox(language.current_language.ailments.sleep,
					cached_config.ailments.filter.sleep);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.stun = imgui.checkbox(language.current_language.ailments.stun,
					cached_config.ailments.filter.stun);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.flash = imgui.checkbox(language.current_language.ailments.flash,
					cached_config.ailments.filter.flash);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.poison = imgui.checkbox(language.current_language.ailments.poison,
					cached_config.ailments.filter.poison);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.blast = imgui.checkbox(language.current_language.ailments.blast,
					cached_config.ailments.filter.blast);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.exhaust = imgui.checkbox(language.current_language.ailments.exhaust,
					cached_config.ailments.filter.exhaust);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.ride = imgui.checkbox(language.current_language.ailments.ride,
					cached_config.ailments.filter.ride);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.waterblight = imgui.checkbox(language.current_language.ailments.waterblight,
					cached_config.ailments.filter.waterblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.fireblight = imgui.checkbox(language.current_language.ailments.fireblight,
					cached_config.ailments.filter.fireblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.iceblight = imgui.checkbox(language.current_language.ailments.iceblight,
					cached_config.ailments.filter.iceblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.thunderblight = imgui.checkbox(language.current_language.ailments.thunderblight
					, cached_config.ailments.filter.thunderblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.fall_trap = imgui.checkbox(language.current_language.ailments.fall_trap,
					cached_config.ailments.filter.fall_trap);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.shock_trap = imgui.checkbox(language.current_language.ailments.shock_trap,
					cached_config.ailments.filter.shock_trap);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.tranq_bomb = imgui.checkbox(language.current_language.ailments.tranq_bomb,
					cached_config.ailments.filter.tranq_bomb);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.dung_bomb = imgui.checkbox(language.current_language.ailments.dung_bomb,
					cached_config.ailments.filter.dung_bomb);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.steel_fang = imgui.checkbox(language.current_language.ailments.steel_fang,
					cached_config.ailments.filter.steel_fang);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.quick_sand = imgui.checkbox(language.current_language.ailments.quick_sand,
					cached_config.ailments.filter.quick_sand);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.fall_otomo_trap = imgui.checkbox(language.current_language.ailments.fall_otomo_trap
					, cached_config.ailments.filter.fall_otomo_trap);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.shock_otomo_trap = imgui.checkbox(language.current_language.ailments.shock_otomo_trap
					, cached_config.ailments.filter.shock_otomo_trap);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
				changed, cached_config.ailments.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.ailments.ailment_name_label.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, cached_config.ailments.ailment_name_label.include.ailment_name = imgui.checkbox(language.current_language.customization_menu
						.ailment_name, cached_config.ailments.ailment_name_label.include.ailment_name);
					config_changed = config_changed or changed;
					changed, cached_config.ailments.ailment_name_label.include.activation_count = imgui.checkbox(language.current_language
						.customization_menu.activation_count, cached_config.ailments.ailment_name_label.include.activation_count);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.ailments.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.ailments.ailment_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.ailments.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.ailments.ailment_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.ailments.ailment_name_label.color = imgui.color_picker_argb("",
						cached_config.ailments.ailment_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, cached_config.ailments.ailment_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu
						.visible, cached_config.ailments.ailment_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, cached_config.ailments.ailment_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu
							.x, cached_config.ailments.ailment_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						changed, cached_config.ailments.ailment_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu
							.y, cached_config.ailments.ailment_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, cached_config.ailments.ailment_name_label.shadow.color = imgui.color_picker_argb("",
							cached_config.ailments.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.ailments.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.ailments.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.ailments.percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.timer_label,
				cached_config.ailments.timer_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.ailments.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.ailment_buildups) then
			changed, cached_config.ailment_buildups.visibility = imgui.checkbox(language.current_language.customization_menu.visible
				, cached_config.ailment_buildups.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.ailment_buildups.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailment_buildups.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailment_buildups.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailment_buildups.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.player_spacing) then
				changed, cached_config.ailment_buildups.player_spacing.x = imgui.drag_float(language.current_language.customization_menu
					.x, cached_config.ailment_buildups.player_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailment_buildups.player_spacing.y = imgui.drag_float(language.current_language.customization_menu
					.y, cached_config.ailment_buildups.player_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.ailment_spacing) then
				changed, cached_config.ailment_buildups.ailment_spacing.x = imgui.drag_float(language.current_language.customization_menu
					.x, cached_config.ailment_buildups.ailment_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailment_buildups.ailment_spacing.y = imgui.drag_float(language.current_language.customization_menu
					.y, cached_config.ailment_buildups.ailment_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, index = imgui.combo(language.current_language.customization_menu.highlighted_bar,
					table_helpers.find_index(customization_menu.highlighted_buildup_bar_types,
						cached_config.ailment_buildups.settings.highlighted_bar),
					customization_menu.displayed_highlighted_buildup_bar_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailment_buildups.settings.highlighted_bar = customization_menu.highlighted_buildup_bar_types[index];
				end
				changed, index = imgui.combo(language.current_language.customization_menu.buildup_bars_are_relative_to,
					table_helpers.find_index(customization_menu.displayed_buildup_bar_relative_types,
						cached_config.ailment_buildups.settings.buildup_bar_relative_to),
					customization_menu.displayed_buildup_bar_relative_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailment_buildups.settings.buildup_bar_relative_to = customization_menu.displayed_buildup_bar_relative_types
						[index];
				end
				changed, cached_config.ailment_buildups.settings.time_limit = imgui.drag_float(language.current_language.customization_menu
					.time_limit, cached_config.ailment_buildups.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, index = imgui.combo(language.current_language.customization_menu.type,
					table_helpers.find_index(customization_menu.ailment_buildups_sorting_types,
						cached_config.ailment_buildups.sorting.type), customization_menu.displayed_ailment_buildups_sorting_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailment_buildups.sorting.type = customization_menu.ailment_buildups_sorting_types[index];
				end
				changed, cached_config.ailment_buildups.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu
					.reversed_order, cached_config.ailment_buildups.sorting.reversed_order);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.filter) then
				changed, cached_config.ailment_buildups.filter.stun = imgui.checkbox(language.current_language.ailments.stun,
					cached_config.ailment_buildups.filter.stun);
				changed, cached_config.ailment_buildups.filter.poison = imgui.checkbox(language.current_language.ailments.poison,
					cached_config.ailment_buildups.filter.poison);
				changed, cached_config.ailment_buildups.filter.blast = imgui.checkbox(language.current_language.ailments.blast,
					cached_config.ailment_buildups.filter.blast);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
				changed, cached_config.ailment_buildups.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.ailment_buildups.ailment_name_label.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, cached_config.ailment_buildups.ailment_name_label.include.ailment_name = imgui.checkbox(language.current_language
						.customization_menu.ailment_name, cached_config.ailment_buildups.ailment_name_label.include.ailment_name);
					config_changed = config_changed or changed;
					changed, cached_config.ailment_buildups.ailment_name_label.include.activation_count = imgui.checkbox(language.current_language
						.customization_menu.activation_count, cached_config.ailment_buildups.ailment_name_label.include.activation_count);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.ailment_buildups.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.ailment_buildups.ailment_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.ailment_buildups.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.ailment_buildups.ailment_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.ailment_buildups.ailment_name_label.color = imgui.color_picker_argb("",
						cached_config.ailment_buildups.ailment_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, cached_config.ailment_buildups.ailment_name_label.shadow.visibility = imgui.checkbox(language.current_language
						.customization_menu.visible, cached_config.ailment_buildups.ailment_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, cached_config.ailment_buildups.ailment_name_label.shadow.offset.x = imgui.drag_float(language.current_language
							.customization_menu.x, cached_config.ailment_buildups.ailment_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						changed, cached_config.ailment_buildups.ailment_name_label.shadow.offset.y = imgui.drag_float(language.current_language
							.customization_menu.y, cached_config.ailment_buildups.ailment_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, cached_config.ailment_buildups.ailment_name_label.shadow.color = imgui.color_picker_argb("",
							cached_config.ailment_buildups.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.player_name_label,
				cached_config.ailment_buildups.player_name_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.buildup_value_label,
				cached_config.ailment_buildups.buildup_value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.buildup_percentage_label,
				cached_config.ailment_buildups.buildup_percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.total_buildup_label,
				cached_config.ailment_buildups.total_buildup_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.total_buildup_value_label,
				cached_config.ailment_buildups.total_buildup_value_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.buildup_bar,
				cached_config.ailment_buildups.buildup_bar);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.highlighted_buildup_bar,
				cached_config.ailment_buildups.highlighted_buildup_bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		imgui.tree_pop();
	end
	return config_changed;
end

function customization_menu.draw_large_monster_highlighted_UI()
	local changed = false;
	local config_changed = false;
	local index = 1;
	if imgui.tree_node(language.current_language.customization_menu.highlighted) then
		local cached_config = config.current_config.large_monster_UI.highlighted;
		changed, cached_config.enabled = imgui.checkbox(language.current_language.customization_menu.enabled,
			cached_config.enabled);
		config_changed = config_changed or changed;
		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.position.x, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;
			changed, cached_config.position.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.position.y, 0.1, 0, screen.height, "%.1f");
			config_changed = config_changed or changed;
			changed, index = imgui.combo(language.current_language.customization_menu.anchor,
				table_helpers.find_index(customization_menu.anchor_types, cached_config.position.anchor),
				customization_menu.displayed_anchor_types);
			config_changed = config_changed or changed;
			if changed then
				cached_config.position.anchor = customization_menu.anchor_types[index];
			end
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.monster_name_label) then
			changed, cached_config.monster_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible
				, cached_config.monster_name_label.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.include) then
				changed, cached_config.monster_name_label.include.monster_name = imgui.checkbox(language.current_language.customization_menu
					.monster_name, cached_config.monster_name_label.include.monster_name);
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.include.monster_id = imgui.checkbox(language.current_language.customization_menu
					.monster_id, cached_config.monster_name_label.include.monster_id);
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.include.crown = imgui.checkbox(language.current_language.customization_menu
					.crown, cached_config.monster_name_label.include.crown);
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.include.size = imgui.checkbox(language.current_language.customization_menu
					.size, cached_config.monster_name_label.include.size);
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.include.scrown_thresholds = imgui.checkbox(language.current_language.customization_menu
					.crown_thresholds, cached_config.monster_name_label.include.scrown_thresholds);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.monster_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x
					, cached_config.monster_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.monster_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y
					, cached_config.monster_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, cached_config.monster_name_label.color = imgui.color_picker_argb("", cached_config.monster_name_label.color
					, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, cached_config.monster_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.monster_name_label.shadow.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.monster_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.monster_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.monster_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.monster_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.monster_name_label.shadow.color = imgui.color_picker_argb("",
						cached_config.monster_name_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.health) then
			changed, cached_config.health.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.health.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.health.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.health.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.health.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.health.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.health.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.health.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.health.percentage_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.health.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.stamina) then
			changed, cached_config.stamina.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.stamina.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.stamina.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.stamina.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.stamina.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.stamina.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.stamina.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.stamina.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.stamina.percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.timer_label,
				cached_config.stamina.timer_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.stamina.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.rage) then
			changed, cached_config.rage.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.rage.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.rage.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.rage.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.rage.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.rage.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.rage.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.rage.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.rage.percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.timer_label,
				cached_config.rage.timer_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.rage.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.body_parts) then
			changed, cached_config.body_parts.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.body_parts.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.body_parts.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.body_parts.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.body_parts.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.spacing) then
				changed, cached_config.body_parts.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.body_parts.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.body_parts.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, cached_config.body_parts.settings.hide_undamaged_parts = imgui.checkbox(language.current_language.customization_menu
					.hide_undamaged_parts, cached_config.body_parts.settings.hide_undamaged_parts);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.settings.time_limit = imgui.drag_float(language.current_language.customization_menu
					.time_limit, cached_config.body_parts.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, index = imgui.combo(language.current_language.customization_menu.type,
					table_helpers.find_index(customization_menu.large_monster_UI_parts_sorting_types,
						cached_config.body_parts.sorting.type), customization_menu.displayed_monster_UI_parts_sorting_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.body_parts.sorting.type = customization_menu.large_monster_UI_parts_sorting_types[index];
				end
				changed, cached_config.body_parts.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu
					.reversed_order, cached_config.body_parts.sorting.reversed_order);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.filter) then
				changed, cached_config.body_parts.filter.health_break_severe = imgui.checkbox(language.current_language.customization_menu
					.health_break_severe_filter, cached_config.body_parts.filter.health_break_severe);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.health_break = imgui.checkbox(language.current_language.customization_menu.health_break_filter
					, cached_config.body_parts.filter.health_break);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.health_severe = imgui.checkbox(language.current_language.customization_menu
					.health_severe_filter, cached_config.body_parts.filter.health_severe);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.health = imgui.checkbox(language.current_language.customization_menu.health_filter
					, cached_config.body_parts.filter.health);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.break_severe = imgui.checkbox(language.current_language.customization_menu.break_severe_filter
					, cached_config.body_parts.filter.break_severe);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.break_ = imgui.checkbox(language.current_language.customization_menu.break_filter
					, cached_config.body_parts.filter.break_);
				config_changed = config_changed or changed;
				changed, cached_config.body_parts.filter.severe = imgui.checkbox(language.current_language.customization_menu.severe_filter
					, cached_config.body_parts.filter.severe);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.part_name_label) then
				changed, cached_config.body_parts.part_name_label.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.body_parts.part_name_label.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, cached_config.body_parts.part_name_label.include.part_name = imgui.checkbox(language.current_language.customization_menu
						.part_name, cached_config.body_parts.part_name_label.include.part_name);
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_name_label.include.flinch_count = imgui.checkbox(language.current_language.customization_menu
						.flinch_count, cached_config.body_parts.part_name_label.include.flinch_count);
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_name_label.include.break_count = imgui.checkbox(language.current_language.customization_menu
						.break_count, cached_config.body_parts.part_name_label.include.break_count);
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_name_label.include.break_max_count = imgui.checkbox(language.current_language
						.customization_menu.break_max_count, cached_config.body_parts.part_name_label.include.break_max_count);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.body_parts.part_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.body_parts.part_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.body_parts.part_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.body_parts.part_name_label.color = imgui.color_picker_argb("",
						cached_config.body_parts.part_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, cached_config.body_parts.part_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu
						.visible, cached_config.body_parts.part_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, cached_config.body_parts.part_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu
							.x, cached_config.body_parts.part_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						changed, cached_config.body_parts.part_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu
							.y, cached_config.body_parts.part_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, cached_config.body_parts.part_name_label.shadow.color = imgui.color_picker_argb("",
							cached_config.body_parts.part_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.part_health) then
				changed, cached_config.body_parts.part_health.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.body_parts.part_health.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.body_parts.part_health.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.body_parts.part_health.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_health.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.body_parts.part_health.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				changed = label_customization.draw(language.current_language.customization_menu.text_label,
					cached_config.body_parts.part_health.text_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.value_label,
					cached_config.body_parts.part_health.value_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
					cached_config.body_parts.part_health.percentage_label);
				config_changed = config_changed or changed;
				changed = bar_customization.draw(language.current_language.customization_menu.bar,
					cached_config.body_parts.part_health.bar);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.break_health) then
				changed, cached_config.body_parts.part_break.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.body_parts.part_break.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.body_parts.part_break.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.body_parts.part_break.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_break.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.body_parts.part_break.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				changed = label_customization.draw(language.current_language.customization_menu.text_label,
					cached_config.body_parts.part_break.text_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.value_label,
					cached_config.body_parts.part_break.value_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
					cached_config.body_parts.part_break.percentage_label);
				config_changed = config_changed or changed;
				changed = bar_customization.draw(language.current_language.customization_menu.bar,
					cached_config.body_parts.part_break.bar);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.loss_health) then
				changed, cached_config.body_parts.part_loss.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.body_parts.part_loss.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.body_parts.part_loss.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.body_parts.part_loss.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.body_parts.part_loss.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.body_parts.part_loss.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				changed = label_customization.draw(language.current_language.customization_menu.text_label,
					cached_config.body_parts.part_loss.text_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.value_label,
					cached_config.body_parts.part_loss.value_label);
				config_changed = config_changed or changed;
				changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
					cached_config.body_parts.part_loss.percentage_label);
				config_changed = config_changed or changed;
				changed = bar_customization.draw(language.current_language.customization_menu.bar,
					cached_config.body_parts.part_loss.bar);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.ailments) then
			changed, cached_config.ailments.visibility = imgui.checkbox(language.current_language.customization_menu.visible,
				cached_config.ailments.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.ailments.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailments.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailments.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailments.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.relative_offset) then
				changed, cached_config.ailments.relative_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailments.relative_offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailments.relative_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailments.relative_offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.spacing) then
				changed, cached_config.ailments.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailments.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailments.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailments.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, cached_config.ailments.settings.hide_ailments_with_zero_buildup = imgui.checkbox(language.current_language.customization_menu
					.hide_ailments_with_zero_buildup, cached_config.ailments.settings.hide_ailments_with_zero_buildup);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_inactive_ailments_with_no_buildup_support = imgui.checkbox(language.current_language
					.customization_menu.hide_inactive_ailments_with_no_buildup_support,
					cached_config.ailments.settings.hide_inactive_ailments_with_no_buildup_support);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_all_inactive_ailments = imgui.checkbox(language.current_language.customization_menu
					.hide_all_inactive_ailments, cached_config.ailments.settings.hide_all_inactive_ailments);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_all_active_ailments = imgui.checkbox(language.current_language.customization_menu
					.hide_all_active_ailments, cached_config.ailments.settings.hide_all_active_ailments);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.hide_disabled_ailments = imgui.checkbox(language.current_language.customization_menu
					.hide_disabled_ailments, cached_config.ailments.settings.hide_disabled_ailments);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.offset_is_relative_to_parts = imgui.checkbox(language.current_language.customization_menu
					.offset_is_relative_to_parts, cached_config.ailments.settings.offset_is_relative_to_parts);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.settings.time_limit = imgui.drag_float(language.current_language.customization_menu.time_limit
					, cached_config.ailments.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, index = imgui.combo(language.current_language.customization_menu.type,
					table_helpers.find_index(customization_menu.ailments_sorting_types, cached_config.ailments.sorting.type),
					customization_menu.displayed_ailments_sorting_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailments.sorting.type = customization_menu.ailments_sorting_types[index];
				end
				changed, cached_config.ailments.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu
					.reversed_order, cached_config.ailments.sorting.reversed_order);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.filter) then
				changed, cached_config.ailments.filter.paralysis = imgui.checkbox(language.current_language.ailments.paralysis,
					cached_config.ailments.filter.paralysis);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.sleep = imgui.checkbox(language.current_language.ailments.sleep,
					cached_config.ailments.filter.sleep);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.stun = imgui.checkbox(language.current_language.ailments.stun,
					cached_config.ailments.filter.stun);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.flash = imgui.checkbox(language.current_language.ailments.flash,
					cached_config.ailments.filter.flash);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.poison = imgui.checkbox(language.current_language.ailments.poison,
					cached_config.ailments.filter.poison);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.blast = imgui.checkbox(language.current_language.ailments.blast,
					cached_config.ailments.filter.blast);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.exhaust = imgui.checkbox(language.current_language.ailments.exhaust,
					cached_config.ailments.filter.exhaust);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.ride = imgui.checkbox(language.current_language.ailments.ride,
					cached_config.ailments.filter.ride);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.waterblight = imgui.checkbox(language.current_language.ailments.waterblight,
					cached_config.ailments.filter.waterblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.fireblight = imgui.checkbox(language.current_language.ailments.fireblight,
					cached_config.ailments.filter.fireblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.iceblight = imgui.checkbox(language.current_language.ailments.iceblight,
					cached_config.ailments.filter.iceblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.thunderblight = imgui.checkbox(language.current_language.ailments.thunderblight
					, cached_config.ailments.filter.thunderblight);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.fall_trap = imgui.checkbox(language.current_language.ailments.fall_trap,
					cached_config.ailments.filter.fall_trap);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.shock_trap = imgui.checkbox(language.current_language.ailments.shock_trap,
					cached_config.ailments.filter.shock_trap);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.tranq_bomb = imgui.checkbox(language.current_language.ailments.tranq_bomb,
					cached_config.ailments.filter.tranq_bomb);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.dung_bomb = imgui.checkbox(language.current_language.ailments.dung_bomb,
					cached_config.ailments.filter.dung_bomb);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.steel_fang = imgui.checkbox(language.current_language.ailments.steel_fang,
					cached_config.ailments.filter.steel_fang);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.quick_sand = imgui.checkbox(language.current_language.ailments.quick_sand,
					cached_config.ailments.filter.quick_sand);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.fall_otomo_trap = imgui.checkbox(language.current_language.ailments.fall_otomo_trap
					, cached_config.ailments.filter.fall_otomo_trap);
				config_changed = config_changed or changed;
				changed, cached_config.ailments.filter.shock_otomo_trap = imgui.checkbox(language.current_language.ailments.shock_otomo_trap
					, cached_config.ailments.filter.shock_otomo_trap);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
				changed, cached_config.ailments.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.ailments.ailment_name_label.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, cached_config.ailments.ailment_name_label.include.ailment_name = imgui.checkbox(language.current_language.customization_menu
						.ailment_name, cached_config.ailments.ailment_name_label.include.ailment_name);
					config_changed = config_changed or changed;
					changed, cached_config.ailments.ailment_name_label.include.activation_count = imgui.checkbox(language.current_language
						.customization_menu.activation_count, cached_config.ailments.ailment_name_label.include.activation_count);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.ailments.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.ailments.ailment_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.ailments.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.ailments.ailment_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.ailments.ailment_name_label.color = imgui.color_picker_argb("",
						cached_config.ailments.ailment_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, cached_config.ailments.ailment_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu
						.visible, cached_config.ailments.ailment_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, cached_config.ailments.ailment_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu
							.x, cached_config.ailments.ailment_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						changed, cached_config.ailments.ailment_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu
							.y, cached_config.ailments.ailment_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, cached_config.ailments.ailment_name_label.shadow.color = imgui.color_picker_argb("",
							cached_config.ailments.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.text_label,
				cached_config.ailments.text_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.value_label,
				cached_config.ailments.value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.percentage_label,
				cached_config.ailments.percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.timer_label,
				cached_config.ailments.timer_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.ailments.bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.ailment_buildups) then
			changed, cached_config.ailment_buildups.visibility = imgui.checkbox(language.current_language.customization_menu.visible
				, cached_config.ailment_buildups.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.ailment_buildups.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.ailment_buildups.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailment_buildups.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.ailment_buildups.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.player_spacing) then
				changed, cached_config.ailment_buildups.player_spacing.x = imgui.drag_float(language.current_language.customization_menu
					.x, cached_config.ailment_buildups.player_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailment_buildups.player_spacing.y = imgui.drag_float(language.current_language.customization_menu
					.y, cached_config.ailment_buildups.player_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.ailment_spacing) then
				changed, cached_config.ailment_buildups.ailment_spacing.x = imgui.drag_float(language.current_language.customization_menu
					.x, cached_config.ailment_buildups.ailment_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.ailment_buildups.ailment_spacing.y = imgui.drag_float(language.current_language.customization_menu
					.y, cached_config.ailment_buildups.ailment_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.settings) then
				changed, index = imgui.combo(language.current_language.customization_menu.highlighted_bar,
					table_helpers.find_index(customization_menu.highlighted_buildup_bar_types,
						cached_config.ailment_buildups.settings.highlighted_bar),
					customization_menu.displayed_highlighted_buildup_bar_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailment_buildups.settings.highlighted_bar = customization_menu.highlighted_buildup_bar_types[index];
				end
				changed, index = imgui.combo(language.current_language.customization_menu.buildup_bars_are_relative_to,
					table_helpers.find_index(customization_menu.displayed_buildup_bar_relative_types,
						cached_config.ailment_buildups.settings.buildup_bar_relative_to),
					customization_menu.displayed_buildup_bar_relative_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailment_buildups.settings.buildup_bar_relative_to = customization_menu.displayed_buildup_bar_relative_types
						[index];
				end
				changed, cached_config.ailment_buildups.settings.time_limit = imgui.drag_float(language.current_language.customization_menu
					.time_limit, cached_config.ailment_buildups.settings.time_limit, 0.1, 0, 99999, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.sorting) then
				changed, customization_menu.index = imgui.combo(language.current_language.customization_menu.type,
					table_helpers.find_index(customization_menu.ailment_buildups_sorting_types,
						cached_config.ailment_buildups.sorting.type), customization_menu.displayed_ailment_buildups_sorting_types);
				config_changed = config_changed or changed;
				if changed then
					cached_config.ailment_buildups.sorting.type = customization_menu.ailment_buildups_sorting_types[index];
				end
				changed, cached_config.ailment_buildups.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu
					.reversed_order, cached_config.ailment_buildups.sorting.reversed_order);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.filter) then
				changed, cached_config.ailment_buildups.filter.stun = imgui.checkbox(language.current_language.ailments.stun,
					cached_config.ailment_buildups.filter.stun);
				changed, cached_config.ailment_buildups.filter.poison = imgui.checkbox(language.current_language.ailments.poison,
					cached_config.ailment_buildups.filter.poison);
				changed, cached_config.ailment_buildups.filter.blast = imgui.checkbox(language.current_language.ailments.blast,
					cached_config.ailment_buildups.filter.blast);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
				changed, cached_config.ailment_buildups.ailment_name_label.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.ailment_buildups.ailment_name_label.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.include) then
					changed, cached_config.ailment_buildups.ailment_name_label.include.ailment_name = imgui.checkbox(language.current_language
						.customization_menu.ailment_name, cached_config.ailment_buildups.ailment_name_label.include.ailment_name);
					config_changed = config_changed or changed;
					changed, cached_config.ailment_buildups.ailment_name_label.include.activation_count = imgui.checkbox(language.current_language
						.customization_menu.activation_count, cached_config.ailment_buildups.ailment_name_label.include.activation_count);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.ailment_buildups.ailment_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.ailment_buildups.ailment_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.ailment_buildups.ailment_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.ailment_buildups.ailment_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.ailment_buildups.ailment_name_label.color = imgui.color_picker_argb("",
						cached_config.ailment_buildups.ailment_name_label.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.shadow) then
					changed, cached_config.ailment_buildups.ailment_name_label.shadow.visibility = imgui.checkbox(language.current_language
						.customization_menu.visible, cached_config.ailment_buildups.ailment_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					if imgui.tree_node(language.current_language.customization_menu.offset) then
						changed, cached_config.ailment_buildups.ailment_name_label.shadow.offset.x = imgui.drag_float(language.current_language
							.customization_menu.x, cached_config.ailment_buildups.ailment_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						changed, cached_config.ailment_buildups.ailment_name_label.shadow.offset.y = imgui.drag_float(language.current_language
							.customization_menu.y, cached_config.ailment_buildups.ailment_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					if imgui.tree_node(language.current_language.customization_menu.color) then
						changed, cached_config.ailment_buildups.ailment_name_label.shadow.color = imgui.color_picker_argb("",
							cached_config.ailment_buildups.ailment_name_label.shadow.color, customization_menu.color_picker_flags);
						config_changed = config_changed or changed;
						imgui.tree_pop();
					end
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			changed = label_customization.draw(language.current_language.customization_menu.player_name_label,
				cached_config.ailment_buildups.player_name_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.buildup_value_label,
				cached_config.ailment_buildups.buildup_value_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.buildup_percentage_label,
				cached_config.ailment_buildups.buildup_percentage_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.total_buildup_label,
				cached_config.ailment_buildups.total_buildup_label);
			config_changed = config_changed or changed;
			changed = label_customization.draw(language.current_language.customization_menu.total_buildup_value_label,
				cached_config.ailment_buildups.total_buildup_value_label);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.buildup_bar,
				cached_config.ailment_buildups.buildup_bar);
			config_changed = config_changed or changed;
			changed = bar_customization.draw(language.current_language.customization_menu.highlighted_buildup_bar,
				cached_config.ailment_buildups.highlighted_buildup_bar);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
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
		changed, cached_config.enabled = imgui.checkbox(language.current_language.customization_menu.enabled,
			cached_config.enabled);
		config_changed = config_changed or changed;
		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.position.x, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;
			changed, cached_config.position.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.position.y, 0.1, 0, screen.height, "%.1f");
			config_changed = config_changed or changed;
			changed, index = imgui.combo(language.current_language.customization_menu.anchor,
				table_helpers.find_index(customization_menu.anchor_types, cached_config.position.anchor),
				customization_menu.stomization_menu.displayed_anchor_types);
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
	local index = 1;
	if imgui.tree_node(language.current_language.customization_menu.damage_meter_UI) then
		local cached_config = config.current_config.damage_meter_UI;
		changed, cached_config.enabled = imgui.checkbox(language.current_language.customization_menu.enabled,
			cached_config.enabled);
		config_changed = config_changed or changed;
		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_myself = imgui.checkbox(language.current_language.customization_menu.hide_myself
				, cached_config.settings.hide_myself);
			config_changed = config_changed or changed;
			changed, cached_config.settings.hide_other_players = imgui.checkbox(language.current_language.customization_menu.hide_other_players
				, cached_config.settings.hide_other_players);
			config_changed = config_changed or changed;
			changed, cached_config.settings.hide_total_damage = imgui.checkbox(language.current_language.customization_menu.hide_total_damage
				, cached_config.settings.hide_total_damage);
			config_changed = config_changed or changed;
			changed, cached_config.settings.hide_module_if_total_damage_is_zero = imgui.checkbox(language.current_language.customization_menu
				.hide_module_if_total_damage_is_zero, cached_config.settings.hide_module_if_total_damage_is_zero);
			config_changed = config_changed or changed;
			changed, cached_config.settings.hide_player_if_player_damage_is_zero = imgui.checkbox(language.current_language.customization_menu
				.hide_player_if_player_damage_is_zero, cached_config.settings.hide_player_if_player_damage_is_zero);
			config_changed = config_changed or changed;
			changed, cached_config.settings.hide_total_if_total_damage_is_zero = imgui.checkbox(language.current_language.customization_menu
				.hide_total_if_total_damage_is_zero, cached_config.settings.hide_total_if_total_damage_is_zero);
			config_changed = config_changed or changed;
			changed, cached_config.settings.total_damage_offset_is_relative = imgui.checkbox(language.current_language.customization_menu
				.total_damage_offset_is_relative, cached_config.settings.total_damage_offset_is_relative);
			config_changed = config_changed or changed;
			changed, cached_config.settings.freeze_dps_on_quest_clear = imgui.checkbox(language.current_language.customization_menu
				.freeze_dps_on_quest_clear, cached_config.settings.freeze_dps_on_quest_clear);
			config_changed = config_changed or changed;
			changed, index = imgui.combo(language.current_language.customization_menu.orientation,
				table_helpers.find_index(customization_menu.orientation_types, cached_config.settings.orientation),
				customization_menu.displayed_orientation_types);
			config_changed = config_changed or changed;
			if changed then
				cached_config.settings.orientation = customization_menu.orientation_types[index];
			end
			changed, index = imgui.combo(language.current_language.customization_menu.highlighted_bar,
				table_helpers.find_index(customization_menu.damage_meter_UI_highlighted_bar_types,
					cached_config.settings.highlighted_bar), customization_menu.displayed_damage_meter_UI_highlighted_bar_types);
			config_changed = config_changed or changed;
			if changed then
				cached_config.settings.highlighted_bar = customization_menu.damage_meter_UI_highlighted_bar_types[index];
			end
			changed, index = imgui.combo(language.current_language.customization_menu.damage_bars_are_relative_to,
				table_helpers.find_index(customization_menu.damage_meter_UI_damage_bar_relative_types,
					cached_config.settings.damage_bar_relative_to),
				customization_menu.displayed_damage_meter_UI_damage_bar_relative_types);
			config_changed = config_changed or changed;
			if changed then
				cached_config.settings.damage_bar_relative_to = customization_menu.damage_meter_UI_damage_bar_relative_types[index];
			end
			changed, index = imgui.combo(language.current_language.customization_menu.my_damage_bar_location,
				table_helpers.find_index(customization_menu.damage_meter_UI_my_damage_bar_location_types,
					cached_config.settings.my_damage_bar_location),
				customization_menu.displayed_damage_meter_UI_my_damage_bar_location_types);
			config_changed = config_changed or changed;
			if changed then
				cached_config.settings.my_damage_bar_location = customization_menu.damage_meter_UI_my_damage_bar_location_types[
					index];
			end
			changed, index = imgui.combo(language.current_language.customization_menu.dps_mode,
				table_helpers.find_index(customization_menu.damage_meter_UI_dps_modes, cached_config.settings.dps_mode),
				customization_menu.displayed_damage_meter_UI_dps_modes);
			config_changed = config_changed or changed;
			if changed then
				cached_config.settings.dps_mode = customization_menu.damage_meter_UI_dps_modes[index];
			end
			changed, cached_config.settings.player_name_size_limit = imgui.drag_float(language.current_language.customization_menu
				.player_name_size_limit, cached_config.settings.player_name_size_limit, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.tracked_monster_types) then
			local tracked_monster_types_changed = false;
			changed, cached_config.tracked_monster_types.small_monsters = imgui.checkbox(language.current_language.customization_menu
				.small_monsters, cached_config.tracked_monster_types.small_monsters);
			config_changed = config_changed or changed;
			tracked_monster_types_changed = tracked_monster_types_changed or changed;
			changed, cached_config.tracked_monster_types.large_monsters = imgui.checkbox(language.current_language.customization_menu
				.large_monsters, cached_config.tracked_monster_types.large_monsters);
			config_changed = config_changed or changed;
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
			changed, cached_config.tracked_damage_types.player_damage = imgui.checkbox(language.current_language.customization_menu
				.player_damage, cached_config.tracked_damage_types.player_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;
			changed, cached_config.tracked_damage_types.bomb_damage = imgui.checkbox(language.current_language.customization_menu
				.bomb_damage, cached_config.tracked_damage_types.bomb_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;
			changed, cached_config.tracked_damage_types.kunai_damage = imgui.checkbox(language.current_language.customization_menu
				.kunai_damage, cached_config.tracked_damage_types.kunai_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;
			changed, cached_config.tracked_damage_types.installation_damage = imgui.checkbox(language.current_language.customization_menu
				.installation_damage, cached_config.tracked_damage_types.installation_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;
			changed, cached_config.tracked_damage_types.otomo_damage = imgui.checkbox(language.current_language.customization_menu
				.otomo_damage, cached_config.tracked_damage_types.otomo_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;
			changed, cached_config.tracked_damage_types.wyvern_riding_damage = imgui.checkbox(language.current_language.customization_menu
				.wyvern_riding_damage, cached_config.tracked_damage_types.wyvern_riding_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;
			changed, cached_config.tracked_damage_types.poison_damage = imgui.checkbox(language.current_language.customization_menu
				.poison_damage, cached_config.tracked_damage_types.poison_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;
			changed, cached_config.tracked_damage_types.blast_damage = imgui.checkbox(language.current_language.customization_menu
				.blast_damage, cached_config.tracked_damage_types.blast_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;
			changed, cached_config.tracked_damage_types.endemic_life_damage = imgui.checkbox(language.current_language.customization_menu
				.endemic_life_damage, cached_config.tracked_damage_types.endemic_life_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;
			changed, cached_config.tracked_damage_types.other_damage = imgui.checkbox(language.current_language.customization_menu
				.other_damage, cached_config.tracked_damage_types.other_damage);
			config_changed = config_changed or changed;
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
			changed, cached_config.spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
			config_changed = config_changed or changed;
			changed, cached_config.spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.position.x, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;
			changed, cached_config.position.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.position.y, 0.1, 0, screen.height, "%.1f");
			config_changed = config_changed or changed;
			changed, index = imgui.combo(language.current_language.customization_menu.anchor,
				table_helpers.find_index(customization_menu.anchor_types, cached_config.position.anchor),
				customization_menu.displayed_anchor_types);
			config_changed = config_changed or changed;
			if changed then
				cached_config.position.anchor = customization_menu.anchor_types[index];
			end
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(language.current_language.customization_menu.type,
				table_helpers.find_index(customization_menu.damage_meter_UI_sorting_types, cached_config.sorting.type),
				customization_menu.displayed_damage_meter_UI_sorting_types);
			config_changed = config_changed or changed;
			if changed then
				cached_config.sorting.type = customization_menu.damage_meter_UI_sorting_types[index];
			end
			changed, cached_config.sorting.reversed_order = imgui.checkbox(language.current_language.customization_menu.reversed_order
				, cached_config.sorting.reversed_order);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.player_name_label) then
			changed, cached_config.player_name_label.visibility = imgui.checkbox(language.current_language.customization_menu.visible
				, cached_config.player_name_label.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.include) then
				if imgui.tree_node(language.current_language.customization_menu.me) then
					changed, cached_config.player_name_label.include.myself.master_rank = imgui.checkbox(language.current_language.customization_menu
						.master_rank, cached_config.player_name_label.include.myself.master_rank);
					config_changed = config_changed or changed;
					changed, cached_config.player_name_label.include.myself.hunter_rank = imgui.checkbox(language.current_language.customization_menu
						.hunter_rank, cached_config.player_name_label.include.myself.hunter_rank);
					config_changed = config_changed or changed;
					changed, cached_config.player_name_label.include.myself.cart_count = imgui.checkbox(language.current_language.customization_menu
						.cart_count, cached_config.player_name_label.include.myself.cart_count);
					config_changed = config_changed or changed;
					changed, cached_config.player_name_label.include.myself.word_player = imgui.checkbox(language.current_language.customization_menu
						.word_player, cached_config.player_name_label.include.myself.word_player);
					config_changed = config_changed or changed;
					changed, cached_config.player_name_label.include.myself.player_id = imgui.checkbox(language.current_language.customization_menu
						.player_id, cached_config.player_name_label.include.myself.player_id);
					config_changed = config_changed or changed;
					changed, cached_config.player_name_label.include.myself.player_name = imgui.checkbox(language.current_language.customization_menu
						.player_name, cached_config.player_name_label.include.myself.player_name);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.other_players) then
					changed, cached_config.player_name_label.include.others.master_rank = imgui.checkbox(language.current_language.customization_menu
						.master_rank, cached_config.player_name_label.include.others.master_rank);
					config_changed = config_changed or changed;
					changed, cached_config.player_name_label.include.others.hunter_rank = imgui.checkbox(language.current_language.customization_menu
						.hunter_rank, cached_config.player_name_label.include.others.hunter_rank);
					config_changed = config_changed or changed;
					changed, cached_config.player_name_label.include.others.cart_count = imgui.checkbox(language.current_language.customization_menu
						.cart_count, cached_config.player_name_label.include.others.cart_count);
					config_changed = config_changed or changed;
					changed, cached_config.player_name_label.include.others.word_player = imgui.checkbox(language.current_language.customization_menu
						.word_player, cached_config.player_name_label.include.others.word_player);
					config_changed = config_changed or changed;
					changed, cached_config.player_name_label.include.others.player_id = imgui.checkbox(language.current_language.customization_menu
						.player_id, cached_config.player_name_label.include.others.player_id);
					config_changed = config_changed or changed;
					changed, cached_config.player_name_label.include.others.player_name = imgui.checkbox(language.current_language.customization_menu
						.player_name, cached_config.player_name_label.include.others.player_name);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.player_name_label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					cached_config.player_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.player_name_label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					cached_config.player_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, cached_config.player_name_label.color = imgui.color_picker_argb("", cached_config.player_name_label.color,
					customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, cached_config.player_name_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.player_name_label.shadow.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.player_name_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.player_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.player_name_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.player_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.player_name_label.shadow.color = imgui.color_picker_argb("",
						cached_config.player_name_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.hunter_rank_label) then
			changed, cached_config.master_hunter_rank_label.visibility = imgui.checkbox(language.current_language.customization_menu
				.visible, cached_config.master_hunter_rank_label.visibility);
			config_changed = config_changed or changed;
			if imgui.tree_node(language.current_language.customization_menu.include) then
				if imgui.tree_node(language.current_language.customization_menu.me) then
					changed, cached_config.master_hunter_rank_label.include.myself.master_rank = imgui.checkbox(language.current_language
						.customization_menu.master_rank, cached_config.player_name_label.include.myself.master_rank);
					config_changed = config_changed or changed;
					changed, cached_config.master_hunter_rank_label.include.myself.hunter_rank = imgui.checkbox(language.current_language
						.customization_menu.hunter_rank, cached_config.player_name_label.include.myself.hunter_rank);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.other_players) then
					changed, cached_config.master_hunter_rank_label.include.others.master_rank = imgui.checkbox(language.current_language
						.customization_menu.master_rank, cached_config.player_name_label.include.others.master_rank);
					config_changed = config_changed or changed;
					changed, cached_config.master_hunter_rank_label.include.others.hunter_rank = imgui.checkbox(language.current_language
						.customization_menu.hunter_rank, cached_config.player_name_label.include.others.hunter_rank);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.master_hunter_rank_label.offset.x = imgui.drag_float(language.current_language.customization_menu
					.x, cached_config.master_hunter_rank_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				changed, cached_config.master_hunter_rank_label.offset.y = imgui.drag_float(language.current_language.customization_menu
					.y, cached_config.master_hunter_rank_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, cached_config.master_hunter_rank_label.color = imgui.color_picker_argb("",
					cached_config.master_hunter_rank_label.color, customization_menu.color_picker_flags);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end
			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, cached_config.master_hunter_rank_label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu
					.visible, cached_config.master_hunter_rank_label.shadow.visibility);
				config_changed = config_changed or changed;
				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.master_hunter_rank_label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu
						.x, cached_config.master_hunter_rank_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					changed, cached_config.master_hunter_rank_label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu
						.y, cached_config.master_hunter_rank_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.master_hunter_rank_label.shadow.color = imgui.color_picker_argb("",
						cached_config.master_hunter_rank_label.shadow.color, customization_menu.color_picker_flags);
					config_changed = config_changed or changed;
					imgui.tree_pop();
				end
				imgui.tree_pop();
			end
			imgui.tree_pop();
		end
		changed = label_customization.draw(language.current_language.customization_menu.cart_count_label,
			cached_config.cart_count_label);
		config_changed = config_changed or changed;
		changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.dps_label);
		config_changed = config_changed or changed;
		changed = label_customization.draw(language.current_language.customization_menu.damage_value_label,
			cached_config.damage_value_label);
		config_changed = config_changed or changed;
		changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label,
			cached_config.damage_percentage_label);
		config_changed = config_changed or changed;
		changed = label_customization.draw(language.current_language.customization_menu.total_damage_label,
			cached_config.total_damage_label);
		config_changed = config_changed or changed;
		changed = label_customization.draw(language.current_language.customization_menu.total_dps_label,
			cached_config.total_dps_label);
		config_changed = config_changed or changed;
		changed = label_customization.draw(language.current_language.customization_menu.total_damage_value_label,
			cached_config.total_damage_value_label);
		config_changed = config_changed or changed;
		changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.damage_bar);
		config_changed = config_changed or changed;
		changed = bar_customization.draw(language.current_language.customization_menu.highlighted_damage_bar,
			cached_config.highlighted_damage_bar);
		config_changed = config_changed or changed;
		imgui.tree_pop();
	end
	return config_changed;
end

function customization_menu.draw_endemic_life_UI()
	local changed = false;
	local config_changed = false;
	if imgui.tree_node(language.current_language.customization_menu.endemic_life_UI) then
		local cached_config = config.current_config.endemic_life_UI;
		changed, cached_config.enabled = imgui.checkbox(language.current_language.customization_menu.enabled,
			cached_config.enabled);
		config_changed = config_changed or changed;
		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_inactive_creatures = imgui.checkbox(language.current_language.customization_menu
				.hide_inactive_creatures, cached_config.settings.hide_inactive_creatures);
			config_changed = config_changed or changed;
			changed, cached_config.settings.opacity_falloff = imgui.checkbox(language.current_language.customization_menu.opacity_falloff
				, cached_config.settings.opacity_falloff);
			config_changed = config_changed or changed;
			changed, cached_config.settings.max_distance = imgui.drag_float(language.current_language.customization_menu.max_distance
				, cached_config.settings.max_distance, 1, 0, 10000, "%.0f");
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.world_offset) then
			changed, cached_config.world_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.world_offset.x, 0.1, -100, 100, "%.1f");
			config_changed = config_changed or changed;
			changed, cached_config.world_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.world_offset.y, 0.1, -100, 100, "%.1f");
			config_changed = config_changed or changed;
			changed, cached_config.world_offset.z = imgui.drag_float(language.current_language.customization_menu.z,
				cached_config.world_offset.z, 0.1, -100, 100, "%.1f");
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		if imgui.tree_node(language.current_language.customization_menu.viewport_offset) then
			changed, cached_config.viewport_offset.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.viewport_offset.x, 0.1, -screen.width, screen.width, "%.1f");
			config_changed = config_changed or changed;
			changed, cached_config.viewport_offset.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.viewport_offset.y, 0.1, -screen.height, screen.height, "%.1f");
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end
		changed = label_customization.draw(language.current_language.customization_menu.creature_name_label,
			cached_config.creature_name_label.visibility);
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
	player = require("MHR_Overlay.Damage_Meter.player");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	part_names = require("MHR_Overlay.Misc.part_names");
	time_UI = require("MHR_Overlay.UI.Modules.time_UI");
	keyboard = require("MHR_Overlay.Game_Handler.keyboard");
	label_customization = require("MHR_Overlay.UI.Customizations.label_customization");
	bar_customization = require("MHR_Overlay.UI.Customizations.bar_customization");
	customization_menu.init();
	customization_menu.reload_font(false);
end

return customization_menu;
