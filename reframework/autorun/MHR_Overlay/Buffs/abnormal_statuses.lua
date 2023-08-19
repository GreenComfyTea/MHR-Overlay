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
	iceblight = nil,
	thunderblight = nil,
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
	sleep = nil,
	defense_down = nil,
	resistance_down = nil,
	tremor = nil,
	roar = nil,
	webbed = nil,
	stench = nil,
	leeched = nil,
	whirlwind = nil,
	bleeding = nil,
	frenzy = nil,
	frenzy_overcome = nil,
	frenzy_infection = nil,
	engulfed = nil,
	frostblight = nil,
	muck = nil
};

local frenzy_infected_duration = 121;

local player_quest_base_type_def = sdk.find_type_definition("snow.player.PlayerQuestBase");

-- Fireblight
local fire_duration_timer = player_quest_base_type_def:get_field("_FireLDurationTimer");
-- Waterblight
local water_duration_timer = player_quest_base_type_def:get_field("_WaterLDurationTimer");
-- Iceblight
local ice_duration_timer = player_quest_base_type_def:get_field("_IceLDurationTimer");
-- Thunderblight
local thunder_duration_timer = player_quest_base_type_def:get_field("_ThunderLDurationTimer");
-- Dragonblight
local dragon_duration_timer = player_quest_base_type_def:get_field("_DragonLDurationTimer");
-- blastblight
local bomb_duration_timer = player_quest_base_type_def:get_field("_BombDurationTimer");
-- Bubbleblight
local bubble_type_field = player_quest_base_type_def:get_field("_BubbleType");
local bubble_damage_timer = player_quest_base_type_def:get_field("_BubbleDamageTimer");
-- Hellfireblight
local oni_bomb_duration_timer = player_quest_base_type_def:get_field("_OniBombDurationTimer");
-- Bloodblight
local mystery_debuff_timer = player_quest_base_type_def:get_field("_MysteryDebuffTimer");
-- Frostblight
local get_is_frozen_damage_method = player_quest_base_type_def:get_method("get_IsFrozenDamage");

-- Poison
local poison_level_field = player_quest_base_type_def:get_field("_PoisonLv");
local poison_duration_timer = player_quest_base_type_def:get_field("_PoisonDurationTimer");
-- Stun
local stun_duration_timer = player_quest_base_type_def:get_field("_StunDurationTimer");
-- Sleep
local sleep_duration_timer = player_quest_base_type_def:get_field("_SleepDurationTimer");
-- Paralysis
local paralyze_duration_timer = player_quest_base_type_def:get_field("_ParalyzeDurationTimer");

-- Defense Down
local defense_down_duration_timer = player_quest_base_type_def:get_field("_DefenceDownDurationTimer");
-- Resistance Down
local resistance_down_duration_timer = player_quest_base_type_def:get_field("_ResistanceDownDurationTimer");

-- Tremor
local quake_duration_timer = player_quest_base_type_def:get_field("_QuakeDurationTimer");
-- Roar
local ear_duration_timer = player_quest_base_type_def:get_field("_EarDurationTimer");
-- Webbed
local beto_duration_timer = player_quest_base_type_def:get_field("_BetoDurationTimer");
-- Stench
local stink_duration_timer = player_quest_base_type_def:get_field("_StinkDurationTimer");
-- Leeched
local blooding_enemy_timer = player_quest_base_type_def:get_field("_BloodingEnemyTimer");
-- Bleeding
local bleeding_debuff_timer = player_quest_base_type_def:get_field("_BleedingDebuffTimer");
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


local cache = {};

function this.update(player, player_data)
	--local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	--if item_parameter == nil then
	--	error_handler.report("consumables.update", "Failed to access Data: item_parameter");
	--	return;
	--end

	-- Missing:
	-- whirlwind?
	-- Wind Pressure?

	this.update_poison(player);
	this.update_bubbleblight(player);
	this.update_muck(player);
	this.update_frenzy_infection(player);

	this.update_generic_timer("fireblight", player, fire_duration_timer);
	this.update_generic_timer("waterblight", player, water_duration_timer);
	this.update_generic_timer("iceblight", player, ice_duration_timer);
	this.update_generic_timer("thunderblight", player, thunder_duration_timer);
	this.update_generic_timer("dragonblight", player, dragon_duration_timer);

	this.update_generic_timer("blastblight", player, bomb_duration_timer);
	this.update_generic_timer("hellfireblight", player, oni_bomb_duration_timer);
	this.update_generic_timer("bloodblight", player, mystery_debuff_timer);

	this.update_generic_timer("stun", player, stun_duration_timer);
	this.update_generic_timer("paralysis", player, paralyze_duration_timer);
	this.update_generic_timer("sleep", player, sleep_duration_timer);
	
	this.update_generic_timer("defense_down", player, defense_down_duration_timer);
	this.update_generic_timer("resistance_down", player, resistance_down_duration_timer);

	this.update_generic_timer("tremor", player, quake_duration_timer);
	this.update_generic_timer("roar", player, ear_duration_timer);
	this.update_generic_timer("webbed", player, beto_duration_timer);
	this.update_generic_timer("stench", player, stink_duration_timer);
	this.update_generic_timer("leeched", player, blooding_enemy_timer, true);
	this.update_generic_timer("bleeding", player, bleeding_debuff_timer);
	this.update_generic_timer("frenzy", player, virus_onset_timer_field);
	this.update_generic_timer("frenzy_overcome", player_data, virus_overcome_buff_timer_field);

	this.update_generic_boolean_value_method("engulfed", player, get_is_vacuum_damage_method);
	this.update_generic_boolean_value_method("frostblight", player, get_is_frozen_damage_method);
