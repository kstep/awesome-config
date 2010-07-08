local setmetatable = setmetatable
local print = print
local pairs = pairs
local ipairs = ipairs
local type = type
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

module("sensual.filters")

function weaktable(mode)
    if not mode then mode = "k" end
    local tbl = {}
    setmetatable(tbl, { __mode = mode })
    return tbl
end

function format(format, args)
    for var, val in pairs(args) do
        format = string.gsub(format, "$" .. var, val)
    end

    return format
end

function scale(w, args, meta)
    local max = meta.max or 100
    local min = meta.min or 0

    return (args - min) / (max - min)
end

function percent(w, args, meta)
    return scale(w, args, meta) * 100
end

function theme(w, args, meta)
    return beautiful[args] or beautiful.fg_normal
end

local velocity_data = weaktable()
function velocity(w, args, meta, stack)
    if not velocity_data[w] then velocity_data[w] = {} end
    if not stack then stack = 1 end
    local time = os.time()
    local vel = 0
    if velocity_data[w][stack] then
        vel = (args - velocity_data[w][stack][1]) / (time - velocity_data[w][stack][2])
        if vel < 0 then vel = 0 end
    end
    velocity_data[w][stack] = { args, time }
    vel = humanize(w, vel, meta)
    vel[2] = vel[2] .. "/s"
    return vel
end

local delta_data = weaktable()
function delta(w, args, meta, stack)
    if not delta_data[w] then delta_data[w] = {} end
    if not stack then stack = 1 end
    local d = args - (delta_data[w][stack] or 0)
    delta_data[w][stack] = args
    return d
end

function hms(w, args, meta)
    local secs = args
    local days  = math.floor(secs / 86400); secs = secs % 86400
    local hours = math.floor(secs / 3600); secs = secs % 3600
    local mins  = math.floor(secs / 60); secs = secs % 60
    return { days, hours, mins, secs }
end

function humanize(w, args, meta)
    local suffixes = meta.suffixes or { "b", "K", "M", "G", "T", "P" }
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

function sum(w, args, meta)
    if type(args) == "table" then
        result = 0
        for _, v in pairs(args) do
            result = result + v
        end
        return result
    else
        return args
    end
end

function all(...)
    local allfilter = function (w, args, meta, stack)
        result = nil
        for i,filter in ipairs(arg) do
            if type(filter) == "function" then
               result = filter(w, args, meta, stack)
            end
        end
        return result
    end
    return allfilter
end

function pipe(...)
    local allfilter = function (w, args, meta, stack)
        result = args
        for i,filter in ipairs(arg) do
            if type(filter) == "function" then
                result = filter(w, result, meta, stack)
            end
        end
        return result
    end
    return allfilter
end

setmetatable(_M, { __call = function(_, ...) return all(...) end })
