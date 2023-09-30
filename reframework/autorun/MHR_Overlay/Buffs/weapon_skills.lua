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
	-- Long Sword
	spirit_gauge_autofill = nil, -- Soaring Kick, Iai Slash
	spirit_gauge = nil,
	harvest_moon = nil,
	-- Sword & Shield
	destroyer_oil = nil,
	-- Dual Blades
	ironshine_silk = nil,
	archdemon_mode = nil,
	-- Lance
	anchor_rage = nil,
	spiral_thrust = nil,
	twin_wine = nil,
	-- Gunlance
	ground_splitter = nil,
	erupting_cannon = nil,
	-- Hammer
	impact_burst = nil,
	-- Hunting Horn
	silkbind_shockwave = nil,
	bead_of_resonance = nil,
	sonic_bloom = nil,
	-- Switch Axe
	amped_state = nil,
	switch_charger = nil,
	axe_heavy_slam = nil,
	-- Charge Blade
	element_boost = nil,
	sword_boost_mode = nil,
	-- Insect Glaive
	red_extract = nil,
	white_extract = nil,
	orange_extract = nil,
	all_extracts_mix = nil,
	-- Light Bowgun
	fanning_maneuver = nil,
	wyvernblast_reload = nil,
	-- Heavy Bowgun
	counter_charger = nil,
	rising_moon = nil,
	setting_sun = nil,
	overheat = nil,
	wyvernsnipe_reload = nil,
	-- Bow
	herculean_draw = nil,
	bolt_boost = nil,
	arc_shot_affinity = nil,
	arc_shot_brace = nil
};

this.keys = {
	-- Great Sword
	{
		key = "great_sword",
		skill_keys = {
			"power_sheathe"
		}
	},
	-- Long Sword
	{
		key = "long_sword",
		skill_keys = {
			"spirit_gauge_autofill", -- Soaring Kick, Iai Slash
			"spirit_gauge",
			"harvest_moon"
		}
	},
	-- Sword & Shield
	{
		key = "sword_and_shield",
		skill_keys = {
			"destroyer_oil"
		}
	},
	-- Dual Blades
	{
		key = "dual_blades",
		skill_keys = {
			"ironshine_silk",
			"archdemon_mode"
		}
	},
	-- Lance
	{
		key = "lance",
		skill_keys = {
			"anchor_rage",
			"spiral_thrust",
			"twin_wine"
		}
	},
	-- Gunlance
	{
		key = "gunlance",
		skill_keys = {
			"ground_splitter",
			"erupting_cannon"
		}
	},
	-- Hammer
	{
		key = "hammer",
		skill_keys = {
			"impact_burst"
		}
	},
	-- Hunting Horn
	{
		key = "hunting_horn",
		skill_keys = {
			"silkbind_shockwave",
			"bead_of_resonance",
			"sonic_bloom"
		}
	},
	-- Switch Axe
	{
		key = "switch_axe",
		skill_keys = {
			"amped_state",
			"switch_charger",
			"axe_heavy_slam"
		}
	},
	-- Charge Blade
	{
		key = "charge_blade",
		skill_keys = {
			"element_boost",
			"sword_boost_mode"
		}
	},
	-- Insect Glaive
	{
		key = "insect_glaive",
		skill_keys = {
			"red_extract",
			"white_extract",
			"orange_extract",
			"all_extracts_mix"
		}
	},
	-- Light Bowgun
	{
		key = "light_bowgun",
		skill_keys = {
			"fanning_maneuver",
			"wyvernblast_reload"
		}
	},
	-- Heavy Bowgun
	{
		key = "heavy_bowgun",
		skill_keys = {
			"counter_charger",
			"rising_moon",
			"setting_sun",
			"overheat",
			"wyvernsnipe_reload"
		}
	},
	-- Bow
	{
		key = "bow",
		skill_keys = {
			"herculean_draw",
			"bolt_boost",
			"arc_shot_affinity",
			"arc_shot_brace"
		}
	}
};

