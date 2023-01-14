local damage_meter_UI = {};
local singletons;
local config;
local customization_menu;
local players;
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

function damage_meter_UI.draw()
	local cached_config = config.current_config.damage_meter_UI;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	if players.total.display.total_damage == 0 and cached_config.settings.hide_module_if_total_damage_is_zero then
		return;
	end

	local quest_players = {};
	
	if damage_meter_UI.freeze_displayed_players and not table_helpers.is_empty(damage_meter_UI.last_displayed_players) then
		quest_players = damage_meter_UI.last_displayed_players;
	else
		quest_players = players.display_list;
	end

	damage_meter_UI.last_displayed_players = quest_players;

	local top_damage = 0;
	local top_dps = 0;
	for _, player in ipairs(quest_players) do
		if player.display.total_damage > top_damage then
			top_damage = player.display.total_damage;
		end

		if player.dps > top_dps then
			top_dps = player.dps;
		end
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
	
	
	for _, player in ipairs(quest_players) do
		
		if player.display.total_damage == 0 and cached_config.settings.hide_player_if_player_damage_is_zero then
			goto continue
		end

		if player.type == players.types.myself then
			if cached_config.settings.hide_myself then
				goto continue
			end
		elseif player.type == players.types.servant then
			if cached_config.settings.hide_servants then
				goto continue
			end
		elseif player.type == players.types.other_player then
			if cached_config.settings.hide_other_players then
				goto continue
			end
		elseif player.type == players.types.my_otomo then
			if not cached_config.settings.show_my_otomos_separately then
				goto continue
			end
		elseif player.type == players.types.other_player_otomo then
			if not cached_config.settings.show_other_player_otomos_separately then
				goto continue
			end
		elseif player.type == players.types.servant_otomo then
			if not cached_config.settings.show_servant_otomos_separately then
				goto continue
			end
		end

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

function damage_meter_UI.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	config = require("MHR_Overlay.Misc.config");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	players = require("MHR_Overlay.Damage_Meter.players");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
	language = require("MHR_Overlay.Misc.language");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
end

return damage_meter_UI;
