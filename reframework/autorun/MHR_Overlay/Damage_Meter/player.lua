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

player.list = {};
player.myself = nil;
player.myself_position = Vector3f.new(0, 0, 0);
player.total = nil;

function player.new(player_id, player_name, player_hunter_rank)
	local new_player = {};
	new_player.id = player_id;
	new_player.name = player_name;
	new_player.hunter_rank = player_hunter_rank;

	new_player.join_time = -1;
	new_player.first_hit_time = -1;
	new_player.dps = 0;

	new_player.small_monsters = {};

	new_player.small_monsters.total_damage = 0;
	new_player.small_monsters.physical_damage = 0;
	new_player.small_monsters.elemental_damage = 0;
	new_player.small_monsters.ailment_damage = 0;

	new_player.small_monsters.bombs = {};
	new_player.small_monsters.bombs.total_damage = 0;
	new_player.small_monsters.bombs.physical_damage = 0;
	new_player.small_monsters.bombs.elemental_damage = 0;
	new_player.small_monsters.bombs.ailment_damage = 0;

	new_player.small_monsters.kunai = {};
	new_player.small_monsters.kunai.total_damage = 0;
	new_player.small_monsters.kunai.physical_damage = 0;
	new_player.small_monsters.kunai.elemental_damage = 0;
	new_player.small_monsters.kunai.ailment_damage = 0;

	new_player.small_monsters.installations = {};
	new_player.small_monsters.installations.total_damage = 0;
	new_player.small_monsters.installations.physical_damage = 0;
	new_player.small_monsters.installations.elemental_damage = 0;
	new_player.small_monsters.installations.ailment_damage = 0;

	new_player.small_monsters.otomo = {};
	new_player.small_monsters.otomo.total_damage = 0;
	new_player.small_monsters.otomo.physical_damage = 0;
	new_player.small_monsters.otomo.elemental_damage = 0;
	new_player.small_monsters.otomo.ailment_damage = 0;

	new_player.small_monsters.monster = {};
	new_player.small_monsters.monster.total_damage = 0;
	new_player.small_monsters.monster.physical_damage = 0;
	new_player.small_monsters.monster.elemental_damage = 0;
	new_player.small_monsters.monster.ailment_damage = 0;

	new_player.small_monsters.poison = {};
	new_player.small_monsters.poison.total_damage = 0;
	new_player.small_monsters.poison.physical_damage = 0;
	new_player.small_monsters.poison.elemental_damage = 0;
	new_player.small_monsters.poison.ailment_damage = 0;

	new_player.small_monsters.blast = {};
	new_player.small_monsters.blast.total_damage = 0;
	new_player.small_monsters.blast.physical_damage = 0;
	new_player.small_monsters.blast.elemental_damage = 0;
	new_player.small_monsters.blast.ailment_damage = 0;

	new_player.large_monsters = {};

	new_player.large_monsters.total_damage = 0;
	new_player.large_monsters.physical_damage = 0;
	new_player.large_monsters.elemental_damage = 0;
	new_player.large_monsters.ailment_damage = 0;

	new_player.large_monsters.bombs = {};
	new_player.large_monsters.bombs.total_damage = 0;
	new_player.large_monsters.bombs.physical_damage = 0;
	new_player.large_monsters.bombs.elemental_damage = 0;
	new_player.large_monsters.bombs.ailment_damage = 0;

	new_player.large_monsters.kunai = {};
	new_player.large_monsters.kunai.total_damage = 0;
	new_player.large_monsters.kunai.physical_damage = 0;
	new_player.large_monsters.kunai.elemental_damage = 0;
	new_player.large_monsters.kunai.ailment_damage = 0;

	new_player.large_monsters.installations = {};
	new_player.large_monsters.installations.total_damage = 0;
	new_player.large_monsters.installations.physical_damage = 0;
	new_player.large_monsters.installations.elemental_damage = 0;
	new_player.large_monsters.installations.ailment_damage = 0;

	new_player.large_monsters.otomo = {};
	new_player.large_monsters.otomo.total_damage = 0;
	new_player.large_monsters.otomo.physical_damage = 0;
	new_player.large_monsters.otomo.elemental_damage = 0;
	new_player.large_monsters.otomo.ailment_damage = 0;

	new_player.large_monsters.monster = {};
	new_player.large_monsters.monster.total_damage = 0;
	new_player.large_monsters.monster.physical_damage = 0;
	new_player.large_monsters.monster.elemental_damage = 0;
	new_player.large_monsters.monster.ailment_damage = 0;

	new_player.large_monsters.poison = {};
	new_player.large_monsters.poison.total_damage = 0;
	new_player.large_monsters.poison.physical_damage = 0;
	new_player.large_monsters.poison.elemental_damage = 0;
	new_player.large_monsters.poison.ailment_damage = 0;

	new_player.large_monsters.blast = {};
	new_player.large_monsters.blast.total_damage = 0;
	new_player.large_monsters.blast.physical_damage = 0;
	new_player.large_monsters.blast.elemental_damage = 0;
	new_player.large_monsters.blast.ailment_damage = 0;

	new_player.display = {};
	new_player.display.total_damage = 0;
	new_player.display.physical_damage = 0;
	new_player.display.elemental_damage = 0;
	new_player.display.ailment_damage = 0;

	if player_name == "Total" then
		player.init_total_UI(new_player);
	else
		player.init_UI(new_player);
	end
	

	return new_player;
