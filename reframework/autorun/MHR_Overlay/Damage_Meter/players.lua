local players = {};
local config;
local table_helpers;
local singletons;
local customization_menu;
local damage_UI_entity;
local time;
local quest_status;
local drawing;
local language;
local non_players;

players.list = {};
players.myself = nil;
players.myself_position = Vector3f.new(0, 0, 0);
players.total = nil;

players.display_list = {};

players.highlighted_damage_UI = nil;

players.types = {
	["myself"] = 0,
	["other_player"] = 1,
	["servant"] = 2,
	["my_otomo"] = 4,
	["other_player_otomo"] = 8,
	["servant_otomo"] = 16,
	["total"] = 32,
	["highlight"] = 64

}

function players.new(id, name, master_rank, hunter_rank, type)
	local player = {};
	player.id = id;
	player.name = name;
	player.hunter_rank = hunter_rank;
	player.master_rank = master_rank;

	player.type = type;

	player.cart_count = 0;

	player.join_time = -1;
	player.first_hit_time = -1;
	player.dps = 0;

	player.small_monsters = players.init_damage_sources()
	player.large_monsters = players.init_damage_sources();
	
	player.display = {};
	player.display.total_damage = 0;
	player.display.physical_damage = 0;
	player.display.elemental_damage = 0;
	player.display.ailment_damage = 0;

	players.init_UI(player);

	return player;
end

function players.init_damage_sources()
	local monster_type = {};

	monster_type.total_damage = 0;
	monster_type.physical_damage = 0;
	monster_type.elemental_damage = 0;
	monster_type.ailment_damage = 0;

	monster_type.bombs = {};
	monster_type.bombs.total_damage = 0;
	monster_type.bombs.physical_damage = 0;
	monster_type.bombs.elemental_damage = 0;
	monster_type.bombs.ailment_damage = 0;

	monster_type.kunai = {};
	monster_type.kunai.total_damage = 0;
	monster_type.kunai.physical_damage = 0;
	monster_type.kunai.elemental_damage = 0;
	monster_type.kunai.ailment_damage = 0;

	monster_type.installations = {};
	monster_type.installations.total_damage = 0;
	monster_type.installations.physical_damage = 0;
	monster_type.installations.elemental_damage = 0;
	monster_type.installations.ailment_damage = 0;

	monster_type.otomo = {};
	monster_type.otomo.total_damage = 0;
	monster_type.otomo.physical_damage = 0;
	monster_type.otomo.elemental_damage = 0;
	monster_type.otomo.ailment_damage = 0;

	monster_type.wyvern_riding = {};
	monster_type.wyvern_riding.total_damage = 0;
	monster_type.wyvern_riding.physical_damage = 0;
	monster_type.wyvern_riding.elemental_damage = 0;
	monster_type.wyvern_riding.ailment_damage = 0;

	monster_type.poison = {};
	monster_type.poison.total_damage = 0;
	monster_type.poison.physical_damage = 0;
	monster_type.poison.elemental_damage = 0;
	monster_type.poison.ailment_damage = 0;

	monster_type.otomo_poison = {};
	monster_type.otomo_poison.total_damage = 0;
	monster_type.otomo_poison.physical_damage = 0;
	monster_type.otomo_poison.elemental_damage = 0;
	monster_type.otomo_poison.ailment_damage = 0;


	monster_type.blast = {};
	monster_type.blast.total_damage = 0;
	monster_type.blast.physical_damage = 0;
	monster_type.blast.elemental_damage = 0;
	monster_type.blast.ailment_damage = 0;

	monster_type.otomo_blast = {};
	monster_type.otomo_blast.total_damage = 0;
	monster_type.otomo_blast.physical_damage = 0;
	monster_type.otomo_blast.elemental_damage = 0;
	monster_type.otomo_blast.ailment_damage = 0;

	monster_type.endemic_life = {};
	monster_type.endemic_life.total_damage = 0;
	monster_type.endemic_life.physical_damage = 0;
	monster_type.endemic_life.elemental_damage = 0;
	monster_type.endemic_life.ailment_damage = 0;

	monster_type.other = {};
	monster_type.other.total_damage = 0;
	monster_type.other.physical_damage = 0;
	monster_type.other.elemental_damage = 0;
	monster_type.other.ailment_damage = 0;

	return monster_type;
