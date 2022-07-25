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

function body_part.new(id, name)
	local part = {};

	part.id = id;

	part.health = 9999;
	part.max_health = 99999;
	part.health_percentage = 0;

	part.break_health = 9999;
	part.break_max_health = 99999;
	part.break_health_percentage = 0;

	part.lost_health = 9999;
	part.loss_max_health = 99999;
	part.loss_health_percentage = 0;

	part.name = name;
	part.flinch_count = 0;
	part.break_count = 0;
	part.break_max_count = 0;

	part.last_change_time = time.total_elapsed_script_seconds;

	body_part.init_dynamic_UI(part);
	body_part.init_static_UI(part);
	body_part.init_highlighted_UI(part);
	return part;
end


function body_part.init_dynamic_UI(part)
	local cached_config = config.current_config.large_monster_UI.dynamic.body_parts;

	part.body_part_dynamic_UI = body_part_UI_entity.new(
		cached_config.visibility,
		cached_config.part_name_label,
		cached_config.part_health.visibility,
		cached_config.part_health.bar,
		cached_config.part_health.text_label,
		cached_config.part_health.value_label,
		cached_config.part_health.percentage_label,
		cached_config.part_break.visibility,
		cached_config.part_break.bar,
		cached_config.part_break.text_label,
		cached_config.part_break.value_label,
		cached_config.part_break.percentage_label,
		cached_config.part_loss.visibility,
		cached_config.part_loss.bar,
		cached_config.part_loss.text_label,
		cached_config.part_loss.value_label,
		cached_config.part_loss.percentage_label
	);
end

function body_part.init_static_UI(part)
	local cached_config = config.current_config.large_monster_UI.static.body_parts;

	part.body_part_static_UI = body_part_UI_entity.new(
		cached_config.visibility,
		cached_config.part_name_label,
		cached_config.part_health.visibility,
		cached_config.part_health.bar,
		cached_config.part_health.text_label,
		cached_config.part_health.value_label,
		cached_config.part_health.percentage_label,
		cached_config.part_break.visibility,
		cached_config.part_break.bar,
		cached_config.part_break.text_label,
		cached_config.part_break.value_label,
		cached_config.part_break.percentage_label,
		cached_config.part_loss.visibility,
		cached_config.part_loss.bar,
		cached_config.part_loss.text_label,
		cached_config.part_loss.value_label,
		cached_config.part_loss.percentage_label
	);
end

function body_part.init_highlighted_UI(part)
	local cached_config = config.current_config.large_monster_UI.highlighted.body_parts;

	part.body_part_highlighted_UI = body_part_UI_entity.new(
		cached_config.visibility,
		cached_config.part_name_label,
		cached_config.part_health.visibility,
		cached_config.part_health.bar,
		cached_config.part_health.text_label,
		cached_config.part_health.value_label,
		cached_config.part_health.percentage_label,
		cached_config.part_break.visibility,
		cached_config.part_break.bar,
		cached_config.part_break.text_label,
		cached_config.part_break.value_label,
		cached_config.part_break.percentage_label,
		cached_config.part_loss.visibility,
		cached_config.part_loss.bar,
		cached_config.part_loss.text_label,
		cached_config.part_loss.value_label,
		cached_config.part_loss.percentage_label
	);
end

function body_part.update_flinch(part, part_current, part_max)
	if part_current > part.health then
		part.flinch_count = part.flinch_count + 1;
	end

	if part.health ~= part_current then
		part.last_change_time = time.total_elapsed_script_seconds;
	end

	if part.max_health ~= part_max then
		part.last_change_time = time.total_elapsed_script_seconds;
	end

	part.health = part_current;
	part.max_health = part_max;

	if part.max_health ~= 0 then
		part.health_percentage = part.health / part.max_health;
	end
end

