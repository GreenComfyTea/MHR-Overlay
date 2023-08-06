local this = {};

local singletons;
local customization_menu;
local config;
local language;
local utils;
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
local error_handler;
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

this.list = {};
this.highlighted_id = -1;

this.monster_ids = {
	chameleos = 25,
	toadversary = 131,
	lucent_nargacuga = 549,
	risen_chameleos = 2073
}

function this.new(enemy)
	local monster = {};

	monster.enemy = enemy;
	monster.is_large = true;

	monster.id = 0;
	monster.unique_id = 0;

	monster.health = 100000;
	monster.max_health = 100000;
	monster.health_percentage = 0;
	monster.missing_health = 0;
	monster.is_health_initialized = false;

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
	monster.size = -1;
	monster.small_border = -1;
	monster.big_border = -1;
	monster.king_border = -1;
	monster.crown = "";

	monster.is_anomaly = false;
	monster.parts = {};

	monster.ailments = ailments.init_ailments();
	monster.rider_id = -1;

	monster.dynamic_UI = {};
	monster.static_UI = {};
	monster.highlighted_UI = {};

	this.init(monster, enemy);
	this.init_UI(monster, monster.dynamic_UI, config.current_config.large_monster_UI.dynamic);
	this.init_UI(monster, monster.static_UI, config.current_config.large_monster_UI.static);
	this.init_UI(monster, monster.highlighted_UI, config.current_config.large_monster_UI.highlighted);

	this.update_position(enemy, monster);
	this.update_stamina(enemy, monster, nil);
	this.update_stamina_timer(enemy, monster, nil);

	this.update_rage(enemy, monster, nil);
	this.update_rage_timer(enemy, monster, nil);
	this.update(enemy, monster);
	pcall(this.update_anomaly_parts, enemy, monster, nil);

	if this.list[enemy] == nil then
		this.list[enemy] = monster;
	end

	return monster;
end

function this.get_monster(enemy)
	local monster = this.list[enemy];
	if monster == nil then
		monster = this.new(enemy);
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

local get_physical_param_method = enemy_character_base_type_def:get_method("get_PhysicalParam");
local get_stamina_param_method = enemy_character_base_type_def:get_method("get_StaminaParam");
local get_anger_param_method = enemy_character_base_type_def:get_method("get_AngerParam");
local get_damage_param_method = enemy_character_base_type_def:get_method("get_DamageParam");
local get_mystery_param_method = enemy_character_base_type_def:get_method("get_MysteryParam");
local get_mario_param_method =  enemy_character_base_type_def:get_method("get_MarioParam");

local check_die_method = enemy_character_base_type_def:get_method("checkDie");
local is_disp_icon_mini_map_method = enemy_character_base_type_def:get_method("isDispIconMiniMap");

local physical_param_type = get_physical_param_method:get_return_type();
local get_vital_method = physical_param_type:get_method("getVital");
local get_capture_hp_vital_method = physical_param_type:get_method("get_CaptureHpVital");

local vital_param_type = get_vital_method:get_return_type();
local get_current_method = vital_param_type:get_method("get_Current");
local get_max_method = vital_param_type:get_method("get_Max");
local is_enable_method = vital_param_type:get_method("isEnable");

local stamina_param_type = get_stamina_param_method:get_return_type();
local is_tired_method = stamina_param_type:get_method("isTired");
local get_stamina_method = stamina_param_type:get_method("getStamina");
local get_max_stamina_method = stamina_param_type:get_method("getMaxStamina");

local get_remaining_tired_time_method = stamina_param_type:get_method("getStaminaRemainingTime");
local get_total_tired_time_method = stamina_param_type:get_method("get_TiredSec");

local anger_param_type = get_anger_param_method:get_return_type();
local is_anger_method = anger_param_type:get_method("isAnger");
local get_anger_point_method = anger_param_type:get_method("get_AngerPoint");
local get_limit_anger_method = anger_param_type:get_method("get_LimitAnger");

local get_remaining_anger_time_method = anger_param_type:get_method("getAngerRemainingTime");
local get_total_anger_time_method = anger_param_type:get_method("get_TimerAnger");

