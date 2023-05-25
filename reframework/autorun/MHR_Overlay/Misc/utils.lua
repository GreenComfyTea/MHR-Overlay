local this = {};

local sdk = sdk;
local tostring = tostring;
local pairs = pairs;
local ipairs = ipairs;
local tonumber = tonumber;
local require = require;
local pcall = pcall;
local table = table;
local string = string;
local Vector3f = Vector3f;
local d2d = d2d;
local math = math;
local json = json;
local log = log;
local fs = fs;
local next = next;
local type = type;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local assert = assert;
local select = select;
local coroutine = coroutine;
local utf8 = utf8;
local re = re;
local imgui = imgui;
local draw = draw;
local Vector2f = Vector2f;
local reframework = reframework;
local os = os;
local ValueType = ValueType;
local package = package;

local table_tostring;
local deep_copy;
local merge;
local is_empty;
local unicode_map;
local unicode_relative_position;
local unicode_chars;

this.table = {};
this.number = {};
this.string = {};
this.vec2 = {};
this.vec3 = {};
this.vec4 = {};
this.math = {};
this.unicode = {};

function this.table.tostring(table_)
	if type(table_) == "number" or type(table_) == "boolean" or type(table_) == "string" then
		return tostring(table_);
	end

	if is_empty(table_) then
		return "{}"; 
	end

	local cache = {};
	local stack = {};
	local output = {};
    local depth = 1;
    local output_str = "{\n";

    while true do
        local size = 0;
        for k,v in pairs(table_) do
            size = size + 1;
        end

        local cur_index = 1;
        for k,v in pairs(table_) do
            if cache[table_] == nil or cur_index >= cache[table_] then

                if string.find(output_str, "}", output_str:len()) then
                    output_str = output_str .. ",\n";
                elseif not string.find(output_str, "\n", output_str:len()) then
                    output_str = output_str .. "\n";
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str);
                output_str = "";

                local key;
                if type(k) == "number" or type(k) == "boolean" then
                    key = "[" .. tostring(k) .. "]";
                else
                    key = "['" .. tostring(k) .. "']";
                end

                if type(v) == "number" or type(v) == "boolean" then
                    output_str = output_str .. string.rep('\t', depth) .. key .. " = "..tostring(v);
                elseif type(v) == "table" then
                    output_str = output_str .. string.rep('\t', depth) .. key .. " = {\n";
                    table.insert(stack, table_);
                    table.insert(stack, v);
                    cache[table_] = cur_index + 1;
                    break;
                else
                    output_str = output_str .. string.rep('\t', depth) .. key .. " = '" .. tostring(v) .. "'";
                end

                if cur_index == size then
                    output_str = output_str .. "\n" .. string.rep('\t', depth - 1) .. "}";
                else
                    output_str = output_str .. ",";
                end
            else
                -- close the table
                if cur_index == size then
                    output_str = output_str .. "\n" .. string.rep('\t', depth - 1) .. "}";
                end
            end

            cur_index = cur_index + 1;
        end

        if size == 0 then
            output_str = output_str .. "\n" .. string.rep('\t', depth - 1) .. "}";
        end

        if #stack > 0 then
            table_ = stack[#stack];
            stack[#stack] = nil;
            depth = cache[table_] == nil and depth + 1 or depth - 1;
        else
            break;
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output, output_str);
    output_str = table.concat(output);

    return output_str;
end

function this.table.tostringln(table_)
	return "\n" .. table_tostring(table_);
end

function this.table.is_empty(table_)
	return next(table_) == nil;
end

function this.table.deep_copy(original, copies)
	copies = copies or {};
	local original_type = type(original);
	local copy;
	if original_type == "table" then
		if copies[original] then
			copy = copies[original];
		else
			copy = {};
			copies[original] = copy;
			for original_key, original_value in next, original, nil do
				copy[deep_copy(original_key, copies)] = deep_copy(original_value,copies);
			end
			setmetatable(copy, deep_copy(getmetatable(original), copies));
		end
	else -- number, string, boolean, etc
		copy = original;
	end
	return copy;
end

function this.table.find_index(table_, value, nullable)
	for i = 1, #table_ do
		if table_[i] == value then
			return i;
		end
	end

	if not nullable then
		return 1;
	end

	return nil;
end

function this.table.merge(...)
	local tables_to_merge = { ... };
	assert(#tables_to_merge > 1, "There should be at least two tables to merge them");

	for key, table_ in ipairs(tables_to_merge) do
		assert(type(table_) == "table", string.format("Expected a table as function parameter %d", key));
	end

	local result = deep_copy(tables_to_merge[1]);

	for i = 2, #tables_to_merge do
		local from = tables_to_merge[i];
		for key, value in pairs(from) do
			if type(value) == "table" then
				result[key] = result[key] or {};
				assert(type(result[key]) == "table", string.format("Expected a table: '%s'", key));
				result[key] = merge(result[key], value);
			else
				result[key] = value;
			end
		end
	end

	return result;
end

function this.number.is_NaN(value)
	return tostring(value) == tostring(0/0);
end

function this.number.round(value)
	return math.floor(value + 0.5);
end

function this.number.is_odd(value)
	return value % 2 ~= 0;
end

function this.number.is_even(value)
	return value % 2 == 0;
end

function this.string.trim(str)
	return str:match("^%s*(.-)%s*$");
end

function this.string.starts_with(str, pattern)
	return str:find("^" .. pattern) ~= nil;
end

function this.vec2.tostring(vector2f)
	return string.format("<%f, %f>", vector2f.x, vector2f.y);
end

function this.vec2.random(distance)
	distance = distance or 1;
	local radians = math.random() * math.pi * 2;
	return Vector2f.new(
		distance * math.cos(radians),
		distance * math.sin(radians)
	);
end

function this.vec3.tostring(vector3f)
	return string.format("<%f, %f, %f>", vector3f.x, vector3f.y, vector3f.z);
end

function this.vec4.tostring(vector4f)
	return string.format("<%f, %f, %f, %f>", vector4f.x, vector4f.y, vector4f.z, vector4f.w);
end

--- When called without arguments, returns a pseudo-random float with uniform distribution in the range [0,1). When called with two floats min and max, math.random returns a pseudo-random float with uniform distribution in the range [min, max). The call .random(max) is equivalent to .random(1, max)
---@param min number
---@param max number
---@return number
function this.math.random(min, max)
	if min == nil and max == nil then
		return math.random();
	end

	if max == nil then
		return max * math.random();
	end

	return min + (max - min) * math.random();
end

function this.math.sign(value)
	return (value >= 0 and 1) or -1;
end
function this.math.round(value, bracket)
	bracket = bracket or 1;
	return math.floor(value / bracket + this.math.sign(value) * 0.5) * bracket;
end

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
function this.unicode.relative_position(position, length)
	if position < 0 then
		position = length + position + 1;
	end
	return position;
end

-- THE MEAT

-- maps f over s's utf8 characters f can accept args: (visual_index, utf8_character, byte_index)
function this.unicode.map(s, f, no_subs)
	local i = 0;

	if no_subs then
		for b, e in s:gmatch("()" .. pattern .. "()") do
			i = i + 1;
			local c = e - b;
			f(i, c, b);
		end
	else
		for b, c in s:gmatch("()(" .. pattern .. ")") do
			i = i + 1;
			f(i, c, b);
		end
	end
end

-- THE REST

-- returns the number of characters in a UTF-8 string
function this.unicode.len(s)
	-- count the number of non-continuing bytes
	return select(2, s:gsub('[^\128-\193]', ''));
end

-- replace all utf8 chars with mapping
function this.unicode.replace(s, map)
	return s:gsub(pattern, map);
end

-- reverse a utf8 string
function this.unicode.reverse(s)
	-- reverse the individual greater-than-single-byte characters
	s = s:gsub(pattern, function (c)
		return #c > 1 and c:reverse()
	end);

	return s:reverse();
end

-- strip non-ascii characters from a utf8 string
function this.unicode.strip(s)
	return s:gsub(pattern, function(c)
		return #c > 1 and '';
	end);
end

-- generator for the above -- to iterate over all utf8 chars
function this.unicode.chars(s, no_subs)
	return coroutine.wrap(function()
		return unicode_map(s, coroutine.yield, no_subs);
	end);
end

-- like string.sub() but i, j are utf8 strings
-- a utf8-safe string.sub()
function this.unicode.sub(str, i, j)
	if coroutine == nil then
		return str;
	end

	local l = utf8.len(str);

	i = unicode_relative_position(i, l);
	j = j and unicode_relative_position(j, l) or l;

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
	local iterator = unicode_chars(str, true);

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

function this.init_module()
end

table_tostring = this.table.tostring;
deep_copy = this.table.deep_copy;
merge = this.table.merge;
is_empty = this.table.is_empty;
unicode_map = this.unicode.map;
unicode_relative_position = this.unicode.relative_position;
unicode_chars = this.unicode.chars;

return this;