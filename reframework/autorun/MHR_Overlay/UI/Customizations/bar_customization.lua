local bar_customization = {};

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
local line_customization;

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

function bar_customization.draw(bar_name, bar)
	if bar == nil then
		return false;
	end

	local bar_changed = false;
	local changed = false;
	local index = 1;

	if imgui.tree_node(bar_name) then
		changed, bar.visibility = imgui.checkbox(language.current_language.customization_menu.visible
			, bar.visibility);
		bar_changed = bar_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.offset) then
			changed, bar.offset.x = imgui.drag_float(language.current_language.customization_menu.x,
				bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
			bar_changed = bar_changed or changed;

			changed, bar.offset.y = imgui.drag_float(language.current_language.customization_menu.y,
				bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
			bar_changed = bar_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.size) then
			changed, bar.size.width = imgui.drag_float(language.current_language.customization_menu.width,
				bar.size.width, 0.1, 0, screen.width, "%.1f");
			bar_changed = bar_changed or changed;

			changed, bar.size.height = imgui.drag_float(language.current_language.customization_menu.height,
				bar.size.height, 0.1, 0, screen.height, "%.1f");
			bar_changed = bar_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.outline) then
			changed, bar.outline.visibility = imgui.checkbox(language.current_language.customization_menu.visible
				, bar.outline.visibility);
			bar_changed = bar_changed or changed;

			changed, bar.outline.thickness = imgui.drag_float(language.current_language.customization_menu.thickness,
				bar.outline.thickness, 0.1, 0, screen.width, "%.1f");
			bar_changed = bar_changed or changed;

			changed, bar.outline.offset = imgui.drag_float(language.current_language.customization_menu.offset,
				bar.outline.offset, 0.1, -screen.height, screen.height, "%.1f");
			bar_changed = bar_changed or changed;


			changed, index = imgui.combo(language.current_language.customization_menu.style,
				table_helpers.find_index(customization_menu.outline_styles,
					bar.outline.style),
				customization_menu.displayed_outline_styles);
			bar_changed = bar_changed or changed;

			if changed then
				bar.outline.style = customization_menu.outline_styles[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.colors) then
			local colors = nil;
			if bar.colors ~= nil then
				colors = bar.colors;
			else
				colors = bar.normal_colors;
			end

			if imgui.tree_node(language.current_language.customization_menu.foreground) then
				changed, colors.foreground = imgui.color_picker_argb("", colors.foreground,
					customization_menu.color_picker_flags);
				bar_changed = bar_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.background) then
				changed, colors.background = imgui.color_picker_argb("", colors.background,
					customization_menu.color_picker_flags);
				bar_changed = bar_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.outline) then
				changed, colors.outline = imgui.color_picker_argb("", colors.outline,
					customization_menu.color_picker_flags);
				bar_changed = bar_changed or changed;

				imgui.tree_pop();
			end

			if bar.capture_colors ~= nil then
				if imgui.tree_node(language.current_language.customization_menu.monster_can_be_captured) then
					if imgui.tree_node(language.current_language.customization_menu.foreground) then
						changed, bar.capture_colors.foreground = imgui.color_picker_argb("",
							bar.capture_colors.foreground
							,
							customization_menu.color_picker_flags);
						bar_changed = bar_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.background) then
						changed, bar.capture_colors.background = imgui.color_picker_argb("",
							bar.capture_colors.background
							,
							customization_menu.color_picker_flags);
						bar_changed = bar_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node(language.current_language.customization_menu.outline) then
						changed, bar.capture_colors.outline = imgui.color_picker_argb("",
							bar.capture_colors.outline
							,
							customization_menu.color_picker_flags);
						bar_changed = bar_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end
			end

			imgui.tree_pop();
		end

		changed = line_customization.draw(language.current_language.customization_menu.capture_line, bar.capture_line);
		bar_changed = bar_changed or changed;

		imgui.tree_pop();
	end

	return bar_changed;
end

function bar_customization.init_module()
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
	line_customization = require("MHR_Overlay.UI.Customizations.line_customization");
end

return bar_customization;
