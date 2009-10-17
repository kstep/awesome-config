local print = print
local pairs = pairs
local string = {
    sub = string.sub,
    gsub = string.gsub
}
local math = {
    floor = math.floor
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
    local value = args[1]
    local max = meta.max or 100
    local min = meta.min or 0

    return (value - min) / (max - min)
end

function percent(widget, args, meta)
    local result = scale(widget, args, meta) * 100
    args[1] = result
    return args
end

function theme(widget, args, meta)
    return beautiful[args[1]] or beautiful.fg_normal
end

function hms(widget, args, meta)
    local secs = args[1]
    local days  = math.floor(secs / 86400); secs = secs % 86400
    local hours = math.floor(secs / 3600); secs = secs % 3600
    local mins  = math.floor(secs / 60); secs = secs % 60
    return { days, hours, mins, secs }
end

function humanize(widget, args, meta)
    local suffixes = meta.suffixes or { "b", "Kb", "Mb", "Gb", "Tb" }
    local scale = meta.scale or 1024
    local init = meta.init or 1
    local value = args[1]

    local suffix = init
    while value > scale and suffix < #suffixes do
        value = value / scale
        suffix = suffix + 1
    end
    return { value, suffixes[suffix] }
end
