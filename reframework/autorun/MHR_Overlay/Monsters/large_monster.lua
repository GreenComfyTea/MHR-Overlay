local large_monster = {};
local singletons;
local customization_menu;
local config;
local language;
local table_helpers;
local health_UI_entity;
local stamina_UI_entity;
local rage_UI_entity;
local screen;
local drawing;

local body_part;
local part_names;

large_monster.list = {};

function large_monster.new(enemy)
	local monster = {};
	monster.is_large = true;
	monster.id = 0;

	monster.health = 0;
	monster.max_health = 999999;
	monster.health_percentage = 0;
	monster.missing_health = 0;

	monster.capture_health = 0;
	monster.capture_percentage = 0;

	monster.dead_or_captured = false;

	monster.stamina = 0;
	monster.max_stamina = 1000;
	monster.stamina_percentage = 0;
	monster.missing_stamina = 0;

	monster.is_in_rage = false;
	monster.rage_point = 0;
	monster.rage_limit = 3000;
	monster.rage_timer = 0;
	monster.rage_duration = 600;
	monster.rage_count = 0;
	monster.rage_percentage = 0;

	monster.rage_total_seconds_left = 0;
	monster.rage_minutes_left = 0;
	monster.rage_seconds_left = 0;
	monster.rage_timer_percentage = 0;

	monster.game_object = nil
	monster.transform = nil
	monster.position = Vector3f.new(0, 0, 0);
	monster.distance = 0;

	monster.name = "Large Monster";
	monster.size = 1;
	monster.small_border = 0;
	monster.big_border = 5;
	monster.king_border = 10;
	monster.crown = "";

	monster.parts = {};
	
	large_monster.init(monster, enemy);
	large_monster.init_static_UI(monster);
	large_monster.init_dynamic_UI(monster);
	large_monster.init_highlighted_UI(monster);

	if large_monster.list[enemy] == nil then
		large_monster.list[enemy] = monster;
	end
	return monster;
end

function large_monster.get_monster(enemy)
	if large_monster.list[enemy] == nil then
		return large_monster.new(enemy);
		
	end
	return large_monster.list[enemy];
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

function large_monster.init(monster, enemy)
	local enemy_type = enemy_type_field:get_data(enemy);
	if enemy_type == nil then
		customization_menu.status = "No enemy type";
		return;
	end

	monster.id = enemy_type;

	local enemy_name = get_enemy_name_message_method:call(singletons.message_manager, enemy_type);
	if enemy_name ~= nil then
		monster.name = enemy_name;
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
end

function large_monster.init_static_UI(monster)
	monster.static_name_label = table_helpers.deep_copy(config.current_config.large_monster_UI.static.monster_name_label);
	
	monster.health_static_UI = health_UI_entity.new(
		config.current_config.large_monster_UI.static.health.visibility,
		config.current_config.large_monster_UI.static.health.bar,
		config.current_config.large_monster_UI.static.health.text_label,
		config.current_config.large_monster_UI.static.health.value_label,
		config.current_config.large_monster_UI.static.health.percentage_label
	);

	monster.health_static_UI.bar.colors = config.current_config.large_monster_UI.static.health.bar.normal_colors;

	monster.stamina_static_UI = stamina_UI_entity.new(
		config.current_config.large_monster_UI.static.stamina.visibility,
		config.current_config.large_monster_UI.static.stamina.bar,
		config.current_config.large_monster_UI.static.stamina.text_label,
		config.current_config.large_monster_UI.static.stamina.value_label,
		config.current_config.large_monster_UI.static.stamina.percentage_label
	);
	
	monster.rage_static_UI = rage_UI_entity.new(
		config.current_config.large_monster_UI.static.rage.visibility,
		config.current_config.large_monster_UI.static.rage.bar,
		config.current_config.large_monster_UI.static.rage.text_label,
		config.current_config.large_monster_UI.static.rage.value_label,
		config.current_config.large_monster_UI.static.rage.percentage_label,
		config.current_config.large_monster_UI.static.rage.timer_label
	);
	
	for REpart, part in pairs(monster.parts) do
		body_part.init_static_UI(part);
	end
end

