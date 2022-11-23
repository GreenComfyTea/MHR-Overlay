local ailments = {};
local player;
local language;
local config;
local ailment_UI_entity;
local ailment_buildup_UI_entity;
local time;
local small_monster;
local large_monster;
local table_helpers;

--0 Paralyze
--1 Sleep
--2 Stun
--3 Flash
--4 Poison
--5 Blast
--6 Stamina
--7 MarionetteStart
--8 Water
--9 Fire
--10 Ice
--11 Thunder
--12 FallTrap
--13 ShockTrap
--14 Capture
--15 Koyashi
--16 SteelFang

ailments.paralyze_id = 0;
ailments.sleep_id = 1;
ailments.stun_id = 2;
ailments.flash_id = 3;
ailments.poison_id = 4;
ailments.blast_id = 5;
ailments.exhaust_id = 6;
ailments.ride_id = 7;
ailments.water_id = 8;
ailments.fire_id = 9;
ailments.ice_id = 10;
ailments.thunder_id = 11;
ailments.fall_trap_id = 12;
ailments.shock_trap_id = 13;
ailments.capture_id = 14 --tranq bomb
ailments.koyashi_id = 15;  --dung bomb
ailments.steel_fang_id = 16;

ailments.fall_quick_sand_id = 17;
ailments.fall_otomo_trap_id = 18;
ailments.shock_otomo_trap_id = 19;

function ailments.new(_ailments, ailment_id)
	_ailments[ailment_id] = {};

	_ailments[ailment_id].is_enable = true;
	_ailments[ailment_id].id = ailment_id;

	_ailments[ailment_id].total_buildup = 0;
	_ailments[ailment_id].buildup_limit = 0;
	_ailments[ailment_id].buildup_percentage = 0;

	_ailments[ailment_id].timer = 0;
	_ailments[ailment_id].duration = 100000;
	_ailments[ailment_id].timer_percentage = 0;

	_ailments[ailment_id].minutes_left = 0;
	_ailments[ailment_id].seconds_left = 0;

	_ailments[ailment_id].is_active = false;
	_ailments[ailment_id].activate_count = 0;

	_ailments[ailment_id].last_change_time = time.total_elapsed_script_seconds;

	if ailment_id == ailments.paralyze_id then
		_ailments[ailment_id].name = language.current_language.ailments.paralysis;
	elseif ailment_id == ailments.sleep_id then
		_ailments[ailment_id].name = language.current_language.ailments.sleep;
	elseif ailment_id == ailments.stun_id then
		_ailments[ailment_id].name = language.current_language.ailments.stun;
	elseif ailment_id == ailments.flash_id then
		_ailments[ailment_id].name = language.current_language.ailments.flash;
	elseif ailment_id == ailments.poison_id then
		_ailments[ailment_id].name = language.current_language.ailments.poison;
	elseif ailment_id == ailments.blast_id then
		_ailments[ailment_id].name = language.current_language.ailments.blast;
	elseif ailment_id == ailments.exhaust_id then
		_ailments[ailment_id].name = language.current_language.ailments.exhaust;
	elseif ailment_id == ailments.ride_id then
		_ailments[ailment_id].name = language.current_language.ailments.ride;
	elseif ailment_id == ailments.water_id then
		_ailments[ailment_id].name = language.current_language.ailments.waterblight;
	elseif ailment_id == ailments.fire_id then
		_ailments[ailment_id].name = language.current_language.ailments.fireblight;
	elseif ailment_id == ailments.ice_id then
		_ailments[ailment_id].name = language.current_language.ailments.iceblight;
	elseif ailment_id == ailments.thunder_id then
		_ailments[ailment_id].name = language.current_language.ailments.thunderblight;
	elseif ailment_id == ailments.fall_trap_id then
		_ailments[ailment_id].name = language.current_language.ailments.fall_trap;
	elseif ailment_id == ailments.shock_trap_id then
		_ailments[ailment_id].name = language.current_language.ailments.shock_trap;
	elseif ailment_id == ailments.capture_id then
		_ailments[ailment_id].name = language.current_language.ailments.tranq_bomb;
	elseif ailment_id == ailments.koyashi_id then
		_ailments[ailment_id].name = language.current_language.ailments.dung_bomb;
	elseif ailment_id == ailments.steel_fang_id then
		_ailments[ailment_id].name = language.current_language.ailments.steel_fang;
	elseif ailment_id == ailments.fall_quick_sand_id then
		_ailments[ailment_id].name = language.current_language.ailments.quick_sand;
	elseif ailment_id == ailments.fall_otomo_trap_id then
		_ailments[ailment_id].name = language.current_language.ailments.fall_otomo_trap;
	elseif ailment_id == ailments.shock_otomo_trap_id then
		_ailments[ailment_id].name = language.current_language.ailments.shock_otomo_trap;
	end