end

function players.get_player(player_id)
	if player_id == non_players.my_second_otomo_id then
		return players.myself;
	end

	return players.list[player_id];
end

function players.update_damage(player, damage_source_type, is_large_monster, damage_object)
	if player == nil then
		return;
	end

	if player.first_hit_time == -1 then
		player.first_hit_time = time.total_elapsed_script_seconds;
	end

	local player_monster_type = player.small_monsters;
	if is_large_monster then
		player_monster_type = player.large_monsters;
	end

	if damage_source_type == "player" then
		players.merge_damage(player_monster_type, damage_object);
	elseif damage_source_type == "bomb" then
		players.merge_damage(player_monster_type.bombs, damage_object);
	elseif damage_source_type == "kunai" then
		players.merge_damage(player_monster_type.kunai, damage_object);
	elseif damage_source_type == "installation" then
		players.merge_damage(player_monster_type.installations, damage_object);
	elseif damage_source_type == "otomo" then
		players.merge_damage(player_monster_type.otomo, damage_object);
	elseif damage_source_type == "wyvern riding" then
		players.merge_damage(player_monster_type.wyvern_riding, damage_object);
	elseif damage_source_type == "poison" then
		players.merge_damage(player_monster_type.poison, damage_object);
	elseif damage_source_type == "blast" then
		players.merge_damage(player_monster_type.blast, damage_object);
	elseif damage_source_type == "otomo poison" then
		players.merge_damage(player_monster_type.otomo_poison, damage_object);
	elseif damage_source_type == "otomo blast" then
		players.merge_damage(player_monster_type.otomo_blast, damage_object);
	elseif damage_source_type == "endemic life" then
		players.merge_damage(player_monster_type.endemic_life, damage_object);
	elseif damage_source_type == "other" then
		players.merge_damage(player_monster_type.other, damage_object);
	else
		players.merge_damage(player_monster_type, damage_object);
	end

	players.update_display(player);
end

