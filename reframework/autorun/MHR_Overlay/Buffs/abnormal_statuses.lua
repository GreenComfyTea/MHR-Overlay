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
	fireblight = nil,
	waterblight = nil,
	thunderblight = nil,
	iceblight = nil,
	dragonblight = nil,
	blastblight = nil,
	minor_bubbleblight = nil,
	major_bubbleblight = nil,
	hellfireblight = nil,
	bloodblight = nil,
	poison = nil,
	deadly_poison = nil,
	stun = nil,
	paralysis = nil,
	falling_asleep = nil,
	sleep = nil,
	defense_down = nil,
	resistance_down = nil,
	tremor = nil,
	roar = nil,
	webbed = nil,
	stench = nil,
	leeched = nil,
	-- whirlwind = nil,
	bleeding = nil,
	frenzy = nil,
	frenzy_overcome = nil,
	engulfed = nil,
	frostblight = nil,
	muck = nil
};

this.keys = {
	"fireblight",
	"waterblight",
	"thunderblight",
	"iceblight",
	"dragonblight",
	"blastblight",
	"minor_bubbleblight",
	"major_bubbleblight",
	"hellfireblight",
	"bloodblight",
	"frostblight",
	"poison",
	"deadly_poison",
	"stun",
	"paralysis",
	"falling_asleep",
	"sleep",
	"defense_down",
	"resistance_down",
	"tremor",
	"roar",
	"webbed",
	"stench",
	"leeched",
	-- "whirlwind",
	"bleeding",
	"engulfed",
	"muck",
	"frenzy",
	"frenzy_overcome",
	"frenzy_infection"
};

this.UI = nil;

local abnormal_statuses_type_name = "abnormal_statuses";

local frenzy_infected_duration = 121;

local player_quest_base_type_def = sdk.find_type_definition("snow.player.PlayerQuestBase");

-- Fireblight
local fire_duration_timer_field = player_quest_base_type_def:get_field("_FireLDurationTimer");
-- Waterblight
local water_duration_timer_field = player_quest_base_type_def:get_field("_WaterLDurationTimer");
-- Thunderblight
local thunder_duration_timer_field = player_quest_base_type_def:get_field("_ThunderLDurationTimer");
-- Iceblight
local ice_duration_timer_field = player_quest_base_type_def:get_field("_IceLDurationTimer");
-- Dragonblight
local dragon_duration_timer_field = player_quest_base_type_def:get_field("_DragonLDurationTimer");
-- blastblight
local bomb_duration_timer_field = player_quest_base_type_def:get_field("_BombDurationTimer");
-- Bubbleblight
local bubble_type_field = player_quest_base_type_def:get_field("_BubbleType");
local bubble_damage_timer_field = player_quest_base_type_def:get_field("_BubbleDamageTimer");
-- Hellfireblight
local oni_bomb_duration_timer_field = player_quest_base_type_def:get_field("_OniBombDurationTimer");
-- Bloodblight
local mystery_debuff_timer_field = player_quest_base_type_def:get_field("_MysteryDebuffTimer");
-- Frostblight
local get_is_frozen_damage_method = player_quest_base_type_def:get_method("get_IsFrozenDamage");
-- Poison
local poison_level_field = player_quest_base_type_def:get_field("_PoisonLv");
local poison_duration_timer_field = player_quest_base_type_def:get_field("_PoisonDurationTimer");
-- Stun
local stun_duration_timer_field = player_quest_base_type_def:get_field("_StunDurationTimer");
-- Falling Sleep
local get_sleep_movable_timer_method = player_quest_base_type_def:get_method("get_SleepMovableTimer");
-- Sleep
local sleep_duration_timer_field = player_quest_base_type_def:get_field("_SleepDurationTimer");
-- Paralysis
local paralyze_duration_timer_field = player_quest_base_type_def:get_field("_ParalyzeDurationTimer");

-- Defense Down
local defense_down_duration_timer_field = player_quest_base_type_def:get_field("_DefenceDownDurationTimer");
-- Resistance Down
local resistance_down_duration_timer_field = player_quest_base_type_def:get_field("_ResistanceDownDurationTimer");

