local screen = {};

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
	-- top left
	if position.anchor == "Top-Left" then
		return {x = position.x, y = position.y};
	end

	-- top right
	if position.anchor == "Top-Right" then
		local screen_x = screen.width - position.x;
		return {x = screen_x, y = position.y};
	end

	-- bottom left
	if position.anchor == "Bottom-Left" then
		local screen_y = screen.height - position.y;
		return {x = position.x, y = screen_y};
	end

	-- bottom right
	if position.anchor == "Bottom-Right" then
		local screen_x = screen.width - position.x;
		local screen_y = screen.height - position.y;
		return {x = screen_x, y = screen_y};
	end

	return {x = position.x, y = position.y};
end

function screen.init_module()

end

return screen;
