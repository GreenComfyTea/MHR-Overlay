xy = "";

local debug = require("MHR_Overlay.Misc.debug");

local keyboard = require("MHR_Overlay.Game_Handler.keyboard");
local quest_status = require("MHR_Overlay.Game_Handler.quest_status");
local screen = require("MHR_Overlay.Game_Handler.screen");
local singletons = require("MHR_Overlay.Game_Handler.singletons");
local time = require("MHR_Overlay.Game_Handler.time");

local config = require("MHR_Overlay.Misc.config");
local language = require("MHR_Overlay.Misc.language");
local table_helpers = require("MHR_Overlay.Misc.table_helpers");
local unicode_helpers = require("MHR_Overlay.Misc.unicode_helpers");
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
local ailment_buildup = require("MHR_Overlay.Monsters.ailment_buildup");

local damage_meter_UI = require("MHR_Overlay.UI.Modules.damage_meter_UI");
local large_monster_UI = require("MHR_Overlay.UI.Modules.large_monster_UI");
local small_monster_UI = require("MHR_Overlay.UI.Modules.small_monster_UI");
local time_UI = require("MHR_Overlay.UI.Modules.time_UI");
local env_creature_UI = require("MHR_Overlay.UI.Modules.env_creature_UI");

local body_part_UI_entity = require("MHR_Overlay.UI.UI_Entities.body_part_UI_entity");
local damage_UI_entity = require("MHR_Overlay.UI.UI_Entities.damage_UI_entity");
local health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
local stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
local rage_UI_entity = require("MHR_Overlay.UI.UI_Entities.rage_UI_entity");
local ailment_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_UI_entity");
local ailment_buildup_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_buildup_UI_entity");

local customization_menu = require("MHR_Overlay.UI.customization_menu");
local label_customization = require("MHR_Overlay.UI.Customizations.label_customization");
local bar_customization = require("MHR_Overlay.UI.Customizations.bar_customization");
local line_customization = require("MHR_Overlay.UI.Customizations.line_customization");

local health_customization = require("MHR_Overlay.UI.Customizations.health_customization");
local stamina_customization = require("MHR_Overlay.UI.Customizations.stamina_customization");
local rage_customization = require("MHR_Overlay.UI.Customizations.rage_customization");
local body_parts_customization = require("MHR_Overlay.UI.Customizations.body_parts_customization");
local ailments_customization = require("MHR_Overlay.UI.Customizations.ailments_customization");
local ailment_buildups_customization = require("MHR_Overlay.UI.Customizations.ailment_buildups_customization");

local large_monster_UI_customization = require("MHR_Overlay.UI.Customizations.large_monster_UI_customization");

local drawing = require("MHR_Overlay.UI.drawing");

------------------------INIT MODULES-------------------------
-- #region
screen.init_module();
singletons.init_module();
table_helpers.init_module();
unicode_helpers.init_module();
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
ailment_buildup_UI_entity.init_module();
body_part_UI_entity.init_module();

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
ailment_buildup.init_module();

customization_menu.init_module();
label_customization.init_module();
bar_customization.init_module();
line_customization.init_module();
large_monster_UI_customization.init_module();

label_customization.init_module();
bar_customization.init_module();
health_customization.init_module();
stamina_customization.init_module();
rage_customization.init_module();
body_parts_customization.init_module();
ailments_customization.init_module();
ailment_buildups_customization.init_module();

drawing.init_module();

damage_meter_UI.init_module();
large_monster_UI.init_module();
small_monster_UI.init_module();
time_UI.init_module();
env_creature_UI.init_module();

keyboard.init_module();

log.info("[MHR Overlay] Loaded.");
-- #endregion
------------------------INIT MODULES-------------------------

