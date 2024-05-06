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
local skills_type_name = type;
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
	adrenaline_rush = nil,
	affinity_sliding = nil,
	agitator = nil,
	berserk = nil,
	bladescale_hone = nil,
	blood_awakening = nil,
	bloodlust = nil,
	burst = nil,
	coalescence = nil,
	counterstrike = nil,
	dereliction = nil,
	dragon_conversion_elemental_attack_up = nil,
	dragon_conversion_elemental_res_up = nil,
	dragonheart = nil,
	embolden = nil,
	frenzied_bloodlust = nil,
	furious = nil,
	grinder_s = nil,
	heaven_sent = nil,
	hellfire_cloak = nil,
	heroics = nil,
	inspiration = nil,
	intrepid_heart = nil,
	latent_power = nil,
	maximum_might = nil,
	offensive_guard = nil,
	partbreaker = nil,
	peak_performance = nil,
	powder_mantle_red = nil,
	powder_mantle_blue = nil,
	protective_polish = nil,
	resentment = nil,
	resuscitate = nil,
	spiribirds_call = nil,
	status_trigger = nil,
	strife = nil,
	wall_runner = nil,
	wind_mantle = nil,
};

this.keys = {
	"adrenaline_rush",
	"affinity_sliding",
	"agitator",
	"berserk",
	"bladescale_hone",
	"blood_awakening",
	"bloodlust",
	"burst",
	"coalescence",
	"counterstrike",
	"dereliction",
	"dragon_conversion_elemental_attack_up",
	"dragon_conversion_elemental_res_up",
	"dragonheart",
	"embolden",
	"frenzied_bloodlust",
	"furious",
	"grinder_s",
	"heaven_sent",
	"hellfire_cloak",
	"heroics",
	"inspiration",
	"intrepid_heart",
	"latent_power",
	"maximum_might",
	"offensive_guard",
	"partbreaker",
	"peak_performance",
	"powder_mantle_red",
	"powder_mantle_blue",
	"protective_polish",
	"resentment",
	"resuscitate",
	"spiribirds_call",
	"status_trigger",
	"strife",
	"wall_runner",
	"wind_mantle"
};

local skills_type_name = "skills";