end

function player.get_player(player_id)
	return player.list[player_id];
end

function player.update_damage(_player, damage_source_type, is_large_monster, damage_object)
	if _player == nil then
		return;
	end

	if _player.first_hit_time == -1 then
		_player.first_hit_time = time.total_elapsed_seconds;
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
	elseif damage_source_type == "wyvernblast" then
		player.merge_damage(player_monster_type, damage_object);
	elseif damage_source_type == "installation" then
		player.merge_damage(player_monster_type.installations, damage_object);
	elseif damage_source_type == "otomo" then
		player.merge_damage(player_monster_type.otomo, damage_object);
	elseif damage_source_type == "monster" then
		player.merge_damage(player_monster_type.monster, damage_object);
	elseif damage_source_type == "poison" then
		player.merge_damage(player_monster_type.poison, damage_object);
	elseif damage_source_type == "blast" then
		player.merge_damage(player_monster_type.blast, damage_object);
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
			player.merge_damage(_player.display, _player.small_monsters.otomo);
		end
		
		if cached_config.tracked_damage_types.monster_damage then
			player.merge_damage(_player.display, _player.small_monsters.monster);
		end

		if cached_config.tracked_damage_types.poison_damage then
			player.merge_damage(_player.display, _player.small_monsters.poison);
		end

		if cached_config.tracked_damage_types.blast_damage then
			player.merge_damage(_player.display, _player.small_monsters.blast);
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
			player.merge_damage(_player.display, _player.large_monsters.otomo);
		end
	
		if cached_config.tracked_damage_types.monster_damage then
			player.merge_damage(_player.display, _player.large_monsters.monster);
		end

		if cached_config.tracked_damage_types.poison_damage then
			player.merge_damage(_player.display, _player.large_monsters.poison);
		end

		if cached_config.tracked_damage_types.blast_damage then
			player.merge_damage(_player.display, _player.large_monsters.blast);
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

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local find_master_player_method = player_manager_type_def:get_method("findMasterPlayer");

local get_game_object_method = sdk.find_type_definition("via.Component"):get_method("get_GameObject")
local get_transform_method = sdk.find_type_definition("via.GameObject"):get_method("get_Transform")
local get_position_method = sdk.find_type_definition("via.Transform"):get_method("get_Position")

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

	local master_player_game_object = get_game_object_method:call(master_player);
	if master_player_game_object == nil then
		customization_menu.status = "No master player game object";
		return;
	end
	
	local master_player_transform = get_transform_method:call(master_player_game_object);
	if not master_player_transform then
		customization_menu.status = "No master player transform";
		return;
	end

	local master_player_position = get_position_method:call(master_player_transform);
	if master_player_position == nil then
		customization_menu.status = "No master player position";
		return;
	end

	player.myself_position = master_player_position;
end

function player.init()
	player.list = {};
	player.total = player.new(0, "Total", 0);
	player.myself = player.new(-1, "Dummy", -1);
end

local lobby_manager_type_def = sdk.find_type_definition("snow.LobbyManager");
local my_hunter_info_field = lobby_manager_type_def:get_field("_myHunterInfo");

local quest_hunter_info_field = lobby_manager_type_def:get_field("_questHunterInfo");
local hunter_info_field = lobby_manager_type_def:get_field("_hunterInfo");

local my_hunter_info_type_def = my_hunter_info_field:get_type();
local name_field = my_hunter_info_type_def:get_field("_name");
local member_index_field = my_hunter_info_type_def:get_field("_memberIndex");
local hunter_rank_field = my_hunter_info_type_def:get_field("_hunterRank");

local hunter_info_type_def = hunter_info_field:get_type();
local get_count_method = hunter_info_type_def:get_method("get_Count");
local get_item_method = hunter_info_type_def:get_method("get_Item");

local progress_manager_type_def = sdk.find_type_definition("snow.progress.ProgressManager");
local get_hunter_rank_method = progress_manager_type_def:get_method("get_HunterRank");

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_master_player_id_method = player_manager_type_def:get_method("getMasterPlayerID");

