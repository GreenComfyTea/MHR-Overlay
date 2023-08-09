local this = {};

local config;
local singletons;
local customization_menu;
local damage_UI_entity;
local time;
local quest_status;
local drawing;
local language;
local players;
local error_handler;
local utils;

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

this.servant_list = {};
this.otomo_list = {};

this.my_second_otomo_id = -1;

function this.new(id, name, level, type)
	local non_player = {};
	non_player.id = id;
	non_player.name = name;
	non_player.level = level;

	non_player.type = type;

	non_player.join_time = utils.constants.uninitialized_int;
	non_player.first_hit_time = utils.constants.uninitialized_int;
	non_player.dps = 0;

	non_player.small_monsters = players.init_damage_sources()
	non_player.large_monsters = players.init_damage_sources();

	non_player.display = {};
	non_player.display.total_damage = 0;
	non_player.display.physical_damage = 0;
	non_player.display.elemental_damage = 0;
	non_player.display.ailment_damage = 0;

	this.init_UI(non_player);

	return non_player;
end

function this.get_servant(servant_id)
	return this.servant_list[servant_id];
end

function this.get_otomo(otomo_id)
	return this.otomo_list[otomo_id];
end

function this.init()
	this.servant_list = {};
	this.otomo_list = {};
end

local servant_manager_type_def = sdk.find_type_definition("snow.ai.ServantManager");
local get_quest_servant_id_list_method = servant_manager_type_def:get_method("getQuestServantIdList");
local get_ai_control_by_servant_id_method = servant_manager_type_def:get_method("getAIControlByServantID");

local servant_list_type_def = get_quest_servant_id_list_method:get_return_type();
local servant_get_count_method = servant_list_type_def:get_method("get_Count");
local servant_get_item_method = servant_list_type_def:get_method("get_Item");

local ai_control_type_def = get_ai_control_by_servant_id_method:get_return_type();
local get_servant_info_method = ai_control_type_def:get_method("get_ServantInfo");

local servant_info_type_def = get_servant_info_method:get_return_type();
local get_servant_name_method = servant_info_type_def:get_method("get_ServantName");
local get_servant_player_index_method = servant_info_type_def:get_method("get_ServantPlayerIndex");

local lobby_manager_type_def = sdk.find_type_definition("snow.LobbyManager");
local quest_otomo_info_field = lobby_manager_type_def:get_field("_questOtomoInfo");
local otomo_info_field = lobby_manager_type_def:get_field("_OtomoInfo");

local otomo_manager_type_def = sdk.find_type_definition("snow.otomo.OtomoManager");
local get_master_otomo_info_method = otomo_manager_type_def:get_method("getMasterOtomoInfo");

local otomo_create_data_type_def = get_master_otomo_info_method:get_return_type();
local otomo_create_data_name_field = otomo_create_data_type_def:get_field("Name");
local otomo_create_data_level_field = otomo_create_data_type_def:get_field("Level");

local get_servant_otomo_list_method = otomo_manager_type_def:get_method("getServantOtomoList");

local otomo_list_type_def = get_servant_otomo_list_method:get_return_type();
local otomo_get_count_method = otomo_list_type_def:get_method("get_Count");
local otomo_get_item_method = otomo_list_type_def:get_method("get_Item");

local otomo_info_list_type_def = quest_otomo_info_field:get_type();
local otomo_info_get_count_method = otomo_info_list_type_def:get_method("get_Count");
local otomo_info_get_item_method = otomo_info_list_type_def:get_method("get_Item");


local otomo_info_type_def = otomo_info_get_item_method:get_return_type();
local otomo_info_name_field = otomo_info_type_def:get_field("_Name");
local otomo_info_level_field = otomo_info_type_def:get_field("_Level");
local otomo_info_order_field = otomo_info_type_def:get_field("_Order");

