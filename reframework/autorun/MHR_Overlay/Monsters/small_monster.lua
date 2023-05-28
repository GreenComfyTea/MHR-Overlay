local this = {};

local singletons;
local customization_menu;
local config;
local utils;
local health_UI_entity;
local stamina_UI_entity;
local screen;
local drawing;
local ailments;
local ailment_UI_entity;
local ailment_buildup;
local ailment_buildup_UI_entity;

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

function this.new(enemy)
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

	monster.UI = {};

	this.init(monster, enemy);
	this.init_UI(monster);

	this.update_position(enemy, monster);
	this.update_health(enemy, monster);
	this.update(enemy, monster);

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

local message_manager_type_def = sdk.find_type_definition("snow.gui.MessageManager");
local get_enemy_name_message_method = message_manager_type_def:get_method("getEnemyNameMessage");

function this.init(monster, enemy)
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

function this.init_UI(monster)
	local cached_config = config.current_config.small_monster_UI;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local monster_UI = monster.UI;

	monster_UI.name_label = utils.table.deep_copy(cached_config.monster_name_label);
	
	monster_UI.name_label.offset.x = monster_UI.name_label.offset.x * global_scale_modifier;
	monster_UI.name_label.offset.y = monster_UI.name_label.offset.y * global_scale_modifier;

	monster_UI.health_UI = health_UI_entity.new(
		cached_config.health.visibility,
		cached_config.health.bar,
		cached_config.health.text_label,
		cached_config.health.value_label,
		cached_config.health.percentage_label
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
end

local get_physical_param_method = enemy_character_base_type_def:get_method("get_PhysicalParam");
local check_die_method = enemy_character_base_type_def:get_method("checkDie");

local physical_param_type = get_physical_param_method:get_return_type();
local get_vital_method = physical_param_type:get_method("getVital");

local vital_param_type = get_vital_method:get_return_type();
local get_current_method = vital_param_type:get_method("get_Current");
local get_max_method = vital_param_type:get_method("get_Max");

local get_pos_field = enemy_character_base_type_def:get_method("get_Pos");

function this.update_position(enemy, monster)
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

function this.update(enemy, monster)
	if not config.current_config.small_monster_UI.enabled then
		return;
	end

	local dead_or_captured = check_die_method:call(enemy);
	if dead_or_captured ~= nil then
		monster.dead_or_captured = dead_or_captured;
	end

	pcall(ailments.update_ailments, enemy, monster);
end

function this.update_health(enemy, monster)
	if not config.current_config.small_monster_UI.enabled or not config.current_config.small_monster_UI.health.visibility then
		return;
	end

	local physical_param = get_physical_param_method:call(enemy);
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

function this.draw(monster, cached_config, position_on_screen, opacity_scale)
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	drawing.draw_label(monster.UI.name_label, position_on_screen, opacity_scale, monster.name);

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

	health_UI_entity.draw(monster, monster.UI.health_UI, health_position_on_screen, opacity_scale);
	ailments.draw(monster, monster.UI.ailment_UI, cached_config, ailments_position_on_screen, opacity_scale);
	ailment_buildup.draw(monster, monster.UI.ailment_buildup_UI, cached_config, ailment_buildups_position_on_screen, opacity_scale);
end

function this.init_list()
	this.list = {};
end

function this.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	config = require("MHR_Overlay.Misc.config");
	utils = require("MHR_Overlay.Misc.utils");
	health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
	screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
	ailments = require("MHR_Overlay.Monsters.ailments");
	ailment_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_UI_entity");
	ailment_buildup = require("MHR_Overlay.Monsters.ailment_buildup");
	ailment_buildup_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_buildup_UI_entity");
end

return this;