function large_monster.init_dynamic_UI(monster)
	monster.dynamic_name_label = table_helpers.deep_copy(config.current_config.large_monster_UI.dynamic.monster_name_label);

	monster.health_dynamic_UI = health_UI_entity.new(
		config.current_config.large_monster_UI.dynamic.health.visibility,
		config.current_config.large_monster_UI.dynamic.health.bar,
		config.current_config.large_monster_UI.dynamic.health.text_label,
		config.current_config.large_monster_UI.dynamic.health.value_label,
		config.current_config.large_monster_UI.dynamic.health.percentage_label
	);

	monster.health_dynamic_UI.bar.colors = config.current_config.large_monster_UI.dynamic.health.bar.normal_colors;


	monster.stamina_dynamic_UI = stamina_UI_entity.new(
		config.current_config.large_monster_UI.dynamic.stamina.visibility,
		config.current_config.large_monster_UI.dynamic.stamina.bar,
		config.current_config.large_monster_UI.dynamic.stamina.text_label,
		config.current_config.large_monster_UI.dynamic.stamina.value_label,
		config.current_config.large_monster_UI.dynamic.stamina.percentage_label
	);

	monster.rage_dynamic_UI = rage_UI_entity.new(
		config.current_config.large_monster_UI.dynamic.rage.visibility,
		config.current_config.large_monster_UI.dynamic.rage.bar,
		config.current_config.large_monster_UI.dynamic.rage.text_label,
		config.current_config.large_monster_UI.dynamic.rage.value_label,
		config.current_config.large_monster_UI.dynamic.rage.percentage_label,
		config.current_config.large_monster_UI.static.rage.timer_label
	);

	for REpart, part in pairs(monster.parts) do
		body_part.init_dynamic_UI(part);
	end
end

function large_monster.init_highlighted_UI(monster)
	monster.highlighted_name_label = table_helpers.deep_copy(config.current_config.large_monster_UI.highlighted.monster_name_label);

	monster.health_highlighted_UI = health_UI_entity.new(
		config.current_config.large_monster_UI.highlighted.health.visibility,
		config.current_config.large_monster_UI.highlighted.health.bar,
		config.current_config.large_monster_UI.highlighted.health.text_label,
		config.current_config.large_monster_UI.highlighted.health.value_label,
		config.current_config.large_monster_UI.highlighted.health.percentage_label
	);

	monster.health_highlighted_UI.bar.colors = config.current_config.large_monster_UI.highlighted.health.bar.normal_colors;

	monster.stamina_highlighted_UI = stamina_UI_entity.new(
		config.current_config.large_monster_UI.highlighted.stamina.visibility,
		config.current_config.large_monster_UI.highlighted.stamina.bar,
		config.current_config.large_monster_UI.highlighted.stamina.text_label,
		config.current_config.large_monster_UI.highlighted.stamina.value_label,
		config.current_config.large_monster_UI.highlighted.stamina.percentage_label
	);
	
	monster.rage_highlighted_UI = rage_UI_entity.new(
		config.current_config.large_monster_UI.highlighted.rage.visibility,
		config.current_config.large_monster_UI.highlighted.rage.bar,
		config.current_config.large_monster_UI.highlighted.rage.text_label,
		config.current_config.large_monster_UI.highlighted.rage.value_label,
		config.current_config.large_monster_UI.highlighted.rage.percentage_label,
		config.current_config.large_monster_UI.highlighted.rage.timer_label
	);
	
	for REpart, part in pairs(monster.parts) do
		body_part.init_highlighted_UI(part);
	end
end

local physical_param_field = enemy_character_base_type_def:get_field("<PhysicalParam>k__BackingField");
local status_param_field = enemy_character_base_type_def:get_field("<StatusParam>k__BackingField")
local stamina_param_field = enemy_character_base_type_def:get_field("<StaminaParam>k__BackingField")
local anger_param_field = enemy_character_base_type_def:get_field("<AngerParam>k__BackingField")
local check_die_method = enemy_character_base_type_def:get_method("checkDie");

local physical_param_type = physical_param_field:get_type();
local get_vital_method = physical_param_type:get_method("getVital")
local get_capture_hp_vital_method = physical_param_type:get_method("get_CaptureHpVital")
local vital_list_field = physical_param_type:get_field("_VitalList")

local vital_param_type = get_vital_method:get_return_type();
local get_current_method = vital_param_type:get_method("get_Current")
local get_max_method = vital_param_type:get_method("get_Max")

local stamina_param_type = stamina_param_field:get_type();
local get_stamina_method = stamina_param_type:get_method("getStamina")
local get_max_stamina_method = stamina_param_type:get_method("getMaxStamina")

