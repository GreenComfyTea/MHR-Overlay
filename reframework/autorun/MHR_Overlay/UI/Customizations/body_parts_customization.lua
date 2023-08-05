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

this.large_monster_UI_parts_sorting_types = {};
this.displayed_large_monster_UI_parts_sorting_types = {};

this.large_monster_UI_parts_filter_types = {};
this.displayed_large_monster_UI_parts_filter_types = {};

function this.init()
	local default = language.default_language.customization_menu;
	local current = language.current_language.customization_menu;

	this.large_monster_UI_parts_sorting_types =
	{
		default.normal,
		default.health,
		default.health_percentage,
		default.flinch_count,
		default.break_health,
		default.break_health_percentage,
		default.break_count,
		default.loss_health,
		default.loss_health_percentage,
		default.anomaly_health,
		default.anomaly_health_percentage
	};

	this.displayed_large_monster_UI_parts_sorting_types =
	{
		current.normal,
		current.health,
		current.health_percentage,
		current.flinch_count,
		current.break_health,
		current.break_health_percentage,
		current.break_count,
		current.loss_health,
		current.loss_health_percentage,
		current.anomaly_health,
		current.anomaly_health_percentage
	};

	this.large_monster_UI_parts_filter_types =
	{
		default.current_state,
		default.default_state
	};

	this.displayed_large_monster_UI_parts_filter_types =
	{
		current.current_state,
		current.default_state
	};
end

