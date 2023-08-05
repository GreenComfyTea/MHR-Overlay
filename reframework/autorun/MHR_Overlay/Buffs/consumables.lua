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
	hardshell_powder = nil,
	immunizer = nil,
	dash_juice = nil
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

local system_array_type_def = sdk.find_type_definition("System.Array");
local length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

function this.update(player_data)
	local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	if item_parameter == nil then
		error_handler.report("consumables.update", "Failed to Access Data: item_parameter");
		return;
	end

	this.update_demondrug(player_data, item_parameter);
	this.update_armorskin(player_data, item_parameter);
	this.update_might_seed(player_data, item_parameter);
	this.update_adamant_seed(player_data, item_parameter);
	this.update_demon_powder(player_data, item_parameter);
	this.update_hardshell_powder(player_data, item_parameter);
	this.update_immunizer(player_data, item_parameter);
	this.update_dash_juice(player_data, item_parameter);
end

function this.update_demondrug(player_data, item_parameter)
	local demondrug_value = atk_up_alive_field:get_data(player_data);
	if demondrug_value == nil then
		error_handler.report("consumables.update_demondrug", "Failed to Access Data: demondrug_value");
		return;
	end

	if demondrug_value == 0 then
		this.list.demondrug = nil;
		this.list.mega_demondrug = nil;
		return;
	end

	local demondrug_const_value = demondrug_atk_up_field:get_data(item_parameter);
	if demondrug_const_value == nil then
		error_handler.report("consumables.update_demondrug", "Failed to Access Data: demondrug_const_value");
		return;
	end

	local mega_demondrug_const_value = great_demondrug_atk_up_field:get_data(item_parameter);
	if mega_demondrug_const_value == nil then
		error_handler.report("consumables.update_demondrug", "Failed to Access Data: mega_demondrug_const_value");
		return;
	end
	if demondrug_value == demondrug_const_value then
		local buff = this.list.demondrug;
		if buff ~= nil and buff.value == demondrug_value then
			return;
		end

		local name = language.current_language.consumables.demondrug;

		this.list.demondrug = buffs.new(buffs.types.consumable, "demondrug", name, demondrug_value);
		this.list.mega_demondrug = nil;
	
	elseif demondrug_value == mega_demondrug_const_value then
		local buff = this.list.mega_demondrug;
		if buff ~= nil and buff.value == demondrug_value then
			return;
		end

		local name = language.current_language.consumables.mega_demondrug;

		this.list.demondrug = nil;
		this.list.mega_demondrug = buffs.new(buffs.types.consumable, "mega_demondrug", name, demondrug_value);
	end
end

function this.update_armorskin(player_data, item_parameter)
	local armorskin_value = def_up_alive_field:get_data(player_data);
	if armorskin_value == nil then
		error_handler.report("consumables.update_armorskin", "Failed to Access Data: armorskin_value");
		return;
	end

	if armorskin_value == 0 then
		this.list.armorskin = nil;
		this.list.mega_armorskin = nil;
		return;
	end

	local armorskin_const_value = armorskin_def_up_field:get_data(item_parameter);
	if armorskin_const_value == nil then
		error_handler.report("consumables.update_armorskin", "Failed to Access Data: armorskin_const_value");
		return;
	end

	local mega_armorskin_const_value = great_armorskin_def_up_field:get_data(item_parameter);
	if mega_armorskin_const_value == nil then
		error_handler.report("consumables.update_armorskin", "Failed to Access Data: mega_armorskin_const_value");
		return;
	end

	if armorskin_value == armorskin_const_value then
		local buff = this.list.armorskin;
		if buff ~= nil and buff.value == armorskin_value then
			return;
		end

		local name = language.current_language.consumables.armorskin;

		this.list.armorskin = buffs.new(buffs.types.consumable, "armorskin", name, armorskin_value);
		this.list.mega_armorskin = nil;

	elseif armorskin_value == mega_armorskin_const_value then
		local buff = this.list.mega_armorskin;
		if buff ~= nil and buff.value == armorskin_value then
			return;
		end

		local name = language.current_language.consumables.mega_armorskin;

		this.list.armorskin = nil;
		this.list.mega_armorskin = buffs.new(buffs.types.consumable, "mega_armorskin", name, armorskin_value);
	end
