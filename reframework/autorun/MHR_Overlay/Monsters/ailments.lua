local this = {};

local players;
local language;
local config;
local ailment_UI_entity;
local ailment_buildup_UI_entity;
local time;
local small_monster;
local large_monster;
local non_players;
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

this.paralyze_id = 0;
this.sleep_id = 1;
this.stun_id = 2;
this.flash_id = 3;
this.poison_id = 4;
this.blast_id = 5;
this.exhaust_id = 6;
this.ride_id = 7;
this.water_id = 8;
this.fire_id = 9;
this.ice_id = 10;
this.thunder_id = 11;
this.fall_trap_id = 12;
this.shock_trap_id = 13;
this.capture_id = 14 --tranq bomb
this.koyashi_id = 15;  --dung bomb
this.steel_fang_id = 16;

this.fall_quick_sand_id = 17;
this.fall_otomo_trap_id = 18;
this.shock_otomo_trap_id = 19;

function this.new(_ailments, ailment_id)
	local new_ailment = {}
	new_ailment = {};

	new_ailment.is_enable = true;
	new_ailment.id = ailment_id;

	new_ailment.total_buildup = 0;
	new_ailment.buildup_limit = 0;
	new_ailment.buildup_percentage = 0;

	new_ailment.timer = 0;
	new_ailment.duration = 100000;
	new_ailment.timer_percentage = 0;

	new_ailment.minutes_left = 0;
	new_ailment.seconds_left = 0;

	new_ailment.is_active = false;
	new_ailment.activate_count = 0;

	new_ailment.last_change_time = time.total_elapsed_script_seconds;

	if ailment_id == this.paralyze_id then
		new_ailment.name = language.current_language.ailments.paralysis;
	elseif ailment_id == this.sleep_id then
		new_ailment.name = language.current_language.ailments.sleep;
	elseif ailment_id == this.stun_id then
		new_ailment.name = language.current_language.ailments.stun;
	elseif ailment_id == this.flash_id then
		new_ailment.name = language.current_language.ailments.flash;
	elseif ailment_id == this.poison_id then
		new_ailment.name = language.current_language.ailments.poison;
	elseif ailment_id == this.blast_id then
		new_ailment.name = language.current_language.ailments.blast;
	elseif ailment_id == this.exhaust_id then
		new_ailment.name = language.current_language.ailments.exhaust;
	elseif ailment_id == this.ride_id then
		new_ailment.name = language.current_language.ailments.ride;
	elseif ailment_id == this.water_id then
		new_ailment.name = language.current_language.ailments.waterblight;
	elseif ailment_id == this.fire_id then
		new_ailment.name = language.current_language.ailments.fireblight;
	elseif ailment_id == this.ice_id then
		new_ailment.name = language.current_language.ailments.iceblight;
	elseif ailment_id == this.thunder_id then
		new_ailment.name = language.current_language.ailments.thunderblight;
	elseif ailment_id == this.fall_trap_id then
		new_ailment.name = language.current_language.ailments.fall_trap;
	elseif ailment_id == this.shock_trap_id then
		new_ailment.name = language.current_language.ailments.shock_trap;
	elseif ailment_id == this.capture_id then
		new_ailment.name = language.current_language.ailments.tranq_bomb;
	elseif ailment_id == this.koyashi_id then
		new_ailment.name = language.current_language.ailments.dung_bomb;
	elseif ailment_id == this.steel_fang_id then
		new_ailment.name = language.current_language.ailments.steel_fang;
	elseif ailment_id == this.fall_quick_sand_id then
		new_ailment.name = language.current_language.ailments.quick_sand;
	elseif ailment_id == this.fall_otomo_trap_id then
		new_ailment.name = language.current_language.ailments.fall_otomo_trap;
	elseif ailment_id == this.shock_otomo_trap_id then
		new_ailment.name = language.current_language.ailments.shock_otomo_trap;
	end

	_ailments[ailment_id] = new_ailment;
end