local skill_data_list = {
	-- attack_boost =			{ id = 1 },
	agitator =					{ id = 2 },
	peak_performance =			{ id = 3,	level = 0, is_equipped = false },
	resentment =				{ id = 4,	level = 0, is_equipped = false },
	resuscitate =				{ id = 5,	level = 0, is_equipped = false },
	-- critical_eye =			{ id = 6 },
	-- critical_boost =			{ id = 7 },
	-- weakness_exploit =		{ id = 8 },
	latent_power =				{ id = 9 },
	maximum_might =				{ id = 10,	level = 0, is_equipped = false },
	-- critical_element =		{ id = 11 },
	-- masters_touch =			{ id = 12 },
	-- fire_attack =			{ id = 13 },
	-- water_attack =			{ id = 14 },
	-- ice_attack =				{ id = 15 },
	-- thunder_attack =			{ id = 16 },
	-- dragon_attack =			{ id = 17 },
	-- poison_attack =			{ id = 18 },
	-- paralysis_attack =		{ id = 19 },
	-- sleep_attack =			{ id = 20 },
	-- blast_attack =			{ id = 21 },
	-- handicraft =				{ id = 22 },
	-- razor_sharp =			{ id = 23 },
	-- spare_shot =				{ id = 24 },
	protective_polish =			{ id = 25 },
	-- minds_eye =				{ id = 26 },
	-- ballistics =				{ id = 27 },
	-- bludgeoner =				{ id = 28 },
	-- bow_charge_plus =		{ id = 29 },
	-- focus =					{ id = 30 },
	-- power_prolonger =		{ id = 31 },
	-- marathon_runner =		{ id = 32 },
	-- constitution =			{ id = 33 },
	-- stamina_surge =			{ id = 34 },
	-- guard =					{ id = 35 },
	-- guard_up =				{ id = 36 },
	offensive_guard =			{ id = 37 },
	-- critical_draw =			{ id = 38 },
	-- punishing_draw =			{ id = 39 },
	-- quick_sheathe =			{ id = 40 },
	-- slugger =				{ id = 41 },
	-- stamina_thief =			{ id = 42 },
	affinity_sliding =			{ id = 43 },
	-- horn_maestro =			{ id = 44 },
	-- artillery =				{ id = 45 },
	-- load_shells =			{ id = 46 },
	-- special_ammo_boost =		{ id = 47 },
	-- normal_rapid_up =		{ id = 48 },
	-- pierce_up =				{ id = 49 },
	-- spread_up =				{ id = 50 },
	-- ammo_up =				{ id = 51 },
	-- reload_speed =			{ id = 52 },
	-- recoil_down =			{ id = 53 },
	-- steadiness =				{ id = 54 },
	-- rapid_fire_up =			{ id = 55 },
	-- defense_boost =			{ id = 56 },
	-- divine_blessing =		{ id = 57 },
	-- recovery_up =			{ id = 58 },
	-- recovery_speed =			{ id = 59 },
	-- speed_eating =			{ id = 60 },
	-- earplugs =				{ id = 61 },
	-- windproof =				{ id = 62 },
	-- tremor_resistance =		{ id = 63 },
	-- bubbly_dance =			{ id = 64 },
	-- evade_window =			{ id = 65 },
	-- evade_extender =			{ id = 66 },
	-- fire_resistance =		{ id = 67 },
	-- water_resistance =		{ id = 68 },
	-- ice_resistance =			{ id = 69 },
	-- thunder_resistance =		{ id = 70 },
	-- dragon_resistance =		{ id = 71 },
	-- blight_resistance =		{ id = 72 },
	-- poison_resistance =		{ id = 73 },
	-- paralysis_resistance =	{ id = 74 },
	-- sleep_resistance =		{ id = 75 },
	-- stun_resistance =		{ id = 76 },
	-- muck_resistance =		{ id = 77 },
	-- blast_resistance =		{ id = 78 },
	-- botanist =				{ id = 79 },
	-- geologist =				{ id = 80 },
	partbreaker =				{ id = 81, level = 0, is_equipped = false },
	-- capture_master =			{ id = 82 },
	-- carving_master =			{ id = 83 },
	-- good_luck =				{ id = 84 },
	-- speed_sharpening =		{ id = 85 },
	-- bombardier =				{ id = 86 },
	-- mushroomancer =			{ id = 87 },
	-- item_prolonger =			{ id = 88 },
	-- wide_range =				{ id = 89 },
	-- free_meal =				{ id = 90 },
	heroics =					{ id = 91, level = 0, is_equipped = false },
	-- fortify =				{ id = 92 },
	-- flinch_free =			{ id = 93 },
	-- jump_master =			{ id = 94 },
	-- carving_pro =			{ id = 95 },
	-- hunger_resistance =		{ id = 96 },
	-- leap_of_faith =			{ id = 97 },
	-- diversion =				{ id = 98 },
	-- master_mounter =			{ id = 99 },
	-- chameleos_blessing =		{ id = 100 },
	-- kushala_blessing =		{ id = 101 },
	-- teostra_blessing =		{ id = 102 },
	dragonheart =				{ id = 103,	level = 0, is_equipped = false },
	-- wirebug_whisperer =		{ id = 104 },
	wall_runner =				{ id = 105 },
	counterstrike =				{ id = 106 },
	-- rapid_morph =			{ id = 107 },
	hellfire_cloak =			{ id = 108 },
	-- wind_alignment =			{ id = 109 },
	-- thunder_alignment =		{ id = 110 },
	-- stormsoul =				{ id = 111 },
	-- blood_rite =				{ id = 112 },
	dereliction =				{ id = 113, level = 0, is_equipped = false },
	furious =					{ id = 114 },
	-- mail_of_hellfire =		{ id = 115 },
	coalescence =				{ id = 116 },
	bloodlust =					{ id = 117,	level = 0, is_equipped = false },
	-- defiance =				{ id = 118 },
	-- sneak_attack =			{ id = 119 },
	adrenaline_rush =			{ id = 120 },
	embolden =					{ id = 121 },
	-- redirection =			{ id = 122 },
	spiribirds_call =			{ id = 123 },
	charge_master =				{ id = 124 },
	-- foray =					{ id = 125 },
	-- tune_up =				{ id = 126 },
	grinder_s =					{ id = 127 },
	bladescale_hone =			{ id = 128 },
	-- wall_runner_boost =		{ id = 129 },
	-- element_exploit =		{ id = 130 },
	burst =						{ id = 131 },
	-- guts =					{ id = 132 },
	-- quick_breath =			{ id = 133 },
	status_trigger =			{ id = 134 },
	intrepid_heart =			{ id = 135 },
	-- buildup_boost =			{ id = 136 },
	berserk =					{ id = 137 },
	wind_mantle =				{ id = 138 },
	-- powder_mantle =			{ id = 139 },
	-- frostcraft =				{ id = 140 },
	-- dragon_conversion =		{ id = 141 }, -- implemented
	heaven_sent =				{ id = 142 },
	frenzied_bloodlust =		{ id = 143 },
	blood_awakening =			{ id = 144 },
	strife =					{ id = 145,	level = 0, is_equipped = false },
	-- shock_absorber =			{ id = 146 },
	inspiration =				{ id = 147 },
}

