local module_visibility_customization = {};

local table_helpers;
local config;
local screen;
local player;
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

function module_visibility_customization.draw(cached_config)
	local changed = false;
	local config_changed = false;

	changed, cached_config.small_monster_UI = imgui.checkbox(
		language.current_language.customization_menu.small_monster_UI,
		cached_config.small_monster_UI);

	config_changed = config_changed or changed;

	changed, cached_config.large_monster_dynamic_UI = imgui.checkbox(
		language.current_language.customization_menu.large_monster_dynamic_UI,
		cached_config.large_monster_dynamic_UI);

	config_changed = config_changed or changed;

	changed, cached_config.large_monster_static_UI = imgui.checkbox(
		language.current_language.customization_menu.large_monster_static_UI,
		cached_config.large_monster_static_UI);

	config_changed = config_changed or changed;

	changed, cached_config.large_monster_highlighted_UI = imgui.checkbox(
		language.current_language.customization_menu.large_monster_highlighted_UI,
		cached_config.large_monster_highlighted_UI);

	config_changed = config_changed or changed;

	changed, cached_config.time_UI = imgui.checkbox(
		language.current_language.customization_menu.time_UI,
		cached_config.time_UI);

	config_changed = config_changed or changed;

	changed, cached_config.damage_meter_UI = imgui.checkbox(
		language.current_language.customization_menu.damage_meter_UI,
		cached_config.damage_meter_UI);

	config_changed = config_changed or changed;

	changed, cached_config.endemic_life_UI = imgui.checkbox(
		language.current_language.customization_menu.endemic_life_UI,
		cached_config.endemic_life_UI);

	config_changed = config_changed or changed;

	return config_changed;
end

function module_visibility_customization.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
	screen = require("MHR_Overlay.Game_Handler.screen");
	player = require("MHR_Overlay.Damage_Meter.player");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	part_names = require("MHR_Overlay.Misc.part_names");
	time_UI = require("MHR_Overlay.UI.Modules.time_UI");
	keyboard = require("MHR_Overlay.Game_Handler.keyboard");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
end

return module_visibility_customization;