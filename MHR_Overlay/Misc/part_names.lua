local part_names = {};
local language;
local table_helpers;

part_names.list = {};

function part_names.init()
	part_names.list = {
		[98] = -- Great Izuchi+ 98
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.arms,
				language.current_language.parts.tail,
			},
		[54] = -- Great Baggi+ 54
			{
				language.current_language.parts.head,
				language.current_language.parts.torso,
				language.current_language.parts.tail
			},
		[107] = -- Kulu-Ya-Ku+ 107 boulders are cut out
			{
				language.current_language.parts.head,
				language.current_language.parts.arms,
				language.current_language.parts.body,
				language.current_language.parts.tail,
				language.current_language.parts.rock,
				language.current_language.parts.rock
			},
		[59] = -- Great Wroggi+ 59
			{
				language.current_language.parts.head,
				language.current_language.parts.torso,
				language.current_language.parts.tail
			},
		[60] = -- Arzuros+ 60 Unknown parts
			{
				language.current_language.parts.head,
				language.current_language.parts.upper_body,
				language.current_language.parts.arms,
				language.current_language.parts.rear,
				language.current_language.parts.lower_body
			},
		[61] = -- Lagombi+ 61
			{
				language.current_language.parts.head,
				language.current_language.parts.upper_body,
				language.current_language.parts.arms,
				language.current_language.parts.rear,
				language.current_language.parts.lower_body
			},
		[62] = -- Volvidon+ 62
			{
				language.current_language.parts.upper_back,
				language.current_language.parts.upper_body,
				language.current_language.parts.arms,
				language.current_language.parts.lower_back,
				language.current_language.parts.lower_body,
				language.current_language.parts.spinning
			},
		[91] = -- Aknosom+ 91
			{
				language.current_language.parts.head,
				language.current_language.parts.neck,
				language.current_language.parts.left_wing,
				language.current_language.parts.right_wing,
				language.current_language.parts.body,
				language.current_language.parts.tail,
				language.current_language.parts.legs
			},
		[47] = -- Royal Ludroth+ 47
			{
				language.current_language.parts.head,
				language.current_language.parts.mane,
				language.current_language.parts.torso,
				language.current_language.parts.left_legs,
				language.current_language.parts.right_legs,
				language.current_language.parts.tail
			},
		[44] = -- Barroth+ 44
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.arms,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail
			},
		[3] = -- Khezu+ 3
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
		[92] = -- Tetranadon+ 92
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
		[90] = -- Bishaten+ 90
			{
				language.current_language.parts.head,
				language.current_language.parts.torso,
				language.current_language.parts.right_arm,
				language.current_language.parts.left_arm,
				language.current_language.parts.right_leg,
				language.current_language.parts.left_leg,
				language.current_language.parts.tail
			},
		[102] = -- Pukei-Pukei+ 102
			{
				language.current_language.parts.head,
				language.current_language.parts.torso,
				language.current_language.parts.left_wing,
				language.current_language.parts.right_wing,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail
			},
		[108] = -- Jyuratodus+ 108 missing mud parts
			{
				language.current_language.parts.head,
				language.current_language.parts.torso,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail,
				language.current_language.parts.head_mud,
				language.current_language.parts.tail_mud
			},
		[4] = -- Basarios+ 4
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
		[93] = -- Somnacanth+ 93
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
		[1] = -- Rathian+ 1
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.left_wing,
				language.current_language.parts.right_wing,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail
			},
		[42] = -- Barioth+ 42
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.left_wing,
				language.current_language.parts.right_wing,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail
			},
		[109] = -- Tobi-Kadachi+ 109
			{
				language.current_language.parts.head,
				language.current_language.parts.torso,
				language.current_language.parts.back,
				language.current_language.parts.arms,
				language.current_language.parts.legs,
				language.current_language.parts.tail
			},
		[89] = -- Magnamalo+ 89
			{
				language.current_language.parts.head,
				language.current_language.parts.torso,
				language.current_language.parts.right_arm,
				language.current_language.parts.left_arm,
				language.current_language.parts.back,
				language.current_language.parts.tail,
				language.current_language.parts.legs
			},
		[100] = -- Anjanath+ 100 (missing parts)
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail,
				language.current_language.parts.left_wing,
				language.current_language.parts.right_wing
			},
		[37] = -- Nargacuga+ 37
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.left_cutwing,
				language.current_language.parts.tail,
				language.current_language.parts.arms,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_cutwing,
				language.current_language.parts.right_leg
			},
		[82] = -- Mizutsune+ 82
			{
				language.current_language.parts.head,
				language.current_language.parts.left_arm,
				language.current_language.parts.right_arm,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.body,
				language.current_language.parts.tail,
				language.current_language.parts.dorsal_fin
			},
		[97] = -- Goss Harag+ 97
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
		[2] = -- Rathalos+ 2
			{
				language.current_language.parts.body,
				language.current_language.parts.left_wing,
				language.current_language.parts.right_wing,
				language.current_language.parts.left_wing,
				language.current_language.parts.right_wing,
				language.current_language.parts.neck,
				language.current_language.parts.head,
				language.current_language.parts.tail
			},
		[95] = -- Almudron+ 95
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.left_arm,
				language.current_language.parts.right_arm,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail,
				language.current_language.parts.large_mudbulb,
				language.current_language.parts.large_mudbulb,
			},
		[57] = -- Zinogre+ 57
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.back,
				language.current_language.parts.left_arm,
				language.current_language.parts.right_arm,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail
			},
		[32] = -- Tigrex+ 32
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.left_arm,
				language.current_language.parts.right_arm,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail
			},
		[7] = -- Diablos+ 7
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.left_wing,
				language.current_language.parts.right_wing,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail
			},
		[94] = -- Rakna-Kadaki+ 94 (?)
			{
				language.current_language.parts.head,
				language.current_language.parts.claw,
				language.current_language.parts.left_arm,
				language.current_language.parts.right_arm,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.abdomen,
				language.current_language.parts.left_arm,
				language.current_language.parts.right_arm -- mb abdomen_cocooned)
			},
		[24] = -- Kushala Daora+ 24
			{
				language.current_language.parts.head,
				language.current_language.parts.back,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.wings,
				language.current_language.parts.tail
			},
		[25] = -- Chameleos+ 25
			{
				language.current_language.parts.head,
				language.current_language.parts.abdomen,
				language.current_language.parts.left_arm,
				language.current_language.parts.right_arm,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail,
				language.current_language.parts.wings
			},
		[27] = -- Teostra+ 27
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.arms,
				language.current_language.parts.legs,
				language.current_language.parts.wings,
				language.current_language.parts.tail
			},
		[23] = -- Rajang+ 23
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.left_arm,
				language.current_language.parts.right_arm,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail
			},
		[118] = -- Bazelgeuse+ 118
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.legs,
				language.current_language.parts.left_wing,
				language.current_language.parts.right_wing,
				language.current_language.parts.tail
			},
		[96] = -- Wind Serpent Ibushi+ 96 (missing parts)
			{ 
				language.current_language.parts.head,
				language.current_language.parts.right_arm,
				language.current_language.parts.left_arm,
				language.current_language.parts.torso,
				language.current_language.parts.back,
				language.current_language.parts.tail,
				language.current_language.parts.tail_windsac,
				language.current_language.parts.chest_windsac,
				language.current_language.parts.back_windsac
			},
		[99] = -- Thunder Serpent Narwa+ 99 (no parts?)
			{},
		[1379] = -- Narwa the Allmother+ 1379 (no parts?)
			{},
		[1366] = -- Crimson Glow Valstrax+ 1366
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.left_wing,
				language.current_language.parts.right_wing,
				language.current_language.parts.left_arm,
				language.current_language.parts.right_arm,
				language.current_language.parts.tail,
				language.current_language.parts.legs,
				language.current_language.parts.chest_windsac
			},
		[1852] = -- Apex Arzuros+ 1852
			{
				language.current_language.parts.head,
				language.current_language.parts.upper_body,
				language.current_language.parts.arms,
				language.current_language.parts.rear,
				language.current_language.parts.lower_body
			},
		[1793] = -- Apex Rathian+ 1793
			{
				language.current_language.parts.head,
				language.current_language.parts.body,
				language.current_language.parts.left_wing,
				language.current_language.parts.right_wing,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail
			},
		[1874] = -- Apex Mizutsune+ 1874
			{
				language.current_language.parts.head,
				language.current_language.parts.left_arm,
				language.current_language.parts.right_arm,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.body,
				language.current_language.parts.tail,
				language.current_language.parts.dorsal_fin
			},
		[1794] = -- Apex Rathalos+ 1794
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
		[1799] = -- Apex Diablos+ 1799
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
				language.current_language.parts.left_arm,
				language.current_language.parts.right_arm,
				language.current_language.parts.left_leg,
				language.current_language.parts.right_leg,
				language.current_language.parts.tail
			}
	};
end

function part_names.get_part_name(monster_id, part_id)
	
	local monster_parts = part_names.list[monster_id];
	if monster_parts == nil then
		return "";
	end

	local part_name = monster_parts[part_id];
	if part_name == nil then
		return "";
	end

	return part_name;
end

function part_names.init_module()
	language = require("MHR_Overlay.Misc.language");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");

	part_names.init();
end

return part_names;