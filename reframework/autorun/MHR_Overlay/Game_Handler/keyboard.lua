local config = require "MHR_Overlay.Misc.config"
local keyboard = {};
local singletons;
local customization_menu;
local player;
local small_monster;
local large_monster;
local damage_meter_UI;
local time;

local game_keyboard_type_def = sdk.find_type_definition("snow.GameKeyboard");
local hard_keyboard_field = game_keyboard_type_def:get_field("hardKeyboard");

local hard_keyboard_field_type_def = hard_keyboard_field:get_type();
local get_down_method = hard_keyboard_field_type_def:get_method("getDown");
local get_trigger_method = hard_keyboard_field_type_def:get_method("getTrg");
local get_release_method = hard_keyboard_field_type_def:get_method("getRelease");

keyboard.keys = {
	[0] = "None",
	[1] = "Left Mouse Button",
	[2] = "Right Mouse Button",
	[3] = "Control-Break",
	[4] = "Middle Mouse Button",
	[5] = "X1 Mouse Button",
	[6] = "X2 Mouse Button",

	--[7] = "Undefined 7",
	[8] = "Backspace",
	[9] = "Tab",
	--[10] = "Reserved 10",
	--[11] = "Reserved 11",
	[12] = "Clear",
	[13] = "Enter",
	--[14] = "Undefined 14",
	--[15] = "Undefined 15",
	[16] = "Shift",
	[17] = "Ctrl",
	[18] = "Alt",
	[19] = "Pause Break",
	[20] = "Caps Lock",

	[21] = "IME Kana/Hanguel/Hangul Mode",
	[22] = "IME On",
	[23] = "IME Junja Mode",
	[24] = "IME Final Mode",
	[25] = "IME Hanja/Kanji Mode",
	[26] = "IME On",
	[27] = "Esc",
	[28] = "IME Convert",
	[29] = "IME NonConvert",
	[30] = "IME Accept",
	[31] = "IME Mode Change Request",

	[32] = "Spacebar",
	[33] = "Page Up",
	[34] = "Page Down",
	[35] = "End",
	[36] = "Home",
	[37] = "Left Arrow",
	[38] = "Up Arrow",
	[39] = "Right Arrow",
	[40] = "Down Arrow",
	[41] = "Select",
	[42] = "Print Screen", -- Print
	[43] = "Execute",
	[44] = "Print Screen",
	[45] = "Ins",
	[46] = "Del",
	[47] = "Help",

	[48] = "0",
	[49] = "1",
	[50] = "2",
	[51] = "3",
	[52] = "4",
	[53] = "5",
	[54] = "6",
	[55] = "7",
	[56] = "8",
	[57] = "9",

	--[58] = "Undefined 58",
	--[59] = "Undefined 59",
	--[60] = "Undefined 60",
	--[61] = "Undefined 60"", -- =+
	--[62] = "Undefined 62",
	--[63] = "Undefined 63",
	--[64] = "Undefined 64",

	[65] = "A",
	[66] = "B",
	[67] = "C",
	[68] = "D",
	[69] = "E",
	[70] = "F",
	[71] = "G",
	[72] = "H",
	[73] = "I",
	[74] = "J",
	[75] = "K",
	[76] = "L",
	[77] = "M",
	[78] = "N",
	[79] = "O",
	[80] = "P",
	[81] = "Q",
	[82] = "R",
	[83] = "S",
	[84] = "T",
	[85] = "U",
	[86] = "V",
	[87] = "W",
	[88] = "X",
	[89] = "Y",
	[90] = "Z",

	[91] = "Left Win",
	[92] = "Right Win",
	[93] = "Applications",
	--[94] = "Reserved 94",
	[95] = "Sleep",

	[96] = "Numpad 0",
	[97] = "Numpad 1",
	[98] = "Numpad 2",
	[99] = "Numpad 3",
	[100] = "Numpad 4",
	[101] = "Numpad 5",
	[102] = "Numpad 6",
	[103] = "Numpad 7",
	[104] = "Numpad 8",
	[105] = "Numpad 9",
	[106] = "Numpad *",
	[107] = "Numpad +",
	[108] = "Numpad Separator",
	[109] = "Numpad -",
	[110] = "Numpad .",
	[111] = "Numpad /",

	[112] = "F1",
	[113] = "F2",
	[114] = "F3",
	[115] = "F4",
	[116] = "F5",
	[117] = "F6",
	[118] = "F7",
	[119] = "F8",
	[120] = "F9",
	[121] = "F10",
	[122] = "F11",
	[123] = "F12",
	[124] = "F13",
	[125] = "F14",
	[126] = "F15",
	[127] = "F16",
	[128] = "F17",
	[129] = "F18",
	[130] = "F19",
	[131] = "F20",
	[132] = "F21",
	[133] = "F22",
	[134] = "F23",
	[135] = "F24",

	--[136] = "Unassigned 136",
	--[137] = "Unassigned 137",
	--[138] = "Unassigned 138",
	--[139] = "Unassigned 139",
	--[140] = "Unassigned 140",
	--[141] = "Unassigned 141",
	--[142] = "Unassigned 142",
	--[143] = "Unassigned 143",

	[144] = "Num Lock",
	[145] = "Scroll Lock",

	[146] = "Numpad Enter", -- OEM Specific 146
	[147] = "OEM Specific 147",
	[148] = "OEM Specific 148",
	[149] = "OEM Specific 149",
	[150] = "OEM Specific 150",
	[151] = "OEM Specific 151",
	[152] = "OEM Specific 152",
	[153] = "OEM Specific 153",
	[154] = "OEM Specific 154",
	[155] = "OEM Specific 155",
	[156] = "OEM Specific 156",
	[157] = "OEM Specific 157",
	[158] = "OEM Specific 158",
	[159] = "OEM Specific 159",

	[160] = "Left Shift",
	[161] = "Right Shift",
	[162] = "Left Ctrl",
	[163] = "Right Ctrl",
	[164] = "Left Alt",
	[165] = "Right Alt",

	[166] = "Browser Back",
	[167] = "Browser Forward",
	[168] = "Browser Refresh",
	[169] = "Browser Stop",
	[170] = "Browser Search",
	[171] = "Browser Favourites",
	[172] = "Browser Start and Home",

	[173] = "Volume Mute",
	[174] = "Volume Down",
	[175] = "Volume Up",
	[176] = "Next Track",
	[177] = "Previous Track",
	[178] = "Stop Media",
	[179] = "Play/Pause Media",
	[180] = "Start Mail",
	[181] = "Select Media",
	[182] = "Start Application 1",
	[183] = "Start Application 2",

	--[184] = "Reserved!",
	--[185] = "Reserved!",

	[186] = ";:",
	[187] = ";:", -- +
	[188] = ",<",
	[189] = "-",
	[190] = ".>",
	[191] = "/?",
	[192] = "`~",

	--[193] = "Reserved!",
	--[194] = "Reserved!",
	--[195] = "Reserved!",
	--[196] = "Reserved!",
	--[197] = "Reserved!",
	--[198] = "Reserved!",
	--[199] = "Reserved!",
	--[200] = "Reserved!",
	--[201] = "Reserved!",
	--[202] = "Reserved!",
	--[203] = "Reserved!",
	--[204] = "Reserved!",
	--[205] = "Reserved!",
	--[206] = "Reserved!",
	--[207] = "Reserved!",
	--[208] = "Reserved!",
	--[209] = "Reserved!",
	--[210] = "Reserved!",
	--[211] = "Reserved!",
	--[212] = "Reserved!",
	--[213] = "Reserved!",
	--[214] = "Reserved!",
	--[215] = "Reserved!",
	--[216] = "Unassigned 216",
	--[217] = "Unassigned 217",
	--[218] = "Unassigned 218",

	[219] = "[{",
	[220] = "\\|",
	[221] = "]}",
	[222] = "\' \"",
	[223] = "OEM_8",
	--[224] = "Reserved",
	[225] = "OEM Specific 225",
	[226] = "<>",
	[227] = "OEM Specific 227",
	[228] = "OEM Specific 228",
	[229] = "IME Process",
	[230] = "OEM Specific 230",
	[231] = "!!!!!!!!!!!!!!!!!!!!!!!",
	--[232] = "Unassigned 232",
	[233] = "OEM Specific 233",
	[234] = "OEM Specific 234",
	[235] = "OEM Specific 235",
	[236] = "OEM Specific 236",
	[237] = "OEM Specific 237",
	[238] = "OEM Specific 238",
	[239] = "OEM Specific 239",
	[240] = "OEM Specific 240",
	[241] = "OEM Specific 241",
	[242] = "OEM Specific 242",
	[243] = "OEM Specific 243",
	[244] = "OEM Specific 244",
	[245] = "OEM Specific 245",

	[246] = "Attn",
	[247] = "CrSel",
	[248] = "ExSel",
	[249] = "Erase EOF",
	[250] = "Play",
	[251] = "Zoom",
	--[252] = "Reserved 252",
	[253] = "PA1",
	--[254] = "Clear"
};


