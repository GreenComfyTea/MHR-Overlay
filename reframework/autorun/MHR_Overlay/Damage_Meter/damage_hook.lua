local this = {};

local quest_status;
local players;
local small_monster;
local large_monster;
local ailments;
local singletons;
local non_players;
local utils;
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

local wall_hit_damage_queue = {};

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_after_calc_damage_damage_side_method = enemy_character_base_type_def:get_method("afterCalcDamage_DamageSide");

local is_boss_enemy_method = enemy_character_base_type_def:get_method("get_isBossEnemy");
local check_die_method = enemy_character_base_type_def:get_method("checkDie");

local stock_direct_marionette_finish_shoot_hit_parts_damage_method = enemy_character_base_type_def:get_method("stockDirectMarionetteFinishShootHitPartsDamage");
local get_mystery_core_break_damage_rate_method = enemy_character_base_type_def:get_method("getMysteryCoreBreakDamageRate");

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

local quest_manager_type_def = sdk.find_type_definition("snow.QuestManager");

local quest_forfeit_method = quest_manager_type_def:get_method("questForfeit");

local packet_quest_forfeit_type_def = sdk.find_type_definition("snow.QuestManager.PacketQuestForfeit");
local dead_player_id_field = packet_quest_forfeit_type_def:get_field("_DeadPlIndex");
local is_from_host_field = packet_quest_forfeit_type_def:get_field("_IsFromQuestHostPacket");

local enemy_mystery_core_parts_type_def = sdk.find_type_definition("snow.enemy.EnemyMysteryCoreParts");
local on_break_method = enemy_mystery_core_parts_type_def:get_method("onBreak");

function this.get_damage_source_type(damage_source_type_id, is_marionette_attack)
	if is_marionette_attack then
		return players.damage_types.wyvern_riding;
	elseif damage_source_type_id == 0 or damage_source_type_id == 7 or damage_source_type_id == 11 or damage_source_type_id == 13 then
		return players.damage_types.player;
	elseif damage_source_type_id == 1 or damage_source_type_id == 8 then
		return players.damage_types.bombs;
	elseif damage_source_type_id == 9 then
		return players.damage_types.kunai;
	elseif damage_source_type_id >= 14 and damage_source_type_id <= 20 then
		return players.damage_types.installations;
	elseif damage_source_type_id >= 21 and damage_source_type_id <= 23 then
		return players.damage_types.otomo;
	elseif damage_source_type_id >= 25 and damage_source_type_id <= 32 then
		return players.damage_types.endemic_life;
	end

	return players.damage_types.other;
end

