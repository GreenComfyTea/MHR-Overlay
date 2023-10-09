local this = {};

local utils;
local config;
local screen;
local players;
local large_monster;
local small_monster;
local env_creature;
local language;
local part_names;
local time_UI;
local keyboard;
local non_players;
local quest_status;
local error_handler;
local time;
local stats_UI;

local buffs;
local item_buffs;
local melody_effects;
local endemic_life_buffs;
local skills;
local dango_skills;
local abnormal_statuses;
local otomo_moves;
local weapon_skills;
local rampage_skills;
local misc_buffs;

local label_customization;
local bar_customization;
local large_monster_UI_customization;

local label_customization;
local bar_customization;
local health_customization;
local stamina_customization;
local rage_customization;
local body_parts_customization;
local ailments_customization;
local ailment_buildups_customization;
local module_visibility_customization;

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

this.is_opened = false;

this.font = nil;
this.full_font_range = {0x1, 0xFFFF, 0};

this.window_position = Vector2f.new(480, 200);
this.window_pivot = Vector2f.new(0, 0);
this.window_size = Vector2f.new(720, 720);
this.window_flags = 0x10120;
this.color_picker_flags = 327680;
this.decimal_input_flags = 33;

this.orientation_types = {};
this.displayed_orientation_types = {};

this.anchor_types = {};
this.displayed_anchor_types = {};

this.monster_UI_sorting_types = {};
this.displayed_monster_UI_sorting_types = {};

this.buff_UI_sorting_types = {};
this.displayed_buff_UI_sorting_types = {};

this.buff_UI_infinite_buffs_location_types = {};
this.displayed_buff_UI_infinite_buffs_location_types = {};

this.damage_meter_UI_highlighted_entity_types = {};
this.displayed_damage_meter_UI_highlighted_entity_types = {};

this.damage_meter_UI_damage_bar_relative_types = {};
this.displayed_damage_meter_UI_damage_bar_relative_types = {};

this.damage_meter_UI_my_damage_bar_location_types = {};
this.displayed_damage_meter_UI_my_damage_bar_location_types = {};

this.damage_meter_UI_total_damage_location_types = {};
this.displayed_damage_meter_UI_total_damage_location_types = {};

this.damage_meter_UI_sorting_types = {};
this.displayed_damage_meter_UI_sorting_types = {};

this.damage_meter_UI_dps_modes = {};
this.displayed_damage_meter_UI_dps_modes = {};

this.auto_highlight_modes = {};
this.displayed_auto_highlight_modes = {};

this.fonts = {"Arial", "Arial Black", "Bahnschrift", "Calibri", "Cambria", "Cambria Math", "Candara",
                            "Comic Sans MS", "Consolas", "Constantia", "Corbel", "Courier New", "Ebrima",
                            "Franklin Gothic Medium", "Gabriola", "Gadugi", "Georgia", "HoloLens MDL2 Assets", "Impact",
                            "Ink Free", "Javanese Text", "Leelawadee UI", "Lucida Console", "Lucida Sans Unicode",
                            "Malgun Gothic", "Marlett", "Microsoft Himalaya", "Microsoft JhengHei",
                            "Microsoft New Tai Lue", "Microsoft PhagsPa", "Microsoft Sans Serif", "Microsoft Tai Le",
                            "Microsoft YaHei", "Microsoft Yi Baiti", "MingLiU-ExtB", "Mongolian Baiti", "MS Gothic",
                            "MV Boli", "Myanmar Text", "Nirmala UI", "Palatino Linotype", "Segoe MDL2 Assets",
                            "Segoe Print", "Segoe Script", "Segoe UI", "Segoe UI Historic", "Segoe UI Emoji",
                            "Segoe UI Symbol", "SimSun", "Sitka", "Sylfaen", "Symbol", "Tahoma", "Times New Roman",
                            "Trebuchet MS", "Verdana", "Webdings", "Wingdings", "Yu Gothic"
};

this.all_UI_waiting_for_key = false;
this.small_monster_UI_waiting_for_key = false;
this.large_monster_UI_waiting_for_key = false;
this.large_monster_dynamic_UI_waiting_for_key = false;
this.large_monster_static_UI_waiting_for_key = false;
this.large_monster_highlighted_UI_waiting_for_key = false;
this.time_UI_waiting_for_key = false;
this.damage_meter_UI_waiting_for_key = false;
this.endemic_life_UI_waiting_for_key = false;
this.menu_font_changed = false;

this.config_name_input = "";

