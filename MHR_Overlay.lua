--------------------CUSTOMIZATION SECTION--------------------
local config = {
	monster_UI = {
		enabled = true,
	
		spacing = 220, 
		orientation = "horizontal",
		sort_type = "health percentage", -- "normal" or "health" or "health percentage"
		reverse_order = false,
		
		position = {
			x = 525,
			y = 44,
			anchor = "bottom-left"
		},
	
		monster_name_label = {
			visibility = true,
			text = "%s",
			offset = {
				x = 5,
				y = 0
			},
	
			shadow = true,
			shadow_offset = {
				x = 1,
				y = 1
			},
	
			text_color = 0xFFE1F4CC,
			shadow_color = 0xFF000000
		},
	
		health_label = {
			visibility = false,
			text = "HP:",
			offset = {
				x = -25,
				y = 19
			},
	
			shadow = true,
			shadow_offset = {
				x = 1,
				y = 1
			},
	
			text_color = 0xFFE1F4CC,
			shadow_color = 0xFF000000
		},
	
		health_value_label = {
			text = "%.0f/%.0f", -- current_health/max_health
			visibility = true,
	
			offset = {
				x = 5,
				y = 19
			},
	
			shadow = true,
			shadow_offset = {
				x = 1,
				y = 1
			},
	
			text_color = 0xFFFFFFFF,
			shadow_color = 0xFF000000
		},
	
		health_percentage_label = {
			text = "%5.1f%%",
			visibility = true,
			
			offset = {
				x = 150,
				y = 19
			},
	
			shadow = true,
			shadow_offset = {
				x = 1,
				y = 1
			},
	
			text_color = 0xFFFFFFFF,
			shadow_color = 0xFF000000
		},
	
		health_bar = {
			visibility = true,
			offset = {
				x = 0,
				y = 17
			},
	
			size = {
				width = 200,
				height = 20
			},
	
			colors = {
				foreground = 0xB952A674,
				background = 0xB9000000,
				capture_health = 0xB933CCCC
			},
		}
	},

	time_UI = {
		enabled = true,
		
		position = {
			x = 65,
			y = 189,
			anchor = "top-left"
		},
	
		time_label = {
			visibility = true,
			text = "%02d:%06.3f",
			offset = {
				x = 0,
				y = 0
			},
	
			shadow = true,
			shadow_offset = {
				x = 1,
				y = 1
			},
	
			text_color = 0xFFE1F4CC,
			shadow_color = 0xFF000000
		}
	},

	damage_meter_UI = {
		enabled = true,
	
		include_small_monsters = true,
		include_player_damage = true,
		include_bomb_damage = true,
		include_kunai_damage = true,
		include_installation_damage = true, -- hunting_installations like ballista, cannon, etc.
		include_otomo_damage = true,
		include_monster_damage = true, -- note that installations during narwa fight are counted as monster damage
	
		show_module_if_total_damage_is_zero = true,
		show_player_if_player_damage_is_zero = true,
	
		highlighted_bar = "me",
	
		spacing = 24,
		orientation = "vertical", -- "vertical" or "horizontal"
		total_damage_offset_is_relative = true,
	
		damage_bar_relative_to = "top damage", -- "total damage" or "top damage"
		myself_bar_place_in_order = "first", --"normal" or "first" or "last"
		sort_type = "damage", -- "normal" or "damage"
		reverse_order = false,
	
		position = {
			x = 525,
			y = 225,
			--Possible values: "top-left", "top-right", "bottom-left", "bottom-right"
			anchor = "bottom-left"
		},
	
		player_name_label = {
			visibility = true,
			text = "[%d] %d %s",
			offset = {
				x = 5,
				y = 0
			},
	
			shadow = true,
			shadow_offset = {
				x = 1,
				y = 1
			},
	
			text_color = 0xFFE1F4CC,
			shadow_color = 0xFF000000
		},
	
		damage_value_label = {
			visibility = true,
			text = "%.0f",
			offset = {
				x = 145,
				y = 0
			},
	
			shadow = true,
			shadow_offset = {
				x = 1,
				y = 1
			},
	
			text_color = 0xFFE1F4CC,
			shadow_color = 0xFF000000
		},
	
		damage_percentage_label = {
			visibility = true,
			text = "%5.1f%%",
			offset = {
				x = 205,
				y = 0
			},
	
			shadow = true,
			shadow_offset = {
				x = 1,
				y = 1
			},
	
			text_color = 0xFFE1F4CC,
			shadow_color = 0xFF000000
		},
	
		total_damage_label = {
			visibility = true,
			text = "Total Damage",
			offset = {
				x = 5,
				y = 0
			},
	
			shadow = true,
			shadow_offset = {
				x = 1,
				y = 1
			},
	
			text_color = 0xFF7373FF,
			shadow_color = 0xFF000000
		},
	
		total_damage_value_label = {
			visibility = true,
			text = "%.0f",
			offset = {
				x = 145,
				y = 0
			},
	
			shadow = true,
			shadow_offset = {
				x = 1,
				y = 1
			},
	
			text_color = 0xFF7373FF,
			shadow_color = 0xFF000000
		},
	
		damage_bar = {
			visibility = true,
			offset = {
				x = 0,
				y = 17
			},
	
			size = {
				width = 250,
				height = 5
			},
	
			colors = {
				foreground = 0xA7F4A3CC,
				background = 0xB9000000
			},
		},
	
		highlighted_damage_bar = {
			visibility = true,
			offset = {
				x = 0,
				y = 17
			},
	
			size = {
				width = 250,
				height = 5
			},
	
			colors = {
				foreground = 0xA7A3D5F4,
				background = 0xB9000000
			},
		}
	}
};
----------------------CUSTOMIZATION END----------------------





