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
	-- Great Sword
	power_sheathe = nil,
	-- Switch Axe
	amped_state = nil,
	switch_charger = nil,
	axe_heavy_slam = nil,
	-- Long Sword
	spirit_gauge_autofill = nil, -- Soaring Kick, Iai Slash
	spirit_gauge = nil,
	harvest_moon = nil,
	-- Light Bowgun
	fanning_maneuver = nil,
	wyvernblast_reload = nil,
	-- Heavy Bowgun
	counter_charger = nil,
	rising_moon = nil,
	setting_sun = nil,
	overheat = nil,
	wyvernsnipe_reload = nil,
	-- Hammer
	impact_burst = nil,
	-- Gunlance
	ground_splitter = nil,
	erupting_cannon = nil,
	-- Lance
	anchor_rage = nil,
	spiral_thrust = nil,
	twin_wine = nil,
	-- Sword & Shield
	destroyer_oil = nil,
	-- Dual Blades
	ironshine_silk = nil,
	archdemon_mode = nil,
	-- Hunting Horn
	silkbind_shockwave = nil,
	bead_of_resonance = nil,
	sonic_bloom = nil,
	-- Charge Blade
	element_boost = nil,
	sword_boost_mode = nil,
	-- Insect Glaive
	red_extract = nil,
	white_extract = nil,
	orange_extract = nil,
	all_extracts_mix = nil,
	-- Bow
	herculean_draw = nil,
	bolt_boost = nil
};

local weapon_skill_ids = {
	-- Great Sword
	power_sheathe = nil,
	-- Switch Axe
	amped_state = nil,
	switch_charger = nil,
	axe_heavy_slam = nil,
	-- Long Sword
	spirit_gauge_autofill = nil, -- Soaring Kick, Iai Slash
	spirit_gauge = nil,
	harvest_moon = 94,
	-- Light Bowgun
	fanning_maneuver = 72,
	wyvernblast_reload = nil,
	-- Heavy Bowgun
	counter_charger = 76,
	rising_moon = 147,
	setting_sun = 149,
	overheat = nil,
	wyvernsnipe_reload = nil,
	-- Hammer
	impact_burst = 109,
	-- Gunlance
	ground_splitter = 46,
	erupting_cannon = 121,
	-- Lance
	anchor_rage = 37,
	spiral_thrust = 38,
	twin_wine = nil,
	-- Sword & Shield
	destroyer_oil = 97,
	-- Dual Blades
	ironshine_silk = 104,
	archdemon_mode = nil,
	-- Hunting Horn
	silkbind_shockwave = 114,
	bead_of_resonance = 35,
	sonic_bloom = 112,
	-- Charge Blade
	element_boost = nil,
	sword_boost_mode = nil,
	-- Insect Glaive
	red_extract = nil,
	white_extract = nil,
	orange_extract = nil,
	all_extracts_mix = nil,
	-- Bow
	herculean_draw = nil,
	bolt_boost = 154
};

--  0 Great Sword
--  1 Switch Axe
--  2 Long Sword
--  3 Light Bowgun
--  4 Heavy Bowgun
--  5 Hammer
--  6 Gunlance
--  7 Lance
--  8 Sword and Shield
--  9 Dual Blades
-- 10 Hunting Horn
-- 11 Charge Blade
-- 12 Insect Glaive
-- 13 Bow

local weapon_skills_type_name = "weapon_skills";
local previous_weapon_type = -1;

local spirit_gauge_breakpoints = {3, 2};

local wyverblast_reload_duration = 60;

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_data_method = player_manager_type_def:get_method("get_PlayerData");

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");

-- Great Sword

local great_sword_type_def = sdk.find_type_definition("snow.player.GreatSword");
-- Power Sheathe
local move_wp_off_buff_great_sword_timer_field = great_sword_type_def:get_field("MoveWpOffBuffGreatSwordTimer");
local move_wp_off_buff_set_time_field = great_sword_type_def:get_field("_MoveWpOffBuffSetTime");

-- Switch Axe

local slash_axe_type_def = sdk.find_type_definition("snow.player.SlashAxe");
-- Amped State
local get_bottle_awake_duration_timer_method = slash_axe_type_def:get_method("get_BottleAwakeDurationTimer");
local bottle_awake_duration_time_field = slash_axe_type_def:get_field("_BottleAwakeDurationTime");
-- Switch Charger
local no_use_slash_gauge_timer_field = slash_axe_type_def:get_field("_NoUseSlashGaugeTimer");
-- Axe: Heavy Slam
local bottle_awake_assist_timer_field = slash_axe_type_def:get_field("_BottleAwakeAssistTimer");


local get_ref_player_user_data_s_axe_method = slash_axe_type_def:get_method("get_RefPlayerUserDataS_Axe");

local player_user_data_slash_axe_type_def = get_ref_player_user_data_s_axe_method:get_return_type();
local  get_no_user_slash_gauge_time_method = player_user_data_slash_axe_type_def:get_method("get_NoUserSlashGaugeTime");

-- Long Sword

local long_sword_type_def = sdk.find_type_definition("snow.player.LongSword");
-- Spirit Gauge Autofill (Soaring Kick, Iai Slash)
local get_long_sword_gauge_powerup_time_method = long_sword_type_def:get_method("get_LongSwordGaugePowerUpTime");
-- Spirit Gauge
local get_long_sword_gauge_lv_method = long_sword_type_def:get_method("get_LongSwordGaugeLv");
local long_sword_gauge_lv_time_field = long_sword_type_def:get_field("_LongSwordGaugeLvTime");
local get_long_sword_gauge_lv_timer_method = long_sword_type_def:get_method("get_LongSwordGaugeLvTimer");

-- Harvest Moon
local long_sword_shell_manager_type_def = sdk.find_type_definition("snow.shell.LongSwordShellManager");
local get_master_long_sword_shell_010s_method = long_sword_shell_manager_type_def:get_method("getMaseterLongSwordShell010s");

local long_sword_shell_010_type_def = sdk.find_type_definition("snow.shell.LongSwordShell010");
local long_sword_shell_010_life_timer_field = long_sword_shell_010_type_def:get_field("_lifeTimer");

