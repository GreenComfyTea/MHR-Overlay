local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;

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


local ids = {
	demondrug = 0,
	mega_demondrug = 1,
	armorskin = 2,
	mega_armorskin = 4,
	might_seed = 8,
	adamant_seed = 16,
	demon_powder = 32,
	hardshell_powder = 64,
	immunizer = 128,
	dash_juice = 256
};

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

function this.update()
	local player_data_array = get_player_data_method:call(singletons.player_manager);
	if player_data_array == nil then
		return;
	end

	local player_data = get_value_method:call(player_data_array, players.myself.id);
	if player_data == nil then
		return;
	end

	local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	if item_parameter == nil then
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
	local demondrug = atk_up_alive_field:get_data(player_data);
	if demondrug == nil then
		return;
	end

	if demondrug == 0 then
		this.list.demondrug = nil;
		this.list.mega_demondrug = nil;
		return;
	end

	local demondrug_const_value = demondrug_atk_up_field:get_data(item_parameter);
	if demondrug_const_value == nil then
		return;
	end

	local mega_demondrug_const_value = great_demondrug_atk_up_field:get_data(item_parameter);
	if mega_demondrug_const_value == nil then
		return;
	end

	if demondrug == demondrug_const_value then
		local buff = this.list.demondrug;
		if buff ~= nil and buff.value == demondrug then
			return;
		end

		this.list.demondrug = buffs.new("Demondrug", demondrug);
		this.list.mega_demondrug = nil;
	
	elseif demondrug == mega_demondrug_const_value then
		local buff = this.list.mega_demondrug;
		if buff ~= nil and buff.value == demondrug then
			return;
		end

		this.list.demondrug = nil;
		this.list.mega_demondrug = buffs.new("Mega Demondrug", demondrug);
	end
end

function this.update_armorskin(player_data, item_parameter)
	local armorskin = def_up_alive_field:get_data(player_data);
	if armorskin == nil then
		return;
	end

	if armorskin == 0 then
		this.list.armorskin = nil;
		this.list.mega_armorskin = nil;
		return;
	end

	local armorskin_const_value = armorskin_def_up_field:get_data(item_parameter);
	if armorskin_const_value == nil then
		return;
	end

	local mega_armorskin_const_value = great_armorskin_def_up_field:get_data(item_parameter);
	if mega_armorskin_const_value == nil then
		return;
	end

	if armorskin == armorskin_const_value then
		local buff = this.list.armorskin;
		if buff ~= nil and buff.value == armorskin then
			return;
		end

		this.list.armorskin = buffs.new("Armorskin", armorskin);
		this.list.mega_armorskin = nil;

	elseif armorskin == mega_armorskin_const_value then
		local buff = this.list.mega_armorskin;
		if buff ~= nil and buff.value == armorskin then
			return;
		end

		this.list.armorskin = nil;
		this.list.mega_armorskin = buffs.new("Mega Armorskin", armorskin);
	end
end

function this.update_might_seed(player_data, item_parameter)
	local might_seed = atk_up_buff_second_field:get_data(player_data);
	if might_seed == nil then
		return;
	end

	if might_seed == 0 then
		this.list.might_seed = nil;
		return;
	end

	local might_seed_timer = atk_up_buff_second_timer_field:get_data(player_data);
	if might_seed_timer == nil then
		return;
	end

	local buff = this.list.might_seed;
	if buff == nil then
		local might_seed_timer_const_value = might_seed_timer_field:get_data(item_parameter);
		if might_seed_timer_const_value == nil then
			return;
		end

		buff = buffs.new("Might Seed", might_seed, might_seed_timer_const_value);
		this.list.might_seed = buff;
	else
		buff.value = might_seed;
		buffs.update_timer(buff, might_seed_timer / 60);
	end
end

function this.update_adamant_seed(player_data, item_parameter)
	local adamant_seed = def_up_buff_second_field:get_data(player_data);
	if adamant_seed == nil then
		return;
	end

	if adamant_seed == 0 then
		this.list.adamant_seed = nil;
		return;
	end

	local adamant_seed_timer = def_up_buff_second_timer_field:get_data(player_data);
	if adamant_seed_timer == nil then
		return;
	end

	local buff = this.list.adamant_seed;
	if buff == nil then
		local adamant_seed_timer_const_value = adamant_seed_timer_field:get_data(item_parameter);
		if adamant_seed_timer_const_value == nil then
			return;
		end

		buff = buffs.new("Adamant Seed", adamant_seed, adamant_seed_timer_const_value);
		this.list.adamant_seed = buff;
	else
		buff.value = adamant_seed;
		buffs.update_timer(buff, adamant_seed_timer / 60);
	end
end

function this.update_demon_powder(player_data, item_parameter)
	local demon_powder = atk_up_item_second_field:get_data(player_data);
	if demon_powder == nil then
		return;
	end

	if demon_powder == 0 then
		this.list.demon_powder = nil;
		return;
	end

	local demon_powder_timer = atk_up_item_second_timer_field:get_data(player_data);
	if demon_powder_timer == nil then
		return;
	end

	local buff = this.list.demon_powder;
	if buff == nil then
		local demon_powder_timer_const_value = demondrug_powder_timer_field:get_data(item_parameter);
		if demon_powder_timer_const_value == nil then
			return;
		end

		buff = buffs.new("Demon Powder", demon_powder, demon_powder_timer_const_value);
		this.list.demon_powder = buff;
	else
		buff.value = demon_powder;
		buffs.update_timer(buff, demon_powder_timer / 60);
	end
end

function this.update_hardshell_powder(player_data, item_parameter)
	local hardshell_powder = def_up_item_second_field:get_data(player_data);
	if hardshell_powder == nil then
		return;
	end

	if hardshell_powder == 0 then
		this.list.hardshell_powder = nil;
		return;
	end

	local hardshell_powder_timer = def_up_item_second_timer_field:get_data(player_data);
	if hardshell_powder_timer == nil then
		return;
	end

	local buff = this.list.hardshell_powder;
	if buff == nil then
		local demon_powder_timer_const_value = armorskin_powder_timer_field:get_data(item_parameter);
		if demon_powder_timer_const_value == nil then
			return;
		end

		buff = buffs.new("Hardshell Powder", hardshell_powder, demon_powder_timer_const_value);
		this.list.hardshell_powder = buff;
	else
		buff.value = hardshell_powder;
		buffs.update_timer(buff, hardshell_powder_timer / 60);
	end
end

function this.update_immunizer(player_data, item_parameter)
	local immunizer_timer = vitalizer_timer_field:get_data(player_data);
	if immunizer_timer == nil then
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
			return;
		end

		buff = buffs.new("Immunizer", 0, immunizer_timer_const_value);
		this.list.immunizer = buff;
	else
		buffs.update_timer(buff, immunizer_timer / 60);
	end
end

function this.update_dash_juice(player_data, item_parameter)
	local dash_juice_timer = stamina_up_buff_second_timer_field:get_data(player_data);

	if dash_juice_timer == nil then
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
			return;
		end

		buff = buffs.new("Dash Juice", 0, dash_juice_timer_const_value);
		this.list.dash_juice = buff;
	else
		buffs.update_timer(buff, dash_juice_timer / 60);
	end
end

function this.init_module()
	buffs = require("MHR_Overlay.Buffs.buffs");
	config = require("MHR_Overlay.Misc.config");
	utils = require("MHR_Overlay.Misc.utils");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	players = require("MHR_Overlay.Damage_Meter.players");
end

return this;