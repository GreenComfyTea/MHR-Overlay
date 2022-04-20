local ailments = {};
local player;
local language;
local config;
local ailment_UI_entity;
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
ailments.sleep_id =    1;
ailments.stun_id =     2;
ailments.flash_id =    3;
ailments.poison_id =   4;
ailments.blast_id =    5;
ailments.exhaust_id =  6;
ailments.mount_id =    7;
ailments.water_id =    8;
ailments.fire_id =     9;
ailments.ice_id =     10;
ailments.thunder_id = 11;
ailments.fall_trap_id = 12;
ailments.shock_trap_id = 13;
ailments.capture_id = 14 --tranq bomb
ailments.koyashi_id = 15; --dung bomb
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

	_ailments[ailment_id].is_active = false;
	_ailments[ailment_id].activate_count = 0;

	_ailments[ailment_id].last_change_time = time.total_elapsed_seconds;

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
	elseif ailment_id == ailments.mount_id then
		_ailments[ailment_id].name = language.current_language.ailments.mount;
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
	ailments.new(_ailments, ailments.mount_id);
	ailments.new(_ailments, ailments.water_id);
	ailments.new(_ailments, ailments.fire_id);
	ailments.new(_ailments, ailments.ice_id);
	ailments.new(_ailments, ailments.thunder_id);

	ailments.new(_ailments, ailments.fall_trap_id);
	ailments.new(_ailments, ailments.shock_trap_id);
	ailments.new(_ailments, ailments.capture_id); --tranq bomb
	ailments.new(_ailments, ailments.koyashi_id); --dung bomb
	ailments.new(_ailments, ailments.steel_fang_id);
	ailments.new(_ailments, ailments.fall_quick_sand_id);
	ailments.new(_ailments, ailments.fall_otomo_trap_id);
	ailments.new(_ailments, ailments.shock_otomo_trap_id);

	_ailments[ailments.poison_id].buildup = {};
	_ailments[ailments.poison_id].buildup_share = {};

	_ailments[ailments.blast_id].buildup = {};
	_ailments[ailments.blast_id].buildup_share = {};

	return _ailments;
end

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_condition_damage_param_base_type_def = sdk.find_type_definition("snow.enemy.EnemyConditionDamageParamBase");

local damage_param_field = enemy_character_base_type_def:get_field("<DamageParam>k__BackingField");
local damage_param_type = damage_param_field:get_type();
local get_condition_param_method = damage_param_type:get_method("get_ConditionParam");

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

local blast_damage_method = blast_param_type:get_method("get_BlastDamage");
local blast_adjust_rate_method = blast_param_type:get_method("get_BlastDamageAdjustRateByEnemyLv");

function ailments.update_ailments(enemy, monster)
	if enemy == nil then
		return;
	end

	local damage_param = damage_param_field:get_data(enemy);
	if damage_param == nil then
		return;
	end

	local condition_param = get_condition_param_method:call(damage_param);

	if condition_param == nil then
		return;
	end

	local condition_param_table = condition_param:get_elements();

	if condition_param == nil then
		return;
	end

	for index, ailment_param in ipairs(condition_param_table) do
		local id = index - 1;

		local is_enable = get_is_enable_method:call(ailment_param);
		local activate_count = get_activate_count_method:call(ailment_param):get_element(0):get_field("mValue");
		local buildup = get_stock_method:call(ailment_param):get_element(0):get_field("mValue");
		local buildup_limit = get_limit_method:call(ailment_param):get_element(0):get_field("mValue");
		local timer = get_active_timer_method:call(ailment_param);
		local duration = get_active_time_method:call(ailment_param);
		local is_active = get_is_active_method:call(ailment_param);
		
		if is_enable ~= nil then
			monster.ailments[id].is_enable = is_enable;
		end

		if activate_count ~= nil then
			monster.ailments[id].activate_count = activate_count;
		end

		if buildup ~= nil then
			monster.ailments[id].total_buildup = buildup;
		end

		if buildup_limit ~= nil then
			monster.ailments[id].buildup_limit = buildup_limit;
		end

		if buildup ~= nil and buildup_limit ~= nil and buildup_limit ~= 0 then
			monster.ailments[id].buildup_percentage = buildup / buildup_limit;
		end

		if timer ~= nil then
			monster.ailments[id].timer = timer;
		end

		if duration ~= nil then
			monster.ailments[id].duration = duration;
		end

		if timer ~= nil and duration ~= nil then
			if duration ~= 0 then
				monster.ailments[id].timer_percentage = timer / duration;
			end
		end

		if is_active ~= nil then
			monster.ailments[id].is_active = is_active;
		end
	end
