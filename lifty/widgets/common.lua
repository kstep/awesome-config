local pairs = pairs
local unpack = unpack
local math = { min = math.min, max = math.max }
local table = { remove = table.remove, insert = table.insert }
local capi = { widget = widget }
local setmetatable = setmetatable

local awful = { hooks = require("awful.hooks") }
local beautiful = require("beautiful")

module("lifty.widgets.common")

function register_sensors(wibox, sensors, period)
	local timeout = period or 10
	local widget = wibox.widgets[2]

	local title = wibox.widgets[1]
	local title_format = wibox.title

	local hook_funcs = {}
	for barname, sensor in pairs(sensors) do
		local sensor_data = sensor:get_data()
		widget:set_properties(barname, {
			min_value = sensor_data.min_value or 0,
			max_value = sensor_data.max_value or 100,
		})

		local hook_func
		if sensor.get_state then
			hook_func = function ()
				local value = sensor:get_value()
				local state = sensor:get_state()
				widget:add_data(barname, value)
				local state = state
				if state and beautiful[state] then
					widget:set_properties(barname, { fg = beautiful[state] })
				end
				return sensor.humanize and sensor:humanize(value) or value, state
			end
		else
			hook_func = function ()
				local value = sensor:get_value()
				widget:add_data(barname, value)
				return sensor.humanize and sensor:humanize(value) or value
			end
		end
		hook_funcs[barname] = hook_func
	end

	local timer_hook
	if title then
		timer_hook = function ()
			local values = {}
			local v, s
			for k, hookf in pairs(hook_funcs) do
				v, s = hookf()
				if s and beautiful[s] then
					table.insert(values, beautiful[s])
				end
				table.insert(values, v)
			end
			title.text = title_format:format(unpack(values))
		end
	else
		timer_hook = function ()
			for k, hookf in pairs(hook_funcs) do
				hookf()
			end
		end
	end
	awful.hooks.timer.register(timeout, timer_hook)
	timer_hook()
end

local function new_widget(wtype, walign)
	local widget = {}
	widget.widget = capi.widget({ type = wtype, align = walign })

	if wtype == "progressbar" then
		widget.set_properties = function (self, k, v) self.widget:bar_properties_set(k, v) end
		widget.add_data       = function (self, k, v) self.widget:bar_data_add(k, v) end
	else
		widget.set_properties = function (self, k, v) self.widget:plot_properties_set(k, v) end
		widget.add_data       = function (self, k, v) self.widget:plot_data_add(k, v) end
	end
	
	setmetatable(widget, {
		__index    = function (self, k) return self.widget[k] end,
		__newindex = function (self, k, v) self.widget[k] = v end,
	})

	return widget
end

function statistic(wtype, params, bars, without_title)
	local wid_align = params["align"] or "left"
	local wid_type = wtype or "progressbar"
	local wid_wibox = {}

	local wid_title = nil
	if not without_title then
		wid_title = capi.widget({ type = "textbox", align = wid_align })
		wid_wibox.title = params["title"] or ""
	end
	local wid_widget = new_widget(wid_type, wid_align)

	for k, v in pairs(params) do
		wid_widget[k] = v
	end

	wid_wibox.widgets = {
		wid_title,
		wid_widget,
	}
	
	local sensors = {}
	local period = 10
	for bar_name, bar_data in pairs(bars) do
		if bar_data["sensor"] then
			sensors[bar_name] = bar_data["sensor"]
			period = math.min(bar_data["period"] or 10, period)
		end
		wid_widget:set_properties(bar_name, bar_data)
	end

	register_sensors(wid_wibox, sensors, period)

	return wid_wibox
end

function graph(params, bars, without_title)
	return statistic("graph", params, bars, without_title)
end

function progressbar(params, bars, without_title)
	return statistic("progressbar", params, bars, without_title)
end