--------------------FUNCTION DEFINITIONS---------------------
local save_config;
local load_config;

local get_window_size;
local calculate_screen_coordinates;

local draw_label;
local draw_bar;
local record_health;
local monster_health;
local quest_time;


local init_player;
local merge_damage;
local get_player;
local update_player;

local damage_meter;
--------------------FUNCTION DEFINITIONS---------------------





----------------------CUSTOMIZATION UI-----------------------
----------------------CUSTOMIZATION UI-----------------------





----------------------CONFIG LOAD/SAVE-----------------------
local config_file_name = 'MHR Overlay/config.json';

local status = "OK";
local x = "";

load_config = function()
	local loaded_config = json.load_file(config_file_name);
	if loaded_config ~= nil then
		log.info('[MHR Overlay] config.json loaded successfully');
		config = loaded_config;
	end
end

save_config = function ()
	x = "2";
	-- save current config to disk, replacing any existing file
	local success = json.dump_file(config_file_name, config);
	if success then
		log.info('[MHR Overlay] config.json saved successfully');
	else
		log.error('[MHR Overlay] Failed to save config.json');
	end
end

load_config();
----------------------CONFIG LOAD/SAVE-----------------------

---------------------------GLOBAL----------------------------
log.info("[MHR Overlay] loaded");


local screen_width = 0;
local screen_height = 0;

local scene_manager = sdk.get_native_singleton("via.SceneManager");
if scene_manager == nil then
    log.error("[MHR Overlay] No scene manager");
    return
end

local scene_view = sdk.call_native_func(scene_manager, sdk.find_type_definition("via.SceneManager"), "get_MainView");
if scene_view == nil then
    log.error("[MHR Overlay] No main view");
    return
end

re.on_draw_ui(function()
	local status_string = tostring(status);
    if string.len(status_string) > 0 then
        imgui.text("Status: " .. status_string);
    end

	local config_changed = false;

	changed, config.monster_UI.enabled = imgui.checkbox("Enable monster health UI", config.monster_UI.enabled);
	if changed then
		config_changed = true;
	end

    changed, config.time_UI.enabled = imgui.checkbox("Enable quest time UI", config.time_UI.enabled);
	if changed then
		config_changed = true;
	end

    changed, config.damage_meter_UI.enabled = imgui.checkbox("Enable damage dealt UI", config.damage_meter_UI.enabled);
	if changed then
		config_changed = true;
	end

	if config_changed then
		save_config();
	end
end);