function keyboard.update()
	if singletons.game_keyboard == nil then
		customization_menu.status = "No game keyboard";
		return;
	end

	local hard_keyboard = hard_keyboard_field:get_data(singletons.game_keyboard);
	if hard_keyboard == nil then
		customization_menu.status = "No hard keyboard";
		return;
	end

	local new_hotkey_registered = keyboard.register_hotkey(hard_keyboard);

	if new_hotkey_registered then
		config.save();
	else
		keyboard.check_hotkeys(hard_keyboard);
	end
end

function keyboard.register_hotkey(hard_keyboard)
	if customization_menu.all_UI_waiting_for_key then
		for key, key_name in pairs(keyboard.keys) do
			if get_release_method:call(hard_keyboard, key) then
				config.current_config.global_settings.hotkeys.all_UI = key;
				customization_menu.all_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.small_monster_UI_waiting_for_key then
		for key, key_name in pairs(keyboard.keys) do
			if get_release_method:call(hard_keyboard, key) then
				config.current_config.global_settings.hotkeys.small_monster_UI = key;
				customization_menu.small_monster_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.large_monster_UI_waiting_for_key then
		for key, key_name in pairs(keyboard.keys) do
			if get_release_method:call(hard_keyboard, key) then
				config.current_config.global_settings.hotkeys.large_monster_UI = key;
				customization_menu.large_monster_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.large_monster_dynamic_UI_waiting_for_key then
		for key, key_name in pairs(keyboard.keys) do
			if get_release_method:call(hard_keyboard, key) then
				config.current_config.global_settings.hotkeys.large_monster_dynamic_UI = key;
				customization_menu.large_monster_dynamic_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.large_monster_static_UI_waiting_for_key then
		for key, key_name in pairs(keyboard.keys) do
			if get_release_method:call(hard_keyboard, key) then
				config.current_config.global_settings.hotkeys.large_monster_static_UI = key;
				customization_menu.large_monster_static_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.large_monster_highlighted_UI_waiting_for_key then
		for key, key_name in pairs(keyboard.keys) do
			if get_release_method:call(hard_keyboard, key) then
				config.current_config.global_settings.hotkeys.large_monster_highlighted_UI = key;
				customization_menu.large_monster_highlighted_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.time_UI_waiting_for_key then
		for key, key_name in pairs(keyboard.keys) do
			if get_release_method:call(hard_keyboard, key) then
				config.current_config.global_settings.hotkeys.time_UI = key;
				customization_menu.time_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.damage_meter_UI_waiting_for_key then
		for key, key_name in pairs(keyboard.keys) do
			if get_release_method:call(hard_keyboard, key) then
				config.current_config.global_settings.hotkeys.damage_meter_UI = key;
				customization_menu.damage_meter_UI_waiting_for_key = false;
				return true;
			end
		end
	end
