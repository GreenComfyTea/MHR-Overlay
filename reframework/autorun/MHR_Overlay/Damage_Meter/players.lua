local this = {};

local config;
local singletons;
local customization_menu;
local damage_UI_entity;
local time;
local quest_status;
local drawing;
local language;
local non_players;
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

this.list = {};
this.myself = nil;
this.myself_position = Vector3f.new(0, 0, 0);
this.total = nil;

this.highlighted_damage_UI = nil;

this.damage_types = {
	["player"] = "player",
	["bombs"] = "bombs",
	["kunai"] = "kunai",
	["installations"] = "installations",
	["otomo"] = "otomo",
	["wyvern_riding"] = "wyvern_riding",
	["poison"] = "poison",
	["otomo_poison"] = "otomo_poison",
	["blast"] = "blast",
	["otomo_blast"] = "otomo_blast",
	["endemic_life"] = "endemic_life",
	["anomaly_core"] = "anomaly_core",
	["other"] = "other"
};

this.types = {
	["myself"] = 0,
	["other_player"] = 1,
	["servant"] = 2,
	["my_otomo"] = 4,
	["other_player_otomo"] = 8,
	["servant_otomo"] = 16,
	["total"] = 32,
	["highlight"] = 64
};

function this.new(id, name, master_rank, hunter_rank, type)
	local player = {};
	player.id = id;
	player.name = name;
	player.hunter_rank = hunter_rank;
	player.master_rank = master_rank;

	player.type = type;

	player.cart_count = 0;

	player.join_time = utils.constants.uninitialized_int;
	player.first_hit_time = utils.constants.uninitialized_int;
	player.dps = 0;

	player.small_monsters = this.init_damage_sources();
	player.large_monsters = this.init_damage_sources();
	
	player.display = {};
	player.display.total_damage = 0;
	player.display.physical_damage = 0;
	player.display.elemental_damage = 0;
	player.display.ailment_damage = 0;

	this.init_UI(player);

	if this.highlighted_damage_UI == nil then
		this.init_highlighted_UI();
	end

	return player;
end

function this.init_damage_sources()
	local monster_type = {};
	
	for damage_type_name, _ in pairs(this.damage_types) do
		monster_type[damage_type_name] = {
			total_damage = 0,
			physical_damage = 0,
			elemental_damage = 0,
			ailment_damage = 0
		};
	end

	return monster_type;
end

function this.get_player(player_id)
	if player_id == non_players.my_second_otomo_id then
		return this.myself;
	end

	return this.list[player_id];
end

function this.update_damage(player, damage_source_type, is_large_monster, damage_object)
	
	if player == nil then
		return;
	end

	if player.first_hit_time == utils.constants.uninitialized_int then
		player.first_hit_time = time.total_elapsed_script_seconds;
	end

	if is_large_monster then
		this.merge_damage(player.large_monsters[damage_source_type], damage_object);
	else
		this.merge_damage(player.small_monsters[damage_source_type], damage_object);
	end

	this.update_display(player);
end