this.is_heroics_active = false;

local intrepid_heart_minimal_value = 400;

local burst_breakpoints = { 5 };
local dereliction_breakpoints = { 100, 50 };
local dragonheart_breakpoints = { 0.5, 0.5, 0.7, 0.7, 0.8 };
local strife_breakpoints = { { 10 }, { 15 }, { 20 } };
local blood_awakening_breakpoints = { 2 };
local wind_mantle_breakpoints = { 20, 10 }; -- Sword & Shield, Lance, Hammer, Switch Axe, Insect Glaive, Long Sword, Hunting Horn
local wind_mantle_special_breakpoints = {
	[0]  = { 10,  5 }, -- Great Sword
	[3]  = { 60, 30 }, -- Light Bowgun
	[4]  = { 60, 30 }, -- Heavy Bowgun
	[6]  = { 30, 15 }, -- Gunlance
	[9]  = { 40, 20 }, -- Dual Blades
	[11] = { 30, 15 }, -- Charge Blade
	[13] = { 60, 30 }, -- Bow
};

local maximum_might_delay_timer = nil;
local maximum_might_previous_timer_value = 0;

local frenzied_bloodlust_duration = 0;
local frenzied_bloodlust_sheathed_duration = 0;

local spiribirds_call_duration = 60;

local wind_mantle_duration = 15;

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Burst
local rengeki_power_up_count_field = player_data_type_def:get_field("_RengekiPowerUpCnt");
local rengeki_power_up_timer_field = player_data_type_def:get_field("_RengekiPowerUpTimer");
-- Intrepid Heart
local equip_skill_223_accumulator_field = player_data_type_def:get_field("_EquipSkill223Accumulator");
-- Derelection
local symbiosis_skill_lost_vital_field = player_data_type_def:get_field("_SymbiosisSkillLostVital");
-- Grinder (S)
local brand_new_sharpness_adjust_up_timer_field = player_data_type_def:get_field("_BrandNewSharpnessAdjustUpTimer");
-- Counterstrike
local counterattack_powerup_timer_field = player_data_type_def:get_field("_CounterattackPowerupTimer");
-- Affinity Sliding
local sliding_powerup_timer_field = player_data_type_def:get_field("_SlidingPowerupTimer");
-- Coalescence
local disaster_turn_powerup_timer_field = player_data_type_def:get_field("_DisasterTurnPowerUpTimer");
-- Adrenaline Rush
local equip_skill_208_atk_up_field = player_data_type_def:get_field("_EquipSkill208_AtkUpTimer");
-- Wall Runner
local wall_run_powerup_timer_field = player_data_type_def:get_field("_WallRunPowerupTimer");
-- Offensive Guard
local equip_skill_036_timer_field = player_data_type_def:get_field("_EquipSkill_036_Timer");
-- Hellfire Cloak
local onibi_powerup_timer_field = player_data_type_def:get_field("_OnibiPowerUpTiemr");
-- Agitator
local challenge_timer_field = player_data_type_def:get_field("_ChallengeTimer");
-- Furious
local furious_skill_stamina_buff_second_timer_field = player_data_type_def:get_field("_FuriousSkillStaminaBuffSecondTimer");
-- Maximum Might
local whole_body_timer_field = player_data_type_def:get_field("_WholeBodyTimer");
-- Frenzied Bloodlust
local equip_skill_231_wire_num_timer_field = player_data_type_def:get_field("_EquipSkill231_WireNumTimer");
local equip_skill_231_wp_off_timer_field = player_data_type_def:get_field("_EquipSkill231_WpOffTimer");
-- Resentment
local r_vital_field = player_data_type_def:get_field("_r_Vital");
-- Status Trigger
local equip_skill_222_timer_field = player_data_type_def:get_field("_EquipSkill222_Timer");
-- Spiritbird's Call
local equip_skill_211_timer_field = player_data_type_def:get_field("_EquipSkill211_Timer");
-- Powder Mantle
local equip_skill_227_state_field = player_data_type_def:get_field("_EquipSkill227State");
local equip_skill_227_state_timer_field = player_data_type_def:get_field("_EquipSkill227StateTimer");
-- Inspiration
local equip_skill_235_atk_up_second_timer_field = player_data_type_def:get_field("_EquipSkill235AtkUpSecondTimer");
-- Blood Awakening
local equip_skill_232_timer_field = player_data_type_def:get_field("_EquipSkill232Timer");



