local this = {};

local buff_UI_entity;
local config;
local singletons;

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

function this.new(name, value, duration)
	local is_infinite = false;

	value = value or 0;

	if duration == nil then
		duration = 0;
		is_infinite = true;
	end

	local buff = {};

	buff.name = name;
	buff.value = value;

	buff.timer = duration;
	buff.duration = duration;

	buff.is_active = true;

	buff.timer_percentage = 0;

	buff.minutes_left = 0;
	buff.seconds_left = 0;

	buff.is_infinite = is_infinite;

	this.update_timer(buff, buff.timer);

	this.init_UI(buff);

	return buff;
end

function this.init_buffs()
	this.list = {};
end

function this.init_UI(buff)
	local cached_config = config.current_config.buff_UI;
	buff.buff_UI = buff_UI_entity.new(cached_config.bar, cached_config.name_label, cached_config.timer_label);
end

function this.draw(buff, buff_UI, position_on_screen, opacity_scale)
	buff_UI_entity.draw(buff, buff_UI, position_on_screen, opacity_scale);
end

function this.update_timer(buff, timer)
	if timer < 0 then
		timer = 0;
	end

	local minutes_left = math.floor(timer / 60);

	buff.timer = timer;
	buff.minutes_left = minutes_left;
	buff.seconds_left = math.floor(timer - 60 * minutes_left);

	if buff.duration ~= 0 then
		buff.timer_percentage = timer / buff.duration;
	end
end

function this.init_module()
	config = require("MHR_Overlay.Misc.config");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	singletons = require("MHR_Overlay.Game_Handler.singletons");

	--[[local buff = this.new("Enviroment Damage Negated");
	buff.duration = 90;
	buff.timer = 65;
	buff.timer_percentage = 0.66;
	buff.minutes_left = 1;
	buff.seconds_left = 5

	this.list["Enviroment Damage Negated"] = buff;

	local buff = this.new("Sharpness Loss Reduced");
	buff.duration = 120;
	buff.timer = 70;
	buff.timer_percentage = 0.583;
	buff.minutes_left = 1;
	buff.seconds_left = 10

	this.list["Sharpness Loss Reduced"] = buff;

	local buff = this.new("Sharpness Loss Reduced 2");
	buff.duration = 120;
	buff.timer = 70;
	buff.timer_percentage = 0.583;
	buff.minutes_left = 1;
	buff.seconds_left = 10
	buff.is_infinite = true;

	this.list["Sharpness Loss Reduced 2"] = buff;]]
end

