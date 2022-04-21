local env_creature_hook = {};
local env_creature;
local config;

local environment_creature_base_type_def = sdk.find_type_definition("snow.envCreature.EnvironmentCreatureBase");
local environment_creature_base_update_method = environment_creature_base_type_def:get_method("update");
sdk.hook(environment_creature_base_update_method, function(args)
	pcall(env_creature_hook.update_env_creature, sdk.to_managed_object(args[2]));
end, function(retval)
	return retval;
end);

function env_creature_hook.update_env_creature(REcreature)
	if not config.current_config.endemic_life_UI.enabled then
		return;
	end

	env_creature.update(REcreature);
end

function env_creature_hook.init_module()
	config = require("MHR_Overlay.Misc.config");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
end

return env_creature_hook;