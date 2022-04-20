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
local part_names;
local time;

body_part.list = {};

function body_part.new(REpart, name, id)
	local part = {};

	part.REpart = REpart;
	part.id = id;

	part.health = 99999;
	part.max_health = 99999;
	part.health_percentage = 0;

	part.name = name;
	part.flinch_count = 0;

	part.last_change_time = time.total_elapsed_seconds;

	body_part.init_dynamic_UI(part);
	body_part.init_static_UI(part);
	body_part.init_highlighted_UI(part);

	return part;
end


function body_part.init_dynamic_UI(part)
	part.body_part_dynamic_UI = body_part_UI_entity.new(
		config.current_config.large_monster_UI.dynamic.parts.visibility,
		config.current_config.large_monster_UI.dynamic.parts.bar,
		config.current_config.large_monster_UI.dynamic.parts.part_name_label,
		config.current_config.large_monster_UI.dynamic.parts.text_label,
		config.current_config.large_monster_UI.dynamic.parts.value_label,
		config.current_config.large_monster_UI.dynamic.parts.percentage_label
	);
end

function body_part.init_static_UI(part)
	part.body_part_static_UI = body_part_UI_entity.new(
		config.current_config.large_monster_UI.static.parts.visibility,
		config.current_config.large_monster_UI.static.parts.bar,
		config.current_config.large_monster_UI.static.parts.part_name_label,
		config.current_config.large_monster_UI.static.parts.text_label,
		config.current_config.large_monster_UI.static.parts.value_label,
		config.current_config.large_monster_UI.static.parts.percentage_label
	);
end

function body_part.init_highlighted_UI(part)
	part.body_part_highlighted_UI = body_part_UI_entity.new(
		config.current_config.large_monster_UI.highlighted.parts.visibility,
		config.current_config.large_monster_UI.highlighted.parts.bar,
		config.current_config.large_monster_UI.highlighted.parts.part_name_label,
		config.current_config.large_monster_UI.highlighted.parts.text_label,
		config.current_config.large_monster_UI.highlighted.parts.value_label,
		config.current_config.large_monster_UI.highlighted.parts.percentage_label
	);
end

function body_part.update(part, new_health, new_max_health)
	if part == nil then
		return;
	end

	if new_health > part.health then
		part.flinch_count = part.flinch_count + 1;
	end

	if part.health ~= new_health then
		part.last_change_time = time.total_elapsed_seconds;
	end
	
	part.health = new_health;
	part.max_health = new_max_health;

	if part.max_health ~= 0 then
		part.health_percentage = part.health / part.max_health;
	end
end

function body_part.draw_dynamic(monster, parts_position_on_screen, opacity_scale)
	--sort parts here
	local displayed_parts = {};
	for REpart, part in pairs(monster.parts) do
		if config.current_config.large_monster_UI.dynamic.parts.settings.hide_undamaged_parts and part.health == part.max_health and part.flinch_count == 0 then
			goto continue;
		end

		if config.current_config.large_monster_UI.dynamic.parts.settings.time_limit ~= 0 and time.total_elapsed_seconds - part.last_change_time > config.current_config.large_monster_UI.dynamic.parts.settings.time_limit then
			goto continue;
		end

		table.insert(displayed_parts, part);
		::continue::
	end

	if config.current_config.large_monster_UI.dynamic.parts.sorting.type == "Normal" then
		if config.current_config.large_monster_UI.dynamic.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif config.current_config.large_monster_UI.dynamic.parts.sorting.type == "Health" then
		if config.current_config.large_monster_UI.dynamic.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health > right.health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health < right.health;
			end);
		end
	elseif config.current_config.large_monster_UI.dynamic.parts.sorting.type == "Health Percentage" then
		if config.current_config.large_monster_UI.dynamic.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage > right.health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage < right.health_percentage;
			end);
		end
	end

	local last_part_position_on_screen;

	for j, part in ipairs(displayed_parts) do
		local part_position_on_screen = {
			x = parts_position_on_screen.x + config.current_config.large_monster_UI.dynamic.parts.spacing.x * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = parts_position_on_screen.y + config.current_config.large_monster_UI.dynamic.parts.spacing.y * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier;
		}

		body_part_UI_entity.draw_dynamic(part, part_position_on_screen, opacity_scale);
		last_part_position_on_screen = part_position_on_screen;
	end

	return last_part_position_on_screen;
end

function body_part.draw_static(monster, parts_position_on_screen, opacity_scale)
	
	--sort parts here
	local displayed_parts = {};
	for REpart, part in pairs(monster.parts) do
		if config.current_config.large_monster_UI.static.parts.settings.hide_undamaged_parts and part.health == part.max_health and part.flinch_count == 0 then
			goto continue;
		end

		if config.current_config.large_monster_UI.static.parts.settings.time_limit ~= 0 and time.total_elapsed_seconds - part.last_change_time > config.current_config.large_monster_UI.static.parts.settings.time_limit then
			goto continue;
		end

		table.insert(displayed_parts, part);
		::continue::
	end

	if config.current_config.large_monster_UI.static.parts.sorting.type == "Normal" then
		if config.current_config.large_monster_UI.static.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif config.current_config.large_monster_UI.static.parts.sorting.type == "Health" then
		if config.current_config.large_monster_UI.static.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health > right.health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health < right.health;
			end);
		end
	elseif config.current_config.large_monster_UI.static.parts.sorting.type == "Health Percentage" then
		if config.current_config.large_monster_UI.static.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage > right.health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage < right.health_percentage;
			end);
		end
	end

	local last_part_position_on_screen;

	for j, part in ipairs(displayed_parts) do
		local part_position_on_screen = {
			x = parts_position_on_screen.x + config.current_config.large_monster_UI.static.parts.spacing.x * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = parts_position_on_screen.y + config.current_config.large_monster_UI.static.parts.spacing.y * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier;
		}

		body_part_UI_entity.draw_static(part, part_position_on_screen, opacity_scale);
		last_part_position_on_screen = part_position_on_screen;
	end

	return last_part_position_on_screen;
end

function body_part.draw_highlighted(monster, parts_position_on_screen, opacity_scale)
	--sort parts here
	local displayed_parts = {};
	for REpart, part in pairs(monster.parts) do
		if config.current_config.large_monster_UI.highlighted.parts.settings.hide_undamaged_parts and part.health == part.max_health and part.flinch_count == 0 then
			goto continue;
		end

		if config.current_config.large_monster_UI.highlighted.parts.settings.time_limit ~= 0 and time.total_elapsed_seconds - part.last_change_time > config.current_config.large_monster_UI.highlighted.parts.settings.time_limit then
			goto continue;
		end

		table.insert(displayed_parts, part);
		::continue::
	end

	if config.current_config.large_monster_UI.highlighted.parts.sorting.type == "Normal" then
		if config.current_config.large_monster_UI.highlighted.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif config.current_config.large_monster_UI.highlighted.parts.sorting.type == "Health" then
		if config.current_config.large_monster_UI.highlighted.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health > right.health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health < right.health;
			end);
		end
	elseif config.current_config.large_monster_UI.highlighted.parts.sorting.type == "Health Percentage" then
		if config.current_config.large_monster_UI.highlighted.parts.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage > right.health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage < right.health_percentage;
			end);
		end
	end

	local last_part_position_on_screen;

	for j, part in ipairs(displayed_parts) do
		local part_position_on_screen = {
			x = parts_position_on_screen.x + config.current_config.large_monster_UI.highlighted.parts.spacing.x * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = parts_position_on_screen.y + config.current_config.large_monster_UI.highlighted.parts.spacing.y * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier;
		};

		body_part_UI_entity.draw_highlighted(part, part_position_on_screen, opacity_scale);
		last_part_position_on_screen = part_position_on_screen;
	end

	return last_part_position_on_screen;
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
	part_names = require("MHR_Overlay.Misc.part_names");
	time = require("MHR_Overlay.Game_Handler.time");
end

return body_part;