function this.update_display(player)
	if player == nil then
		error_handler.report("players.update_display", "Missing Parameter: player");
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
		if cached_config.tracked_damage_types.players then
			this.merge_damage(player.display, monster_type.player);
		end

		if cached_config.tracked_damage_types.bombs then
			this.merge_damage(player.display, monster_type.bombs);
		end

		if cached_config.tracked_damage_types.kunai then
			this.merge_damage(player.display, monster_type.kunai);
		end

		if cached_config.tracked_damage_types.installations then
			this.merge_damage(player.display, monster_type.installations);
		end

		if cached_config.tracked_damage_types.otomos then
			if player.type == this.types.myself then

				if not cached_config.settings.show_my_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo);
				end
			elseif player.type == this.types.other_player then

				if not cached_config.settings.show_other_player_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo);
				end
			elseif player.type == this.types.servant then
				
				if not cached_config.settings.show_servant_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo);
				end
			elseif player.type == this.types.my_otomo then

				if cached_config.settings.show_my_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo);
				end
			elseif player.type == this.types.other_player_otomo then

				if cached_config.settings.show_other_player_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo);
				end
			elseif player.type == this.types.servant_otomo then

				if cached_config.settings.show_servant_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo);
				end
			elseif player.type == this.types.total then

				this.merge_damage(player.display, monster_type.otomo);
			end
		end

		if cached_config.tracked_damage_types.wyvern_riding then
			this.merge_damage(player.display, monster_type.wyvern_riding);
		end

		if cached_config.tracked_damage_types.poison then
			this.merge_damage(player.display, monster_type.poison);

			if player.type == this.types.myself then

				if not cached_config.settings.show_my_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo_poison);
				end
			elseif player.type == this.types.other_player then

				if not cached_config.settings.show_other_player_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo_poison);
				end
			elseif player.type == this.types.servant then

				if not cached_config.settings.show_servant_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo_poison);
				end
			elseif player.type == this.types.my_otomo then

				if cached_config.settings.show_my_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo_poison);
				end
			elseif player.type == this.types.other_player_otomo then

				if cached_config.settings.show_other_player_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo_poison);
				end
			elseif player.type == this.types.servant_otomo then

				if cached_config.settings.show_servant_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo_poison);
				end

			elseif player.type == this.types.total then
				
				this.merge_damage(player.display, monster_type.otomo_poison);
			end
		end

		if cached_config.tracked_damage_types.blast then
			this.merge_damage(player.display, monster_type.blast);

			if player.type == this.types.myself then

				if not cached_config.settings.show_my_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo_blast);
				end
			elseif player.type == this.types.other_player then

				if not cached_config.settings.show_other_player_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo_blast);
				end
			elseif player.type == this.types.servant then

				if not cached_config.settings.show_servant_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo_blast);
				end
			elseif player.type == this.types.my_otomo then

				if cached_config.settings.show_my_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo_blast);
				end
			elseif player.type == this.types.other_player_otomo then

				if cached_config.settings.show_other_player_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo_blast);
				end
			elseif player.type == this.types.servant_otomo then

				if cached_config.settings.show_servant_otomos_separately then
					this.merge_damage(player.display, monster_type.otomo_blast);
				end
			elseif player.type == this.types.total then
				
				this.merge_damage(player.display, monster_type.otomo_blast);
			end
		end

		if cached_config.tracked_damage_types.endemic_life then
			this.merge_damage(player.display, monster_type.endemic_life);
		end

		if cached_config.tracked_damage_types.anomaly_cores then
			this.merge_damage(player.display, monster_type.anomaly_core);
		end

		if cached_config.tracked_damage_types.other then
			this.merge_damage(player.display, monster_type.other);
		end
	end
end

function this.merge_damage(first, second)
	first.total_damage = first.total_damage + second.total_damage;
	first.physical_damage = first.physical_damage + second.physical_damage;
	first.elemental_damage = first.elemental_damage + second.elemental_damage;
	first.ailment_damage = first.ailment_damage + second.ailment_damage;

	return first;
end

function this.update_dps(bypass_freeze)
	local cached_config = config.current_config.damage_meter_UI.settings;

	if cached_config.freeze_dps_on_quest_end and quest_status.flow_state >= quest_status.flow_states.KILLCAM and not bypass_freeze then
		return;
	end

	this.total.dps = 0;
	for _, player in pairs(this.list) do
		this.update_player_dps(player);
	end

	for _, servant in pairs(non_players.servant_list) do
		this.update_player_dps(servant);
	end

	for _, otomo in pairs(non_players.otomo_list) do
		this.update_player_dps(otomo);
	end
end

function this.update_player_dps(player)
	local cached_config = config.current_config.damage_meter_UI.settings;

	if player.join_time == utils.constants.uninitialized_int then
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

	this.total.dps = this.total.dps + player.dps;
end

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local find_master_player_method = player_manager_type_def:get_method("findMasterPlayer");

local player_base_type_def = sdk.find_type_definition("snow.player.PlayerBase");
local get_pos_field = player_base_type_def:get_method("get_Pos");

function this.update_myself_position()
	if singletons.player_manager == nil then
		error_handler.report("players.update_myself_position", "Failed to access Data: player_manager");
		return;
	end

	if quest_status.flow_state == quest_status.flow_states.NONE
	or quest_status.flow_state == quest_status.flow_states.CUTSCENE then
		return;
	end

	local master_player = find_master_player_method:call(singletons.player_manager);
	if master_player == nil then
		error_handler.report("players.update_myself_position", "Failed to access Data: master_player");
		return;
	end

	local position = get_pos_field:call(master_player);
	if position == nil then
		error_handler.report("players.update_myself_position", "Failed to access Data: position");
	end

	this.myself_position = position;
end

function this.init()
	this.list = {};
	this.total = this.new(0, "Total", 0, 0, this.types.total);
	this.myself = nil;
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

function this.update_players()
	local is_on_quest = quest_status.flow_state ~= quest_status.flow_states.IN_LOBBY and quest_status.flow_state ~= quest_status.flow_states.IN_TRAINING_AREA;

	this.update_player_list(is_on_quest);
	non_players.update_servant_list();
	non_players.update_otomo_list(is_on_quest, quest_status.is_online);

	this.update_dps(false);

	quest_status.get_cart_count();
end

function this.update_player_list(is_on_quest)
	if is_on_quest then
		this.update_player_list_(quest_hunter_info_field);
	else
		this.update_player_list_(hunter_info_field);
	end
end

