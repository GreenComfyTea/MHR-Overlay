local customization_menu = {};

local table_helpers;
local config;
local screen;
local player;
local large_monster;
local small_monster;

customization_menu.is_opened = false;
customization_menu.status = "OK";
customization_menu.window_flags = 0x10120;
customization_menu.color_picker_flags = 327680;

customization_menu.orientation_types = {"Horizontal", "Vertical"};
customization_menu.anchor_types = {"Top-left", "Top-Right", "Bottom-Left", "Bottom-Right"};

customization_menu.monster_UI_sorting_types = {"Normal", "Health", "Health Percentage", "Distance"};
customization_menu.large_monster_UI_parts_sorting_types = {"Normal", "Health", "Health Percentage"};

customization_menu.damage_meter_UI_highlighted_bar_types = {"Me", "Top Damage", "None"};
customization_menu.damage_meter_UI_damage_bar_relative_types = {"Total Damage", "Top Damage"};
customization_menu.damage_meter_UI_my_damage_bar_location_types = {"Normal", "First", "Last"};
customization_menu.damage_meter_UI_sorting_types = {"Normal", "Damage"};

customization_menu.fonts = {"Arial", "Arial Black", "Bahnschrift", "Calibri", "Cambria", "Cambria Math", "Candara",
                            "Comic Sans MS", "Consolas", "Constantia", "Corbel", "Courier New", "Ebrima",
                            "Franklin Gothic Medium", "Gabriola", "Gadugi", "Georgia", "HoloLens MDL2 Assets", "Impact",
                            "Ink Free", "Javanese Text", "Leelawadee UI", "Lucida Console", "Lucida Sans Unicode",
                            "Malgun Gothic", "Marlett", "Microsoft Himalaya", "Microsoft JhengHei",
                            "Microsoft New Tai Lue", "Microsoft PhagsPa", "Microsoft Sans Serif", "Microsoft Tai Le",
                            "Microsoft YaHei", "Microsoft Yi Baiti", "MingLiU-ExtB", "Mongolian Baiti", "MS Gothic",
                            "MV Boli", "Myanmar Text", "Nirmala UI", "Palatino Linotype", "Segoe MDL2 Assets",
                            "Segoe Print", "Segoe Script", "Segoe UI", "Segoe UI Historic", "Segoe UI Emoji",
                            "Segoe UI Symbol", "SimSun", "Sitka", "Sylfaen", "Symbol", "Tahoma", "Times New Roman",
                            "Trebuchet MS", "Verdana", "Webdings", "Wingdings", "Yu Gothic"};

customization_menu.small_monster_UI_orientation_index = 0;
customization_menu.small_monster_UI_sorting_type_index = 0;

customization_menu.large_monster_UI_orientation_index = 0;
customization_menu.large_monster_UI_sorting_type_index = 0;

customization_menu.large_monster_dynamic_UI_parts_sorting_type_index = 0;
customization_menu.large_monster_static_UI_parts_sorting_type_index = 0;

customization_menu.damage_meter_UI_orientation_index = 0;
customization_menu.damage_meter_UI_sorting_type_index = 0;
customization_menu.damage_meter_UI_highlighted_bar_index = 0;
customization_menu.damage_meter_UI_damage_bar_relative_index = 0;
customization_menu.damage_meter_UI_my_damage_bar_location_index = 0;

customization_menu.small_monster_UI_anchor_index = 0;
customization_menu.large_monster_UI_anchor_index = 0;
customization_menu.time_UI_anchor_index = 0;
customization_menu.damage_meter_UI_anchor_index = 0;

customization_menu.selected_font_index = 9;

function customization_menu.init()
	customization_menu.large_monster_UI_orientation_index = table_helpers.find_index(customization_menu.orientation_types,
		config.current_config.large_monster_UI.static.settings.orientation, false);

	customization_menu.large_monster_UI_sorting_type_index = table_helpers.find_index(
		customization_menu.monster_UI_sorting_types, config.current_config.large_monster_UI.static.sorting.type, false);

	customization_menu.large_monster_dynamic_UI_parts_sorting_type_index = table_helpers.find_index(
		customization_menu.large_monster_UI_parts_sorting_types, config.current_config.large_monster_UI.dynamic.parts.sorting.type, false);

		customization_menu.large_monster_static_UI_parts_sorting_type_index = table_helpers.find_index(
		customization_menu.large_monster_UI_parts_sorting_types, config.current_config.large_monster_UI.static.parts.sorting.type, false);

	customization_menu.damage_meter_UI_orientation_index = table_helpers.find_index(customization_menu.orientation_types,
		config.current_config.damage_meter_UI.settings.orientation, false);

	customization_menu.damage_meter_UI_highlighted_bar_index = table_helpers.find_index(
		customization_menu.damage_meter_UI_highlighted_bar_types,
		config.current_config.damage_meter_UI.settings.highlighted_bar, false);

	customization_menu.damage_meter_UI_damage_bar_relative_index = table_helpers.find_index(
		customization_menu.damage_meter_UI_damage_bar_relative_types,
		config.current_config.damage_meter_UI.settings.damage_bar_relative_to, false);

	customization_menu.damage_meter_UI_my_damage_bar_location_index = table_helpers.find_index(
		customization_menu.damage_meter_UI_my_damage_bar_location_types,
		config.current_config.damage_meter_UI.settings.my_damage_bar_location, false);

	customization_menu.damage_meter_UI_sorting_type_index = table_helpers.find_index(
		customization_menu.damage_meter_UI_sorting_types, config.current_config.damage_meter_UI.sorting.type, false);

	customization_menu.selected_font_index = table_helpers.find_index(customization_menu.fonts,
		config.current_config.global_settings.font.family, false);

	customization_menu.small_monster_UI_anchor_index = table_helpers.find_index(customization_menu.anchor_types,
	config.current_config.small_monster_UI.static_position.anchor, false);

	customization_menu.large_monster_UI_anchor_index = table_helpers.find_index(customization_menu.anchor_types,
	config.current_config.large_monster_UI.static.position.anchor, false);

	customization_menu.time_UI_anchor_index = table_helpers.find_index(customization_menu.anchor_types,
	config.current_config.time_UI.position.anchor, false);
	
	customization_menu.damage_meter_UI_anchor_index = table_helpers.find_index(customization_menu.anchor_types,
	config.current_config.damage_meter_UI.position.anchor, false);
end

