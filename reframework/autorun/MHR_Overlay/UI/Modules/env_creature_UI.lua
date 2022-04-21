local env_creature_UI = {};
local singletons;
local config;
local customization_menu;
local large_monster;
local screen;
local player;
local drawing;
local table_helpers;
local health_UI_entity;
local stamina_UI_entity;
local rage_UI_entity;
local env_creature;

local enemy_manager_type_def = sdk.find_type_definition("snow.enemy.EnemyManager");
local get_boss_enemy_count_method = enemy_manager_type_def:get_method("getBossEnemyCount");
local get_boss_enemy_method = enemy_manager_type_def:get_method("getBossEnemy");

function env_creature_UI.draw()
	if singletons.enemy_manager == nil then
		return;
	end

	for _, creature in pairs(env_creature.list) do
				
		if config.current_config.endemic_life_UI.settings.max_distance == 0 then
			break;
		end
		
		if config.current_config.endemic_life_UI.settings.hide_inactive_creatures and creature.is_inactive then
			goto continue;
		end

		local position_on_screen = {};

		local world_offset = Vector3f.new(config.current_config.endemic_life_UI.world_offset.x, config.current_config.endemic_life_UI.world_offset.y, config.current_config.endemic_life_UI.world_offset.z);
	
		position_on_screen = draw.world_to_screen(creature.position + world_offset);
		
		if position_on_screen == nil then
			goto continue;
		end

		position_on_screen.x = position_on_screen.x + config.current_config.endemic_life_UI.viewport_offset.x * config.current_config.global_settings.modifiers.global_scale_modifier;
		position_on_screen.y = position_on_screen.y + config.current_config.endemic_life_UI.viewport_offset.y * config.current_config.global_settings.modifiers.global_scale_modifier;

		
		creature.distance = (player.myself_position - creature.position):length();

		local opacity_scale = 1;
		if creature.distance > config.current_config.endemic_life_UI.settings.max_distance then
			goto continue;
		end
		
		if config.current_config.endemic_life_UI.settings.opacity_falloff then
			opacity_scale = 1 - (creature.distance / config.current_config.endemic_life_UI.settings.max_distance);
		end


		env_creature.draw(creature, position_on_screen, opacity_scale);
		::continue::
	end
end


function env_creature_UI.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	config = require("MHR_Overlay.Misc.config");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	screen = require("MHR_Overlay.Game_Handler.screen");
	player = require("MHR_Overlay.Damage_Meter.player");
	drawing = require("MHR_Overlay.UI.drawing");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
	rage_UI_entity = require("MHR_Overlay.UI.UI_Entities.rage_UI_entity");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
end

return env_creature_UI;