-- Tremor
local quake_duration_timer_field = player_quest_base_type_def:get_field("_QuakeDurationTimer");
-- Roar
local ear_duration_timer_field = player_quest_base_type_def:get_field("_EarDurationTimer");
-- Webbed
local beto_duration_timer_field = player_quest_base_type_def:get_field("_BetoDurationTimer");
-- Stench
local stink_duration_timer_field = player_quest_base_type_def:get_field("_StinkDurationTimer");
-- Leeched
local blooding_enemy_timer_field = player_quest_base_type_def:get_field("_BloodingEnemyTimer");
-- Bleeding
local bleeding_debuff_timer_field = player_quest_base_type_def:get_field("_BleedingDebuffTimer");
-- Engulfed
local get_is_vacuum_damage_method = player_quest_base_type_def:get_method("get__IsVacuumDamage");
-- Muck
local get_is_mud_damage_method = player_quest_base_type_def:get_method("get__IsMudDamage");
local get_is_gold_mud_damage_method = player_quest_base_type_def:get_method("get__IsGoldMudDamage");

-- Frenzy Infected
local virus_accumulator_field = player_quest_base_type_def:get_field("_VirusAccumulator");
local virus_timer_field = player_quest_base_type_def:get_field("_VirusTimer");
-- Frenzy
local virus_onset_timer_field = player_quest_base_type_def:get_field("_VirusOnsetTimer");

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");

-- Frenzy Overcome
local virus_overcome_buff_timer_field = player_data_type_def:get_field("_VirusOvercomeBuffTimer");

function this.update(player, player_data)
	-- Missing:
	-- whirlwind?
	-- Wind Pressure?

	this.update_poison(player);
	this.update_bubbleblight(player);
	this.update_muck(player);
	this.update_frenzy_infection(player);

	this.update_abnormal_status("fireblight", nil, nil, player, fire_duration_timer_field);
	this.update_abnormal_status("waterblight", nil, nil, player, water_duration_timer_field);
	this.update_abnormal_status("thunderblight", nil, nil, player, thunder_duration_timer_field);
	this.update_abnormal_status("iceblight", nil, nil, player, ice_duration_timer_field);
	this.update_abnormal_status("dragonblight", nil, nil, player, dragon_duration_timer_field);
	this.update_abnormal_status("blastblight", nil, nil, player, bomb_duration_timer_field);
	this.update_abnormal_status("hellfireblight", nil, nil, player, oni_bomb_duration_timer_field);
	this.update_abnormal_status("bloodblight", nil, nil, player, mystery_debuff_timer_field);
	this.update_abnormal_status("frostblight", player, get_is_frozen_damage_method);

	this.update_abnormal_status("stun", nil, nil, player, stun_duration_timer_field);
	this.update_abnormal_status("paralysis", nil, nil, player, paralyze_duration_timer_field);
	this.update_abnormal_status("falling_asleep", nil, nil, player, get_sleep_movable_timer_method);
	this.update_abnormal_status("defense_down", nil, nil, player, defense_down_duration_timer_field);
	this.update_abnormal_status("resistance_down", nil, nil, player, resistance_down_duration_timer_field);

	this.update_abnormal_status("tremor", nil, nil, player, quake_duration_timer_field);
	this.update_abnormal_status("roar", nil, nil, player, ear_duration_timer_field);
	this.update_abnormal_status("webbed", nil, nil, player, beto_duration_timer_field);
	this.update_abnormal_status("stench", nil, nil, player, stink_duration_timer_field);
	this.update_abnormal_status("leeched", nil, nil, player, blooding_enemy_timer_field, true);
	this.update_abnormal_status("bleeding", nil, nil, player, bleeding_debuff_timer_field);
	this.update_abnormal_status("engulfed", player, get_is_vacuum_damage_method);

	this.update_abnormal_status("frenzy", nil, nil, player, virus_onset_timer_field);
	this.update_abnormal_status("frenzy_overcome", nil, nil, player_data, virus_overcome_buff_timer_field);

	this.update_sleep(player);
end

function this.update_abnormal_status(key, value_owner, value_holder, timer_owner, timer_holder, is_infinite, minimal_value, level_breakpoints)
	return buffs.update_generic_buff(this.list, config.current_config.buff_UI.filter.abnormal_statuses, this.get_abnormal_status_name,
		abnormal_statuses_type_name, key, value_owner, value_holder, timer_owner, timer_holder, is_infinite, minimal_value, level_breakpoints);
end

function this.update_generic(key, level, timer)
	return buffs.update_generic(this.list, this.get_abnormal_status_name, abnormal_statuses_type_name, key, level, timer);
end

function this.apply_filter(key)
	return buffs.apply_filter(this.list, config.current_config.buff_UI.filter.abnormal_statuses, key);
end

