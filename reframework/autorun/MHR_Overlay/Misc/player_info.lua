local this = {};

local drawing;
local customization_menu;
local singletons;
local config;
local utils;
local error_handler;
local quest_status;
local time;
local dangos;

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
	health = 0;
	max_health = 0;

	attack = 0;
	defense = 0;
	affinity = 0;
	
	stamina = 0;
	max_stamina = -1;
	
	element_type = 0;
	element_attack = 0;
	
	element_type_2 = 0;
	element_attack_2 = 0;
	
	fire_resistance = 0;
	water_resistance = 0;
	thunder_resistance = 0;
	ice_resistance = 0;
	dragon_resistance = 0;
};

local should_health_update = true;

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_method = player_manager_type_def:get_method("getPlayer");
local find_master_player_method = player_manager_type_def:get_method("findMasterPlayer");

local player_base_type_def = find_master_player_method:get_return_type();
local get_player_data_method = player_base_type_def:get_method("get_PlayerData");

local player_data_type_def = get_player_data_method:get_return_type();

local get_vital_method = player_data_type_def:get_method("get_vital");
local attack_field = player_data_type_def:get_field("_Attack");
local defence_field = player_data_type_def:get_field("_Defence");
local critical_rate_field = player_data_type_def:get_field("_CriticalRate");

local vital_max_field = player_data_type_def:get_field("_vitalMax");

local stamina_field = player_data_type_def:get_field("_stamina");
local stamina_max_field = player_data_type_def:get_field("_staminaMax");

local element_type_field = player_data_type_def:get_field("_ElementType");
local element_attack_field = player_data_type_def:get_field("_ElementAttack");

local element_type_2nd_field = player_data_type_def:get_field("_ElementType2nd");
local element_attack_2nd_field = player_data_type_def:get_field("_ElementAttack2nd");

local resistance_element_field = player_data_type_def:get_field("_ResistanceElement");

local system_array_type_def = sdk.find_type_definition("System.Array");
local get_length_method = system_array_type_def:get_method("get_Length");
local get_value_method = system_array_type_def:get_method("GetValue(System.Int32)");

local player_quest_base_type_def = sdk.find_type_definition("snow.player.PlayerQuestBase");
local player_quest_base_update_method = player_quest_base_type_def:get_method("update");
local is_master_player_method = player_quest_base_type_def:get_method("isMasterPlayer");

local player_base_type_def = sdk.find_type_definition("snow.player.PlayerBase");
-- Dango Adrenaline
local is_kitchen_skill_predicament_powerup_method = player_base_type_def:get_method("isKitchenSkillPredicamentPowerUp");

local single_type_def = sdk.find_type_definition("System.Single");
local mvalue_field = single_type_def:get_field("mValue");

local master_player_ref = nil;
local master_player_data_ref = nil;

function this.update()
	if quest_status.flow_state == quest_status.flow_states.NONE then
		return;
	end

	local cached_config = config.current_config;

	if not cached_config.buff_UI.enabled
	and not cached_config.stats_UI.enabled then
		return;
	end

	if singletons.player_manager == nil then
		error_handler.report("player_info.update", "Failed to access Data: player_manager");
		return;
	end

	local master_player = find_master_player_method:call(singletons.player_manager); 
	if master_player == nil then
		error_handler.report("player_info.update", "Failed to access Data: master_player");
		return;
	end

	local master_player_data = get_player_data_method:call(master_player);
	if master_player_data == nil then
		error_handler.report("player_info.update", "Failed to access Data: master_player_data");
	end
	
	master_player_ref = master_player;
	master_player_data_ref = master_player_data;
	should_health_update = true;

	this.update_generic("max_health", master_player_data, vital_max_field);

	this.update_generic("stamina", master_player_data, stamina_field);
	this.list.stamina = math.floor(this.list.stamina / 30);

	this.update_generic("max_stamina", master_player_data, stamina_max_field);
	this.list.max_stamina = math.floor(this.list.max_stamina / 30);

	if not cached_config.stats_UI.enabled then
		return;
	end

	this.update_generic("attack", master_player_data, attack_field);
	this.update_generic("affinity", master_player_data, critical_rate_field);
	this.update_generic("defense", master_player_data, defence_field);

	this.update_generic("element_type", master_player_data, element_type_field);
	this.update_generic("element_attack", master_player_data, element_attack_field);

	this.update_generic("element_type_2", master_player_data, element_type_2nd_field);
	this.update_generic("element_attack_2", master_player_data, element_attack_2nd_field);

	this.update_resistances(master_player_data);
end

function this.update_generic(key, player_data, field)
	local value = field:get_data(player_data);
	if value == nil then
		error_handler.report("player_info.update_generic", string.format("Failed to access Data: %s_value", key));
		return;
	end

	this.list[key] = math.floor(value);
end

