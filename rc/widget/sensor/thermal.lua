
local progressbar = require("awful.widget.progressbar")
local tooltip     = require("awful.tooltip")
local util        = require("awful.util")

local sensual = require("sensual")
local vars = require("rc.vars")

local theme = require("beautiful")

local setmetatable = setmetatable

module("rc.widget.sensor.thermal")

local widgets = {
    progressbar({ width = 5, layout = vars.statbox_layout }), -- tz1
    progressbar({ width = 5, layout = vars.statbox_layout }), -- tz0
    sensual.label("/%.1f°C "), -- tz1
    sensual.label(" %.1f°C"), -- tz0
    layout = vars.statbox_layout
}

for i = 1,2 do
    widgets[i]:set_vertical(true)
    widgets[i]:set_color(theme.cpu.therm[i])
    widgets[i]:set_border_color(theme.cpu.therm[i])
    widgets[i]:set_height(17)
    widgets[i+2]:set_color(theme.cpu.therm[i])
end

hint = tooltip({
    objects = {
	widgets[1].widget, widgets[2].widget,
	widgets[3].widget, widgets[4].widget,
    },
    timer_function = function () 
	return util.pread("acpi -t; sudo hddtemp /dev/sda; echo -n NVidia \"GeForce 9300M GS: `nvidia-settings -t -q GPUCoreTemp`°C\"")
    end
})

regs = {
    sensual.registermore(sensual.thermal(1), { widgets[1], widgets[3] }, {
        { 1, sensual.filters.scale },
        { },
    }, 10),

    sensual.registermore(sensual.thermal(0), { widgets[2], widgets[4] }, {
        { 1, sensual.filters.scale },
        { },
    }, 10)
}

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