----------------------------LOOP-----------------------------
-- #region
local function main_loop()
	customization_menu.status = "OK";
	singletons.init();
	screen.update_window_size();
	player.update_myself_position();
	quest_status.update_is_online();
	quest_status.update_is_result_screen();
	quest_status.update_is_host();
	time.tick();

	--xy = tostring(singletons.quest_manager:call("isPlayQuest")) ..
	--"\n" .. tostring(singletons.quest_manager:call("isActiveQuest")) ..
	--"\n" .. tostring(singletons.quest_manager:call("isSingleQuest")) ..
	--"\n" .. tostring(singletons.quest_manager:call("isStartQuest")) ..
	--"\n" .. tostring(quest_status.index);

	player.update_player_list(quest_status.index >= 2);
	if quest_status.index < 2 then
		quest_status.update_is_training_area();

		if quest_status.is_training_area then
			local dynamic_enabled = config.current_config.large_monster_UI.dynamic.enabled and
				                        config.current_config.global_settings.module_visibility.training_area
					                        .large_monster_dynamic_UI;
			local static_enabled = config.current_config.large_monster_UI.static.enabled and
				                       config.current_config.global_settings.module_visibility.training_area.large_monster_static_UI;
			local highlighted_enabled = config.current_config.large_monster_UI.highlighted.enabled and
				                            config.current_config.global_settings.module_visibility.training_area
					                            .large_monster_highlighted_UI;

			if dynamic_enabled or static_enabled or highlighted_enabled then
				local success = pcall(large_monster_UI.draw, dynamic_enabled, static_enabled, highlighted_enabled);
				if not success then
					customization_menu.status = "Large monster drawing function threw an exception";
				end
			end

			if config.current_config.damage_meter_UI.enabled and
				config.current_config.global_settings.module_visibility.training_area.damage_meter_UI then
				local success = pcall(damage_meter_UI.draw);
				if not success then
					customization_menu.status = "Damage meter drawing function threw an exception";
				end
			end

			if config.current_config.endemic_life_UI.enabled and
				config.current_config.global_settings.module_visibility.training_area.endemic_life_UI then
				local success = pcall(env_creature_UI.draw);
				if not success then
					customization_menu.status = "Endemic life drawing function threw an exception";
				end
			end
		end
	elseif quest_status.is_result_screen then
		if config.current_config.small_monster_UI.enabled and
			config.current_config.global_settings.module_visibility.quest_result_screen.small_monster_UI then
			local success = pcall(small_monster_UI.draw);
			if not success then
				customization_menu.status = "Small monster drawing function threw an exception";
			end
		end

		local dynamic_enabled = config.current_config.large_monster_UI.dynamic.enabled and
			                        config.current_config.global_settings.module_visibility.quest_result_screen
				                        .large_monster_dynamic_UI;
		local static_enabled = config.current_config.large_monster_UI.static.enabled and
			                       config.current_config.global_settings.module_visibility.quest_result_screen
				                       .large_monster_static_UI;
		local highlighted_enabled = config.current_config.large_monster_UI.highlighted.enabled and
			                            config.current_config.global_settings.module_visibility.quest_result_screen
				                            .large_monster_highlighted_UI;

		if dynamic_enabled or static_enabled or highlighted_enabled then
			local success = pcall(large_monster_UI.draw, dynamic_enabled, static_enabled, highlighted_enabled);
			if not success then
				customization_menu.status = "Large monster drawing function threw an exception";
			end
		end

		if config.current_config.time_UI.enabled and
			config.current_config.global_settings.module_visibility.quest_result_screen.time_UI then
			local success = pcall(time_UI.draw);
			if not success then
				customization_menu.status = "Time drawing function threw an exception";
			end
		end

		if config.current_config.damage_meter_UI.enabled and
			config.current_config.global_settings.module_visibility.quest_result_screen.damage_meter_UI then
			local success = pcall(damage_meter_UI.draw);
			if not success then
				customization_menu.status = "Damage meter drawing function threw an exception";
			end
		end

		if config.current_config.endemic_life_UI.enabled and
			config.current_config.global_settings.module_visibility.quest_result_screen.endemic_life_UI then
			local success = pcall(env_creature_UI.draw);
			if not success then
				customization_menu.status = "Endemic life drawing function threw an exception";
			end
		end
	elseif quest_status.index == 2 then

		if config.current_config.small_monster_UI.enabled and
			config.current_config.global_settings.module_visibility.during_quest.small_monster_UI then
			local success = pcall(small_monster_UI.draw);
			if not success then
				customization_menu.status = "Small monster drawing function threw an exception";
			end
		end

		local dynamic_enabled = config.current_config.large_monster_UI.dynamic.enabled and
			                        config.current_config.global_settings.module_visibility.during_quest.large_monster_dynamic_UI;
		local static_enabled = config.current_config.large_monster_UI.static.enabled and
			                       config.current_config.global_settings.module_visibility.during_quest.large_monster_static_UI;
		local highlighted_enabled = config.current_config.large_monster_UI.highlighted.enabled and
			                            config.current_config.global_settings.module_visibility.during_quest
				                            .large_monster_highlighted_UI;

		if dynamic_enabled or static_enabled or highlighted_enabled then
			local success = pcall(large_monster_UI.draw, dynamic_enabled, static_enabled, highlighted_enabled);
			if not success then
				customization_menu.status = "Large monster drawing function threw an exception";
			end
		end

		if config.current_config.time_UI.enabled and
			config.current_config.global_settings.module_visibility.during_quest.time_UI then
			local success = pcall(time_UI.draw);
			if not success then
				customization_menu.status = "Time drawing function threw an exception";
			end
		end

		if config.current_config.damage_meter_UI.enabled and
			config.current_config.global_settings.module_visibility.during_quest.damage_meter_UI then
			local success = pcall(damage_meter_UI.draw);
			if not success then
				customization_menu.status = "Damage meter drawing function threw an exception";
			end
		end

		if config.current_config.endemic_life_UI.enabled and
			config.current_config.global_settings.module_visibility.during_quest.endemic_life_UI then
			local success = pcall(env_creature_UI.draw);
			if not success then
				customization_menu.status = "Endemic life drawing function threw an exception";
			end
		end
	end
end

-- #endregion
----------------------------LOOP-----------------------------

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
-- #endregion
--------------------------RE_IMGUI---------------------------

----------------------------D2D------------------------------
-- #region
if d2d ~= nil then
	d2d.register(function()
		drawing.init_font();
	end, main_loop);
else
	re.on_frame(main_loop);
end
-- #endregion
----------------------------D2D------------------------------

if debug.enabled then
	if d2d ~= nil then
		d2d.register(function()
		end, function()
			if xy ~= "" then
				d2d.text(drawing.font, "xy:\n" .. tostring(xy), 551, 11, 0xFF000000);
				d2d.text(drawing.font, "xy:\n" .. tostring(xy), 550, 10, 0xFFFFFFFF);
			end
		end);
	else
		re.on_frame(function()
			if xy ~= "" then
				draw.text("xy:\n" .. tostring(xy), 551, 11, 0xFF000000);
				draw.text("xy:\n" .. tostring(xy), 550, 10, 0xFFFFFFFF);
			end
		end);
	end
end

if imgui.begin_table == nil then
	re.msg(language.current_language.customization_menu.reframework_outdated);
end
