
local progressbar = require("awful.widget.progressbar")
local tooltip     = require("awful.tooltip")
local util        = require("awful.util")

local sensual = require("sensual")
local vars = require("rc.vars")

local theme = require("beautiful")

local setmetatable = setmetatable

module("rc.widget.sensor.battery")

local widgets = {
    progressbar({ width = 10, layout = vars.statbox_layout }),
    sensual.label("[%(2)2d:%(3)02d] "),
    sensual.label(" %3d%% "),
    layout = vars.statbox_layout
}
widgets[1]:set_vertical(true)
widgets[1]:set_ticks(true)
widgets[1]:set_height(17)
widgets[1]:set_ticks_size(2)

hint = tooltip({
    objects = {
	widgets[1].widget,
	widgets[2].widget,
	widgets[3].widget,
    },
    timer_function = function () 
	return util.pread("acpi -b -i")
    end
})

reg = sensual.registermore(sensual.bat("BAT0"), util.table.join(widgets, widgets), {
    { 1, sensual.filters.scale },
    { 2, sensual.filters.hms },
    { 1, sensual.filters.percent },

    { 3, sensual.filters.theme, "set_color" },
    { 3, sensual.filters.theme, "set_color" },
    { 3, sensual.filters.theme, "set_color" },
},
5)

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

