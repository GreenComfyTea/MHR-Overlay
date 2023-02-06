local table_helpers = {};

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

function table_helpers.deep_copy(original, copies)
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
				copy[table_helpers.deep_copy(original_key, copies)] = table_helpers.deep_copy(original_value,copies);
			end
			setmetatable(copy, table_helpers.deep_copy(getmetatable(original), copies));
		end
	else -- number, string, boolean, etc
		copy = original;
	end
	return copy;
end

function table_helpers.find_index(table_, value, nullable)
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

function table_helpers.merge(...)
	local tables_to_merge = { ... };
	assert(#tables_to_merge > 1, "There should be at least two tables to merge them");

	for key, table_ in ipairs(tables_to_merge) do
		assert(type(table_) == "table", string.format("Expected a table as function parameter %d", key));
	end

	local result = table_helpers.deep_copy(tables_to_merge[1]);

	for i = 2, #tables_to_merge do
		local from = tables_to_merge[i];
		for key, value in pairs(from) do
			if type(value) == "table" then
				result[key] = result[key] or {};
				assert(type(result[key]) == "table", string.format("Expected a table: '%s'", key));
				result[key] = table_helpers.merge(result[key], value);
			else
				result[key] = value;
			end
		end
	end

	return result;
end

function table_helpers.tostring(table_)
	if type(table_) == "number" or type(table_) == "boolean" or type(table_) == "string" then
		return tostring(table_);
	end

	if table_helpers.is_empty(table_) then
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
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output, output_str);
    output_str = table.concat(output);

    return output_str;
end

function table_helpers.tostringln(table_)
	return "\n" .. table_helpers.tostring(table_);
end

function table_helpers.is_empty(table_)
	return next(table_) == nil;
end

function table_helpers.init_module()
	
end

return table_helpers;
