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
local env_creature;
local error_handler;

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

function this.draw()
	if singletons.enemy_manager == nil then
		return;
	end

	local cached_config = config.current_config.endemic_life_UI;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	for REcreature, creature in pairs(env_creature.list) do

		if cached_config.settings.max_distance == 0 then
			break;
		end

		if cached_config.settings.hide_inactive_creatures and creature.is_inactive then
			goto continue;
		end

		local position_on_screen = {};

		local world_offset = Vector3f.new(cached_config.world_offset.x, cached_config.world_offset.y,
			cached_config.world_offset.z);

		position_on_screen = draw.world_to_screen(creature.position + world_offset);

		if position_on_screen == nil then
			goto continue;
		end

		position_on_screen.x = position_on_screen.x + cached_config.viewport_offset.x * global_scale_modifier;
		position_on_screen.y = position_on_screen.y + cached_config.viewport_offset.y * global_scale_modifier;

		creature.distance = (players.myself_position - creature.position):length();

		local opacity_scale = 1;
		if creature.distance > cached_config.settings.max_distance then
			goto continue;
		end

		if cached_config.settings.opacity_falloff then
			opacity_scale = 1 - (creature.distance / cached_config.settings.max_distance);
		end

		env_creature.draw(creature, position_on_screen, opacity_scale);
		::continue::
	end
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
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
end

return this;
