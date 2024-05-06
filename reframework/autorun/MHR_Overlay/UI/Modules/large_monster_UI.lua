local this = {};

local singletons;
local config;
local customization_menu;
local large_monster;
local screen;
local players;
local drawing;
local health_UI_entity;
local stamina_UI_entity;
local rage_UI_entity;
local error_handler;
local utils;

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

local enemy_manager_type_def = sdk.find_type_definition("snow.enemy.EnemyManager");
local get_boss_enemy_count_method = enemy_manager_type_def:get_method("getBossEnemyCount");
local get_boss_enemy_method = enemy_manager_type_def:get_method("getBossEnemy");

local gui_manager_type_def = sdk.find_type_definition("snow.gui.GuiManager");
local get_tg_camera_method = gui_manager_type_def:get_method("get_refGuiHud_TgCamera");

local tg_camera_type_def = get_tg_camera_method:get_return_type();
local get_targeting_enemy_index_field = tg_camera_type_def:get_field("OldTargetingEmIndex");

local large_monster_list = {};

local displayed_dynamic_monsters = {};
local displayed_static_monsters = {};
local highlighted_monster = nil;

function this.update(dynamic_enabled, static_enabled, highlighted_enabled)
	local cached_config = config.current_config.large_monster_UI;

	if singletons.enemy_manager == nil then
		error_handler.report("large_monster_UI.update", "Failed to Access Data: enemy_manager");
		return;
	end

	large_monster_list = {};

	local enemy_count = get_boss_enemy_count_method:call(singletons.enemy_manager);
	if enemy_count == nil then
		error_handler.report("large_monster_UI.update", "Failed to Access Data: enemy_count");
		return;
	end
	

	for i = 0, enemy_count - 1 do
		local enemy = get_boss_enemy_method:call(singletons.enemy_manager, i);
		if enemy == nil then
			error_handler.report("large_monster_UI.update", "Failed to Access Data: enemy No. " .. tostring(i));
			goto continue;
		end

		local monster = large_monster.get_monster(enemy);
		if monster == nil then
			error_handler.report("large_monster_UI.update", "Failed to create Large Monster Entry No. " .. tostring(i));
			goto continue;
		end

		monster.distance = (players.myself_position - monster.position):length();

		table.insert(large_monster_list, monster);

		::continue::
	end

	if dynamic_enabled then
		this.update_dynamic_monsters(large_monster_list, cached_config);
	end

	if static_enabled then
		this.update_static_monsters(large_monster_list, cached_config);
	end
end

function this.update_dynamic_monsters(large_monster_list, cached_config)
	if not cached_config.dynamic.enabled then
		displayed_dynamic_monsters = {};
		return;
	end

	local dynamic_cached_config = cached_config.dynamic.settings;

	local _displayed_dynamic_monsters = {};

	if utils.number.is_equal(dynamic_cached_config.max_distance, 0) then
		displayed_dynamic_monsters = {};
		return;
	end

	for i, monster in ipairs(large_monster_list) do
		if monster.distance > dynamic_cached_config.max_distance then
			goto continue;
		end

		if monster.is_stealth then
			goto continue;
		end

		if monster.dead_or_captured and dynamic_cached_config.hide_dead_or_captured then
			goto continue;
		end

		if monster == highlighted_monster then
			if not dynamic_cached_config.render_highlighted_monster then
				goto continue;
			end
		else
			if not dynamic_cached_config.render_not_highlighted_monsters then
				goto continue;
			end
		end

		table.insert(_displayed_dynamic_monsters, monster);

		::continue::
	end

	displayed_dynamic_monsters = _displayed_dynamic_monsters;
end

function this.update_static_monsters(large_monster_list, cached_config)
	if not cached_config.static.enabled then
		displayed_static_monsters = {};
		return;
	end

	local static_cached_config = cached_config.static.settings;

	local _displayed_static_monsters = {};

	for i, monster in ipairs(large_monster_list) do
		if monster.is_stealth then
			goto continue;
		end

		if monster.dead_or_captured and static_cached_config.hide_dead_or_captured then
			goto continue;
		end

		if monster == highlighted_monster then
			if not static_cached_config.render_highlighted_monster then
				goto continue;
			end
		else
			if not static_cached_config.render_not_highlighted_monsters then
				goto continue;
			end
		end

		table.insert(_displayed_static_monsters, monster);
		::continue::
	end
	

	displayed_static_monsters = this.sort_static_monsters(_displayed_static_monsters, cached_config);
end

function this.sort_static_monsters(_displayed_static_monsters, cached_config)
	cached_config = cached_config.static.sorting;

	-- sort here
	if cached_config.type == "Normal" and cached_config.reversed_order then
		local reversed_monsters = {};
		for i = #_displayed_static_monsters, 1, -1 do
			table.insert(reversed_monsters, _displayed_static_monsters[i]);
		end

		_displayed_static_monsters = reversed_monsters;

	elseif cached_config.type == "Health" then
		if cached_config.reversed_order then
			table.sort(_displayed_static_monsters, function(left, right)
				return left.health > right.health;
			end);
		else
			table.sort(_displayed_static_monsters, function(left, right)
				return left.health < right.health;
			end);
		end
	elseif cached_config.type == "Health Percentage" then
		if cached_config.reversed_order then
			table.sort(_displayed_static_monsters, function(left, right)
				return left.health_percentage > right.health_percentage;
			end);
		else
			table.sort(_displayed_static_monsters, function(left, right)
				return left.health_percentage < right.health_percentage;
			end);
		end
	elseif cached_config.type == "Distance" then
		if cached_config.reversed_order then
			table.sort(_displayed_static_monsters, function(left, right)
				return left.distance > right.distance;
			end);
		else
			table.sort(_displayed_static_monsters, function(left, right)
				return left.distance < right.distance;
			end);
		end
	end

	return _displayed_static_monsters;
