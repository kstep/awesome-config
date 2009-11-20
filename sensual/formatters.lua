local print = print
local pairs = pairs
local string = {
    sub = string.sub,
    gsub = string.gsub
}
local math = {
    floor = math.floor
}
local os = {
    time = os.time
}
local beautiful = require("beautiful")

module("sensual.formatters")

function format(format, args)
    for var, val in pairs(args) do
        format = string.gsub(format, "$" .. var, val)
    end

    return format
end

function scale(widget, args, meta)
    local max = meta.max or 100
    local min = meta.min or 0

    return (args - min) / (max - min)
end

function percent(widget, args, meta)
    return scale(widget, args, meta) * 100
end

function theme(widget, args, meta)
    return beautiful[args] or beautiful.fg_normal
end

local velocity_data = {}
function velocity(widget, args, meta)
    local time = os.time()
    local vel = 0
    if velocity_data[widget] then
        vel = (args - velocity_data[widget][1]) / (time - velocity_data[widget][2])
        if vel < 0 then vel = 0 end
    end
    velocity_data[widget] = { args, time }
    vel = humanize(widget, vel, meta)
    vel[2] = vel[2] .. "/s"
    return vel
end

local delta_data = {}
function delta(widget, args, meta)
    local d = args - (delta_data[widget] or 0)
    delta_data[widget] = args
    return d
end

function hms(widget, args, meta)
    local secs = args
    local days  = math.floor(secs / 86400); secs = secs % 86400
    local hours = math.floor(secs / 3600); secs = secs % 3600
    local mins  = math.floor(secs / 60); secs = secs % 60
    return { days, hours, mins, secs }
end

function humanize(widget, args, meta)
    local suffixes = meta.suffixes or { "b", "Kb", "Mb", "Gb", "Tb" }
    local scale = meta.scale or 1024
    local init = meta.init or 1
    local value = args

    local suffix = init
    while value > scale and suffix < #suffixes do
        value = value / scale
        suffix = suffix + 1
    end
    return { value, suffixes[suffix] }
end
