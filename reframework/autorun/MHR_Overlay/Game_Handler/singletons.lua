local this = {};

local time;
local utils;
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

this.message_manager = nil;
this.enemy_manager = nil;
this.lobby_manager = nil;
this.progress_manager = nil;
this.quest_manager = nil;
this.player_manager = nil;
this.village_area_manager = nil;
this.gui_manager = nil;
this.game_keyboard = nil;
this.scene_manager = nil;
this.game_manager = nil;

function this.init()
	this.init_message_manager();
	this.init_enemy_manager();
	this.init_lobby_manager()
	this.init_progress_manager();
	this.init_quest_manager();
	this.init_player_manager();
	this.init_village_area_manager();
	this.init_gui_manager();
	this.init_game_keyboard();
	this.init_scene_manager();
	this.init_game_manager();
	this.init_servant_manager();
	this.init_otomo_manager();
end

function this.init_message_manager()
	this.message_manager = sdk.get_managed_singleton("snow.gui.MessageManager");
	if this.message_manager == nil then
		error_handler.report("singletons.init_message_manager", "Failed to Access Data: message_manager");
	end

	return this.message_manager;
end

function this.init_enemy_manager()
	this.enemy_manager = sdk.get_managed_singleton("snow.enemy.EnemyManager");
	if this.enemy_manager == nil then
		error_handler.report("singletons.init_enemy_manager", "Failed to Access Data: enemy_manager");
	end

	return this.enemy_manager;
end

function this.init_lobby_manager()
	this.lobby_manager = sdk.get_managed_singleton("snow.LobbyManager");
	if this.lobby_manager == nil then
		error_handler.report("singletons.init_lobby_manager", "Failed to Access Data: lobby_manager");
		return false;
	end

	return this.lobby_manager;
end

function this.init_progress_manager()
	this.progress_manager = sdk.get_managed_singleton("snow.progress.ProgressManager");
	if this.progress_manager == nil then
		error_handler.report("singletons.init_lobby_manager", "Failed to Access Data: progress_manager");
		return false;
	end

	return this.progress_manager;
end

function this.init_quest_manager()
	this.quest_manager = sdk.get_managed_singleton("snow.QuestManager");
	if this.quest_manager == nil then
		error_handler.report("singletons.init_quest_manager", "Failed to Access Data: quest_manager");
	end

	return this.quest_manager;
end

function this.init_player_manager()
	this.player_manager = sdk.get_managed_singleton("snow.player.PlayerManager");
	if this.player_manager == nil then
		error_handler.report("singletons.init_player_manager", "Failed to Access Data: player_manager");
	end

	return this.player_manager;
end

function this.init_village_area_manager()
	this.village_area_manager = sdk.get_managed_singleton("snow.VillageAreaManager");
	if this.village_area_manager == nil then
		error_handler.report("singletons.init_village_area_manager", "Failed to Access Data: village_area_manager");
	end

	return this.village_area_manager;
end

function this.init_gui_manager()
	this.gui_manager = sdk.get_managed_singleton("snow.gui.GuiManager");
	if this.gui_manager == nil then
		error_handler.report("singletons.init_gui_manager", "Failed to Access Data: gui_manager");
	end

	return this.gui_manager;
end

function this.init_game_keyboard()
	this.game_keyboard = sdk.get_managed_singleton("snow.GameKeyboard");
	if this.game_keyboard == nil then
		error_handler.report("singletons.init_game_keyboard", "Failed to Access Data: game_keyboard");
	end

	return this.game_keyboard;
end

function this.init_scene_manager()
	this.scene_manager = sdk.get_native_singleton("via.SceneManager");
	if this.scene_manager == nil then
		error_handler.report("singletons.init_scene_manager", "Failed to Access Data: scene_manager");
	end

	return this.scene_manager;
end

function this.init_game_manager()
	this.game_manager = sdk.get_managed_singleton("snow.SnowGameManager");
	if this.game_manager == nil then
		error_handler.report("singletons.init_game_manager", "Failed to Access Data: game_manager");
	end

	return this.game_manager;
end

function this.init_servant_manager()
	this.servant_manager = sdk.get_managed_singleton("snow.ai.ServantManager");
	if this.servant_manager == nil then
		error_handler.report("singletons.init_servant_manager", "Failed to Access Data: servant_manager");
	end

	return this.servant_manager;
end

function this.init_otomo_manager()
	this.otomo_manager = sdk.get_managed_singleton("snow.otomo.OtomoManager");
	if this.otomo_manager == nil then
		error_handler.report("singletons.init_otomo_manager", "Failed to Access Data: otomo_manager");
	end

	return this.otomo_manager;
end

function this.init_dependencies()
	time = require("MHR_Overlay.Game_Handler.time");
	utils = require("MHR_Overlay.Misc.utils");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
	this.init();
	time.new_timer(this.init, 1);
end

return this;
