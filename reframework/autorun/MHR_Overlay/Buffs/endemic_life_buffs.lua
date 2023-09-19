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
local item_buffs;

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
	clothfly = nil,
	stinkmink = nil,
	butterflame = nil,
	-- peepersects = nil,
	cutterfly = nil,
	ruby_wirebug = nil,
	gold_wirebug = nil,
	red_lampsquid = nil,
	yellow_lampsquid = nil
};

this.peepersects_duration = 90;

local endemic_life_buffs_type_name = "endemic_life_buffs";

local marionette_mode_types = { "ruby_wirebug", "gold_wirebug" };
local butterflame_attack_up = 25;



local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Cutterfly
local crit_up_ec_second_timer_field = player_data_type_def:get_field("_CritUpEcSecondTimer");
-- Clothfly
local def_up_buff_second_rate_timer_field = player_data_type_def:get_field("_DefUpBuffSecondRateTimer");
-- Ruby/Gold Wirebugs
local wirebug_powerup_timer_field = player_data_type_def:get_field("_WireBugPowerUpTimer");
-- Butterflame
local atk_up_buff_second_field = player_data_type_def:get_field("_AtkUpBuffSecond");
local atk_up_buff_second_timer_field = player_data_type_def:get_field("_AtkUpBuffSecondTimer");
-- Stinkmink
local lead_enemy_timer_field = player_data_type_def:get_field("_LeadEnemyTimer");
-- Red Lampsquid
local atk_up_ec_second_timer_field = player_data_type_def:get_field("_AtkUpEcSecondTimer");
-- Yellow Lampsquid
local def_up_ec_second_timer_field = player_data_type_def:get_field("_DefUpEcSecondTimer");


local player_quest_base_type_def = sdk.find_type_definition("snow.player.PlayerQuestBase");
-- Ruby/Gold Wirebugs
local get_marionette_mode_type_method = player_quest_base_type_def:get_method("get_MarionetteModeType");

local message_manager_type_def = sdk.find_type_definition("snow.gui.MessageManager");
local get_env_creature_name_message_method = message_manager_type_def:get_method("getEnvCreatureNameMessage");

function this.update(player, player_data, item_parameter)
	this.update_ruby_and_gold_wirebugs(player, player_data);
	this.update_butterflame(player_data);

	buffs.update_generic_buff(this.list, endemic_life_buffs_type_name, "cutterfly", this.get_endemic_life_name,
		nil, nil, player_data, crit_up_ec_second_timer_field);

	buffs.update_generic_buff(this.list, endemic_life_buffs_type_name, "clothfly", this.get_endemic_life_name,
		nil, nil, player_data, def_up_buff_second_rate_timer_field);

	buffs.update_generic_buff(this.list, endemic_life_buffs_type_name, "stinkmink", this.get_endemic_life_name,
		nil, nil, player_data, lead_enemy_timer_field);

	buffs.update_generic_buff(this.list, endemic_life_buffs_type_name, "red_lampsquid", this.get_endemic_life_name,
		nil, nil, player_data, atk_up_ec_second_timer_field);

	buffs.update_generic_buff(this.list, endemic_life_buffs_type_name, "yellow_lampsquid", this.get_endemic_life_name,
		nil, nil, player_data, def_up_ec_second_timer_field);
end

function this.update_ruby_and_gold_wirebugs(player, player_data)
	local marionette_mode_type = get_marionette_mode_type_method:call(player);
	if marionette_mode_type == nil then
		error_handler.report("endemic_life_buffs.update_ruby_and_gold_wirebugs", "Failed to access Data: marionette_mode_type");
	end

	if marionette_mode_type ~= 1 and marionette_mode_type ~= 2 then
		this.list.ruby_wirebug = nil;
		this.list.gold_wirebug = nil;
		return;
	elseif marionette_mode_type ~= 1 then
		this.list.ruby_wirebug = nil;
	else
		this.list.gold_wirebug = nil;
	end

	local endemic_life_buff_key = marionette_mode_types[marionette_mode_type];

	buffs.update_generic_buff(this.list, endemic_life_buffs_type_name, endemic_life_buff_key, this.get_endemic_life_name,
		nil, nil, player_data, wirebug_powerup_timer_field);
end

function this.update_butterflame(player_data)
	local atk_up_buff_second = atk_up_buff_second_field:get_data(player_data);
	if atk_up_buff_second == nil then
		error_handler.report("item_buffs.update_butterflame", "Failed to access Data: atk_up_buff_second");
		return;
	end

	if atk_up_buff_second ~= butterflame_attack_up then
		this.list.butterflame = nil;
		return;
	end

	buffs.update_generic_buff(this.list, endemic_life_buffs_type_name, "butterflame", this.get_endemic_life_name,
		nil, nil, player_data, atk_up_buff_second_timer_field);
end

function this.get_endemic_life_name(endemic_life_buff_key)
	if singletons.message_manager == nil then
		error_handler.report("endemic_life_buffs.get_endemic_life_name", "Failed to access Data: message_manager");
		return endemic_life_buff_key;
	end

	local endemic_life_name = get_env_creature_name_message_method:call(singletons.message_manager, env_creature.creature_ids[endemic_life_buff_key]);
	if endemic_life_name == nil then
		error_handler.report("endemic_life_buffs.get_endemic_life_name", string.format("Failed to access Data: %s_name", endemic_life_buff_key));
		return endemic_life_buff_key;
	end

	return endemic_life_name;
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
	item_buffs = require("MHR_Overlay.Buffs.item_buffs");
end

function this.init_module()
end

return this;