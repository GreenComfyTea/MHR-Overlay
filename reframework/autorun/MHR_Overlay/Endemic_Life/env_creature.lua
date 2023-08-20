local this = {};

local drawing;
local customization_menu;
local singletons;
local config;
local utils;
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

this.list = {};

this.creature_ids = {
	cutterfly = 50,
	clothfly = 7,
	ruby_wirebug = 62,
	gold_wirebug = 63
};

function this.new(REcreature)
	local creature = {};

	creature.life = 0;
	creature.name = "Env Creature";
	creature.is_inactive = true;

	creature.position = Vector3f.new(0, 0, 0);
	creature.distance = 0;

	this.init(creature, REcreature);
	this.init_UI(creature);

	if this.list[REcreature] == nil then
		this.list[REcreature] = creature;
	end

	return creature;
end

function this.get_creature(REcreature)
	if this.list[REcreature] == nil then
		this.list[REcreature] = this.new(REcreature);
	end

	return this.list[REcreature];
end

local environment_creature_base_type_def = sdk.find_type_definition("snow.envCreature.EnvironmentCreatureBase");
local creature_type_field = environment_creature_base_type_def:get_field("_Type");
local creature_is_inactive_field = environment_creature_base_type_def:get_field("<Muteki>k__BackingField");

local message_manager_type_def = sdk.find_type_definition("snow.gui.MessageManager");
local get_env_creature_name_message_method = message_manager_type_def:get_method("getEnvCreatureNameMessage");

local get_pos_method = environment_creature_base_type_def:get_method("get_Pos");

function this.init(creature, REcreature)
	local creature_type = creature_type_field:get_data(REcreature);
	if creature_type == nil then
		error_handler.report("env_creature.init", "Failed to access Data: creature_type");
		return;
	end

	local creature_name = get_env_creature_name_message_method:call(singletons.message_manager, creature_type);
	if creature_name == nil then
		error_handler.report("env_creature.init", "Failed to access Data: creature_name");
		return;
	end
	
	creature.name = creature_name;
end

function this.init_UI(creature)
	creature.name_label = utils.table.deep_copy(config.current_config.endemic_life_UI.creature_name_label);

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	creature.name_label.offset.x = creature.name_label.offset.x * global_scale_modifier;
	creature.name_label.offset.y = creature.name_label.offset.y * global_scale_modifier;
end

function this.update_position(REcreature, creature)
	if not config.current_config.endemic_life_UI.enabled then
		return;
	end

	if creature == nil then
		creature = this.get_creature(REcreature);
	end

	local position = get_pos_method:call(REcreature);
	if position == nil then
		error_handler.report("env_creature.update_position", "Failed to access Data: position");
	end
	
	creature.position = position;
end

function this.update(REcreature, creature)
	if not config.current_config.endemic_life_UI.enabled then
		return;
	end

	if creature == nil then
		creature = this.get_creature(REcreature);
	end

	local is_inactive = creature_is_inactive_field:get_data(REcreature);
	if is_inactive == nil then
		error_handler.report("env_creature.update", "Failed to access Data: is_inactive");
	end
	
	creature.is_inactive = is_inactive;
end

function this.draw(creature, position_on_screen, opacity_scale)
	if d2d ~= nil and config.current_config.global_settings.renderer.use_d2d_if_available then
		local text_width, text_height = drawing.font:measure(creature.name);
		position_on_screen.x = position_on_screen.x - text_width / 2;
	end

	drawing.draw_label(creature.name_label, position_on_screen, opacity_scale, creature.name);
end

function this.init_list()
	this.list = {};
end

function this.init_dependencies()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	config = require("MHR_Overlay.Misc.config");
	utils = require("MHR_Overlay.Misc.utils");
	--health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	--stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
	--screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
	--ailments = require("MHR_Overlay.Monsters.ailments");
	--ailment_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_UI_entity");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
end

return this;
