local large_monster = {};

local singletons;
local customization_menu;
local config;
local language;
local table_helpers;
local health_UI_entity;
local stamina_UI_entity;
local rage_UI_entity;
local ailment_UI_entity;
local ailment_buildup;
local ailment_buildup_UI_entity;
local body_part_UI_entity;
local screen;
local drawing;
local ailments;
local players;
local time;
local body_part;
local part_names;

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

large_monster.list = {};

function large_monster.new(enemy)
	local monster = {};
	monster.enemy = enemy;
	monster.is_large = true;

	monster.id = 0;
	monster.unique_id = 0;

	monster.health = 0;
	monster.max_health = 999999;
	monster.health_percentage = 0;
	monster.missing_health = 0;

	monster.is_capturable = true;
	monster.capture_health = 0;
	monster.capture_percentage = 0;

	monster.dead_or_captured = false;
	monster.is_disp_icon_mini_map = true;
	monster.is_stealth = false;
	monster.can_go_stealth = false;

	monster.is_tired = false;
	monster.stamina = 0;
	monster.max_stamina = 1000;
	monster.stamina_percentage = 0;
	monster.missing_stamina = 0;

	monster.tired_timer = 0;
	monster.tired_duration = 600;

	monster.tired_total_seconds_left = 0;
	monster.tired_minutes_left = 0;
	monster.tired_seconds_left = 0;
	monster.tired_timer_percentage = 0;

	monster.is_in_rage = false;
	monster.rage_point = 0;
	monster.rage_limit = 3000;
	monster.rage_count = 0;
	monster.rage_percentage = 0;

	monster.rage_timer = 0;
	monster.rage_duration = 600;

	monster.rage_total_seconds_left = 0;
	monster.rage_minutes_left = 0;
	monster.rage_seconds_left = 0;
	monster.rage_timer_percentage = 0;

	monster.position = Vector3f.new(0, 0, 0);
	monster.distance = 0;

	monster.name = "Large Monster";
	monster.size = 1;
	monster.small_border = 0;
	monster.big_border = 5;
	monster.king_border = 10;
	monster.crown = "";

	monster.parts = {};

	monster.ailments = ailments.init_ailments();

	monster.rider_id = -1;

	monster.dynamic_UI = {};
	monster.static_UI = {};
	monster.highlighted_UI = {};

	large_monster.init(monster, enemy);
	large_monster.init_UI(monster, monster.dynamic_UI, config.current_config.large_monster_UI.dynamic);
	large_monster.init_UI(monster, monster.static_UI, config.current_config.large_monster_UI.static);
	large_monster.init_UI(monster, monster.highlighted_UI, config.current_config.large_monster_UI.highlighted);

	large_monster.update_position(enemy, monster);
	
	local physical_param = large_monster.update_health(enemy, monster);

	large_monster.update_stamina(enemy, monster, nil);
	large_monster.update_stamina_timer(enemy, monster, nil);

	large_monster.update_rage(enemy, monster, nil);
	large_monster.update_rage_timer(enemy, monster, nil);

	large_monster.update(enemy, monster);
	pcall(large_monster.update_parts, enemy, monster, physical_param);

	if large_monster.list[enemy] == nil then
		large_monster.list[enemy] = monster;
	end

	return monster;
end

function large_monster.get_monster(enemy)
	local monster = large_monster.list[enemy];
	if monster == nil then
		monster = large_monster.new(enemy);
	end
	return monster;
end

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");

local enemy_type_field = enemy_character_base_type_def:get_field("<EnemyType>k__BackingField");
local get_monster_list_register_scale_method = enemy_character_base_type_def:get_method("get_MonsterListRegisterScale");

local message_manager_type_def = sdk.find_type_definition("snow.gui.MessageManager");
local get_enemy_name_message_method = message_manager_type_def:get_method("getEnemyNameMessage");

