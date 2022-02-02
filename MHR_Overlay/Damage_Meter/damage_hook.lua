local damage_hook = {};
local quest_status;
local player;



local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_after_calc_damage_damage_side = enemy_character_base_type_def:get_method("afterCalcDamage_DamageSide");

sdk.hook(enemy_character_base_after_calc_damage_damage_side, function(args)
	damage_hook.update_damage(args);
end, function(retval)
	return retval;
end);

function damage_hook.update_damage(args)
	local enemy = sdk.to_managed_object(args[2]);
	if enemy == nil then
		return;
	end

	local is_large_monster = enemy:call("get_isBossEnemy");
	if is_large_monster == nil then
		return;
	end

	local dead_or_captured = enemy:call("checkDie");
	if dead_or_captured == nil then
		return;
	end

	if dead_or_captured then
		return;
	end

	local enemy_calc_damage_info = sdk.to_managed_object(args[3]); -- snow.hit.EnemyCalcDamageInfo.AfterCalcInfo_DamageSide
	local attacker_id = enemy_calc_damage_info:call("get_AttackerID");
	local attacker_type = enemy_calc_damage_info:call("get_DamageAttackerType");

	if attacker_id >= 100 then
		return;
	end

	-- 4 is virtual player in singleplayer that 'owns' 2nd otomo
	if not quest_status.is_online and attacker_id == 4 then
		attacker_id = player.myself.player_id;
	end

	local damage_object = {}
	damage_object.total_damage = enemy_calc_damage_info:call("get_TotalDamage");
	damage_object.physical_damage = enemy_calc_damage_info:call("get_PhysicalDamage");
	damage_object.elemental_damage = enemy_calc_damage_info:call("get_ElementDamage");
	damage_object.ailment_damage = enemy_calc_damage_info:call("get_ConditionDamage");

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
		return;
	end

	player.update_damage(player.total, damage_source_type, is_large_monster, damage_object);
	player.update_damage(attacking_player, damage_source_type, is_large_monster, damage_object);
end

function damage_hook.init_module()
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	player = require("MHR_Overlay.Damage_Meter.player");
end

return damage_hook;