function this.reload_font(pop_push)
	local cached_language = language.current_language;

	local font_range = cached_language.unicode_glyph_ranges;

	if cached_language.font_name == "" then
		font_range = nil;

	elseif cached_language.unicode_glyph_ranges == nil
	or utils.table.is_empty(cached_language.unicode_glyph_ranges)
	or #cached_language.unicode_glyph_ranges == 1
	or not utils.number.is_odd(#cached_language.unicode_glyph_ranges) then

		font_range = this.full_font_range;
	end
	
	this.font = imgui.load_font(cached_language.font_name, config.current_config.global_settings.menu_font.size, font_range);

	if pop_push then
		imgui.pop_font();
		imgui.push_font(this.font);
	end
end

function this.init()
	local default = language.default_language.customization_menu;
	local current = language.current_language.customization_menu;

	bar_customization.init();
	ailments_customization.init();
	ailment_buildups_customization.init();
	body_parts_customization.init();

	this.orientation_types = 
	{
		default.horizontal,
		default.vertical
	};

	this.displayed_orientation_types =
	{
		current.horizontal,
		current.vertical
	};

	this.anchor_types =
	{
		default.top_left,
		default.top_right,
		default.bottom_left,
		default.bottom_right
	};

	this.displayed_anchor_types =
	{
		current.top_left,
		current.top_right,
		current.bottom_left,
		current.bottom_right
	};

	this.monster_UI_sorting_types =
	{
		default.normal,
		default.health,
		default.health_percentage,
		default.distance
	};									

	this.displayed_monster_UI_sorting_types =
	{
		current.normal,
		current.health,
		current.health_percentage,
		current.distance
	};

	this.buff_UI_sorting_types =
	{
		default.name,
		default.timer,
		default.duration
	};

	this.displayed_buff_UI_sorting_types =
	{
		current.name,
		current.timer,
		current.duration
	};

	this.buff_UI_infinite_buffs_location_types =
	{
		default.normal,
		default.first,
		default.last
	};

	this.displayed_buff_UI_infinite_buffs_location_types =
	{
		current.normal,
		current.first,
		current.last
	};

	this.damage_meter_UI_highlighted_entity_types =
	{
		default.top_damage,
		default.top_dps,
		default.none
	};

	this.displayed_damage_meter_UI_highlighted_entity_types =
	{
		current.top_damage,
		current.top_dps,
		current.none
	};

	this.damage_meter_UI_damage_bar_relative_types =
	{
		default.total_damage,
		default.top_damage
	};

	this.displayed_damage_meter_UI_damage_bar_relative_types =
	{
		current.total_damage,
		current.top_damage
	};

	this.damage_meter_UI_my_damage_bar_location_types =
	{
		default.normal,
		default.first,
		default.last
	};
	
	this.displayed_damage_meter_UI_my_damage_bar_location_types =
	{
		current.normal,
		current.first,
		current.last
	};

	this.damage_meter_UI_total_damage_location_types =
	{
		default.first,
		default.last
	};

	this.displayed_damage_meter_UI_total_damage_location_types =
	{
		current.first,
		current.last
	};

	this.damage_meter_UI_sorting_types =
	{
		default.normal,
		default.damage,
		default.dps
	};

	this.displayed_damage_meter_UI_sorting_types =
	{
		current.normal,
		current.damage,
		current.dps
	};

	this.damage_meter_UI_dps_modes =
	{
		default.first_hit,
		default.quest_time,
		default.join_time
	};

	this.displayed_damage_meter_UI_dps_modes =
	{
		current.first_hit,
		current.quest_time,
		current.join_time
	};

	this.auto_highlight_modes =
	{
		default.closest,
		default.farthest,
		default.lowest_health,
		default.highest_health,
		default.lowest_health_percentage,
		default.highest_health_percentage
	};

	this.displayed_auto_highlight_modes =
	{
		current.closest,
		current.farthest,
		current.lowest_health,
		current.highest_health,
		current.lowest_health_percentage,
		current.highest_health_percentage
	};
end

function this.draw()
	if not this.is_opened then
		return;
	end

	local window_position = Vector2f.new(config.current_config.customization_menu.position.x, config.current_config.customization_menu.position.y);
	local window_pivot = Vector2f.new(config.current_config.customization_menu.pivot.x, config.current_config.customization_menu.pivot.y);
	local window_size = Vector2f.new(config.current_config.customization_menu.size.width, config.current_config.customization_menu.size.height);

	imgui.set_next_window_pos(window_position, 1 << 3, window_pivot);
	imgui.set_next_window_size(window_size, 1 << 3);
	
	imgui.push_font(this.font);

	this.is_opened = imgui.begin_window(
		string.format("%s v%s", language.current_language.customization_menu.mod_name, config.current_config.version),
		this.is_opened,
		this.window_flags);


	if not this.is_opened then
		imgui.pop_font();
		imgui.end_window();
		config.save_current();
		return;
	end

	local window_changed = false;
	local config_changed = false;
	local language_changed = false;
	local modifiers_changed = false;
	local modules_changed = false;
	local global_settings_changed = false;
	local timer_delays_changed = false;
	local small_monster_UI_changed = false;
	local large_monster_dynamic_UI_changed = false;
	local large_monster_static_UI_changed = false;
	local large_monster_highlighted_UI_changed = false;
	local time_UI_changed = false;
	local damage_meter_UI_changed = false;
	local endemic_life_UI_changed = false;
	local buff_UI_changed = false;
	local stats_UI_changed = false;
	local debug_changed = false;
	local apply_font_requested = false;

	local new_window_position = imgui.get_window_pos();
	if window_position.x ~= new_window_position.x or window_position.y ~= new_window_position.y then
		window_changed = window_changed or true;

		config.current_config.customization_menu.position.x = new_window_position.x;
		config.current_config.customization_menu.position.y = new_window_position.y;
	end

	local new_window_size = imgui.get_window_size();
	if window_size.x ~= new_window_size.x or window_size.y ~= new_window_size.y then
		window_changed = window_changed or true;

		config.current_config.customization_menu.size.width = new_window_size.x;
		config.current_config.customization_menu.size.height = new_window_size.y;
	end

	local new_window_size = imgui.get_window_size();
	window_changed = window_changed or new_window_size.x ~= window_size.x or new_window_size.y ~= window_size.y;

	config_changed, apply_font_requested = this.draw_config();
	modules_changed = this.draw_modules();
	this.draw_hotkeys();
	global_settings_changed, modifiers_changed, timer_delays_changed, apply_font_requested, language_changed = this.draw_global_settings(apply_font_requested, config_changed);
	small_monster_UI_changed = this.draw_small_monster_UI();

	if imgui.tree_node(language.current_language.customization_menu.large_monster_UI) then
		large_monster_dynamic_UI_changed = this.draw_large_monster_dynamic_UI()
		large_monster_static_UI_changed = this.draw_large_monster_static_UI()
		large_monster_highlighted_UI_changed = this.draw_large_monster_highlighted_UI()
		imgui.tree_pop();
	end

	time_UI_changed = this.draw_time_UI();
	damage_meter_UI_changed = this.draw_damage_meter_UI();
	endemic_life_UI_changed = this.draw_endemic_life_UI()
	buff_UI_changed = this.draw_buff_UI();
	stats_UI_changed = this.draw_stats_UI()
	
	imgui.new_line();
	debug_changed = this.draw_debug();

	-- local lorem_ipsum = [[
	-- 	Japanese:
	-- 	個、えろつのはんエセコモニョ雲雲てなっけもいてのょり阿目手区きも模差露毛阿はら雲毛かくれめ二野なすなまよひか氏氏くっ瀬知魔んよ絵魔て列離日ね留差ほつれつえてゆせそそ、都、うし絵らにな根遊二雲以ゆ野目るヒカヤロ、オシレ遊擢ねてゆ等手津もえ。津阿みこえ知氏阿ンカカおぬやてと。
	-- 	おせす尾樹目個二阿樹ねけゃもたら。おうょる阿雲けてろふ尾課二毛日ニュサのへひ課遊にらそほき離以ろひむもふそろは素日シキハモゅつ野知つせ毛舳ひ列留よせ御遊舳れつ、ねすんと譜保。以樹。夜津尾派露鵜り手手すやとれあろまめにて、こに列留魔知他列二樹ほ。はつに保知等てまゃ無夜とひけやへこ。
	-- 	素派目鵜ちうはえなエヘフレキ、派知他瀬列遊根区いな都留手けもつっそぬりいゆおふゅれもイタキホ無二コチクキやそるき野毛以そいはぬうめ御んせたくめ遊模魔つ鵜阿ほよほつ擢以露、等離譜ぬれ鵜ゆおきまうるかせ擢ひたフンユ。
	-- 	保ゆぬホノハスシカ以屋ら日模へたよ樹手手まお手根派御マツッセチカら、ヒョアレょへち保以屋瀬キョュナめにゆな樹舳毛手え鵜留等瀬ほえ夜区鵜根目名阿絵区日素めフルモョヌスリサクマテカ根鵜さおゆヒエサレ露日鵜留りすせいへたそりるきや個舳らそめっっ知二阿露きね課譜名けょひ根区列以樹個。列津以模ャセャサョみうえのらす鵜派舳。
	-- 	目個なふ、そゃ氏区、鵜瀬保以露遊やはみすき舳課保手舳津譜素個等くせうアメヨルラチヘ留素保手氏たえたお露瀬日毛野ちふ巣課瀬日留列ぬりにほゆ絵擢名模。ふの。っうつゆ、みょタノフカ目列巣舳手知けすん手魔、無雲の課ゅおんりょ。
	-- 	魔雲留課舳根舳か手素二はめ差ーャオシ津やちんなふやてもか列等以露つまえよ。はゆて擢露譜へねょ以区ねのへふもとゃえきナュユモトヌセ樹列知阿阿他列等みれとほルスナ。魔お区ゃゅね素遊ふにふ以個素日絵こもとれち。ゆゆっや阿絵ちネネむろ夜派等阿離知手氏るつねおきえ巣留夜派雲名目他ュノミサミキメウケヘ。
	-- 	氏毛かき夜鵜まのひよかひほねに他んんはし、しへ課氏模めなサシヌケミヘけんむりひめめえもこほよ。差根トャレムリテメへめメメ個差津らめのはょゃ巣えせく列名個舳もま個派るみめ根鵜、きすめ区瀬屋雲れ。鵜留譜夜ツリミふたれ個とい「めつょめこったゅふ」ゅ、すぬやら日区尾等手んひ模、マホセね絵絵コヤヌマ絵んんっへけなぬ野差課瀬ゅり絵等ウチイヌヘ樹、雲他ねろくす名無尾派手遊等区雲そほせるえ派列。
	-- 	よそ津根差屋雲う夜舳野絵こさほえふろクヒはす目鵜っえンノネモソ尾野毛おむめ保日等夜ささえゃうあ列瀬ョイニケョセオウュレヘすすさめ、ぬちひぬはゅれしまろむ屋知まきぬむのひひの目津名二名尾無知め区津津瀬えくよほえっしえお目個留瀬毛譜二雲野知屋ぬ差無鵜のやゆアコハサシヤ根素手無、や模露ョヌヒムフクミ。
	-- 	きまるふかいゅみ他夜都知手野雲サヨシ舳露。くち、野フノユタせおょち目課るれらつはッサウセモュムオンョ無尾列かりのこけろイネいまてめの、絵夜毛遊毛離差無以素課瀬日ゆこう素瀬シサスヒモン列擢はやせ留知名すさぬ。
	-- 	魔等むホカヨアるユチエリサ御都。素樹絵そたゃ擢個尾列ま無雲知名セイ譜津遊たち夜尾ゅっきたろん無模毛都遊ゆ名差。さ雲目ちゆゅんれ、素御やひい巣擢樹つあそ魔、模都以巣舳すれ鵜以「鵜ヘノメヨメヘにさ」もちかしみっはまひゅねほら鵜保尾氏派かろるめあ。遊目樹目鵜毛はせなへめ。

	-- 	English:
	-- 	abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ

	-- 	French:
	-- 	abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ Àà Ââ Ææ Çç Éé Èè Êê Ëë Îî Ïï Ôô Œœ Ùù Ûû Üü Ÿÿ

	-- 	German:
	-- 	abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ Ä Ü Ö ß

	-- 	Italian:
	-- 	abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ

	-- 	Spanish:
	-- 	abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ Ññ 

	-- 	Russian:
	-- 	абвгдеёжзийклмнопрстуфцчшщъыьэюя АБВГДЕЁЖЗИЙКЛМНОПРСТУФЦЧШЩЪЫЬЭЮЯ

	-- 	Polish:
	-- 	abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ Ąą Ćć Ęę Łł Ńń Óó Śś Źź Żż é

	-- 	Brazilian Portuguese:
	-- 	abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ

	-- 	Korean
	-- 	ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅅ ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎㅏ ㅑ ㅓ ㅕ ㅗ ㅛ ㅜ ㅠ ㅡ ㅣㄲ ㄸ ㅃ ㅉ ㅆ ㅢ ㅚ ㅐ ㅟ ㅔ ㅒ ㅖ ㅘ ㅝ ㅙ ㅞ
	-- 	기관과 간에 이 것이다. 풀밭에 부패뿐이다, 보라, 봄바람이다. 희망의 황금시대다, 못할 앞이 지혜는 공자는 평화스러운 그리하였는가? 긴지라 청춘이 없으면 바이며, 우리의 길지 미묘한 무엇을 끝에 것은 사는가 끓는다. 인류의 그것을 같이.
	-- 	같으며, 물방아 예수는 풍부하게 이상의 있으랴? 그들의 용기가 튼튼하며, 사라지지 보내는 내려온 위하여서 꽃이 것이다. 심장의 피가 고행을 무한한 끝까지 보라. 같이. 그리하였는가? 무엇이 넣는 물방아 봄바람이다. 이것은 청춘의 있는 이것이다. 못할 방지하는 구하기 능히 속에 피다.
	-- 	찾아다녀도. 쓸쓸한 생생하며. 찾아다녀도. 튼튼하며. 이상의 피다, 눈에 새가 피부가 그들의 그들의 작고 것은 운다. 부패를 인생에 이상은 보배를 그리하였는가? 품었기 창공에 작고 커다란 용기가 것이 것이다, 쓸쓸하랴?이것을 심장의 긴지라 착목한는 것이다.
	-- 	속에 우리 그들은 광야에서 인생에 노년에게서 청춘이 동산에는 것이다. 얼음과 할지니. 길지 낙원을 대한 말이다. 뭇 피가 이것이다, 풍부하게 바이며. 살았으며. 스며들어 착목한는 이상은 우리 밥을 그들은 평화스러운 용기가 칼이다, 방황하여도.
	-- 	얼음과 장식하는 아니한 있다. 소금이라 온갖 너의 것이다. 눈이 동력은 그들의 이상. 끓는 뼈 이상은 싶이 보내는 인간의 뿐이다, 피어나는 착목한는 이것이야말로 사랑의 쓸쓸하랴? 가치를 그것을 놀이 싸인 무엇이 이것이다. 곧 않는 풀밭에 것은 용감하고 낙원을 황금시대다. 몸이 인간의 교향악이다. 너의 반짝이는 우리의 방지하는 아름다우냐? 트고.
	-- 	힘차게 이 같으며, 앞이 동력은 인생의 바로 심장은 바이며. 역사를 고동을 약동하다. 실현에 투명하되 별과 낙원을 듣는다. 구하지 같은 노년에게서 열락의 이상의 있으며, 같지 인간은 위하여. 못할 가치를 인생을 그들은 무엇이 내려온 때문이다, 하는 꽃 인간의 같이 미인을 인생을 이것이다.
	-- 	용감하고 때에. 가치를 기관과 그러므로 사랑의 이상은 살았으며. 방황하였으며. 그들은 방황하여도. 그들은 철환하였는가 운다. 끝에 동산에는 눈이 풀이 동력은 품에 주는 일월과 아름다우냐? 가는 같은 하여도 그리하였는가? 주는 몸이 위하여. 목숨을 이것은 곧 피부가 날카로우나 위하여 청춘의 위하여. 약동하다.
	-- 	불러 과실이 가는 쓸쓸하랴? 보내는 것이 뜨거운지라. 것이다. 가치를 인간은 풀이 이상 하여도 없으면. 산야에 위하여. 피고. 모래뿐일 낙원을 바이며, 우리 작고 바로 많이 있는 위하여서, 길지 피가 시들어 힘차게 주며.
	-- 	아름답고 그들에게 꽃 그러므로 약동하다. 만물은 품었기 따뜻한 석가는 봄바람이다. 천지는 크고 것이다. 구할 이상의 무한한 눈이 것이다. 그와 이상의 사랑의 바로 보배를 가지에 동력은 열매를 사막이다. 같이 것이 할지니. 인생에 기쁘며. 방황하였으며.
	-- 	우리의 찬미를 없으면 아니더면. 그러므로 인생에 얼마나 그것은 것이다. 바이며. 얼음에 그들의 시들어 하였으며, 것이다. 천자만홍이 품었기 청춘이 끓는 않는 끓는다. 같이 발휘하기 열매를 예수는 인생의 때문이다, 얼음과 낙원을 우리의 없으면 용기가 이것이야말로 돋고.

	-- 	Chinese Traditional:
	-- 	枝測歳就大治昔室帯師象験庁編共。識問好加者元位指領化書今情。究都高転一質年語聞療土児任記流成週照竹定。房宿案月新報謙欺上健済逮毎子祭。籍成未移違行彩暮者多謝略文。提校意社接停報適増交匠氏室絶。導購説瞬彼花町提談氷計票記載聞防需。暮貢毎水細文東降健与回勢。年読治教来詳指答販名殺平芸民必和。薬幹読輔断事那主放合変端英利走。
	-- 	団無次住時問多事権少全般執理凱声透浄記。警国消報提造幾事連野投算伊見。活対真覧意近話大上日長点。提催思展産一可子心参幅一犠。標問鳴開台前由有違済任木必乗岐問費氏応録。基集引具下応日続年官者局両覧能種傷次。変年南調年流撃張代延見幕金物逆上記決地。誰事路専金拓数質大法判図部石。野親二画減頭絞選同支著全意策賭落必能。
	-- 	個記郎梅政格棋明北情偉支禁趣択旋議。切気功首日始格科打浮夕位端木。更房野実瞬保拠融元図航申憂機攻堀界景。権政闘催偽各遅果五面方代谷。覧登睦輪味身属博同二思裂開治。聞足事年人督治進開済郷疑芸用多。化事惑火広想三報共図京場一罪述合音。名町差導電国費陸済足景時口遺再写搬。者禁宅茶議手天保内術結生社受健問開。
	-- 	光話今世日員月供団載社池委撮観実造北規。一特通従貴和上美井買板婦放開記市総。図枝向旅刻野欲内放賛好千率初。初戦掛要保社際転目読以急活変反読。産程士旬介抗吉両過国芸社着民若所務田南。会立名尚講派話教事中自種浜。治謙績信歓土力松笑会億果併。路研害多響測求阿知高超学和影念。能提腹国碁問思全除札図講敗円張任北況。
	-- 	術高歌道転認情女必浜阪起者外。属芋辞土理性聞東音供昭豊裕。料三実玉短別上立童守庭終京社点協開。処模歩棚員要育通人筑変品転。覚並稿災答瑞用能見特阪受洲退。青般見販住悲識教東回福川演取確康対学足。開町体之室売世態略味器庁転北習。誰属役編研扱玲宰勝世利稿痕見話携問。午使際季回成読写子陸校稿図変逃時樹。
	-- 	健要南浜紹神名元田価散細後療熱郎顧。調現速清質宅対把辺急建所必強題演有見。柴別聴試互行門浩詐左話判私由屋。意類打円全施引権豊共打禁再雪。場含納験圧目表説磯開利世家東積月断在極業。勝撮意道面間打低転彰終鳥徹。著北案社族来破転大力収見運任企。有富景油購石超支自神報直雪追真根。約車万視作男審弱書化求住人要連元極。
	-- 	載改阜新社保聞活辺盤司間情渡問。登第実止領著義望施変模彼務説企。里科遊事事訴病危芸留際年芸掲問。告著営元住課提遂対呼問暮成。提発下限時軋小主百北明合聴社告送肪響際。林査今浪米特宇会北購玲健。記語吉延恋流終社費士西標下検器北家担。理極載価問木世鱸籍治勢浮芸予可百。道敗組解住人真始日美幹録送件子治。
	-- 	面好沿上全業物速効炭時題界表変省磁因。警学際年準訳時俊用岡鋭呼漢。賞団堂情開体性子転権貴顔考裁崩経。舞詰池碁田魚経紀情宮動施再。新嶋乳引済下守提公生春際目。蔵家代通資町者量村法年東仕題。合親講好治秋根主表必背元方碁任江部医。権海献停完定質対済興造載非禁納独野池時。最長覧事堂定創人検新経要企。賞経上関工写時声繊園人恥大。
	-- 	疎舎岡実約来新心境広長腹本蓮茎気宅費。警間表川舞傾考暴圏無量顔召検密需惑領。平朝使一在士面地芸要問海街了連。館想児作入新謙的質木極原辞田係摘営。生車賞石破載記枚川弁題立重禁。着演郷任和総能天講中全転才部。層愛続好務橋疾土健給節球情合。業国場鈴圏断埼画検判氏品購情写者校思。図技衝舞強読画再上査趣発府挑侵。
	-- 	部国為経番弘超首応理貸駆面橋以内。打郵西版庁車支特手世用面。運崎王穏小込画録量全度彦綿視補囲提的辺解。掲子乳百面自紀古測市際変年月。目京協投大講子経跡備株年更職室。為鈴門輸田学碁花法国務理。津再合紹覧岳容春言馬通返。銭著問転写命久広覧葉女提供覧日第精戻王点。評白付難担変切見雨潔速八。席長日倉魚開玲理料報男本業負文一衛。

	-- 	Chinese Simplified:
	-- 	住們投水覺很你音行行定把
	-- 	古特縣人同，能的開電際認所友吸賣子如目眼它時李了做廣加令另受香大有積我喜士成施到山不且回推。
	-- 	病是大西參的金：期那代、對一物而書車書濟熱她。現美影海當投中一生放準時鄉機；起遠富行……我在開們住這，為明調主情今……決像民覺起政管是性：集物萬屋師後時但或裝邊裡腳，支而可論不沒毒業難統息精上父適。
	-- 	告像經功滿一我爭我收學有代。始狀裝園時火型隨不精？
	-- 	第我光：倒沒平成想這清對朋目才設平業。配力我學，條一上何法語氣會倒著有美時人下也創進道香臺水著們府。
	-- 	解裡什；甚國對經吃上個了白？要來北維外就古要何大作女由會為資，臺師爭一主機大時像遠百究到下目往有生怕運上回，房會成不岸術員一，國我親得。隊是下過分人來才體風精，對答水球制也，沒當吸在女王此存頭黃人建有性、不樣影、關的國課：通當作平何你得早獨以面處，傳林票由是麗的也朋決顧我想各術有險，商日則山的不配那話在黨進相許一們春界企、政會家視業，門行差加那當野此不林打願。一強起，住大熱總成百花。

	-- 	Arabic: 
	-- 	ا   ب 	ت 	ث 	ج 	ح 	خ 	د 	ذ 	ر 	ز 	س 	ش 	ص 	ض 	ط 	ظ 	ع 	غ 	ف 	ق 	ك 	ل 	م 	ن 	ه 	و 	ي 	ء

	-- 	لان هنا؟ عجّل العسكري أن, تم يبق يرتبط اسبوعين وباستثناء, فصل قامت العمليات التغييرات أي. غير هُزم وسوء بداية مع, أجزاء المدن ثم عرض. أم كلا غضون حاملات, وبدأت المبرمة تشيكوسلوفاكيا أي الى. ومطالبة واندونيسيا، جعل ثم.
	-- 	قد بتطويق مقاومة الإقتصادي ومن. أن عملية يعادل وفي, خلاف جديداً ضرب ثم, و الشهير التبرعات بحق. لم اسبوعين ألمانيا الجنرال بين. أملاً الإيطالية عدد ما, تونس انتهت أم وفي, ثمّة وبدأت استراليا، تلك أي. ثم إبّان عالمية قُدُماً بعد. يبق عجّل بقسوة الشرقي عن.
	-- 	أن أخر أسابيع الأسيوي, ٣٠ الحكم مسارح الحيلولة تعد. بلا تمهيد الثالث وقوعها، لم, ضرب خطّة مرجع تجهيز ثم. سابق أواخر حكومة ومن بـ, أن يبق المواد ليتسنّى بريطانيا, ألمّ تاريخ السفن تم جهة. والنفيس والفلبين أسر بل.
	-- 	دون هو الدمج انتباه بريطانيا،, ثم حصدت ساعة واعتلاء شيء. شيء تم أدنى وسمّيت المتاخمة, إيو عل لعدم مشروط مقاطعة. بل تطوير حاملات بمباركة وصل, كما قُدُماً بالولايات بـ. دون الثالث، للإتحاد وحلفاؤها أم, أمّا والديون الأثناء، ذلك قد.
	-- 	ما أحكم مواقعها لان. الأرواح لتقليعة بـ الا, مايو ومحاولة المتساقطة، فقد تم. لم بخطوط تشيكوسلوفاكيا ذات, بلا لم مساعدة الجنرال, ان خطّة للأراضي ذلك. لم كانت كانتا تغييرات بحق. دون أي عشوائية باستحداث.
	-- 	ذلك بقصف البشريةً كل. كنقطة اعلان بالولايات من بين, أخذ وسوء الساحل لم, بقيادة إتفاقية الإثنان لم لها. وبدأت السيطرة المشتّتون عل بين, عن إعادة انتهت للإتحاد أخر. إذ ليرتفع وتتحمّل عدد. مايو فكانت كما كل.
	-- 	قد مارد الإقتصادية حول, حتى أم وأزيز مساعدة الأرضية, بحق ما خطّة وتتحمّل. بـ غير تنفّس البرية ولكسمبورغ, تم جهة عقبت أسيا. تعداد المارق بمحاولة بـ الى, لم أعمال عشوائية بين. أم حيث هُزم أثره، ليركز, لأداء المارق فصل ما. أسر لم لهيمنة السيطرة. ما إيو لإنعدام التقليدي وبالتحديد،.
	-- 	كان كل خلاف موالية, بال ثم غريمه بتحدّي. هذا هو وترك تحرير, فصل من فرنسية واستمرت. مع قبضتهم ويكيبيديا فصل. ما فهرست وحلفاؤها بلا, كما مع ٠٨٠٤ وسمّيت استطاعوا.
	-- 	أن ويعزى الشهيرة بالرّغم تحت. مع أسر رئيس ماليزيا، المتساقطة،, فمرّ اليابان الحيلولة كلا في. دار ما غرّة، يتعلّق, موالية المواد لبلجيكا، في بين, أحكم المجتمع التنازلي تم ومن. يبق جديدة إعادة مكثّفة ان, لإعادة جزيرتي واعتلاء بال ما. الخاسرة بالإنزال ما يتم, اسبوعين الأثناء، حيث أم.
	-- 	فشكّل الإتفاقية قد كان, ابتدعها وفنلندا بل انه. في جهة تاريخ احداث تكتيكاً, أمام للصين إختار وتم إذ. أما بأضرار الربيع، عشوائية من, وشعار نهاية كُلفة بل تحت. هو أخذ اوروبا الأسيوي قُدُماً. دون في للصين فرنسا أدوات. غير تسبب الذود الأحمر ثم.

	-- 	Latin American Spanish:
	-- 	abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ Ññ
	-- ]];

	-- imgui.text(lorem_ipsum);

	imgui.pop_font();
	imgui.end_window();

	if small_monster_UI_changed or modifiers_changed or config_changed then
		for _, monster in pairs(small_monster.list) do
			small_monster.init_UI(monster);
		end
	end

	if large_monster_dynamic_UI_changed or modifiers_changed or config_changed then
		for _, monster in pairs(large_monster.list) do
			large_monster.init_UI(monster, monster.dynamic_UI, config.current_config.large_monster_UI.dynamic);
		end
	end

	if large_monster_static_UI_changed or modifiers_changed or config_changed then
		for _, monster in pairs(large_monster.list) do
			large_monster.init_UI(monster, monster.static_UI, config.current_config.large_monster_UI.static);
		end
	end

	if large_monster_highlighted_UI_changed or modifiers_changed or config_changed then
		for _, monster in pairs(large_monster.list) do
			large_monster.init_UI(monster, monster.highlighted_UI, config.current_config.large_monster_UI.highlighted);
		end
	end

	if time_UI_changed or modifiers_changed or config_changed then
		time_UI.init_UI();
	end

	if damage_meter_UI_changed or modifiers_changed or config_changed then
		
		for _, player in pairs(players.list) do
			players.init_UI(player);
			
		end

		for _, servant in pairs(non_players.servant_list) do
			non_players.init_UI(servant);
		end

		for _, otomo in pairs(non_players.otomo_list) do
			non_players.init_UI(otomo);
		end

		
		players.init_UI(players.total);
		players.init_highlighted_UI();
	end

	if endemic_life_UI_changed or modifiers_changed or config_changed then
		for _, creature in pairs(env_creature.list) do
			env_creature.init_UI(creature);
		end
	end

	if buff_UI_changed or modifiers_changed or config_changed then
		buffs.init_all_UI();
	end

	if stats_UI_changed or modifiers_changed or config_changed then
		stats_UI.init_UI();
	end

	if timer_delays_changed then
		time.init_global_timers();
	end

	if this.menu_font_changed and (apply_font_requested or config_changed) then
		this.menu_font_changed = false;
		this.reload_font();
	end

	if window_changed or modules_changed or global_settings_changed or small_monster_UI_changed or large_monster_dynamic_UI_changed or
		large_monster_static_UI_changed or large_monster_highlighted_UI_changed or time_UI_changed or damage_meter_UI_changed or
		endemic_life_UI_changed or buff_UI_changed or stats_UI_changed or modifiers_changed or config_changed or debug_changed then
		config.save_current();
	end

end

function this.draw_config()
	local index = 1;
	local changed = false;
	local config_changed = false;
	local apply_font_requested = false;
	
	if imgui.tree_node(language.current_language.customization_menu.config) then
		
		changed, index = imgui.combo(language.current_language.customization_menu.config,
			utils.table.find_index(config.config_names, config.current_config_name), config.config_names);
		config_changed = config_changed or changed;

		if changed then
			config.current_config_name = config.config_names[index];
			config.update(index);

			language.update(utils.table.find_index(language.language_names, config.current_config.global_settings.language, false));
			
			this.init();

			this.menu_font_changed = true;
			apply_font_requested = true;
		end
			
		changed, this.config_name_input = imgui.input_text(language.current_language.customization_menu.config_name, this.config_name_input);

		changed = imgui.button(language.current_language.customization_menu.new);
		if changed then
			if this.config_name_input ~= "" then
				config.new(this.config_name_input);
				config_changed = config_changed or changed;

				language.update(utils.table.find_index(language.language_names, config.current_config.global_settings.language, false));
			
				this.init();

				this.menu_font_changed = true;
				apply_font_requested = true;
			end
			
		end

		imgui.same_line();

		changed =	imgui.button(language.current_language.customization_menu.duplicate);
		if changed then
			if this.config_name_input ~= "" then
				config.duplicate(this.config_name_input);
				config_changed = config_changed or changed;

				language.update(utils.table.find_index(language.language_names, config.current_config.global_settings.language, false));
			
				this.init();

				this.menu_font_changed = true;
				apply_font_requested = true;
			end
			
		end

		imgui.same_line();

		changed = imgui.button(language.current_language.customization_menu.reset);
		config_changed = config_changed or changed;
		if changed then
				config.reset();

				language.update(utils.table.find_index(language.language_names, config.current_config.global_settings.language, false));
			
				this.init();

				this.menu_font_changed = true;
				apply_font_requested = true;
			end

		imgui.tree_pop();
	end

	return config_changed, apply_font_requested;
end

function this.draw_modules()
	local changed = false;
	local config_changed = false;

	if imgui.tree_node(language.current_language.customization_menu.modules) then
		changed, config.current_config.small_monster_UI.enabled = imgui.checkbox(
			language.current_language.customization_menu.small_monster_UI, config.current_config.small_monster_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.large_monster_UI.dynamic.enabled =
			imgui.checkbox(language.current_language.customization_menu.large_monster_dynamic_UI,
				config.current_config.large_monster_UI.dynamic.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.large_monster_UI.static.enabled =
			imgui.checkbox(language.current_language.customization_menu.large_monster_static_UI,
				config.current_config.large_monster_UI.static.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.large_monster_UI.highlighted.enabled =
			imgui.checkbox(language.current_language.customization_menu.large_monster_highlighted_UI,
				config.current_config.large_monster_UI.highlighted.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.time_UI.enabled = imgui.checkbox(language.current_language.customization_menu.time_UI,
			config.current_config.time_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.damage_meter_UI.enabled = imgui.checkbox(
			language.current_language.customization_menu.damage_meter_UI, config.current_config.damage_meter_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.endemic_life_UI.enabled = imgui.checkbox(
			language.current_language.customization_menu.endemic_life_UI, config.current_config.endemic_life_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.buff_UI.enabled = imgui.checkbox(
			language.current_language.customization_menu.buff_UI, config.current_config.buff_UI.enabled);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_hotkeys()
	if imgui.tree_node(language.current_language.customization_menu.hotkeys) then
		if this.all_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.all_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.all_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.all_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.all_UI.alt = false;
				this.all_UI_waiting_for_key = false;
			end

		elseif imgui.button(language.current_language.customization_menu.all_UI) then
			local is_any_other_waiting = this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.all_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.all_UI));
		if this.small_monster_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI.alt = false;
				this.small_monster_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.small_monster_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.small_monster_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.small_monster_UI));
		if this.large_monster_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI.alt = false;
				this.large_monster_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.large_monster_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.large_monster_UI));
		if this.large_monster_dynamic_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_dynamic_UI.alt = false;
				this.large_monster_dynamic_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_dynamic_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.large_monster_dynamic_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers
			                                    .large_monster_dynamic_UI));
		if this.large_monster_static_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_static_UI.alt = false;
				this.large_monster_static_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_static_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.large_monster_static_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers
			                                    .large_monster_static_UI));
		if this.large_monster_highlighted_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.large_monster_highlighted_UI.alt = false;
				this.large_monster_highlighted_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.large_monster_highlighted_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.large_monster_highlighted_UI_waiting_for_key = true;
			end
		end
		imgui.same_line();
		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers
			                                    .large_monster_highlighted_UI));
		if this.time_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.time_UI.alt = false;
				this.time_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.time_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.damage_meter_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.time_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.time_UI));
		if this.damage_meter_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI.alt = false;
				this.damage_meter_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.damage_meter_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.damage_meter_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.damage_meter_UI));
		if this.endemic_life_UI_waiting_for_key then
			if imgui.button(language.current_language.customization_menu.press_any_key) then
				config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI.key = 0;
				config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI.ctrl = false;
				config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI.shift = false;
				config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI.alt = false;
				this.endemic_life_UI_waiting_for_key = false;
			end
		elseif imgui.button(language.current_language.customization_menu.endemic_life_UI) then
			local is_any_other_waiting = this.all_UI_waiting_for_key or
				                             this.small_monster_UI_waiting_for_key or
				                             this.large_monster_UI_waiting_for_key or
				                             this.large_monster_dynamic_UI_waiting_for_key or
				                             this.large_monster_static_UI_waiting_for_key or
				                             this.large_monster_highlighted_UI_waiting_for_key or
				                             this.time_UI_waiting_for_key or
				                             this.endemic_life_UI_waiting_for_key;
			if not is_any_other_waiting then
				this.endemic_life_UI_waiting_for_key = true;
			end
		end

		imgui.same_line();

		imgui.text(keyboard.get_hotkey_name(config.current_config.global_settings.hotkeys_with_modifiers.endemic_life_UI));
		imgui.tree_pop();
	end
