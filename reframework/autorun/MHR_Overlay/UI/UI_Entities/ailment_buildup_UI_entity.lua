local this = {};

local utils;
local drawing;
local config;
local players;
local language;

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

function this.new(buildup_bar, highlighted_buildup_bar, ailment_name_label, player_name_label,
                                       buildup_value_label, buildup_percentage_label, total_buildup_label,
                                       total_buildup_value_label)
	local entity = {};

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	--entity.visibility = visibility;
	entity.buildup_bar = utils.table.deep_copy(buildup_bar);
	entity.highlighted_buildup_bar = utils.table.deep_copy(highlighted_buildup_bar);
	entity.ailment_name_label = utils.table.deep_copy(ailment_name_label);
	entity.player_name_label = utils.table.deep_copy(player_name_label);
	entity.buildup_value_label = utils.table.deep_copy(buildup_value_label);
	entity.buildup_percentage_label = utils.table.deep_copy(buildup_percentage_label);
	entity.total_buildup_label = utils.table.deep_copy(total_buildup_label);
	entity.total_buildup_value_label = utils.table.deep_copy(total_buildup_value_label);

	entity.buildup_bar.offset.x = entity.buildup_bar.offset.x * global_scale_modifier;
	entity.buildup_bar.offset.y = entity.buildup_bar.offset.y * global_scale_modifier;
	entity.buildup_bar.size.width = entity.buildup_bar.size.width * global_scale_modifier;
	entity.buildup_bar.size.height = entity.buildup_bar.size.height * global_scale_modifier;
	entity.buildup_bar.outline.thickness = entity.buildup_bar.outline.thickness * global_scale_modifier;
	entity.buildup_bar.outline.offset = entity.buildup_bar.outline.offset * global_scale_modifier;

	entity.highlighted_buildup_bar.offset.x = entity.highlighted_buildup_bar.offset.x * global_scale_modifier;
	entity.highlighted_buildup_bar.offset.y = entity.highlighted_buildup_bar.offset.y * global_scale_modifier;
	entity.highlighted_buildup_bar.size.width = entity.highlighted_buildup_bar.size.width * global_scale_modifier;
	entity.highlighted_buildup_bar.size.height = entity.highlighted_buildup_bar.size.height * global_scale_modifier;
	entity.highlighted_buildup_bar.outline.thickness = entity.highlighted_buildup_bar.outline.thickness *
		global_scale_modifier;
	entity.highlighted_buildup_bar.outline.offset = entity.highlighted_buildup_bar.outline.offset * global_scale_modifier;

	entity.player_name_label.offset.x = entity.player_name_label.offset.x * global_scale_modifier;
	entity.player_name_label.offset.y = entity.player_name_label.offset.y * global_scale_modifier;

	entity.buildup_value_label.offset.x = entity.buildup_value_label.offset.x * global_scale_modifier;
	entity.buildup_value_label.offset.y = entity.buildup_value_label.offset.y * global_scale_modifier;

	entity.buildup_percentage_label.offset.x = entity.buildup_percentage_label.offset.x * global_scale_modifier
	entity.buildup_percentage_label.offset.y = entity.buildup_percentage_label.offset.y * global_scale_modifier;

	entity.total_buildup_label.offset.x = entity.total_buildup_label.offset.x * global_scale_modifier;
	entity.total_buildup_label.offset.y = entity.total_buildup_label.offset.y * global_scale_modifier;

	entity.total_buildup_value_label.offset.x = entity.total_buildup_value_label.offset.x * global_scale_modifier;
	entity.total_buildup_value_label.offset.y = entity.total_buildup_value_label.offset.y * global_scale_modifier;

	return entity;
end

function this.draw(player, player_buildup, ailment_buildup_UI, cached_config, position_on_screen, opacity_scale, top_buildup)
	local player_buildup_bar_percentage = 0;

	if cached_config.settings.buildup_bar_relative_to == "Total Buildup" then
		player_buildup_bar_percentage = player_buildup.buildup_share;
	else
		if top_buildup ~= 0 then
			player_buildup_bar_percentage = player_buildup.buildup / top_buildup;
		end
	end

	if player.type == players.types.myself and cached_config.settings.highlighted_bar == "Me" then
		drawing.draw_bar(ailment_buildup_UI.highlighted_buildup_bar, position_on_screen, opacity_scale, player_buildup_bar_percentage);
	elseif cached_config.settings.highlighted_bar == "Top Buildup" and player_buildup.buildup == top_buildup then
		drawing.draw_bar(ailment_buildup_UI.highlighted_buildup_bar, position_on_screen, opacity_scale, player_buildup_bar_percentage);
	else
		drawing.draw_bar(ailment_buildup_UI.buildup_bar, position_on_screen, opacity_scale, player_buildup_bar_percentage);
	end

	local player_name = tostring(player_buildup.id);
	if player ~= nil then
		player_name = player.name;
	end

	drawing.draw_label(ailment_buildup_UI.player_name_label, position_on_screen, opacity_scale, player_name);
	drawing.draw_label(ailment_buildup_UI.buildup_value_label, position_on_screen, opacity_scale, player_buildup.buildup);
	drawing.draw_label(ailment_buildup_UI.buildup_percentage_label, position_on_screen, opacity_scale, 100 * player_buildup.buildup_share);
end

function this.init_module()
	utils = require("MHR_Overlay.Misc.utils");
	drawing = require("MHR_Overlay.UI.drawing");
	config = require("MHR_Overlay.Misc.config");
	players = require("MHR_Overlay.Damage_Meter.players");
	language = require("MHR_Overlay.Misc.language");
end

return this;