local enemy_manager_type_def = sdk.find_type_definition("snow.enemy.EnemyManager");
local find_enemy_size_info_method = enemy_manager_type_def:get_method("findEnemySizeInfo");

local size_info_type = find_enemy_size_info_method:get_return_type();
local get_small_border_method = size_info_type:get_method("get_SmallBorder");
local get_big_border_method = size_info_type:get_method("get_BigBorder");
local get_king_border_method = size_info_type:get_method("get_KingBorder");

local get_set_info_method = enemy_character_base_type_def:get_method("get_SetInfo");

local set_info_type = get_set_info_method:get_return_type();
local get_unique_id_method = set_info_type:get_method("get_UniqueId");

function large_monster.init(monster, enemy)
	local enemy_type = enemy_type_field:get_data(enemy);
	if enemy_type == nil then
		customization_menu.status = "No enemy type";
		return;
	end

	monster.id = enemy_type;

	if monster.id == 549 or monster.id == 25 or monster.id == 2073 then
		monster.can_go_stealth = true;
	end

	local enemy_name = get_enemy_name_message_method:call(singletons.message_manager, enemy_type);
	if enemy_name ~= nil then
		monster.name = enemy_name;
	end

	local set_info = get_set_info_method:call(enemy);
	if set_info ~= nil then
		local unique_id = get_unique_id_method:call(set_info);
		if unique_id ~= nil then
			monster.unique_id = unique_id;
		end
	end

	local size_info = find_enemy_size_info_method:call(singletons.enemy_manager, enemy_type);
	if size_info ~= nil then
		local small_border = get_small_border_method:call(size_info);
		local big_border = get_big_border_method:call(size_info);
		local king_border = get_king_border_method:call(size_info);

		local size = get_monster_list_register_scale_method:call(enemy);

		if small_border ~= nil then
			monster.small_border = small_border;
		end

		if big_border ~= nil then
			monster.big_border = big_border;
		end

		if king_border ~= nil then
			monster.king_border = king_border;
		end

		if size ~= nil then
			monster.size = size;
		end

		if monster.size <= monster.small_border then
			monster.crown = language.current_language.UI.mini;
		elseif monster.size >= monster.king_border then
			monster.crown = language.current_language.UI.gold;
		elseif monster.size >= monster.big_border then
			monster.crown = language.current_language.UI.silver;
		end
	end

	local is_capture_enable = true;

	local damage_param = enemy:get_field("<DamageParam>k__BackingField");
	if damage_param ~= nil then
		local capture_param = damage_param:get_field("_CaptureParam");

		if capture_param ~= nil then
			local is_capture_enable_ = capture_param:call("get_IsEnable");
			if is_capture_enable_ ~= nil then
				is_capture_enable = is_capture_enable_;
			end
		end
	end

	local curia_param = enemy:get_field("<CuriaParam>k__BackingField");
	local is_anomaly = curia_param ~= nil;

	monster.is_capturable = is_capture_enable and not is_anomaly;
end

