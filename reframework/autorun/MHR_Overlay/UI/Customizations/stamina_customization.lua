local stamina_customization = {};

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

function stamina_customization.draw(cached_config)
	local changed = false;
	local config_changed = false;

	if imgui.tree_node(language.current_language.customization_menu.stamina) then
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

function stamina_customization.init_module()
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

return stamina_customization;