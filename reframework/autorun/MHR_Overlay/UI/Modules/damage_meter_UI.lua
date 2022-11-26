local damage_meter_UI = {};
local singletons;
local config;
local customization_menu;
local player;
local non_players;
local quest_status;
local screen;
local drawing;
local language;
local table_helpers;

damage_meter_UI.last_displayed_players = {};
damage_meter_UI.freeze_displayed_players = false;

local lobby_manager_type_def = sdk.find_type_definition("snow.LobbyManager");
local quest_hunter_info_field = lobby_manager_type_def:get_field("_questHunterInfo");
local hunter_info_field = lobby_manager_type_def:get_field("_hunterInfo");

local quest_hunter_info_type_def = quest_hunter_info_field:get_type();
local get_count_method = quest_hunter_info_type_def:get_method("get_Count");
local get_item_method = quest_hunter_info_type_def:get_method("get_Item");

local hunter_info_type_def = sdk.find_type_definition("snow.LobbyManager.HunterInfo");
local member_index_field = hunter_info_type_def:get_field("_memberIndex");

function damage_meter_UI.get_players(player_info_list)
	local cached_config = config.current_config.damage_meter_UI;

	-- other players
	if player_info_list == nil then
		customization_menu.status = "No player info list";
		return {};
	end

	local quest_players = {};

	local count = get_count_method:call(player_info_list);

	if count == nil then
		customization_menu.status = "No player info list count";
		return {};
	end

	for i = 0, count - 1 do
		local player_info = get_item_method:call(player_info_list, i);

		if player_info == nil then
			goto continue
		end

		local player_id = member_index_field:get_data(player_info);
		if player_id == nil then
			goto continue
		end

		local _player = player.get_player(player_id);
		if _player ~= nil then
			if _player == player.myself and cached_config.settings.my_damage_bar_location ~= "Normal" then
				goto continue
			end
			table.insert(quest_players, _player);
		end

		::continue::
	end

	if cached_config.settings.show_followers_separately then
		for id, non_player in pairs(non_players.servant_list) do
			table.insert(quest_players, non_player);
		end
	end

	return quest_players;
end

function damage_meter_UI.draw()
	local cached_config = config.current_config.damage_meter_UI;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	if player.total.display.total_damage == 0 and cached_config.settings.hide_module_if_total_damage_is_zero then
		return;
	end

	local quest_players = {};
	if damage_meter_UI.freeze_displayed_players and damage_meter_UI.last_displayed_players ~= {} then
		quest_players = damage_meter_UI.last_displayed_players;
	elseif quest_status.flow_state == quest_status.flow_states.IN_LOBBY or quest_status.flow_state == quest_status.flow_states.IN_TRAINING_AREA then
		local player_info_list = hunter_info_field:get_data(singletons.lobby_manager);
		quest_players = damage_meter_UI.get_players(player_info_list);
	else
		local player_info_list = quest_hunter_info_field:get_data(singletons.lobby_manager);
		quest_players = damage_meter_UI.get_players(player_info_list);
	end

	if not damage_meter_UI.freeze_displayed_players then
		if #quest_players ~= 0 then
			-- sort here
			if cached_config.sorting.type == "Normal" then
				if cached_config.sorting.reversed_order then
					local reversed_quest_players = {};
					for i = #quest_players, 1, -1 do
						table.insert(reversed_quest_players, quest_players[i]);
					end
					quest_players = reversed_quest_players;
				end
			elseif cached_config.sorting.type == "DPS" then
				if cached_config.sorting.reversed_order then
					table.sort(quest_players, function(left, right)
						return left.dps < right.dps;
					end);
				else
					table.sort(quest_players, function(left, right)
						return left.dps > right.dps;
					end);
				end
			else
				if cached_config.sorting.reversed_order then
					table.sort(quest_players, function(left, right)
						return left.display.total_damage < right.display.total_damage;
					end);
				else
					table.sort(quest_players, function(left, right)
						return left.display.total_damage > right.display.total_damage;
					end);
				end
			end
		end

		if cached_config.settings.my_damage_bar_location == "First" then
			table.insert(quest_players, 1, player.myself);
		elseif cached_config.settings.my_damage_bar_location == "Last" then
			table.insert(quest_players, #quest_players + 1, player.myself);
		elseif #player.list == 0 then
			table.insert(quest_players, player.myself);
		end
		
		damage_meter_UI.last_displayed_players = quest_players;
	end

	local top_damage = 0;
	local top_dps = 0;
	for _, _player in ipairs(quest_players) do
		if _player.display.total_damage > top_damage then
			top_damage = _player.display.total_damage;
		end

		if _player.dps > top_dps then
			top_dps = _player.dps;
		end
	end

	local position_on_screen = screen.calculate_absolute_coordinates(cached_config.position);

	-- draw total damage
	if  cached_config.settings.total_damage_location == "First" then
		if cached_config.settings.hide_total_damage then
			return;
		end

		if cached_config.settings.hide_total_if_total_damage_is_zero and player.total.display.total_damage == 0 then
			return;
		end

		player.draw_total(position_on_screen, 1);

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
	
	for _, _player in ipairs(quest_players) do
		if _player.display.total_damage == 0 and cached_config.settings.hide_player_if_player_damage_is_zero then
			goto continue
		end

		if _player == player.myself then
			if cached_config.settings.hide_myself then
				goto continue
			end
		elseif cached_config.settings.hide_other_players then
			goto continue
		end

		if _player.is_player then
			player.draw(_player, position_on_screen, 1, top_damage, top_dps);
		else
			non_players.draw(_player, position_on_screen, 1, top_damage, top_dps);
		end
		

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

		if cached_config.settings.hide_total_if_total_damage_is_zero and player.total.display.total_damage == 0 then
			return;
		end

		if not cached_config.settings.total_damage_offset_is_relative then
			position_on_screen = screen.calculate_absolute_coordinates(cached_config.position);
		end

		player.draw_total(position_on_screen, 1);
	end
end

function damage_meter_UI.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	config = require("MHR_Overlay.Misc.config");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	player = require("MHR_Overlay.Damage_Meter.player");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
	language = require("MHR_Overlay.Misc.language");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
end

return damage_meter_UI;
