
local layout = require("awful.layout")
local util   = require("awful.util")
local button = require("awful.button")

local lobox = require("awful.widget.layoutbox")

local setmetatable = setmetatable

module("rc.widget.layoutbox")

local layouts =
{
    layout.suit.tile,
    layout.suit.tile.left,
    layout.suit.tile.bottom,
    layout.suit.tile.top,
    layout.suit.fair,
    layout.suit.fair.horizontal,
    layout.suit.spiral,
    layout.suit.spiral.dwindle,
    layout.suit.max,
    layout.suit.max.fullscreen,
    layout.suit.magnifier,
    layout.suit.floating
}

function get(s)
    local widget = lobox(s)
    widget:buttons(util.table.join(
	button({ }, 1, function () layout.inc(layouts, 1) end),
	button({ }, 3, function () layout.inc(layouts, -1) end),
	button({ }, 4, function () layout.inc(layouts, 1) end),
	button({ }, 5, function () layout.inc(layouts, -1) end)
    ))
    return widget
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

