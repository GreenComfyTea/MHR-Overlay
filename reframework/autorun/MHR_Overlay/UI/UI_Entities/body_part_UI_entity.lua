local this = {};

local config;
local utils;
local drawing;

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

function this.new(part_visibility, part_name_label,
	flinch_visibility, flinch_bar, flinch_text_label, flinch_value_label, flinch_percentage_label,
	break_visibility, break_bar, break_text_label, break_value_label, break_percentage_label,
	loss_visibility, loss_bar, loss_text_label, loss_value_label, loss_health_percentage_label,
	anomaly_visibility, anomaly_bar, anomaly_text_label, anomaly_value_label, anomaly_health_percentage_label)

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local entity = {};

	entity.part_visibility = part_visibility;
	entity.flinch_visibility = flinch_visibility;
	entity.break_visibility = break_visibility;
	entity.loss_visibility = loss_visibility;
	entity.anomaly_visibility = anomaly_visibility;

	entity.part_name_label = utils.table.deep_copy(part_name_label);

	entity.part_name_label.offset.x = entity.part_name_label.offset.x * global_scale_modifier;
	entity.part_name_label.offset.y = entity.part_name_label.offset.y * global_scale_modifier;

	entity.flinch_bar = utils.table.deep_copy(flinch_bar);
	entity.flinch_text_label = utils.table.deep_copy(flinch_text_label);
	entity.flinch_value_label = utils.table.deep_copy(flinch_value_label);
	entity.flinch_percentage_label = utils.table.deep_copy(flinch_percentage_label);

	entity.flinch_bar.offset.x = entity.flinch_bar.offset.x * global_scale_modifier;
	entity.flinch_bar.offset.y = entity.flinch_bar.offset.y * global_scale_modifier;
	entity.flinch_bar.size.width = entity.flinch_bar.size.width * global_scale_modifier;
	entity.flinch_bar.size.height = entity.flinch_bar.size.height * global_scale_modifier;
	entity.flinch_bar.outline.thickness = entity.flinch_bar.outline.thickness * global_scale_modifier;
	entity.flinch_bar.outline.offset = entity.flinch_bar.outline.offset * global_scale_modifier;

	entity.flinch_text_label.offset.x = entity.flinch_text_label.offset.x * global_scale_modifier;
	entity.flinch_text_label.offset.y = entity.flinch_text_label.offset.y * global_scale_modifier;

	entity.flinch_value_label.offset.x = entity.flinch_value_label.offset.x * global_scale_modifier;
	entity.flinch_value_label.offset.y = entity.flinch_value_label.offset.y * global_scale_modifier;

	entity.flinch_percentage_label.offset.x = entity.flinch_percentage_label.offset.x * global_scale_modifier;
	entity.flinch_percentage_label.offset.y = entity.flinch_percentage_label.offset.y * global_scale_modifier;

	entity.break_bar = utils.table.deep_copy(break_bar);
	entity.break_text_label = utils.table.deep_copy(break_text_label);
	entity.break_value_label = utils.table.deep_copy(break_value_label);
	entity.break_percentage_label = utils.table.deep_copy(break_percentage_label);

	entity.break_bar.offset.x = entity.break_bar.offset.x * global_scale_modifier;
	entity.break_bar.offset.y = entity.break_bar.offset.y * global_scale_modifier;
	entity.break_bar.size.width = entity.break_bar.size.width * global_scale_modifier;
	entity.break_bar.size.height = entity.break_bar.size.height * global_scale_modifier;
	entity.break_bar.outline.thickness = entity.break_bar.outline.thickness * global_scale_modifier;
	entity.break_bar.outline.offset = entity.break_bar.outline.offset * global_scale_modifier;

	entity.break_text_label.offset.x = entity.break_text_label.offset.x * global_scale_modifier;
	entity.break_text_label.offset.y = entity.break_text_label.offset.y * global_scale_modifier;

	entity.break_value_label.offset.x = entity.break_value_label.offset.x * global_scale_modifier;
	entity.break_value_label.offset.y = entity.break_value_label.offset.y * global_scale_modifier;

	entity.break_percentage_label.offset.x = entity.break_percentage_label.offset.x * global_scale_modifier;
	entity.break_percentage_label.offset.y = entity.break_percentage_label.offset.y * global_scale_modifier;

	entity.loss_bar = utils.table.deep_copy(loss_bar);
	entity.loss_text_label = utils.table.deep_copy(loss_text_label);
	entity.loss_value_label = utils.table.deep_copy(loss_value_label);
	entity.loss_health_percentage_label = utils.table.deep_copy(loss_health_percentage_label);

	entity.loss_bar.offset.x = entity.loss_bar.offset.x * global_scale_modifier;
	entity.loss_bar.offset.y = entity.loss_bar.offset.y * global_scale_modifier;
	entity.loss_bar.size.width = entity.loss_bar.size.width * global_scale_modifier;
	entity.loss_bar.size.height = entity.loss_bar.size.height * global_scale_modifier;
	entity.loss_bar.outline.thickness = entity.loss_bar.outline.thickness * global_scale_modifier;
	entity.loss_bar.outline.offset = entity.loss_bar.outline.offset * global_scale_modifier;

	entity.loss_text_label.offset.x = entity.loss_text_label.offset.x * global_scale_modifier;
	entity.loss_text_label.offset.y = entity.loss_text_label.offset.y * global_scale_modifier;

	entity.loss_value_label.offset.x = entity.loss_value_label.offset.x * global_scale_modifier;
	entity.loss_value_label.offset.y = entity.loss_value_label.offset.y * global_scale_modifier;

	entity.loss_health_percentage_label.offset.x = entity.loss_health_percentage_label.offset.x * global_scale_modifier;
	entity.loss_health_percentage_label.offset.y = entity.loss_health_percentage_label.offset.y * global_scale_modifier;

	entity.anomaly_bar = utils.table.deep_copy(anomaly_bar);
	entity.anomaly_text_label = utils.table.deep_copy(anomaly_text_label);
	entity.anomaly_value_label = utils.table.deep_copy(anomaly_value_label);
	entity.anomaly_health_percentage_label = utils.table.deep_copy(anomaly_health_percentage_label);

	entity.anomaly_bar.offset.x = entity.anomaly_bar.offset.x * global_scale_modifier;
	entity.anomaly_bar.offset.y = entity.anomaly_bar.offset.y * global_scale_modifier;
	entity.anomaly_bar.size.width = entity.anomaly_bar.size.width * global_scale_modifier;
	entity.anomaly_bar.size.height = entity.anomaly_bar.size.height * global_scale_modifier;
	entity.anomaly_bar.outline.thickness = entity.anomaly_bar.outline.thickness * global_scale_modifier;
	entity.anomaly_bar.outline.offset = entity.anomaly_bar.outline.offset * global_scale_modifier;

	entity.anomaly_text_label.offset.x = entity.anomaly_text_label.offset.x * global_scale_modifier;
	entity.anomaly_text_label.offset.y = entity.anomaly_text_label.offset.y * global_scale_modifier;

	entity.anomaly_value_label.offset.x = entity.anomaly_value_label.offset.x * global_scale_modifier;
	entity.anomaly_value_label.offset.y = entity.anomaly_value_label.offset.y * global_scale_modifier;

	entity.anomaly_health_percentage_label.offset.x = entity.anomaly_health_percentage_label.offset.x * global_scale_modifier;
	entity.anomaly_health_percentage_label.offset.y = entity.anomaly_health_percentage_label.offset.y * global_scale_modifier;

	return entity;
