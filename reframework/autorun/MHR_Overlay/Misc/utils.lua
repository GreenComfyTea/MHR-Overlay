local utils = {};

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

function utils.sign(v)
	return (v >= 0 and 1) or -1;
end
function utils.round(value, bracket)
	bracket = bracket or 1;
	return math.floor(value / bracket + utils.sign(value) * 0.5) * bracket;
end

function  utils.init_module()
end

return utils;