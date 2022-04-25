xy = "";

local keyboard = require("MHR_Overlay.Game_Handler.keyboard");
local quest_status = require("MHR_Overlay.Game_Handler.quest_status");
local screen = require("MHR_Overlay.Game_Handler.screen");
local singletons = require("MHR_Overlay.Game_Handler.singletons");
local time = require("MHR_Overlay.Game_Handler.time");

local config = require("MHR_Overlay.Misc.config");
local language = require("MHR_Overlay.Misc.language");
local table_helpers = require("MHR_Overlay.Misc.table_helpers");
local part_names = require("MHR_Overlay.Misc.part_names");


local player = require("MHR_Overlay.Damage_Meter.player");
local damage_hook = require("MHR_Overlay.Damage_Meter.damage_hook");

local env_creature_hook = require("MHR_Overlay.Endemic_Life.env_creature_hook");
local env_creature = require("MHR_Overlay.Endemic_Life.env_creature");

local body_part = require("MHR_Overlay.Monsters.body_part");
local large_monster = require("MHR_Overlay.Monsters.large_monster");
local monster_hook = require("MHR_Overlay.Monsters.monster_hook");
local small_monster = require("MHR_Overlay.Monsters.small_monster");
local ailments = require("MHR_Overlay.Monsters.ailments");
local ailment_hook = require("MHR_Overlay.Monsters.ailment_hook");

local damage_meter_UI = require("MHR_Overlay.UI.Modules.damage_meter_UI");
local large_monster_UI = require("MHR_Overlay.UI.Modules.large_monster_UI");
local small_monster_UI = require("MHR_Overlay.UI.Modules.small_monster_UI");
local time_UI = require("MHR_Overlay.UI.Modules.time_UI");

local body_part_UI_entity = require("MHR_Overlay.UI.UI_Entities.body_part_UI_entity");
local damage_UI_entity = require("MHR_Overlay.UI.UI_Entities.damage_UI_entity");
local health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
local stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
local rage_UI_entity = require("MHR_Overlay.UI.UI_Entities.rage_UI_entity");
local ailment_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_UI_entity");
local env_creature_UI = require("MHR_Overlay.UI.Modules.env_creature_UI");

local customization_menu = require("MHR_Overlay.UI.customization_menu");
local drawing = require("MHR_Overlay.UI.drawing");

------------------------INIT MODULES-------------------------
-- #region
screen.init_module();
singletons.init_module();
table_helpers.init_module();
time.init_module();

language.init_module();
config.init_module();
quest_status.init_module();
part_names.init_module();

damage_UI_entity.init_module();
health_UI_entity.init_module();
stamina_UI_entity.init_module();
rage_UI_entity.init_module();
ailment_UI_entity.init_module();
damage_hook.init_module();
player.init_module();

env_creature_hook.init_module();
env_creature.init_module();

body_part.init_module();
ailments.init_module();
large_monster.init_module();
monster_hook.init_module();
small_monster.init_module();
ailment_hook.init_module();

customization_menu.init_module();
body_part_UI_entity.init_module();
damage_meter_UI.init_module();
drawing.init_module();
large_monster_UI.init_module();
small_monster_UI.init_module();
time_UI.init_module();
env_creature_UI.init_module();

keyboard.init_module();

log.info("[MHR Overlay] loaded");
-- #endregion
------------------------INIT MODULES-------------------------

--------------------------RE_IMGUI---------------------------
-- #region
re.on_draw_ui(function()
	if imgui.button(language.current_language.customization_menu.mod_name .. " " .. config.current_config.version) then
		customization_menu.is_opened = not customization_menu.is_opened;
	end
end);

re.on_frame(function()
	if not reframework:is_drawing_ui() then
		customization_menu.is_opened = false;
	end

	if customization_menu.is_opened then
		pcall(customization_menu.draw);
	end

	keyboard.update();
end);

re.on_frame(function()
	--draw.text("xy: " .. tostring(xy), 551, 11, 0xFF000000);
	--draw.text("xy: " .. tostring(xy), 550, 10, 0xFFFFFFFF);
end);
-- #endregion
--------------------------RE_IMGUI---------------------------

----------------------------D2D------------------------------