function body_part.update_break(part, part_break_current, part_break_max, part_break_count, part_break_max_count)

	if part.break_health ~= part_break_current then
		part.last_change_time = time.total_elapsed_script_seconds;
	end

	if part.break_max_health ~= part_break_max then
		part.last_change_time = time.total_elapsed_script_seconds;
	end

	if part.break_count ~= part_break_count then
		part.last_change_time = time.total_elapsed_script_seconds;
	end

	if part.break_max_count ~= part_break_max_count then
		part.last_change_time = time.total_elapsed_script_seconds;
	end
	
	part.break_health = part_break_current;
	part.break_max_health = part_break_max;

	part.break_count = part_break_count;
	part.break_max_count = part_break_max_count;

	if part.break_max_health ~= 0 then
		part.break_health_percentage = part.break_health / part.break_max_health;
	end
end

function body_part.update_loss(part, part_loss_current, part_loss_max, is_severed)
	if part.loss_health ~= part_loss_current then
		part.last_change_time = time.total_elapsed_script_seconds;
	end

	if part.loss_max_health ~= part_loss_max then
		part.last_change_time = time.total_elapsed_script_seconds;
	end

	if part.is_severed ~= is_severed then
		part.last_change_time = time.total_elapsed_script_seconds;
	end

	part.loss_health = part_loss_current;
	part.loss_max_health = part_loss_max;

	part.is_severed = is_severed;

	if part.loss_max_health ~= 0 then
		part.loss_health_percentage = part.loss_health / part.loss_max_health;
	end

end

function body_part.draw_dynamic(monster, parts_position_on_screen, opacity_scale)
	local cached_config = config.current_config.large_monster_UI.dynamic.body_parts;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local displayed_parts = {};
	for REpart, part in pairs(monster.parts) do
		local health_supported = part.max_health >= 0;
		local break_supported = part.break_max_health >= 0;
		local severe_supported = part.loss_max_health >= 0;

		if health_supported then
			if break_supported then
				if severe_supported then
					if not cached_config.filter.health_break_severe then
						goto continue;
					end
				else
					if not cached_config.filter.health_break then
						goto continue;
					end
				end
			else
				if severe_supported then
					if not cached_config.filter.health_severe then
						goto continue;
					end
				else
					if not cached_config.filter.health then
						goto continue;
					end
				end
			end
		else
			if break_supported then
				if severe_supported then
					if not cached_config.filter.break_severe then
						goto continue;
					end
				else
					if not cached_config.filter.break_ then
						goto continue;
					end
				end
			else
				if severe_supported then
					if not cached_config.filter.severe then
						goto continue;
					end
				else
					goto continue;
				end
			end
		end

		if cached_config.settings.hide_undamaged_parts
		and ((part.health == part.max_health and part.flinch_count == 0) or not health_supported)
		and ((part.break_health == part.break_max_health and part.break_count == 0) or not break_supported)
		and ((part.loss_health == part.loss_max_health and not part.is_severed) or not severe_supported) then
			goto continue;
		end

		if (not part.body_part_dynamic_UI.flinch_visibility or not health_supported)
		and (not part.body_part_dynamic_UI.break_visibility or not break_supported or part.break_count >= part.break_max_count)
		and (not part.body_part_dynamic_UI.loss_visibility or not severe_supported or part.is_severed) then
			goto continue;
		end

		if cached_config.settings.time_limit ~= 0 and time.total_elapsed_script_seconds - part.last_change_time > cached_config.settings.time_limit then
			goto continue;
		end

		table.insert(displayed_parts, part);
		::continue::
	end

	if cached_config.sorting.type == "Normal" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif cached_config.sorting.type == "Health" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health > right.health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health < right.health;
			end);
		end
	elseif cached_config.sorting.type == "Health Percentage" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage > right.health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage < right.health_percentage;
			end);
		end
	elseif cached_config.sorting.type == "Flinch Count" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.flinch_count > right.flinch_count;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.flinch_count < right.flinch_count;
			end);
		end
	elseif cached_config.sorting.type == "Break Health" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.break_health > right.break_health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.break_health < right.break_health;
			end);
		end
	elseif cached_config.sorting.type == "Break Health Percentage" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.break_health_percentage > right.break_health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.break_health_percentage < right.break_health_percentage;
			end);
		end
	elseif cached_config.sorting.type == "Break Count" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.break_count > right.break_count;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.break_count < right.break_count;
			end);
		end
	elseif cached_config.sorting.type == "Sever Health" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.loss_health > right.loss_health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.loss_health < right.loss_health;
			end);
		end
	elseif cached_config.sorting.type == "Sever Health Percentage" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.loss_health_percentage > right.loss_health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.loss_health_percentage < right.loss_health_percentage;
			end);
		end
	end

	local last_part_position_on_screen;

	for j, part in ipairs(displayed_parts) do
		local part_position_on_screen = {
			x = parts_position_on_screen.x + cached_config.spacing.x * (j - 1) * global_scale_modifier,
			y = parts_position_on_screen.y + cached_config.spacing.y * (j - 1) * global_scale_modifier;
		}

		body_part_UI_entity.draw_dynamic(part, part_position_on_screen, opacity_scale);
		last_part_position_on_screen = part_position_on_screen;
	end

	return last_part_position_on_screen;
