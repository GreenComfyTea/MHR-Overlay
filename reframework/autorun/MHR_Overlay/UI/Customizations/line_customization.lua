local this = {};

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

function this.draw(line_name, line)
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

function this.init_dependencies()
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
end

function this.init_module()
end

return this;