-- #region
d2d.register(function()
	drawing.init_font();
end, function()
	customization_menu.status = "OK";
	screen.update_window_size();
	singletons.init();
	player.update_myself_position();
	quest_status.update_is_online();
	quest_status.update_is_result_screen();
	time.tick();

	if quest_status.index < 2 then
		player.update_player_list_in_village();
	else
		player.update_player_list_on_quest();
	end

	if quest_status.index < 2 then
		quest_status.update_is_training_area();

		if quest_status.is_training_area then
			local dynamic_enabled = config.current_config.large_monster_UI.dynamic.enabled and config.current_config.global_settings.module_visibility.training_area.large_monster_dynamic_UI;
			local static_enabled = config.current_config.large_monster_UI.static.enabled and config.current_config.global_settings.module_visibility.training_area.large_monster_static_UI;
			local highlighted_enabled = config.current_config.large_monster_UI.highlighted.enabled and config.current_config.global_settings.module_visibility.training_area.large_monster_highlighted_UI;

			if dynamic_enabled or static_enabled or highlighted_enabled then
				local success = pcall(large_monster_UI.draw, dynamic_enabled, static_enabled, highlighted_enabled);
				if not success then
					customization_menu.status = "Large monster drawing function threw an exception";
				end
			end
	
			if config.current_config.damage_meter_UI.enabled and config.current_config.global_settings.module_visibility.training_area.damage_meter_UI then
				local success = pcall(damage_meter_UI.draw);
				if not success then
					customization_menu.status = "Damage meter drawing function threw an exception";
				end
			end

			if config.current_config.endemic_life_UI.enabled and config.current_config.global_settings.module_visibility.training_area.endemic_life_UI then
				local success = pcall(env_creature_UI.draw);
				if not success then
					customization_menu.status = "Endemic life drawing function threw an exception";
				end
			end
		end
	elseif quest_status.is_result_screen then
		if config.current_config.small_monster_UI.enabled and config.current_config.global_settings.module_visibility.quest_result_screen.small_monster_UI then
			local success = pcall(small_monster_UI.draw);
			if not success then
				customization_menu.status = "Small monster drawing function threw an exception";
			end
		end

		local dynamic_enabled = config.current_config.large_monster_UI.dynamic.enabled and config.current_config.global_settings.module_visibility.quest_result_screen.large_monster_dynamic_UI;
		local static_enabled = config.current_config.large_monster_UI.static.enabled and config.current_config.global_settings.module_visibility.quest_result_screen.large_monster_static_UI;
		local highlighted_enabled = config.current_config.large_monster_UI.highlighted.enabled and config.current_config.global_settings.module_visibility.quest_result_screen.large_monster_highlighted_UI;

		if dynamic_enabled or static_enabled or highlighted_enabled then
			local success = pcall(large_monster_UI.draw, dynamic_enabled, static_enabled, highlighted_enabled);
			if not success then
				customization_menu.status = "Large monster drawing function threw an exception";
			end
		end
		
		if config.current_config.time_UI.enabled and config.current_config.global_settings.module_visibility.quest_result_screen.time_UI then
			local success = pcall(time_UI.draw);
			if not success then
				customization_menu.status = "Time drawing function threw an exception";
			end
		end

		if config.current_config.damage_meter_UI.enabled and config.current_config.global_settings.module_visibility.quest_result_screen.damage_meter_UI then
			local success = pcall(damage_meter_UI.draw);
			if not success then
				customization_menu.status = "Damage meter drawing function threw an exception";
			end
		end

		if config.current_config.endemic_life_UI.enabled and config.current_config.global_settings.module_visibility.quest_result_screen.endemic_life_UI then
			local success = pcall(env_creature_UI.draw);
			if not success then
				customization_menu.status = "Endemic life drawing function threw an exception";
			end
		end
	elseif quest_status.index == 2 then

		if config.current_config.small_monster_UI.enabled and config.current_config.global_settings.module_visibility.during_quest.small_monster_UI then
			local success = pcall(small_monster_UI.draw);
			if not success then
				customization_menu.status = "Small monster drawing function threw an exception";
			end
		end

		local dynamic_enabled = config.current_config.large_monster_UI.dynamic.enabled and config.current_config.global_settings.module_visibility.during_quest.large_monster_dynamic_UI;
		local static_enabled = config.current_config.large_monster_UI.static.enabled and config.current_config.global_settings.module_visibility.during_quest.large_monster_static_UI;
		local highlighted_enabled = config.current_config.large_monster_UI.highlighted.enabled and config.current_config.global_settings.module_visibility.during_quest.large_monster_highlighted_UI;



		if dynamic_enabled or static_enabled or highlighted_enabled then
			local success = pcall(large_monster_UI.draw, dynamic_enabled, static_enabled, highlighted_enabled);
			if not success then
				customization_menu.status = "Large monster drawing function threw an exception";
			end
		end

		if config.current_config.time_UI.enabled and config.current_config.global_settings.module_visibility.during_quest.time_UI then
			local success = pcall(time_UI.draw);
			if not success then
				customization_menu.status = "Time drawing function threw an exception";
			end
		end

		if config.current_config.damage_meter_UI.enabled and config.current_config.global_settings.module_visibility.during_quest.damage_meter_UI then
			local success = pcall(damage_meter_UI.draw);
			if not success then
				customization_menu.status = "Damage meter drawing function threw an exception";
			end
		end

		if config.current_config.endemic_life_UI.enabled and config.current_config.global_settings.module_visibility.during_quest.endemic_life_UI then
			local success = pcall(env_creature_UI.draw);
			if not success then
				customization_menu.status = "Endemic life drawing function threw an exception";
			end
		end
	end

	--snow.player.PlayerManager ->
	-- <PlayerData>k_BackingField -> [0]

	--Demondrug				_AtkUpAlive = 5									1
	--Mega Demondrug		_AtkUpAlive = 7									1
	--Armorskin				_DefUpAlive = 15								1
	--Mega Armorskin		_DefUpAlive = 25								1
	--Might Seed			_AtkUpBuffSecond and _AtkUpBuffSecondTimer		1
	--Demon Powder			_AtkUpItemSecond and _AtkUpItemSecondTimer		1
	--Adamant Seed			_DefUpBuffSecond and _DefUpBuffSecondTimer		1
	--Hardshell Powder		_DefUpItemSecond and _DefUpItemSecondTimer		1
	--Dash Juice			_StaminaUpBuffSecondTimer						1
	--Immunizer				_VitalizerTimer									1

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

	--[[
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
	--]]
end);
