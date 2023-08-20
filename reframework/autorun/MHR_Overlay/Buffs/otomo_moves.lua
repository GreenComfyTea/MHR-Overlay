local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;
local language;
local error_handler;
local env_creature;
local player_info;
local time;
local abnormal_statuses;

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

this.list = {
	rousing_roar = nil,
	power_drum = nil,
	go_fight_win = nil
};


local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_data_method = player_manager_type_def:get_method("get_PlayerData");

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Palico: Rousing Roar
local beast_roar_otomo_timer_field = player_data_type_def:get_field("_BeastRoarOtomoTimer");
-- Palico: Power Drum
local kijin_otomo_timer_field = player_data_type_def:get_field("_KijinOtomoTimer");
-- Palico: Go, Fight, Win
local runhigh_otomo_timer_field = player_data_type_def:get_field("_RunhighOtomoTimer");

function this.update(player_data)
	this.update_generic_timer("rousing_roar", player_data, beast_roar_otomo_timer_field);
	this.update_generic_timer("power_drum", player_data, kijin_otomo_timer_field);
	this.update_generic_timer("go_fight_win", player_data, runhigh_otomo_timer_field);
end

function this.update_generic_timer(otomo_move_key, timer_owner, timer_field, is_infinite)
	if is_infinite == nil then is_infinite = false; end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("otomo_moves.update_generic_timer", string.format("Failed to access Data: %s_timer", otomo_move_key));
			return;
		end

		if utils.number.is_equal(timer, 0) then
			this.list[otomo_move_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(otomo_move_key, 1, timer);
end

function this.update_generic_number_value_field(otomo_move_key, timer_owner, value_field, timer_field, is_infinite, minimal_value)
	if minimal_value == nil then minimal_value = 1; end
	if is_infinite == nil then is_infinite = false; end


	local level = 1;

	if value_field ~= nil then
		local value = value_field:get_data(timer_owner);
		
		if value == nil then
			error_handler.report("otomo_moves.update_generic_number_value_field", string.format("Failed to access Data: %s_value", otomo_move_key));
			return;
		end

		if value < minimal_value then
			this.list[otomo_move_key] = nil;
			return;
		end
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("otomo_moves.update_generic_number_value_field", string.format("Failed to access Data: %s_timer", otomo_move_key));
			return;
		end

		if value_field == nil and utils.number.is_equal(timer, 0) then
			this.list[otomo_move_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(otomo_move_key, level, timer);
end

function this.update_generic_boolean_value_field(otomo_move_key, timer_owner, value_field, timer_field, is_infinite, minimal_value)
	if minimal_value == nil then minimal_value = true; end
	if is_infinite == nil then is_infinite = false; end

	if value_field ~= nil then
		local value = value_field:get_data(timer_owner);
		
		if value == nil then
			error_handler.report("otomo_moves.update_generic_boolean_value_field", string.format("Failed to access Data: %s_value", otomo_move_key));
			return;
		end

		if value < minimal_value then
			this.list[otomo_move_key] = nil;
			return;
		end
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("otomo_moves.update_generic_boolean_value_field", string.format("Failed to access Data: %s_timer", otomo_move_key));
			return;
		end

		if value_field == nil and utils.number.is_equal(timer, 0) then
			this.list[otomo_move_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(otomo_move_key, 1, timer);
end

function this.update_generic_number_value_method(otomo_move_key, timer_owner, value_method, timer_field, is_infinite, minimal_value)
	if minimal_value == nil then minimal_value = 1; end
	if is_infinite == nil then is_infinite = false; end

	local level = 1;

	if value_method ~= nil then
		local value = value_method:call(timer_owner);
		
		if value == nil then
			error_handler.report("otomo_moves.update_generic_number_value_method", string.format("Failed to access Data: %s_value", otomo_move_key));
			return;
		end

		if value < minimal_value then
			this.list[otomo_move_key] = nil;
			return;
		end
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("otomo_moves.update_generic_number_value_method", string.format("Failed to access Data: %s_timer", otomo_move_key));
			return;
		end

		if value_method == nil and utils.number.is_equal(timer, 0) then
			this.list[otomo_move_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(otomo_move_key, level, timer);
end

function this.update_generic_boolean_value_method(otomo_move_key, timer_owner, value_method, timer_field, is_infinite, minimal_value)
	if minimal_value == nil then minimal_value = true; end
	if is_infinite == nil then is_infinite = false; end

	if value_method ~= nil then
		local value = value_method:call(timer_owner);
		
		if value == nil then
			error_handler.report("otomo_moves.update_generic_boolean_value_method", string.format("Failed to access Data: %s_value", otomo_move_key));
			return;
		end

		if value ~= minimal_value then
			this.list[otomo_move_key] = nil;
			return;
		end
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("otomo_moves.update_generic_boolean_value_method", string.format("Failed to access Data: %s_timer", otomo_move_key));
			return;
		end

		if value_method == nil and utils.number.is_equal(timer, 0) then
			this.list[otomo_move_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(otomo_move_key, 1, timer);
end

function this.update_generic(otomo_move_key, level, timer, duration)
	duration = duration or timer;

	local otomo_move = this.list[otomo_move_key];
	if otomo_move == nil then
		local name = language.current_language.otomo_moves[otomo_move_key];
		
		otomo_move = buffs.new(buffs.types.otomo_move, otomo_move_key, name, level, duration);
		this.list[otomo_move_key] = otomo_move;
	else
		otomo_move.level = level;

		if timer ~= nil then
			buffs.update_timer(otomo_move, timer);
		end
	end
end

function this.init_names()
	for otomo_move_key, otomo_move in pairs(this.list) do
		local name = language.current_language.otomo_moves[otomo_move_key];

		if name == nil then
			name = otomo_move_key;
		end

		otomo_move.name = name;
	end
end

function this.init_dependencies()
	buffs = require("MHR_Overlay.Buffs.buffs");
	config = require("MHR_Overlay.Misc.config");
	utils = require("MHR_Overlay.Misc.utils");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	players = require("MHR_Overlay.Damage_Meter.players");
	language = require("MHR_Overlay.Misc.language");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	player_info = require("MHR_Overlay.Misc.player_info");
	time = require("MHR_Overlay.Game_Handler.time");
	abnormal_statuses = require("MHR_Overlay.Buffs.abnormal_statuses");
end

function this.init_module()
end

return this;