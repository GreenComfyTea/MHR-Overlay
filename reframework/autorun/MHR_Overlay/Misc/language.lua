local this = {};

local utils;

local sdk = sdk;
local tostring = tostring;
local pairs = pairs;
local ipairs = ipairs;
local tonumber = tonumber;
local require = require;
local pcall = pcall;
local table = table;
local string = string;
local Vector3f = Vector3f;
local d2d = d2d;
local math = math;
local json = json;
local log = log;
local fs = fs;
local next = next;
local type = type;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local assert = assert;
local select = select;
local coroutine = coroutine;
local utf8 = utf8;
local re = re;
local imgui = imgui;
local draw = draw;
local Vector2f = Vector2f;
local reframework = reframework;
local os = os;
local ValueType = ValueType;
local package = package;

this.language_folder = "MHR Overlay\\languages\\";

--[[
	EXAMPLE: 
	unicode_glyph_ranges = {
		0x0020, 0x00FF, -- Basic Latin + Latin Supplement
		0x2000, 0x206F, -- General Punctuation
		0x3000, 0x30FF, -- CJK Symbols and Punctuations, Hiragana, Katakana
		0x31F0, 0x31FF, -- Katakana Phonetic Extensions
		0x4e00, 0x9FAF, -- CJK Ideograms
		0xFF00, 0xFFEF, -- Half-width characters
		0
	},
]]

--[[
	EXAMPLE: 
	unicode_glyph_ranges = {
		0x0020, 0x00FF, -- Basic Latin + Latin Supplement
		0x0400, 0x052F, -- Cyrillic
		0x2000, 0x206F, -- General Punctuation
		0xFF00, 0xFFEF, -- Half-width characters
		0
	},
]]

--[[
	EXAMPLE: 
	unicode_glyph_ranges = {
		0x0020, 0x00FF, -- Basic Latin + Latin Supplement
		0x1100, 0x11FF, -- Hangul Jamo
		0x2000, 0x206F, -- General Punctuation
		0x3130, 0x318F, -- Hangul Compatibility Jamo
		0xAC00, 0xD7AF, -- Hangul Syllables
		0xFF00, 0xFFEF, -- Half-width characters
		0
	},
]]

