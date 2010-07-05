
local wiout = require("awful.widget.layout")
local wibox = require("awful.wibox")

local sensor    = require("rc.widget.sensor")
local promptbox = require("rc.widget.promptbox")

local setmetatable = setmetatable

module("rc.widget.statbar")

local cache = {}
local function get(s)
    local wbox = wibox({ position = "bottom", screen = s })
    if cache[s] then return cache[s] end

    wbox.widgets = {

        sensor.thermal(s),
        sensor.cpuload(s),
        sensor.cpufreq(s),
        sensor.usedmem(s),
        sensor.netstat(s),
        sensor.diskio(s),
        sensor.battery(s),
        sensor.volume(s),
        promptbox(s),

        layout = wiout.horizontal.rightleft
    }

    cache[s] = wbox
    return wbox
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