function large_monster.init_UI(monster, monster_UI, cached_config)
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	monster_UI.monster_name_label = table_helpers.deep_copy(cached_config.monster_name_label);

	monster_UI.health_UI = health_UI_entity.new(
		cached_config.health.visibility,
		cached_config.health.bar,
		cached_config.health.text_label,
		cached_config.health.value_label,
		cached_config.health.percentage_label
	);

	monster_UI.health_UI.bar.capture_line.offset.x = monster_UI.health_UI.bar.capture_line.offset.x * global_scale_modifier;
	monster_UI.health_UI.bar.capture_line.offset.y = monster_UI.health_UI.bar.capture_line.offset.y * global_scale_modifier;
	monster_UI.health_UI.bar.capture_line.size.width = monster_UI.health_UI.bar.capture_line.size.width * global_scale_modifier;
	monster_UI.health_UI.bar.capture_line.size.height = monster_UI.health_UI.bar.capture_line.size.height * global_scale_modifier;

	monster_UI.health_UI.bar.colors = monster_UI.health_UI.bar.normal_colors;

	monster_UI.stamina_UI = stamina_UI_entity.new(
		cached_config.stamina.visibility,
		cached_config.stamina.bar,
		cached_config.stamina.text_label,
		cached_config.stamina.value_label,
		cached_config.stamina.percentage_label,
		cached_config.stamina.timer_label
	);

	monster_UI.rage_UI = rage_UI_entity.new(
		cached_config.rage.visibility,
		cached_config.rage.bar,
		cached_config.rage.text_label,
		cached_config.rage.value_label,
		cached_config.rage.percentage_label,
		cached_config.rage.timer_label
	);

	monster_UI.part_UI = body_part_UI_entity.new(
		cached_config.body_parts.visibility,
		cached_config.body_parts.part_name_label,
		cached_config.body_parts.part_health.visibility,
		cached_config.body_parts.part_health.bar,
		cached_config.body_parts.part_health.text_label,
		cached_config.body_parts.part_health.value_label,
		cached_config.body_parts.part_health.percentage_label,
		cached_config.body_parts.part_break.visibility,
		cached_config.body_parts.part_break.bar,
		cached_config.body_parts.part_break.text_label,
		cached_config.body_parts.part_break.value_label,
		cached_config.body_parts.part_break.percentage_label,
		cached_config.body_parts.part_loss.visibility,
		cached_config.body_parts.part_loss.bar,
		cached_config.body_parts.part_loss.text_label,
		cached_config.body_parts.part_loss.value_label,
		cached_config.body_parts.part_loss.percentage_label
	);

	monster_UI.ailment_UI = ailment_UI_entity.new(
		cached_config.ailments.visibility,
		cached_config.ailments.bar,
		cached_config.ailments.ailment_name_label,
		cached_config.ailments.text_label,
		cached_config.ailments.value_label,
		cached_config.ailments.percentage_label,
		cached_config.ailments.timer_label
	);

	monster_UI.ailment_buildup_UI = ailment_buildup_UI_entity.new(
		cached_config.ailment_buildups.buildup_bar,
		cached_config.ailment_buildups.highlighted_buildup_bar,
		cached_config.ailment_buildups.ailment_name_label,
		cached_config.ailment_buildups.player_name_label,
		cached_config.ailment_buildups.buildup_value_label,
		cached_config.ailment_buildups.buildup_percentage_label,
		cached_config.ailment_buildups.total_buildup_label,
		cached_config.ailment_buildups.total_buildup_value_label
	);

	ailments.init_ailment_names(monster.ailments);
end

local physical_param_field = enemy_character_base_type_def:get_field("<PhysicalParam>k__BackingField");
local stamina_param_field = enemy_character_base_type_def:get_field("<StaminaParam>k__BackingField");
local anger_param_field = enemy_character_base_type_def:get_field("<AngerParam>k__BackingField");
local damage_param_field = enemy_character_base_type_def:get_field("<DamageParam>k__BackingField");

local check_die_method = enemy_character_base_type_def:get_method("checkDie");
local is_disp_icon_mini_map_method = enemy_character_base_type_def:get_method("isDispIconMiniMap");

local physical_param_type = physical_param_field:get_type();
local get_vital_method = physical_param_type:get_method("getVital");
local get_capture_hp_vital_method = physical_param_type:get_method("get_CaptureHpVital");

local vital_param_type = get_vital_method:get_return_type();
local get_current_method = vital_param_type:get_method("get_Current");
local get_max_method = vital_param_type:get_method("get_Max");

local stamina_param_type = stamina_param_field:get_type();
local is_tired_method = stamina_param_type:get_method("isTired");
local get_stamina_method = stamina_param_type:get_method("getStamina");
local get_max_stamina_method = stamina_param_type:get_method("getMaxStamina");

