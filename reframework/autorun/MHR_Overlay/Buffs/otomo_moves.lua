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
	go_fight_win = nil,
	power_drum = nil,
	rousing_roar = nil
};

this.keys = {
	"go_fight_win",
	"power_drum",
	"rousing_roar"
};

local otomo_moves_ids = {
	-- herbaceous_healing = 1,
	-- felyne_silkbind = 2,
	-- felyne_wyvernblast = 3,
	rousing_roar = 4,
	-- endemic_life_barrage = 5,
	-- health_horn = 6,
	-- healing_bubble = 7,
	vase_of_vitality = 8,
	-- furbidden_acorn = 9,
	-- poison_purr_ison = 10,
	-- summeown_endemic_life = 11,
	-- shock_purr_ison = 12,
	go_fight_win = 13,
	-- giga_barrel_bombay = 14,
	-- flash_bombay = 15,
	-- anti_monster_mine = 16,
	-- zap_blast_spinner = 17,
	-- furr_ious = 18,
	power_drum = 19,
	-- fleet_foot_feat = 20,
	-- whirlwind_assault = 21,
	-- pilfer = 22,
	-- shock_tripper = 23,
	-- mega_boomerang = 24,
	-- camouflage = 25,
	-- healing_clover_bat = 26,
	-- felyne_firewors = 27,
	-- lottery_box = 28,
	-- felyne_powered_up = 29,
	-- ameowzing_mist = 30
};

local otomo_moves_type_name = "otomo_moves"

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Palico: Rousing Roar
local beast_roar_otomo_timer_field = player_data_type_def:get_field("_BeastRoarOtomoTimer");
-- Palico: Power Drum
local kijin_otomo_timer_field = player_data_type_def:get_field("_KijinOtomoTimer");
-- Palico: Go, Fight, Win
local runhigh_otomo_timer_field = player_data_type_def:get_field("_RunhighOtomoTimer");

local data_shortcut_type_def = sdk.find_type_definition("snow.data.DataShortcut");
local get_name_method = data_shortcut_type_def:get_method("getName(snow.data.DataDef.OtSupportActionId)");

function this.update(player_data)
	this.update_otomo_move("rousing_roar", nil, nil, player_data, beast_roar_otomo_timer_field);
	this.update_otomo_move("go_fight_win", nil, nil, player_data, runhigh_otomo_timer_field);
	this.update_otomo_move("power_drum", nil, nil, player_data, kijin_otomo_timer_field);
end

function this.update_otomo_move(key, value_owner, value_holder, timer_owner, timer_holder, is_infinite, minimal_value, level_breakpoints)
	return buffs.update_generic_buff(this.list, config.current_config.buff_UI.filter.otomo_moves, this.get_otomo_move_name,
		otomo_moves_type_name, key,
		value_owner, value_holder, timer_owner, timer_holder, is_infinite, minimal_value, level_breakpoints)
end

function this.apply_filter(key)
	return buffs.apply_filter(this.list, config.current_config.buff_UI.filter.otomo_moves, key);
end

function this.init_all_UI()
	for otomo_move_key, otomo_move in pairs(this.list) do
		buffs.init_UI(otomo_move);
	end
end

function this.init_names()
	for otomo_move_key, otomo_move in pairs(this.list) do
		otomo_move.name =  this.get_otomo_move_name(otomo_move_key);
	end
end

function this.get_otomo_move_name(key)
	local otomo_move_name = get_name_method:call(nil, otomo_moves_ids[key]);
	if otomo_move_name == nil then
		error_handler.report("otomo_moves.get_otomo_move_name", string.format("Failed to access Data: %s_name", key));
		return key;
	end

	return otomo_move_name;
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