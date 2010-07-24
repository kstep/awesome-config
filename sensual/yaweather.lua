local setmetatable = setmetatable
local helpers = require("sensual.helpers")

module("sensual.yaweather")

function worker(self)
    -- Get /proc/uptime
    local line = helpers.readfile("/tmp/weather.txt", "*line")
    if not line then return { nil } end
    local temp, icon = line:match("[|]([+-][0-9]+ °C)[|]([^|]+)[|]")
    -- use sensual.filters.hms() to get days/hours/mins/secs
    return { temp, icon }
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
