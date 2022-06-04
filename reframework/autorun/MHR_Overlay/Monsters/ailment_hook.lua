local ailment_hook = {};
local small_monster;
local large_monster;
local config;
local ailments;
local table_helpers;

local enemy_poison_damage_param_type_def = sdk.find_type_definition("snow.enemy.EnemyPoisonDamageParam");
local on_poison_activate_proc_method = enemy_poison_damage_param_type_def:get_method("onActivateProc");

local enemy_condition_damage_param_base_type_def = sdk.find_type_definition("snow.enemy.EnemyConditionDamageParamBase");
local get_enemy_method = enemy_condition_damage_param_base_type_def:get_method("get_Em");

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local damage_param_field = enemy_character_base_type_def:get_field("<DamageParam>k__BackingField");
local is_boss_enemy_method = enemy_character_base_type_def:get_method("get_isBossEnemy");

local enemy_damage_param_type_def = sdk.find_type_definition("snow.enemy.EnemyDamageParam");
local stock_damage_method = enemy_damage_param_type_def:get_method("stockDamage");
local poison_param_field = enemy_damage_param_type_def:get_field("_PoisonParam");
local blast_param_field = enemy_damage_param_type_def:get_field("_BlastParam");

sdk.hook(stock_damage_method, function(args)
	pcall(ailment_hook.stock_damage);
end, function(retval)
	return retval;
end);

sdk.hook(on_poison_activate_proc_method, function(args)
	pcall(ailment_hook.poison_proc, sdk.to_managed_object(args[2]));
end, function(retval)
	return retval;
end);

function ailment_hook.poison_proc(poison_param)
	if poison_param == nil then
		return;
	end

	local enemy = get_enemy_method:call(poison_param);
	if enemy == nil then
		return;
	end

	local is_large = is_boss_enemy_method:call(enemy);
	if is_large == nil then
		return;
	end

	local monster;
	if is_large then
		monster = large_monster.get_monster(enemy);
	else
		monster = small_monster.get_monster(enemy);
	end

	monster.ailments[ailments.poison_id].cashed_buildup_share = monster.ailments[ailments.poison_id].buildup_share;
	ailments.clear_ailment_contribution(monster, ailments.poison_id);
end

function ailment_hook.stock_damage()
	for enemy, monster in pairs(large_monster.list) do
		local damage_param = damage_param_field:get_data(enemy);
		if damage_param == nil then
			goto continue;
		end

		local poison_param = poison_param_field:get_data(damage_param);
		local blast_param = blast_param_field:get_data(damage_param);

		ailments.update_poison_blast(monster, poison_param, blast_param);
		::continue::
	end

	for enemy, monster in pairs(small_monster.list) do
		local damage_param = damage_param_field:get_data(enemy);
		if damage_param == nil then
			goto continue;
		end

		local poison_param = poison_param_field:get_data(damage_param);
		local blast_param = blast_param_field:get_data(damage_param);

		ailments.update_poison_blast(monster, poison_param, blast_param);
		::continue::
	end
end

function ailment_hook.init_module()
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	config = require("MHR_Overlay.Misc.config");
	ailments = require("MHR_Overlay.Monsters.ailments");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
end

return ailment_hook;