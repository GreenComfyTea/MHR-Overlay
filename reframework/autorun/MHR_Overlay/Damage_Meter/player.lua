local player = {};
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

player.list = {};
player.myself = nil;
player.myself_position = Vector3f.new(0, 0, 0);
player.total = nil;

player.display_list = {}

function player.new(id, name, master_rank, hunter_rank)
	local new_player = {};
	new_player.id = id;
	new_player.name = name; -- 齁ODO
	new_player.hunter_rank = hunter_rank;
	new_player.master_rank = master_rank;

	new_player.is_player = true;

	new_player.cart_count = 0;

	new_player.join_time = -1;
	new_player.first_hit_time = -1;
	new_player.dps = 0;

	new_player.small_monsters = player.init_damage_sources()
	new_player.large_monsters = player.init_damage_sources();
	
	new_player.display = {};
	new_player.display.total_damage = 0;
	new_player.display.physical_damage = 0;
	new_player.display.elemental_damage = 0;
	new_player.display.ailment_damage = 0;

	if name == "Total" then
		player.init_total_UI(new_player);
	else
		player.init_UI(new_player);
	end

	return new_player;
end

function player.init_damage_sources()
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

	monster_type.blast = {};
	monster_type.blast.total_damage = 0;
	monster_type.blast.physical_damage = 0;
	monster_type.blast.elemental_damage = 0;
	monster_type.blast.ailment_damage = 0;

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

function player.get_player(player_id)
	return player.list[player_id];
end

function player.update_damage(_player, damage_source_type, is_large_monster, damage_object)
	if _player == nil then
		return;
	end

	if _player.first_hit_time == -1 then
		_player.first_hit_time = time.total_elapsed_script_seconds;
	end

	local player_monster_type = _player.small_monsters;
	if is_large_monster then
		player_monster_type = _player.large_monsters;
	end

	if damage_source_type == "player" then
		player.merge_damage(player_monster_type, damage_object);
	elseif damage_source_type == "bomb" then
		player.merge_damage(player_monster_type.bombs, damage_object);
	elseif damage_source_type == "kunai" then
		player.merge_damage(player_monster_type.kunai, damage_object);
	elseif damage_source_type == "installation" then
		player.merge_damage(player_monster_type.installations, damage_object);
	elseif damage_source_type == "otomo" then
		player.merge_damage(player_monster_type.otomo, damage_object);
	elseif damage_source_type == "wyvern riding" then
		player.merge_damage(player_monster_type.wyvern_riding, damage_object);
	elseif damage_source_type == "poison" then
		player.merge_damage(player_monster_type.poison, damage_object);
	elseif damage_source_type == "blast" then
		player.merge_damage(player_monster_type.blast, damage_object);
	elseif damage_source_type == "endemic life" then
		player.merge_damage(player_monster_type.endemic_life, damage_object);
	elseif damage_source_type == "other" then
		player.merge_damage(player_monster_type.other, damage_object);
	else
		player.merge_damage(player_monster_type, damage_object);
	end

	player.update_display(_player);
end

