local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;
local language;
local error_handler;
local env_creature;
local player_info;
local time;
local abnormal_statuses;

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

this.list = {
	
};

this.weapon_types = {
	nil, --  0 Great Sword
	nil, --  1 Switch Axe
	nil, --  2 Long Sword
	nil, --  3 Light Bowgun
	nil, --  4 Heavy Bowgun
	nil, --  5 Hammer
	nil, --  6 Gunlance
	nil, --  7 Lance
	nil, --  8 Sword and Shield
	nil, --  9 Dual Blades
	nil, -- 10 Hunting Horn
	nil, -- 11 Charge Blade
	nil, -- 12 Insect Glaive
	nil, -- 13 Bow
};

local weapon_skills_type_name = "weapon_skills";
local previous_weapon_type = -1;

local spirit_gauge_breakpoints = {3, 2};

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_data_method = player_manager_type_def:get_method("get_PlayerData");

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");

-- Great Sword

local great_sword_type_def = sdk.find_type_definition("snow.player.GreatSword");
-- Power Sheathe
local move_wp_off_buff_great_sword_timer_field = great_sword_type_def:get_field("MoveWpOffBuffGreatSwordTimer");
local move_wp_off_buff_set_time_field = great_sword_type_def:get_field("_MoveWpOffBuffSetTime");

-- Switch Axe

local slash_axe_type_def = sdk.find_type_definition("snow.player.SlashAxe");
-- Amped State
local get_bottle_awake_duration_timer_method = slash_axe_type_def:get_method("get_BottleAwakeDurationTimer");
local bottle_awake_duration_time_field = slash_axe_type_def:get_field("_BottleAwakeDurationTime");
-- Switch Charger
local no_use_slash_gauge_timer_field = slash_axe_type_def:get_field("_NoUseSlashGaugeTimer");
-- Axe: Heavy Slam
local bottle_awake_assist_timer_field = slash_axe_type_def:get_field("_BottleAwakeAssistTimer");

-- Long Sword

local long_sword_type_def = sdk.find_type_definition("snow.player.LongSword");
-- Spirit Gauge Autofill (Soaring Kick, Iai Slash)
local get_long_sword_gauge_powerup_time_method = long_sword_type_def:get_method("get_LongSwordGaugePowerUpTime");
-- Spirit Gauge
local get_long_sword_gauge_lv_method = long_sword_type_def:get_method("get_LongSwordGaugeLv");
local long_sword_gauge_lv_time_field = long_sword_type_def:get_field("_LongSwordGaugeLvTime");
local get_long_sword_gauge_lv_timer_method = long_sword_type_def:get_method("get_LongSwordGaugeLvTimer");

-- Harvest Moon
local long_sword_shell_manager_type_def = sdk.find_type_definition("snow.shell.LongSwordShellManager");
local get_master_long_sword_shell_010s_method = long_sword_shell_manager_type_def:get_method("getMaseterLongSwordShell010s");

local system_array_type_def = sdk.find_type_definition("System.Array");
local get_length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

local long_sword_shell_010_list_type_def = sdk.find_type_definition("System.Collections.Generic.List`1<snow.shell.LongSwordShell010>");
local get_count_method = long_sword_shell_010_list_type_def:get_method("get_Count");
local get_item_method = long_sword_shell_010_list_type_def:get_method("get_Item");

local long_sword_shell_010_type_def = sdk.find_type_definition("snow.shell.LongSwordShell010");
local life_timer_field = long_sword_shell_010_type_def:get_field("_lifeTimer");

local single_type_def = sdk.find_type_definition("System.Single");
local mvalue_field = single_type_def:get_field("mValue");

function this.update(player, player_data, weapon_type)
	if weapon_type ~= previous_weapon_type then
		this.list = {};
	end

	previous_weapon_type = weapon_type;

	if weapon_type == 0 then
		this.update_great_sword_skills(player);

	elseif weapon_type == 1 then
		this.update_switch_axe_skills(player);

	elseif weapon_type == 2 then
		this.update_long_sword_skills(player);

	elseif weapon_type == 3 then
		this.update_light_bowgun_skills(player);

	elseif weapon_type == 4 then
		this.update_heavy_bowgun_skills(player);

	elseif weapon_type == 5 then
		this.update_hammer_skills(player);

	elseif weapon_type == 6 then
		this.update_gunlance_skills(player);

	elseif weapon_type == 7 then
		this.update_lance_skills(player);

	elseif weapon_type == 8 then
		this.update_sword_and_shield_skills(player);

	elseif weapon_type == 9 then
		this.update_dual_blades_skills(player);

	elseif weapon_type == 10 then
		this.update_hunting_horn_skills(player);

	elseif weapon_type == 11 then
		this.update_charge_blade_skills(player);

	elseif weapon_type == 12 then
		this.update_insect_glaive_skills(player);

	else
		this.update_bow_skills(player);
	end
end


function this.update_great_sword_skills(player)
	buffs.update_generic_buff(this.list, weapon_skills_type_name, "power_sheathe", nil, nil,
		player, move_wp_off_buff_set_time_field, player, move_wp_off_buff_set_time_field);
end

function this.update_switch_axe_skills(player)
	buffs.update_generic_buff(this.list, weapon_skills_type_name, "amped_state", nil, nil,
		player, get_bottle_awake_duration_timer_method, player, bottle_awake_duration_time_field);

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "switch_charger", nil, nil,
		player, no_use_slash_gauge_timer_field);

	buffs.update_generic_buff(this.list, weapon_skills_type_name, "axe_heavy_slam", nil, nil,
		player, bottle_awake_assist_timer_field);
end

function this.update_long_sword_skills(player)
	buffs.update_generic_buff(this.list, weapon_skills_type_name, "spirit_gauge_autofill", nil, nil,
	player, get_long_sword_gauge_powerup_time_method);

	this.update_spirit_gauge(player);
	this.update_harvest_moon();
end

function this.update_spirit_gauge(player)
	local weapon_skill = buffs.update_generic_buff(this.list, weapon_skills_type_name, "spirit_gauge",
		player, get_long_sword_gauge_lv_method, player, get_long_sword_gauge_lv_timer_method, nil, nil, false, nil, spirit_gauge_breakpoints);

	if weapon_skill == nil then
		return;
	end

	local long_sword_gauge_lv_time_array = long_sword_gauge_lv_time_field:get_data(player);
	if long_sword_gauge_lv_time_array == nil then
		error_handler.report("weapon_skills.update_spirit_gauge", "Failed to access Data: long_sword_gauge_lv_time_array");
		return;
	end

	local long_sword_gauge_lv_time_array_length = get_length_method:call(long_sword_gauge_lv_time_array);
	if long_sword_gauge_lv_time_array_length == nil then
		error_handler.report("weapon_skills.update_spirit_gauge", "Failed to access Data: long_sword_gauge_lv_time_array_length");
		return;
	end

	if weapon_skill.level >= long_sword_gauge_lv_time_array_length then
		return;
	end

	local long_sword_gauge_lv_time_single_valtype = get_value_method:call(long_sword_gauge_lv_time_array, weapon_skill.level);
	if long_sword_gauge_lv_time_single_valtype == nil then
		error_handler.report("weapon_skills.update_spirit_gauge", "Failed to access Data: long_sword_gauge_lv_time_single_valtype");
		return;
	end

	local long_sword_gauge_lv_time = mvalue_field:get_data(long_sword_gauge_lv_time_single_valtype);
	if long_sword_gauge_lv_time == nil then
		error_handler.report("weapon_skills.update_spirit_gauge", "Failed to access Data: long_sword_gauge_lv_time");
		return;
	end

	weapon_skill.duration = long_sword_gauge_lv_time / 60;
end

function this.update_harvest_moon()
	if singletons.long_sword_shell_manager == nil then
		error_handler.report("weapon_skills.update_harvest_moon", "Failed to access Data: long_sword_shell_manager");
		return;
	end

	local master_long_sword_shell_010_list =  get_master_long_sword_shell_010s_method:call(singletons.long_sword_shell_manager, players.myself.id);
	if master_long_sword_shell_010_list == nil then
		error_handler.report("weapon_skills.update_harvest_moon", "Failed to access Data: master_long_sword_shell_010_list");
		return;
	end

	local master_long_sword_shell_010_list_count = get_count_method:call(master_long_sword_shell_010_list);
	if master_long_sword_shell_010_list_count == nil then
		error_handler.report("weapon_skills.update_harvest_moon", "Failed to access Data: master_long_sword_shell_010_list_count");
		return;
	end

	if master_long_sword_shell_010_list_count == 0 then
		return;
	end

	local master_long_sword_shell_010 = get_item_method:call(master_long_sword_shell_010_list, 0);
	if master_long_sword_shell_010 == nil then
		error_handler.report("weapon_skills.update_harvest_moon", "Failed to access Data: master_long_sword_shell_010");
		return;
	end

	local life_timer = life_timer_field:get_data(master_long_sword_shell_010);
	if life_timer == nil then
		error_handler.report("weapon_skills.update_harvest_moon", "Failed to access Data: life_timer");
		return;
	end

	if utils.number.is_equal(life_timer, 0) then
		this.list.harvest_moon = nil;
		return;
	end

	buffs.update_generic(this.list, weapon_skills_type_name, "harvest_moon", 1, life_timer);
end

function this.update_light_bowgun_skills(player)
end

function this.update_heavy_bowgun_skills(player)
end

function this.update_hammer_skills(player)
end

function this.update_gunlance_skills(player)
end

function this.update_lance_skills(player)
end

function this.update_sword_and_shield_skills(player)
end

function this.update_dual_blades_skills(player)
end

function this.update_hunting_horn_skills(player)
end

function this.update_charge_blade_skills(player)
end

function this.update_insect_glaive_skills(player)
end

function this.update_bow_skills(player)
end

function this.init_names()
	for weapon_skill_key, weapon_skill in pairs(this.list) do
		local name = language.current_language.weapon_skills[weapon_skill_key];

		if name == nil then
			name = weapon_skill_key;
		end

		weapon_skill.name = name;
	end
end

function this.init_dependencies()
	buffs = require("MHR_Overlay.Buffs.buffs");
	config = require("MHR_Overlay.Misc.config");
	utils = require("MHR_Overlay.Misc.utils");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	players = require("MHR_Overlay.Damage_Meter.players");
	language = require("MHR_Overlay.Misc.language");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	player_info = require("MHR_Overlay.Misc.player_info");
	time = require("MHR_Overlay.Game_Handler.time");
	abnormal_statuses = require("MHR_Overlay.Buffs.abnormal_statuses");
end

function this.init_module()
end

return this;