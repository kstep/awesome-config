local setmetatable = setmetatable
local helpers = require("sensual.helpers")

module("sensual.yaweather")

function worker(self)
    return helpers.luafile("/tmp/weather.lua") or { { temp = "N/A" } }
end

local sensor
local function new()
    if not sensor then
        sensor = { meta = {} }
        setmetatable(sensor, { __call = worker })
    end
    return sensor
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