function player.update_player_list_in_village()
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

	local myself_hunter_rank = get_hunter_rank_method:call(singletons.progress_manager);
	if myself_hunter_rank == nil then
		customization_menu.status = "No myself hunter rank";
		myself_hunter_rank = 0;
	end

	local myself_id = get_master_player_id_method:call(singletons.player_manager);
	if myself_id == nil then
		customization_menu.status = "No myself player id";
	elseif player.myself == nil or myself_id ~= player.myself.id then
			player.myself = player.new(myself_id, myself_player_name, myself_hunter_rank);
		player.list[myself_id] = player.myself;
	end

	-- other players
	local player_info_list = hunter_info_field:get_data(singletons.lobby_manager);
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

		local player_id = member_index_field:get_data(player_info);
		if player_id == nil then
			goto continue
		end

		local player_hunter_rank = hunter_rank_field:get_data(player_info);
		if player_hunter_rank == nil then
			goto continue
		end

		local player_name = name_field:get_data(player_info);
		if player_name == nil then
			goto continue
		end

		if player.myself.id == player_id then
			player.list[player_id] = player.myself;
		elseif player.list[player_id] == nil or player.list[player_id].name ~= player_name then
			player.list[player_id] = player.new(player_id, player_name, player_hunter_rank);
		end

		::continue::
	end
end

function player.update_player_list_on_quest()
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

	local myself_hunter_rank = get_hunter_rank_method:call(singletons.progress_manager);
	if myself_hunter_rank == nil then
		customization_menu.status = "No myself hunter rank";
		myself_hunter_rank = 0;
	end

	local myself_id = get_master_player_id_method:call(singletons.player_manager);
	if myself_id == nil then
		customization_menu.status = "No myself player id";
	elseif player.myself == nil or myself_id ~= player.myself.id then
			player.myself = player.new(myself_id, myself_player_name, myself_hunter_rank);
		player.list[myself_id] = player.myself;
	end
	
	-- other players
	local player_info_list = quest_hunter_info_field:get_data(singletons.lobby_manager);
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

		local player_id = member_index_field:get_data(player_info);
		
		if player_id == nil then
			goto continue
		end

		local player_hunter_rank = hunter_rank_field:get_data(player_info);
		if player_hunter_rank == nil then
			goto continue
		end

		local player_name = name_field:get_data(player_info);
		if player_name == nil then
			goto continue
		end

		if player.myself.id == player_id then
			player.list[player_id] = player.myself;
		elseif player.list[player_id] == nil or player.list[player_id].name ~= player_name then
			player.list[player_id] = player.new(player_id, player_name, player_hunter_rank);
		end

		::continue::
	end
end

function player.init_UI(_player)
	local cached_config = config.current_config.damage_meter_UI;

	_player.damage_UI = damage_UI_entity.new(
		cached_config.damage_bar,
		cached_config.highlighted_damage_bar,
		cached_config.player_name_label,
		cached_config.dps_label,
		cached_config.hunter_rank_label,
		cached_config.damage_value_label,
		cached_config.damage_percentage_label
	);
end

function player.init_total_UI(_player)
	local cached_config = config.current_config.damage_meter_UI;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	_player.damage_UI = {
		total_damage_label = table_helpers.deep_copy(cached_config.total_damage_label),
		total_damage_value_label = table_helpers.deep_copy(cached_config.total_damage_value_label),
		total_dps_label = table_helpers.deep_copy(cached_config.total_dps_label)
	};

	_player.damage_UI.total_damage_label.offset.x = _player.damage_UI.total_damage_label.offset.x * global_scale_modifier;
	_player.damage_UI.total_damage_label.offset.y = _player.damage_UI.total_damage_label.offset.y * global_scale_modifier;

	_player.damage_UI.total_damage_value_label.offset.x = _player.damage_UI.total_damage_value_label.offset.x * global_scale_modifier;
	_player.damage_UI.total_damage_value_label.offset.y = _player.damage_UI.total_damage_value_label.offset.y * global_scale_modifier;

	_player.damage_UI.total_dps_label.offset.x = _player.damage_UI.total_dps_label.offset.x * global_scale_modifier;
	_player.damage_UI.total_dps_label.offset.y = _player.damage_UI.total_dps_label.offset.y * global_scale_modifier;
end

function player.draw(_player, position_on_screen, opacity_scale, top_damage, top_dps)
	damage_UI_entity.draw(_player, position_on_screen, opacity_scale, top_damage, top_dps);
end

function player.draw_total(position_on_screen, opacity_scale)
	drawing.draw_label(player.total.damage_UI.total_damage_label, position_on_screen, opacity_scale, language.current_language.UI.total_damage);
	drawing.draw_label(player.total.damage_UI.total_damage_value_label, position_on_screen, opacity_scale, player.total.display.total_damage);
	drawing.draw_label(player.total.damage_UI.total_dps_label, position_on_screen, opacity_scale, player.total.dps);
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

	player.init();
end

return player;