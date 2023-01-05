local ailment_buildup = {};
local players;
local language;
local config;
local ailments;
local ailment_buildup_UI_entity;
local time;
local small_monster;
local large_monster;
local table_helpers;
local drawing;

function ailment_buildup.draw(monster, ailment_buildup_UI, cached_config, ailment_buildups_position_on_screen, opacity_scale)

	local cached_config = cached_config.ailment_buildups;
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	if not cached_config.visibility then
		return;
	end

	for id, ailment in pairs(monster.ailments) do
		if id == ailments.stun_id then
			if not cached_config.filter.stun then
				goto continue
			end

		elseif id == ailments.poison_id then
			if not cached_config.filter.poison then
				goto continue
			end
		elseif id == ailments.blast_id then
			if not cached_config.filter.blast then
				goto continue
			end
		else
			goto continue
		end

		if cached_config.settings.time_limit ~= 0 and
			time.total_elapsed_script_seconds - ailment.last_change_time > cached_config.settings.time_limit then
			goto continue
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
			goto continue
		end

		if cached_config.sorting.type == "Normal" then
			if cached_config.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.id < right.id;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.id > right.id;
				end);
			end
		elseif cached_config.sorting.type == "Buildup" then
			if cached_config.sorting.reversed_order then
				table.sort(displayed_players, function(left, right)
					return left.buildup < right.buildup;
				end);
			else
				table.sort(displayed_players, function(left, right)
					return left.buildup > right.buildup;
				end);
			end
		elseif cached_config.sorting.type == "Buildup Percentage" then
			if cached_config.sorting.reversed_order then
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
		if cached_config.ailment_name_label.include.ailment_name then
			ailment_name = ailment.name .. " ";
		end
		if cached_config.ailment_name_label.include.activation_count and ailment.activate_count ~= 0 then
			ailment_name = ailment_name .. "x" .. tostring(ailment.activate_count);
		end

		drawing.draw_label(ailment_buildup_UI.ailment_name_label, ailment_buildups_position_on_screen, opacity_scale, ailment_name);

		local last_j = 0;
		for j, player in ipairs(displayed_players) do
			local ailment_buildup_position_on_screen = {
				x = ailment_buildups_position_on_screen.x + cached_config.player_spacing.x * (j - 1) * global_scale_modifier,
				y = ailment_buildups_position_on_screen.y + cached_config.player_spacing.y * (j - 1) * global_scale_modifier;
			};

			ailment_buildup_UI_entity.draw(player, ailment_buildup_UI, cached_config, ailment_buildup_position_on_screen, opacity_scale, top_buildup);
			last_j = j;
		end

		local total_buildup_position_on_screen = {
			x = ailment_buildups_position_on_screen.x + cached_config.player_spacing.x * last_j * global_scale_modifier,
			y = ailment_buildups_position_on_screen.y + cached_config.player_spacing.y * last_j * global_scale_modifier;
		};

		drawing.draw_label(ailment_buildup_UI.total_buildup_label, total_buildup_position_on_screen, opacity_scale, language.current_language.UI.total_buildup);
		drawing.draw_label(ailment_buildup_UI.total_buildup_value_label, total_buildup_position_on_screen, opacity_scale, total_buildup);

		ailment_buildups_position_on_screen = {
			x = total_buildup_position_on_screen.x + cached_config.ailment_spacing.x * global_scale_modifier,
			y = total_buildup_position_on_screen.y + 17 + cached_config.ailment_spacing.y * global_scale_modifier
		};

		::continue::
	end


end

function ailment_buildup.init_module()
	players = require("MHR_Overlay.Damage_Meter.players");
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
