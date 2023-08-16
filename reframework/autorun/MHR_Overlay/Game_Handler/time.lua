local this = {};

local singletons;
local customization_menu;
local quest_status;
local players;
local non_players;
local config;
local small_monster;
local utils;
local error_handler;
local screen;
local buffs;
local player_info;

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

this.total_elapsed_seconds = 0;
this.elapsed_minutes = 0;
this.elapsed_seconds = 0;

this.total_elapsed_script_seconds = 0;

this.list = {};

function this.new_timer(callback, cooldown_seconds, start_offset_seconds)
	start_offset_seconds = start_offset_seconds or utils.math.random();

	if callback == nil or cooldown_seconds == nil then
		return;
	end

	local timer = {};
	timer.callback = callback;
	timer.cooldown = cooldown_seconds;
	
	timer.last_trigger_time = os.clock() + start_offset_seconds;

	this.list[callback] =  timer;

end

function this.init_global_timers()
	this.new_timer(singletons.init, 1);
	this.new_timer(screen.update_window_size, 1);
	this.new_timer(quest_status.update_is_online, 1);
	this.new_timer(this.update_quest_time, 1 / 60);
	this.new_timer(players.update_display_list, 0.5);
	this.new_timer(players.update_myself_position, 1);
	this.new_timer(buffs.update, 1/60);
	this.new_timer(player_info.update, 0.5);
	
end

function this.update_timers()
	this.update_script_time();

	for callback, timer in pairs(this.list) do
		if this.total_elapsed_script_seconds - timer.last_trigger_time > timer.cooldown then
			timer.last_trigger_time = this.total_elapsed_script_seconds;
			callback();
		end
	end
end

function this.update_script_time()
	this.total_elapsed_script_seconds = os.clock();
end

function this.update_quest_time()
	if singletons.quest_manager == nil then
		return;
	end

	if quest_status.flow_state == quest_status.flow_states.IN_LOBBY
	or quest_status.flow_state >= quest_status.flow_states.QUEST_END_TIMER then
		return;
	end

	local quest_time_elapsed_minutes = get_quest_elapsed_time_min_method:call(singletons.quest_manager);
	if quest_time_elapsed_minutes == nil then
		error_handler.report("time.update_quest_time", "Failed to access Data: quest_time_elapsed_minutes");
	else 
		this.elapsed_minutes = quest_time_elapsed_minutes;
	end

	local quest_time_total_elapsed_seconds = get_quest_elapsed_time_sec_method:call(singletons.quest_manager);
	if quest_time_total_elapsed_seconds == nil then
		error_handler.report("time.update_quest_time", "Failed to access Data: quest_time_total_elapsed_seconds");
	else
		this.total_elapsed_seconds = quest_time_total_elapsed_seconds;
	end

	this.elapsed_seconds = quest_time_total_elapsed_seconds - quest_time_elapsed_minutes * 60;
end

function this.init_dependencies()
	players = require("MHR_Overlay.Damage_Meter.players");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	config = require("MHR_Overlay.Misc.config");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
	utils = require("MHR_Overlay.Misc.utils");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	screen = require("MHR_Overlay.Game_Handler.screen");
	buffs = require("MHR_Overlay.Buffs.buffs");
	player_info = require("MHR_Overlay.Misc.player_info");
end

function this.init_module()
end

return this;
