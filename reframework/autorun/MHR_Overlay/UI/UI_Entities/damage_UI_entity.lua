local damage_UI_entity = {};
local table_helpers;
local drawing;
local config;
local player;
local language;

function damage_UI_entity.new(bar, highlighted_bar, player_name_label, dps_label, hunter_rank_label, value_label,
                              percentage_label, cart_count_label)
	local entity = {};

	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;

	--entity.visibility = visibility;
	entity.bar = table_helpers.deep_copy(bar);
	entity.highlighted_bar = table_helpers.deep_copy(highlighted_bar);
	entity.player_name_label = table_helpers.deep_copy(player_name_label);
	entity.dps_label = table_helpers.deep_copy(dps_label);
	entity.hunter_rank_label = table_helpers.deep_copy(hunter_rank_label);
	entity.cart_count_label = table_helpers.deep_copy(cart_count_label);
	entity.value_label = table_helpers.deep_copy(value_label);
	entity.percentage_label = table_helpers.deep_copy(percentage_label);

	entity.bar.offset.x = entity.bar.offset.x * global_scale_modifier;
	entity.bar.offset.y = entity.bar.offset.y * global_scale_modifier;
	entity.bar.size.width = entity.bar.size.width * global_scale_modifier;
	entity.bar.size.height = entity.bar.size.height * global_scale_modifier;
	entity.bar.outline.thickness = entity.bar.outline.thickness * global_scale_modifier;
	entity.bar.outline.offset = entity.bar.outline.offset * global_scale_modifier;

	entity.highlighted_bar.offset.x = entity.highlighted_bar.offset.x * global_scale_modifier;
	entity.highlighted_bar.offset.y = entity.highlighted_bar.offset.y * global_scale_modifier;
	entity.highlighted_bar.size.width = entity.highlighted_bar.size.width * global_scale_modifier;
	entity.highlighted_bar.size.height = entity.highlighted_bar.size.height * global_scale_modifier;
	entity.highlighted_bar.outline.thickness = entity.highlighted_bar.outline.thickness * global_scale_modifier;
	entity.highlighted_bar.outline.offset = entity.highlighted_bar.outline.offset * global_scale_modifier;

	entity.player_name_label.offset.x = entity.player_name_label.offset.x * global_scale_modifier;
	entity.player_name_label.offset.y = entity.player_name_label.offset.y * global_scale_modifier;

	entity.player_name_size_limit = config.current_config.damage_meter_UI.settings.player_name_size_limit *
		global_scale_modifier;

	entity.dps_label.offset.x = entity.dps_label.offset.x * global_scale_modifier;
	entity.dps_label.offset.y = entity.dps_label.offset.y * global_scale_modifier;

	entity.hunter_rank_label.offset.x = entity.hunter_rank_label.offset.x * global_scale_modifier;
	entity.hunter_rank_label.offset.y = entity.hunter_rank_label.offset.y * global_scale_modifier;

	entity.cart_count_label.offset.x = entity.cart_count_label.offset.x * global_scale_modifier;
	entity.cart_count_label.offset.y = entity.cart_count_label.offset.y * global_scale_modifier;

	entity.value_label.offset.x = entity.value_label.offset.x * global_scale_modifier;
	entity.value_label.offset.y = entity.value_label.offset.y * global_scale_modifier;

	entity.percentage_label.offset.x = entity.percentage_label.offset.x * global_scale_modifier;
	entity.percentage_label.offset.y = entity.percentage_label.offset.y * global_scale_modifier;

	return entity;
end

