local wid = widget

local vars = require("rc.vars")

local setmetatable = setmetatable

module("rc.widget.systray")

widget = wid({ type = "systray" })

local function get(s)
    return s == vars.widgets_screen and widget or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

