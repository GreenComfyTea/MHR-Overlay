local this = {};

local utils;
local drawing;
local language;
local config;
local error_handler;

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

function this.new(visibility, bar, text_label, value_label, percentage_label)
	local entity = {};

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	entity.visibility = visibility;
	entity.bar = utils.table.deep_copy(bar);
	entity.text_label = utils.table.deep_copy(text_label);
	entity.value_label = utils.table.deep_copy(value_label);
	entity.percentage_label = utils.table.deep_copy(percentage_label);

	entity.bar.offset.x = entity.bar.offset.x * global_scale_modifier;
	entity.bar.offset.y = entity.bar.offset.y * global_scale_modifier;
	entity.bar.size.width = entity.bar.size.width * global_scale_modifier;
	entity.bar.size.height = entity.bar.size.height * global_scale_modifier;
	entity.bar.outline.thickness = entity.bar.outline.thickness * global_scale_modifier;
	entity.bar.outline.offset = entity.bar.outline.offset * global_scale_modifier;

	entity.text_label.offset.x = entity.text_label.offset.x * global_scale_modifier;
	entity.text_label.offset.y = entity.text_label.offset.y * global_scale_modifier;

	entity.value_label.offset.x = entity.value_label.offset.x * global_scale_modifier;
	entity.value_label.offset.y = entity.value_label.offset.y * global_scale_modifier;

	entity.percentage_label.offset.x = entity.percentage_label.offset.x * global_scale_modifier;
	entity.percentage_label.offset.y = entity.percentage_label.offset.y * global_scale_modifier;

	return entity;
end

function this.draw(monster, health_UI, position_on_screen, opacity_scale)
	if not health_UI.visibility then
		return;
	end

	local include_current_value = health_UI.value_label.include.current_value;
	local include_max_value = health_UI.value_label.include.max_value;

	local health_string;
	if include_current_value and include_max_value then
		health_string = string.format("%.0f/%.0f", monster.health, monster.max_health);
	elseif include_current_value then
		health_string = string.format("%.0f", monster.health);
	elseif include_max_value then
		health_string = string.format("%.0f", monster.max_health);
	end

	drawing.draw_bar(health_UI.bar, position_on_screen, opacity_scale, monster.health_percentage);

	drawing.draw_label(health_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.HP);
	drawing.draw_label(health_UI.value_label, position_on_screen, opacity_scale, health_string);
	drawing.draw_label(health_UI.percentage_label, position_on_screen, opacity_scale, 100 * monster.health_percentage);
end

function this.init_dependencies()
	utils = require("MHR_Overlay.Misc.utils");
	drawing = require("MHR_Overlay.UI.drawing");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
end

return this;
