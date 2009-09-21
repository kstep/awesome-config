local pairs = pairs
local io = io

local table = { remove = table.remove }
local math = { max = math.max, min = math.min }
local capi = { widget = widget }

local awful = { hooks = require("awful.hooks") }
local beautiful = require("beautiful")

module("lifty.utils")

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

function new_bar_widget(params, bars, without_title)
	local wid_align = params["align"] or "left"

	local new_title = nil
	if not without_title then
		new_title = capi.widget({ type = "textbox", align = wid_align })
		new_title.text = params["title"] or ""
	end
	local new_widget = capi.widget({ type = "progressbar", align = wid_align })

	for k, v in pairs(params) do
		new_widget[k] = v
	end

	local sensors = {}
	local period = 10
	for bar_name, bar_data in pairs(bars) do
		if bar_data["sensor"] then
			sensors[bar_name] = bar_data["sensor"]
			period = math.min(bar_data["period"] or 10, period)
		end
		new_widget:bar_properties_set(bar_name, bar_data)
	end

	register_sensors(new_widget, sensors, period)

	return new_title, new_widget
end

function register_sensors(widget, sensors, period)
	local timeout = period or 10

	local hook_funcs = {}
	for barname, sensor in pairs(sensors) do
		local sensor_data = sensor:get_data()
		widget:bar_properties_set(barname, {
			min_value = sensor_data.min_value or 0,
			max_value = sensor_data.max_value or 100,
		})

		local hook_func
		if sensor.get_state then
			hook_func = function ()
				widget:bar_data_add(barname, sensor:get_value())
				local state = sensor:get_state()
				if state and beautiful[state] then
					widget:bar_properties_set(barname, { fg = beautiful[state] })
				end
			end
		else
			hook_func = function ()
				widget:bar_data_add(barname, sensor:get_value())
			end
		end
		hook_funcs[barname] = hook_func
		hook_func()
	end

	awful.hooks.timer.register(timeout, function ()
		for k, hookf in pairs(hook_funcs) do hookf() end
	end)
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
