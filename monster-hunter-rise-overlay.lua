--------------------CUSTOMIZATION SECTION--------------------
local monster_UI = {
	enabled = true,

    visibility = {
        health_bar = true,
        monster_name = true,
        current_health = true,
        max_health = true,
        health_percentage = true
    },

	shadows = {
		monster_name = true,
		health_values = true, --current_health and max_health
		health_percentage = true
	},
    
    position = {
        x = 450,
        y = 27,  
        --Possible values: "top_left", "top_right", "bottom_left", "bottom_right"
        anchor = "bottom_left"
    },

	spacing = 220,

    offsets = {
        health_bar = {
            x = 0,
            y = 0
        },
		
        monster_name = {
            x = 5,
            y = -17
        },

        health_values = {
            x = 5,
            y = 2
        },

        health_percentage = {
            x = 150,
            y = 2
        }
    },
    
    health_bar = {
        width = 200,
        height = 20
    },

    shadow_offsets = {
        monster_name = {
            x = 1,
            y = 1
        },

        health_values = {
            x = 1,
            y = 1
        },

        health_percentage = {
            x = 1,
            y = 1
        }
    },

    colors = {
		health_bar = {
            remaining_health = 0xB952A674,
            missing_health = 0xB9000000
        },
		
        monster_name = {
            text = 0xFFE1F4CC,
            shadow = 0xFF000000
        },

        health_values = {
            text = 0xFFFFFFFF,
            shadow = 0xFF000000
        },

        health_percentage = {
            text = 0xFFFFFFFF,
            shadow = 0xFF000000
        }
    }
};

local time_UI = {
    enabled = true,
	shadow = true,

    position = {
        x = 65,
        y = 189,
        --Possible values: "top_left", "top_right", "bottom_left", "bottom_right"
        anchor = "top_left"
    },

    shadow_offset = {
        x = 1,
        y = 1
    },

    colors = {
        text = 0xFFE1F4CC,
		shadow = 0xFF000000
    }
};

local damage_meter_UI = {
	enabled = true,

	visibility = {
		damage_bar = true,
		player_damage = true,
		total_damage = true,
		damage_percentage = true

	},

	shadows = {
		damage_values = true,
		damage_percentage = true
	},

	position = {
		x = 450,
		y = 75,  
		--Possible values: "top_left", "top_right", "bottom_left", "bottom_right"
		anchor = "bottom_left"
	},

	offsets = {
		damage_bar = {
			x = 0,
			y = 17
		},
		
		damage_values = {
			x = 5,
			y = 0
		},

		damage_percentage = {
			x = 155,
			y = 0
		}
	},
	
	damage_bar = {
		width = 200,
		height = 3
	},

	shadow_offsets = {
		damage_values = {
			x = 1,
			y = 1
		},

		damage_percentage = {
			x = 1,
			y = 1
		}
	},

	colors = {
		damage_bar = {
			player_damage = 0xA7F4A3CC,
			others_damage = 0xA7000000
		},
		
		damage_values = {
			text = 0xFFE1F4CC,
			shadow = 0xFF000000
		},

		damage_percentage = {
			text = 0xFFE1F4CC,
			shadow = 0xFF000000
		},
	}
};
----------------------CUSTOMIZATION END----------------------

log.info("[monster_has_hp_bar.lua] loaded");

local status = "";
local monster_table = {};

local missing_monster_health = 0;
local previous_missing_monster_health = 0;
local memorized_missing_monster_health = 0;

local scene_manager = sdk.get_native_singleton("via.SceneManager");
if not scene_manager then 
    log.error("[monster_has_hp_bar.lua] No scene manager");
    return
end

local scene_view = sdk.call_native_func(scene_manager, sdk.find_type_definition("via.SceneManager"), "get_MainView");
if not scene_view then
    log.error("[monster_has_hp_bar.lua] No main view");
    return
end

local screen_width;
local screen_height;