this.current_language = {};
this.default_language = {
	font_name = "",
	unicode_glyph_ranges = {0},
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
		body_mud = "Body (Mud)",
		arms_mud = "Arms (Mud)",
		torso_mud = "Torso (Mud)",
		left_leg_mud = "Leg L (Mud)",
		right_leg_mud = "Leg R (Mud)",
		tail_mud = "Tail (Mud)",

		tail_windsac = "Tail (Windsac)",
		chest_windsac = "Chest (Windsac)",
		back_windsac = "Back (Windsac)",

		large_mudbulb = "Large Mudbulb",
		mudbulb = "Mudbulb",
		mane = "Mane",
		rear = "Rear",
		claw = "Claw",
		dorsal_fin = "Dorsal Fin",
		carapace = "Carapace",
		spinning = "Spinning",
		rock = "Rock",

		tail_tip = "Tail Tip",

		left_claw = "Claw L",
		right_claw = "Claw R",

		unknown = "?",

		crest = "Crest",
		wingclaw = "Wingclaw",
		left_wingclaw = "Wingclaw L",
		right_wingclaw = "Wingclaw R",
		wingclaws = "Wingclaws",
		antenna = "Antenna",

		hind_leg = "Hind Leg",
		hind_legs = "Hind Legs",
		left_hind_leg = "Hind Leg L",
		right_hind_leg = "Hind Leg R",

		foreleg = "Foreleg",
		forelegs = "Forelegs",
		left_foreleg = "Foreleg L",
		right_foreleg = "Foreleg R",
		chest = "Chest",
		shell = "Shell",

		thundersacs = "Thundersacs",

		amatsu_unknown = "?"
	},

	ailments = {
		paralysis = "Paralysis",
		sleep = "Sleep",
		stun = "Stun",
		flash = "Flash",
		poison = "Poison",
		blast = "Blast",
		exhaust = "Exhaust",
		ride = "Wyvern Riding",
		waterblight = "Waterblight",
		fireblight = "Fireblight",
		iceblight = "Iceblight",
		thunderblight = "Thunderblight",

		fall_trap = "Fall Trap",
		shock_trap = "Shock Trap",
		tranq_bomb = "Tranq Bomb",
		dung_bomb = "Dung Bomb",
		steel_fang = "Steel Fang",
		quick_sand = "Quick Sand",
		fall_otomo_trap = "Fall Buddy Trap",
		shock_otomo_trap = "Shock Buddy Trap"
	},

	UI = {
		HP = "HP:",
		stamina = "Stamina:",
		rage = "Rage:",
		gold = "Gold",
		silver = "Silver",
		mini = "Mini",
		total_damage = "Total Damage",
		player = "Player",
		buildup = "Buildup:",
		total_buildup = "Total Buildup",
		part_break = "Break",
		part_sever = "Sever",
		part_anomaly_core = "Anomaly Core",

		otomo = "Buddy",
		servant = "Follower",
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
		endemic_life_UI = "Endemic Life UI",

		large_monster_dynamic_UI = "Large Monster Dynamic UI",
		large_monster_static_UI = "Large Monster Static UI",
		large_monster_highlighted_UI = "Large Monster Highlighted UI",

		language = "Language",
		module_visibility_based_on_game_state = "Module Visibility based on Game State",
		in_lobby = "In Lobby",
		in_training_area = "In Training Area",
		cutscene = "Cutscene",
		loading_quest = "Loading Quest",
		quest_start_animation = "Quest Start Animation",
		playing_quest = "Playing Quest",
		killcam = "Killcam",
		quest_end_timer = "Quest End Timer",
		quest_end_animation = "Quest End Animation",
		quest_end_screen = "Quest End Screen",
		reward_screen = "Reward Screen",
		summary_screen = "Summary Screen",

		performance = "Performance",

		UI_font_notice = "Any changes to the font require script reload!",

		menu_font = "Menu Font",
		UI_font = "UI Font",
		family = "Family",
		size = "Size",
		bold = "Bold",
		italic = "Italic",

		renderer = "Renderer",
		use_d2d_if_available = "Use Direct2D if available",

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

		hide_dead_or_captured = "Hide Dead or Captured",
		render_highlighted_monster = "Render Highlighted Monster",
		render_not_highlighted_monsters = "Render Not Highlighted Monsters",

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
		bar = "Bar",

		width = "Width",
		height = "Height",
		foreground = "Foreground",
		background = "Background",

		capture_line = "Capture Line",

		dynamically_positioned = "Dynamically Positioned",
		statically_positioned = "Statically Positioned",
		highlighted_targeted = "Highlighted (targeted)",

		include = "Include",
		monster_name = "Monster Name",
		crown = "Crown",
		crown_thresholds = "Crown Thresholds",

		rage = "Rage",
		body_parts = "Body Parts",
		hide_undamaged_parts = "Hide Undamaged Parts",
		render_inactive_anomaly_cores = "Render Inactive Anomaly Cores",
		part_name = "Part Name",
		flinch_count = "Flinch Count",
		break_count = "Break Count",
		break_max_count = "Break Max Count",

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
		damage_percentage_label = "Damage Percentage Label",
		dps_label = "DPS Label",
		total_dps_label = "Total DPS Label",
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
		total_damage_location = "Total Damage Bar Location",
		first = "First",
		last = "Last",

		small_monsters = "Small Monsters",
		large_monsters = "Large Monsters",

		player_damage = "Player Damage",
		bomb_damage = "Bomb Damage",
		kunai_damage = "Kunai Damage",
		installation_damage = "Installation Damage",
		otomo_damage = "Buddy Damage",
		monster_damage = "Monster Damage",
		poison_damage = "Poison Damage",
		blast_damage = "Blast Damage",

		damage = "Damage",

		other_players = "Other Players",
		hunter_rank = "Hunter Rank",
		id = "ID",
		name = "Name",

		show_my_otomos_separately = "Show My Buddies separately",
		show_other_player_otomos_separately = "Show Other Player Buddies separately",
		show_servant_otomos_separately = "Show Follower Buddies separately",

		dps_mode = "DPS Mode",
		dps = "DPS",
		top_dps = "Top DPS",
		total_dps = "Total DPS",
		first_hit = "First Hit",
		quest_time = "Quest Time",
		join_time = "Join Time",
		fight_time = "Fight Time",

		modifiers = "Modifiers",
		global_scale_modifier = "Global Scale Modifier",
		global_position_modifier = "Global Position Modifier",

		hotkeys = "Hotkeys",
		all_UI = "All UI",
		assign_new_key = "Assign new key",
		press_any_key = "Press any key...",

		buildup = "Buildup",
		buildup_percentage = "Buildup Percentage",

		ailments = "Ailments",
		hide_ailments_with_zero_buildup = "Hide Ailments when Buildup is 0",
		hide_inactive_ailments_with_no_buildup_support = "Hide Inactive Ailments with no Buildup Support",
		hide_all_inactive_ailments = "Hide All Inactive Ailments",
		hide_all_active_ailments = "Hide All Active Ailments",
		hide_disabled_ailments = "Hide Disabled Ailments by Game",
		offset_is_relative_to_parts = "Offset is Relative to Parts",
		time_limit = "Time Limit (seconds)",
		ailment_name_label = "Ailment Name Label",
		ailment_name = "Ailment Name",
		activation_count = "Activation Count",

		creature_name_label = "Creature Name Label",
		hide_inactive_creatures = "Hide Inactive Creatures",

		relative_offset = "Relative Offset",

		ailment_buildups = "Ailment Buildups",
		player_spacing = "Player Spacing",
		ailment_spacing = "Ailment Spacing",
		buildup_value_label = "Buildup Value Label",
		buildup_percentage_label = "Buildup Percentage Label",
		total_buildup_label = "Total Buildup Label",
		total_buildup_value_label = "Total Buildup Value Label",
		buildup_bar = "Buildup Bar",
		highlighted_buildup_bar = "Highlighted Buildup Bar",

		filter = "Filter",
		top_buildup = "Top Buildup",
		total_buildup = "Total Buildup",
		buildup_bars_are_relative_to = "Buildup Bars are relative to",

		part_health = "Part Health",
		break_health = "Break Health",
		break_health_percentage = "Break Health Percentage",
		loss_health = "Sever Health",
		loss_health_percentage = "Sever Health Percentage",
		anomaly_health = "Anomaly Core Health",
		anomaly_health_percentage = "Anomaly Core Health Percentage",

		monster_id = "Monster ID",

		apply = "Apply",

		menu_font_change_disclaimer = "Changing Language and Menu Font Size several times will cause a crash!",

		master_rank = "Master Rank",

		other_damage = "Other Damage",
		wyvern_riding_damage = "Wyvern Riding Damage",
		endemic_life_damage = "Endemic Life Damage",

		hide_myself = "Hide Myself",
		hide_other_players = "Hide Other Players",
		hide_servants = "Hide Followers",
		hide_total_damage = "Hide Total Damage",

		player_name_size_limit = "Player Name Size Limit",

		cart_count = "Cart Count",
		cart_count_label = "Cart Count Label",
		total_cart_count_label = "Total Cart Count Label",

		prioritize_large_monsters = "Large Monsters on High Priority",
		max_monster_updates_per_tick = "Max Monster Updates per Tick",

		freeze_dps_on_quest_end = "Freeze DPS on Quest End",

		health_break_sever_anomaly_filter = "Health + Break + Sever + Anomaly Core",
		health_break_sever_filter = "Health + Break + Sever",
		health_break_anomaly_filter = "Health + Break + Anomaly Core",
		health_sever_anomaly_filter = "Health + Sever + Anomaly Core",
		break_sever_anomaly_filter = "Break + Sever + Anomaly Core",

		health_break_filter = "Health + Break",
		health_sever_filter = "Health + Sever",
		health_anomaly_filter = "Health + Anomaly Core",

		break_sever_filter = "Break + Sever",
		break_anomaly_filter = "Break + Anomaly Core",
		sever_anomaly_filter = "Sever + Anomaly Core",

		health_filter = "Health",
		break_filter = "Break",
		sever_filter = "Sever",
		anomaly_filter = "Anomaly Core",

		outline = "Outline",
		thickness = "Thickness",
		style = "Style",
		inside = "Inside",
		outside = "Outside",
		center = "Center",

		auto_highlight = "Auto-highlight",
		mode = "Mode",
		closest = "Closest",
		farthest = "Farthest",
		lowest_health = "Lowest Health",
		highest_health = "Highest Health",
		lowest_health_percentage = "Lowest Health Percentage",
		highest_health_percentage = "Highest Health Percentage",

		reframework_outdated = "Installed REFramework version is outdated. Please, update. Otherwise, MHR Overlay won't work correctly.",

		servants = "Followers",
		my_otomos = "My Buddies",
		other_player_otomos = "Other Player Buddies",
		servant_otomos = "Servant Buddies",
		level = "Level",

		name_label = "Name Label",
		myself = "Myself",
		total = "Total",

		level_label = "Level Label",

		config = "Config",
		rename = "Rename",
		duplicate = "Duplicate",
		delete = "Delete",
		new = "New",
		reset = "Reset",

		highlighted = "Highlighted",

		buff_UI = "Buff UI",
		timer = "Timer",
		duration = "Duration",
		hide_bar_for_infinite_buffs = "Hide Bar for infinite Buffs",
		hide_timer_for_infinite_buffs = "Hide Timer for infinite Buffs",

		current_value = "Current Value",
		max_value = "Max Value",

		filter_mode = "Filter Mode",
		current_state = "Current State",
		default_state = "Default State",

		fill_direction = "Fill Direction",
		left_to_right = "Left to Right",
		right_to_left = "Right to Left",
		top_to_bottom = "Top to Bottom",
		bottom_to_top = "Bottom to Top",

		right_alignment_shift = "Right Alignment Shift"
	}
};

