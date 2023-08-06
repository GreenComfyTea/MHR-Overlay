local this = {};

local time;
local utils;
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
this.is_empty = true;

this.history = {};

function this.report(error_key, error_message)
	if error_key == nil or error_key == ""
	or error_message == nil or error_message == "" then
		return;
	end

	local error_time = time.total_elapsed_script_seconds;

	if error_time == 0 then
		return;
	end

	local error = {
		key = error_key,
		time = error_time,
		message = error_message
	};

	this.list[error_key] = error;
	this.is_empty = false;

	this.add_to_history(error_key, error);
end

function this.add_to_history(error_key, error)
	this.clear_history();

	table.insert(this.history, error);
end

function this.clear_history()
	local history_size = config.current_config.debug.history_size;

	while #this.history >= history_size do
		table.remove(this.history, 1);
	end
end

function this.init_dependencies()
	time = require("MHR_Overlay.Game_Handler.time");
	utils = require("MHR_Overlay.Misc.utils");
	config = require("MHR_Overlay.Misc.config");
end

function this.init_module()
	
end

return this;