end

function this.update_generic_timer(debuff_key, timer_owner, timer_field, is_infinite)
	if is_infinite == nil then is_infinite = false; end

	local timer = timer_field:get_data(timer_owner);
	if timer == nil then
		error_handler.report("abnormal_statuses.update_generic_timer", string.format("Failed to access Data: %s_timer", debuff_key));
		return;
	end

	if utils.number.is_equal(timer, 0) then
		this.list[debuff_key] = nil;
		return;
	end

	if is_infinite then
		timer = nil;
	else
		timer = timer / 60;
	end

	this.update_generic(debuff_key, timer);
end

function this.update_generic_boolean_value_method(debuff_key, value_owner, value_method)
	local value = value_method:call(value_owner);
	if value == nil then
		error_handler.report("abnormal_statuses.update_generic_boolean_value_method", string.format("Failed to access Data: %s_value", debuff_key));
		return;
	end

	if not value then
		this.list[debuff_key] = nil;
		return;
	end

	this.update_generic(debuff_key, nil);
end

function this.update_bubbleblight(player)
	local bubble_Type = bubble_type_field:get_data(player);
	if bubble_Type == nil then
		error_handler.report("abnormal_statuses.update_bubbleblight", "Failed to access Data: bubble_Type");
		return;
	end

	if bubble_Type == 0 then
		this.list.minor_bubbleblight = nil;
		this.list.major_bubbleblight = nil;
		return;
	end
	
	if bubble_Type == 1 then
		this.update_generic_timer("minor_bubbleblight", player, bubble_damage_timer);
		this.list.major_bubbleblight = nil;
	else
		this.update_generic_timer("major_bubbleblight", player, bubble_damage_timer);
		this.list.minor_bubbleblight = nil;
	end
end

function this.update_poison(player)
	local poison_level = poison_level_field:get_data(player);
	if poison_level == nil then
		error_handler.report("abnormal_statuses.update_poison", "Failed to access Data: poison_level");
		return;
	end

	if poison_level == 0 then
		this.list.poison = nil;
		this.list.deadly_poison = nil;
		return;
	end
	
	if poison_level == 1 then
		this.update_generic_timer("poison", player, poison_duration_timer);
		this.list.deadly_poison = nil;
	else
		this.update_generic_timer("deadly_poison", player, poison_duration_timer);
		this.list.poison = nil;
	end
end

function this.update_muck(player)
	local is_mud_damage = get_is_mud_damage_method:call(player);
	if is_mud_damage == nil then
		error_handler.report("abnormal_statuses.update_generic_boolean_value_method", "Failed to access Data: is_mud_damage");
		return;
	end

	local is_gold_mud_damage = get_is_gold_mud_damage_method:call(player);
	if is_gold_mud_damage == nil then
		error_handler.report("abnormal_statuses.update_generic_boolean_value_method", "Failed to access Data: is_gold_mud_damage");
		return;
	end

	if not is_mud_damage and not is_gold_mud_damage then
		this.list.muck = nil;
		return;
	end

	this.update_generic("muck", nil);
end

function this.update_frenzy_infection(player)
	local virus_accumulator_value = virus_accumulator_field:get_data(player);
	if virus_accumulator_value == nil then
		error_handler.report("abnormal_statuses.update_frenzy_infection", "Failed to access Data: virus_accumulator_value");
		return;
	end

	local virus_timer = virus_timer_field:get_data(player);
	if virus_timer == nil then
		error_handler.report("abnormal_statuses.update_frenzy_infection", "Failed to access Data: virus_timer");
		return;
	end

	if virus_accumulator_value == 0 and utils.number.is_equal(virus_timer, 0)then
		this.list.frenzy_infection = nil;
		return;
	end

	local timer = frenzy_infected_duration - (virus_accumulator_value + virus_timer / 60);

	this.update_generic("frenzy_infection", timer, frenzy_infected_duration);
end

function this.update_generic(debuff_key, timer, duration)
	duration = duration or timer;

	local debuff = this.list[debuff_key];
	if debuff == nil then
		local name = language.current_language.ailments[debuff_key];
		if name == nil then
			name = debuff_key;
		end

		debuff = buffs.new(buffs.types.debuff, debuff_key, name, 1, duration);
		this.list[debuff_key] = debuff;
	elseif timer ~= nil then
		buffs.update_timer(debuff, timer);
	end
end

function this.init_names()
	for debuff_key, debuff in pairs(this.list) do
		local name = language.current_language.ailments[debuff_key];

		if name == nil then
			name = debuff_key;
		end

		debuff.name = name;
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
	time = require("MHR_Overlay.Game_Handler.time");
end

function this.init_module()
end

return this;