local player_base_type_def = sdk.find_type_definition("snow.player.PlayerBase");
local get_player_skill_list_method = player_base_type_def:get_method("get_PlayerSkillList");

-- Latent Power
local power_freedom_timer_field = player_base_type_def:get_field("_PowerFreedomTimer");
-- Protective Polish
local sharpness_gauge_boost_timer_field = player_base_type_def:get_field("_SharpnessGaugeBoostTimer");
-- Heroics
--local is_predicament_power_up_method = player_base_type_def:get_method("isPredicamentPowerUp");
-- Berserk
local get_is_enable_equip_skill_225_method = player_base_type_def:get_method("get_IsEnableEquipSkill225");
-- Dragon Conversion
local equip_skill_229_sum_resist_field = player_base_type_def:get_field("_EquipSkill229SumResist");
-- Resuscitate
local is_debuff_state_method = player_base_type_def:get_method("isDebuffState");

local player_skill_list_type_def = sdk.find_type_definition("snow.player.PlayerSkillList");
local get_skill_data_method = player_skill_list_type_def:get_method("getSkillData");

local skill_data_type_def = get_skill_data_method:get_return_type();
local skill_lv_field = skill_data_type_def:get_field("SkillLv");



local player_quest_base_type_def = sdk.find_type_definition("snow.player.PlayerQuestBase");
-- Wind Mantle
local is_equip_skill_226_enable_field = player_quest_base_type_def:get_field("_IsEquipSkill226Enable");
local equip_skill_226_attack_count_field = player_quest_base_type_def:get_field("_EquipSkill226AttackCount");
local equip_skill_226_attack_off_timer_field = player_quest_base_type_def:get_field("_EquipSkill226AttackOffTimer");
-- Heaven-Sent
local is_active_equip_skill_230_method = player_quest_base_type_def:get_method("isActiveEquipSkill230");
-- Frenzied Bloodlust
local get_hunter_wire_skill_231_num_method = player_quest_base_type_def:get_method("get_HunterWireSkill231Num");
-- Embolden
local get_active_equip_209_method = player_quest_base_type_def:get_method("getActiveEquipSkill209");
-- Dragon Conversion
local equip_skill_229_use_up_flag_field = player_quest_base_type_def:get_field("_EquipSkill229UseUpFlg");
-- Strife
local get_affinity_equip_skill_233_method = player_quest_base_type_def:get_method("getAffinityEquipSkill233");
-- Blood Awakening
local get_equip_skill_232_lv_method = player_quest_base_type_def:get_method("getEquipSkill232Lv");

local bow_type_def = sdk.find_type_definition("snow.player.Bow");
local _equip_skill_216_bottle_up_timer_field = bow_type_def:get_field("_EquipSkill216_BottleUpTimer");

