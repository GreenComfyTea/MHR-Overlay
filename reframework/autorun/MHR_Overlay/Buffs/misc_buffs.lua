local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;
local language;
local error_handler;
local endemic_life_buffs;
local item_buffs;

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

this.list = {
	attack_up = nil,
	defense_up = nil,
	stamina_use_down = nil
};

local misc_buffs_type_name = "misc_buffs";

-- Attack Up
-- Might Seed +10		3min
-- Dango Bulker + 15	30sec
-- Chameleos Souls +15	30sec

-- Defense Up
-- Adamant Seed +20		3min
-- Chameleos Souls +20	30sec

-- Stamina Use Down
-- Dash Juice			3min
-- Peepersects			1.5min
-- Chameleos Soul		30sec

-- Natural Healing Up
-- Immunizer			5min
-- Vase of Vitality		20sec

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Attack Up
local atk_up_buff_second_field = player_data_type_def:get_field("_AtkUpBuffSecond");
local atk_up_buff_second_timer_field = player_data_type_def:get_field("_AtkUpBuffSecondTimer");
-- Defense Up
local def_up_buff_second_field = player_data_type_def:get_field("_DefUpBuffSecond");
local def_up_buff_second_timer_field = player_data_type_def:get_field("_DefUpBuffSecondTimer");
-- Stamina Use Down
local stamina_up_buff_second_timer_field = player_data_type_def:get_field("_StaminaUpBuffSecondTimer");
-- Immunity
local debuff_prevention_timer_field = player_data_type_def:get_field("_DebuffPreventionTimer");
-- Immunizer
local vitalizer_timer_field = player_data_type_def:get_field("_VitalizerTimer");

function this.update(player, player_data)
	buffs.update_generic_buff(this.list, misc_buffs_type_name, "stamina_use_down", this.get_misc_buff_name,
		nil, nil, player_data, stamina_up_buff_second_timer_field);

	buffs.update_generic_buff(this.list, misc_buffs_type_name, "attack_up", this.get_misc_buff_name,
		player_data, atk_up_buff_second_field, player_data, atk_up_buff_second_timer_field);

	buffs.update_generic_buff(this.list, misc_buffs_type_name, "defense_up", this.get_misc_buff_name,
		player_data, def_up_buff_second_field, player_data, def_up_buff_second_timer_field);

	buffs.update_generic_buff(this.list, misc_buffs_type_name, "immunity", this.get_misc_buff_name,
		nil, nil, player_data, debuff_prevention_timer_field);

	buffs.update_generic_buff(this.list, misc_buffs_type_name, "natural_healing_up", this.get_misc_buff_name,
		nil, nil, player_data, vitalizer_timer_field);
end

function this.init_names()
	for misc_buff_key, dango in pairs(this.list) do
		dango.name =  this.get_misc_buff_name(misc_buff_key);
	end
end

function this.get_misc_buff_name(misc_buff_key)
	local misc_buff_name = language.current_language.misc_buffs[misc_buff_key];
	if misc_buff_name == nil then
		return misc_buff_key;
	end

	return misc_buff_name;
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
	endemic_life_buffs = require("MHR_Overlay.Buffs.endemic_life_buffs");
	item_buffs = require("MHR_Overlay.Buffs.item_buffs");
end

function this.init_module()
end

return this;