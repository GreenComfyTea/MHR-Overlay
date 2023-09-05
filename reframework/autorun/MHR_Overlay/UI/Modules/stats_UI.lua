local this = {};

local buff_UI_entity;
local config;
local buffs;
local consumables;
local melody_effects;
local endemic_life_buff;
local screen;
local utils;
local error_handler;
local skills;
local dango_skills;
local abnormal_statuses;
local drawing;
local player_info;
local language;

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

this.label_list = {
	attack = nil,

	defense = nil,
	fire_resistance = nil,
	water_resistance = nil,
	thunder_resistance = nil,
	ice_resistance = nil,
	dragon_resistance = nil
};

this.affinity_label = nil;
this.health_label = nil;
this.stamina_label = nil;
this.element_label = nil;
this.element_2_label = nil;

function this.draw()
	local cached_config = config.current_config.stats_UI;

	if not cached_config.enabled then
		return;
	end

	local cached_names = language.current_language.stats;

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local position_on_screen = screen.calculate_absolute_coordinates(cached_config.position);

	-- draw
	for label_key, label in pairs(this.label_list) do
		local name_text = "";
		if label.include.name then
			if label.include.value then
				name_text = string.format("%s: ", cached_names[label_key]);
			else
				name_text = string.format("%s", cached_names[label_key]);
			end
		end

		if label.include.value then
			name_text = string.format("%s%s", name_text, tostring(player_info.list[label_key]));
		end

		drawing.draw_label(label, position_on_screen, 1, name_text);

		::continue::
	end

	-- Health Label
	local health_name_text = "";
	if this.health_label.include.name then
		health_name_text = string.format("%s: ", language.current_language.customization_menu.health);

		if this.health_label.include.value or this.health_label.include.max_value then
			health_name_text = string.format("%s: ", language.current_language.customization_menu.health);
		else
			health_name_text = string.format("%s", language.current_language.customization_menu.health);
		end
	end

	if this.health_label.include.value and not this.health_label.include.max_value then
		health_name_text = string.format("%s%s", health_name_text, tostring(player_info.list.health));

	elseif not this.health_label.include.value and this.health_label.include.max_value then
		health_name_text = string.format("%s%s", health_name_text, tostring(player_info.list.max_health));

	elseif this.health_label.include.value and this.health_label.include.max_value then
		health_name_text = string.format("%s%s/%s", health_name_text, tostring(player_info.list.health), tostring(player_info.list.max_health));
	end

	drawing.draw_label(this.health_label, position_on_screen, 1, health_name_text);

	-- Stamina Label
	local stamina_name_text = "";
	if this.stamina_label.include.name then
		if this.stamina_label.include.value or this.stamina_label.include.max_value then
			stamina_name_text = string.format("%s: ", cached_names.stamina);
		else
			stamina_name_text = string.format("%s", cached_names.stamina);
		end
	end

	if this.stamina_label.include.value and not this.stamina_label.include.max_value then
		stamina_name_text = string.format("%s%s", stamina_name_text, tostring(player_info.list.stamina));

	elseif not this.stamina_label.include.value and this.stamina_label.include.max_value then
		stamina_name_text = string.format("%s%s", stamina_name_text, tostring(player_info.list.max_stamina));

	elseif this.stamina_label.include.value and this.stamina_label.include.max_value then
		stamina_name_text = string.format("%s%s/%s", stamina_name_text, tostring(player_info.list.stamina), tostring(player_info.list.max_stamina));
	end

	drawing.draw_label(this.stamina_label, position_on_screen, 1, stamina_name_text);

	-- Affinity Label
	local affinity_name_text = "";
	if this.affinity_label.include.name then
		if this.affinity_label.include.value then
			affinity_name_text = string.format("%s: ", cached_names.affinity);
		else
			affinity_name_text = string.format("%s", cached_names.affinity);
		end
	end

	if this.affinity_label.include.value then
		affinity_name_text = string.format("%s%s%%", affinity_name_text, tostring(player_info.list.affinity));
	end

	drawing.draw_label(this.affinity_label, position_on_screen, 1, affinity_name_text);

	-- Element Label
	if player_info.list.element_type ~= 0 then

		local element_name_text = "";
		if this.element_label.include.name then

			local ailment_names = language.current_language.ailments;

			local ailment_name = "";

			if player_info.list.element_type == 1 then
				ailment_name = cached_names.fire;
			elseif player_info.list.element_type == 2 then
				ailment_name = cached_names.water;
			elseif player_info.list.element_type == 3 then
				ailment_name = cached_names.thunder;
			elseif player_info.list.element_type == 4 then
				ailment_name = cached_names.ice;
			elseif player_info.list.element_type == 5 then
				ailment_name = cached_names.dragon;
			elseif player_info.list.element_type == 6 then
				ailment_name = ailment_names.poison;
			elseif player_info.list.element_type == 7 then
				ailment_name = ailment_names.sleep;
			elseif player_info.list.element_type == 8 then
				ailment_name = ailment_names.paralysis;
			elseif player_info.list.element_type == 9 then
				ailment_name = ailment_names.blast;
			end

			if this.element_label.include.value then
				element_name_text = string.format("%s: ", ailment_name);
			else
				element_name_text = string.format("%s", ailment_name);
			end
		end

		if this.element_label.include.value then
			element_name_text = string.format("%s%s", element_name_text, tostring(player_info.list.element_attack));
		end

		drawing.draw_label(this.element_label, position_on_screen, 1, element_name_text);
	end
	

	-- Element 2 Label
	if player_info.list.element_type_2 ~= 0 then

		local element_2_name_text = "";
		if this.element_2_label.include.name then

			local ailment_names = language.current_language.ailments;

			local ailment_name = "";

			if player_info.list.element_type_2 == 1 then
				ailment_name = cached_names.fire;
			elseif player_info.list.element_type_2 == 2 then
				ailment_name = cached_names.water;
			elseif player_info.list.element_type_2 == 3 then
				ailment_name = cached_names.thunder;
			elseif player_info.list.element_type_2 == 4 then
				ailment_name = cached_names.ice;
			elseif player_info.list.element_type_2 == 5 then
				ailment_name = cached_names.dragon;
			elseif player_info.list.element_type_2 == 6 then
				ailment_name = ailment_names.poison;
			elseif player_info.list.element_type_2 == 7 then
				ailment_name = ailment_names.sleep;
			elseif player_info.list.element_type_2 == 8 then
				ailment_name = ailment_names.paralysis;
			elseif player_info.list.element_type_2 == 9 then
				ailment_name = ailment_names.blast;
			end

			if this.element_2_label.include.value then
				element_2_name_text = string.format("%s: ", ailment_name);
			else
				element_2_name_text = string.format("%s", ailment_name);
			end

		end

		if this.element_2_label.include.value then
			element_2_name_text = string.format("%s%s", element_2_name_text, tostring(player_info.list.element_attack_2));
		end

		drawing.draw_label(this.element_2_label, position_on_screen, 1, element_2_name_text);
	end
