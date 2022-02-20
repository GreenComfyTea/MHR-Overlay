local config = require "MHR_Overlay.Misc.config"
local screen = {};
local config;

screen.width = 1920;
screen.height = 1080;

function screen.update_window_size()
	local width, height = d2d.surface_size();
	
	if width ~= nil then
		screen.width = width;
	end

	if height ~= nil then
		screen.height = height;
	end
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
end

return screen;