function this.update_servant_list()
	local cached_config = config.current_config.damage_meter_UI;

	if singletons.servant_manager == nil then
		error_handler.report("non_players.update_servant_list", "Failed to access Data: servant_manager");
		return;
	end

	local quest_servant_id_list = get_quest_servant_id_list_method:call(singletons.servant_manager);
	if quest_servant_id_list == nil then
		error_handler.report("non_players.update_servant_list", "Failed to access Data: quest_servant_id_list");
		return;
	end

	local servant_count = servant_get_count_method:call(quest_servant_id_list);
	if servant_count == nil then
		error_handler.report("non_players.update_servant_list", "Failed to access Data: servant_count");
		return;
	end


	for i = 0, servant_count - 1 do
		local servant_id = servant_get_item_method:call(quest_servant_id_list, i);
		if servant_id == nil then
			error_handler.report("non_players.update_servant_list", "Failed to access Data: servant_id No." .. tostring(i));
			goto continue;
		end


		local ai_control = get_ai_control_by_servant_id_method:call(singletons.servant_manager, servant_id);
		if ai_control == nil then
			error_handler.report("non_players.update_servant_list", "Failed to access Data: ai_control No." .. tostring(i));
			goto continue;
		end

		local servant_info = get_servant_info_method:call(ai_control);
		if servant_info == nil then
			error_handler.report("non_players.update_servant_list", "Failed to access Data: servant_info No." .. tostring(i));
			goto continue;
		end

		local name = get_servant_name_method:call(servant_info);
		if name == nil then
			goto continue;
		end

		local id = get_servant_player_index_method:call(servant_info);
		if id == nil then
			goto continue;
		end

		if this.servant_list[id] == nil then
			this.servant_list[id] = this.new(id, name, 0, players.types.servant);
		end

		if not cached_config.settings.hide_servants then
			table.insert(players.display_list, this.servant_list[id]);
		end

		::continue::
	end
end

function this.update_otomo_list(is_on_quest, is_online)
	if is_online then
		if is_on_quest then
			--non_players.update_my_otomos();
			this.update_otomos(quest_otomo_info_field);
		else
			this.update_otomos(otomo_info_field);
		end


	else
		if is_on_quest then
			this.update_my_otomos();
			this.update_servant_otomos();
		else
			this.update_my_otomos();
		end

	end
end

function this.update_my_otomos()
	local cached_config = config.current_config.damage_meter_UI;

	local first_otomo = get_master_otomo_info_method:call(singletons.otomo_manager, 0);
	if first_otomo == nil then
		error_handler.report("non_players.update_my_otomos", "Failed to access Data: first_otomo");
	else
		local name = otomo_create_data_name_field:get_data(first_otomo);
		if name == nil then
			error_handler.report("non_players.update_my_otomos", "Failed to access Data: first_otomo -> name");
		end

		if name ~= nil and name ~= "" then
			local level = otomo_create_data_level_field:get_data(first_otomo) or 0;

			local myself_id = players.myself.id;
			if this.otomo_list[myself_id] == nil then
				this.otomo_list[myself_id] = this.new(0, name, level, players.types.my_otomo);
			end

			if cached_config.settings.show_my_otomos_separately then
				table.insert(players.display_list, this.otomo_list[myself_id]);
			end
		end
	end

	local second_otomo = get_master_otomo_info_method:call(singletons.otomo_manager, 1);
	if second_otomo == nil then
		error_handler.report("non_players.update_my_otomos", "Failed to access Data: second_otomo");
	else
		local name = otomo_create_data_name_field:get_data(second_otomo);
		if name == nil then
			error_handler.report("non_players.update_my_otomos", "Failed to access Data: second_otomo -> name");
		end

		if name ~= nil and name ~= "" then
			local level = otomo_create_data_level_field:get_data(second_otomo) or 0;

			-- the secondary otomo is actually the 4th one!
			if this.otomo_list[this.my_second_otomo_id] == nil then
				this.otomo_list[this.my_second_otomo_id] = this.new(this.my_second_otomo_id, name, level, players.types.my_otomo);
			end

			if cached_config.settings.show_my_otomos_separately then
				table.insert(players.display_list, this.otomo_list[this.my_second_otomo_id]);
			end
		end
	end
end