function record_health(enemy)
    if not enemy then
		return;
	end

    local physical_param = enemy:get_field("<PhysicalParam>k__BackingField");
    if not physical_param then 
        status = "No physical param";
        return;
    end

    local vital_param = physical_param:call("getVital", 0, 0);
    if not vital_param then
        status = "No vital param";
        return;
    end

    local health = vital_param:call("get_Current");
    local max_health = vital_param:call("get_Max");
	local missing_health = max_health - health;

	local health_percentage = 1;
	if max_health ~= 0 then
		health_percentage = health / max_health;
	end

    local monster = monster_table[enemy];

    if not hp_entry then 
        monster = {};
        monster_table[enemy] = monster;

        -- Grab enemy name.
        local message_manager = sdk.get_managed_singleton("snow.gui.MessageManager");
        if not message_manager then
            status = "No message manager";
            return;
        end

        local enemy_type = enemy:get_field("<EnemyType>k__BackingField");
        if not enemy_type then
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
end

function get_window_size()
	local size = scene_view:call("get_Size");
	if not size then
		log.error("[monster_has_hp_bar.lua] No scene view size");
		return
	end

	screen_width = size:get_field("w");
	if not screen_width then
		log.error("[monster_has_hp_bar.lua] No screen width");
		return
	end

	screen_height = size:get_field("h");
	if not screen_height then
		log.error("[monster_has_hp_bar.lua] No screen height");
		return
	end
end

function calculate_screen_coordinates(position)
	if position.anchor == "top_left" then
		return {x = position.x, y = position.y};
	end

	if position.anchor == "top_right" then
		local screen_x = screen_width - position.x;
		return {x = screen_x, y = position.y};
	end

	if position.anchor == "bottom_left" then
		local screen_y = screen_height - position.y;
		return {x = position.x, y = screen_y};
	end

	if position.anchor == "bottom_right" then
		local screen_x = screen_width - position.x;
		local screen_y = screen_height - position.y;
		return {x = screen_x, y = screen_y};
	end

	return {x = position.x, y = position.y};
end

function disappearing_monster_fix()
	if missing_monster_health < previous_missing_monster_health then
		memorized_missing_monster_health = memorized_missing_monster_health + previous_missing_monster_health - missing_monster_health;
	end
	previous_missing_monster_health = missing_monster_health;
end

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_type_def_update_method = enemy_character_base_type_def:get_method("update");

sdk.hook(enemy_character_base_type_def_update_method, function(args) 
    record_health(sdk.to_managed_object(args[2]));
end, function(retval) end);

re.on_draw_ui(function() 
    if string.len(status) > 0 then
        imgui.text("[monster_has_hp_bar.lua] Status: " .. status);
    end
end);

re.on_frame(function()
	get_window_size();

	if monster_UI.enabled then
		monster_health();
	end
   
	if time_UI.enabled then
		quest_time();
	end

	if damage_meter_UI.enabled then
		damage_meter();
		
	end
end)

