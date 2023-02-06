local rage_UI_entity = {};

local table_helpers;
local drawing;
local language;
local config;

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

function rage_UI_entity.new(visibility, bar, text_label, value_label, percentage_label, timer_label)
	local entity = {};

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	entity.visibility = visibility;
	entity.bar = table_helpers.deep_copy(bar);
	entity.text_label = table_helpers.deep_copy(text_label);
	entity.value_label = table_helpers.deep_copy(value_label);
	entity.percentage_label = table_helpers.deep_copy(percentage_label);
	entity.timer_label = table_helpers.deep_copy(timer_label);

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

	entity.timer_label.offset.x = entity.timer_label.offset.x * global_scale_modifier;
	entity.timer_label.offset.y = entity.timer_label.offset.y * global_scale_modifier;

	return entity;
end

function rage_UI_entity.draw(monster, rage_UI, position_on_screen, opacity_scale)
	if not rage_UI.visibility then
		return;
	end

	if monster.is_in_rage then
		drawing.draw_bar(rage_UI.bar, position_on_screen, opacity_scale, monster.rage_timer_percentage);

		drawing.draw_label(rage_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.rage);
		drawing.draw_label(rage_UI.timer_label, position_on_screen, opacity_scale, monster.rage_minutes_left,
			monster.rage_seconds_left);
	else
		drawing.draw_bar(rage_UI.bar, position_on_screen, opacity_scale, monster.rage_percentage);

		drawing.draw_label(rage_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.rage);
		drawing.draw_label(rage_UI.value_label, position_on_screen, opacity_scale, monster.rage_point, monster.rage_limit);
		drawing.draw_label(rage_UI.percentage_label, position_on_screen, opacity_scale, 100 * monster.rage_percentage);
	end
end

function rage_UI_entity.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	drawing = require("MHR_Overlay.UI.drawing");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
end

return rage_UI_entity;