function player.update_display(_player)
	if _player == nil then
		return;
	end

	_player.display.total_damage = 0;
	_player.display.physical_damage = 0;
	_player.display.elemental_damage = 0;
	_player.display.ailment_damage = 0;

	local cached_config = config.current_config.damage_meter_UI;

	if cached_config.tracked_monster_types.small_monsters then
		if cached_config.tracked_damage_types.player_damage then
			player.merge_damage(_player.display, _player.small_monsters);
		end

		if cached_config.tracked_damage_types.bomb_damage then
			player.merge_damage(_player.display, _player.small_monsters.bombs);
		end

		if cached_config.tracked_damage_types.kunai_damage then
			player.merge_damage(_player.display, _player.small_monsters.kunai);
		end

		if cached_config.tracked_damage_types.installation_damage then
			player.merge_damage(_player.display, _player.small_monsters.installations);
		end

		if cached_config.tracked_damage_types.otomo_damage then
			if _player.is_otomo then
				if _player.id == player.myself.id or _player.id == non_players.my_second_otomo_id then

					if cached_config.settings.show_my_otomos_separately then
						player.merge_damage(_player.display, _player.small_monsters.otomo);
					end
				elseif _player.is_servant then

					if cached_config.settings.show_servant_otomos_separately then
						player.merge_damage(_player.display, _player.small_monsters.otomo);
					end
				else

					if cached_config.settings.show_other_player_otomos_separately then
						player.merge_damage(_player.display, _player.small_monsters.otomo);
					end
				end
			else
				if _player == player.myself then

					if not cached_config.settings.show_my_otomos_separately then
						player.merge_damage(_player.display, _player.small_monsters.otomo);
					end
				elseif _player.is_servant then

					if not cached_config.settings.show_servant_otomos_separately then
						player.merge_damage(_player.display, _player.small_monsters.otomo);
					end
				else

					if not cached_config.settings.show_other_player_otomos_separately then
						player.merge_damage(_player.display, _player.small_monsters.otomo);
					end
				end

			end
		end

		if cached_config.tracked_damage_types.wyvern_riding_damage then
			player.merge_damage(_player.display, _player.small_monsters.wyvern_riding);
		end

		if cached_config.tracked_damage_types.poison_damage then
			player.merge_damage(_player.display, _player.small_monsters.poison);
		end

		if cached_config.tracked_damage_types.blast_damage then
			player.merge_damage(_player.display, _player.small_monsters.blast);
		end

		if cached_config.tracked_damage_types.endemic_life_damage then
			player.merge_damage(_player.display, _player.small_monsters.endemic_life);
		end

		if cached_config.tracked_damage_types.other_damage then
			player.merge_damage(_player.display, _player.small_monsters.other);
		end
	end

	if cached_config.tracked_monster_types.large_monsters then
		if cached_config.tracked_damage_types.player_damage then
			player.merge_damage(_player.display, _player.large_monsters);
		end

		if cached_config.tracked_damage_types.bomb_damage then
			player.merge_damage(_player.display, _player.large_monsters.bombs);
		end

		if cached_config.tracked_damage_types.kunai_damage then
			player.merge_damage(_player.display, _player.large_monsters.kunai);
		end

		if cached_config.tracked_damage_types.installation_damage then
			player.merge_damage(_player.display, _player.large_monsters.installations);
		end

		if cached_config.tracked_damage_types.otomo_damage then
			if _player.is_otomo then
				if _player.id == player.myself.id or _player.id == non_players.my_second_otomo_id then

					if cached_config.settings.show_my_otomos_separately then
						player.merge_damage(_player.display, _player.large_monsters.otomo);
					end
				elseif _player.is_servant then

					if cached_config.settings.show_servant_otomos_separately then
						player.merge_damage(_player.display, _player.large_monsters.otomo);
					end
				else

					if cached_config.settings.show_other_player_otomos_separately then
						player.merge_damage(_player.display, _player.large_monsters.otomo);
					end
				end
			else
				if _player == player.myself then

					if not cached_config.settings.show_my_otomos_separately then
						player.merge_damage(_player.display, _player.large_monsters.otomo);
					end
				elseif _player.is_servant then

					if not cached_config.settings.show_servant_otomos_separately then
						player.merge_damage(_player.display, _player.large_monsters.otomo);
					end
				else

					if not cached_config.settings.show_other_player_otomos_separately then
						player.merge_damage(_player.display, _player.large_monsters.otomo);
					end
				end

			end
		end

		if cached_config.tracked_damage_types.wyvern_riding_damage then
			player.merge_damage(_player.display, _player.large_monsters.wyvern_riding);
		end

		if cached_config.tracked_damage_types.poison_damage then
			player.merge_damage(_player.display, _player.large_monsters.poison);
		end

		if cached_config.tracked_damage_types.blast_damage then
			player.merge_damage(_player.display, _player.large_monsters.blast);
		end

		if cached_config.tracked_damage_types.endemic_life_damage then
			player.merge_damage(_player.display, _player.large_monsters.endemic_life);
		end

		if cached_config.tracked_damage_types.other_damage then
			player.merge_damage(_player.display, _player.large_monsters.other);
		end
	end