local mario_param_type = get_mario_param_method:get_return_type();
local get_is_marionette_method = mario_param_type:get_method("get_IsMarionette");
local get_mario_player_index_method = mario_param_type:get_method("get_MarioPlayerIndex");

local get_pos_field = enemy_character_base_type_def:get_method("get_Pos");

local system_array_type_def = sdk.find_type_definition("System.Array");
local length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

-- Lucent Nargacuga
local em037_02Character_type_def = sdk.find_type_definition("snow.enemy.em037.Em037_02Character");
local is_stealth_method = em037_02Character_type_def:get_method("isStealth");

-- Risen Chameleos and CHameleos
local Em025Character_base_type_Def =  sdk.find_type_definition("snow.enemy.em025.Em025CharacterBase");
local get_stealth_ctrl_method = Em025Character_base_type_Def:get_method("get_StealthCtrl");

local stealth_ctrl_type_def = get_stealth_ctrl_method:get_return_type();
local get_current_status_method = stealth_ctrl_type_def:get_method("get_CurrentStatus");

local damage_param_type_def = get_damage_param_method:get_return_type();
local enemy_parts_damage_info_field = damage_param_type_def:get_field("_EnemyPartsDamageInfo");

local enemy_parts_damage_info_type_def = enemy_parts_damage_info_field:get_type();
local get_part_info_array_method = enemy_parts_damage_info_type_def:get_method("get_PartsInfo");

local enemy_parts_info_type_def = sdk.find_type_definition("snow.enemy.EnemyDamageParam.EnemyPartsDamageInfo.EnemyPartsInfo");
local get_parts_break_damage_level_method = enemy_parts_info_type_def:get_method("get_PartsBreakDamageLevel");
local get_parts_break_damage_max_level_method = enemy_parts_info_type_def:get_method("get_PartsBreakDamageMaxLevel");
local get_parts_loss_state_method = enemy_parts_info_type_def:get_method("get_PartsLossState");

local mystery_param_type_def = get_mystery_param_method:get_return_type();
local core_parts_array_field = mystery_param_type_def:get_field("CoreParts");

local enemy_mystery_core_parts_type_def = sdk.find_type_definition("snow.enemy.EnemyMysteryCoreParts");
local core_parts_get_vital_method = enemy_mystery_core_parts_type_def:get_method("get_Vital");
local core_parts_get_is_active_method = enemy_mystery_core_parts_type_def:get_method("get_IsActive");
local core_parts_get_dying_vital_threashold_method = enemy_mystery_core_parts_type_def:get_method("get_DyingVitalThreashold");
local on_break_method = enemy_mystery_core_parts_type_def:get_method("onBreak");

local gui_manager_type_def = sdk.find_type_definition("snow.gui.GuiManager");
local get_tg_camera_method = gui_manager_type_def:get_method("get_refGuiHud_TgCamera");

local tg_camera_type_def = get_tg_camera_method:get_return_type();
local get_targeting_enemy_index_field = tg_camera_type_def:get_field("OldTargetingEmIndex");

