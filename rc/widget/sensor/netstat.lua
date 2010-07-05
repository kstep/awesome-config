
local progressbar = require("awful.widget.progressbar")
local graph       = require("awful.widget.graph")

local sensual = require("sensual")
local vars = require("rc.vars")

local setmetatable = setmetatable

module("rc.widget.sensor.netstat")

local widgets = {
    graph({ width = 30, height = 17, layout = vars.statbox_layout }),
    sensual.label(" ◊%3d %s "),

    graph({ width = 30, height = 17, layout = vars.statbox_layout }),
    progressbar({ width = 5, layout = vars.statbox_layout }),
    sensual.label(" ᛘ%3d %s "),

    layout = vars.statbox_layout
}
widgets[1]:set_max_value(1024*3000)
widgets[3]:set_max_value(1024*3000)
widgets[4]:set_vertical(true)

regs = {
    sensual.registermore(sensual.net("ppp0"), { widgets[1], widgets[2], widgets[2] }, {
        { 3, sensual.filters.delta },
        { 3, sensual.filters.velocity },
        { 1, sensual.filters.theme, "set_color" },
    }, 5),
    sensual.registermore(sensual.net("wlan0"), { widgets[3], widgets[5], widgets[5] }, {
        { 3, sensual.filters.delta },
        { 3, sensual.filters.velocity },
        { 1, sensual.filters.theme, "set_color" },
    }, 5),
    sensual.registermore(sensual.wifi("wlan0"), { widgets[4] }, {
        { "link", sensual.filters.scale },
    }, 5)
}

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })


