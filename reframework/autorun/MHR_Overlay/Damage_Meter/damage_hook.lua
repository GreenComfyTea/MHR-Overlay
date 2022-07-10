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

local types = {
	[0] = "PlayerWeapon",
	[1] = "BarrelBombLarge",
	[2] = "Makimushi",
	[3] = "Nitro",
	[4] = "OnibiMine",
	[5] = "BallistaHate",
	[6] = "CaptureSmokeBomb",
	[7] = "CaptureBullet",
	[8] = "BarrelBombSmall",
	[9] = "Kunai",
	[10] = "WaterBeetle",
	[11] = "DetonationGrenade",
	[12] = "Kabutowari",
	[13] = "FlashBoll", -- Flash Bomb
	[14] = "HmBallista",
	[15] = "HmCannon",
	[16] = "HmGatling",
	[17] = "HmTrap",
	[18] = "HmNpc",
	[19] = "HmFlameThrower",
	[20] = "HmDragnator",
	[21] = "Otomo",
	[22] = "OtAirouShell014",
	[23] = "OtAirouShell102",
	[24] = "Fg005",
	[25] = "EcBatExplode",
	[26] = "EcWallTrapBugExplode",
	[27] = "EcPiranha",
	[28] = "EcFlash",
	[29] = "EcSandWallShooter",
	[30] = "EcForestWallShooter",
	[31] = "EcSwampLeech",
	[32] = "EcPenetrateFish",
	[33] = "Max",
	[34] = "Invalid"
}

function damage_hook.get_damage_source_type(damage_source_type_id, is_marionette_attack)
	if is_marionette_attack then
		return "wyvern riding";
	elseif damage_source_type_id == 0 or damage_source_type_id == 7 or damage_source_type_id == 11 or damage_source_type_id == 13 then
		return "player";
	elseif damage_source_type_id == 1 or damage_source_type_id == 8 then
		return "bomb";
	elseif damage_source_type_id == 9 then
		return "kunai";
	elseif damage_source_type_id >= 14 and damage_source_type_id <= 20 then
		return "installation";
	elseif damage_source_type_id >= 21 and damage_source_type_id <= 23 then
		return "otomo";
	elseif damage_source_type_id >= 25 and damage_source_type_id <= 32 then
		return "endemic life";
	elseif damage_source_type_id == 34 then
		return "other";
	end

	return tostring(damage_source_type_id);
end

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

	local enemy_calc_damage_info = sdk.to_managed_object(args[3]); -- snow.hit.EnemyCalcDamageInfo.AfterCalcInfo_DamageSide -- snow.hit.DamageFlowInfoBase calcDamageResult?
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

	-- get_Em2EmDamageType()

	local damage_object = {}
	damage_object.total_damage = get_total_damage_method:call(enemy_calc_damage_info);
	damage_object.physical_damage = get_physical_damage_method:call(enemy_calc_damage_info);
	damage_object.elemental_damage = get_elemental_damage_method:call(enemy_calc_damage_info);
	damage_object.ailment_damage = 0;

	local condition_damage = get_condition_damage_method:call(enemy_calc_damage_info);
	local condition_type   = tonumber(get_condition_type_method:call(enemy_calc_damage_info));

	--  0 - PlayerWeapon
	--  1 - BarrelBombLarge
	--  2 - Makimushi
	--  3 - Nitro
	--  4 - OnibiMine
	--  5 - BallistaHate
	--  6 - CaptureSmokeBomb
	--  7 - CaptureBullet
	--  8 - BarrelBombSmall
	--  9 - Kunai
	-- 10 - WaterBeetle
	-- 11 - DetonationGrenade
	-- 12 - Kabutowari
	-- 13 - FlashBoll
	-- 14 - HmBallista
	-- 15 - HmCannon
	-- 16 - HmGatling
	-- 17 - HmTrap
	-- 18 - HmNpc
	-- 19 - HmFlameThrower
	-- 20 - HmDragnator
	-- 21 - Otomo
	-- 22 - OtAirouShell014
	-- 23 - OtAirouShell102
	-- 24 - Fg005
	-- 25 - EcBatExplode
	-- 26 - EcWallTrapBugExplode
	-- 27 - EcPiranha
	-- 28 - EcFlash
	-- 29 - EcSandWallShooter
	-- 30 - EcForestWallShooter
	-- 31 - EcSwampLeech
	-- 32 - EcPenetrateFish


	xy = "\nPlayer: " .. tostring(attacker_id) ..
	"\nDamage: " .. tostring(damage_object.total_damage) ..
	"\nType: ("	.. tostring(attacker_type) ..
	") " .. tostring(types[attacker_type]);

	local damage_source_type = damage_hook.get_damage_source_type(attacker_type, is_marionette_attack);

	local attacking_player = player.get_player(attacker_id);

	local monster;
	if is_large_monster then
		monster = large_monster.get_monster(enemy);
	else
		monster = small_monster.get_monster(enemy);
	end

	local stun_damage = enemy_calc_damage_info:get_field("<StunDamage>k__BackingField");
	if stun_damage ~= 0 and stun_damage ~= nil then
		ailments.apply_ailment_buildup(monster, attacker_id, ailments.stun_id, stun_damage);
	end
	
	ailments.apply_ailment_buildup(monster, attacker_id, condition_type, condition_damage);

	player.update_damage(player.total, damage_source_type, is_large_monster, damage_object);
	player.update_damage(attacking_player, damage_source_type, is_large_monster, damage_object);
end

function damage_hook.init_module()
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	player = require("MHR_Overlay.Damage_Meter.player");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	ailments = require("MHR_Overlay.Monsters.ailments");

	sdk.hook(enemy_character_base_after_calc_damage_damage_side, function(args)
		pcall(damage_hook.update_damage, args);
	end, function(retval)
		return retval;
	end);
end

return damage_hook;