end

function this.update_might_seed(player_data, item_parameter)
	local might_seed_value = atk_up_buff_second_field:get_data(player_data);
	if might_seed_value == nil then
		error_handler.report("consumables.update_might_seed", "Failed to Access Data: might_seed_value");
		return;
	end

	if might_seed_value == 0 then
		this.list.might_seed = nil;
		return;
	end

	local might_seed_timer = atk_up_buff_second_timer_field:get_data(player_data);
	if might_seed_timer == nil then
		error_handler.report("consumables.update_might_seed", "Failed to Access Data: might_seed_timer");
		return;
	end

	local buff = this.list.might_seed;
	if buff == nil then
		local might_seed_timer_const_value = might_seed_timer_field:get_data(item_parameter);
		if might_seed_timer_const_value == nil then
			error_handler.report("consumables.update_might_seed", "Failed to Access Data: might_seed_timer_const_value");
			return;
		end

		local name = language.current_language.consumables.might_seed;

		buff = buffs.new(buffs.types.consumable, "might_seed", name, might_seed_value, might_seed_timer_const_value);
		this.list.might_seed = buff;
	else
		buff.value = might_seed_value;
		buffs.update_timer(buff, might_seed_timer / 60);
	end
end

function this.update_adamant_seed(player_data, item_parameter)
	local adamant_seed_value = def_up_buff_second_field:get_data(player_data);
	if adamant_seed_value == nil then
		error_handler.report("consumables.update_adamant_seed", "Failed to Access Data: adamant_seed_value");
		return;
	end

	if adamant_seed_value == 0 then
		this.list.adamant_seed = nil;
		return;
	end

	local adamant_seed_timer = def_up_buff_second_timer_field:get_data(player_data);
	if adamant_seed_timer == nil then
		error_handler.report("consumables.update_adamant_seed", "Failed to Access Data: adamant_seed_timer");
		return;
	end

	local buff = this.list.adamant_seed;
	if buff == nil then
		local adamant_seed_timer_const_value = adamant_seed_timer_field:get_data(item_parameter);
		if adamant_seed_timer_const_value == nil then
			error_handler.report("consumables.update_adamant_seed", "Failed to Access Data: adamant_seed_timer_const_value");
			return;
		end

		local name = language.current_language.consumables.adamant_seed;

		buff = buffs.new(buffs.types.consumable, "adamant_seed", name, adamant_seed_value, adamant_seed_timer_const_value);
		this.list.adamant_seed = buff;
	else
		buff.value = adamant_seed_value;
		buffs.update_timer(buff, adamant_seed_timer / 60);
	end
end

function this.update_demon_powder(player_data, item_parameter)
	local demon_powder_value = atk_up_item_second_field:get_data(player_data);
	if demon_powder_value == nil then
		error_handler.report("consumables.update_demon_powder", "Failed to Access Data: demon_powder_value");
		return;
	end

	if demon_powder_value == 0 then
		this.list.demon_powder = nil;
		return;
	end

	local demon_powder_timer = atk_up_item_second_timer_field:get_data(player_data);
	if demon_powder_timer == nil then
		error_handler.report("consumables.update_demon_powder", "Failed to Access Data: demon_powder_timer");
		return;
	end

	local buff = this.list.demon_powder;
	if buff == nil then
		local demon_powder_timer_const_value = demondrug_powder_timer_field:get_data(item_parameter);
		if demon_powder_timer_const_value == nil then
			error_handler.report("consumables.update_demon_powder", "Failed to Access Data: demon_powder_timer_const_value");
			return;
		end

		local name = language.current_language.consumables.demon_powder;

		buff = buffs.new(buffs.types.consumable, "demon_powder", name, demon_powder_value, demon_powder_timer_const_value);
		this.list.demon_powder = buff;
	else
		buff.value = demon_powder_value;
		buffs.update_timer(buff, demon_powder_timer / 60);
	end
