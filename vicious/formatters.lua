local print = print
local pairs = pairs
local string = {
    sub = string.sub,
    gsub = string.gsub
}

module("vicious.formatters")

function format(format, args)
    for var, val in pairs(args) do
        format = string.gsub(format, "$" .. var, val)
    end

    return format
end

function scale(widget, args)
    local value = args[1]
    local max = args[2] or 100
    local min = args[3] or 0

    return (value - min) / (max - min)
end

function humanize(widget, args)
    local suffixes = args.suffixes or { "b", "Kb", "Mb", "Gb", "Tb" }
    local scale = args.scale or 1024
    local init = args.init or 1
    local format = args.format or " %.3f %s "
    local value = args[1]

    local suffix = init
    while value > scale and suffix < #suffixes do
        value = value / scale
        suffix = suffix + 1
    end
    return format:format(value, suffixes[suffix])
end
