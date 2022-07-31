local label_customization = {};

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

function label_customization.draw(label_name, label)
	local label_changed = false;
	local changed = false;

	if imgui.tree_node(label_name) then
		changed, label.visibility = imgui.checkbox(language.current_language.customization_menu.visible
			, label.visibility);
		label_changed = label_changed or changed;

		-- add text format

		if imgui.tree_node(language.current_language.customization_menu.offset) then
			changed, label.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
				label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
			label_changed = label_changed or changed;

			changed, label.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
				label.offset.y, 0.1, -screen.height, screen.height, "%.1f");

			label_changed = label_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.color) then
			changed, label.color = imgui.color_picker_argb("", label.color,
				customization_menu.color_picker_flags);
			label_changed = label_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.shadow) then
			changed, label.shadow.visibility = imgui.checkbox(language.current_language.customization_menu.visible
				, label.shadow.visibility);
			label_changed = label_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.offset) then
				changed, label.shadow.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
					label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				label_changed = label_changed or changed;

				changed, label.shadow.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
					label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				label_changed = label_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.color) then
				changed, label.shadow.color = imgui.color_picker_argb("", label.shadow.color,
					customization_menu.color_picker_flags);
				label_changed = label_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	return label_changed;
end

function label_customization.init_module()
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
end

return label_customization;