function this.update_poison(player)
	local cached_config = config.current_config.buff_UI.filter.abnormal_statuses;

	if not cached_config.poison
	and not cached_config.deadly_poison then
		if this.apply_filter("poison") then
			return;
		end

		if this.apply_filter("deadly_poison") then
			return;
		end
	end

	local poison_level = poison_level_field:get_data(player);
	if poison_level == nil then
		error_handler.report("abnormal_statuses.update_poison", "Failed to access Data: poison_level");
		this.list.poison = nil;
		this.list.deadly_poison = nil;
		return;
	end

	if poison_level == 0 then
		this.list.poison = nil;
		this.list.deadly_poison = nil;
		return;
	end
	
	if poison_level == 1 then
		this.update_abnormal_status("poison", nil, nil, player, poison_duration_timer_field);
		this.list.deadly_poison = nil;
	else
		this.update_abnormal_status("deadly_poison", nil, nil,  player, poison_duration_timer_field);
		this.list.poison = nil;
	end
end

function this.update_bubbleblight(player)
	local cached_config = config.current_config.buff_UI.filter.abnormal_statuses;

	if not cached_config.minor_bubbleblight
	and not cached_config.major_bubbleblight then
		if this.apply_filter("minor_bubbleblight") then
			return;
		end

		if this.apply_filter("major_bubbleblight") then
			return;
		end
	end

	local bubble_type = bubble_type_field:get_data(player);
	if bubble_type == nil then
		error_handler.report("abnormal_statuses.update_bubbleblight", "Failed to access Data: bubble_Type");
		this.list.minor_bubbleblight = nil;
		this.list.major_bubbleblight = nil;
		return;
	end

	if bubble_type == 0 then
		this.list.minor_bubbleblight = nil;
		this.list.major_bubbleblight = nil;
		return;
	end
	
	if bubble_type == 1 then
		this.update_abnormal_status("minor_bubbleblight", nil, nil, player, bubble_damage_timer_field);
		this.list.major_bubbleblight = nil;
	else
		this.update_abnormal_status("major_bubbleblight", nil, nil, player, bubble_damage_timer_field);
		this.list.minor_bubbleblight = nil;
	end
end

function this.update_muck(player)
	if this.apply_filter("muck") then
		return;
	end

	local is_mud_damage = get_is_mud_damage_method:call(player);
	if is_mud_damage == nil then
		error_handler.report("abnormal_statuses.update_generic_boolean_value_method", "Failed to access Data: is_mud_damage");
		this.list.muck = nil;
		return;
	end

	local is_gold_mud_damage = get_is_gold_mud_damage_method:call(player);
	if is_gold_mud_damage == nil then
		error_handler.report("abnormal_statuses.update_generic_boolean_value_method", "Failed to access Data: is_gold_mud_damage");
		this.list.muck = nil;
		return;
	end

	if not is_mud_damage and not is_gold_mud_damage then
		this.list.muck = nil;
		return;
	end

	this.update_generic("muck");
end

function this.update_frenzy_infection(player)
	if this.apply_filter("frenzy_infection") then
		return;
	end

	local virus_accumulator_value = virus_accumulator_field:get_data(player);
	if virus_accumulator_value == nil then
		error_handler.report("abnormal_statuses.update_frenzy_infection", "Failed to access Data: virus_accumulator_value");
		this.list.frenzy_infection = nil;
		return;
	end

	local virus_timer = virus_timer_field:get_data(player);
	if virus_timer == nil then
		error_handler.report("abnormal_statuses.update_frenzy_infection", "Failed to access Data: virus_timer");
		this.list.frenzy_infection = nil;
		return;
	end

	if virus_accumulator_value == 0 and utils.number.is_equal(virus_timer, 0) then
		this.list.frenzy_infection = nil;
		return;
	end

	local timer = frenzy_infected_duration - (virus_accumulator_value + virus_timer / 60);

	this.update_generic("frenzy_infection", 1, timer);
end

function this.update_sleep(player)
	if this.apply_filter("sleep") then
		this.list.sleep = nil;
		return;
	end

	if this.list.falling_asleep ~= nil then
		this.list.sleep = nil;
		return;
	end
	
	this.update_abnormal_status("sleep", nil, nil, player, sleep_duration_timer_field);
end

function this.init_all_UI()
	for abnormal_status_key, abnormal_status in pairs(this.list) do
		buffs.init_UI(abnormal_status);
	end
end

function this.init_names()
	for abnormal_status_key, abnormal_status in pairs(this.list) do
		abnormal_status.name = this.get_abnormal_status_name(abnormal_status_key);
	end
end

function this.get_abnormal_status_name(key)
	local abnormal_status_name = language.current_language.ailments[key];
	if abnormal_status_name == nil then
		return key;
	end

	return abnormal_status_name;
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