function this.update_servant_otomos()
	local cached_config = config.current_config.damage_meter_UI;

	local servant_otomo_list = get_servant_otomo_list_method:call(singletons.otomo_manager);
	if servant_otomo_list == nil then
		error_handler.report("non_players.update_servant_otomos", "Failed to access Data: servant_otomo_list");
		return;
	end

	local count = otomo_get_count_method:call(servant_otomo_list);
	if count == nil then
		error_handler.report("non_players.update_servant_otomos", "Failed to access Data: servant_otomo_list -> count");
		return;
	end

	for i = 0, count - 1 do
		local servant_otomo = otomo_get_item_method:call(servant_otomo_list, i);
		if servant_otomo == nil then
			error_handler.report("non_players.update_servant_otomos", "Failed to access Data: servant_otomo No. " .. tostring(i));
			goto continue;
		end

		local otomo_create_data = servant_otomo:call("get_OtCreateData");
		if otomo_create_data ~= nil then
			local name = otomo_create_data_name_field:get_data(otomo_create_data);
			local level = otomo_create_data_level_field:get_data(otomo_create_data) or 0;
			local member_id = otomo_create_data:get_field("MemberID");
			
			if name == nil then
				error_handler.report("non_players.update_servant_otomos", string.format("Failed to access Data: servant_otomo No. %d -> name", i));
				goto continue;
			end

			if this.otomo_list[member_id] == nil then
				this.otomo_list[member_id] = this.new(member_id, name, level, players.types.servant_otomo);
			end

			if cached_config.settings.show_servant_otomos_separately then
				table.insert(players.display_list, this.otomo_list[member_id]);
			end
		end

		::continue::
	end
	
end

function this.update_otomos(otomo_info_field_)
	local cached_config = config.current_config.damage_meter_UI;
	
	if singletons.lobby_manager == nil then
		error_handler.report("non_players.update_otomos", "Failed to access Data: lobby_manager");
		return;
	end

	-- other players
	local otomo_info_list = otomo_info_field_:get_data(singletons.lobby_manager);
	if otomo_info_list == nil then
		error_handler.report("non_players.update_otomos", "Failed to access Data: otomo_info_list");
		return;
	end

	local count = otomo_info_get_count_method:call(otomo_info_list);
	if count == nil then
		error_handler.report("non_players.update_otomos", "Failed to access Data: otomo_info_list -> count");
		return;
	end

	for id = 0, count - 1 do
		local otomo_info = otomo_info_get_item_method:call(otomo_info_list, id);
		if otomo_info == nil then
			error_handler.report("non_players.update_otomos", "Failed to access Data: otomo_info No. " .. tostring(id));
			goto continue;
		end

		local name = otomo_info_name_field:get_data(otomo_info);
		if name == nil then
			error_handler.report("non_players.update_otomos", string.format("Failed to access Data: otomo_info No. %d -> name", id));
			goto continue;
		end

		local level = otomo_info_level_field:get_data(otomo_info) or 0;

		local otomo = this.otomo_list[id];

		if otomo == nil or (otomo.name ~= name and level ~= otomo.level) or
		(otomo.type == players.types.my_otomo and otomo.id ~= players.myself.id) or
		(otomo.type ~= players.types.my_otomo and otomo.id == players.myself.id) then
			if id == players.myself.id then
				otomo = this.new(id, name, level, players.types.my_otomo);
				this.otomo_list[id] = otomo;

			elseif id >= 4 then
				otomo = this.new(id, name, level, players.types.servant_otomo);
				this.otomo_list[id] = otomo;

			else
				otomo = this.new(id, name, level, players.types.other_player_otomo);
				this.otomo_list[id] = otomo;

			end 
		end

		if id == players.myself.id then
			if cached_config.settings.show_my_otomos_separately then
				table.insert(players.display_list, otomo);
			end
		elseif id >= 4 then
			if cached_config.settings.show_servant_otomos_separately then
				table.insert(players.display_list, otomo);
			end
		else
			if cached_config.settings.show_other_player_otomos_separately then
				table.insert(players.display_list, otomo);
			end
		end 

		::continue::
	end
end

function this.init_UI(non_player)
	local cached_config = config.current_config.damage_meter_UI;

	if non_player.type == players.types.servant then
		non_player.damage_UI = damage_UI_entity.new(cached_config.servants, non_player.type);
	elseif non_player.type == players.types.my_otomo then
		non_player.damage_UI = damage_UI_entity.new(cached_config.my_otomos, non_player.type);
	elseif non_player.type == players.types.other_player_otomo then
		non_player.damage_UI = damage_UI_entity.new(cached_config.other_player_otomos, non_player.type);
	elseif non_player.type == players.types.servant_otomo then
		non_player.damage_UI = damage_UI_entity.new(cached_config.servant_otomos, non_player.type);
	end
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
	players = require("MHR_Overlay.Damage_Meter.players");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	utils = require("MHR_Overlay.Misc.utils");
end

function this.init_module()
	this.init();
end

return this;