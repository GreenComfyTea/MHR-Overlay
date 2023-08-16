local this = {};

local singletons;
local config;
local small_monster;
local customization_menu;
local screen;
local players;
local drawing;
local health_UI_entity;
local stamina_UI_entity;
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
local get_zako_enemy_count_method = enemy_manager_type_def:get_method("getZakoEnemyCount");
local get_zako_enemy_method = enemy_manager_type_def:get_method("getZakoEnemy");

local displayed_monsters = {};

function this.update()
	local cached_config = config.current_config.small_monster_UI;

	if cached_config.dynamic_positioning.enabled and utils.number.is_equal(cached_config.dynamic_positioning.max_distance, 0) then
		displayed_monsters = {};
		return;
	end

	local _displayed_monsters = {};

	for enemy, monster in pairs(small_monster.list) do
		
		if monster.dead_or_captured and cached_config.settings.hide_dead_or_captured then
			goto continue;
		end;

		monster.distance = (players.myself_position - monster.position):length();
		if monster.distance > cached_config.dynamic_positioning.max_distance then
			goto continue;
		end
		table.insert(_displayed_monsters, monster);
		::continue::
	end
	
	displayed_monsters = this.sort_monsters(_displayed_monsters, cached_config);
end

function this.sort_monsters(_displayed_monsters, cached_config)
	if not cached_config.dynamic_positioning.enabled then
		if cached_config.static_sorting.type == "Normal" and cached_config.static_sorting.reversed_order then
			local reversed_monsters = {};
			for i = #_displayed_monsters, 1, -1 do
				table.insert(reversed_monsters, _displayed_monsters[i]);
			end
			_displayed_monsters = reversed_monsters;

		elseif cached_config.static_sorting.type == "Health" then
			if cached_config.static_sorting.reversed_order then
				table.sort(_displayed_monsters, function(left, right)
					return left.health > right.health;
				end);
			else
				table.sort(_displayed_monsters, function(left, right)
					return left.health < right.health;
				end);
			end

		elseif cached_config.static_sorting.type == "Health Percentage" then
			if cached_config.static_sorting.reversed_order then
				table.sort(_displayed_monsters, function(left, right)
					return left.health_percentage > right.health_percentage;
				end);
			else
				table.sort(_displayed_monsters, function(left, right)
					return left.health_percentage < right.health_percentage;
				end);
			end
		elseif cached_config.static_sorting.type == "Distance" then
			if cached_config.static_sorting.reversed_order then
				table.sort(_displayed_monsters, function(left, right)
					return left.distance > right.distance;
				end);
			else
				table.sort(_displayed_monsters, function(left, right)
					return left.distance < right.distance;
				end);
			end
		end
	end

	return _displayed_monsters;
end

function this.draw()
	local cached_config = config.current_config.small_monster_UI;

	local is_dynamic_positioning_enabled = cached_config.dynamic_positioning.enabled;

	local i = 0;
	for _, monster in ipairs(displayed_monsters) do
		local position_on_screen;

		if is_dynamic_positioning_enabled then
			local world_offset = Vector3f.new(
				cached_config.dynamic_positioning.world_offset.x,
				cached_config.dynamic_positioning.world_offset.y,
				cached_config.dynamic_positioning.world_offset.z
			);

			position_on_screen = draw.world_to_screen(monster.position + world_offset);

			if position_on_screen == nil then
				goto continue;
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
		if is_dynamic_positioning_enabled and cached_config.dynamic_positioning.opacity_falloff then
			monster.distance = (players.myself_position - monster.position):length();
			opacity_scale = 1 - (monster.distance / cached_config.dynamic_positioning.max_distance);
		end

		small_monster.draw(monster, cached_config, position_on_screen, opacity_scale);

		i = i + 1;
		::continue::
	end
end

function this.init_dependencies()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	config = require("MHR_Overlay.Misc.config");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	screen = require("MHR_Overlay.Game_Handler.screen");
	players = require("MHR_Overlay.Damage_Meter.players");
	drawing = require("MHR_Overlay.UI.drawing");
	health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	utils = require("MHR_Overlay.Misc.utils");
end

function this.init_module()
end

return this;