local anger_param_type = anger_param_field:get_type();
local is_anger_method = anger_param_type:get_method("isAnger")
local get_anger_point_method = anger_param_type:get_method("get_AngerPoint")
local get_limit_anger_method = anger_param_type:get_method("get_LimitAnger")
local anger_param_get_timer_method = anger_param_type:get_method("get_Timer")
local get_timer_anger_method = anger_param_type:get_method("get_TimerAnger")
local get_count_anger_method = anger_param_type:get_method("get_CountAnger")

local get_game_object_method = sdk.find_type_definition("via.Component"):get_method("get_GameObject")
local get_transform_method = sdk.find_type_definition("via.GameObject"):get_method("get_Transform")
local get_position_method = sdk.find_type_definition("via.Transform"):get_method("get_Position")

function large_monster.update_position(enemy)
	if not config.current_config.large_monster_UI.dynamic.enabled and
		not config.current_config.large_monster_UI.static.enabled then
		return;
	end

	local monster = large_monster.get_monster(enemy);
	if not monster then
		return;
	end

	-- cache off the game object and transform
	-- as these are pretty much guaranteed to stay constant
	-- as long as the enemy is alive
	if monster.game_object == nil then
		monster.game_object = get_game_object_method:call(enemy)
		if monster.game_object == nil then
			customization_menu.status = "No enemy game object";
			return;
		end
	end

	if monster.transform == nil then
		monster.transform = get_transform_method:call(monster.game_object)
		if monster.transform == nil then
			customization_menu.status = "No enemy transform";
			return;
		end
	end

	local position = get_position_method:call(monster.transform)
	if not position then
		customization_menu.status = "No enemy position";
		return;
	end

	if position ~= nil then
		monster.position = position;
	end
end

