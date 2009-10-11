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

function scale(widget, args, meta)
    local value = args[1]
    local max = meta.max or 100
    local min = meta.min or 0

    return (value - min) / (max - min)
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
