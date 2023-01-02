local non_players = {};
local config;
local table_helpers;
local singletons;
local customization_menu;
local damage_UI_entity;
local time;
local quest_status;
local drawing;
local language;
local unicode_helpers;
local players;

non_players.servant_list = {};
non_players.otomo_list = {};

non_players.my_second_otomo_id = -1;

function non_players.new(id, name, level, type)
	local non_player = {};
	non_player.id = id;
	non_player.name = name;
	non_player.level = level;

	non_player.type = type;

	non_player.join_time = -1;
	non_player.first_hit_time = -1;
	non_player.dps = 0;

	non_player.small_monsters = players.init_damage_sources()
	non_player.large_monsters = players.init_damage_sources();

	non_player.display = {};
	non_player.display.total_damage = 0;
	non_player.display.physical_damage = 0;
	non_player.display.elemental_damage = 0;
	non_player.display.ailment_damage = 0;

	non_players.init_UI(non_player);

	return non_player;
end

function non_players.get_servant(servant_id)
	return non_players.servant_list[servant_id];
end

function non_players.get_otomo(otomo_id)
	return non_players.otomo_list[otomo_id];
end

function non_players.init()
	non_players.servant_list = {};
	non_players.otomo_list = {};
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

function non_players.update_servant_list()
	local cached_config = config.current_config.damage_meter_UI;

	if singletons.servant_manager == nil then
		return;
	end

	local quest_servant_id_list = get_quest_servant_id_list_method:call(singletons.servant_manager);
	if quest_servant_id_list == nil then
		return;
	end

	local servant_count = servant_get_count_method:call(quest_servant_id_list);
	if servant_count == nil then
		customization_menu.status = "No quest servant id list count";
		return;
	end


	for i = 0, servant_count - 1 do
		local servant_id = servant_get_item_method:call(quest_servant_id_list, i);
		if servant_id == nil then
			goto continue;
		end


		local ai_control = get_ai_control_by_servant_id_method:call(singletons.servant_manager, servant_id);
		if ai_control == nil then
			customization_menu.status = "No quest servant ai control";
			goto continue;
		end

		local servant_info = get_servant_info_method:call(ai_control);
		if servant_info == nil then
			customization_menu.status = "No quest servant info";
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

		if non_players.servant_list[id] == nil then
			non_players.servant_list[id] = non_players.new(id, name, 0, players.types.servant);
		end

		if not cached_config.settings.hide_servants then
			table.insert(players.display_list, non_players.servant_list[id]);
		end

		::continue::
	end
end

function non_players.update_otomo_list(is_on_quest, is_online)
	if is_online then
		if is_on_quest then
			--non_players.update_my_otomos();
			non_players.update_otomos(quest_otomo_info_field);
		else
			non_players.update_otomos(otomo_info_field);
		end


	else
		if is_on_quest then
			non_players.update_my_otomos();
			non_players.update_servant_otomos();
		else
			non_players.update_my_otomos();
		end

	end
end

function non_players.update_my_otomos()
	local cached_config = config.current_config.damage_meter_UI;

	local first_otomo = get_master_otomo_info_method:call(singletons.otomo_manager, 0);
	if first_otomo ~= nil then
		local name = otomo_create_data_name_field:get_data(first_otomo);
		if name ~= nil and name ~= "" then
			local level = otomo_create_data_level_field:get_data(first_otomo) or 0;

			if non_players.otomo_list[0] == nil then
				non_players.otomo_list[0] = non_players.new(0, name, level, players.types.my_otomo);
			end

			if cached_config.settings.show_my_otomos_separately then
				table.insert(players.display_list, non_players.otomo_list[0]);
			end
		end
	end

	local second_otomo = get_master_otomo_info_method:call(singletons.otomo_manager, 1);
	if second_otomo ~= nil then
		local name = otomo_create_data_name_field:get_data(second_otomo);
		if name ~= nil and name ~= "" then
			local level = otomo_create_data_level_field:get_data(second_otomo) or 0;

			-- the secondary otomo is actually the 4th one!
			if non_players.otomo_list[non_players.my_second_otomo_id] == nil then
				non_players.otomo_list[non_players.my_second_otomo_id] = non_players.new(non_players.my_second_otomo_id, name, level, players.types.my_otomo);
			end

			if cached_config.settings.show_my_otomos_separately then
				table.insert(players.display_list, non_players.otomo_list[non_players.my_second_otomo_id]);
			end
		end
	end