end

-- Code by coavins
function ailments.update_poison_blast(enemy, is_large)
	if enemy == nil then
		return;
	end

	local monster;
	if is_large then
		monster	= large_monster.get_monster(enemy);
	else
		monster	= small_monster.get_monster(enemy);
	end 

	local damage_param = damage_param_field:get_data(enemy);
	if damage_param ~= nil then

		local poison_param = poison_param_field:get_data(damage_param);
		if poison_param ~= nil then
			-- if applied, then calculate share for poison
			local activate_count = get_activate_count_method:call(poison_param):get_element(0):get_field("mValue");

			if activate_count > monster.ailments[ailments.poison_id].activate_count then
				monster.ailments[ailments.poison_id].activate_count = activate_count;
				ailments.calculate_ailment_contribution(monster, ailments.poison_id);
			end

			-- if poison tick, apply damage
			local poison_damage = poison_damage_field:get_data(poison_param);
			local is_damage = poison_get_is_damage_method:call(poison_param);

			if is_damage then
				ailments.apply_ailment_damage(monster, ailments.poison_id, poison_damage);
			end
		end

		local blast_param = blast_param_field:get_data(damage_param);
		if blast_param ~= nil then
			-- if applied, then calculate share for blast and apply damage
			local activate_count = get_activate_count_method:call(blast_param):get_element(0):get_field("mValue");

			if activate_count > monster.ailments[ailments.blast_id].activate_count then
				monster.ailments[ailments.blast_id].activate_count = activate_count;
				ailments.calculate_ailment_contribution(monster, ailments.blast_id);

				local blast_damage = blast_damage_method:call(blast_param);
				local blast_adjust_rate = blast_adjust_rate_method:call(blast_param);
				
				ailments.apply_ailment_damage(monster, ailments.blast_id, blast_damage * blast_adjust_rate);
			end
		end
	end
end

function ailments.draw_dynamic(monster, ailments_position_on_screen, opacity_scale)
	--sort parts here
	local displayed_ailments = {};
	for REpart, ailment in pairs(monster.ailments) do
		if config.current_config.large_monster_UI.dynamic.ailments.settings.hide_ailments_with_zero_buildup and ailment.total_buildup == 0 and ailment.buildup_limit ~= 0 and ailment.activate_count == 0 then
			goto continue;
		end

		if config.current_config.large_monster_UI.dynamic.ailments.settings.hide_inactive_ailments_with_no_buildup_support and ailment.buildup_limit == 0 then
			goto continue;
		end

		if config.current_config.large_monster_UI.dynamic.ailments.settings.hide_all_inactive_ailments and not ailment.is_active then
			goto continue;
		end

		if config.current_config.large_monster_UI.dynamic.ailments.settings.hide_all_active_ailments and ailment.is_active then
			goto continue;
		end

		if config.current_config.large_monster_UI.dynamic.ailments.settings.hide_disabled_ailments and not ailment.is_enable then
			goto continue;
		end

		if config.current_config.large_monster_UI.dynamic.ailments.settings.time_limit ~= 0 and time.total_elapsed_seconds - ailment.last_change_time > config.current_config.large_monster_UI.dynamic.ailments.settings.time_limit then
			goto continue;
		end

		table.insert(displayed_ailments, ailment);
		::continue::
	end
	

	if config.current_config.large_monster_UI.dynamic.ailments.sorting.type == "Normal" then
		if config.current_config.large_monster_UI.dynamic.ailments.sorting.reversed_order then
			table.sort(displayed_ailments, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_ailments, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif config.current_config.large_monster_UI.dynamic.ailments.sorting.type == "Buildup" then
		if config.current_config.large_monster_UI.dynamic.ailments.sorting.reversed_order then
			table.sort(displayed_ailments, function(left, right)
				return left.total_buildup > right.total_buildup;
			end);
		else
			table.sort(displayed_ailments, function(left, right)
				return left.total_buildup < right.total_buildup;
			end);
		end
	elseif config.current_config.large_monster_UI.dynamic.ailments.sorting.type == "Buildup Percentage" then
		if config.current_config.large_monster_UI.dynamic.ailments.sorting.reversed_order then
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
			x = ailments_position_on_screen.x + config.current_config.large_monster_UI.dynamic.ailments.spacing.x * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = ailments_position_on_screen.y + config.current_config.large_monster_UI.dynamic.ailments.spacing.y * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier;
		}
		ailment_UI_entity.draw_dynamic(ailment, monster.ailment_dynamic_UI, ailment_position_on_screen, opacity_scale);
	end


