local ailments_customization = {};

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
local customization_menu;
local label_customization;
local bar_customization;

function ailments_customization.draw(cached_config)
	local changed = false;
	local config_changed = false;

	if imgui.tree_node(language.current_language.customization_menu.ailments) then
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

		if imgui.tree_node(language.current_language.customization_menu.relative_offset) then
			changed, cached_config.relative_offset.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.relative_offset.x, 0.1, -screen.width, screen.width, "%.1f");
			
			config_changed = config_changed or changed;
			
			changed, cached_config.relative_offset.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.relative_offset.y, 0.1, -screen.height, screen.height, "%.1f");
			
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
			changed, cached_config.settings.hide_ailments_with_zero_buildup = imgui.checkbox(
				language.current_language.customization_menu.hide_ailments_with_zero_buildup, cached_config.settings.hide_ailments_with_zero_buildup);
			
			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_inactive_ailments_with_no_buildup_support = imgui.checkbox(
				language.current_language.customization_menu.hide_inactive_ailments_with_no_buildup_support,
				cached_config.settings.hide_inactive_ailments_with_no_buildup_support);
			
			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_all_inactive_ailments = imgui.checkbox(
				language.current_language.customization_menu.hide_all_inactive_ailments, cached_config.settings.hide_all_inactive_ailments);
			
			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_all_active_ailments = imgui.checkbox(
				language.current_language.customization_menu.hide_all_active_ailments, cached_config.settings.hide_all_active_ailments);
			
			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_disabled_ailments = imgui.checkbox(
				language.current_language.customization_menu.hide_disabled_ailments, cached_config.settings.hide_disabled_ailments);
			
			config_changed = config_changed or changed;

			changed, cached_config.settings.offset_is_relative_to_parts = imgui.checkbox(
				language.current_language.customization_menu.offset_is_relative_to_parts, cached_config.settings.offset_is_relative_to_parts);
			
			config_changed = config_changed or changed;

			changed, cached_config.settings.time_limit = imgui.drag_float(
				language.current_language.customization_menu.time_limit, cached_config.settings.time_limit, 0.1, 0, 99999, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(
				language.current_language.customization_menu.type, 
				table_helpers.find_index(customization_menu.ailments_sorting_types, cached_config.sorting.type),
				customization_menu.displayed_ailments_sorting_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = customization_menu.ailments_sorting_types[index];
			end

			changed, cached_config.sorting.reversed_order = imgui.checkbox(
				language.current_language.customization_menu.reversed_order, cached_config.sorting.reversed_order);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.filter) then
			changed, cached_config.filter.paralysis = imgui.checkbox(
				language.current_language.ailments.paralysis, cached_config.filter.paralysis);

			config_changed = config_changed or changed;

			changed, cached_config.filter.sleep = imgui.checkbox(
				language.current_language.ailments.sleep, cached_config.filter.sleep);
				
			config_changed = config_changed or changed;

			changed, cached_config.filter.stun = imgui.checkbox(
				language.current_language.ailments.stun, cached_config.filter.stun);

			config_changed = config_changed or changed;

			changed, cached_config.filter.flash = imgui.checkbox(
				language.current_language.ailments.flash, cached_config.filter.flash);

			config_changed = config_changed or changed;

			changed, cached_config.filter.poison = imgui.checkbox(
				language.current_language.ailments.poison, cached_config.filter.poison);

			config_changed = config_changed or changed;

			changed, cached_config.filter.blast = imgui.checkbox(
				language.current_language.ailments.blast, cached_config.filter.blast);

			config_changed = config_changed or changed;

			changed, cached_config.filter.exhaust = imgui.checkbox(
				language.current_language.ailments.exhaust, cached_config.filter.exhaust);

			config_changed = config_changed or changed;

			changed, cached_config.filter.ride = imgui.checkbox(
				language.current_language.ailments.ride, cached_config.filter.ride);

			config_changed = config_changed or changed;

			changed, cached_config.filter.waterblight = imgui.checkbox(
				language.current_language.ailments.waterblight, cached_config.filter.waterblight);

			config_changed = config_changed or changed;

			changed, cached_config.filter.fireblight = imgui.checkbox(
				language.current_language.ailments.fireblight, cached_config.filter.fireblight);

			config_changed = config_changed or changed;

			changed, cached_config.filter.iceblight = imgui.checkbox(
				language.current_language.ailments.iceblight, cached_config.filter.iceblight);

			config_changed = config_changed or changed;

			changed, cached_config.filter.thunderblight = imgui.checkbox(
				language.current_language.ailments.thunderblight, cached_config.filter.thunderblight);

			config_changed = config_changed or changed;

			changed, cached_config.filter.fall_trap = imgui.checkbox(
				language.current_language.ailments.fall_trap, cached_config.filter.fall_trap);

			config_changed = config_changed or changed;

			changed, cached_config.filter.shock_trap = imgui.checkbox(
				language.current_language.ailments.shock_trap, cached_config.filter.shock_trap);

			config_changed = config_changed or changed;

			changed, cached_config.filter.tranq_bomb = imgui.checkbox(
				language.current_language.ailments.tranq_bomb, cached_config.filter.tranq_bomb);

			config_changed = config_changed or changed;

			changed, cached_config.filter.dung_bomb = imgui.checkbox(
				language.current_language.ailments.dung_bomb, cached_config.filter.dung_bomb);

			config_changed = config_changed or changed;

			changed, cached_config.filter.steel_fang = imgui.checkbox(
				language.current_language.ailments.steel_fang, cached_config.filter.steel_fang);

			config_changed = config_changed or changed;

			changed, cached_config.filter.quick_sand = imgui.checkbox(
				language.current_language.ailments.quick_sand, cached_config.filter.quick_sand);

			config_changed = config_changed or changed;

			changed, cached_config.filter.fall_otomo_trap = imgui.checkbox(
				language.current_language.ailments.fall_otomo_trap, cached_config.filter.fall_otomo_trap);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.shock_otomo_trap = imgui.checkbox(
				language.current_language.ailments.shock_otomo_trap, cached_config.filter.shock_otomo_trap);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.ailment_name_label) then
			changed, cached_config.ailment_name_label.visibility = imgui.checkbox(
				language.current_language.customization_menu.visible, cached_config.ailment_name_label.visibility);

			config_changed = config_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.include) then
				changed, cached_config.ailment_name_label.include.ailment_name = imgui.checkbox(
					language.current_language.customization_menu.ailment_name, cached_config.ailment_name_label.include.ailment_name);

				config_changed = config_changed or changed;

				changed, cached_config.ailment_name_label.include.activation_count = imgui.checkbox(
					language.current_language.customization_menu.activation_count, cached_config.ailment_name_label.include.activation_count);

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.ailment_name_label.offset.x = imgui.drag_float(
					language.current_language.customization_menu.x, cached_config.ailment_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");

				config_changed = config_changed or changed;

				changed, cached_config.ailment_name_label.offset.y = imgui.drag_float(
					language.current_language.customization_menu.y, cached_config.ailment_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				
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

		changed = label_customization.draw(language.current_language.customization_menu.text_label, cached_config.text_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.value_label, cached_config.value_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.percentage_label, cached_config.percentage_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.timer_label, cached_config.timer_label);
		config_changed = config_changed or changed;

		changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.bar);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function ailments_customization.init_module()
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
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	label_customization = require("MHR_Overlay.UI.Customizations.label_customization");
	bar_customization = require("MHR_Overlay.UI.Customizations.bar_customization");
end

return ailments_customization;