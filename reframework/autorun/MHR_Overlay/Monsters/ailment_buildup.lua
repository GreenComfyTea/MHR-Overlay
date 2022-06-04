local ailment_buildup = {};
local player;
local language;
local config;
local ailments;
local ailment_buildup_UI_entity;
local time;
local small_monster;
local large_monster;
local table_helpers;
local drawing;

function ailment_buildup.draw_dynamic(monster, ailment_buildups_position_on_screen, opacity_scale)
	if not config.current_config.large_monster_UI.dynamic.ailment_buildups.enabled then
		return;
	end

	for id, ailment in pairs(monster.ailments) do
		if id == ailments.stun_id then
			if not config.current_config.large_monster_UI.dynamic.ailment_buildups.filter.stun then
				goto continue;
			end
			
		elseif id == ailments.poison_id then
			if not config.current_config.large_monster_UI.dynamic.ailment_buildups.filter.poison then
				goto continue;
			end
		elseif id == ailments.blast_id then
			if not config.current_config.large_monster_UI.dynamic.ailment_buildups.filter.blast then
				goto continue;
			end
		else
			goto continue;
		end

		if config.current_config.large_monster_UI.dynamic.ailment_buildups.settings.time_limit ~= 0 and time.total_elapsed_seconds - ailment.last_change_time > config.current_config.large_monster_UI.dynamic.ailment_buildups.settings.time_limit then
			goto continue;
		end

		local total_buildup = 0;
		local top_buildup = 0;

		local displayed_players = {};
		for player_id, player_buildup in pairs(ailment.buildup) do
			total_buildup = total_buildup + player_buildup;

			if player_buildup > top_buildup then
				top_buildup = player_buildup;
			end

			table.insert(displayed_players,
			{
					["buildup"] = player_buildup,
					["buildup_share"] = ailment.buildup_share[player_id],
					["id"] = player_id
				}
			);
		end

		if total_buildup == 0 then
			goto continue;
		end

		if config.current_config.large_monster_UI.dynamic.ailment_buildups.sorting.type == "Normal" then
			if config.current_config.large_monster_UI.dynamic.ailment_buildups.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.id < right.id;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.id > right.id;
				end);
			end
		elseif config.current_config.large_monster_UI.dynamic.ailment_buildups.sorting.type == "Buildup" then
			if config.current_config.large_monster_UI.dynamic.ailment_buildups.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.buildup < right.buildup;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.buildup > right.buildup;
				end);
			end
		elseif config.current_config.large_monster_UI.dynamic.ailment_buildups.sorting.type == "Buildup Percentage" then
			if config.current_config.large_monster_UI.dynamic.ailment_buildups.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.buildup_share < right.buildup_share;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.buildup_share > right.buildup_share;
				end);
			end
		end

		local ailment_name = "";
		if config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.include.ailment_name then
			ailment_name = ailment.name .. " ";
		end
		if config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_name_label.include.activation_count and ailment.activate_count ~= 0 then
			ailment_name = ailment_name .. "x" .. tostring(ailment.activate_count);
		end
	
		drawing.draw_label(monster.ailments[ailments.stun_id].ailment_buildup_dynamic_UI.ailment_name_label, ailment_buildups_position_on_screen, opacity_scale, ailment_name);


		local last_j = 0;
		for j, _player in ipairs(displayed_players) do
			local ailment_buildup_position_on_screen = {
				x = ailment_buildups_position_on_screen.x + config.current_config.large_monster_UI.dynamic.ailment_buildups.player_spacing.x * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier,
				y = ailment_buildups_position_on_screen.y + config.current_config.large_monster_UI.dynamic.ailment_buildups.player_spacing.y * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier;
			};

			ailment_buildup_UI_entity.draw_dynamic(_player, monster.ailments[ailments.stun_id].ailment_buildup_dynamic_UI, ailment_buildup_position_on_screen, opacity_scale, top_buildup);

			last_j = j;
		end
		
		

		local total_buildup_position_on_screen = {
			x = ailment_buildups_position_on_screen.x + config.current_config.large_monster_UI.dynamic.ailment_buildups.player_spacing.x * last_j * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = ailment_buildups_position_on_screen.y + config.current_config.large_monster_UI.dynamic.ailment_buildups.player_spacing.y * last_j * config.current_config.global_settings.modifiers.global_scale_modifier;
		};

		drawing.draw_label(monster.ailments[ailments.stun_id].ailment_buildup_dynamic_UI.total_buildup_label, total_buildup_position_on_screen, opacity_scale, language.current_language.UI.total_buildup);

		drawing.draw_label(monster.ailments[ailments.stun_id].ailment_buildup_dynamic_UI.total_buildup_value_label, total_buildup_position_on_screen, opacity_scale, total_buildup);

		ailment_buildups_position_on_screen = {
			x = total_buildup_position_on_screen.x + config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_spacing.x * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = total_buildup_position_on_screen.y + 17 + config.current_config.large_monster_UI.dynamic.ailment_buildups.ailment_spacing.y * config.current_config.global_settings.modifiers.global_scale_modifier
		};

		::continue::
	end

	