function this.init(monster, enemy)
	local monster_id = enemy_type_field:get_data(enemy);
	if monster_id == nil then
		error_handler.report("large_monster.init", "Failed to Access Data: enemy_type");
		return;
	end

	monster.id = monster_id;

	if monster_id == this.monster_ids.lucent_nargacuga or monster_id == this.monster_ids.chameleos or monster_id == this.monster_ids.risen_chameleos then
		monster.can_go_stealth = true;
	end

	local enemy_name = get_enemy_name_message_method:call(singletons.message_manager, monster_id);
	if enemy_name ~= nil then
		monster.name = enemy_name;
	else
		error_handler.report("large_monster.init", "Failed to Access Data: enemy_name");
	end

	if monster_id ~= this.monster_ids.toadversary then
		local set_info = get_set_info_method:call(enemy);
		if set_info ~= nil then
			local unique_id = get_unique_id_method:call(set_info);
			if unique_id ~= nil then
				monster.unique_id = unique_id;
			else
				error_handler.report("large_monster.init", "Failed to Access Data: unique_id");
			end
		else
			error_handler.report("large_monster.init", "Failed to Access Data: set_info");
		end

		local size_info = find_enemy_size_info_method:call(singletons.enemy_manager, monster_id);
		if size_info ~= nil then
			local small_border = get_small_border_method:call(size_info);
			local big_border = get_big_border_method:call(size_info);
			local king_border = get_king_border_method:call(size_info);

			local size = get_monster_list_register_scale_method:call(enemy);

			if small_border ~= nil then
				monster.small_border = small_border;
			else
				error_handler.report("large_monster.init", "Failed to Access Data: small_border");
			end

			if big_border ~= nil then
				monster.big_border = big_border;
			else
				error_handler.report("large_monster.init", "Failed to Access Data: big_border");
			end

			if king_border ~= nil then
				monster.king_border = king_border;
			else
				error_handler.report("large_monster.init", "Failed to Access Data: king_border");
			end

			if size ~= nil then
				monster.size = size;
			else
				error_handler.report("large_monster.init", "Failed to Access Data: size");
			end

			if monster.size <= monster.small_border then
				monster.crown = language.current_language.UI.mini;
			elseif monster.size >= monster.king_border then
				monster.crown = language.current_language.UI.gold;
			elseif monster.size >= monster.big_border then
				monster.crown = language.current_language.UI.silver;
			end
		else
			error_handler.report("large_monster.init", "Failed to Access Data: size_info");
		end
	end

	local is_capture_enable = true;

	local damage_param = get_damage_param_method:call(enemy);
	if damage_param ~= nil then
		local capture_param = damage_param:get_field("_CaptureParam");

		if capture_param ~= nil then
			local is_capture_enable_ = capture_param:call("get_IsEnable");
			if is_capture_enable_ ~= nil then
				is_capture_enable = is_capture_enable_;
			else
				error_handler.report("large_monster.init", "Failed to Access Data: is_capture_enable_");
			end
		else
			error_handler.report("large_monster.init", "Failed to Access Data: capture_param");
		end
	else
		error_handler.report("large_monster.init", "Failed to Access Data: damage_param");
	end

	local mystery_param =  get_mystery_param_method:call(enemy);
	local is_anomaly = mystery_param ~= nil;

	monster.is_anomaly = is_anomaly;
	monster.is_capturable = is_capture_enable and not is_anomaly;
end

function this.init_UI(monster, monster_UI, cached_config)
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	monster_UI.monster_name_label = utils.table.deep_copy(cached_config.monster_name_label);

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
		cached_config.body_parts.part_loss.percentage_label,
		cached_config.body_parts.part_anomaly.visibility,
		cached_config.body_parts.part_anomaly.bar,
		cached_config.body_parts.part_anomaly.text_label,
		cached_config.body_parts.part_anomaly.value_label,
		cached_config.body_parts.part_anomaly.percentage_label
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
	body_part.init_part_names(monster.id, monster.parts);
end

function this.update_position(enemy, monster)
	if not config.current_config.large_monster_UI.dynamic.enabled
	and config.current_config.large_monster_UI.static.sorting.type ~= "Distance" then
		return;
	end

	local position = get_pos_field:call(enemy);
	if position == nil then
		error_handler.report("large_monster.update_position", "Failed to Access Data: position");
	end
	
	monster.position = position;
end

-- Code by coavins
function this.update_all_riders()
	for enemy, monster in pairs(this.list) do
		-- get marionette rider
		local mario_param = get_mario_param_method:call(enemy);
		if mario_param == nil then
			error_handler.report("large_monster.update_all_riders", "Failed to Access Data: mario_param");
			goto continue;
		end

		local is_marionette = get_is_marionette_method:call(mario_param);
		if is_marionette == nil then
			error_handler.report("large_monster.update_all_riders", "Failed to Access Data: is_marionette");
			goto continue;
		end

		if is_marionette then
			local player_id = get_mario_player_index_method:call(mario_param);
			if player_id == nil then
				error_handler.report("large_monster.update_all_riders", "Failed to Access Data: player_id");
				goto continue;
			end
			
			monster.rider_id = player_id;
		else
			monster.rider_id = -1;
		end

		::continue::
	end
