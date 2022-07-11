local monster_hook = {};
local small_monster;
local large_monster;
local config;
local ailments;
local quest_status;

local character_base_type_def = sdk.find_type_definition("snow.CharacterBase");
local character_base_start_method = character_base_type_def:get_method("start");

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_update_method = enemy_character_base_type_def:get_method("update");
local is_boss_enemy_method = enemy_character_base_type_def:get_method("get_isBossEnemy");

local enemy_damage_check_type_def = sdk.find_type_definition("snow.enemy.EnemyDamageCheck");
local damage_check_update_param_update_method = enemy_damage_check_type_def:get_method("updateParam");

local anger_param_type_def = sdk.find_type_definition("snow.enemy.EnemyAngerParam");
local anger_add_method = anger_param_type_def:get_method("add");
local anger_update_method = anger_param_type_def:get_method("updateNormal");

local stamina_param_type_def = sdk.find_type_definition("snow.enemy.EnemyStaminaParam");
local stamina_sub_method = stamina_param_type_def:get_method("sub");
local stamina_update_method = stamina_param_type_def:get_method("updateParam");

--snow.enemy.EnemyDamageStockParam
function monster_hook.update_health(enemy_damage_stock_param)
	local enemy = enemy_damage_stock_param:call("get_RefEnemy");
	if enemy == nil then
		return;
	end

	local is_large = is_boss_enemy_method:call(enemy);

	if is_large == nil then
		return;
	end
	
	if is_large then
		local monster = large_monster.get_monster(enemy);
		
		local physical_param = large_monster.update_health(enemy, monster);
		large_monster.update_parts(enemy, monster, physical_param);

	else
		local monster = small_monster.get_monster(enemy);
		small_monster.update_health(enemy, monster);
	end
end

function monster_hook.update_stamina(stamina_param, stamina_sub)
	local enemy = stamina_param:call("get_Em");
	if enemy == nil then
		return;
	end

	local monster = large_monster.get_monster(enemy);

	if stamina_sub > 0 then
		large_monster.update_stamina(enemy, monster, stamina_param);
		return;
	end
	
	-- stamina sub gets called periodically at low rate for large monsters even without damage
	large_monster.update(enemy, monster);
	large_monster.update_stamina_timer(enemy, monster, stamina_param);
	large_monster.update_rage_timer(enemy, monster, nil);
end

function monster_hook.update_stamina_timer(stamina_param, enemy)
	local monster = large_monster.get_monster(enemy);
	large_monster.update_stamina_timer(enemy, monster, stamina_param);
end

function monster_hook.update_rage(anger_param, anger_add, enemy)
	if anger_add == 0 then
		return;
	end

	local monster = large_monster.get_monster(enemy);
	large_monster.update_rage(enemy, monster, anger_param);
end

function monster_hook.update_rage_timer(anger_param, enemy)
	local monster = large_monster.get_monster(enemy);
	large_monster.update_rage_timer(enemy, monster, anger_param);
end

function monster_hook.update_monster(enemy)
	local is_large = is_boss_enemy_method:call(enemy);
	if is_large == nil then
		return;
	end

	if is_large then
		local cached_config = config.current_config.large_monster_UI;
		local monster = large_monster.get_monster(enemy);

		if not cached_config.dynamic.enabled then
			return;
		end

		large_monster.update_position(enemy, monster);
	else
		if not config.current_config.small_monster_UI.enabled then
			return;
		end
	
		local monster = small_monster.get_monster(enemy);
		small_monster.update_position(enemy, monster);
	end
end

function monster_hook.init_module()
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	config = require("MHR_Overlay.Misc.config");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");

	sdk.hook(enemy_character_base_update_method, function(args)
		pcall(monster_hook.update_monster, sdk.to_managed_object(args[2]));
	end, function(retval)
		return retval;
	end);

	sdk.hook(damage_check_update_param_update_method, function(args)
		pcall(monster_hook.update_health, sdk.to_managed_object(args[2]));
	end, function(retval)
		return retval;
	end);

	sdk.hook(stamina_sub_method, function(args)
		pcall(monster_hook.update_stamina, sdk.to_managed_object(args[2]), sdk.to_float(args[3]));
	end, function(retval)
		return retval;
	end);

	--sdk.hook(stamina_update_method, function(args)
	--	pcall(monster_hook.update_stamina_timer, sdk.to_managed_object(args[2]), -1, sdk.to_managed_object(args[3]));
	--end, function(retval)
	--	return retval;
	--end);

	sdk.hook(anger_add_method, function(args)
		pcall(monster_hook.update_rage, sdk.to_managed_object(args[2]), sdk.to_float(args[3]), sdk.to_managed_object(args[4]));
	end, function(retval)
		return retval;
	end);

	--sdk.hook(anger_update_method, function(args)
	--	pcall(monster_hook.update_rage_timer, sdk.to_managed_object(args[2]), sdk.to_managed_object(args[3]));
	--end, function(retval)
	--	return retval;
	--end);


end

return monster_hook;