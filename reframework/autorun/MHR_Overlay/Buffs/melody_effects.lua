local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;
local language;
local error_handler;
local time;

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

--[[local melody_effect_ids = {
	self_improvement = 0,
	attack_up = 1,
	defense_up = 2,
	affinity_up = 3,
	elemental_attack_boost = 4,
	attack_and_defense_up = 5,
	attack_and_affinity_up = 6,
	knockbacks_negated = 7,
	earplugs_s = 8,
	earplugs_l = 9,
	tremors_negated = 10,
	wind_pressure_negated = 11,
	stun_negated = 12,
	blight_negated = 13,
	divine_protection = 14,
	health_recovery_s = 15,
	health_recovery_l = 16,
	health_recovery_s_antidote = 17,
	health_regeneration = 18,
	stamina_use_reduced = 19,
	stamina_recovery_up = 20,
	sharpness_loss_reduced = 21,
	environment_damage_negated = 22,
	sonic_wave = 23,
	sonic_barrier = 24,
	infernal_melody = 25,
	sharpness_regeneration = 26,
	sharpness_extension = 27
};]]

this.keys = {
	"self_improvement",
	"attack_up",
	"defense_up",
	"affinity_up",
	"elemental_attack_boost",
	"attack_and_defense_up",
	"attack_and_affinity_up",
	"knockbacks_negated",
	"earplugs_s",
	"earplugs_l",
	"tremors_negated",
	"wind_pressure_negated",
	"stun_negated",
	"blight_negated",
	"divine_protection",
	"health_recovery_s",
	"health_recovery_l",
	"health_recovery_s_antidote",
	"health_regeneration",
	"stamina_use_reduced",
	"stamina_recovery_up",
	"sharpness_loss_reduced",
	"environment_damage_negated",
	"sonic_wave",
	"sonic_barrier",
	"infernal_melody",
	"sharpness_regeneration",
	"sharpness_extension"
};

this.list = {};

local melody_effects_type_name = "melody_effects";

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local find_master_player_method = player_manager_type_def:get_method("findMasterPlayer");

local player_base_type_def = find_master_player_method:get_return_type();
local music_data_field = player_base_type_def:get_field("_MusicData");

local music_data_type_def = sdk.find_type_definition("snow.player.Horn.MusicData");
local time_field = music_data_type_def:get_field("_Time");

local system_array_type_def = sdk.find_type_definition("System.Array");
local get_length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

local data_shortcut_type_def = sdk.find_type_definition("snow.data.DataShortcut");
local get_name_method = data_shortcut_type_def:get_method("getName(snow.data.DataDef.HornConcertId)");

function this.update(master_player)
	local music_data_array = music_data_field:get_data(master_player);
	if music_data_array == nil then
		error_handler.report("melody_effects.update", "Failed to access Data: music_data_array");
		return;
	end

	local length = get_length_method:call(music_data_array);
	if length == nil then
		error_handler.report("melody_effects.update", "Failed to access Data: music_data_array -> length");
		return;
	end

	length = length - 1;

	for id = 0, length do

		local lua_index = id + 1;

		local melody_effect = this.list[lua_index];
		local key = this.keys[lua_index];

		if this.apply_filter(key, lua_index) then
			goto continue;
		end

		local music_data = get_value_method:call(music_data_array, id);
		if music_data == nil then
			error_handler.report("melody_effects.update", "Failed to access Data: music_data No." .. tostring(id));
			goto continue;
		end

		this.update_melody_effect(lua_index, id, key, melody_effect, music_data);
		::continue::
	end
end

function this.update_melody_effect(lua_index, id, key, melody_effect, melody_data)
	local melody_timer = time_field:get_data(melody_data);
	if melody_timer == nil then
		error_handler.report("melody_effects.update_melody_effect", "Failed to access Data: melody_timer No. " .. tostring(id));
		return;
	end

	if utils.number.is_equal(melody_timer, 0) then
		this.list[lua_index] = nil;
		return;
	end

	if melody_effect == nil then
		local melody_effect_name = this.get_melody_effect_name(id);

		melody_effect = buffs.new(melody_effects_type_name, key, melody_effect_name, 1, melody_timer / 60);
		this.list[lua_index] = melody_effect;
	else
		buffs.update_timer(melody_effect, melody_timer / 60);
	end
end

function this.apply_filter(key, lua_index)
	if config.current_config.buff_UI.filter.melody_effects[key] then
		return false;
	end
	
	local buff = this.list[lua_index];
	if buff == nil then
		return true;
	end

	if not buff.is_visible then
		return true;
	end

	if buff.is_infinite then
		this.list[lua_index] = nil;
		return true;
	end

	time.new_delay_timer(function()
		
		local _buff = this.list[lua_index];
		if _buff ~= nil and not _buff.is_visible then
			this.list[lua_index] = nil;
		end

	end, buff.timer);

	buff.is_visible = false;
	return true;
end

function this.get_melody_effect_name(id)
	local melody_effect_name = get_name_method:call(nil, id);
	if melody_effect_name == nil then
		local name = string.format("Melody Effect No. %d", id);
		error_handler.report("melody_effects.get_melody_effect_name", "Failed to access Data: " .. melody_effect_name);
		return name;
	end

	return melody_effect_name;
end

function this.init_dependencies()
	buffs = require("MHR_Overlay.Buffs.buffs");
	config = require("MHR_Overlay.Misc.config");
	utils = require("MHR_Overlay.Misc.utils");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	players = require("MHR_Overlay.Damage_Meter.players");
	language = require("MHR_Overlay.Misc.language");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	time = require("MHR_Overlay.Game_Handler.time");
end

function this.init_module()
end

return this;