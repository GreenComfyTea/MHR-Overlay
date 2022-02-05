local large_monster = {};
local singletons;
local customization_menu;
local config;
local table_helpers;
local health_UI_entity;
local stamina_UI_entity;
local rage_UI_entity;
local screen;
local drawing;
local body_part;

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

	monster.position = Vector3f.new(0, 0, 0);

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

function large_monster.init(monster, enemy)
	local enemy_type = enemy:get_field("<EnemyType>k__BackingField");
	if enemy_type == nil then
		customization_menu.status = "No enemy type";
		return;
	end

	monster.id = enemy_type;

	local enemy_name = singletons.message_manager:call("getEnemyNameMessage", enemy_type);
	if enemy_name ~= nil then
		monster.name = enemy_name;
	end

	local size_info = singletons.enemy_manager:call("findEnemySizeInfo", enemy_type);
	if size_info ~= nil then
		local small_border = size_info:call("get_SmallBorder");
		local big_border = size_info:call("get_BigBorder");
		local king_border = size_info:call("get_KingBorder");

		local size = enemy:call("get_MonsterListRegisterScale");

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
			monster.crown = "Mini";
		elseif monster.size >= monster.king_border then
			monster.crown = "Gold";
		elseif monster.size >= monster.big_border then
			monster.crown = "Silver";
		end
	end
end

function large_monster.init_static_UI(monster)
	monster.static_name_label = table_helpers.deep_copy(config.current_config.large_monster_UI.static.monster_name_label);
	
	monster.health_static_UI = health_UI_entity.new(
		config.current_config.large_monster_UI.static.health.bar,
		config.current_config.large_monster_UI.static.health.text_label,
		config.current_config.large_monster_UI.static.health.value_label,
		config.current_config.large_monster_UI.static.health.percentage_label
	);

	monster.stamina_static_UI = stamina_UI_entity.new(
		config.current_config.large_monster_UI.static.stamina.bar,
		config.current_config.large_monster_UI.static.stamina.text_label,
		config.current_config.large_monster_UI.static.stamina.value_label,
		config.current_config.large_monster_UI.static.stamina.percentage_label
	);
	
	monster.rage_static_UI = rage_UI_entity.new(
		config.current_config.large_monster_UI.static.rage.bar,
		config.current_config.large_monster_UI.static.rage.text_label,
		config.current_config.large_monster_UI.static.rage.value_label,
		config.current_config.large_monster_UI.static.rage.percentage_label
	);
	
	for REpart, part in pairs(monster.parts) do
		body_part.init_static_UI(part);
	end
end

function large_monster.init_dynamic_UI(monster)
	monster.dynamic_name_label = table_helpers.deep_copy(config.current_config.large_monster_UI.dynamic.monster_name_label);

	monster.health_dynamic_UI = health_UI_entity.new(
		config.current_config.large_monster_UI.dynamic.health.bar,
		config.current_config.large_monster_UI.dynamic.health.text_label,
		config.current_config.large_monster_UI.dynamic.health.value_label,
		config.current_config.large_monster_UI.dynamic.health.percentage_label
	);

	monster.stamina_dynamic_UI = stamina_UI_entity.new(
		config.current_config.large_monster_UI.dynamic.stamina.bar,
		config.current_config.large_monster_UI.dynamic.stamina.text_label,
		config.current_config.large_monster_UI.dynamic.stamina.value_label,
		config.current_config.large_monster_UI.dynamic.stamina.percentage_label
	);

	monster.rage_dynamic_UI = rage_UI_entity.new(
		config.current_config.large_monster_UI.dynamic.rage.bar,
		config.current_config.large_monster_UI.dynamic.rage.text_label,
		config.current_config.large_monster_UI.dynamic.rage.value_label,
		config.current_config.large_monster_UI.dynamic.rage.percentage_label
	);

	for REpart, part in pairs(monster.parts) do
		body_part.init_dynamic_UI(part);
	end
end