function large_monster.update(enemy)
	-- maybe more checks are needed here i'm not fully aware of how the code flows here
	if not config.current_config.large_monster_UI.dynamic.enabled and
		not config.current_config.large_monster_UI.static.enabled then
		return;
	end

	if enemy == nil then
		return;
	end

	local monster = large_monster.get_monster(enemy);

	local physical_param = physical_param_field:get_data(enemy)
	if physical_param == nil then
		customization_menu.status = "No physical param";
		return;
	end

	local vital_param = get_vital_method:call(physical_param, 0, 0);
	if vital_param == nil then
		customization_menu.status = "No vital param";
		return;
	end

	local health = get_current_method:call(vital_param);
	local max_health = get_max_method:call(vital_param);
	local capture_health = get_capture_hp_vital_method:call(physical_param);

	local dead_or_captured = check_die_method:call(enemy);
	if dead_or_captured == nil then
		return;
	end

	local stamina_param = stamina_param_field:get_data(enemy)
	if stamina_param == nil then
		customization_menu.status = "No stamina param";
		return;
	end

	local stamina = get_stamina_method:call(stamina_param);
	local max_stamina = get_max_stamina_method:call(stamina_param);

	local anger_param = anger_param_field:get_data(enemy);
	if anger_param == nil then
		customization_menu.status = "No anger param";
		return;
	end

	local is_in_rage = is_anger_method:call(anger_param);
	local rage_point = get_anger_point_method:call(anger_param);
	local rage_limit = get_limit_anger_method:call(anger_param);
	local rage_timer = anger_param_get_timer_method:call(anger_param);
	local rage_duration = get_timer_anger_method:call(anger_param);
	local rage_count = get_count_anger_method:call(anger_param);

	local vital_list = vital_list_field:get_data(physical_param);
	if vital_list == nil then
		customization_menu.status = "No vital list";
		return;
	end
	
	local vital_list_count = vital_list:call("get_Count");
	if  vital_list_count == nil or vital_list_count < 2 then
		customization_menu.status = "No vital list count";
		return;
	end

	local part_list = vital_list:call("get_Item", 1);
	if part_list == nil then
		customization_menu.status = "No part list";
		return;
	end

	local part_list_count = part_list:call("get_Count");
	if  part_list_count == nil then
		customization_menu.status = "No part list count";
		return;
	end

	local last_REpart = part_list:call("get_Item",  part_list_count - 1);
	local last_REpart_health = 9999999;
	if last_REpart ~= nil then
		local _last_REpart_health = last_REpart:call("get_Current");
		if last_REpart_health ~= nil then
			last_REpart_health = _last_REpart_health;
		end
	end
	
	local part_id = 1;
	for i = 0, part_list_count - 1 do

		local REpart = part_list:call("get_Item", i);
		if REpart == nil then
			goto continue;
		end
			
		local part_health = REpart:call("get_Current");
		if part_health == nil then
			goto continue;
		end

		local part_max_health = REpart:call("get_Max");
		if part_max_health == nil or part_max_health <= 0 then
			goto continue;
		end

		local part = monster.parts[REpart];
		if part == nil then
			local part_name = part_names.get_part_name(monster.id, part_id);

			if part_name ~= "" then
				part = body_part.new(REpart, part_name, part_id);
				monster.parts[REpart] = part;
			end
		end

		body_part.update(part, part_health, part_max_health);
		
		part_id = part_id + 1;
		::continue::
	end

	large_monster.update_position(enemy);

	if health ~= nil then
		monster.health = health;
	end

	if max_health ~= nil then
		monster.max_health = max_health;
	end

	if capture_health ~= nil then
		monster.capture_health = capture_health;
	end

	if max_health ~= nil and health ~= nil then
		monster.missing_health = max_health - health;
		if max_health ~= 0 then
			monster.health_percentage = health / max_health;
		end
	end

	if max_health ~= nil and capture_health ~= nil then
		if max_health ~= 0 then
			monster.capture_percentage = capture_health / max_health;
		end
	end

	if dead_or_captured ~= nil then
		monster.dead_or_captured = dead_or_captured;
	end

	if stamina ~= nil then
		monster.stamina = stamina;
	end

	if max_stamina ~= nil then
		monster.max_stamina = max_stamina;
	end

	if max_stamina ~= nil and stamina ~= nil then
		monster.missing_stamina = max_stamina - stamina;
		if max_stamina  ~= 0 then
			monster.stamina_percentage = stamina / max_stamina;
		end
	end

	if is_in_rage ~= nil then
		monster.is_in_rage = is_in_rage;
	end

	if rage_point ~= nil then
		monster.rage_point = rage_point;
	end

	if rage_limit ~= nil then
		monster.rage_limit = rage_limit;
	end

	if rage_point ~= nil and rage_limit ~= nil then
		if rage_limit ~= 0 then
			monster.rage_percentage = rage_point / rage_limit;
		end
	end

	if rage_timer ~= nil then
		monster.rage_timer = rage_timer;
	end

	if rage_duration ~= nil then
		monster.rage_duration = rage_duration;
	end

	if rage_timer ~= nil and rage_duration ~= nil and monster.is_in_rage then
		monster.rage_total_seconds_left = rage_duration - rage_timer;
		if monster.rage_total_seconds_left < 0 then
			monster.rage_total_seconds_left = 0;
		end

		monster.rage_minutes_left = math.floor(monster.rage_total_seconds_left / 60);
		monster.rage_seconds_left = monster.rage_total_seconds_left - 60 * monster.rage_minutes_left;
		if rage_duration ~= 0 then
			monster.rage_timer_percentage = monster.rage_total_seconds_left / rage_duration;
		end
	end

	if rage_count ~= nil then
		monster.rage_count = rage_count;
	end
end

