local this = {};

local buff_UI_entity;
local config;
local singletons;
local players;
local item_buffs;
local melody_effects;
local utils;
local language;
local time;
local quest_status;
local error_handler;
local endemic_life_buffs;
local skills;
local dango_skills;
local abnormal_statuses;
local otomo_moves;
local weapon_skills;
local misc_buffs;
local rampage_skills;

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

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local find_master_player_method = player_manager_type_def:get_method("findMasterPlayer");
local get_ref_item_parameter_method = player_manager_type_def:get_method("get_RefItemParameter");

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

	buff.is_visible = true;

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

function this.init_all_UI()
	abnormal_statuses.init_all_UI();
	item_buffs.init_all_UI();
	endemic_life_buffs.init_all_UI();
	melody_effects.init_all_UI();
	dango_skills.init_all_UI();
	rampage_skills.init_all_UI();
	skills.init_all_UI();
	weapon_skills.init_all_UI();
	otomo_moves.init_all_UI();
	misc_buffs.init_all_UI();
end

function this.init_UI(buff)
	local cached_config = config.current_config.buff_UI[buff.type];
	buff.buff_UI = buff_UI_entity.new(cached_config.bar, cached_config.name_label, cached_config.timer_label);
end

function this.init_names()
	abnormal_statuses.init_names();
	item_buffs.init_names();
	endemic_life_buffs.init_names();
	melody_effects.init_names();
	dango_skills.init_names();
	rampage_skills.init_names();
	skills.init_names();
	weapon_skills.init_names();
	otomo_moves.init_names();
	misc_buffs.init_names();
end

local tere = {};
local tere2 = {};
local tere3 = {};

function this.update()
	if not config.current_config.buff_UI.enabled then
		return;
	end

	if singletons.player_manager == nil then
		error_handler.report("buffs.update", "Failed to Access Data: player_manager");
		return;
	end

	if quest_status.flow_state <= quest_status.flow_states.IN_LOBBY
	or quest_status.flow_state == quest_status.flow_states.CUTSCENE
	or quest_status.flow_state >= quest_status.flow_states.QUEST_END_ANIMATION then
		return;
	end

	local master_player = find_master_player_method:call(singletons.player_manager);
	if master_player == nil then
		error_handler.report("buffs.update", "Failed to Access Data: master_player");
		return;
	end

	melody_effects.update(master_player);

	local master_player_data = get_player_data_method:call(master_player);
	if master_player_data == nil then
		error_handler.report("buffs.update", "Failed to Access Data: master_player_data");
		return;
	end

	local weapon_type = player_weapon_type_field:get_data(master_player);
	if weapon_type == nil then
		error_handler.report("buffs.update", "Failed to Access Data: weapon_type");
		return;
	end

	if singletons.player_manager == nil then
		error_handler.report("buffs.update", "Failed to Access Data: player_manager");
		return;
	end

	local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	if item_parameter == nil then
		error_handler.report("buffs.update", "Failed to Access Data: item_parameter");
		return;
	end

	local is_player_lobby_base = master_player:get_type_definition() == player_lobby_base_type_def;

	item_buffs.update(master_player_data, item_parameter);
	rampage_skills.update(master_player_data);
	otomo_moves.update(master_player_data);

	if not is_player_lobby_base then
		abnormal_statuses.update(master_player, master_player_data);
		endemic_life_buffs.update(master_player, master_player_data);
		dango_skills.update(master_player, master_player_data);
		skills.update(master_player, master_player_data, weapon_type);
		weapon_skills.update(master_player, master_player_data, weapon_type);
		misc_buffs.update(master_player, master_player_data, item_parameter);
	end
end

function this.update_timer(buff, timer)
	buff.is_visible = true;

	if timer == nil then
		return;
	end

	if timer < 0 then
		timer = 0;
	end

	if timer > buff.duration or timer > buff.timer then
		buff.duration = timer;
	end

	local minutes_left = math.floor(timer / 60);

	buff.timer = timer;
	buff.minutes_left = minutes_left;
	buff.seconds_left = math.floor(timer - 60 * minutes_left);

	if buff.duration ~= 0 then
		buff.timer_percentage = timer / buff.duration;
	end
end

function this.update_generic_buff(buff_list, filter_list, get_name_function, 
	buff_type, buff_key,
	value_owner, value_holder,
	timer_owner, timer_holder,
	is_infinite, minimal_value, level_breakpoints)

	if this.apply_filter(buff_list, filter_list, buff_key) then
		return;
	end

	if timer_owner == nil then timer_owner = value_owner; end
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
			error_handler.report("buffs.update_generic_number", string.format("Failed to Access Data: %s_value", buff_key));
			buff_list[buff_key] = nil;
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
			error_handler.report("buffs.update_generic_number", string.format("Failed to Access Data: %s_timer", buff_key));
			buff_list[buff_key] = nil;
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

	return this.update_generic(buff_list, get_name_function, buff_type, buff_key, level, timer);
end

function this.update_generic(buff_list, get_name_function, buff_type, buff_key, level, timer)
	level = level or 1;

	local buff = buff_list[buff_key];
	if buff == nil then
		local name = get_name_function(buff_key);

		buff = this.new(buff_type, buff_key, name, level, timer);
		buff_list[buff_key] = buff;
	else
		if buff.level ~= level then
			buff.duration = timer;
		end

		buff.level = level;
		this.update_timer(buff, timer);
	end

	return buff;
end

function this.apply_filter(buff_list, filter_list, buff_key)
	if filter_list[buff_key] then
		return false;
	end
	
	local buff = buff_list[buff_key];
	if buff == nil then
		return true;
	end

	if not buff.is_visible then
		return true;
	end

	if buff.is_infinite then
		buff_list[buff_key] = nil;
		return true;
	end

	time.new_delay_timer(function()
		
		local _buff = buff_list[buff_key];
		if _buff ~= nil and not _buff.is_visible then
			buff_list[buff_key] = nil;
		end

	end, buff.timer);

	buff.is_visible = false;
	return true;
end

function this.draw(buff, buff_UI, position_on_screen, opacity_scale)
	buff_UI_entity.draw(buff, buff_UI, position_on_screen, opacity_scale);
end

function this.init_dependencies()
	config = require("MHR_Overlay.Misc.config");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	players = require("MHR_Overlay.Damage_Meter.players");
	item_buffs = require("MHR_Overlay.Buffs.item_buffs");
	melody_effects = require("MHR_Overlay.Buffs.melody_effects");
	utils = require("MHR_Overlay.Misc.utils");
	language = require("MHR_Overlay.Misc.language");
	time = require("MHR_Overlay.Game_Handler.time");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	endemic_life_buffs = require("MHR_Overlay.Buffs.endemic_life_buffs");
	skills = require("MHR_Overlay.Buffs.skills");
	dango_skills = require("MHR_Overlay.Buffs.dango_skills");
	abnormal_statuses = require("MHR_Overlay.Buffs.abnormal_statuses");
	otomo_moves = require("MHR_Overlay.Buffs.otomo_moves");
	weapon_skills = require("MHR_Overlay.Buffs.weapon_skills");
	rampage_skills = require("MHR_Overlay.Buffs.rampage_skills");
	misc_buffs = require("MHR_Overlay.Buffs.misc_buffs");
end

function this.init_module()
	
end

return this;