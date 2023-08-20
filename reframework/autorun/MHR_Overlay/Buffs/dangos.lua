local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;
local language;
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

this.list = {
	dango_defender = nil,
	dango_adrenaline = nil
};

this.is_dango_adrenaline_active = false;
local dango_defender_minimal_value = 200;

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_data_method = player_manager_type_def:get_method("get_PlayerData");
local get_ref_item_parameter_method = player_manager_type_def:get_method("get_RefItemParameter");

local player_user_data_item_parameter_type_def = get_ref_item_parameter_method:get_return_type();



local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Dango Defender
local kitchen_skill_048_field = player_data_type_def:get_field("_KitchenSkill048_Damage");

local player_base_type_def = sdk.find_type_definition("snow.player.PlayerBase");
-- Dango Adrenaline
local is_kitchen_skill_predicament_powerup_method = player_base_type_def:get_method("isKitchenSkillPredicamentPowerUp");

function this.update(player, player_data)
	local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	if item_parameter == nil then
		error_handler.report("dangos.update", "Failed to access Data: item_parameter");
		return;
	end

	this.update_generic_number_value_field("dango_defender", player_data, kitchen_skill_048_field, nil, true, dango_defender_minimal_value);
	this.update_dango_adrenaline();
end


function this.update_generic_timer(dango_key, timer_owner, timer_field, is_infinite)
	if is_infinite == nil then is_infinite = false; end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("dangos.update_generic_timer", string.format("Failed to access Data: %s_timer", dango_key));
			return;
		end

		if utils.number.is_equal(timer, 0) then
			this.list[dango_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(dango_key, 1, timer);
end

function this.update_generic_number_value_field(dango_key, timer_owner, value_field, timer_field, is_infinite, minimal_value)
	if minimal_value == nil then minimal_value = 1; end
	if is_infinite == nil then is_infinite = false; end

	local level = 1;

	if value_field ~= nil then
		local value = value_field:get_data(timer_owner);
		
		if value == nil then
			error_handler.report("dangos.update_generic_number_value_field", string.format("Failed to access Data: %s_value", dango_key));
			return;
		end

		if value < minimal_value then
			this.list[dango_key] = nil;
			return;
		end
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("dangos.update_generic_number_value_field", string.format("Failed to access Data: %s_timer", dango_key));
			return;
		end

		if value_field == nil and utils.number.is_equal(timer, 0) then
			this.list[dango_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(dango_key, level, timer);
end

function this.update_generic_boolean_value_field(dango_key, timer_owner, value_field, timer_field, is_infinite, minimal_value)
	if minimal_value == nil then minimal_value = true; end
	if is_infinite == nil then is_infinite = false; end

	if value_field ~= nil then
		local value = value_field:get_data(timer_owner);
		
		if value == nil then
			error_handler.report("dangos.update_generic_boolean_value_field", string.format("Failed to access Data: %s_value", dango_key));
			return;
		end

		if value < minimal_value then
			this.list[dango_key] = nil;
			return;
		end
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("dangos.update_generic_boolean_value_field", string.format("Failed to access Data: %s_timer", dango_key));
			return;
		end

		if value_field == nil and utils.number.is_equal(timer, 0) then
			this.list[dango_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(dango_key, 1, timer);
end

function this.update_generic_number_value_method(dango_key, timer_owner, value_method, timer_field, is_infinite, minimal_value)
	if minimal_value == nil then minimal_value = 1; end
	if is_infinite == nil then is_infinite = false; end

	local level = 1;

	if value_method ~= nil then
		local value = value_method:call(timer_owner);
		
		if value == nil then
			error_handler.report("dangos.update_generic_number_value_method", string.format("Failed to access Data: %s_value", dango_key));
			return;
		end

		if value < minimal_value then
			this.list[dango_key] = nil;
			return;
		end
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("dangos.update_generic_number_value_method", string.format("Failed to access Data: %s_timer", dango_key));
			return;
		end

		if value_method == nil and utils.number.is_equal(timer, 0) then
			this.list[dango_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(dango_key, level, timer);
end

function this.update_generic_boolean_value_method(dango_key, timer_owner, value_method, timer_field, is_infinite, minimal_value)
	if minimal_value == nil then minimal_value = true; end
	if is_infinite == nil then is_infinite = false; end

	if value_method ~= nil then
		local value = value_method:call(timer_owner);
		if value == nil then
			error_handler.report("dangos.update_generic_boolean_value_method", string.format("Failed to access Data: %s_value", dango_key));
			return;
		end

		if value ~= minimal_value then
			this.list[dango_key] = nil;
			return;
		end
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("dangos.update_generic_boolean_value_method", string.format("Failed to access Data: %s_timer", dango_key));
			return;
		end

		if value_method == nil and utils.number.is_equal(timer, 0) then
			this.list[dango_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(dango_key, 1, timer);
end

function this.update_generic(dango_key, level, timer, duration)
	duration = duration or timer;

	local dango = this.list[dango_key];
	if dango == nil then
		local name = language.current_language.dangos[dango_key];
		
		dango = buffs.new(buffs.types.dango, dango_key, name, level, duration);
		this.list[dango_key] = dango;
	else
		dango.level = level;

		if timer ~= nil then
			buffs.update_timer(dango, timer);
		end
	end
end

function this.update_dango_adrenaline()
	if not this.is_dango_adrenaline_active then
		this.list.dango_adrenaline = nil;
		return;
	end

	this.update_generic("dango_adrenaline", 1);
end

function this.init_names()
	for dango_key, dango in pairs(this.list) do
		local name = language.current_language.dangos[dango_key];

		if name == nil then
			name = dango_key;
		end

		dango.name = name;
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
end

function this.init_module()
end

return this;