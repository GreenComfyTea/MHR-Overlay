local this = {};

local buff_UI_entity;
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

this.list = {};

function this.new(name)
	local buff = {};

	buff.name = name;
	buff.timer = 0;
	buff.duration = 0;

	buff.is_active = true;

	buff.timer_percentage = 0;

	buff.minutes_left = 0;
	buff.seconds_left = 0;

	buff.is_infinite = false;

	this.init_UI(buff);

	return buff;
end

function this.init_buffs()
	this.list = {};
end

function this.init_UI(buff)
	local cached_config = config.current_config.buff_UI;
	buff.buff_UI = buff_UI_entity.new(cached_config.bar, cached_config.name_label, cached_config.timer_label);
end

function this.draw(buff, buff_UI, position_on_screen, opacity_scale)
	buff_UI_entity.draw(buff, buff_UI, position_on_screen, opacity_scale);
end

function this.init_module()
	config = require("MHR_Overlay.Misc.config");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");


	local buff = this.new("Enviroment Damage Negated");
	buff.duration = 90;
	buff.timer = 65;
	buff.timer_percentage = 0.66;
	buff.minutes_left = 1;
	buff.seconds_left = 5

	this.list["Enviroment Damage Negated"] = buff;

	local buff = this.new("Sharpness Loss Reduced");
	buff.duration = 120;
	buff.timer = 70;
	buff.timer_percentage = 0.583;
	buff.minutes_left = 1;
	buff.seconds_left = 10

	this.list["Sharpness Loss Reduced"] = buff;

	local buff = this.new("Sharpness Loss Reduced 2");
	buff.duration = 120;
	buff.timer = 70;
	buff.timer_percentage = 0.583;
	buff.minutes_left = 1;
	buff.seconds_left = 10
	buff.is_infinite = true;

	this.list["Sharpness Loss Reduced 2"] = buff;
end

return this;