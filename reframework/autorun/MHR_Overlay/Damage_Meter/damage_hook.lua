local damage_hook = {};
local quest_status;
local player;
local small_monster;
local large_monster;
local ailments;
local table_helpers;

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_after_calc_damage_damage_side_method = enemy_character_base_type_def:get_method("afterCalcDamage_DamageSide");

local is_boss_enemy_method = enemy_character_base_type_def:get_method("get_isBossEnemy");
local check_die_method = enemy_character_base_type_def:get_method("checkDie");

local enemy_calc_damage_info_type_def = sdk.find_type_definition("snow.hit.EnemyCalcDamageInfo.AfterCalcInfo_DamageSide");
local get_attacker_id_method = enemy_calc_damage_info_type_def:get_method("get_AttackerID");
local get_damage_attacker_type_method = enemy_calc_damage_info_type_def:get_method("get_DamageAttackerType");
local is_marionette_attack_method = enemy_calc_damage_info_type_def:get_method("get_IsMarionetteAttack");

local get_total_damage_method = enemy_calc_damage_info_type_def:get_method("get_TotalDamage");
local get_physical_damage_method = enemy_calc_damage_info_type_def:get_method("get_PhysicalDamage");
local get_elemental_damage_method = enemy_calc_damage_info_type_def:get_method("get_ElementDamage");

local stun_damage_field = enemy_calc_damage_info_type_def:get_field("<StunDamage>k__BackingField");

local get_condition_damage_method = enemy_calc_damage_info_type_def:get_method("get_ConditionDamage");
local get_condition_type_method = enemy_calc_damage_info_type_def:get_method("get_ConditionDamageType");
local get_condition_damage2_method = enemy_calc_damage_info_type_def:get_method("get_ConditionDamage2");
local get_condition_type2_method = enemy_calc_damage_info_type_def:get_method("get_ConditionDamageType2");
local get_condition_damage3_method = enemy_calc_damage_info_type_def:get_method("get_ConditionDamage3");
local get_condition_type3_method = enemy_calc_damage_info_type_def:get_method("get_ConditionDamageType3");

local stock_mystery_core_break_damage_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase.stockMysteryCoreBreakDamage");

local quest_manager_type_def = sdk.find_type_definition("snow.QuestManager");

local quest_forfeit_method = quest_manager_type_def:get_method("questForfeit");

local packet_quest_forfeit_type_def = sdk.find_type_definition("snow.QuestManager.PacketQuestForfeit");
local dead_player_id_field = packet_quest_forfeit_type_def:get_field("_DeadPlIndex");
local is_from_host_field = packet_quest_forfeit_type_def:get_field("_IsFromQuestHostPacket");

function damage_hook.get_damage_source_type(damage_source_type_id, is_marionette_attack)
	if is_marionette_attack then
		return "wyvern riding";
	elseif damage_source_type_id == 0 or damage_source_type_id == 7 or damage_source_type_id == 11 or
		damage_source_type_id == 13 then
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