function this.init_ailments()
	local _ailments = {};

	this.new(_ailments, this.paralyze_id);
	this.new(_ailments, this.sleep_id);
	this.new(_ailments, this.stun_id);
	this.new(_ailments, this.flash_id);
	this.new(_ailments, this.poison_id);
	this.new(_ailments, this.blast_id);
	this.new(_ailments, this.exhaust_id);
	this.new(_ailments, this.ride_id);
	this.new(_ailments, this.water_id);
	this.new(_ailments, this.fire_id);
	this.new(_ailments, this.ice_id);
	this.new(_ailments, this.thunder_id);

	this.new(_ailments, this.fall_trap_id);
	this.new(_ailments, this.shock_trap_id);
	this.new(_ailments, this.capture_id); --tranq bomb
	this.new(_ailments, this.koyashi_id); --dung bomb
	this.new(_ailments, this.steel_fang_id);
	--ailments.new(_ailments, ailments.fall_quick_sand_id);
	--ailments.new(_ailments, ailments.fall_otomo_trap_id);
	--ailments.new(_ailments, ailments.shock_otomo_trap_id);

	_ailments[this.poison_id].buildup = {};
	_ailments[this.poison_id].buildup_share = {};
	_ailments[this.poison_id].cached_buildup_share = {};

	_ailments[this.blast_id].buildup = {};
	_ailments[this.blast_id].buildup_share = {};

	_ailments[this.stun_id].buildup = {};
	_ailments[this.stun_id].buildup_share = {};

	_ailments[this.poison_id].otomo_buildup = {};
	_ailments[this.poison_id].otomo_buildup_share = {};
	_ailments[this.poison_id].cached_otomo_buildup_share = {};

	_ailments[this.blast_id].otomo_buildup = {};
	_ailments[this.blast_id].otomo_buildup_share = {};

	_ailments[this.stun_id].otomo_buildup = {};
	_ailments[this.stun_id].otomo_buildup_share = {};

	return _ailments;
end

function this.init_ailment_names(_ailments)
	for ailment_id, ailment in pairs(_ailments) do
		if ailment_id == this.paralyze_id then
			ailment.name = language.current_language.ailments.paralysis;
		elseif ailment_id == this.sleep_id then
			ailment.name = language.current_language.ailments.sleep;
		elseif ailment_id == this.stun_id then
			ailment.name = language.current_language.ailments.stun;
		elseif ailment_id == this.flash_id then
			ailment.name = language.current_language.ailments.flash;
		elseif ailment_id == this.poison_id then
			ailment.name = language.current_language.ailments.poison;
		elseif ailment_id == this.blast_id then
			ailment.name = language.current_language.ailments.blast;
		elseif ailment_id == this.exhaust_id then
			ailment.name = language.current_language.ailments.exhaust;
		elseif ailment_id == this.ride_id then
			ailment.name = language.current_language.ailments.ride;
		elseif ailment_id == this.water_id then
			ailment.name = language.current_language.ailments.waterblight;
		elseif ailment_id == this.fire_id then
			ailment.name = language.current_language.ailments.fireblight;
		elseif ailment_id == this.ice_id then
			ailment.name = language.current_language.ailments.iceblight;
		elseif ailment_id == this.thunder_id then
			ailment.name = language.current_language.ailments.thunderblight;
		elseif ailment_id == this.fall_trap_id then
			ailment.name = language.current_language.ailments.fall_trap;
		elseif ailment_id == this.shock_trap_id then
			ailment.name = language.current_language.ailments.shock_trap;
		elseif ailment_id == this.capture_id then
			ailment.name = language.current_language.ailments.tranq_bomb;
		elseif ailment_id == this.koyashi_id then
			ailment.name = language.current_language.ailments.dung_bomb;
		elseif ailment_id == this.steel_fang_id then
			ailment.name = language.current_language.ailments.steel_fang;
		elseif ailment_id == this.fall_quick_sand_id then
			ailment.name = language.current_language.ailments.quick_sand;
		elseif ailment_id == this.fall_otomo_trap_id then
			ailment.name = language.current_language.ailments.fall_otomo_trap;
		elseif ailment_id == this.shock_otomo_trap_id then
			ailment.name = language.current_language.ailments.shock_otomo_trap;
		end
	end
end

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local get_damage_param_method = enemy_character_base_type_def:get_method("get_DamageParam");

local damage_param_type_def = get_damage_param_method:get_return_type();
local get_condition_param_method = damage_param_type_def:get_method("get_ConditionParam");

local stun_param_field = damage_param_type_def:get_field("_StunParam");
local poison_param_field = damage_param_type_def:get_field("_PoisonParam");
local blast_param_field = damage_param_type_def:get_field("_BlastParam");

local blast_param_type_def = blast_param_field:get_type();

