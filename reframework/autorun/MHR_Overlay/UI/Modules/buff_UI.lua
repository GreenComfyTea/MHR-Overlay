local this = {};

local buff_UI_entity;
local config;
local buffs;
local item_buffs;
local melody_effects;
local endemic_life_buff;
local screen;
local utils;
local error_handler;
local skills;
local dango_skills;
local abnormal_statuses;
local otomo_moves;
local weapon_skills;
local misc_buffs;
local rampage_skills;

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

local displayed_buffs = {};

function this.update()
	local cached_config = config.current_config.buff_UI;

	local _displayed_buffs = {};

	for key, item_buff in pairs(item_buffs.list) do
		
		if not item_buff.is_active then
			goto continue;
		end

		table.insert(_displayed_buffs, item_buff);

		::continue::
	end

	for _, melody_effect in pairs(melody_effects.list) do
		
		if not melody_effect.is_active then
			goto continue2;
		end

		table.insert(_displayed_buffs, melody_effect);

		::continue2::
	end

	for key, endemic_life_buff in pairs(endemic_life_buff.list) do
		if not endemic_life_buff.is_active then
			goto continue3;
		end

		table.insert(_displayed_buffs, endemic_life_buff);

		::continue3::
	end

	for key, skill in pairs(skills.list) do
		if not skill.is_active then
			goto continue4;
		end

		table.insert(_displayed_buffs, skill);

		::continue4::
	end

	for key, dango_skill in pairs(dango_skills.list) do
		if not dango_skill.is_active then
			goto continue5;
		end

		table.insert(_displayed_buffs, dango_skill);

		::continue5::
	end

	for key, abnormal_status in pairs(abnormal_statuses.list) do
		if not abnormal_status.is_active then
			goto continue6;
		end

		table.insert(_displayed_buffs, abnormal_status);

		::continue6::
	end

	for key, otomo_move in pairs(otomo_moves.list) do
		if not otomo_move.is_active then
			goto continue7;
		end

		table.insert(_displayed_buffs, otomo_move);

		::continue7::
	end

	for key, weapon_skill in pairs(weapon_skills.list) do
		if not weapon_skill.is_active then
			goto continue8;
		end

		table.insert(_displayed_buffs, weapon_skill);

		::continue8::
	end

	for key, rampage_skill in pairs(rampage_skills.list) do
		if not rampage_skill.is_active then
			goto continue9;
		end

		table.insert(_displayed_buffs, rampage_skill);

		::continue9::
	end

	for key, misc_buffs in pairs(misc_buffs.list) do
		if not misc_buffs.is_active then
			goto continue10;
		end

		table.insert(_displayed_buffs, misc_buffs);

		::continue10::
	end
	

	displayed_buffs = this.sort_buffs(_displayed_buffs, cached_config);
end

function this.sort_buffs(_displayed_buffs, cached_config)
	cached_config = cached_config.sorting;

	if cached_config.type == "Name" then
		if cached_config.reversed_order then
			table.sort(_displayed_buffs, function(left, right)
				return left.name > right.name;
			end);
		else
			table.sort(_displayed_buffs, function(left, right)
				return left.name < right.name;
			end);
		end
	elseif cached_config.type == "Timer" then
		if cached_config.reversed_order then
			table.sort(_displayed_buffs, function(left, right)
				return left.timer > right.timer;
			end);
		else
			table.sort(_displayed_buffs, function(left, right)
				return left.timer < right.timer;
			end);
		end
	else
		if cached_config.reversed_order then
			table.sort(_displayed_buffs, function(left, right)
				return left.duration > right.duration;
			end);
		else
			table.sort(_displayed_buffs, function(left, right)
				return left.duration < right.duration;
			end);
		end
	end

	return _displayed_buffs;
end

function this.draw()
	local cached_config = config.current_config.buff_UI;

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	local position_on_screen = screen.calculate_absolute_coordinates(cached_config.position);

	-- draw
	for _, buff in ipairs(displayed_buffs) do
		buffs.draw(buff, buff.buff_UI, position_on_screen, 1);

		if cached_config.settings.orientation == "Horizontal" then
			position_on_screen.x = position_on_screen.x + cached_config.spacing.x * global_scale_modifier;
		else
			position_on_screen.y = position_on_screen.y + cached_config.spacing.y * global_scale_modifier;
		end

		::continue::
	end
end

function this.init_dependencies()
	config = require("MHR_Overlay.Misc.config");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	item_buffs = require("MHR_Overlay.Buffs.item_buffs");
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
	otomo_moves = require("MHR_Overlay.Buffs.otomo_moves");
	weapon_skills = require("MHR_Overlay.Buffs.weapon_skills");
	misc_buffs = require("MHR_Overlay.Buffs.misc_buffs");
	rampage_skills = require("MHR_Overlay.Buffs.rampage_skills");
end

function this.init_module()
end

return this;