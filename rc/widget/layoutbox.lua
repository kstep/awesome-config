
local layout = require("awful.layout")
local util   = require("awful.util")
local button = require("awful.button")

local lobox = require("awful.widget.layoutbox")

local vars = require("rc.vars")

local setmetatable = setmetatable

module("rc.widget.layoutbox")

function get(s)
    local widget = lobox(s)
    widget:buttons(util.table.join(
	button({ }, 1, function () layout.inc(vars.layouts, 1) end),
	button({ }, 3, function () layout.inc(vars.layouts, -1) end),
	button({ }, 4, function () layout.inc(vars.layouts, 1) end),
	button({ }, 5, function () layout.inc(vars.layouts, -1) end)
    ))
    return widget
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

