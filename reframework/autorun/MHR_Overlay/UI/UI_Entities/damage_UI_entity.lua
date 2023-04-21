local damage_UI_entity = {};

local utils;
local drawing;
local config;
local players;
local language;
local quest_status;
local non_players;

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

function damage_UI_entity.new(damage_meter_UI_elements, type)
	local entity = {};

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	entity.bar = utils.table.deep_copy(damage_meter_UI_elements.damage_bar);
	entity.name_label = utils.table.deep_copy(damage_meter_UI_elements.name_label);
	entity.hunter_rank_label = utils.table.deep_copy(damage_meter_UI_elements.hunter_rank_label);
	entity.cart_count_label = utils.table.deep_copy(damage_meter_UI_elements.cart_count_label);
	entity.dps_label = utils.table.deep_copy(damage_meter_UI_elements.dps_label);
	entity.value_label = utils.table.deep_copy(damage_meter_UI_elements.damage_value_label);
	entity.percentage_label = utils.table.deep_copy(damage_meter_UI_elements.damage_percentage_label);

	entity.player_name_size_limit = config.current_config.damage_meter_UI.settings.player_name_size_limit;

	if type == players.types.total then
		entity.total_name = language.current_language.UI.total_damage;
	elseif type == players.types.myself or type == players.types.other_players then
		entity.type_name = language.current_language.UI.player;
	elseif type == players.types.servant then
		entity.type_name = language.current_language.UI.servant;
	else
		entity.type_name = language.current_language.UI.otomo;
	end 

	if entity.bar ~= nil then
		entity.bar.offset.x = entity.bar.offset.x * global_scale_modifier;
		entity.bar.offset.y = entity.bar.offset.y * global_scale_modifier;
		entity.bar.size.width = entity.bar.size.width * global_scale_modifier;
		entity.bar.size.height = entity.bar.size.height * global_scale_modifier;
		entity.bar.outline.thickness = entity.bar.outline.thickness * global_scale_modifier;
		entity.bar.outline.offset = entity.bar.outline.offset * global_scale_modifier;
	end

	if entity.name_label ~= nil then
		entity.name_label.offset.x = entity.name_label.offset.x * global_scale_modifier;
		entity.name_label.offset.y = entity.name_label.offset.y * global_scale_modifier;
	end

	if entity.player_name_size_limit ~= nil then
		entity.player_name_size_limit = entity.player_name_size_limit * global_scale_modifier;
	end

	if entity.hunter_rank_label ~= nil then
		entity.hunter_rank_label.offset.x = entity.hunter_rank_label.offset.x * global_scale_modifier;
		entity.hunter_rank_label.offset.y = entity.hunter_rank_label.offset.y * global_scale_modifier;
	end
	
	if entity.cart_count_label ~= nil then
		entity.cart_count_label.offset.x = entity.cart_count_label.offset.x * global_scale_modifier;
		entity.cart_count_label.offset.y = entity.cart_count_label.offset.y * global_scale_modifier;
	end

	if entity.dps_label ~= nil then
		entity.dps_label.offset.x = entity.dps_label.offset.x * global_scale_modifier;
		entity.dps_label.offset.y = entity.dps_label.offset.y * global_scale_modifier;
	end

	if entity.value_label ~= nil then
		entity.value_label.offset.x = entity.value_label.offset.x * global_scale_modifier;
		entity.value_label.offset.y = entity.value_label.offset.y * global_scale_modifier;
	end

	if 	entity.percentage_label ~= nil then
		entity.percentage_label.offset.x = entity.percentage_label.offset.x * global_scale_modifier;
		entity.percentage_label.offset.y = entity.percentage_label.offset.y * global_scale_modifier;
	end

	return entity;
end