function large_monster.draw_dynamic(monster, position_on_screen, opacity_scale)
	local monster_name_text = "";
	if config.current_config.large_monster_UI.dynamic.monster_name_label.include.monster_name then
		monster_name_text = string.format("%s ", monster.name);
	end

	if config.current_config.large_monster_UI.dynamic.monster_name_label.include.crown and monster.crown ~= "" then
		monster_name_text = monster_name_text .. string.format("%s ", monster.crown);
	end
	if config.current_config.large_monster_UI.dynamic.monster_name_label.include.size then
		monster_name_text = monster_name_text .. string.format("#%.0f ", 100 * monster.size);
	end

	if config.current_config.large_monster_UI.dynamic.monster_name_label.include.scrown_thresholds then
		monster_name_text = monster_name_text .. string.format("<=%.0f >=%.0f >=%.0f", 100 * monster.small_border,
				100 * monster.big_border, 100 * monster.king_border);
	end

	if monster.health < monster.capture_health then
		monster.health_dynamic_UI.bar.colors = config.current_config.large_monster_UI.dynamic.health.bar.capture_colors;
	else
		monster.health_dynamic_UI.bar.colors = config.current_config.large_monster_UI.dynamic.health.bar.normal_colors;
	end

	drawing.draw_label(monster.dynamic_name_label, position_on_screen, opacity_scale, monster_name_text);

	health_UI_entity.draw(monster, monster.health_dynamic_UI, position_on_screen, opacity_scale);
	drawing.draw_capture_line(monster.health_dynamic_UI.bar, position_on_screen, opacity_scale, monster.capture_percentage);

	stamina_UI_entity.draw(monster, monster.stamina_dynamic_UI, position_on_screen, opacity_scale);
	rage_UI_entity.draw(monster, monster.rage_dynamic_UI, position_on_screen, opacity_scale);

	--sort parts here
	local displayed_parts = {};
	for REpart, part in pairs(monster.parts) do
		if config.current_config.large_monster_UI.dynamic.parts.settings.hide_undamaged_parts and part.health == part.max_health and part.break_count == 0 then
			goto continue;
		end

		table.insert(displayed_parts, part);
		::continue::
	end

	if config.current_config.large_monster_UI.dynamic.parts.sorting.type == "Normal" then
		if config.current_config.large_monster_UI.dynamic.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif config.current_config.large_monster_UI.dynamic.parts.sorting.type == "Health" then
		if config.current_config.large_monster_UI.dynamic.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health > right.health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health < right.health;
			end);
		end
	elseif config.current_config.large_monster_UI.dynamic.parts.sorting.type == "Health Percentage" then
		if config.current_config.large_monster_UI.dynamic.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage > right.health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage < right.health_percentage;
			end);
		end
	end

	for j, part in ipairs(displayed_parts) do
		local part_position_on_screen = {
			x = position_on_screen.x + config.current_config.large_monster_UI.dynamic.parts.offset.x + config.current_config.large_monster_UI.dynamic.parts.spacing.x * (j - 1),
			y = position_on_screen.y + config.current_config.large_monster_UI.dynamic.parts.offset.y + config.current_config.large_monster_UI.dynamic.parts.spacing.y * (j - 1);
		}
		
		body_part.draw_dynamic(part, part_position_on_screen, opacity_scale);
	end
end

function large_monster.draw_static(monster, position_on_screen, opacity_scale)
	local monster_name_text = "";
	if config.current_config.large_monster_UI.static.monster_name_label.include.monster_name then
		monster_name_text = string.format("%s ", monster.name);
	end

	if config.current_config.large_monster_UI.static.monster_name_label.include.crown and monster.crown ~= "" then
		monster_name_text = monster_name_text .. string.format("%s ", monster.crown);
	end
	if config.current_config.large_monster_UI.static.monster_name_label.include.size then
		monster_name_text = monster_name_text .. string.format("#%.0f ", 100 * monster.size);
	end

	if config.current_config.large_monster_UI.static.monster_name_label.include.scrown_thresholds then
		monster_name_text = monster_name_text .. string.format("<=%.0f >=%.0f >=%.0f", 100 * monster.small_border,
				100 * monster.big_border, 100 * monster.king_border);
	end

	if monster.health < monster.capture_health then
		monster.health_static_UI.bar.colors = config.current_config.large_monster_UI.static.health.bar.capture_colors;
	else
		monster.health_static_UI.bar.colors = config.current_config.large_monster_UI.static.health.bar.normal_colors;
	end

	drawing.draw_label(monster.static_name_label, position_on_screen, opacity_scale, monster_name_text);


	health_UI_entity.draw(monster, monster.health_static_UI, position_on_screen, opacity_scale);
	drawing.draw_capture_line(monster.health_static_UI.bar, position_on_screen, opacity_scale, monster.capture_percentage);

	stamina_UI_entity.draw(monster, monster.stamina_static_UI, position_on_screen, opacity_scale);
	rage_UI_entity.draw(monster, monster.rage_static_UI, position_on_screen, opacity_scale);

	--sort parts here
	local displayed_parts = {};
	for REpart, part in pairs(monster.parts) do
		if config.current_config.large_monster_UI.static.parts.settings.hide_undamaged_parts and part.health == part.max_health and part.break_count == 0 then
			goto continue;
		end

		table.insert(displayed_parts, part);
		::continue::
	end

	if config.current_config.large_monster_UI.static.parts.sorting.type == "Normal" then
		if config.current_config.large_monster_UI.static.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif config.current_config.large_monster_UI.static.parts.sorting.type == "Health" then
		if config.current_config.large_monster_UI.static.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health > right.health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health < right.health;
			end);
		end
	elseif config.current_config.large_monster_UI.static.parts.sorting.type == "Health Percentage" then
		if config.current_config.large_monster_UI.static.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage > right.health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage < right.health_percentage;
			end);
		end
	end

	for j, part in ipairs(displayed_parts) do
		local part_position_on_screen = {
			x = position_on_screen.x + config.current_config.large_monster_UI.static.parts.offset.x + config.current_config.large_monster_UI.static.parts.spacing.x * (j - 1),
			y = position_on_screen.y + config.current_config.large_monster_UI.static.parts.offset.y + config.current_config.large_monster_UI.static.parts.spacing.y * (j - 1);
		}

		body_part.draw_static(part, part_position_on_screen, opacity_scale);
	end
