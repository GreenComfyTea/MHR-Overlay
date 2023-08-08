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
	cutterfly = nil,
	clothfly = nil
};

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_data_method = player_manager_type_def:get_method("get_PlayerData");
local get_ref_item_parameter_method = player_manager_type_def:get_method("get_RefItemParameter");

local player_user_data_item_parameter_type_def = get_ref_item_parameter_method:get_return_type();
local demondrug_atk_up_field = player_user_data_item_parameter_type_def:get_field("_DemondrugAtkUp");

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Cutterfly
local crit_up_ec_second_timer_field = player_data_type_def:get_field("_CritUpEcSecondTimer");
-- Clothfly
local def_up_buff_second_rate_timer_field = player_data_type_def:get_field("_DefUpBuffSecondRateTimer");

local system_array_type_def = sdk.find_type_definition("System.Array");
local length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

local message_manager_type_def = sdk.find_type_definition("snow.gui.MessageManager");
local get_env_creature_name_message_method = message_manager_type_def:get_method("getEnvCreatureNameMessage");

function this.update(player_data)
	local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	if item_parameter == nil then
		error_handler.report("endemic_life_buffs.update", "Failed to access Data: item_parameter");
		return;
	end

	this.update_cutterfly(player_data, item_parameter);
	this.update_clothfly(player_data, item_parameter);
end

function this.update_cutterfly(player_data, item_parameter)
	local cutterfly_timer = crit_up_ec_second_timer_field:get_data(player_data);
	if cutterfly_timer == nil then
		error_handler.report("endemic_life_buffs.update_cutterfly", "Failed to access Data: cutterfly_timer");
		return;
	end

	if cutterfly_timer == 0 then
		this.list.cutterfly = nil;
		return;
	end

	local buff = this.list.cutterfly;

	if buff == nil then
		local name = get_env_creature_name_message_method:call(singletons.message_manager, env_creature.creature_ids.cutterfly);
		if name == nil then
			error_handler.report("endemic_life_buffs.update_cutterfly", "Failed to access Data: name");
			return;
		end

		buff = buffs.new(buffs.types.consumable, "cutterfly", name, 1, cutterfly_timer / 60);
		this.list.cutterfly = buff;
	else
		buffs.update_timer(buff, cutterfly_timer / 60);
	end
end

function this.update_clothfly(player_data, item_parameter)
	local clothfly_timer = def_up_buff_second_rate_timer_field:get_data(player_data);
	if clothfly_timer == nil then
		error_handler.report("endemic_life_buffs.update_clothfly", "Failed to access Data: clothfly_timer");
		return;
	end

	if clothfly_timer == 0 then
		this.list.clothfly = nil;
		return;
	end

	local buff = this.list.clothfly;

	if buff == nil then
		local name = get_env_creature_name_message_method:call(singletons.message_manager, env_creature.creature_ids.clothfly);
		if name == nil then
			error_handler.report("endemic_life_buffs.update_clothfly", "Failed to access Data: name");
			return;
		end

		buff = buffs.new(buffs.types.consumable, "clothfly", name, 1, clothfly_timer / 60);
		this.list.clothfly = buff;
	else
		buffs.update_timer(buff, clothfly_timer / 60);
	end
end

function this.init_names()
	-- Nothing to do here
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
end

function this.init_module()
end

return this;