end

function keyboard.check_hotkeys(hard_keyboard)
	if get_release_method:call(hard_keyboard, config.current_config.global_settings.hotkeys.all_UI) then
		local is_any_enabled = config.current_config.time_UI.enabled
			or config.current_config.small_monster_UI.enabled
			or config.current_config.large_monster_UI.dynamic.enabled
			or config.current_config.large_monster_UI.static.enabled
			or config.current_config.large_monster_UI.highlighted.enabled
			or config.current_config.damage_meter_UI.enabled;

		config.current_config.time_UI.enabled = not is_any_enabled;
		config.current_config.small_monster_UI.enabled = not is_any_enabled;
		config.current_config.large_monster_UI.dynamic.enabled = not is_any_enabled;
		config.current_config.large_monster_UI.static.enabled = not is_any_enabled;
		config.current_config.large_monster_UI.highlighted.enabled = not is_any_enabled;
		config.current_config.damage_meter_UI.enabled = not is_any_enabled;
	end

	if get_release_method:call(hard_keyboard, config.current_config.global_settings.hotkeys.small_monster_UI) then
		config.current_config.small_monster_UI.enabled = not config.current_config.small_monster_UI.enabled;
	end

	if get_release_method:call(hard_keyboard, config.current_config.global_settings.hotkeys.large_monster_UI) then
		local is_any_enabled = config.current_config.large_monster_UI.dynamic.enabled
			or config.current_config.large_monster_UI.static.enabled
			or config.current_config.large_monster_UI.highlighted.enabled;

		config.current_config.large_monster_UI.dynamic.enabled = not is_any_enabled;
		config.current_config.large_monster_UI.static.enabled = not is_any_enabled;
		config.current_config.large_monster_UI.highlighted.enabled = not is_any_enabled;
	end

	if get_release_method:call(hard_keyboard, config.current_config.global_settings.hotkeys.large_monster_dynamic_UI) then
		config.current_config.large_monster_UI.dynamic.enabled = not config.current_config.large_monster_UI.dynamic.enabled;
	end

	if get_release_method:call(hard_keyboard, config.current_config.global_settings.hotkeys.large_monster_static_UI) then
		config.current_config.large_monster_UI.static.enabled = not config.current_config.large_monster_UI.static.enabled;
	end

	if get_release_method:call(hard_keyboard, config.current_config.global_settings.hotkeys.large_monster_highlighted_UI) then
		config.current_config.large_monster_UI.highlighted.enabled = not config.current_config.large_monster_UI.highlighted.enabled;
	end

	if get_release_method:call(hard_keyboard, config.current_config.global_settings.hotkeys.time_UI) then
		config.current_config.time_UI.enabled = not config.current_config.time_UI.enabled;
	end

	if get_release_method:call(hard_keyboard, config.current_config.global_settings.hotkeys.damage_meter_UI) then
		config.current_config.damage_meter_UI.enabled = not config.current_config.damage_meter_UI.enabled;
	end
end

function keyboard.init_module()
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	player = require("MHR_Overlay.Damage_Meter.player");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	damage_meter_UI = require("MHR_Overlay.UI.Modules.damage_meter_UI");
	time = require("MHR_Overlay.Game_Handler.time");
end

return keyboard;