local large_monster_UI = {};
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

function large_monster_UI.draw()
	if singletons.enemy_manager == nil then
		return;
	end
	
	local displayed_monsters = {};

	local enemy_count = singletons.enemy_manager:call("getBossEnemyCount");
	if enemy_count == nil then
		return;
	end
	
	for i = 0, enemy_count - 1 do
		local enemy = singletons.enemy_manager:call("getBossEnemy", i);
		if enemy == nil then
			customization_menu.status = "No enemy";
			break
		end

		local monster = large_monster.list[enemy];
		if monster == nil then
			customization_menu.status = "No monster hp entry";
			break
		end

		table.insert(displayed_monsters, monster);
	end

	if config.current_config.large_monster_UI.dynamic.enabled then
		local i = 0;
		for _, monster in ipairs(displayed_monsters) do
			
			if config.current_config.large_monster_UI.dynamic.settings.max_distance == 0 then
				break;
			end

			local position_on_screen = {};
	
			local world_offset = Vector3f.new(config.current_config.large_monster_UI.dynamic.world_offset.x, config.current_config.large_monster_UI.dynamic.world_offset.y, config.current_config.large_monster_UI.dynamic.world_offset.z);
			
			position_on_screen = draw.world_to_screen(monster.position + world_offset);
			
			if position_on_screen == nil then
				goto continue;
			end
			
			position_on_screen.x = position_on_screen.x + config.current_config.large_monster_UI.dynamic.viewport_offset.x;
			position_on_screen.y = position_on_screen.y + config.current_config.large_monster_UI.dynamic.viewport_offset.y;
	
			local opacity_scale = 1;
			local distance = (player.myself_position - monster.position):length();
			if distance > config.current_config.large_monster_UI.dynamic.settings.max_distance then
				goto continue;
			end
			
			if config.current_config.large_monster_UI.dynamic.settings.opacity_falloff then
				opacity_scale = 1 - (distance / config.current_config.large_monster_UI.dynamic.settings.max_distance);
			end
			
			large_monster.draw_dynamic(monster, position_on_screen, opacity_scale);
	
			i = i + 1;
			::continue::
		end
	end

	if config.current_config.large_monster_UI.static.enabled then
		-- sort here
		if config.current_config.large_monster_UI.static.sorting.type == "Normal" and config.current_config.large_monster_UI.static.sorting.reversed_order then
			local reversed_monsters = {};
			for i = #displayed_monsters, 1, -1 do
				table.insert(reversed_monsters, displayed_monsters[i]);
			end
			
			displayed_monsters = reversed_monsters;

		elseif config.current_config.large_monster_UI.static.sorting.type == "Health" then
			if config.current_config.large_monster_UI.static.sorting.reversed_order then
				table.sort(displayed_monsters, function(left, right)
					return left.health > right.health;
				end);
			else
				table.sort(displayed_monsters, function(left, right)
					return left.health < right.health;
				end);
			end
		elseif config.current_config.large_monster_UI.static.sorting.type == "Health Percentage" then
			if config.current_config.large_monster_UI.static.sorting.reversed_order then
				table.sort(displayed_monsters, function(left, right)
					return left.health_percentage > right.health_percentage;
				end);
			else
				table.sort(displayed_monsters, function(left, right)
					return left.health_percentage < right.health_percentage;
				end);
			end
		end

		local position_on_screen = screen.calculate_absolute_coordinates(config.current_config.large_monster_UI.static.position);

		local i = 0;
		for _, monster in ipairs(displayed_monsters) do
			local monster_position_on_screen = {
				x = position_on_screen.x,
				y = position_on_screen.y
			}
			
			if config.current_config.large_monster_UI.static.settings.orientation == "Horizontal" then
				monster_position_on_screen.x = monster_position_on_screen.x + config.current_config.large_monster_UI.static.spacing.x * i;
			else
				monster_position_on_screen.y = monster_position_on_screen.y + config.current_config.large_monster_UI.static.spacing.y * i;
			end

			large_monster.draw_static(monster, monster_position_on_screen, 1);

			i = i + 1;
		end
	end
end

function large_monster_UI.init_module()
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
end

return large_monster_UI;