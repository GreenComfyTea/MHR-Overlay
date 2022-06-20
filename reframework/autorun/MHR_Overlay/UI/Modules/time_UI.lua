local time_UI = {};
local time;
local screen;
local config;
local drawing;
local table_helpers;

time_UI.label = nil;

function time_UI.draw()
	local elapsed_minutes = time.elapsed_minutes;
	local elapsed_seconds = time.elapsed_seconds;

	if elapsed_seconds == 0 and elapsed_minutes == 0 then
		return;
	end

	local position_on_screen = screen.calculate_absolute_coordinates(config.current_config.time_UI.position);
	
	drawing.draw_label(time_UI.label , position_on_screen, 1, elapsed_minutes, elapsed_seconds);
end

function time_UI.init_UI()
	time_UI.label = table_helpers.deep_copy(config.current_config.time_UI.time_label);

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	time_UI.label.offset.x = time_UI.label.offset.x * global_scale_modifier;
	time_UI.label.offset.y = time_UI.label.offset.y * global_scale_modifier;
end

function time_UI.init_module()
	time = require("MHR_Overlay.Game_Handler.time");
	screen = require("MHR_Overlay.Game_Handler.screen");
	config = require("MHR_Overlay.Misc.config");
	drawing = require("MHR_Overlay.UI.drawing");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");

	time_UI.init_UI()
end

return time_UI;