end

function ailments.init_ailments()
	local _ailments = {};

	ailments.new(_ailments, ailments.paralyze_id);
	ailments.new(_ailments, ailments.sleep_id);
	ailments.new(_ailments, ailments.stun_id);
	ailments.new(_ailments, ailments.flash_id);
	ailments.new(_ailments, ailments.poison_id);
	ailments.new(_ailments, ailments.blast_id);
	ailments.new(_ailments, ailments.exhaust_id);
	ailments.new(_ailments, ailments.ride_id);
	ailments.new(_ailments, ailments.water_id);
	ailments.new(_ailments, ailments.fire_id);
	ailments.new(_ailments, ailments.ice_id);
	ailments.new(_ailments, ailments.thunder_id);

	ailments.new(_ailments, ailments.fall_trap_id);
	ailments.new(_ailments, ailments.shock_trap_id);
	ailments.new(_ailments, ailments.capture_id); --tranq bomb
	ailments.new(_ailments, ailments.koyashi_id); --dung bomb
	ailments.new(_ailments, ailments.steel_fang_id);
	--ailments.new(_ailments, ailments.fall_quick_sand_id);
	--ailments.new(_ailments, ailments.fall_otomo_trap_id);
	--ailments.new(_ailments, ailments.shock_otomo_trap_id);

	_ailments[ailments.poison_id].buildup = {};
	_ailments[ailments.poison_id].buildup_share = {};
	_ailments[ailments.poison_id].cached_buildup_share = {};

	_ailments[ailments.blast_id].buildup = {};
	_ailments[ailments.blast_id].buildup_share = {};

	_ailments[ailments.stun_id].buildup = {};
	_ailments[ailments.stun_id].buildup_share = {};

	return _ailments;
end

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_condition_damage_param_base_type_def = sdk.find_type_definition("snow.enemy.EnemyConditionDamageParamBase");

local damage_param_field = enemy_character_base_type_def:get_field("<DamageParam>k__BackingField");
local damage_param_type = damage_param_field:get_type();
local get_condition_param_method = damage_param_type:get_method("get_ConditionParam");

local stun_param_field = damage_param_type:get_field("_StunParam");
local poison_param_field = damage_param_type:get_field("_PoisonParam");
local blast_param_field = damage_param_type:get_field("_BlastParam");


local poison_param_type = poison_param_field:get_type();
local blast_param_type = blast_param_field:get_type();

local get_is_enable_method = enemy_condition_damage_param_base_type_def:get_method("get_IsEnable");
local get_is_active_method = enemy_condition_damage_param_base_type_def:get_method("get_IsActive");
local get_activate_count_method = enemy_condition_damage_param_base_type_def:get_method("get_ActivateCount");
local get_stock_method = enemy_condition_damage_param_base_type_def:get_method("get_Stock");
local get_limit_method = enemy_condition_damage_param_base_type_def:get_method("get_Limit");
local get_active_time_method = enemy_condition_damage_param_base_type_def:get_method("get_ActiveTime");
local get_active_timer_method = enemy_condition_damage_param_base_type_def:get_method("get_ActiveTimer");

local poison_damage_field = poison_param_type:get_field("<Damage>k__BackingField");
local poison_get_is_damage_method = poison_param_type:get_method("get_IsDamage");

local system_array_type_def = sdk.find_type_definition("System.Array");
local length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

function ailments.update_ailments(enemy, monster)
	if enemy == nil then
		return;
	end
	local damage_param = damage_param_field:get_data(enemy);
	if damage_param == nil then
		return;
	end

	ailments.update_stun_poison_blast_ailments(monster, damage_param);

	if not config.current_config.large_monster_UI.dynamic.ailments.visibility
		and not config.current_config.large_monster_UI.static.ailments.visibility
		and not config.current_config.large_monster_UI.highlighted.ailments.visibility
		and not config.current_config.small_monster_UI.ailments.visibility
		and not config.current_config.large_monster_UI.dynamic.ailment_buildups.visibility
		and not config.current_config.large_monster_UI.static.ailment_buildups.visibility
		and not config.current_config.small_monster_UI.ailment_buildups.visibility then
		return;
	end

	local condition_param_array = get_condition_param_method:call(damage_param);

	if condition_param_array == nil then
		return;
	end

	local condition_param_array_length = length_method:call(condition_param_array);
	if condition_param_array_length == nil then
		return;
	end

	for id = 0, condition_param_array_length - 1 do
		if id == ailments.stun_id or id == ailments.poison_id or id == ailments.blast_id then
			goto continue
		end

		local ailment_param = get_value_method:call(condition_param_array, id);
		if ailment_param == nil then
			goto continue
		end

		ailments.update_ailment(monster, ailment_param, id);
		::continue::
	end
