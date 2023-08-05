local this = {};

local buff_UI_entity;
local config;
local buffs;
local consumables;
local melody_effects;
local screen;
local utils;
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
	local cached_config = config.current_config.buff_UI;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local displayed_buffs = {};

	for key, consumable in pairs(consumables.list) do
		
		if not consumable.is_active then
			goto continue;
		end

		table.insert(displayed_buffs, consumable);

		::continue::
	end

	for _, melody_effect in pairs(melody_effects.list) do
		
		if not melody_effect.is_active then
			goto continue2;
		end

		table.insert(displayed_buffs, melody_effect);

		::continue2::
	end

	-- sort
	if cached_config.sorting.type == "Name" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_buffs, function(left, right)
				return left.name > right.name;
			end);
		else
			table.sort(displayed_buffs, function(left, right)
				return left.name < right.name;
			end);
		end
	elseif cached_config.sorting.type == "Timer" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_buffs, function(left, right)
				return left.timer > right.timer;
			end);
		else
			table.sort(displayed_buffs, function(left, right)
				return left.timer < right.timer;
			end);
		end
	else
		if cached_config.sorting.reversed_order then
			table.sort(displayed_buffs, function(left, right)
				return left.duration > right.duration;
			end);
		else
			table.sort(displayed_buffs, function(left, right)
				return left.duration < right.duration;
			end);
		end
	end

	local position_on_screen = screen.calculate_absolute_coordinates(cached_config.position);

	-- draw
	for _, buff in ipairs(displayed_buffs) do
		
		if not buff.is_active then
			goto continue3;
		end

		buffs.draw(buff, buff.buff_UI, position_on_screen, 1);

		if cached_config.settings.orientation == "Horizontal" then
			position_on_screen.x = position_on_screen.x + cached_config.spacing.x * global_scale_modifier;
		else
			position_on_screen.y = position_on_screen.y + cached_config.spacing.y * global_scale_modifier;
		end

		::continue3::
	end
end

function this.init_dependencies()
	config = require("MHR_Overlay.Misc.config");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	consumables = require("MHR_Overlay.Buffs.consumables");
	melody_effects = require("MHR_Overlay.Buffs.melody_effects");
	buffs = require("MHR_Overlay.Buffs.buffs");
	--singletons = require("MHR_Overlay.Game_Handler.singletons");
	config = require("MHR_Overlay.Misc.config");
	--customization_menu = require("MHR_Overlay.UI.customization_menu");
	--players = require("MHR_Overlay.Damage_Meter.players");
	--non_players = require("MHR_Overlay.Damage_Meter.non_players");
	--quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	screen = require("MHR_Overlay.Game_Handler.screen");
	--drawing = require("MHR_Overlay.UI.drawing");
	utils = require("MHR_Overlay.Misc.utils");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
end

return this;