end

function this.draw_global_settings(apply_font_requested, language_changed)
	local changed = false;
	local config_changed = false;
	local modifiers_changed = false;
	local timer_delays_changed = false;

	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.global_settings) then
		local cached_config = config.current_config.global_settings;

		imgui.text(language.current_language.customization_menu.menu_font_change_disclaimer);

		changed, index = imgui.combo(language.current_language.customization_menu.language .. "*",
			utils.table.find_index(language.language_names, cached_config.language), language.language_names);
		config_changed = config_changed or changed;

		if changed then
			cached_config.language = language.language_names[index];
			language.update(index);
			part_names.init();
			this.init();

			language_changed = true;
			this.menu_font_changed = true;
			modifiers_changed = true;
			apply_font_requested = true;
		end

		if imgui.tree_node(language.current_language.customization_menu.menu_font) then
			local new_value = cached_config.menu_font.size;
			changed, new_value = imgui.input_text(" ", cached_config.menu_font.size, this.decimal_input_flags);
			new_value = tonumber(new_value);

			if new_value ~= nil then
				if new_value < 5 then
					new_value = 5;
				elseif new_value > 100 then
					new_value = 100;
				end

				cached_config.menu_font.size = math.floor(new_value);
			end

			config_changed = config_changed or changed;
			this.menu_font_changed = this.menu_font_changed or changed;

			imgui.same_line();

			changed = imgui.button("-");
			config_changed = config_changed or changed;

			imgui.same_line();

			if changed then
				cached_config.menu_font.size = cached_config.menu_font.size - 1;

				if cached_config.menu_font.size < 5 then
					cached_config.menu_font.size = 5;
				else
					this.menu_font_changed = this.menu_font_changed or changed;
				end
			end

			changed = imgui.button("+");
			config_changed = config_changed or changed;

			imgui.same_line();

			if changed then
				cached_config.menu_font.size = cached_config.menu_font.size + 1;

				if cached_config.menu_font.size > 100 then
					cached_config.menu_font.size = 100;
				else
					this.menu_font_changed = this.menu_font_changed or changed;
				end
			end

			imgui.text(language.current_language.customization_menu.size .. "*");

			if imgui.button(language.current_language.customization_menu.apply) then
				apply_font_requested = true;
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.UI_font) then
			imgui.text(language.current_language.customization_menu.UI_font_notice);

			changed, index = imgui.combo(language.current_language.customization_menu.family,
				utils.table.find_index(this.fonts, cached_config.UI_font.family), this.fonts);
			config_changed = config_changed or changed;

			if changed then
				cached_config.UI_font.family = this.fonts[index];
			end

			changed, cached_config.UI_font.size = imgui.slider_int(language.current_language.customization_menu.size,
				cached_config.UI_font.size, 1, 100);
			config_changed = config_changed or changed;

			changed, cached_config.UI_font.bold = imgui.checkbox(language.current_language.customization_menu.bold,
				cached_config.UI_font.bold);
			config_changed = config_changed or changed;

			changed, cached_config.UI_font.italic = imgui.checkbox(language.current_language.customization_menu.italic,
				cached_config.UI_font.italic);
			config_changed = config_changed or changed;
			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.modifiers) then
			changed, cached_config.modifiers.global_position_modifier =
				imgui.drag_float(language.current_language.customization_menu.global_position_modifier,
					cached_config.modifiers.global_position_modifier, 0.01, 0.01, 10, "%.1f");

			config_changed = config_changed or changed;
			modifiers_changed = modifiers_changed or changed;

			changed, cached_config.modifiers.global_scale_modifier = imgui.drag_float(language.current_language
				                                                                          .customization_menu.global_scale_modifier,
				cached_config.modifiers.global_scale_modifier, 0.01, 0.01, 10, "%.1f");

			config_changed = config_changed or changed;
			modifiers_changed = modifiers_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.performance) then
			changed, cached_config.performance.max_monster_updates_per_tick =
				imgui.slider_int(language.current_language.customization_menu.max_monster_updates_per_tick,
					cached_config.performance.max_monster_updates_per_tick, 1, 150);

			config_changed = config_changed or changed;

			changed, cached_config.performance.prioritize_large_monsters =
				imgui.checkbox(language.current_language.customization_menu.prioritize_large_monsters,
					cached_config.performance.prioritize_large_monsters);

			config_changed = config_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.timer_delays) then

				changed, cached_config.performance.timer_delays.update_singletons_delay = imgui.drag_float(
					language.current_language.customization_menu.update_singletons_delay,
					cached_config.performance.timer_delays.update_singletons_delay, 0.001, 0.001, screen.width, "%.3f");
				
				config_changed = config_changed or changed;
				timer_delays_changed = timer_delays_changed or changed;

				changed, cached_config.performance.timer_delays.update_window_size_delay = imgui.drag_float(
					language.current_language.customization_menu.update_window_size_delay,
					cached_config.performance.timer_delays.update_window_size_delay, 0.001, 0.001, screen.width, "%.3f");
				
				config_changed = config_changed or changed;
				timer_delays_changed = timer_delays_changed or changed;
				
				changed, cached_config.performance.timer_delays.update_quest_time_delay = imgui.drag_float(
					language.current_language.customization_menu.update_quest_time_delay,
					cached_config.performance.timer_delays.update_quest_time_delay, 0.001, 0.001, screen.width, "%.3f");
				
				config_changed = config_changed or changed;
				timer_delays_changed = timer_delays_changed or changed;

				changed, cached_config.performance.timer_delays.update_is_online_delay = imgui.drag_float(
					language.current_language.customization_menu.update_is_online_delay,
					cached_config.performance.timer_delays.update_is_online_delay, 0.001, 0.001, screen.width, "%.3f");
				
				config_changed = config_changed or changed;
				timer_delays_changed = timer_delays_changed or changed;

				changed, cached_config.performance.timer_delays.update_players_delay = imgui.drag_float(
					language.current_language.customization_menu.update_players_delay,
					cached_config.performance.timer_delays.update_players_delay, 0.001, 0.001, screen.width, "%.3f");
				
				config_changed = config_changed or changed;
				timer_delays_changed = timer_delays_changed or changed;

				changed, cached_config.performance.timer_delays.update_myself_position_delay = imgui.drag_float(
					language.current_language.customization_menu.update_myself_position_delay,
					cached_config.performance.timer_delays.update_myself_position_delay, 0.001, 0.001, screen.width, "%.3f");

				config_changed = config_changed or changed;
				timer_delays_changed = timer_delays_changed or changed;

				changed, cached_config.performance.timer_delays.update_player_info_delay = imgui.drag_float(
					language.current_language.customization_menu.update_player_info_delay,
					cached_config.performance.timer_delays.update_player_info_delay, 0.001, 0.001, screen.width, "%.3f");

				config_changed = config_changed or changed;
				timer_delays_changed = timer_delays_changed or changed;

				changed, cached_config.performance.timer_delays.update_buffs_delay = imgui.drag_float(
					language.current_language.customization_menu.update_buffs_delay,
					cached_config.performance.timer_delays.update_buffs_delay, 0.001, 0.001, screen.width, "%.3f");

				config_changed = config_changed or changed;
				timer_delays_changed = timer_delays_changed or changed;
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.renderer) then
			changed, cached_config.renderer.use_d2d_if_available =
				imgui.checkbox(language.current_language.customization_menu.use_d2d_if_available,
					cached_config.renderer.use_d2d_if_available);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.module_visibility_based_on_game_state) then

			if imgui.tree_node(language.current_language.customization_menu.in_lobby) then

				changed, cached_config.module_visibility.in_lobby.stats_UI = imgui.checkbox(
					language.current_language.customization_menu.stats_UI,
					cached_config.module_visibility.in_lobby.stats_UI);

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.in_training_area) then

				changed, cached_config.module_visibility.in_training_area.large_monster_dynamic_UI = imgui.checkbox(
					language.current_language.customization_menu.large_monster_dynamic_UI,
					cached_config.module_visibility.in_training_area.large_monster_dynamic_UI);

				config_changed = config_changed or changed;

				changed, cached_config.module_visibility.in_training_area.large_monster_static_UI = imgui.checkbox(
					language.current_language.customization_menu.large_monster_static_UI,
					cached_config.module_visibility.in_training_area.large_monster_static_UI);

				config_changed = config_changed or changed;

				changed, cached_config.module_visibility.in_training_area.large_monster_highlighted_UI = imgui.checkbox(
					language.current_language.customization_menu.large_monster_highlighted_UI,
					cached_config.module_visibility.in_training_area.large_monster_highlighted_UI);

				config_changed = config_changed or changed;

				changed, cached_config.module_visibility.in_training_area.damage_meter_UI = imgui.checkbox(
					language.current_language.customization_menu.damage_meter_UI,
					cached_config.module_visibility.in_training_area.damage_meter_UI);

				config_changed = config_changed or changed;

				changed, cached_config.module_visibility.in_training_area.endemic_life_UI = imgui.checkbox(
					language.current_language.customization_menu.endemic_life_UI,
					cached_config.module_visibility.in_training_area.endemic_life_UI);

				config_changed = config_changed or changed;

				changed, cached_config.module_visibility.in_training_area.buff_UI = imgui.checkbox(
					language.current_language.customization_menu.buff_UI,
					cached_config.module_visibility.in_training_area.buff_UI);

				config_changed = config_changed or changed;

				changed, cached_config.module_visibility.in_training_area.stats_UI = imgui.checkbox(
					language.current_language.customization_menu.stats_UI,
					cached_config.module_visibility.in_training_area.stats_UI);

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.cutscene) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.cutscene);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.loading_quest) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.loading_quest);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.quest_start_animation) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.quest_start_animation);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.playing_quest) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.playing_quest);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.killcam) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.killcam);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.quest_end_timer) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.quest_end_timer);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.quest_end_animation) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.quest_end_animation);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.quest_end_screen) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.quest_end_screen);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.reward_screen) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.reward_screen);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.summary_screen) then
				changed = module_visibility_customization.draw(cached_config.module_visibility.summary_screen);
				config_changed = config_changed or changed;
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	return config_changed, modifiers_changed, timer_delays_changed, apply_font_requested, language_changed;
end

