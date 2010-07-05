
local progressbar = require("awful.widget.progressbar")
local sensual = require("sensual")
local vars = require("rc.vars")

local setmetatable = setmetatable

module("rc.widget.sensor.cpufreq")

local widgets = {
    progressbar({ width = 5, layout = vars.statbox_layout }), -- cpu0
    sensual.label(" %5.1f %s "), -- cpu0
    layout = vars.statbox_layout
}
widgets[1]:set_vertical(true)

reg = sensual.registermore(sensual.cpufreq("cpu0"), widgets, {
    { 1, sensual.filters.scale },
    { 1, sensual.filters.humanize },
}, 5)

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

