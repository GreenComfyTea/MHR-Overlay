local this = {};

local config;
local singletons;
local customization_menu;
local players;
local small_monster;
local large_monster;
local damage_meter_UI;
local time;

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

local game_keyboard_type_def = sdk.find_type_definition("snow.GameKeyboard");
local hard_keyboard_field = game_keyboard_type_def:get_field("hardKeyboard");

local hard_keyboard_field_type_def = hard_keyboard_field:get_type();
local get_down_method = hard_keyboard_field_type_def:get_method("getDown");
local get_trigger_method = hard_keyboard_field_type_def:get_method("getTrg");
local get_release_method = hard_keyboard_field_type_def:get_method("getRelease");

this.hotkey_modifiers_down = {
	ctrl = false,
	shift = false,
	alt = false
};

this.keys = {
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


function this.update()
	if singletons.game_keyboard == nil then
		customization_menu.status = "No game keyboard";
		return;
	end

	local hard_keyboard = hard_keyboard_field:get_data(singletons.game_keyboard);
	if hard_keyboard == nil then
		customization_menu.status = "No hard keyboard";
		return;
	end

	this.check_modifiers(hard_keyboard);

	local new_hotkey_registered = this.register_hotkey(hard_keyboard);



	if new_hotkey_registered then
		config.save();
	else
		this.check_hotkeys(hard_keyboard);
	end

	this.hotkey_modifiers_down.ctrl = false;
	this.hotkey_modifiers_down.shift = false;
	this.hotkey_modifiers_down.alt = false
end

function this.check_modifiers(hard_keyboard)
	local is_ctrl_down = get_down_method:call(hard_keyboard, 17);
	if is_ctrl_down ~= nil then
		this.hotkey_modifiers_down.ctrl = is_ctrl_down;
	end

	local is_shift_down = get_down_method:call(hard_keyboard, 16);
	if is_shift_down ~= nil then
		this.hotkey_modifiers_down.shift = is_shift_down;
	end

	local is_alt_down = get_down_method:call(hard_keyboard, 18);
	if is_alt_down ~= nil then
		this.hotkey_modifiers_down.alt = is_alt_down;
	end
end

function this.register_hotkey(hard_keyboard)
	local cached_config = config.current_config.global_settings.hotkeys_with_modifiers;

	if customization_menu.all_UI_waiting_for_key then
		for key, key_name in pairs(this.keys) do
			if get_release_method:call(hard_keyboard, key) then
				cached_config.all_UI.ctrl = this.hotkey_modifiers_down.ctrl;
				cached_config.all_UI.shift = this.hotkey_modifiers_down.shift;
				cached_config.all_UI.alt = this.hotkey_modifiers_down.alt;
				cached_config.all_UI.key = key;
				customization_menu.all_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.small_monster_UI_waiting_for_key then
		for key, key_name in pairs(this.keys) do
			if get_release_method:call(hard_keyboard, key) then
				cached_config.small_monster_UI.ctrl = this.hotkey_modifiers_down.ctrl;
				cached_config.small_monster_UI.shift = this.hotkey_modifiers_down.shift;
				cached_config.small_monster_UI.alt = this.hotkey_modifiers_down.alt;
				cached_config.small_monster_UI.key = key;
				customization_menu.small_monster_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.large_monster_UI_waiting_for_key then
		for key, key_name in pairs(this.keys) do
			if get_release_method:call(hard_keyboard, key) then
				cached_config.large_monster_UI.ctrl = this.hotkey_modifiers_down.ctrl;
				cached_config.large_monster_UI.shift = this.hotkey_modifiers_down.shift;
				cached_config.large_monster_UI.alt = this.hotkey_modifiers_down.alt;
				cached_config.large_monster_UI.key = key;
				customization_menu.large_monster_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.large_monster_dynamic_UI_waiting_for_key then
		for key, key_name in pairs(this.keys) do
			if get_release_method:call(hard_keyboard, key) then
				cached_config.large_monster_dynamic_UI.ctrl = this.hotkey_modifiers_down.ctrl;
				cached_config.large_monster_dynamic_UI.shift = this.hotkey_modifiers_down.shift;
				cached_config.large_monster_dynamic_UI.alt = this.hotkey_modifiers_down.alt;
				cached_config.large_monster_dynamic_UI.key = key;
				customization_menu.large_monster_dynamic_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.large_monster_static_UI_waiting_for_key then
		for key, key_name in pairs(this.keys) do
			if get_release_method:call(hard_keyboard, key) then
				cached_config.large_monster_static_UI.ctrl = this.hotkey_modifiers_down.ctrl;
				cached_config.large_monster_static_UI.shift = this.hotkey_modifiers_down.shift;
				cached_config.large_monster_static_UI.alt = this.hotkey_modifiers_down.alt;
				cached_config.large_monster_static_UI.key = key;
				customization_menu.large_monster_static_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.large_monster_highlighted_UI_waiting_for_key then
		for key, key_name in pairs(this.keys) do
			if get_release_method:call(hard_keyboard, key) then
				cached_config.large_monster_highlighted_UI.ctrl = this.hotkey_modifiers_down.ctrl;
				cached_config.large_monster_highlighted_UI.shift = this.hotkey_modifiers_down.shift;
				cached_config.large_monster_highlighted_UI.alt = this.hotkey_modifiers_down.alt;
				cached_config.large_monster_highlighted_UI.key = key;
				customization_menu.large_monster_highlighted_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.time_UI_waiting_for_key then
		for key, key_name in pairs(this.keys) do
			if get_release_method:call(hard_keyboard, key) then
				cached_config.time_UI.ctrl = this.hotkey_modifiers_down.ctrl;
				cached_config.time_UI.shift = this.hotkey_modifiers_down.shift;
				cached_config.time_UI.alt = this.hotkey_modifiers_down.alt;
				cached_config.time_UI.key = key;
				customization_menu.time_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.damage_meter_UI_waiting_for_key then
		for key, key_name in pairs(this.keys) do
			if get_release_method:call(hard_keyboard, key) then
				cached_config.damage_meter_UI.ctrl = this.hotkey_modifiers_down.ctrl;
				cached_config.damage_meter_UI.shift = this.hotkey_modifiers_down.shift;
				cached_config.damage_meter_UI.alt = this.hotkey_modifiers_down.alt;
				cached_config.damage_meter_UI.key = key;
				customization_menu.damage_meter_UI_waiting_for_key = false;
				return true;
			end
		end
	elseif customization_menu.endemic_life_UI_waiting_for_key then
		for key, key_name in pairs(this.keys) do
			if get_release_method:call(hard_keyboard, key) then
				cached_config.endemic_life_UI.ctrl = this.hotkey_modifiers_down.ctrl;
				cached_config.endemic_life_UI.shift = this.hotkey_modifiers_down.shift;
				cached_config.endemic_life_UI.alt = this.hotkey_modifiers_down.alt;
				cached_config.endemic_life_UI.key = key;
				customization_menu.endemic_life_UI_waiting_for_key = false;
				return true;
			end
		end
	end

	return false;
end

function this.check_hotkeys(hard_keyboard)
	local cached_config = config.current_config.global_settings.hotkeys_with_modifiers;

	if not (cached_config.all_UI.ctrl and not this.hotkey_modifiers_down.ctrl)
		and not (cached_config.all_UI.shift and not this.hotkey_modifiers_down.shift)
		and not (cached_config.all_UI.alt and not this.hotkey_modifiers_down.alt) then
		if get_release_method:call(hard_keyboard, math.tointeger(cached_config.all_UI.key)) then

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
	end

	if not (cached_config.small_monster_UI.ctrl and not this.hotkey_modifiers_down.ctrl)
		and not (cached_config.small_monster_UI.shift and not this.hotkey_modifiers_down.shift)
		and not (cached_config.small_monster_UI.alt and not this.hotkey_modifiers_down.alt) then
		if get_release_method:call(hard_keyboard, math.tointeger(cached_config.small_monster_UI.key)) then
			config.current_config.small_monster_UI.enabled = not config.current_config.small_monster_UI.enabled;
		end
	end

	if not (cached_config.large_monster_UI.ctrl and not this.hotkey_modifiers_down.ctrl)
		and not (cached_config.large_monster_UI.shift and not this.hotkey_modifiers_down.shift)
		and not (cached_config.large_monster_UI.alt and not this.hotkey_modifiers_down.alt) then
		if get_release_method:call(hard_keyboard, math.tointeger(cached_config.large_monster_UI.key)) then
			local is_any_enabled = config.current_config.large_monster_UI.dynamic.enabled
				or config.current_config.large_monster_UI.static.enabled
				or config.current_config.large_monster_UI.highlighted.enabled;

			config.current_config.large_monster_UI.dynamic.enabled = not is_any_enabled;
			config.current_config.large_monster_UI.static.enabled = not is_any_enabled;
			config.current_config.large_monster_UI.highlighted.enabled = not is_any_enabled;
		end
	end

	if not (cached_config.large_monster_dynamic_UI.ctrl and not this.hotkey_modifiers_down.ctrl)
		and not (cached_config.large_monster_dynamic_UI.shift and not this.hotkey_modifiers_down.shift)
		and not (cached_config.large_monster_dynamic_UI.alt and not this.hotkey_modifiers_down.alt) then
		if get_release_method:call(hard_keyboard,
			math.tointeger(cached_config.large_monster_dynamic_UI.key)) then
			config.current_config.large_monster_UI.dynamic.enabled = not config.current_config.large_monster_UI.dynamic.enabled;
		end
	end

	if not (cached_config.large_monster_static_UI.ctrl and not this.hotkey_modifiers_down.ctrl)
		and not (cached_config.large_monster_static_UI.shift and not this.hotkey_modifiers_down.shift)
		and not (cached_config.large_monster_static_UI.alt and not this.hotkey_modifiers_down.alt) then
		if get_release_method:call(hard_keyboard,
			math.tointeger(cached_config.large_monster_static_UI.key)) then
			config.current_config.large_monster_UI.static.enabled = not config.current_config.large_monster_UI.static.enabled;
		end
	end

	if not (cached_config.large_monster_highlighted_UI.ctrl and not this.hotkey_modifiers_down.ctrl)
		and not (cached_config.large_monster_highlighted_UI.shift and not this.hotkey_modifiers_down.shift)
		and not (cached_config.large_monster_highlighted_UI.alt and not this.hotkey_modifiers_down.alt) then
		if get_release_method:call(hard_keyboard,
			math.tointeger(cached_config.large_monster_highlighted_UI.key)) then
			config.current_config.large_monster_UI.highlighted.enabled = not
				config.current_config.large_monster_UI.highlighted.enabled;
		end
	end

	if not (cached_config.time_UI.ctrl and not this.hotkey_modifiers_down.ctrl)
		and not (cached_config.time_UI.shift and not this.hotkey_modifiers_down.shift)
		and not (cached_config.time_UI.alt and not this.hotkey_modifiers_down.alt) then
		if get_release_method:call(hard_keyboard, math.tointeger(cached_config.time_UI.key)) then
			config.current_config.time_UI.enabled = not config.current_config.time_UI.enabled;
		end
	end

	if not (cached_config.damage_meter_UI.ctrl and not this.hotkey_modifiers_down.ctrl)
		and not (cached_config.damage_meter_UI.shift and not this.hotkey_modifiers_down.shift)
		and not (cached_config.damage_meter_UI.alt and not this.hotkey_modifiers_down.alt) then
		if get_release_method:call(hard_keyboard, math.tointeger(cached_config.damage_meter_UI.key)) then
			config.current_config.damage_meter_UI.enabled = not config.current_config.damage_meter_UI.enabled;
		end
	end

	if not (cached_config.endemic_life_UI.ctrl and not this.hotkey_modifiers_down.ctrl)
		and not (cached_config.endemic_life_UI.shift and not this.hotkey_modifiers_down.shift)
		and not (cached_config.endemic_life_UI.alt and not this.hotkey_modifiers_down.alt) then
		if get_release_method:call(hard_keyboard, math.tointeger(cached_config.endemic_life_UI.key)) then
			config.current_config.endemic_life_UI.enabled = not config.current_config.endemic_life_UI.enabled;
		end
	end
end

function this.get_hotkey_name(hotkey)
	local hotkey_name = "";

	if hotkey.ctrl then
		hotkey_name = "Ctrl + ";
	end

	if hotkey.shift then
		hotkey_name = hotkey_name .. "Shift + ";
	end

	if hotkey.alt then
		hotkey_name = hotkey_name .. "Alt + ";
	end

	return hotkey_name .. tostring(this.keys[hotkey.key]);
end

function this.init_module()
	config = require "MHR_Overlay.Misc.config"
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	customization_menu = require("MHR_Overlay.UI.customization_menu");
	players = require("MHR_Overlay.Damage_Meter.players");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	damage_meter_UI = require("MHR_Overlay.UI.Modules.damage_meter_UI");
	time = require("MHR_Overlay.Game_Handler.time");
end

return this;
