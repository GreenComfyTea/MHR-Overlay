local this = {};

local config;
local utils;
local drawing;
local language;
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

function this.new(bar, name_label, timer_label)
	local entity = {};

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	--entity.visibility = visibility;
	entity.bar = utils.table.deep_copy(bar);
	entity.name_label = utils.table.deep_copy(name_label);
	entity.timer_label = utils.table.deep_copy(timer_label);

	entity.bar.offset.x = entity.bar.offset.x * global_scale_modifier;
	entity.bar.offset.y = entity.bar.offset.y * global_scale_modifier;
	entity.bar.size.width = entity.bar.size.width * global_scale_modifier;
	entity.bar.size.height = entity.bar.size.height * global_scale_modifier;
	entity.bar.outline.thickness = entity.bar.outline.thickness * global_scale_modifier;
	entity.bar.outline.offset = entity.bar.outline.offset * global_scale_modifier;

	entity.name_label.offset.x = entity.name_label.offset.x * global_scale_modifier;
	entity.name_label.offset.y = entity.name_label.offset.y * global_scale_modifier;

	entity.timer_label.offset.x = entity.timer_label.offset.x * global_scale_modifier;
	entity.timer_label.offset.y = entity.timer_label.offset.y * global_scale_modifier;

	return entity;
end

function this.draw(buff, buff_UI, position_on_screen, opacity_scale)
	local cached_config = config.current_config.buff_UI;

	if not buff.is_infinite then
		drawing.draw_bar(buff_UI.bar, position_on_screen, opacity_scale, buff.timer_percentage);
	elseif not cached_config.settings.hide_bar_for_infinite_buffs then
		drawing.draw_bar(buff_UI.bar, position_on_screen, opacity_scale, 1);
	end

	local buff_name = buff.name;
	if cached_config.name_label.include.skill_level and buff.level > 1 then
		buff_name = string.format("%s %d", buff_name, buff.level);
	end

	drawing.draw_label(buff_UI.name_label, position_on_screen, opacity_scale, buff_name);

	if not buff.is_infinite then
		drawing.draw_label(buff_UI.timer_label, position_on_screen, opacity_scale, buff.minutes_left, buff.seconds_left);
	elseif not cached_config.settings.hide_timer_for_infinite_buffs then
		drawing.draw_label(buff_UI.timer_label, position_on_screen, opacity_scale, 0, 0);
	end
end

function this.init_dependencies()
	utils = require("MHR_Overlay.Misc.utils");
	drawing = require("MHR_Overlay.UI.drawing");
	config = require("MHR_Overlay.Misc.config");
	language = require("MHR_Overlay.Misc.language");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
end

return this;