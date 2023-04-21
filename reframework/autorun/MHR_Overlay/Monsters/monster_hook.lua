local this = {};

local small_monster;
local large_monster;
local config;
local ailments;
local players;
local quest_status;

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

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_update_method = enemy_character_base_type_def:get_method("update");

local is_boss_enemy_method = enemy_character_base_type_def:get_method("get_isBossEnemy");

local enemy_damage_check_type_def = sdk.find_type_definition("snow.enemy.EnemyDamageCheck");
local damage_check_update_param_update_method = enemy_damage_check_type_def:get_method("updateParam");
local get_ref_enemy = enemy_damage_check_type_def:get_method("get_RefEnemy");

local anger_param_type_def = sdk.find_type_definition("snow.enemy.EnemyAngerParam");
local anger_add_method = anger_param_type_def:get_method("add");

local stamina_param_type_def = sdk.find_type_definition("snow.enemy.EnemyStaminaParam");
local stamina_sub_method = stamina_param_type_def:get_method("sub");
local get_enemy_method = stamina_param_type_def:get_method("get_Em");

local tick_count = 0;
local last_update_tick = 0;
local recorded_monsters = {};
local updated_monsters = {};
local known_big_monsters = {};
local num_known_monsters = 0;
local num_updated_monsters = 0;

local updates_this_tick = 0;

-- run every tick to keep track of msonsters
-- whenever we've updated enough monsters to surpass how many we've seen,
-- we reset and start over
-- this allows us to only update N monsters per tick to save on performance
-- the reason for this is that the hooks on all the monsters' update functions
-- causes a HUGE performance hit (adds ~3+ ms to UpdateBehavior and frame time)
re.on_pre_application_entry("UpdateBehavior", function()
	tick_count = tick_count + 1;
	updates_this_tick = 0;

	if num_known_monsters ~= 0 and num_updated_monsters >= num_known_monsters or tick_count >= num_known_monsters * 2 then
		recorded_monsters = {};
		updated_monsters = {};
		known_big_monsters = {};
		last_update_tick = 0;
		tick_count = 0;
		num_known_monsters = 0;
		num_updated_monsters = 0;
		updates_this_tick = 0;
	end
end)

function this.update_monster(enemy)
	if enemy == nil then
		return;
	end

	if not recorded_monsters[enemy] then
		num_known_monsters = num_known_monsters + 1;
		recorded_monsters[enemy] = true;
	end

	-- saves on a method call.
	if not known_big_monsters[enemy] then
		known_big_monsters[enemy] = is_boss_enemy_method:call(enemy);
	end

	local is_large = known_big_monsters[enemy];
	if is_large == nil then
		return;
	end

	if is_large then
		this.update_large_monster(enemy);
	else
		this.update_small_monster(enemy);
	end
end

function this.update_large_monster(enemy)
	local cached_config = config.current_config.large_monster_UI;

	if not cached_config.dynamic.enabled and
		not cached_config.static.enabled and
		not cached_config.highlighted.enabled then
		return;
	end

	local monster = large_monster.get_monster(enemy);

	-- this is the VERY LEAST thing we should do all the time
	-- so the position doesn't lag all over the place
	-- due to how infrequently we update the monster(s).
	large_monster.update_position(enemy, monster);

	if not config.current_config.global_settings.performance.prioritize_large_monsters and updated_monsters[enemy] then
		return;
	end

	-- is it old tick?
	-- is update limit reached?
	if tick_count == last_update_tick and
		updates_this_tick >= config.current_config.global_settings.performance.max_monster_updates_per_tick then
		return;
	end

	-- actually update the enemy now. we don't do this very often
	-- due to how much CPU time it takes to update each monster.
	if not config.current_config.global_settings.performance.prioritize_large_monsters then
		updates_this_tick = updates_this_tick + 1;
		last_update_tick = tick_count;
		num_updated_monsters = num_updated_monsters + 1;
		updated_monsters[enemy] = true;
	end

	large_monster.update_stamina_timer(enemy, monster, nil);
	large_monster.update_rage_timer(enemy, monster, nil);

	if quest_status.is_online and players.myself.id ~= 0 then
		local physical_param = large_monster.update_health(enemy, monster);
		pcall(large_monster.update_parts, enemy, monster, physical_param);
	end

	large_monster.update(enemy, monster);
end

function this.update_small_monster(enemy)
	if not config.current_config.small_monster_UI.enabled then
		return;
	end

	local monster = small_monster.get_monster(enemy);

	-- this is the VERY LEAST thing we should do all the time
	-- so the position doesn't lag all over the place
	-- due to how infrequently we update the monster(s).
	small_monster.update_position(enemy, monster);

	if updated_monsters[enemy] then
		return;
	end

	-- is it old tick?
	-- is update limit reached?
	if tick_count == last_update_tick and
		updates_this_tick >= config.current_config.global_settings.performance.max_monster_updates_per_tick then
		return;
	end

	-- actually update the enemy now. we don't do this very often
	-- due to how much CPU time it takes to update each monster.
	updates_this_tick = updates_this_tick + 1;
	last_update_tick = tick_count;
	num_updated_monsters = num_updated_monsters + 1;
	updated_monsters[enemy] = true;

	small_monster.update(enemy, monster);

	if quest_status.is_online and players.myself.id ~= 0 then
		small_monster.update_health(enemy, monster);
	end
end

function this.update_health(enemy_damage_check)
	local enemy = get_ref_enemy:call(enemy_damage_check);
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
		pcall(large_monster.update_parts, enemy, monster, physical_param);
	else
		local monster = small_monster.get_monster(enemy);
		small_monster.update_health(enemy, monster);
	end
end

function this.update_stamina(stamina_param, stamina_sub)
	if stamina_sub <= 0 then
		return;
	end

	local enemy = get_enemy_method:call(stamina_param);
	if enemy == nil then
		return;
	end

	local monster = large_monster.get_monster(enemy);
	large_monster.update_stamina(enemy, monster, stamina_param);
end

function this.update_stamina_timer(stamina_param, enemy)
	local monster = large_monster.get_monster(enemy);
	large_monster.update_stamina_timer(enemy, monster, stamina_param);
end

function this.update_rage(anger_param, anger_add, enemy)
	if anger_add <= 0 then
		return;
	end

	local monster = large_monster.get_monster(enemy);
	large_monster.update_rage(enemy, monster, anger_param);
end

function this.update_rage_timer(anger_param, enemy)
	local monster = large_monster.get_monster(enemy);
	large_monster.update_rage_timer(enemy, monster, anger_param);
end

function this.init_module()
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	config = require("MHR_Overlay.Misc.config");
	ailments = require("MHR_Overlay.Monsters.ailments");
	players = require("MHR_Overlay.Damage_Meter.players");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");

	sdk.hook(enemy_character_base_update_method, function(args)
		pcall(this.update_monster, sdk.to_managed_object(args[2]));
	end, function(retval)
		return retval;
	end);

	sdk.hook(damage_check_update_param_update_method, function(args)
		pcall(this.update_health, sdk.to_managed_object(args[2]));
	end, function(retval)
		return retval;
	end);

	sdk.hook(stamina_sub_method, function(args)
		pcall(this.update_stamina, sdk.to_managed_object(args[2]), sdk.to_float(args[3]));
	end, function(retval)
		return retval;
	end);

	sdk.hook(anger_add_method, function(args)
		pcall(this.update_rage, sdk.to_managed_object(args[2]), sdk.to_float(args[3]),
			sdk.to_managed_object(args[4]));
	end, function(retval)
		return retval;
	end);
end

return this;
