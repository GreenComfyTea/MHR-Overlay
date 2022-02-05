local damage_meter_UI = {};
local singletons;
local config;
local customization_menu;
local player;
local quest_status;
local screen;
local drawing;

damage_meter_UI.last_displayed_players = {};

function damage_meter_UI.draw()

	if player.total.display.total_damage == 0 and config.current_config.damage_meter_UI.settings.hide_module_if_total_damage_is_zero then
		return;
	end

	if singletons.lobby_manager == nil then
		return;
	end
	
	if singletons.progress_manager == nil then
		return;
	end

	-- myself player
	local myself_player_info = singletons.lobby_manager:get_field("_myHunterInfo");
	if myself_player_info == nil then
		customization_menu.status = "No myself player info list";
		return;
	end

	local myself_player_name = myself_player_info:get_field("_name");
	if myself_player_name == nil then
		customization_menu.status = "No myself player name";
		return;
	end

	if quest_status.is_online then
		player.myself_id = singletons.lobby_manager:get_field("_myselfQuestIndex");
		if player.myself_id == nil then
			customization_menu.status = "No myself player id";
			return;
		end
	else
		player.myself_id = singletons.lobby_manager:get_field("_myselfIndex");
		if player.myself_id == nil then
			customization_menu.status = "No myself player id";
			return;
		end
	end

	local myself_hunter_rank = singletons.progress_manager:call("get_HunterRank");
	if myself_hunter_rank == nil then
		customization_menu.status = "No myself hunter rank";
		myself_hunter_rank = 0;
	end

	if player.list[player.myself_id] == nil then
		player.list[player.myself_id] = player.new(player.myself_id, myself_player_name, myself_hunter_rank);
		player.myself = player.list[player.myself_id];
	end

	local quest_players = {};

	if quest_status.index > 2 then
		quest_players = damage_meter_UI.last_displayed_players;
	else
		-- other players
		local player_info_list = singletons.lobby_manager:get_field("_questHunterInfo");
		if player_info_list == nil then
			customization_menu.status = "No player info list";
		end

		local count = player_info_list:call("get_Count");
		if count == nil then
			customization_menu.status = "No player info list count";
			return;
		end

		for i = 0, count - 1 do
			
			local player_info = player_info_list:call("get_Item", i);
			if player_info == nil then
				goto continue
			end

			local player_id = player_info:get_field("_memberIndex");
			if player_id == nil then

				goto continue
			end

			local player_hunter_rank = player_info:get_field("_hunterRank");
			if player_hunter_rank == nil then
				goto continue
			end

			if player_id == player.myself_id and config.current_config.damage_meter_UI.settings.my_damage_bar_location ~= "Normal" then
				player.list[player.myself_id].hunter_rank = player_hunter_rank;
				goto continue
			end

			local player_name = player_info:get_field("_name");
			if player_name == nil then
				goto continue
			end

			if player.list[player_id] == nil then
				player.list[player_id] = player.new(player_id, player_name, player_hunter_rank);
			elseif player.list[player_id].name ~= player_name then
				player.list[player_id] = player.new(player_id, player_name, player_hunter_rank);
			end

			table.insert(quest_players, player.list[player_id]);

			::continue::
		end

		-- sort here
		if config.current_config.damage_meter_UI.sorting.type == "Normal" and config.current_config.damage_meter_UI.sorting.reversed_order then

			local reversed_quest_players = {};
			for i = #quest_players, 1, -1 do
				table.insert(reversed_quest_players, quest_players[i]);
			end
			quest_players = reversed_quest_players;
		elseif config.current_config.damage_meter_UI.sorting.type == "Damage" then
			if config.current_config.damage_meter_UI.sorting.reversed_order then
				table.sort(quest_players, function(left, right)
					return left.display.total_damage < right.display.total_damage;
				end);
			else
				table.sort(quest_players, function(left, right)
					return left.display.total_damage > right.display.total_damage;
				end);
			end
		end
		
		if config.current_config.damage_meter_UI.settings.my_damage_bar_location == "First" then
			table.insert(quest_players, 1, player.list[player.myself_id]);
		elseif config.current_config.damage_meter_UI.settings.my_damage_bar_location == "Last" then
			table.insert(quest_players, #quest_players + 1, player.list[player.myself_id]);
		elseif #quest_players == 0 then
			table.insert(quest_players, 1, player.list[player.myself_id]);
		end

		damage_meter_UI.last_displayed_players = quest_players;
	end

	local top_damage = 0;
	for _, _player in ipairs(quest_players) do
		if _player.display.total_damage > top_damage then
			top_damage = _player.display.total_damage;
		end
	end

	-- draw
	local position_on_screen = screen.calculate_absolute_coordinates(config.current_config.damage_meter_UI.position);
	for _, _player in ipairs(quest_players) do
		
		if _player.display.total_damage == 0 and config.current_config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero then
			goto continue1
		end

		player.draw(_player, position_on_screen, 1, top_damage);

		if config.current_config.damage_meter_UI.settings.orientation == "Horizontal" then
			position_on_screen.x = position_on_screen.x + config.current_config.damage_meter_UI.spacing.x;
		else
			position_on_screen.y = position_on_screen.y + config.current_config.damage_meter_UI.spacing.y;
		end

		::continue1::

	end

	-- draw total damage
	if not config.current_config.damage_meter_UI.settings.total_damage_offset_is_relative then
		position_on_screen = screen.calculate_absolute_coordinates(config.current_config.damage_meter_UI.position);
	end

	drawing.draw_label(config.current_config.damage_meter_UI.total_damage_label, position_on_screen, 1);
	drawing.draw_label(config.current_config.damage_meter_UI.total_damage_value_label, position_on_screen, 1, player.total.display.total_damage);

end

function damage_meter_UI.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	config = require("MHR_Overlay.Misc.config");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	player = require("MHR_Overlay.Damage_Meter.player");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
end

return damage_meter_UI;