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
local time;

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
	clothfly = nil,
	butterflame = nil,
	-- peepersects = nil,
	stinkmink = nil,
	ruby_wirebug = nil,
	gold_wirebug = nil,
	red_lampsquid = nil,
	yellow_lampsquid = nil
};

this.keys = {
	"cutterfly",
	"clothfly",
	"butterflame",
	-- "peepersects",
	"stinkmink",
	"ruby_wirebug",
	"gold_wirebug",
	"red_lampsquid",
	"yellow_lampsquid"
};

this.peepersects_duration = 90;
this.butterflame_attack_up = 25;

local endemic_life_buffs_type_name = "endemic_life_buffs";

local marionette_mode_types = { "ruby_wirebug", "gold_wirebug" };



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

	this.update_endemic_life_buff("cutterfly", nil, nil, player_data, crit_up_ec_second_timer_field);
	this.update_endemic_life_buff("clothfly", nil, nil, player_data, def_up_buff_second_rate_timer_field);
	this.update_endemic_life_buff("stinkmink", nil, nil, player_data, lead_enemy_timer_field);
	this.update_endemic_life_buff("red_lampsquid", nil, nil, player_data, atk_up_ec_second_timer_field);
	this.update_endemic_life_buff("yellow_lampsquid", nil, nil, player_data, def_up_ec_second_timer_field);
end

function this.update_endemic_life_buff(key, value_owner, value_holder, timer_owner, timer_holder, is_infinite, minimal_value, level_breakpoints)
	return buffs.update_generic_buff(this.list, config.current_config.buff_UI.filter.endemic_life_buffs, this.get_endemic_life_name,
		endemic_life_buffs_type_name, key,
		value_owner, value_holder, timer_owner, timer_holder, is_infinite, minimal_value, level_breakpoints)
end

function this.update_generic(key, level, timer)
	return buffs.update_generic(this.list, this.get_endemic_life_name, endemic_life_buffs_type_name, key, level, timer);
end

function this.apply_filter(key)
	return buffs.apply_filter(this.list, config.current_config.buff_UI.filter.endemic_life_buffs, key);
end

function this.update_ruby_and_gold_wirebugs(player, player_data)
	local cached_config = config.current_config.buff_UI.filter.endemic_life_buffs;
	
	if not cached_config.ruby_wirebug
	and not cached_config.gold_wirebug then
		if this.apply_filter("ruby_wirebug") then
			return;
		end

		if this.apply_filter("gold_wirebug") then
			return;
		end
	end

	local marionette_mode_type = get_marionette_mode_type_method:call(player);
	if marionette_mode_type == nil then
		error_handler.report("endemic_life_buffs.update_ruby_and_gold_wirebugs", "Failed to Access Data: marionette_mode_type");
		this.list.ruby_wirebug = nil;
		this.list.gold_wirebug = nil;
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
	this.update_endemic_life_buff(endemic_life_buff_key, nil, nil, player_data, wirebug_powerup_timer_field);
end

function this.update_butterflame(player_data)
	if this.apply_filter("butterflame") then
		return;
	end

	local atk_up_buff_second = atk_up_buff_second_field:get_data(player_data);
	if atk_up_buff_second == nil then
		error_handler.report("item_buffs.update_butterflame", "Failed to Access Data: atk_up_buff_second");
		this.list.butterflame = nil;
		return;
	end

	if atk_up_buff_second ~= this.butterflame_attack_up then
		this.list.butterflame = nil;
		return;
	end

	this.update_endemic_life_buff("butterflame", nil, nil, player_data, atk_up_buff_second_timer_field);
end

function this.init_all_UI()
	for endemic_life_key, endemic_life in pairs(this.list) do
		buffs.init_UI(endemic_life);
	end
end

function this.init_names()
	for endemic_life_key, endemic_life in pairs(this.list) do
		endemic_life.name = this.get_endemic_life_name(endemic_life_key);
	end
end

function this.get_endemic_life_name(key)
	if singletons.message_manager == nil then
		error_handler.report("endemic_life_buffs.get_endemic_life_name", "Failed to Access Data: message_manager");
		return key;
	end

	local endemic_life_name = get_env_creature_name_message_method:call(singletons.message_manager, env_creature.creature_ids[key]);
	if endemic_life_name == nil then
		error_handler.report("endemic_life_buffs.get_endemic_life_name", string.format("Failed to Access Data: %s_name", key));
		return key;
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
	time = require("MHR_Overlay.Game_Handler.time");
end

function this.init_module()
end

return this;