local long_sword_shell_010_list_type_def = sdk.find_type_definition("System.Collections.Generic.List`1<snow.shell.LongSwordShell010>");
local get_long_sword_shell_010_list_count_method = long_sword_shell_010_list_type_def:get_method("get_Count");
local get_long_sword_shell_010_list_item_method = long_sword_shell_010_list_type_def:get_method("get_Item");

-- Light Bowgun

local light_bowgun_type_def = sdk.find_type_definition("snow.player.LightBowgun");
-- Fanning Maneuver
local light_bowgun_wire_buff_timer_field = light_bowgun_type_def:get_field("LightBowgunWireBuffTimer");
-- Wyvernblast Reload
local wyvernblast_reload_timer_field = player_data_type_def:get_field("_WyvernBlastReloadTimer");

-- Heavy Bowgun

local heavy_bowgun_type_def = sdk.find_type_definition("snow.player.HeavyBowgun");
-- Counter Charger 
local reduce_charge_timer_field = heavy_bowgun_type_def:get_field("_ReduseChargeTimer");
local reduce_charge_timer_base_field = heavy_bowgun_type_def:get_field("_ReduseChargeTimeBase");
-- Rising Moon
local light_bowgun_shell_manager_type_def = sdk.find_type_definition("snow.shell.LightBowgunShellManager");
local get_light_bowgun_shell_030s_speed_boost_list_method = light_bowgun_shell_manager_type_def:get_method("get_getLightBowgunShell030s_SpeedBoost");

local light_bowgun_shell_030_type_def = sdk.find_type_definition("snow.shell.LightBowgunShell030");
local light_bowgun_shell_030_is_enable_hit_field = light_bowgun_shell_030_type_def:get_field("<IsEnableHit>k__BackingField");
local light_bowgun_shell_030_timer_field = light_bowgun_shell_030_type_def:get_field("_Timer");
-- Setting Sun
local get_light_bowgun_shell_030s_all_list_method = light_bowgun_shell_manager_type_def:get_method("get_getLightBowgunShell030s_All");

local light_bowgun_shell_030_list_type_def = sdk.find_type_definition("System.Collections.Generic.List`1<snow.shell.LightBowgunShell030>");
local get_light_bowgun_shell_030_list_count_method = light_bowgun_shell_030_list_type_def:get_method("get_Count");
local get_light_bowgun_shell_030_list_item_method = light_bowgun_shell_030_list_type_def:get_method("get_Item");
-- Overheat
local heavy_bowgun_overheat_timer_field = player_data_type_def:get_field("_HeavyBowgunOverHeatTimer");
-- Wyvernsnipe Reload
local heavy_bowgun_wyvern_snipe_timer_field = player_data_type_def:get_field("_HeavyBowgunWyvernSnipeTimer");


-- Hammer

local hammer_type_def = sdk.find_type_definition("snow.player.Hammer");
-- Impact Burst
local hammer_impact_pulls_timer_field = hammer_type_def:get_field("_ImpactPullsTimer");
local player_user_data_hammer_field = hammer_type_def:get_field("_PlayerUserDataHammer");

local player_user_data_hammer_type_def = player_user_data_hammer_field:get_type();
local hammer_impact_pulls_time_max_field = player_user_data_hammer_type_def:get_field("ImpactPullsTimeMax");

-- Gunlance

local gunlance_type_def = sdk.find_type_definition("snow.player.GunLance");
local get_shot_type_method = gunlance_type_def:get_method("get__ShotType");

-- Ground Splitter
local shot_damage_up_duration_timer_field = gunlance_type_def:get_field("_ShotDamageUpDurationTimer");
local get_player_user_data_gunlance_method = gunlance_type_def:get_method("GetPlayerUserDataGunLance");

local player_user_data_gunlance_type_def = get_player_user_data_gunlance_method:get_return_type();
local shot_damage_up_time_field = player_user_data_gunlance_type_def:get_field("_ShotDamageUpTime");

local explode_pile_data_normal_field = player_user_data_gunlance_type_def:get_field("_ExplodePileData_Normal");
local explode_pile_data_radiate_field = player_user_data_gunlance_type_def:get_field("_ExplodePileData_Radiate");
local explode_pile_data_spread_field = player_user_data_gunlance_type_def:get_field("_ExplodePileData_Spread");

local explode_pile_data_type_def = explode_pile_data_normal_field:get_type();
local explode_pile_data_duration_field = explode_pile_data_type_def:get_field("_Duration");

-- Erupting Cannon
local explode_pile_buff_timer_field = gunlance_type_def:get_field("_ExplodePileBuffTimer");

-- Lance

local lance_type_def = sdk.find_type_definition("snow.player.Lance");
-- Anchor Rage
local get_guard_rage_timer_method = lance_type_def:get_method("get_GuardRageTimer");
local guard_rage_buff_type_field = lance_type_def:get_field("_GuardRageBuffType");

-- Spiral Thrust
local get_ruten_timer_method = lance_type_def:get_method("get_RutenTimer");
-- Twin Wine 
local chain_death_match_shell_field = lance_type_def:get_field("_ChainDeathMatchShell");
local chain_death_match_shell_type_def = chain_death_match_shell_field:get_type();
local chain_death_match_shell_life_timer_field = chain_death_match_shell_type_def:get_field("_lifeTimer");

local player_user_data_lance_field = lance_type_def:get_field("_PlayerUserDataLance");

local player_user_data_lance_type_field = player_user_data_lance_field:get_type();
local guard_rage_timer_field = player_user_data_lance_type_field:get_field("_GuardRageTimer");

-- Sword & Shield

local short_sword_type_def = sdk.find_type_definition("snow.player.ShortSword");
-- Destroyer Oil
local get_oil_buff_timer_method = short_sword_type_def:get_method("get_OilBuffTimer");
local player_user_data_short_sword_field = short_sword_type_def:get_field("_PlayerUserDataShortSword");

local player_user_data_short_sword_type_def = player_user_data_short_sword_field:get_type();
local oil_buff_time_field = player_user_data_short_sword_type_def:get_field("OilBuffTime");

-- Dual Blades