local data_shortcut_type_def = sdk.find_type_definition("snow.data.DataShortcut");
local get_name_method = data_shortcut_type_def:get_method("getName(snow.data.DataDef.PlEquipSkillId)");

function this.update(player, player_data, weapon_type)
	this.update_equipped_skill_data(player);

	this.update_wind_mantle(player, weapon_type);
	this.update_maximum_might(player_data);
	this.update_bloodlust();
	this.update_frenzied_bloodlust(player, player_data);
	this.update_peak_performance();
	this.update_heroics();
	this.update_dragonheart();
	this.update_resentment(player_data);
	this.update_bladescale_hone(player, weapon_type);
	this.update_spiribirds_call(player_data);
	this.update_powder_mantle(player_data);
	this.update_blood_awakening(player, player_data);

	this.update_skill("dereliction", player_data, symbiosis_skill_lost_vital_field, nil, nil, true, nil, dereliction_breakpoints);
	this.update_skill("burst", player_data, rengeki_power_up_count_field, player_data, rengeki_power_up_timer_field, false, nil, burst_breakpoints);
	this.update_skill("intrepid_heart", player_data, equip_skill_223_accumulator_field, nil, nil, true, intrepid_heart_minimal_value);
	this.update_skill("latent_power", nil, nil, player, power_freedom_timer_field);
	this.update_skill("protective_polish", nil, nil, player, sharpness_gauge_boost_timer_field);
	this.update_skill("grinder_s", nil, nil, player_data, brand_new_sharpness_adjust_up_timer_field);
	this.update_skill("counterstrike", nil, nil, player_data, counterattack_powerup_timer_field);
	this.update_skill("affinity_sliding", nil, nil, player_data, sliding_powerup_timer_field);
	this.update_skill("coalescence", nil, nil, player_data, disaster_turn_powerup_timer_field);
	this.update_skill("adrenaline_rush", nil, nil, player_data, equip_skill_208_atk_up_field);
	this.update_skill("wall_runner", nil, nil, player_data, wall_run_powerup_timer_field);
	this.update_skill("offensive_guard", nil, nil, player_data, equip_skill_036_timer_field);
	this.update_skill("hellfire_cloak", nil, nil, player_data, onibi_powerup_timer_field);
	this.update_skill("agitator", nil, nil, player_data, challenge_timer_field, nil, nil, true);
	this.update_skill("furious", nil, nil, player_data, furious_skill_stamina_buff_second_timer_field);
	this.update_skill("status_trigger", nil, nil, player_data, equip_skill_222_timer_field);
	this.update_skill("inspiration", nil, nil, player_data, equip_skill_235_atk_up_second_timer_field);
	this.update_skill("heaven_sent", player, is_active_equip_skill_230_method);
	this.update_skill("resuscitate", player, is_debuff_state_method);
	this.update_skill("embolden", player, get_active_equip_209_method);
	this.update_skill("berserk", player, get_is_enable_equip_skill_225_method);
	this.update_skill("dragon_conversion_elemental_attack_up", player, equip_skill_229_sum_resist_field);
	this.update_skill("dragon_conversion_elemental_res_up", player, equip_skill_229_use_up_flag_field);
	this.update_skill("partbreaker", nil, nil, nil, nil, true);
	this.update_skill("strife", player, get_affinity_equip_skill_233_method, nil, nil, nil, nil, strife_breakpoints[skill_data_list.strife.level]);
end

function this.update_skill(key, value_owner, value_holder, timer_owner, timer_holder, is_infinite, minimal_value, level_breakpoints)
	local skill_data = skill_data_list[key];
	if skill_data ~= nil and skill_data.is_equipped ~= nil and not skill_data.is_equipped then
		this.list[key] = nil;
		return nil;
	end

	return buffs.update_generic_buff(this.list, config.current_config.buff_UI.filter.skills, this.get_skill_name,
		skills_type_name, key,
		value_owner, value_holder, timer_owner, timer_holder, is_infinite, minimal_value, level_breakpoints);
end

function this.update_generic(key, level, timer)
	return buffs.update_generic(this.list, this.get_skill_name, skills_type_name, key, level, timer);
end

function this.apply_filter(key)
	return buffs.apply_filter(this.list, config.current_config.buff_UI.filter.skills, key);