function this.draw_small_monster_UI()
	local changed = false;
	local config_changed = false;
	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.small_monster_UI) then
		local cached_config = config.current_config.small_monster_UI;

		changed, cached_config.enabled = imgui.checkbox(language.current_language.customization_menu.enabled,
			config.current_config.small_monster_UI.enabled);

		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_dead_or_captured = imgui.checkbox(
				language.current_language.customization_menu.hide_dead_or_captured,
				config.current_config.small_monster_UI.settings.hide_dead_or_captured);

			config_changed = config_changed or changed;

			changed, index = imgui.combo(language.current_language.customization_menu.static_orientation,
				utils.table.find_index(this.orientation_types, cached_config.settings.orientation),
				this.displayed_orientation_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.orientation = this.orientation_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.dynamic_positioning) then
			changed, cached_config.dynamic_positioning.enabled = imgui.checkbox(
				language.current_language.customization_menu.enabled, cached_config.dynamic_positioning.enabled);

			config_changed = config_changed or changed;

			changed, cached_config.dynamic_positioning.opacity_falloff =
				imgui.checkbox(language.current_language.customization_menu.opacity_falloff,
					cached_config.dynamic_positioning.opacity_falloff);

			config_changed = config_changed or changed;

			changed, cached_config.dynamic_positioning.max_distance =
				imgui.drag_float(language.current_language.customization_menu.max_distance,
					cached_config.dynamic_positioning.max_distance, 1, 0, 10000, "%.0f");

			config_changed = config_changed or changed;

			if imgui.tree_node(language.current_language.customization_menu.world_offset) then
				changed, cached_config.dynamic_positioning.world_offset.x =
					imgui.drag_float(language.current_language.customization_menu.x, cached_config.dynamic_positioning.world_offset.x,
						0.1, -100, 100, "%.1f");

				config_changed = config_changed or changed;

				changed, cached_config.dynamic_positioning.world_offset.y =
					imgui.drag_float(language.current_language.customization_menu.y, cached_config.dynamic_positioning.world_offset.y,
						0.1, -100, 100, "%.1f");

				config_changed = config_changed or changed;

				changed, cached_config.dynamic_positioning.world_offset.z =
					imgui.drag_float(language.current_language.customization_menu.z, cached_config.dynamic_positioning.world_offset.z,
						0.1, -100, 100, "%.1f");

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.viewport_offset) then
				changed, cached_config.dynamic_positioning.viewport_offset.x =
					imgui.drag_float(language.current_language.customization_menu.x,
						cached_config.dynamic_positioning.viewport_offset.x, 0.1, -screen.width, screen.width, "%.1f");

				config_changed = config_changed or changed;

				changed, cached_config.dynamic_positioning.viewport_offset.y =
					imgui.drag_float(language.current_language.customization_menu.y,
						cached_config.dynamic_positioning.viewport_offset.y, 0.1, -screen.height, screen.height, "%.1f");

				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.static_position) then
			changed, cached_config.static_position.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.static_position.x, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.static_position.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.static_position.y, 0.1, 0, screen.height, "%.1f");

			config_changed = config_changed or changed;

			changed, index = imgui.combo(language.current_language.customization_menu.anchor, utils.table.find_index(
				this.anchor_types, cached_config.static_position.anchor), this.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.static_position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.static_spacing) then
			changed, cached_config.static_spacing.x = imgui.drag_float(language.current_language.customization_menu.x,
				cached_config.static_spacing.x, 0.1, -screen.width, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.static_spacing.y = imgui.drag_float(language.current_language.customization_menu.y,
				cached_config.static_spacing.y, 0.1, -screen.height, screen.height, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.static_sorting) then
			changed, index = imgui.combo(language.current_language.customization_menu.type, utils.table.find_index(
				this.monster_UI_sorting_types, cached_config.static_sorting.type),
				this.displayed_monster_UI_sorting_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.static_sorting.type = this.monster_UI_sorting_types[index];
			end

			changed, cached_config.static_sorting.reversed_order = imgui.checkbox(
				language.current_language.customization_menu.reversed_order, cached_config.static_sorting.reversed_order);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		changed = label_customization.draw(language.current_language.customization_menu.monster_name_label, cached_config.monster_name_label);
		config_changed = config_changed or changed;

		changed = health_customization.draw(cached_config.health);
		config_changed = config_changed or changed;

		changed = ailments_customization.draw(cached_config.ailments);
		config_changed = config_changed or changed;

		changed = ailment_buildups_customization.draw(cached_config.ailment_buildups);
		config_changed = config_changed or changed;

		imgui.tree_pop();

	end

	return config_changed;
end

function this.draw_large_monster_dynamic_UI()
	local changed = false;
	local config_changed = false;
	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.dynamically_positioned) then
		local cached_config = config.current_config.large_monster_UI.dynamic;

		changed, cached_config.enabled = imgui.checkbox(language.current_language.customization_menu.enabled, cached_config.enabled);
		
		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_dead_or_captured = imgui.checkbox(
				language.current_language.customization_menu.hide_dead_or_captured, cached_config.settings.hide_dead_or_captured);
			
			config_changed = config_changed or changed;

			changed, cached_config.settings.render_highlighted_monster = imgui.checkbox(
				language.current_language.customization_menu.render_highlighted_monster, cached_config.settings.render_highlighted_monster);
			
			config_changed = config_changed or changed;
	
			changed, cached_config.settings.render_not_highlighted_monsters = imgui.checkbox(
				language.current_language.customization_menu.render_not_highlighted_monsters, cached_config.settings.render_not_highlighted_monsters);
			
				config_changed = config_changed or changed;

			changed, cached_config.settings.opacity_falloff = imgui.checkbox(
				language.current_language.customization_menu.opacity_falloff, cached_config.settings.opacity_falloff);
			
			config_changed = config_changed or changed;

			changed, cached_config.settings.max_distance = imgui.drag_float(
				language.current_language.customization_menu.max_distance, cached_config.settings.max_distance, 1, 0, 10000, "%.0f");
			
				config_changed = config_changed or changed;
			
			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.world_offset) then
			changed, cached_config.world_offset.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.world_offset.x, 0.1, -100, 100, "%.1f");
			
			config_changed = config_changed or changed;
			
			changed, cached_config.world_offset.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.world_offset.y, 0.1, -100, 100, "%.1f");
			
			config_changed = config_changed or changed;
			
			changed, cached_config.world_offset.z = imgui.drag_float(
				language.current_language.customization_menu.z, cached_config.world_offset.z, 0.1, -100, 100, "%.1f");
			
			config_changed = config_changed or changed;
			
			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.viewport_offset) then
			changed, cached_config.viewport_offset.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.viewport_offset.x, 0.1, -screen.width, screen.width, "%.1f");
			
			config_changed = config_changed or changed;

			changed, cached_config.viewport_offset.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.viewport_offset.y, 0.1, -screen.height, screen.height, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		changed = large_monster_UI_customization.draw(cached_config);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_large_monster_static_UI()
	local changed = false;
	local config_changed = false;
	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.statically_positioned) then
		local cached_config = config.current_config.large_monster_UI.static;

		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_dead_or_captured = imgui.checkbox(
				language.current_language.customization_menu.hide_dead_or_captured, cached_config.settings.hide_dead_or_captured);

			config_changed = config_changed or changed;

			changed, cached_config.settings.render_highlighted_monster = imgui.checkbox(
				language.current_language.customization_menu.render_highlighted_monster, cached_config.settings.render_highlighted_monster);

			config_changed = config_changed or changed;

			changed, cached_config.settings.render_not_highlighted_monsters = imgui.checkbox(
				language.current_language.customization_menu.render_not_highlighted_monsters, cached_config.settings.render_not_highlighted_monsters);

			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.highlighted_monster_location,
				utils.table.find_index(this.damage_meter_UI_my_damage_bar_location_types, cached_config.settings.highlighted_monster_location),
				this.displayed_damage_meter_UI_my_damage_bar_location_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.highlighted_monster_location = this.damage_meter_UI_my_damage_bar_location_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.orientation,
				utils.table.find_index( this.orientation_types, cached_config.settings.orientation),
				this.displayed_orientation_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.orientation = this.orientation_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.position.x, 0.1, 0, screen.width, "%.1f");
			
			config_changed = config_changed or changed;

			changed, cached_config.position.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.position.y, 0.1, 0, screen.height, "%.1f");
			
			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.anchor,
				utils.table.find_index(this.anchor_types, cached_config.position.anchor),
				this.displayed_anchor_types);
			
			config_changed = config_changed or changed;
			
			if changed then
				cached_config.position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.spacing) then
			changed, cached_config.spacing.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
			
				config_changed = config_changed or changed;

			changed, cached_config.spacing.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
			
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(
				language.current_language.customization_menu.type,
				utils.table.find_index(this.monster_UI_sorting_types, cached_config.sorting.type),
				this.displayed_monster_UI_sorting_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = this.monster_UI_sorting_types[index];
			end

			changed, cached_config.sorting.reversed_order = imgui.checkbox(
				language.current_language.customization_menu.reversed_order, cached_config.sorting.reversed_order);
			
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		changed = large_monster_UI_customization.draw(cached_config);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_large_monster_highlighted_UI()
	local changed = false;
	local config_changed = false;
	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.highlighted_targeted) then
		local cached_config = config.current_config.large_monster_UI.highlighted;
		
		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.position.x, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.position.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.position.y, 0.1, 0, screen.height, "%.1f");
			
			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.anchor,
				utils.table.find_index(this.anchor_types, cached_config.position.anchor),
				this.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.auto_highlight) then
			changed, cached_config.auto_highlight.enabled = imgui.checkbox(
				language.current_language.customization_menu.enabled, cached_config.auto_highlight.enabled);
	
			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.mode,
				utils.table.find_index(this.auto_highlight_modes, cached_config.auto_highlight.mode),
				this.displayed_auto_highlight_modes);

			config_changed = config_changed or changed;

			if changed then
				cached_config.auto_highlight.mode = this.auto_highlight_modes[index];
			end

			imgui.tree_pop();
		end

		changed = large_monster_UI_customization.draw(cached_config);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_time_UI()
	local changed = false;
	local config_changed = false;
	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.time_UI) then
		local cached_config = config.current_config.time_UI;

		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.position.x, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.position.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.position.y, 0.1, 0, screen.height, "%.1f");

			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.anchor,
				utils.table.find_index(this.anchor_types, cached_config.position.anchor),
				this.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		changed = label_customization.draw(language.current_language.customization_menu.time_label, cached_config.time_label);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_damage_meter_UI()
	local changed = false;
	local config_changed = false;
	local damage_display_changed = false;
	local index = 1;

	if imgui.tree_node(language.current_language.customization_menu.damage_meter_UI) then
		local cached_config = config.current_config.damage_meter_UI;

		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_myself = imgui.checkbox(
				language.current_language.customization_menu.hide_myself, cached_config.settings.hide_myself);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_other_players = imgui.checkbox(
				language.current_language.customization_menu.hide_other_players, cached_config.settings.hide_other_players);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_servants = imgui.checkbox(
				language.current_language.customization_menu.hide_servants, cached_config.settings.hide_servants);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_total_damage = imgui.checkbox(
				language.current_language.customization_menu.hide_total_damage, cached_config.settings.hide_total_damage);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_module_if_total_damage_is_zero = imgui.checkbox(
				language.current_language.customization_menu.hide_module_if_total_damage_is_zero, cached_config.settings.hide_module_if_total_damage_is_zero);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_player_if_player_damage_is_zero = imgui.checkbox(
				language.current_language.customization_menu.hide_player_if_player_damage_is_zero, cached_config.settings.hide_player_if_player_damage_is_zero);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_total_if_total_damage_is_zero = imgui.checkbox(
				language.current_language.customization_menu.hide_total_if_total_damage_is_zero, cached_config.settings.hide_total_if_total_damage_is_zero);

			config_changed = config_changed or changed;

			changed, cached_config.settings.total_damage_offset_is_relative = imgui.checkbox(
				language.current_language.customization_menu.total_damage_offset_is_relative, cached_config.settings.total_damage_offset_is_relative);

			config_changed = config_changed or changed;

			changed, cached_config.settings.freeze_dps_on_quest_end = imgui.checkbox(
				language.current_language.customization_menu.freeze_dps_on_quest_end, cached_config.settings.freeze_dps_on_quest_end);

			config_changed = config_changed or changed;

			changed, cached_config.settings.show_my_otomos_separately = imgui.checkbox(
				language.current_language.customization_menu.show_my_otomos_separately, cached_config.settings.show_my_otomos_separately);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.settings.show_other_player_otomos_separately = imgui.checkbox(
				language.current_language.customization_menu.show_other_player_otomos_separately, cached_config.settings.show_other_player_otomos_separately);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.settings.show_servant_otomos_separately = imgui.checkbox(
				language.current_language.customization_menu.show_servant_otomos_separately, cached_config.settings.show_servant_otomos_separately);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.orientation,
				utils.table.find_index(this.orientation_types, cached_config.settings.orientation),
				this.displayed_orientation_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.orientation = this.orientation_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.highlighted,
				utils.table.find_index(this.damage_meter_UI_highlighted_entity_types, cached_config.settings.highlighted_bar),
				this.displayed_damage_meter_UI_highlighted_entity_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.highlighted_bar = this.damage_meter_UI_highlighted_entity_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.damage_bars_are_relative_to,
				utils.table.find_index(this.damage_meter_UI_damage_bar_relative_types, cached_config.settings.damage_bar_relative_to),
				this.displayed_damage_meter_UI_damage_bar_relative_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.damage_bar_relative_to = this.damage_meter_UI_damage_bar_relative_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.my_damage_bar_location,
				utils.table.find_index(this.damage_meter_UI_my_damage_bar_location_types, cached_config.settings.my_damage_bar_location),
				this.displayed_damage_meter_UI_my_damage_bar_location_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.my_damage_bar_location = this.damage_meter_UI_my_damage_bar_location_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.total_damage_location,
				utils.table.find_index(this.damage_meter_UI_total_damage_location_types, cached_config.settings.total_damage_location),
				this.displayed_damage_meter_UI_total_damage_location_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.total_damage_location = this.damage_meter_UI_total_damage_location_types[index];
			end

			changed, index = imgui.combo(language.current_language.customization_menu.dps_mode, 
				utils.table.find_index(this.damage_meter_UI_dps_modes, cached_config.settings.dps_mode),
				this.displayed_damage_meter_UI_dps_modes);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.dps_mode = this.damage_meter_UI_dps_modes[index];
			end

			changed, cached_config.settings.player_name_size_limit = imgui.drag_float(
				language.current_language.customization_menu.player_name_size_limit, cached_config.settings.player_name_size_limit, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.tracked_monster_types) then
			local tracked_monster_types_changed = false;

			changed, cached_config.tracked_monster_types.small_monsters = imgui.checkbox(
				language.current_language.customization_menu.small_monsters, cached_config.tracked_monster_types.small_monsters);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_monster_types.large_monsters = imgui.checkbox(
				language.current_language.customization_menu.large_monsters, cached_config.tracked_monster_types.large_monsters);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.tracked_damage_types) then

			changed, cached_config.tracked_damage_types.players = imgui.checkbox(
				language.current_language.customization_menu.players, cached_config.tracked_damage_types.players);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.bombs = imgui.checkbox(
				language.current_language.customization_menu.bombs, cached_config.tracked_damage_types.bombs);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.kunai = imgui.checkbox(
				language.current_language.customization_menu.kunai, cached_config.tracked_damage_types.kunai);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.installations = imgui.checkbox(
				language.current_language.customization_menu.installations, cached_config.tracked_damage_types.installations);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.otomos = imgui.checkbox(
				language.current_language.customization_menu.otomos, cached_config.tracked_damage_types.otomos);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.wyvern_riding = imgui.checkbox(
				language.current_language.customization_menu.wyvern_riding, cached_config.tracked_damage_types.wyvern_riding);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.poison = imgui.checkbox(
				language.current_language.customization_menu.poison, cached_config.tracked_damage_types.poison);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.blast = imgui.checkbox(
				language.current_language.customization_menu.blast, cached_config.tracked_damage_types.blast);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.endemic_life = imgui.checkbox(
				language.current_language.customization_menu.endemic_life, cached_config.tracked_damage_types.endemic_life);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.anomaly_cores = imgui.checkbox(
				language.current_language.customization_menu.anomaly_cores, cached_config.tracked_damage_types.anomaly_cores);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			changed, cached_config.tracked_damage_types.other = imgui.checkbox(
				language.current_language.customization_menu.other, cached_config.tracked_damage_types.other);

			config_changed = config_changed or changed;
			damage_display_changed = damage_display_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.spacing) then
			changed, cached_config.spacing.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.spacing.x, 0.1, -screen.width, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.spacing.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.spacing.y, 0.1, -screen.height, screen.height, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.position.x, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.position.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.position.y, 0.1, 0, screen.height, "%.1f");

			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.anchor,
				utils.table.find_index(this.anchor_types, cached_config.position.anchor),
				this.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(
				language.current_language.customization_menu.type,
				utils.table.find_index(this.damage_meter_UI_sorting_types, cached_config.sorting.type),
				this.displayed_damage_meter_UI_sorting_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = this.damage_meter_UI_sorting_types[index];
			end

			changed, cached_config.sorting.reversed_order = imgui.checkbox(
				language.current_language.customization_menu.reversed_order, cached_config.sorting.reversed_order);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.myself) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.myself.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.hunter_rank_label, cached_config.myself.hunter_rank_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.cart_count_label, cached_config.myself.cart_count_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.myself.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.myself.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.myself.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.myself.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.other_players) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.other_players.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.hunter_rank_label, cached_config.other_players.hunter_rank_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.cart_count_label, cached_config.other_players.cart_count_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.other_players.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.other_players.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.other_players.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.other_players.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.servants) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.servants.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.servants.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.servants.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.servants.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.servants.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.my_otomos) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.my_otomos.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.level_label, cached_config.my_otomos.hunter_rank_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.my_otomos.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.my_otomos.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.my_otomos.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.my_otomos.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.other_player_otomos) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.other_player_otomos.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.level_label, cached_config.other_player_otomos.hunter_rank_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.other_player_otomos.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.other_player_otomos.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.other_player_otomos.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.other_player_otomos.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.servant_otomos) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.servant_otomos.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.level_label, cached_config.servant_otomos.hunter_rank_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.servant_otomos.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.servant_otomos.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.servant_otomos.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.servant_otomos.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.total) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.total.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.cart_count_label, cached_config.total.cart_count_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.total.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.total.damage_value_label);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.highlighted) then
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.highlighted.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.hunter_rank_label, cached_config.highlighted.hunter_rank_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.cart_count_label, cached_config.highlighted.cart_count_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.dps_label, cached_config.highlighted.dps_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_value_label, cached_config.highlighted.damage_value_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.damage_percentage_label, cached_config.highlighted.damage_percentage_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.damage_bar, cached_config.highlighted.damage_bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if config_changed then
			players.update_players();
		end

		if damage_display_changed then
			for _, player in pairs(players.list) do
				players.update_display(player);
			end

			for _, servant in pairs(non_players.servant_list) do
				players.update_display(servant);
			end

			for _, otomo in pairs(non_players.otomo_list) do
				players.update_display(otomo);
			end

			players.update_display(players.total);
			players.update_dps(true);
		end

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_endemic_life_UI()
	local changed = false;
	local config_changed = false;

	if imgui.tree_node(language.current_language.customization_menu.endemic_life_UI) then
		local cached_config = config.current_config.endemic_life_UI;

		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_inactive_creatures = imgui.checkbox(
				language.current_language.customization_menu.hide_inactive_creatures, cached_config.settings.hide_inactive_creatures);

			config_changed = config_changed or changed;

			changed, cached_config.settings.opacity_falloff = imgui.checkbox(
				language.current_language.customization_menu.opacity_falloff, cached_config.settings.opacity_falloff);

			config_changed = config_changed or changed;

			changed, cached_config.settings.max_distance = imgui.drag_float(
				language.current_language.customization_menu.max_distance, cached_config.settings.max_distance, 1, 0, 10000, "%.0f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.world_offset) then
			changed, cached_config.world_offset.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.world_offset.x, 0.1, -100, 100, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.world_offset.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.world_offset.y, 0.1, -100, 100, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.world_offset.z = imgui.drag_float(
				language.current_language.customization_menu.z, cached_config.world_offset.z, 0.1, -100, 100, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.viewport_offset) then
			changed, cached_config.viewport_offset.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.viewport_offset.x, 0.1, -screen.width, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.viewport_offset.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.viewport_offset.y, 0.1, -screen.height, screen.height, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		changed = label_customization.draw(
			language.current_language.customization_menu.creature_name_label, cached_config.creature_name_label);

		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_buff_UI()
	local changed = false;
	local config_changed = false;
	local index = 0;

	if imgui.tree_node(language.current_language.customization_menu.buff_UI) then
		local cached_config = config.current_config.buff_UI;

		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;	

		if imgui.tree_node(language.current_language.customization_menu.settings) then
			changed, cached_config.settings.hide_bar_for_infinite_buffs = imgui.checkbox(
				language.current_language.customization_menu.hide_bar_for_infinite_buffs, cached_config.settings.hide_bar_for_infinite_buffs);

			config_changed = config_changed or changed;

			changed, cached_config.settings.hide_timer_for_infinite_buffs = imgui.checkbox(
				language.current_language.customization_menu.hide_timer_for_infinite_buffs, cached_config.settings.hide_timer_for_infinite_buffs);

			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.orientation,
				utils.table.find_index(this.orientation_types, cached_config.settings.orientation),
				this.displayed_orientation_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.orientation = this.orientation_types[index];
			end

			changed, index = imgui.combo(
				language.current_language.customization_menu.infinite_buffs_location,
				utils.table.find_index(this.buff_UI_infinite_buffs_location_types, cached_config.settings.infinite_buffs_location),
				this.displayed_buff_UI_infinite_buffs_location_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.settings.infinite_buffs_location = this.buff_UI_infinite_buffs_location_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.spacing) then
			changed, cached_config.spacing.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.spacing.x, 0.1, -screen.width, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.spacing.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.spacing.y, 0.1, -screen.height, screen.height, "%.1f");

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.position.x, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.position.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.position.y, 0.1, 0, screen.height, "%.1f");

			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.anchor,
				utils.table.find_index(this.anchor_types, cached_config.position.anchor),
				this.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.sorting) then
			changed, index = imgui.combo(
				language.current_language.customization_menu.type,
				utils.table.find_index(this.buff_UI_sorting_types, cached_config.sorting.type),
				this.displayed_buff_UI_sorting_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.sorting.type = this.buff_UI_sorting_types[index];
			end

			changed, cached_config.sorting.reversed_order = imgui.checkbox(
				language.current_language.customization_menu.reversed_order, cached_config.sorting.reversed_order);

			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.filter) then

			if imgui.tree_node(language.current_language.customization_menu.abnormal_statuses) then

				for _, key in ipairs(abnormal_statuses.keys) do
					changed, cached_config.filter.abnormal_statuses[key] = imgui.checkbox(
						abnormal_statuses.get_abnormal_status_name(key), cached_config.filter.abnormal_statuses[key]);

					config_changed = config_changed or changed;
				end
		
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.item_buffs) then
		
				local cached_language = language.current_language.item_buffs; 

				for _, key in ipairs(item_buffs.keys) do
					changed, cached_config.filter.item_buffs[key] = imgui.checkbox(cached_language[key], cached_config.filter.item_buffs[key]);
					config_changed = config_changed or changed;
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.endemic_life_buffs) then
				
				local cached_language = language.current_language.endemic_life; 

				for _, key in ipairs(endemic_life_buffs.keys) do
					changed, cached_config.filter.endemic_life_buffs[key] = imgui.checkbox(cached_language[key], cached_config.filter.endemic_life_buffs[key]);
					config_changed = config_changed or changed;
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.melody_effects) then
		
				local cached_language = language.current_language.melody_effects; 

				for lua_index, key in ipairs(melody_effects.keys) do
					-- Health Recovery (S), Health Recovery (L), Health Recovery (S) + (Antidote), Sonic Wave
					if (lua_index >= 16 and lua_index <= 18) or lua_index == 24 then
						goto continue;
					end

					changed, cached_config.filter.melody_effects[key] = imgui.checkbox(cached_language[key], cached_config.filter.melody_effects[key]);
					config_changed = config_changed or changed;

					::continue::
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.dango_skills) then
		
				local cached_language = language.current_language.dango_skills; 

				for _, key in ipairs(dango_skills.keys) do
					changed, cached_config.filter.dango_skills[key] = imgui.checkbox(cached_language[key], cached_config.filter.dango_skills[key]);
					config_changed = config_changed or changed;
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.rampage_skills) then
		
				local cached_language = language.current_language.rampage_skills; 

				for _, key in ipairs(rampage_skills.keys) do
					changed, cached_config.filter.rampage_skills[key] = imgui.checkbox(cached_language[key], cached_config.filter.rampage_skills[key]);

					config_changed = config_changed or changed;
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.skills) then

				local cached_language = language.current_language.skills; 

				for _, key in ipairs(skills.keys) do
					changed, cached_config.filter.skills[key] = imgui.checkbox(cached_language[key], cached_config.filter.skills[key]);
					config_changed = config_changed or changed;
				end
		
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.weapon_skills) then
		
				for _, weapon in ipairs(weapon_skills.keys) do
					if imgui.tree_node(language.current_language.weapons[weapon.key]) then

						local cached_weapon_filter = cached_config.filter.weapon_skills[weapon.key];
						local cached_language = language.current_language.weapon_skills[weapon.key]; 

						for _, key in ipairs(weapon.skill_keys) do
							local name = cached_language[key];

							if key == "spirit_gauge_autofill" then
								local soaring_kick_name = tostring(cached_language.soaring_kick);
								local iai_slash_name = tostring(cached_language.iai_slash);
								name = string.format("%s (%s, %s)", name, soaring_kick_name, iai_slash_name);
							end

							changed, cached_weapon_filter[key] = imgui.checkbox(
								name, cached_weapon_filter[key]);
		
							config_changed = config_changed or changed;
						end

						imgui.tree_pop();
					end
				end

				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.otomo_moves) then

				local cached_language = language.current_language.otomo_moves; 

				for _, key in ipairs(otomo_moves.keys) do
					changed, cached_config.filter.otomo_moves[key] = imgui.checkbox(cached_language[key], cached_config.filter.otomo_moves[key]);
					config_changed = config_changed or changed;
				end
		
				imgui.tree_pop();
			end

			if imgui.tree_node(language.current_language.customization_menu.misc_buffs) then

				local cached_language = language.current_language.misc_buffs;

				for _, key in ipairs(misc_buffs.keys) do
					local name = cached_language[key];

					if key == "attack_up" then

						local might_seed_name = tostring(language.current_language.item_buffs.might_seed);
						local dango_bulker_name = tostring(language.current_language.dango_skills.dango_bulker);
						local chameleos_soul_name = tostring(language.current_language.rampage_skills.chameleos_soul);
						name = string.format("%s (%s, %s, %s)", name, might_seed_name, dango_bulker_name, chameleos_soul_name);

					elseif key == "defense_up" then

						local adamant_seed_name = tostring(language.current_language.item_buffs.adamant_seed);
						local chameleos_soul_name = tostring(language.current_language.rampage_skills.chameleos_soul);

						name = string.format("%s (%s, %s)", name, adamant_seed_name, chameleos_soul_name);
					elseif key == "stamina_use_down" then

						local dash_juice_name = tostring(language.current_language.item_buffs.dash_juice);
						local peepersects_name = tostring(language.current_language.endemic_life.peepersects);
						local chameleos_soul_name = tostring(language.current_language.rampage_skills.chameleos_soul);

						name = string.format("%s (%s, %s, %s)", name, dash_juice_name, peepersects_name, chameleos_soul_name);
					elseif key == "natural_healing_up" then

						local immunizer_name = tostring(language.current_language.item_buffs.immunizer);
						local vase_of_vitality_name = tostring(language.current_language.otomo_moves.vase_of_vitality);

						name = string.format("%s (%s, %s)", name, immunizer_name, vase_of_vitality_name);
					end

					changed, cached_config.filter.misc_buffs[key] = imgui.checkbox(name, cached_config.filter.misc_buffs[key]);

					config_changed = config_changed or changed;
				end
		
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.abnormal_statuses) then

			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.abnormal_statuses.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.timer_label, cached_config.abnormal_statuses.timer_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.abnormal_statuses.bar);
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.item_buffs) then
	
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.item_buffs.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.timer_label, cached_config.item_buffs.timer_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.item_buffs.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.endemic_life_buffs) then
	
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.endemic_life_buffs.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.timer_label, cached_config.endemic_life_buffs.timer_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.endemic_life_buffs.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.melody_effects) then
	
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.melody_effects.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.timer_label, cached_config.melody_effects.timer_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.melody_effects.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.dango_skills) then
	
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.dango_skills.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.timer_label, cached_config.dango_skills.timer_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.dango_skills.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.rampage_skills) then
	
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.rampage_skills.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.timer_label, cached_config.rampage_skills.timer_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.rampage_skills.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.skills) then

			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.skills.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.timer_label, cached_config.skills.timer_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.skills.bar);
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.weapon_skills) then
	
			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.weapon_skills.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.timer_label, cached_config.weapon_skills.timer_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.weapon_skills.bar);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.otomo_moves) then

			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.otomo_moves.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.timer_label, cached_config.otomo_moves.timer_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.otomo_moves.bar);
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end

		if imgui.tree_node(language.current_language.customization_menu.misc_buffs) then

			changed = label_customization.draw(language.current_language.customization_menu.name_label, cached_config.misc_buffs.name_label);
			config_changed = config_changed or changed;

			changed = label_customization.draw(language.current_language.customization_menu.timer_label, cached_config.misc_buffs.timer_label);
			config_changed = config_changed or changed;

			changed = bar_customization.draw(language.current_language.customization_menu.bar, cached_config.misc_buffs.bar);
			config_changed = config_changed or changed;
		
			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_stats_UI()
	local changed = false;
	local config_changed = false;
	local index = 0;

	if imgui.tree_node(language.current_language.customization_menu.stats_UI) then
		local cached_config = config.current_config.stats_UI;

		changed, cached_config.enabled = imgui.checkbox(
			language.current_language.customization_menu.enabled, cached_config.enabled);

		config_changed = config_changed or changed;	

		if imgui.tree_node(language.current_language.customization_menu.position) then
			changed, cached_config.position.x = imgui.drag_float(
				language.current_language.customization_menu.x, cached_config.position.x, 0.1, 0, screen.width, "%.1f");

			config_changed = config_changed or changed;

			changed, cached_config.position.y = imgui.drag_float(
				language.current_language.customization_menu.y, cached_config.position.y, 0.1, 0, screen.height, "%.1f");

			config_changed = config_changed or changed;

			changed, index = imgui.combo(
				language.current_language.customization_menu.anchor,
				utils.table.find_index(this.anchor_types, cached_config.position.anchor),
				this.displayed_anchor_types);

			config_changed = config_changed or changed;

			if changed then
				cached_config.position.anchor = this.anchor_types[index];
			end

			imgui.tree_pop();
		end

		changed = label_customization.draw(language.current_language.customization_menu.health_label, cached_config.health_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.stamina_label, cached_config.stamina_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.attack_label, cached_config.attack_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.affinity_label, cached_config.affinity_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.defense_label, cached_config.defense_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.fire_resistance_label, cached_config.fire_resistance_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.water_resistance_label, cached_config.water_resistance_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.thunder_resistance_label, cached_config.thunder_resistance_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.ice_resistance_label, cached_config.ice_resistance_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.dragon_resistance_label, cached_config.dragon_resistance_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.element_label, cached_config.element_label);
		config_changed = config_changed or changed;

		changed = label_customization.draw(language.current_language.customization_menu.element_2_label, cached_config.element_2_label);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	return config_changed;