local get_remaining_tired_time_method = stamina_param_type:get_method("getStaminaRemainingTime");
local get_total_tired_time_method = stamina_param_type:get_method("get_TiredSec");

local anger_param_type = anger_param_field:get_type();
local is_anger_method = anger_param_type:get_method("isAnger");
local get_anger_point_method = anger_param_type:get_method("get_AngerPoint");
local get_limit_anger_method = anger_param_type:get_method("get_LimitAnger");

local get_remaining_anger_time_method = anger_param_type:get_method("getAngerRemainingTime");
local get_total_anger_time_method = anger_param_type:get_method("get_TimerAnger");

local mario_param_field = enemy_character_base_type_def:get_field("<MarioParam>k__BackingField");

local mario_param_type = mario_param_field:get_type();
local get_is_marionette_method = mario_param_type:get_method("get_IsMarionette");
local get_mario_player_index_method = mario_param_type:get_method("get_MarioPlayerIndex");

local get_pos_field = enemy_character_base_type_def:get_method("get_Pos");

local system_array_type_def = sdk.find_type_definition("System.Array");
local length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

function large_monster.update_position(enemy, monster)
	if not config.current_config.large_monster_UI.dynamic.enabled and
		config.current_config.large_monster_UI.static.sorting.type ~= "Distance" then
		return;
	end

	local position = get_pos_field:call(enemy);
	if position ~= nil then
		monster.position = position;
	end
end

-- Code by coavins
function large_monster.update_all_riders()
	for enemy, monster in pairs(large_monster.list) do
		-- get marionette rider
		local mario_param = enemy:get_field("<MarioParam>k__BackingField");
		if mario_param ~= nil then
			local is_marionette = get_is_marionette_method:call(mario_param);

			if is_marionette == nil then
				goto continue;
			end

			if is_marionette then
				local player_id = get_mario_player_index_method:call(mario_param);
				if player_id ~= nil then
					monster.rider_id = player_id;
				end
			else
				monster.rider_id = -1;
			end
		end

		::continue::
	end

end

function large_monster.update(enemy, monster)
	local cached_config = config.current_config.large_monster_UI;

	if not cached_config.dynamic.enabled
		and not cached_config.static.enabled
		and not cached_config.highlighted.enabled then
		return;
	end

	local dead_or_captured = check_die_method:call(enemy);
	if dead_or_captured ~= nil then
		monster.dead_or_captured = dead_or_captured;
	end

	local is_disp_icon_mini_map = is_disp_icon_mini_map_method:call(enemy);
	if is_disp_icon_mini_map ~= nil then
		monster.is_disp_icon_mini_map = is_disp_icon_mini_map;
	end

	if monster.id == 549 or monster.id == 25 or monster.id == 2073 then
		monster.can_go_stealth = true;
	end

	if monster.can_go_stealth then
		-- Lucent Nargacuga
		if monster.id == 549 then
			local is_stealth = enemy:call("isStealth");
			if is_stealth ~= nil then
				monster.is_stealth = is_stealth;
			end
		-- Chameleos and Risen Chameleos
		elseif monster.id == 25 or monster.id == 2073 then
			local stealth_controller = enemy:call("get_StealthCtrl");
			if stealth_controller ~= nil then
				local status = stealth_controller:call("get_CurrentStatus");

				if status >= 2 then
					monster.is_stealth = true;
				else 
					monster.is_stealth = false;
				end
			end
		end
		
	end
	
	pcall(ailments.update_ailments, enemy, monster);
end

