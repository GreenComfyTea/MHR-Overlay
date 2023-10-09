local this = {};

local utils;
local error_handler;

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

-- this.traditional_chinese_ranges = {
-- 	0x0020, 0x00FF, -- Basic Latin + Latin Supplement
-- 	0x2000, 0x206F, -- General Punctuation
-- 	0x2E80, 0x2EFF, -- CJK Radicals Supplement
-- 	0x3000, 0x303F, -- CJK Symbols and Punctuations
-- 	0x31F0, 0x31FF, -- Katakana Phonetic Extensions
-- 	0x3200, 0x4DBF, -- Enclosed CJK Letters and Months, CJK Compatibility, CJK Unified Ideographs Extension A 	
-- 	0x4E00, 0x9FAF, -- CJK Unified Ideograms
-- 	0xF900, 0xFAFF, -- CJK Compatibility Ideographs
-- 	0xFE30, 0xFE4F, -- CJK Compatibility Forms
-- 	0xFF00, 0xFFEF, -- Half-width characters
-- };

-- this.japanese_glyph_ranges = {
-- 	0x0020, 0x00FF, -- Basic Latin + Latin Supplement
-- 	0x2000, 0x206F, -- General Punctuation
-- 	0x2E80, 0x2EFF, -- CJK Radicals Supplement
-- 	0x3000, 0x30FF, -- CJK Symbols and Punctuations, Hiragana, Katakana
-- 	0x31F0, 0x31FF, -- Katakana Phonetic Extensions
-- 	0x3200, 0x4DBF, -- Enclosed CJK Letters and Months, CJK Compatibility, CJK Unified Ideographs Extension A 	
-- 	0x4E00, 0x9FAF, -- CJK Unified Ideograms
-- 	0xF900, 0xFAFF, -- CJK Compatibility Ideographs
-- 	0xFE30, 0xFE4F, -- CJK Compatibility Forms
-- 	0xFF00, 0xFFEF, -- Half-width characters
-- };

-- this.korean_glyph_ranges = {
-- 	0x0020, 0x00FF, -- Basic Latin + Latin Supplement
-- 	0x1100, 0x11FF, -- Hangul Jamo
-- 	0x2000, 0x206F, -- General Punctuation
-- 	0x3130, 0x318F, -- Hangul Compatibility Jamo
-- 	0xAC00, 0xD7AF, -- Hangul Syllables
-- 	0xFF00, 0xFFEF, -- Half-width characters
-- 	0
-- }

