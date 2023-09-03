local this = {};

local buff_UI_entity;
local config;
local singletons;
local players;
local consumables;
local melody_effects;
local utils;
local language;
local time;
local quest_status;
local error_handler;
local endemic_life_buffs;
local skills;
local dangos;
local abnormal_statuses;
local otomo_moves;
local weapon_skills;
local misc_buffs;

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

--[[
	TODO:
	[x] DONE! Wirebug-related skills
	More otomo skills
	[x] DONE! More Dango skills
	Part breaker, charge master
	[x] DONE! Weapon buffs
	More endemic life, such as Lampsquid
	[x] DONE! Horn music
]]

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_method = player_manager_type_def:get_method("getPlayer");
local find_master_player_method = player_manager_type_def:get_method("findMasterPlayer");

local player_base_type_def = find_master_player_method:get_return_type();
local get_player_data_method = player_base_type_def:get_method("get_PlayerData");

local player_lobby_base_type_def = sdk.find_type_definition("snow.player.PlayerLobbyBase");

local player_base_type_def = sdk.find_type_definition("snow.player.PlayerBase");
local player_weapon_type_field = player_base_type_def:get_field("_playerWeaponType");

function this.new(type, key, name, level, duration)
	local is_infinite = false;

	if name == nil then
		name = utils.constants.uninitialized_string;
	end

	if duration == nil then
		duration = 0;
	end

	if utils.number.is_equal(duration, 0) then
		is_infinite = true;
	end

	level = level or 1;

	local buff = {};

	buff.type = type;
	buff.key = key;
	buff.name = name;
	buff.level = level;

	buff.timer = duration;
	buff.duration = duration;

	buff.is_active = true;

	buff.timer_percentage = 0;

	buff.minutes_left = 0;
	buff.seconds_left = 0;

	buff.is_infinite = is_infinite;

	this.update_timer(buff, buff.timer);

	this.init_UI(buff);

	return buff;
end

function this.init_buffs()
	this.list = {};
end

function this.init_UI(buff)
	local cached_config = config.current_config.buff_UI;
	buff.buff_UI = buff_UI_entity.new(cached_config.bar, cached_config.name_label, cached_config.timer_label);
end

function this.init_names()
	skills.init_names();
	abnormal_statuses.init_names();
end

function this.update()
	if not config.current_config.buff_UI.enabled then
		return;
	end

	if singletons.player_manager == nil then
		error_handler.report("buffs.update", "Failed to access Data: player_manager");
		return;
	end

	if quest_status.flow_state <= quest_status.flow_states.IN_LOBBY
	or quest_status.flow_state == quest_status.flow_states.CUTSCENE
	or quest_status.flow_state >= quest_status.flow_states.QUEST_END_ANIMATION then
		return;
	end

	local master_player = find_master_player_method:call(singletons.player_manager); 
	if master_player == nil then
		error_handler.report("buffs.update", "Failed to access Data: master_player");
		return;
	end

	melody_effects.update(master_player);

	local master_player_data = get_player_data_method:call(master_player);
	if master_player_data == nil then
		error_handler.report("buffs.update", "Failed to access Data: master_player_data");
		return;
	end

	local weapon_type = player_weapon_type_field:get_data(master_player);
	if weapon_type == nil then
		error_handler.report("skills.update", "Failed to access Data: weapon_type");
		return;
	end

	local is_player_lobby_base = master_player:get_type_definition() == player_lobby_base_type_def;

	consumables.update(master_player_data);
	otomo_moves.update(master_player_data);

	if not is_player_lobby_base then
		skills.update(master_player, master_player_data, weapon_type);
		dangos.update(master_player, master_player_data);
		endemic_life_buffs.update(master_player, master_player_data);
		abnormal_statuses.update(master_player, master_player_data);
		weapon_skills.update(master_player, master_player_data, weapon_type);
		misc_buffs.update(master_player, master_player_data);
	end

	-- local tbl = {
	-- 	"_IsEnable_KitchenSkill048_Reduce",
	-- 	"_KitchenSkill_Insurance_DefUp_Lv3",
	-- 	"_KitchenSkill_Insurance_DefUp_Lv4",
	-- 	"_KitchenSkill051_AtkUpTimer",
	-- 	"_KitchenSkill051_AtkUp",
	-- 	"_KitchenSkill054_Timer",
	-- 	"_KitchenSkill054_DefUp",
	-- };

	-- xy = "";
	-- for _, key in ipairs(tbl) do
	-- 	xy = string.format("%s%s: %s\n", xy, key, tostring(master_player_data:get_field(key)));
	-- end