function large_monster.update(enemy)
	if enemy == nil then
		return;
	end

	local monster = large_monster.get_monster(enemy);

	local physical_param = enemy:get_field("<PhysicalParam>k__BackingField");
	if physical_param == nil then
		customization_menu.status = "No physical param";
		return;
	end

	local vital_param = physical_param:call("getVital", 0, 0);
	if vital_param == nil then
		customization_menu.status = "No vital param";
		return;
	end

	local health = vital_param:call("get_Current");
	local max_health = vital_param:call("get_Max");
	local capture_health = physical_param:call("get_CaptureHpVital");

	local stamina_param = enemy:get_field("<StaminaParam>k__BackingField");
	if stamina_param == nil then
		customization_menu.status = "No stamina param";
		return;
	end

	local stamina = stamina_param:call("getStamina");
	local max_stamina = stamina_param:call("getMaxStamina");

	local anger_param = enemy:get_field("<AngerParam>k__BackingField");
	if anger_param == nil then
		customization_menu.status = "No anger param";
		return;
	end

	local is_in_rage = anger_param:call("isAnger");
	local rage_point = anger_param:call("get_AngerPoint");
	local rage_limit = anger_param:call("get_LimitAnger");
	local rage_timer = anger_param:call("get_Timer");
	local rage_duration = anger_param:call("get_TimerAnger");
	local rage_count = anger_param:call("get_CountAnger");

	local vital_list = physical_param:get_field("_VitalList");
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

		if part_health == last_REpart_health then
			break;
		end

		local part_max_health = REpart:call("get_Max");
		if part_max_health == nil or part_max_health <= 0 then
			goto continue;
		end

		local part = monster.parts[REpart];
		if part == nil then
			part = body_part.new(REpart, part_id);
			monster.parts[REpart] = part;
		end

		body_part.update(part, part_health, part_max_health);
		
		part_id = part_id + 1;
		::continue::
	end

	local enemy_game_object = enemy:call("get_GameObject");
	if enemy_game_object == nil then
		customization_menu.status = "No enemy game object";
		return;
	end

	local enemy_transform = enemy_game_object:call("get_Transform");
	if enemy_transform == nil then
		customization_menu.status = "No enemy transform";
		return;
	end

	local position = enemy_transform:call("get_Position");
	if not position then
		customization_menu.status = "No enemy position";
		return;
	end

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

	if position ~= nil then
		monster.position = position;
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

	drawing.draw_label(monster.dynamic_name_label, position_on_screen, opacity_scale, monster_name_text .. " " .. tostring(monster.id));

	health_UI_entity.draw(monster, monster.health_dynamic_UI, position_on_screen, opacity_scale);
	stamina_UI_entity.draw(monster, monster.stamina_dynamic_UI, position_on_screen, opacity_scale);
	rage_UI_entity.draw(monster, monster.rage_dynamic_UI, position_on_screen, opacity_scale);

	local j = 0;
	for REpart, part in pairs(monster.parts) do
		local part_position_on_screen = {
			x = position_on_screen.x + config.current_config.large_monster_UI.dynamic.parts.offset.x + config.current_config.large_monster_UI.dynamic.parts.spacing.x * j,
			y = position_on_screen.y + config.current_config.large_monster_UI.dynamic.parts.offset.y + config.current_config.large_monster_UI.dynamic.parts.spacing.y * j;
		}
		
		body_part.draw_dynamic(part, part_position_on_screen, opacity_scale);

		j = j + 1;
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

	drawing.draw_label(monster.static_name_label, position_on_screen, opacity_scale, monster_name_text .. " " .. tostring(monster.id));

	health_UI_entity.draw(monster, monster.health_static_UI, position_on_screen, opacity_scale);
	stamina_UI_entity.draw(monster, monster.stamina_static_UI, position_on_screen, opacity_scale);
	rage_UI_entity.draw(monster, monster.rage_static_UI, position_on_screen, opacity_scale);

	local j = 0;
	for REpart, part in pairs(monster.parts) do
		local part_position_on_screen = {
			x = position_on_screen.x + config.current_config.large_monster_UI.static.parts.offset.x + config.current_config.large_monster_UI.static.parts.spacing.x * j,
			y = position_on_screen.y + config.current_config.large_monster_UI.static.parts.offset.y + config.current_config.large_monster_UI.static.parts.spacing.y * j;
		}

		body_part.draw_static(part, part_position_on_screen, opacity_scale);

		j = j + 1;
	end
end

function large_monster.init_list()
	large_monster.list = {};
end

function large_monster.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	config = require("MHR_Overlay.Misc.config");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	body_part = require("MHR_Overlay.Monsters.body_part");
	health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
	rage_UI_entity = require("MHR_Overlay.UI.UI_Entities.rage_UI_entity");
	screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
end

return large_monster;