function monster_health()
    local enemy_manager = sdk.get_managed_singleton("snow.enemy.EnemyManager");
    if not enemy_manager then
        status = "No enemy manager";
        return;
	end

    for i = 0, 4 do
        local enemy = enemy_manager:call("getBossEnemy", i);
        if not enemy then
            break;
        end
		
        local monster = monster_table[enemy];
        if not monster then 
            status = "No hp entry";
            break;
        end

		local screen_position = calculate_screen_coordinates(monster_UI.position);
		screen_position.x = screen_position.x + monster_UI.spacing * i;

		if monster_UI.visibility.health_bar then
			local health_bar_remaining_health_width = monster_UI.health_bar.width * monster.health_percentage;
			local health_bar_missing_health_width = monster_UI.health_bar.width - health_bar_remaining_health_width;

			--remaining health
			draw.filled_rect(screen_position.x + monster_UI.offsets.health_bar.x, screen_position.y + monster_UI.offsets.health_bar.y, health_bar_remaining_health_width, monster_UI.health_bar.height, monster_UI.colors.health_bar.remaining_health);
			--missing health
			draw.filled_rect(screen_position.x + monster_UI.offsets.health_bar.x + health_bar_remaining_health_width, screen_position.y + monster_UI.offsets.health_bar.y, health_bar_missing_health_width, monster_UI.health_bar.height, monster_UI.colors.health_bar.missing_health);
		end

		if monster_UI.visibility.monster_name then
			if monster_UI.shadows.monster_name then
				--monster name shadow
				draw.text(monster.name, screen_position.x + monster_UI.offsets.monster_name.x + monster_UI.shadow_offsets.monster_name.x, screen_position.y + monster_UI.offsets.monster_name.y + monster_UI.shadow_offsets.monster_name.y, monster_UI.colors.monster_name.shadow);
			end

			--monster name
			draw.text(monster.name, screen_position.x  + monster_UI.offsets.monster_name.x, screen_position.y + monster_UI.offsets.monster_name.y, monster_UI.colors.monster_name.text);
		end

		if monster_UI.visibility.current_health or monster_UI.visibility.max_health then
			local health_values = "";
			if monster_UI.visibility.current_health then
				health_values = string.format("%d", monster.health);
			end
	
			if monster_UI.visibility.max_health then
				if monster_UI.visibility.current_health then
					health_values = health_values .. "/";
				end

				health_values = health_values .. string.format("%d", monster.max_health);
			end

			if monster_UI.shadows.health_values then
				--health values shadow
				draw.text(health_values, screen_position.x + monster_UI.offsets.health_values.x + monster_UI.shadow_offsets.health_values.x, screen_position.y + monster_UI.offsets.health_values.y + monster_UI.shadow_offsets.health_values.y, monster_UI.colors.health_values.shadow);
			end
			--health values
			draw.text(health_values, screen_position.x + monster_UI.offsets.health_values.x, screen_position.y  + monster_UI.offsets.health_values.y, monster_UI.colors.health_values.text);
		end

		if monster_UI.visibility.health_percentage then
			local health_percentage_text = string.format("%3.1f%%", 100 * monster.health_percentage);

			if monster_UI.shadows.health_percentage then
				--health percentage shadow
				draw.text(health_percentage_text, screen_position.x + monster_UI.offsets.health_percentage.x + monster_UI.shadow_offsets.health_percentage.x, screen_position.y + monster_UI.offsets.health_percentage.y + monster_UI.shadow_offsets.health_percentage.y, monster_UI.colors.health_percentage.shadow);
			end
			--health percentage
			draw.text(health_percentage_text, screen_position.x + monster_UI.offsets.health_percentage.x, screen_position.y + monster_UI.offsets.health_percentage.y, monster_UI.colors.health_percentage.text);
		end
    end

	disappearing_monster_fix();
end

function quest_time()
    local quest_manager = sdk.get_managed_singleton("snow.QuestManager");
    if not quest_manager then
        status = "No quest manager";
        return;
    end

    local quest_time_elapsed_minutes = quest_manager:call("getQuestElapsedTimeMin");
    if not quest_time_elapsed_minutes then
        status = "No quest time elapsed minutes";
        return;
    end

    local quest_time_total_elapsed_seconds = quest_manager:call("getQuestElapsedTimeSec");
    if not quest_time_total_elapsed_seconds then
        status = "No quest time total elapsed seconds";
        return;
    end

    if quest_time_total_elapsed_seconds == 0 then
        return;
    end

    local quest_time_elapsed_seconds = quest_time_total_elapsed_seconds - quest_time_elapsed_minutes * 60;

    local elapsed_time_text = string.format("%02d:%06.3f", quest_time_elapsed_minutes, quest_time_elapsed_seconds);

	local screen_position = calculate_screen_coordinates(time_UI.position);

	if time_UI.shadow then
		--shadow
		draw.text(elapsed_time_text, screen_position.x + time_UI.shadow_offset.x, screen_position.y + time_UI.shadow_offset.y, time_UI.colors.shadow);
	end
    --text
	draw.text(elapsed_time_text, screen_position.x, screen_position.y, time_UI.colors.text);
end

