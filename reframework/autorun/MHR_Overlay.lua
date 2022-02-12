x = "";

local quest_status = require("MHR_Overlay.Game_Handler.quest_status");
local screen = require("MHR_Overlay.Game_Handler.screen");
local singletons = require("MHR_Overlay.Game_Handler.singletons");

local config = require("MHR_Overlay.Misc.config");
local language = require("MHR_Overlay.Misc.language");
local table_helpers = require("MHR_Overlay.Misc.table_helpers");
local part_names = require("MHR_Overlay.Misc.part_names");

local player = require("MHR_Overlay.Damage_Meter.player");
local damage_hook = require("MHR_Overlay.Damage_Meter.damage_hook");

local body_part = require("MHR_Overlay.Monsters.body_part");
local large_monster = require("MHR_Overlay.Monsters.large_monster");
local monster_hook = require("MHR_Overlay.Monsters.monster_hook");
local small_monster = require("MHR_Overlay.Monsters.small_monster");

local damage_meter_UI = require("MHR_Overlay.UI.Modules.damage_meter_UI");
local large_monster_UI = require("MHR_Overlay.UI.Modules.large_monster_UI");
local small_monster_UI = require("MHR_Overlay.UI.Modules.small_monster_UI");
local time_UI = require("MHR_Overlay.UI.Modules.time_UI");

local body_part_UI_entity = require("MHR_Overlay.UI.UI_Entities.body_part_UI_entity");
local damage_UI_entity = require("MHR_Overlay.UI.UI_Entities.damage_UI_entity");
local health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
local stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
local rage_UI_entity = require("MHR_Overlay.UI.UI_Entities.rage_UI_entity");

local customization_menu = require("MHR_Overlay.UI.customization_menu");
local drawing = require("MHR_Overlay.UI.drawing");

------------------------INIT MODULES-------------------------
-- #region
screen.init_module();
singletons.init_module();
table_helpers.init_module();

language.init_module();
config.init_module();
quest_status.init_module();
part_names.init_module();

damage_UI_entity.init_module();
health_UI_entity.init_module();
stamina_UI_entity.init_module();
rage_UI_entity.init_module();

damage_hook.init_module();
player.init_module();

body_part.init_module();
large_monster.init_module();
monster_hook.init_module();
small_monster.init_module();

customization_menu.init_module();
body_part_UI_entity.init_module();
damage_meter_UI.init_module();
drawing.init_module();
large_monster_UI.init_module();
small_monster_UI.init_module();
time_UI.init_module();



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
end);

re.on_frame(function()
	--draw.text("x: " .. tostring(x), 451, 51, 0xFF000000);
	--draw.text("x: " .. tostring(x), 450, 50, 0xFFFFFFFF);
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


	if quest_status.index < 2 then
		quest_status.update_is_training_area();

		if quest_status.is_training_area then
			local dynamic_enabled = config.current_config.large_monster_UI.dynamic.enabled and config.current_config.global_settings.module_visibility.training_area.large_monster_dynamic_UI;
			local static_enabled = config.current_config.large_monster_UI.static.enabled and config.current_config.global_settings.module_visibility.training_area.large_monster_static_UI;

			if dynamic_enabled or static_enabled then
				large_monster_UI.draw(dynamic_enabled, static_enabled);
			end
	
			if config.current_config.damage_meter_UI.enabled and config.current_config.global_settings.module_visibility.training_area.damage_meter_UI then
				damage_meter_UI.draw();
			end
		end
		
	elseif quest_status.index == 2 then
		if config.current_config.small_monster_UI.enabled and config.current_config.global_settings.module_visibility.during_quest.small_monster_UI then
			small_monster_UI.draw();
		end

		local dynamic_enabled = config.current_config.large_monster_UI.dynamic.enabled and config.current_config.global_settings.module_visibility.during_quest.large_monster_dynamic_UI;
		local static_enabled = config.current_config.large_monster_UI.static.enabled and config.current_config.global_settings.module_visibility.during_quest.large_monster_static_UI;

		if dynamic_enabled or static_enabled then
			large_monster_UI.draw(dynamic_enabled, static_enabled);
		end

		if config.current_config.time_UI.enabled and config.current_config.global_settings.module_visibility.during_quest.time_UI then
			time_UI.draw();
		end

		if config.current_config.damage_meter_UI.enabled and config.current_config.global_settings.module_visibility.during_quest.damage_meter_UI then
			damage_meter_UI.draw();
		end
	elseif quest_status.index > 2 then
		if config.current_config.small_monster_UI.enabled and config.current_config.global_settings.module_visibility.quest_summary_screen.small_monster_UI then
			small_monster_UI.draw();
		end

		local dynamic_enabled = config.current_config.large_monster_UI.dynamic.enabled and config.current_config.global_settings.module_visibility.quest_summary_screen.large_monster_dynamic_UI;
		local static_enabled = config.current_config.large_monster_UI.static.enabled and config.current_config.global_settings.module_visibility.quest_summary_screen.large_monster_static_UI;

		if dynamic_enabled or static_enabled then
			large_monster_UI.draw(dynamic_enabled, static_enabled);
		end
		
		if config.current_config.time_UI.enabled and config.current_config.global_settings.module_visibility.quest_summary_screen.time_UI then
			time_UI.draw();
		end

		if config.current_config.damage_meter_UI.enabled and config.current_config.global_settings.module_visibility.quest_summary_screen.damage_meter_UI then
			damage_meter_UI.draw();
		end
	end
end);
