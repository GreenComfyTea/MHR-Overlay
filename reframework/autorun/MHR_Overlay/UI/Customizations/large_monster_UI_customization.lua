local this = {};

local config;
local screen;
local players;
local large_monster;
local small_monster;
local env_creature;
local language;
local part_names;
local time_UI;
local keyboard;
local customization_menu;

local label_customization;
local bar_customization;
local health_customization;
local stamina_customization;
local rage_customization;
local body_parts_customization;
local ailments_customization;
local ailment_buildups_customization;

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

function this.draw(cached_config)
	local changed = false;
	local config_changed = false;

	changed = label_customization.draw(language.current_language.customization_menu.monster_name_label, cached_config.monster_name_label);
	config_changed = config_changed or changed;

	changed = health_customization.draw(cached_config.health);
	config_changed = config_changed or changed;

	changed = stamina_customization.draw(cached_config.stamina);
	config_changed = config_changed or changed;

	changed = rage_customization.draw(cached_config.rage);
	config_changed = config_changed or changed;	

	changed = body_parts_customization.draw(cached_config.body_parts);
	config_changed = config_changed or changed;

	changed = ailments_customization.draw(cached_config.ailments);
	config_changed = config_changed or changed;

	changed = ailment_buildups_customization.draw(cached_config.ailment_buildups);
	config_changed = config_changed or changed;

	return config_changed;
end

function this.init_module()
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
	screen = require("MHR_Overlay.Game_Handler.screen");
	players = require("MHR_Overlay.Damage_Meter.players");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	part_names = require("MHR_Overlay.Misc.part_names");
	time_UI = require("MHR_Overlay.UI.Modules.time_UI");
	keyboard = require("MHR_Overlay.Game_Handler.keyboard");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	label_customization = require("MHR_Overlay.UI.Customizations.label_customization");
	bar_customization = require("MHR_Overlay.UI.Customizations.bar_customization");

	health_customization = require("MHR_Overlay.UI.Customizations.health_customization");
	stamina_customization = require("MHR_Overlay.UI.Customizations.stamina_customization");
	rage_customization = require("MHR_Overlay.UI.Customizations.rage_customization");
	body_parts_customization = require("MHR_Overlay.UI.Customizations.body_parts_customization");
	ailments_customization = require("MHR_Overlay.UI.Customizations.ailments_customization");
	ailment_buildups_customization = require("MHR_Overlay.UI.Customizations.ailment_buildups_customization");
end

return this;