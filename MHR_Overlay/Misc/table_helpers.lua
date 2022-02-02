local table_helpers = {};

function table_helpers.deep_copy(original, copies)
	copies = copies or {};
	local original_type = type(original);
	local copy;
	if original_type == 'table' then
		if copies[original] then
			copy = copies[original];
		else
			copy = {};
			copies[original] = copy;
			for original_key, original_value in next, original, nil do
				copy[table_helpers.deep_copy(original_key, copies)] = table_helpers.deep_copy(original_value, copies);
			end
			setmetatable(copy, table_helpers.deep_copy(getmetatable(original), copies));
		end
	else -- number, string, boolean, etc
		copy = original;
	end
	return copy;
end

function table_helpers.find_index(table, value, nullable)
	for i = 1, #table do
		if table[i] == value then
			return i;
		end
	end

	if not nullable then
		return 1;
	end

	return nil;
end

function table_helpers.merge(...)
	local tables_to_merge = {...};
	assert(#tables_to_merge > 1, "There should be at least two tables to merge them");

	for key, table in ipairs(tables_to_merge) do
		assert(type(table) == "table", string.format("Expected a table as function parameter %d", key));
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

function table_helpers.tostring(table)
	local cache, stack, output = {}, {}, {};
	local depth = 1;
	local output_string = "{\n";

	while true do
		local size = 0;
		for key, value in pairs(table) do
			size = size + 1;
		end

		local current_index = 1;
		for key, value in pairs(table) do
			if (cache[table] == nil) or (current_index >= cache[table]) then

				if (string.find(output_string, "}", output_string:len())) then
					output_string = output_string .. ",\n";
				elseif not (string.find(output_string, "\n",output_string:len())) then
					output_string = output_string .. "\n";
				end

				-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
				table.insert(output, output_string);
				output_string = "";

				local key;
				if (type(key) == "number" or type(key) == "boolean") then
					key = "[" .. tostring(key) .. "]";
				else
					key = "['" .. tostring(key) .. "']";
				end

				if (type(value) == "number" or type(value) == "boolean") then
					output_string = output_string .. string.rep('\t', depth) .. key .. " = " .. tostring(value);
				elseif (type(value) == "table") then
					output_string = output_string .. string.rep('\t', depth) .. key .. " = {\n";
					table.insert(stack, table);
					table.insert(stack, value);
					cache[table] = current_index + 1;
					break
				else
					output_string = output_string .. string.rep('\t', depth) .. key .. " = '" .. tostring(value) .. "'";
				end

				if (current_index == size) then
					output_string = output_string .. "\n" .. string.rep('\t', depth - 1) .. "}";
				else
					output_string = output_string .. ",";
				end
			else
				-- close the table
				if (current_index == size) then
					output_string = output_string .. "\n" .. string.rep('\t', depth - 1) .. "}";
				end
			end

			current_index = current_index + 1;
		end

		if (size == 0) then
			output_string = output_string .. "\n" .. string.rep('\t', depth - 1) .. "}";
		end

		if (#stack > 0) then
			table = stack[#stack];
			stack[#stack] = nil;
			depth = cache[table] == nil and depth + 1 or depth - 1;
		else
			break;
		end
	end

	-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
	table.insert(output, output_string);
	output_string = table.concat(output);

	return output_string;
end

function table_helpers.init_module()
end

return table_helpers;