function damage_UI_entity.draw(player, position_on_screen, opacity_scale, top_damage, top_dps)
	local cached_config = config.current_config.damage_meter_UI;

	local name_include = nil;
	if player.damage_UI.name_label ~= nil then
		name_include = player.damage_UI.name_label.include;
	end

	local hunter_rank_include = nil;
	if player.damage_UI.hunter_rank_label ~= nil then
		hunter_rank_include = player.damage_UI.hunter_rank_label.include;
	end

	local is_on_quest = quest_status.flow_state ~= quest_status.flow_states.IN_LOBBY and quest_status.flow_state ~= quest_status.flow_states.IN_TRAINING_AREA;

	local player_damage_percentage = 0;
	if players.total.display.total_damage ~= 0 then
		player_damage_percentage = player.display.total_damage / players.total.display.total_damage;
	end

	local player_damage_bar_percentage = 0;

	if player.type ~= players.types.total then
		if cached_config.settings.damage_bar_relative_to == "Total Damage" then
			if players.total.display.total_damage ~= 0 then
				player_damage_bar_percentage = player.display.total_damage / players.total.display.total_damage;
			end
		else
			if top_damage ~= 0 then
				player_damage_bar_percentage = player.display.total_damage / top_damage;
			end
		end
	end

	local name_text = "";

	if player.type == players.types.total then
		name_text = player.damage_UI.total_name;
	elseif name_include ~= nil then

		if name_include.master_rank and name_include.hunter_rank then
			name_text = string.format("[%d:%d] ", player.master_rank, player.hunter_rank);
		elseif name_include.master_rank then
			name_text = string.format("[%d] ", player.master_rank);
		elseif name_include.hunter_rank then
			name_text = string.format("[%d] ", player.hunter_rank);
		elseif name_include.level then
			name_text = string.format("[%d] ", player.level);
		end

		if name_include.cart_count and is_on_quest then
			name_text = name_text .. string.format("x%d ", player.cart_count);
		end
	
		if name_include.type then
			name_text = name_text .. player.damage_UI.type_name .. " ";
		end
	
		if name_include.id then
			name_text = name_text .. string.format("%d ", player.id);
		end
	
		if name_include.name then
			name_text = name_text .. player.name;
		end
	end

	local hunter_rank_string = "";

	if player.damage_UI.hunter_rank_label ~= nil then
		if hunter_rank_include == nil then
			hunter_rank_string = string.format("%d", player.level);
		elseif hunter_rank_include.master_rank and hunter_rank_include.hunter_rank then
			hunter_rank_string = string.format("%d:%d", player.master_rank, player.hunter_rank);

		elseif hunter_rank_include.master_rank then
			hunter_rank_string = string.format("%d", player.master_rank);

		elseif hunter_rank_include.hunter_rank then
			hunter_rank_string = string.format("%d", player.hunter_rank);
		end
	end

	local bar = player.damage_UI.bar;
	local name_label = player.damage_UI.name_label;
	local hunter_rank_label = player.damage_UI.hunter_rank_label;
	local value_label = player.damage_UI.value_label;
	local percentage_label = player.damage_UI.percentage_label;
	local dps_label = player.damage_UI.dps_label;

	if player.type ~= players.types.total then
		if (cached_config.settings.highlighted_bar == "Top Damage" and player.display.total_damage == top_damage and top_damage ~= 0) or
		(cached_config.settings.highlighted_bar == "Top DPS" and player.dps == top_dps and top_dps ~= 0) then
			bar = players.highlighted_damage_UI.bar;
			name_label = players.highlighted_damage_UI.name_label;
			hunter_rank_label = players.highlighted_damage_UI.hunter_rank_label;
			value_label = players.highlighted_damage_UI.value_label;
			percentage_label = players.highlighted_damage_UI.percentage_label;
			dps_label = players.highlighted_damage_UI.dps_label;
		end
	end

	drawing.draw_bar(bar, position_on_screen, opacity_scale, player_damage_bar_percentage);

	name_text = drawing.limit_text_size(name_text, player.damage_UI.player_name_size_limit);

	drawing.draw_label(name_label, position_on_screen, opacity_scale, name_text);
	drawing.draw_label(hunter_rank_label, position_on_screen, opacity_scale, hunter_rank_string);
	drawing.draw_label(value_label, position_on_screen, opacity_scale, player.display.total_damage);
	drawing.draw_label(percentage_label, position_on_screen, opacity_scale, 100 * player_damage_percentage);
	drawing.draw_label(dps_label, position_on_screen, opacity_scale, player.dps);
	
	if is_on_quest then
		if player.type == players.types.total then
			drawing.draw_label(player.damage_UI.cart_count_label, position_on_screen, opacity_scale, quest_status.cart_count, quest_status.max_cart_count);
		else
			drawing.draw_label(player.damage_UI.cart_count_label, position_on_screen, opacity_scale, player.cart_count);
		end
		
	end
end

function damage_UI_entity.init_module()
	utils = require("MHR_Overlay.Misc.utils");
	drawing = require("MHR_Overlay.UI.drawing");
	config = require("MHR_Overlay.Misc.config");
	players = require("MHR_Overlay.Damage_Meter.players");
	language = require("MHR_Overlay.Misc.language");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
end

return damage_UI_entity;
