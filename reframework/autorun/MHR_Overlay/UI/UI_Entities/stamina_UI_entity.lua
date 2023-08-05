local this = {};

local utils;
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
local os = os;
local ValueType = ValueType;
local package = package;

function this.new(visibility, bar, text_label, value_label, percentage_label, timer_label)
	local entity = {};

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	entity.visibility = visibility;
	entity.bar = utils.table.deep_copy(bar);
	entity.text_label = utils.table.deep_copy(text_label);
	entity.value_label = utils.table.deep_copy(value_label);
	entity.percentage_label = utils.table.deep_copy(percentage_label);
	entity.timer_label = utils.table.deep_copy(timer_label);

	entity.bar.offset.x = entity.bar.offset.x * global_scale_modifier;
	entity.bar.offset.y = entity.bar.offset.y * global_scale_modifier;
	entity.bar.size.width = entity.bar.size.width * global_scale_modifier;
	entity.bar.size.height = entity.bar.size.height * global_scale_modifier;

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

function this.draw(monster, stamina_UI, position_on_screen, opacity_scale)
	if not stamina_UI.visibility then
		return;
	end

	local stamina_string = "";
	if not monster.is_tired then
		local include_current_value = stamina_UI.value_label.include.current_value;
		local include_max_value = stamina_UI.value_label.include.max_value;
	
		if include_current_value and include_max_value then
			stamina_string = string.format("%.0f/%.0f", monster.stamina, monster.max_stamina);
		elseif include_current_value then
			stamina_string = string.format("%.0f", monster.stamina);
		elseif include_max_value then
			stamina_string = string.format("%.0f", monster.max_stamina);
		end
	end

	drawing.draw_label(stamina_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.stamina);

	if monster.is_tired then
		drawing.draw_bar(stamina_UI.bar, position_on_screen, opacity_scale, monster.tired_timer_percentage);

		drawing.draw_label(stamina_UI.timer_label, position_on_screen, opacity_scale, monster.tired_minutes_left, monster.tired_seconds_left);
	else
		drawing.draw_bar(stamina_UI.bar, position_on_screen, opacity_scale, monster.stamina_percentage);

		drawing.draw_label(stamina_UI.value_label, position_on_screen, opacity_scale, stamina_string);
		drawing.draw_label(stamina_UI.percentage_label, position_on_screen, opacity_scale, 100 * monster.stamina_percentage);
	end
end

function this.init_dependencies()
	utils = require("MHR_Overlay.Misc.utils");
	drawing = require("MHR_Overlay.UI.drawing");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
end

function this.init_module()
end

return this;
