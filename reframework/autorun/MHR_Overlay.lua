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

local keyboard = require("MHR_Overlay.Game_Handler.keyboard");
local quest_status = require("MHR_Overlay.Game_Handler.quest_status");
local screen = require("MHR_Overlay.Game_Handler.screen");
local singletons = require("MHR_Overlay.Game_Handler.singletons");
local time = require("MHR_Overlay.Game_Handler.time");
local error_handler = require("MHR_Overlay.Misc.error_handler");

local config = require("MHR_Overlay.Misc.config");
local language = require("MHR_Overlay.Misc.language");
local part_names = require("MHR_Overlay.Misc.part_names");
local utils = require("MHR_Overlay.Misc.utils");

local buffs = require("MHR_Overlay.Buffs.buffs");
local consumables = require("MHR_Overlay.Buffs.consumables");
local melody_effects = require("MHR_Overlay.Buffs.melody_effects");

local players = require("MHR_Overlay.Damage_Meter.players");
local non_players = require("MHR_Overlay.Damage_Meter.non_players");
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
local buff_UI = require("MHR_Overlay.UI.Modules.buff_UI");

local body_part_UI_entity = require("MHR_Overlay.UI.UI_Entities.body_part_UI_entity");
local damage_UI_entity = require("MHR_Overlay.UI.UI_Entities.damage_UI_entity");
local health_UI_entity = require("MHR_Overlay.UI.UI_Entities.health_UI_entity");
local stamina_UI_entity = require("MHR_Overlay.UI.UI_Entities.stamina_UI_entity");
local rage_UI_entity = require("MHR_Overlay.UI.UI_Entities.rage_UI_entity");
local ailment_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_UI_entity");
local ailment_buildup_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_buildup_UI_entity");
local buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");

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
local module_visibility_customization = require("MHR_Overlay.UI.Customizations.module_visibility_customization");
local large_monster_UI_customization = require("MHR_Overlay.UI.Customizations.large_monster_UI_customization");

local drawing = require("MHR_Overlay.UI.drawing");

------------------------INIT MODULES-------------------------
-- #region

error_handler.init_dependencies();
screen.init_dependencies();
singletons.init_dependencies();
utils.init_dependencies();
time.init_dependencies();

language.init_dependencies();
config.init_dependencies();
part_names.init_dependencies();

damage_UI_entity.init_dependencies();
health_UI_entity.init_dependencies();
stamina_UI_entity.init_dependencies();
rage_UI_entity.init_dependencies();
ailment_UI_entity.init_dependencies();
ailment_buildup_UI_entity.init_dependencies();
body_part_UI_entity.init_dependencies();
buff_UI_entity.init_dependencies();

buffs.init_dependencies();
consumables.init_dependencies();
melody_effects.init_dependencies();

damage_hook.init_dependencies();
players.init_dependencies();
non_players.init_dependencies();
quest_status.init_dependencies();

env_creature_hook.init_dependencies();
env_creature.init_dependencies();

body_part.init_dependencies();
ailments.init_dependencies();
large_monster.init_dependencies();
monster_hook.init_dependencies();
small_monster.init_dependencies();
ailment_hook.init_dependencies();
ailment_buildup.init_dependencies();

label_customization.init_dependencies();
bar_customization.init_dependencies();
line_customization.init_dependencies();
large_monster_UI_customization.init_dependencies();

label_customization.init_dependencies();
bar_customization.init_dependencies();
health_customization.init_dependencies();
stamina_customization.init_dependencies();
rage_customization.init_dependencies();
body_parts_customization.init_dependencies();
ailments_customization.init_dependencies();
ailment_buildups_customization.init_dependencies();
module_visibility_customization.init_dependencies();
customization_menu.init_dependencies();

drawing.init_dependencies();

damage_meter_UI.init_dependencies();
large_monster_UI.init_dependencies();
small_monster_UI.init_dependencies();
time_UI.init_dependencies();
env_creature_UI.init_dependencies();
buff_UI.init_dependencies();

keyboard.init_dependencies();

------------------------------------------------------------

error_handler.init_module();
language.init_module();
config.init_module();
part_names.init_module();

screen.init_module();
singletons.init_module();
utils.init_module();
time.init_module();

