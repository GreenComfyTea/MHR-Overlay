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

local dangos_type_name = "dangos";
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

	buffs.update_generic_buff(this.list, dangos_type_name, "dango_defender", player_data, kitchen_skill_048_field, nil, nil, nil, nil, true, dango_defender_minimal_value);
	this.update_dango_adrenaline();
end


function this.update_dango_adrenaline()
	if not this.is_dango_adrenaline_active then
		this.list.dango_adrenaline = nil;
		return;
	end

	buffs.update_generic(this.list, dangos_type_name, "dango_adrenaline");
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