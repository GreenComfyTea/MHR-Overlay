local this = {};

local small_monster;
local large_monster;
local config;
local ailments;
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

local enemy_poison_damage_param_type_def = sdk.find_type_definition("snow.enemy.EnemyPoisonDamageParam");
local on_poison_activate_proc_method = enemy_poison_damage_param_type_def:get_method("onActivateProc");

local enemy_poison_damage_param_type_def = sdk.find_type_definition("snow.enemy.EnemyBlastDamageParam");
local on_blast_activate_proc_method = enemy_poison_damage_param_type_def:get_method("onActivateProc");

local enemy_condition_damage_param_base_type_def = sdk.find_type_definition("snow.enemy.EnemyConditionDamageParamBase");
local get_enemy_method = enemy_condition_damage_param_base_type_def:get_method("get_Em");

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local get_damage_param_method = enemy_character_base_type_def:get_method("get_DamageParam");
local is_boss_enemy_method = enemy_character_base_type_def:get_method("get_isBossEnemy");

local enemy_damage_param_type_def = sdk.find_type_definition("snow.enemy.EnemyDamageParam");
local stock_damage_method = enemy_damage_param_type_def:get_method("stockDamage");

local poison_param_field = enemy_damage_param_type_def:get_field("_PoisonParam");
local blast_param_field = enemy_damage_param_type_def:get_field("_BlastParam");

local blast_param_type = blast_param_field:get_type();
local blast_damage_method = blast_param_type:get_method("get_BlastDamage");
local blast_adjust_rate_method = blast_param_type:get_method("get_BlastDamageAdjustRateByEnemyLv");

function this.poison_proc(poison_param)
	if poison_param == nil then
		error_handler.report("ailment_hook.poison_proc", "Missing Parameter: poison_param");
		return;
	end

	local enemy = get_enemy_method:call(poison_param);
	if enemy == nil then
		error_handler.report("ailment_hook.poison_proc", "Failed to access Data: enemy");
		return;
	end

	local is_large = is_boss_enemy_method:call(enemy);
	if is_large == nil then
		error_handler.report("ailment_hook.poison_proc", "Failed to access Data: is_large");
		return;
	end

	local monster;
	if is_large then
		monster = large_monster.get_monster(enemy);
	else
		monster = small_monster.get_monster(enemy);
	end

	monster.ailments[ailments.poison_id].cached_buildup_share = monster.ailments[ailments.poison_id].buildup_share;
	monster.ailments[ailments.poison_id].cached_otomo_buildup_share = monster.ailments[ailments.poison_id].otomo_buildup_share;

	ailments.clear_ailment_contribution(monster, ailments.poison_id);
end

function this.blast_proc(blast_param)
	if blast_param == nil then
		error_handler.report("ailment_hook.blast_proc", "Missing Parameter: blast_param");
		return;
	end

	local enemy = get_enemy_method:call(blast_param);
	if enemy == nil then
		error_handler.report("ailment_hook.blast_proc", "Failed to access Data: enemy");
		return;
	end

	local is_large = is_boss_enemy_method:call(enemy);
	if is_large == nil then
		error_handler.report("ailment_hook.blast_proc", "Failed to access Data: is_large");
		return;
	end

	local monster;
	if is_large then
		monster = large_monster.get_monster(enemy);
	else
		monster = small_monster.get_monster(enemy);
	end

	local blast_damage = blast_damage_method:call(blast_param);
	local blast_adjust_rate = blast_adjust_rate_method:call(blast_param);


	ailments.apply_ailment_damage(monster, ailments.blast_id, blast_damage * blast_adjust_rate);
	ailments.clear_ailment_contribution(monster, ailments.blast_id);
end

function this.stock_damage()
	for enemy, monster in pairs(large_monster.list) do
		local damage_param = get_damage_param_method:call(enemy);
		if damage_param == nil then
			error_handler.report("ailment_hook.stock_damage", "Failed to access Data: large_monster -> damage_param");
			goto continue;
		end

		local poison_param = poison_param_field:get_data(damage_param);
		if poison_param == nil then
			error_handler.report("ailment_hook.stock_damage", "Failed to access Data: large_monster -> poison_param");
			goto continue;
		end

		ailments.update_poison(monster, poison_param);
		::continue::
	end

	for enemy, monster in pairs(small_monster.list) do
		local damage_param = get_damage_param_method:call(enemy);
		if damage_param == nil then
			error_handler.report("ailment_hook.stock_damage", "Failed to access Data: small_monster -> damage_param");
			goto continue
		end

		local poison_param = poison_param_field:get_data(damage_param);
		if poison_param == nil then
			error_handler.report("ailment_hook.stock_damage", "Failed to access Data: small_monster -> poison_param");
			goto continue;
		end

		ailments.update_poison(monster, poison_param);
		::continue::
	end
end

function this.init_dependencies()
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	config = require("MHR_Overlay.Misc.config");
	ailments = require("MHR_Overlay.Monsters.ailments");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
	sdk.hook(stock_damage_method, function(args)
		pcall(this.stock_damage, sdk.to_managed_object(args[2]));
	end, function(retval)
		return retval;
	end);

	sdk.hook(on_poison_activate_proc_method, function(args)
		pcall(this.poison_proc, sdk.to_managed_object(args[2]));
	end, function(retval)
		return retval;
	end);

	sdk.hook(on_blast_activate_proc_method, function(args)
		pcall(this.blast_proc, sdk.to_managed_object(args[2]));
	end, function(retval)
		return retval;
	end);
end

return this;
