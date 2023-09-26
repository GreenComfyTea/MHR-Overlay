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

this.timer_list = {};
this.delay_timer_list = {};

function this.new_timer(callback, cooldown_seconds, start_offset_seconds)
	start_offset_seconds = start_offset_seconds or utils.math.random();

	if callback == nil or cooldown_seconds == nil then
		return;
	end

	local timer = {};
	timer.callback = callback;
	timer.cooldown = cooldown_seconds;
	
	timer.last_trigger_time = os.clock() + start_offset_seconds;

	this.timer_list[callback] =  timer;
end

function this.new_delay_timer(callback, delay)
	if callback == nil or delay == nil then
		return;
	end

	local delay_timer = {};
	delay_timer.callback = callback;
	delay_timer.delay = delay;
	
	delay_timer.init_time = os.clock();

	this.delay_timer_list[callback] = delay_timer;

	return delay_timer;
end

function this.remove_delay_timer(delay_timer)
	if delay_timer == nil then
		return;
	end

	this.delay_timer_list[delay_timer.callback] = nil; 
end

function this.init_global_timers()
	local cached_config = config.current_config.global_settings.performance.timer_delays;

	this.timer_list = {};

	this.new_timer(singletons.update, cached_config.update_singletons_delay);
	this.new_timer(screen.update_window_size, cached_config.update_window_size_delay);
	this.new_timer(quest_status.update_is_online, cached_config.update_is_online_delay);
	this.new_timer(this.update_quest_time, cached_config.update_quest_time_delay);
	this.new_timer(players.update_players, cached_config.update_players_delay);
	this.new_timer(players.update_myself_position, cached_config.update_myself_position_delay);
	this.new_timer(buffs.update, cached_config.update_buffs_delay);
	this.new_timer(player_info.update, cached_config.update_player_info_delay);
end

function this.update_timers()
	this.update_script_time();

	for callback, timer in pairs(this.timer_list) do
		if this.total_elapsed_script_seconds - timer.last_trigger_time > timer.cooldown then
			timer.last_trigger_time = this.total_elapsed_script_seconds;
			callback();
		end
	end

	local remove_list = {};

	for callback, delay_timer in pairs(this.delay_timer_list) do
		if this.total_elapsed_script_seconds - delay_timer.init_time > delay_timer.delay then
			callback();
			table.insert(remove_list, callback);
		end
	end

	for i, callback in ipairs(remove_list) do
		this.delay_timer_list[callback] = nil;
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
