local health_UI_entity = {};
local table_helpers;
local drawing;
local language;

function health_UI_entity.new(visibility, bar, text_label, value_label, percentage_label)
	local entity = {};

	entity.visibility = visibility;
	entity.bar = table_helpers.deep_copy(bar);
	entity.text_label = table_helpers.deep_copy(text_label);
	entity.value_label = table_helpers.deep_copy(value_label);
	entity.percentage_label = table_helpers.deep_copy(percentage_label);

	return entity;
end

function health_UI_entity.draw(monster, health_UI, position_on_screen, opacity_scale)
	if not health_UI.visibility then
		return;
	end

	drawing.draw_bar(health_UI.bar, position_on_screen, opacity_scale, monster.health_percentage);

	drawing.draw_label(health_UI.text_label, position_on_screen, opacity_scale, language.current_language.UI.HP);
	drawing.draw_label(health_UI.value_label, position_on_screen, opacity_scale, monster.health, monster.max_health);
	drawing.draw_label(health_UI.percentage_label, position_on_screen, opacity_scale, 100 * monster.health_percentage);
end

function health_UI_entity.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	drawing = require("MHR_Overlay.UI.drawing");
	language = require("MHR_Overlay.Misc.language");
end

return health_UI_entity;