function large_monster.update_health(enemy, monster)
	local cached_config = config.current_config.large_monster_UI;

	if not cached_config.dynamic.enabled
		and not cached_config.static.enabled
		and not cached_config.highlighted.enabled then
		return;
	end

	if not cached_config.dynamic.health.visibility
		and not cached_config.static.health.visibility
		and not cached_config.highlighted.health.visibility then
		return nil;
	end

	local physical_param = physical_param_field:get_data(enemy);
	if physical_param == nil then
		customization_menu.status = "No physical param";
		return nil;
	end

	local vital_param = get_vital_method:call(physical_param, 0, 0);
	if vital_param == nil then
		customization_menu.status = "No vital param";
		return nil;
	end

	monster.health = get_current_method:call(vital_param) or monster.health;
	monster.max_health = get_max_method:call(vital_param) or monster.max_health;
	monster.capture_health = get_capture_hp_vital_method:call(physical_param) or monster.capture_health;

	monster.missing_health = monster.max_health - monster.health;
	if monster.max_health ~= 0 then
		monster.health_percentage = monster.health / monster.max_health;
		monster.capture_percentage = monster.capture_health / monster.max_health;
	end

	return physical_param;
end

function large_monster.update_stamina(enemy, monster, stamina_param)
	local cached_config = config.current_config.large_monster_UI;

	if not cached_config.dynamic.enabled
		and not cached_config.static.enabled
		and not cached_config.highlighted.enabled then
		return;
	end

	if not cached_config.dynamic.stamina.visibility
		and not cached_config.static.stamina.visibility
		and not cached_config.highlighted.stamina.visibility then
		return;
	end

	if stamina_param == nil then
		stamina_param = stamina_param_field:get_data(enemy);
		if stamina_param == nil then
			customization_menu.status = "No stamina param";
			return;
		end
	end

	local is_tired = is_tired_method:call(stamina_param, false);
	if is_tired ~= nil then
		monster.is_tired = is_tired;
	end

	monster.stamina     = get_stamina_method:call(stamina_param) or monster.stamina;
	monster.max_stamina = get_max_stamina_method:call(stamina_param) or monster.max_stamina;

	monster.missing_stamina = monster.max_stamina - monster.stamina;
	if monster.max_stamina ~= 0 then
		monster.stamina_percentage = monster.stamina / monster.max_stamina;
	end
end

function large_monster.update_stamina_timer(enemy, monster, stamina_param)
	local cached_config = config.current_config.large_monster_UI;

	if not cached_config.dynamic.enabled
		and not cached_config.static.enabled
		and not cached_config.highlighted.enabled then
		return;
	end

	if not cached_config.dynamic.stamina.visibility
		and not cached_config.static.stamina.visibility
		and not cached_config.highlighted.stamina.visibility then
		return;
	end

	if stamina_param == nil then
		stamina_param = stamina_param_field:get_data(enemy);
		if stamina_param == nil then
			customization_menu.status = "No stamina param";
			return;
		end
	end

	local is_tired = is_tired_method:call(stamina_param, false);
	if is_tired ~= nil then
		monster.is_tired = is_tired;
	end


	monster.tired_timer = get_remaining_tired_time_method:call(stamina_param) or monster.tired_timer;
	monster.tired_duration = get_total_tired_time_method:call(stamina_param) or monster.tired_duration;

	if monster.is_tired then
		monster.tired_total_seconds_left = monster.tired_timer;
		if monster.tired_total_seconds_left < 0 then
			monster.tired_total_seconds_left = 0;
		end

		monster.tired_minutes_left = math.floor(monster.tired_total_seconds_left / 60);
		monster.tired_seconds_left = monster.tired_total_seconds_left - 60 * monster.tired_minutes_left;

		if monster.tired_duration ~= 0 then
			monster.tired_timer_percentage = monster.tired_total_seconds_left / monster.tired_duration;
		end
	end
end