end

function this.update_highlighted_monster(large_monster_list, autohighlight_config)
	local monster_id_shift = 0;
	local _highlighted_monster = nil;

	large_monster.update_highlighted_id();

	if large_monster.highlighted_id == -1 then
		highlighted_monster = nil;
		return;
	end

	for i, monster in ipairs(large_monster_list) do
		if monster.dead_or_captured or not monster.is_disp_icon_mini_map then
			monster_id_shift = monster_id_shift + 1;
			goto continue;
		end
	
		if not autohighlight_config.enabled then
			if i - 1 == large_monster.highlighted_id + monster_id_shift then
				_highlighted_monster = monster;
				goto continue;
			end

			goto continue;
		end
	
		if _highlighted_monster == nil then
			_highlighted_monster = monster;
			goto continue;
		end
	
		if autohighlight_config.mode == "Farthest" and monster.distance > _highlighted_monster.distance then
			_highlighted_monster = monster;
			goto continue;
		end
	
		if autohighlight_config.mode == "Lowest Health" and monster.health < _highlighted_monster.health then
			_highlighted_monster = monster;
			goto continue;
		end
	
		if autohighlight_config.mode == "Highest Health" and monster.health > _highlighted_monster.health then
			_highlighted_monster = monster;
			goto continue;
		end
	
		if autohighlight_config.mode == "Lowest Health Percentage" and monster.health_percentage < _highlighted_monster.health_percentage then
			_highlighted_monster = monster;
			goto continue;
		end
	
		if autohighlight_config.mode == "Highest Health Percentage" and monster.health_percentage > _highlighted_monster.health_percentage then
			_highlighted_monster = monster;
			goto continue;
		end
	
		if monster.distance < _highlighted_monster.distance then
			_highlighted_monster = monster;
		end

		::continue::
	end

	highlighted_monster = _highlighted_monster;
end

function this.draw(dynamic_enabled, static_enabled, highlighted_enabled)
	local cached_config = config.current_config.large_monster_UI;

	this.update_highlighted_monster(large_monster_list, cached_config.highlighted.auto_highlight);

	if dynamic_enabled then
		local success = pcall(this.draw_dynamic, cached_config);
		if not success then
			error_handler.report("large_monster_UI.draw", "Dynamic Large Monster drawing function threw an exception");
		end
	end

	if highlighted_enabled then
		local success = pcall(this.draw_highlighted, cached_config);
		if not success then
			error_handler.report("large_monster_UI.draw", "Highlighted Large Monster drawing function threw an exception");
		end
	end

	if static_enabled then
		local success = pcall(this.draw_static, cached_config);
		if not success then
			error_handler.report("large_monster_UI.draw", "Static Large Monster drawing function threw an exception");
		end
	end
end

function this.draw_dynamic(cached_config)
	cached_config = cached_config.dynamic;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local i = 0;
	for _, monster in ipairs(displayed_dynamic_monsters) do
		local world_offset = Vector3f.new(cached_config.world_offset.x, cached_config.world_offset.y, cached_config.world_offset.z);

		local position_on_screen;
		if cached_config.settings.head_tracking then
			position_on_screen = draw.world_to_screen(monster.head_position + world_offset);
		else
			position_on_screen = draw.world_to_screen(monster.position + world_offset);
		end

		if position_on_screen == nil then
			goto continue;
		end

		position_on_screen.x = position_on_screen.x + cached_config.viewport_offset.x * global_scale_modifier;
		position_on_screen.y = position_on_screen.y + cached_config.viewport_offset.y * global_scale_modifier;

		local opacity_scale = 1;
		
		if cached_config.settings.opacity_falloff then
			monster.distance = (players.myself_position - monster.position):length();
			opacity_scale = 1 - (monster.distance / cached_config.settings.max_distance);
		end

		large_monster.draw(monster, "dynamic_UI", cached_config, position_on_screen, opacity_scale);

		i = i + 1;
		::continue::
	end
end

function this.draw_static(cached_config)
	cached_config = cached_config.static;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local position_on_screen = screen.calculate_absolute_coordinates(cached_config.position);

	local i = 0;
	for _, monster in ipairs(displayed_static_monsters) do
		local monster_position_on_screen = {
			x = position_on_screen.x,
			y = position_on_screen.y
		}

		if cached_config.settings.orientation == "Horizontal" then
			monster_position_on_screen.x = monster_position_on_screen.x + cached_config.spacing.x * i * global_scale_modifier;
		else
			monster_position_on_screen.y = monster_position_on_screen.y + cached_config.spacing.y * i * global_scale_modifier;
		end

		large_monster.draw(monster, "static_UI", cached_config, monster_position_on_screen, 1);

		i = i + 1;
		::continue::
	end
end

function this.draw_highlighted(cached_config)
	if highlighted_monster == nil then
		return;
	end

	cached_config = cached_config.highlighted;

	local position_on_screen = screen.calculate_absolute_coordinates(cached_config.position);

	large_monster.draw(highlighted_monster, "highlighted_UI", cached_config, position_on_screen, 1);
end

function this.init_dependencies()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	config = require("MHR_Overlay.Misc.config");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	screen = require("MHR_Overlay.Game_Handler.screen");
	players = require("MHR_Overlay.Damage_Meter.players");
	drawing = require("MHR_Overlay.UI.drawing");
	health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
	rage_UI_entity = require("MHR_Overlay.UI.UI_Entities.rage_UI_entity");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	utils = require("MHR_Overlay.Misc.utils");
end

function this.init_module()
end

return this;