end

function ailment_buildup.draw_static(monster, ailment_buildups_position_on_screen, opacity_scale)
	if not config.current_config.large_monster_UI.static.ailment_buildups.enabled then
		return;
	end

	for id, ailment in pairs(monster.ailments) do
		if id == ailments.stun_id then
			if not config.current_config.large_monster_UI.static.ailment_buildups.filter.stun then
				goto continue;
			end
			
		elseif id == ailments.poison_id then
			if not config.current_config.large_monster_UI.static.ailment_buildups.filter.poison then
				goto continue;
			end
		elseif id == ailments.blast_id then
			if not config.current_config.large_monster_UI.static.ailment_buildups.filter.blast then
				goto continue;
			end
		else
			goto continue;
		end

		if config.current_config.large_monster_UI.static.ailment_buildups.settings.time_limit ~= 0 and time.total_elapsed_seconds - ailment.last_change_time > config.current_config.large_monster_UI.static.ailment_buildups.settings.time_limit then
			goto continue;
		end

		local total_buildup = 0;
		local top_buildup = 0;

		local displayed_players = {};
		for player_id, player_buildup in pairs(ailment.buildup) do
			total_buildup = total_buildup + player_buildup;

			if player_buildup > top_buildup then
				top_buildup = player_buildup;
			end

			table.insert(displayed_players,
			{
					["buildup"] = player_buildup,
					["buildup_share"] = ailment.buildup_share[player_id],
					["id"] = player_id
				}
			);
		end

		if total_buildup == 0 then
			goto continue;
		end

		if config.current_config.large_monster_UI.static.ailment_buildups.sorting.type == "Normal" then
			if config.current_config.large_monster_UI.static.ailment_buildups.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.id < right.id;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.id > right.id;
				end);
			end
		elseif config.current_config.large_monster_UI.static.ailment_buildups.sorting.type == "Buildup" then
			if config.current_config.large_monster_UI.static.ailment_buildups.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.buildup < right.buildup;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.buildup > right.buildup;
				end);
			end
		elseif config.current_config.large_monster_UI.static.ailment_buildups.sorting.type == "Buildup Percentage" then
			if config.current_config.large_monster_UI.static.ailment_buildups.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.buildup_share < right.buildup_share;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.buildup_share > right.buildup_share;
				end);
			end
		end

		local ailment_name = "";
		if config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.include.ailment_name then
			ailment_name = ailment.name .. " ";
		end
		if config.current_config.large_monster_UI.static.ailment_buildups.ailment_name_label.include.activation_count and ailment.activate_count ~= 0 then
			ailment_name = ailment_name .. "x" .. tostring(ailment.activate_count);
		end

		drawing.draw_label(monster.ailments[ailments.stun_id].ailment_buildup_static_UI.ailment_name_label, ailment_buildups_position_on_screen, opacity_scale, ailment_name);

		local last_j = 0;
		for j, _player in ipairs(displayed_players) do
			local ailment_buildup_position_on_screen = {
				x = ailment_buildups_position_on_screen.x + config.current_config.large_monster_UI.static.ailment_buildups.player_spacing.x * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier,
				y = ailment_buildups_position_on_screen.y + config.current_config.large_monster_UI.static.ailment_buildups.player_spacing.y * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier;
			};

			ailment_buildup_UI_entity.draw_static(_player, monster.ailments[ailments.stun_id].ailment_buildup_static_UI, ailment_buildup_position_on_screen, opacity_scale, top_buildup);

			last_j = j;
		end

		local total_buildup_position_on_screen = {
			x = ailment_buildups_position_on_screen.x + config.current_config.large_monster_UI.static.ailment_buildups.player_spacing.x * last_j * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = ailment_buildups_position_on_screen.y + config.current_config.large_monster_UI.static.ailment_buildups.player_spacing.y * last_j * config.current_config.global_settings.modifiers.global_scale_modifier;
		};

		drawing.draw_label(monster.ailments[ailments.stun_id].ailment_buildup_static_UI.total_buildup_label, total_buildup_position_on_screen, opacity_scale, language.current_language.UI.total_buildup);

		drawing.draw_label(monster.ailments[ailments.stun_id].ailment_buildup_static_UI.total_buildup_value_label, total_buildup_position_on_screen, opacity_scale, total_buildup);

		ailment_buildups_position_on_screen = {
			x = total_buildup_position_on_screen.x + config.current_config.large_monster_UI.static.ailment_buildups.ailment_spacing.x * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = total_buildup_position_on_screen.y + 17 + config.current_config.large_monster_UI.static.ailment_buildups.ailment_spacing.y * config.current_config.global_settings.modifiers.global_scale_modifier
		};

		::continue::
	end

	