function large_monster.update_rage(enemy, monster, anger_param)
	local cached_config = config.current_config.large_monster_UI;

	if not cached_config.dynamic.enabled
		and not cached_config.static.enabled
		and not cached_config.highlighted.enabled then
		return;
	end

	if not cached_config.dynamic.rage.visibility
		and not cached_config.static.rage.visibility
		and not cached_config.highlighted.rage.visibility then
		return;
	end

	if anger_param == nil then
		anger_param = anger_param_field:get_data(enemy);
		if anger_param == nil then
			customization_menu.status = "No anger param";
			return;
		end
	end


	monster.rage_point = get_anger_point_method:call(anger_param) or monster.rage_point;
	monster.rage_limit = get_limit_anger_method:call(anger_param) or monster.rage_limit;

	if monster.rage_limit ~= 0 then
		monster.rage_percentage = monster.rage_point / monster.rage_limit;
	end
end

function large_monster.update_rage_timer(enemy, monster, anger_param)
	local cached_config = config.current_config.large_monster_UI;

	if not cached_config.dynamic.enabled
		and not cached_config.static.enabled
		and not cached_config.highlighted.enabled then
		return;
	end

	if not cached_config.dynamic.rage.visibility
		and not cached_config.static.rage.visibility
		and not cached_config.highlighted.rage.visibility then
		return;
	end

	if anger_param == nil then
		anger_param = anger_param_field:get_data(enemy);
		if anger_param == nil then
			customization_menu.status = "No anger param";
			return;
		end
	end

	local is_in_rage = is_anger_method:call(anger_param);
	if is_in_rage ~= nil then
		monster.is_in_rage = is_in_rage;
	end

	monster.rage_timer = get_remaining_anger_time_method:call(anger_param) or monster.rage_timer;
	monster.rage_duration = get_total_anger_time_method:call(anger_param) or monster.rage_duration;

	if monster.is_in_rage then
		monster.rage_total_seconds_left = monster.rage_timer;
		if monster.rage_total_seconds_left < 0 then
			monster.rage_total_seconds_left = 0;
		end

		monster.rage_minutes_left = math.floor(monster.rage_total_seconds_left / 60);
		monster.rage_seconds_left = monster.rage_total_seconds_left - 60 * monster.rage_minutes_left;

		if monster.rage_duration ~= 0 then
			monster.rage_timer_percentage = monster.rage_total_seconds_left / monster.rage_duration;
		end
	end
end

