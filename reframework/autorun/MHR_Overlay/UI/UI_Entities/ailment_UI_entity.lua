local ailment_UI_entity = {};
local config;
local table_helpers;
local drawing;
local language;

function ailment_UI_entity.new(visibility, bar, name_label, text_label, value_label, percentage_label, timer_label)
	local entity = {};

	entity.visibility = visibility;
	entity.bar = table_helpers.deep_copy(bar);
	entity.name_label = table_helpers.deep_copy(name_label);
	entity.text_label = table_helpers.deep_copy(text_label);
	entity.value_label = table_helpers.deep_copy(value_label);
	entity.percentage_label = table_helpers.deep_copy(percentage_label);
	entity.timer_label = table_helpers.deep_copy(timer_label);

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

	entity.timer_label.offset.x = entity.timer_label.offset.x * config.current_config.global_settings.modifiers.global_scale_modifier;
	entity.timer_label.offset.y = entity.timer_label.offset.y * config.current_config.global_settings.modifiers.global_scale_modifier;

	return entity;
end

function ailment_UI_entity.draw_dynamic(ailment, ailment_UI, position_on_screen, opacity_scale)
	if not ailment_UI.visibility then
		return;
	end

	local ailment_name = "";
	if config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.include.ailment_name then
		ailment_name = ailment.name .. " ";
	end
	if config.current_config.large_monster_UI.dynamic.ailments.ailment_name_label.include.activation_count and ailment.activate_count ~= 0 then
		ailment_name = ailment_name .. "x" .. tostring(ailment.activate_count);
	end

	if ailment.is_active then
		drawing.draw_bar(ailment_UI.bar, position_on_screen, opacity_scale, ailment.timer_percentage);
		
		drawing.draw_label(ailment_UI.name_label, position_on_screen, opacity_scale, ailment_name);
		drawing.draw_label(ailment_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.buildup);
		drawing.draw_label(ailment_UI.timer_label, position_on_screen, opacity_scale, 0, ailment.timer);
	else
		drawing.draw_bar(ailment_UI.bar, position_on_screen, opacity_scale, ailment.buildup_percentage);

		drawing.draw_label(ailment_UI.name_label, position_on_screen, opacity_scale, ailment_name);
		drawing.draw_label(ailment_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.buildup);
		drawing.draw_label(ailment_UI.value_label, position_on_screen, opacity_scale, ailment.total_buildup, ailment.buildup_limit);
		drawing.draw_label(ailment_UI.percentage_label, position_on_screen, opacity_scale, 100 * ailment.buildup_percentage);
	end
end

function ailment_UI_entity.draw_static(ailment, ailment_UI, position_on_screen, opacity_scale)
	if not ailment_UI.visibility then
		return;
	end

	local ailment_name = "";
	if config.current_config.large_monster_UI.static.ailments.ailment_name_label.include.ailment_name then
		ailment_name = ailment.name .. " ";
	end
	if config.current_config.large_monster_UI.static.ailments.ailment_name_label.include.activation_count and ailment.activate_count ~= 0 then
		ailment_name = ailment_name .. "x" .. tostring(ailment.activate_count);
	end

	if ailment.is_active then
		drawing.draw_bar(ailment_UI.bar, position_on_screen, opacity_scale, ailment.timer_percentage);
		
		drawing.draw_label(ailment_UI.name_label, position_on_screen, opacity_scale, ailment_name);
		drawing.draw_label(ailment_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.buildup);
		drawing.draw_label(ailment_UI.timer_label, position_on_screen, opacity_scale, 0, ailment.timer);
	else
		drawing.draw_bar(ailment_UI.bar, position_on_screen, opacity_scale, ailment.buildup_percentage);

		drawing.draw_label(ailment_UI.name_label, position_on_screen, opacity_scale, ailment_name);
		drawing.draw_label(ailment_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.buildup);
		drawing.draw_label(ailment_UI.value_label, position_on_screen, opacity_scale, ailment.total_buildup, ailment.buildup_limit);
		drawing.draw_label(ailment_UI.percentage_label, position_on_screen, opacity_scale, 100 * ailment.buildup_percentage);
	end
end

function ailment_UI_entity.draw_highlighted(ailment, ailment_UI, position_on_screen, opacity_scale)
	if not ailment_UI.visibility then
		return;
	end

	local ailment_name = "";
	if config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.include.ailment_name then
		ailment_name = ailment.name .. " ";
	end
	if config.current_config.large_monster_UI.highlighted.ailments.ailment_name_label.include.activation_count and ailment.activate_count ~= 0 then
		ailment_name = ailment_name .. "x" .. tostring(ailment.activate_count);
	end

	if ailment.is_active then
		drawing.draw_bar(ailment_UI.bar, position_on_screen, opacity_scale, ailment.timer_percentage);
		
		drawing.draw_label(ailment_UI.name_label, position_on_screen, opacity_scale, ailment_name);
		drawing.draw_label(ailment_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.buildup);
		drawing.draw_label(ailment_UI.timer_label, position_on_screen, opacity_scale, 0, ailment.timer);
	else
		drawing.draw_bar(ailment_UI.bar, position_on_screen, opacity_scale, ailment.buildup_percentage);

		drawing.draw_label(ailment_UI.name_label, position_on_screen, opacity_scale, ailment_name);
		drawing.draw_label(ailment_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.buildup);
		drawing.draw_label(ailment_UI.value_label, position_on_screen, opacity_scale, ailment.total_buildup, ailment.buildup_limit);
		drawing.draw_label(ailment_UI.percentage_label, position_on_screen, opacity_scale, 100 * ailment.buildup_percentage);
	end
end

function ailment_UI_entity.draw_small(ailment, ailment_UI, position_on_screen, opacity_scale)
	if not ailment_UI.visibility then
		return;
	end

	local ailment_name = "";
	if config.current_config.small_monster_UI.ailments.ailment_name_label.include.ailment_name then
		ailment_name = ailment.name .. " ";
	end
	if config.current_config.small_monster_UI.ailments.ailment_name_label.include.activation_count and ailment.activate_count ~= 0 then
		ailment_name = ailment_name .. "x" .. tostring(ailment.activate_count);
	end

	if ailment.is_active then
		drawing.draw_bar(ailment_UI.bar, position_on_screen, opacity_scale, ailment.timer_percentage);
		
		drawing.draw_label(ailment_UI.name_label, position_on_screen, opacity_scale, ailment_name);
		drawing.draw_label(ailment_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.buildup);
		drawing.draw_label(ailment_UI.timer_label, position_on_screen, opacity_scale, 0, ailment.timer);
	else
		drawing.draw_bar(ailment_UI.bar, position_on_screen, opacity_scale, ailment.buildup_percentage);

		drawing.draw_label(ailment_UI.name_label, position_on_screen, opacity_scale, ailment_name);
		drawing.draw_label(ailment_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.buildup);
		drawing.draw_label(ailment_UI.value_label, position_on_screen, opacity_scale, ailment.total_buildup, ailment.buildup_limit);
		drawing.draw_label(ailment_UI.percentage_label, position_on_screen, opacity_scale, 100 * ailment.buildup_percentage);
	end
end

function ailment_UI_entity.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	drawing = require("MHR_Overlay.UI.drawing");
	config = require("MHR_Overlay.Misc.config");
	language = require("MHR_Overlay.Misc.language");
end

return ailment_UI_entity;