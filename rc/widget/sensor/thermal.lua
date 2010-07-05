
local progressbar = require("awful.widget.progressbar")
local sensual = require("sensual")
local vars = require("rc.vars")

local setmetatable = setmetatable

module("rc.widget.sensor.thermal")

local widgets = {
    progressbar({ width = 5, layout = vars.statbox_layout }), -- tz1
    progressbar({ width = 5, layout = vars.statbox_layout }), -- tz0
    sensual.label("/%.1f°C "), -- tz1
    sensual.label(" %.1f°C"), -- tz0
    layout = vars.statbox_layout
}
widgets[1]:set_vertical(true)
widgets[2]:set_vertical(true)

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

