local this = {};

local buff_UI_entity;
local config;
local singletons;
local players;
local consumables;
local melody_effects;
local utils;
local language;
local time;
local quest_status;
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

this.types = {
	consumable = 0,
	melody_effect = 1,
	dango = 2,
};

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_method = player_manager_type_def:get_method("getPlayer");
local find_master_player_method = player_manager_type_def:get_method("findMasterPlayer");

local player_base_type_def = find_master_player_method:get_return_type();
local get_player_data_method = player_base_type_def:get_method("get_PlayerData");
local music_data_field = player_base_type_def:get_field("_MusicData");

local system_array_type_def = sdk.find_type_definition("System.Array");
local length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

function this.new(type, key, name, value, duration)
	local is_infinite = false;

	value = value or 0;

	if duration == nil then
		duration = 0;
		is_infinite = true;
	end

	local buff = {};

	buff.type = type;
	buff.key = key;
	buff.name = name;
	buff.value = value;

	buff.timer = duration;
	buff.duration = duration;

	buff.is_active = true;

	buff.timer_percentage = 0;

	buff.minutes_left = 0;
	buff.seconds_left = 0;

	buff.is_infinite = is_infinite;

	this.update_timer(buff, buff.timer);

	this.init_UI(buff);

	return buff;
end

function this.init_buffs()
	this.list = {};
end

function this.init_UI(buff)
	local cached_config = config.current_config.buff_UI;
	buff.buff_UI = buff_UI_entity.new(cached_config.bar, cached_config.name_label, cached_config.timer_label);
end

function this.init_names()
	consumables.init_names();
	melody_effects.init_names();
end

function this.update()
	if singletons.player_manager == nil then
		error_handler.report("buffs.update", "Failed to Access Data: player_manager");
		return;
	end

	if quest_status.flow_state == quest_status.flow_states.IN_LOBBY
	or quest_status.flow_state >= quest_status.flow_states.QUEST_END_ANIMATION then
		return;
	end

	local master_player = find_master_player_method:call(singletons.player_manager); 
	if master_player == nil then
		error_handler.report("buffs.update", "Failed to Access Data: master_player");
		return;
	end

	local master_player_data = get_player_data_method:call(master_player);
	if master_player_data ~= nil then
		consumables.update(master_player_data);
	else
		error_handler.report("buffs.update", "Failed to Access Data: master_player_data");
	end

	local music_data_array = music_data_field:get_data(master_player);
	if music_data_array ~= nil then
		local music_data_table = {};

		local length = length_method:call(music_data_array) - 1;
		for i = 0, length do
			local music_data = get_value_method:call(music_data_array, i);
			if music_data == nil then
				error_handler.report("buffs.update", "Failed to Access Data: music_data No." .. tostring(i));
				music_data = "";
			end

			table.insert(music_data_table, music_data);
		end

		melody_effects.update(music_data_table);
	else
		error_handler.report("buffs.update", "Failed to Access Data: music_data_array");
	end
end

function this.draw(buff, buff_UI, position_on_screen, opacity_scale)
	buff_UI_entity.draw(buff, buff_UI, position_on_screen, opacity_scale);
end

function this.update_timer(buff, timer)
	if timer < 0 then
		timer = 0;
	end

	local minutes_left = math.floor(timer / 60);

	buff.timer = timer;
	buff.minutes_left = minutes_left;
	buff.seconds_left = math.floor(timer - 60 * minutes_left);

	if buff.duration ~= 0 then
		buff.timer_percentage = timer / buff.duration;
	end
end

function this.init_dependencies()
	config = require("MHR_Overlay.Misc.config");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	players = require("MHR_Overlay.Damage_Meter.players");
	consumables = require("MHR_Overlay.Buffs.consumables");
	melody_effects = require("MHR_Overlay.Buffs.melody_effects");
	utils = require("MHR_Overlay.Misc.utils");
	language = require("MHR_Overlay.Misc.language");
	time = require("MHR_Overlay.Game_Handler.time");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
	time.new_timer(this.update, 0.5);
end

return this;