end

function non_players.update_servant_otomos()
	local cached_config = config.current_config.damage_meter_UI;

	local servant_otomo_list = get_servant_otomo_list_method:call(singletons.otomo_manager);
	if servant_otomo_list == nil then
		customization_menu.status = "No servant otomo list";
		return;
	end

	local count = otomo_get_count_method:call(servant_otomo_list);
	if count == nil then
		customization_menu.status = "No servant otomo list count";
		return;
	end

	for i = 0, count - 1 do
		local servant_otomo = otomo_get_item_method:call(servant_otomo_list, i);
		if servant_otomo == nil then
			goto continue
		end

		local otomo_create_data = servant_otomo:call("get_OtCreateData");
		if otomo_create_data ~= nil then
			local name = otomo_create_data_name_field:get_data(otomo_create_data);
			local level = otomo_create_data_level_field:get_data(otomo_create_data) or 0;
			local member_id = otomo_create_data:get_field("MemberID");
			
			if name == nil then
				goto continue;
			end

			--name = unicode_helpers.sub(name, 13);

			if non_players.otomo_list[member_id] == nil then
				non_players.otomo_list[member_id] = non_players.new(member_id, name, level, players.types.servant_otomo);
			end

			if cached_config.settings.show_servant_otomos_separately then
				table.insert(players.display_list, non_players.otomo_list[member_id]);
			end
		end

		::continue::
	end
	
end

function non_players.update_otomos(otomo_info_field_)
	local cached_config = config.current_config.damage_meter_UI;
	
	if singletons.lobby_manager == nil then
		return;
	end

	-- other players
	local otomo_info_list = otomo_info_field_:get_data(singletons.lobby_manager);
	if otomo_info_list == nil then
		customization_menu.status = "No otomo info list";
		return;
	end

	local count = otomo_info_get_count_method:call(otomo_info_list);
	if count == nil then
		customization_menu.status = "No otomo info list count";
		return;
	end

	for id = 0, count - 1 do
		local otomo_info = otomo_info_get_item_method:call(otomo_info_list, id);
		if otomo_info == nil then
			goto continue;
		end

		local name = otomo_info_name_field:get_data(otomo_info);
		if name == nil then
			goto continue;
		end

		local level = otomo_info_level_field:get_data(otomo_info) or 0;

		local otomo_in_list = non_players.otomo_list[id];

		if otomo_in_list == nil or (otomo_in_list.name ~= name and otomo_in_list.level) then
			if id == players.myself.id then
				local otomo = non_players.new(id, name, level, players.types.my_otomo);
				non_players.otomo_list[id] = otomo;

				if cached_config.settings.show_my_otomos_separately then
					table.insert(players.display_list, otomo);
				end
			elseif id >= 4 then
				local otomo = non_players.new(id, name, level, players.types.servant_otomo);
				non_players.otomo_list[id] = otomo;

				if cached_config.settings.show_servant_otomos_separately then
					table.insert(players.display_list, non_players);
				end
			else
				local otomo = non_players.new(id, name, level, players.types.my_otomo);
				non_players.otomo_list[id] = otomo;

				if cached_config.settings.show_other_player_otomos_separately then
					table.insert(players.display_list, non_players);
				end
			end 
		end

		::continue::
	end
end

function non_players.init_UI(non_player)
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

function non_players.init_module()
	config = require("MHR_Overlay.Misc.config");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	damage_UI_entity = require("MHR_Overlay.UI.UI_Entities.damage_UI_entity");
	time = require("MHR_Overlay.Game_Handler.time");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	drawing = require("MHR_Overlay.UI.drawing");
	language = require("MHR_Overlay.Misc.language");
	players = require("MHR_Overlay.Damage_Meter.players");
	unicode_helpers = require("MHR_Overlay.Misc.unicode_helpers");

	non_players.init();
end

return non_players;