function players.update_display(player)
	if player == nil then
		return;
	end

	local cached_config = config.current_config.damage_meter_UI;

	player.display.total_damage = 0;
	player.display.physical_damage = 0;
	player.display.elemental_damage = 0;
	player.display.ailment_damage = 0;

	local monster_types = {};

	if cached_config.tracked_monster_types.small_monsters then
		table.insert(monster_types, player.small_monsters);
	end

	if cached_config.tracked_monster_types.large_monsters then
		table.insert(monster_types, player.large_monsters);
	end

	for _, monster_type in ipairs(monster_types) do
		if cached_config.tracked_damage_types.player_damage then
			players.merge_damage(player.display, monster_type);
		end

		if cached_config.tracked_damage_types.bomb_damage then
			players.merge_damage(player.display, monster_type.bombs);
		end

		if cached_config.tracked_damage_types.kunai_damage then
			players.merge_damage(player.display, monster_type.kunai);
		end

		if cached_config.tracked_damage_types.installation_damage then
			players.merge_damage(player.display, monster_type.installations);
		end

		if cached_config.tracked_damage_types.otomo_damage then
			if player.type == players.types.myself then

				if not cached_config.settings.show_my_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo);
				end
			elseif player.type == players.types.other_player then

				if not cached_config.settings.show_other_player_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo);
				end
			elseif player.type == players.types.servant then
				
				if not cached_config.settings.show_servant_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo);
				end
			elseif player.type == players.types.my_otomo then

				if cached_config.settings.show_my_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo);
				end
			elseif player.type == players.types.other_player_otomo then

				if cached_config.settings.show_other_player_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo);
				end
			elseif player.type == players.types.servant_otomo then

				if cached_config.settings.show_servant_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo);
				end
			elseif player.type == players.types.total then

				players.merge_damage(player.display, monster_type.otomo);
			end
		end

		if cached_config.tracked_damage_types.wyvern_riding_damage then
			players.merge_damage(player.display, monster_type.wyvern_riding);
		end

		if cached_config.tracked_damage_types.poison_damage then
			players.merge_damage(player.display, monster_type.poison);

			if player.type == players.types.myself then

				if not cached_config.settings.show_my_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo_poison);
				end
			elseif player.type == players.types.other_player then

				if not cached_config.settings.show_other_player_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo_poison);
				end
			elseif player.type == players.types.servant then

				if not cached_config.settings.show_servant_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo_poison);
				end
			elseif player.type == players.types.my_otomo then

				if cached_config.settings.show_my_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo_poison);
				end
			elseif player.type == players.types.other_player_otomo then

				if cached_config.settings.show_other_player_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo_poison);
				end
			elseif player.type == players.types.servant_otomo then

				if cached_config.settings.show_servant_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo_poison);
				end

			elseif player.type == players.types.total then
				
				players.merge_damage(player.display, monster_type.otomo_poison);
			end
		end

		if cached_config.tracked_damage_types.blast_damage then
			players.merge_damage(player.display, monster_type.blast);

			if player.type == players.types.myself then

				if not cached_config.settings.show_my_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo_blast);
				end
			elseif player.type == players.types.other_player then

				if not cached_config.settings.show_other_player_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo_blast);
				end
			elseif player.type == players.types.servant then

				if not cached_config.settings.show_servant_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo_blast);
				end
			elseif player.type == players.types.my_otomo then

				if cached_config.settings.show_my_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo_blast);
				end
			elseif player.type == players.types.other_player_otomo then

				if cached_config.settings.show_other_player_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo_blast);
				end
			elseif player.type == players.types.servant_otomo then

				if cached_config.settings.show_servant_otomos_separately then
					players.merge_damage(player.display, monster_type.otomo_blast);
				end
			elseif player.type == players.types.total then
				
				players.merge_damage(player.display, monster_type.otomo_blast);
			end
		end

		if cached_config.tracked_damage_types.endemic_life_damage then
			players.merge_damage(player.display, monster_type.endemic_life);
		end

		if cached_config.tracked_damage_types.other_damage then
			players.merge_damage(player.display, monster_type.other);
		end
	end
end

function players.merge_damage(first, second)
	first.total_damage = first.total_damage + second.total_damage;
	first.physical_damage = first.physical_damage + second.physical_damage;
	first.elemental_damage = first.elemental_damage + second.elemental_damage;
	first.ailment_damage = first.ailment_damage + second.ailment_damage;

	return first;
end

function players.update_dps(bypass_freeze)
	local cached_config = config.current_config.damage_meter_UI.settings;

	if cached_config.freeze_dps_on_quest_end and quest_status.flow_state >= quest_status.flow_states.KILLCAM and not bypass_freeze then
		return;
	end

	players.total.dps = 0;
	for _, player in pairs(players.list) do
		players.update_player_dps(player);
	end

	for _, servant in pairs(non_players.servant_list) do
		players.update_player_dps(servant);
	end

	for _, otomo in pairs(non_players.otomo_list) do
		players.update_player_dps(otomo);
	end
end

function players.update_player_dps(player)
	local cached_config = config.current_config.damage_meter_UI.settings;

	if player.join_time == -1 then
		player.join_time = time.total_elapsed_script_seconds;
	end

	if cached_config.dps_mode == "Quest Time" then
		if time.total_elapsed_seconds > 0 then
			player.dps = player.display.total_damage / time.total_elapsed_seconds;
		end
	elseif cached_config.dps_mode == "Join Time" then
		if time.total_elapsed_script_seconds - player.join_time > 0 then
			player.dps = player.display.total_damage / (time.total_elapsed_script_seconds - player.join_time);
		end
	elseif cached_config.dps_mode == "First Hit" then
		if time.total_elapsed_script_seconds - player.first_hit_time > 0 then
			player.dps = player.display.total_damage / (time.total_elapsed_script_seconds - player.first_hit_time);
		end
	end

	players.total.dps = players.total.dps + player.dps;