re.on_frame(function()
	status = "OK";
	get_window_size();

	if config.monster_UI.enabled then
		monster_health();
	end

	if config.time_UI.enabled then
		quest_time();
	end

	if config.damage_meter_UI.enabled then
		damage_meter();
	end

	--draw.text("x:\n" .. tostring(x), 500, 800, 0xFFFFFFFF);

end);

get_window_size = function ()
	local size = scene_view:call("get_Size");
	if size == nil then
		log.error("[MHR Overlay] No scene view size");
		return
	end

	screen_width = size:get_field("w");
	if screen_width == nil then
		log.error("[MHR Overlay] No screen width");
		return
	end

	screen_height = size:get_field("h");
	if screen_height == nil then
		log.error("[MHR Overlay] No screen height");
		return
	end
end

calculate_screen_coordinates = function (position)
	if position.anchor == "top-left" then
		return {x = position.x, y = position.y};
	end

	if position.anchor == "top-right" then
		local screen_x = screen_width - position.x;
		return {x = screen_x, y = position.y};
	end

	if position.anchor == "bottom-left" then
		local screen_y = screen_height - position.y;
		return {x = position.x, y = screen_y};
	end

	if position.anchor == "bottom-right" then
		local screen_x = screen_width - position.x;
		local screen_y = screen_height - position.y;
		return {x = screen_x, y = screen_y};
	end

	return {x = position.x, y = position.y};
end
---------------------------GLOBAL----------------------------





------------------------DRAW HELPERS-------------------------
draw_label = function(label, position, ...)
	if label == nil then
		return;
	end

	if not label.visibility then
		return;
	end

	local text = string.format(label.text, table.unpack({...}));

	if label.shadow then
		draw.text(text, position.x + label.offset.x + label.shadow_offset.x, position.y + label.offset.y + label.shadow_offset.y, label.shadow_color);
	end

	draw.text(text, position.x + label.offset.x, position.y + label.offset.y, label.text_color);
end

draw_bar = function (bar, position, percentage)
	if bar == nil then
		return;
	end

	if not bar.visibility then
		return;
	end

	local foreground_width = bar.size.width * percentage;
	local background_width = bar.size.width - foreground_width;

	--foreground
	draw.filled_rect(position.x + bar.offset.x, position.y + bar.offset.y, foreground_width, bar.size.height, bar.colors.foreground);

	--background
	draw.filled_rect(position.x + foreground_width + bar.offset.x, position.y + bar.offset.y, background_width,bar.size.height, bar.colors.background);
end
------------------------DRAW HELPERS-------------------------




-------------------------MONSTER UI--------------------------
local monster_table = {};

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_type_def_update_method = enemy_character_base_type_def:get_method("update");

sdk.hook(enemy_character_base_type_def_update_method, function(args)
    record_health(sdk.to_managed_object(args[2]));
end, function(retval) return retval; end);

record_health = function (enemy)
    if enemy == nil then
		return;
	end

    local physical_param = enemy:get_field("<PhysicalParam>k__BackingField");
    if physical_param == nil then
        status = "No physical param";
        return;
    end

    local vital_param = physical_param:call("getVital", 0, 0);
    if vital_param == nil then
        status = "No vital param";
        return;
    end

    local health = vital_param:call("get_Current");
    local max_health = vital_param:call("get_Max");
	local missing_health = max_health - health;
	local capture_health = physical_param:call("get_CaptureHpVital");

	local health_percentage = 1;
	if max_health ~= 0 then
		health_percentage = health / max_health;
	end

    local monster = monster_table[enemy];

    if monster == nil then
        monster = {};
        monster_table[enemy] = monster;

        -- Grab enemy name.
        local message_manager = sdk.get_managed_singleton("snow.gui.MessageManager");
        if message_manager == nil then
            status = "No message manager";
            return;
        end

        local enemy_type = enemy:get_field("<EnemyType>k__BackingField");
        if enemy_type == nil then
            status = "No enemy type";
            return;
        end

        local enemy_name = message_manager:call("getEnemyNameMessage", enemy_type);
        monster.name = enemy_name;
    end

    monster.health = health;
    monster.max_health = max_health;
	monster.health_percentage = health_percentage;
	monster.missing_health = missing_health;
	monster.capture_health = capture_health;

end

