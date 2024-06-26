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

this.list = {
	dango_adrenaline = nil,
	dango_booster = nil,
	dango_connector = nil,
	dango_defender = nil,
	dango_flyer = nil,
	dango_glutton = nil,
	dango_hunter = nil,
	dango_insurance = nil,
	dango_insurance_defense_up = nil,
	super_recovery_dango = nil
};

this.keys = {
	"dango_adrenaline",
	"dango_booster",
	"dango_connector",
	"dango_defender",
	"dango_flyer",
	"dango_glutton",
	"dango_hunter",
	"dango_insurance",
	"dango_insurance_defense_up",
	"super_recovery_dango"
};

local dango_skill_ids = {
	-- dango_polisher = 1,
	-- dango_rider = 2,
	dango_adrenaline = 3,
	-- dango_carver_lo = 4,
	-- dango_carver_hi = 5,
	-- dango_medic_lo = 6,
	-- dango_medic_hi = 7,
	-- dango_fighter = 8,
	-- dango_pyro = 9,
	-- dango_specialist = 10,
	-- dango_defender_lo = 11,
	-- dango_defender_hi = 12,
	-- dango_harvester = 13,
	-- dango_marksman = 14,
	-- dango_fortune_caller = 15,
	-- dango_miracle_worker = 16,
	-- dango_deflector = 17,
	-- dango_weakener = 18,
	-- dango_calculator = 19,
	-- dango_temper = 20,
	-- dango_wall_runner = 21,
	-- dango_slugger = 22,
	-- dango_money_maker = 23,
	-- dango_bombardier = 24,
	-- dango_moxie = 25,
	-- dango_immunizer = 26,
	-- dango_trainer = 27,
	dango_booster = 28,
	-- dango_feet = 29,
	dango_bulker = 30,
	dango_insurance = 31,
	-- dango_reviver = 32,
	-- dango_summoner = 33,
	-- dango_hurler = 34,
	-- dango_fire_res_lo = 35,
	-- dango_fire_res_hi = 36,
	-- dango_water_res_lo = 37,
	-- dango_water_res_hi = 38,
	-- dango_thunder_res_lo = 39,
	-- dango_thunder_res_hi = 40,
	-- dango_ice_res_lo = 41,
	-- dango_ice_res_hi = 42,
	-- dango_dragon_res_lo = 43,
	-- dango_dragon_res_hi = 44,
	-- dango_gatherer = 45,
	dango_glutton = 46,
	-- dango_bird_caller = 47,
	dango_flyer = 48,
	dango_defender = 49,
	-- enhanced_dango_fighter = 50,
	-- dango_driver = 51,
	dango_hunter = 52,
	-- dango_guard = 53,
	-- dango_shifter = 54,
	dango_connector = 55,
	super_recovery_dango = 56
};


this.is_dango_adrenaline_active = false;

local dango_skills_type_name = "dango_skills";

local dango_bulker_attack_up = 15;
local previous_super_recovery_dango_timer = 0;

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local has_anyone_kitchen_skill_in_quest_method = player_manager_type_def:get_method("hasAnyoneKitchenSkillInQuest");


local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Dango Defender
local is_enable_kitchen_skill_048_reduce_field = player_data_type_def:get_field("_IsEnable_KitchenSkill048_Reduce");
-- Dango Booster
local kitchen_skill_027_timer_field = player_data_type_def:get_field("_KitchenSkill027Timer");
-- Dango Glutton
local kitchen_skill_045_timer_field = player_data_type_def:get_field("_KitchenSkill045Timer");
-- Dango Insurance
local kitchen_skill_insurance_def_up_lv3_field = player_data_type_def:get_field("_KitchenSkill_Insurance_DefUp_Lv3");
local kitchen_skill_insurance_def_up_lv4_field = player_data_type_def:get_field("_KitchenSkill_Insurance_DefUp_Lv4");
-- Dango Hunter
local kitchen_skill_051_atk_up_timer_field = player_data_type_def:get_field("_KitchenSkill051_AtkUpTimer");
-- Dango Connector
local kitchen_skill_054_timer_field = player_data_type_def:get_field("_KitchenSkill054_Timer");


