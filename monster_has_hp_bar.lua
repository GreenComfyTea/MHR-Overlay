log.info("[monster_has_hp_bar.lua] loaded")

local status = ""
local hp_table = {}

local scene_manager = sdk.get_native_singleton("via.SceneManager")
if not scene_manager then 
    log.error("[monster_has_hp_bar.lua] No scene manager")
    return
end

local scene_view = sdk.call_native_func(scene_manager, sdk.find_type_definition("via.SceneManager"), "get_MainView")
if not scene_view then
    log.error("[monster_has_hp_bar.lua] No main view")
    return
end

local size = scene_view:call("get_Size")
if not size then
    log.error("[monster_has_hp_bar.lua] No scene view size")
    return
end

local screen_width = size:get_field("w")
if not screen_width then
    log.error("[monster_has_hp_bar.lua] No screen width")
    return
end

local screen_height = size:get_field("h")
if not screen_height then
    log.error("[monster_has_hp_bar.lua] No screen height")
    return
end

function record_hp(enemy)
    if not enemy then return end

    local physical_param = enemy:get_field("<PhysicalParam>k__BackingField")
    if not physical_param then 
        status = "No physical param"
        return
    end

    local vital_param = physical_param:call("getVital", 0, 0)
    if not vital_param then
        status = "No vital param"
        return
    end

    local hp = vital_param:call("get_Current")
    local max_hp = vital_param:call("get_Max")
    local hp_entry = hp_table[enemy]

    if not hp_entry then 
        hp_entry = {} 
        hp_table[enemy] = hp_entry

        -- Grab enemy name.
        local message_manager = sdk.get_managed_singleton("snow.gui.MessageManager")
        if not message_manager then
            status = "No message manager"
            return
        end

        local enemy_type = enemy:get_field("<EnemyType>k__BackingField")
        if not enemy_type then
            status = "No enemy type"
            return
        end

        local enemy_name = message_manager:call("getEnemyNameMessage", enemy_type)
        hp_entry.name = enemy_name
    end

    hp_entry.hp = hp
    hp_entry.max_hp = max_hp
end

local type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase")
local update_method = type_def:get_method("update")

sdk.hook(update_method, function(args) 
    record_hp(sdk.to_managed_object(args[2]))
end, function(retval) end)

re.on_draw_ui(function() 
    if string.len(status) > 0 then
        imgui.text("[monster_has_hp_bar.lua] Status: " .. status)
    end
end)

local shadow_shift_x = 1
local shadow_shift_y = 1

local missing_monster_hp = 0;

re.on_frame(function()
    monster_hp();
    quest_time();
    dps_meter();

    status = ""
end)

function monster_hp()
    --[[
    local player_manager = sdk.get_managed_singleton("snow.player.PlayerManager")
    if not player_manager then 
        status = "No player manager"
        return
    end

    local player = player_manager:call("findMasterPlayer")
    if not player then 
        status = "No local player"
        return
    end

    local player_game_object = player:call("get_GameObject")
    if not player_game_object then
        status = "No local player game object"
        return
    end

    local player_transform = player_game_object:call("get_Transform")
    if not player_transform then
        status = "No local player transform"
        return
    end

    local player_position = player_transform:call("get_Position")
    if not player_position then 
        status = "No local player position"
        return
    end
    --]]

    local enemy_manager = sdk.get_managed_singleton("snow.enemy.EnemyManager")
    if not enemy_manager then 
        status = "No enemy manager"
        return 
    end

    --local closest_enemy = nil
    --local closest_dist = 999999

    missing_monster_hp = 0

    for i = 0, 4 do
        local enemy = enemy_manager:call("getBossEnemy", i)
        if not enemy then
            break
        end

        local hp_entry = hp_table[enemy]
        if not hp_entry then 
            status = "No hp entry"
            break 
        end

        --[[
        local enemy_game_object = enemy:call("get_GameObject")
        if not enemy_game_object then
            status = "No enemy game object"
            break
        end

        local enemy_transform = enemy_game_object:call("get_Transform")
        if not enemy_transform then
            status = "No enemy transform"
            break 
        end

        local enemy_position = enemy_transform:call("get_Position")
        if not enemy_position then 
            status = "No enemy position"
            break 
        end

        local distance = (player_position - enemy_position):length()

        if distance < closest_dist then
            closest_dist = distance
            closest_enemy = enemy
        end
        --]]

        local width = 200
        local height = 20

        local spacing = 20

        local x = 450 + width * i + spacing * i
        local y = screen_height - 27

        missing_monster_hp = missing_monster_hp + (hp_entry.max_hp - hp_entry.hp)

        local hp_percent = hp_entry.hp / hp_entry.max_hp
        local hp_width = width * hp_percent
        local missing_hp_width = width - hp_width
    
        local text_name = hp_entry.name
        local text_hp = string.format("%d/%d\t(%d%%)", hp_entry.hp, hp_entry.max_hp, math.floor(hp_percent * 100))

        --border
        --draw.filled_rect(x - 1, y - 1, width + 2, height + 2, 0xAA000000)
        --missing hp
        draw.filled_rect(x + hp_width, y, missing_hp_width, height, 0xB9000000)
        --remaining hp
        draw.filled_rect(x, y, hp_width, height, 0xB952A674)

        --text shadow
        draw.text(text_name, x + 5 + shadow_shift_x, y - height + shadow_shift_y + 2, 0xFF000000)
        draw.text(text_hp, x + shadow_shift_x + width / 4, y + shadow_shift_y + 2, 0xFF000000)

        --text itself
        draw.text(text_name, x + 5, y - height + 2, 0xFFE1F4CC)
        draw.text(text_hp, x + width / 4, y + 2, 0xFFFFFFFF)
        
        status = ""
    end

     --[[
    if not closest_enemy then
        hp_table = {}
        status = "No enemy"
        return
    end

    local hp_entry = hp_table[closest_enemy]
    if not hp_entry then 
        status = "No hp entry"
        return
    end

    local x = 0
    local y = 0
    local w = screen_width
    local h = 20
    local hp_percent = hp_entry.hp / hp_entry.max_hp
    local hp_w = w * hp_percent 
    local missing_hp_w = w - hp_w 

    draw.filled_rect(x + hp_w, y, missing_hp_w, h, 0xAA000000)
    draw.filled_rect(x, y, hp_w, h, 0xAA228B22)
    draw.text(hp_entry.name .. "\t" .. math.floor(hp_percent * 100) .. "%\t" .. hp_entry.hp .. "/" .. hp_entry.max_hp, x + 5, y + 2, 0xFFFFFFFF)
    status = ""
    --]]