end

function this.update(enemy, monster)
	local cached_config = config.current_config.large_monster_UI;

	if not cached_config.dynamic.enabled
	and not cached_config.static.enabled
	and not cached_config.highlighted.enabled then
		return;
	end

	local dead_or_captured = check_die_method:call(enemy);
	if dead_or_captured ~= nil then
		monster.dead_or_captured = dead_or_captured;
	else
		error_handler.report("large_monster.update", "Failed to Access Data: dead_or_captured");
	end

	local is_disp_icon_mini_map = is_disp_icon_mini_map_method:call(enemy);
	if is_disp_icon_mini_map ~= nil then
		monster.is_disp_icon_mini_map = is_disp_icon_mini_map;
	else
		error_handler.report("large_monster.update", "Failed to Access Data: is_disp_icon_mini_map");
	end

	if monster.id == this.monster_ids.lucent_nargacuga or monster.id == this.monster_ids.chameleos or monster.id == this.monster_ids.risen_chameleos then
		monster.can_go_stealth = true;
	end

	if monster.can_go_stealth then
		-- Lucent Nargacuga
		if monster.id == this.monster_ids.lucent_nargacuga then
			local is_stealth = is_stealth_method:call(enemy);
			if is_stealth == nil then
				monster.is_stealth = is_stealth;
			else
				error_handler.report("large_monster.update", "Failed to Access Data: is_stealth");
			end
			
		-- Chameleos and Risen Chameleos
		elseif monster.id == this.monster_ids.chameleos or monster.id == this.monster_ids.risen_chameleos then
			local stealth_controller = get_stealth_ctrl_method:call(enemy);
			if stealth_controller ~= nil then
				local status = get_current_status_method:call(stealth_controller);

				if status == nil then
					error_handler.report("large_monster.update", "Failed to Access Data: status");
				elseif status >= 2 then
					monster.is_stealth = true;
				else 
					monster.is_stealth = false;
				end
			else
				error_handler.report("large_monster.update", "Failed to Access Data: stealth_controller");
			end
		end
	end
	
	pcall(ailments.update_ailments, enemy, monster);
end

function this.update_health(enemy, monster)
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

	local physical_param = get_physical_param_method:call(enemy);
	if physical_param == nil then
		error_handler.report("large_monster.update_health", "Failed to Access Data: physical_param");
		return nil;
	end

	local vital_param = get_vital_method:call(physical_param, 0, 0);
	if vital_param == nil then
		error_handler.report("large_monster.update_health", "Failed to Access Data: vital_param");
		return nil;
	end

	local health = get_current_method:call(vital_param);
	if health ~= nil then
		monster.health = health;
	else 
		error_handler.report("large_monster.update_health", "Failed to Access Data: health");
	end

	local max_health = get_max_method:call(vital_param);
	if max_health ~= nil then
		monster.max_health = max_health;
	else 
		error_handler.report("large_monster.update_health", "Failed to Access Data: max_health");
	end

	local capture_health = get_capture_hp_vital_method:call(physical_param);
	if capture_health ~= nil then
		monster.capture_health = capture_health;
	else 
		error_handler.report("large_monster.update_health", "Failed to Access Data: capture_health");
	end

	monster.missing_health = max_health - health;
	if monster.max_health ~= 0 then
		monster.health_percentage = health / max_health;
		monster.capture_percentage = capture_health / max_health;
	end

	return physical_param;
end

