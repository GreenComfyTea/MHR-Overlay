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
};

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_data_method = player_manager_type_def:get_method("get_PlayerData");
local get_ref_item_parameter_method = player_manager_type_def:get_method("get_RefItemParameter");

local player_user_data_item_parameter_type_def = get_ref_item_parameter_method:get_return_type();

local demondrug_atk_up_field = player_user_data_item_parameter_type_def:get_field("_DemondrugAtkUp");
local great_demondrug_atk_up_field = player_user_data_item_parameter_type_def:get_field("_GreatDemondrugAtkUp");
local armorskin_def_up_field = player_user_data_item_parameter_type_def:get_field("_ArmorSkinDefUp");
local great_armorskin_def_up_field = player_user_data_item_parameter_type_def:get_field("_GreatArmorSkinDefUp");

local might_seed_timer_field = player_user_data_item_parameter_type_def:get_field("_MightSeedTimer");
local adamant_seed_timer_field = player_user_data_item_parameter_type_def:get_field("_AdamantSeedTimer");
local demondrug_powder_timer_field = player_user_data_item_parameter_type_def:get_field("_DemondrugPowderTimer");
local armorskin_powder_timer_field = player_user_data_item_parameter_type_def:get_field("_ArmorSkinPowderTimer");
local vitalizer_timer_const_field = player_user_data_item_parameter_type_def:get_field("_VitalizerTimer");
local stamina_up_buff_second_field = player_user_data_item_parameter_type_def:get_field("_StaminaUpBuffSecond");

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Dango Defender
local kitchen_skill_048_field = player_data_type_def:get_field("_KitchenSkill048_Damage");

local system_array_type_def = sdk.find_type_definition("System.Array");
local length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

function this.update(player_data)
	local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	if item_parameter == nil then
		error_handler.report("dangos.update", "Failed to access Data: item_parameter");
		return;
	end

	--this.update_dango_defender(player_data, item_parameter);
end

-- Not working??
function this.update_dango_defender(player_data, item_parameter)
	local dango_defender_value = kitchen_skill_048_field:get_data(player_data);
	if dango_defender_value == nil then
		error_handler.report("dangos.update_dango_defender", "Failed to access Data: dango_defender_value");
		return;
	end

	if dango_defender_value < 200 then
		this.list.dango_defender = nil;
		return;
	end

	local buff = this.list.dango_defender;
	if buff ~= nil then
		return;
	end

	local name = language.current_language.dangos.dango_defender_hi;

	this.list.dango_defender = buffs.new(buffs.types.dango, "dango_defender", name, 1);
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