end

function this.draw_debug()
	local cached_config = config.current_config.debug;

	local changed = false;
	local config_changed = false;

	if imgui.tree_node(language.current_language.customization_menu.debug) then
		
		imgui.text_colored(string.format("%s:", language.current_language.customization_menu.current_time), 0xFFAAAA66);
		imgui.same_line();
		imgui.text(string.format("%.3fs", time.total_elapsed_script_seconds));

		if error_handler.is_empty then
			imgui.text(language.current_language.customization_menu.everything_seems_to_be_ok);
		else
			for error_key, error in pairs(error_handler.list) do

				imgui.button(string.format("%.3fs", error.time));
				imgui.same_line();
				imgui.text_colored(error_key, 0xFFAA66AA);
				imgui.same_line();
				imgui.text(error.message);
			end
		end

		if imgui.tree_node(language.current_language.customization_menu.history) then

			changed, cached_config.history_size = imgui.drag_int(
				language.current_language.customization_menu.history_size, cached_config.history_size, 1, 0, 1024);

			config_changed = config_changed or changed;

			if changed then
				error_handler.history = {};
			end

			for index, error in pairs(error_handler.history) do
				imgui.text_colored(index, 0xFF66AA66);
				imgui.same_line();
				imgui.button(string.format("%.3fs", error.time));
				imgui.same_line();
				imgui.text_colored(error.key, 0xFFAA66AA);
				imgui.same_line();
				imgui.text(error.message);
			end


			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	return config_changed;