function this.update_player_list_(hunter_info_field_)
	local cached_config = config.current_config.damage_meter_UI;

	if singletons.lobby_manager == nil then
		error_handler.report("players.update_player_list_", "Failed to access Data: lobby_manager");
		return;
	end

	if singletons.progress_manager == nil then
		error_handler.report("players.update_player_list_", "Failed to access Data: progress_manager");
		return;
	end

	-- myself player
	local myself_player_info = my_hunter_info_field:get_data(singletons.lobby_manager);
	if myself_player_info == nil then
		error_handler.report("players.update_player_list_", "Failed to access Data: myself_player_info");
		return;
	end

	local myself_player_name = name_field:get_data(myself_player_info);
	if myself_player_name == nil then
		error_handler.report("players.update_player_list_", "Failed to access Data: myself_player_name");
		return;
	end

	local myself_hunter_rank = get_hunter_rank_method:call(singletons.progress_manager) or 0;
	local myself_master_rank = get_master_rank_method:call(singletons.progress_manager) or 0;

	local myself_id = get_master_player_id_method:call(singletons.player_manager);

	if myself_id == nil then
		error_handler.report("players.update_player_list_", "Failed to access Data: myself_id");
		return;
	end

	if this.myself == nil or myself_id ~= this.myself.id then
		if this.myself ~= nil then
			this.list[this.myself.id] = nil;
		end

		this.myself = this.new(myself_id, myself_player_name, myself_master_rank, myself_hunter_rank, this.types.myself);
		this.list[myself_id] = this.myself;
	end

	-- other players
	local player_info_array = hunter_info_field_:get_data(singletons.lobby_manager);
	if player_info_array == nil then
		error_handler.report("players.update_player_list_", "Failed to access Data: player_info_array");
		return;
	end

	local count = get_count_method:call(player_info_array);
	if count == nil then
		error_handler.report("players.update_player_list_", "Failed to access Data: player_info_array -> count");
		return;
	end

	for i = 0, count - 1 do
		local player_info = get_item_method:call(player_info_array, i);
		if player_info == nil then
			error_handler.report("players.update_player_list_", "Failed to access Data: player_info No. " .. tostring(i));
			goto continue;
		end

		local id = member_index_field:get_data(player_info);
		if id == nil then
			error_handler.report("players.update_player_list_", string.format("Failed to access Data: player_info No. %d -> id", i));
			goto continue;
		end

		local hunter_rank = hunter_rank_field:get_data(player_info) or 0;
		local master_rank = master_rank_field:get_data(player_info) or 0;

		local name = name_field:get_data(player_info);
		if name == nil then
			error_handler.report("players.update_player_list_", string.format("Failed to access Data: player_info No. %d -> name", i));
			goto continue;
		end

		local player = this.list[id];

		if player == nil then
			if name == this.myself.name then
				player = this.new(id, name, master_rank, hunter_rank, this.types.myself);
				this.myself = player;
				this.list[id] = player;
			else
				player = this.new(id, name, master_rank, hunter_rank, this.types.other_player);
				this.list[id] = player;
			end
			
		elseif player.name ~= name or player.hunter_rank ~= hunter_rank or player.master_rank ~= master_rank then

			if name == this.myself.name then
				player = this.new(id, name, master_rank, hunter_rank, this.types.myself);
				this.myself = player;
				this.list[id] = player;
			else
				player = this.new(id, name, master_rank, hunter_rank, this.types.other_player);
				this.list[id] = player;
			end
		end

		::continue::
	end
end

function this.init_UI(player)
	local cached_config = config.current_config.damage_meter_UI;

	if player.type == this.types.myself then
		player.damage_UI = damage_UI_entity.new(cached_config.myself, player.type);
	elseif player.type == this.types.other_player then
		player.damage_UI = damage_UI_entity.new(cached_config.other_players, player.type);
	elseif player.type == this.types.total then
		player.damage_UI = damage_UI_entity.new(cached_config.total, player.type);
	end
end

function this.init_highlighted_UI()
	local cached_config = config.current_config.damage_meter_UI;

	this.highlighted_damage_UI = damage_UI_entity.new(cached_config.highlighted, this.types.highlight);
end

function this.draw(player, position_on_screen, opacity_scale, top_damage, top_dps)
	damage_UI_entity.draw(player, position_on_screen, opacity_scale, top_damage, top_dps);
end

function this.init_dependencies()
	config = require("MHR_Overlay.Misc.config");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	damage_UI_entity = require("MHR_Overlay.UI.UI_Entities.damage_UI_entity");
	time = require("MHR_Overlay.Game_Handler.time");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	drawing = require("MHR_Overlay.UI.drawing");
	language = require("MHR_Overlay.Misc.language");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
	utils = require("MHR_Overlay.Misc.utils");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
	this.init();
end

return this;
