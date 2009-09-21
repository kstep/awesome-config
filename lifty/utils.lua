local io = io

module("lifty.utils")

function humanize(size, exp, suffixes)
	local suffix = suffixes or { "b", "K", "M", "G", "T" }
	local i = 1
	if exp and (exp > 1 or exp <= #suffix) then
		i = exp
	end
	while size > 1023 and i < #suffix do
		size = size / 1024
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
