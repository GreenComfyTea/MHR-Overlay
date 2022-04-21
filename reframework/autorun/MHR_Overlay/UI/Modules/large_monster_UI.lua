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

local enemy_manager_type_def = sdk.find_type_definition("snow.enemy.EnemyManager");
local get_boss_enemy_count_method = enemy_manager_type_def:get_method("getBossEnemyCount");
local get_boss_enemy_method = enemy_manager_type_def:get_method("getBossEnemy");

local gui_manager_type_def = sdk.find_type_definition("snow.gui.GuiManager");
local get_tg_camera_method = gui_manager_type_def:get_method("get_refGuiHud_TgCamera");

local tg_camera_type = get_tg_camera_method:get_return_type();
local get_targeting_enemy_index_field = tg_camera_type:get_field("OldTargetingEmIndex");

function large_monster_UI.draw(dynamic_enabled, static_enabled, highlighted_enabled)
	if singletons.enemy_manager == nil then
		return;
	end
	
	local displayed_monsters = {};

	local highlighted_id = -1;
	local monster_id_shift = 0;
	local highlighted_monster = nil;

	if singletons.gui_manager ~= nil then
		local gui_hud_target_camera = get_tg_camera_method:call(singletons.gui_manager);
		if gui_hud_target_camera ~= nil then
			highlighted_id = get_targeting_enemy_index_field:get_data(gui_hud_target_camera);

			if highlighted_id == nil then
				highlighted_id = -1;
			end
		end
	end

	
	local enemy_count = get_boss_enemy_count_method:call(singletons.enemy_manager);
	if enemy_count == nil then
		return;
	end

	for i = 0, enemy_count - 1 do
		local enemy = get_boss_enemy_method:call(singletons.enemy_manager, i);
		if enemy == nil then
			customization_menu.status = "No enemy";
			goto continue;
		end

		local monster = large_monster.list[enemy];
		if monster == nil then
			customization_menu.status = "No monster hp entry";
			goto continue;
		end

		if monster.dead_or_captured then
			monster_id_shift = monster_id_shift + 1;
		elseif i == highlighted_id + monster_id_shift then
			highlighted_monster = monster;
		end

		table.insert(displayed_monsters, monster);
		::continue::
	end

	if dynamic_enabled or config.current_config.large_monster_UI.static.sorting.type == "Distance" then
		for _, monster in ipairs(displayed_monsters) do
			monster.distance = (player.myself_position - monster.position):length();
		end
	end

	if dynamic_enabled then
		large_monster_UI.draw_dynamic(displayed_monsters, highlighted_monster);
	end

	if highlighted_enabled then
		large_monster_UI.draw_highlighted(highlighted_monster);
	end

	if static_enabled then
		large_monster_UI.draw_static(displayed_monsters, highlighted_monster);
	end

end

function large_monster_UI.draw_dynamic(displayed_monsters, highlighted_monster)
	local i = 0;
		for _, monster in ipairs(displayed_monsters) do
			if config.current_config.large_monster_UI.dynamic.settings.max_distance == 0 then
				break;
			end

			if monster.dead_or_captured and config.current_config.large_monster_UI.dynamic.settings.hide_dead_or_captured then
				goto continue;
			end

			if monster == highlighted_monster then
				if not config.current_config.large_monster_UI.dynamic.settings.render_highlighted_monster then
					goto continue;
				end
			else
				if not config.current_config.large_monster_UI.dynamic.settings.render_not_highlighted_monsters then
					goto continue;
				end
			end

			local position_on_screen = {};
	
			local world_offset = Vector3f.new(config.current_config.large_monster_UI.dynamic.world_offset.x, config.current_config.large_monster_UI.dynamic.world_offset.y, config.current_config.large_monster_UI.dynamic.world_offset.z);
			
			position_on_screen = draw.world_to_screen(monster.position + world_offset);
			
			if position_on_screen == nil then
				goto continue;
			end
			
			position_on_screen.x = position_on_screen.x + config.current_config.large_monster_UI.dynamic.viewport_offset.x * config.current_config.global_settings.modifiers.global_scale_modifier;
			position_on_screen.y = position_on_screen.y + config.current_config.large_monster_UI.dynamic.viewport_offset.y * config.current_config.global_settings.modifiers.global_scale_modifier;
	
			local opacity_scale = 1;
			if monster.distance > config.current_config.large_monster_UI.dynamic.settings.max_distance then
				goto continue;
			end
			
			if config.current_config.large_monster_UI.dynamic.settings.opacity_falloff then
				opacity_scale = 1 - (monster.distance / config.current_config.large_monster_UI.dynamic.settings.max_distance);
			end
			
			large_monster.draw_dynamic(monster, position_on_screen, opacity_scale);
	
			i = i + 1;
			::continue::
		end
end

function large_monster_UI.draw_static(displayed_monsters, highlighted_monster)
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
	elseif config.current_config.large_monster_UI.static.sorting.type == "Distance" then
		if config.current_config.large_monster_UI.static.sorting.reversed_order then
			table.sort(displayed_monsters, function(left, right)
				return left.distance > right.distance;
			end);
		else
			table.sort(displayed_monsters, function(left, right)
				return left.distance < right.distance;
			end);
		end
	end

	local position_on_screen = screen.calculate_absolute_coordinates(config.current_config.large_monster_UI.static.position);

	local i = 0;
	for _, monster in ipairs(displayed_monsters) do
		if monster.dead_or_captured and config.current_config.large_monster_UI.static.settings.hide_dead_or_captured then
			goto continue;
		end

		if monster == highlighted_monster then
			if not config.current_config.large_monster_UI.static.settings.render_highlighted_monster then
				goto continue;
			end
		else
			if not config.current_config.large_monster_UI.static.settings.render_not_highlighted_monsters then
				goto continue;
			end
		end

		local monster_position_on_screen = {
			x = position_on_screen.x,
			y = position_on_screen.y
		}
		
		if config.current_config.large_monster_UI.static.settings.orientation == "Horizontal" then
			monster_position_on_screen.x = monster_position_on_screen.x + config.current_config.large_monster_UI.static.spacing.x * i * config.current_config.global_settings.modifiers.global_scale_modifier;
		else
			monster_position_on_screen.y = monster_position_on_screen.y + config.current_config.large_monster_UI.static.spacing.y * i  * config.current_config.global_settings.modifiers.global_scale_modifier;
		end

		large_monster.draw_static(monster, monster_position_on_screen, 1);

		i = i + 1;
		::continue::
	end
end

function large_monster_UI.draw_highlighted(monster)
	if monster == nil then
		return;
	end
	
	local position_on_screen = screen.calculate_absolute_coordinates(config.current_config.large_monster_UI.highlighted.position);

	if monster.dead_or_captured and config.current_config.large_monster_UI.highlighted.settings.hide_dead_or_captured then
		return;
	end
	
	large_monster.draw_highlighted(monster, position_on_screen, 1);
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