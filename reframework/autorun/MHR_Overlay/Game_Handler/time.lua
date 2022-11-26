local time = {};
local singletons;
local customization_menu;
local quest_status;
local player;
local non_players;
local config;
local small_monster;

local quest_manager_type_def = sdk.find_type_definition("snow.QuestManager");
local get_quest_elapsed_time_min_method = quest_manager_type_def:get_method("getQuestElapsedTimeMin");
local get_quest_elapsed_time_sec_method = quest_manager_type_def:get_method("getQuestElapsedTimeSec");

time.total_elapsed_seconds = 0;
time.elapsed_minutes = 0;
time.elapsed_seconds = 0;

time.total_elapsed_script_seconds = 0;
time.last_elapsed_script_seconds = 0;

function time.update_script_time()
	time.total_elapsed_script_seconds = os.clock();
end

function time.tick()
	time.update_script_time();

	if singletons.quest_manager == nil then
		return;
	end

	local quest_time_elapsed_minutes = get_quest_elapsed_time_min_method:call(singletons.quest_manager);
	if quest_time_elapsed_minutes == nil then
		customization_menu.status = "No quest time elapsed minutes";
		return;
	end

	time.elapsed_minutes = quest_time_elapsed_minutes;

	local quest_time_total_elapsed_seconds = get_quest_elapsed_time_sec_method:call(singletons.quest_manager);
	if quest_time_total_elapsed_seconds == nil then
		customization_menu.status = "No quest time total elapsed seconds";
		return;
	end

	time.total_elapsed_seconds = quest_time_total_elapsed_seconds;
	time.elapsed_seconds = quest_time_total_elapsed_seconds - quest_time_elapsed_minutes * 60;

	if time.total_elapsed_script_seconds - time.last_elapsed_script_seconds > 1 then
		time.last_elapsed_script_seconds = time.total_elapsed_script_seconds;
		time.update_players_dps();
	end
end

function time.update_players_dps()
	local cached_config = config.current_config.damage_meter_UI.settings;

	if cached_config.freeze_dps_on_quest_end and quest_status.is_quest_end then
		return;
	end

	local new_total_dps = 0;
	for _, _player in pairs(player.list) do
		if _player.join_time == -1 then
			_player.join_time = time.total_elapsed_script_seconds;
		end

		if cached_config.dps_mode == "Quest Time" then
			if time.total_elapsed_seconds > 0 then
				_player.dps = _player.display.total_damage / time.total_elapsed_seconds;
			end
		elseif cached_config.dps_mode == "Join Time" then
			if time.total_elapsed_script_seconds - _player.join_time > 0 then
				_player.dps = _player.display.total_damage / (time.total_elapsed_script_seconds - _player.join_time);
			end
		elseif cached_config.dps_mode == "First Hit" then
			if time.total_elapsed_script_seconds - _player.first_hit_time > 0 then
				_player.dps = _player.display.total_damage / (time.total_elapsed_script_seconds - _player.first_hit_time);
			end
		end

		new_total_dps = new_total_dps + _player.dps;
	end

	for _, servant in pairs(non_players.servant_list) do
		if servant.join_time == -1 then
			servant.join_time = time.total_elapsed_script_seconds;
		end

		if cached_config.dps_mode == "Quest Time" then
			if time.total_elapsed_seconds > 0 then
				servant.dps = servant.display.total_damage / time.total_elapsed_seconds;
			end
		elseif cached_config.dps_mode == "Join Time" then
			if time.total_elapsed_script_seconds - servant.join_time > 0 then
				servant.dps = servant.display.total_damage / (time.total_elapsed_script_seconds - servant.join_time);
			end
		elseif cached_config.dps_mode == "First Hit" then
			if time.total_elapsed_script_seconds - servant.first_hit_time > 0 then
				servant.dps = servant.display.total_damage / (time.total_elapsed_script_seconds - servant.first_hit_time);
			end
		end

		new_total_dps = new_total_dps + servant.dps;
	end

	player.total.dps = new_total_dps;
end

function time.init_module()
	player = require("MHR_Overlay.Damage_Meter.player");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	config = require("MHR_Overlay.Misc.config");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
end

return time;