local dual_blades_type_def = sdk.find_type_definition("snow.player.DualBlades");
-- Destroyer Oil
local get_sharpness_recovery_buff_valid_timer_method = dual_blades_type_def:get_method("get__SharpnessRecoveryBuffValidTimer");
-- Archdemon Mode
local is_kijin_kyouka_field = dual_blades_type_def:get_field("IsKijinKyouka");
local get_kijin_kyouka_gauge_method = dual_blades_type_def:get_method("get_KijinKyoukaGuage");
local player_user_data_dual_blades_field = dual_blades_type_def:get_field("_PlayerUserDataDualBlades");

local player_user_data_dual_blades_type_def = player_user_data_dual_blades_field:get_type();
local sharpness_recovery_buff_valid_max_timer_field = player_user_data_dual_blades_type_def:get_field("_SharpnessRecoveryBuffValidMaxTimer");

-- Hunting Horn

local horn_type_def = sdk.find_type_definition("snow.player.Horn");
-- Silkbind Shockwave
local horn_impact_pulls_timer_field = horn_type_def:get_field("_ImpactPullsTimer");
local player_user_data_horn_field = horn_type_def:get_field("_PlayerUserDataHorn");

local player_user_data_dual_horn_type_def = player_user_data_horn_field:get_type();
local horn_impact_pulls_duration_field = player_user_data_dual_horn_type_def:get_field("_ImpactPullsDuration");
-- Bead of Resonance
local horn_shell_manager_type_def = sdk.find_type_definition("snow.shell.HornShellManager");
local horn_shell_003s_field = horn_shell_manager_type_def:get_field("_HornShell003s");

local horn_shell_003_list_type_def = sdk.find_type_definition("System.Collections.Generic.List`1<snow.shell.HornShell003>");
local get_horn_shell_003_list_count_method = horn_shell_003_list_type_def:get_method("get_Count");
local get_horn_shell_003_list_item_method = horn_shell_003_list_type_def:get_method("get_Item");

local horn_shell_003_type_def = sdk.find_type_definition("snow.shell.HornShell003");
local horn_shell_003_life_timer_field = horn_shell_003_type_def:get_field("_lifeTimer");
-- Sonic Bloom
local get_ref_blast_speaker_shell_method = horn_type_def:get_method("get_RefBlastSpeakerShell");
local horn_shell_020_type_def = get_ref_blast_speaker_shell_method:get_return_type();
local horn_shell_020_life_timer_field = horn_shell_020_type_def:get_field("_lifeTimer");

-- Charge Blade

local charge_axe_type_def = sdk.find_type_definition("snow.player.ChargeAxe");
-- Element Boost
local shield_buff_timer_field = charge_axe_type_def:get_field("_ShieldBuffTimer");
local get_charged_bottle_num_method = charge_axe_type_def:get_method("get_ChargedBottleNum");
-- Sword Boost Mode
local sword_buff_timer_field = charge_axe_type_def:get_field("_SwordBuffTimer");

local get_ref_player_user_data_charge_axe_method = charge_axe_type_def:get_method("get_RefPlayerUserDataC_Axe");

local player_user_data_charge_axe_type_def = get_ref_player_user_data_charge_axe_method:get_return_type();
local get_sword_buff_time_method = player_user_data_charge_axe_type_def:get_method("get_SwordBuffTime");
local get_shield_buff_time_per_bottle_method = player_user_data_charge_axe_type_def:get_method("get_ShieldBuffTimePerBottle");

-- Insect Glaive

local insect_glaive_type_def = sdk.find_type_definition("snow.player.InsectGlaive");
-- All Extracts Mix
local is_get_all_extractive_method = insect_glaive_type_def:get_method("isGetAllExtractive");
local all_extractive_max_time_field = insect_glaive_type_def:get_field("AllExtractiveMaxTime");

-- Red Extract
local get_red_extractive_time_method = insect_glaive_type_def:get_method("get_RedExtractiveTime");
local red_extractive_max_time_field = insect_glaive_type_def:get_field("RedExtractiveMaxTime");
-- White Extract
local get_white_extractive_time_method = insect_glaive_type_def:get_method("get_WhiteExtractiveTime");
local white_extractive_max_time_field = insect_glaive_type_def:get_field("WhiteExtractiveMaxTime");
-- Orange Extract
local get_orange_extractive_time_method = insect_glaive_type_def:get_method("get_OrangeExtractiveTime");
local orange_extractive_max_time_field = insect_glaive_type_def:get_field("OrangeExtractiveMaxTime");

-- Bow

local bow_type_def = sdk.find_type_definition("snow.player.Bow");
local get_ref_player_user_data_bow_method = bow_type_def:get_method("get_RefPlayerUserDataBow");
-- Herculean Draw
local wire_buff_attack_up_timer_field = bow_type_def:get_field("_WireBuffAttackUpTimer");
-- Bolt Boost
local wire_buff_arrow_up_timer_field = bow_type_def:get_field("_WireBuffArrowUpTimer");

local player_user_data_bow_type_def = get_ref_player_user_data_bow_method:get_return_type();
local get_wire_buff_attack_up_time_method = player_user_data_bow_type_def:get_method("get_WireBuffAttackUpTime");
local get_arrow_up_time_method = player_user_data_bow_type_def:get_method("get_ArrowUpBufTime");


local system_array_type_def = sdk.find_type_definition("System.Array");
local get_length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

local single_type_def = sdk.find_type_definition("System.Single");
local single_mvalue_field = single_type_def:get_field("mValue");

local int32_type_def = sdk.find_type_definition("System.Int32");
local int32_mvalue_field = int32_type_def:get_field("mValue");

local data_shortcut_type_def = sdk.find_type_definition("snow.data.DataShortcut");
local get_name_method = data_shortcut_type_def:get_method("getName(snow.data.DataDef.PlWeaponActionId)");

local heavy_bowgun_shot_type_data_fields = { explode_pile_data_normal_field, explode_pile_data_radiate_field, explode_pile_data_spread_field};

