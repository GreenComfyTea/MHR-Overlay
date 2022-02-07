local small_monster_UI = {};
local singletons;
local config;
local small_monster;
local customization_menu;
local screen;
local player;
local drawing;
local table_helpers;
local health_UI_entity;
local stamina_UI_entity;

function small_monster_UI.draw()
	if singletons.enemy_manager == nil then
		return;
	end

	local displayed_monsters = {};

	local enemy_count = singletons.enemy_manager:call("getZakoEnemyCount");
	if enemy_count == nil then
		customization_menu.status = "No enemy count";
		return;
	end

	for i = 0, enemy_count - 1 do
		local enemy = singletons.enemy_manager:call("getZakoEnemy", i);
		if enemy == nil then
			customization_menu.status = "No enemy";
			break
		end

		local monster = small_monster.list[enemy];
		if monster == nil then
			customization_menu.status = "No monster hp entry";
			break
		end

		table.insert(displayed_monsters, monster);
	end

	if not config.current_config.small_monster_UI.dynamic_positioning.enabled then
		-- sort here
		
		if config.current_config.small_monster_UI.static_sorting.type == "Normal" and config.current_config.small_monster_UI.static_sorting.reversed_order then
			local reversed_monsters = {};
			for i = #displayed_monsters, 1, -1 do
				table.insert(reversed_monsters, displayed_monsters[i]);
			end
			displayed_monsters = reversed_monsters;

		elseif config.current_config.small_monster_UI.static_sorting.type == "Health" then
			if config.current_config.small_monster_UI.static_sorting.reversed_order then
				table.sort(displayed_monsters, function(left, right)
					return left.health > right.health;
				end);
			else
				table.sort(displayed_monsters, function(left, right)
					return left.health < right.health;
				end);
			end

		elseif config.current_config.small_monster_UI.static_sorting.type == "Health Percentage" then
			if config.current_config.small_monster_UI.static_sorting.reversed_order then
				table.sort(displayed_monsters, function(left, right)
					return left.health_percentage > right.health_percentage;
				end);
			else
				table.sort(displayed_monsters, function(left, right)
					return left.health_percentage < right.health_percentage;
				end);
			end
		end
	end
	
	local i = 0;
	for _, monster in ipairs(displayed_monsters) do
		local position_on_screen;

		if config.current_config.small_monster_UI.dynamic_positioning.enabled then
			local world_offset = Vector3f.new(config.current_config.small_monster_UI.dynamic_positioning.world_offset.x, config.current_config.small_monster_UI.dynamic_positioning.world_offset.y, config.current_config.small_monster_UI.dynamic_positioning.world_offset.z);

			position_on_screen = draw.world_to_screen(monster.position + world_offset);

			if position_on_screen == nil then
				goto continue
			end

			position_on_screen.x = position_on_screen.x + config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.x;
			position_on_screen.y = position_on_screen.y + config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.y;
		else
			position_on_screen = screen.calculate_absolute_coordinates(config.current_config.small_monster_UI.static_position);
			if config.current_config.small_monster_UI.settings.orientation == "Horizontal" then
				position_on_screen.x = position_on_screen.x + config.current_config.small_monster_UI.static_spacing.x * i;

			else
				position_on_screen.y = position_on_screen.y + config.current_config.small_monster_UI.static_spacing.y * i;
			end
		end

	
		local opacity_scale = 1;
		if config.current_config.small_monster_UI.dynamic_positioning.enabled then
			if config.current_config.small_monster_UI.dynamic_positioning.max_distance == 0 then
				return;
			end

			local distance = (player.myself_position - monster.position):length();

			if distance > config.current_config.small_monster_UI.dynamic_positioning.max_distance then
				goto continue;
			end
					
			if config.current_config.small_monster_UI.dynamic_positioning.opacity_falloff then
				opacity_scale = 1 - (distance / config.current_config.small_monster_UI.dynamic_positioning.max_distance);
			end
		end

		small_monster.draw(monster, position_on_screen, opacity_scale);
		
		i = i + 1;
		::continue::
	end
end

function small_monster_UI.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	config = require("MHR_Overlay.Misc.config");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	screen = require("MHR_Overlay.Game_Handler.screen");
	player = require("MHR_Overlay.Damage_Meter.player");
	drawing = require("MHR_Overlay.UI.drawing");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
end

return small_monster_UI;