end

function ailment_buildup.draw_highlighted(monster, ailment_buildups_position_on_screen, opacity_scale)
	if not config.current_config.large_monster_UI.highlighted.ailment_buildups.enabled then
		return;
	end

	for id, ailment in pairs(monster.ailments) do
		if id == ailments.stun_id then
			if not config.current_config.large_monster_UI.highlighted.ailment_buildups.filter.stun then
				goto continue;
			end
			
		elseif id == ailments.poison_id then
			if not config.current_config.large_monster_UI.highlighted.ailment_buildups.filter.poison then
				goto continue;
			end
		elseif id == ailments.blast_id then
			if not config.current_config.large_monster_UI.highlighted.ailment_buildups.filter.blast then
				goto continue;
			end
		else
			goto continue;
		end

		if config.current_config.large_monster_UI.highlighted.ailment_buildups.settings.time_limit ~= 0 and time.total_elapsed_seconds - ailment.last_change_time > config.current_config.large_monster_UI.highlighted.ailment_buildups.settings.time_limit then
			goto continue;
		end

		local total_buildup = 0;
		local top_buildup = 0;

		local displayed_players = {};
		for player_id, player_buildup in pairs(ailment.buildup) do
			total_buildup = total_buildup + player_buildup;

			if player_buildup > top_buildup then
				top_buildup = player_buildup;
			end

			table.insert(displayed_players,
			{
					["buildup"] = player_buildup,
					["buildup_share"] = ailment.buildup_share[player_id],
					["id"] = player_id
				}
			);
		end

		if total_buildup == 0 then
			goto continue;
		end

		if config.current_config.large_monster_UI.highlighted.ailment_buildups.sorting.type == "Normal" then
			if config.current_config.large_monster_UI.highlighted.ailment_buildups.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.id < right.id;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.id > right.id;
				end);
			end
		elseif config.current_config.large_monster_UI.highlighted.ailment_buildups.sorting.type == "Buildup" then
			if config.current_config.large_monster_UI.highlighted.ailment_buildups.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.buildup < right.buildup;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.buildup > right.buildup;
				end);
			end
		elseif config.current_config.large_monster_UI.highlighted.ailment_buildups.sorting.type == "Buildup Percentage" then
			if config.current_config.large_monster_UI.highlighted.ailment_buildups.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.buildup_share < right.buildup_share;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.buildup_share > right.buildup_share;
				end);
			end
		end

		local ailment_name = "";
		if config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.include.ailment_name then
			ailment_name = ailment.name .. " ";
		end
		if config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_name_label.include.activation_count and ailment.activate_count ~= 0 then
			ailment_name = ailment_name .. "x" .. tostring(ailment.activate_count);
		end

		drawing.draw_label(monster.ailments[ailments.stun_id].ailment_buildup_highlighted_UI.ailment_name_label, ailment_buildups_position_on_screen, opacity_scale, ailment_name);

		local last_j = 0;
		for j, _player in ipairs(displayed_players) do
			local ailment_buildup_position_on_screen = {
				x = ailment_buildups_position_on_screen.x + config.current_config.large_monster_UI.highlighted.ailment_buildups.player_spacing.x * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier,
				y = ailment_buildups_position_on_screen.y + config.current_config.large_monster_UI.highlighted.ailment_buildups.player_spacing.y * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier;
			};

			ailment_buildup_UI_entity.draw_highlighted(_player, monster.ailments[ailments.stun_id].ailment_buildup_highlighted_UI, ailment_buildup_position_on_screen, opacity_scale, top_buildup);

			last_j = j;
		end

		local total_buildup_position_on_screen = {
			x = ailment_buildups_position_on_screen.x + config.current_config.large_monster_UI.highlighted.ailment_buildups.player_spacing.x * last_j * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = ailment_buildups_position_on_screen.y + config.current_config.large_monster_UI.highlighted.ailment_buildups.player_spacing.y * last_j * config.current_config.global_settings.modifiers.global_scale_modifier;
		};

		drawing.draw_label(monster.ailments[ailments.stun_id].ailment_buildup_highlighted_UI.total_buildup_label, total_buildup_position_on_screen, opacity_scale, language.current_language.UI.total_buildup);

		drawing.draw_label(monster.ailments[ailments.stun_id].ailment_buildup_highlighted_UI.total_buildup_value_label, total_buildup_position_on_screen, opacity_scale, total_buildup);

		ailment_buildups_position_on_screen = {
			x = total_buildup_position_on_screen.x + config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_spacing.x * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = total_buildup_position_on_screen.y + 17 + config.current_config.large_monster_UI.highlighted.ailment_buildups.ailment_spacing.y * config.current_config.global_settings.modifiers.global_scale_modifier
		};

		::continue::
	end

	
