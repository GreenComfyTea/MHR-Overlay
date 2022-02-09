local quest_status = {};
local singletons;
local customization_menu;
local player;
local small_monster;
local large_monster;

quest_status.index = 0;
quest_status.is_online = false;
quest_status.is_training_area = false;

local quest_manager_type_definition = sdk.find_type_definition("snow.QuestManager");
local on_changed_game_status = quest_manager_type_definition:get_method("onChangedGameStatus");

local village_area_manager_type_def = sdk.find_type_definition("snow.VillageAreaManager");
local check_current_area_training_area_method = village_area_manager_type_def:get_method("checkCurrentArea_TrainingArea");

sdk.hook(on_changed_game_status, function(args)
	local new_quest_status = sdk.to_int64(args[3]);
	if new_quest_status ~= nil then
		if (quest_status.index < 2 and new_quest_status == 2) or
		new_quest_status < 2 then

			player.list = {};
			player.total = player.new(0, "Total", 0);
			small_monster.list = {};
			large_monster.list = {};
		end

		quest_status.index = new_quest_status;
	end

end, function(retval)
	return retval;
end);

function quest_status.init()
	if singletons.quest_manager == nil then
		return;
	end

	local new_quest_status = singletons.quest_manager:call("getStatus");
	if new_quest_status == nil then
		customization_menu.status = "No quest status";
		return;
	end

	quest_status.index = new_quest_status;
	quest_status.update_is_online();
	quest_status.update_is_training_area();
end

function quest_status.update_is_online()
	if singletons.lobby_manager == nil then
		return;
	end

	local is_quest_online = singletons.lobby_manager:call("IsQuestOnline");
	if is_quest_online == nil then
		return;
	end

	quest_status.is_online = is_quest_online;
end

function quest_status.update_is_training_area()
	if singletons.village_area_manager == nil then
		customization_menu.status = "No village area manager";
		return;
	end

	local _is_training_area = check_current_area_training_area_method:call(singletons.village_area_manager);
	if _is_training_area == nil then
		return;
	end

	quest_status.is_training_area = _is_training_area;
end

function quest_status.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	player = require("MHR_Overlay.Damage_Meter.player");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	
	quest_status.init();
end

return quest_status;