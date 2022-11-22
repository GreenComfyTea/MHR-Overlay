local quest_status = {};

local singletons;
local customization_menu;
local player;
local small_monster;
local large_monster;
local damage_meter_UI;
local time;
local env_creature;

quest_status.flow_states = {
	NONE = 0,
	IN_LOBBY = 1,
	IN_TRAINING_AREA = 2,
	CUTSCENE = 4,
	LOADING_QUEST = 8,
	QUEST_START_ANIMATION = 16,
	PLAYING_QUEST = 32,

	PLAYER_DEATH_ANIMATION = 64,
	PLAYER_CART_ANIMATION = 128,
	FAST_TRAVEL_ANIMATION = 256,
	WYVERN_RIDING_START_ANIMATION = 512,

	KILLCAM = 1024,
	QUEST_END_TIMER = 2048,
	QUEST_END_ANIMATION = 4096,
	QUEST_END_SCREEN = 8192,
	REWARD_SCREEN = 16384,
	SUMMARY_SCREEN = 32768,
};

quest_status.previous_flow_state = quest_status.flow_states.NONE;
quest_status.flow_state = quest_status.flow_states.NONE;

quest_status.index = 0;
quest_status.is_online = false;
quest_status.is_quest_host = false;

local quest_manager_type_def = sdk.find_type_definition("snow.QuestManager");
local on_changed_game_status_method = quest_manager_type_def:get_method("onChangedGameStatus");
local is_result_demo_play_start_method = quest_manager_type_def:get_method("isResultDemoPlayStart");
local set_quest_clear_method = quest_manager_type_def:get_method("setQuestClear");
local set_quest_clear_sub_method = quest_manager_type_def:get_method("setQuestClearSub");
local set_quest_clear_sub_hyakurui_method = quest_manager_type_def:get_method("setQuestClearSubHyakuryu");
local set_quest_fail_method = quest_manager_type_def:get_method("setQuestFail");

local game_manager_type_def = sdk.find_type_definition("snow.SnowGameManager");
local get_status_method = game_manager_type_def:get_method("getStatus");

local village_area_manager_type_def = sdk.find_type_definition("snow.VillageAreaManager");
local check_current_area_training_area_method = village_area_manager_type_def:get_method("checkCurrentArea_TrainingArea");
local fast_travel_method = village_area_manager_type_def:get_method("fastTravel");

local lobby_manager_type_definition = sdk.find_type_definition("snow.LobbyManager");
local is_quest_online_method = lobby_manager_type_definition:get_method("IsQuestOnline");
local is_quest_host_method = lobby_manager_type_definition:get_method("isQuestHost");

local is_play_quest_method = quest_manager_type_def:get_method("isPlayQuest");
local is_end_wait_method = quest_manager_type_def:get_method("isEndWait");

local demo_camera_type_def = sdk.find_type_definition("snow.camera.DemoCamera");
local demo_request_activation_method = demo_camera_type_def:get_method("RequestActivation");
local demo_end_method = demo_camera_type_def:get_method("DemoEnd");

local gui_quest_end_base_type_def = sdk.find_type_definition("snow.gui.GuiQuestEndBase");
local quest_end_set_state_method = gui_quest_end_base_type_def:get_method("setState");

local gui_result_reward_type_def = sdk.find_type_definition("snow.gui.GuiResultReward");
local gui_result_reward_do_open_method = gui_result_reward_type_def:get_method("doOpen");

local gui_result_pay_off_type_def = sdk.find_type_definition("snow.gui.GuiResultPayOff");
local gui_result_pay_off_do_open_method = gui_result_pay_off_type_def:get_method("doOpen");

local unique_event_manager_type_def = sdk.find_type_definition("snow.eventcut.UniqueEventManager");
local play_event_common_method = unique_event_manager_type_def:get_method("playEventCommon");
local event_manager_dispose_method = unique_event_manager_type_def:get_method("dispose");

function quest_status.get_flow_state(flow_state, new_line)
    for key, value in pairs(quest_status.flow_states) do
		if value == flow_state then
			if new_line then
				return "\n" .. tostring(key);
			else
				return tostring(key);
			end
		end
	end
end

