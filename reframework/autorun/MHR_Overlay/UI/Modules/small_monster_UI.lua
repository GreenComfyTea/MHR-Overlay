local small_monster_UI = {};
local singletons;
local config;
local small_monster;
local customization_menu;
local screen;
local players;
local drawing;
local table_helpers;
local health_UI_entity;
local stamina_UI_entity;

local enemy_manager_type_def = sdk.find_type_definition("snow.enemy.EnemyManager");
local get_zako_enemy_count_method = enemy_manager_type_def:get_method("getZakoEnemyCount");
local get_zako_enemy_method = enemy_manager_type_def:get_method("getZakoEnemy");

function small_monster_UI.draw()
	if singletons.enemy_manager == nil then
		return;
	end

	local cached_config = config.current_config.small_monster_UI;

	local displayed_monsters = {};

	local enemy_count = get_zako_enemy_count_method:call(singletons.enemy_manager);
	if enemy_count == nil then
		customization_menu.status = "No enemy count";
		return;
	end

	for i = 0, enemy_count - 1 do
		local enemy = get_zako_enemy_method:call(singletons.enemy_manager, i);
		if enemy == nil then
			customization_menu.status = "No enemy";
			goto continue
		end

		local monster = small_monster.list[enemy];
		if monster == nil then
			customization_menu.status = "No small monster entry";
			goto continue
		end

		if monster.dead_or_captured and cached_config.settings.hide_dead_or_captured then
			goto continue
		end

		table.insert(displayed_monsters, monster);
		::continue::
	end

	if cached_config.dynamic_positioning.enabled
		or (not cached_config.dynamic_positioning.enabled and cached_config.static_sorting.type == "Distance") then
		for _, monster in ipairs(displayed_monsters) do
			monster.distance = (players.myself_position - monster.position):length();
		end
	end

	if not cached_config.dynamic_positioning.enabled then
		-- sort here
		if cached_config.static_sorting.type == "Normal" and cached_config.static_sorting.reversed_order then
			local reversed_monsters = {};
			for i = #displayed_monsters, 1, -1 do
				table.insert(reversed_monsters, displayed_monsters[i]);
			end
			displayed_monsters = reversed_monsters;

		elseif cached_config.static_sorting.type == "Health" then
			if cached_config.static_sorting.reversed_order then
				table.sort(displayed_monsters, function(left, right)
					return left.health > right.health;
				end);
			else
				table.sort(displayed_monsters, function(left, right)
					return left.health < right.health;
				end);
			end

		elseif cached_config.static_sorting.type == "Health Percentage" then
			if cached_config.static_sorting.reversed_order then
				table.sort(displayed_monsters, function(left, right)
					return left.health_percentage > right.health_percentage;
				end);
			else
				table.sort(displayed_monsters, function(left, right)
					return left.health_percentage < right.health_percentage;
				end);
			end
		elseif cached_config.static_sorting.type == "Distance" then
			if cached_config.static_sorting.reversed_order then
				table.sort(displayed_monsters, function(left, right)
					return left.distance > right.distance;
				end);
			else
				table.sort(displayed_monsters, function(left, right)
					return left.distance < right.distance;
				end);
			end
		end
	end

	local i = 0;
	for _, monster in ipairs(displayed_monsters) do
		local position_on_screen;

		if cached_config.dynamic_positioning.enabled then
			local world_offset = Vector3f.new(cached_config.dynamic_positioning.world_offset.x,
				cached_config.dynamic_positioning.world_offset.y,
				cached_config.dynamic_positioning.world_offset.z);

			position_on_screen = draw.world_to_screen(monster.position + world_offset);

			if position_on_screen == nil then
				goto continue
			end

			position_on_screen.x = position_on_screen.x + cached_config.dynamic_positioning.viewport_offset.x;
			position_on_screen.y = position_on_screen.y + cached_config.dynamic_positioning.viewport_offset.y;
		else
			position_on_screen = screen.calculate_absolute_coordinates(cached_config.static_position);
			if cached_config.settings.orientation == "Horizontal" then
				position_on_screen.x = position_on_screen.x + cached_config.static_spacing.x * i;

			else
				position_on_screen.y = position_on_screen.y + cached_config.static_spacing.y * i;
			end
		end




		local opacity_scale = 1;
		if cached_config.dynamic_positioning.enabled then
			if cached_config.dynamic_positioning.max_distance == 0 then
				return;
			end

			if monster.distance > cached_config.dynamic_positioning.max_distance then
				goto continue
			end

			if cached_config.dynamic_positioning.opacity_falloff then
				opacity_scale = 1 - (monster.distance / cached_config.dynamic_positioning.max_distance);
			end
		end



		small_monster.draw(monster, cached_config, position_on_screen, opacity_scale);

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
	players = require("MHR_Overlay.Damage_Meter.players");
	drawing = require("MHR_Overlay.UI.drawing");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
end

return small_monster_UI;