end

function body_part.draw_static(monster, parts_position_on_screen, opacity_scale)
	local cached_config = config.current_config.large_monster_UI.static.body_parts;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local displayed_parts = {};
	for REpart, part in pairs(monster.parts) do
		local health_supported = part.max_health >= 0;
		local break_supported = part.break_max_health >= 0;
		local severe_supported = part.loss_max_health >= 0;

		if health_supported then
			if break_supported then
				if severe_supported then
					if not cached_config.filter.health_break_severe then
						goto continue;
					end
				else
					if not cached_config.filter.health_break then
						goto continue;
					end
				end
			else
				if severe_supported then
					if not cached_config.filter.health_severe then
						goto continue;
					end
				else
					if not cached_config.filter.health then
						goto continue;
					end
				end
			end
		else
			if break_supported then
				if severe_supported then
					if not cached_config.filter.break_severe then
						goto continue;
					end
				else
					if not cached_config.filter.break_ then
						goto continue;
					end
				end
			else
				if severe_supported then
					if not cached_config.filter.severe then
						goto continue;
					end
				else
					goto continue;
				end
			end
		end

		if cached_config.settings.hide_undamaged_parts
		and ((part.health == part.max_health and part.flinch_count == 0) or not health_supported)
		and ((part.break_health == part.break_max_health and part.break_count == 0) or not break_supported)
		and ((part.loss_health == part.loss_max_health and not part.is_severed) or not severe_supported) then
			goto continue;
		end

		if (not part.body_part_static_UI.flinch_visibility or not health_supported)
		and (not part.body_part_static_UI.break_visibility or not break_supported or part.break_count >= part.break_max_count)
		and (not part.body_part_static_UI.loss_visibility or not severe_supported or part.is_severed) then
			goto continue;
		end

		if cached_config.settings.time_limit ~= 0 and time.total_elapsed_script_seconds - part.last_change_time > cached_config.settings.time_limit then
			goto continue;
		end


		table.insert(displayed_parts, part);
		::continue::
	end

	if cached_config.sorting.type == "Normal" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif cached_config.sorting.type == "Health" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health > right.health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health < right.health;
			end);
		end
	elseif cached_config.sorting.type == "Health Percentage" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage > right.health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage < right.health_percentage;
			end);
		end
	elseif cached_config.sorting.type == "Flinch Count" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.flinch_count > right.flinch_count;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.flinch_count < right.flinch_count;
			end);
		end
	elseif cached_config.sorting.type == "Break Health" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.break_health > right.break_health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.break_health < right.break_health;
			end);
		end
	elseif cached_config.sorting.type == "Break Health Percentage" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.break_health_percentage > right.break_health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.break_health_percentage < right.break_health_percentage;
			end);
		end
	elseif cached_config.sorting.type == "Break Count" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.break_count > right.break_count;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.break_count < right.break_count;
			end);
		end
	elseif cached_config.sorting.type == "Sever Health" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.loss_health > right.loss_health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.loss_health < right.loss_health;
			end);
		end
	elseif cached_config.sorting.type == "Sever Health Percentage" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.loss_health_percentage > right.loss_health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.loss_health_percentage < right.loss_health_percentage;
			end);
		end
	end

	local last_part_position_on_screen;

	for j, part in ipairs(displayed_parts) do
		local part_position_on_screen = {
			x = parts_position_on_screen.x + cached_config.spacing.x * (j - 1) * global_scale_modifier,
			y = parts_position_on_screen.y + cached_config.spacing.y * (j - 1) * global_scale_modifier;
		}

		body_part_UI_entity.draw_static(part, part_position_on_screen, opacity_scale);
		last_part_position_on_screen = part_position_on_screen;
	end

	return last_part_position_on_screen;
