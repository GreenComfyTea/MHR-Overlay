local this = {};

local singletons;
local customization_menu;
local players;
local small_monster;
local large_monster;
local damage_meter_UI;
local time;
local env_creature;
local non_players;
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

this.flow_states = {
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

this.previous_flow_state = this.flow_states.NONE;
this.flow_state = this.flow_states.NONE;

this.index = 0;
this.is_online = false;
--quest_status.is_quest_host = false;

this.cart_count = 0;
this.max_cart_count = 3;

local quest_manager_type_def = sdk.find_type_definition("snow.QuestManager");
local on_changed_game_status_method = quest_manager_type_def:get_method("onChangedGameStatus");
local is_result_demo_play_start_method = quest_manager_type_def:get_method("isResultDemoPlayStart");
local set_quest_clear_method = quest_manager_type_def:get_method("setQuestClear");
local set_quest_clear_sub_method = quest_manager_type_def:get_method("setQuestClearSub");
local set_quest_clear_sub_hyakurui_method = quest_manager_type_def:get_method("setQuestClearSubHyakuryu");
local set_quest_fail_method = quest_manager_type_def:get_method("setQuestFail");

local get_death_num_method = quest_manager_type_def:get_method("getDeathNum");
local get_quest_life_method = quest_manager_type_def:get_method("getQuestLife");

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

function this.get_flow_state_name(flow_state, new_line)
    for key, value in pairs(this.flow_states) do
		if value == flow_state then
			if new_line then
				return "\n" .. tostring(key);
			else
				return tostring(key);
			end
		end
	end
end

function this.set_flow_state(new_flow_state)
	this.previous_flow_state = this.flow_state;
	this.flow_state = new_flow_state;

	if this.flow_state >= this.flow_states.KILLCAM then
		damage_meter_UI.freeze_displayed_players = true;
	else 
		damage_meter_UI.freeze_displayed_players = false;
	end

	if this.flow_state == this.flow_states.IN_LOBBY or this.flow_state == this.flow_states.IN_TRAINING_AREA then
		players.init();
		non_players.init();
		small_monster.init_list();
		large_monster.init_list();
		env_creature.init_list();
		damage_meter_UI.last_displayed_players = {};
	elseif this.flow_state >= this.flow_states.LOADING_QUEST then
		this.get_cart_count();
		this.get_max_cart_count();
	end
end

function this.get_cart_count()
	local death_num = get_death_num_method:call(singletons.quest_manager);
	if death_num == nil then
		error_handler.report("quest_status.get_cart_count", "Failed to Access Data: death_num");
	end
	
	this.cart_count = death_num;
end

function this.get_max_cart_count()
	local quest_life = get_quest_life_method:call(singletons.quest_manager);
	if quest_life == nil then
		error_handler.report("quest_status.get_max_cart_count", "Failed to Access Data: quest_life");
	end
	
	this.max_cart_count = quest_life;
end

--type 2 = quest start
--type 3 = monster killcam
--type 5 = end screen
function this.on_demo_request_activation(request_data_base)
	if request_data_base == nil then
		error_handler.report("quest_status.on_demo_request_activation", "Missing Parameter: request_data_base");
		return;
	end

	if this.index ~= 2 then
		return;
	end

	local request_data_type = request_data_base:call("get_Type");
	if request_data_type == nil then
		error_handler.report("quest_status.on_demo_request_activation", "Failed to Access Data: request_data_type");
		return;
	end

	-- QUEST_START_ANIMATION
	if request_data_type == 2 then
		this.set_flow_state(this.flow_states.QUEST_START_ANIMATION);

	-- KILLCAM
	elseif request_data_type == 3 then
		this.set_flow_state(this.flow_states.KILLCAM);

	-- QUEST_END_ANIMATION
	elseif request_data_type == 5 or request_data_type == 6 or request_data_type == 7 then
		this.set_flow_state(this.flow_states.QUEST_END_ANIMATION);

	-- PLAYER_DEATH_ANIMATION
	elseif request_data_type == 8 then
		this.set_flow_state(this.flow_states.PLAYER_DEATH_ANIMATION);

	-- PLAYER_CART_ANIMATION
	elseif request_data_type == 9 then
		this.set_flow_state(this.flow_states.PLAYER_CART_ANIMATION);

	-- FAST_TRAVEL_ANIMATION
	elseif request_data_type == 10 then
		this.set_flow_state(this.flow_states.FAST_TRAVEL_ANIMATION);

	-- WYVERN_RIDING_START_ANIMATION
	elseif request_data_type == 11 then
		this.set_flow_state(this.flow_states.WYVERN_RIDING_START_ANIMATION);
	end
end

function this.on_demo_end()
	if this.index == 2 then
		if  this.flow_state == this.flow_states.PLAYER_DEATH_ANIMATION
		or this.flow_state == this.flow_states.PLAYER_CART_ANIMATION
		or this.flow_state == this.flow_states.FAST_TRAVEL_ANIMATION
		or this.flow_state == this.flow_states.WYVERN_RIDING_START_ANIMATION then
				
			this.set_flow_state(this.previous_flow_state);

		elseif this.flow_state == this.flow_states.QUEST_START_ANIMATION then
			
			this.set_flow_state(this.flow_states.PLAYING_QUEST);

		elseif this.flow_state == this.flow_states.KILLCAM then
			
			this.set_flow_state(this.flow_states.QUEST_END_TIMER);
		end
	end
end

function this.on_set_quest_clear()
	if this.index == 2 and this.flow_state ~= this.flow_states.KILLCAM then
		this.set_flow_state(this.flow_states.QUEST_END_TIMER);
	end
end

function this.on_quest_end_set_state()
	if this.index == 2 then	
		this.set_flow_state(this.flow_states.QUEST_END_SCREEN);
	end
end

function this.on_gui_result_reward_do_open()
	if this.index == 3 then
		this.set_flow_state(this.flow_states.REWARD_SCREEN);
	end
end

function this.on_gui_result_pay_off_do_open()
	if this.index == 3 then
		this.set_flow_state(this.flow_states.SUMMARY_SCREEN);
	end
end

function this.on_play_event_common()
	this.set_flow_state(this.flow_states.CUTSCENE);
end

function this.on_event_manager_dispose()
	if this.flow_state == this.flow_states.CUTSCENE then
		this.set_flow_state(this.previous_flow_state);
	end
end

function this.on_set_quest_fail()
	if this.flow_state == this.flow_states.PLAYER_DEATH_ANIMATION or
	this.flow_state == this.flow_states.PLAYER_CART_ANIMATION or
	this.flow_state == this.flow_states.FAST_TRAVEL_ANIMATION or
	this.flow_state == this.flow_states.WYVERN_RIDING_START_ANIMATION then
		
		this.set_flow_state(this.flow_states.QUEST_END_ANIMATION);
	end
end

function this.on_village_fast_travel(area)
	if area == nil then
		error_handler.report("quest_status.on_village_fast_travel", "Missing Parameter: area");
		return;
	end

	if area == 7 then
		this.set_flow_state(this.flow_states.IN_TRAINING_AREA);
	else 
		this.set_flow_state(this.flow_states.IN_LOBBY);
	end
end

function this.on_changed_game_status(new_quest_status)
	if new_quest_status == nil then
		error_handler.report("quest_status.on_changed_game_status", "Missing Parameter: new_quest_status");
		return;
	end

	this.index = new_quest_status;

	if this.index == 0 then
		this.set_flow_state(this.flow_states.NONE);
	elseif this.index == 1 then
		this.set_flow_state(this.flow_states.IN_LOBBY);
	elseif this.index == 2 then
		this.set_flow_state(this.flow_states.LOADING_QUEST);
	elseif this.index == 3 then
		this.set_flow_state(this.flow_states.SUMMARY_SCREEN);
	end
end

function this.init()
	if singletons.quest_manager == nil then
		error_handler.report("quest_status.init", "Failed to Access Data: quest_manager");
		return;
	end

	local new_quest_status = get_status_method:call(singletons.game_manager);
	if new_quest_status == nil then
		error_handler.report("quest_status.init", "Failed to Access Data: new_quest_status");
		return;
	end

	this.index = new_quest_status;
	
	if this.index == 0 then
		this.set_flow_state(this.flow_states.NONE);
	elseif this.index == 1 then
		this.set_flow_state(this.flow_states.IN_LOBBY);
	elseif this.index == 2 then
		this.set_flow_state(this.flow_states.PLAYING_QUEST);
	elseif this.index == 3 then
		this.set_flow_state(this.flow_states.SUMMARY_SCREEN);
	end

	this.update_is_training_area();
end

function this.update_is_online()
	if singletons.lobby_manager == nil then
		error_handler.report("quest_status.update_is_online", "Failed to Access Data: lobby_manager");
		return;
	end

	local is_quest_online = is_quest_online_method:call(singletons.lobby_manager);
	if is_quest_online == nil then
		error_handler.report("quest_status.update_is_online", "Failed to Access Data: is_quest_online");
		return;
	end

	this.is_online = is_quest_online;
end

--[[function quest_status.update_is_quest_host()
	if singletons.lobby_manager == nil then
		error_handler.report("quest_status.update_is_quest_host", "Failed to Access Data: lobby_manager");
		return;
	end

	local is_quest_host = is_quest_host_method:call(singletons.lobby_manager, true);
	if is_quest_host == nil then
		error_handler.report("quest_status.update_is_quest_host", "Failed to Access Data: is_quest_host");
		return;
	end

	quest_status.is_quest_host = is_quest_host;
end--]]

function this.update_is_training_area()
	if singletons.village_area_manager == nil then
		error_handler.report("quest_status.update_is_training_area", "Failed to Access Data: village_area_manager");
		return;
	end

	local is_training_area = check_current_area_training_area_method:call(singletons.village_area_manager);
	if is_training_area == nil then
		error_handler.report("quest_status.update_is_training_area", "Failed to Access Data: is_training_area");
		return;
	end

	if is_training_area then
		this.set_flow_state(this.flow_states.IN_TRAINING_AREA);
	end
end

function this.init_dependencies()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	players = require("MHR_Overlay.Damage_Meter.players");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	damage_meter_UI = require("MHR_Overlay.UI.Modules.damage_meter_UI");
	time = require("MHR_Overlay.Game_Handler.time");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
	this.init();

	time.new_timer(this.update_is_online, 1);

	sdk.hook(on_changed_game_status_method, function(args)
		this.on_changed_game_status(sdk.to_int64(args[3]));
	end, function(retval) return retval; end);

	sdk.hook(set_quest_clear_method, function(args)
		this.on_set_quest_clear();
	end, function(retval) return retval; end);

	sdk.hook(set_quest_clear_sub_method, function(args)
		this.on_set_quest_clear();
	end, function(retval) return retval; end);

	sdk.hook(set_quest_clear_sub_hyakurui_method, function(args)
		this.on_set_quest_clear();
	end, function(retval) return retval; end);

	sdk.hook(demo_request_activation_method, function(args)
		this.on_demo_request_activation(sdk.to_managed_object(args[3]));
	end, function(retval) return retval; end);
		
	sdk.hook(demo_end_method, function(args)
		this.on_demo_end();
	end, function(retval) return retval; end);

	sdk.hook(set_quest_clear_method, function(args)
		this.on_set_quest_clear();
	end, function(retval) return retval; end);
	
	sdk.hook(quest_end_set_state_method, function(args)
		this.on_quest_end_set_state();
	end, function(retval) return retval; end);
	
	sdk.hook(gui_result_reward_do_open_method, function(args)
		this.on_gui_result_reward_do_open();
	end, function(retval) return retval; end);

	sdk.hook(gui_result_pay_off_do_open_method, function(args)
		this.on_gui_result_pay_off_do_open();
	end, function(retval) return retval; end);

	sdk.hook(play_event_common_method, function(args)
		this.on_play_event_common();
	end, function(retval) return retval; end);
	
	sdk.hook(event_manager_dispose_method, function(args)
		this.on_event_manager_dispose();
	end, function(retval) return retval; end);
	
	sdk.hook(set_quest_fail_method, function(args)
		this.on_set_quest_fail();
	end, function(retval) return retval; end);
	
	sdk.hook(fast_travel_method, function(args)
		this.on_village_fast_travel(sdk.to_int64(args[3]));
	end, function(retval) return retval; end);
end

return this;
