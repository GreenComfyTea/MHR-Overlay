local this = {};

local time;
local screen;
local config;
local drawing;
local utils;

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

this.label = nil;

function this.draw()
	local elapsed_minutes = time.elapsed_minutes;
	local elapsed_seconds = time.elapsed_seconds;

	if elapsed_seconds == 0 and elapsed_minutes == 0 then
		return;
	end

	local position_on_screen = screen.calculate_absolute_coordinates(config.current_config.time_UI.position);

	drawing.draw_label(this.label, position_on_screen, 1, elapsed_minutes, elapsed_seconds);
end

function this.init_UI()
	this.label = utils.table.deep_copy(config.current_config.time_UI.time_label);

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	this.label.offset.x = this.label.offset.x * global_scale_modifier;
	this.label.offset.y = this.label.offset.y * global_scale_modifier;
end

function this.init_dependencies()
	time = require("MHR_Overlay.Game_Handler.time");
	screen = require("MHR_Overlay.Game_Handler.screen");
	config = require("MHR_Overlay.Misc.config");
	drawing = require("MHR_Overlay.UI.drawing");
	utils = require("MHR_Overlay.Misc.utils");
end

function this.init_module()
	this.init_UI()
end

return this;
