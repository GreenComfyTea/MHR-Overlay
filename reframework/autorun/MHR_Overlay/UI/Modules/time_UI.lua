local time_UI = {};
local time;
local screen;
local config;
local drawing;

function time_UI.draw()
	local elapsed_minutes = time.elapsed_minutes;
	local elapsed_seconds = time.elapsed_seconds;

	if elapsed_seconds == 0 and elapsed_minutes == 0 then
		return;
	end

	local position_on_screen = screen.calculate_absolute_coordinates(config.current_config.time_UI.position);
	
	drawing.draw_label(config.current_config.time_UI.time_label, position_on_screen, 1, elapsed_minutes, elapsed_seconds);
end

function time_UI.init_module()
	time = require("MHR_Overlay.Game_Handler.time");
	screen = require("MHR_Overlay.Game_Handler.screen");
	config = require("MHR_Overlay.Misc.config");
	drawing = require("MHR_Overlay.UI.drawing");
end

return time_UI;