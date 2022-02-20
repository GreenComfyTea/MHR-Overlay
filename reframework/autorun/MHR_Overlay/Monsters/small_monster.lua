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

	monster.game_object = nil
	monster.transform = nil
	monster.position = Vector3f.new(0, 0, 0);
	monster.distance = 0;

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

	monster.name_label.offset.x = monster.name_label.offset.x * config.current_config.global_settings.modifiers.global_scale_modifier;
	monster.name_label.offset.y = monster.name_label.offset.y * config.current_config.global_settings.modifiers.global_scale_modifier;

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

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase")
local physical_param_field = enemy_character_base_type_def:get_field("<PhysicalParam>k__BackingField");
local status_param_field = enemy_character_base_type_def:get_field("<StatusParam>k__BackingField")
local stamina_param_field = enemy_character_base_type_def:get_field("<StaminaParam>k__BackingField")
local check_die_method = enemy_character_base_type_def:get_method("checkDie");

local physical_param_type = physical_param_field:get_type()
local get_vital_method = physical_param_type:get_method("getVital")
local get_capture_hp_vital_method = physical_param_type:get_method("get_CaptureHpVital")

local vital_param_type = get_vital_method:get_return_type()
local get_current_method = vital_param_type:get_method("get_Current")
local get_max_method = vital_param_type:get_method("get_Max")

local stamina_param_type = stamina_param_field:get_type()
local get_stamina_method = stamina_param_type:get_method("getStamina")
local get_max_stamina_method = stamina_param_type:get_method("getMaxStamina")

local get_gameobject_method = sdk.find_type_definition("via.Component"):get_method("get_GameObject")
local get_transform_method = sdk.find_type_definition("via.GameObject"):get_method("get_Transform")
local get_position_method = sdk.find_type_definition("via.Transform"):get_method("get_Position")

function small_monster.update_position(enemy)
	if not config.current_config.small_monster_UI.enabled then
		return;
	end

	local monster = small_monster.get_monster(enemy);
	if not monster then return end

	-- cache off the game object and transform
	-- as these are pretty much guaranteed to stay constant
	-- as long as the enemy is alive
	if monster.game_object == nil then
		monster.game_object = get_gameobject_method:call(enemy)
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

function small_monster.update(enemy)
	if enemy == nil then
		return;
	end

	if not config.current_config.small_monster_UI.enabled then
		return;
	end

	local physical_param = physical_param_field:get_data(enemy)
	if physical_param == nil then
		customization_menu.status = "No physical param";
		return;
	end

	local status_param = status_param_field:get_data(enemy)
	if status_param == nil then
		customization_menu.status = "No status param";
		return;
	end

	local stamina_param = stamina_param_field:get_data(enemy)
	if stamina_param == nil then
		customization_menu.status = "No stamina param";
		return;
	end

	local vital_param = get_vital_method:call(physical_param, 0, 0);
	if vital_param == nil then
		customization_menu.status = "No vital param";
		return;
	end

	local health = get_current_method:call(vital_param)
	local max_health = get_max_method:call(vital_param)
	local capture_health = get_capture_hp_vital_method:call(physical_param)

	local stamina = get_stamina_method:call(stamina_param)
	local max_stamina = get_max_stamina_method:call(stamina_param)

	local dead_or_captured = check_die_method:call(enemy);
	if dead_or_captured == nil then
		return;
	end

	small_monster.update_position(enemy)

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
end

function small_monster.draw(monster, position_on_screen, opacity_scale)
	drawing.draw_label(monster.name_label, position_on_screen, opacity_scale, monster.name);

	local health_position_on_screen = {
		x = position_on_screen.x + config.current_config.small_monster_UI.health.offset.x * config.current_config.global_settings.modifiers.global_scale_modifier,
		y = position_on_screen.y + config.current_config.small_monster_UI.health.offset.y * config.current_config.global_settings.modifiers.global_scale_modifier
	};

	local stamina_position_on_screen = {
		x = position_on_screen.x + config.current_config.small_monster_UI.stamina.offset.x * config.current_config.global_settings.modifiers.global_scale_modifier,
		y = position_on_screen.y + config.current_config.small_monster_UI.stamina.offset.y * config.current_config.global_settings.modifiers.global_scale_modifier
	};
	
	health_UI_entity.draw(monster, monster.health_UI, health_position_on_screen, opacity_scale);
	stamina_UI_entity.draw(monster, monster.stamina_UI, stamina_position_on_screen, opacity_scale);
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