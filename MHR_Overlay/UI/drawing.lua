local drawing = {};
local config;

drawing.font = nil;

function drawing.init_font()
	drawing.font = d2d.Font.new(config.current_config.global_settings.font.family, config.current_config.global_settings.font.size, config.current_config.global_settings.font.bold, config.current_config.global_settings.font.italic);
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

function drawing.scale_color_opacity(color, scale)
	local  alpha, red, green, blue = drawing.color_to_argb(color);
	local new_alpha = math.floor(alpha * scale);
	if new_alpha < 0 then new_alpha = 0; end
	if new_alpha > 255 then new_alpha = 255; end

	return drawing.argb_to_color(new_alpha, red, green, blue);
end

function drawing.scale_bar_opacity(bar, scale)
	if bar == nil or scale == nil then
		return;
	end

	if not bar.visibility then
		return;
	end
	
	bar.colors.foreground = drawing.scale_color_opacity(bar.colors.foreground, scale);
	bar.colors.background = drawing.scale_color_opacity(bar.colors.background, scale);
end

function drawing.scale_label_opacity(label, scale)
	if label == nil or scale == nil then
		return;
	end

	if not label.visibility then
		return;
	end
	
	label.color = drawing.scale_color_opacity(label.color, scale);
	label.shadow.color = drawing.scale_color_opacity(label.shadow.color, scale);
end

function drawing.draw_label(label, position, ...)
	if label == nil or not label.visibility then
		return;
	end
	
	local text = string.format(label.text, table.unpack({...}));
	if label.shadow.visibility then
		d2d.text(drawing.font, text, position.x + label.offset.x + label.shadow.offset.x,
			position.y + label.offset.y + label.shadow.offset.y, label.shadow.color);
	end
	d2d.text(drawing.font, text, position.x + label.offset.x, position.y + label.offset.y, label.color);
end

function drawing.draw_bar(bar, position, percentage)
	if bar == nil then
		return;
	end

	if not bar.visibility then
		return;
	end

	if percentage > 1 then 
		percentage = 1;
	end

	local foreground_width = bar.size.width * percentage;
	local background_width = bar.size.width - foreground_width;

	-- foreground
	d2d.fill_rect(position.x + bar.offset.x, position.y + bar.offset.y, foreground_width, bar.size.height,
		bar.colors.foreground);

	-- background
	d2d.fill_rect(position.x + foreground_width + bar.offset.x, position.y + bar.offset.y, background_width,
		bar.size.height, bar.colors.background);
end

function drawing.init_module()
	config = require("MHR_Overlay.Misc.config");
end

return drawing;