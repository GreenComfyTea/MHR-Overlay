local unicode_helpers = {};

-- https://github.com/blitmap/lua-utf8-simple/blob/master/utf8_simple.lua

-- ABNF from RFC 3629
--
-- UTF8-octets = *( UTF8-char )
-- UTF8-char = UTF8-1 / UTF8-2 / UTF8-3 / UTF8-4
-- UTF8-1 = %x00-7F
-- UTF8-2 = %xC2-DF UTF8-tail
-- UTF8-3 = %xE0 %xA0-BF UTF8-tail / %xE1-EC 2( UTF8-tail ) /
-- %xED %x80-9F UTF8-tail / %xEE-EF 2( UTF8-tail )
-- UTF8-4 = %xF0 %x90-BF 2( UTF8-tail ) / %xF1-F3 3( UTF8-tail ) /
-- %xF4 %x80-8F 2( UTF8-tail )
-- UTF8-tail = %x80-BF

-- 0xxxxxxx                            | 007F   (127)
-- 110xxxxx	10xxxxxx                   | 07FF   (2047)
-- 1110xxxx	10xxxxxx 10xxxxxx          | FFFF   (65535)
-- 11110xxx	10xxxxxx 10xxxxxx 10xxxxxx | 10FFFF (1114111)

local pattern = "[%z\1-\127\194-\244][\128-\191]*";

-- helper function
function unicode_helpers.relative_position(position, length)
	if position < 0 then
		position = length + position + 1;
	end
	return position;
end

-- THE MEAT

-- maps f over s's utf8 characters f can accept args: (visual_index, utf8_character, byte_index)
function unicode_helpers.map(s, f, no_subs)
	local i = 0;

	if no_subs then
		for b, e in s:gmatch("()" .. pattern .. "()") do
			i = i + 1;
			local c = e - b;
			f(i, c, b)
		end
	else
		for b, c in s:gmatch("()(" .. pattern .. ")") do
			i = i + 1;
			f(i, c, b);
		end
	end
end

-- THE REST

-- generator for the above -- to iterate over all utf8 chars
function unicode_helpers.chars(s, no_subs)
	return coroutine.wrap(function()
		return unicode_helpers.map(s, coroutine.yield, no_subs);
	end);
end

-- like string.sub() but i, j are utf8 strings
-- a utf8-safe string.sub()
function unicode_helpers.sub(str, i, j)
	if coroutine == nil then
		return str;
	end

	local l = utf8.len(str);

	i = unicode_helpers.relative_position(i, l);
	j = j and unicode_helpers.relative_position(j, l) or l;

	if i < 1 then
		i = 1;
	end

	if j > l then
		j = l;
	end

	if i > j then
		return "";
	end

	local diff = j - i;
	local iterator = unicode_helpers.chars(str, true);

	-- advance up to i
	for _ = 1, i - 1 do
		iterator();
	end

	local c, b = select(2, iterator());

	-- i and j are the same, single-charaacter sub
	if diff == 0 then
		return string.sub(str, b, b + c - 1);
	end

	i = b;

	-- advance up to j
	for _ = 1, diff - 1 do
		iterator();
	end

	c, b = select(2, iterator());

	return string.sub(str, i, b + c - 1);
end

function unicode_helpers.init_module()
end

return unicode_helpers;