-- snow.hit.EnemyCalcDamageInfo.AfterCalcInfo_DamageSide
function this.update_damage(enemy, enemy_calc_damage_info)
	local is_large_monster = is_boss_enemy_method:call(enemy);

	if is_large_monster == nil then
		error_handler.report("damage_hook.update_damage", "Failed to access Data: is_large_monster");
		return;
	end

	local dead_or_captured = check_die_method:call(enemy);
	if dead_or_captured == nil then
		error_handler.report("damage_hook.update_damage", "Failed to access Data: dead_or_captured");
		return;
	end

	if dead_or_captured then
		return;
	end

	local attacker_id = get_attacker_id_method:call(enemy_calc_damage_info);
	local otomo_id = attacker_id;
	local attacker_type = get_damage_attacker_type_method:call(enemy_calc_damage_info);
	local is_marionette_attack = is_marionette_attack_method:call(enemy_calc_damage_info)

	local is_otomo_attack = attacker_type >= 21 and attacker_type <= 23;

	if is_marionette_attack then
		large_monster.update_all_riders();
		for enemy, monster in pairs(large_monster.list) do
			if monster.unique_id == attacker_id then
				attacker_id = monster.rider_id;
				break;
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

	local damage_source_type = this.get_damage_source_type(attacker_type, is_marionette_attack);

	local monster;
	if is_large_monster then
		monster = large_monster.get_monster(enemy);
	else
		monster = small_monster.get_monster(enemy);
	end

	local player = nil;
	local otomo = nil;

	if not is_otomo_attack then
		player = players.get_player(attacker_id);

		if player == nil then
			player = non_players.get_servant(attacker_id);
		end
	else
		if attacker_id < 4 then
			player = players.get_player(attacker_id);
			otomo = non_players.get_otomo(attacker_id);
		elseif attacker_id == 4 then
			player = players.myself;
			otomo = non_players.get_otomo(non_players.my_second_otomo_id);
		else 
			player = non_players.get_servant(attacker_id - 1);
			otomo = non_players.get_otomo(attacker_id - 1);
		end

		players.update_damage(otomo, damage_source_type, is_large_monster, damage_object);
	end

	local stun_damage = stun_damage_field:get_data(enemy_calc_damage_info);
	ailments.apply_ailment_buildup(monster, player, otomo, ailments.stun_id, stun_damage);

	ailments.apply_ailment_buildup(monster, player, otomo, condition_type, condition_damage);
	ailments.apply_ailment_buildup(monster, player, otomo, condition_type2, condition_damage2);
	ailments.apply_ailment_buildup(monster, player, otomo, condition_type3, condition_damage3);

	players.update_damage(players.total, damage_source_type, is_large_monster, damage_object);
	players.update_damage(player, damage_source_type, is_large_monster, damage_object);

	--[[xy = string.format(
		
			PhysicalPartsVitalDamage(): 		%s
			PhysicalPartsBreakVitalDamage():	%s
			PhysicalPartsLossVitalDamage():		%s
			PhysicalMultiPartsVitalDamage():	%s

			ElementPartsVitalDamage():			%s
			ElementPartsBreakVitalDamage():		%s
			ElementPartsLossVitalDamage():		%s
			ElementMultiPartsVitalDamage():		%s

			IsBreakPartsDamage():				%s
		,
		tostring(enemy_calc_damage_info:get_PhysicalPartsVitalDamage()),
		tostring(enemy_calc_damage_info:get_PhysicalPartsBreakVitalDamage()),
		tostring(enemy_calc_damage_info:get_PhysicalPartsLossVitalDamage()),
		tostring(enemy_calc_damage_info:get_PhysicalMultiPartsVitalDamage()),

		tostring(enemy_calc_damage_info:get_ElementPartsVitalDamage()),
		tostring(enemy_calc_damage_info:get_ElementPartsBreakVitalDamage()),
		tostring(enemy_calc_damage_info:get_ElementPartsLossVitalDamage()),
		tostring(enemy_calc_damage_info:get_ElementMultiPartsVitalDamage()),

		tostring(enemy_calc_damage_info:get_IsBreakPartsDamage())
	);]]
end

function this.cart(dead_player_id, flag_cat_skill_insurance)
	-- flag_cat_skill_insurance = 0
	-- flag_cat_skill_insurance = 1

	--local player = players.list[dead_player_id];
	--if player == nil then
	--	error_handler.report("damage_hook.cart", "No Dead Player Found");
	--	return;
	--end

	quest_status.update_cart_count();
end

function this.on_stock_direct_marionette_finish_shoot_hit_parts_damage(enemy, damage_rate, is_endure, is_ignore_multi_rate, category, no)
	local monster = large_monster.get_monster(enemy);

	local damage = utils.math.round(monster.max_health * damage_rate);

	large_monster.update_all_riders();
	local attacker_id = monster.rider_id;
	
	table.insert(wall_hit_damage_queue,
		{
			damage = damage, 
			is_large = monster.is_large
		}
	);
	
	if attacker_id == -1 then
		return;
	end

	local player = players.get_player(attacker_id);
	if player == nil then
		player = non_players.get_servant(attacker_id);
	end

	if player == nil then
		error_handler.report("damage_hook.on_stock_direct_marionette_finish_shoot_hit_parts_damage", "Failed to create Player Entry");
		return;
	end

	local damage_source_type = this.get_damage_source_type(0, true);
	local is_large_monster = monster.is_large;

	local large_monster_damage_object = {};
	large_monster_damage_object.total_damage = 0;
	large_monster_damage_object.physical_damage = 0;
	large_monster_damage_object.elemental_damage = 0;
	large_monster_damage_object.ailment_damage = 0;

	local small_monster_damage_object = {};
	small_monster_damage_object.total_damage = 0;
	small_monster_damage_object.physical_damage = 0;
	small_monster_damage_object.elemental_damage = 0;
	small_monster_damage_object.ailment_damage = 0;

	for _, damage_info in ipairs(wall_hit_damage_queue) do
		if damage_info.is_large then

			large_monster_damage_object.total_damage = large_monster_damage_object.total_damage + damage_info.damage;
			large_monster_damage_object.physical_damage = large_monster_damage_object.physical_damage + damage_info.damage;
		else
			small_monster_damage_object.total_damage = small_monster_damage_object.total_damage + damage_info.damage;
			small_monster_damage_object.physical_damage = small_monster_damage_object.physical_damage + damage_info.damage;
		end
		
	end

	wall_hit_damage_queue = {};

	players.update_damage(players.total, damage_source_type, false, small_monster_damage_object);
	players.update_damage(player, damage_source_type, false, small_monster_damage_object);

	players.update_damage(players.total, damage_source_type, true, large_monster_damage_object);
	players.update_damage(player, damage_source_type, true, large_monster_damage_object);