end

function ailments.draw_static(monster, ailments_position_on_screen, opacity_scale)
	--sort parts here
	local displayed_ailments = {};
	for REpart, ailment in pairs(monster.ailments) do
		if config.current_config.large_monster_UI.static.ailments.settings.hide_ailments_with_zero_buildup and ailment.total_buildup == 0 and ailment.buildup_limit ~= 0 and ailment.activate_count == 0 then
			goto continue;
		end

		if config.current_config.large_monster_UI.static.ailments.settings.hide_inactive_ailments_with_no_buildup_support and ailment.buildup_limit == 0 then
			goto continue;
		end

		if config.current_config.large_monster_UI.static.ailments.settings.hide_all_inactive_ailments and not ailment.is_active then
			goto continue;
		end

		if config.current_config.large_monster_UI.static.ailments.settings.hide_all_active_ailments and ailment.is_active then
			goto continue;
		end

		if config.current_config.large_monster_UI.static.ailments.settings.hide_disabled_ailments and not ailment.is_enable then
			goto continue;
		end

		if config.current_config.large_monster_UI.static.ailments.settings.time_limit ~= 0 and time.total_elapsed_seconds - ailment.last_change_time > config.current_config.large_monster_UI.static.ailments.settings.time_limit then
			goto continue;
		end

		table.insert(displayed_ailments, ailment);
		::continue::
	end
	

	if config.current_config.large_monster_UI.static.ailments.sorting.type == "Normal" then
		if config.current_config.large_monster_UI.static.ailments.sorting.reversed_order then
			table.sort(displayed_ailments, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_ailments, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif config.current_config.large_monster_UI.static.ailments.sorting.type == "Buildup" then
		if config.current_config.large_monster_UI.static.ailments.sorting.reversed_order then
			table.sort(displayed_ailments, function(left, right)
				return left.total_buildup > right.total_buildup;
			end);
		else
			table.sort(displayed_ailments, function(left, right)
				return left.total_buildup < right.total_buildup;
			end);
		end
	elseif config.current_config.large_monster_UI.static.ailments.sorting.type == "Buildup Percentage" then
		if config.current_config.large_monster_UI.static.ailments.sorting.reversed_order then
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
			x = ailments_position_on_screen.x + config.current_config.large_monster_UI.static.ailments.spacing.x * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = ailments_position_on_screen.y + config.current_config.large_monster_UI.static.ailments.spacing.y * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier;
		}
		
		ailment_UI_entity.draw_static(ailment, monster.ailment_static_UI, ailment_position_on_screen, opacity_scale);
	end
end