end

function player.merge_damage(first, second)
	first.total_damage = first.total_damage + second.total_damage;
	first.physical_damage = first.physical_damage + second.physical_damage;
	first.elemental_damage = first.elemental_damage + second.elemental_damage;
	first.ailment_damage = first.ailment_damage + second.ailment_damage;

	return first;
end

function player.update_dps(bypass_freeze)
	local cached_config = config.current_config.damage_meter_UI.settings;

	if cached_config.freeze_dps_on_quest_end and quest_status.flow_state >= quest_status.flow_states.KILLCAM and not bypass_freeze then
		return;
	end

	player.total.dps = 0;
	for _, _player in pairs(player.list) do
		player.update_player_dps(_player);
	end

	for _, servant in pairs(non_players.servant_list) do
		player.update_player_dps(servant);
	end

	for _, otomo in pairs(non_players.otomo_list) do
		player.update_player_dps(otomo);
	end
end

function player.update_player_dps(_player)
	local cached_config = config.current_config.damage_meter_UI.settings;

	if _player.join_time == -1 then
		_player.join_time = time.total_elapsed_script_seconds;
	end

	if cached_config.dps_mode == "Quest Time" then
		if time.total_elapsed_seconds > 0 then
			_player.dps = _player.display.total_damage / time.total_elapsed_seconds;
		end
	elseif cached_config.dps_mode == "Join Time" then
		if time.total_elapsed_script_seconds - _player.join_time > 0 then
			_player.dps = _player.display.total_damage / (time.total_elapsed_script_seconds - _player.join_time);
		end
	elseif cached_config.dps_mode == "First Hit" then
		if time.total_elapsed_script_seconds - _player.first_hit_time > 0 then
			_player.dps = _player.display.total_damage / (time.total_elapsed_script_seconds - _player.first_hit_time);
		end
	end

	player.total.dps = player.total.dps + _player.dps;
end