end

function this.on_anomaly_core_break(anomaly_core_part)
	local anomaly_monster = nil;
	for enemy, monster in pairs(large_monster.list) do

		if monster.is_anomaly then
			for part_id, part in pairs(monster.parts) do

				if part.anomaly_core_ref == anomaly_core_part then
					anomaly_monster = monster;
					break;
				end
			end

			if anomaly_monster ~= nil then
				break;
			end
		end
	end

	if anomaly_monster == nil then
		error_handler.report("damage_hook.on_anomaly_core_break", "No Anomaly Monster Found");
		return;
	end

	local anomaly_core_break_damage_rate = get_mystery_core_break_damage_rate_method:call(anomaly_monster.enemy);
	if anomaly_core_break_damage_rate == nil then
		error_handler.report("damage_hook.on_anomaly_core_break", "Failed to access Data: anomaly_core_break_damage_rate");
		return;
	end

	local anomaly_core_break_damage = utils.math.round(anomaly_core_break_damage_rate * anomaly_monster.max_health);

	local damage_object = {};
	damage_object.total_damage = anomaly_core_break_damage;
	damage_object.physical_damage = 0;
	damage_object.elemental_damage = 0;
	damage_object.ailment_damage = anomaly_core_break_damage;

	players.update_damage(players.total, players.damage_types.anomaly_core, true, damage_object);
end

function this.init_dependencies()
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	players = require("MHR_Overlay.Damage_Meter.players");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	ailments = require("MHR_Overlay.Monsters.ailments");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
	utils = require("MHR_Overlay.Misc.utils");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
	sdk.hook(stock_direct_marionette_finish_shoot_hit_parts_damage_method, function(args)
		local enemy = sdk.to_managed_object(args[2]);
		local damage_rate = sdk.to_float(args[3]);
		local is_endure = (sdk.to_int64(args[4]) & 1) == 1;
		local is_ignore_multi_rate = (sdk.to_int64(args[5]) & 1) == 1;
		local category = sdk.to_int64(args[6]); --snow.enemy.EnemyDef.VitalCategory
		local no = sdk.to_int64(args[7]);

		this.on_stock_direct_marionette_finish_shoot_hit_parts_damage(enemy, damage_rate, is_endure, is_ignore_multi_rate, category, no);
	end, function(retval)
		return retval;
	end);

	sdk.hook(enemy_character_base_after_calc_damage_damage_side_method, function(args)
		pcall(this.update_damage, sdk.to_managed_object(args[2]), sdk.to_managed_object(args[3]));
	end, function(retval)
		return retval;
	end);

	sdk.hook(quest_forfeit_method, function(args)
		pcall(this.cart, sdk.to_int64(args[3]), (sdk.to_int64(args[4]) & 0xFFFFFFFF));
	end, function(retval)
		return retval;
	end);

	sdk.hook(on_break_method, function(args)
		-- break core group is same as hit group?
		-- break core group is part id which exploded
		local anomaly_core_part = sdk.to_managed_object(args[2]);

		this.on_anomaly_core_break(anomaly_core_part);
	end, function(retval)
		return retval;
	end);
end

return this;
