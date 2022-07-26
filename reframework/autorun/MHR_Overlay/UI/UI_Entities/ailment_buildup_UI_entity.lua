local ailment_buildup_UI_entity = {};
local table_helpers;
local drawing;
local config;
local player;
local language;

function ailment_buildup_UI_entity.new(buildup_bar, highlighted_buildup_bar, ailment_name_label, player_name_label,
                                       buildup_value_label, buildup_percentage_label, total_buildup_label,
                                       total_buildup_value_label)
	local entity = {};

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	--entity.visibility = visibility;
	entity.buildup_bar = table_helpers.deep_copy(buildup_bar);
	entity.highlighted_buildup_bar = table_helpers.deep_copy(highlighted_buildup_bar);
	entity.ailment_name_label = table_helpers.deep_copy(ailment_name_label);
	entity.player_name_label = table_helpers.deep_copy(player_name_label);
	entity.buildup_value_label = table_helpers.deep_copy(buildup_value_label);
	entity.buildup_percentage_label = table_helpers.deep_copy(buildup_percentage_label);
	entity.total_buildup_label = table_helpers.deep_copy(total_buildup_label);
	entity.total_buildup_value_label = table_helpers.deep_copy(total_buildup_value_label);

	entity.buildup_bar.offset.x = entity.buildup_bar.offset.x * global_scale_modifier;
	entity.buildup_bar.offset.y = entity.buildup_bar.offset.y * global_scale_modifier;
	entity.buildup_bar.size.width = entity.buildup_bar.size.width * global_scale_modifier;
	entity.buildup_bar.size.height = entity.buildup_bar.size.height * global_scale_modifier;
	entity.buildup_bar.outline.thickness = entity.buildup_bar.outline.thickness * global_scale_modifier;
	entity.buildup_bar.outline.offset = entity.buildup_bar.outline.offset * global_scale_modifier;

	entity.highlighted_buildup_bar.offset.x = entity.highlighted_buildup_bar.offset.x * global_scale_modifier;
	entity.highlighted_buildup_bar.offset.y = entity.highlighted_buildup_bar.offset.y * global_scale_modifier;
	entity.highlighted_buildup_bar.size.width = entity.highlighted_buildup_bar.size.width * global_scale_modifier;
	entity.highlighted_buildup_bar.size.height = entity.highlighted_buildup_bar.size.height * global_scale_modifier;
	entity.highlighted_buildup_bar.outline.thickness = entity.highlighted_buildup_bar.outline.thickness *
		global_scale_modifier;
	entity.highlighted_buildup_bar.outline.offset = entity.highlighted_buildup_bar.outline.offset * global_scale_modifier;

	entity.player_name_label.offset.x = entity.player_name_label.offset.x * global_scale_modifier;
	entity.player_name_label.offset.y = entity.player_name_label.offset.y * global_scale_modifier;

	entity.buildup_value_label.offset.x = entity.buildup_value_label.offset.x * global_scale_modifier;
	entity.buildup_value_label.offset.y = entity.buildup_value_label.offset.y * global_scale_modifier;

	entity.buildup_percentage_label.offset.x = entity.buildup_percentage_label.offset.x * global_scale_modifier
	entity.buildup_percentage_label.offset.y = entity.buildup_percentage_label.offset.y * global_scale_modifier;

	entity.total_buildup_label.offset.x = entity.total_buildup_label.offset.x * global_scale_modifier;
	entity.total_buildup_label.offset.y = entity.total_buildup_label.offset.y * global_scale_modifier;

	entity.total_buildup_value_label.offset.x = entity.total_buildup_value_label.offset.x * global_scale_modifier;
	entity.total_buildup_value_label.offset.y = entity.total_buildup_value_label.offset.y * global_scale_modifier;

	return entity;
end

function ailment_buildup_UI_entity.draw_dynamic(_player, ailment_buildup_UI, position_on_screen, opacity_scale,
                                                top_buildup)
	local cached_config = config.current_config.large_monster_UI.dynamic.ailment_buildups;

	local player_buildup_bar_percentage = 0;
	if cached_config.settings.buildup_bar_relative_to == "Total Buildup" then
		player_buildup_bar_percentage = _player.buildup_share;
	else
		if top_buildup ~= 0 then
			player_buildup_bar_percentage = _player.buildup / top_buildup;
		end
	end

	if _player.id == player.myself.id and cached_config.settings.highlighted_bar == "Me" then
		drawing.draw_bar(ailment_buildup_UI.highlighted_buildup_bar, position_on_screen, opacity_scale,
			player_buildup_bar_percentage);
	elseif cached_config.settings.highlighted_bar == "Top Buildup" and _player.buildup == top_buildup then
		drawing.draw_bar(ailment_buildup_UI.highlighted_buildup_bar, position_on_screen, opacity_scale,
			player_buildup_bar_percentage);
	else
		drawing.draw_bar(ailment_buildup_UI.buildup_bar, position_on_screen, opacity_scale, player_buildup_bar_percentage);
	end

	drawing.draw_label(ailment_buildup_UI.player_name_label, position_on_screen, opacity_scale,
		player.get_player(_player.id).name);
	drawing.draw_label(ailment_buildup_UI.buildup_value_label, position_on_screen, opacity_scale, _player.buildup);
	drawing.draw_label(ailment_buildup_UI.buildup_percentage_label, position_on_screen, opacity_scale,
		100 * _player.buildup_share);