function this.update(player, player_data, weapon_type)
	if weapon_type ~= previous_weapon_type then
		this.list = {};
	end

	previous_weapon_type = weapon_type;

	if weapon_type == 0 then
		this.update_great_sword_skills(player);

	elseif weapon_type == 1 then
		this.update_switch_axe_skills(player);

	elseif weapon_type == 2 then
		this.update_long_sword_skills(player);

	elseif weapon_type == 3 then
		this.update_light_bowgun_skills(player, player_data);

	elseif weapon_type == 4 then
		this.update_heavy_bowgun_skills(player, player_data);

	elseif weapon_type == 5 then
		this.update_hammer_skills(player);

	elseif weapon_type == 6 then
		this.update_gunlance_skills(player);

	elseif weapon_type == 7 then
		this.update_lance_skills(player);

	elseif weapon_type == 8 then
		this.update_sword_and_shield_skills(player);

	elseif weapon_type == 9 then
		this.update_dual_blades_skills(player);

	elseif weapon_type == 10 then
		this.update_hunting_horn_skills(player);

	elseif weapon_type == 11 then
		this.update_charge_blade_skills(player);

	elseif weapon_type == 12 then
		this.update_insect_glaive_skills(player);

	else
		this.update_bow_skills(player);
	end
end

function this.update_great_sword_skills(player)
	buffs.update_generic_buff(this.list, weapon_skills_type_name, "power_sheathe", this.get_weapon_skill_name,
		nil, nil, player, move_wp_off_buff_set_time_field, player, move_wp_off_buff_set_time_field);
end

function this.update_switch_axe_skills(player)
	local player_user_data_slash_axe = get_ref_player_user_data_s_axe_method:call(player);
	if player_user_data_slash_axe == nil then
		error_handler.report("weapon_skills.update_switch_axe_skills", "Failed to access Data: player_user_data_slash_axe");
		return;
	end

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "amped_state", this.get_weapon_skill_name,
		nil, nil, player, get_bottle_awake_duration_timer_method, player, bottle_awake_duration_time_field);

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "switch_charger", this.get_weapon_skill_name,
		nil, nil, player, no_use_slash_gauge_timer_field, player_user_data_slash_axe, get_no_user_slash_gauge_time_method);

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "axe_heavy_slam", this.get_weapon_skill_name,
		nil, nil, player, bottle_awake_assist_timer_field);
end

function this.update_long_sword_skills(player)
	buffs.update_generic_buff(this.list, weapon_skills_type_name, "spirit_gauge_autofill",  this.get_weapon_skill_name,
		nil, nil, player, get_long_sword_gauge_powerup_time_method);

	this.update_spirit_gauge(player);
	this.update_harvest_moon();
end

function this.update_spirit_gauge(player)
	local weapon_skill = buffs.update_generic_buff(this.list, weapon_skills_type_name, "spirit_gauge", this.get_weapon_skill_name,
		player, get_long_sword_gauge_lv_method, player, get_long_sword_gauge_lv_timer_method, nil, nil, false, nil, spirit_gauge_breakpoints);

	if weapon_skill == nil then
		return;
	end

	local long_sword_gauge_lv_time_array = long_sword_gauge_lv_time_field:get_data(player);
	if long_sword_gauge_lv_time_array == nil then
		error_handler.report("weapon_skills.update_spirit_gauge", "Failed to access Data: long_sword_gauge_lv_time_array");
		return;
	end

	local long_sword_gauge_lv_time_array_length = get_length_method:call(long_sword_gauge_lv_time_array);
	if long_sword_gauge_lv_time_array_length == nil then
		error_handler.report("weapon_skills.update_spirit_gauge", "Failed to access Data: long_sword_gauge_lv_time_array_length");
		return;
	end

	if weapon_skill.level >= long_sword_gauge_lv_time_array_length then
		return;
	end

	local long_sword_gauge_lv_time_single_valtype = get_value_method:call(long_sword_gauge_lv_time_array, weapon_skill.level);
	if long_sword_gauge_lv_time_single_valtype == nil then
		error_handler.report("weapon_skills.update_spirit_gauge", "Failed to access Data: long_sword_gauge_lv_time_single_valtype");
		return;
	end

	local long_sword_gauge_lv_time = single_mvalue_field:get_data(long_sword_gauge_lv_time_single_valtype);
	if long_sword_gauge_lv_time == nil then
		error_handler.report("weapon_skills.update_spirit_gauge", "Failed to access Data: long_sword_gauge_lv_time");
		return;
	end

	weapon_skill.duration = long_sword_gauge_lv_time / 60;
end

function this.update_harvest_moon()
	if singletons.long_sword_shell_manager == nil then
		error_handler.report("weapon_skills.update_harvest_moon", "Failed to access Data: long_sword_shell_manager");
		return;
	end

	local master_long_sword_shell_010_list =  get_master_long_sword_shell_010s_method:call(singletons.long_sword_shell_manager, players.myself.id);
	if master_long_sword_shell_010_list == nil then
		error_handler.report("weapon_skills.update_harvest_moon", "Failed to access Data: master_long_sword_shell_010_list");
		return;
	end

	local master_long_sword_shell_010_list_count = get_long_sword_shell_010_list_count_method:call(master_long_sword_shell_010_list);
	if master_long_sword_shell_010_list_count == nil then
		error_handler.report("weapon_skills.update_harvest_moon", "Failed to access Data: master_long_sword_shell_010_list_count");
		return;
	end

	if master_long_sword_shell_010_list_count == 0 then
		return;
	end

	local master_long_sword_shell_010 = get_long_sword_shell_010_list_item_method:call(master_long_sword_shell_010_list, 0);
	if master_long_sword_shell_010 == nil then
		error_handler.report("weapon_skills.update_harvest_moon", "Failed to access Data: master_long_sword_shell_010");
		return;
	end

	local life_timer = long_sword_shell_010_life_timer_field:get_data(master_long_sword_shell_010);
	if life_timer == nil then
		error_handler.report("weapon_skills.update_harvest_moon", "Failed to access Data: life_timer");
		return;
	end

	if utils.number.is_equal(life_timer, 0) then
		this.list.harvest_moon = nil;
		return;
	end

	buffs.update_generic(this.list, weapon_skills_type_name, "harvest_moon", this.get_weapon_skill_name, 1, life_timer);
end

function this.update_light_bowgun_skills(player, player_data)
	buffs.update_generic_buff(this.list, weapon_skills_type_name, "fanning_maneuver", this.get_weapon_skill_name,
		nil, nil, player, light_bowgun_wire_buff_timer_field);

	this.update_wyvernblast_reload(player_data);
end

