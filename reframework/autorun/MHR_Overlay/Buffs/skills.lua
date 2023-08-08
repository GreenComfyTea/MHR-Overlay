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
	burst = nil,
	kushala_daora_soul = nil,
	intrepid_heart = nil,
	dereliction = nil,
};

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_data_method = player_manager_type_def:get_method("get_PlayerData");
local get_ref_item_parameter_method = player_manager_type_def:get_method("get_RefItemParameter");

local player_user_data_item_parameter_type_def = get_ref_item_parameter_method:get_return_type();
local demondrug_atk_up_field = player_user_data_item_parameter_type_def:get_field("_DemondrugAtkUp");

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Burst
local rengeki_power_up_count_field = player_data_type_def:get_field("_RengekiPowerUpCnt");
local rengeki_power_up_timer_field = player_data_type_def:get_field("_RengekiPowerUpTimer");
-- Kushala Daora Soul
local hyakuryu_dragon_power_up_count_field = player_data_type_def:get_field("_HyakuryuDragonPowerUpCnt");
local hyakuryu_dragon_power_up_timer_field = player_data_type_def:get_field("_HyakuryuDragonPowerUpTimer");
-- Intrepid Heart
local equip_skill_223_accumulator_field = player_data_type_def:get_field("_EquipSkill223Accumulator");
-- Derelection
local symbiosis_skill_lost_vital_field = player_data_type_def:get_field("_SymbiosisSkillLostVital");

local system_array_type_def = sdk.find_type_definition("System.Array");
local length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

function this.update(player_data)
	local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	if item_parameter == nil then
		error_handler.report("skills.update", "Failed to access Data: item_parameter");
		return;
	end

	this.update_burst(player_data);
	this.update_kushala_daora_soul(player_data);
	this.update_intrepid_heart(player_data);
	this.update_dereliction(player_data);

	--xy = string.format("%s\n%s", player_data._Attack, player_data._SymbiosisSkillLostVital);
end

function this.update_burst(player_data)
	local burst_value = rengeki_power_up_count_field:get_data(player_data);
	if burst_value == nil then
		error_handler.report("skills.update_burst", "Failed to access Data: burst_value");
		return;
	end

	if burst_value == 0 then
		this.list.burst = nil;
		return;
	end

	local burst_timer = rengeki_power_up_timer_field:get_data(player_data);
	if burst_timer == nil then
		error_handler.report("skills.update_burst", "Failed to access Data: burst_timer");
		return;
	end

	local skill_level = 1;
	if burst_value >= 5 then
		skill_level = 2;
	end

	local buff = this.list.burst;
	if buff == nil then
		local name = language.current_language.skills.burst;

		buff = buffs.new(buffs.types.skill, "burst", name, skill_level, burst_timer / 60);
		this.list.burst = buff;
	else
		buff.level = skill_level;
		buffs.update_timer(buff, burst_timer / 60);
	end
end

function this.update_kushala_daora_soul(player_data)
	local kushala_daora_soul_value = hyakuryu_dragon_power_up_count_field:get_data(player_data);
	if kushala_daora_soul_value == nil then
		error_handler.report("skills.update_kushala_daora_soul", "Failed to access Data: kushala_daora_soul_value");
		return;
	end

	if kushala_daora_soul_value == 0 then
		this.list.kushala_daora_soul = nil;
		this.list.kushala_daora_soul_2 = nil;
		return;
	end

	local kushala_daora_soul_timer = hyakuryu_dragon_power_up_timer_field:get_data(player_data);
	if kushala_daora_soul_timer == nil then
		error_handler.report("skills.update_kushala_daora_soul", "Failed to access Data: kushala_daora_soul_timer");
		return;
	end

	local skill_level = 1;
	if kushala_daora_soul_value >= 5 then
		skill_level = 2;
	end

	local buff = this.list.kushala_daora_soul;
	if buff == nil then
		local name = language.current_language.skills.kushala_daora_soul;

		buff = buffs.new(buffs.types.skill, "kushala_daora_soul", name, skill_level, kushala_daora_soul_timer / 60);
		this.list.kushala_daora_soul = buff;
	else
		buff.level = skill_level;
		buffs.update_timer(buff, kushala_daora_soul_timer / 60);
	end
end

function this.update_intrepid_heart(player_data)
	local intrepid_heart_value = equip_skill_223_accumulator_field:get_data(player_data);
	if intrepid_heart_value == nil then
		error_handler.report("skills.update_intrepid_heart", "Failed to access Data: intrepid_heart_value");
		return;
	end

	if intrepid_heart_value < 400 then
		this.list.intrepid_heart = nil;
		return;
	end

	local buff = this.list.intrepid_heart;
	if buff == nil then
		local name = language.current_language.skills.intrepid_heart;

		buff = buffs.new(buffs.types.skill, "intrepid_heart", name, 1);
		this.list.intrepid_heart = buff;
	end
end

function this.update_dereliction(player_data)
	local dereliction_value = symbiosis_skill_lost_vital_field:get_data(player_data);
	if dereliction_value == nil then
		error_handler.report("skills.update_derelection", "Failed to access Data: dereliction_value");
		return;
	end

	if dereliction_value == 0 then
		this.list.dereliction = nil;
		return;
	end

	local skill_level = 1;
	if dereliction_value >= 100 then
		skill_level = 3;
	elseif dereliction_value >= 50 then
		skill_level = 2;
	end

	local buff = this.list.dereliction;
	if buff == nil then
		local name = language.current_language.skills.dereliction;

		buff = buffs.new(buffs.types.skill, "dereliction", name, skill_level);
		this.list.dereliction = buff;
	else
		buff.level = skill_level;
	end
end

function this.init_names()
	for key, buff in pairs(this.list) do
		buff.name = language.current_language.skills[key];
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
end

function this.init_module()
end

return this;