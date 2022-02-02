local large_monster = {};
local singletons;
local customization_menu;

large_monster.list = {};

function large_monster.new(enemy)
	local new_monster = {};
	new_monster.is_large = true;

	new_monster.health = 0;
	new_monster.max_health = 999999;
	new_monster.health_percentage = 0;
	new_monster.missing_health = 0;
	new_monster.capture_health = 0;

	new_monster.stamina = 0;
	new_monster.max_stamina = 1000;
	new_monster.stamina_percentage = 0;
	new_monster.missing_stamina = 0;

	new_monster.is_in_rage = false;
	new_monster.rage_point = 0;
	new_monster.rage_limit = 2001;
	new_monster.rage_timer = 0;
	new_monster.rage_duration = 600;
	new_monster.rage_count = 0;
	new_monster.rage_percentage = 0;

	new_monster.rage_total_seconds_left = 0;
	new_monster.rage_minutes_left = 0;
	new_monster.rage_seconds_left = 0;
	new_monster.rage_timer_percentage = 0;

	new_monster.position = Vector3f.new(0, 0, 0);

	new_monster.name = "Large Monster";
	new_monster.size = 1;
	new_monster.small_border = 0;
	new_monster.big_border = 5;
	new_monster.king_border = 10;
	new_monster.crown = "";
	
	large_monster.init(new_monster, enemy);

	if large_monster.list[enemy] == nil then
		large_monster.list[enemy] = new_monster;
	end

	return new_monster;
end

function large_monster.get_monster(enemy)
	if large_monster.list[enemy] == nil then
		large_monster.list[enemy] = large_monster.new(enemy);
	end

	return large_monster.list[enemy];
end

function large_monster.init(monster, enemy)
	local enemy_type = enemy:get_field("<EnemyType>k__BackingField");
	if enemy_type == nil then
		customization_menu.status = "No enemy type";
		return;
	end

	local enemy_name = singletons.message_manager:call("getEnemyNameMessage", enemy_type);
	if enemy_name ~= nil then
		monster.name = enemy_name;
	end

	local size_info = singletons.enemy_manager:call("findEnemySizeInfo", enemy_type);
	if size_info ~= nil then
		local small_border = size_info:call("get_SmallBorder");
		local big_border = size_info:call("get_BigBorder");
		local king_border = size_info:call("get_KingBorder");

		local size = enemy:call("get_MonsterListRegisterScale");

		if small_border ~= nil then
			monster.small_border = small_border;
		end

		if big_border ~= nil then
			monster.big_border = big_border;
		end

		if king_border ~= nil then
			monster.king_border = king_border;
		end


		if size ~= nil then
			monster.size = size;
		end

		if monster.size <= monster.small_border then
			monster.crown = "Mini";
		elseif monster.size >= monster.king_border then
			monster.crown = "Gold";
		elseif monster.size >= monster.big_border then
			monster.crown = "Silver";
		end
	end
end

function large_monster.update(enemy)
	if enemy == nil then
		return;
	end
	
	local physical_param = enemy:get_field("<PhysicalParam>k__BackingField");
	if physical_param == nil then
		customization_menu.status = "No physical param";
		return;
	end

	local status_param = enemy:get_field("<StatusParam>k__BackingField");
	if status_param == nil then
		customization_menu.status = "No status param";
		return;
	end

	local anger_param = enemy:get_field("<AngerParam>k__BackingField");
	if anger_param == nil then
		customization_menu.status = "No anger param";
		return;
	end

	local stamina_param = enemy:get_field("<StaminaParam>k__BackingField");
	if stamina_param == nil then
		customization_menu.status = "No stamina param";
		return;
	end

	local vital_param = physical_param:call("getVital", 0, 0);
	if vital_param == nil then
		customization_menu.status = "No vital param";
		return;
	end

	local health = vital_param:call("get_Current");
	local max_health = vital_param:call("get_Max");
	local capture_health = physical_param:call("get_CaptureHpVital");

	local stamina = stamina_param:call("getStamina");
	local max_stamina = stamina_param:call("getMaxStamina");

	local is_in_rage = anger_param:call("isAnger");
	local rage_point = anger_param:call("get_AngerPoint");
	local rage_limit = anger_param:call("get_LimitAnger");
	local rage_timer = anger_param:call("get_Timer");
	local rage_duration = anger_param:call("get_TimerAnger");
	local rage_count = anger_param:call("get_CountAnger");

	local enemy_game_object = enemy:call("get_GameObject");
	if enemy_game_object == nil then
		customization_menu.status = "No enemy game object";
		return;
	end

	local enemy_transform = enemy_game_object:call("get_Transform");
	if enemy_transform == nil then
		customization_menu.status = "No enemy transform";
		return;
	end

	local position = enemy_transform:call("get_Position");
	if not position then
		customization_menu.status = "No enemy position";
		return;
	end
	
	local monster = large_monster.get_monster(enemy);
	
	if health ~= nil then
		monster.health = health;
	end

	if max_health ~= nil then
		monster.max_health = max_health;
	end

	if capture_health ~= nil then
		monster.capture_health = capture_health;
	end

	if max_health ~= nil and health ~= nil then
		monster.missing_health = max_health - health;
		if max_health ~= 0 then
			monster.health_percentage = health / max_health;
		end
	end

	if position ~= nil then
		monster.position = position;
	end

	if stamina ~= nil then
		monster.stamina = stamina;
	end

	if max_stamina ~= nil then
		monster.max_stamina = max_stamina;
	end

	if max_stamina ~= nil and stamina ~= nil then
		monster.missing_stamina = max_stamina - stamina;
		if max_stamina  ~= 0 then
			monster.stamina_percentage = stamina / max_stamina;
		end
	end

	if is_in_rage ~= nil then
		monster.is_in_rage = is_in_rage;
	end

	if rage_point ~= nil then
		monster.rage_point = rage_point;
	end

	if rage_limit ~= nil then
		monster.rage_limit = rage_limit;
	end

	if rage_point ~= nil and rage_limit ~= nil then
		if rage_limit ~= 0 then
			monster.rage_percentage = rage_point / rage_limit;
		end
	end

	if rage_timer ~= nil then
		monster.rage_timer = rage_timer;
	end

	if rage_duration ~= nil then
		monster.rage_duration = rage_duration;
	end

	if rage_timer ~= nil and rage_duration ~= nil and monster.is_in_rage then
		monster.rage_total_seconds_left = rage_duration - rage_timer;
		if monster.rage_total_seconds_left < 0 then
			monster.rage_total_seconds_left = 0;
		end

		monster.rage_minutes_left = math.floor(monster.rage_total_seconds_left / 60);
		monster.rage_seconds_left = monster.rage_total_seconds_left - 60 * monster.rage_minutes_left;
		if rage_duration ~= 0 then
			monster.rage_timer_percentage = monster.rage_total_seconds_left / rage_duration;
		end
	end

	if rage_count ~= nil then
		monster.rage_count = rage_count;
	end
end

function large_monster.init_list()
	large_monster.list = {};
end

function large_monster.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
end

return large_monster;