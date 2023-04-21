local part_names = {};

local language;

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

part_names.list = {};

function part_names.init()
	part_names.list = {
		[98] = -- Great Izuchi 98
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.arms,
			language.current_language.parts.tail,
		},
		[54] = -- Great Baggi 54
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.tail
		},
		[107] = -- Kulu-Ya-Ku 107
		{
			language.current_language.parts.head,
			language.current_language.parts.arms,
			language.current_language.parts.body,
			language.current_language.parts.tail,
			language.current_language.parts.rock,
			language.current_language.parts.rock
		},
		[59] = -- Great Wroggi 59
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.tail
		},
		[60] = -- Arzuros 60
		{
			language.current_language.parts.head,
			language.current_language.parts.upper_body,
			language.current_language.parts.forelegs,
			language.current_language.parts.rear,
			language.current_language.parts.lower_body
		},
		[61] = -- Lagombi 61
		{
			language.current_language.parts.head,
			language.current_language.parts.upper_body,
			language.current_language.parts.forelegs,
			language.current_language.parts.rear,
			language.current_language.parts.lower_body
		},
		[62] = -- Volvidon 62
		{
			language.current_language.parts.upper_back,
			language.current_language.parts.Head,
			language.current_language.parts.forelegs,
			language.current_language.parts.lower_back,
			language.current_language.parts.hind_legs,
			language.current_language.parts.spinning
		},
		[91] = -- Aknosom 91
		{
			language.current_language.parts.head,
			language.current_language.parts.neck,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.torso,
			language.current_language.parts.tail,
			language.current_language.parts.legs
		},
		[47] = -- Royal Ludroth 47
		{
			language.current_language.parts.head,
			language.current_language.parts.mane,
			language.current_language.parts.torso,
			language.current_language.parts.left_legs,
			language.current_language.parts.right_legs,
			language.current_language.parts.tail
		},
		[44] = -- Barroth 44
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.arms,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail,
			language.current_language.parts.head_mud,
			language.current_language.parts.body_mud,
			language.current_language.parts.arms_mud,
			language.current_language.parts.left_leg_mud,
			language.current_language.parts.right_leg_mud,
			language.current_language.parts.tail_mud
		},
		[3] = -- Khezu 3
		{
			language.current_language.parts.head,
			language.current_language.parts.neck,
			language.current_language.parts.torso,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.tail
		},
		[92] = -- Tetranadon 92
		{
			language.current_language.parts.head,
			language.current_language.parts.right_arm,
			language.current_language.parts.left_arm,
			language.current_language.parts.right_leg,
			language.current_language.parts.left_leg,
			language.current_language.parts.carapace,
			language.current_language.parts.torso,
			language.current_language.parts.tail
		},
		[90] = -- Bishaten 90
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.right_arm,
			language.current_language.parts.left_arm,
			language.current_language.parts.right_leg,
			language.current_language.parts.left_leg,
			language.current_language.parts.tail
		},
		[102] = -- Pukei-Pukei 102
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail
		},
		[108] = -- Jyuratodus 108
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail,
			language.current_language.parts.head_mud,
			language.current_language.parts.torso_mud,
			language.current_language.parts.left_leg_mud,
			language.current_language.parts.right_leg_mud,
			language.current_language.parts.tail_mud
		},
		[4] = -- Basarios 4
		{
			language.current_language.parts.torso,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.head,
			language.current_language.parts.abdomen,
			language.current_language.parts.tail
		},
		[93] = -- Somnacanth 93
		{
			language.current_language.parts.body,
			language.current_language.parts.head,
			language.current_language.parts.neck,
			language.current_language.parts.left_arm,
			language.current_language.parts.right_arm,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail
		},
		[1] = -- Rathian 1
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail
		},
		[42] = -- Barioth 42
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.tail
		},
		[109] = -- Tobi-Kadachi 109
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.back,
			language.current_language.parts.forelegs,
			language.current_language.parts.hind_legs,
			language.current_language.parts.tail
		},
		[89] = -- Magnamalo 89
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.back,
			language.current_language.parts.tail,
			language.current_language.parts.hind_legs
		},
		[100] = -- Anjanath 100
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing
		},
		[37] = -- Nargacuga 37
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_cutwing,
			language.current_language.parts.tail,
			language.current_language.parts.forelegs,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_cutwing,
			language.current_language.parts.right_hind_leg
		},
		[82] = -- Mizutsune 82
		{
			language.current_language.parts.head,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.body,
			language.current_language.parts.tail,
			language.current_language.parts.dorsal_fin
		},
		[97] = -- Goss Harag 97
		{

			language.current_language.parts.head,
			language.current_language.parts.back,
			language.current_language.parts.left_arm,
			language.current_language.parts.left_arm_ice,
			language.current_language.parts.right_arm,
			language.current_language.parts.right_arm_ice,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.body
		},
		[2] = -- Rathalos 2
		{
			language.current_language.parts.body,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.neck,
			language.current_language.parts.head,
			language.current_language.parts.tail
		},
		[95] = -- Almudron 95
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.tail,
			language.current_language.parts.tail_tip,
			language.current_language.parts.mudbulb
		},
		[57] = -- Zinogre 57
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.back,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.tail
		},
		[32] = -- Tigrex 32
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.tail
		},
		[7] = -- Diablos 7
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail
		},
		[94] = -- Rakna-Kadaki 94
		{
			language.current_language.parts.head,
			language.current_language.parts.claw,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.abdomen,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.abdomen,
			language.current_language.parts.chest

		},
		[24] = -- Kushala Daora 24
		{
			language.current_language.parts.head,
			language.current_language.parts.back,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.wings,
			language.current_language.parts.tail
		},
		[25] = -- Chameleos 25
		{
			language.current_language.parts.head,
			language.current_language.parts.abdomen,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.tail,
			language.current_language.parts.wings
		},
		[27] = -- Teostra 27
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.forelegs,
			language.current_language.parts.hind_legs,
			language.current_language.parts.wings,
			language.current_language.parts.tail
		},
		[23] = -- Rajang 23
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.left_arm,
			language.current_language.parts.right_arm,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail
		},
		[118] = -- Bazelgeuse 118
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.legs,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.tail
		},
		[96] = -- Wind Serpent Ibushi 96
		{
			language.current_language.parts.head,
			language.current_language.parts.right_arm,
			language.current_language.parts.left_arm,
			language.current_language.parts.torso,
			language.current_language.parts.back,
			language.current_language.parts.tail,
			--language.current_language.parts.tail_windsac,
			--language.current_language.parts.chest_windsac,
			--language.current_language.parts.back_windsac
		},
		[99] = -- Thunder Serpent Narwa+ 99
		{
			language.current_language.parts.head,
			nil,
			language.current_language.parts.right_arm,
			language.current_language.parts.left_arm,
			language.current_language.parts.tail,
			nil,
			language.current_language.parts.back,
			language.current_language.parts.thundersacs
		},
		[1379] = -- Narwa the Allmother+ 1379
		{
			language.current_language.parts.head,
			nil,
			language.current_language.parts.right_arm,
			language.current_language.parts.left_arm,
			language.current_language.parts.tail,
			nil,
			language.current_language.parts.back,
			language.current_language.parts.thundersacs
		},
		[1366] = -- Crimson Glow Valstrax 1366
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.tail,
			language.current_language.parts.hind_legs,
			language.current_language.parts.chest
		},
		[1852] = -- Apex Arzuros 1852
		{
			language.current_language.parts.head,
			language.current_language.parts.upper_body,
			language.current_language.parts.forelegs,
			language.current_language.parts.rear,
			language.current_language.parts.lower_body
		},
		[1793] = -- Apex Rathian 1793
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail
		},
		[1874] = -- Apex Mizutsune 1874
		{
			language.current_language.parts.head,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.body,
			language.current_language.parts.tail,
			language.current_language.parts.dorsal_fin
		},
		[1794] = -- Apex Rathalos 1794
		{
			language.current_language.parts.body,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.neck,
			language.current_language.parts.head,
			language.current_language.parts.tail
		},
		[1799] = -- Apex Diablos 1799
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail
		},
		[1849] = -- Apex Zinogre+ 1849
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.back,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.tail
		},






		--SUNBREAK





		[81] = -- Astalos 81
		{
			language.current_language.parts.crest,
			language.current_language.parts.body,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_leg,
			language.current_language.parts.left_leg,
			language.current_language.parts.tail,
			language.current_language.parts.tail_tip
		},
		[132] = -- Malzeno 132
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.hind_legs,
			language.current_language.parts.wings,
			language.current_language.parts.tail,
		},
		[19] = -- Daimyo Hermitaur 19
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.shell,
			language.current_language.parts.left_legs,
			language.current_language.parts.right_legs,
			language.current_language.parts.left_claw,
			language.current_language.parts.right_claw,
			language.current_language.parts.forelegs
		},
		[346] = -- Blood Orange Bishaten 346
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.right_arm,
			language.current_language.parts.left_arm,
			language.current_language.parts.right_leg,
			language.current_language.parts.left_leg,
			language.current_language.parts.tail
		},
		[134] = -- Garangolm 134
		{
			language.current_language.parts.head,
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.left_arm,
			language.current_language.parts.right_arm,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail
		},
		[349] = -- Aurora Somnacanth 349
		{
			language.current_language.parts.body,
			language.current_language.parts.head,
			language.current_language.parts.neck,
			language.current_language.parts.left_arm,
			language.current_language.parts.right_arm,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail
		},
		[133] = -- Lunagaron 133
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.hind_legs,
			language.current_language.parts.tail,
			language.current_language.parts.abdomen,
			language.current_language.parts.back
		},
		[136] = -- Espinas 136
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.wings,
			language.current_language.parts.legs,
			language.current_language.parts.tail
		},
		[135] = -- Gaismagorm 135
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.left_wingclaw,
			language.current_language.parts.right_wingclaw,
			language.current_language.parts.left_wingclaw,
			language.current_language.parts.right_wingclaw,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.tail,
			language.current_language.parts.head,
			language.current_language.parts.back
		},
		[71] = -- Gore Magala 71
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.wings,
			language.current_language.parts.wingclaws,
			language.current_language.parts.forelegs,
			language.current_language.parts.hind_legs,
			language.current_language.parts.tail,
			language.current_language.parts.antenna
		},
		[77] = -- Seregios 77
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.tail
		},
		[351] = -- Magma Almudron 351
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.tail,
			language.current_language.parts.tail_tip,
			language.current_language.parts.mudbulb
		},
		[350] = -- Pyre Rakna-Kadaki 350
		{
			language.current_language.parts.head,
			language.current_language.parts.claw,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.abdomen,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.abdomen,
			language.current_language.parts.chest
		},
		[72] = -- Shagaru Magala 72
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.wings,
			language.current_language.parts.wingclaws,
			language.current_language.parts.forelegs,
			language.current_language.parts.hind_legs,
			language.current_language.parts.tail
		},
		[20] = -- Shogun Ceanataur 20
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.shell,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.left_claw,
			language.current_language.parts.right_claw,
			language.current_language.parts.forelegs,
			language.current_language.parts.shell,
			language.current_language.parts.shell
		},
		[1303] = -- Furious Rajang missing
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.left_arm,
			language.current_language.parts.right_arm,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail
		},
		[1369] = -- Scorned Magnamalo missing
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.back,
			language.current_language.parts.tail,
			language.current_language.parts.hind_legs
		},
		




		--SUNBREAK TITLE UPDATE 1





		[1398] = -- Seething Bazelgeuse
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.legs,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.tail
		},
		[514] = -- Silver Rathalos
		{
			language.current_language.parts.body,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.neck,
			language.current_language.parts.head,
			language.current_language.parts.tail
		},
		[513] = -- Gold Rathian
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.tail
		},
		[549] = -- Lucent Nargacuga
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_cutwing,
			language.current_language.parts.tail,
			language.current_language.parts.forelegs,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_cutwing,
			language.current_language.parts.right_hind_leg
		},





		--SUNBREAK TITLE UPDATE 2




				
		[392] = -- Flaming Espinas
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.wings,
			language.current_language.parts.legs,
			language.current_language.parts.tail
		},
		[594] = -- Violet Mizutsune
		{
			language.current_language.parts.head,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.body,
			language.current_language.parts.tail,
			language.current_language.parts.dorsal_fin
		},
		[2073] = -- Risen Chameleos
		{
			language.current_language.parts.head,
			language.current_language.parts.abdomen,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.left_hind_leg,
			language.current_language.parts.right_hind_leg,
			language.current_language.parts.tail,
			language.current_language.parts.wings
		},





		--SUNBREAK TITLE UPDATE 3





		[1351] = -- Chaotic Gore Magala  1351
		{
			language.current_language.parts.head,
			language.current_language.parts.torso,
			language.current_language.parts.wings,
			language.current_language.parts.wingclaws,
			language.current_language.parts.forelegs,
			language.current_language.parts.hind_legs,
			language.current_language.parts.tail,
			language.current_language.parts.antenna
		},

		[2072] = -- Risen Kushala Daora 2072
		{
			language.current_language.parts.head,
			language.current_language.parts.back,
			language.current_language.parts.left_leg,
			language.current_language.parts.right_leg,
			language.current_language.parts.wings,
			language.current_language.parts.tail
		},

		[2075] = -- Risen Teostra 2075
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.forelegs,
			language.current_language.parts.hind_legs,
			language.current_language.parts.wings,
			language.current_language.parts.tail
		},





		--SUNBREAK TITLE UPDATE 4





		[124] = -- Velkhana 124
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.forelegs,
			language.current_language.parts.hind_legs,
			language.current_language.parts.wings,
			language.current_language.parts.tail
		},

		[2134] = -- Risen Crimson Glow Valstrax 2134
		{
			language.current_language.parts.head,
			language.current_language.parts.body,
			language.current_language.parts.left_wing,
			language.current_language.parts.right_wing,
			language.current_language.parts.left_foreleg,
			language.current_language.parts.right_foreleg,
			language.current_language.parts.tail,
			language.current_language.parts.hind_legs,
			language.current_language.parts.chest
		},
	};
end

function part_names.get_part_name(monster_id, part_id)
	local monster_parts = part_names.list[monster_id];
	if monster_parts == nil then
		return "?";
	end

	local part_name = monster_parts[part_id];
	return part_name;
end

function part_names.init_module()
	language = require("MHR_Overlay.Misc.language");

	part_names.init();
end

return part_names;