function this.update_wyvernblast_reload(player_data)
	local wyvernblast_reload_timer = wyvernblast_reload_timer_field:get_data(player_data);
	if wyvernblast_reload_timer == nil then
		error_handler.report("weapon_skills.update_wyvernblast_reload", "Failed to access Data: heavy_bowgun_overheat_timer_field");
		return;
	end

	if wyvernblast_reload_timer <= 1 then
		this.list.wyvernblast_reload = nil;
		return;
	end

	local timer = wyverblast_reload_duration - (wyvernblast_reload_timer / 60);

	buffs.update_generic(this.list, weapon_skills_type_name, "wyvernblast_reload", this.get_weapon_skill_name, 1, timer);
end

function this.update_heavy_bowgun_skills(player, player_data)
	buffs.update_generic_buff(this.list, weapon_skills_type_name, "counter_charger", this.get_weapon_skill_name,
		nil, nil, player, reduce_charge_timer_field, player, reduce_charge_timer_base_field);

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "wyvernsnipe_reload", this.get_weapon_skill_name,
		nil, nil, player_data, heavy_bowgun_wyvern_snipe_timer_field);

	this.update_rising_moon();
	this.update_setting_sun();
	this.update_overheat(player_data);
end

function this.update_rising_moon()
	if singletons.light_bowgun_shell_manager == nil then
		error_handler.report("weapon_skills.update_rising_moon", "Failed to access Data: light_bowgun_shell_manager");
		return;
	end

	local light_bowgun_shell_030s_speed_boost_list =  get_light_bowgun_shell_030s_speed_boost_list_method:call(singletons.light_bowgun_shell_manager);
	if light_bowgun_shell_030s_speed_boost_list == nil then
		error_handler.report("weapon_skills.update_rising_moon", "Failed to access Data: light_bowgun_shell_030s_speed_boost_list");
		return;
	end

	local light_bowgun_shell_030_speed_boost_list_count = get_light_bowgun_shell_030_list_count_method:call(light_bowgun_shell_030s_speed_boost_list);
	if light_bowgun_shell_030_speed_boost_list_count == nil then
		error_handler.report("weapon_skills.update_rising_moon", "Failed to access Data: light_bowgun_shell_030_speed_boost_list_count");
		return;
	end

	if light_bowgun_shell_030_speed_boost_list_count == 0 then
		this.list.rising_moon = nil;
		return;
	end

	-- Possibly requires players.myself.id instead of 0?
	local light_bowgun_shell_030 = get_light_bowgun_shell_030_list_item_method:call(light_bowgun_shell_030s_speed_boost_list, 0);
	if light_bowgun_shell_030 == nil then
		error_handler.report("weapon_skills.update_rising_moon", "Failed to access Data: light_bowgun_shell_030");
		return;
	end

	local is_hit_enable = light_bowgun_shell_030_is_enable_hit_field:get_data(light_bowgun_shell_030);
	if is_hit_enable == nil then
		error_handler.report("weapon_skills.update_rising_moon", "Failed to access Data: is_hit_enable");
		return;
	end

	if not is_hit_enable then
		this.list.rising_moon = nil;
		return;
	end

	local timer = light_bowgun_shell_030_timer_field:get_data(light_bowgun_shell_030);
	if timer == nil then
		error_handler.report("weapon_skills.update_rising_moon", "Failed to access Data: timer");
		return;
	end

	if utils.number.is_equal(timer, 0) then
		this.list.rising_moon = nil;
		return;
	end

	buffs.update_generic(this.list, weapon_skills_type_name, "rising_moon", this.get_weapon_skill_name, 1, timer);
end

function this.update_setting_sun()
	if singletons.light_bowgun_shell_manager == nil then
		error_handler.report("weapon_skills.update_setting_sun", "Failed to access Data: light_bowgun_shell_manager");
		return;
	end

	local light_bowgun_shell_030s_all_list =  get_light_bowgun_shell_030s_all_list_method:call(singletons.light_bowgun_shell_manager);
	if light_bowgun_shell_030s_all_list == nil then
		error_handler.report("weapon_skills.update_setting_sun", "Failed to access Data: light_bowgun_shell_030s_all_list");
		return;
	end

	local light_bowgun_shell_030_all_list_count = get_light_bowgun_shell_030_list_count_method:call(light_bowgun_shell_030s_all_list);
	if light_bowgun_shell_030_all_list_count == nil then
		error_handler.report("weapon_skills.update_setting_sun", "Failed to access Data: light_bowgun_shell_030_all_list_count");
		return;
	end

	local min_count = 1;
	if this.list.rising_moon ~= nil then
		min_count = 2;
	end

	if light_bowgun_shell_030_all_list_count < min_count then
		this.list.setting_sun = nil;
		return;
	end

	-- Possibly requires players.myself.id instead of 0?
	local light_bowgun_shell_030 = get_light_bowgun_shell_030_list_item_method:call(light_bowgun_shell_030s_all_list, 0);
	if light_bowgun_shell_030 == nil then
		error_handler.report("weapon_skills.update_setting_sun", "Failed to access Data: light_bowgun_shell_030");
		return;
	end

	local is_hit_enable = light_bowgun_shell_030_is_enable_hit_field:get_data(light_bowgun_shell_030);
	if is_hit_enable == nil then
		error_handler.report("weapon_skills.update_setting_sun", "Failed to access Data: is_hit_enable");
		return;
	end

	if not is_hit_enable then
		this.list.setting_sun = nil;
		return;
	end

	local timer = light_bowgun_shell_030_timer_field:get_data(light_bowgun_shell_030);
	if timer == nil then
		error_handler.report("weapon_skills.update_setting_sun", "Failed to access Data: timer");
		return;
	end

	if utils.number.is_equal(timer, 0) then
		this.list.setting_sun = nil;
		return;
	end

	buffs.update_generic(this.list, weapon_skills_type_name, "setting_sun", this.get_weapon_skill_name, 1, timer);
end

function this.update_overheat(player_data)
	local heavy_bowgun_overheat_timer = heavy_bowgun_overheat_timer_field:get_data(player_data);
	if heavy_bowgun_overheat_timer_field == nil then
		error_handler.report("weapon_skills.update_overheat", "Failed to access Data: heavy_bowgun_overheat_timer_field");
		return;
	end

	if heavy_bowgun_overheat_timer <= 1 then
		this.list.overheat = nil;
		return;
	end

	buffs.update_generic(this.list, weapon_skills_type_name, "overheat", this.get_weapon_skill_name, 1, heavy_bowgun_overheat_timer);