damage_UI_entity.init_module();
health_UI_entity.init_module();
stamina_UI_entity.init_module();
rage_UI_entity.init_module();
ailment_UI_entity.init_module();
ailment_buildup_UI_entity.init_module();
body_part_UI_entity.init_module();
buff_UI_entity.init_module();

buffs.init_module();
consumables.init_module();
melody_effects.init_module();

damage_hook.init_module();
players.init_module();
non_players.init_module();
quest_status.init_module();

env_creature_hook.init_module();
env_creature.init_module();

body_part.init_module();
ailments.init_module();
large_monster.init_module();
monster_hook.init_module();
small_monster.init_module();
ailment_hook.init_module();
ailment_buildup.init_module();

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
module_visibility_customization.init_module();
customization_menu.init_module();

drawing.init_module();

damage_meter_UI.init_module();
large_monster_UI.init_module();
small_monster_UI.init_module();
time_UI.init_module();
env_creature_UI.init_module();
buff_UI.init_module();

keyboard.init_module();

log.info("[MHR Overlay] Loaded.");
-- #endregion
------------------------INIT MODULES-------------------------

----------------------------LOOP-----------------------------
-- #region

local function draw_modules(module_visibility_config, flow_state_name)
	if module_visibility_config.small_monster_UI and config.current_config.small_monster_UI.enabled then
		local success = pcall(small_monster_UI.draw);
		if not success then
			error_handler.report("MHR_Overlay.draw_modules", string.format("[%s] Small Monster UI Drawing Function threw an Exception", flow_state_name));
		end
	end

	local large_monster_UI_config = config.current_config.large_monster_UI;

	local dynamic_enabled = large_monster_UI_config.dynamic.enabled and module_visibility_config.large_monster_dynamic_UI;
	local static_enabled = large_monster_UI_config.static.enabled and module_visibility_config.large_monster_static_UI;
	local highlighted_enabled = large_monster_UI_config.highlighted.enabled and module_visibility_config.large_monster_highlighted_UI;

	if dynamic_enabled or static_enabled or highlighted_enabled then
		local success = pcall(large_monster_UI.draw, dynamic_enabled, static_enabled, highlighted_enabled);
		if not success then
			error_handler.report("MHR_Overlay.draw_modules", string.format("[%s] Large Monster UI Drawing Function threw an Exception", flow_state_name));
		end
	end

	if config.current_config.time_UI.enabled and module_visibility_config.time_UI then
		local success = pcall(time_UI.draw);
		if not success then
			error_handler.report("MHR_Overlay.draw_modules", string.format("[%s] Time UI Drawing Function threw an Exception", flow_state_name));
		end
	end

	if config.current_config.damage_meter_UI.enabled and module_visibility_config.damage_meter_UI then
		local success = pcall(damage_meter_UI.draw);
		if not success then
			error_handler.report("MHR_Overlay.draw_modules", string.format("[%s] Damage Meter UI Drawing Function threw an Exception", flow_state_name));
		end
	end

	if config.current_config.endemic_life_UI.enabled and module_visibility_config.endemic_life_UI then
		local success = pcall(env_creature_UI.draw);
		if not success then
			error_handler.report("MHR_Overlay.draw_modules", string.format("[%s] Endemic Life UI Drawing Function threw an Exception", flow_state_name));
		end
	end

	if config.current_config.buff_UI.enabled and module_visibility_config.buff_UI then
		local success = pcall(buff_UI.draw);
		if not success then
			error_handler.report("MHR_Overlay.draw_modules", string.format("[%s] Buff UI Drawing Function threw an Exception", flow_state_name));
		end
	end
end