monster_health = function()
    local enemy_manager = sdk.get_managed_singleton("snow.enemy.EnemyManager");
    if enemy_manager == nil then
        status = "No enemy manager";
        return;
	end

	local monsters = {};

	local enemy_count = enemy_manager:call("getBossEnemyCount");
	if enemy_count == nil then
		status = "No enemy count";
		return;
	end

    for i = 0, enemy_count - 1 do
        local enemy = enemy_manager:call("getBossEnemy", i);
        if enemy == nil then
			status = "No enemy";
            break;
        end

        local monster = monster_table[enemy];
        if monster == nil then
            status = "No monster hp entry";
            break;
		end

		table.insert(monsters, monster);
    end

	--sort here
	if config.monster_UI.sort_type == "normal" and config.monster_UI.reverse_order then
		local reversed_monsters = {};

		for i = #monsters, 1, -1 do
			table.insert(reversed_monsters, monsters[i]);
		end
		monsters = reversed_monsters;

	elseif config.monster_UI.sort_type == "health" then
		table.sort(monsters, function(left, right)
			local result = left.health > right.health;

			if config.monster_UI.reverse_order then
				result = not result;
			end

			return result;
		end);
	elseif config.monster_UI.sort_type == "health percentage" then
		table.sort(monsters, function(left, right)
			local result = left.health_percentage < right.health_percentage;

			if config.monster_UI.reverse_order then
				result = not result;
			end

			return result;
		end);
	end

	local i = 0;
	for _, monster in ipairs(monsters) do
		local position_on_screen = calculate_screen_coordinates(config.monster_UI.position);

		if config.monster_UI.orientation == "horizontal" then
			position_on_screen.x = position_on_screen.x + config.monster_UI.spacing * i;
		else
			position_on_screen.y = position_on_screen.y + config.monster_UI.spacing * i;
		end

		--remaining health
		--[[
		if monster.health <= monster.capture_health then
			remaining_health_color = monster_UI.colors.health_bar.capture_health
		else
			remaining_health_color = monster_UI.colors.health_bar.remaining_health
		end
		--]]

		draw_bar(config.monster_UI.health_bar, position_on_screen, monster.health_percentage);

		draw_label(config.monster_UI.monster_name_label, position_on_screen, monster.name);
		draw_label(config.monster_UI.health_label, position_on_screen);
		draw_label(config.monster_UI.health_value_label, position_on_screen, monster.health, monster.max_health);
		draw_label(config.monster_UI.health_percentage_label, position_on_screen, 100 * monster.health_percentage);

		i = i + 1;
	end
end
-------------------------MONSTER UI--------------------------





---------------------------TIME UI---------------------------
quest_time = function()
    local quest_manager = sdk.get_managed_singleton("snow.QuestManager");
    if quest_manager == nil then
        status = "No quest manager";
        return;
    end

    local quest_time_elapsed_minutes = quest_manager:call("getQuestElapsedTimeMin");
    if quest_time_elapsed_minutes == nil then
        status = "No quest time elapsed minutes";
        return;
    end

    local quest_time_total_elapsed_seconds = quest_manager:call("getQuestElapsedTimeSec");
    if quest_time_total_elapsed_seconds == nil then
        status = "No quest time total elapsed seconds";
        return;
    end

    if quest_time_total_elapsed_seconds == 0 then
        return;
    end

    local quest_time_elapsed_seconds = quest_time_total_elapsed_seconds - quest_time_elapsed_minutes * 60;

	local position_on_screen = calculate_screen_coordinates(config.time_UI.position);

	draw_label(config.time_UI.time_label, position_on_screen, quest_time_elapsed_minutes, quest_time_elapsed_seconds);
end
---------------------------TIME UI---------------------------





-----------------------DAMAGE METER UI-----------------------
local players = {};
local total = {};
local is_quest_online = false;
local last_displayed_players = {};
local myself_player_id = 0;

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_after_calc_damage_damage_side = enemy_character_base_type_def:get_method("afterCalcDamage_DamageSide");