local enemy_condition_damage_param_base_type_def = sdk.find_type_definition("snow.enemy.EnemyConditionDamageParamBase");
local get_is_enable_method = enemy_condition_damage_param_base_type_def:get_method("get_IsEnable");
local get_is_active_method = enemy_condition_damage_param_base_type_def:get_method("get_IsActive");
local get_activate_count_method = enemy_condition_damage_param_base_type_def:get_method("get_ActivateCount");
local get_stock_method = enemy_condition_damage_param_base_type_def:get_method("get_Stock");
local get_limit_method = enemy_condition_damage_param_base_type_def:get_method("get_Limit");
local get_active_time_method = enemy_condition_damage_param_base_type_def:get_method("get_ActiveTime");
local get_active_timer_method = enemy_condition_damage_param_base_type_def:get_method("get_ActiveTimer");

local poison_param_type_def = poison_param_field:get_type();
local poison_damage_field = poison_param_type_def:get_field("<Damage>k__BackingField");
local poison_get_is_damage_method = poison_param_type_def:get_method("get_IsDamage");

local system_array_type_def = sdk.find_type_definition("System.Array");
local length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

function this.update_ailments(enemy, monster)
	if enemy == nil then
		error_handler.report("ailments.update_ailments", "Missing Parameter: enemy");
		return;
	end

	local damage_param = get_damage_param_method:call(enemy);
	if damage_param == nil then
		error_handler.report("ailments.update_ailments", "Failed to Access Data: damage_param");
		return;
	end

	this.update_stun_poison_blast_ailments(monster, damage_param);

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
		error_handler.report("ailments.update_ailments", "Failed to Access Data: condition_param_array");
		return;
	end

	local condition_param_array_length = length_method:call(condition_param_array);
	if condition_param_array_length == nil then
		error_handler.report("ailments.update_ailments", "Failed to Access Data: condition_param_array_length");
		return;
	end

	for id = 0, condition_param_array_length - 1 do
		if id == this.stun_id or id == this.poison_id or id == this.blast_id then
			goto continue
		end

		local ailment_param = get_value_method:call(condition_param_array, id);
		if ailment_param == nil then
			error_handler.report("ailments.update_ailments", "Failed to Access Data: ailment_param No. " .. tostring(id));
			goto continue
		end

		this.update_ailment(monster, ailment_param, id);
		::continue::
	end
end

function this.update_stun_poison_blast_ailments(monster, damage_param)
	local stun_param = stun_param_field:get_data(damage_param);
	if stun_param ~= nil then
		this.update_ailment(monster, stun_param, this.stun_id);
	else
		error_handler.report("ailments.update_stun_poison_blast_ailments", "Failed to Access Data: stun_param");
	end

	local poison_param = poison_param_field:get_data(damage_param);
	if poison_param ~= nil then
		this.update_ailment(monster, poison_param, this.poison_id);
	else
		error_handler.report("ailments.update_stun_poison_blast_ailments", "Failed to Access Data: poison_param");
	end

	local blast_param = blast_param_field:get_data(damage_param);
	if blast_param ~= nil then
		this.update_ailment(monster, blast_param, this.blast_id);
	else
		error_handler.report("ailments.update_stun_poison_blast_ailments", "Failed to Access Data: blast_param");
	end
end