end

function this.update_equipped_skill_data(player)
	local player_skill_list = get_player_skill_list_method:call(player);
	if player_skill_list == nil then
		error_handler.report("this.update_equipped_skill_data", "Failed to Access Data: player_skill_list");
		return;
	end

	for skill_key, skill_data in pairs(skill_data_list) do
		if skill_data.is_equipped == nil then
			goto continue;
		end

		local re_skill_data = get_skill_data_method:call(player_skill_list, skill_data.id);
		if re_skill_data == nil then
			skill_data.is_equipped = false;
			skill_data.level = 0;
			goto continue;
		end

		local skill_level = skill_lv_field:get_data(re_skill_data);
		if skill_level == nil then
			error_handler.report("skills.update_equipped_skill_data", string.format("Failed to Access Data: %s -> skill_level", skill_key));
			goto continue;
		end

		if skill_level <= 0 then
			skill_data.is_equipped = false;
			skill_data.level = 0;
			goto continue;
		end

		skill_data.is_equipped = true;
		skill_data.level = skill_level;

		::continue::
	end
end

function this.update_wind_mantle(player, weapon_type)
	if this.apply_filter("wind_mantle") then
		return;
	end

	local is_wind_mantle_enable = is_equip_skill_226_enable_field:get_data(player);
	if is_wind_mantle_enable == nil then
		error_handler.report("skills.update_wind_mantle", "Failed to Access Data: is_wind_mantle_enable");
		this.list.wind_mantle = nil;
		return;
	end

	if not is_wind_mantle_enable then
		this.list.wind_mantle = nil;
		return;
	end

	local wind_mantle_timer = equip_skill_226_attack_off_timer_field:get_data(player);
	if wind_mantle_timer == nil then
		error_handler.report("skills.update_wind_mantle", "Failed to Access Data: wind_mantle_timer");
		this.list.wind_mantle = nil;
		return;
	end

	local wind_mantle_value = equip_skill_226_attack_count_field:get_data(player);
	if wind_mantle_value == nil then
		error_handler.report("skills.update_wind_mantle", "Failed to Access Data: wind_mantle_value");
		this.list.wind_mantle = nil;
		return;
	end

	local level = 1;

	local breakpoints = wind_mantle_special_breakpoints[weapon_type] or wind_mantle_breakpoints;
	local breakpoint_count = #breakpoints;

	for index, breakpoint in ipairs(breakpoints) do
		if wind_mantle_value >= breakpoint then
			level = 2 + breakpoint_count - index;
			break;
		end
	end

	this.update_generic("wind_mantle", level, wind_mantle_duration - (wind_mantle_timer / 60));
end

function this.update_maximum_might(player_data)
	if not config.current_config.buff_UI.filter.skills.maximum_might then
		this.list.maximum_might = nil;
		maximum_might_previous_timer_value = 0;
		return;
	end

	if not skill_data_list.maximum_might.is_equipped then
		this.list.maximum_might = nil;
		return;
	end

	local whole_body_timer = whole_body_timer_field:get_data(player_data);
	if whole_body_timer == nil then
		error_handler.report("skills.update_maximum_might", "Failed to Access Data: whole_body_timer");
		this.list.maximum_might = nil;
		return;
	end

	if player_info.list.max_stamina == -1 then
		this.list.maximum_might = nil;
		return;
	end

	local maximum_might = this.list.maximum_might;

	if player_info.list.stamina ~= player_info.list.max_stamina then
		if whole_body_timer < maximum_might_previous_timer_value then
			this.list.maximum_might = nil;
		end

	elseif maximum_might == nil then
		local maximum_might_name = this.get_skill_name("maximum_might");

		if whole_body_timer < maximum_might_previous_timer_value then
			this.list.maximum_might = buffs.new(skills_type_name, "maximum_might", maximum_might_name, 1);

		elseif utils.number.is_equal(whole_body_timer, 0) then
			if maximum_might_delay_timer == nil then
				maximum_might_delay_timer = time.new_delay_timer(function()
					maximum_might_delay_timer = nil;

					this.list.maximum_might = buffs.new(skills_type_name, "maximum_might", maximum_might_name, 1);
				end, 3.5);
			end

		else
			time.remove_delay_timer(maximum_might_delay_timer);
		end
	end

	maximum_might_previous_timer_value = whole_body_timer;

	if maximum_might ~= nil then
		maximum_might.is_visible = true;
	end