end

function quest_time()
    local quest_manager = sdk.get_managed_singleton("snow.QuestManager")
    if not quest_manager then 
        status = "No quest manager"
        return 
    end

    local quest_time_elapsed_minutes = quest_manager:call("getQuestElapsedTimeMin");
    if not quest_time_elapsed_minutes then
        status = "No quest time elapsed minutes"
        return
    end

    local quest_time_total_elapsed_seconds = quest_manager:call("getQuestElapsedTimeSec");
    if not quest_time_total_elapsed_seconds then
        status = "No quest time total elapsed seconds"
        return
    end

    if quest_time_total_elapsed_seconds == 0 then
        return
    end

    local quest_time_elapsed_seconds = quest_time_total_elapsed_seconds - quest_time_elapsed_minutes * 60

    local elapsed_time = string.format("%02d:%06.3f", quest_time_elapsed_minutes, quest_time_elapsed_seconds)

    local x = 65
    local y = 189

    --shadow
    draw.text(elapsed_time, x + shadow_shift_x, y + shadow_shift_y, 0xFF000000)

    --text
    draw.text(elapsed_time, x, y, 0xFFE1F4CC)
end

function dps_meter()
    local player_manager = sdk.get_managed_singleton("snow.player.PlayerManager")
    if not player_manager then 
        status = "No player manager"
        return
    end

    local player = player_manager:call("findMasterPlayer")
    if not player then 
        status = "No local player"
        return
    end

    local quest_manager = sdk.get_managed_singleton("snow.QuestManager")
    if not quest_manager then 
        status = "No quest manager"
        return 
    end

    local kpi_data = quest_manager:call("get_KpiData");
    if not kpi_data then
        status = "No kpi data"
        return
    end

    local player_total_attack_damage = kpi_data:call("get_PlayerTotalAttackDamage");
    if not player_total_attack_damage then
        status = "No player total attack damage"
        return
    end
    
    local player_total_elemental_attack_damage = kpi_data:call("get_PlayerTotalElementalAttackDamage");
    if not player_total_elemental_attack_damage then
        status = "No player total elemental attack damage"
        return
    end

    local player_total_status_ailments_damage = kpi_data:call("get_PlayerTotalStatusAilmentsDamage");
    if not player_total_status_ailments_damage then
        status = "No player total status ailments damage"
        return
    end

    if missing_monster_hp == 0 then
        return
    end

    local player_total_damage = player_total_attack_damage + player_total_elemental_attack_damage + player_total_status_ailments_damage

    local x = 450
    local y = screen_height - 75
    local width = 200
    local height = 3

    local bar_shift = 17

    local dealt_damage_percent = player_total_damage / missing_monster_hp
    local dealt_damage_bar_width = width * dealt_damage_percent
    local rest_bar_width = width - dealt_damage_bar_width
    
    local damage_text = string.format("%d/%d\t", player_total_damage, missing_monster_hp);
    local damage_percent_text = string.format("%5.1f%%",  100 * dealt_damage_percent);

    --rest of the bar
    draw.filled_rect(x + dealt_damage_bar_width, y + bar_shift, rest_bar_width, height, 0xA7000000)
    --dealt_damage
    draw.filled_rect(x, y + bar_shift, dealt_damage_bar_width, height, 0xA7F4A3CC)

    --Damage
    --shadow
    draw.text(damage_text, x + 5 + shadow_shift_x, y + shadow_shift_y, 0xFF000000)
    --text
    draw.text(damage_text, x + 5, y, 0xFFE1F4CC)
    
    --Percent
    --shadow
    draw.text(damage_percent_text , x - 45 + width + shadow_shift_x, y + shadow_shift_y, 0xFF000000)
    --text
    draw.text(damage_percent_text, x - 45 + width, y, 0xFFE1F4CC)
end