--type 2 = quest start
--type 3 = monster killcam
--type 5 = end screen
function quest_status.on_demo_request_activation(request_data_base)
	if request_data_base == nil then
		return;
	end

	if quest_status.index ~= 2 then
		return;
	end

	local request_data_type = request_data_base:call("get_Type");
	if request_data_type == nil then
		return;
	end

	-- QUEST_START_ANIMATION
	if request_data_type == 2 then
		quest_status.previous_flow_state = quest_status.flow_state;
		quest_status.flow_state = quest_status.flow_states.QUEST_START_ANIMATION;

	-- KILLCAM
	elseif request_data_type == 3 then
		quest_status.previous_flow_state = quest_status.flow_state;
		quest_status.flow_state = quest_status.flow_states.KILLCAM;

	-- QUEST_END_ANIMATION
	elseif request_data_type == 5 or request_data_type == 6 or request_data_type == 7 then
		quest_status.previous_flow_state = quest_status.flow_state;
		quest_status.flow_state = quest_status.flow_states.QUEST_END_ANIMATION;

	-- PLAYER_DEATH_ANIMATION
	elseif request_data_type == 8 then
		quest_status.previous_flow_state = quest_status.flow_state;
		quest_status.flow_state = quest_status.flow_states.PLAYER_DEATH_ANIMATION;

	-- PLAYER_CART_ANIMATION
	elseif request_data_type == 9 then
		quest_status.previous_flow_state = quest_status.flow_state;
		quest_status.flow_state = quest_status.flow_states.PLAYER_CART_ANIMATION;

	-- FAST_TRAVEL_ANIMATION
	elseif request_data_type == 10 then
		quest_status.previous_flow_state = quest_status.flow_state;
			quest_status.flow_state = quest_status.flow_states.FAST_TRAVEL_ANIMATION;

	-- WYVERN_RIDING_START_ANIMATION
	elseif request_data_type == 11 then
		quest_status.previous_flow_state = quest_status.flow_state;
		quest_status.flow_state = quest_status.flow_states.WYVERN_RIDING_START_ANIMATION;
	end
end

function quest_status.on_demo_end()
	if quest_status.index == 2 then
		if  quest_status.flow_state == quest_status.flow_states.PLAYER_DEATH_ANIMATION
		or quest_status.flow_state == quest_status.flow_states.PLAYER_CART_ANIMATION
		or quest_status.flow_state == quest_status.flow_states.FAST_TRAVEL_ANIMATION
		or quest_status.flow_state == quest_status.flow_states.WYVERN_RIDING_START_ANIMATION then
				
			local next_flow_state = quest_status.previous_flow_state;
			quest_status.previous_flow_state = quest_status.flow_state;
			quest_status.flow_state = next_flow_state;

		elseif quest_status.flow_state == quest_status.flow_states.QUEST_START_ANIMATION then
			
			quest_status.previous_flow_state = quest_status.flow_state;
			quest_status.flow_state = quest_status.flow_states.PLAYING_QUEST;	

		elseif quest_status.flow_state == quest_status.flow_states.KILLCAM then
			
			quest_status.previous_flow_state = quest_status.flow_state;
			quest_status.flow_state = quest_status.flow_states.QUEST_END_TIMER;
		end
	end
end

function quest_status.on_set_quest_clear()
	if quest_status.index == 2 and quest_status.flow_state ~= quest_status.flow_states.KILLCAM then
		quest_status.previous_flow_state = quest_status.flow_state;
		quest_status.flow_state = quest_status.flow_states.QUEST_END_TIMER;
	end
end

function quest_status.on_quest_end_set_state()
	if quest_status.index == 2 then	
		quest_status.previous_flow_state = quest_status.flow_state;
		quest_status.flow_state = quest_status.flow_states.QUEST_END_SCREEN;
	end
end

function quest_status.on_gui_result_reward_do_open()
	if quest_status.index == 3 then
		quest_status.previous_flow_state = quest_status.flow_state;
		quest_status.flow_state = quest_status.flow_states.REWARD_SCREEN;
	end
end

function quest_status.on_gui_result_pay_off_do_open()
	if quest_status.index == 3 then
		quest_status.previous_flow_state = quest_status.flow_state;
		quest_status.flow_state = quest_status.flow_states.SUMMARY_SCREEN;
	end
end

function quest_status.on_play_event_common()
	quest_status.previous_flow_state = quest_status.flow_state;
	quest_status.flow_state = quest_status.flow_states.CUTSCENE;
end

function quest_status.on_event_manager_dispose()
	if quest_status.flow_state == quest_status.flow_states.CUTSCENE then
		
		local next_flow_state = quest_status.previous_flow_state;
		quest_status.previous_flow_state = quest_status.flow_state;
		quest_status.flow_state = next_flow_state;
	end
end

function quest_status.on_set_quest_fail()
	if quest_status.flow_state == quest_status.flow_states.PLAYER_DEATH_ANIMATION or
	quest_status.flow_state == quest_status.flow_states.PLAYER_CART_ANIMATION or
	quest_status.flow_state == quest_status.flow_states.FAST_TRAVEL_ANIMATION or
	quest_status.flow_state == quest_status.flow_states.WYVERN_RIDING_START_ANIMATION then
		
		quest_status.previous_flow_state = quest_status.flow_state;
		quest_status.flow_state = quest_status.flow_states.QUEST_END_ANIMATION;
	end
end

function quest_status.on_village_fast_travel(area)
	if area == nil then
		return;
	end

	quest_status.previous_flow_state = quest_status.flow_state;
	
	if area == 7 then
		quest_status.flow_state = quest_status.flow_states.IN_TRAINING_AREA;
	else 
		quest_status.flow_state = quest_status.flow_states.IN_LOBBY;
	end