end

function ailments.update_stun_poison_blast_ailments(monster, damage_param)
	local stun_param = stun_param_field:get_data(damage_param);
	if stun_param ~= nil then
		ailments.update_ailment(monster, stun_param, ailments.stun_id);
	end

	local poison_param = poison_param_field:get_data(damage_param);
	if poison_param ~= nil then
		ailments.update_ailment(monster, poison_param, ailments.poison_id);
	end

	local blast_param = blast_param_field:get_data(damage_param);
	if blast_param ~= nil then
		ailments.update_ailment(monster, blast_param, ailments.blast_id);
	end
end

function ailments.update_ailment(monster, ailment_param, id)
	local is_enable = get_is_enable_method:call(ailment_param);
	local activate_count_array = get_activate_count_method:call(ailment_param);
	local buildup_array = get_stock_method:call(ailment_param);
	local buildup_limit_array = get_limit_method:call(ailment_param);
	local timer = get_active_timer_method:call(ailment_param);
	local duration = get_active_time_method:call(ailment_param);
	local is_active = get_is_active_method:call(ailment_param);

	local activate_count = -999;
	local buildup = -999;
	local buildup_limit = 9999;
	
	if activate_count_array ~= nil then
		local activate_count_array_length = length_method:call(activate_count_array);

		if activate_count_array_length ~= nil then

			if activate_count_array_length > 0 then
				local activate_count_valuetype = get_value_method:call(activate_count_array, 0);

				if activate_count_valuetype ~= nil then
					local _activate_count = activate_count_valuetype:get_field("mValue");

					if _activate_count ~= nil then
						activate_count = _activate_count;
					end
				end
			end
		end
	end
	
	if buildup_array ~= nil then
		local buildup_array_length = length_method:call(buildup_array);

		if buildup_array_length ~= nil then 

			if buildup_array_length > 0 then
				local buildup_valuetype = get_value_method:call(buildup_array, 0);

				if buildup_valuetype ~= nil then
					local _buildup = buildup_valuetype:get_field("mValue");

					if _buildup ~= nil then
						buildup = _buildup;
					end
				end
			end
		end
	end
	
	if buildup_limit_array ~= nil then
		local buildup_limit_array_length = length_method:call(buildup_limit_array);

		if buildup_limit_array_length ~= nil then 

			if buildup_limit_array_length > 0 then
				local buildup_limit_valuetype = get_value_method:call(buildup_limit_array, 0);

				if buildup_limit_valuetype ~= nil then
					local _buildup_limit = buildup_limit_valuetype:get_field("mValue");

					if _buildup_limit ~= nil then
						buildup_limit = _buildup_limit;
					end
				end
			end
		end
	end

	if is_enable == nil then
		is_enable = true;
	end
	
	if is_enable ~= monster.ailments[id].is_enable then
		ailments.update_last_change_time(monster, id);
	end
	
	monster.ailments[id].is_enable = is_enable;
	
	if activate_count ~= nil then
		if activate_count ~= monster.ailments[id].activate_count then
			ailments.update_last_change_time(monster, id);

			if id == ailments.stun_id then
				ailments.clear_ailment_contribution(monster, ailments.stun_id);
			end
		end

		monster.ailments[id].activate_count = activate_count;
	end
	
	if buildup ~= nil then
		if buildup ~= monster.ailments[id].total_buildup then
			ailments.update_last_change_time(monster, id);
		end

		monster.ailments[id].total_buildup = buildup;
	end
	
	if buildup_limit ~= nil then
		if buildup_limit ~= monster.ailments[id].buildup_limit then
			ailments.update_last_change_time(monster, id);
		end

		monster.ailments[id].buildup_limit = buildup_limit;
	end
	
	if buildup ~= nil and buildup_limit ~= nil and buildup_limit ~= 0 then
		monster.ailments[id].buildup_percentage = buildup / buildup_limit;
	end
	
	if timer ~= nil then
		if timer ~= monster.ailments[id].timer then
			ailments.update_last_change_time(monster, id);
		end

		monster.ailments[id].timer = timer;
	end
	
	if is_active ~= nil then
		if is_active ~= monster.ailments[id].is_active then
			ailments.update_last_change_time(monster, id);
		end

		monster.ailments[id].is_active = is_active;
	end
	
	if duration ~= nil and not monster.ailments[id].is_active then
		if duration ~= monster.ailments[id].duration then
			ailments.update_last_change_time(monster, id);
		end

		monster.ailments[id].duration = duration;
	end
	
	if duration ~= 0 and duration ~= nil then
		monster.ailments[id].timer_percentage = timer / monster.ailments[id].duration;
	end
	
	if is_active then
		if timer < 0 then
			timer = 0;
		end

		local minutes_left = math.floor(timer / 60);
		local seconds_left = timer - 60 * minutes_left;

		if duration ~= 0 then
			monster.ailments[id].timer_percentage = timer / monster.ailments[id].duration;
		end

		monster.ailments[id].minutes_left = minutes_left;
		monster.ailments[id].seconds_left = seconds_left;
	end
