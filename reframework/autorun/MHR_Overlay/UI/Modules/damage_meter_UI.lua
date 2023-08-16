local this = {};

local singletons;
local config;
local customization_menu;
local players;
local non_players;
local quest_status;
local screen;
local drawing;
local language;
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

local top_damage = 0;
local top_dps = 0;

this.displayed_players = {};
this.last_displayed_players = {};
this.freeze_displayed_players = false;

function this.update()
	local is_on_quest = quest_status.flow_state ~= quest_status.flow_states.IN_LOBBY and quest_status.flow_state ~= quest_status.flow_states.IN_TRAINING_AREA;
	local cached_config = config.current_config.damage_meter_UI;

	if this.freeze_displayed_players and not utils.table.is_empty(this.last_displayed_players) then
		this.displayed_players = this.last_displayed_players;
		return;
	end;

	if players.total.display.total_damage == 0 and cached_config.settings.hide_module_if_total_damage_is_zero then
		return;
	end

	this.displayed_players = {};

	for id, player in pairs(players.list) do
		if player ~= players.myself then
			this.add_to_displayed_players_list(player, cached_config);
		end
	end

	if not cached_config.settings.hide_servants then
		for id, servant in pairs(non_players.servant_list) do
			this.add_to_displayed_players_list(servant, cached_config);
		end
	end

	for id, otomo in pairs(non_players.otomo_list) do
		if id == players.myself.id or id == non_players.my_second_otomo_id then
			if cached_config.settings.show_my_otomos_separately then
				this.add_to_displayed_players_list(otomo, cached_config);
			end
		elseif id >= 4 then
			if cached_config.settings.show_servant_otomos_separately then
				this.add_to_displayed_players_list(otomo, cached_config);
			end
		else
			if cached_config.settings.show_other_player_otomos_separately then
				this.add_to_displayed_players_list(otomo, cached_config);
			end
		end 
	end

	this.calculate_top_damage_and_dps();
	this.sort();

	this.last_displayed_players = this.displayed_players;
end

function this.add_to_displayed_players_list(player, cached_config, position)
	cached_config = cached_config.settings;
	position = position or #(this.displayed_players) + 1;

	if player.display.total_damage == 0 and cached_config.hide_player_if_player_damage_is_zero then
		return;
	end

	if player.type == players.types.myself then
		if cached_config.hide_myself then
			return;
		end
	elseif player.type == players.types.servant then
		if cached_config.hide_servants then
			return;
		end
	elseif player.type == players.types.other_player then
		if cached_config.hide_other_players then
			return;
		end
	elseif player.type == players.types.my_otomo then
		if not cached_config.show_my_otomos_separately then
			return;
		end
	elseif player.type == players.types.other_player_otomo then
		if not cached_config.show_other_player_otomos_separately then
			return;
		end
	elseif player.type == players.types.servant_otomo then
		if not cached_config.show_servant_otomos_separately then
			return;
		end
	end

	--if position == nil then
	--	table.insert(this.displayed_players, player);
	--else
		table.insert(this.displayed_players, position, player);
	--end
end

function this.calculate_top_damage_and_dps()
	top_damage = 0;
	top_dps = 0;
	for _, player in ipairs(this.displayed_players) do
		if player.display.total_damage > top_damage then
			top_damage = player.display.total_damage;
		end

		if player.dps > top_dps then
			top_dps = player.dps;
		end
	end
end

function this.sort()
	local cached_config = config.current_config.damage_meter_UI;

	if cached_config.settings.my_damage_bar_location == "Normal" then
		table.insert(this.displayed_players, this.myself);
	end

	-- sort here
	if cached_config.sorting.type == "Normal" then
		if cached_config.sorting.reversed_order then
			table.sort(this.displayed_players, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(this.displayed_players, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif cached_config.sorting.type == "DPS" then
		if cached_config.sorting.reversed_order then
			table.sort(this.displayed_players, function(left, right)
				return left.dps < right.dps;
			end);
		else
			table.sort(this.displayed_players, function(left, right)
				return left.dps > right.dps;
			end);
		end
	else
		if cached_config.sorting.reversed_order then
			table.sort(this.displayed_players, function(left, right)
				return left.display.total_damage < right.display.total_damage;
			end);
		else
			table.sort(this.displayed_players, function(left, right)
				return left.display.total_damage > right.display.total_damage;
			end);
		end
	end

	if cached_config.settings.my_damage_bar_location == "First" then
		this.add_to_displayed_players_list(players.myself, cached_config, 1);

	elseif cached_config.settings.my_damage_bar_location == "Last" then
		this.add_to_displayed_players_list(players.myself, cached_config);
	end
end

function this.draw()
	local cached_config = config.current_config.damage_meter_UI;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	if players.total.display.total_damage == 0 and cached_config.settings.hide_module_if_total_damage_is_zero then
		return;
	end
	
	local position_on_screen = screen.calculate_absolute_coordinates(cached_config.position);

	-- draw total damage
	if  cached_config.settings.total_damage_location == "First" then
		if cached_config.settings.hide_total_damage then
			return;
		end

		if cached_config.settings.hide_total_if_total_damage_is_zero and players.total.display.total_damage == 0 then
			return;
		end

		players.draw(players.total, position_on_screen, 1, top_damage, top_dps);

		if cached_config.settings.orientation == "Horizontal" then
			position_on_screen.x = position_on_screen.x + cached_config.spacing.x * global_scale_modifier;
		else
			position_on_screen.y = position_on_screen.y + cached_config.spacing.y * global_scale_modifier;
		end
	end

	-- draw
	if not cached_config.settings.total_damage_offset_is_relative then
		position_on_screen = screen.calculate_absolute_coordinates(cached_config.position);
	end

	for _, player in ipairs(this.displayed_players) do

		players.draw(player, position_on_screen, 1, top_damage, top_dps);
		
		if cached_config.settings.orientation == "Horizontal" then
			position_on_screen.x = position_on_screen.x + cached_config.spacing.x * global_scale_modifier;
		else
			position_on_screen.y = position_on_screen.y + cached_config.spacing.y * global_scale_modifier;
		end

		::continue::
	end

	-- draw total damage
	if  cached_config.settings.total_damage_location == "Last" then
		if cached_config.settings.hide_total_damage then
			return;
		end

		if cached_config.settings.hide_total_if_total_damage_is_zero and players.total.display.total_damage == 0 then
			return;
		end

		if not cached_config.settings.total_damage_offset_is_relative then
			position_on_screen = screen.calculate_absolute_coordinates(cached_config.position);
		end

		players.draw(players.total, position_on_screen, 1);
	end
end

function this.init_dependencies()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	config = require("MHR_Overlay.Misc.config");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	players = require("MHR_Overlay.Damage_Meter.players");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
	language = require("MHR_Overlay.Misc.language");
	utils = require("MHR_Overlay.Misc.utils");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
end

return this;