function this.update_resistances(player_data)
	local resistance_element_array = resistance_element_field:get_data(player_data);
	if resistance_element_array == nil then
		error_handler.report("player_info.update_resistances", "Failed to access Data: resistance_element_array");
		return;
	end

	-- Fire Resistance
	local fire_resistance_single_valtype = get_value_method:call(resistance_element_array, 0);
	if fire_resistance_single_valtype == nil then
		error_handler.report("player_info.update_resistances", "Failed to access Data: fire_resistance_single_valtype");
		return;
	end

	local fire_resistance = mvalue_field:get_data(fire_resistance_single_valtype);
	if fire_resistance ~= nil then
		this.list.fire_resistance = math.floor(fire_resistance);
	else
		error_handler.report("player_info.update_resistances", "Failed to access Data: fire_resistance");
		return;
	end

	-- Water Resistance
	local water_resistance_single_valtype = get_value_method:call(resistance_element_array, 1);
	if water_resistance_single_valtype == nil then
		error_handler.report("player_info.update_resistances", "Failed to access Data: water_resistance_single_valtype");
		return;
	end

	local water_resistance = mvalue_field:get_data(water_resistance_single_valtype);
	if water_resistance ~= nil then
		this.list.water_resistance = math.floor(water_resistance);
	else
		error_handler.report("player_info.update_resistances", "Failed to access Data: water_resistance");
		return;
	end

	-- Thunder Resistance
	local thunder_resistance_single_valtype = get_value_method:call(resistance_element_array, 2);
	if thunder_resistance_single_valtype == nil then
		error_handler.report("player_info.update_resistances", "Failed to access Data: thunder_resistance_single_valtype");
		return;
	end

	local thunder_resistance = mvalue_field:get_data(thunder_resistance_single_valtype);
	if thunder_resistance ~= nil then
		this.list.thunder_resistance = math.floor(thunder_resistance);
	else
		error_handler.report("player_info.update_resistances", "Failed to access Data: thunder_resistance");
		return;
	end

	-- Ice Resistance
	local ice_resistance_single_valtype = get_value_method:call(resistance_element_array, 3);
	if ice_resistance_single_valtype == nil then
		error_handler.report("player_info.update_resistances", "Failed to access Data: ice_resistance_single_valtype");
		return;
	end

	local ice_resistance = mvalue_field:get_data(ice_resistance_single_valtype);
	if ice_resistance ~= nil then
		this.list.ice_resistance = math.floor(ice_resistance);
	else
		error_handler.report("player_info.update_resistances", "Failed to access Data: ice_resistance");
		return;
	end

	-- Dragon Resistance
	local dragon_resistance_single_valtype = get_value_method:call(resistance_element_array, 4);
	if dragon_resistance_single_valtype == nil then
		error_handler.report("player_info.update_resistances", "Failed to access Data: dragon_resistance_single_valtype");
		return;
	end

	local dragon_resistance = mvalue_field:get_data(dragon_resistance_single_valtype);
	if dragon_resistance ~= nil then
		this.list.dragon_resistance = math.floor(dragon_resistance);
	else
		error_handler.report("player_info.update_resistances", "Failed to access Data: dragon_resistance");
		return;
	end
end

function this.on_pre_player_update(quest_player_base)
	if not should_health_update then
		return;
	end
	
	if quest_player_base ~= master_player_ref then
		return;
	end

	this.update_health(quest_player_base);
	this.update_dango_adrenaline(quest_player_base);

	should_health_update = false;
end

function this.update_health(quest_player_base)
	local vital = get_vital_method:call(master_player_data_ref);
	if vital == nil then
		error_handler.report("player_info.update_health", "Failed to access Data: vital");
		return;
	end

	this.list.health = vital;
end

function this.update_dango_adrenaline(quest_player_base)
	local is_kitchen_skill_predicament_powerup = is_kitchen_skill_predicament_powerup_method:call(master_player_ref);
	if is_kitchen_skill_predicament_powerup == nil then
		error_handler.report("player_info.update_dango_adrenaline", "Failed to access Data: is_kitchen_skill_predicament_powerup");
		return;
	end

	dangos.is_dango_adrenaline_active = is_kitchen_skill_predicament_powerup;
end

function this.init_dependencies()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	config = require("MHR_Overlay.Misc.config");
	utils = require("MHR_Overlay.Misc.utils");
	--health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
	--stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
	--screen = require("MHR_Overlay.Game_Handler.screen");
	drawing = require("MHR_Overlay.UI.drawing");
	--ailments = require("MHR_Overlay.Monsters.ailments");
	--ailment_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_UI_entity");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	time = require("MHR_Overlay.Game_Handler.time");
	dangos = require("MHR_Overlay.Buffs.dangos");
end

function this.init_module()
	sdk.hook(player_quest_base_update_method, function(args)
		local quest_player_base = sdk.to_managed_object(args[2]);
		this.on_pre_player_update(quest_player_base);
	end, function(retval)
		return retval;
	end);
end

return this;
