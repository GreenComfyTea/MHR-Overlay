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

local tg_camera_type_def = get_tg_camera_method:get_return_type();
local get_targeting_enemy_index_field = tg_camera_type_def:get_field("OldTargetingEmIndex");

function large_monster_UI.draw(dynamic_enabled, static_enabled, highlighted_enabled)
	local cached_config = config.current_config.large_monster_UI;

	if singletons.enemy_manager == nil then
		return;
	end

	local displayed_monsters = {};

	local update_distance =
		dynamic_enabled or cached_config.static.sorting.type == "Distance"
		or (cached_config.highlighted.auto_highlight.enabled
			and (cached_config.highlighted.auto_highlight.mode == "Closest" or cached_config.highlighted.auto_highlight.mode == "Furthest")
		);

	local highlighted_id = -1;
	local monster_id_shift = 0;
	local highlighted_monster = nil;

	if not cached_config.highlighted.auto_highlight.enabled and singletons.gui_manager ~= nil then
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
			goto continue
		end

		local monster = large_monster.list[enemy];
		if monster == nil then
			customization_menu.status = "No large monster entry";
			goto continue
		end

		if update_distance then
			monster.distance = (player.myself_position - monster.position):length();
		end

		if cached_config.highlighted.auto_highlight.enabled then
			if highlighted_monster == nil then
				highlighted_monster = monster;

			elseif cached_config.highlighted.auto_highlight.mode == "Farthest" then
				if monster.distance > highlighted_monster.distance then
					highlighted_monster = monster;
				end
	
			elseif cached_config.highlighted.auto_highlight.mode == "Lowest Health" then
				if monster.health < highlighted_monster.health then
					highlighted_monster = monster;
				end
	
			elseif cached_config.highlighted.auto_highlight.mode == "Highest Health" then
				if monster.health > highlighted_monster.health then
					highlighted_monster = monster;
				end
	
			elseif cached_config.highlighted.auto_highlight.mode == "Lowest Health Percentage" then
				if monster.health_percentage < highlighted_monster.health_percentage then
					highlighted_monster = monster;
				end
	
			elseif cached_config.highlighted.auto_highlight.mode == "Highest Health Percentage" then
				if monster.health_percentage > highlighted_monster.health_percentage then
					highlighted_monster = monster;
				end
	
			else
				if monster.distance < highlighted_monster.distance then
					highlighted_monster = monster;
				end
			end
		else
			if monster.dead_or_captured or not monster.is_disp_icon_mini_map then
				monster_id_shift = monster_id_shift + 1;

			elseif i == highlighted_id + monster_id_shift then
				highlighted_monster = monster;
			end
		end

		table.insert(displayed_monsters, monster);
		::continue::
	end

	if dynamic_enabled then
		large_monster_UI.draw_dynamic(displayed_monsters, highlighted_monster, cached_config);
	end

	if highlighted_enabled then
		large_monster_UI.draw_highlighted(highlighted_monster, cached_config);
	end

	if static_enabled then
		large_monster_UI.draw_static(displayed_monsters, highlighted_monster, cached_config);
	end
end

function large_monster_UI.draw_dynamic(displayed_monsters, highlighted_monster, cached_config)
	cached_config = cached_config.dynamic;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local i = 0;
	for _, monster in ipairs(displayed_monsters) do
		if cached_config.settings.max_distance == 0 then
			break
		end

		if monster.id == 549 or monster.id == 25 or monster.id == 2073 then
			goto continue
		end

		if monster.dead_or_captured and cached_config.settings.hide_dead_or_captured then
			goto continue
		end

		if monster == highlighted_monster then
			if not cached_config.settings.render_highlighted_monster then
				goto continue
			end
		else
			if not cached_config.settings.render_not_highlighted_monsters then
				goto continue
			end
		end

		local position_on_screen = {};

		local world_offset = Vector3f.new(cached_config.world_offset.x, cached_config.world_offset.y,
			cached_config.world_offset.z);

		position_on_screen = draw.world_to_screen(monster.position + world_offset);

		if position_on_screen == nil then
			goto continue
		end

		position_on_screen.x = position_on_screen.x + cached_config.viewport_offset.x * global_scale_modifier;
		position_on_screen.y = position_on_screen.y + cached_config.viewport_offset.y * global_scale_modifier;

		local opacity_scale = 1;
		if monster.distance > cached_config.settings.max_distance then
			goto continue
		end

		if cached_config.settings.opacity_falloff then
			opacity_scale = 1 - (monster.distance / cached_config.settings.max_distance);
		end

		large_monster.draw(monster, "dynamic", cached_config, position_on_screen, opacity_scale);

		i = i + 1;
		::continue::
	end
end

function large_monster_UI.draw_static(displayed_monsters, highlighted_monster, cached_config)
	cached_config = cached_config.static;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	-- sort here
	if cached_config.sorting.type == "Normal" and cached_config.sorting.reversed_order then
		local reversed_monsters = {};
		for i = #displayed_monsters, 1, -1 do
			table.insert(reversed_monsters, displayed_monsters[i]);
		end

		displayed_monsters = reversed_monsters;

	elseif cached_config.sorting.type == "Health" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_monsters, function(left, right)
				return left.health > right.health;
			end);
		else
			table.sort(displayed_monsters, function(left, right)
				return left.health < right.health;
			end);
		end
	elseif cached_config.sorting.type == "Health Percentage" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_monsters, function(left, right)
				return left.health_percentage > right.health_percentage;
			end);
		else
			table.sort(displayed_monsters, function(left, right)
				return left.health_percentage < right.health_percentage;
			end);
		end
	elseif cached_config.sorting.type == "Distance" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_monsters, function(left, right)
				return left.distance > right.distance;
			end);
		else
			table.sort(displayed_monsters, function(left, right)
				return left.distance < right.distance;
			end);
		end
	end

	local position_on_screen = screen.calculate_absolute_coordinates(cached_config.position);

	local i = 0;
	for _, monster in ipairs(displayed_monsters) do
		if monster.dead_or_captured and cached_config.settings.hide_dead_or_captured then
			goto continue
		end

		if monster == highlighted_monster then
			if not cached_config.settings.render_highlighted_monster then
				goto continue
			end
		else
			if not cached_config.settings.render_not_highlighted_monsters then
				goto continue
			end
		end

		local monster_position_on_screen = {
			x = position_on_screen.x,
			y = position_on_screen.y
		}

		if cached_config.settings.orientation == "Horizontal" then
			monster_position_on_screen.x = monster_position_on_screen.x + cached_config.spacing.x * i * global_scale_modifier;
		else
			monster_position_on_screen.y = monster_position_on_screen.y + cached_config.spacing.y * i * global_scale_modifier;
		end

		large_monster.draw(monster, "static", cached_config, monster_position_on_screen, 1);

		i = i + 1;
		::continue::
	end
end

function large_monster_UI.draw_highlighted(monster, cached_config)
	cached_config = cached_config.highlighted;

	if monster == nil then
		return;
	end

	local position_on_screen = screen.calculate_absolute_coordinates(cached_config.position);

	if monster.dead_or_captured and cached_config.settings.hide_dead_or_captured then
		return;
	end

	large_monster.draw(monster, "highlighted", cached_config, position_on_screen, 1);
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
