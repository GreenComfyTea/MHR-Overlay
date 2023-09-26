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

function this.update()
	this.update_message_manager();
	this.update_enemy_manager();
	this.update_lobby_manager()
	this.update_progress_manager();
	this.update_quest_manager();
	this.update_player_manager();
	this.update_village_area_manager();
	this.update_gui_manager();
	this.update_game_keyboard();
	this.update_scene_manager();
	this.update_game_manager();
	this.update_servant_manager();
	this.update_otomo_manager();
	this.update_long_sword_shell_manager();
	this.update_light_bowgun_shell_manager();
	this.update_horn_shell_manager();
end

function this.update_message_manager()
	this.message_manager = sdk.get_managed_singleton("snow.gui.MessageManager");
	if this.message_manager == nil then
		error_handler.report("singletons.update_message_manager", "Failed to access Data: message_manager");
	end

	return this.message_manager;
end

function this.update_enemy_manager()
	this.enemy_manager = sdk.get_managed_singleton("snow.enemy.EnemyManager");
	if this.enemy_manager == nil then
		error_handler.report("singletons.update_enemy_manager", "Failed to access Data: enemy_manager");
	end

	return this.enemy_manager;
end

function this.update_lobby_manager()
	this.lobby_manager = sdk.get_managed_singleton("snow.LobbyManager");
	if this.lobby_manager == nil then
		error_handler.report("singletons.update_lobby_manager", "Failed to access Data: lobby_manager");
		return false;
	end

	return this.lobby_manager;
end

function this.update_progress_manager()
	this.progress_manager = sdk.get_managed_singleton("snow.progress.ProgressManager");
	if this.progress_manager == nil then
		error_handler.report("singletons.update_progress_manager", "Failed to access Data: progress_manager");
		return false;
	end

	return this.progress_manager;
end

function this.update_quest_manager()
	this.quest_manager = sdk.get_managed_singleton("snow.QuestManager");
	if this.quest_manager == nil then
		error_handler.report("singletons.update_quest_manager", "Failed to access Data: quest_manager");
	end

	return this.quest_manager;
end

function this.update_player_manager()
	this.player_manager = sdk.get_managed_singleton("snow.player.PlayerManager");
	if this.player_manager == nil then
		error_handler.report("singletons.update_player_manager", "Failed to access Data: player_manager");
	end

	return this.player_manager;
end

function this.update_village_area_manager()
	this.village_area_manager = sdk.get_managed_singleton("snow.VillageAreaManager");
	if this.village_area_manager == nil then
		error_handler.report("singletons.update_village_area_manager", "Failed to access Data: village_area_manager");
	end

	return this.village_area_manager;
end

function this.update_gui_manager()
	this.gui_manager = sdk.get_managed_singleton("snow.gui.GuiManager");
	if this.gui_manager == nil then
		error_handler.report("singletons.update_gui_manager", "Failed to access Data: gui_manager");
	end

	return this.gui_manager;
end

function this.update_game_keyboard()
	this.game_keyboard = sdk.get_managed_singleton("snow.GameKeyboard");
	if this.game_keyboard == nil then
		error_handler.report("singletons.update_game_keyboard", "Failed to access Data: game_keyboard");
	end

	return this.game_keyboard;
end

function this.update_scene_manager()
	this.scene_manager = sdk.get_native_singleton("via.SceneManager");
	if this.scene_manager == nil then
		error_handler.report("singletons.update_scene_manager", "Failed to access Data: scene_manager");
	end

	return this.scene_manager;
end

function this.update_game_manager()
	this.game_manager = sdk.get_managed_singleton("snow.SnowGameManager");
	if this.game_manager == nil then
		error_handler.report("singletons.update_game_manager", "Failed to access Data: game_manager");
	end

	return this.game_manager;
end

function this.update_servant_manager()
	this.servant_manager = sdk.get_managed_singleton("snow.ai.ServantManager");
	if this.servant_manager == nil then
		error_handler.report("singletons.update_servant_manager", "Failed to access Data: servant_manager");
	end

	return this.servant_manager;
end

function this.update_otomo_manager()
	this.otomo_manager = sdk.get_managed_singleton("snow.otomo.OtomoManager");
	if this.otomo_manager == nil then
		error_handler.report("singletons.update_otomo_manager", "Failed to access Data: otomo_manager");
	end

	return this.otomo_manager;
end

function this.update_long_sword_shell_manager()
	this.long_sword_shell_manager = sdk.get_managed_singleton("snow.shell.LongSwordShellManager");
	if this.long_sword_shell_manager == nil then
		error_handler.report("singletons.update_long_sword_shell_manager", "Failed to access Data: long_sword_shell_manager");
	end

	return this.long_sword_shell_manager;
end

function this.update_light_bowgun_shell_manager()
	this.light_bowgun_shell_manager = sdk.get_managed_singleton("snow.shell.LightBowgunShellManager");
	if this.light_bowgun_shell_manager == nil then
		error_handler.report("singletons.update_light_bowgun_shell_manager", "Failed to access Data: light_bowgun_shell_manager");
	end

	return this.light_bowgun_shell_manager;
end

function this.update_horn_shell_manager()
	this.horn_shell_manager = sdk.get_managed_singleton("snow.shell.HornShellManager");
	if this.horn_shell_manager == nil then
		error_handler.report("singletons.update_horn_shell_manager", "Failed to access Data: horn_shell_manager");
	end

	return this.horn_shell_manager;
end


function this.init_dependencies()
	time = require("MHR_Overlay.Game_Handler.time");
	utils = require("MHR_Overlay.Misc.utils");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
	this.update();
end

return this;
