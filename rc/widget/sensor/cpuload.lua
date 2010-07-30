
local progressbar = require("awful.widget.progressbar")
local graph       = require("awful.widget.graph")
local tooltip     = require("awful.tooltip")
local util        = require("awful.util")

local sensual = require("sensual")
local vars = require("rc.vars")

local theme = require("beautiful")

local setmetatable = setmetatable

module("rc.widget.sensor.cpuload")

local widgets = {
    graph({ width = 30, height = 17, layout = vars.statbox_layout }),
    layout = vars.statbox_layout
}
widgets[1]:set_stack(true)
widgets[1]:set_max_value(100)
widgets[1]:set_border_color(theme.cpu.load)
widgets[1]:set_stack_colors(theme.cpu.therm)
widgets[1]:set_background_color(theme.cpu.load.."33")
widgets[1]:set_color(theme.cpu.load)

hint = tooltip({
    objects = { widgets[1].widget },
    timer_function = function ()
        return util.pread("top -b | head -n 15")
    end
})

reg = sensual.registermore(sensual.cpu(), widgets, {
    { 1, nil, nil, 1 },
    { 3, nil, nil, 2 },
}, 2)

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