end

function this.init_UI()
	this.label_list.attack = utils.table.deep_copy(config.current_config.stats_UI.attack_label);
	this.label_list.defense = utils.table.deep_copy(config.current_config.stats_UI.defense_label);

	this.label_list.fire_resistance = utils.table.deep_copy(config.current_config.stats_UI.fire_resistance_label);
	this.label_list.water_resistance = utils.table.deep_copy(config.current_config.stats_UI.water_resistance_label);
	this.label_list.thunder_resistance = utils.table.deep_copy(config.current_config.stats_UI.thunder_resistance_label);
	this.label_list.ice_resistance = utils.table.deep_copy(config.current_config.stats_UI.ice_resistance_label);
	this.label_list.dragon_resistance = utils.table.deep_copy(config.current_config.stats_UI.dragon_resistance_label);

	this.affinity_label = utils.table.deep_copy(config.current_config.stats_UI.affinity_label);
	this.health_label = utils.table.deep_copy(config.current_config.stats_UI.health_label);
	this.stamina_label = utils.table.deep_copy(config.current_config.stats_UI.stamina_label);
	this.element_label = utils.table.deep_copy(config.current_config.stats_UI.element_label);
	this.element_2_label = utils.table.deep_copy(config.current_config.stats_UI.element_2_label);

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	for label_key, label in pairs(this.label_list) do
		label.offset.x = label.offset.x * global_scale_modifier;
		label.offset.y = label.offset.y * global_scale_modifier;
	end

	this.affinity_label.offset.x = this.affinity_label.offset.x * global_scale_modifier;
	this.affinity_label.offset.y = this.affinity_label.offset.y * global_scale_modifier;

	this.health_label.offset.x = this.health_label.offset.x * global_scale_modifier;
	this.health_label.offset.y = this.health_label.offset.y * global_scale_modifier;

	this.stamina_label.offset.x = this.stamina_label.offset.x * global_scale_modifier;
	this.stamina_label.offset.y = this.stamina_label.offset.y * global_scale_modifier;

	this.element_label.offset.x = this.element_label.offset.x * global_scale_modifier;
	this.element_label.offset.y = this.element_label.offset.y * global_scale_modifier;

	this.element_2_label.offset.x = this.element_2_label.offset.x * global_scale_modifier;
	this.element_2_label.offset.y = this.element_2_label.offset.y * global_scale_modifier;
end

function this.init_dependencies()
	config = require("MHR_Overlay.Misc.config");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	consumables = require("MHR_Overlay.Buffs.consumables");
	melody_effects = require("MHR_Overlay.Buffs.melody_effects");
	buffs = require("MHR_Overlay.Buffs.buffs");
	--singletons = require("MHR_Overlay.Game_Handler.singletons");
	config = require("MHR_Overlay.Misc.config");
	--customization_menu = require("MHR_Overlay.UI.customization_menu");
	--players = require("MHR_Overlay.Damage_Meter.players");
	--non_players = require("MHR_Overlay.Damage_Meter.non_players");
	--quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	screen = require("MHR_Overlay.Game_Handler.screen");
	--drawing = require("MHR_Overlay.UI.drawing");
	utils = require("MHR_Overlay.Misc.utils");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	endemic_life_buff = require("MHR_Overlay.Buffs.endemic_life_buffs");
	skills = require("MHR_Overlay.Buffs.skills");
	dango_skills = require("MHR_Overlay.Buffs.dango_skills");
	abnormal_statuses = require("MHR_Overlay.Buffs.abnormal_statuses");
	drawing = require("MHR_Overlay.UI.drawing");
	player_info = require("MHR_Overlay.Misc.player_info");
	language = require("MHR_Overlay.Misc.language");
end

function this.init_module()
	this.init_UI();
end

return this;