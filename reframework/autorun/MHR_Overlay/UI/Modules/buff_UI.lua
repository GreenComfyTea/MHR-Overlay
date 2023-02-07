local buff_UI = {};

local buff_UI_entity;
local config;
local buffs;
local screen;
local table_helpers;

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

function buff_UI.draw()
	local cached_config = config.current_config.buff_UI;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local displayed_buffs = {};

	for _, buff in pairs(buffs.list) do
		
		if not buff.is_active then
			goto continue
		end

		table.insert(displayed_buffs, buff);

		::continue::
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
			goto continue2
		end

		buffs.draw(buff, buff.buff_UI, position_on_screen, 1);

		if cached_config.settings.orientation == "Horizontal" then
			position_on_screen.x = position_on_screen.x + cached_config.spacing.x * global_scale_modifier;
		else
			position_on_screen.y = position_on_screen.y + cached_config.spacing.y * global_scale_modifier;
		end

		::continue2::
	end
end

function buff_UI.init_module()
	config = require("MHR_Overlay.Misc.config");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	buffs = require("MHR_Overlay.Buffs.buffs");
	--singletons = require("MHR_Overlay.Game_Handler.singletons");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	config = require("MHR_Overlay.Misc.config");
	--customization_menu = require("MHR_Overlay.UI.customization_menu");
	--players = require("MHR_Overlay.Damage_Meter.players");
	--non_players = require("MHR_Overlay.Damage_Meter.non_players");
	--quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	screen = require("MHR_Overlay.Game_Handler.screen");
	--drawing = require("MHR_Overlay.UI.drawing");
end

return buff_UI;