local weapon_skill_ids = {
	-- Great Sword
	power_sheathe = nil,
	-- Long Sword
	soaring_kick = 9,
	spirit_gauge_autofill = nil, -- Soaring Kick, Iai Slash
	spirit_gauge = nil,
	harvest_moon = 94,
	-- Sword & Shield
	destroyer_oil = 97,
	-- Dual Blades
	ironshine_silk = 104,
	archdemon_mode = nil,
	-- Lance
	anchor_rage = 37,
	spiral_thrust = 38,
	twin_wine = nil,
	-- Gunlance
	ground_splitter = 46,
	erupting_cannon = 121,
	-- Hammer
	impact_burst = 109,
	-- Hunting Horn
	silkbind_shockwave = 114,
	bead_of_resonance = 35,
	sonic_bloom = 112,
	-- Switch Axe
	amped_state = nil,
	switch_charger = nil,
	axe_heavy_slam = nil,
	-- Charge Blade
	element_boost = nil,
	sword_boost_mode = nil,
	-- Insect Glaive
	red_extract = nil,
	white_extract = nil,
	orange_extract = nil,
	all_extracts_mix = nil,
	-- Light Bowgun
	fanning_maneuver = 72,
	wyvernblast_reload = nil,
	-- Heavy Bowgun
	counter_charger = 76,
	rising_moon = 147,
	setting_sun = 149,
	overheat = nil,
	wyvernsnipe_reload = nil,
	-- Bow
	herculean_draw = nil,
	bolt_boost = 154
};

local weapon_skill_type_name = "weapon_skills";
--  0 Great Sword
local great_sword_type_name = "great_sword";
--  1 Switch Axe
local switch_axe_type_name = "switch_axe";
--  2 Long Sword
local long_sword_type_name = "long_sword";
--  3 Light Bowgun
local light_bowgun_type_name = "light_bowgun";
--  4 Heavy Bowgun
local heavy_bowgun_type_name = "heavy_bowgun";
--  5 Hammer
local hammer_type_name = "hammer";
--  6 Gunlance
local gunlance_type_name = "gunlance";
--  7 Lance
local lance_type_name = "lance";
--  8 Sword and Shield
local sword_and_shield_type_name = "sword_and_shield";
--  9 Dual Blades
local dual_blades_type_name = "dual_blades";
-- 10 Hunting Horn
local hunting_horn_type_name = "hunting_horn";
-- 11 Charge Blade
local charge_blade_type_name = "charge_blade";
-- 12 Insect Glaive
local insect_glaive_type_name = "insect_glaive";
-- 13 Bow
local bow_type_name = "bow";

local previous_weapon_type = -1;

local spirit_gauge_breakpoints = {3, 2};

local wyverblast_reload_duration = 60;

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");

-- Great Sword

local great_sword_type_def = sdk.find_type_definition("snow.player.GreatSword");
-- Power Sheathe
local move_wp_off_buff_great_sword_timer_field = great_sword_type_def:get_field("MoveWpOffBuffGreatSwordTimer");

-- Switch Axe

local slash_axe_type_def = sdk.find_type_definition("snow.player.SlashAxe");
-- Amped State
local get_bottle_awake_duration_timer_method = slash_axe_type_def:get_method("get_BottleAwakeDurationTimer");
-- Switch Charger
local no_use_slash_gauge_timer_field = slash_axe_type_def:get_field("_NoUseSlashGaugeTimer");
-- Axe: Heavy Slam
local bottle_awake_assist_timer_field = slash_axe_type_def:get_field("_BottleAwakeAssistTimer");

-- Long Sword

local long_sword_type_def = sdk.find_type_definition("snow.player.LongSword");
-- Spirit Gauge Autofill (Soaring Kick, Iai Slash)
local get_long_sword_gauge_powerup_time_method = long_sword_type_def:get_method("get_LongSwordGaugePowerUpTime");
-- Spirit Gauge
local get_long_sword_gauge_lv_method = long_sword_type_def:get_method("get_LongSwordGaugeLv");
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

-- Gunlance

local gunlance_type_def = sdk.find_type_definition("snow.player.GunLance");
-- Ground Splitter
local shot_damage_up_duration_timer_field = gunlance_type_def:get_field("_ShotDamageUpDurationTimer");
local get_player_user_data_gunlance_method = gunlance_type_def:get_method("GetPlayerUserDataGunLance");

local player_user_data_gunlance_type_def = get_player_user_data_gunlance_method:get_return_type();