end

function this.update_hammer_skills(player)
	local player_user_data_hammer = player_user_data_hammer_field:get_data(player);
	if player_user_data_hammer == nil then
		error_handler.report("weapon_skills.update_hammer_skills", "Failed to access Data: player_user_data_hammer");
		return;
	end

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "impact_burst", this.get_weapon_skill_name,
		nil, nil, player, horn_impact_pulls_timer_field, player_user_data_hammer, hammer_impact_pulls_time_max_field);
end

function this.update_gunlance_skills(player)
	local player_user_data_gunlance = get_player_user_data_gunlance_method:call(player);
	if player_user_data_gunlance == nil then
		error_handler.report("weapon_skills.update_gunlance_skills", "Failed to access Data: player_user_data_gunlance");
		return;
	end

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "ground_splitter", this.get_weapon_skill_name,
		nil, nil, player, shot_damage_up_duration_timer_field, player_user_data_gunlance, get_player_user_data_gunlance_method);

	this.update_erupting_cannon(player, player_user_data_gunlance);
end

function this.update_erupting_cannon(player, player_user_data_gunlance)
	local shot_type = get_shot_type_method:call(player);
	if shot_type == nil then
		error_handler.report("weapon_skills.update_erupting_cannon", "Failed to access Data: shot_type");
		return;
	end

	local explode_pile_data = heavy_bowgun_shot_type_data_fields[shot_type + 1]:get_data(player_user_data_gunlance);
	if explode_pile_data == nil then
		error_handler.report("weapon_skills.update_erupting_cannon", "Failed to access Data: explode_pile_data");
		return;
	end

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "erupting_cannon", this.get_weapon_skill_name,
		nil, nil, player, explode_pile_buff_timer_field, explode_pile_data, explode_pile_data_duration_field);
end

function this.update_lance_skills(player)
	buffs.update_generic_buff(this.list, weapon_skills_type_name, "spiral_thrust", this.get_weapon_skill_name,
		nil, nil, player, get_ruten_timer_method);

	this.update_anchor_rage(player);
	this.update_twin_wine(player);
end

function this.update_anchor_rage(player)
	local guard_rage_buff_type = guard_rage_buff_type_field:get_data(player);
	if guard_rage_buff_type == nil then
		error_handler.report("weapon_skills.update_anchor_rage", "Failed to access Data: guard_rage_buff_type");
		return;
	end

	if guard_rage_buff_type == 0 then
		this.anchor_rage = nil;
		return;
	end

	local player_user_data_lance = player_user_data_lance_field:get_data(player);
	if player_user_data_lance == nil then
		error_handler.report("weapon_skills.update_anchor_rage", "Failed to access Data: player_user_data_lance");
		return;
	end

	local guard_rage_timer_array = guard_rage_timer_field:get_data(player_user_data_lance);
	if guard_rage_timer_array == nil then
		error_handler.report("weapon_skills.update_anchor_rage", "Failed to access Data: guard_rage_timer_array");
		return;
	end

	local guard_rage_timer_array_length = get_length_method:call(guard_rage_timer_array);
	if guard_rage_timer_array_length == nil then
		error_handler.report("weapon_skills.update_anchor_rage", "Failed to access Data: guard_rage_timer_array_length");
		return;
	end

	if guard_rage_buff_type >= guard_rage_timer_array_length then
		this.anchor_rage = nil;
		return;
	end

	local guard_rage_duration_valtype = get_value_method:call(guard_rage_timer_array, guard_rage_buff_type);
	if guard_rage_duration_valtype == nil then
		error_handler.report("weapon_skills.update_anchor_rage", "Failed to access Data: guard_rage_duration_valtype");
		return;
	end

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "anchor_rage", this.get_weapon_skill_name,
		nil, nil, player, get_guard_rage_timer_method, guard_rage_duration_valtype, single_mvalue_field);
end

function this.update_twin_wine(player)
	local chain_death_match_shell = chain_death_match_shell_field:get_data(player);
	if chain_death_match_shell == nil then
		error_handler.report("weapon_skills.update_twin_wine", "Failed to access Data: chain_death_match_shell");
		return;
	end

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "twin_wine", this.get_weapon_skill_name,
		nil, nil, chain_death_match_shell, chain_death_match_shell_life_timer_field);
end

function this.update_sword_and_shield_skills(player)
	local player_user_data_short_sword = player_user_data_short_sword_field:get_data(player);
	if player_user_data_short_sword == nil then
		error_handler.report("weapon_skills.update_sword_and_shield_skills", "Failed to access Data: player_user_data_short_sword");
		return;
	end

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "destroyer_oil", this.get_weapon_skill_name,
		nil, nil, player, get_oil_buff_timer_method, player_user_data_short_sword, oil_buff_time_field);
end

function this.update_dual_blades_skills(player)
	this.update_archdemon_mode(player)

	local player_user_data_dual_blades = player_user_data_dual_blades_field:get_data(player);
	if player_user_data_dual_blades == nil then
		error_handler.report("weapon_skills.update_dual_blades_skills", "Failed to access Data: player_user_data_dual_blades");
		return;
	end

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "ironshine_silk", this.get_weapon_skill_name,
		nil, nil, player,
		get_sharpness_recovery_buff_valid_timer_method,
		player_user_data_dual_blades, sharpness_recovery_buff_valid_max_timer_field);
end

function this.update_archdemon_mode(player)
	local is_kijin_kyouka = is_kijin_kyouka_field:get_data(player);
	if is_kijin_kyouka == nil then
		error_handler.report("weapon_skills.update_archdemon_mode", "Failed to access Data: is_kijin_kyouka");
		return;
	end

	if not is_kijin_kyouka then
		this.list.archdemon_mode = nil;
		return;
	end

	local kijin_kyouka_gauge = get_kijin_kyouka_gauge_method:call(player);
	if kijin_kyouka_gauge == nil then
		error_handler.report("weapon_skills.update_archdemon_mode", "Failed to access Data: kijin_kyouka_gauge");
		return;
	end

	if utils.number.is_equal(kijin_kyouka_gauge, 0) then
		this.list.archdemon_mode = nil;
		return;
	end

	buffs.update_generic(this.list, weapon_skills_type_name, "archdemon_mode", this.get_weapon_skill_name, 1, kijin_kyouka_gauge);
