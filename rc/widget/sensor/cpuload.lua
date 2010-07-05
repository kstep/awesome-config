
local progressbar = require("awful.widget.progressbar")
local graph       = require("awful.widget.graph")

local sensual = require("sensual")
local vars = require("rc.vars")

local setmetatable = setmetatable

module("rc.widget.sensor.cpuload")

local widgets = {
    graph({ width = 30, height = 17, layout = vars.statbox_layout }),
    layout = vars.statbox_layout
}
widgets[1]:set_max_value(100)
widgets[1]:set_border_color("#006600")
widgets[1]:set_background_color("#000000dd")
widgets[1]:set_color("#009900")

reg = sensual.registermore(sensual.cpu(), widgets, {
    { 1 },
}, 2)

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