this.current_language = {};
this.default_language = {
	font_name = "NotoSans-Bold.otf",
	unicode_glyph_ranges = {
		0x0020, 0x00FF, -- Basic Latin + Latin Supplement
		0x0100, 0x017F, -- Latin Extended-A
		0x0400, 0x052F, -- Cyrillic
		0x1E00, 0x1EFF, -- Latin Extended Additional
		0x2000, 0x206F, -- General Punctuation
		0xFF00, 0xFFEF, -- Halfwidth and Fullwidth Forms
		0
	},

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
		blast = "Blast",
		exhaust = "Exhaust",
		ride = "Wyvern Riding",

		poison = "Poison",
		deadly_poison = "Deadly Poison",

		fireblight = "Fireblight",
		waterblight = "Waterblight",
		thunderblight = "Thunderblight",
		iceblight = "Iceblight",

		fall_trap = "Fall Trap",
		shock_trap = "Shock Trap",
		tranq_bomb = "Tranq Bomb",
		dung_bomb = "Dung Bomb",
		steel_fang = "Steel Fang",
		quick_sand = "Quick Sand",
		fall_otomo_trap = "Fall Buddy Trap",
		shock_otomo_trap = "Shock Buddy Trap",

		dragonblight = "Dragonblight",
		blastblight = "Blastblight",
		hellfireblight = "Hellfireblight",
		bloodblight = "Bloodblight",
		frostblight = "Frostblight",

		minor_bubbleblight = "Minor Bubbleblight",
		major_bubbleblight = "Major Bubbleblight",
		
		defense_down = "Defense Down",
		resistance_down = "Resistance Down",
		
		falling_asleep = "Falling Asleep",
		tremor = "Tremor",
		roar = "Roar",
		webbed = "Webbed",
		stench = "Stench",
		leeched = "Leeched",
		bleeding = "Bleeding",
		engulfed = "Engulfed",
		muck = "Muck",
		frenzy = "Frenzy",
		frenzy_infection = "Frenzy Infection",
		frenzy_overcome = "Frenzy Overcome"
	},

	item_buffs = {
		demondrug = "Demondrug",
		mega_demondrug = "Mega Demondrug",
		armorskin = "Armorskin",
		mega_armorskin = "Mega Armorskin",
		might_seed = "Might Seed",
		adamant_seed = "Adamant Seed",
		demon_powder = "Demon Powder",
		hardshell_powder = "Hardshell Powder",
		immunizer = "Immunizer",
		dash_juice = "Dash Juice",
		gourmet_fish = "Gourmet Fish",
		demon_ammo = "Demon Ammo",
		armor_ammo = "Armor Ammo",
	},

	endemic_life = {
		cutterfly = "Cutterfly",
		clothfly = "Clothfly",
		butterflame = "Butterflame",
		peepersects = "Peepersects",
		stinkmink = "Stinkmink",
		ruby_wirebug = "Ruby Wirebug",
		gold_wirebug = "Gold Wirebug",
		red_lampsquid = "Red Lampsquid",
		yellow_lampsquid = "Yellow Lampsquid"
	},

	melody_effects = {
		self_improvement = "Self-Improvement",
		attack_up =	"Attack Up",
		defense_up ="Defense Up",
		affinity_up = "Affinity Up",
		elemental_attack_boost = "Elemental Attack Boost",
		attack_and_defense_up = "Attack and Defense Up",
		attack_and_affinity_up = "Attack and Affinity Up",
		knockbacks_negated = "Knockbacks Negated",
		earplugs_s = "Earplugs (S)",
		earplugs_l = "Earplugs (L)",
		tremors_negated = "Tremors Negated",
		wind_pressure_negated = "Wind Pressure Negated",
		stun_negated = "Stun Negated",
		blight_negated = "Blight Negated",
		divine_protection = "Divine Protection",
		health_recovery_s = "Health Recovery (S)",
		health_recovery_l = "Health Recovery (L)",
		health_recovery_s_antidote = "Health Recovery (S) + (Antidote)",
		health_regeneration = "Health Regeneration",
		stamina_use_reduced = "Stamina Use Reduced",
		stamina_recovery_up = "Stamina Recovery Up",
		sharpness_loss_reduced = "Sharpness Loss Reduced",
		environment_damage_negated = "Environment Damage Negated",
		sonic_wave = "Sonic Wave",
		sonic_barrier = "Sonic Barrier",
		infernal_melody = "Infernal Melody",
		sharpness_regeneration = "Sharpness Regeneration",
		sharpness_extension = "Sharpness Extension",
	},

	dango_skills = {
		dango_adrenaline = "Dango Adrenaline",	
		dango_booster = "Dango Booster",
		dango_bulker = "Dango Bulker",
		dango_connector = "Dango Connector",
		dango_defender = "Dango Defender",
		dango_flyer = "Dango Flyer",
		dango_glutton = "Dango Glutton",
		dango_hunter = "Dango Hunter",
		dango_insurance = "Dango Insurance",
		dango_insurance_defense_up = "Dango Insurance Defense Up",
		super_recovery_dango = "Super Recovery Dango"
	},

	rampage_skills = {
		chameleos_soul = "Chameleos Soul",
		kushala_daora_soul = "Kushala Daora Soul"
	},

	skills = {
		adrenaline_rush = "Adrenaline Rush",
		affinity_sliding = "Affinity Sliding",
		agitator = "Agitator",
		berserk = "Berserk",
		bladescale_hone = "Bladescale Hone",
		blood_awakening = "Blood Awakened",
		bloodlust = "Bloodlust",
		burst = "Burst",
		coalescence = "Coalescence",
		counterstrike = "Counterstrike",
		dereliction = "Dereliction",
		dragon_conversion_elemental_attack_up = "Dragon Conversion Elem. Atk Up",
		dragon_conversion_elemental_res_up = "Dragon Conversion Elem. Res Up",
		dragonheart = "Dragonheart",
		embolden = "Embolden",
		frenzied_bloodlust = "Frenzied Bloodlust",
		furious = "Furious",
		grinder_s = "Grinder (S)",
		heaven_sent = "Heaven-Sent",
		hellfire_cloak = "Hellfire Cloak",
		heroics = "Heroics",
		inspiration = "Inspiration",
		intrepid_heart = "Intrepid Heart",
		latent_power = "Latent Power",
		maximum_might = "Maximum Might",
		offensive_guard = "Offensive Guard",
		partbreaker = "Partbreaker",
		peak_performance = "Peak Performance",
		powder_mantle_red = "Powder Mantle (Red)",
		powder_mantle_blue = "Powder Mantle (Blue)",
		protective_polish = "Protective Polish",
		resentment = "Resentment",
		resuscitate = "Resuscitate",
		spiribirds_call = "Spiribird's Call",
		status_trigger = "Status Trigger",
		strife = "Strife",
		wall_runner = "Wall Runner",
		wind_mantle = "Wind Mantle"
	},

	weapons = {
		great_sword = "Great Sword",
		long_sword = "Long Sword",
		sword_and_shield = "Sword & Shield",
		dual_blades = "Dual Blades",
		lance = "Lance",
		gunlance = "Gunlance",
		hammer = "Hammer",
		hunting_horn = "Hunting Horn",
		switch_axe = "Switch Axe",
		charge_blade = "Charge Blade",
		insect_glaive = "Insect Glaive",
		light_bowgun = "Light Bowgun",
		heavy_bowgun = "Heavy Bowgun",
		bow = "Bow"
	},

	weapon_skills = {
		-- Great Sword
		great_sword = {
			power_sheathe = "Power Sheathe"
		},
		-- Long Sword
		long_sword = {
			harvest_moon = "Harvest Moon",
			iai_slash = "Iai Slash",
			soaring_kick = "Soaring Kick",
			spirit_gauge = "Spirit Gauge",
			spirit_gauge_autofill = "Spirit Gauge Autofill", -- Soaring Kick, Iai Slash
		},
		-- Sword & Shield
		sword_and_shield = {
			destroyer_oil = "Destroyer Oil"
		},
		-- Dual Blades
		dual_blades = {
			archdemon_mode = "Archdemon Mode",
			ironshine_silk = "Ironshine Silk"
		},
		-- Lance
		lance = {
			anchor_rage = "Anchor Rage",
			spiral_thrust = "Spiral Thrust",
			twin_wine = "Twin Wine"
		},
		-- Gunlance
		gunlance = {
			erupting_cannon = "Erupting Cannon",
			ground_splitter = "Ground Splitter"
		},
		-- Hammer
		hammer = {
			impact_burst = "Impact Burst"
		},
		-- Hunting Horn
		hunting_horn =	{
			bead_of_resonance = "Bead of Resonance",
			silkbind_shockwave = "Silkbind Shockwave",
			sonic_bloom = "Sonic Bloom"
		},
		-- Switch Axe
		switch_axe = {
			amped_state = "Amped State",
			axe_heavy_slam = "Axe: Heavy Slam",
			switch_charger = "Switch Charger"
		},
		-- Charge Blade
		charge_blade = {
			element_boost = "Element Boost",
			sword_boost_mode = "Sword Boost Mode"
		},
		-- Insect Glaive
		insect_glaive = {
			red_extract = "Red Extract",
			white_extract = "White Extract",
			orange_extract = "Orange Extract",
			all_extracts_mix = "All Extracts Mix"
		},
		-- Light Bowgun
		light_bowgun = {
			fanning_maneuver = "Fanning Maneuver",
			wyvernblast_reload = "Wyvernblast Reload"
		},
		-- Heavy Bowgun
		heavy_bowgun = {
			counter_charger = "Counter Charger",
			overheat = "Overheat",
			rising_moon = "Rising Moon",
			setting_sun = "Setting Sun",
			wyvernsnipe_reload = "Wyvernsnipe Reload"
		},
		-- Bow
		bow = {
			arc_shot_affinity = "Arc Shot: Affinity",
			arc_shot_brace = "Arc Shot: Brace",
			bolt_boost = "Bolt Boost",
			herculean_draw = "Herculean Draw"
		}
	},

	otomo_moves = {
		go_fight_win = "Go, Fight, Win",
		power_drum = "Power Drum",
		rousing_roar = "Rousing Roar",
		vase_of_vitality = "Vase of Vitality",
	},

	misc_buffs = {
		attack_up = "Attack Up",
		defense_up = "Defense Up",
		stamina_use_down = "Stamina Use Down",
		immunity = "Immunity",
		natural_healing_up = "Natural Healing Up"
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

		lv = ""
	},

	stats = {
		attack = "Attack",
		defense = "Defense",
		affinity = "Affinity",
		
		fire_resistance = "Fire Res";
		water_resistance = "Water Res";
		thunder_resistance = "Thunder Res";
		ice_resistance = "Ice Res";
		dragon_resistance = "Dragon Res";

		stamina = "Stamina",

		fire = "Fire",
		water = "Water",
		thunder = "Thunder",
		ice = "Ice",
		dragon = "Dragon",
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

		players = "Players",
		bombs = "Bombs",
		kunai = "Kunai",
		installations = "Installations",
		otomos = "Buddies",
		monsters = "Monsters",
		wyvern_riding = "Wyvern Riding",
		poison = "Poison",
		blast = "Blast",
		endemic_life = "Endemic Life",
		anomaly_cores = "Anomaly Cores",
		other = "Other",

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

		right_alignment_shift = "Right Alignment Shift",

		debug = "Debug",
		current_time = "Current Time",
		everything_seems_to_be_ok = "Everything seems to be OK!",
		history = "History",
		history_size = "History Size",

		value = "Value",

		stats_UI = "Stats UI",
		health_label = "Health Label",
		stamina_label = "Stamina Label",
		attack_label = "Attack Label",
		defense_label = "Defense Label",
		affinity_label = "Affinity Label",
		fire_resistance_label = "Fire Resistance Label",
		water_resistance_label = "Water Resistance Label",
		thunder_resistance_label = "Thunder Resistance Label",
		ice_resistance_label = "Ice Resistance Label",
		dragon_resistance_label = "Dragon Resistance Label",
		element_label = "Element Label",
		element_2_label = "Element 2 Label",

		abnormal_statuses = "Abnormal Statuses",
		item_buffs = "Item Buffs",
		endemic_life_buffs = "Endemic Life Buffs",
		melody_effects = "Melody Effects",
		dango_skills = "Dango Skills",
		rampage_skills = "Rampage Skills",
		skills = "Skills",
		weapon_skills = "Weapon Skills",
		otomo_moves = "Buddy Moves",
		misc_buffs = "Misc Buffs",

		timer_delays = "Timer Delays",
		update_singletons_delay = "Update Singletons (seconds)",
		update_window_size_delay = "Update Window Size (seconds)",
		update_quest_time_delay = "Update Quest Time (seconds)",
		update_is_online_delay = "Update Is Online (seconds)",
		update_players_delay = "Update Players (seconds)",
		update_myself_position_delay = "Update Myself Position (seconds)",
		update_player_info_delay = "Update Player Info (seconds)",
		update_buffs_delay = "Update Buffs (seconds)",

		infinite_buffs_location = "Infinite Buffs Location",

		skill_level = "Skill Level"
	},
};

