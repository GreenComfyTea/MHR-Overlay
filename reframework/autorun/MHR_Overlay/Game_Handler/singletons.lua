local singletons = {};

singletons.message_manager = nil;
singletons.enemy_manager = nil;
singletons.lobby_manager = nil;
singletons.progress_manager = nil;
singletons.quest_manager = nil;
singletons.player_manager = nil;
singletons.village_area_manager = nil;
singletons.gui_manager = nil;

function singletons.init()
	singletons.init_message_manager();
	singletons.init_enemy_manager();
	singletons.init_lobby_manager()
	singletons.init_progress_manager();
	singletons.init_quest_manager();
	singletons.init_player_manager();
	singletons.init_village_area_manager();
	singletons.init_gui_manager();
end

function singletons.init_message_manager()
	if singletons.message_manager ~= nil then
		return;
	end

	singletons.message_manager = sdk.get_managed_singleton("snow.gui.MessageManager");
	if singletons.message_manager == nil then
		log.error("[MHR Overlay] No message manager");
	end

	return singletons.message_manager;
end

function singletons.init_enemy_manager()
	if singletons.enemy_manager ~= nil then
		return;
	end

	singletons.enemy_manager = sdk.get_managed_singleton("snow.enemy.EnemyManager");
	if singletons.enemy_manager == nil then
		log.error("[MHR Overlay] No enemy manager");
	end

	return singletons.enemy_manager;
end

function singletons.init_lobby_manager()
	if singletons.lobby_manager ~= nil then
		return;
	end

	singletons.lobby_manager = sdk.get_managed_singleton("snow.LobbyManager");
	if singletons.lobby_manager == nil then
		log.error("[MHR Overlay] No lobby manager");
		return false;
	end

	return singletons.lobby_manager;
end

function singletons.init_progress_manager()
	if singletons.progress_manager ~= nil then
		return;
	end

	singletons.progress_manager = sdk.get_managed_singleton("snow.progress.ProgressManager");
	if singletons.progress_manager == nil then
		log.error("[MHR Overlay] No progress manager");
		return false;
	end

	return singletons.progress_manager;
end

function singletons.init_quest_manager()
	if singletons.quest_manager ~= nil then
		return;
	end

	singletons.quest_manager = sdk.get_managed_singleton("snow.QuestManager");
	if singletons.quest_manager == nil then
		log.error("[MHR Overlay] No quest manager");
	end

	return singletons.quest_manager;
end

function singletons.init_player_manager()
	if singletons.player_manager ~= nil then
		return;
	end

	singletons.player_manager = sdk.get_managed_singleton("snow.player.PlayerManager");
	if singletons.player_manager == nil then
		log.error("[MHR Overlay] No player manager");
	end

	return singletons.player_manager;
end

function singletons.init_village_area_manager()
	if singletons.village_area_manager ~= nil then
		return;
	end

	singletons.village_area_manager = sdk.get_managed_singleton("snow.VillageAreaManager");
	if singletons.village_area_manager == nil then
		log.error("[MHR Overlay] No village manager");
	end

	return singletons.village_area_manager;
end

function singletons.init_gui_manager()
	if singletons.gui_manager ~= nil then
		return;
	end

	singletons.gui_manager = sdk.get_managed_singleton("snow.gui.GuiManager");
	if singletons.gui_manager == nil then
		log.error("[MHR Overlay] No gui manager");
	end

	return singletons.gui_manager;
end


function singletons.init_module()
	singletons.init();
end

return singletons;