sdk.hook(enemy_character_base_after_calc_damage_damage_side, function(args)
	local enemy = sdk.to_managed_object(args[2]);
	if enemy == nil then
		return;
	end

	if not config.damage_meter_UI.include_small_monsters then
		local is_boss_enemy = enemy:call("get_isBossEnemy");
		if not is_boss_enemy then
			return;
		end
	end

	local dead_or_captured = enemy:call("checkDie");
	if dead_or_captured == nil then
		return;
	end

	if dead_or_captured then
		return;
	end

	local enemy_calc_damage_info = sdk.to_managed_object(args[3]); -- snow.hit.EnemyCalcDamageInfo.AfterCalcInfo_DamageSide
	local attacker_id = enemy_calc_damage_info:call("get_AttackerID");
	local attacker_type = enemy_calc_damage_info:call("get_DamageAttackerType");

	if attacker_id >= 100 then
		return;
	end

	-- 4 is virtual player in singleplayer that 'owns' 2nd otomo
	if not is_quest_online and attacker_id == 4 then
		attacker_id = myself_player_id;
	end

	local damage_object = {}
	damage_object.total_damage = enemy_calc_damage_info:call("get_TotalDamage");;
	damage_object.physical_damage = enemy_calc_damage_info:call("get_PhysicalDamage");
	damage_object.elemental_damage = enemy_calc_damage_info:call("get_ElementDamage");
	damage_object.ailment_damage = enemy_calc_damage_info:call("get_ConditionDamage");

	-- -1 - bombs
	--  0 - player
	--  9 - kunai
	-- 11 - wyverblast
	-- 12 - ballista
	-- 13 - cannon
	-- 14 - machine cannon
	-- 16 - defender ballista/cannon
	-- 17 - wyvernfire artillery
	-- 18 - dragonator
	-- 19 - otomo
	-- 23 - monster

	local damage_source_type = tostring(attacker_type);
	if attacker_type == 0 then
		damage_source_type = "player";
	elseif attacker_type == 1 then
		damage_source_type = "bomb";
	elseif attacker_type == 9 then
		damage_source_type = "kunai";
	elseif attacker_type == 11 then
		damage_source_type = "wyvernblast";
	elseif attacker_type == 12 or attacker_type == 13 or attacker_type == 14 or attacker_type == 18 then
		damage_source_type = "installation";
	elseif attacker_type == 19 then
		damage_source_type = "otomo";
	elseif attacker_type == 23 then
		damage_source_type = "monster";
	end

	local player = get_player(attacker_id);
	if player == nil then
		return;
	end

	--x = x.. string.format("[attacker] %d [type] %s [dmg] %d", attacker_id, damage_source_type, damage_object.total_damage);

	update_player(total, damage_source_type, damage_object);
	update_player(player, damage_source_type, damage_object);
end, function(retval) return retval; end);

init_player = function(player_id, player_name, player_hunter_rank)
	player = {};
	player.id = player_id;
	player.name = player_name;
	player.hunter_rank = player_hunter_rank;

	player.total_damage = 0;
	player.physical_damage = 0;
	player.elemental_damage = 0;
	player.ailment_damage = 0;

	player.bombs = {};
	player.bombs.total_damage = 0;
	player.bombs.physical_damage = 0;
	player.bombs.elemental_damage = 0;
	player.bombs.ailment_damage = 0;

	player.kunai = {};
	player.kunai.total_damage = 0;
	player.kunai.physical_damage = 0;
	player.kunai.elemental_damage = 0;
	player.kunai.ailment_damage = 0;

	player.installations = {};
	player.installations.total_damage = 0;
	player.installations.physical_damage = 0;
	player.installations.elemental_damage = 0;
	player.installations.ailment_damage = 0;

	player.otomo = {};
	player.otomo.total_damage = 0;
	player.otomo.physical_damage = 0;
	player.otomo.elemental_damage = 0;
	player.otomo.ailment_damage = 0;

	player.monster = {};
	player.monster.total_damage = 0;
	player.monster.physical_damage = 0;
	player.monster.elemental_damage = 0;
	player.monster.ailment_damage = 0;

	player.display = {};
	player.display.total_damage = 0;
	player.display.physical_damage = 0;
	player.display.elemental_damage = 0;
	player.display.ailment_damage = 0;

	return player;
end
total = init_player(0, "Total", 0);