function damage_meter()
	local quest_manager = sdk.get_managed_singleton("snow.QuestManager");
    if not quest_manager then
        status = "No quest manager";
        return;
    end

	local quest_status = quest_manager:call("getStatus");
	if not quest_status then
		status = "No quest status";
        return;
	end

	if quest_status == 0 then
		memorized_missing_monster_health = 0;
		previous_missing_monster_health = 0;
		return;
	end

	missing_monster_health = 0;

	local enemy_manager = sdk.get_managed_singleton("snow.enemy.EnemyManager");
	if not enemy_manager then
		status = "No enemy manager";
		return;
	end

	for i = 0, 4 do
		local enemy = enemy_manager:call("getBossEnemy", i);
		if not enemy then
			break;
		end

		local monster = monster_table[enemy];
		if not monster then 
			status = "No health entry";
			break;
		end

		missing_monster_health = missing_monster_health + monster.missing_health;

	end
	disappearing_monster_fix();

	if missing_monster_health == 0 then
        return;
    end

    local quest_manager = sdk.get_managed_singleton("snow.QuestManager");
    if not quest_manager then
        status = "No quest manager";
        return;
    end

    local kpi_data = quest_manager:call("get_KpiData");
    if not kpi_data then
        status = "No kpi data";
        return;
    end

    local player_total_attack_damage = kpi_data:call("get_PlayerTotalAttackDamage");
    if not player_total_attack_damage then
        status = "No player total attack damage";
        return;
    end
    
    local player_total_elemental_attack_damage = kpi_data:call("get_PlayerTotalElementalAttackDamage");
    if not player_total_elemental_attack_damage then
        status = "No player total elemental attack damage";
        return;
    end

    local player_total_status_ailments_damage = kpi_data:call("get_PlayerTotalStatusAilmentsDamage");
    if not player_total_status_ailments_damage then
        status = "No player total status ailments damage";
        return;
    end

    local player_total_damage = player_total_attack_damage + player_total_elemental_attack_damage + player_total_status_ailments_damage;
	local total_missing_monster_health = missing_monster_health + memorized_missing_monster_health;
	local player_damage_percentage = player_total_damage / total_missing_monster_health ;

    local screen_position = calculate_screen_coordinates(damage_meter_UI.position);

	if damage_meter_UI.visibility.damage_bar then
		local damage_bar_player_damage_width = damage_meter_UI.damage_bar.width * player_damage_percentage;
		local damage_bar_others_damage_width = damage_meter_UI.damage_bar.width - damage_bar_player_damage_width;

		--player damage
		draw.filled_rect(screen_position.x + damage_meter_UI.offsets.damage_bar.x, screen_position.y + damage_meter_UI.offsets.damage_bar.y, damage_bar_player_damage_width, damage_meter_UI.damage_bar.height, damage_meter_UI.colors.damage_bar.player_damage);
		--others damage
		draw.filled_rect(screen_position.x + damage_meter_UI.offsets.damage_bar.x + damage_bar_player_damage_width, screen_position.y + damage_meter_UI.offsets.damage_bar.y, damage_bar_others_damage_width, damage_meter_UI.damage_bar.height, damage_meter_UI.colors.damage_bar.others_damage);
	end

	if damage_meter_UI.visibility.player_damage or damage_meter_UI.visibility.total_damage then
		local damage_values = "";
		if damage_meter_UI.visibility.player_damage then
			damage_values = string.format("%d", player_total_damage);
		end

		if damage_meter_UI.visibility.total_damage then
			if damage_meter_UI.visibility.player_damage then
				damage_values = damage_values .. "/";
			end

			damage_values = damage_values .. string.format("%d", total_missing_monster_health);
		end

		if damage_meter_UI.shadows.damage_values then
			--health values shadow
			draw.text(damage_values, screen_position.x + damage_meter_UI.offsets.damage_values.x + damage_meter_UI.shadow_offsets.damage_values.x, screen_position.y + damage_meter_UI.offsets.damage_values.y + damage_meter_UI.shadow_offsets.damage_values.y, damage_meter_UI.colors.damage_values.shadow);
		end
		--health values
		draw.text(damage_values, screen_position.x  + damage_meter_UI.offsets.damage_values.x, screen_position.y  + damage_meter_UI.offsets.damage_values.y, damage_meter_UI.colors.damage_values.text);
	end

	

	if damage_meter_UI.visibility.damage_percentage then
		local damage_percentage_text = string.format("%3.1f%%", 100 * player_damage_percentage);

		if damage_meter_UI.shadows.damage_percentage then
			--health percentage shadow
			draw.text(damage_percentage_text, screen_position.x + damage_meter_UI.offsets.damage_percentage.x + damage_meter_UI.shadow_offsets.damage_percentage.x, screen_position.y + damage_meter_UI.offsets.damage_percentage.y + damage_meter_UI.shadow_offsets.damage_percentage.y, damage_meter_UI.colors.damage_percentage.shadow);
		end
		--health percentage
		draw.text(damage_percentage_text, screen_position.x + damage_meter_UI.offsets.damage_percentage.x, screen_position.y + damage_meter_UI.offsets.damage_percentage.y, damage_meter_UI.colors.damage_percentage.text);
	end
end