end

function ailment_buildup.draw_small(monster, ailment_buildups_position_on_screen, opacity_scale)
	if not config.current_config.small_monster_UI.ailment_buildups.enabled then
		return;
	end

	for id, ailment in pairs(monster.ailments) do
		if id == ailments.stun_id then
			if not config.current_config.small_monster_UI.ailment_buildups.filter.stun then
				goto continue;
			end
			
		elseif id == ailments.poison_id then
			if not config.current_config.small_monster_UI.ailment_buildups.filter.poison then
				goto continue;
			end
		elseif id == ailments.blast_id then
			if not config.current_config.small_monster_UI.ailment_buildups.filter.blast then
				goto continue;
			end
		else
			goto continue;
		end

		if config.current_config.small_monster_UI.ailment_buildups.settings.time_limit ~= 0 and time.total_elapsed_seconds - ailment.last_change_time > config.current_config.small_monster_UI.ailment_buildups.settings.time_limit then
			goto continue;
		end

		local total_buildup = 0;
		local top_buildup = 0;

		local displayed_players = {};
		for player_id, player_buildup in pairs(ailment.buildup) do
			total_buildup = total_buildup + player_buildup;

			if player_buildup > top_buildup then
				top_buildup = player_buildup;
			end

			table.insert(displayed_players,
			{
					["buildup"] = player_buildup,
					["buildup_share"] = ailment.buildup_share[player_id],
					["id"] = player_id
				}
			);
		end

		if total_buildup == 0 then
			goto continue;
		end

		if config.current_config.small_monster_UI.ailment_buildups.sorting.type == "Normal" then
			if config.current_config.small_monster_UI.ailment_buildups.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.id < right.id;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.id > right.id;
				end);
			end
		elseif config.current_config.small_monster_UI.ailment_buildups.sorting.type == "Buildup" then
			if config.current_config.small_monster_UI.ailment_buildups.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.buildup < right.buildup;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.buildup > right.buildup;
				end);
			end
		elseif config.current_config.small_monster_UI.ailment_buildups.sorting.type == "Buildup Percentage" then
			if config.current_config.small_monster_UI.ailment_buildups.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.buildup_share < right.buildup_share;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.buildup_share > right.buildup_share;
				end);
			end
		end

		local ailment_name = "";
		if config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.include.ailment_name then
			ailment_name = ailment.name .. " ";
		end
		if config.current_config.small_monster_UI.ailment_buildups.ailment_name_label.include.activation_count and ailment.activate_count ~= 0 then
			ailment_name = ailment_name .. "x" .. tostring(ailment.activate_count);
		end

		drawing.draw_label(monster.ailments[ailments.stun_id].ailment_buildup_small_UI.ailment_name_label, ailment_buildups_position_on_screen, opacity_scale, ailment_name);

		local last_j = 0;
		for j, _player in ipairs(displayed_players) do
			local ailment_buildup_position_on_screen = {
				x = ailment_buildups_position_on_screen.x + config.current_config.small_monster_UI.ailment_buildups.player_spacing.x * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier,
				y = ailment_buildups_position_on_screen.y + config.current_config.small_monster_UI.ailment_buildups.player_spacing.y * (j - 1) * config.current_config.global_settings.modifiers.global_scale_modifier;
			};

			ailment_buildup_UI_entity.draw_small(_player, monster.ailments[ailments.stun_id].ailment_buildup_small_UI, ailment_buildup_position_on_screen, opacity_scale, top_buildup);

			last_j = j;
		end

		local total_buildup_position_on_screen = {
			x = ailment_buildups_position_on_screen.x + config.current_config.small_monster_UI.ailment_buildups.player_spacing.x * last_j * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = ailment_buildups_position_on_screen.y + config.current_config.small_monster_UI.ailment_buildups.player_spacing.y * last_j * config.current_config.global_settings.modifiers.global_scale_modifier;
		};

		drawing.draw_label(monster.ailments[ailments.stun_id].ailment_buildup_small_UI.total_buildup_label, total_buildup_position_on_screen, opacity_scale, language.current_language.UI.total_buildup);

		drawing.draw_label(monster.ailments[ailments.stun_id].ailment_buildup_small_UI.total_buildup_value_label, total_buildup_position_on_screen, opacity_scale, total_buildup);

		ailment_buildups_position_on_screen = {
			x = total_buildup_position_on_screen.x + config.current_config.small_monster_UI.ailment_buildups.ailment_spacing.x * config.current_config.global_settings.modifiers.global_scale_modifier,
			y = total_buildup_position_on_screen.y + 17 + config.current_config.small_monster_UI.ailment_buildups.ailment_spacing.y * config.current_config.global_settings.modifiers.global_scale_modifier
		};

		::continue::
	end

	
end

function ailment_buildup.init_module()
	player = require("MHR_Overlay.Damage_Meter.player");
	language = require("MHR_Overlay.Misc.language");
	config = require("MHR_Overlay.Misc.config");
	ailments = require("MHR_Overlay.Monsters.ailments");
	ailment_buildup_UI_entity = require("MHR_Overlay.UI.UI_Entities.ailment_buildup_UI_entity");
	time = require("MHR_Overlay.Game_Handler.time");
	small_monster = require("MHR_Overlay.Monsters.small_monster");
	large_monster = require("MHR_Overlay.Monsters.large_monster");
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	drawing = require("MHR_Overlay.UI.drawing");
end

return ailment_buildup;