function this.update_ailment(monster, ailment_param, id)
	local is_enable = get_is_enable_method:call(ailment_param);
	local activate_count_array = get_activate_count_method:call(ailment_param);
	local buildup_array = get_stock_method:call(ailment_param);
	local buildup_limit_array = get_limit_method:call(ailment_param);
	local timer = get_active_timer_method:call(ailment_param);
	local duration = get_active_time_method:call(ailment_param);
	local is_active = get_is_active_method:call(ailment_param);

	local activate_count = nil;
	local buildup = nil;
	local buildup_limit = nil;
	
	if activate_count_array ~= nil then
		local activate_count_array_length = length_method:call(activate_count_array);

		if activate_count_array_length ~= nil then

			if activate_count_array_length > 0 then
				local activate_count_valuetype = get_value_method:call(activate_count_array, 0);

				if activate_count_valuetype ~= nil then
					activate_count = activate_count_valuetype:get_field("mValue");
				else
					error_handler.report("ailments.update_ailment", "Failed to Access Data: activate_count_valuetype");
				end
			end
		else
			error_handler.report("ailments.update_ailment", "Failed to Access Data: activate_count_array_length");
		end
	else
		error_handler.report("ailments.update_ailment", "Failed to Access Data: activate_count_array");
	end
	
	if buildup_array ~= nil then
		local buildup_array_length = length_method:call(buildup_array);

		if buildup_array_length ~= nil then 

			if buildup_array_length > 0 then
				local buildup_valuetype = get_value_method:call(buildup_array, 0);

				if buildup_valuetype ~= nil then
					buildup = buildup_valuetype:get_field("mValue");
				else
					error_handler.report("ailments.update_ailment", "Failed to Access Data: buildup_valuetype");
				end
			end
		else
			error_handler.report("ailments.update_ailment", "Failed to Access Data: buildup_array_length");
		end
	else
		error_handler.report("ailments.update_ailment", "Failed to Access Data: buildup_array");
	end
	
	if buildup_limit_array ~= nil then
		local buildup_limit_array_length = length_method:call(buildup_limit_array);

		if buildup_limit_array_length ~= nil then 

			if buildup_limit_array_length > 0 then
				local buildup_limit_valuetype = get_value_method:call(buildup_limit_array, 0);

				if buildup_limit_valuetype ~= nil then
					buildup_limit = buildup_limit_valuetype:get_field("mValue");
				else
					error_handler.report("ailments.update_ailment", "Failed to Access Data: buildup_limit_valuetype");
				end
			end
		else
			error_handler.report("ailments.update_ailment", "Failed to Access Data: buildup_limit_array_length");
		end
	else
		error_handler.report("ailments.update_ailment", "Failed to Access Data: buildup_limit_array");
	end

	if is_enable == nil then
		is_enable = true;
	end
	
	if is_enable ~= monster.ailments[id].is_enable then
		this.update_last_change_time(monster, id);
	end
	
	monster.ailments[id].is_enable = is_enable;
	
	if activate_count ~= nil then
		if activate_count ~= monster.ailments[id].activate_count then
			this.update_last_change_time(monster, id);

			if id == this.stun_id then
				this.clear_ailment_contribution(monster, this.stun_id);
			end
		end

		monster.ailments[id].activate_count = activate_count;
	else
		error_handler.report("ailments.update_ailment", "Failed to Access Data: activate_count");
	end
	
	if buildup ~= nil then
		if buildup ~= monster.ailments[id].total_buildup then
			this.update_last_change_time(monster, id);
		end

		monster.ailments[id].total_buildup = buildup;
	else
		error_handler.report("ailments.update_ailment", "Failed to Access Data: buildup");
	end
	
	if buildup_limit ~= nil then
		if buildup_limit ~= monster.ailments[id].buildup_limit then
			this.update_last_change_time(monster, id);
		end

		monster.ailments[id].buildup_limit = buildup_limit;
	else
		error_handler.report("ailments.update_ailment", "Failed to Access Data: buildup_limit");
	end
	
	if buildup ~= nil and buildup_limit ~= nil and buildup_limit ~= 0 then
		monster.ailments[id].buildup_percentage = buildup / buildup_limit;
	end
	
	if timer ~= nil then
		if timer ~= monster.ailments[id].timer then
			this.update_last_change_time(monster, id);
		end

		monster.ailments[id].timer = timer;
	end
	
	if is_active ~= nil then
		if is_active ~= monster.ailments[id].is_active then
			this.update_last_change_time(monster, id);
		end

		monster.ailments[id].is_active = is_active;
	end
	
	if duration ~= nil and not monster.ailments[id].is_active then
		if duration ~= monster.ailments[id].duration then
			this.update_last_change_time(monster, id);
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

function this.update_last_change_time(monster, id)
	monster.ailments[id].last_change_time = time.total_elapsed_script_seconds;
end

-- Code by coavins
function this.update_poison(monster, poison_param)
	if monster == nil then
		error_handler.report("ailments.update_poison", "Missing Parameter: monster");
		return;
	end

	if poison_param == nil then
		error_handler.report("ailments.update_poison", "Missing Parameter: poison_param");
		return;
	end

	--if poison tick, apply damage
	local is_damage = poison_get_is_damage_method:call(poison_param);
	if is_damage == nil then
		error_handler.report("ailments.update_poison", "Failed to Access Data: is_damage");
		return;
	end
	
	local poison_damage = poison_damage_field:get_data(poison_param);
	if poison_damage == nil then
		error_handler.report("ailments.update_poison", "Failed to Access Data: poison_damage");
		return;
	end

	this.apply_ailment_damage(monster, this.poison_id, poison_damage);
