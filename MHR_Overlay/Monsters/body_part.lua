local body_part = {};
local singletons;
local customization_menu;
local config;
local table_helpers;
local health_UI_entity;
local stamina_UI_entity;
local rage_UI_entity;
local body_part_UI_entity;
local screen;
local drawing;

body_part.list = {};

function body_part.new(REpart, id)
	local part = {};

	part.REpart = REpart;
	part.id = id;

	part.health = 99999;
	part.max_health = 99999;
	part.health_percentage = 0;

	part.name = "??";
	part.break_count = 0;

	body_part.init_dynamic_UI(part);
	body_part.init_static_UI(part);

	return part;
end


function body_part.init_dynamic_UI(part)
	part.body_part_dynamic_UI = body_part_UI_entity.new(
		config.current_config.large_monster_UI.dynamic.parts.bar,
		config.current_config.large_monster_UI.dynamic.parts.part_name_label,
		config.current_config.large_monster_UI.dynamic.parts.text_label,
		config.current_config.large_monster_UI.dynamic.parts.value_label,
		config.current_config.large_monster_UI.dynamic.parts.percentage_label
	);
end

function body_part.init_static_UI(part)
	part.body_part_static_UI = body_part_UI_entity.new(
		config.current_config.large_monster_UI.static.parts.bar,
		config.current_config.large_monster_UI.static.parts.part_name_label,
		config.current_config.large_monster_UI.static.parts.text_label,
		config.current_config.large_monster_UI.static.parts.value_label,
		config.current_config.large_monster_UI.static.parts.percentage_label
	);
end

function body_part.update(part, new_health, new_max_health)
	if part == nil then
		return;
	end

	if new_health > part.health then
		part.break_count = part.break_count + 1;
	end
	
	part.health = new_health;
	part.max_health = new_max_health;

	if part.max_health ~= 0 then
		part.health_percentage = part.health / part.max_health;
	end
end

function body_part.draw_dynamic(part, position_on_screen, opacity_scale)
	body_part_UI_entity.draw_dynamic(part, position_on_screen, opacity_scale);
end

function body_part.draw_static(part, position_on_screen, opacity_scale)
	body_part_UI_entity.draw_static(part, position_on_screen, opacity_scale);
end

function body_part.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	config = require("MHR_Overlay.Misc.config");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
	rage_UI_entity = require("MHR_Overlay.UI.UI_Entities.rage_UI_entity");
	body_part_UI_entity = require("MHR_Overlay.UI.UI_Entities.body_part_UI_entity");
	screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
end

return body_part;