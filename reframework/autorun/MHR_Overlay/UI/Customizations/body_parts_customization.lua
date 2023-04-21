local body_parts_customization = {};

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
local customization_menu;
local label_customization;
local bar_customization;

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

function body_parts_customization.draw(cached_config)
	local changed = false;
	local config_changed = false;
	local index = 0;

	if imgui.tree_node(language.current_language.customization_menu.body_parts) then
		changed, cached_config.visibility = imgui.checkbox(
			language.current_language.customization_menu.visible, cached_config.visibility);
		
		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.offset) then
			changed, cached_config.offset.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.offset.x, 0.1, -screen.width, screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, cached_config.offset.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.offset.y, 0.1, -screen.height, screen.height, "%.1f");
			config_changed = config_changed or changed;

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

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_undamaged_parts = imgui.checkbox(
				language.current_language.customization_menu.hide_undamaged_parts, cached_config.settings.hide_undamaged_parts);
			
			config_changed = config_changed or changed;

			changed, index = imgui.combo(language.current_language.customization_menu.filter_mode,
				utils.table.find_index(customization_menu.large_monster_UI_parts_filter_types, cached_config.settings.filter_mode),
				customization_menu.displayed_large_monster_UI_parts_filter_types);
			
			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.filter_mode = customization_menu.large_monster_UI_parts_filter_types[index];
			end

			changed, cached_config.settings.time_limit = imgui.drag_float(
				language.current_language.customization_menu.time_limit, cached_config.settings.time_limit, 0.1, 0, 99999, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(
				language.current_language.customization_menu.type,
				utils.table.find_index(customization_menu.large_monster_UI_parts_sorting_types, cached_config.sorting.type),
				customization_menu.displayed_large_monster_UI_parts_sorting_types);
			
				config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = customization_menu.large_monster_UI_parts_sorting_types[index];
			end

			changed, cached_config.sorting.reversed_order = imgui.checkbox(
				language.current_language.customization_menu.reversed_order, cached_config.sorting.reversed_order);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.filter) then
			changed, cached_config.filter.health_break_severe = imgui.checkbox(
				language.current_language.customization_menu.health_break_severe_filter, cached_config.filter.health_break_severe);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.health_break = imgui.checkbox(
				language.current_language.customization_menu.health_break_filter, cached_config.filter.health_break);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.health_severe = imgui.checkbox(
				language.current_language.customization_menu.health_severe_filter, cached_config.filter.health_severe);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.health = imgui.checkbox(
				language.current_language.customization_menu.health_filter, cached_config.filter.health);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.break_severe = imgui.checkbox(
				language.current_language.customization_menu.break_severe_filter, cached_config.filter.break_severe);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.break_ = imgui.checkbox(
				language.current_language.customization_menu.break_filter, cached_config.filter.break_);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.severe = imgui.checkbox(
				language.current_language.customization_menu.severe_filter, cached_config.filter.severe);
			
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.part_name_label) then
			changed, cached_config.part_name_label.visibility = imgui.checkbox(
				language.current_language.customization_menu.visible, cached_config.part_name_label.visibility);
			
			config_changed = config_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.include) then
				changed, cached_config.part_name_label.include.part_name = imgui.checkbox(
					language.current_language.customization_menu.part_name, cached_config.part_name_label.include.part_name);
				
				config_changed = config_changed or changed;

				changed, cached_config.part_name_label.include.flinch_count = imgui.checkbox(
					language.current_language.customization_menu.flinch_count, cached_config.part_name_label.include.flinch_count);
				
				config_changed = config_changed or changed;

				changed, cached_config.part_name_label.include.break_count = imgui.checkbox(
					language.current_language.customization_menu.break_count, cached_config.part_name_label.include.break_count);

				config_changed = config_changed or changed;

				changed, cached_config.part_name_label.include.break_max_count = imgui.checkbox(
					language.current_language.customization_menu.break_max_count, cached_config.part_name_label.include.break_max_count);

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.part_name_label.offset.x = imgui.drag_float(
					language.current_language.customization_menu.x, cached_config.part_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				
				config_changed = config_changed or changed;

				changed, cached_config.part_name_label.offset.y = imgui.drag_float(
					language.current_language.customization_menu.y, cached_config.part_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, cached_config.part_name_label.color = imgui.color_picker_argb(
					"", cached_config.part_name_label.color, customization_menu.color_picker_flags);

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, cached_config.part_name_label.shadow.visibility = imgui.checkbox(
					language.current_language.customization_menu.visible, cached_config.part_name_label.shadow.visibility);
				
				config_changed = config_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.part_name_label.shadow.offset.x = imgui.drag_float(
						language.current_language.customization_menu.x, cached_config.part_name_label.shadow.offset.x,
						0.1, -screen.width, screen.width, "%.1f");

					config_changed = config_changed or changed;

					changed, cached_config.part_name_label.shadow.offset.y = imgui.drag_float(
						language.current_language.customization_menu.y, cached_config.part_name_label.shadow.offset.y,
						0.1, -screen.height, screen.height, "%.1f");

					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.part_name_label.shadow.color = imgui.color_picker_argb(
						"",cached_config.part_name_label.shadow.color, customization_menu.color_picker_flags);

					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.part_health) then
			changed, cached_config.part_health.visibility = imgui.checkbox(
				language.current_language.customization_menu.visible, cached_config.part_health.visibility);
			
			config_changed = config_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.part_health.offset.x = imgui.drag_float(
					language.current_language.customization_menu.x, cached_config.part_health.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				
				config_changed = config_changed or changed;

				changed, cached_config.part_health.offset.y = imgui.drag_float(
					language.current_language.customization_menu.y, cached_config.part_health.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			changed = label_customization.draw(language.current_language.customization_menu.text_label, cached_config.part_health.text_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.value_label, cached_config.part_health.value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.percentage_label, cached_config.part_health.percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.part_health.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.break_health) then
			changed, cached_config.part_break.visibility = imgui.checkbox(
				language.current_language.customization_menu.visible, cached_config.part_break.visibility);

			config_changed = config_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.part_break.offset.x = imgui.drag_float(
					language.current_language.customization_menu.x, cached_config.part_break.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				
				config_changed = config_changed or changed;

				changed, cached_config.part_break.offset.y = imgui.drag_float(
					language.current_language.customization_menu.y, cached_config.part_break.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			changed = label_customization.draw(language.current_language.customization_menu.text_label, cached_config.part_break.text_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.value_label, cached_config.part_break.value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.percentage_label, cached_config.part_break.percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.part_break.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.loss_health) then
			changed, cached_config.part_loss.visibility = imgui.checkbox(
				language.current_language.customization_menu.visible, cached_config.part_loss.visibility);

			config_changed = config_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.part_loss.offset.x = imgui.drag_float(
					language.current_language.customization_menu.x, cached_config.part_loss.offset.x, 0.1, -screen.width, screen.width, "%.1f");

				config_changed = config_changed or changed;

				changed, cached_config.part_loss.offset.y = imgui.drag_float(
					language.current_language.customization_menu.y, cached_config.part_loss.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			changed = label_customization.draw(language.current_language.customization_menu.text_label, cached_config.part_loss.text_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.value_label, cached_config.part_loss.value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.percentage_label, cached_config.part_loss.percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.part_loss.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	return config_changed;
end

function body_parts_customization.init_module()
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
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	label_customization = require("MHR_Overlay.UI.Customizations.label_customization");
	bar_customization = require("MHR_Overlay.UI.Customizations.bar_customization");
end

return body_parts_customization;