end

function this.draw(monster, ailment_UI, cached_config, ailments_position_on_screen, opacity_scale)
	local cached_config = cached_config.ailments;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	--sort parts here
	local displayed_ailments = {};
	for id, ailment in pairs(monster.ailments) do
		if id == this.paralyze_id then
			if not cached_config.filter.paralysis then
				goto continue
			end
		elseif id == this.sleep_id then
			if not cached_config.filter.sleep then
				goto continue
			end
		elseif id == this.stun_id then
			if not cached_config.filter.stun then
				goto continue
			end
		elseif id == this.flash_id then
			if not cached_config.filter.flash then
				goto continue
			end
		elseif id == this.poison_id then
			if not cached_config.filter.poison then
				goto continue
			end
		elseif id == this.blast_id then
			if not cached_config.filter.blast then
				goto continue
			end
		elseif id == this.exhaust_id then
			if not cached_config.filter.exhaust then
				goto continue
			end
		elseif id == this.ride_id then
			if not cached_config.filter.ride then
				goto continue
			end
		elseif id == this.water_id then
			if not cached_config.filter.waterblight then
				goto continue
			end
		elseif id == this.fire_id then
			if not cached_config.filter.fireblight then
				goto continue
			end
		elseif id == this.ice_id then
			if not cached_config.filter.iceblight then
				goto continue
			end
		elseif id == this.thunder_id then
			if not cached_config.filter.thunderblight then
				goto continue
			end
		elseif id == this.fall_trap_id then
			if not cached_config.filter.fall_trap then
				goto continue
			end
		elseif id == this.shock_trap_id then
			if not cached_config.filter.shock_trap then
				goto continue
			end
		elseif id == this.capture_id then
			if not cached_config.filter.tranq_bomb then
				goto continue
			end
		elseif id == this.koyashi_id then
			if not cached_config.filter.dung_bomb then
				goto continue
			end
		elseif id == this.steel_fang_id then
			if not cached_config.filter.steel_fang then
				goto continue
			end
		elseif id == this.fall_quick_sand_id then
			if not cached_config.filter.quick_sand then
				goto continue
			end
		elseif id == this.fall_otomo_trap_id then
			if not cached_config.filter.fall_otomo_trap then
				goto continue
			end
		elseif id == this.shock_otomo_trap_id then
			if not cached_config.filter.shock_otomo_trap then
				goto continue
			end
		else
			goto continue
		end

		if cached_config.settings.hide_ailments_with_zero_buildup
		and ailment.total_buildup == 0
		and ailment.buildup_limit ~= 0
		and ailment.activate_count == 0
		and not ailment.is_active then
			goto continue
		end

		if cached_config.settings.hide_inactive_ailments_with_no_buildup_support
		and ailment.buildup_limit == 0 
		and not ailment.is_active then
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

		if cached_config.settings.time_limit ~= 0
		and time.total_elapsed_script_seconds - ailment.last_change_time > cached_config.settings.time_limit
		and not ailment.is_active then
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

function this.apply_ailment_buildup(monster, player, otomo, ailment_type, ailment_buildup)
	if monster == nil then
		error_handler.report("ailments.apply_ailment_buildup", "Missing Parameter: monster");
		return;
	end

	if ailment_buildup == nil then
		error_handler.report("ailments.apply_ailment_buildup", "Missing Parameter: ailment_buildup");
		return;
	end

	if (ailment_type ~= this.poison_id and ailment_type ~= this.blast_id and ailment_type ~= this.stun_id)
	or ailment_buildup == 0 then
		return;
	end

	-- get the buildup accumulator for this type
	if monster.ailments[ailment_type].buildup == nil then
		monster.ailments[ailment_type].buildup = {};
	end

	-- get the otomo buildup accumulator for this type
	if monster.ailments[ailment_type].otomo_buildup == nil then
		monster.ailments[ailment_type].otomo_buildup = {};
	end

	if otomo == nil then
		monster.ailments[ailment_type].buildup[player] = (monster.ailments[ailment_type].buildup[player] or 0) + ailment_buildup;
	else
		monster.ailments[ailment_type].otomo_buildup[otomo] = (monster.ailments[ailment_type].otomo_buildup[otomo] or 0) + ailment_buildup;
	end

	this.calculate_ailment_contribution(monster, ailment_type);
