local env_creature = {};
local drawing;
local customization_menu;
local singletons;
local config;
local table_helpers;

env_creature.list = {};

function env_creature.new(REcreature)
	local creature = {};

	creature.life = 0;
	creature.name = "Env Creature";
	creature.is_inactive = true;

	creature.position = Vector3f.new(0, 0, 0);
	creature.distance = 0;

	env_creature.init(creature, REcreature);
	env_creature.init_UI(creature);

	if env_creature.list[REcreature] == nil then
		env_creature.list[REcreature] = creature;
	end

	return creature;
end

function env_creature.get_creature(REcreature)
	if env_creature.list[REcreature] == nil then
		env_creature.list[REcreature] = env_creature.new(REcreature);
	end

	return env_creature.list[REcreature];
end

local environment_creature_base_type_def = sdk.find_type_definition("snow.envCreature.EnvironmentCreatureBase");
local creature_type_field = environment_creature_base_type_def:get_field("_Type");
local creature_is_inactive_field = environment_creature_base_type_def:get_field("<Muteki>k__BackingField");

local message_manager_type_def = sdk.find_type_definition("snow.gui.MessageManager");
local get_env_creature_name_message_method = message_manager_type_def:get_method("getEnvCreatureNameMessage");

local get_pos_method = environment_creature_base_type_def:get_method("get_Pos");

function env_creature.init(creature, REcreature)
	local creature_type = creature_type_field:get_data(REcreature);
	if creature_type == nil then
		customization_menu.status = "No env creature type";
		return;
	end

	local creature_name = get_env_creature_name_message_method:call(singletons.message_manager,
		creature_type);
	if creature_name ~= nil then
		creature.name = creature_name;
	end
end

function env_creature.init_UI(creature)
	creature.name_label = table_helpers.deep_copy(config.current_config.endemic_life_UI.creature_name_label);

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	creature.name_label.offset.x = creature.name_label.offset.x * global_scale_modifier;
	creature.name_label.offset.y = creature.name_label.offset.y * global_scale_modifier;
end

function env_creature.update_position(REcreature, creature)
	if not config.current_config.endemic_life_UI.enabled then
		return;
	end

	if creature == nil then
		creature = env_creature.get_creature(REcreature);
	end

	local position = get_pos_method:call(REcreature);
	if position ~= nil then
		creature.position = position;
	end
end

function env_creature.update(REcreature, creature)
	if not config.current_config.endemic_life_UI.enabled then
		return;
	end

	if creature == nil then
		creature = env_creature.get_creature(REcreature);
	end

	local is_inactive = creature_is_inactive_field:get_data(REcreature);
	if is_inactive ~= nil then
		creature.is_inactive = is_inactive;
	end
end

function env_creature.draw(creature, position_on_screen, opacity_scale)
	if d2d ~= nil then
		local text_width, text_height = drawing.font:measure(creature.name);
		position_on_screen.x = position_on_screen.x - text_width / 2;
	end

	drawing.draw_label(creature.name_label, position_on_screen, opacity_scale, creature.name);
end

function env_creature.init_list()
	env_creature.list = {};
end

function env_creature.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	config = require("MHR_Overlay.Misc.config");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	--health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	--stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
	--screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
	--ailments = require("MHR_Overlay.Monsters.ailments");
	--ailment_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_UI_entity");
end

return env_creature;
