local small_monster_UI = {};
local singletons;
local config;
local small_monster;
local customization_menu;
local screen;
local player;
local drawing;
local table_helpers;

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
		if config.current_config.small_monster_UI.sorting.type == "Normal" and config.current_config.small_monster_UI.sorting.reversed_order then
			local reversed_monsters = {};
			for i = #displayed_monsters, 1, -1 do
				table.insert(reversed_monsters, displayed_monsters[i]);
			end
			displayed_monsters = reversed_monsters;

		elseif config.current_config.small_monster_UI.sorting.type == "Health" then
			if config.current_config.small_monster_UI.sorting.reversed_order then
				table.sort(displayed_monsters, function(left, right)
					return left.health > right.health;
				end);
			else
				table.sort(displayed_monsters, function(left, right)
					return left.health < right.health;
				end);
			end

		elseif config.current_config.small_monster_UI.sorting.type == "Health Percentage" then
			if config.current_config.small_monster_UI.sorting.reversed_order then
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

	x = "";
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
			position_on_screen = screen.calculate_absolute_coordinates(config.current_config.small_monster_UI.position);
			if config.current_config.small_monster_UI.settings.orientation == "Horizontal" then
				position_on_screen.x = position_on_screen.x + config.current_config.small_monster_UI.spacing.x * i;

			else
				position_on_screen.y = position_on_screen.y + config.current_config.small_monster_UI.spacing.y * i;
			end
		end

		local monster_name_label = config.current_config.small_monster_UI.monster_name_label;

		local health_bar = config.current_config.small_monster_UI.health.bar;
		local health_label = config.current_config.small_monster_UI.health.text_label;
		local health_value_label = config.current_config.small_monster_UI.health.value_label;
		local health_percentage_label = config.current_config.small_monster_UI.health.percentage_label;

		local stamina_bar = config.current_config.small_monster_UI.stamina.bar;
		local stamina_label = config.current_config.small_monster_UI.stamina.text_label;
		local stamina_value_label = config.current_config.small_monster_UI.stamina.value_label;
		local stamina_percentage_label = config.current_config.small_monster_UI.stamina.percentage_label;

		if config.current_config.small_monster_UI.dynamic_positioning.enabled then
			if config.current_config.small_monster_UI.dynamic_positioning.max_distance == 0 then
				return;
			end

			local distance = (player.myself_position - monster.position):length();

			if distance > config.current_config.small_monster_UI.dynamic_positioning.max_distance then
				goto continue;
			end
			
			if config.current_config.small_monster_UI.dynamic_positioning.opacity_falloff then
				local opacity_falloff = 1 - (distance / config.current_config.small_monster_UI.dynamic_positioning.max_distance);

				monster_name_label = table_helpers.deep_copy(config.current_config.small_monster_UI.monster_name_label);

				health_bar = table_helpers.deep_copy(config.current_config.small_monster_UI.health.bar);
				health_label = table_helpers.deep_copy(config.current_config.small_monster_UI.health.text_label);
				health_value_label = table_helpers.deep_copy(config.current_config.small_monster_UI.health.value_label);
				health_percentage_label = table_helpers.deep_copy(config.current_config.small_monster_UI.health.percentage_label);

				stamina_bar = table_helpers.deep_copy(config.current_config.small_monster_UI.stamina.bar);
				stamina_label = table_helpers.deep_copy(config.current_config.small_monster_UI.stamina.text_label);
				stamina_value_label = table_helpers.deep_copy(config.current_config.small_monster_UI.stamina.value_label);
				stamina_percentage_label = table_helpers.deep_copy(config.current_config.small_monster_UI.stamina.percentage_label);

				drawing.scale_bar_opacity(health_bar, opacity_falloff);
				drawing.scale_bar_opacity(stamina_bar, opacity_falloff)

				drawing.scale_label_opacity(monster_name_label, opacity_falloff);

				drawing.scale_label_opacity(health_label, opacity_falloff);
				drawing.scale_label_opacity(health_value_label, opacity_falloff);
				drawing.scale_label_opacity(health_percentage_label, opacity_falloff);

				drawing.scale_label_opacity(stamina_label, opacity_falloff);
				drawing.scale_label_opacity(stamina_value_label, opacity_falloff);
				drawing.scale_label_opacity(stamina_percentage_label, opacity_falloff);
			end
		end
	
		drawing.draw_bar(health_bar, position_on_screen, monster.health_percentage);
		drawing.draw_bar(stamina_bar, position_on_screen, monster.stamina_percentage);

		drawing.draw_label(monster_name_label, position_on_screen, monster.name);

		drawing.draw_label(health_label, position_on_screen);
		drawing.draw_label(health_value_label, position_on_screen, monster.health, monster.max_health);
		drawing.draw_label(health_percentage_label, position_on_screen, 100 * monster.health_percentage);

		drawing.draw_label(stamina_label, position_on_screen);
		drawing.draw_label(stamina_value_label, position_on_screen, monster.stamina, monster.max_stamina);
		drawing.draw_label(stamina_percentage_label, position_on_screen, 100 * monster.stamina_percentage);

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
end

return small_monster_UI;