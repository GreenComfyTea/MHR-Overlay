local stamina_UI_entity = {};
local table_helpers;
local drawing;

function stamina_UI_entity.new(visibility, bar, text_label, value_label, percentage_label)
	local entity = {};

	entity.visibility = visibility;
	entity.bar = table_helpers.deep_copy(bar);
	entity.text_label = table_helpers.deep_copy(text_label);
	entity.value_label = table_helpers.deep_copy(value_label);
	entity.percentage_label = table_helpers.deep_copy(percentage_label);

	return entity;
end

function stamina_UI_entity.draw(monster, stamina_UI, position_on_screen, opacity_scale)
	if not stamina_UI.visibility then
		return;
	end

	drawing.draw_bar(stamina_UI.bar, position_on_screen, opacity_scale, monster.stamina_percentage);

	drawing.draw_label(stamina_UI.text_label, position_on_screen, opacity_scale);
	drawing.draw_label(stamina_UI.value_label, position_on_screen, opacity_scale, monster.stamina, monster.max_stamina);
	drawing.draw_label(stamina_UI.percentage_label, position_on_screen, opacity_scale, 100 * monster.stamina_percentage);
end

function stamina_UI_entity.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	drawing = require("MHR_Overlay.UI.drawing");
end

return stamina_UI_entity;