this.language_names = { "default"};
this.languages = { this.default_language };

function this.load()
	local language_files = fs.glob([[MHR Overlay\\languages\\.*json]]);

	if language_files == nil then
		return;
	end

	for i, language_file_name in ipairs(language_files) do
		local language_name = language_file_name:gsub(this.language_folder, ""):gsub(".json","");

		local loaded_language = json.load_file(language_file_name);
		if loaded_language ~= nil then

			log.info("[MHR Overlay] " .. language_file_name .. ".json loaded successfully");
			table.insert(this.language_names, language_name);

			local merged_language = utils.table.merge(this.default_language, loaded_language);
			table.insert(this.languages, merged_language);

			this.save(language_file_name, merged_language);


		else
			log.error("[MHR Overlay] Failed to load " .. language_file_name .. ".json");
		end
	end
end

function this.save(file_name, language_table)
	local success = json.dump_file(file_name, language_table);
	if success then
		log.info("[MHR Overlay] " .. file_name .. " saved successfully");
	else
		log.error("[MHR Overlay] Failed to save " .. file_name);
	end
end

function this.save_default()
	this.save(this.language_folder .. "en-us.json", this.default_language);
end

function this.update(index)
	this.current_language = this.languages[index];
end

function this.init_module()
	utils = require("MHR_Overlay.Misc.utils");
	
	this.save_default();
	this.load();
	this.current_language = this.default_language;
end

return this;
