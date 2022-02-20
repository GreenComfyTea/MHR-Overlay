local body_part_UI_entity = {};
local config;
local table_helpers;
local drawing;

function body_part_UI_entity.new(visibility, bar, name_label, text_label, value_label, percentage_label)
	local entity = {};

	entity.visibility = visibility;
	entity.bar = table_helpers.deep_copy(bar);
	entity.name_label = table_helpers.deep_copy(name_label);
	entity.text_label = table_helpers.deep_copy(text_label);
	entity.value_label = table_helpers.deep_copy(value_label);
	entity.percentage_label = table_helpers.deep_copy(percentage_label);

	entity.bar.offset.x = entity.bar.offset.x * config.current_config.global_settings.modifiers.global_scale_modifier;
	entity.bar.offset.y = entity.bar.offset.y * config.current_config.global_settings.modifiers.global_scale_modifier;
	entity.bar.size.width = entity.bar.size.width * config.current_config.global_settings.modifiers.global_scale_modifier;
	entity.bar.size.height = entity.bar.size.height * config.current_config.global_settings.modifiers.global_scale_modifier;

	entity.name_label.offset.x = entity.name_label.offset.x * config.current_config.global_settings.modifiers.global_scale_modifier;
	entity.name_label.offset.y = entity.name_label.offset.y * config.current_config.global_settings.modifiers.global_scale_modifier;

	entity.text_label.offset.x = entity.text_label.offset.x * config.current_config.global_settings.modifiers.global_scale_modifier;
	entity.text_label.offset.y = entity.text_label.offset.y * config.current_config.global_settings.modifiers.global_scale_modifier;

	entity.value_label.offset.x = entity.value_label.offset.x * config.current_config.global_settings.modifiers.global_scale_modifier;
	entity.value_label.offset.y = entity.value_label.offset.y * config.current_config.global_settings.modifiers.global_scale_modifier;

	entity.percentage_label.offset.x = entity.percentage_label.offset.x * config.current_config.global_settings.modifiers.global_scale_modifier;
	entity.percentage_label.offset.y = entity.percentage_label.offset.y * config.current_config.global_settings.modifiers.global_scale_modifier;

	return entity;
end

function body_part_UI_entity.draw_dynamic(part, position_on_screen, opacity_scale)
	if not part.body_part_dynamic_UI.visibility then
		return;
	end
	
	local part_name = "";
	if config.current_config.large_monster_UI.dynamic.parts.part_name_label.include.part_name then
		part_name = part.name .. " ";
	end
	if config.current_config.large_monster_UI.dynamic.parts.part_name_label.include.flinch_count and part.flinch_count ~= 0 then
		part_name = part_name .. "x" .. tostring(part.flinch_count);
	end
	
	drawing.draw_bar(part.body_part_dynamic_UI.bar, position_on_screen, opacity_scale, part.health_percentage);

	drawing.draw_label(part.body_part_dynamic_UI.name_label, position_on_screen, opacity_scale, part_name);
	drawing.draw_label(part.body_part_dynamic_UI.text_label, position_on_screen, opacity_scale);
	drawing.draw_label(part.body_part_dynamic_UI.value_label, position_on_screen, opacity_scale, part.health, part.max_health);
	drawing.draw_label(part.body_part_dynamic_UI.percentage_label, position_on_screen, opacity_scale, 100 * part.health_percentage);
end

function body_part_UI_entity.draw_static(part, position_on_screen, opacity_scale)
	if not part.body_part_static_UI.visibility then
		return;
	end
	
	local part_name = "";
	if config.current_config.large_monster_UI.static.parts.part_name_label.include.part_name then
		part_name = part.name .. " ";
	end
	if config.current_config.large_monster_UI.static.parts.part_name_label.include.flinch_count and part.flinch_count ~= 0 then
		part_name = part_name .. "x" .. tostring(part.flinch_count);
	end
	
	drawing.draw_bar(part.body_part_static_UI.bar, position_on_screen, opacity_scale, part.health_percentage);

	drawing.draw_label(part.body_part_static_UI.name_label, position_on_screen, opacity_scale, part_name);
	drawing.draw_label(part.body_part_static_UI.text_label, position_on_screen, opacity_scale);
	drawing.draw_label(part.body_part_static_UI.value_label, position_on_screen, opacity_scale, part.health, part.max_health);
	drawing.draw_label(part.body_part_static_UI.percentage_label, position_on_screen, opacity_scale, 100 * part.health_percentage);
end

function body_part_UI_entity.draw_highlighted(part, position_on_screen, opacity_scale)
	if not part.body_part_highlighted_UI.visibility then
		return;
	end
	
	local part_name = "";
	if config.current_config.large_monster_UI.highlighted.parts.part_name_label.include.part_name then
		part_name = part.name .. " ";
	end
	if config.current_config.large_monster_UI.highlighted.parts.part_name_label.include.flinch_count and part.flinch_count ~= 0 then
		part_name = part_name .. "x" .. tostring(part.flinch_count);
	end
	
	drawing.draw_bar(part.body_part_highlighted_UI.bar, position_on_screen, opacity_scale, part.health_percentage);

	drawing.draw_label(part.body_part_highlighted_UI.name_label, position_on_screen, opacity_scale, part_name);
	drawing.draw_label(part.body_part_highlighted_UI.text_label, position_on_screen, opacity_scale);
	drawing.draw_label(part.body_part_highlighted_UI.value_label, position_on_screen, opacity_scale, part.health, part.max_health);
	drawing.draw_label(part.body_part_highlighted_UI.percentage_label, position_on_screen, opacity_scale, 100 * part.health_percentage);
end

function body_part_UI_entity.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	drawing = require("MHR_Overlay.UI.drawing");
	config = require("MHR_Overlay.Misc.config");
end

return body_part_UI_entity;