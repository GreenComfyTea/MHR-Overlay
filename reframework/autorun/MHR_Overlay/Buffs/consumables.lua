local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;
local language;
local error_handler;
local endemic_life_buffs;

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

local consumable_ids = {
	demondrug = 68157917,
	mega_demondrug = 68157918,
	armorskin = 68157922,
	mega_armorskin = 68157923,
	might_seed = 68157919,
	adamant_seed = 68157924,
	demon_powder = 68157920,
	hardshell_powder = 68157925,
	immunizer = 68157911,
	dash_juice = 68157913,
	gourmet_fish = 68157909
}

local consumables_type_name = "consumables";

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_data_method = player_manager_type_def:get_method("get_PlayerData");
local get_ref_item_parameter_method = player_manager_type_def:get_method("get_RefItemParameter");

local player_user_data_item_parameter_type_def = get_ref_item_parameter_method:get_return_type();

local demondrug_atk_up_field = player_user_data_item_parameter_type_def:get_field("_DemondrugAtkUp");
local great_demondrug_atk_up_field = player_user_data_item_parameter_type_def:get_field("_GreatDemondrugAtkUp");

local armorskin_def_up_field = player_user_data_item_parameter_type_def:get_field("_ArmorSkinDefUp");
local great_armorskin_def_up_field = player_user_data_item_parameter_type_def:get_field("_GreatArmorSkinDefUp");

local might_seed_atk_up_field = player_user_data_item_parameter_type_def:get_field("_MightSeedAtkUp");
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

local data_shortcut_type_def = sdk.find_type_definition("snow.data.DataShortcut");
local get_name_method = data_shortcut_type_def:get_method("getName(snow.data.ContentsIdSystem.ItemId)");

function this.update(player_data)
	local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	if item_parameter == nil then
		error_handler.report("consumables.update", "Failed to access Data: item_parameter");
		return;
	end

	local cached_language = language.current_language

	this.update_demondrug(player_data, item_parameter);
	this.update_armorskin(player_data, item_parameter);
	this.update_might_seed(player_data, item_parameter);
	this.update_dash_juice(player_data, item_parameter);
	
	buffs.update_generic_buff(this.list, consumables_type_name, "adamant_seed", this.get_consumable_name,
		player_data, def_up_buff_second_field, player_data, def_up_buff_second_timer_field, item_parameter, adamant_seed_timer_field);
	
	buffs.update_generic_buff(this.list, consumables_type_name, "demon_powder", this.get_consumable_name,
		player_data, atk_up_item_second_field, player_data, atk_up_item_second_timer_field, item_parameter, demondrug_powder_timer_field);
	
	buffs.update_generic_buff(this.list, consumables_type_name, "hardshell_powder", this.get_consumable_name,
		player_data, def_up_item_second_field, player_data, def_up_item_second_timer_field, item_parameter, armorskin_powder_timer_field);
	
	buffs.update_generic_buff(this.list, consumables_type_name, "immunizer", this.get_consumable_name,
		nil, nil, player_data, vitalizer_timer_field, item_parameter, vitalizer_timer_const_field);

	buffs.update_generic_buff(this.list, consumables_type_name, "gourmet_fish", this.get_consumable_name,
		nil, nil, player_data, fish_regene_enable_field, nil, nil);
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

	local consumable_key;
	if demondrug_value == demondrug_const_value then
		consumable_key = "demondrug";
		this.list.mega_demondrug = nil;
	
	elseif demondrug_value == mega_demondrug_const_value then
		consumable_key = "mega_demondrug";
		this.list.demondrug = nil;
	end

	buffs.update_generic(this.list, consumables_type_name, consumable_key, this.get_consumable_name);
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

	local consumable_key;
	if armorskin_value == armorskin_const_value then
		consumable_key = "armorskin";
		this.list.mega_armorskin = nil;
	
	elseif armorskin_value == mega_armorskin_const_value then
		consumable_key = "mega_armorskin";
		this.list.armorskin = nil;
	end

	buffs.update_generic(this.list, consumables_type_name, consumable_key, this.get_consumable_name);
end

function this.update_might_seed(player_data, item_parameter)
	local atk_up_buff_second = atk_up_buff_second_field:get_data(player_data);
	if atk_up_buff_second == nil then
		error_handler.report("consumables.update_might_seed", "Failed to access Data: atk_up_buff_second");
		return;
	end

	local might_seed_atk_up = might_seed_atk_up_field:get_data(item_parameter);
	if might_seed_atk_up == nil then
		error_handler.report("consumables.update_might_seed", "Failed to access Data: might_seed_atk_up");
		return;
	end

	if atk_up_buff_second ~= might_seed_atk_up then
		this.list.might_seed = nil;
		return;
	end

	this.update_generic_buff(this.list, consumables_type_name, "might_seed", this.get_consumable_name,
		nil, nil, player_data, atk_up_buff_second_timer_field, item_parameter, might_seed_timer_field);
end

function this.update_dash_juice(player_data, item_parameter)
	local stamina_up_buff_second_timer = stamina_up_buff_second_timer_field:get_data(player_data);
	if stamina_up_buff_second_timer == nil then
		error_handler.report("consumables.update_dash_juice", "Failed to access Data: stamina_up_buff_second_timer");
		return;
	end

	local stamina_up_buff_second = stamina_up_buff_second_field:get_data(item_parameter);
	if stamina_up_buff_second == nil then
		error_handler.report("consumables.update_dash_juice", "Failed to access Data: stamina_up_buff_second");
		return;
	end

	if utils.number.is_equal(stamina_up_buff_second_timer, 0) then
		this.list.dash_juice = nil;
		return;
	end

	local timer = stamina_up_buff_second_timer / 60;
	local dash_juice_consumable = this.list.dash_juice;

	if dash_juice_consumable == nil
	or (dash_juice_consumable ~= nil and timer > dash_juice_consumable.timer) then
		if timer <= endemic_life_buffs.peepersects_duration + 0.1 then
			this.list.dash_juice = nil;
			return;
		end
	end

	buffs.update_generic(this.list, consumables_type_name, "dash_juice", this.get_consumable_name, 1, timer, stamina_up_buff_second);
end

function this.get_consumable_name(consumable_key)
	local consumable_name = get_name_method:call(nil, consumable_ids[consumable_key]);
	if consumable_name == nil then
		error_handler.report("consumables.get_consumable_name", string.format("Failed to access Data: %s_name", consumable_key));
		return consumable_key;
	end

	return consumable_name;
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
	endemic_life_buffs = require("MHR_Overlay.Buffs.endemic_life_buffs");
end

function this.init_module()
end

return this;