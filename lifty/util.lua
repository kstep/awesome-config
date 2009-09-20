local pairs = pairs
local io = io

module("lifty.util")

function humanize_size(size, exp)
	local suffix = { "b", "K", "M", "G", "T" }
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

function new_titled_stat_widget(w_type, w_align, params, bars)
	local wid_align = w_align or "left"
	local wid_type = w_type

	local new_title = widget({ type = "textbox", align = wid_align })
	local new_widget = widget({ type = wid_type, align = wid_align })

	for k, v in pairs(params) do
		new_widget[k] = v
	end

	if wid_type == "progressbar" then
		for bar_name, bar_data in pairs(bars) do
			new_widget:bar_properties_set(bar_name, bar_data)
		end
	else
		for bar_name, bar_data in pairs(bars) do
			new_widget:plot_properties_set(bar_name, bar_data)
		end
	end

	return new_widget, new_title
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