end

function this.init_dependencies()
	utils = require("MHR_Overlay.Misc.utils");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
	screen = require("MHR_Overlay.Game_Handler.screen");
	players = require("MHR_Overlay.Damage_Meter.players");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	part_names = require("MHR_Overlay.Misc.part_names");
	time_UI = require("MHR_Overlay.UI.Modules.time_UI");
	keyboard = require("MHR_Overlay.Game_Handler.keyboard");
	non_players = require("MHR_Overlay.Damage_Meter.non_players");
	quest_status = require("MHR_Overlay.Game_Handler.quest_status");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	time = require("MHR_Overlay.Game_Handler.time");
	stats_UI = require("MHR_Overlay.UI.Modules.stats_UI");

	buffs = require("MHR_Overlay.Buffs.buffs");
	item_buffs = require("MHR_Overlay.Buffs.item_buffs");
	melody_effects = require("MHR_Overlay.Buffs.melody_effects");
	endemic_life_buffs = require("MHR_Overlay.Buffs.endemic_life_buffs");
	skills = require("MHR_Overlay.Buffs.skills");
	dango_skills = require("MHR_Overlay.Buffs.dango_skills");
	abnormal_statuses = require("MHR_Overlay.Buffs.abnormal_statuses");
	otomo_moves = require("MHR_Overlay.Buffs.otomo_moves");
	weapon_skills = require("MHR_Overlay.Buffs.weapon_skills");
	rampage_skills = require("MHR_Overlay.Buffs.rampage_skills");
	misc_buffs = require("MHR_Overlay.Buffs.misc_buffs");

	label_customization = require("MHR_Overlay.UI.Customizations.label_customization");
	bar_customization = require("MHR_Overlay.UI.Customizations.bar_customization");
	large_monster_UI_customization = require("MHR_Overlay.UI.Customizations.large_monster_UI_customization");

	health_customization = require("MHR_Overlay.UI.Customizations.health_customization");
	stamina_customization = require("MHR_Overlay.UI.Customizations.stamina_customization");
	rage_customization = require("MHR_Overlay.UI.Customizations.rage_customization");
	body_parts_customization = require("MHR_Overlay.UI.Customizations.body_parts_customization");
	ailments_customization = require("MHR_Overlay.UI.Customizations.ailments_customization");
	ailment_buildups_customization = require("MHR_Overlay.UI.Customizations.ailment_buildups_customization");
	module_visibility_customization = require("MHR_Overlay.UI.Customizations.module_visibility_customization");
end

function this.init_module()
	this.init();
	this.reload_font();
end

return this;