-- snow.hit.EnemyCalcDamageInfo.AfterCalcInfo_DamageSide
function damage_hook.update_damage(enemy, enemy_calc_damage_info)
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

	local attacker_id = get_attacker_id_method:call(enemy_calc_damage_info);
	local attacker_type = get_damage_attacker_type_method:call(enemy_calc_damage_info);
	local is_marionette_attack = is_marionette_attack_method:call(enemy_calc_damage_info)

	-- 4 is virtual player in singleplayer that "owns" 2nd otomo
	if not quest_status.is_online and attacker_id == 4 then
		attacker_id = player.myself.id;
	end

	if is_marionette_attack then
		large_monster.update_all_riders();
		for enemy, monster in pairs(large_monster.list) do
			if monster.unique_id == attacker_id then
				attacker_id = monster.rider_id;
				break
			end
		end
	end

	-- get_Em2EmDamageType();

	local damage_object = {}
	damage_object.total_damage = get_total_damage_method:call(enemy_calc_damage_info);
	damage_object.physical_damage = get_physical_damage_method:call(enemy_calc_damage_info);
	damage_object.elemental_damage = get_elemental_damage_method:call(enemy_calc_damage_info);
	damage_object.ailment_damage = 0;

	local condition_damage = get_condition_damage_method:call(enemy_calc_damage_info);
	local condition_type = tonumber(get_condition_type_method:call(enemy_calc_damage_info));

	local condition_damage2 = get_condition_damage2_method:call(enemy_calc_damage_info);
	local condition_type2 = tonumber(get_condition_type2_method:call(enemy_calc_damage_info));

	local condition_damage3 = get_condition_damage3_method:call(enemy_calc_damage_info);
	local condition_type3 = tonumber(get_condition_type3_method:call(enemy_calc_damage_info));

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

	--xy = "\nPlayer: " .. tostring(attacker_id) ..
	--" Damage: " .. tostring(damage_object.total_damage) ..
	--" Type: ("	.. tostring(attacker_type) ..
	--") " ..
	--" Condition Damage: " .. tostring(condition_damage) ..
	--" Condition Type: ("	.. tostring(attacker_type) ..
	--") " .. tostring(condition_type);

	--if string.len(xy) > 2300 then
	--	xy = "";
	--end

	local damage_source_type = damage_hook.get_damage_source_type(attacker_type,
		is_marionette_attack);

	local attacking_player = player.get_player(attacker_id);

	local monster;
	if is_large_monster then
		monster = large_monster.get_monster(enemy);
	else
		monster = small_monster.get_monster(enemy);
	end

	local stun_damage = stun_damage_field:get_data(enemy_calc_damage_info);
	if attacking_player ~= nil then
		ailments.apply_ailment_buildup(monster, attacker_id, ailments.stun_id, stun_damage);

		ailments.apply_ailment_buildup(monster, attacker_id, condition_type, condition_damage);
		ailments.apply_ailment_buildup(monster, attacker_id, condition_type2, condition_damage2);
		ailments.apply_ailment_buildup(monster, attacker_id, condition_type3, condition_damage3);
	end

	player.update_damage(player.total, damage_source_type, is_large_monster, damage_object);
	player.update_damage(attacking_player, damage_source_type, is_large_monster, damage_object);
end

--function damage_hook.on_mystery_core_break(enemy)

--end

-- Coavins code
function damage_hook.cart(dead_player_id, flag_cat_skill_insurance)
	-- flag_cat_skill_insurance = 0
	-- flag_cat_skill_insurance = 1
	local player_ = player.list[dead_player_id];
	if player_ == nil then
		return;
	end

	player_.cart_count = player_.cart_count + 1;
end

--function damage_hook.on_get_finish_shoot_wall_hit_damage_rate(enemy, rate, is_part_damage)

--xy = string.format("enemy: %s\nrate: %s\nis_part_damage: %s", tostring(enemy), tostring(rate), tostring(is_part_damage));
--end


local get_finish_shoot_wall_hit_damage_rate_method = enemy_character_base_type_def:get_method("stockFinishShootHitDamage");

function damage_hook.init_module()
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	player = require("MHR_Overlay.Damage_Meter.player");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	ailments = require("MHR_Overlay.Monsters.ailments");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");

	--sdk.hook(get_finish_shoot_wall_hit_damage_rate_method, function(args)
	--	pcall(damage_hook.on_get_finish_shoot_wall_hit_damage_rate, sdk.to_managed_object(args[2]), sdk.to_float(args[3]), sdk.to_int64(args--[4]));
	--end, function(retval)
	--	return retval;
	--end);

	sdk.hook(enemy_character_base_after_calc_damage_damage_side_method, function(args)
		pcall(damage_hook.update_damage, sdk.to_managed_object(args[2]), sdk.to_managed_object(args[3]));
	end, function(retval)
		return retval;
	end);

	sdk.hook(quest_forfeit_method, function(args)
		pcall(damage_hook.cart, sdk.to_int64(args[3]), (sdk.to_int64(args[4]) & 0xFFFFFFFF));
	end, function(retval)
		return retval;
	end);

	--sdk.hook(stock_mystery_core_break_damage_type_def, function(args)
	--	pcall(damage_hook.on_mystery_core_break, sdk.to_managed_object(args[2]));
	--end, function(retval)
	--	return retval;
	--end);
end

return damage_hook;