function player.sort_players()
	local cached_config = config.current_config.damage_meter_UI;

	if cached_config.settings.my_damage_bar_location == "Normal" then
		table.insert(player.display_list, player.myself);
	end

	-- sort here
	if cached_config.sorting.type == "Normal" then
		if cached_config.sorting.reversed_order then
			table.sort(player.display_list, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(player.display_list, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif cached_config.sorting.type == "DPS" then
		if cached_config.sorting.reversed_order then
			table.sort(player.display_list, function(left, right)
				return left.dps < right.dps;
			end);
		else
			table.sort(player.display_list, function(left, right)
				return left.dps > right.dps;
			end);
		end
	else
		if cached_config.sorting.reversed_order then
			table.sort(player.display_list, function(left, right)
				return left.display.total_damage < right.display.total_damage;
			end);
		else
			table.sort(player.display_list, function(left, right)
				return left.display.total_damage > right.display.total_damage;
			end);
		end
	end

	if cached_config.settings.my_damage_bar_location == "First" then
		table.insert(player.display_list, 1, player.myself);

	elseif cached_config.settings.my_damage_bar_location == "Last" then
		table.insert(player.display_list, player.myself);
	end
end

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local find_master_player_method = player_manager_type_def:get_method("findMasterPlayer");

local player_base_type_def = sdk.find_type_definition("snow.player.PlayerBase");
local get_pos_field = player_base_type_def:get_method("get_Pos");

function player.update_myself_position()
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
		player.myself_position = position;
	end
end

function player.init()
	player.list = {};
	player.display_list = {};
	player.total = player.new(0, "Total", 0, 0);
	player.myself = player.new(-1, "Dummy", -1, -1);
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

function player.update_player_list(is_on_quest)
	if is_on_quest then
		player.update_player_list_(quest_hunter_info_field);
	else
		player.update_player_list_(hunter_info_field);
	end
end

function player.update_player_list_(hunter_info_field_)
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

	if player.myself == nil or myself_id ~= player.myself.id then
		player.list[player.myself.id] = nil;
		player.myself = player.new(myself_id, myself_player_name, myself_master_rank, myself_hunter_rank);
		player.list[myself_id] = player.myself;
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

		local player_in_list = player.list[id];

		if player_in_list == nil or (player_in_list.name ~= name and player_in_list.hunter_rank ~= hunter_rank and player_in_list.master_rank ~= master_rank) then
			local _player = player.new(id, name, master_rank, hunter_rank);
			player.list[id] = _player;

			if player_in_list.name == player.myself.name then
				player.myself = _player
			end
		end

		if player_in_list ~= player.myself then
			table.insert(player.display_list, player_in_list);
		end

		::continue::
	end
end

function player.init_UI(_player)
	local cached_config = config.current_config.damage_meter_UI;

	_player.damage_UI = damage_UI_entity.new(cached_config.damage_bar, cached_config.highlighted_damage_bar,
	cached_config.player_name_label, cached_config.dps_label, cached_config.master_hunter_rank_label,
	cached_config.damage_value_label, cached_config.damage_percentage_label, cached_config.cart_count_label);
end

function player.init_total_UI(_player)
	local cached_config = config.current_config.damage_meter_UI;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	_player.damage_UI = {
		total_damage_label = table_helpers.deep_copy(cached_config.total_damage_label),
		total_damage_value_label = table_helpers.deep_copy(cached_config.total_damage_value_label),
		total_dps_label = table_helpers.deep_copy(cached_config.total_dps_label),
		total_cart_count_label = table_helpers.deep_copy(cached_config.total_cart_count_label),
	};

	_player.damage_UI.total_damage_label.offset.x = _player.damage_UI.total_damage_label.offset.x * global_scale_modifier;
	_player.damage_UI.total_damage_label.offset.y = _player.damage_UI.total_damage_label.offset.y * global_scale_modifier;

	_player.damage_UI.total_damage_value_label.offset.x = _player.damage_UI.total_damage_value_label.offset.x *
		                                                      global_scale_modifier;
	_player.damage_UI.total_damage_value_label.offset.y = _player.damage_UI.total_damage_value_label.offset.y *
		                                                      global_scale_modifier;

	_player.damage_UI.total_dps_label.offset.x = _player.damage_UI.total_dps_label.offset.x * global_scale_modifier;
	_player.damage_UI.total_dps_label.offset.y = _player.damage_UI.total_dps_label.offset.y * global_scale_modifier;

	_player.damage_UI.total_cart_count_label.offset.x = _player.damage_UI.total_cart_count_label.offset.x * global_scale_modifier;
	_player.damage_UI.total_cart_count_label.offset.y = _player.damage_UI.total_cart_count_label.offset.y * global_scale_modifier;
end

function player.draw(_player, position_on_screen, opacity_scale, top_damage, top_dps)
	damage_UI_entity.draw(_player, position_on_screen, opacity_scale, top_damage, top_dps);
end

function player.draw_total(position_on_screen, opacity_scale)
	drawing.draw_label(player.total.damage_UI.total_damage_label, position_on_screen, opacity_scale, language.current_language.UI.total_damage);
	drawing.draw_label(player.total.damage_UI.total_damage_value_label, position_on_screen, opacity_scale, player.total.display.total_damage);
	drawing.draw_label(player.total.damage_UI.total_dps_label, position_on_screen, opacity_scale, player.total.dps);
	
	if quest_status.flow_state ~= quest_status.flow_states.IN_LOBBY and quest_status.flow_state ~= quest_status.flow_states.IN_TRAINING_AREA then
		drawing.draw_label(player.total.damage_UI.total_cart_count_label, position_on_screen, opacity_scale, quest_status.cart_count,  quest_status.max_cart_count);
	end
end

function player.init_module()
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

	player.init();
end

return player;
