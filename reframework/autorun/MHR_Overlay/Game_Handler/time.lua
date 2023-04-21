local time = {};

local singletons;
local customization_menu;
local quest_status;
local players;
local non_players;
local config;
local small_monster;

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

local quest_manager_type_def = sdk.find_type_definition("snow.QuestManager");
local get_quest_elapsed_time_min_method = quest_manager_type_def:get_method("getQuestElapsedTimeMin");
local get_quest_elapsed_time_sec_method = quest_manager_type_def:get_method("getQuestElapsedTimeSec");

time.total_elapsed_seconds = 0;
time.elapsed_minutes = 0;
time.elapsed_seconds = 0;

time.total_elapsed_script_seconds = 0;
time.last_elapsed_script_seconds = 0;

function time.update_script_time()
	time.total_elapsed_script_seconds = os.clock();
end

function time.tick()
	time.update_script_time();

	if singletons.quest_manager == nil then
		return;
	end

	local quest_time_elapsed_minutes = get_quest_elapsed_time_min_method:call(singletons.quest_manager);
	if quest_time_elapsed_minutes == nil then
		customization_menu.status = "No quest time elapsed minutes";
	else 
		time.elapsed_minutes = quest_time_elapsed_minutes;
	end

	local quest_time_total_elapsed_seconds = get_quest_elapsed_time_sec_method:call(singletons.quest_manager);
	if quest_time_total_elapsed_seconds == nil then
		customization_menu.status = "No quest time total elapsed seconds";
	else
		time.total_elapsed_seconds = quest_time_total_elapsed_seconds;
	end

	time.elapsed_seconds = quest_time_total_elapsed_seconds - quest_time_elapsed_minutes * 60;

	if time.total_elapsed_script_seconds - time.last_elapsed_script_seconds > 0.5 then
		time.last_elapsed_script_seconds = time.total_elapsed_script_seconds;

		local is_on_quest = quest_status.flow_state ~= quest_status.flow_states.IN_LOBBY and quest_status.flow_state ~= quest_status.flow_states.IN_TRAINING_AREA;

		players.display_list = {};
		players.update_player_list(is_on_quest);
		non_players.update_servant_list();
		non_players.update_otomo_list(is_on_quest, quest_status.is_online);

		players.update_dps(false);
		players.sort_players();
	end
end

function time.init_module()
	players = require("MHR_Overlay.Damage_Meter.players");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	config = require("MHR_Overlay.Misc.config");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
end

return time;