end

-- Code by coavins
function this.calculate_ailment_contribution(monster, ailment_type)
	-- get total
	local total = 0;
	for player, player_buildup in pairs(monster.ailments[ailment_type].buildup) do
		total = total + player_buildup;
	end

	for otomo, otomo_buildup in pairs(monster.ailments[ailment_type].otomo_buildup) do
		total = total + otomo_buildup;
	end

	if total == 0 then
		total = 1;
	end

	for player, player_buildup in pairs(monster.ailments[ailment_type].buildup) do
		-- update ratio for this player
		monster.ailments[ailment_type].buildup_share[player] = player_buildup / total;
	end

	for otomo, otomo_buildup in pairs(monster.ailments[ailment_type].otomo_buildup) do
		-- update ratio for this otomo
		monster.ailments[ailment_type].otomo_buildup_share[otomo] = otomo_buildup / total;
	end
end

function this.clear_ailment_contribution(monster, ailment_type)
	monster.ailments[ailment_type].buildup = {};
	monster.ailments[ailment_type].otomo_buildup = {};

	monster.ailments[ailment_type].buildup_share = {};
	monster.ailments[ailment_type].otomo_buildup_share = {};
end

-- Code by coavins
function this.apply_ailment_damage(monster, ailment_type, ailment_damage)
	-- we only track poison and blast for now
	if monster == nil then
		error_handler.report("ailments.apply_ailment_damage", "Missing Parameter: monster");
	end

	if ailment_type == nil then
		error_handler.report("ailments.apply_ailment_damage", "Missing Parameter: ailment_type");
		return;
	end

	if ailment_damage == nil then
		error_handler.report("ailments.apply_ailment_damage", "Missing Parameter: ailment_damage");
		return;
	end

	local damage_source_type = players.damage_types.other;
	local otomo_damage_source_type = players.damage_types.other;
	local buildup_share = monster.ailments[ailment_type].buildup_share;
	local otomo_buildup_share = monster.ailments[ailment_type].otomo_buildup_share;
	
	if ailment_type == this.poison_id then
		damage_source_type = players.damage_types.poison;
		otomo_damage_source_type = players.damage_types.otomo_poison;
		buildup_share = monster.ailments[ailment_type].cached_buildup_share;
		otomo_buildup_share = monster.ailments[ailment_type].cached_otomo_buildup_share;
		
	elseif ailment_type == this.blast_id then
		damage_source_type = players.damage_types.blast;
		otomo_damage_source_type = players.damage_types.otomo_blast;
	else
		return;
	end

	-- split up damage according to ratio of buildup on boss for this type
	for player, percentage in pairs(buildup_share) do
		local damage_portion = ailment_damage * percentage;

		local damage_object = {};
		damage_object.total_damage = damage_portion;
		damage_object.physical_damage = 0;
		damage_object.elemental_damage = 0;
		damage_object.ailment_damage = damage_portion;

		players.update_damage(player, damage_source_type, monster.is_large, damage_object);
	end

	-- split up damage according to ratio of buildup on boss for this type
	for otomo, percentage in pairs(otomo_buildup_share) do
		local damage_portion = ailment_damage * percentage;

		local damage_object = {};
		damage_object.total_damage = damage_portion;
		damage_object.physical_damage = 0;
		damage_object.elemental_damage = 0;
		damage_object.ailment_damage = damage_portion;

		local player = players.get_player(otomo.id);
		
		if player ~= nil then
			players.update_damage(player, otomo_damage_source_type, monster.is_large, damage_object);
		end
		
		players.update_damage(otomo, otomo_damage_source_type, monster.is_large, damage_object);
	end

	local damage_object = {};
	damage_object.total_damage = ailment_damage;
	damage_object.physical_damage = 0;
	damage_object.elemental_damage = 0;
	damage_object.ailment_damage = ailment_damage;

	players.update_damage(players.total, damage_source_type, monster.is_large, damage_object);
end

function this.init_dependencies()
	players = require("MHR_Overlay.Damage_Meter.players");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
	ailment_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_UI_entity");
	ailment_buildup_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_buildup_UI_entity");
	time = require("MHR_Overlay.Game_Handler.time");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
end

return this;
