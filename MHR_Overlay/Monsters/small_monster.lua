local small_monster = {};
local singletons;
local customization_menu;
local config;
local table_helpers;
local health_UI_entity;
local stamina_UI_entity;
local screen;
local drawing;

small_monster.list = {};

function small_monster.new(enemy)
	local monster = {};
	monster.is_large = false;

	monster.health = 0;
	monster.max_health = 999999;
	monster.health_percentage = 0;
	monster.missing_health = 0;
	monster.capture_health = 0;

	monster.stamina = 0;
	monster.max_stamina = 1000;
	monster.stamina_percentage = 0;
	monster.missing_stamina = 0;

	monster.position = Vector3f.new(0, 0, 0);
	monster.name = "Small Monster";
	
	small_monster.init(monster, enemy);
	small_monster.init_UI(monster);

	if small_monster.list[enemy] == nil then
		small_monster.list[enemy] = monster;
	end

	return monster;
end

function small_monster.get_monster(enemy)
	if small_monster.list[enemy] == nil then
		small_monster.list[enemy] = small_monster.new(enemy);
	end

	return small_monster.list[enemy];
end

function small_monster.init(monster, enemy)
	local enemy_type = enemy:get_field("<EnemyType>k__BackingField");
	if enemy_type == nil then
		customization_menu.status = "No enemy type";
		return;
	end

	local enemy_name = singletons.message_manager:call("getEnemyNameMessage", enemy_type);
	if enemy_name ~= nil then
		monster.name = enemy_name;
	end
end

function small_monster.init_UI(monster)
	monster.name_label = table_helpers.deep_copy(config.current_config.small_monster_UI.monster_name_label);

	monster.health_UI = health_UI_entity.new(
		config.current_config.small_monster_UI.health.visibility,
		config.current_config.small_monster_UI.health.bar,
		config.current_config.small_monster_UI.health.text_label,
		config.current_config.small_monster_UI.health.value_label,
		config.current_config.small_monster_UI.health.percentage_label
	);

	monster.stamina_UI = stamina_UI_entity.new(
		config.current_config.small_monster_UI.stamina.visibility,
		config.current_config.small_monster_UI.stamina.bar,
		config.current_config.small_monster_UI.stamina.text_label,
		config.current_config.small_monster_UI.stamina.value_label,
		config.current_config.small_monster_UI.stamina.percentage_label
	);
end

function small_monster.update(enemy)
	if enemy == nil then
		return;
	end

	local physical_param = enemy:get_field("<PhysicalParam>k__BackingField");
	if physical_param == nil then
		customization_menu.status = "No physical param";
		return;
	end

	local status_param = enemy:get_field("<StatusParam>k__BackingField");
	if status_param == nil then
		customization_menu.status = "No status param";
		return;
	end

	local stamina_param = enemy:get_field("<StaminaParam>k__BackingField");
	if stamina_param == nil then
		customization_menu.status = "No stamina param";
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

	local stamina = stamina_param:call("getStamina");
	local max_stamina = stamina_param:call("getMaxStamina");


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

	local monster = small_monster.get_monster(enemy);

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
end

function small_monster.draw(monster, position_on_screen, opacity_scale)
	drawing.draw_label(monster.name_label, position_on_screen, opacity_scale, monster.name);

	
	health_UI_entity.draw(monster, monster.health_UI, position_on_screen, opacity_scale);
	stamina_UI_entity.draw(monster, monster.stamina_UI, position_on_screen, opacity_scale);
end

function small_monster.init_list()
	small_monster.list = {};
end

function small_monster.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	config = require("MHR_Overlay.Misc.config");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
	screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
end

return small_monster;