function large_monster.update_parts(enemy, monster, physical_param)
	local cached_config = config.current_config.large_monster_UI;

	if not cached_config.dynamic.enabled
		and not cached_config.static.enabled
		and not cached_config.highlighted.enabled then
		return;
	end

	if not cached_config.dynamic.body_parts.visibility
		and not cached_config.static.body_parts.visibility
		and not cached_config.highlighted.body_parts.visibility then
		return;
	end

	if not cached_config.dynamic.body_parts.part_health.visibility
		and not cached_config.dynamic.body_parts.part_break.visibility
		and not cached_config.dynamic.body_parts.part_loss.visibility
		and not cached_config.static.body_parts.part_health.visibility
		and not cached_config.static.body_parts.part_break.visibility
		and not cached_config.static.body_parts.part_loss.visibility
		and not cached_config.highlighted.body_parts.part_health.visibility
		and not cached_config.highlighted.body_parts.part_break.visibility
		and not cached_config.highlighted.body_parts.part_loss.visibility then
		return;
	end

	if physical_param == nil then
		physical_param = physical_param_field:get_data(enemy)
		if physical_param == nil then
			customization_menu.status = "No physical param";
			return nil;
		end
	end

	local damage_param = damage_param_field:get_data(enemy);
	if damage_param == nil then
		customization_menu.status = "No damage param";
		return;
	end

	local enemy_parts_damage_info = damage_param:get_field("_EnemyPartsDamageInfo");
	if enemy_parts_damage_info == nil then
		customization_menu.status = "No parts damage info";
		return;
	end

	local enemy_parts_info_array = enemy_parts_damage_info:call("get_PartsInfo");
	if enemy_parts_info_array == nil then
		customization_menu.status = "No parts damage info array";
		return;
	end

	local enemy_parts_info_array_length = length_method:call(enemy_parts_info_array);
	if enemy_parts_info_array_length == nil then
		return;
	end


	for i = 0, enemy_parts_info_array_length - 1 do
		local part_id = i + 1;

		local enemy_parts_info = get_value_method:call(enemy_parts_info_array, i);
		if enemy_parts_info == nil then
			goto continue
		end

		local part = monster.parts[part_id];
		if part == nil then
			local part_name = part_names.get_part_name(monster.id, part_id);
			if part_name == nil then
				goto continue
			else
				part = body_part.new(part_id, part_name);
				monster.parts[part_id] = part;
			end
		end

		if cached_config.dynamic.body_parts.part_health.visibility
			or cached_config.static.body_parts.part_health.visibility
			or cached_config.highlighted.body_parts.part_health.visibility then
			local part_vital = physical_param:call("getVital", 1, i);
			if part_vital ~= nil then
				local part_current = part_vital:call("get_Current") or -1;
				local part_max = part_vital:call("get_Max") or -1;

				body_part.update_flinch(part, part_current, part_max);

			end
		end

		if cached_config.dynamic.body_parts.part_break.visibility
			or cached_config.static.body_parts.part_break.visibility
			or cached_config.highlighted.body_parts.part_break.visibility then
			local part_break_vital = physical_param:call("getVital", 2, i);
			if part_break_vital ~= nil then
				local part_break_current = part_break_vital:call("get_Current") or -1;
				local part_break_max = part_break_vital:call("get_Max") or -1;
				local part_break_count = -1;
				local part_break_max_count = -1;

				if enemy_parts_info ~= nil then
					part_break_count = enemy_parts_info:call("get_PartsBreakDamageLevel") or part_break_count;
					part_break_max_count = enemy_parts_info:call("get_PartsBreakDamageMaxLevel") or part_break_max_count;
				end

				body_part.update_break(part, part_break_current, part_break_max, part_break_count, part_break_max_count)
			end
		end

		if cached_config.dynamic.body_parts.part_loss.visibility
			or cached_config.static.body_parts.part_loss.visibility
			or cached_config.highlighted.body_parts.part_loss.visibility then
			local part_loss_vital = physical_param:call("getVital", 3, i);
			if part_loss_vital ~= nil then
				local part_loss_current = part_loss_vital:call("get_Current") or -1;
				local part_loss_max = part_loss_vital:call("get_Max") or -1;
				local is_severed = false;

				if enemy_parts_info ~= nil then
					local _is_severed = enemy_parts_info:call("get_PartsLossState");
					if _is_severed ~= nil then
						is_severed = _is_severed;
					end
				end

				body_part.update_loss(part, part_loss_current, part_loss_max, is_severed);
			end
		end

		::continue::
	end
end