function this.update_stamina(enemy, monster, stamina_param)
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
		stamina_param = get_stamina_param_method:call(enemy);
		if stamina_param == nil then
			error_handler.report("large_monster.update_stamina", "Failed to Access Data: stamina_param");
			return;
		end
	end

	local is_tired = is_tired_method:call(stamina_param, false);
	if is_tired ~= nil then
		monster.is_tired = is_tired;
	else
		error_handler.report("large_monster.update_stamina", "Failed to Access Data: is_tired");
		return;
	end

	if is_tired then
		return;
	end

	local stamina = get_stamina_method:call(stamina_param);
	if stamina ~= nil then
		monster.stamina = stamina;
	else
		error_handler.report("large_monster.update_stamina", "Failed to Access Data: stamina");
		return;
	end

	local max_stamina = get_max_stamina_method:call(stamina_param);
	if max_stamina ~= nil then
		monster.max_stamina = max_stamina;
	else
		error_handler.report("large_monster.update_stamina", "Failed to Access Data: max_stamina");
		return;
	end

	monster.missing_stamina = max_stamina - stamina;
	if max_stamina ~= 0 then
		monster.stamina_percentage = stamina / max_stamina;
	end
end

function this.update_stamina_timer(enemy, monster, stamina_param)
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
		stamina_param = get_stamina_param_method:call(enemy);
		if stamina_param == nil then
			error_handler.report("large_monster.update_stamina_timer", "Failed to Access Data: stamina_param");
			return;
		end
	end

	local is_tired = is_tired_method:call(stamina_param, false);
	if is_tired ~= nil then
		monster.is_tired = is_tired;
	else
		error_handler.report("large_monster.update_stamina_timer", "Failed to Access Data: is_tired");
		return;
	end
	
	if not is_tired then
		return;
	end

	local tired_timer = get_remaining_tired_time_method:call(stamina_param);
	if tired_timer ~= nil then
		monster.tired_timer = tired_timer;
	else
		error_handler.report("large_monster.update_stamina_timer", "Failed to Access Data: tired_timer");
		return;
	end

	local tired_duration = get_total_tired_time_method:call(stamina_param);
	if tired_duration ~= nil then
		monster.tired_duration = tired_duration;
	else
		error_handler.report("large_monster.update_stamina_timer", "Failed to Access Data: tired_duration");
		return;
	end

	monster.tired_total_seconds_left = tired_timer;
	if monster.tired_total_seconds_left < 0 then
		monster.tired_total_seconds_left = 0;
	end

	monster.tired_minutes_left = math.floor(monster.tired_total_seconds_left / 60);
	monster.tired_seconds_left = monster.tired_total_seconds_left - 60 * monster.tired_minutes_left;

	if tired_duration ~= 0 then
		monster.tired_timer_percentage = monster.tired_total_seconds_left / tired_duration;
	end
end

function this.update_rage(enemy, monster, anger_param)
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
		anger_param = get_anger_param_method:call(enemy);
		if anger_param == nil then
			error_handler.report("large_monster.update_rage", "Failed to Access Data: anger_param");
			return;
		end
	end

	local is_in_rage = is_anger_method:call(anger_param);
	if is_in_rage ~= nil then
		monster.is_in_rage = is_in_rage;
	else
		error_handler.report("large_monster.update_rage", "Failed to Access Data: is_in_rage");
		return;
	end

	if is_in_rage then
		return;
	end
	
	local rage_point = get_anger_point_method:call(anger_param);
	if rage_point ~= nil then
		monster.rage_point = rage_point;
	else
		error_handler.report("large_monster.update_rage", "Failed to Access Data: rage_point");
		return;
	end

	local rage_limit = get_limit_anger_method:call(anger_param);
	if rage_limit ~= nil then
		monster.rage_limit = rage_limit;
	else
		error_handler.report("large_monster.update_rage", "Failed to Access Data: rage_limit");
		return;
	end

	if rage_limit ~= 0 then
		monster.rage_percentage = rage_point / rage_limit;
	end
end

