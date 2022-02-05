local player = {};
local config;
local table_helpers;
local singletons;
local customization_menu;
local damage_UI_entity;

player.list = {};
player.myself = nil;
player.myself_id = nil;
player.myself_position = Vector3f.new(0, 0, 0);
player.total = nil;

function player.new(player_id, player_name, player_hunter_rank)
	local new_player = {};
	new_player.id = player_id;
	new_player.name = player_name;
	new_player.hunter_rank = player_hunter_rank;

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

	new_player.display = {};
	new_player.display.total_damage = 0;
	new_player.display.physical_damage = 0;
	new_player.display.elemental_damage = 0;
	new_player.display.ailment_damage = 0;

	player.init_UI(new_player);

	return new_player;
end

function player.get_player(player_id)
	if player.list[player_id] == nil then
		return nil;
	end

	return player.list[player_id];
end

function player.update_damage(_player, damage_source_type, is_large_monster, damage_object)
	if _player == nil then
		return;
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
	else
		player.merge_damage(_player, damage_object);
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

	if config.current_config.damage_meter_UI.tracked_monster_types.small_monsters then
		if config.current_config.damage_meter_UI.tracked_damage_types.player_damage then
			player.merge_damage(_player.display, _player.small_monsters);
		end
		
		if config.current_config.damage_meter_UI.tracked_damage_types.bomb_damage then
			player.merge_damage(_player.display, _player.small_monsters.bombs);
		end
		
		if config.current_config.damage_meter_UI.tracked_damage_types.kunai_damage then
			player.merge_damage(_player.display, _player.small_monsters.kunai);
		end
		
		if config.current_config.damage_meter_UI.tracked_damage_types.installation_damage then
			player.merge_damage(_player.display, _player.small_monsters.installations);
		end
		
		if config.current_config.damage_meter_UI.tracked_damage_types.otomo_damage then
			player.merge_damage(_player.display, _player.small_monsters.otomo);
		end
		
		if config.current_config.damage_meter_UI.tracked_damage_types.monster_damage then
			player.merge_damage(_player.display, _player.small_monsters.monster);
		end
	end



	if config.current_config.damage_meter_UI.tracked_monster_types.large_monsters then
		if config.current_config.damage_meter_UI.tracked_damage_types.player_damage then
			player.merge_damage(_player.display, _player.large_monsters);
		end
	
		if config.current_config.damage_meter_UI.tracked_damage_types.bomb_damage then
			player.merge_damage(_player.display, _player.large_monsters.bombs);
		end
	
		if config.current_config.damage_meter_UI.tracked_damage_types.kunai_damage then
			player.merge_damage(_player.display, _player.large_monsters.kunai);
		end
	
		if config.current_config.damage_meter_UI.tracked_damage_types.installation_damage then
			player.merge_damage(_player.display, _player.large_monsters.installations);
		end
	
		if config.current_config.damage_meter_UI.tracked_damage_types.otomo_damage then
			player.merge_damage(_player.display, _player.large_monsters.otomo);
		end
	
		if config.current_config.damage_meter_UI.tracked_damage_types.monster_damage then
			player.merge_damage(_player.display, _player.large_monsters.monster);
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

function player.update_myself_position()
	if singletons.player_manager == nil then 
		customization_menu.status = "No player manager";
		return;
	end

	local master_player = singletons.player_manager:call("findMasterPlayer")
	if master_player == nil then
		customization_menu.status = "No master player";
		return;
	end

	local master_player_game_object = master_player:call("get_GameObject")
	if master_player_game_object == nil then
		customization_menu.status = "No master player game object";
		return;
	end

	local master_player_transform = master_player_game_object:call("get_Transform")
	if not master_player_transform then
		customization_menu.status = "No master player transform";
		return;
	end

	local master_player_position = master_player_transform:call("get_Position")
	if master_player_position == nil then
		customization_menu.status = "No masterplayer position";
		return;
	end

	player.myself_position = master_player_position;
end

function player.init_total()
	player.total = player.new(0, "Total", 0);
end

function player.init_UI(_player)
	_player.damage_UI = damage_UI_entity.new(
		config.current_config.damage_meter_UI.damage_bar,
		config.current_config.damage_meter_UI.highlighted_damage_bar,
		config.current_config.damage_meter_UI.player_name_label,
		config.current_config.damage_meter_UI.damage_value_label,
		config.current_config.damage_meter_UI.damage_percentage_label
	);
end

function player.draw(_player, position_on_screen, opacity_scale, top_damage)
	damage_UI_entity.draw(_player, position_on_screen, opacity_scale, top_damage);
end

function player.init_module()
	config = require("MHR_Overlay.Misc.config");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	damage_UI_entity = require("MHR_Overlay.UI.UI_Entities.damage_UI_entity");

	player.init_total();
end

return player;