end

function this.update_hardshell_powder(player_data, item_parameter)
	local hardshell_powder_value = def_up_item_second_field:get_data(player_data);
	if hardshell_powder_value == nil then
		error_handler.report("consumables.update_hardshell_powder", "Failed to Access Data: hardshell_powder_value");
		return;
	end

	if hardshell_powder_value == 0 then
		this.list.hardshell_powder = nil;
		return;
	end

	local hardshell_powder_timer = def_up_item_second_timer_field:get_data(player_data);
	if hardshell_powder_timer == nil then
		error_handler.report("consumables.update_hardshell_powder", "Failed to Access Data: hardshell_powder_timer");
		return;
	end

	local buff = this.list.hardshell_powder;
	if buff == nil then
		local demon_powder_timer_const_value = armorskin_powder_timer_field:get_data(item_parameter);
		if demon_powder_timer_const_value == nil then
			error_handler.report("consumables.update_hardshell_powder", "Failed to Access Data: demon_powder_timer_const_value");
			return;
		end

		local name = language.current_language.consumables.hardshell_powder;

		buff = buffs.new(buffs.types.consumable, "hardshell_powder", name, hardshell_powder_value, demon_powder_timer_const_value);
		this.list.hardshell_powder = buff;
	else
		buff.value = hardshell_powder_value;
		buffs.update_timer(buff, hardshell_powder_timer / 60);
	end
end

function this.update_immunizer(player_data, item_parameter)
	local immunizer_timer = vitalizer_timer_field:get_data(player_data);
	if immunizer_timer == nil then
		error_handler.report("consumables.update_immunizer", "Failed to Access Data: immunizer_timer");
		return;
	end

	if immunizer_timer == 0 then
		this.list.immunizer = nil;
		return;
	end

	local buff = this.list.immunizer;
	if buff == nil then
		local immunizer_timer_const_value = vitalizer_timer_const_field:get_data(item_parameter);
		if immunizer_timer_const_value == nil then
			error_handler.report("consumables.update_immunizer", "Failed to Access Data: immunizer_timer_const_value");
			return;
		end

		local name = language.current_language.consumables.immunizer;

		buff = buffs.new(buffs.types.consumable, "immunizer", name, 0, immunizer_timer_const_value);
		this.list.immunizer = buff;
	else
		buffs.update_timer(buff, immunizer_timer / 60);
	end
end

function this.update_dash_juice(player_data, item_parameter)
	local dash_juice_timer = stamina_up_buff_second_timer_field:get_data(player_data);
	if dash_juice_timer == nil then
		error_handler.report("consumables.update_dash_juice", "Failed to Access Data: dash_juice_timer");
		return;
	end

	if dash_juice_timer == 0 then
		this.list.dash_juice = nil;
		return;
	end

	local buff = this.list.dash_juice;

	if buff == nil then
		local dash_juice_timer_const_value = stamina_up_buff_second_field:get_data(item_parameter);
		if dash_juice_timer_const_value == nil then
			error_handler.report("consumables.update_dash_juice", "Failed to Access Data: dash_juice_timer");
			return;
		end

		local name = language.current_language.consumables.dash_juice;

		buff = buffs.new(buffs.types.consumable, "dash_juice", name, 0, dash_juice_timer_const_value);
		this.list.dash_juice = buff;
	else
		buffs.update_timer(buff, dash_juice_timer / 60);
	end
end

function this.init_names()
	for key, buff in pairs(this.list) do
		buff.name = language.current_language.consumables[key];
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