local explode_pile_data_normal_field = player_user_data_gunlance_type_def:get_field("_ExplodePileData_Normal");
local explode_pile_data_radiate_field = player_user_data_gunlance_type_def:get_field("_ExplodePileData_Radiate");
local explode_pile_data_spread_field = player_user_data_gunlance_type_def:get_field("_ExplodePileData_Spread");

-- Erupting Cannon
local explode_pile_buff_timer_field = gunlance_type_def:get_field("_ExplodePileBuffTimer");

-- Lance

local lance_type_def = sdk.find_type_definition("snow.player.Lance");
-- Anchor Rage
local get_guard_rage_timer_method = lance_type_def:get_method("get_GuardRageTimer");

-- Spiral Thrust
local get_ruten_timer_method = lance_type_def:get_method("get_RutenTimer");
-- Twin Wine 
local chain_death_match_shell_field = lance_type_def:get_field("_ChainDeathMatchShell");
local chain_death_match_shell_type_def = chain_death_match_shell_field:get_type();
local chain_death_match_shell_life_timer_field = chain_death_match_shell_type_def:get_field("_lifeTimer");

-- Sword & Shield

local short_sword_type_def = sdk.find_type_definition("snow.player.ShortSword");
-- Destroyer Oil
local get_oil_buff_timer_method = short_sword_type_def:get_method("get_OilBuffTimer");

-- Dual Blades

local dual_blades_type_def = sdk.find_type_definition("snow.player.DualBlades");
-- Destroyer Oil
local get_sharpness_recovery_buff_valid_timer_method = dual_blades_type_def:get_method("get__SharpnessRecoveryBuffValidTimer");
-- Archdemon Mode
local is_kijin_kyouka_field = dual_blades_type_def:get_field("IsKijinKyouka");
local get_kijin_kyouka_gauge_method = dual_blades_type_def:get_method("get_KijinKyoukaGuage");

-- Hunting Horn

local horn_type_def = sdk.find_type_definition("snow.player.Horn");
-- Silkbind Shockwave
local horn_impact_pulls_timer_field = horn_type_def:get_field("_ImpactPullsTimer");

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
-- Sword Boost Mode
local sword_buff_timer_field = charge_axe_type_def:get_field("_SwordBuffTimer");

-- Insect Glaive

local insect_glaive_type_def = sdk.find_type_definition("snow.player.InsectGlaive");
-- All Extracts Mix
local is_get_all_extractive_method = insect_glaive_type_def:get_method("isGetAllExtractive");

-- Red Extract
local get_red_extractive_time_method = insect_glaive_type_def:get_method("get_RedExtractiveTime");
-- White Extract
local get_white_extractive_time_method = insect_glaive_type_def:get_method("get_WhiteExtractiveTime");
-- Orange Extract
local get_orange_extractive_time_method = insect_glaive_type_def:get_method("get_OrangeExtractiveTime");

-- Bow

local bow_type_def = sdk.find_type_definition("snow.player.Bow");
-- Herculean Draw
local wire_buff_attack_up_timer_field = bow_type_def:get_field("_WireBuffAttackUpTimer");
-- Bolt Boost
local wire_buff_arrow_up_timer_field = bow_type_def:get_field("_WireBuffArrowUpTimer");

-- Arc Shot: Affinity
local crit_chance_bow_timer_field = player_data_type_def:get_field("_CritChanceUpBowTimer");
-- Arc Shot: Brace
local super_armor_item_timer_field = player_data_type_def:get_field("_SuperArmorItemTimer");



local system_array_type_def = sdk.find_type_definition("System.Array");
local get_length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

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
		this.update_bow_skills(player, player_data);
	end
end

function this.update_weapon_skill(key, weapon_type_name, value_owner, value_holder, timer_owner, timer_holder, is_infinite, minimal_value, level_breakpoints)
	return buffs.update_generic_buff(this.list, config.current_config.buff_UI.filter.weapon_skills[weapon_type_name], this.get_weapon_skill_name, 
		weapon_skill_type_name, key,
		value_owner, value_holder, timer_owner, timer_holder, is_infinite, minimal_value, level_breakpoints);
end

function this.update_generic(key, level, timer)
	return buffs.update_generic(this.list, this.get_weapon_skill_name, weapon_skill_type_name, key, level, timer);
