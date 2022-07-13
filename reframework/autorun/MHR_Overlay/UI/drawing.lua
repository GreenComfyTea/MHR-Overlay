local drawing = {};
local config;

drawing.font = nil;

function drawing.init_font()
	local cached_config = config.current_config.global_settings.UI_font;
	drawing.font = d2d.Font.new(cached_config.family, cached_config.size, cached_config.bold, cached_config.italic);
end

function drawing.argb_color_to_abgr_color(argb_color)
	local alpha = (argb_color >> 24) & 0xFF;
	local red = (argb_color >> 16) & 0xFF;
	local green = (argb_color >> 8) & 0xFF;
	local blue = argb_color & 0xFF;

	local abgr_color = 0x1000000 * alpha + 0x10000 * blue + 0x100 * green + red;

	return abgr_color;
end

function drawing.color_to_argb(color)
	local alpha = (color >> 24) & 0xFF;
	local red = (color >> 16) & 0xFF;
	local green = (color >> 8) & 0xFF;
	local blue = color & 0xFF;

	return alpha, red, green, blue;
end

function drawing.argb_to_color(alpha, red, green, blue)
    return 0x1000000 * alpha + 0x10000 * red + 0x100 * green + blue;
end

function drawing.limit_text_size(text, size_limit)
	if d2d == nil then
		return text;
	end

	--do return end;

	local limited_text = text;
	while true do
		local text_width, text_height = drawing.font:measure(limited_text);

		if text_width < size_limit then
			return limited_text;
		else
			limited_text = limited_text:sub(1, -5) .. "...";
		end
	end
end

function drawing.scale_color_opacity(color, scale)
	local  alpha, red, green, blue = drawing.color_to_argb(color);
	local new_alpha = math.floor(alpha * scale);
	if new_alpha < 0 then new_alpha = 0; end
	if new_alpha > 255 then new_alpha = 255; end

	return drawing.argb_to_color(new_alpha, red, green, blue);
end

function drawing.scale_bar_opacity(bar, scale)
	if bar == nil
	or scale == nil
	or not bar.visibility then
		return;
	end
	
	bar.colors.foreground = drawing.scale_color_opacity(bar.colors.foreground, scale);
	bar.colors.background = drawing.scale_color_opacity(bar.colors.background, scale);
end

function drawing.scale_label_opacity(label, scale)
	if label == nil
	or scale == nil
	or not label.visibility then
		return;
	end

	label.color = drawing.scale_color_opacity(label.color, scale);
	label.shadow.color = drawing.scale_color_opacity(label.shadow.color, scale);
end

function drawing.draw_label(label, position, opacity_scale, ...)
	if label == nil
	or not label.visibility then
		return;
	end
	
	local text = string.format(label.text, table.unpack({...}));
	local position_x = position.x + label.offset.x;
	local position_y = position.y + label.offset.y;
	
	if label.shadow.visibility then
		local new_shadow_color = label.shadow.color;
		
		if opacity_scale < 1 then
			new_shadow_color = drawing.scale_color_opacity(new_shadow_color, opacity_scale);
		end

		if d2d ~= nil then
			d2d.text(drawing.font, text, position_x + label.shadow.offset.x, position_y + label.shadow.offset.y, new_shadow_color);
		else
			new_shadow_color = drawing.argb_color_to_abgr_color(new_shadow_color);
			draw.text(text, position_x + label.shadow.offset.x, position_y + label.shadow.offset.y, new_shadow_color);
		end
	end

	local new_color = label.color;
	if opacity_scale < 1 then
		new_color = drawing.scale_color_opacity(new_color, opacity_scale);
	end

	if d2d ~= nil then
		d2d.text(drawing.font, text, position_x, position_y, new_color);
	else
		new_color = drawing.argb_color_to_abgr_color(new_color);
		draw.text(text, position_x, position_y, new_color);
	end
	
end

function drawing.draw_bar(bar, position, opacity_scale, percentage)
	if bar == nil
	or not bar.visibility then
		return;
	end

	if percentage > 1 then
		percentage = 1;
	end

	if percentage < 0 then
		percentage = 0;
	end

	local position_x = position.x + bar.offset.x;
	local position_y = position.y + bar.offset.y;
	local foreground_width = bar.size.width * percentage;
	local background_width = bar.size.width - foreground_width;

	local new_foreground_color = bar.colors.foreground;
	local new_background_color = bar.colors.background;

	if opacity_scale < 1 then
		new_foreground_color = drawing.scale_color_opacity(new_foreground_color, opacity_scale);
		new_background_color = drawing.scale_color_opacity(new_background_color, opacity_scale);
	end

	-- foreground
	if d2d ~= nil then
		d2d.fill_rect(position_x, position_y, foreground_width, bar.size.height, new_foreground_color);
	else
		new_foreground_color = drawing.argb_color_to_abgr_color(new_foreground_color);
		draw.filled_rect(position_x, position_y, foreground_width, bar.size.height, new_foreground_color)
	end
	
	-- background
	if d2d ~= nil then
		d2d.fill_rect(position_x + foreground_width, position_y, background_width, bar.size.height, new_background_color);
	else
		new_background_color = drawing.argb_color_to_abgr_color(new_background_color);
		draw.filled_rect(position_x + foreground_width, position_y, background_width, bar.size.height, new_background_color)
	end
end

function drawing.draw_capture_line(bar, position, opacity_scale, percentage)
	if bar == nil
	or bar.capture_line == nil
	or not bar.visibility
	or not bar.capture_line.visibility
	or percentage >= 1
	or percentage <= 0 then
		return;
	end

	
	local position_x = position.x + bar.offset.x + bar.capture_line.offset.x + bar.size.width * percentage;
	local position_y = position.y + bar.offset.y + bar.capture_line.offset.y;

	local color = bar.capture_line.color;

	if opacity_scale < 1 then
		color  = drawing.scale_color_opacity(color, opacity_scale);
	end

	if d2d ~= nil then
		d2d.fill_rect(position_x, position_y, bar.capture_line.size.width, bar.capture_line.size.height, color);
	else
		color = drawing.argb_color_to_abgr_color(color);
		draw.filled_rect(position_x, position_y, bar.capture_line.size.width, bar.capture_line.size.height, color)
	end
end

function drawing.init_module()
	config = require("MHR_Overlay.Misc.config");
end

return drawing;