end

function this.update_hunting_horn_skills(player)
	this.update_bead_of_resonance();
	this.update_sonic_bloom(player);

	local player_user_data_horn = player_user_data_horn_field:get_data(player);
	if player_user_data_horn == nil then
		error_handler.report("weapon_skills.update_hunting_horn_skills", "Failed to access Data: player_user_data_horn");
		return;
	end

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "silkbind_shockwave", this.get_weapon_skill_name,
		nil, nil, player, horn_impact_pulls_timer_field, player_user_data_horn, horn_impact_pulls_duration_field);
end

function this.update_bead_of_resonance()
	if singletons.horn_shell_manager == nil then
		error_handler.report("weapon_skills.update_bead_of_resonance", "Failed to access Data: horn_shell_manager");
		return;
	end

	local horn_shell_003s_array = horn_shell_003s_field:get_data(singletons.horn_shell_manager);
	if horn_shell_003s_array == nil then
		error_handler.report("weapon_skills.update_bead_of_resonance", "Failed to access Data: horn_shell_003s_list");
		return;
	end

	local horn_shell_003s_array_length = get_length_method:call(horn_shell_003s_array);
	if horn_shell_003s_array_length == nil then
		error_handler.report("weapon_skills.update_bead_of_resonance", "Failed to access Data: horn_shell_003s_array_length");
		return;
	end

	if players.myself.id >= horn_shell_003s_array_length then
		this.list.bead_of_resonance = nil;
		return;
	end

	local horn_shell_003_list = get_value_method:call(horn_shell_003s_array, players.myself.id);
	if horn_shell_003_list == nil then
		error_handler.report("weapon_skills.update_bead_of_resonance", "Failed to access Data: horn_shell_003_list");
		return;
	end

	local horn_shell_003_list_count = get_horn_shell_003_list_count_method:call(horn_shell_003_list);
	if horn_shell_003_list_count == nil then
		error_handler.report("weapon_skills.update_bead_of_resonance", "Failed to access Data: horn_shell_003_list_count");
		return;
	end

	if horn_shell_003_list_count == 0 then
		this.list.bead_of_resonance = nil;
		return;
	end

	local horn_shell_003 = get_horn_shell_003_list_item_method:call(horn_shell_003_list, 0);
	if horn_shell_003 == nil then
		error_handler.report("weapon_skills.update_bead_of_resonance", "Failed to access Data: horn_shell_003");
		return;
	end

	local life_timer = horn_shell_003_life_timer_field:get_data(horn_shell_003);
	if life_timer == nil then
		error_handler.report("weapon_skills.update_bead_of_resonance", "Failed to access Data: life_timer");
		return;
	end

	if utils.number.is_equal(life_timer, 0) then
		this.list.bead_of_resonance = nil;
		return;
	end

	buffs.update_generic(this.list, weapon_skills_type_name, "bead_of_resonance", this.get_weapon_skill_name, 1, life_timer);
end

function this.update_sonic_bloom(player)
	local blast_speaker_shell = get_ref_blast_speaker_shell_method:call(player);
	if blast_speaker_shell == nil then
		this.list.bead_of_resonance = nil;
		return;
	end

	local life_timer = horn_shell_020_life_timer_field:get_data(blast_speaker_shell);
	if life_timer == nil then
		error_handler.report("weapon_skills.update_sonic_bloom", "Failed to access Data: life_timer");
		return;
	end

	if utils.number.is_equal(life_timer, 0) then
		this.list.bead_of_resonance = nil;
		return;
	end

	buffs.update_generic(this.list, weapon_skills_type_name, "sonic_bloom", this.get_weapon_skill_name, 1, life_timer);
end

function this.update_charge_blade_skills(player)
	local player_user_data_charge_axe = get_ref_player_user_data_charge_axe_method:call(player);
	if player_user_data_charge_axe == nil then
		error_handler.report("weapon_skills.update_sonic_bloom", "Failed to access Data: life_timer");
		return;
	end

	this.update_element_boost(player, player_user_data_charge_axe);
	this.update_sword_boost_mode(player, player_user_data_charge_axe);
end

function this.update_element_boost(player, player_user_data_charge_axe)
	local shield_buff_timer = shield_buff_timer_field:get_data(player);
	if shield_buff_timer == nil then
		error_handler.report("weapon_skills.update_element_boost", "Failed to access Data: shield_buff_timer");
		return;
	end

	if utils.number.is_equal(shield_buff_timer, 0) then
		this.list.element_boost = nil;
		return;
	end

	shield_buff_timer = shield_buff_timer / 60;

	local duration = nil;
	if this.list.element_boost == nil then
		local shield_buff_time_per_bottle = get_shield_buff_time_per_bottle_method:call(player_user_data_charge_axe);
		if shield_buff_time_per_bottle == nil then
			error_handler.report("weapon_skills.update_element_boost", "Failed to access Data: shield_buff_time_duration");
			return;
		end

		local bottle_num = get_charged_bottle_num_method:call(player);
		if bottle_num == nil then
			error_handler.report("weapon_skills.update_element_boost", "Failed to access Data: bottle_num");
			return;
		end

		if bottle_num ~= 0 then
			duration = (bottle_num * shield_buff_time_per_bottle) / 60;
		else
			duration = shield_buff_timer;
		end
	end

	buffs.update_generic(this.list, weapon_skills_type_name, "element_boost", this.get_weapon_skill_name, 1, shield_buff_timer, duration);
end

function this.update_sword_boost_mode(player, player_user_data_charge_axe)
	local sword_buff_timer = sword_buff_timer_field:get_data(player);
	if sword_buff_timer == nil then
		error_handler.report("weapon_skills.update_sword_boost_mode", "Failed to access Data: sword_buff_timer");
		return;
	end

	if utils.number.is_equal(sword_buff_timer, 0) then
		this.list.sword_boost_mode = nil;
		return;
	end

	local sword_buff_time_duration = get_sword_buff_time_method:call(player_user_data_charge_axe);
	if sword_buff_time_duration == nil then
		error_handler.report("weapon_skills.update_sword_boost_mode", "Failed to access Data: sword_buff_time_duration");
		return;
	end

	buffs.update_generic(this.list, weapon_skills_type_name, "sword_boost_mode", this.get_weapon_skill_name, 1,
		sword_buff_timer / 60, sword_buff_time_duration / 60);