end

function this.update_timer(buff, timer, duration)
	if timer == nil then
		return;
	end

	if timer < 0 then
		timer = 0;
	end

	duration = duration or timer;

	if duration > buff.duration then
		buff.duration = duration;
	end

	local minutes_left = math.floor(timer / 60);

	buff.timer = timer;
	buff.minutes_left = minutes_left;
	buff.seconds_left = math.floor(timer - 60 * minutes_left);

	if buff.duration ~= 0 then
		buff.timer_percentage = timer / buff.duration;
	end
end

function this.update_generic_buff(buff_list, buff_type, buff_key, get_name_function,
	value_owner, value_holder,
	timer_owner, timer_holder,
	duration_owner, duration_holder,
	is_infinite, minimal_value, level_breakpoints)

	if timer_owner == nil then timer_owner = value_owner; end
	if duration_owner == nil then duration_owner = value_owner; end
	if minimal_value == nil then minimal_value = 1; end

	local level = 1;

	if value_holder ~= nil then
		local value;
		if utils.type.is_REField(value_holder) then
			value = value_holder:get_data(value_owner);
		else
			value = value_holder:call(value_owner);
		end
		
		if value == nil then
			error_handler.report("buffs.update_generic_number", string.format("Failed to access Data: %s_value", buff_key));
			return;
		end

		if utils.type.is_boolean(value) then
			if not value then
				buff_list[buff_key] = nil;
				return;
			end
		else
			if value < minimal_value then
				buff_list[buff_key] = nil;
				return;
			end

			if level_breakpoints ~= nil then
				local level_breakpoints_count = #level_breakpoints;
				for index, breakpoint in ipairs(level_breakpoints) do
					if value >= breakpoint then
						level = 2 + level_breakpoints_count - index;
						break;
					end
				end
			end
		end
	end

	local timer = nil;
	if timer_holder ~= nil then
		if utils.type.is_REField(timer_holder) then
			timer = timer_holder:get_data(timer_owner);
		else
			timer = timer_holder:call(timer_owner);
		end

		if timer == nil then
			error_handler.report("buffs.update_generic_number", string.format("Failed to access Data: %s_timer", buff_key));
			return;
		end

		if value_holder == nil and utils.number.is_equal(timer, 0) then
			buff_list[buff_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	local duration = nil;
	if duration_holder ~= nil then
		if utils.type.is_REField(duration_holder) then
			duration = duration_holder:get_data(duration_owner);
		else
			duration = duration_holder:call(duration_owner);
		end

		if duration == nil then
			error_handler.report("buffs.update_generic_number", string.format("Failed to access Data: %s_duration", buff_key));
			return;
		end
	end

	return this.update_generic(buff_list, buff_type, buff_key, get_name_function, level, timer, duration);
end

function this.update_generic(buff_list, buff_type, buff_key, get_name_function, level, timer, duration)
	duration = duration or timer;
	level = level or 1;

	local buff = buff_list[buff_key];
	if buff == nil then
		local name = get_name_function(buff_key);

		buff = this.new(buff_type, buff_key, name, level, duration);
		buff_list[buff_key] = buff;
	else
		buff.level = level;
		this.update_timer(buff, timer, duration);
	end

	return buff;
end

function this.draw(buff, buff_UI, position_on_screen, opacity_scale)
	buff_UI_entity.draw(buff, buff_UI, position_on_screen, opacity_scale);
end

function this.init_dependencies()
	config = require("MHR_Overlay.Misc.config");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	players = require("MHR_Overlay.Damage_Meter.players");
	consumables = require("MHR_Overlay.Buffs.consumables");
	melody_effects = require("MHR_Overlay.Buffs.melody_effects");
	utils = require("MHR_Overlay.Misc.utils");
	language = require("MHR_Overlay.Misc.language");
	time = require("MHR_Overlay.Game_Handler.time");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	endemic_life_buffs = require("MHR_Overlay.Buffs.endemic_life_buffs");
	skills = require("MHR_Overlay.Buffs.skills");
	dangos = require("MHR_Overlay.Buffs.dangos");
	abnormal_statuses = require("MHR_Overlay.Buffs.abnormal_statuses");
	otomo_moves = require("MHR_Overlay.Buffs.otomo_moves");
	weapon_skills = require("MHR_Overlay.Buffs.weapon_skills");
	misc_buffs = require("MHR_Overlay.Buffs.misc_buffs");
end

function this.init_module()
	
end

return this;