end

function players.sort_players()
	local cached_config = config.current_config.damage_meter_UI;

	if cached_config.settings.my_damage_bar_location == "Normal" then
		table.insert(players.display_list, players.myself);
	end

	-- sort here
	if cached_config.sorting.type == "Normal" then
		if cached_config.sorting.reversed_order then
			table.sort(players.display_list, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(players.display_list, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif cached_config.sorting.type == "DPS" then
		if cached_config.sorting.reversed_order then
			table.sort(players.display_list, function(left, right)
				return left.dps < right.dps;
			end);
		else
			table.sort(players.display_list, function(left, right)
				return left.dps > right.dps;
			end);
		end
	else
		if cached_config.sorting.reversed_order then
			table.sort(players.display_list, function(left, right)
				return left.display.total_damage < right.display.total_damage;
			end);
		else
			table.sort(players.display_list, function(left, right)
				return left.display.total_damage > right.display.total_damage;
			end);
		end
	end

	if cached_config.settings.my_damage_bar_location == "First" then
		table.insert(players.display_list, 1, players.myself);

	elseif cached_config.settings.my_damage_bar_location == "Last" then
		table.insert(players.display_list, players.myself);
	end
end

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local find_master_player_method = player_manager_type_def:get_method("findMasterPlayer");

local player_base_type_def = sdk.find_type_definition("snow.player.PlayerBase");
local get_pos_field = player_base_type_def:get_method("get_Pos");

function players.update_myself_position()
	if singletons.player_manager == nil then
		customization_menu.status = "No player manager";
		return;
	end

	local master_player = find_master_player_method:call(singletons.player_manager);
	if master_player == nil then
		customization_menu.status = "No master player";
		return;
	end

	local position = get_pos_field:call(master_player);
	if position ~= nil then
		players.myself_position = position;
	end
end

function players.init()
	players.list = {};
	players.display_list = {};
	players.total = players.new(0, "Total", 0, 0, players.types.total);
	players.myself = players.new(-1, "Dummy", -1, -1, players.types.myself);
end

local lobby_manager_type_def = sdk.find_type_definition("snow.LobbyManager");
local my_hunter_info_field = lobby_manager_type_def:get_field("_myHunterInfo");
local myself_quest_index_field = lobby_manager_type_def:get_field("_myselfQuestIndex");

local quest_hunter_info_field = lobby_manager_type_def:get_field("_questHunterInfo");
local hunter_info_field = lobby_manager_type_def:get_field("_hunterInfo");

local my_hunter_info_type_def = my_hunter_info_field:get_type();
local name_field = my_hunter_info_type_def:get_field("_name");
local hunter_unique_id_field = my_hunter_info_type_def:get_field("_HunterUniqueId");
local member_index_field = my_hunter_info_type_def:get_field("_memberIndex");
local hunter_rank_field = my_hunter_info_type_def:get_field("_hunterRank");
local master_rank_field = my_hunter_info_type_def:get_field("_masterRank");

local hunter_info_type_def = hunter_info_field:get_type();
local get_count_method = hunter_info_type_def:get_method("get_Count");
local get_item_method = hunter_info_type_def:get_method("get_Item");

local guid_type = hunter_unique_id_field:get_type();
local guid_equals_method = guid_type:get_method("Equals(System.Guid)");

local progress_manager_type_def = sdk.find_type_definition("snow.progress.ProgressManager");
local get_hunter_rank_method = progress_manager_type_def:get_method("get_HunterRank");
local get_master_rank_method = progress_manager_type_def:get_method("get_MasterRank");

local get_master_player_id_method = player_manager_type_def:get_method("getMasterPlayerID");

function players.update_player_list(is_on_quest)
	if is_on_quest then
		players.update_player_list_(quest_hunter_info_field);
	else
		players.update_player_list_(hunter_info_field);
	end
end

function players.update_player_list_(hunter_info_field_)
	local cached_config = config.current_config.damage_meter_UI;

	if singletons.lobby_manager == nil then
		return;
	end

	if singletons.progress_manager == nil then
		return;
	end

	-- myself player
	local myself_player_info = my_hunter_info_field:get_data(singletons.lobby_manager);
	if myself_player_info == nil then
		customization_menu.status = "No myself player info list";
		return;
	end

	local myself_player_name = name_field:get_data(myself_player_info);
	if myself_player_name == nil then
		customization_menu.status = "No myself player name";
		return;
	end

	local myself_hunter_rank = get_hunter_rank_method:call(singletons.progress_manager) or 0;
	local myself_master_rank = get_master_rank_method:call(singletons.progress_manager) or 0;

	local myself_id = get_master_player_id_method:call(singletons.player_manager);

	if myself_id == nil then
		customization_menu.status = "No myself player id";
		return;
	end

	if players.myself == nil or myself_id ~= players.myself.id then
		players.list[players.myself.id] = nil;
		players.myself = players.new(myself_id, myself_player_name, myself_master_rank, myself_hunter_rank, players.types.myself);
		players.list[myself_id] = players.myself;
	end

	-- other players
	local player_info_list = hunter_info_field_:get_data(singletons.lobby_manager);
	if player_info_list == nil then
		customization_menu.status = "No player info list";
		return;
	end

	local count = get_count_method:call(player_info_list);
	if count == nil then
		customization_menu.status = "No player info list count";
		return;
	end

	for i = 0, count - 1 do
		local player_info = get_item_method:call(player_info_list, i);
		if player_info == nil then
			goto continue
		end

		local id = member_index_field:get_data(player_info);

		if id == nil then
			goto continue
		end

		local hunter_rank = hunter_rank_field:get_data(player_info) or 0;
		local master_rank = master_rank_field:get_data(player_info) or 0;

		local name = name_field:get_data(player_info);
		if name == nil then
			goto continue
		end

		local player = players.list[id];

		if player == nil or (player.name ~= name and player.hunter_rank ~= hunter_rank and player.master_rank ~= master_rank) then
			if player ~= nil then
				if player.name == players.myself.name  then
					player = players.new(id, name, master_rank, hunter_rank, players.types.myself);
					players.myself = player;
					players.list[id] = player;
				end
			else
				player = players.new(id, name, master_rank, hunter_rank, players.types.other_player);
				players.list[id] = player;
			end
		end

		if player ~= players.myself then
			table.insert(players.display_list, player);
		end

		::continue::
	end
end

function players.init_UI(player)
	local cached_config = config.current_config.damage_meter_UI;

	if player.type == players.types.myself then
		player.damage_UI = damage_UI_entity.new(cached_config.myself, player.type);
	elseif player.type == players.types.other_player then
		player.damage_UI = damage_UI_entity.new(cached_config.other_players, player.type);
	elseif player.type == players.types.total then
		player.damage_UI = damage_UI_entity.new(cached_config.total, player.type);
	end
end

function players.init_highlighted_UI()
	local cached_config = config.current_config.damage_meter_UI;

	players.highlighted_damage_UI = damage_UI_entity.new(cached_config.highlighted, players.types.highlight);
end

function players.draw(player, position_on_screen, opacity_scale, top_damage, top_dps)
	damage_UI_entity.draw(player, position_on_screen, opacity_scale, top_damage, top_dps);
end

function players.init_module()
	config = require("MHR_Overlay.Misc.config");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	damage_UI_entity = require("MHR_Overlay.UI.UI_Entities.damage_UI_entity");
	time = require("MHR_Overlay.Game_Handler.time");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	drawing = require("MHR_Overlay.UI.drawing");
	language = require("MHR_Overlay.Misc.language");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");

	players.init();
end

return players;