function ailments.draw_highlighted(monster, ailments_position_on_screen, opacity_scale)
	--sort parts here
	local displayed_ailments = {};
	for id, ailment in pairs(monster.ailments) do
		if config.current_config.large_monster_UI.highlighted.ailments.settings.hide_ailments_with_zero_buildup and ailment.total_buildup == 0 and ailment.buildup_limit ~= 0 and ailment.activate_count == 0 then
			goto continue;
		end

		if config.current_config.large_monster_UI.highlighted.ailments.settings.hide_inactive_ailments_with_no_buildup_support and ailment.buildup_limit == 0 then
			goto continue;
		end

		if config.current_config.large_monster_UI.highlighted.ailments.settings.hide_all_inactive_ailments and not ailment.is_active then
			goto continue;
		end

		if config.current_config.large_monster_UI.highlighted.ailments.settings.hide_all_active_ailments and ailment.is_active then
			goto continue;
		end

		if config.current_config.large_monster_UI.highlighted.ailments.settings.hide_disabled_ailments and not ailment.is_enable then
			goto continue;
		end

		if config.current_config.large_monster_UI.highlighted.ailments.settings.time_limit ~= 0 and time.total_elapsed_seconds - ailment.last_change_time > config.current_config.large_monster_UI.highlighted.ailments.settings.time_limit then
			goto continue;
		end

		table.insert(displayed_ailments, ailment);
		::continue::
	end
	
	if config.current_config.large_monster_UI.highlighted.ailments.sorting.type == "Normal" then
		if config.current_config.large_monster_UI.highlighted.ailments.sorting.reversed_order then
			table.sort(displayed_ailments, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_ailments, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif config.current_config.large_monster_UI.highlighted.ailments.sorting.type == "Buildup" then
		if config.current_config.large_monster_UI.highlighted.ailments.sorting.reversed_order then
			table.sort(displayed_ailments, function(left, right)
				return left.total_buildup > right.total_buildup;
			end);
		else
			table.sort(displayed_ailments, function(left, right)
				return left.total_buildup < right.total_buildup;
			end);
		end
	elseif config.current_config.large_monster_UI.highlighted.ailments.sorting.type == "Buildup Percentage" then
		if config.current_config.large_monster_UI.highlighted.ailments.sorting.reversed_order then
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
			x = ailments_position_on_screen.x + config.current_config.large_monster_UI.highlighted.ailments.spacing.x * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = ailments_position_on_screen.y + config.current_config.large_monster_UI.highlighted.ailments.spacing.y * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier;
		}
		
		ailment_UI_entity.draw_highlighted(ailment, monster.ailment_highlighted_UI, ailment_position_on_screen, opacity_scale);
	end
end