get_player = function(player_id)
	if players[player_id] == nil then
		return nil;
	end

	return players[player_id];
end

update_player = function(player, damage_source_type, damage_object)
	if player == nil then
		return;
	end

	if damage_source_type == "player" then
		merge_damage(player, damage_object);
	elseif damage_source_type == "bomb" then
		merge_damage(player.bombs, damage_object);
	elseif damage_source_type == "kunai" then
		merge_damage(player.kunai, damage_object);
	elseif damage_source_type == "wyvernblast" then
		merge_damage(player, damage_object);
	elseif damage_source_type == "installation" then
		merge_damage(player.installations, damage_object);
	elseif damage_source_type == "otomo" then
		merge_damage(player.otomo, damage_object);
	elseif damage_source_type == "monster" then
		merge_damage(player.monster, damage_object);
	else
		merge_damage(player, damage_object);
	end

	player.display.total_damage = 0;
	player.display.physical_damage = 0;
	player.display.elemental_damage = 0;
	player.display.ailment_damage = 0;

	if config.damage_meter_UI.include_player_damage then
		merge_damage(player.display, player);
	end

	if config.damage_meter_UI.include_bomb_damage then
		merge_damage(player.display, player.bombs);

	end

	if config.damage_meter_UI.include_kunai_damage then
		merge_damage(player.display, player.kunai);
	end

	if config.damage_meter_UI.include_installation_damage then
		merge_damage(player.display, player.installations);
	end

	if config.damage_meter_UI.include_otomo_damage then
		merge_damage(player.display, player.otomo);
	end

	if config.damage_meter_UI.include_monster_damage then
		merge_damage(player.display, player.monster);
	end
end

merge_damage = function(first, second)
	first.total_damage = first.total_damage + second.total_damage;
	first.physical_damage =  first.physical_damage + second.physical_damage;
	first.elemental_damage = first.elemental_damage + second.elemental_damage;
	first.ailment_damage = first.ailment_damage + second.ailment_damage;
end

