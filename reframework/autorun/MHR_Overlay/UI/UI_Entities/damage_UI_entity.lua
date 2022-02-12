local damage_UI_entity = {};
local table_helpers;
local drawing;
local config;
local player;
local language;

function damage_UI_entity.new(bar, highlighted_bar, player_name_label, value_label, percentage_label)
	local entity = {};

	--entity.visibility = visibility;
	entity.bar = table_helpers.deep_copy(bar);
	entity.highlighted_bar = table_helpers.deep_copy(highlighted_bar);
	entity.player_name_label = table_helpers.deep_copy(player_name_label);
	entity.value_label = table_helpers.deep_copy(value_label);
	entity.percentage_label = table_helpers.deep_copy(percentage_label);

	return entity;
end

function damage_UI_entity.draw(_player, position_on_screen, opacity_scale, top_damage)

	local player_include = config.current_config.damage_meter_UI.player_name_label.include.others;
	if _player.id == _player.myself_id then
		player_include = config.current_config.damage_meter_UI.player_name_label.include.myself;
	end
	
	local player_name_text = "";
	if player_include.hunter_rank then
		player_name_text = string.format("[%d] ", _player.hunter_rank);
	end

	if player_include.word_player then
		player_name_text = player_name_text .. language.current_config.UI.player .. " ";
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
	if config.current_config.damage_meter_UI.settings.damage_bar_relative_to == "Total Damage" then
		if player.total.display.total_damage ~= 0 then
			player_damage_bar_percentage = _player.display.total_damage / player.total.display.total_damage;
		end
	else
		if top_damage ~= 0 then
			player_damage_bar_percentage = _player.display.total_damage / top_damage;
		end
	end

	if _player.id == player.myself_id and config.current_config.damage_meter_UI.settings.highlighted_bar == "Me" then
		drawing.draw_bar(_player.damage_UI.highlighted_bar, position_on_screen, opacity_scale, player_damage_bar_percentage);
	elseif config.current_config.damage_meter_UI.settings.highlighted_bar == "Top Damage" and _player.display.total_damage == top_damage then
		drawing.draw_bar(_player.damage_UI.highlighted_bar, position_on_screen, opacity_scale, player_damage_bar_percentage);
	else
		drawing.draw_bar(_player.damage_UI.bar, position_on_screen, opacity_scale, player_damage_bar_percentage);
	end

	drawing.draw_label(_player.damage_UI.player_name_label, position_on_screen, opacity_scale, player_name_text);
	drawing.draw_label(_player.damage_UI.value_label, position_on_screen, opacity_scale, _player.display.total_damage);
	drawing.draw_label(_player.damage_UI.percentage_label, position_on_screen, opacity_scale, 100 * player_damage_percentage);
end

function damage_UI_entity.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	drawing = require("MHR_Overlay.UI.drawing");
	config = require("MHR_Overlay.Misc.config");
	player = require("MHR_Overlay.Damage_Meter.player");
	language = require("MHR_Overlay.Misc.language");
end

return damage_UI_entity;