function this.draw(cached_config)
	local cached_language = language.current_language.customization_menu;

	local changed = false;
	local config_changed = false;
	local index = 0;

	if imgui.tree_node(cached_language.body_parts) then
		changed, cached_config.visibility = imgui.checkbox(
			cached_language.visible, cached_config.visibility);
		
		config_changed = config_changed or changed;

		if imgui.tree_node(cached_language.offset) then
			changed, cached_config.offset.x = imgui.drag_float(
				cached_language.x, cached_config.offset.x, 0.1, -screen.width, screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, cached_config.offset.y = imgui.drag_float(
				cached_language.y, cached_config.offset.y, 0.1, -screen.height, screen.height, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(cached_language.spacing) then
			changed, cached_config.spacing.x = imgui.drag_float(
				cached_language.x, cached_config.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
			
			config_changed = config_changed or changed;

			changed, cached_config.spacing.y = imgui.drag_float(
				cached_language.y, cached_config.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
			
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(cached_language.settings) then
			changed, cached_config.settings.hide_undamaged_parts = imgui.checkbox(
				cached_language.hide_undamaged_parts, cached_config.settings.hide_undamaged_parts);
			
			config_changed = config_changed or changed;

			changed, cached_config.settings.render_inactive_anomaly_cores = imgui.checkbox(
				cached_language.render_inactive_anomaly_cores, cached_config.settings.render_inactive_anomaly_cores);
			
			config_changed = config_changed or changed;

			changed, index = imgui.combo(cached_language.filter_mode,
				utils.table.find_index(this.large_monster_UI_parts_filter_types, cached_config.settings.filter_mode),
				this.displayed_large_monster_UI_parts_filter_types);
			
			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.filter_mode = this.large_monster_UI_parts_filter_types[index];
			end

			changed, cached_config.settings.time_limit = imgui.drag_float(
				cached_language.time_limit, cached_config.settings.time_limit, 0.1, 0, 99999, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(cached_language.sorting) then
			changed, index = imgui.combo(
				cached_language.type,
				utils.table.find_index(this.large_monster_UI_parts_sorting_types, cached_config.sorting.type),
				this.displayed_large_monster_UI_parts_sorting_types);
			
				config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = this.large_monster_UI_parts_sorting_types[index];
			end

			changed, cached_config.sorting.reversed_order = imgui.checkbox(
				cached_language.reversed_order, cached_config.sorting.reversed_order);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(cached_language.filter) then
			changed, cached_config.filter.health_break_sever_anomaly = imgui.checkbox(
				cached_language.health_break_sever_anomaly_filter, cached_config.filter.health_break_sever_anomaly);
			
			config_changed = config_changed or changed;



			changed, cached_config.filter.health_break_sever = imgui.checkbox(
				cached_language.health_break_sever_filter, cached_config.filter.health_break_sever);

			config_changed = config_changed or changed;

			changed, cached_config.filter.health_break_anomaly = imgui.checkbox(
				cached_language.health_break_anomaly_filter, cached_config.filter.health_break_anomaly);

			config_changed = config_changed or changed;

			changed, cached_config.filter.health_sever_anomaly = imgui.checkbox(
				cached_language.health_sever_anomaly_filter, cached_config.filter.health_sever_anomaly);

			config_changed = config_changed or changed;

			changed, cached_config.filter.break_sever_anomaly = imgui.checkbox(
				cached_language.break_sever_anomaly_filter, cached_config.filter.break_sever_anomaly);

			config_changed = config_changed or changed;
			
			

			changed, cached_config.filter.health_break = imgui.checkbox(
				cached_language.health_break_filter, cached_config.filter.health_break);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.health_sever = imgui.checkbox(
				cached_language.health_sever_filter, cached_config.filter.health_sever);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.health_anomaly = imgui.checkbox(
				cached_language.health_anomaly_filter, cached_config.filter.health_anomaly);
			
			config_changed = config_changed or changed;



			changed, cached_config.filter.break_sever = imgui.checkbox(
				cached_language.break_sever_filter, cached_config.filter.break_sever);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.break_anomaly = imgui.checkbox(
				cached_language.break_anomaly_filter, cached_config.filter.break_anomaly);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.sever_anomaly = imgui.checkbox(
				cached_language.sever_anomaly_filter, cached_config.filter.sever_anomaly);
			
			config_changed = config_changed or changed;



			changed, cached_config.filter.health = imgui.checkbox(
				cached_language.health_filter, cached_config.filter.health);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.break_ = imgui.checkbox(
				cached_language.break_filter, cached_config.filter.break_);
			
			config_changed = config_changed or changed;

			changed, cached_config.filter.sever = imgui.checkbox(
				cached_language.sever_filter, cached_config.filter.sever);

			config_changed = config_changed or changed;

			changed, cached_config.filter.anomaly = imgui.checkbox(
				cached_language.anomaly_filter, cached_config.filter.anomaly);
			
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(cached_language.part_name_label) then
			changed, cached_config.part_name_label.visibility = imgui.checkbox(
				cached_language.visible, cached_config.part_name_label.visibility);
			
			config_changed = config_changed or changed;

			if imgui.tree_node(cached_language.include) then
				changed, cached_config.part_name_label.include.part_name = imgui.checkbox(
					cached_language.part_name, cached_config.part_name_label.include.part_name);
				
				config_changed = config_changed or changed;

				changed, cached_config.part_name_label.include.flinch_count = imgui.checkbox(
					cached_language.flinch_count, cached_config.part_name_label.include.flinch_count);
				
				config_changed = config_changed or changed;

				changed, cached_config.part_name_label.include.break_count = imgui.checkbox(
					cached_language.break_count, cached_config.part_name_label.include.break_count);

				config_changed = config_changed or changed;

				changed, cached_config.part_name_label.include.break_max_count = imgui.checkbox(
					cached_language.break_max_count, cached_config.part_name_label.include.break_max_count);

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(cached_language.offset) then
				changed, cached_config.part_name_label.offset.x = imgui.drag_float(
					cached_language.x, cached_config.part_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				
				config_changed = config_changed or changed;

				changed, cached_config.part_name_label.offset.y = imgui.drag_float(
					cached_language.y, cached_config.part_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(cached_language.color) then
				changed, cached_config.part_name_label.color = imgui.color_picker_argb(
					"", cached_config.part_name_label.color, customization_menu.color_picker_flags);

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(cached_language.shadow) then
				changed, cached_config.part_name_label.shadow.visibility = imgui.checkbox(
					cached_language.visible, cached_config.part_name_label.shadow.visibility);
				
				config_changed = config_changed or changed;

				if imgui.tree_node(cached_language.offset) then
					changed, cached_config.part_name_label.shadow.offset.x = imgui.drag_float(
						cached_language.x, cached_config.part_name_label.shadow.offset.x,
						0.1, -screen.width, screen.width, "%.1f");

					config_changed = config_changed or changed;

					changed, cached_config.part_name_label.shadow.offset.y = imgui.drag_float(
						cached_language.y, cached_config.part_name_label.shadow.offset.y,
						0.1, -screen.height, screen.height, "%.1f");

					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node(cached_language.color) then
					changed, cached_config.part_name_label.shadow.color = imgui.color_picker_argb(
						"",cached_config.part_name_label.shadow.color, customization_menu.color_picker_flags);

					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(cached_language.part_health) then
			changed, cached_config.part_health.visibility = imgui.checkbox(
				cached_language.visible, cached_config.part_health.visibility);
			
			config_changed = config_changed or changed;

			if imgui.tree_node(cached_language.offset) then
				changed, cached_config.part_health.offset.x = imgui.drag_float(
					cached_language.x, cached_config.part_health.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				
				config_changed = config_changed or changed;

				changed, cached_config.part_health.offset.y = imgui.drag_float(
					cached_language.y, cached_config.part_health.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			changed = label_customization.draw(cached_language.text_label, cached_config.part_health.text_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(cached_language.value_label, cached_config.part_health.value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(cached_language.percentage_label, cached_config.part_health.percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(cached_language.bar, cached_config.part_health.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(cached_language.break_health) then
			changed, cached_config.part_break.visibility = imgui.checkbox(
				cached_language.visible, cached_config.part_break.visibility);

			config_changed = config_changed or changed;

			if imgui.tree_node(cached_language.offset) then
				changed, cached_config.part_break.offset.x = imgui.drag_float(
					cached_language.x, cached_config.part_break.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				
				config_changed = config_changed or changed;

				changed, cached_config.part_break.offset.y = imgui.drag_float(
					cached_language.y, cached_config.part_break.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			changed = label_customization.draw(cached_language.text_label, cached_config.part_break.text_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(cached_language.value_label, cached_config.part_break.value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(cached_language.percentage_label, cached_config.part_break.percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(cached_language.bar, cached_config.part_break.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(cached_language.loss_health) then
			changed, cached_config.part_loss.visibility = imgui.checkbox(
				cached_language.visible, cached_config.part_loss.visibility);

			config_changed = config_changed or changed;

			if imgui.tree_node(cached_language.offset) then
				changed, cached_config.part_loss.offset.x = imgui.drag_float(
					cached_language.x, cached_config.part_loss.offset.x, 0.1, -screen.width, screen.width, "%.1f");

				config_changed = config_changed or changed;

				changed, cached_config.part_loss.offset.y = imgui.drag_float(
					cached_language.y, cached_config.part_loss.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			changed = label_customization.draw(cached_language.text_label, cached_config.part_loss.text_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(cached_language.value_label, cached_config.part_loss.value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(cached_language.percentage_label, cached_config.part_loss.percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(cached_language.bar, cached_config.part_loss.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(cached_language.anomaly_health) then
			changed, cached_config.part_anomaly.visibility = imgui.checkbox(
				cached_language.visible, cached_config.part_anomaly.visibility);

			config_changed = config_changed or changed;

			if imgui.tree_node(cached_language.offset) then
				changed, cached_config.part_anomaly.offset.x = imgui.drag_float(
					cached_language.x, cached_config.part_anomaly.offset.x, 0.1, -screen.width, screen.width, "%.1f");

				config_changed = config_changed or changed;

				changed, cached_config.part_anomaly.offset.y = imgui.drag_float(
					cached_language.y, cached_config.part_anomaly.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			changed = label_customization.draw(cached_language.text_label, cached_config.part_anomaly.text_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(cached_language.value_label, cached_config.part_anomaly.value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(cached_language.percentage_label, cached_config.part_anomaly.percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(cached_language.bar, cached_config.part_anomaly.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	return config_changed;
end

function this.init_dependencies()
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

function this.init_module()
end

return this;