end

function this.update_bloodlust()
	if not config.current_config.buff_UI.filter.skills.bloodlust then
		this.list.bloodlust = nil;
		return;
	end

	if not skill_data_list.bloodlust.is_equipped then
		this.list.bloodlust = nil;
		return;
	end

	if not abnormal_statuses.list.frenzy_infection
	and not abnormal_statuses.list.frenzy_overcome then
		this.list.bloodlust = nil;
		return;
	end

	local bloodlust = this.list.bloodlust;
	if bloodlust == nil then
		local bloodlust_name = this.get_skill_name("bloodlust");
		if bloodlust_name == nil then
			error_handler.report("skills.update_bloodlust", "Failed to Access Data: bloodlust_name");
			this.list.bloodlust = nil;
			return;
		end

		this.list.bloodlust = buffs.new(skills_type_name, "bloodlust", bloodlust_name);
	end

	this.list.bloodlust.is_visible = true;
end

function this.update_frenzied_bloodlust(player, player_data)
	if this.apply_filter("frenzied_bloodlust") then
		return;
	end

	local hunter_wire_skill_231_num = get_hunter_wire_skill_231_num_method:call(player);
	if hunter_wire_skill_231_num == nil then
		error_handler.report("skills.update_frenzied_bloodlust", "Failed to Access Data: hunter_wire_skill_231_num");
		this.list.frenzied_bloodlust = nil;
		return;
	end

	if hunter_wire_skill_231_num == 0 then
		this.list.frenzied_bloodlust = nil;
		frenzied_bloodlust_duration = 0;
		frenzied_bloodlust_sheathed_duration = 0;
		return;
	end

	local equip_skill_231_wire_num_timer = equip_skill_231_wire_num_timer_field:get_data(player_data);
	if equip_skill_231_wire_num_timer == nil then
		error_handler.report("skills.update_frenzied_bloodlust", "Failed to Access Data: equip_skill_231_wire_num_timer");
		this.list.frenzied_bloodlust = nil;
		return;
	end

	local equip_skill_231_wp_off_timer = equip_skill_231_wp_off_timer_field:get_data(player_data);
	if equip_skill_231_wp_off_timer == nil then
		error_handler.report("skills.update_frenzied_bloodlust", "Failed to Access Data: equip_skill_231_wp_off_timer");
		this.list.frenzied_bloodlust = nil;
		return;
	end

	local is_wire_num_timer_zero = utils.number.is_equal(equip_skill_231_wire_num_timer, 0);
	if is_wire_num_timer_zero then
		this.list.frenzied_bloodlust = nil;
		return;
	end

	if equip_skill_231_wire_num_timer > frenzied_bloodlust_duration then
		frenzied_bloodlust_duration = equip_skill_231_wire_num_timer;
	end

	if equip_skill_231_wp_off_timer > frenzied_bloodlust_sheathed_duration then
		frenzied_bloodlust_sheathed_duration = equip_skill_231_wp_off_timer;
	end
	
	local is_wp_off_timer_max = utils.number.is_equal(equip_skill_231_wp_off_timer, frenzied_bloodlust_sheathed_duration);

	local timer = equip_skill_231_wire_num_timer;
	if not is_wp_off_timer_max then
		timer =	equip_skill_231_wp_off_timer;
	end

	local skill = this.update_generic("frenzied_bloodlust", 1, timer / 60);
	
	if is_wp_off_timer_max then
		skill.duration = frenzied_bloodlust_duration / 60;
	else
		skill.duration = frenzied_bloodlust_sheathed_duration / 60;
	end
end

function this.update_peak_performance()
	if not config.current_config.buff_UI.filter.skills.peak_performance then
		this.list.peak_performance = nil;
		return;
	end

	if not skill_data_list.peak_performance.is_equipped then
		this.list.peak_performance = nil;
		return;
	end

	if player_info.list.health ~= player_info.list.max_health then
		this.list.peak_performance = nil;
		return;
	end

	this.update_generic("peak_performance");