local player_base_type_def = sdk.find_type_definition("snow.player.PlayerBase");
-- Dango Adrenaline
-- local is_kitchen_skill_predicament_powerup_method = player_base_type_def:get_method("isKitchenSkillPredicamentPowerUp");
-- Dango Flyer
local get_is_kitchen_skill_wire_stop_heal_spd_method = player_base_type_def:get_method("get_IsKitchenSkill_WireStop_HealSpd");
local get_is_kitchen_skill_wire_stop_regene_method = player_base_type_def:get_method("get_IsKitchenSkill_WireStop_Regene");
-- Super Recovery Dango
local get_kitchen_skill_surume_regene_timer_method = player_base_type_def:get_method("get_KitchenSkill_Surume_RegeneTimer");



local data_shortcut_type_def = sdk.find_type_definition("snow.data.DataShortcut");
local get_name_method = data_shortcut_type_def:get_method("getName(snow.data.DataDef.PlKitchenSkillId)");

local quest_manager_type_def = sdk.find_type_definition("snow.QuestManager");
local flag_cat_skill_insurance_field = quest_manager_type_def:get_field("_FlagCatSkillInsurance");
local is_cat_skill_insurance_method = quest_manager_type_def:get_method("isCatSkillInsurance");

function this.update(player, player_data)
	this.update_dango_adrenaline();
	this.update_dango_hunter(player_data);
	this.update_dango_insurance();
	this.update_dango_insurance_defense_up(player_data);
	this.update_dango_flyer(player);
	this.update_super_recovery_dango(player);

	this.update_dango_skill("dango_booster", nil, nil, player_data, kitchen_skill_027_timer_field);
	this.update_dango_skill("dango_defender", player_data, is_enable_kitchen_skill_048_reduce_field, nil, nil, true);
	this.update_dango_skill("dango_glutton", nil, nil, player_data, kitchen_skill_045_timer_field);
	this.update_dango_skill("dango_connector", nil, nil, player_data, kitchen_skill_054_timer_field);
end

function this.update_dango_skill(key, value_owner, value_holder, timer_owner, timer_holder, is_infinite, minimal_value, level_breakpoints)
	return buffs.update_generic_buff(this.list, config.current_config.buff_UI.filter.dango_skills, this.get_dango_skill_name,
		dango_skills_type_name, key,
		value_owner, value_holder, timer_owner, timer_holder, is_infinite, minimal_value, level_breakpoints);
end

function this.update_generic(key, level, timer)
	return buffs.update_generic(this.list, this.get_dango_skill_name, dango_skills_type_name, key, level, timer);
end

function this.apply_filter(key)
	return buffs.apply_filter(this.list, config.current_config.buff_UI.filter.dango_skills, key);
end

function this.update_dango_adrenaline()
	if this.apply_filter("dango_adrenaline") then
		return;
	end

	if not this.is_dango_adrenaline_active then
		this.list.dango_adrenaline = nil;
		return;
	end

	this.update_generic("dango_adrenaline");
end

function this.update_dango_insurance()
	if this.apply_filter("dango_insurance") then
		return;
	end

	if singletons.player_manager == nil then
		error_handler.report("dango_skills.update_dango_insurance", "Failed to Access Data: player_manager");
		this.list.dango_insurance = nil;
		return;
	end

	if singletons.quest_manager == nil then
		error_handler.report("dango_skills.update_dango_insurance", "Failed to Access Data: quest_manager");
		this.list.dango_insurance = nil;
		return;
	end

	local has_insurance_skill = has_anyone_kitchen_skill_in_quest_method:call(singletons.player_manager, dango_skill_ids.dango_insurance);

	local flag_cat_skill_insurance = flag_cat_skill_insurance_field:get_data(singletons.quest_manager);
	if flag_cat_skill_insurance == nil then
		error_handler.report("dango_skills.update_dango_insurance", "Failed to Access Data: flag_cat_skill_insurance");
		this.list.dango_insurance = nil;
		return;
	end

	local is_cat_skill_insurance = is_cat_skill_insurance_method:call(singletons.quest_manager, flag_cat_skill_insurance);
	if is_cat_skill_insurance == nil then
		error_handler.report("dango_skills.update_dango_insurance", "Failed to Access Data: is_cat_skill_insurance");
		this.list.dango_insurance = nil;
		return;
	end

	if not has_insurance_skill or is_cat_skill_insurance then
		this.list.dango_insurance = nil;
		return;
	end

	this.update_generic("dango_insurance");
