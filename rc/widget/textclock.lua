local clock = require("awful.widget.textclock")

local setmetatable = setmetatable

module("rc.widget.textclock")

widget = clock({ align = right })

setmetatable(_M, { __call = function(_, ...) return widget end })