end

function quest_status.on_changed_game_status(new_quest_status)
	quest_status.index = new_quest_status;

	if quest_status.index < 3 then
		player.init();
		small_monster.init_list();
		large_monster.init_list();
		env_creature.init_list();

		quest_status.is_quest_clear = false;
		damage_meter_UI.freeze_displayed_players = false;
		damage_meter_UI.last_displayed_players = {};
	end

	if quest_status.index == 0 then
		quest_status.flow_state = quest_status.flow_states.NONE;
	elseif quest_status.index == 1 then
		quest_status.flow_state = quest_status.flow_states.IN_LOBBY;
	elseif quest_status.index == 2 then
		quest_status.flow_state = quest_status.flow_states.LOADING_QUEST;
	elseif quest_status.index == 3 then
		quest_status.flow_state = quest_status.flow_states.SUMMARY_SCREEN;
	end
end

function quest_status.init()
	if singletons.quest_manager == nil then
		return;
	end

	local new_quest_status = get_status_method:call(singletons.game_manager);
	if new_quest_status == nil then
		customization_menu.status = "No quest status";
		return;
	end

	quest_status.index = new_quest_status;
	
	if quest_status.index == 0 then
		quest_status.flow_state = quest_status.flow_states.NONE;
	elseif quest_status.index == 1 then
		quest_status.flow_state = quest_status.flow_states.IN_LOBBY;
	elseif quest_status.index == 2 then
		quest_status.flow_state = quest_status.flow_states.PLAYING_QUEST;
	elseif quest_status.index == 3 then
		quest_status.flow_state = quest_status.flow_states.SUMMARY_SCREEN;
	end

	quest_status.update_is_online();
	quest_status.update_is_training_area();
end

function quest_status.update_is_online()
	if singletons.lobby_manager == nil then
		return;
	end

	local is_quest_online = is_quest_online_method:call(singletons.lobby_manager);
	if is_quest_online == nil then
		return;
	end

	if quest_status.is_online and not is_quest_online then
		damage_meter_UI.freeze_displayed_players = true;
	end

	quest_status.is_online = is_quest_online;
end

function quest_status.update_is_quest_host()
	if singletons.lobby_manager == nil then
		return;
	end

	local is_quest_host = is_quest_host_method:call(singletons.lobby_manager, true);
	if is_quest_host == nil then
		return;
	end

	quest_status.is_quest_host = is_quest_host;
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

	if _is_training_area then
		quest_status.flow_state = quest_status.flow_states.IN_TRAINING_AREA;
	end
end

function quest_status.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	player = require("MHR_Overlay.Damage_Meter.player");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	damage_meter_UI = require("MHR_Overlay.UI.Modules.damage_meter_UI");
	time = require("MHR_Overlay.Game_Handler.time");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");

	quest_status.init();

	sdk.hook(on_changed_game_status_method, function(args)
		quest_status.on_changed_game_status(sdk.to_int64(args[3]));
	end, function(retval) return retval; end);

	sdk.hook(set_quest_clear_method, function(args)
		quest_status.on_set_quest_clear();
	end, function(retval) return retval; end);

	sdk.hook(set_quest_clear_sub_method, function(args)
		quest_status.on_set_quest_clear();
	end, function(retval) return retval; end);

	sdk.hook(set_quest_clear_sub_hyakurui_method, function(args)
		quest_status.on_set_quest_clear();
	end, function(retval) return retval; end);

	sdk.hook(demo_request_activation_method, function(args)
		quest_status.on_demo_request_activation(sdk.to_managed_object(args[3]));
	end, function(retval) return retval; end);
		
	sdk.hook(demo_end_method, function(args)
		quest_status.on_demo_end();
	end, function(retval) return retval; end);

	sdk.hook(set_quest_clear_method, function(args)
		quest_status.on_set_quest_clear();
	end, function(retval) return retval; end);
	
	sdk.hook(quest_end_set_state_method, function(args)
		quest_status.on_quest_end_set_state();
	end, function(retval) return retval; end);
	
	sdk.hook(gui_result_reward_do_open_method, function(args)
		quest_status.on_gui_result_reward_do_open();
	end, function(retval) return retval; end);

	sdk.hook(gui_result_pay_off_do_open_method, function(args)
		quest_status.on_gui_result_pay_off_do_open();
	end, function(retval) return retval; end);

	sdk.hook(play_event_common_method, function(args)
		quest_status.on_play_event_common();
	end, function(retval) return retval; end);
	
	sdk.hook(event_manager_dispose_method, function(args)
		quest_status.on_event_manager_dispose();
	end, function(retval) return retval; end);
	
	sdk.hook(set_quest_fail_method, function(args)
		quest_status.on_set_quest_fail();
	end, function(retval) return retval; end);
	
	sdk.hook(fast_travel_method, function(args)
		quest_status.on_village_fast_travel(sdk.to_int64(args[3]));
	end, function(retval) return retval; end);
end

return quest_status;