function customization_menu.draw()
	customization_menu.is_opened = imgui.begin_window("MHR Overlay " .. config.current_config.version,
		customization_menu.is_opened, customization_menu.window_flags);

	if not customization_menu.is_opened then
		return;
	end

	local config_changed = false;
	local changed;
	local status_string = tostring(customization_menu.status);
	imgui.text("Status: " .. status_string);

	if imgui.tree_node("Modules") then
		changed, config.current_config.small_monster_UI.enabled = imgui.checkbox("Small Monster UI", config.current_config
			.small_monster_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.large_monster_UI.dynamic.enabled =
		imgui.checkbox("Large Monster Dynamic UI", config.current_config.large_monster_UI.dynamic.enabled);
		config_changed = config_changed or changed;
		imgui.same_line();

		changed, config.current_config.large_monster_UI.static.enabled =
			imgui.checkbox("Large Monster Static UI", config.current_config.large_monster_UI.static.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.time_UI.enabled = imgui.checkbox("Time UI", config.current_config.time_UI.enabled);
		config_changed = config_changed or changed;
		imgui.same_line();

		changed, config.current_config.damage_meter_UI.enabled = imgui.checkbox("Damage Meter UI",
			config.current_config.damage_meter_UI.enabled);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	if imgui.tree_node("Global Settings") then
		if imgui.tree_node("Module Visibility on Different Screens") then

			if imgui.tree_node("During Quest") then
				changed, config.current_config.global_settings.module_visibility.during_quest.small_monster_UI = imgui.checkbox(
					"Small Monster UI", config.current_config.global_settings.module_visibility.during_quest.small_monster_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.during_quest.large_monster_dynamic_UI = imgui.checkbox(
					"Large Monster Dynamic UI", config.current_config.global_settings.module_visibility.during_quest.large_monster_dynamic_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.during_quest.large_monster_static_UI = imgui.checkbox(
					"Large Monster Static UI", config.current_config.global_settings.module_visibility.during_quest.large_monster_static_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.during_quest.time_UI = imgui.checkbox("Time UI",
					config.current_config.global_settings.module_visibility.during_quest.time_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.during_quest.damage_meter_UI = imgui.checkbox(
					"Damage Meter UI", config.current_config.global_settings.module_visibility.during_quest.damage_meter_UI);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Quest Summary Screen") then
				changed, config.current_config.global_settings.module_visibility.quest_summary_screen.small_monster_UI = imgui.checkbox(
					"Small Monster UI", config.current_config.global_settings.module_visibility.quest_summary_screen.small_monster_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.quest_summary_screen.large_monster_dynamic_UI = imgui.checkbox(
					"Large Monster Dynamic UI", config.current_config.global_settings.module_visibility.quest_summary_screen.large_monster_dynamic_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.quest_summary_screen.large_monster_static_UI = imgui.checkbox("Large Monster Static UI", config.current_config.global_settings.module_visibility.quest_summary_screen.large_monster_static_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.quest_summary_screen.time_UI = imgui.checkbox("Time UI", config.current_config.global_settings.module_visibility.quest_summary_screen.time_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.quest_summary_screen.damage_meter_UI = imgui.checkbox("Damage Meter UI", config.current_config.global_settings.module_visibility.quest_summary_screen.damage_meter_UI);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Training Area") then
				changed, config.current_config.global_settings.module_visibility.training_area.large_monster_dynamic_UI = imgui.checkbox(
					"Large Monster Dynamic UI", config.current_config.global_settings.module_visibility.training_area.large_monster_dynamic_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.training_area.large_monster_static_UI = imgui.checkbox(
					"Large Monster Static UI", config.current_config.global_settings.module_visibility.training_area.large_monster_static_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.training_area.damage_meter_UI = imgui.checkbox(
					"Damage Meter UI", config.current_config.global_settings.module_visibility.training_area.damage_meter_UI);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Font") then
			imgui.text("Any changes to the font require script reload!");

			changed, customization_menu.selected_font_index = imgui.combo("Family", customization_menu.selected_font_index,
				customization_menu.fonts);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.global_settings.font.family = customization_menu.fonts[customization_menu.selected_font_index];
			end

			changed, config.current_config.global_settings.font.size =
				imgui.slider_int("Size", config.current_config.global_settings.font.size, 1, 100);
			config_changed = config_changed or changed;

			changed, config.current_config.global_settings.font.bold =
				imgui.checkbox("Bold", config.current_config.global_settings.font.bold);
			config_changed = config_changed or changed;

			changed, config.current_config.global_settings.font.italic =
				imgui.checkbox("Italic", config.current_config.global_settings.font.italic);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Small Monster UI") then
		local small_monster_UI_changed = false;
		changed, config.current_config.small_monster_UI.enabled = imgui.checkbox("Enabled", config.current_config
			.small_monster_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node("Settings") then
			changed, customization_menu.small_monster_UI_orientation_index = imgui.combo("Static Orientation",
				customization_menu.small_monster_UI_orientation_index, customization_menu.orientation_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.small_monster_UI.settings.orientation =
					customization_menu.orientation_types[customization_menu.small_monster_UI_orientation_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Dynamic Positioning") then
			changed, config.current_config.small_monster_UI.dynamic_positioning.enabled = imgui.checkbox("Enabled",
				config.current_config.small_monster_UI.dynamic_positioning.enabled);
			config_changed = config_changed or changed;

			changed, config.current_config.small_monster_UI.dynamic_positioning.opacity_falloff = imgui.checkbox(
				"Opacity Falloff", config.current_config.small_monster_UI.dynamic_positioning.opacity_falloff);
			config_changed = config_changed or changed;

			changed, config.current_config.small_monster_UI.dynamic_positioning.max_distance =
				imgui.drag_float("Max Distance", config.current_config.small_monster_UI.dynamic_positioning.max_distance, 1, 0,
					10000, "%.0f");
			config_changed = config_changed or changed;

			if imgui.tree_node("World Offset") then
				changed, config.current_config.small_monster_UI.dynamic_positioning.world_offset.x = imgui.drag_float("X",
					config.current_config.small_monster_UI.dynamic_positioning.world_offset.x, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.small_monster_UI.dynamic_positioning.world_offset.y = imgui.drag_float("Y",
					config.current_config.small_monster_UI.dynamic_positioning.world_offset.y, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.small_monster_UI.dynamic_positioning.world_offset.z = imgui.drag_float("Z",
					config.current_config.small_monster_UI.dynamic_positioning.world_offset.z, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Viewport Offset") then
				changed, config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.x = imgui.drag_float("X",
					config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.x, 0.1, -screen.width, screen.width,
					"%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.y = imgui.drag_float("Y",
					config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.y, 0.1, -screen.height, screen.height,
					"%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Static Position") then
			changed, config.current_config.small_monster_UI.static_position.x =
				imgui.drag_float("X", config.current_config.small_monster_UI.static_position.x, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.small_monster_UI.static_position.y =
				imgui.drag_float("Y", config.current_config.small_monster_UI.static_position.y, 0.1, 0, screen.height, "%.1f");
			config_changed = config_changed or changed;

			changed, customization_menu.small_monster_UI_anchor_index = imgui.combo("Anchor",
			customization_menu.small_monster_UI_anchor_index, customization_menu.anchor_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.small_monster_UI.static_position.anchor =
					customization_menu.anchor_types[customization_menu.small_monster_UI_anchor_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Static Spacing") then
			changed, config.current_config.small_monster_UI.static_spacing.x =
				imgui.drag_float("X", config.current_config.small_monster_UI.static_spacing.x, 0.1, -screen.width, screen.width,
					"%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.small_monster_UI.static_spacing.y =
				imgui.drag_float("Y", config.current_config.small_monster_UI.static_spacing.y, 0.1, -screen.height, screen.height,
					"%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Static Sorting") then
			changed, customization_menu.small_monster_UI_sorting_type_index = imgui.combo("Type",
				customization_menu.small_monster_UI_sorting_type_index, customization_menu.monster_UI_sorting_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.small_monster_UI.static_sorting.type =
					customization_menu.monster_UI_sorting_types[customization_menu.small_monster_UI_sorting_type_index];
			end

			changed, config.current_config.small_monster_UI.static_sorting.reversed_order =
				imgui.checkbox("Reversed Order", config.current_config.small_monster_UI.static_sorting.reversed_order);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Monster Name Label") then
			changed, config.current_config.small_monster_UI.monster_name_label.visibility = imgui.checkbox("Visible",
				config.current_config.small_monster_UI.monster_name_label.visibility);
			config_changed = config_changed or changed;
			small_monster_UI_changed = small_monster_UI_changed or changed;

			if imgui.tree_node("Offset") then
				changed, config.current_config.small_monster_UI.monster_name_label.offset.x = imgui.drag_float("X",
					config.current_config.small_monster_UI.monster_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				changed, config.current_config.small_monster_UI.monster_name_label.offset.y = imgui.drag_float("Y",
					config.current_config.small_monster_UI.monster_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				-- changed, config.current_config.small_monster_UI.monster_name_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.monster_name_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.small_monster_UI.monster_name_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.small_monster_UI.monster_name_label.shadow.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.monster_name_label.shadow.offset.x = imgui.drag_float("X",
						config.current_config.small_monster_UI.monster_name_label.shadow.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.monster_name_label.shadow.offset.y = imgui.drag_float("Y",
						config.current_config.small_monster_UI.monster_name_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.small_monster_UI.monster_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.monster_name_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Health") then
			changed, config.current_config.small_monster_UI.health.visibility = imgui.checkbox("Visible",
			config.current_config.small_monster_UI.health.visibility);
			config_changed = config_changed or changed;
			small_monster_UI_changed = small_monster_UI_changed or changed;

			if imgui.tree_node("Text Label") then
				changed, config.current_config.small_monster_UI.health.text_label.visibility = imgui.checkbox("Visible",
					config.current_config.small_monster_UI.health.text_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.health.text_label.offset.x = imgui.drag_float("X",
						config.current_config.small_monster_UI.health.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.health.text_label.offset.y = imgui.drag_float("Y",
						config.current_config.small_monster_UI.health.text_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.small_monster_UI.health.text_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.text_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Shadow") then
					changed, config.current_config.small_monster_UI.health.text_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.small_monster_UI.health.text_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.small_monster_UI.health.text_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.small_monster_UI.health.text_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.health.text_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.small_monster_UI.health.text_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.small_monster_UI.health.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.text_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Value Label") then
				changed, config.current_config.small_monster_UI.health.value_label.visibility = imgui.checkbox("Visible",
					config.current_config.small_monster_UI.health.value_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.health.value_label.offset.x = imgui.drag_float("X",
						config.current_config.small_monster_UI.health.value_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.health.value_label.offset.y = imgui.drag_float("Y",
						config.current_config.small_monster_UI.health.value_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.small_monster_UI.health.value_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.value_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Shadow") then
					changed, config.current_config.small_monster_UI.health.value_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.small_monster_UI.health.value_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.small_monster_UI.health.value_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.small_monster_UI.health.value_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.health.value_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.small_monster_UI.health.value_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.small_monster_UI.health.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.value_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Percentage Label") then
				changed, config.current_config.small_monster_UI.health.percentage_label.visibility = imgui.checkbox("Visible",
					config.current_config.small_monster_UI.health.percentage_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.health.percentage_label.offset.x = imgui.drag_float("X",
						config.current_config.small_monster_UI.health.percentage_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.health.percentage_label.offset.y = imgui.drag_float("Y",
						config.current_config.small_monster_UI.health.percentage_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.small_monster_UI.health.percentage_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.percentage_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Shadow") then
					changed, config.current_config.small_monster_UI.health.percentage_label.shadow.visibility = imgui.checkbox(
						"Enable", config.current_config.small_monster_UI.health.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.small_monster_UI.health.percentage_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.small_monster_UI.health.percentage_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.health.percentage_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.small_monster_UI.health.percentage_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.small_monster_UI.health.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.percentage_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Bar") then
				changed, config.current_config.small_monster_UI.health.bar.visibility = imgui.checkbox("Visible",
					config.current_config.small_monster_UI.health.bar.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.health.bar.offset.x =
						imgui.drag_float("X", config.current_config.small_monster_UI.health.bar.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.health.bar.offset.y =
						imgui.drag_float("Y", config.current_config.small_monster_UI.health.bar.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Size") then
					changed, config.current_config.small_monster_UI.health.bar.size.width = imgui.drag_float("Width",
						config.current_config.small_monster_UI.health.bar.size.width, 0.1, 0, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.health.bar.size.height = imgui.drag_float("Height",
						config.current_config.small_monster_UI.health.bar.size.height, 0.1, 0, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Colors") then
					if imgui.tree_node("Foreground") then
						-- changed, config.current_config.small_monster_UI.health.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.bar.colors.foreground, color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Background") then
						--	changed, config.current_config.small_monster_UI.health.bar.colors.background = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.bar.colors.background, color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Stamina (Pointless: small monsters don't get tired)") then
			changed, config.current_config.small_monster_UI.stamina.visibility = imgui.checkbox("Visible",
			config.current_config.small_monster_UI.stamina.visibility);
			config_changed = config_changed or changed;
			small_monster_UI_changed = small_monster_UI_changed or changed;

			if imgui.tree_node("Text Label") then
				changed, config.current_config.small_monster_UI.stamina.text_label.visibility = imgui.checkbox("Visible",
					config.current_config.small_monster_UI.stamina.text_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.stamina.text_label.offset.x = imgui.drag_float("X",
						config.current_config.small_monster_UI.stamina.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.stamina.text_label.offset.y = imgui.drag_float("Y",
						config.current_config.small_monster_UI.stamina.text_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.small_monster_UI.stamina.text_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.text_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Shadow") then
					changed, config.current_config.small_monster_UI.stamina.text_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.small_monster_UI.stamina.text_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.small_monster_UI.stamina.text_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.small_monster_UI.stamina.text_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.stamina.text_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.small_monster_UI.stamina.text_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.small_monster_UI.stamina.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.text_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Value Label") then
				changed, config.current_config.small_monster_UI.stamina.value_label.visibility = imgui.checkbox("Visible",
					config.current_config.small_monster_UI.stamina.value_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.stamina.value_label.offset.x = imgui.drag_float("X",
						config.current_config.small_monster_UI.stamina.value_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.stamina.value_label.offset.y = imgui.drag_float("Y",
						config.current_config.small_monster_UI.stamina.value_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.small_monster_UI.stamina.value_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.value_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Shadow") then
					changed, config.current_config.small_monster_UI.stamina.value_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.small_monster_UI.stamina.value_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.small_monster_UI.stamina.value_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.small_monster_UI.stamina.value_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.stamina.value_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.small_monster_UI.stamina.value_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.small_monster_UI.stamina.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.value_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Percentage Label") then
				changed, config.current_config.small_monster_UI.stamina.percentage_label.visibility = imgui.checkbox("Visible",
					config.current_config.small_monster_UI.stamina.percentage_label.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				-- add text format

				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.stamina.percentage_label.offset.x = imgui.drag_float("X",
						config.current_config.small_monster_UI.stamina.percentage_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.stamina.percentage_label.offset.y = imgui.drag_float("Y",
						config.current_config.small_monster_UI.stamina.percentage_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.small_monster_UI.stamina.percentage_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.percentage_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Shadow") then
					changed, config.current_config.small_monster_UI.stamina.percentage_label.shadow.visibility = imgui.checkbox(
						"Enable", config.current_config.small_monster_UI.stamina.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.small_monster_UI.stamina.percentage_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.small_monster_UI.stamina.percentage_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						changed, config.current_config.small_monster_UI.stamina.percentage_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.small_monster_UI.stamina.percentage_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.small_monster_UI.stamina.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.percentage_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Bar") then
				changed, config.current_config.small_monster_UI.stamina.bar.visibility = imgui.checkbox("Visible",
					config.current_config.small_monster_UI.stamina.bar.visibility);
				config_changed = config_changed or changed;
				small_monster_UI_changed = small_monster_UI_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.stamina.bar.offset.x =
						imgui.drag_float("X", config.current_config.small_monster_UI.stamina.bar.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.stamina.bar.offset.y =
						imgui.drag_float("Y", config.current_config.small_monster_UI.stamina.bar.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Size") then
					changed, config.current_config.small_monster_UI.stamina.bar.size.width = imgui.drag_float("Width",
						config.current_config.small_monster_UI.stamina.bar.size.width, 0.1, 0, screen.width, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					changed, config.current_config.small_monster_UI.stamina.bar.size.height = imgui.drag_float("Height",
						config.current_config.small_monster_UI.stamina.bar.size.height, 0.1, 0, screen.height, "%.1f");
					config_changed = config_changed or changed;
					small_monster_UI_changed = small_monster_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Colors") then
					if imgui.tree_node("Foreground") then
						-- changed, config.current_config.small_monster_UI.stamina.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.bar.colors.foreground, color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Background") then
						-- changed, config.current_config.small_monster_UI.stamina.bar.colors.background = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.bar.colors.background, color_picker_flags);
						config_changed = config_changed or changed;
						small_monster_UI_changed = small_monster_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if small_monster_UI_changed then
			for _, monster in pairs(small_monster.list) do
				small_monster.init_UI(monster);
			end
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Large Monster UI") then
		if imgui.tree_node("Dynamically Positioned") then
			local large_monster_dynamic_UI_changed = false;

			changed, config.current_config.large_monster_UI.dynamic.enabled =
				imgui.checkbox("Enabled", config.current_config.large_monster_UI.dynamic.enabled);
			config_changed = config_changed or changed;
			large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

			if imgui.tree_node("Settings") then
				changed, config.current_config.large_monster_UI.dynamic.settings.opacity_falloff =
					imgui.checkbox("Opacity Falloff", config.current_config.large_monster_UI.dynamic.settings.opacity_falloff);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic.settings.max_distance =
					imgui.drag_float("Max Distance", config.current_config.large_monster_UI.dynamic.settings.max_distance, 1, 0, 10000, "%.0f");
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("World Offset") then
				changed, config.current_config.large_monster_UI.dynamic.world_offset.x = imgui.drag_float("X",
					config.current_config.large_monster_UI.dynamic.world_offset.x, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic.world_offset.y = imgui.drag_float("Y",
					config.current_config.large_monster_UI.dynamic.world_offset.y, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic.world_offset.z = imgui.drag_float("Z",
					config.current_config.large_monster_UI.dynamic.world_offset.z, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Viewport Offset") then
				changed, config.current_config.large_monster_UI.dynamic.viewport_offset.x = imgui.drag_float("X",
					config.current_config.large_monster_UI.dynamic.viewport_offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic.viewport_offset.y = imgui.drag_float("Y",
					config.current_config.large_monster_UI.dynamic.viewport_offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Monster Name Label") then
				changed, config.current_config.large_monster_UI.dynamic.monster_name_label.visibility = imgui.checkbox("Visible",
					config.current_config.large_monster_UI.dynamic.monster_name_label.visibility);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				if imgui.tree_node("Include") then
					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.include.monster_name = imgui.checkbox(
						"Monster Name", config.current_config.large_monster_UI.dynamic.monster_name_label.include.monster_name);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.include.crown = imgui.checkbox("Crown",
						config.current_config.large_monster_UI.dynamic.monster_name_label.include.crown);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.include.size = imgui.checkbox("Size",
						config.current_config.large_monster_UI.dynamic.monster_name_label.include.size);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.include.scrown_thresholds =
						imgui.checkbox("Crown Thresholds",
							config.current_config.large_monster_UI.dynamic.monster_name_label.include.scrown_thresholds);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.offset.x = imgui.drag_float("X",
						config.current_config.large_monster_UI.dynamic.monster_name_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.offset.y = imgui.drag_float("Y",
						config.current_config.large_monster_UI.dynamic.monster_name_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.large_monster_UI.dynamic.monster_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.monster_name_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Shadow") then
					changed, config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.visibility = imgui.checkbox(
						"Enable", config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.monster_name_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Health") then
				changed, config.current_config.large_monster_UI.dynamic.health.visibility = imgui.checkbox("Visible",
				config.current_config.large_monster_UI.dynamic.health.visibility);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				if imgui.tree_node("Text Label") then
					changed, config.current_config.large_monster_UI.dynamic.health.text_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.dynamic.health.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.health.text_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.health.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.health.text_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.health.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.health.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.text_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.health.text_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.dynamic.health.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.health.text_label.shadow.offset.x = imgui.drag_float("X",
								config.current_config.large_monster_UI.dynamic.health.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.health.text_label.shadow.offset.y = imgui.drag_float("Y",
								config.current_config.large_monster_UI.dynamic.health.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.health.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.text_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Value Label") then
					changed, config.current_config.large_monster_UI.dynamic.health.value_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.dynamic.health.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.health.value_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.health.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.health.value_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.health.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.health.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.value_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.health.value_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.dynamic.health.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.health.value_label.shadow.offset.x = imgui.drag_float(
								"X", config.current_config.large_monster_UI.dynamic.health.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.health.value_label.shadow.offset.y = imgui.drag_float(
								"Y", config.current_config.large_monster_UI.dynamic.health.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.health.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.value_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Percentage Label") then
					changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.visibility = imgui.checkbox(
						"Visible", config.current_config.large_monster_UI.dynamic.health.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.health.percentage_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.health.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.percentage_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.visibility =
							imgui.checkbox("Enable", config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.offset.x =
								imgui.drag_float("X", config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.offset.x,
									0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.offset.y =
								imgui.drag_float("Y", config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.offset.y,
									0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.percentage_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Bar") then
					changed, config.current_config.large_monster_UI.dynamic.health.bar.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.dynamic.health.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.health.bar.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.health.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.health.bar.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.health.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Size") then
						changed, config.current_config.large_monster_UI.dynamic.health.bar.size.width = imgui.drag_float("Width",
							config.current_config.large_monster_UI.dynamic.health.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.health.bar.size.height = imgui.drag_float("Height",
							config.current_config.large_monster_UI.dynamic.health.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Colors") then
						if imgui.tree_node("Foreground") then
							-- changed, config.current_config.large_monster_UI.dynamic.health.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.bar.colors.foreground, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Background") then
							-- changed, config.current_config.large_monster_UI.dynamic.health.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.bar.colors.background, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Monster can be captured") then
							if imgui.tree_node("Foreground") then
								-- changed, config.current_config.large_monster_UI.dynamic.health.bar.colors.capture.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.bar.colors.capture.foreground, color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

								imgui.tree_pop();
							end

							if imgui.tree_node("Background") then
								-- changed, config.current_config.large_monster_UI.dynamic.health.bar.colors.capture.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.health.bar.colors.capture.background, color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

								imgui.tree_pop();
							end
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Stamina") then
				changed, config.current_config.large_monster_UI.dynamic.stamina.visibility = imgui.checkbox("Visible",
				config.current_config.large_monster_UI.dynamic.stamina.visibility);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				if imgui.tree_node("Text Label") then
					changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.dynamic.stamina.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.stamina.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.stamina.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.text_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.offset.x = imgui.drag_float(
								"X", config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.offset.y = imgui.drag_float(
								"Y", config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.text_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Value Label") then
					changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.dynamic.stamina.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.stamina.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.stamina.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.value_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.offset.x = imgui.drag_float(
								"X", config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.offset.y = imgui.drag_float(
								"Y", config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.value_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Percentage Label") then
					changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.visibility = imgui.checkbox(
						"Visible", config.current_config.large_monster_UI.dynamic.stamina.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.stamina.percentage_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.stamina.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.percentage_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.visibility =
							imgui.checkbox("Enable",
								config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.offset.x =
								imgui.drag_float("X", config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.offset.x,
									0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.offset.y =
								imgui.drag_float("Y", config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.offset.y,
									0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.percentage_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Bar") then
					changed, config.current_config.large_monster_UI.dynamic.stamina.bar.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.dynamic.stamina.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.stamina.bar.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.stamina.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.stamina.bar.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.stamina.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Size") then
						changed, config.current_config.large_monster_UI.dynamic.stamina.bar.size.width = imgui.drag_float("Width",
							config.current_config.large_monster_UI.dynamic.stamina.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.stamina.bar.size.height = imgui.drag_float("Height",
							config.current_config.large_monster_UI.dynamic.stamina.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Colors") then
						if imgui.tree_node("Foreground") then
							-- changed, config.current_config.large_monster_UI.dynamic.stamina.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.bar.colors.foreground, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Background") then
							-- changed, config.current_config.large_monster_UI.dynamic.stamina.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.stamina.bar.colors.background, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Rage") then
				changed, config.current_config.large_monster_UI.dynamic.rage.visibility = imgui.checkbox("Visible",
				config.current_config.large_monster_UI.dynamic.rage.visibility);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				if imgui.tree_node("Text Label") then
					changed, config.current_config.large_monster_UI.dynamic.rage.text_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.dynamic.rage.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.rage.text_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.rage.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.rage.text_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.rage.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.rage.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.text_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.offset.x = imgui.drag_float("X",
								config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.offset.y = imgui.drag_float("Y",
								config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.text_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Value Label") then
					changed, config.current_config.large_monster_UI.dynamic.rage.value_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.dynamic.rage.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.rage.value_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.rage.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.rage.value_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.rage.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.rage.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.value_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.offset.x = imgui.drag_float("X",
								config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.offset.y = imgui.drag_float("Y",
								config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.value_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Percentage Label") then
					changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.visibility = imgui.checkbox(
						"Visible", config.current_config.large_monster_UI.dynamic.rage.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.rage.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.rage.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.percentage_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.offset.x = imgui.drag_float(
								"X", config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.offset.y = imgui.drag_float(
								"Y", config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.percentage_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Bar") then
					changed, config.current_config.large_monster_UI.dynamic.rage.bar.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.dynamic.rage.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.rage.bar.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.rage.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.rage.bar.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.rage.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Size") then
						changed, config.current_config.large_monster_UI.dynamic.rage.bar.size.width = imgui.drag_float("Width",
							config.current_config.large_monster_UI.dynamic.rage.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.rage.bar.size.height = imgui.drag_float("Height",
							config.current_config.large_monster_UI.dynamic.rage.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Colors") then
						if imgui.tree_node("Foreground") then
							-- changed, config.current_config.large_monster_UI.dynamic.rage.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.bar.colors.foreground, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Background") then
							-- changed, config.current_config.large_monster_UI.dynamic.rage.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.rage.bar.colors.background, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Body Parts") then
				changed, config.current_config.large_monster_UI.dynamic.parts.visibility = imgui.checkbox(
						"Visible", config.current_config.large_monster_UI.dynamic.parts.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.dynamic.parts.offset.x = imgui.drag_float("X",
						config.current_config.large_monster_UI.dynamic.parts.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.parts.offset.y = imgui.drag_float("Y",
						config.current_config.large_monster_UI.dynamic.parts.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Spacing") then
					changed, config.current_config.large_monster_UI.dynamic.parts.spacing.x = imgui.drag_float("X",
						config.current_config.large_monster_UI.dynamic.parts.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					changed, config.current_config.large_monster_UI.dynamic.parts.spacing.y = imgui.drag_float("Y",
						config.current_config.large_monster_UI.dynamic.parts.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Settings") then
					changed, config.current_config.large_monster_UI.dynamic.parts.settings.hide_undamaged_parts =
					imgui.checkbox("Hide Undamaged Parts", config.current_config.large_monster_UI.dynamic.parts.settings.hide_undamaged_parts);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					imgui.tree_pop();
				end

				if imgui.tree_node("Sorting") then
					changed, customization_menu.large_monster_dynamic_UI_parts_sorting_type_index = imgui.combo("Type",
						customization_menu.large_monster_dynamic_UI_parts_sorting_type_index, customization_menu.large_monster_UI_parts_sorting_types);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
					if changed then
						config.current_config.large_monster_UI.dynamic.parts.sorting.type =
							customization_menu.large_monster_UI_parts_sorting_types[customization_menu.large_monster_dynamic_UI_parts_sorting_type_index];
					end

					changed, config.current_config.large_monster_UI.dynamic.parts.sorting.reversed_order =
					imgui.checkbox("Reversed Order", config.current_config.large_monster_UI.dynamic.parts.sorting.reversed_order);
				config_changed = config_changed or changed;
				large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;
	
					imgui.tree_pop();
				end

				if imgui.tree_node("Part Name Label") then
					changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.visibility = imgui.checkbox(
						"Visible", config.current_config.large_monster_UI.dynamic.parts.part_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					if imgui.tree_node("Include") then
						changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.include.part_name = imgui.checkbox(
							"Part Name", config.current_config.large_monster_UI.dynamic.parts.part_name_label.include.part_name);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.include.break_count =
							imgui.checkbox("Break Count",
								config.current_config.large_monster_UI.dynamic.parts.part_name_label.include.break_count);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.parts.part_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.parts.part_name_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.part_name_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.offset.x = imgui.drag_float(
								"X", config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.offset.y = imgui.drag_float(
								"Y", config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.part_name_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Text Label") then
					changed, config.current_config.large_monster_UI.dynamic.parts.text_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.dynamic.parts.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.parts.text_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.parts.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.text_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.parts.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.parts.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.text_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.offset.x = imgui.drag_float("X",
								config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.offset.y = imgui.drag_float("Y",
								config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.text_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Value Label") then
					changed, config.current_config.large_monster_UI.dynamic.parts.value_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.dynamic.parts.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.parts.value_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.parts.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.value_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.parts.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.parts.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.value_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.offset.x = imgui.drag_float("X",
								config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.offset.y = imgui.drag_float("Y",
								config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.value_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Percentage Label") then
					changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.visibility = imgui.checkbox(
						"Visible", config.current_config.large_monster_UI.dynamic.parts.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.parts.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.parts.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.percentage_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.offset.x =
								imgui.drag_float("X", config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.offset.x,
									0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.offset.y =
								imgui.drag_float("Y", config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.offset.y,
									0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.percentage_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Bar") then
					changed, config.current_config.large_monster_UI.dynamic.parts.bar.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.dynamic.parts.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.dynamic.parts.bar.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.dynamic.parts.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.bar.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.dynamic.parts.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Size") then
						changed, config.current_config.large_monster_UI.dynamic.parts.bar.size.width = imgui.drag_float("Width",
							config.current_config.large_monster_UI.dynamic.parts.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						changed, config.current_config.large_monster_UI.dynamic.parts.bar.size.height = imgui.drag_float("Height",
							config.current_config.large_monster_UI.dynamic.parts.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Colors") then
						if imgui.tree_node("Foreground") then
							-- changed, config.current_config.large_monster_UI.dynamic.parts.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.bar.colors.foreground, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Background") then
							-- changed, config.current_config.large_monster_UI.dynamic.parts.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.dynamic.parts.bar.colors.background, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_dynamic_UI_changed = large_monster_dynamic_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if large_monster_dynamic_UI_changed then
				for _, monster in pairs(large_monster.list) do
					large_monster.init_dynamic_UI(monster);
				end
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Statically Positioned") then
			local large_monster_static_UI_changed = false;

			changed, config.current_config.large_monster_UI.static.enabled =
				imgui.checkbox("Enabled", config.current_config.large_monster_UI.static.enabled);
			config_changed = config_changed or changed;
			large_monster_static_UI_changed = large_monster_static_UI_changed or changed;


			if imgui.tree_node("Settings") then
				changed, customization_menu.large_monster_UI_orientation_index = imgui.combo("Orientation",
					customization_menu.large_monster_UI_orientation_index, customization_menu.orientation_types);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
				if changed then
					config.current_config.large_monster_UI.static.settings.orientation =
						customization_menu.orientation_types[customization_menu.large_monster_UI_orientation_index];
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Position") then
				changed, config.current_config.large_monster_UI.static.position.x =
					imgui.drag_float("X", config.current_config.large_monster_UI.static.position.x, 0.1, 0, screen.width, "%.1f");
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				changed, config.current_config.large_monster_UI.static.position.y =
					imgui.drag_float("Y", config.current_config.large_monster_UI.static.position.y, 0.1, 0, screen.height, "%.1f");
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				changed, customization_menu.large_monster_UI_anchor_index = imgui.combo("Anchor",
				customization_menu.large_monster_UI_anchor_index, customization_menu.anchor_types);
				config_changed = config_changed or changed;
				if changed then
					config.current_config.large_monster_UI.static.position.anchor =
						customization_menu.anchor_types[customization_menu.large_monster_UI_anchor_index];
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Spacing") then
				changed, config.current_config.large_monster_UI.static.spacing.x =
					imgui.drag_float("X", config.current_config.large_monster_UI.static.spacing.x, 0.1, -screen.width, screen.width,
						"%.1f");
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				changed, config.current_config.large_monster_UI.static.spacing.y =
					imgui.drag_float("Y", config.current_config.large_monster_UI.static.spacing.y, 0.1, -screen.height, screen.height,
						"%.1f");
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Sorting") then
				changed, customization_menu.monster_UI_sort_type_index = imgui.combo("Type",
					customization_menu.monster_UI_sort_type_index, customization_menu.monster_UI_sorting_types);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
				if changed then
					config.current_config.large_monster_UI.static.sorting.type =
						customization_menu.monster_UI_sorting_types[customization_menu.monster_UI_sort_type_index];
				end

				changed, config.current_config.large_monster_UI.static.sorting.reversed_order =
					imgui.checkbox("Reversed Order", config.current_config.large_monster_UI.static.sorting.reversed_order);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Monster Name Label") then
				changed, config.current_config.large_monster_UI.static.monster_name_label.visibility = imgui.checkbox("Visible",
					config.current_config.large_monster_UI.static.monster_name_label.visibility);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				if imgui.tree_node("Include") then
					changed, config.current_config.large_monster_UI.static.monster_name_label.include.monster_name = imgui.checkbox(
						"Monster Name", config.current_config.large_monster_UI.static.monster_name_label.include.monster_name);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.monster_name_label.include.crown = imgui.checkbox("Crown",
						config.current_config.large_monster_UI.static.monster_name_label.include.crown);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.monster_name_label.include.size = imgui.checkbox("Size",
						config.current_config.large_monster_UI.static.monster_name_label.include.size);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.monster_name_label.include.scrown_thresholds =
						imgui.checkbox("Crown Thresholds",
							config.current_config.large_monster_UI.static.monster_name_label.include.scrown_thresholds);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.static.monster_name_label.offset.x = imgui.drag_float("X",
						config.current_config.large_monster_UI.static.monster_name_label.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.monster_name_label.offset.y = imgui.drag_float("Y",
						config.current_config.large_monster_UI.static.monster_name_label.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.large_monster_UI.static.monster_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.monster_name_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Shadow") then
					changed, config.current_config.large_monster_UI.static.monster_name_label.shadow.visibility = imgui.checkbox(
						"Enable", config.current_config.large_monster_UI.static.monster_name_label.shadow.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.monster_name_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.monster_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.monster_name_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.monster_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.monster_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.monster_name_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Health") then
				changed, config.current_config.large_monster_UI.static.health.visibility = imgui.checkbox("Visible",
				config.current_config.large_monster_UI.static.health.visibility);
			config_changed = config_changed or changed;
			large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				if imgui.tree_node("Text Label") then
					changed, config.current_config.large_monster_UI.static.health.text_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.health.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.health.text_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.health.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.health.text_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.health.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.health.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.text_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.health.text_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.static.health.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.health.text_label.shadow.offset.x = imgui.drag_float("X",
								config.current_config.large_monster_UI.static.health.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.health.text_label.shadow.offset.y = imgui.drag_float("Y",
								config.current_config.large_monster_UI.static.health.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.health.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.text_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Value Label") then
					changed, config.current_config.large_monster_UI.static.health.value_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.health.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.health.value_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.health.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.health.value_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.health.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.health.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.value_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.health.value_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.static.health.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.health.value_label.shadow.offset.x = imgui.drag_float("X",
								config.current_config.large_monster_UI.static.health.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.health.value_label.shadow.offset.y = imgui.drag_float("Y",
								config.current_config.large_monster_UI.static.health.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.health.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.value_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Percentage Label") then
					changed, config.current_config.large_monster_UI.static.health.percentage_label.visibility = imgui.checkbox(
						"Visible", config.current_config.large_monster_UI.static.health.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.health.percentage_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.health.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.health.percentage_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.health.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.health.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.percentage_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.health.percentage_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.static.health.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.health.percentage_label.shadow.offset.x =
								imgui.drag_float("X", config.current_config.large_monster_UI.static.health.percentage_label.shadow.offset.x,
									0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.health.percentage_label.shadow.offset.y =
								imgui.drag_float("Y", config.current_config.large_monster_UI.static.health.percentage_label.shadow.offset.y,
									0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.health.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.percentage_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Bar") then
					changed, config.current_config.large_monster_UI.static.health.bar.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.health.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.health.bar.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.health.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.health.bar.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.health.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Size") then
						changed, config.current_config.large_monster_UI.static.health.bar.size.width = imgui.drag_float("Width",
							config.current_config.large_monster_UI.static.health.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.health.bar.size.height = imgui.drag_float("Height",
							config.current_config.large_monster_UI.static.health.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Colors") then
						if imgui.tree_node("Foreground") then
							-- changed, config.current_config.large_monster_UI.static.health.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.bar.colors.foreground, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Background") then
							-- changed, config.current_config.large_monster_UI.static.health.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.bar.colors.background, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Monster can be captured") then
							if imgui.tree_node("Foreground") then
								-- changed, config.current_config.large_monster_UI.static.health.bar.colors.capture.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.bar.colors.capture.foreground, color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

								imgui.tree_pop();
							end

							if imgui.tree_node("Background") then
								-- changed, config.current_config.large_monster_UI.static.health.bar.colors.capture.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.health.bar.colors.capture.background, color_picker_flags);
								config_changed = config_changed or changed;
								large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

								imgui.tree_pop();
							end
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Stamina") then
				changed, config.current_config.large_monster_UI.static.stamina.visibility = imgui.checkbox("Visible",
				config.current_config.large_monster_UI.static.stamina.visibility);
			config_changed = config_changed or changed;
			large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				if imgui.tree_node("Text Label") then
					changed, config.current_config.large_monster_UI.static.stamina.text_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.stamina.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.stamina.text_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.stamina.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.stamina.text_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.stamina.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.stamina.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.text_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.stamina.text_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.static.stamina.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.stamina.text_label.shadow.offset.x = imgui.drag_float("X",
								config.current_config.large_monster_UI.static.stamina.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.stamina.text_label.shadow.offset.y = imgui.drag_float("Y",
								config.current_config.large_monster_UI.static.stamina.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.stamina.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.text_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Value Label") then
					changed, config.current_config.large_monster_UI.static.stamina.value_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.stamina.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.stamina.value_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.stamina.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.stamina.value_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.stamina.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.stamina.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.value_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.stamina.value_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.static.stamina.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.stamina.value_label.shadow.offset.x = imgui.drag_float(
								"X", config.current_config.large_monster_UI.static.stamina.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.stamina.value_label.shadow.offset.y = imgui.drag_float(
								"Y", config.current_config.large_monster_UI.static.stamina.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.stamina.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.value_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Percentage Label") then
					changed, config.current_config.large_monster_UI.static.stamina.percentage_label.visibility = imgui.checkbox(
						"Visible", config.current_config.large_monster_UI.static.stamina.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.stamina.percentage_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.stamina.percentage_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.stamina.percentage_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.stamina.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.stamina.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.percentage_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.visibility =
							imgui.checkbox("Enable", config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.offset.x =
								imgui.drag_float("X", config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.offset.x,
									0.1, -screen.width, screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.offset.y =
								imgui.drag_float("Y", config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.offset.y,
									0.1, -screen.height, screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.percentage_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Bar") then
					changed, config.current_config.large_monster_UI.static.stamina.bar.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.stamina.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.stamina.bar.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.stamina.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.stamina.bar.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.stamina.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Size") then
						changed, config.current_config.large_monster_UI.static.stamina.bar.size.width = imgui.drag_float("Width",
							config.current_config.large_monster_UI.static.stamina.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.stamina.bar.size.height = imgui.drag_float("Height",
							config.current_config.large_monster_UI.static.stamina.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Colors") then
						if imgui.tree_node("Foreground") then
							-- changed, config.current_config.large_monster_UI.static.stamina.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.bar.colors.foreground, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Background") then
							-- changed, config.current_config.large_monster_UI.static.stamina.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.stamina.bar.colors.background, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Rage") then
				changed, config.current_config.large_monster_UI.static.rage.visibility = imgui.checkbox("Visible",
				config.current_config.large_monster_UI.static.rage.visibility);
			config_changed = config_changed or changed;
			large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				if imgui.tree_node("Text Label") then
					changed, config.current_config.large_monster_UI.static.rage.text_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.rage.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.rage.text_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.rage.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.rage.text_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.rage.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.rage.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.text_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.rage.text_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.static.rage.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.rage.text_label.shadow.offset.x = imgui.drag_float("X",
								config.current_config.large_monster_UI.static.rage.text_label.shadow.offset.x, 0.1, -screen.width, screen.width,
								"%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.rage.text_label.shadow.offset.y = imgui.drag_float("Y",
								config.current_config.large_monster_UI.static.rage.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.rage.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.text_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Value Label") then
					changed, config.current_config.large_monster_UI.static.rage.value_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.rage.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.rage.value_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.rage.value_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.rage.value_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.rage.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.rage.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.value_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.rage.value_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.static.rage.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.rage.value_label.shadow.offset.x = imgui.drag_float("X",
								config.current_config.large_monster_UI.static.rage.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.rage.value_label.shadow.offset.y = imgui.drag_float("Y",
								config.current_config.large_monster_UI.static.rage.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.rage.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.value_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Percentage Label") then
					changed, config.current_config.large_monster_UI.static.rage.percentage_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.rage.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.rage.percentage_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.rage.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.rage.percentage_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.rage.percentage_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.rage.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.percentage_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.rage.percentage_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.static.rage.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.rage.percentage_label.shadow.offset.x = imgui.drag_float(
								"X", config.current_config.large_monster_UI.static.rage.percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.rage.percentage_label.shadow.offset.y = imgui.drag_float(
								"Y", config.current_config.large_monster_UI.static.rage.percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.rage.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.percentage_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Bar") then
					changed, config.current_config.large_monster_UI.static.rage.bar.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.rage.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.rage.bar.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.rage.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.rage.bar.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.rage.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Size") then
						changed, config.current_config.large_monster_UI.static.rage.bar.size.width = imgui.drag_float("Width",
							config.current_config.large_monster_UI.static.rage.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.rage.bar.size.height = imgui.drag_float("Height",
							config.current_config.large_monster_UI.static.rage.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Colors") then
						if imgui.tree_node("Foreground") then
							-- changed, config.current_config.large_monster_UI.static.rage.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.bar.colors.foreground, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Background") then
							-- changed, config.current_config.large_monster_UI.static.rage.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.rage.bar.colors.background, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Body Parts") then
				changed, config.current_config.large_monster_UI.static.parts.visibility = imgui.checkbox("Visible",
				config.current_config.large_monster_UI.static.parts.visibility);
			config_changed = config_changed or changed;
			large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.static.parts.offset.x = imgui.drag_float("X",
						config.current_config.large_monster_UI.static.parts.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.parts.offset.y = imgui.drag_float("Y",
						config.current_config.large_monster_UI.static.parts.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Spacing") then
					changed, config.current_config.large_monster_UI.static.parts.spacing.x = imgui.drag_float("X",
						config.current_config.large_monster_UI.static.parts.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					changed, config.current_config.large_monster_UI.static.parts.spacing.y = imgui.drag_float("Y",
						config.current_config.large_monster_UI.static.parts.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Settings") then
					changed, config.current_config.large_monster_UI.static.parts.settings.hide_undamaged_parts =
					imgui.checkbox("Hide Undamaged Parts", config.current_config.large_monster_UI.static.parts.settings.hide_undamaged_parts);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					imgui.tree_pop();
				end

				if imgui.tree_node("Sorting") then
					changed, customization_menu.large_monster_static_UI_parts_sorting_type_index = imgui.combo("Type",
						customization_menu.large_monster_static_UI_parts_sorting_type_index, customization_menu.large_monster_UI_parts_sorting_types);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
					if changed then
						config.current_config.large_monster_UI.static.parts.sorting.type =
							customization_menu.large_monster_UI_parts_sorting_types[customization_menu.large_monster_static_UI_parts_sorting_type_index];
					end

					changed, config.current_config.large_monster_UI.static.parts.sorting.reversed_order =
					imgui.checkbox("Reversed Order", config.current_config.large_monster_UI.static.parts.sorting.reversed_order);
				config_changed = config_changed or changed;
				large_monster_static_UI_changed = large_monster_static_UI_changed or changed;
	
					imgui.tree_pop();
				end

				if imgui.tree_node("Part Name Label") then
					changed, config.current_config.large_monster_UI.static.parts.part_name_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.parts.part_name_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					if imgui.tree_node("Include") then
						changed, config.current_config.large_monster_UI.static.parts.part_name_label.include.part_name = imgui.checkbox(
							"Part Name", config.current_config.large_monster_UI.static.parts.part_name_label.include.part_name);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.part_name_label.include.break_count = imgui.checkbox(
							"Break Count", config.current_config.large_monster_UI.static.parts.part_name_label.include.break_count);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.parts.part_name_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.parts.part_name_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.part_name_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.parts.part_name_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.parts.part_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.part_name_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.parts.part_name_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.static.parts.part_name_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.parts.part_name_label.shadow.offset.x = imgui.drag_float(
								"X", config.current_config.large_monster_UI.static.parts.part_name_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.parts.part_name_label.shadow.offset.y = imgui.drag_float(
								"Y", config.current_config.large_monster_UI.static.parts.part_name_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.parts.part_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.part_name_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Text Label") then
					changed, config.current_config.large_monster_UI.static.parts.text_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.parts.text_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.parts.text_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.parts.text_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.text_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.parts.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.parts.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.text_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.parts.text_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.static.parts.text_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.parts.text_label.shadow.offset.x = imgui.drag_float("X",
								config.current_config.large_monster_UI.static.parts.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.parts.text_label.shadow.offset.y = imgui.drag_float("Y",
								config.current_config.large_monster_UI.static.parts.text_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.parts.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.text_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Value Label") then
					changed, config.current_config.large_monster_UI.static.parts.value_label.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.parts.value_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.parts.value_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.parts.value_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.value_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.parts.value_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.parts.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.value_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.parts.value_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.static.parts.value_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.parts.value_label.shadow.offset.x = imgui.drag_float("X",
								config.current_config.large_monster_UI.static.parts.value_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.parts.value_label.shadow.offset.y = imgui.drag_float("Y",
								config.current_config.large_monster_UI.static.parts.value_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.parts.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.value_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Percentage Label") then
					changed, config.current_config.large_monster_UI.static.parts.percentage_label.visibility = imgui.checkbox(
						"Visible", config.current_config.large_monster_UI.static.parts.percentage_label.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					-- add text format

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.parts.percentage_label.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.parts.percentage_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.percentage_label.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.parts.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Color") then
						-- changed, config.current_config.large_monster_UI.static.parts.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.percentage_label.color, color_picker_flags);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Shadow") then
						changed, config.current_config.large_monster_UI.static.parts.percentage_label.shadow.visibility = imgui.checkbox(
							"Enable", config.current_config.large_monster_UI.static.parts.percentage_label.shadow.visibility);
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						if imgui.tree_node("Offset") then
							changed, config.current_config.large_monster_UI.static.parts.percentage_label.shadow.offset.x = imgui.drag_float(
								"X", config.current_config.large_monster_UI.static.parts.percentage_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							changed, config.current_config.large_monster_UI.static.parts.percentage_label.shadow.offset.y = imgui.drag_float(
								"Y", config.current_config.large_monster_UI.static.parts.percentage_label.shadow.offset.y, 0.1, -screen.height,
								screen.height, "%.1f");
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Color") then
							-- changed, config.current_config.large_monster_UI.static.parts.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.percentage_label.shadow.color, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				if imgui.tree_node("Bar") then
					changed, config.current_config.large_monster_UI.static.parts.bar.visibility = imgui.checkbox("Visible",
						config.current_config.large_monster_UI.static.parts.bar.visibility);
					config_changed = config_changed or changed;
					large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.static.parts.bar.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.static.parts.bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.bar.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.static.parts.bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Size") then
						changed, config.current_config.large_monster_UI.static.parts.bar.size.width = imgui.drag_float("Width",
							config.current_config.large_monster_UI.static.parts.bar.size.width, 0.1, 0, screen.width, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						changed, config.current_config.large_monster_UI.static.parts.bar.size.height = imgui.drag_float("Height",
							config.current_config.large_monster_UI.static.parts.bar.size.height, 0.1, 0, screen.height, "%.1f");
						config_changed = config_changed or changed;
						large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

						imgui.tree_pop();
					end

					if imgui.tree_node("Colors") then
						if imgui.tree_node("Foreground") then
							-- changed, config.current_config.large_monster_UI.static.parts.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.bar.colors.foreground, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						if imgui.tree_node("Background") then
							-- changed, config.current_config.large_monster_UI.static.parts.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.static.parts.bar.colors.background, color_picker_flags);
							config_changed = config_changed or changed;
							large_monster_static_UI_changed = large_monster_static_UI_changed or changed;

							imgui.tree_pop();
						end

						imgui.tree_pop();
					end

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if large_monster_static_UI_changed then
				for _, monster in pairs(large_monster.list) do
					large_monster.init_static_UI(monster);
				end
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Time UI") then
		changed, config.current_config.time_UI.enabled = imgui.checkbox("Enabled", config.current_config.time_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node("Position") then
			changed, config.current_config.time_UI.position.x = imgui.drag_float("X", config.current_config.time_UI.position.x,
				0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.time_UI.position.y = imgui.drag_float("Y", config.current_config.time_UI.position.y,
				0.1, 0, screen.height, "%.1f");
			config_changed = config_changed or changed;

			changed, customization_menu.time_UI_anchor_index = imgui.combo("Anchor",
				customization_menu.time_UI_anchor_index, customization_menu.anchor_types);
				config_changed = config_changed or changed;
			if changed then
				config.current_config.time_UI.position.anchor =
					customization_menu.anchor_types[customization_menu.time_UI_anchor_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Time Label") then
			changed, config.current_config.time_UI.time_label.visibility =
				imgui.checkbox("Visible", config.current_config.time_UI.time_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.current_config.time_UI.time_label.offset.x =
					imgui.drag_float("X", config.current_config.time_UI.time_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.time_UI.time_label.offset.y =
					imgui.drag_float("Y", config.current_config.time_UI.time_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				-- changed, config.current_config.time_UI.time_label.color = imgui.color_picker_argb("", config.current_config.time_UI.time_label.color, color_picker_flags);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.time_UI.time_label.shadow.visibility =
					imgui.checkbox("Enable", config.current_config.time_UI.time_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.time_UI.time_label.shadow.offset.x =
						imgui.drag_float("X", config.current_config.time_UI.time_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.time_UI.time_label.shadow.offset.y =
						imgui.drag_float("Y", config.current_config.time_UI.time_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.time_UI.time_label.shadow.color = imgui.color_picker_argb("", config.current_config.time_UI.time_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end
			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Damage Meter UI") then
		changed, config.current_config.damage_meter_UI.enabled = imgui.checkbox("Enabled",
			config.current_config.damage_meter_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node("Settings") then
			changed, config.current_config.damage_meter_UI.settings.hide_module_if_total_damage_is_zero = imgui.checkbox(
				"Hide Module if Total Damage is 0",
				config.current_config.damage_meter_UI.settings.hide_module_if_total_damage_is_zero);
			config_changed = config_changed or changed;

			changed, config.current_config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero = imgui.checkbox(
				"Hide Player if Player Damage is 0",
				config.current_config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero);
			config_changed = config_changed or changed;

			changed, config.current_config.damage_meter_UI.settings.hide_total_if_total_damage_is_zero  = imgui.checkbox(
				"Hide Total if Total Damage is 0",
				config.current_config.damage_meter_UI.settings.hide_total_if_total_damage_is_zero);
			config_changed = config_changed or changed;


			changed, config.current_config.damage_meter_UI.settings.total_damage_offset_is_relative = imgui.checkbox(
				"Total Damage Offset is Relative", config.current_config.damage_meter_UI.settings.total_damage_offset_is_relative);
			config_changed = config_changed or changed;

			changed, customization_menu.damage_meter_UI_orientation_index = imgui.combo("Orientation",
				customization_menu.damage_meter_UI_orientation_index, customization_menu.orientation_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.orientation =
					customization_menu.orientation_types[customization_menu.damage_meter_UI_orientation_index];
			end

			changed, customization_menu.damage_meter_UI_highlighted_bar_index =
				imgui.combo("Highlighted Bar", customization_menu.damage_meter_UI_highlighted_bar_index,
					customization_menu.damage_meter_UI_highlighted_bar_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.highlighted_bar =
					customization_menu.damage_meter_UI_highlighted_bar_types[customization_menu.damage_meter_UI_highlighted_bar_index];
			end

			changed, customization_menu.damage_meter_UI_damage_bar_relative_index =
				imgui.combo("Damage Bars are Relative to", customization_menu.damage_meter_UI_damage_bar_relative_index,
					customization_menu.damage_meter_UI_damage_bar_relative_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.damage_bar_relative_to =
					customization_menu.damage_meter_UI_damage_bar_relative_types[customization_menu.damage_meter_UI_damage_bar_relative_index];
			end

			changed, customization_menu.damage_meter_UI_my_damage_bar_location_index =
				imgui.combo("My Damage Bar Location", customization_menu.damage_meter_UI_my_damage_bar_location_index,
					customization_menu.damage_meter_UI_my_damage_bar_location_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.my_damage_bar_location =
					customization_menu.damage_meter_UI_my_damage_bar_location_types[customization_menu.damage_meter_UI_my_damage_bar_location_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Tracked Monster Types") then
			local tracked_monster_types_changed = false;
			changed, config.current_config.damage_meter_UI.tracked_monster_types.small_monsters = imgui.checkbox(
				"Small Monsters", config.current_config.damage_meter_UI.tracked_monster_types.small_monsters);
			config_changed = config_changed or changed;
			tracked_monster_types_changed = tracked_monster_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_monster_types.large_monsters = imgui.checkbox(
				"Large Monsters", config.current_config.damage_meter_UI.tracked_monster_types.large_monsters);
			config_changed = config_changed or changed;
			tracked_monster_types_changed = tracked_monster_types_changed or changed;

			if tracked_monster_types_changed then
				for player_id, _player in pairs(player.list) do
					_player.update_display(player);
				end
				player.update_display(player.total);
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Tracked Damage Types") then
			local tracked_damage_types_changed = false;
			changed, config.current_config.damage_meter_UI.tracked_damage_types.player_damage =
				imgui.checkbox("Player Damage", config.current_config.damage_meter_UI.tracked_damage_types.player_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.bomb_damage = imgui.checkbox("Bomb Damage",
				config.current_config.damage_meter_UI.tracked_damage_types.bomb_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.kunai_damage =
				imgui.checkbox("Kunai Damage", config.current_config.damage_meter_UI.tracked_damage_types.kunai_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.installation_damage = imgui.checkbox(
				"Installation Damage", config.current_config.damage_meter_UI.tracked_damage_types.installation_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.otomo_damage =
				imgui.checkbox("Otomo Damage", config.current_config.damage_meter_UI.tracked_damage_types.otomo_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.monster_damage =
				imgui.checkbox("Monster Damage", config.current_config.damage_meter_UI.tracked_damage_types.monster_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			if tracked_damage_types_changed then
				for player_id, _player in pairs(player.list) do
					player.update_display(_player);
				end
				player.update_display(player.total);
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Spacing") then
			changed, config.current_config.damage_meter_UI.spacing.x =
				imgui.drag_float("X", config.current_config.damage_meter_UI.spacing.x, 0.1, -screen.width, screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.damage_meter_UI.spacing.y =
				imgui.drag_float("Y", config.current_config.damage_meter_UI.spacing.y, 0.1, -screen.height, screen.height, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Position") then
			changed, config.current_config.damage_meter_UI.position.x =
				imgui.drag_float("X", config.current_config.damage_meter_UI.position.x, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.damage_meter_UI.position.y =
				imgui.drag_float("Y", config.current_config.damage_meter_UI.position.y, 0.1, 0, screen.height, "%.1f");
			config_changed = config_changed or changed;

			changed, customization_menu.damage_meter_UI_anchor_index = imgui.combo("Anchor",
			customization_menu.damage_meter_UI_anchor_index, customization_menu.anchor_types);
			config_changed = config_changed or changed;
		if changed then
			config.current_config.damage_meter_UI.position.anchor =
				customization_menu.anchor_types[customization_menu.damage_meter_UI_anchor_index];
		end

			imgui.tree_pop();
		end

		if imgui.tree_node("Sorting") then
			changed, customization_menu.damage_meter_UI_sort_type_index = imgui.combo("Type",
				customization_menu.damage_meter_UI_sort_type_index, customization_menu.damage_meter_UI_sorting_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.sorting.type =
					customization_menu.damage_meter_UI_sorting_types[customization_menu.damage_meter_UI_sort_type_index];
			end

			changed, config.current_config.damage_meter_UI.sorting.reversed_order =
				imgui.checkbox("Reversed Order", config.current_config.damage_meter_UI.sorting.reversed_order);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Player Name Label") then
			changed, config.current_config.damage_meter_UI.player_name_label.visibility = imgui.checkbox("Visible",
				config.current_config.damage_meter_UI.player_name_label.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Include") then
				if imgui.tree_node("Me") then
					changed, config.current_config.damage_meter_UI.player_name_label.include.myself.hunter_rank = imgui.checkbox(
						"Hunter Rank", config.current_config.damage_meter_UI.player_name_label.include.myself.hunter_rank);
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.myself.word_player = imgui.checkbox(
						"Word \"Player\"", config.current_config.damage_meter_UI.player_name_label.include.myself.word_player);
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.myself.player_id = imgui.checkbox(
						"Player ID", config.current_config.damage_meter_UI.player_name_label.include.myself.player_id);
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.myself.player_name = imgui.checkbox(
						"Player Name", config.current_config.damage_meter_UI.player_name_label.include.myself.player_name);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Other Players") then
					changed, config.current_config.damage_meter_UI.player_name_label.include.others.hunter_rank = imgui.checkbox(
						"Hunter Rank", config.current_config.damage_meter_UI.player_name_label.include.others.hunter_rank);
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.others.word_player = imgui.checkbox(
						"Word \"Player\"", config.current_config.damage_meter_UI.player_name_label.include.others.word_player);
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.others.player_id = imgui.checkbox(
						"Player ID", config.current_config.damage_meter_UI.player_name_label.include.others.player_id);
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.others.player_name = imgui.checkbox(
						"Player Name", config.current_config.damage_meter_UI.player_name_label.include.others.player_name);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.player_name_label.offset.x = imgui.drag_float("X",
					config.current_config.damage_meter_UI.player_name_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.player_name_label.offset.y = imgui.drag_float("Y",
					config.current_config.damage_meter_UI.player_name_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				-- changed, config.current_config.damage_meter_UI.player_name_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.player_name_label.color, color_picker_flags);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.damage_meter_UI.player_name_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.damage_meter_UI.player_name_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.damage_meter_UI.player_name_label.shadow.offset.x = imgui.drag_float("X",
						config.current_config.damage_meter_UI.player_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.shadow.offset.y = imgui.drag_float("Y",
						config.current_config.damage_meter_UI.player_name_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.damage_meter_UI.player_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.player_name_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Damage Value Label") then
			changed, config.current_config.damage_meter_UI.damage_value_label.visibility = imgui.checkbox("Visible",
				config.current_config.damage_meter_UI.damage_value_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.damage_value_label.offset.x = imgui.drag_float("X",
					config.current_config.damage_meter_UI.damage_value_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.damage_value_label.offset.y = imgui.drag_float("Y",
					config.current_config.damage_meter_UI.damage_value_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				-- changed, config.current_config.damage_meter_UI.damage_value_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_value_label.color, color_picker_flags);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.damage_meter_UI.damage_value_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.damage_meter_UI.damage_value_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.damage_meter_UI.damage_value_label.shadow.offset.x = imgui.drag_float("X",
						config.current_config.damage_meter_UI.damage_value_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.damage_value_label.shadow.offset.y = imgui.drag_float("Y",
						config.current_config.damage_meter_UI.damage_value_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.damage_meter_UI.damage_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_value_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Damage Percentage Label") then
			changed, config.current_config.damage_meter_UI.damage_percentage_label.visibility = imgui.checkbox("Visible",
				config.current_config.damage_meter_UI.damage_percentage_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.damage_percentage_label.offset.x = imgui.drag_float("X",
					config.current_config.damage_meter_UI.damage_percentage_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.damage_percentage_label.offset.y = imgui.drag_float("Y",
					config.current_config.damage_meter_UI.damage_percentage_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				-- changed, config.current_config.damage_meter_UI.damage_percentage_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_percentage_label.color, color_picker_flags);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.damage_meter_UI.damage_percentage_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.damage_meter_UI.damage_percentage_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.damage_meter_UI.damage_percentage_label.shadow.offset.x = imgui.drag_float("X",
						config.current_config.damage_meter_UI.damage_percentage_label.shadow.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.damage_percentage_label.shadow.offset.y = imgui.drag_float("Y",
						config.current_config.damage_meter_UI.damage_percentage_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.damage_meter_UI.damage_percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_percentage_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Total Damage Label") then
			changed, config.current_config.damage_meter_UI.total_damage_label.visibility = imgui.checkbox("Visible",
				config.current_config.damage_meter_UI.total_damage_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.total_damage_label.offset.x = imgui.drag_float("X",
					config.current_config.damage_meter_UI.total_damage_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.total_damage_label.offset.y = imgui.drag_float("Y",
					config.current_config.damage_meter_UI.total_damage_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				-- changed, config.current_config.damage_meter_UI.total_damage_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_damage_label.color, color_picker_flags);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.damage_meter_UI.total_damage_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.damage_meter_UI.total_damage_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.damage_meter_UI.total_damage_label.shadow.offset.x = imgui.drag_float("X",
						config.current_config.damage_meter_UI.total_damage_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.total_damage_label.shadow.offset.y = imgui.drag_float("Y",
						config.current_config.damage_meter_UI.total_damage_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.damage_meter_UI.total_damage_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_damage_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Total Damage Value Label") then
			changed, config.current_config.damage_meter_UI.total_damage_value_label.visibility = imgui.checkbox("Visible",
				config.current_config.damage_meter_UI.total_damage_value_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.total_damage_value_label.offset.x = imgui.drag_float("X",
					config.current_config.damage_meter_UI.total_damage_value_label.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.total_damage_value_label.offset.y = imgui.drag_float("Y",
					config.current_config.damage_meter_UI.total_damage_value_label.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				-- changed, config.current_config.damage_meter_UI.total_damage_value_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_damage_value_label.color, color_picker_flags);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.damage_meter_UI.total_damage_value_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.damage_meter_UI.total_damage_value_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.damage_meter_UI.total_damage_value_label.shadow.offset.x = imgui.drag_float("X",
						config.current_config.damage_meter_UI.total_damage_value_label.shadow.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.total_damage_value_label.shadow.offset.y = imgui.drag_float("Y",
						config.current_config.damage_meter_UI.total_damage_value_label.shadow.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					-- changed, config.current_config.damage_meter_UI.total_damage_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_damage_value_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Damage Bar") then
			changed, config.current_config.damage_meter_UI.damage_bar.visibility = imgui.checkbox("Visible",
				config.current_config.damage_meter_UI.damage_bar.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.damage_bar.offset.x =
					imgui.drag_float("X", config.current_config.damage_meter_UI.damage_bar.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.damage_bar.offset.y =
					imgui.drag_float("Y", config.current_config.damage_meter_UI.damage_bar.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Size") then
				changed, config.current_config.damage_meter_UI.damage_bar.size.width = imgui.drag_float("Width",
					config.current_config.damage_meter_UI.damage_bar.size.width, 0.1, 0, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.damage_bar.size.height = imgui.drag_float("Height",
					config.current_config.damage_meter_UI.damage_bar.size.height, 0.1, 0, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Colors") then
				if imgui.tree_node("Foreground") then
					-- changed, config.current_config.damage_meter_UI.damage_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_bar.colors.foreground, color_picker_flags);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Background") then
					-- changed, config.current_config.damage_meter_UI.damage_bar.colors.background = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_bar.colors.background, color_picker_flags);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Highlighted Damage Bar") then
			changed, config.current_config.damage_meter_UI.highlighted_damage_bar.visibility = imgui.checkbox("Visible",
				config.current_config.damage_meter_UI.highlighted_damage_bar.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.highlighted_damage_bar.offset.x = imgui.drag_float("X",
					config.current_config.damage_meter_UI.highlighted_damage_bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.highlighted_damage_bar.offset.y = imgui.drag_float("Y",
					config.current_config.damage_meter_UI.highlighted_damage_bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Size") then
				changed, config.current_config.damage_meter_UI.highlighted_damage_bar.size.width = imgui.drag_float("Width",
					config.current_config.damage_meter_UI.highlighted_damage_bar.size.width, 0.1, 0, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.highlighted_damage_bar.size.height = imgui.drag_float("Height",
					config.current_config.damage_meter_UI.highlighted_damage_bar.size.height, 0.1, 0, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Colors") then
				if imgui.tree_node("Foreground") then
					-- changed, config.current_config.damage_meter_UI.highlighted_damage_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.damage_meter_UI.highlighted_damage_bar.colors.foreground, color_picker_flags);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Background") then
					-- changed, config.current_config.damage_meter_UI.highlighted_damage_bar.colors.background = imgui.color_picker_argb("", config.current_config.damage_meter_UI.highlighted_damage_bar.colors.background, color_picker_flags);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	imgui.end_window();

	if config_changed then
		config.save();
	end
end

function customization_menu.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	config = require("MHR_Overlay.Misc.config");
	screen = require("MHR_Overlay.Game_Handler.screen");
	player = require("MHR_Overlay.Damage_Meter.player");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");

	customization_menu.init();
end

return customization_menu;