local table_helpers = {};

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
				copy[table_helpers.deep_copy(original_key, copies)] = table_helpers.deep_copy(original_value
					,
					copies);
			end
			setmetatable(copy,
				table_helpers.deep_copy(getmetatable(original)
					, copies));
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
	local tables_to_merge = { ... };
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
	if type(table) == "table" then
		local s = "{ \n";
		for k, v in pairs(table) do
			if type(k) ~= "number" then
				k = "\"" .. k .. "\"";
			end
			s = s .. "\t[" .. k .. "] = " .. table_helpers.tostring(v) .. ",\n";
		end
		return s .. "} \n";
	else
		return tostring(table);
	end
end

function table_helpers.init_module()
end

return table_helpers;