function ailments.draw_small(monster, ailments_position_on_screen, opacity_scale)
	--sort parts here
	local displayed_ailments = {};
	for REpart, ailment in pairs(monster.ailments) do
		if config.current_config.small_monster_UI.ailments.settings.hide_ailments_with_zero_buildup and ailment.total_buildup == 0 and ailment.buildup_limit ~= 0 and ailment.activate_count == 0 then
			goto continue;
		end

		if config.current_config.small_monster_UI.ailments.settings.hide_inactive_ailments_with_no_buildup_support and ailment.buildup_limit == 0 then
			goto continue;
		end

		if config.current_config.small_monster_UI.ailments.settings.hide_all_inactive_ailments and not ailment.is_active then
			goto continue;
		end

		if config.current_config.small_monster_UI.ailments.settings.hide_all_active_ailments and ailment.is_active then
			goto continue;
		end

		if config.current_config.small_monster_UI.ailments.settings.hide_disabled_ailments and not ailment.is_enable then
			goto continue;
		end

		if config.current_config.small_monster_UI.ailments.settings.time_limit ~= 0 and time.total_elapsed_seconds - ailment.last_change_time > config.current_config.small_monster_UI.ailments.settings.time_limit then
			goto continue;
		end

		table.insert(displayed_ailments, ailment);
		::continue::
	end
	

	if config.current_config.small_monster_UI.ailments.sorting.type == "Normal" then
		if config.current_config.small_monster_UI.ailments.sorting.reversed_order then
			table.sort(displayed_ailments, function(left, right)
				if config.current_config.small_monster_UI.ailments.settings.prioritize_active_ailments and left.is_active then return false; end
				return left.id > right.id;
			end);
		else
			table.sort(displayed_ailments, function(left, right)
				if config.current_config.small_monster_UI.ailments.settings.prioritize_active_ailments and left.is_active then return true; end
				return left.id < right.id;
			end);
		end
	elseif config.current_config.small_monster_UI.ailments.sorting.type == "Buildup" then
		if config.current_config.small_monster_UI.ailments.sorting.reversed_order then
			table.sort(displayed_ailments, function(left, right)
				if config.current_config.small_monster_UI.ailments.settings.prioritize_active_ailments and left.is_active then return false; end
				return left.total_buildup > right.total_buildup;
			end);
		else
			table.sort(displayed_ailments, function(left, right)
				if config.current_config.small_monster_UI.ailments.settings.prioritize_active_ailments and left.is_active then return true; end
				return left.total_buildup < right.total_buildup;
			end);
		end
	elseif config.current_config.small_monster_UI.ailments.sorting.type == "Buildup Percentage" then
		if config.current_config.small_monster_UI.ailments.sorting.reversed_order then
			table.sort(displayed_ailments, function(left, right)
				if config.current_config.small_monster_UI.ailments.settings.prioritize_active_ailments and left.is_active then return false; end
				return left.buildup_percentage > right.buildup_percentage;
			end);
		else
			table.sort(displayed_ailments, function(left, right)
				if config.current_config.small_monster_UI.ailments.settings.prioritize_active_ailments and left.is_active then return true; end
				return left.buildup_percentage < right.buildup_percentage;
			end);
		end
	end

	for j, ailment in ipairs(displayed_ailments) do
		local ailment_position_on_screen = {
			x = ailments_position_on_screen.x + config.current_config.small_monster_UI.ailments.spacing.x * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = ailments_position_on_screen.y + config.current_config.small_monster_UI.ailments.spacing.y * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier;
		}



		ailment_UI_entity.draw_small(ailment, monster.ailment_UI, ailment_position_on_screen, opacity_scale);
	end
end

function ailments.apply_ailment_buildup(monster, attacker_id, ailment_type, ailment_buildup)
	if monster == nil or player == nil or (ailment_type ~= ailments.poison_id and ailment_type ~= ailments.blast_id) then
		return;
	end

	-- get the buildup accumulator for this type
	if monster.ailments[ailment_type].buildup == nil then
		monster.ailments[ailment_type].buildup = {};
	end
	
	-- accumulate this buildup for this attacker
	monster.ailments[ailment_type].buildup[attacker_id] = (monster.ailments[ailment_type].buildup[attacker_id] or 0) + ailment_buildup;
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
		-- clear accumulated buildup for this attacker
		-- they have to start over to earn a share of next ailment trigger
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
	if ailment_type == ailments.poison_id then
		damage_source_type = "poison";
	elseif ailment_type == ailments.blast_id then
		damage_source_type = "blast";
	else
		return;
	end

	local damage = ailment_damage;


	-- split up damage according to ratio of buildup on boss for this type
	for attacker_id, percentage in pairs(monster.ailments[ailment_type].buildup_share) do
		local damage_portion = damage * percentage;
		
		local damage_object = {};
		damage_object.total_damage = damage_portion;
		damage_object.physical_damage = 0;
		damage_object.elemental_damage = 0;
		damage_object.ailment_damage = damage_portion;
		
		local attacking_player = player.get_player(attacker_id);
		
		if attacking_player ~= nil then
			player.update_damage(attacking_player, damage_source_type, true, damage_object);
		end

		player.update_damage(player.total, damage_source_type, true, damage_object);
	end

	
end

function ailments.init_module()
	player = require("MHR_Overlay.Damage_Meter.player");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
	ailment_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_UI_entity");
	time = require("MHR_Overlay.Game_Handler.time");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
end

return ailments;