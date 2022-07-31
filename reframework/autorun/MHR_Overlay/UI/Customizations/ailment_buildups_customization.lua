local ailment_buildups_customization = {};

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
local customization_menu;
local label_customization;
local bar_customization;

function ailment_buildups_customization.draw(cached_config)
	local changed = false;
	local config_changed = false;

	if imgui.tree_node(language.current_language.customization_menu.ailment_buildups) then
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

		if imgui.tree_node(language.current_language.customization_menu.player_spacing) then
			changed, cached_config.player_spacing.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.player_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
			
			config_changed = config_changed or changed;

			changed, cached_config.player_spacing.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.player_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
			
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.ailment_spacing) then
			changed, cached_config.ailment_spacing.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.ailment_spacing.x, 0.1, -screen.width, screen.width, "%.1f");
			
			config_changed = config_changed or changed;
			
			changed, cached_config.ailment_spacing.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.ailment_spacing.y, 0.1, -screen.height, screen.height, "%.1f");
		
			config_changed = config_changed or changed;
		
			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, index = imgui.combo(
				language.current_language.customization_menu.highlighted_bar,
				table_helpers.find_index(customization_menu.highlighted_buildup_bar_types, cached_config.settings.highlighted_bar),
				customization_menu.displayed_highlighted_buildup_bar_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.highlighted_bar = customization_menu.highlighted_buildup_bar_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.buildup_bars_are_relative_to,
				table_helpers.find_index(customization_menu.displayed_buildup_bar_relative_types, cached_config.settings.buildup_bar_relative_to),
				customization_menu.displayed_buildup_bar_relative_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.buildup_bar_relative_to = customization_menu.displayed_buildup_bar_relative_types[index];
			end

			changed, cached_config.settings.time_limit = imgui.drag_float(
				language.current_language.customization_menu.time_limit, cached_config.settings.time_limit, 0.1, 0, 99999, "%.1f");
			
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(
				language.current_language.customization_menu.type,
				table_helpers.find_index(customization_menu.ailment_buildups_sorting_types, cached_config.sorting.type),
				customization_menu.displayed_ailment_buildups_sorting_types);
			
			config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = customization_menu.ailment_buildups_sorting_types[index];
			end

			changed, cached_config.sorting.reversed_order = imgui.checkbox(
				language.current_language.customization_menu.reversed_order, cached_config.sorting.reversed_order);
			
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.filter) then
			changed, cached_config.filter.stun = imgui.checkbox(
				language.current_language.ailments.stun, cached_config.filter.stun);

			config_changed = config_changed or changed;

			changed, cached_config.filter.poison = imgui.checkbox(
				language.current_language.ailments.poison, cached_config.filter.poison);

			config_changed = config_changed or changed;

			changed, cached_config.filter.blast = imgui.checkbox(
				language.current_language.ailments.blast, cached_config.filter.blast);

			config_changed = config_changed or changed;
			
			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
			changed, cached_config.ailment_name_label.visibility =
				imgui.checkbox(language.current_language.customization_menu.visible,
					cached_config.ailment_name_label.visibility);

			config_changed = config_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.include) then
				changed, cached_config.ailment_name_label.include.ailment_name = imgui.checkbox(
					language.current_language.customization_menu.ailment_name,
					cached_config.ailment_name_label.include.ailment_name);

				config_changed = config_changed or changed;

				changed, cached_config.ailment_name_label.include.activation_count = imgui.checkbox(
					language.current_language.customization_menu.activation_count,
					cached_config.ailment_name_label.include.activation_count);

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.ailment_name_label.offset.x = imgui.drag_float(
					language.current_language.customization_menu.x, cached_config.ailment_name_label.offset.x, 
					0.1, -screen.width, screen.width, "%.1f");

				config_changed = config_changed or changed;

				changed, cached_config.ailment_name_label.offset.y = imgui.drag_float(
					language.current_language.customization_menu.y, cached_config.ailment_name_label.offset.y, 
					0.1, -screen.height, screen.height, "%.1f");

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, cached_config.ailment_name_label.color = imgui.color_picker_argb(
					"", cached_config.ailment_name_label.color, customization_menu.color_picker_flags);
				
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.shadow) then
				changed, cached_config.ailment_name_label.shadow.visibility = imgui.checkbox(
					language.current_language.customization_menu.visible, cached_config.ailment_name_label.shadow.visibility);

				config_changed = config_changed or changed;

				if imgui.tree_node(language.current_language.customization_menu.offset) then
					changed, cached_config.ailment_name_label.shadow.offset.x = imgui.drag_float(
						language.current_language.customization_menu.x, cached_config.ailment_name_label.shadow.offset.x, 
						0.1, -screen.width, screen.width, "%.1f");

					config_changed = config_changed or changed;

					changed, cached_config.ailment_name_label.shadow.offset.y = imgui.drag_float(
						language.current_language.customization_menu.y, cached_config.ailment_name_label.shadow.offset.y, 
						0.1, -screen.height, screen.height, "%.1f");

					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(language.current_language.customization_menu.color) then
					changed, cached_config.ailment_name_label.shadow.color = imgui.color_picker_argb(
						"", cached_config.ailment_name_label.shadow.color, customization_menu.color_picker_flags);

					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		changed = label_customization.draw(language.current_language.customization_menu.player_name_label, cached_config.player_name_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.buildup_value_label, cached_config.buildup_value_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.buildup_percentage_label, cached_config.buildup_percentage_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.total_buildup_label, cached_config.total_buildup_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.total_buildup_value_label, cached_config.total_buildup_value_label);
		config_changed = config_changed or changed;

		changed = bar_customization.draw(language.current_language.customization_menu.buildup_bar, cached_config.buildup_bar);
		config_changed = config_changed or changed;

		changed = bar_customization.draw(language.current_language.customization_menu.highlighted_buildup_bar, cached_config.highlighted_buildup_bar);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function ailment_buildups_customization.init_module()
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
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	
	label_customization = require("MHR_Overlay.UI.Customizations.label_customization");
	bar_customization = require("MHR_Overlay.UI.Customizations.bar_customization");
end

return ailment_buildups_customization;