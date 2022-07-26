local env_creature_hook = {};
local env_creature;
local config;
local time;

local environment_creature_base_type_def = sdk.find_type_definition("snow.envCreature.EnvironmentCreatureBase");
local update_method = environment_creature_base_type_def:get_method("update");

function env_creature_hook.update(REcreature)
	local creature = env_creature.get_creature(REcreature);
	env_creature.update(REcreature, creature);
	env_creature.update_position(REcreature, creature);
end

function env_creature_hook.init_module()
	config = require("MHR_Overlay.Misc.config");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	time = require("MHR_Overlay.Game_Handler.time");

	sdk.hook(update_method, function(args)
		pcall(env_creature_hook.update, sdk.to_managed_object(args[2]));
	end, function(retval)
		return retval;
	end);
end

return env_creature_hook;