function this.update_rage_timer(enemy, monster, anger_param)
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
		anger_param = get_anger_param_method:call(enemy);
		if anger_param == nil then
			error_handler.report("large_monster.update_rage_timer", "Failed to Access Data: anger_param");
			return;
		end
	end

	local is_in_rage = is_anger_method:call(anger_param);
	if is_in_rage ~= nil then
		monster.is_in_rage = is_in_rage;
	else
		error_handler.report("large_monster.update_rage_timer", "Failed to Access Data: is_in_rage");
		return;
	end

	if not is_in_rage then
		return;
	end

	local rage_timer = get_remaining_anger_time_method:call(anger_param);
	if rage_timer ~= nil then
		monster.rage_timer = rage_timer;
	else
		error_handler.report("large_monster.update_rage_timer", "Failed to Access Data: rage_timer");
		return;
	end

	local rage_duration = get_total_anger_time_method:call(anger_param);
	if rage_duration ~= nil then
		monster.rage_duration = rage_duration;
	else
		error_handler.report("large_monster.update_rage_timer", "Failed to Access Data: rage_duration");
		return;
	end

	monster.rage_total_seconds_left = rage_timer;
	if monster.rage_total_seconds_left < 0 then
		monster.rage_total_seconds_left = 0;
	end

	monster.rage_minutes_left = math.floor(monster.rage_total_seconds_left / 60);
	monster.rage_seconds_left = monster.rage_total_seconds_left - 60 * monster.rage_minutes_left;

	if rage_duration ~= 0 then
		monster.rage_timer_percentage = monster.rage_total_seconds_left / rage_duration;
	end
end

function this.update_parts(enemy, monster, physical_param)
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
		physical_param = get_physical_param_method:call(enemy);
		if physical_param == nil then
			error_handler.report("large_monster.update_parts", "Failed to Access Data: physical_param");
			return;
		end
	end

	local damage_param = get_damage_param_method:call(enemy);
	if damage_param == nil then
		error_handler.report("large_monster.update_parts", "Failed to Access Data: damage_param");
		return;
	end

	local enemy_parts_damage_info = enemy_parts_damage_info_field:get_data(damage_param);
	if enemy_parts_damage_info == nil then
		error_handler.report("large_monster.update_parts", "Failed to Access Data: enemy_parts_damage_info");
		return;
	end

	local core_parts_array = get_part_info_array_method:call(enemy_parts_damage_info);
	if core_parts_array == nil then
		error_handler.report("large_monster.update_parts", "Failed to Access Data: core_parts_array");
		return;
	end

	local core_parts_array_length = length_method:call(core_parts_array);
	if core_parts_array_length == nil then
		error_handler.report("large_monster.update_parts", "Failed to Access Data: core_parts_array_length");
		return;
	end

	for i = 0, core_parts_array_length - 1 do
		local part_id = i + 1;

		local enemy_parts_info = get_value_method:call(core_parts_array, i);
		if enemy_parts_info == nil then
			error_handler.report("large_monster.update_parts", "Failed to Access Data: enemy_parts_info No. " .. tostring(i));
			goto continue;
		end

		local part = monster.parts[part_id];
		if part == nil then
			local part_name = part_names.get_part_name(monster.id, part_id);
			if part_name == nil then
				goto continue;
			else
				part = body_part.new(part_id, part_name);
				monster.parts[part_id] = part;
			end
		end

		if cached_config.dynamic.body_parts.part_health.visibility
		or cached_config.static.body_parts.part_health.visibility
		or cached_config.highlighted.body_parts.part_health.visibility then

			local part_vital = get_vital_method:call(physical_param, 1, i);
			if part_vital ~= nil then

				local part_current = get_current_method:call(part_vital);
				if part_current == nil then
					error_handler.report("large_monster.update_parts", string.format("Failed to Access Data: enemy_parts_info No. %d -> part_current", i));
				end

				local part_max = get_max_method:call(part_vital);
				if part_max == nil then
					error_handler.report("large_monster.update_parts", string.format("Failed to Access Data: enemy_parts_info No. %d -> part_max", i));
				end

				if part_current ~= nil and part_max ~= nil then
					body_part.update_flinch(part, part_current, part_max);
				end
			else
				error_handler.report("large_monster.update_parts", string.format("Failed to Access Data: enemy_parts_info No. %d -> part_vital", i));
			end
		end

		if cached_config.dynamic.body_parts.part_break.visibility
		or cached_config.static.body_parts.part_break.visibility
		or cached_config.highlighted.body_parts.part_break.visibility then

			local part_break_vital = get_vital_method:call(physical_param, 2, i);
			if part_break_vital ~= nil then

				local part_break_current = get_current_method:call(part_break_vital);
				if part_break_current == nil then
					error_handler.report("large_monster.update_parts", string.format("Failed to Access Data: enemy_parts_info No. %d -> part_break_current", i));
				end

				local part_break_max = get_max_method:call(part_break_vital);
				if part_break_max == nil then
					error_handler.report("large_monster.update_parts", string.format("Failed to Access Data: enemy_parts_info No. %d -> part_break_max", i));
				end

				local part_break_count = get_parts_break_damage_level_method:call(enemy_parts_info);
				if part_break_count == nil then
					error_handler.report("large_monster.update_parts", string.format("Failed to Access Data: enemy_parts_info No. %d -> part_break_count", i));
				end

				local part_break_max_count = get_parts_break_damage_max_level_method:call(enemy_parts_info);
				if part_break_max_count == nil then
					error_handler.report("large_monster.update_parts", string.format("Failed to Access Data: enemy_parts_info No. %d -> part_break_max_count", i));
				end

				if part_break_current ~= nil and part_break_max ~= nil and part_break_count ~= nil and part_break_max_count ~= nil then
					body_part.update_break(part, part_break_current, part_break_max, part_break_count, part_break_max_count);
				end
			else
				error_handler.report("large_monster.update_parts", string.format("Failed to Access Data: enemy_parts_info No. %d -> part_break_vital", i));
			end
		end

		if cached_config.dynamic.body_parts.part_loss.visibility
		or cached_config.static.body_parts.part_loss.visibility
		or cached_config.highlighted.body_parts.part_loss.visibility then

			local part_loss_vital = get_vital_method:call(physical_param, 3, i);
			if part_loss_vital ~= nil then

				local part_loss_current = get_current_method:call(part_loss_vital);
				if part_loss_current == nil then
					error_handler.report("large_monster.update_parts", string.format("Failed to Access Data: enemy_parts_info No. %d -> part_loss_current", i));
				end

				local part_loss_max = get_max_method:call(part_loss_vital);
				if part_loss_max == nil then
					error_handler.report("large_monster.update_parts", string.format("Failed to Access Data: enemy_parts_info No. %d -> part_loss_max", i));
				end

				local is_severed = get_parts_loss_state_method:call(enemy_parts_info);
				if is_severed == nil then
					error_handler.report("large_monster.update_parts", string.format("Failed to Access Data: enemy_parts_info No. %d -> is_severed", i));
				end
				
				if part_loss_current ~= nil and part_loss_max ~= nil and is_severed ~= nil then	
					body_part.update_loss(part, part_loss_current, part_loss_max, is_severed);
				end
			else
				error_handler.report("large_monster.update_parts", string.format("Failed to Access Data: enemy_parts_info No. %d -> part_loss_vital", i));
			end
		end

		::continue::
	end