end

function this.apply_filter(weapon_type_name, key)
	return buffs.apply_filter(this.list, config.current_config.buff_UI.filter.weapon_skills[weapon_type_name], key);
end

function this.update_great_sword_skills(player)
	this.update_weapon_skill("power_sheathe", great_sword_type_name, nil, nil, player, move_wp_off_buff_great_sword_timer_field);
end

function this.update_switch_axe_skills(player)
	this.update_weapon_skill("amped_state", switch_axe_type_name, nil, nil, player, get_bottle_awake_duration_timer_method);
	this.update_weapon_skill("switch_charger", switch_axe_type_name, nil, nil, player, no_use_slash_gauge_timer_field);
	this.update_weapon_skill("axe_heavy_slam", switch_axe_type_name, nil, nil, player, bottle_awake_assist_timer_field);
end

function this.update_long_sword_skills(player)
	this.update_weapon_skill("spirit_gauge_autofill", long_sword_type_name, nil, nil, player, get_long_sword_gauge_powerup_time_method);
	this.update_weapon_skill("spirit_gauge", long_sword_type_name, player, get_long_sword_gauge_lv_method, player, get_long_sword_gauge_lv_timer_method, false, nil, spirit_gauge_breakpoints);

	this.update_harvest_moon();
end

function this.update_harvest_moon()
	if this.apply_filter(long_sword_type_name, "harvest_moon") then
		return;
	end

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

	this.update_generic("harvest_moon", 1, life_timer);
end

function this.update_light_bowgun_skills(player, player_data)
	this.update_weapon_skill("fanning_maneuver", light_bowgun_type_name, nil, nil, player, light_bowgun_wire_buff_timer_field);

	this.update_wyvernblast_reload(player_data);
end

function this.update_wyvernblast_reload(player_data)
	if this.apply_filter(light_bowgun_type_name, "wyvernblast_reload") then
		return;
	end

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

	this.update_generic("wyvernblast_reload", 1, timer);
end

function this.update_heavy_bowgun_skills(player, player_data)
	this.update_weapon_skill("counter_charger", heavy_bowgun_type_name, nil, nil, player, reduce_charge_timer_field);
	this.update_weapon_skill("wyvernsnipe_reload", heavy_bowgun_type_name, nil, nil, player_data, heavy_bowgun_wyvern_snipe_timer_field);

	this.update_rising_moon();
	this.update_setting_sun();
	this.update_overheat(player_data);
end

function this.update_rising_moon()
	if this.apply_filter(heavy_bowgun_type_name, "rising_moon") then
		return;
	end
	
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

	this.update_generic("rising_moon", 1, timer);
end

function this.update_setting_sun()
	if this.apply_filter(heavy_bowgun_type_name, "setting_sun") then
		return;
	end

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

	this.update_generic("setting_sun", 1, timer);
end

function this.update_overheat(player_data)
	if this.apply_filter(heavy_bowgun_type_name, "overheat") then
		return;
	end

	local heavy_bowgun_overheat_timer = heavy_bowgun_overheat_timer_field:get_data(player_data);
	if heavy_bowgun_overheat_timer_field == nil then
		error_handler.report("weapon_skills.update_overheat", "Failed to access Data: heavy_bowgun_overheat_timer_field");
		return;
	end

	if heavy_bowgun_overheat_timer <= 1 then
		this.list.overheat = nil;
		return;
	end

	this.update_generic("overheat", 1, heavy_bowgun_overheat_timer);
end

function this.update_hammer_skills(player)
	this.update_weapon_skill("impact_burst", hammer_type_name, nil, nil, player, hammer_impact_pulls_timer_field);
end

function this.update_gunlance_skills(player)
	this.update_weapon_skill("ground_splitter", gunlance_type_name, nil, nil, player, shot_damage_up_duration_timer_field);
	this.update_weapon_skill("erupting_cannon", gunlance_type_name, nil, nil, player, explode_pile_buff_timer_field);
end

function this.update_lance_skills(player)
	this.update_weapon_skill("spiral_thrust", lance_type_name, nil, nil, player, get_ruten_timer_method);
	this.update_weapon_skill("anchor_rage", lance_type_name, nil, nil, player, get_guard_rage_timer_method);

	this.update_twin_wine(player);