end

function ailments.update_last_change_time(monster, id)
	monster.ailments[id].last_change_time = time.total_elapsed_script_seconds;
end

-- Code by coavins
function ailments.update_poison(monster, poison_param)
	if monster == nil then
		return;
	end

	if poison_param ~= nil then
		--if poison tick, apply damage
		local is_damage = poison_get_is_damage_method:call(poison_param);
		if is_damage then
			local poison_damage = poison_damage_field:get_data(poison_param);

			ailments.apply_ailment_damage(monster, ailments.poison_id, poison_damage);
		end
	end
end

function ailments.draw(monster, ailment_UI, cached_config, ailments_position_on_screen, opacity_scale)
	local cached_config = cached_config.ailments;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	--sort parts here
	local displayed_ailments = {};
	for id, ailment in pairs(monster.ailments) do
		if id == ailments.paralyze_id then
			if not cached_config.filter.paralysis then
				goto continue
			end
		elseif id == ailments.sleep_id then
			if not cached_config.filter.sleep then
				goto continue
			end
		elseif id == ailments.stun_id then
			if not cached_config.filter.stun then
				goto continue
			end
		elseif id == ailments.flash_id then
			if not cached_config.filter.flash then
				goto continue
			end
		elseif id == ailments.poison_id then
			if not cached_config.filter.poison then
				goto continue
			end
		elseif id == ailments.blast_id then
			if not cached_config.filter.blast then
				goto continue
			end
		elseif id == ailments.exhaust_id then
			if not cached_config.filter.exhaust then
				goto continue
			end
		elseif id == ailments.ride_id then
			if not cached_config.filter.ride then
				goto continue
			end
		elseif id == ailments.water_id then
			if not cached_config.filter.waterblight then
				goto continue
			end
		elseif id == ailments.fire_id then
			if not cached_config.filter.fireblight then
				goto continue
			end
		elseif id == ailments.ice_id then
			if not cached_config.filter.iceblight then
				goto continue
			end
		elseif id == ailments.thunder_id then
			if not cached_config.filter.thunderblight then
				goto continue
			end
		elseif id == ailments.fall_trap_id then
			if not cached_config.filter.fall_trap then
				goto continue
			end
		elseif id == ailments.shock_trap_id then
			if not cached_config.filter.shock_trap then
				goto continue
			end
		elseif id == ailments.capture_id then
			if not cached_config.filter.tranq_bomb then
				goto continue
			end
		elseif id == ailments.koyashi_id then
			if not cached_config.filter.dung_bomb then
				goto continue
			end
		elseif id == ailments.steel_fang_id then
			if not cached_config.filter.steel_fang then
				goto continue
			end
		elseif id == ailments.fall_quick_sand_id then
			if not cached_config.filter.quick_sand then
				goto continue
			end
		elseif id == ailments.fall_otomo_trap_id then
			if not cached_config.filter.fall_otomo_trap then
				goto continue
			end
		elseif id == ailments.shock_otomo_trap_id then
			if not cached_config.filter.shock_otomo_trap then
				goto continue
			end
		else
			goto continue
		end

		if cached_config.settings.hide_ailments_with_zero_buildup and ailment.total_buildup == 0 and
			ailment.buildup_limit ~= 0
			and ailment.activate_count == 0 and not ailment.is_active then
			goto continue
		end

		if cached_config.settings.hide_inactive_ailments_with_no_buildup_support and ailment.buildup_limit == 0 and
			not ailment.is_active then
			goto continue
		end

		if cached_config.settings.hide_all_inactive_ailments and not ailment.is_active then
			goto continue
		end

		if cached_config.settings.hide_all_active_ailments and ailment.is_active then
			goto continue
		end

		if cached_config.settings.hide_disabled_ailments and not ailment.is_enable then
			goto continue
		end

		if cached_config.settings.time_limit ~= 0 and
			time.total_elapsed_script_seconds - ailment.last_change_time > cached_config.settings.time_limit and
			not ailment.is_active then
			goto continue
		end

		table.insert(displayed_ailments, ailment);
		::continue::
	end


	if cached_config.sorting.type == "Normal" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_ailments, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_ailments, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif cached_config.sorting.type == "Buildup" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_ailments, function(left, right)
				return left.total_buildup > right.total_buildup;
			end);
		else
			table.sort(displayed_ailments, function(left, right)
				return left.total_buildup < right.total_buildup;
			end);
		end
	elseif cached_config.sorting.type == "Buildup Percentage" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_ailments, function(left, right)
				return left.buildup_percentage > right.buildup_percentage;
			end);
		else
			table.sort(displayed_ailments, function(left, right)
				return left.buildup_percentage < right.buildup_percentage;
			end);
		end
	end

	for j, ailment in ipairs(displayed_ailments) do
		local ailment_position_on_screen = {
			x = ailments_position_on_screen.x + cached_config.spacing.x * (j - 1) * global_scale_modifier,
			y = ailments_position_on_screen.y + cached_config.spacing.y * (j - 1) * global_scale_modifier;
		}

		ailment_UI_entity.draw(ailment, ailment_UI, cached_config, ailment_position_on_screen, opacity_scale);
	end


