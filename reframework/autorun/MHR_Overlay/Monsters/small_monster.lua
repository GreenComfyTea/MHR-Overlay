local small_monster = {};
local singletons;
local customization_menu;
local config;
local table_helpers;
local health_UI_entity;
local stamina_UI_entity;
local screen;
local drawing;
local ailments;
local ailment_UI_entity;
local ailment_buildup;

small_monster.list = {};

function small_monster.new(enemy)
	local monster = {};
	monster.is_large = false;

	monster.health = 0;
	monster.max_health = 999999;
	monster.health_percentage = 0;
	monster.missing_health = 0;
	monster.capture_health = 0;

	monster.position = Vector3f.new(0, 0, 0);
	monster.distance = 0;

	monster.name = "Small Monster";

	monster.ailments = ailments.init_ailments();

	small_monster.init(monster, enemy);
	small_monster.init_UI(monster);

	if small_monster.list[enemy] == nil then
		small_monster.list[enemy] = monster;
	end

	small_monster.update_position(enemy, monster);
	small_monster.update(enemy, monster);
	small_monster.update_health(enemy, monster);

	return monster;
end

function small_monster.get_monster(enemy)
	local monster = small_monster.list[enemy];
	if monster == nil then
		monster = small_monster.new(enemy);
	end

	return monster;
end

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_type_field = enemy_character_base_type_def:get_field("<EnemyType>k__BackingField");

local message_manager_type_def = sdk.find_type_definition("snow.gui.MessageManager");
local get_enemy_name_message_method = message_manager_type_def:get_method("getEnemyNameMessage");

function small_monster.init(monster, enemy)
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
end

function small_monster.init_UI(monster)
	local cached_config = config.current_config.small_monster_UI;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	monster.name_label = table_helpers.deep_copy(cached_config.monster_name_label);

	monster.name_label.offset.x = monster.name_label.offset.x * global_scale_modifier;
	monster.name_label.offset.y = monster.name_label.offset.y * global_scale_modifier;

	monster.health_UI = health_UI_entity.new(
		cached_config.health.visibility,
		cached_config.health.bar,
		cached_config.health.text_label,
		cached_config.health.value_label,
		cached_config.health.percentage_label
	);

	monster.ailment_UI = ailment_UI_entity.new(
		cached_config.ailments.visibility,
		cached_config.ailments.bar,
		cached_config.ailments.ailment_name_label,
		cached_config.ailments.text_label,
		cached_config.ailments.value_label,
		cached_config.ailments.percentage_label,
		cached_config.ailments.timer_label
	);

	ailments.init_ailment_buildup_small_UI(monster.ailments);
end

local physical_param_field = enemy_character_base_type_def:get_field("<PhysicalParam>k__BackingField");
local check_die_method = enemy_character_base_type_def:get_method("checkDie");

local physical_param_type = physical_param_field:get_type();
local get_vital_method = physical_param_type:get_method("getVital");

local vital_param_type = get_vital_method:get_return_type();
local get_current_method = vital_param_type:get_method("get_Current");
local get_max_method = vital_param_type:get_method("get_Max");

local get_pos_field = enemy_character_base_type_def:get_method("get_Pos");

function small_monster.update_position(enemy, monster)
	local cached_config = config.current_config.small_monster_UI;

	if not cached_config.enabled then
		return;
	end

	if not cached_config.dynamic_positioning.enabled and cached_config.static_sorting.type ~= "Distance" then
		return;
	end

	local position = get_pos_field:call(enemy);
	if position ~= nil then
		monster.position = position;
	end
end

function small_monster.update(enemy, monster)
	if not config.current_config.small_monster_UI.enabled then
		return;
	end

	local dead_or_captured = check_die_method:call(enemy);
	monster.dead_or_captured = (dead_or_captured == nil and false) or dead_or_captured;

	ailments.update_ailments(enemy, monster);
end

function small_monster.update_health(enemy, monster)
	if not config.current_config.small_monster_UI.enabled or not config.current_config.small_monster_UI.health.visibility then
		return;
	end

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

	monster.health = get_current_method:call(vital_param) or monster.health;
	monster.max_health = get_max_method:call(vital_param) or monster.max_health;

	monster.missing_health = monster.max_health - monster.health;
	if monster.max_health ~= 0 then
		monster.health_percentage = monster.health / monster.max_health;
		monster.capture_percentage = monster.capture_health / monster.max_health;
	end
end

function small_monster.draw(monster, position_on_screen, opacity_scale)
	local cached_config = config.current_config.small_monster_UI;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	drawing.draw_label(monster.name_label, position_on_screen, opacity_scale, monster.name);

	local health_position_on_screen = {
		x = position_on_screen.x + cached_config.health.offset.x * global_scale_modifier,
		y = position_on_screen.y + cached_config.health.offset.y * global_scale_modifier
	};

	local ailments_position_on_screen = {
		x = position_on_screen.x + cached_config.ailments.offset.x * global_scale_modifier,
		y = position_on_screen.y + cached_config.ailments.offset.y * global_scale_modifier
	};

	local ailment_buildups_position_on_screen = {
		x = position_on_screen.x + cached_config.ailment_buildups.offset.x * global_scale_modifier,
		y = position_on_screen.y + cached_config.ailment_buildups.offset.y * global_scale_modifier
	};

	health_UI_entity.draw(monster, monster.health_UI, health_position_on_screen, opacity_scale);
	ailments.draw_small(monster, ailments_position_on_screen, opacity_scale);
	ailment_buildup.draw_small(monster, ailment_buildups_position_on_screen, opacity_scale);
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
	ailments = require("MHR_Overlay.Monsters.ailments");
	ailment_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_UI_entity");
	ailment_buildup = require("MHR_Overlay.Monsters.ailment_buildup");
end

return small_monster;
