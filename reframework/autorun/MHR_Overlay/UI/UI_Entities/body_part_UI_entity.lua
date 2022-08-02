local body_part_UI_entity = {};
local config;
local table_helpers;
local drawing;

function body_part_UI_entity.new(part_visibility, part_name_label, flinch_visibility, flinch_bar, flinch_text_label,
	flinch_value_label, flinch_percentage_label, break_visibility, break_bar, break_text_label, break_value_label,
	break_percentage_label, loss_visibility, loss_bar, loss_text_label, loss_value_label, loss_health_percentage_label)

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local entity = {};

	entity.part_visibility = part_visibility;
	entity.flinch_visibility = flinch_visibility;
	entity.break_visibility = break_visibility;
	entity.loss_visibility = loss_visibility;

	entity.part_name_label = table_helpers.deep_copy(part_name_label);

	entity.part_name_label.offset.x = entity.part_name_label.offset.x * global_scale_modifier;
	entity.part_name_label.offset.y = entity.part_name_label.offset.y * global_scale_modifier;

	entity.flinch_bar = table_helpers.deep_copy(flinch_bar);
	entity.flinch_text_label = table_helpers.deep_copy(flinch_text_label);
	entity.flinch_value_label = table_helpers.deep_copy(flinch_value_label);
	entity.flinch_percentage_label = table_helpers.deep_copy(flinch_percentage_label);

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

	entity.break_bar = table_helpers.deep_copy(break_bar);
	entity.break_text_label = table_helpers.deep_copy(break_text_label);
	entity.break_value_label = table_helpers.deep_copy(break_value_label);
	entity.break_percentage_label = table_helpers.deep_copy(break_percentage_label);

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

	entity.loss_bar = table_helpers.deep_copy(loss_bar);
	entity.loss_text_label = table_helpers.deep_copy(loss_text_label);
	entity.loss_value_label = table_helpers.deep_copy(loss_value_label);
	entity.loss_health_percentage_label = table_helpers.deep_copy(loss_health_percentage_label);

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

	return entity;
end

function body_part_UI_entity.draw(part, part_UI, cached_config, position_on_screen, opacity_scale)
	if not part_UI.part_visibility then
		return;
	end

	local draw_health = part_UI.flinch_visibility and part.max_health > 0;
	local draw_break = part_UI.break_visibility and part.break_max_health > 0 and part.break_count < part.break_max_count;
	local draw_severe = part_UI.loss_visibility and part.loss_max_health > 0 and not part.is_severed;

	if not draw_health and not draw_break and not draw_severe then
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

	local health_string = string.format("%.0f/%.0f", part.health, part.max_health);
	local break_health_string = string.format("%.0f/%.0f", part.break_health, part.break_max_health);
	local loss_health_string = string.format("%.0f/%.0f", part.loss_health, part.loss_max_health);

	local flinch_position_on_screen = {
		x = position_on_screen.x + cached_config.part_health.offset.x,
		y = position_on_screen.y + cached_config.part_health.offset.y,
		visibility = part_UI.flinch_visibility
	};

	local break_position_on_screen = {
		x = position_on_screen.x + cached_config.part_break.offset.x,
		y = position_on_screen.y + cached_config.part_break.offset.y,
		visibility = part_UI.flinch_visibility
	};

	local loss_position_on_screen = {
		x = position_on_screen.x + cached_config.part_loss.offset.x,
		y = position_on_screen.y + cached_config.part_loss.offset.y,
		part_UI = part_UI.loss_visibility
	};

	if draw_health then
		drawing.draw_bar(part_UI.flinch_bar, flinch_position_on_screen, opacity_scale, part.health_percentage);
	end

	if draw_break  then
		drawing.draw_bar(part_UI.break_bar, break_position_on_screen, opacity_scale, part.break_health_percentage);
	end

	if draw_severe then
		drawing.draw_bar(part_UI.loss_bar, loss_position_on_screen, opacity_scale, part.loss_health_percentage);
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

	if draw_severe then
		drawing.draw_label(part_UI.loss_text_label, loss_position_on_screen, opacity_scale);
		drawing.draw_label(part_UI.loss_value_label, loss_position_on_screen, opacity_scale, loss_health_string);
		drawing.draw_label(part_UI.loss_health_percentage_label, loss_position_on_screen, opacity_scale, 100 * part.loss_health_percentage);
	end
end

function body_part_UI_entity.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	drawing = require("MHR_Overlay.UI.drawing");
	config = require("MHR_Overlay.Misc.config");
end

return body_part_UI_entity;
