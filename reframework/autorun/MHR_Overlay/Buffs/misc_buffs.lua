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
local consumables;

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
	stamina_use_down = nil,
};

local misc_buffs_type_name = "misc_buffs";

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Dash Juice/Peepersects
local stamina_up_buff_second_timer_field = player_data_type_def:get_field("_StaminaUpBuffSecondTimer");

function this.update(player, player_data)
	this.update_stamina_use_down(player_data);
end

function this.update_stamina_use_down(player_data)
	if consumables.list.dash_juice ~= nil or endemic_life_buffs.list.peepersects ~= nil then
		this.list.stamina_use_down = nil;
		return;
	end

	local stamina_up_buff_second_timer = stamina_up_buff_second_timer_field:get_data(player_data);
	if stamina_up_buff_second_timer == nil then
		error_handler.report("consumables.update_stamina_use_down", "Failed to access Data: stamina_up_buff_second_timer");
		return;
	end

	if utils.number.is_equal(stamina_up_buff_second_timer, 0) then
		this.list.stamina_use_down = nil;
		return;
	end

	buffs.update_generic(this.list, misc_buffs_type_name, "stamina_use_down", this.get_misc_buff_name, 1,
		stamina_up_buff_second_timer / 60, endemic_life_buffs.peepersects_duration);
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
	consumables = require("MHR_Overlay.Buffs.consumables");
end

function this.init_module()
end

return this;