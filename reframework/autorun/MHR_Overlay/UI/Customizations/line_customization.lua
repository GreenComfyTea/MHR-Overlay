local line_customization = {};

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

function line_customization.draw(line_name, line)
	if line == nil then
		return;
	end

	local line_changed = false;
	local changed = false;

	if imgui.tree_node(line_name) then
		changed, line.visibility = imgui.checkbox(language.current_language.customization_menu.visible
			, line.visibility);
		line_changed = line_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.offset) then
			changed, line.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
				line.offset.x, 0.1, -screen.width, screen.width, "%.1f");
			line_changed = line_changed or changed;

			changed, line.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
				line.offset.y, 0.1, -screen.height, screen.height, "%.1f");
			line_changed = line_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.size) then
			changed, line.size.width = imgui.drag_float(language.current_language.customization_menu.width,
				line.size.width, 0.1, 0, screen.width, "%.1f");
			line_changed = line_changed or changed;

			changed, line.size.height = imgui.drag_float(language.current_language.customization_menu.height,
				line.size.height, 0.1, 0, screen.height, "%.1f");
			line_changed = line_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.color) then
			changed, line.color = imgui.color_picker_argb("", line.color,
				customization_menu.color_picker_flags);
			line_changed = line_changed or changed;

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	return line_changed;
end

function line_customization.init_module()
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

return line_customization;