end

function this.update_anomaly_parts(enemy, monster, mystery_param)
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

	if not cached_config.dynamic.body_parts.part_anomaly.visibility
	and not cached_config.static.body_parts.part_anomaly.visibility
	and not cached_config.highlighted.body_parts.part_anomaly.visibility then
		return;
	end

	if mystery_param == nil then
		mystery_param = get_mystery_param_method:call(enemy);
		if mystery_param == nil then
			return;
		end
	end

	local core_parts_array = core_parts_array_field:get_data(mystery_param);
	if core_parts_array == nil then
		error_handler.report("large_monster.update_anomaly_parts", "Failed to Access Data: core_parts_array");
		return;
	end

	local core_parts_array_length = length_method:call(core_parts_array);
	if core_parts_array_length == nil then
		error_handler.report("large_monster.update_anomaly_parts", "Failed to Access Data: core_parts_array_length");
		return;
	end

	for i = 0, core_parts_array_length - 1 do
		local part_id = i + 1;

		local core_part = get_value_method:call(core_parts_array, i);
		if core_part == nil then
			error_handler.report("large_monster.update_anomaly_parts", "Failed to Access Data: core_part No. " .. tostring(i));
			goto continue;
		end

		local part = monster.parts[part_id];
		if part == nil then
			local part_name = part_names.get_part_name(monster.id, part_id);
			if part_name == nil then
				goto continue;
			else
				part = body_part.new(part_id, part_name);
				monster.parts[part_id] = part;
			end
		end

		local part_vital = core_parts_get_vital_method:call(core_part);
		if part_vital == nil then
			error_handler.report("large_monster.update_anomaly_parts", "Failed to Access Data: part_vital No. " .. tostring(i));
			return;
		end

		local part_is_active = core_parts_get_is_active_method:call(core_part);
		if part_is_active == nil then
			error_handler.report("large_monster.update_anomaly_parts", "Failed to Access Data: part_is_active No. " .. tostring(i));
			return;
		end

		--local part_dying_vital_threshold = core_parts_get_dying_vital_threashold_method:call(core_part);

		local part_current = get_current_method:call(part_vital);
		if part_current == nil then
			error_handler.report("large_monster.update_anomaly_parts", "Failed to Access Data: part_current No. " .. tostring(i));
			goto continue;
		end

		local part_max = get_max_method:call(part_vital);
		if part_max == nil then
			error_handler.report("large_monster.update_anomaly_parts", "Failed to Access Data: part_max No. " .. tostring(i));
			goto continue;
		end

		local part_is_enabled = is_enable_method:call(part_vital);
		if part_is_enabled == nil then
			error_handler.report("large_monster.update_anomaly_parts", "Failed to Access Data: part_is_enabled No. " .. tostring(i));
			goto continue;
		end

		if not part_is_enabled then
			goto continue;
		end

		body_part.update_anomaly(part, core_part, part_current, part_max, part_is_active);

		::continue::
	end
