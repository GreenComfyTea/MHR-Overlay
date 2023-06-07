local this = {};

local singletons;
local customization_menu;
local config;
local health_UI_entity;
local stamina_UI_entity;
local rage_UI_entity;
local body_part_UI_entity;
local screen;
local drawing;
local part_names;
local time;
local utils;

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

this.list = {};

function this.new(id, name)
	local part = {};


	part.id = id;
	part.name = name;

	part.health = -9;
	part.max_health = -10;
	part.health_percentage = 0;

	part.break_health = -9;
	part.break_max_health = -10;
	part.break_health_percentage = 0;

	part.lost_health = -9;
	part.loss_max_health = -10;
	part.loss_health_percentage = 0;

	part.flinch_count = 0;
	part.break_count = 0;
	part.break_max_count = 0;

	part.anomaly_ref = nil;
	part.anomaly_health = -9;
	part.anomaly_max_health = -10;
	part.anomaly_health_percentage = 0;
	part.anomaly_is_active = false;

	part.last_change_time = time.total_elapsed_script_seconds;

	return part;
end

function this.init_part_names(monster_id, parts)
	for part_id, part in pairs(parts) do
		part.name = part_names.get_part_name(monster_id, part_id);
	end
end

function this.update_flinch(part, part_current, part_max)
	if part_current > part.health and part.max_health > 0 then
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

function this.update_break(part, part_break_current, part_break_max, part_break_count, part_break_max_count)

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

function this.update_loss(part, part_loss_current, part_loss_max, is_severed)
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

function this.update_anomaly(part, part_anomaly_ref, part_anomaly_current, part_anomaly_max, part_is_active)
	if part.anomaly_health ~= part_anomaly_current then
		part.last_change_time = time.total_elapsed_script_seconds;
	end

	if part.anomaly_max_health ~= part_anomaly_max then
		part.last_change_time = time.total_elapsed_script_seconds;
	end

	if part.anomaly_is_active ~= part_is_active then
		part.last_change_time = time.total_elapsed_script_seconds;
	end

	part.anomaly_core_ref = part_anomaly_ref;
	part.anomaly_health = part_anomaly_current;
	part.anomaly_max_health = part_anomaly_max;
	part.anomaly_is_active = part_is_active;
	
	if part.anomaly_max_health ~= 0 then
		part.anomaly_health_percentage = part.anomaly_health / part.anomaly_max_health;
	end
end

function this.is_filtered_out(cached_config, health_supported, break_supported, sever_supported, anomaly_supported)
	if health_supported then
		if break_supported then
			if sever_supported then
				if anomaly_supported then
					if not cached_config.filter.health_break_sever_anomaly then
						return true;
					end
				else
					if not cached_config.filter.health_break_sever then
						return true;
					end
				end
			else
				if anomaly_supported then
					if not cached_config.filter.health_break_anomaly then
						return true;
					end
				else
					if not cached_config.filter.health_break then
						return true;
					end
				end
			end
		else
			if sever_supported then
				if anomaly_supported then
					if not cached_config.filter.health_sever_anomaly then
						return true;
					end
				else
					if not cached_config.filter.health_sever then
						return true;
					end
				end
			else
				if anomaly_supported then
					if not cached_config.filter.health_anomaly then
						return true;
					end
				else
					if not cached_config.filter.health then
						return true;
					end
				end
			end
		end
	else
		if break_supported then
			if sever_supported then
				if anomaly_supported then
					if not cached_config.filter.break_sever_anomaly then
						return true;
					end
				else
					if not cached_config.filter.break_sever then
						return true;
					end
				end
			else
				if anomaly_supported then
					if not cached_config.filter.break_anomaly then
						return true;
					end
				else
					if not cached_config.filter.break_ then
						return true;
					end
				end
			end
		else
			if sever_supported then
				if anomaly_supported then
					if not cached_config.filter.sever_anomaly then
						return true;
					end
				else
					if not cached_config.filter.sever then
						return true;
					end
				end
			else
				if anomaly_supported then
					if not cached_config.filter.anomaly then
						return true;
					end
				else
					return true;
				end
			end
		end
	end

	return false;
end

function this.draw(monster, part_UI, cached_config, parts_position_on_screen, opacity_scale)
	local cached_config = cached_config.body_parts;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local displayed_parts = {};
	for REpart, part in pairs(monster.parts) do
		local health_supported = part.max_health > 0;
		local break_supported = part.break_max_health > 0;
		local sever_supported = part.loss_max_health > 0;
		local anomaly_supported = part.anomaly_max_health > 0;


		if cached_config.settings.filter_mode == "Current State" then
			if break_supported and part.break_count >= part.break_max_count then
				break_supported = false;
			end

			if sever_supported and part.is_severed then
				sever_supported = false;
			end

			if anomaly_supported and not part.anomaly_is_active then
				anomaly_supported = false;
			end
		end

		local is_filtered_out = this.is_filtered_out(cached_config, health_supported, break_supported, sever_supported, anomaly_supported);
		if is_filtered_out then
			goto continue;
		end

		if cached_config.settings.hide_undamaged_parts
		and ((part.health == part.max_health and part.flinch_count == 0) or not health_supported)
		and ((part.break_health == part.break_max_health and part.break_count == 0) or not break_supported)
		and ((part.loss_health == part.loss_max_health and not part.is_severed) or not sever_supported)
		and ((part.anomaly_health == part.anomaly_max_health) or not anomaly_supported) then
			goto continue
		end

		if (not part_UI.flinch_visibility or not health_supported)
		and (not part_UI.break_visibility or not break_supported or part.break_count >= part.break_max_count)
		and (not part_UI.loss_visibility or not sever_supported or part.is_severed)
		and (not part_UI.anomaly_visibility or not anomaly_supported) then
			goto continue
		end

		if cached_config.settings.time_limit ~= 0 and
			time.total_elapsed_script_seconds - part.last_change_time > cached_config.settings.time_limit then
			goto continue
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
	elseif cached_config.sorting.type == "Anomaly Core Health" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.anomaly_health > right.anomaly_health;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.anomaly_health < right.anomaly_health;
			end);
		end
	elseif cached_config.sorting.type == "Anomaly Core Health Percentage" then
		if cached_config.sorting.reversed_order then
			table.sort(displayed_parts, function(left, right)
				return left.anomaly_health_percentage > right.anomaly_health_percentage;
			end);
		else
			table.sort(displayed_parts, function(left, right)
				return left.anomaly_health_percentage < right.anomaly_health_percentage;
			end);
		end
	end

	local last_part_position_on_screen;

	for j, part in ipairs(displayed_parts) do
		local part_position_on_screen = {
			x = parts_position_on_screen.x + cached_config.spacing.x * (j - 1) * global_scale_modifier,
			y = parts_position_on_screen.y + cached_config.spacing.y * (j - 1) * global_scale_modifier;
		};

		body_part_UI_entity.draw(part, part_UI, cached_config, part_position_on_screen, opacity_scale);
		last_part_position_on_screen = part_position_on_screen;
	end

	return last_part_position_on_screen;
end

function this.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	config = require("MHR_Overlay.Misc.config");
	health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
	rage_UI_entity = require("MHR_Overlay.UI.UI_Entities.rage_UI_entity");
	body_part_UI_entity = require("MHR_Overlay.UI.UI_Entities.body_part_UI_entity");
	screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
	part_names = require("MHR_Overlay.Misc.part_names");
	time = require("MHR_Overlay.Game_Handler.time");
	utils = require("MHR_Overlay.Misc.utils");
end

return this;
