local prompt = require("awful.widget.prompt")
local wiout  = require("awful.widget.layout")

local setmetatable = setmetatable

module("rc.widget.promptbox")

local cache = {}
local function get(s)
    if cache[s] then return cache[s] end
    cache[s] = prompt({ layout  = wiout.horizontal.flex })
    return cache[s]
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