end

function this.update_twin_wine(player)
	if this.apply_filter(lance_type_name, "twin_wine") then
		return;
	end

	local chain_death_match_shell = chain_death_match_shell_field:get_data(player);
	if chain_death_match_shell == nil then
		error_handler.report("weapon_skills.update_twin_wine", "Failed to access Data: chain_death_match_shell");
		return;
	end

	this.update_weapon_skill("twin_wine", lance_type_name, nil, nil, chain_death_match_shell, chain_death_match_shell_life_timer_field);
end

function this.update_sword_and_shield_skills(player)
	this.update_weapon_skill("destroyer_oil", sword_and_shield_type_name, nil, nil, player, get_oil_buff_timer_method);
end

function this.update_dual_blades_skills(player)
	this.update_weapon_skill("ironshine_silk", dual_blades_type_name, nil, nil, player, get_sharpness_recovery_buff_valid_timer_method);

	this.update_archdemon_mode(player)
end

function this.update_archdemon_mode(player)
	if this.apply_filter(dual_blades_type_name, "archdemon_mode") then
		return;
	end

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

	this.update_generic("archdemon_mode", 1, kijin_kyouka_gauge);
end

function this.update_hunting_horn_skills(player)
	this.update_bead_of_resonance();
	this.update_sonic_bloom(player);

	this.update_weapon_skill("silkbind_shockwave", hunting_horn_type_name, nil, nil, player, horn_impact_pulls_timer_field);
end

function this.update_bead_of_resonance()
	if this.apply_filter(hunting_horn_type_name, "bead_of_resonance") then
		return;
	end

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

	this.update_generic("bead_of_resonance", 1, life_timer);
end

function this.update_sonic_bloom(player)
	if this.apply_filter(hunting_horn_type_name, "sonic_bloom") then
		return;
	end

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

	this.update_generic("sonic_bloom", 1, life_timer);
end

function this.update_charge_blade_skills(player)
	this.update_weapon_skill("element_boost", charge_blade_type_name, nil, nil, player, shield_buff_timer_field);

	this.update_weapon_skill("sword_boost_mode", charge_blade_type_name, nil, nil, player, sword_buff_timer_field);
end

function this.update_insect_glaive_skills(player)
	this.update_all_extracts_mix(player);

	if this.list.all_extracts_mix ~= nil then
		this.list.red_extract = nil;
		this.list.white_extract = nil;
		this.list.orange_extract = nil;
		return;
	end

	this.update_extract(player, "red_extract", get_red_extractive_time_method);
	this.update_extract(player, "white_extract", get_white_extractive_time_method);
	this.update_extract(player, "orange_extract", get_orange_extractive_time_method);
end

function this.update_all_extracts_mix(player)
	if this.apply_filter(insect_glaive_type_name, "all_extracts_mix") then
		return;
	end

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

	this.update_generic("all_extracts_mix", 1, red_extractive_time);
end

function this.update_extract(player, extract_key, time_holder)
	if this.apply_filter(insect_glaive_type_name, extract_key) then
		return;
	end

	local extractive_time = time_holder:call(player);
	if extractive_time == nil then
		error_handler.report("weapon_skills.update_extract", string.format("Failed to access Data: %s_extractive_time", extract_key));
		return;
	end

	if utils.number.is_equal(extractive_time, 0) then
		this.list[extract_key] = nil;
		return;
	end

	this.update_generic(extract_key, 1, extractive_time);
end

function this.update_bow_skills(player, player_data)
	this.update_weapon_skill("herculean_draw", bow_type_name, nil, nil, player, wire_buff_attack_up_timer_field);
	this.update_weapon_skill("bolt_boost", bow_type_name, nil, nil, player, wire_buff_arrow_up_timer_field);
	this.update_weapon_skill("arc_shot_affinity", bow_type_name, nil, nil, player_data, crit_chance_bow_timer_field);
	this.update_weapon_skill("arc_shot_brace", bow_type_name, nil, nil, player_data, super_armor_item_timer_field);
end

function this.init_all_UI()
	for weapon_skill_key, weapon_skill in pairs(this.list) do
		buffs.init_UI(weapon_skill);
	end
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