damage_meter = function()
	local quest_manager = sdk.get_managed_singleton("snow.QuestManager");
    if quest_manager == nil then
        status = "No quest manager";
        return;
    end

	local quest_status = quest_manager:call("getStatus");
	if quest_status == nil then
		status = "No quest status";
        return;
	end

	if quest_status < 2 then
		players = {};
		total = init_player(0, "Total");
		return;
	end

	if total.display.total_damage == 0 and not config.damage_meter_UI.show_module_if_total_damage_is_zero then
		return;
	end

	-- players in lobby
	local lobby_manager = sdk.get_managed_singleton("snow.LobbyManager");
    if lobby_manager == nil then
        status = "No lobby manager";
        return;
    end

	is_quest_online = lobby_manager:call("IsQuestOnline");
	if is_quest_online == nil then
		is_quest_online = false;
	end

	--myself player
	local myself_player_info = lobby_manager:get_field("_myHunterInfo");
	if  myself_player_info == nil then
        status = "No myself player info list";
		return;
    end

	local myself_player_name = myself_player_info:get_field("_name");
	if myself_player_name == nil then
		status = "No myself player name";
		return;
	end

	myself_player_id = 0;
	if is_quest_online then
		myself_player_id = lobby_manager:get_field("_myselfQuestIndex");
		if myself_player_id == nil then
			status = "No myself player id";
			return;
		end
	else
		myself_player_id = lobby_manager:get_field("_myselfIndex");
		if myself_player_id == nil then
			status = "No myself player id";
			return;
		end
	end

	local progress_manager = sdk.get_managed_singleton("snow.progress.ProgressManager");
    if progress_manager == nil then
        status = "No progress manager";
        return;
    end

	local myself_hunter_rank = progress_manager:call("get_HunterRank");
	if myself_hunter_rank == nil then
        status = "No myself hunter rank";
		myself_hunter_rank = 0;
    end

	if players[myself_player_id] == nil then
		players[myself_player_id] = init_player(myself_player_id, myself_player_name, myself_hunter_rank);
	end

	local quest_players = {};

	--other players
	local player_info_list = lobby_manager:get_field("_questHunterInfo");
	if player_info_list == nil then
        status = "No player info list";
    end

	local count = player_info_list:call("get_Count");
	if count == nil then
        status = "No player info list count";
		return;
    end

	for i = 0, count - 1 do
		local player_info = player_info_list:call("get_Item", i);
		if player_info == nil then
			goto continue;
		end
		local player_id = player_info:get_field("_memberIndex");
		if player_id == nil then
			goto continue;
		end

		local player_hunter_rank = player_info:get_field("_hunterRank");
		if player_hunter_rank == nil then
			goto continue;
		end

		if player_id == myself_player_id and config.damage_meter_UI.myself_bar_place_in_order ~= "normal" then
			players[myself_player_id].hunter_rank = player_hunter_rank;
			goto continue;
		end

		local player_name = player_info:get_field("_name");
		if player_name == nil then
			goto continue;
		end

		if players[player_id] == nil then
			players[player_id] = init_player(player_id, player_name, player_hunter_rank);
		elseif players[player_id].name ~= player_name then
			players[player_id] = init_player(player_id, player_name, player_hunter_rank);
		end

		table.insert(quest_players, players[player_id]);

		::continue::
	end

	--sort here
	if config.damage_meter_UI.sort_type == "normal" and config.damage_meter_UI.reverse_order then
		local reversed_quest_players = {};

		for i = #quest_players, 1, -1 do
			table.insert(reversed_quest_players, quest_players[i]);
		end
		quest_players = reversed_quest_players;

	elseif config.damage_meter_UI.sort_type == "damage" then
		table.sort(quest_players, function(left, right)
			local result = left.display.total_damage > right.display.total_damage;
			if config.damage_meter_UI.reverse_order then
				result = not result;
			end

			return result;
		end);
	end

	if config.damage_meter_UI.myself_bar_place_in_order == "first" then
		table.insert(quest_players, 1, players[myself_player_id]);
	end

	if config.damage_meter_UI.myself_bar_place_in_order == "last" then
		table.insert(quest_players, #quest_players + 1, players[myself_player_id]);
	end

	local top_damage = 0;
	for _, player in ipairs(quest_players) do
		if player.display.total_damage > top_damage then
			top_damage = player.display.total_damage;
		end
	end

	last_displayed_players = quest_players;

	--draw
	local position_on_screen = calculate_screen_coordinates(config.damage_meter_UI.position);

	for _, player in ipairs(quest_players) do
		if player.display.total_damage == 0 and not config.damage_meter_UI.show_player_if_player_damage_is_zero then
			goto continue1;
		end
		local player_damage_percentage = 0;
		if total.display.total_damage ~= 0 then
			player_damage_percentage = player.display.total_damage / total.display.total_damage;
		end

		if config.damage_meter_UI.highlighted_bar == "me" then
			if player.id == myself_player_id then
				draw_bar(config.damage_meter_UI.highlighted_damage_bar, position_on_screen, player_damage_percentage);
			end
		elseif config.damage_meter_UI.highlighted_bar == "top damage" then
			if player.display.total_damage == top_damage then
				draw_bar(config.damage_meter_UI.highlighted_damage_bar, position_on_screen, player_damage_percentage);
			end
		else
			draw_bar(config.damage_meter_UI.damage_bar, position_on_screen, player_damage_percentage);
		end

		draw_label(config.damage_meter_UI.player_name_label, position_on_screen, player.hunter_rank, player.id, player.name)
		draw_label(config.damage_meter_UI.damage_value_label, position_on_screen, player.display.total_damage);
		draw_label(config.damage_meter_UI.damage_percentage_label, position_on_screen, 100 * player_damage_percentage);

		if config.damage_meter_UI.orientation == "horizontal" then
			position_on_screen.x = position_on_screen.x + config.damage_meter_UI.spacing;
		else
			position_on_screen.y = position_on_screen.y + config.damage_meter_UI.spacing;
		end
		::continue1::

	end

	--draw total damage
	draw_label(config.damage_meter_UI.total_damage_label, position_on_screen);
	draw_label(config.damage_meter_UI.total_damage_value_label, position_on_screen, total.display.total_damage);

end
-----------------------DAMAGE METER UI-----------------------
