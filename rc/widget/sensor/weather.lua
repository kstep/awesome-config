local sensual = require("sensual")
local vars = require("rc.vars")
local layouts = require("awful.widget.layout")
local setmetatable = setmetatable

module("rc.widget.sensor.weather")

local widget = { sensual.label(" %s"), sensual.icon() }
reg = sensual.registermore(sensual.yaweather(), widget, { { 1 }, { 2 } }, 600)
widget.layout = layouts.horizontal.rightleft

local function get(s)
    return s == vars.widgets_screen and widget or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