this.language_names = { "default" };
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
			log.info(string.format("[MHR Overlay] %s.json Loaded Successfully", language_file_name));

			table.insert(this.language_names, language_name);

			local merged_language = utils.table.merge(this.default_language, loaded_language);
			table.insert(this.languages, merged_language);

			this.save(language_file_name, merged_language);
		else
			error_handler.report("language.load", string.format("Failed to load %s.json", language_file_name));
			log.error(string.format("[MHR Overlay] Failed to Load %s.json", language_file_name));
		end
	end
end

function this.save(file_name, language_table)
	local success = json.dump_file(file_name, language_table);
	if success then
		log.info(string.format("[MHR Overlay] %s Saved Successfully", file_name));
	else
		error_handler.report("language.save", string.format("[MHR Overlay] Failed to Save %s", file_name));
		log.error(string.format("[MHR Overlay] Failed to Save %s", file_name));
	end
end

function this.save_default()
	this.save(this.language_folder .. "en-us.json", this.default_language);
end

function this.update(index)
	this.current_language = this.languages[index];
end

function this.init_dependencies()
	utils = require("MHR_Overlay.Misc.utils");
	error_handler = require("MHR_Overlay.Misc.error_handler");
end

function this.init_module()
	this.save_default();
	this.load();
	this.current_language = this.default_language;
end

return this;