end

function body_part.draw_highlighted(monster, parts_position_on_screen, opacity_scale)
	local cached_config = config.current_config.large_monster_UI.highlighted.body_parts;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local displayed_parts = {};
	for REpart, part in pairs(monster.parts) do
		local health_supported = part.max_health >= 0;
		local break_supported = part.break_max_health >= 0;
		local severe_supported = part.loss_max_health >= 0;

		if health_supported then
			if break_supported then
				if severe_supported then
					if not cached_config.filter.health_break_severe then
						goto continue;
					end
				else
					if not cached_config.filter.health_break then
						goto continue;
					end
				end
			else
				if severe_supported then
					if not cached_config.filter.health_severe then
						goto continue;
					end
				else
					if not cached_config.filter.health then
						goto continue;
					end
				end
			end
		else
			if break_supported then
				if severe_supported then
					if not cached_config.filter.break_severe then
						goto continue;
					end
				else
					if not cached_config.filter.break_ then
						goto continue;
					end
				end
			else
				if severe_supported then
					if not cached_config.filter.severe then
						goto continue;
					end
				else
					goto continue;
				end
			end
		end

		if cached_config.settings.hide_undamaged_parts
		and ((part.health == part.max_health and part.flinch_count == 0) or not health_supported)
		and ((part.break_health == part.break_max_health and part.break_count == 0) or not break_supported)
		and ((part.loss_health == part.loss_max_health and not part.is_severed) or not severe_supported) then
			goto continue;
		end

		if (not part.body_part_highlighted_UI.flinch_visibility or not health_supported)
		and (not part.body_part_highlighted_UI.break_visibility or not break_supported or part.break_count >= part.break_max_count)
		and (not part.body_part_highlighted_UI.loss_visibility or not severe_supported or part.is_severed) then
			goto continue;
		end

		if cached_config.settings.time_limit ~= 0 and time.total_elapsed_script_seconds - part.last_change_time > cached_config.settings.time_limit then
			goto continue;
		end

		table.insert(displayed_parts, part);
		::continue::
	end

	if cached_config.sorting.type == "Normal" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.id > right.id;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.id < right.id;
			end);
		end
	elseif cached_config.sorting.type == "Health" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health > right.health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health < right.health;
			end);
		end
	elseif cached_config.sorting.type == "Health Percentage" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage > right.health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.health_percentage < right.health_percentage;
			end);
		end
	elseif cached_config.sorting.type == "Flinch Count" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.flinch_count > right.flinch_count;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.flinch_count < right.flinch_count;
			end);
		end
	elseif cached_config.sorting.type == "Break Health" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.break_health > right.break_health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.break_health < right.break_health;
			end);
		end
	elseif cached_config.sorting.type == "Break Health Percentage" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.break_health_percentage > right.break_health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.break_health_percentage < right.break_health_percentage;
			end);
		end
	elseif cached_config.sorting.type == "Break Count" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.break_count > right.break_count;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.break_count < right.break_count;
			end);
		end
	elseif cached_config.sorting.type == "Sever Health" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.loss_health > right.loss_health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.loss_health < right.loss_health;
			end);
		end
	elseif cached_config.sorting.type == "Sever Health Percentage" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.loss_health_percentage > right.loss_health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.loss_health_percentage < right.loss_health_percentage;
			end);
		end
	end

	local last_part_position_on_screen;

	for j, part in ipairs(displayed_parts) do
		local part_position_on_screen = {
			x = parts_position_on_screen.x + cached_config.spacing.x * (j - 1) * global_scale_modifier,
			y = parts_position_on_screen.y + cached_config.spacing.y * (j - 1) * global_scale_modifier;
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