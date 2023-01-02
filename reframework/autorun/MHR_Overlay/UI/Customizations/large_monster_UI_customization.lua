local large_monster_UI_customization = {};

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
local health_customization;
local stamina_customization;
local rage_customization;
local body_parts_customization;
local ailments_customization;
local ailment_buildups_customization;

function large_monster_UI_customization.draw(cached_config)
	local changed = false;
	local config_changed = false;

	if imgui.tree_node(language.current_language.customization_menu.monster_name_label) then
		changed, cached_config.monster_name_label.visibility = imgui.checkbox(
			language.current_language.customization_menu.visible, cached_config.monster_name_label.visibility);
		
		config_changed = config_changed or changed;
		
		if imgui.tree_node(language.current_language.customization_menu.include) then
			changed, cached_config.monster_name_label.include.monster_name = imgui.checkbox(
				language.current_language.customization_menu.monster_name, cached_config.monster_name_label.include.monster_name);

			config_changed = config_changed or changed;

			changed, cached_config.monster_name_label.include.monster_id = imgui.checkbox(
				language.current_language.customization_menu.monster_id, cached_config.monster_name_label.include.monster_id);
			
			config_changed = config_changed or changed;

			changed, cached_config.monster_name_label.include.crown = imgui.checkbox(
				language.current_language.customization_menu.crown, cached_config.monster_name_label.include.crown);
			
			config_changed = config_changed or changed;

			changed, cached_config.monster_name_label.include.size = imgui.checkbox(
				language.current_language.customization_menu.size, cached_config.monster_name_label.include.size);

			config_changed = config_changed or changed;

			changed, cached_config.monster_name_label.include.scrown_thresholds = imgui.checkbox(
				language.current_language.customization_menu.crown_thresholds, cached_config.monster_name_label.include.scrown_thresholds);

			config_changed = config_changed or changed;
			
			imgui.tree_pop();
		end
		
		if imgui.tree_node(language.current_language.customization_menu.offset) then
			changed, cached_config.monster_name_label.offset.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.monster_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.monster_name_label.offset.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.monster_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.color) then
			changed, cached_config.monster_name_label.color = imgui.color_picker_argb(
				"", cached_config.monster_name_label.color, customization_menu.color_picker_flags);
			
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.shadow) then
			changed, cached_config.monster_name_label.shadow.visibility = imgui.checkbox(
				language.current_language.customization_menu.visible, cached_config.monster_name_label.shadow.visibility);
			
				config_changed = config_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, cached_config.monster_name_label.shadow.offset.x = imgui.drag_float(
					language.current_language.customization_menu.x, cached_config.monster_name_label.shadow.offset.x,
						0.1, -screen.width, screen.width, "%.1f");
				
				config_changed = config_changed or changed;

				changed, cached_config.monster_name_label.shadow.offset.y = imgui.drag_float(
					language.current_language.customization_menu.y, cached_config.monster_name_label.shadow.offset.y,
						0.1, -screen.height, screen.height, "%.1f");
				
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, cached_config.monster_name_label.shadow.color = imgui.color_picker_argb(
					"", cached_config.monster_name_label.shadow.color, customization_menu.color_picker_flags);
				
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	changed = health_customization.draw(cached_config.health);
	config_changed = config_changed or changed;

	changed = stamina_customization.draw(cached_config.stamina);
	config_changed = config_changed or changed;

	changed = rage_customization.draw(cached_config.rage);
	config_changed = config_changed or changed;	

	changed = body_parts_customization.draw(cached_config.body_parts);
	config_changed = config_changed or changed;

	changed = ailments_customization.draw(cached_config.ailments);
	config_changed = config_changed or changed;

	changed = ailment_buildups_customization.draw(cached_config.ailment_buildups);
	config_changed = config_changed or changed;

	return config_changed;
end

function large_monster_UI_customization.init_module()
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

	health_customization = require("MHR_Overlay.UI.Customizations.health_customization");
	stamina_customization = require("MHR_Overlay.UI.Customizations.stamina_customization");
	rage_customization = require("MHR_Overlay.UI.Customizations.rage_customization");
	body_parts_customization = require("MHR_Overlay.UI.Customizations.body_parts_customization");
	ailments_customization = require("MHR_Overlay.UI.Customizations.ailments_customization");
	ailment_buildups_customization = require("MHR_Overlay.UI.Customizations.ailment_buildups_customization");
end

return large_monster_UI_customization;