end

function this.draw(part, part_UI, cached_config, position_on_screen, opacity_scale)
	if not part_UI.part_visibility then
		return;
	end

	local draw_health = part_UI.flinch_visibility and part.max_health > 0;
	local draw_break = part_UI.break_visibility and part.break_max_health > 0 and part.break_count < part.break_max_count;
	local draw_sever = part_UI.loss_visibility and part.loss_max_health > 0 and not part.is_severed;
	local draw_anomaly = part_UI.anomaly_visibility and part.anomaly_max_health > 0 and (part.anomaly_is_active or cached_config.settings.render_inactive_anomaly_cores);

	if not draw_health and not draw_break and not draw_sever and not draw_anomaly then
		return;
	end

	local part_name = "";
	if cached_config.part_name_label.include.part_name then
		part_name = part.name .. " ";
	end
	if cached_config.part_name_label.include.flinch_count and part.flinch_count ~= 0 then
		part_name = part_name .. "x" .. tostring(part.flinch_count) .. " ";
	end

	if part.break_max_count ~= 0 then
		if cached_config.part_name_label.include.break_count then
			if cached_config.part_name_label.include.break_max_count then
				part_name = part_name .. tostring(part.break_count) .. "/" .. tostring(part.break_max_count);

			elseif part.flinch_count ~= 0 then
				part_name = part_name .. "x" .. tostring(part.break_count);
			end
		elseif cached_config.part_name_label.include.break_max_count then
			part_name = part_name .. "/" .. tostring(part.break_max_count);
		end
	end

	-- health value string
	local health_string = "";
	if draw_health then
		local include_health_current_value = part_UI.flinch_value_label.include.current_value;
		local include_health_max_value = part_UI.flinch_value_label.include.max_value;

		if include_health_current_value and include_health_max_value then
			health_string = string.format("%.0f/%.0f", part.health, part.max_health);
		elseif include_health_current_value then
			health_string = string.format("%.0f", part.health);
		elseif include_health_max_value then
			health_string = string.format("%.0f", part.max_health);
		end
	end
	
	-- break health value string
	local break_health_string = "";
	if draw_break then
		local include_break_health_current_value = part_UI.break_value_label.include.current_value;
		local include_break_health_max_value = part_UI.break_value_label.include.max_value;

		if include_break_health_current_value and include_break_health_max_value then
			break_health_string = string.format("%.0f/%.0f", part.break_health, part.break_max_health);
		elseif include_break_health_current_value then
			break_health_string = string.format("%.0f", part.break_health);
		elseif include_break_health_max_value then
			break_health_string = string.format("%.0f", part.break_max_health);
		end
	end

	-- loss health value string
	local loss_health_string = "";
	if draw_sever then
		local include_loss_health_current_value = part_UI.loss_value_label.include.current_value;
		local include_loss_health_max_value = part_UI.loss_value_label.include.max_value;

		if include_loss_health_current_value and include_loss_health_max_value then
			loss_health_string = string.format("%.0f/%.0f", part.loss_health, part.loss_max_health);
		elseif include_loss_health_current_value then
			loss_health_string = string.format("%.0f", part.loss_health);
		elseif include_loss_health_max_value then
			loss_health_string = string.format("%.0f", part.loss_max_health);
		end
	end

	-- anomaly health value string
	local anomaly_health_string = "";
	if draw_anomaly then
		local include_anomaly_health_current_value = part_UI.anomaly_value_label.include.current_value;
		local include_anomaly_health_max_value = part_UI.anomaly_value_label.include.max_value;

		if include_anomaly_health_current_value and include_anomaly_health_max_value then
			anomaly_health_string = string.format("%.0f/%.0f", part.anomaly_health, part.anomaly_max_health);
		elseif include_anomaly_health_current_value then
			anomaly_health_string = string.format("%.0f", part.anomaly_health);
		elseif include_anomaly_health_max_value then
			anomaly_health_string = string.format("%.0f", part.anomaly_max_health);
		end
	end

	local flinch_position_on_screen = {
		x = position_on_screen.x + cached_config.part_health.offset.x,
		y = position_on_screen.y + cached_config.part_health.offset.y,
	};

	local break_position_on_screen = {
		x = position_on_screen.x + cached_config.part_break.offset.x,
		y = position_on_screen.y + cached_config.part_break.offset.y,
	};

	local loss_position_on_screen = {
		x = position_on_screen.x + cached_config.part_loss.offset.x,
		y = position_on_screen.y + cached_config.part_loss.offset.y,
	};

	local anomaly_position_on_screen = {
		x = position_on_screen.x + cached_config.part_anomaly.offset.x,
		y = position_on_screen.y + cached_config.part_anomaly.offset.y,
	};

	if draw_health then
		drawing.draw_bar(part_UI.flinch_bar, flinch_position_on_screen, opacity_scale, part.health_percentage);
	end

	if draw_break then
		drawing.draw_bar(part_UI.break_bar, break_position_on_screen, opacity_scale, part.break_health_percentage);
	end

	if draw_sever then
		drawing.draw_bar(part_UI.loss_bar, loss_position_on_screen, opacity_scale, part.loss_health_percentage);
	end

	if draw_anomaly then
		drawing.draw_bar(part_UI.anomaly_bar, anomaly_position_on_screen, opacity_scale, part.anomaly_health_percentage);
	end

	drawing.draw_label(part_UI.part_name_label, position_on_screen, opacity_scale, part_name);

	if draw_health then
		drawing.draw_label(part_UI.flinch_text_label, flinch_position_on_screen, opacity_scale);
		drawing.draw_label(part_UI.flinch_value_label, flinch_position_on_screen, opacity_scale, health_string);
		drawing.draw_label(part_UI.flinch_percentage_label, flinch_position_on_screen, opacity_scale, 100 * part.health_percentage);
	end

	if draw_break then
		drawing.draw_label(part_UI.break_text_label, break_position_on_screen, opacity_scale);
		drawing.draw_label(part_UI.break_value_label, break_position_on_screen, opacity_scale, break_health_string);
		drawing.draw_label(part_UI.break_percentage_label, break_position_on_screen, opacity_scale, 100 * part.break_health_percentage);
	end

	if draw_sever then
		drawing.draw_label(part_UI.loss_text_label, loss_position_on_screen, opacity_scale);
		drawing.draw_label(part_UI.loss_value_label, loss_position_on_screen, opacity_scale, loss_health_string);
		drawing.draw_label(part_UI.loss_health_percentage_label, loss_position_on_screen, opacity_scale, 100 * part.loss_health_percentage);
	end

	if draw_anomaly then
		drawing.draw_label(part_UI.anomaly_text_label, anomaly_position_on_screen, opacity_scale);
		drawing.draw_label(part_UI.anomaly_value_label, anomaly_position_on_screen, opacity_scale, anomaly_health_string);
		drawing.draw_label(part_UI.anomaly_health_percentage_label, anomaly_position_on_screen, opacity_scale, 100 * part.anomaly_health_percentage);
	end
end

function this.init_module()
	utils = require("MHR_Overlay.Misc.utils");
	drawing = require("MHR_Overlay.UI.drawing");
	config = require("MHR_Overlay.Misc.config");
end

return this;
