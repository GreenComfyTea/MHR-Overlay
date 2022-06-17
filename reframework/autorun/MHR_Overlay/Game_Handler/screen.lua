local screen = {};

local config;
local singletons;

screen.width = 1920;
screen.height = 1080;

function screen.update_window_size()
	local width;
	local height;

	if d2d ~= nil then
		width, height = d2d.surface_size();
	else
		width, height = screen.get_game_window_size();
	end
	
	if width ~= nil then
		screen.width = width;
	end

	if height ~= nil then
		screen.height = height;
	end
end

local scene_view;
local scene_view_type = sdk.find_type_definition("via.SceneView");
local get_size_method = scene_view_type:get_method("get_Size");

local size_type = get_size_method:get_return_type();
local width_field = size_type:get_field("w");
local height_field = size_type:get_field("h");

function screen.get_game_window_size()
	if scene_view == nil then
		scene_view = sdk.call_native_func(singletons.scene_manager, sdk.find_type_definition("via.SceneManager"), "get_MainView");

		if scene_view == nil then
			--log.error("[MHR_Overlay.lua] No scene view");
			return;
		end
	end

	local size = get_size_method:call(scene_view);
	if size == nil then
		--log.error("[MHR_Overlay.lua] No scene view size");
		return;
	end

	local screen_width = width_field:get_data(size);
	if screen_width == nil then
		--log.error("[MHR_Overlay.lua] No screen width");
		return;
	end

	local screen_height = height_field:get_data(size);
	if  screen_height == nil then
		--log.error("[MHR_Overlay.lua] No screen height");
		return;
	end

	return screen_width, screen_height;
end

function screen.calculate_absolute_coordinates(position)
	local _position = {
		x = position.x * config.current_config.global_settings.modifiers.global_position_modifier;
		y = position.y * config.current_config.global_settings.modifiers.global_position_modifier;
	}
	
	-- top left
	if position.anchor == "Top-Left" then
		return {x = _position.x, y = _position.y};
	end

	-- top right
	if position.anchor == "Top-Right" then
		local screen_x = screen.width - _position.x;
		return {x = screen_x, y = _position.y};
	end

	-- bottom left
	if position.anchor == "Bottom-Left" then
		local screen_y = screen.height - _position.y;
		return {x = _position.x, y = screen_y};
	end

	-- bottom right
	if position.anchor == "Bottom-Right" then
		local screen_x = screen.width - _position.x;
		local screen_y = screen.height - _position.y;
		return {x = screen_x, y = screen_y};
	end

	return {x = _position.x, y = _position.y};
end

function screen.init_module()
	config = require("MHR_Overlay.Misc.config");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
end

return screen;