end

function this.update_heroics()
	if this.apply_filter("heroics") then
		return;
	end

	if not this.is_heroics_active then
		this.list.heroics = nil;
		return;
	end

	this.update_generic("heroics");
end

function this.update_dragonheart()
	if not config.current_config.buff_UI.filter.skills.dragonheart then
		this.list.dragonheart = nil;
		return;
	end

	if not skill_data_list.dragonheart.is_equipped then
		this.list.dragonheart = nil;
		return;
	end

	local breakpoint = dragonheart_breakpoints[skill_data_list.dragonheart.level];
	local health_percentage = 1;

	local max_health = player_info.list.max_health;

	if max_health ~= 0 then
		health_percentage = player_info.list.health / max_health;
	end

	if health_percentage > breakpoint then
		this.list.dragonheart = nil;
		return;
	end

	this.update_generic("dragonheart");
end

function this.update_resentment(player_data)
	if not config.current_config.buff_UI.filter.skills.resentment then
		this.list.resentment = nil;
		return;
	end

	if not skill_data_list.resentment.is_equipped then
		this.list.resentment = nil;
		return;
	end

	local r_vital = r_vital_field:get_data(player_data);
	if r_vital == nil then
		error_handler.report("skills.update_resentment", "Failed to Access Data: r_vital");
		this.list.resentment = nil;
		return;
	end

	if player_info.list.health >= r_vital then
		this.list.resentment = nil;
		return;
	end

	this.update_generic("resentment");
end

function this.update_bladescale_hone(player, weapon_type)
	if weapon_type ~= 13 then -- 13 = Bow
		this.list.bladescale_hone = nil;
		return;
	end

	if this.apply_filter("bladescale_hone") then
		return;
	end

	this.update_skill("bladescale_hone", nil, nil, player, _equip_skill_216_bottle_up_timer_field);
end

function this.update_spiribirds_call(player_data)
	if this.apply_filter("spiribirds_call") then
		return;
	end

	local equip_skill_211_timer = equip_skill_211_timer_field:get_data(player_data);
	if equip_skill_211_timer == nil then
		error_handler.report("skills.update_spiribirds_call", "Failed to Access Data: equip_skill_211_timer");
		this.list.spiribirds_call = nil;
		return;
	end

	if utils.number.is_equal(equip_skill_211_timer, 0) then
		this.list.spiribirds_call = nil;
		return;
	end

	local timer = spiribirds_call_duration - (equip_skill_211_timer / 60);

	this.update_generic("spiribirds_call", 1, timer);
end

function this.update_powder_mantle(player_data)
	if not this.apply_filter("powder_mantle_blue") then
		this.update_skill("powder_mantle_blue", player_data, equip_skill_227_state_field, player_data, equip_skill_227_state_timer_field, nil, 2);
	end
	
	if this.list.powder_mantle_blue ~= nil then
		this.list.powder_mantle_red = nil;
		return;
	end
	
	if this.apply_filter("powder_mantle_red") then
		return;
	end

	this.update_skill("powder_mantle_red", player_data, equip_skill_227_state_field, player_data, equip_skill_227_state_timer_field);
end

function this.update_blood_awakening(player, player_data)
	this.update_skill("blood_awakening", player, get_equip_skill_232_lv_method, player_data, equip_skill_232_timer_field, nil, nil, blood_awakening_breakpoints);
end

function this.init_all_UI()
	for skill_key, skill in pairs(this.list) do
		buffs.init_UI(skill);
	end
end

function this.init_names()
	for skill_key, skill in pairs(this.list) do
		skill.name = this.get_skill_name(skill_key);
	end
end

function this.get_skill_name(key)
	local skill_data = skill_data_list[key];
	if skill_data == nil then
		local skill_name = language.current_language.skills[key];

		if skill_name == nil then
			return key;
		end

		return skill_name;
	end

	local skill_name = get_name_method:call(nil, skill_data_list[key].id);
	if skill_name == nil then
		error_handler.report("skills.get_skill_name", string.format("Failed to Access Data: %s_name", key));
		return key;
	end

	return skill_name;
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