end

function ailment_buildup_UI_entity.draw_static(_player, ailment_buildup_UI, position_on_screen, opacity_scale,
                                               top_buildup)
	local cached_config = config.current_config.large_monster_UI.static.ailment_buildups;

	local player_buildup_bar_percentage = 0;
	if cached_config.settings.buildup_bar_relative_to == "Total Buildup" then
		player_buildup_bar_percentage = _player.buildup_share;
	else
		if top_buildup ~= 0 then
			player_buildup_bar_percentage = _player.buildup / top_buildup;
		end
	end

	if _player.id == player.myself.id and cached_config.settings.highlighted_bar == "Me" then
		drawing.draw_bar(ailment_buildup_UI.highlighted_buildup_bar, position_on_screen, opacity_scale,
			player_buildup_bar_percentage);
	elseif cached_config.settings.highlighted_bar == "Top Buildup" and _player.buildup == top_buildup then
		drawing.draw_bar(ailment_buildup_UI.highlighted_buildup_bar, position_on_screen, opacity_scale,
			player_buildup_bar_percentage);
	else
		drawing.draw_bar(ailment_buildup_UI.buildup_bar, position_on_screen, opacity_scale, player_buildup_bar_percentage);
	end

	drawing.draw_label(ailment_buildup_UI.player_name_label, position_on_screen, opacity_scale,
		player.get_player(_player.id).name);
	drawing.draw_label(ailment_buildup_UI.buildup_value_label, position_on_screen, opacity_scale, _player.buildup);
	drawing.draw_label(ailment_buildup_UI.buildup_percentage_label, position_on_screen, opacity_scale,
		100 * _player.buildup_share);
end

function ailment_buildup_UI_entity.draw_highlighted(_player, ailment_buildup_UI, position_on_screen, opacity_scale,
                                                    top_buildup)
	local cached_config = config.current_config.large_monster_UI.highlighted.ailment_buildups;

	local player_buildup_bar_percentage = 0;
	if cached_config.settings.buildup_bar_relative_to == "Total Buildup" then
		player_buildup_bar_percentage = _player.buildup_share;
	else
		if top_buildup ~= 0 then
			player_buildup_bar_percentage = _player.buildup / top_buildup;
		end
	end

	if _player.id == player.myself.id and cached_config.settings.highlighted_bar == "Me" then
		drawing.draw_bar(ailment_buildup_UI.highlighted_buildup_bar, position_on_screen, opacity_scale,
			player_buildup_bar_percentage);
	elseif cached_config.settings.highlighted_bar == "Top Buildup" and _player.buildup == top_buildup then
		drawing.draw_bar(ailment_buildup_UI.highlighted_buildup_bar, position_on_screen, opacity_scale,
			player_buildup_bar_percentage);
	else
		drawing.draw_bar(ailment_buildup_UI.buildup_bar, position_on_screen, opacity_scale, player_buildup_bar_percentage);
	end

	drawing.draw_label(ailment_buildup_UI.player_name_label, position_on_screen, opacity_scale,
		player.get_player(_player.id).name);
	drawing.draw_label(ailment_buildup_UI.buildup_value_label, position_on_screen, opacity_scale, _player.buildup);
	drawing.draw_label(ailment_buildup_UI.buildup_percentage_label, position_on_screen, opacity_scale,
		100 * _player.buildup_share);
end

function ailment_buildup_UI_entity.draw_small(_player, ailment_buildup_UI, position_on_screen, opacity_scale, top_buildup)
	local cached_config = config.current_config.small_monster_UI.ailment_buildups;

	local player_buildup_bar_percentage = 0;
	if cached_config.settings.buildup_bar_relative_to == "Total Buildup" then
		player_buildup_bar_percentage = _player.buildup_share;
	else
		if top_buildup ~= 0 then
			player_buildup_bar_percentage = _player.buildup / top_buildup;
		end
	end

	if _player.id == player.myself.id and cached_config.settings.highlighted_bar == "Me" then
		drawing.draw_bar(ailment_buildup_UI.highlighted_buildup_bar, position_on_screen, opacity_scale,
			player_buildup_bar_percentage);
	elseif cached_config.settings.highlighted_bar == "Top Buildup" and _player.buildup == top_buildup then
		drawing.draw_bar(ailment_buildup_UI.highlighted_buildup_bar, position_on_screen, opacity_scale,
			player_buildup_bar_percentage);
	else
		drawing.draw_bar(ailment_buildup_UI.buildup_bar, position_on_screen, opacity_scale, player_buildup_bar_percentage);
	end

	drawing.draw_label(ailment_buildup_UI.player_name_label, position_on_screen, opacity_scale,
		player.get_player(_player.id).name);
	drawing.draw_label(ailment_buildup_UI.buildup_value_label, position_on_screen, opacity_scale, _player.buildup);
	drawing.draw_label(ailment_buildup_UI.buildup_percentage_label, position_on_screen, opacity_scale,
		100 * _player.buildup_share);
end

function ailment_buildup_UI_entity.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	drawing = require("MHR_Overlay.UI.drawing");
	config = require("MHR_Overlay.Misc.config");
	player = require("MHR_Overlay.Damage_Meter.player");
	language = require("MHR_Overlay.Misc.language");
end

return ailment_buildup_UI_entity;
