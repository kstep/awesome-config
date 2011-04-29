
local posix = require("posix")
local sensual = require("sensual")
local tooltip = require("awful.tooltip")
local os = { date = os.date, time = os.time, getenv = os.getenv }
local math = { floor = math.floor, abs = math.abs }
local tonumber = tonumber

local naughty = require("naughty")

local vars = require("rc.vars")

local setmetatable = setmetatable

module("rc.widget.sensor.uptime")

local widget = sensual.label(" [%dd %2d:%02d]")
reg = sensual.registermore(sensual.uptime(), { widget }, { { 1, sensual.filters.hms } }, 60)

local function tzoffs_to_sec(tz)
    local hm = math.abs(tz)
    local h, m = math.floor(hm / 100), hm % 100
    hm = h * 3600 + m * 60
    if tonumber(tz) < 0 then hm = -hm end
    return hm
end

local timezone = tzoffs_to_sec(os.date('%z'))
local function time_offset(offset, time)
    time = time or os.time()
    return time + offset
end

local function date_utc(fmt, time)
    return os.date(fmt, time_offset(-timezone, time))
end
local function date_offset(fmt, tzoffs, time)
    return os.date(fmt, time_offset(tzoffs - timezone, time))
end
local function date_tz(fmt, tz, time)
    local oldtz = os.getenv('TZ')
    posix.setenv('TZ', tz)
    local result = os.date(fmt, time)
    posix.setenv('TZ', oldtz)
    return result
end

hint = tooltip({
    objects = { widget.widget },
    timer_function = function ()
        local fmt = '%a %b %d, %H:%M %z'
        times = ""
        times = times .. "California, USA: " .. date_tz(fmt, 'America/Los_Angeles'--[[-25200]]) .. "\n"
        times = times .. "Moscow, Russia:  " .. date_tz(fmt, 'Europe/Moscow'--[[14400]]) .. "\n"
        return times
    end,
    timeout = 60,
})

local function get(s)
    return s == vars.widgets_screen and widget or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

