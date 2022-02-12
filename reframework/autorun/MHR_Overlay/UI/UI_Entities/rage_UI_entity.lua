local rage_UI_entity = {};
local table_helpers;
local drawing;
local language;

function rage_UI_entity.new(visibility, bar, text_label, value_label, percentage_label, timer_label)
	local entity = {};

	entity.visibility = visibility;
	entity.bar = table_helpers.deep_copy(bar);
	entity.text_label = table_helpers.deep_copy(text_label);
	entity.value_label = table_helpers.deep_copy(value_label);
	entity.percentage_label = table_helpers.deep_copy(percentage_label);
	entity.timer_label = table_helpers.deep_copy(timer_label);

	return entity;
end

function rage_UI_entity.draw(monster, rage_UI, position_on_screen, opacity_scale)
	if not rage_UI.visibility then
		return;
	end

	if monster.is_in_rage then
		drawing.draw_bar(rage_UI.bar, position_on_screen, opacity_scale, monster.rage_timer_percentage);
		
		drawing.draw_label(rage_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.rage);
		drawing.draw_label(rage_UI.timer_label, position_on_screen, opacity_scale, monster.rage_minutes_left, monster.rage_seconds_left);
	else
		drawing.draw_bar(rage_UI.bar, position_on_screen, opacity_scale, monster.rage_percentage);

		drawing.draw_label(rage_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.rage);
		drawing.draw_label(rage_UI.value_label, position_on_screen, opacity_scale, monster.rage_point, monster.rage_limit);
		drawing.draw_label(rage_UI.percentage_label, position_on_screen, opacity_scale, 100 * monster.rage_percentage);
	end
end

function rage_UI_entity.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	drawing = require("MHR_Overlay.UI.drawing");
	language = require("MHR_Overlay.Misc.language");
end

return rage_UI_entity;