end

function large_monster.draw_highlighted(monster, position_on_screen, opacity_scale)
	local monster_name_text = "";
	if config.current_config.large_monster_UI.highlighted.monster_name_label.include.monster_name then
		monster_name_text = string.format("%s ", monster.name);
	end

	if config.current_config.large_monster_UI.highlighted.monster_name_label.include.crown and monster.crown ~= "" then
		monster_name_text = monster_name_text .. string.format("%s ", monster.crown);
	end
	if config.current_config.large_monster_UI.highlighted.monster_name_label.include.size then
		monster_name_text = monster_name_text .. string.format("#%.0f ", 100 * monster.size);
	end

	if config.current_config.large_monster_UI.highlighted.monster_name_label.include.scrown_thresholds then
		monster_name_text = monster_name_text .. string.format("<=%.0f >=%.0f >=%.0f", 100 * monster.small_border,
				100 * monster.big_border, 100 * monster.king_border);
	end

	if monster.health < monster.capture_health then
		monster.health_highlighted_UI.bar.colors = config.current_config.large_monster_UI.highlighted.health.bar.capture_colors;
	else
		monster.health_highlighted_UI.bar.colors = config.current_config.large_monster_UI.highlighted.health.bar.normal_colors;
	end

	drawing.draw_label(monster.highlighted_name_label, position_on_screen, opacity_scale, monster_name_text);


	health_UI_entity.draw(monster, monster.health_highlighted_UI, position_on_screen, opacity_scale);
	drawing.draw_capture_line(monster.health_highlighted_UI.bar, position_on_screen, opacity_scale, monster.capture_percentage);

	stamina_UI_entity.draw(monster, monster.stamina_highlighted_UI, position_on_screen, opacity_scale);
	rage_UI_entity.draw(monster, monster.rage_highlighted_UI, position_on_screen, opacity_scale);

	--sort parts here
	local displayed_parts = {};
	for REpart, part in pairs(monster.parts) do
		if config.current_config.large_monster_UI.highlighted.parts.settings.hide_undamaged_parts and part.health == part.max_health and part.break_count == 0 then
			goto continue;
		end

		table.insert(displayed_parts, part);
		::continue::
	end

	if config.current_config.large_monster_UI.highlighted.parts.sorting.type == "Normal" then
		if config.current_config.large_monster_UI.highlighted.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif config.current_config.large_monster_UI.highlighted.parts.sorting.type == "Health" then
		if config.current_config.large_monster_UI.highlighted.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health > right.health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health < right.health;
			end);
		end
	elseif config.current_config.large_monster_UI.highlighted.parts.sorting.type == "Health Percentage" then
		if config.current_config.large_monster_UI.highlighted.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage > right.health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage < right.health_percentage;
			end);
		end
	end

	for j, part in ipairs(displayed_parts) do
		local part_position_on_screen = {
			x = position_on_screen.x + config.current_config.large_monster_UI.highlighted.parts.offset.x + config.current_config.large_monster_UI.highlighted.parts.spacing.x * (j - 1),
			y = position_on_screen.y + config.current_config.large_monster_UI.highlighted.parts.offset.y + config.current_config.large_monster_UI.highlighted.parts.spacing.y * (j - 1);
		}

		body_part.draw_highlighted(part, part_position_on_screen, opacity_scale);
	end
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
	screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
	part_names = require("MHR_Overlay.Misc.part_names");
end

return large_monster;