function this.debug()
	--Buffs location:
	--snow.player.PlayerManager -> <PlayerData> k_BackingField -> [0]

	-- snow.player.PlayerManager ->
	-- <PlayerData>k_BackingField -> [0]

	-- Attack Up
	-- Defense Up
	-- Affinity Up					_AtkUpEcSecond and _AtkUpEcSecondTimer
	-- Sharpness Loss Reduced
	-- Elemental Attack Boost
	-- Divine Protection
	-- Health Regeneration
	-- Natural Healing Up
	-- Blight Negated
	-- Immunity
	-- Stamina Recovery Up
	-- Stamina Use Reduced
	-- Knockbacks Negated			_DefUpEcSecond and _DefUpEcSecondTimer
	-- Sonic Barrier
	-- Earplugs (S)
	-- Earplugs (L)
	-- Tremor Negated
	-- Enviroment Damage Negated
	-- Stun Negated
	-- Wind Pressure Negated
	-- Gourmet Fish Effect
	-- Self Improvement
	-- Infernal Melody

	local player_data_array = singletons.player_manager:get_field("<PlayerData>k__BackingField");
	local player_data = player_data_array:get_element(0);

	local _AtkUpAlive = player_data:get_field("_AtkUpAlive");
	local _DefUpAlive = player_data:get_field("_DefUpAlive");

	xy = "AtkUpAlive: " .. tostring(_AtkUpAlive);
	xy = xy .. "\n_DefUpAlive: " .. tostring(_DefUpAlive);

	local _AtkUpBuffSecond = player_data:get_field("_AtkUpBuffSecond");
	local _DefUpBuffSecond = player_data:get_field("_DefUpBuffSecond");
	local _DefUpBuffSecondRate = player_data:get_field("_DefUpBuffSecondRate");

	xy = xy .. "\n_AtkUpBuffSecond: " .. tostring(_AtkUpBuffSecond);
	xy = xy .. "\n_DefUpBuffSecond: " .. tostring(_DefUpBuffSecond);
	xy = xy .. "\n_DefUpBuffSecondRate: " .. tostring(_DefUpBuffSecondRate);

	local _AtkUpBuffSecondTimer = player_data:get_field("_AtkUpBuffSecondTimer");
	local _DefUpBuffSecondTimer = player_data:get_field("_DefUpBuffSecondTimer");
	local _DefUpBuffSecondRateTimer = player_data:get_field("_DefUpBuffSecondRateTimer");

	xy = xy .. "\n_AtkUpBuffSecondTimer: " .. tostring(_AtkUpBuffSecondTimer);
	xy = xy .. "\n_DefUpBuffSecondTimer: " .. tostring(_DefUpBuffSecondTimer);
	xy = xy .. "\n_DefUpBuffSecondRateTimer: " .. tostring(_DefUpBuffSecondRateTimer);

	local _StaminaUpBuffSecondTimer = player_data:get_field("_StaminaUpBuffSecondTimer");

	xy = xy .. "\n_StaminaUpBuffSecondTimer: " .. tostring(_StaminaUpBuffSecondTimer);
	
	local _AtkUpItemSecond = player_data:get_field("_AtkUpItemSecond");
	local _DefUpItemSecond = player_data:get_field("_DefUpItemSecond");

	xy = xy .. "\n_AtkUpItemSecond: " .. tostring(_AtkUpItemSecond);
	xy = xy .. "\n_DefUpItemSecond: " .. tostring(_DefUpItemSecond);

	local _AtkUpItemSecondTimer = player_data:get_field("_AtkUpItemSecondTimer");
	local _DefUpItemSecondTimer = player_data:get_field("_DefUpItemSecondTimer");

	xy = xy .. "\n_AtkUpItemSecondTimer: " .. tostring(_AtkUpItemSecondTimer);
	xy = xy .. "\n_DefUpItemSecondTimer: " .. tostring(_DefUpItemSecondTimer);

	local _SuperArmorItemTimer = player_data:get_field("_SuperArmorItemTimer");

	xy = xy .. "\n_SuperArmorItemTimer: " .. tostring(_SuperArmorItemTimer);

	local _AtkUpEcSecondTimer = player_data:get_field("_AtkUpEcSecondTimer");
	local _AtkUpEcSecond = player_data:get_field("_AtkUpEcSecond");

	xy = xy .. "\n_AtkUpEcSecondTimer: " .. tostring(_AtkUpEcSecondTimer);
	xy = xy .. "\n_AtkUpEcSecond: " .. tostring(_AtkUpEcSecond);

	local _DefUpEcSecondTimer = player_data:get_field("_DefUpEcSecondTimer");
	local _DefUpEcSecond = player_data:get_field("_DefUpEcSecond");

	xy = xy .. "\n_DefUpEcSecondTimer: " .. tostring(_DefUpEcSecondTimer);
	xy = xy .. "\n_DefUpEcSecond: " .. tostring(_DefUpEcSecond);

	local _CritUpEcSecondTimer = player_data:get_field("_CritUpEcSecondTimer");
	local _CritChanceUpBowTimer = player_data:get_field("_CritChanceUpBowTimer");
	local _CritChanceUpBow = player_data:get_field("_CritChanceUpBow");

	xy = xy .. "\n_CritUpEcSecondTimer: " .. tostring(_CritUpEcSecondTimer);
	xy = xy .. "\n_CritChanceUpBowTimer: " .. tostring(_CritChanceUpBowTimer);
	xy = xy .. "\n_CritChanceUpBow: " .. tostring(_CritChanceUpBow);

	local _MusicRegeneTimer = player_data:get_field("_MusicRegeneTimer");

	xy = xy .. "\n_MusicRegeneTimer: " .. tostring(_MusicRegeneTimer);
	
	local _LeadEnemyTimer = player_data:get_field("_LeadEnemyTimer");
	local _IsLeadEnemy = player_data:get_field("_IsLeadEnemy");

	xy = xy .. "\n_LeadEnemyTimer: " .. tostring(_LeadEnemyTimer);
	xy = xy .. "\n_IsLeadEnemy: " .. tostring(_IsLeadEnemy);

	local _DebuffPreventionTimer = player_data:get_field("_DebuffPreventionTimer");

	xy = xy .. "\n_DebuffPreventionTimer: " .. tostring(_DebuffPreventionTimer);

	local _FishRegeneTimer = player_data:get_field("_FishRegeneTimer");
	local _FishRegeneEnableTimer = player_data:get_field("_FishRegeneEnableTimer");

	xy = xy .. "\n_FishRegeneTimer: " .. tostring(_FishRegeneTimer);
	xy = xy .. "\n_FishRegeneEnableTimer: " .. tostring(_FishRegeneEnableTimer);

	local _VitalizerTimer = player_data:get_field("_VitalizerTimer");

	xy = xy .. "\n_VitalizerTimer: " .. tostring(_VitalizerTimer);

	local _RunhighOtomoTimer = player_data:get_field("_RunhighOtomoTimer");
	local _KijinBulletTimer = player_data:get_field("_KijinBulletTimer");
	local _KoukaBulletTimer = player_data:get_field("_KoukaBulletTimer");
	local _EquipSkill_036_Timer = player_data:get_field("_EquipSkill_036_Timer");

	xy = xy .. "\n_RunhighOtomoTimer: " .. tostring(_RunhighOtomoTimer);
	xy = xy .. "\n_KijinBulletTimer: " .. tostring(_KijinBulletTimer);
	xy = xy .. "\n_KoukaBulletTimer: " .. tostring(_KoukaBulletTimer);
	xy = xy .. "\n_EquipSkill_036_Timer: " .. tostring(_EquipSkill_036_Timer);

	local _HyperArmorItemTimer = player_data:get_field("_HyperArmorItemTimer");

	xy = xy .. "\n_HyperArmorItemTimer: " .. tostring(_HyperArmorItemTimer);

	local _KijinOtomoTimer = player_data:get_field("_KijinOtomoTimer");
	local _BeastRoarOtomoTimer = player_data:get_field("_BeastRoarOtomoTimer");
	local _ChallengeTimer = player_data:get_field("_ChallengeTimer");
	local _WholeBodyTimer = player_data:get_field("_WholeBodyTimer");

	xy = xy .. "\n_KijinOtomoTimer: " .. tostring(_KijinOtomoTimer);
	xy = xy .. "\n_BeastRoarOtomoTimer: " .. tostring(_BeastRoarOtomoTimer);
	xy = xy .. "\n_ChallengeTimer: " .. tostring(_ChallengeTimer);
	xy = xy .. "\n_WholeBodyTimer: " .. tostring(_WholeBodyTimer);

	local _SlidingTimer = player_data:get_field("_SlidingTimer");
	local _SlidingPowerupTimer = player_data:get_field("_SlidingPowerupTimer");

	xy = xy .. "\n_SlidingTimer: " .. tostring(_SlidingTimer);
	xy = xy .. "\n_SlidingPowerupTimer: " .. tostring(_SlidingPowerupTimer);

	local _WallRunTimer = player_data:get_field("_WallRunTimer");
	local _WallRunPowerupTimer = player_data:get_field("_WallRunPowerupTimer");

	xy = xy .. "\n_WallRunTimer: " .. tostring(_WallRunTimer);
	xy = xy .. "\n_WallRunPowerupTimer: " .. tostring(_WallRunPowerupTimer);

	local _CounterattackPowerupTimer = player_data:get_field("_CounterattackPowerupTimer");

	xy = xy .. "\n_CounterattackPowerupTimer: " .. tostring(_CounterattackPowerupTimer);

	-- sic!
	local _OnibiPowerUpTiemr  = player_data:get_field("_OnibiPowerUpTiemr");
	local _OnibiPowerUpInterval = player_data:get_field("_OnibiPowerUpInterval");

	xy = xy .. "\n_OnibiPowerUpTiemr: " .. tostring(_OnibiPowerUpTiemr);
	xy = xy .. "\n_OnibiPowerUpInterval: " .. tostring(_OnibiPowerUpInterval);

	local _HyakuryuDragonPowerUpTimer = player_data:get_field("_HyakuryuDragonPowerUpTimer");
	local _HyakuryuDragonPowerUpCnt = player_data:get_field("_HyakuryuDragonPowerUpCnt");
	local _HyakuryuHyakuryuOnazutiPowerUpInterval = player_data:get_field("_HyakuryuHyakuryuOnazutiPowerUpInterval");

	xy = xy .. "\n_HyakuryuDragonPowerUpTimer: " .. tostring(_HyakuryuDragonPowerUpTimer);
	xy = xy .. "\n_HyakuryuDragonPowerUpCnt: " .. tostring(_HyakuryuDragonPowerUpCnt);
	xy = xy .. "\n_HyakuryuHyakuryuOnazutiPowerUpInterval: " .. tostring(_HyakuryuHyakuryuOnazutiPowerUpInterval);

	local _KitchenSkill027Timer = player_data:get_field("_KitchenSkill027Timer");
	local _KitchenSkill045Timer = player_data:get_field("_KitchenSkill045Timer");

	xy = xy .. "\n_KitchenSkill027Timer: " .. tostring(_KitchenSkill027Timer);
	xy = xy .. "\n_KitchenSkill045Timer: " .. tostring(_KitchenSkill045Timer);

	-- sic!
	local _ReduseUseStaminaKichenSkillActive = player_data:get_field("_ReduseUseStaminaKichenSkillActive");

	xy = xy .. "\n_ReduseUseStaminaKichenSkillActive: " .. tostring(_ReduseUseStaminaKichenSkillActive);

	local _HeavyBowgunWyvernSnipeTimer = player_data:get_field("_HeavyBowgunWyvernSnipeTimer");
	local _HeavyBowgunWyvernMachineGunTimer = player_data:get_field("_HeavyBowgunWyvernMachineGunTimer");
	local _HeavyBowgunWyvernSnipeBullet = player_data:get_field("_HeavyBowgunWyvernSnipeBullet");
	local _HeavyBowgunWyvernMachineGunBullet = player_data:get_field("_HeavyBowgunWyvernMachineGunBullet");

	xy = xy .. "\n_HeavyBowgunWyvernSnipeTimer: " .. tostring(_HeavyBowgunWyvernSnipeTimer);
	xy = xy .. "\n_HeavyBowgunWyvernMachineGunTimer: " .. tostring(_HeavyBowgunWyvernMachineGunTimer);
	xy = xy .. "\n_HeavyBowgunWyvernSnipeBullet: " .. tostring(_HeavyBowgunWyvernSnipeBullet);
	xy = xy .. "\n_HeavyBowgunWyvernMachineGunBullet: " .. tostring(_HeavyBowgunWyvernMachineGunBullet);

	local _ChargeDragonSlayCannonTime = player_data:get_field("_ChargeDragonSlayCannonTime");

	xy = xy .. "\n_ChargeDragonSlayCannonTime: " .. tostring(_ChargeDragonSlayCannonTime);

	local _WyvernBlastGauge = player_data:get_field("_WyvernBlastGauge");
	local _WyvernBlastReloadTimer = player_data:get_field("_WyvernBlastReloadTimer");

	xy = xy .. "\n_WyvernBlastGauge: " .. tostring(_WyvernBlastGauge);
	xy = xy .. "\n_WyvernBlastReloadTimer: " .. tostring(_WyvernBlastReloadTimer);
end

return this;