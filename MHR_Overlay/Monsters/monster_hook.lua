local monster = {};
local small_monster;
local large_monster;

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_character_base_type_def_update_method = enemy_character_base_type_def:get_method("update");

sdk.hook(enemy_character_base_type_def_update_method, function(args)
	monster.update_monster(sdk.to_managed_object(args[2]));
end, function(retval)
	return retval;
end);

function monster.update_monster(enemy)
	
	if enemy == nil then
		return;
	end

	local is_large = enemy:call("get_isBossEnemy");
	if is_large == nil then
		return;
	end
	
	if is_large then
		large_monster.update(enemy);
	else
		small_monster.update(enemy);
	end
end

function monster.init_module()
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
end

return monster;