local function main_loop()
	time.update_timers();

	if quest_status.flow_state == quest_status.flow_states.IN_TRAINING_AREA then

		local large_monster_UI_config = config.current_config.large_monster_UI;
		local module_visibility_config = config.current_config.global_settings.module_visibility.in_training_area;

		local dynamic_enabled = large_monster_UI_config.dynamic.enabled and module_visibility_config.large_monster_dynamic_UI;
		local static_enabled = large_monster_UI_config.static.enabled and module_visibility_config.large_monster_static_UI;
		local highlighted_enabled = large_monster_UI_config.highlighted.enabled and module_visibility_config.large_monster_highlighted_UI;

		if dynamic_enabled or static_enabled or highlighted_enabled then
			local success = pcall(large_monster_UI.draw, dynamic_enabled, static_enabled, highlighted_enabled);
			if not success then
				error_handler.report("MHR_Overlay.main_loop", "[In Training Area] Large Monster UI Drawing Function threw an Exception");
			end
		end

		if config.current_config.damage_meter_UI.enabled and module_visibility_config.damage_meter_UI then
			local success = pcall(damage_meter_UI.draw);
			if not success then
				error_handler.report("MHR_Overlay.main_loop", "[In Training Area] Damage Meter UI Drawing Function threw an Exception");
			end
		end

		if config.current_config.endemic_life_UI.enabled and module_visibility_config.endemic_life_UI then
			local success = pcall(env_creature_UI.draw);
			if not success then
				error_handler.report("MHR_Overlay.main_loop", "[In Training Area] Endemic Life UI Drawing Function threw an Exception");
			end
		end

		if config.current_config.buff_UI.enabled and module_visibility_config.buff_UI then
			local success = pcall(buff_UI.draw);
			if not success then
				error_handler.report("MHR_Overlay.main_loop", "[In Training Area] Buff UI Drawing Function threw an Exception");
			end
		end


	elseif quest_status.flow_state == quest_status.flow_states.CUTSCENE then
		draw_modules(config.current_config.global_settings.module_visibility.cutscene, "Cutscene");
	elseif quest_status.flow_state == quest_status.flow_states.LOADING_QUEST then
		draw_modules(config.current_config.global_settings.module_visibility.loading_quest, "Loading Quest");
	elseif quest_status.flow_state == quest_status.flow_states.QUEST_START_ANIMATION then
		draw_modules(config.current_config.global_settings.module_visibility.quest_start_animation, "Quest Start Animation");
	elseif quest_status.flow_state >= quest_status.flow_states.PLAYING_QUEST and quest_status.flow_state <= quest_status.flow_states.WYVERN_RIDING_START_ANIMATION then
		draw_modules(config.current_config.global_settings.module_visibility.playing_quest, "Playing Quest");
	elseif quest_status.flow_state == quest_status.flow_states.KILLCAM then
		draw_modules(config.current_config.global_settings.module_visibility.killcam, "Killcam");
	elseif quest_status.flow_state == quest_status.flow_states.QUEST_END_TIMER then
		draw_modules(config.current_config.global_settings.module_visibility.quest_end_timer, "Quest End Timer");
	elseif quest_status.flow_state == quest_status.flow_states.QUEST_END_ANIMATION then
		draw_modules(config.current_config.global_settings.module_visibility.quest_end_animation, "Quest End Animation");
	elseif quest_status.flow_state == quest_status.flow_states.QUEST_END_SCREEN then
		draw_modules(config.current_config.global_settings.module_visibility.quest_end_screen, "Quest End Screen");
	elseif quest_status.flow_state == quest_status.flow_states.REWARD_SCREEN then
		draw_modules(config.current_config.global_settings.module_visibility.reward_screen, "Reward Screen");
	elseif quest_status.flow_state == quest_status.flow_states.SUMMARY_SCREEN then
		draw_modules(config.current_config.global_settings.module_visibility.summary_screen, "Summary Screen");
	end
end

-- #endregion
----------------------------LOOP-----------------------------

--------------------------RE_IMGUI---------------------------
-- #region
re.on_draw_ui(function()
	if imgui.button(language.current_language.customization_menu.mod_name .. " v" .. config.current_config.version) then
		local cached_config = config.current_config.customization_menu;
		cached_config.visible = not cached_config.visible;
		config.save_current();
	end
end);

re.on_frame(function()
	if reframework:is_drawing_ui() then
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
	end, function() 
		if config.current_config.global_settings.renderer.use_d2d_if_available then
			main_loop();
		end
	end);
end

re.on_frame(function()
	if d2d == nil or not config.current_config.global_settings.renderer.use_d2d_if_available then
		main_loop();
	end
end);
-- #endregion
----------------------------D2D------------------------------

if imgui.begin_table == nil then
	re.msg(language.current_language.customization_menu.reframework_outdated);
end