end

function ailments.apply_ailment_buildup(monster, attacker_id, ailment_type, ailment_buildup)

	if monster == nil or
		(ailment_type ~= ailments.poison_id and ailment_type ~= ailments.blast_id and ailment_type ~= ailments.stun_id) then
		return;
	end

	if ailment_buildup == 0 or ailment_buildup == nil then
		return;
	end

	-- get the buildup accumulator for this type
	if monster.ailments[ailment_type].buildup == nil then
		monster.ailments[ailment_type].buildup = {};
	end

	-- accumulate this buildup for this attacker
	monster.ailments[ailment_type].buildup[attacker_id] = (monster.ailments[ailment_type].buildup[attacker_id] or 0) + ailment_buildup;

	ailments.calculate_ailment_contribution(monster, ailment_type);
end

-- Code by coavins
function ailments.calculate_ailment_contribution(monster, ailment_type)
	-- get total
	local total = 0;
	for attacker_id, player_buildup in pairs(monster.ailments[ailment_type].buildup) do
		total = total + player_buildup;
	end

	for attacker_id, player_buildup in pairs(monster.ailments[ailment_type].buildup) do
		-- update ratio for this attacker
		monster.ailments[ailment_type].buildup_share[attacker_id] = player_buildup / total;
	end
end

function ailments.clear_ailment_contribution(monster, ailment_type)
	for attacker_id, player_buildup in pairs(monster.ailments[ailment_type].buildup) do
		monster.ailments[ailment_type].buildup_share[attacker_id] = 0;
		monster.ailments[ailment_type].buildup[attacker_id] = 0;
	end
end

-- Code by coavins
function ailments.apply_ailment_damage(monster, ailment_type, ailment_damage)
	-- we only track poison and blast for now
	if ailment_type == nil or ailment_damage == nil then
		return;
	end

	local damage_source_type = "";
	local buildup_share = monster.ailments[ailment_type].buildup_share;
	if ailment_type == ailments.poison_id then
		damage_source_type = "poison";
		buildup_share = monster.ailments[ailment_type].cached_buildup_share;
	elseif ailment_type == ailments.blast_id then
		damage_source_type = "blast";
	else
		return;
	end

	-- split up damage according to ratio of buildup on boss for this type
	for attacker_id, percentage in pairs(buildup_share) do
		local damage_portion = ailment_damage * percentage;

		local damage_object = {};
		damage_object.total_damage = damage_portion;
		damage_object.physical_damage = 0;
		damage_object.elemental_damage = 0;
		damage_object.ailment_damage = damage_portion;

		local attacking_player = player.get_player(attacker_id);

		if attacking_player ~= nil then
			player.update_damage(attacking_player, damage_source_type, true, damage_object);
		end
	end

	local damage_object = {};
	damage_object.total_damage = ailment_damage;
	damage_object.physical_damage = 0;
	damage_object.elemental_damage = 0;
	damage_object.ailment_damage = ailment_damage;

	player.update_damage(player.total, damage_source_type, true, damage_object);
end

function ailments.init_module()
	player = require("MHR_Overlay.Damage_Meter.player");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
	ailment_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_UI_entity");
	ailment_buildup_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_buildup_UI_entity");
	time = require("MHR_Overlay.Game_Handler.time");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
end

return ailments;
