
local sensual = require("sensual")

local vars = require("rc.vars")

local setmetatable = setmetatable

module("rc.widget.sensor.uptime")

local widget = sensual.label(" [%dd %2d:%02d]")
reg = sensual.registermore(sensual.uptime(), { widget }, { { 1, sensual.filters.hms } }, 60)

local function get(s)
    return s == vars.widgets_screen and widget or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