end

function this.update_highlighted_id()
	if quest_status.flow_state <= quest_status.flow_states.IN_LOBBY
	or quest_status.flow_state == quest_status.flow_states.LOADING_QUEST
	or quest_status.flow_state >= quest_status.flow_states.QUEST_END_ANIMATION then
		return;
	end

	if singletons.gui_manager == nil then
		error_handler.report("large_monster.update_highlighted_id", "Failed to Access Data: gui_manager");
		return;
	end

	local gui_hud_target_camera = get_tg_camera_method:call(singletons.gui_manager);
	if gui_hud_target_camera == nil then
		error_handler.report("large_monster.update_highlighted_id", "Failed to Access Data: gui_hud_target_camera");
		return;
	end

	local highlighted_id = get_targeting_enemy_index_field:get_data(gui_hud_target_camera);
	if highlighted_id == nil then
		error_handler.report("large_monster_UI.update_highlighted_id", "Failed to Access Data: highlighted_id");
		return;
	end

	this.highlighted_id = highlighted_id;
end

function this.draw(monster, type, cached_config, position_on_screen, opacity_scale)
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
		monster_name_text = string.format("%s%s ", monster_name_text, tostring(monster.id));
	end

	if cached_config.monster_name_label.include.crown and monster.crown ~= "" then
		monster_name_text = string.format("%s%s ", monster_name_text, monster.crown);
	end

	if cached_config.monster_name_label.include.size and monster.size ~= -1 then
		monster_name_text = string.format("%s#%.0f ", monster_name_text, 100 * monster.size);
	end
	
	if cached_config.monster_name_label.include.crown_thresholds then
		if monster.small_border ~= -1 then
			monster_name_text = string.format("%s<=%.0f ", monster_name_text, 100 * monster.small_border);
		end

		if monster.big_border ~= -1 then
			monster_name_text = string.format("%s>=%.0f ", monster_name_text, 100 * monster.big_border);
		end

		if monster.king_border ~= -1 then
			monster_name_text = string.format("%s>=%.0f ", monster_name_text, 100 * monster.king_border);
		end
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

function this.init_list()
	this.list = {};
end

function this.init_dependencies()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
	utils = require("MHR_Overlay.Misc.utils");
	body_part = require("MHR_Overlay.Monsters.body_part");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");

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
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
	time.new_timer(this.update_highlighted_id, 1/30);
end

return this;