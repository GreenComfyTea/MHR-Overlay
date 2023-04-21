local ailment_UI_entity = {};

local config;
local utils;
local drawing;
local language;

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

function ailment_UI_entity.new(visibility, bar, name_label, text_label, value_label, percentage_label, timer_label)
	local entity = {};

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	entity.visibility = visibility;
	entity.bar = utils.table.deep_copy(bar);
	entity.name_label = utils.table.deep_copy(name_label);
	entity.text_label = utils.table.deep_copy(text_label);
	entity.value_label = utils.table.deep_copy(value_label);
	entity.percentage_label = utils.table.deep_copy(percentage_label);
	entity.timer_label = utils.table.deep_copy(timer_label);

	entity.bar.offset.x = entity.bar.offset.x * global_scale_modifier;
	entity.bar.offset.y = entity.bar.offset.y * global_scale_modifier;
	entity.bar.size.width = entity.bar.size.width * global_scale_modifier;
	entity.bar.size.height = entity.bar.size.height * global_scale_modifier;
	entity.bar.outline.thickness = entity.bar.outline.thickness * global_scale_modifier;
	entity.bar.outline.offset = entity.bar.outline.offset * global_scale_modifier;

	entity.name_label.offset.x = entity.name_label.offset.x * global_scale_modifier;
	entity.name_label.offset.y = entity.name_label.offset.y * global_scale_modifier;

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

function ailment_UI_entity.draw(ailment, ailment_UI, cached_config, position_on_screen, opacity_scale)
	if not ailment_UI.visibility then
		return;
	end

	local ailment_name = "";
	if cached_config.ailment_name_label.include.ailment_name then
		ailment_name = ailment.name .. " ";
	end
	if cached_config.ailment_name_label.include.activation_count and ailment.activate_count ~= 0 then
		ailment_name = ailment_name .. "x" .. tostring(ailment.activate_count);
	end

	local total_buildup_string = "";
	if not ailment.is_active then
		local include_current_value = ailment_UI.value_label.include.current_value;
		local include_max_value = ailment_UI.value_label.include.max_value;

		if include_current_value and include_max_value then
			total_buildup_string = string.format("%.0f/%.0f", ailment.total_buildup, ailment.buildup_limit);
		elseif include_current_value then
			total_buildup_string = string.format("%.0f", ailment.total_buildup);
		elseif include_max_value then
			total_buildup_string = string.format("%.0f", ailment.buildup_limit);
		end
	end

	if ailment.is_active then
		drawing.draw_bar(ailment_UI.bar, position_on_screen, opacity_scale, ailment.timer_percentage);

		drawing.draw_label(ailment_UI.name_label, position_on_screen, opacity_scale, ailment_name);
		drawing.draw_label(ailment_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.buildup);
		drawing.draw_label(ailment_UI.timer_label, position_on_screen, opacity_scale, ailment.minutes_left, ailment.seconds_left);
	else
		drawing.draw_bar(ailment_UI.bar, position_on_screen, opacity_scale, ailment.buildup_percentage);

		drawing.draw_label(ailment_UI.name_label, position_on_screen, opacity_scale, ailment_name);
		drawing.draw_label(ailment_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.buildup);
		drawing.draw_label(ailment_UI.value_label, position_on_screen, opacity_scale, total_buildup_string);
		drawing.draw_label(ailment_UI.percentage_label, position_on_screen, opacity_scale, 100 * ailment.buildup_percentage);
	end
end

function ailment_UI_entity.init_module()
	utils = require("MHR_Overlay.Misc.utils");
	drawing = require("MHR_Overlay.UI.drawing");
	config = require("MHR_Overlay.Misc.config");
	language = require("MHR_Overlay.Misc.language");
end

return ailment_UI_entity;
