local language = {};
local table_helpers;

language.current_language = {};

language.language_names = {};
language.languages = {};

language.language_folder = "MHR Overlay\\languages\\";

language.default_language = {
	parts = {
		head = "Head",
		neck = "Neck",
		body = "Body",
		torso = "Torso",
		abdomen = "Abdomen",
		back = "Back",
		tail = "Tail",

		upper_body = "Upper Body",
		lower_body = "Lower Body",

		upper_back = "Upper Back",
		lower_back = "Lower Back",

		left_wing = "Wing L",
		right_wing = "Wing R",
		wings = "Wings",

		left_leg = "Leg L",
		right_leg = "Leg R",
		legs = "Legs",
		left_legs = "Legs L",
		right_legs = "Legs R",

		left_arm = "Arm L",
		right_arm = "Arm R",
		arms = "Arms",

		left_arm_ice = "Arm L (Ice)",
		right_arm_ice = "Arm R (Ice)",

		left_cutwing = "Cutwing L",
		right_cutwing = "Cutwing R",

		head_mud = "Head (Mud)",
		tail_mud = "Tail (Mud)",
		
		tail_windsac = "Tail (Windsac)",
		chest_windsac = "Chest (Windsac)",
		back_windsac = "Back (Windsac)",

		large_mudbulb = "Large Mudbulb",
		mane = "Mane",
		rear = "Rear",
		claw = "Claw",
		dorsal_fin = "Dorsal Fin",
		carapace = "Carapace",
		spinning = "Spinning",
		rock = "Rock"
	}
};

function language.load()
	local language_files = fs.glob([[MHR Overlay\\languages\\.*json]]);

	if language_files == nil then
		return;
	end

	for i, language_file in ipairs(language_files) do
		local language_name = language_file:gsub(language.language_folder, ""):gsub(".json", "");

		-- v will be something like `my-cool-mod\config-file-1.json`;
		local loaded_language = json.load_file(language.language_folder .. "en-us.json");
		if loaded_language ~= nil then
			log.info("[MHR Overlay] " .. language_name .. ".json loaded successfully");
			table.insert(language.language_names, language_name);
			table.insert(language.languages, loaded_language);
		else
			log.error("[MHR Overlay] Failed to load " .. language_name .. ".json");
		end
	end

   
end

function language.save_default()
	-- save current config to disk, replacing any existing file
	local success = json.dump_file(language.language_folder .. "en-us.json", language.default_language);
	if success then
		log.info('[MHR Overlay] en-us.json saved successfully');
	else
		log.error('[MHR Overlay] Failed to save en-us.json');
	end
end


function language.update(index)
	language.current_language = table_helpers.deep_copy(language.languages[index]);
end

function language.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	language.save_default();
	language.load();
end

return language;