end

function this.update_dango_insurance_defense_up(player_data)
	if this.apply_filter("dango_insurance_defense_up") then
		return;
	end

	local level = 3;

	local insurance_def_up_lv3 = kitchen_skill_insurance_def_up_lv3_field:get_data(player_data);
	if insurance_def_up_lv3 == nil then
		error_handler.report("dango_skills.update_dango_insurance_defense_up", "Failed to Access Data: insurance_def_up_lv3");
		this.list.dango_insurance_defense_up = nil;
		return;
	end

	if not insurance_def_up_lv3 then
		local insurance_def_up_lv4 = kitchen_skill_insurance_def_up_lv4_field:get_data(player_data);

		if insurance_def_up_lv4 == nil then
			error_handler.report("dango_skills.update_dango_insurance_defense_up", "Failed to Access Data: insurance_def_up_lv4");
			this.list.dango_insurance_defense_up = nil;
			return;
		end

		if not insurance_def_up_lv4 then
			this.list.dango_insurance_defense_up = nil;
			return;
		end

		level = 4;
	end

	this.update_generic("dango_insurance_defense_up", level);
end

function this.update_dango_flyer(player)
	if this.apply_filter("dango_flyer") then
		return;
	end

	local level = 4;

	local is_kitchen_skill_wire_stop_regene = get_is_kitchen_skill_wire_stop_regene_method:call(player);
	if is_kitchen_skill_wire_stop_regene == nil then
		error_handler.report("dango_skills.update_dango_flyer", "Failed to Access Data: is_kitchen_skill_wire_stop_regene");
		this.list.dango_flyer = nil;
		return;
	end

	if not is_kitchen_skill_wire_stop_regene then

		local is_kitchen_skill_wire_stop_heal_spd = get_is_kitchen_skill_wire_stop_heal_spd_method:call(player);
		if is_kitchen_skill_wire_stop_heal_spd == nil then
			error_handler.report("dango_skills.update_dango_flyer", "Failed to Access Data: is_kitchen_skill_wire_stop_heal_spd");
			this.list.dango_flyer = nil;
			return;
		end

		if not is_kitchen_skill_wire_stop_regene then
			this.list.dango_flyer = nil;
			return;
		end

		level = 3;
	end

	this.update_generic("dango_flyer", level);
end

function this.update_dango_hunter(player_data)
	local dango_hunter_buff = this.update_dango_skill("dango_hunter", nil, nil, player_data, kitchen_skill_051_atk_up_timer_field);

	if dango_hunter_buff ~= nil then
		dango_hunter_buff.level = 4;
	end
end

function this.update_super_recovery_dango(player)
	if this.apply_filter("super_recovery_dango") then
		return;
	end

	local kitchen_skill_surume_regene_timer = get_kitchen_skill_surume_regene_timer_method:call(player);
	if kitchen_skill_surume_regene_timer == nil then
		error_handler.report("dango_skills.update_super_recovery_dango", "Failed to Access Data: kitchen_skill_surume_regene_timer");
		this.list.super_recovery_dango = nil;
		return;
	end

	if utils.number.is_equal(kitchen_skill_surume_regene_timer, 0)
	and utils.number.is_equal(previous_super_recovery_dango_timer, 0) then
		this.list.super_recovery_dango = nil;
		return;
	end

	previous_super_recovery_dango_timer = kitchen_skill_surume_regene_timer;
	this.update_generic("super_recovery_dango");
end

function this.init_all_UI()
	for dango_skill_key, dango_skill in pairs(this.list) do
		buffs.init_UI(dango_skill);
	end
end

function this.init_names()
	for dango_skill_key, dango_skill in pairs(this.list) do
		dango_skill.name = this.get_dango_skill_name(dango_skill_key);
	end
end

function this.get_dango_skill_name(key)
	local dango_skill_id = dango_skill_ids[key];
	if dango_skill_id == nil then
		
		local dango_skill_name = language.current_language.dango_skills[key];
		if dango_skill_name == nil then
			return key;
		end

		return dango_skill_name;
	end

	local dango_skill_name = get_name_method:call(nil, dango_skill_id);
	if dango_skill_name == nil then
		error_handler.report("dango_skills.get_dango_name", string.format("Failed to Access Data: %s_name", key));
		return key;
	end

	return dango_skill_name;
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