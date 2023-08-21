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
	demondrug = nil,
	mega_demondrug = nil,
	armorskin = nil,
	mega_armorskin = nil,
	might_seed = nil,
	adamant_seed = nil,
	demon_powder = nil,
	hardshell_powder = nil,
	immunizer = nil,
	dash_juice = nil,
	gourmet_fish = nil,
};

local consumables_type_name = "consumables";

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
-- Demondrug/Mega Demondrug
local atk_up_alive_field = player_data_type_def:get_field("_AtkUpAlive");
-- Armorskin/Mega Armorskin
local def_up_alive_field = player_data_type_def:get_field("_DefUpAlive");
-- Might Seed
local atk_up_buff_second_field = player_data_type_def:get_field("_AtkUpBuffSecond");
local atk_up_buff_second_timer_field = player_data_type_def:get_field("_AtkUpBuffSecondTimer");
-- Adamant Seed
local def_up_buff_second_field = player_data_type_def:get_field("_DefUpBuffSecond");
local def_up_buff_second_timer_field = player_data_type_def:get_field("_DefUpBuffSecondTimer");
-- Demon Powder
local atk_up_item_second_field = player_data_type_def:get_field("_AtkUpItemSecond");
local atk_up_item_second_timer_field = player_data_type_def:get_field("_AtkUpItemSecondTimer");
-- Hardshell Powder
local def_up_item_second_field = player_data_type_def:get_field("_DefUpItemSecond");
local def_up_item_second_timer_field = player_data_type_def:get_field("_DefUpItemSecondTimer");
-- Immunizer
local vitalizer_timer_field = player_data_type_def:get_field("_VitalizerTimer");
-- Dash Juice
local stamina_up_buff_second_timer_field = player_data_type_def:get_field("_StaminaUpBuffSecondTimer");
-- Gourmet Fish
local fish_regene_enable_field = player_data_type_def:get_field("_FishRegeneEnableTimer");

function this.update(player_data)
	local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	if item_parameter == nil then
		error_handler.report("consumables.update", "Failed to access Data: item_parameter");
		return;
	end

	this.update_demondrug(player_data, item_parameter);
	this.update_armorskin(player_data, item_parameter);

	buffs.update_generic_buff(this.list, consumables_type_name, "might_seed",
		player_data, atk_up_buff_second_field,
		player_data, atk_up_buff_second_timer_field,
		item_parameter, might_seed_timer_field);

	buffs.update_generic_buff(this.list, consumables_type_name, "adamant_seed",
		player_data, def_up_buff_second_field,
		player_data, def_up_buff_second_timer_field,
		item_parameter, adamant_seed_timer_field);

	buffs.update_generic_buff(this.list, consumables_type_name, "demon_powder",
		player_data, atk_up_item_second_field,
		player_data, atk_up_item_second_timer_field,
		item_parameter, demondrug_powder_timer_field);

	buffs.update_generic_buff(this.list, consumables_type_name, "hardshell_powder",
		player_data, def_up_item_second_field,
		player_data, def_up_item_second_timer_field,
		item_parameter, armorskin_powder_timer_field);
		
	buffs.update_generic_buff(this.list, consumables_type_name, "immunizer",
		nil, nil,
		player_data, vitalizer_timer_field,
		item_parameter, vitalizer_timer_const_field);

	buffs.update_generic_buff(this.list, consumables_type_name, "immunizer",
		nil, nil,
		player_data, stamina_up_buff_second_timer_field,
		item_parameter, stamina_up_buff_second_field);

	buffs.update_generic_buff(this.list, consumables_type_name, "gourmet_fish",
		nil, nil,
		player_data, fish_regene_enable_field,
		nil, nil);
		
end

function this.update_demondrug(player_data, item_parameter)
	local demondrug_value = atk_up_alive_field:get_data(player_data);
	if demondrug_value == nil then
		error_handler.report("consumables.update_demondrug", "Failed to access Data: demondrug_value");
		return;
	end

	if demondrug_value == 0 then
		this.list.demondrug = nil;
		this.list.mega_demondrug = nil;
		return;
	end

	local demondrug_const_value = demondrug_atk_up_field:get_data(item_parameter);
	if demondrug_const_value == nil then
		error_handler.report("consumables.update_demondrug", "Failed to access Data: demondrug_const_value");
		return;
	end

	local mega_demondrug_const_value = great_demondrug_atk_up_field:get_data(item_parameter);
	if mega_demondrug_const_value == nil then
		error_handler.report("consumables.update_demondrug", "Failed to access Data: mega_demondrug_const_value");
		return;
	end

	if demondrug_value == demondrug_const_value then
		buffs.update_generic(this.list, consumables_type_name, "demondrug");
		this.list.mega_demondrug = nil;
	
	elseif demondrug_value == mega_demondrug_const_value then
		buffs.update_generic(this.list, consumables_type_name, "mega_demondrug");
		this.list.demondrug = nil;
	end
end

function this.update_armorskin(player_data, item_parameter)
	local armorskin_value = def_up_alive_field:get_data(player_data);
	if armorskin_value == nil then
		error_handler.report("consumables.update_armorskin", "Failed to access Data: armorskin_value");
		return;
	end

	if armorskin_value == 0 then
		this.list.armorskin = nil;
		this.list.mega_armorskin = nil;
		return;
	end

	local armorskin_const_value = armorskin_def_up_field:get_data(item_parameter);
	if armorskin_const_value == nil then
		error_handler.report("consumables.update_armorskin", "Failed to access Data: armorskin_const_value");
		return;
	end

	local mega_armorskin_const_value = great_armorskin_def_up_field:get_data(item_parameter);
	if mega_armorskin_const_value == nil then
		error_handler.report("consumables.update_armorskin", "Failed to access Data: mega_armorskin_const_value");
		return;
	end

	if armorskin_value == armorskin_const_value then
		buffs.update_generic(this.list, consumables_type_name, "armorskin");
		this.list.mega_armorskin = nil;
	
	elseif armorskin_value == mega_armorskin_const_value then
		buffs.update_generic(this.list, consumables_type_name, "mega_armorskin");
		this.list.armorskin = nil;
	end
end

function this.init_names()
	for consumable_key, consumable in pairs(this.list) do
		local name = language.current_language.consumables[consumable_key];

		if name == nil then
			name = consumable_key;
		end

		consumable.name = name;
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