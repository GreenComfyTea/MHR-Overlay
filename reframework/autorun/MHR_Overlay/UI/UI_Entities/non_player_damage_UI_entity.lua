local non_player_damage_UI_entity = {};
local table_helpers;
local drawing;
local config;
local player;
local language;

function non_player_damage_UI_entity.new(bar, highlighted_bar, name_label, dps_label, value_label, percentage_label)
	local entity = {};
	
	local global_scale_modifier = config.current_config.global_settings.modifiers.global_scale_modifier;
	

	--entity.visibility = visibility;
	entity.bar = table_helpers.deep_copy(bar);
	entity.highlighted_bar = table_helpers.deep_copy(highlighted_bar);
	entity.name_label = table_helpers.deep_copy(name_label);
	entity.dps_label = table_helpers.deep_copy(dps_label);
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

	entity.name_label.offset.x = entity.name_label.offset.x * global_scale_modifier;
	entity.name_label.offset.y = entity.name_label.offset.y * global_scale_modifier;

	entity.name_size_limit = config.current_config.damage_meter_UI.settings.player_name_size_limit * global_scale_modifier;

	entity.dps_label.offset.x = entity.dps_label.offset.x * global_scale_modifier;
	entity.dps_label.offset.y = entity.dps_label.offset.y * global_scale_modifier;

	entity.value_label.offset.x = entity.value_label.offset.x * global_scale_modifier;
	entity.value_label.offset.y = entity.value_label.offset.y * global_scale_modifier;

	entity.percentage_label.offset.x = entity.percentage_label.offset.x * global_scale_modifier;
	entity.percentage_label.offset.y = entity.percentage_label.offset.y * global_scale_modifier;

	return entity;
end

function non_player_damage_UI_entity.draw(non_player, position_on_screen, opacity_scale, top_damage, top_dps)
	local cached_config = config.current_config.damage_meter_UI;

	local include = cached_config.player_name_label.include.others;

	local name_text = "";

	if include.type then
		if non_player.is_otomo then
			name_text = name_text .. language.current_language.UI.otomo .. " ";
		else
			name_text = name_text .. language.current_language.UI.servant .. " ";
		end
	end

	if include.id then
		name_text = name_text .. string.format("%d ", non_player.id);
	end

	if include.name then
		name_text = name_text .. non_player.name;
	end

	local player_damage_percentage = 0;
	if player.total.display.total_damage ~= 0 then
		player_damage_percentage = non_player.display.total_damage / player.total.display.total_damage;
	end

	local player_damage_bar_percentage = 0;
	if cached_config.settings.damage_bar_relative_to == "Total Damage" then
		if player.total.display.total_damage ~= 0 then
			player_damage_bar_percentage = non_player.display.total_damage / player.total.display.total_damage;
		end
	else
		if top_damage ~= 0 then
			player_damage_bar_percentage = non_player.display.total_damage / top_damage;
		end
	end

	if cached_config.settings.highlighted_bar == "Top Damage" and non_player.display.total_damage == top_damage then
		drawing.draw_bar(non_player.damage_UI.highlighted_bar, position_on_screen, opacity_scale, player_damage_bar_percentage);
	elseif cached_config.settings.highlighted_bar == "Top DPS" and non_player.dps == top_dps then
		drawing.draw_bar(non_player.damage_UI.highlighted_bar, position_on_screen, opacity_scale, player_damage_bar_percentage);
	else
		drawing.draw_bar(non_player.damage_UI.bar, position_on_screen, opacity_scale, player_damage_bar_percentage);
	end

	name_text = drawing.limit_text_size(name_text, non_player.damage_UI.name_size_limit);

	drawing.draw_label(non_player.damage_UI.name_label, position_on_screen, opacity_scale, name_text);
	drawing.draw_label(non_player.damage_UI.value_label, position_on_screen, opacity_scale, non_player.display.total_damage);
	drawing.draw_label(non_player.damage_UI.percentage_label, position_on_screen, opacity_scale, 100 * player_damage_percentage);
	drawing.draw_label(non_player.damage_UI.dps_label, position_on_screen, opacity_scale, non_player.dps);
end

function non_player_damage_UI_entity.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	drawing = require("MHR_Overlay.UI.drawing");
	config = require("MHR_Overlay.Misc.config");
	player = require("MHR_Overlay.Damage_Meter.player");
	language = require("MHR_Overlay.Misc.language");
end

return non_player_damage_UI_entity;
