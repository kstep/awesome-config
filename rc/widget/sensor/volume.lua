
local progressbar = require("awful.widget.progressbar")
local sensual = require("sensual")
local vars = require("rc.vars")

local setmetatable = setmetatable

module("rc.widget.sensor.volume")

local widgets = {
    progressbar({ width = 5, layout = vars.statbox_layout }),
    sensual.label(" %d%% "),
    layout = vars.statbox_layout
}
widgets[1]:set_vertical(true)

reg = sensual.registermore(sensual.mixer(-1, "vol"), widgets, {
    { 1, sensual.filters.scale },
    { 1 },
}, 5)

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

