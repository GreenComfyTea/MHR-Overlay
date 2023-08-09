local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;
local language;
local error_handler;

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

local ids = {
	self_improvement = 0,
	attack_up = 1,
	defense_up = 2,
	affinity_up = 3,
	elemental_attack_boost = 4,
	attack_and_defense_up = 5,
	attack_and_affinity_up = 6,
	knockbacks_negated = 7,
	earplugs_s = 8,
	earplugs_l = 9,
	tremors_negated = 10,
	wind_pressure_negated = 11,
	stun_negated = 12,
	blight_negated = 13,
	divine_protection = 14,
	health_recovery_s = 15,
	health_recovery_l = 16,
	health_recovery_s_antidote = 17,
	health_regeneration = 18,
	stamina_use_reduced = 19,
	stamina_recovery_up = 20,
	sharpness_loss_reduced = 21,
	environment_damage_negated = 22,
	sonic_wave = 23,
	sonic_barrier = 24,
	infernal_melody = 25,
	sharpness_regeneration = 26,
	sharpness_extension = 27
};

local melody_effect_keys = {
	"self_improvement",
	"attack_up",
	"defense_up",
	"affinity_up",
	"elemental_attack_boost",
	"attack_and_defense_up",
	"attack_and_affinity_up",
	"knockbacks_negated",
	"earplugs_s",
	"earplugs_l",
	"tremors_negated",
	"wind_pressure_negated",
	"stun_negated",
	"blight_negated",
	"divine_protection",
	"health_recovery_s",
	"health_recovery_l",
	"health_recovery_s_antidote",
	"health_regeneration",
	"stamina_use_reduced",
	"stamina_recovery_up",
	"sharpness_loss_reduced",
	"environment_damage_negated",
	"sonic_wave",
	"sonic_barrier",
	"infernal_melody",
	"sharpness_regeneration",
	"sharpness_extension"
};

this.list = {};

local music_data_type_def = sdk.find_type_definition("snow.player.Horn.MusicData");
local time_field = music_data_type_def:get_field("_Time");

function this.update(melody_data_table)
	for lua_index, melody_data in ipairs(melody_data_table) do
		if melody_data ~= "" then
			this.update_melody_effect(lua_index, melody_data);

		end
	end
end

function this.update_melody_effect(lua_index, melody_data)
	local melody_timer = time_field:get_data(melody_data);
		if melody_timer == nil then
			error_handler.report("melody_effects.update", "Failed to access Data: melody_timer No. " .. tostring(lua_index - 1));
			return;
		end

		if melody_timer == 0 then
			this.list[lua_index] = nil;
			return;
		end

		local melody_effect = this.list[lua_index];
		if melody_effect == nil then
			local melody_effect_key = melody_effect_keys[lua_index];
			local name = language.current_language.melody_effects[melody_effect_key];

			melody_effect = buffs.new(buffs.types.melody_effect, melody_effect_key, name, 1, melody_timer / 60);
			this.list[lua_index] = melody_effect;
		else
			buffs.update_timer(melody_effect, melody_timer / 60);
		end
end

function this.init_names()
	for index, buff in pairs(this.list) do
		buff.name = language.current_language.melody_effects[buff.key];
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
end

function this.init_module()
end

return this;