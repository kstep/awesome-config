
local graph = require("awful.widget.graph")

local sensual = require("sensual")
local vars = require("rc.vars")

local setmetatable = setmetatable

module("rc.widget.sensor.usedmem")

local widgets = {
    graph({ width = 30, height = 17, layout = vars.statbox_layout }),
    sensual.label("/%.1f %s "),
    sensual.label(" %.1f %s"),
    layout = vars.statbox_layout
}
widgets[1]:set_max_value(1)
widgets[1]:set_border_color("#006600")
widgets[1]:set_background_color("#000000dd")
widgets[1]:set_color("#009900")

reg = sensual.registermore(sensual.mem(), widgets, {
    { 1, sensual.filters.scale },
    { 4, sensual.filters.humanize },
    { 3, sensual.filters.humanize },
}, 2)

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

