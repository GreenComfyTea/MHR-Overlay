local damage_hook = {};
local quest_status;
local player;
local small_monster;
local large_monster;
local ailments;

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_after_calc_damage_damage_side = enemy_character_base_type_def:get_method("afterCalcDamage_DamageSide");

local is_boss_enemy_method = enemy_character_base_type_def:get_method("get_isBossEnemy");
local check_die_method = enemy_character_base_type_def:get_method("checkDie");

local enemy_calc_damage_info_type_def =  sdk.find_type_definition("snow.hit.EnemyCalcDamageInfo.AfterCalcInfo_DamageSide");
local get_attacker_id_method = enemy_calc_damage_info_type_def:get_method("get_AttackerID");
local get_damage_attacker_type_method = enemy_calc_damage_info_type_def:get_method("get_DamageAttackerType");
local is_marionette_attack_method = enemy_calc_damage_info_type_def:get_method("get_IsMarionetteAttack");

local get_total_damage_method = enemy_calc_damage_info_type_def:get_method("get_TotalDamage");
local get_physical_damage_method = enemy_calc_damage_info_type_def:get_method("get_PhysicalDamage");
local get_elemental_damage_method = enemy_calc_damage_info_type_def:get_method("get_ElementDamage");
local get_condition_damage_method = enemy_calc_damage_info_type_def:get_method("get_ConditionDamage");
local get_condition_type_method = enemy_calc_damage_info_type_def:get_method("get_ConditionDamageType");

sdk.hook(enemy_character_base_after_calc_damage_damage_side, function(args)
	pcall(damage_hook.update_damage, args);
end, function(retval)
	return retval;
end);

function damage_hook.update_damage(args)
	local enemy = sdk.to_managed_object(args[2]);
	if enemy == nil then
		return;
	end

	local is_large_monster = is_boss_enemy_method:call(enemy);

	if is_large_monster == nil then
		return;
	end

	local dead_or_captured = check_die_method:call(enemy);
	if dead_or_captured == nil then
		return;
	end

	if dead_or_captured then
		return;
	end

	local enemy_calc_damage_info = sdk.to_managed_object(args[3]); -- snow.hit.EnemyCalcDamageInfo.AfterCalcInfo_DamageSide
	local attacker_id = get_attacker_id_method:call(enemy_calc_damage_info);
	local attacker_type = get_damage_attacker_type_method:call(enemy_calc_damage_info);
	local is_marionette_attack = is_marionette_attack_method:call(enemy_calc_damage_info)
	
	-- 4 is virtual player in singleplayer that 'owns' 2nd otomo
	if not quest_status.is_online and attacker_id == 4 then
		attacker_id = player.myself.player_id;
	end

	if is_marionette_attack then
		large_monster.update_all_riders();
		for enemy, monster in pairs(large_monster.list) do
			if monster.unique_id == attacker_id then
				attacker_id = monster.rider_id;
				break;
			end
		end
	end

	local damage_object = {}
	damage_object.total_damage = get_total_damage_method:call(enemy_calc_damage_info);
	damage_object.physical_damage = get_physical_damage_method:call(enemy_calc_damage_info);
	damage_object.elemental_damage = get_elemental_damage_method:call(enemy_calc_damage_info);
	damage_object.ailment_damage = 0;

	local condition_damage = get_condition_damage_method:call(enemy_calc_damage_info);
	local condition_type   = tonumber(get_condition_type_method:call(enemy_calc_damage_info));

	-- -1 - bombs
	--  0 - player
	--  9 - kunai
	-- 11 - wyverblast
	-- 12 - ballista
	-- 13 - cannon
	-- 14 - machine cannon
	-- 16 - defender ballista/cannon
	-- 17 - wyvernfire artillery
	-- 18 - dragonator
	-- 19 - otomo
	-- 23 - monster

	local damage_source_type = tostring(attacker_type);
	if attacker_type == 0 then
		damage_source_type = "player";
	elseif attacker_type == 1 then
		damage_source_type = "bomb";
	elseif attacker_type == 9 then
		damage_source_type = "kunai";
	elseif attacker_type == 11 then
		damage_source_type = "wyvernblast";
	elseif attacker_type == 12 or attacker_type == 13 or attacker_type == 14 or attacker_type == 18 then
		damage_source_type = "installation";
	elseif attacker_type == 19 then
		damage_source_type = "otomo";
	elseif attacker_type == 23 then
		damage_source_type = "monster";
	end

	local attacking_player = player.get_player(attacker_id);
	if attacking_player == nil then
		--return;
	end

	local monster;
	if is_large_monster then
		monster = large_monster.get_monster(enemy);
	else
		monster = small_monster.get_monster(enemy);
	end

	--xy =
	--	"type:             " .. tostring(damage_source_type) .. "\n" .. 
	--	"total damage:     " .. tostring(damage_object.total_damage) .. "\n" ..
	--	"physical damage:  " .. tostring(damage_object.physical_damage) .. "\n" ..
	--	"elemental damage: " .. tostring(damage_object.elemental_damage) .. "\n" ..
	--	"condition damage: " .. tostring(condition_damage) .. "\n" ..
	--	"condition type:   " .. tostring(condition_type) .. "\n" ..
	--	"is mario attack:  " .. tostring(is_marionette_attack) .. "\n" ..
	--	"attacker id:      " .. tostring(attacker_id) .. "\n";

	ailments.apply_ailment_buildup(monster, attacker_id, condition_type, condition_damage);

	player.update_damage(player.total, damage_source_type, is_large_monster, damage_object);
	player.update_damage(attacking_player, damage_source_type, is_large_monster, damage_object);
end

function damage_hook.init_module()
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	player = require("MHR_Overlay.Damage_Meter.player");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	ailments = require("MHR_Overlay.Damage_Meter.ailments");
end

return damage_hook;