local language = {};
local table_helpers;

language.language_folder = "MHR Overlay\\languages\\";

language.default_language = {
	font_name = "NotoSansKR-Bold.otf",
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
	},

	UI = {
		HP = "HP:",
		stamina = "Stamina:",
		rage = "Rage:",
		gold = "Gold",
		silver = "Silver",
		mini = "Mini",
		total_damage = "Total Damage",
		player = "Player"
	},

	customization_menu = {
		mod_name = "MHR Overlay";
		status = "Status",

		modules = "Modules",
		global_settings = "Global Settings",
		small_monster_UI = "Small Monster UI",
		large_monster_UI = "Large Monster UI",
		time_UI = "Time UI",
		damage_meter_UI = "Damage Meter UI",

		large_monster_dynamic_UI = "Large Monster Dynamic UI",
		large_monster_static_UI = "Large Monster Static UI",
		large_monster_highlighted_UI = "Large Monster Highlighted UI",

		language = "Language",
		module_visibility_on_different_screens = "Module Visibility on Different Screens",
		during_quest = "During Quest",
		quest_summary_screen = "Quest Summary Screen",
		training_area = "Training Area",

		performance = "Performance",
		max_monster_updates_per_tick = "Max Monster Updates per Tick",
		prioritize_large_monsters = "Large Monsters on High Priority";

		UI_font_notice = "Any changes to the font require script reload!",

		menu_font = "Menu Font",
		UI_font = "UI Font",
		family = "Family",
		size = "Size",
		bold = "Bold",
		italic = "Italic",

		enabled = "Enabled",
		settings = "Settings",
		dynamic_positioning = "Dynamic Positioning",
		static_position = "Static Position",
		static_spacing = "Static Spacing",
		static_sorting = "Static Sorting",
		monster_name_label = "Monster Name Label",
		health = "Health",
		stamina = "Stamina",

		static_orientation = "Static Orientation",

		hide_dead_or_captured = "Hide dead or captured",

		opacity_falloff = "Opacity Falloff",
		max_distance = "Max Distance",
		world_offset = "World Offset",
		viewport_offset = "Viewport Offset",

		x = "X",
		y = "Y",
		z = "Z",

		anchor = "Anchor",
		top_left = "Top-Left",
		top_right = "Top-Right",
		bottom_left = "Bottom-Left",
		bottom_right = "Bottom-Right",

		type = "Type",
		normal = "Normal",
		health_percentage = "Health Percentage",
		distance = "Distance",
		reversed_order = "Reversed Order",

		visible = "Visible",
		offset = "Offset",
		color = "Color",
		colors = "Colors",
		shadow = "Shadow",

		text_label = "Text Label",
		value_label = "Value Label",
		percentage_label = "Percentage Label",
		bar =  "Bar",

		width = "Width",
		height = "Height",
		foreground = "Foreground",
		background = "Background",

		capture_line = "Capture Line",

		dynamically_positioned = "Dynamically Positioned",
		statically_positioned = "Statically Positioned",
		highlighted = "Highlighted (targeted)",

		include = "Include",
		monster_name = "Monster Name",
		crown = "Crown",
		crown_thresholds = "Crown Thresholds",

		rage = "Rage",
		body_parts = "Body Parts",
		hide_undamaged_parts = "Hide Undamaged Parts",
		part_name = "Part Name",
		break_count = "Break Count",

		orientation = "Orientation",
		horizontal = "Horizontal",
		vertical = "Vertical",

		position = "Position",
		spacing = "Spacing",
		sorting = "Sorting",

		timer_label = "Timer Label",
		part_name_label = "Part Name Label",

		time_label = "Time Label",

		tracked_monster_types = "Tracked Monster Types",
		tracked_damage_types = "Tracked Damage Types",

		player_name_label = "Player Name Label",
		hunter_rank_label = "Hunter Rank Label",
		damage_value_label = "Damage Value Label",
		damage_percentage_label = "Damage Percetange Label",
		total_damage_label = "Total Damage Label",
		total_damage_value_label = "Total Damage Value Label",
		damage_bar = "Damage Bar",
		highlighted_damage_bar = "Highlighted Damage Bar",

		monster_can_be_captured = "Monster can be captured",

		hide_module_if_total_damage_is_zero = "Hide Module if Total Damage is 0",
		hide_player_if_player_damage_is_zero = "Hide Player if Player Damage is 0",
		hide_total_if_total_damage_is_zero = "Hide Total if Total Damage is 0",
		total_damage_offset_is_relative = "Total Damage Offset is Relative",

		enable_for = "Enable for",
		highlighted_bar = "Highlighted Bar",
		me = "Me",
		top_damage = "Top Damage",
		none = "None",

		damage_bars_are_relative_to = "Damage Bars are relative to",
		total_damage = "Total Damage",

		my_damage_bar_location = "My Damage Bar Location",
		first = "First",
		last = "Last",
		
		small_monsters = "Small Monsters",
		large_monsters = "Large Monsters",

		player_damage = "Player Damage",
		bomb_damage = "Bomb Damage",
		kunai_damage = "Kunai Damage",
		installation_damage = "Installation Damage",
		otomo_damage = "Otomo Damage",
		monster_damage = "Monster Damage",

		damage = "Damage",
		
		other_players = "Other Players",
		hunter_rank = "Hunter Rank",
		word_player = "Word \"Player\"";
		player_id = "Player ID",
		player_name = "Player Name",
	}
};

language.current_language = {};

language.language_names = {"default"};
language.languages = {language.default_language};

function language.load()
	local language_files = fs.glob([[MHR Overlay\\languages\\.*json]]);

	if language_files == nil then
		return;
	end

	for i, language_file_name in ipairs(language_files) do
		local language_name = language_file_name:gsub(language.language_folder, ""):gsub(".json", "");

		-- language_file will be something like `my-cool-mod\config-file-1.json`;
		local loaded_language = json.load_file(language_file_name);
		if loaded_language ~= nil then
			log.info("[MHR Overlay] " .. language_name .. ".json loaded successfully");
			table.insert(language.language_names, language_name);

			local merged_language = table_helpers.merge(language.default_language, loaded_language);
			table.insert(language.languages, merged_language);

			language.save(language_file_name, merged_language);

		else
			log.error("[MHR Overlay] Failed to load " .. language_name .. ".json");
		end
	end
end

function language.save(file_name, language_table)
	local success = json.dump_file(file_name, language_table);
	if success then
		log.info('[MHR Overlay] en-us.json saved successfully');
	else
		log.error('[MHR Overlay] Failed to save en-us.json');
	end
end

function language.save_default();
	language.save(language.language_folder .. "en-us.json", language.default_language)
end


function language.update(index)
	language.current_language = table_helpers.deep_copy(language.languages[index]);
end

function language.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	language.save_default();
	language.load();
	language.current_language = table_helpers.deep_copy(language.default_language);
end

return language;