function large_monster.draw(monster, type, cached_config, position_on_screen, opacity_scale)
	local monster_UI;

	if type == "dynamic" then	
		monster_UI = monster.dynamic_UI;
	elseif type == "static" then
		monster_UI = monster.static_UI;
	else
		monster_UI = monster.highlighted_UI;
	end

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local monster_name_text = "";
	if cached_config.monster_name_label.include.monster_name then
		monster_name_text = string.format("%s ", monster.name);
	end

	if cached_config.monster_name_label.include.monster_id then
		monster_name_text = monster_name_text .. tostring(monster.id) .. " ";
	end

	if cached_config.monster_name_label.include.crown and monster.crown ~= "" then
		monster_name_text = monster_name_text .. string.format("%s ", monster.crown);
	end

	if cached_config.monster_name_label.include.size then
		monster_name_text = monster_name_text .. string.format("#%.0f ", 100 * monster.size);
	end

	if cached_config.monster_name_label.include.scrown_thresholds then
		monster_name_text = monster_name_text .. string.format("<=%.0f >=%.0f >=%.0f", 100 * monster.small_border,
			100 * monster.big_border, 100 * monster.king_border);
	end

	if monster.is_capturable and monster.health < monster.capture_health then
		monster_UI.health_UI.bar.colors = monster_UI.health_UI.bar.capture_colors;
	else
		monster_UI.health_UI.bar.colors = monster_UI.health_UI.bar.normal_colors;
	end

	local health_position_on_screen = {
		x = position_on_screen.x + cached_config.health.offset.x * global_scale_modifier,
		y = position_on_screen.y + cached_config.health.offset.y * global_scale_modifier
	};

	local stamina_position_on_screen = {
		x = position_on_screen.x + cached_config.stamina.offset.x * global_scale_modifier,
		y = position_on_screen.y + cached_config.stamina.offset.y * global_scale_modifier
	};

	local rage_position_on_screen = {
		x = position_on_screen.x + cached_config.rage.offset.x * global_scale_modifier,
		y = position_on_screen.y + cached_config.rage.offset.y * global_scale_modifier
	};

	local parts_position_on_screen = {
		x = position_on_screen.x + cached_config.body_parts.offset.x * global_scale_modifier,
		y = position_on_screen.y + cached_config.body_parts.offset.y * global_scale_modifier
	};

	local ailments_position_on_screen = {
		x = position_on_screen.x + cached_config.ailments.offset.x * global_scale_modifier,
		y = position_on_screen.y + cached_config.ailments.offset.y * global_scale_modifier
	};

	local ailment_buildups_position_on_screen = {
		x = position_on_screen.x + cached_config.ailment_buildups.offset.x * global_scale_modifier,
		y = position_on_screen.y + cached_config.ailment_buildups.offset.y * global_scale_modifier
	};

	health_UI_entity.draw(monster, monster_UI.health_UI, health_position_on_screen, opacity_scale);

	if monster.is_capturable then
		drawing.draw_capture_line(monster_UI.health_UI, health_position_on_screen, opacity_scale, monster.capture_percentage);
	end

	stamina_UI_entity.draw(monster, monster_UI.stamina_UI, stamina_position_on_screen, opacity_scale);
	rage_UI_entity.draw(monster, monster_UI.rage_UI, rage_position_on_screen, opacity_scale);

	local last_part_position_on_screen = body_part.draw(monster, monster_UI.part_UI, cached_config, parts_position_on_screen, opacity_scale);

	if cached_config.ailments.settings.offset_is_relative_to_parts then
		if last_part_position_on_screen ~= nil then
			ailments_position_on_screen = {
				x = last_part_position_on_screen.x + cached_config.ailments.relative_offset.x * global_scale_modifier,
				y = last_part_position_on_screen.y + cached_config.ailments.relative_offset.y * global_scale_modifier
			};
		end
	end

	ailments.draw(monster, monster_UI.ailment_UI, cached_config, ailments_position_on_screen, opacity_scale);
	ailment_buildup.draw(monster, monster_UI.ailment_buildup_UI, cached_config, ailment_buildups_position_on_screen, opacity_scale);

	drawing.draw_label(monster_UI.monster_name_label, position_on_screen, opacity_scale, monster_name_text);
end

function large_monster.init_list()
	large_monster.list = {};
end

function large_monster.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	body_part = require("MHR_Overlay.Monsters.body_part");
	health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
	rage_UI_entity = require("MHR_Overlay.UI.UI_Entities.rage_UI_entity");
	ailment_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_UI_entity");
	ailment_buildup_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_buildup_UI_entity");
	body_part_UI_entity = require("MHR_Overlay.UI.UI_Entities.body_part_UI_entity");

	screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
	part_names = require("MHR_Overlay.Misc.part_names");
	ailments = require("MHR_Overlay.Monsters.ailments");
	players = require("MHR_Overlay.Damage_Meter.players");
	time = require("MHR_Overlay.Game_Handler.time");
	ailment_buildup = require("MHR_Overlay.Monsters.ailment_buildup");
end

return large_monster;