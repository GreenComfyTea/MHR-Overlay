local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;
local language;
local error_handler;
local env_creature;
local player_info;
local time;
local abnormal_statuses;

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
	rousing_roar = nil,
	power_drum = nil,
	go_fight_win = nil
};

local otomo_moves_type_name = "otomo_moves";

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_data_method = player_manager_type_def:get_method("get_PlayerData");

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Palico: Rousing Roar
local beast_roar_otomo_timer_field = player_data_type_def:get_field("_BeastRoarOtomoTimer");
-- Palico: Power Drum
local kijin_otomo_timer_field = player_data_type_def:get_field("_KijinOtomoTimer");
-- Palico: Go, Fight, Win
local runhigh_otomo_timer_field = player_data_type_def:get_field("_RunhighOtomoTimer");

function this.update(player_data)
	buffs.update_generic_buff(this.list, otomo_moves_type_name, "rousing_roar", nil, nil, player_data, beast_roar_otomo_timer_field);
	buffs.update_generic_buff(this.list, otomo_moves_type_name, "power_drum", nil, nil, player_data, kijin_otomo_timer_field);
	buffs.update_generic_buff(this.list, otomo_moves_type_name, "go_fight_win", nil, nil, player_data, runhigh_otomo_timer_field);
end

function this.init_names()
	for otomo_move_key, otomo_move in pairs(this.list) do
		local name = language.current_language.otomo_moves[otomo_move_key];

		if name == nil then
			name = otomo_move_key;
		end

		otomo_move.name = name;
	end
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
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	player_info = require("MHR_Overlay.Misc.player_info");
	time = require("MHR_Overlay.Game_Handler.time");
	abnormal_statuses = require("MHR_Overlay.Buffs.abnormal_statuses");
end

function this.init_module()
end

return this;