local io = io

module("lifty.utils")

function humanize(size, factor, suffix, exp)
	suffix = suffix or { "b", "K", "M", "G", "T" }
	factor = factor or 1024
	exp = exp or 1

	local i = 1
	if exp < 1 or #suffix >= exp then
		i = exp
	end
	while size > factor and i < #suffix do
		size = size / factor
		i = i + 1
	end
	return ("%0.1f %s"):format(size, suffix[i])
end

function fread_num(fname, match)
    local fh = io.open(fname)
    local value = nil
    if fh then
        value = fh:read(match or "*n")
        fh:close()
    end
    return value
end

function fread_table(fname)
	local result = {}
	for line in io.lines(fname) do
		local key, value = line:match("(%w+):%s+(%d+)")
		if key then result[key] = value end
	end
	return result
end

function table_sum(tbl)
	local sum = 0
	for i = 1, #tbl do
		sum = sum + tbl[i]
	end
	return sum
end
