local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;
local language;
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

this.list = {
	dango_defender = nil,
	dango_adrenaline = nil,
	dango_booster = nil,
	dango_glutton = nil,

	dango_bulker = nil,
};

local dango_ids = {
	dango_polisher = 1,
	dango_rider = 2,
	dango_adrenaline = 3,
	dango_carver_lo = 4,
	dango_carver_hi = 5,
	dango_medic_lo = 6,
	dango_medic_hi = 7,
	dango_fighter = 8,
	dango_pyro = 9,
	dango_specialist = 10,
	dango_defender_lo = 11,
	dango_defender_hi = 12,
	dango_harvester = 13,
	dango_marksman = 14,
	dango_fortune_caller = 15,
	dango_miracle_worker = 16,
	dango_deflector = 17,
	dango_weakener = 18,
	dango_calculator = 19,
	dango_temper = 20,
	dango_wall_runner = 21,
	dango_slugger = 22,
	dango_money_maker = 23,
	dango_bombardier = 24,
	dango_moxie = 25,
	dango_immunizer = 26,
	dango_trainer = 27,
	dango_booster = 28,
	dango_feet = 29,
	dango_bulker = 30,
	dango_insurance = 31,
	dango_reviver = 32,
	dango_summoner = 33,
	dango_hurler = 34,
	dango_fire_res_lo = 35,
	dango_fire_res_hi = 36,
	dango_water_res_lo = 37,
	dango_water_res_hi = 38,
	dango_thunder_res_lo = 39,
	dango_thunder_res_hi = 40,
	dango_ice_res_lo = 41,
	dango_ice_res_hi = 42,
	dango_dragon_res_lo = 43,
	dango_dragon_res_hi = 44,
	dango_gatherer = 45,
	dango_glutton = 46,
	dango_bird_caller = 47,
	dango_flyer = 48,
	dango_defender = 49,
	enhanced_dango_fighter = 50,
	dango_driver = 51,
	dango_hunter = 52,
	dango_guard = 53,
	dango_shifter = 54,
	dango_connector = 55,
	super_recovery_dango = 56
};

this.is_dango_adrenaline_active = false;

local dangos_type_name = "dangos";
local dango_defender_minimal_value = 200;
local dango_bulker_attack_up = 15;

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_data_method = player_manager_type_def:get_method("get_PlayerData");
local get_ref_item_parameter_method = player_manager_type_def:get_method("get_RefItemParameter");

local player_user_data_item_parameter_type_def = get_ref_item_parameter_method:get_return_type();



local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Dango Defender
local kitchen_skill_048_field = player_data_type_def:get_field("_KitchenSkill048_Damage");
-- Dango Booster
local kitchen_skill_027_timer_field = player_data_type_def:get_field("_KitchenSkill027Timer");
-- Dango Glutton
local kitchen_skill_045_timer_field = player_data_type_def:get_field("_KitchenSkill045Timer");
-- Dango Bulker
local atk_up_buff_second_field = player_data_type_def:get_field("_AtkUpBuffSecond");
local atk_up_buff_second_timer_field = player_data_type_def:get_field("_AtkUpBuffSecondTimer");


local player_base_type_def = sdk.find_type_definition("snow.player.PlayerBase");
-- Dango Adrenaline
local is_kitchen_skill_predicament_powerup_method = player_base_type_def:get_method("isKitchenSkillPredicamentPowerUp");

local data_shortcut_type_def = sdk.find_type_definition("snow.data.DataShortcut");
local get_name_method = data_shortcut_type_def:get_method("getName(snow.data.DataDef.PlKitchenSkillId)");

function this.update(player, player_data)
	local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	if item_parameter == nil then
		error_handler.report("dangos.update", "Failed to access Data: item_parameter");
		return;
	end

	this.update_dango_adrenaline();
	this.update_dango_bulker(player_data);
	
	buffs.update_generic_buff(this.list, dangos_type_name, "dango_defender", this.get_dango_name,
		player_data, kitchen_skill_048_field, nil, nil, nil, nil, true, dango_defender_minimal_value);

	buffs.update_generic_buff(this.list, dangos_type_name, "dango_booster", this.get_dango_name,
		nil, nil, player_data, kitchen_skill_027_timer_field);

	buffs.update_generic_buff(this.list, dangos_type_name, "dango_glutton", this.get_dango_name,
		nil, nil, player_data, kitchen_skill_045_timer_field);
end

function this.update_dango_adrenaline()
	if not this.is_dango_adrenaline_active then
		this.list.dango_adrenaline = nil;
		return;
	end

	buffs.update_generic(this.list, dangos_type_name, "dango_adrenaline", this.get_dango_name);
end

function this.update_dango_bulker(player_data)
	local atk_up_buff_second = atk_up_buff_second_field:get_data(player_data);
	if atk_up_buff_second == nil then
		error_handler.report("consumables.update_dango_bulker", "Failed to access Data: atk_up_buff_second");
		return;
	end

	if atk_up_buff_second ~= dango_bulker_attack_up then
		this.list.dango_bulker = nil;
		return;
	end

	buffs.update_generic_buff(this.list, dangos_type_name, "dango_bulker", this.get_dango_name, nil, nil, player_data, atk_up_buff_second_timer_field);
end

function this.get_dango_name(dango_key)
	local dango_name = get_name_method:call(nil, dango_ids[dango_key]);
	if dango_name == nil then
		error_handler.report("dangos.get_dango_name", string.format("Failed to access Data: %s_name", dango_key));
		return dango_key;
	end

	return dango_name;
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
end


function this.init_module()
end

return this;