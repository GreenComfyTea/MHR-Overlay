local this = {};

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

this.ailment_buildups_sorting_types = {};
this.displayed_ailment_buildups_sorting_types = {};

this.highlighted_buildup_bar_types = {};
this.displayed_highlighted_buildup_bar_types = {};

this.buildup_bar_relative_types = {};
this.displayed_buildup_bar_relative_types = {};

function this.init()
	local default = language.default_language.customization_menu;
	local current = language.current_language.customization_menu;

	this.ailment_buildups_sorting_types =
	{
		default.normal,
		default.buildup,
		default.buildup_percentage
	};

	this.displayed_ailment_buildups_sorting_types =
	{
		current.normal,
		current.buildup,
		current.buildup_percentage
	};

	this.highlighted_buildup_bar_types =
	{
		default.me,
		default.top_buildup,
		default.none
	};

	this.displayed_highlighted_buildup_bar_types =
	{
		current.me,
		current.top_buildup,
		current.none
	};

	this.buildup_bar_relative_types =
	{
		default.total_buildup,
		default.top_buildup
	};

	
	this.displayed_buildup_bar_relative_types =
	{
		current.total_buildup,
		current.top_buildup
	};
end

function this.draw(cached_config)
	local changed = false;
	local config_changed = false;
	local index = 1;

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
				utils.table.find_index(this.highlighted_buildup_bar_types, cached_config.settings.highlighted_bar),
				this.displayed_highlighted_buildup_bar_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.highlighted_bar = this.highlighted_buildup_bar_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.buildup_bars_are_relative_to,
				utils.table.find_index(this.displayed_buildup_bar_relative_types, cached_config.settings.buildup_bar_relative_to),
				this.displayed_buildup_bar_relative_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.buildup_bar_relative_to = this.displayed_buildup_bar_relative_types[index];
			end

			changed, cached_config.settings.time_limit = imgui.drag_float(
				language.current_language.customization_menu.time_limit, cached_config.settings.time_limit, 0.1, 0, 99999, "%.1f");
			
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(
				language.current_language.customization_menu.type,
				utils.table.find_index(this.ailment_buildups_sorting_types, cached_config.sorting.type),
				this.displayed_ailment_buildups_sorting_types);
			
			config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = this.ailment_buildups_sorting_types[index];
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

		changed = label_customization.draw(language.current_language.customization_menu.ailment_name_label, cached_config.ailment_name_label);
		config_changed = config_changed or changed;

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

function this.init_module()
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

return this;