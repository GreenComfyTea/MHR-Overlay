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

function this.draw(label_name, label)
	local cached_language = language.current_language.customization_menu;

	local label_changed = false;
	local changed = false;

	if imgui.tree_node(label_name) then
		changed, label.visibility = imgui.checkbox(cached_language.visible, label.visibility);
		label_changed = label_changed or changed;

		if imgui.tree_node(cached_language.settings) then
			changed, label.settings.right_alignment_shift = imgui.slider_int(cached_language.right_alignment_shift, label.settings.right_alignment_shift, 0, 64);
			label_changed = label_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(cached_language.offset) then
			changed, label.offset.x = imgui.drag_float(cached_language.x, label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
			label_changed = label_changed or changed;

			changed, label.offset.y = imgui.drag_float(cached_language.y, label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
			label_changed = label_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(cached_language.color) then
			changed, label.color = imgui.color_picker_argb("", label.color, customization_menu.color_picker_flags);
			label_changed = label_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(cached_language.shadow) then
			changed, label.shadow.visibility = imgui.checkbox(cached_language
					.visible, label.shadow.visibility);
			label_changed = label_changed or changed;

			if imgui.tree_node(cached_language.offset) then
				changed, label.shadow.offset.x = imgui.drag_float(cached_language.x,
					label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				label_changed = label_changed or changed;

				changed, label.shadow.offset.y = imgui.drag_float(cached_language.y,
					label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				label_changed = label_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(cached_language.color) then
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

function this.init_module()
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

return this;
