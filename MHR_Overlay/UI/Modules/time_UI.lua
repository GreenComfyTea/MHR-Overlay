local time_UI = {};
local singletons;
local customization_menu;
local screen;
local config;
local drawing;

function time_UI.draw()
	if singletons.quest_manager == nil then
		return;
	end



	local quest_time_elapsed_minutes = singletons.quest_manager:call("getQuestElapsedTimeMin");
	if quest_time_elapsed_minutes == nil then
		customization_menu.status = "No quest time elapsed minutes";
		return;
	end

	local quest_time_total_elapsed_seconds = singletons.quest_manager:call("getQuestElapsedTimeSec");
	if quest_time_total_elapsed_seconds == nil then
		customization_menu.status = "No quest time total elapsed seconds";
		return;
	end

	if quest_time_total_elapsed_seconds == 0 then
		return;
	end
	
	local quest_time_elapsed_seconds = quest_time_total_elapsed_seconds - quest_time_elapsed_minutes * 60;

	local position_on_screen = screen.calculate_absolute_coordinates(config.current_config.time_UI.position);
	
	drawing.draw_label(config.current_config.time_UI.time_label, position_on_screen, 1, quest_time_elapsed_minutes, quest_time_elapsed_seconds);
end

function time_UI.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	screen = require("MHR_Overlay.Game_Handler.screen");
	config = require("MHR_Overlay.Misc.config");
	drawing = require("MHR_Overlay.UI.drawing");
end

return time_UI;