function damage_UI_entity.draw(_player, position_on_screen, opacity_scale, top_damage, top_dps)
	local cached_config = config.current_config.damage_meter_UI;

	local player_include = cached_config.player_name_label.include.others;
	if _player.id == player.myself.id then
		player_include = cached_config.player_name_label.include.myself;
	end

	local player_name_text = "";

	if player_include.master_rank and player_include.hunter_rank then
		player_name_text = string.format("[%d:%d] ", _player.master_rank, _player.hunter_rank);
	elseif player_include.master_rank then
		player_name_text = string.format("[%d] ", _player.master_rank);
	elseif player_include.hunter_rank then
		player_name_text = string.format("[%d] ", _player.hunter_rank);
	end

	if player_include.cart_count then
		player_name_text = player_name_text .. string.format("x%d ", _player.cart_count);
	end


	if player_include.word_player then
		player_name_text = player_name_text .. language.current_language.UI.player .. " ";
	end

	if player_include.player_id then
		player_name_text = player_name_text .. string.format("%d ", _player.id);
	end

	if player_include.player_name then
		player_name_text = player_name_text .. _player.name;
	end

	local player_damage_percentage = 0;
	if player.total.display.total_damage ~= 0 then
		player_damage_percentage = _player.display.total_damage / player.total.display.total_damage;
	end

	local player_damage_bar_percentage = 0;
	if cached_config.settings.damage_bar_relative_to == "Total Damage" then
		if player.total.display.total_damage ~= 0 then
			player_damage_bar_percentage = _player.display.total_damage / player.total.display.total_damage;
		end
	else
		if top_damage ~= 0 then
			player_damage_bar_percentage = _player.display.total_damage / top_damage;
		end
	end



	if _player.id == player.myself.id and cached_config.settings.highlighted_bar == "Me" then
		drawing.draw_bar(_player.damage_UI.highlighted_bar, position_on_screen, opacity_scale, player_damage_bar_percentage);
	elseif cached_config.settings.highlighted_bar == "Top Damage" and _player.display.total_damage == top_damage then
		drawing.draw_bar(_player.damage_UI.highlighted_bar, position_on_screen, opacity_scale, player_damage_bar_percentage);
	elseif cached_config.settings.highlighted_bar == "Top DPS" and _player.dps == top_dps then
		drawing.draw_bar(_player.damage_UI.highlighted_bar, position_on_screen, opacity_scale, player_damage_bar_percentage);
	else
		drawing.draw_bar(_player.damage_UI.bar, position_on_screen, opacity_scale, player_damage_bar_percentage);
	end

	if _player.id == player.myself.id then
		if _player.damage_UI.hunter_rank_label.include.myself.master_rank and
			_player.damage_UI.hunter_rank_label.include.myself.hunter_rank then
			drawing.draw_label(_player.damage_UI.hunter_rank_label, position_on_screen, opacity_scale,
				string.format("%d:%d", _player.master_rank, _player.hunter_rank));
		elseif _player.damage_UI.hunter_rank_label.include.myself.master_rank then
			drawing.draw_label(_player.damage_UI.hunter_rank_label, position_on_screen, opacity_scale,
				string.format("%d", _player.master_rank));
		elseif _player.damage_UI.hunter_rank_label.include.myself.hunter_rank then
			drawing.draw_label(_player.damage_UI.hunter_rank_label, position_on_screen, opacity_scale,
				string.format("%d", _player.hunter_rank));
		end
	else
		if _player.damage_UI.hunter_rank_label.include.others.master_rank and
			_player.damage_UI.hunter_rank_label.include.others.hunter_rank then
			drawing.draw_label(_player.damage_UI.hunter_rank_label, position_on_screen, opacity_scale,
				string.format("%d:%d", _player.master_rank, _player.hunter_rank));
		elseif _player.damage_UI.hunter_rank_label.include.others.master_rank then
			drawing.draw_label(_player.damage_UI.hunter_rank_label, position_on_screen, opacity_scale,
				string.format("%d", _player.master_rank));
		elseif _player.damage_UI.hunter_rank_label.include.others.hunter_rank then
			drawing.draw_label(_player.damage_UI.hunter_rank_label, position_on_screen, opacity_scale,
				string.format("%d", _player.hunter_rank));
		end
	end

	player_name_text = drawing.limit_text_size(player_name_text, _player.damage_UI.player_name_size_limit);


	drawing.draw_label(_player.damage_UI.player_name_label, position_on_screen, opacity_scale, player_name_text);
	drawing.draw_label(_player.damage_UI.value_label, position_on_screen, opacity_scale, _player.display.total_damage);
	drawing.draw_label(_player.damage_UI.percentage_label, position_on_screen, opacity_scale, 100 * player_damage_percentage);
	drawing.draw_label(_player.damage_UI.dps_label, position_on_screen, opacity_scale, _player.dps);
	drawing.draw_label(_player.damage_UI.cart_count_label, position_on_screen, opacity_scale, _player.cart_count);
end

function damage_UI_entity.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	drawing = require("MHR_Overlay.UI.drawing");
	config = require("MHR_Overlay.Misc.config");
	player = require("MHR_Overlay.Damage_Meter.player");
	language = require("MHR_Overlay.Misc.language");
end

return damage_UI_entity;
