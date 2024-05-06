local this = {};

local config;
local singletons;
local utils;
local time;
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

this.width = 1920;
this.height = 1080;

function this.update_window_size()
	local width;
	local height;

	-- if d2d ~= nil and config.current_config.global_settings.renderer.use_d2d_if_available then
	--  	width, height = d2d.surface_size();
	--  else
	--	width, height = this.get_game_window_size();
	--  end

	width, height = this.get_game_window_size();

	if width ~= nil then
		this.width = width;
	end

	if height ~= nil then
		this.height = height;
	end
end

local scene_view;
local scene_view_type = sdk.find_type_definition("via.SceneView");
local get_size_method = scene_view_type:get_method("get_Size");

local size_type = get_size_method:get_return_type();
local width_field = size_type:get_field("w");
local height_field = size_type:get_field("h");

function this.get_game_window_size()
	if scene_view == nil then
		scene_view = sdk.call_native_func(singletons.scene_manager, sdk.find_type_definition("via.SceneManager") , "get_MainView");

		if scene_view == nil then
			error_handler.report("screen.get_game_window_size", "Failed to Access Data: scene_view");
			return;
		end
	end

	local size = get_size_method:call(scene_view);
	if size == nil then
		error_handler.report("screen.get_game_window_size", "Failed to Access Data: size");
		return;
	end

	local screen_width = width_field:get_data(size);
	if screen_width == nil then
		error_handler.report("screen.get_game_window_size", "Failed to Access Data: screen_width");
		return;
	end

	local screen_height = height_field:get_data(size);
	if screen_height == nil then
		error_handler.report("screen.get_game_window_size", "Failed to Access Data: screen_height");
		return;
	end

	return screen_width, screen_height;
end

function this.calculate_absolute_coordinates(position)
	local global_position_modifier = config.current_config.global_settings.modifiers.global_position_modifier;

	local _position = {
		x = position.x * global_position_modifier;
		y = position.y * global_position_modifier;
	}

	-- top left
	if position.anchor == "Top-Left" then
		return { x = _position.x, y = _position.y };
	end

	-- top right
	if position.anchor == "Top-Right" then
		local screen_x = this.width - _position.x;
		return { x = screen_x, y = _position.y };
	end

	-- bottom left
	if position.anchor == "Bottom-Left" then
		local screen_y = this.height - _position.y;
		return { x = _position.x, y = screen_y };
	end

	-- bottom right
	if position.anchor == "Bottom-Right" then
		local screen_x = this.width - _position.x;
		local screen_y = this.height - _position.y;
		return { x = screen_x, y = screen_y };
	end

	return { x = _position.x, y = _position.y };
end

function this.init_dependencies()
	config = require("MHR_Overlay.Misc.config");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	time = require("MHR_Overlay.Game_Handler.time");
	utils = require("MHR_Overlay.Misc.utils");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
end

return this;