end

function this.update_insect_glaive_skills(player)
	this.update_all_extracts_mix(player);

	if this.list.all_extracts_mix ~= nil then
		this.list.red_extract = nil;
		this.list.white_extract = nil;
		this.list.orange_extract = nil;
		return;
	end

	this.update_extract(player, "red_extract", get_red_extractive_time_method, red_extractive_max_time_field);
	this.update_extract(player, "white_extract", get_white_extractive_time_method, white_extractive_max_time_field);
	this.update_extract(player, "orange_extract", get_orange_extractive_time_method, orange_extractive_max_time_field);
end

function this.update_all_extracts_mix(player)
	local is_get_all_extractive = is_get_all_extractive_method:call(player);
	if is_get_all_extractive == nil then
		error_handler.report("weapon_skills.update_all_extracts_mix", "Failed to access Data: is_get_all_extractive");
		return;
	end

	if not is_get_all_extractive then
		this.list.all_extracts_mix = nil;
		return;
	end

	local red_extractive_time = get_red_extractive_time_method:call(player);
	if red_extractive_time == nil then
		error_handler.report("weapon_skills.update_all_extracts_mix", "Failed to access Data: red_extractive_time");
		return;
	end

	if utils.number.is_equal(red_extractive_time, 0) then
		this.list.all_extracts_mix = nil;
		return;
	end

	local all_extractive_max_time = all_extractive_max_time_field:get_data(player);
	if all_extractive_max_time == nil then
		error_handler.report("weapon_skills.update_all_extract", "Failed to access Data: all_extractive_max_time");
		return;
	end

	buffs.update_generic(this.list, weapon_skills_type_name, "all_extracts_mix", this.get_weapon_skill_name, 1,
		red_extractive_time, all_extractive_max_time);
end

function this.update_extract(player, extract_key, time_holder, max_time_holder)
	local extractive_time = time_holder:call(player);
	if extractive_time == nil then
		error_handler.report("weapon_skills.update_extract", string.format("Failed to access Data: %s_extractive_time", extract_key));
		return;
	end

	if utils.number.is_equal(extractive_time, 0) then
		this.list[extract_key] = nil;
		return;
	end

	local duration = nil;

	local extractive_max_time_array = max_time_holder:get_data(player);
	if extractive_max_time_array == nil then
		error_handler.report("weapon_skills.update_red_extract", string.format("Failed to access Data: %s_extractive_max_time_array", extract_key));
		return;
	end

	local extractive_max_time_array_length = get_length_method:call(extractive_max_time_array);
	if extractive_max_time_array_length == nil then
		error_handler.report("weapon_skills.update_red_extract", string.format("Failed to access Data: %s_extractive_max_time_array_length", extract_key));
		return;
	end

	if extractive_max_time_array_length ~= 0 then
		local extractive_max_time_int32_valtype = get_value_method:call(extractive_max_time_array, 0);
		if extractive_max_time_int32_valtype == nil then
			error_handler.report("weapon_skills.update_red_extract", string.format("Failed to access Data: %s_extractive_max_time_int32_valtype", extract_key));
			return;
		end

		local extractive_max_time = int32_mvalue_field:get_data(extractive_max_time_int32_valtype);
		if extractive_max_time == nil then
			error_handler.report("weapon_skills.update_red_extract", string.format("Failed to access Data: %s_extractive_max_time", extract_key));
			return;
		end

		duration = extractive_max_time;
	end

	buffs.update_generic(this.list, weapon_skills_type_name, extract_key, this.get_weapon_skill_name, 1, extractive_time, duration);
end

function this.update_bow_skills(player)
	local player_user_data_bow = get_ref_player_user_data_bow_method:call(player);
	if player_user_data_bow == nil then
		error_handler.report("weapon_skills.update_extract", "Failed to access Data: player_user_data_bow");
		return;
	end

	this.update_bow_skill(player, "herculean_draw", wire_buff_attack_up_timer_field, player_user_data_bow, get_wire_buff_attack_up_time_method);
	this.update_bow_skill(player, "bolt_boost", wire_buff_arrow_up_timer_field, player_user_data_bow, get_arrow_up_time_method);
end

function this.update_bow_skill(player, bow_skill_key, timer_holder, player_user_data_bow, max_time_holder)
	local timer = timer_holder:get_data(player);
	if timer == nil then
		error_handler.report("weapon_skills.update_bow_skill", string.format("Failed to access Data: %s_timer", bow_skill_key));
		return;
	end

	if utils.number.is_equal(timer, 0) then
		this.list[bow_skill_key] = nil;
		return;
	end

	local max_time = max_time_holder:call(player_user_data_bow);
	if max_time == nil then
		error_handler.report("weapon_skills.update_bow_skill", string.format("Failed to access Data: %s_max_time", bow_skill_key));
		return;
	end

	buffs.update_generic(this.list, weapon_skills_type_name, bow_skill_key, this.get_weapon_skill_name, 1, timer / 60, max_time / 60);
end

function this.init_names()
	for weapon_skill_key, weapon_skill in pairs(this.list) do
		weapon_skill.name = this.get_weapon_skill_name(weapon_skill_key);
	end
end

function this.get_weapon_skill_name(weapon_skill_key)
	if weapon_skill_ids[weapon_skill_key] == nil then
		
		local weapon_skill_name = language.current_language.weapon_skills[weapon_skill_key];
		if weapon_skill_name == nil then
			return weapon_skill_key;
		end

		return weapon_skill_name;
	end

	local weapon_skill_name = get_name_method:call(nil, weapon_skill_ids[weapon_skill_key]);
	if weapon_skill_name == nil then
		error_handler.report("weapon_skills.get_weapon_skill_name", string.format("Failed to access Data: %s_name", weapon_skill_key));
		return weapon_skill_key;
	end

	return weapon_skill_name;
	
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