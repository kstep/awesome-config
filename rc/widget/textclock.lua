local clock = require("awful.widget.textclock")
local tooltip = require("awful.tooltip")
local os = { popen = io.popen, date = os.date }
local theme = require("beautiful")

local setmetatable = setmetatable

module("rc.widget.textclock")

widget = clock({ align = right })
hint = tooltip({
    objects = { widget },
    timer_function = function ()
        local f = os.popen(os.date('/usr/bin/ncal %Y'))
        local data = f:read('*all')
        f:close(io)
        return data:gsub(' (%d%d%d%d)', '<big><b>%1</b></big>'):gsub('_([0-9 ])', ('<span bgcolor="%s" color="%s">%%1</span>'):format(theme.bg_focus, theme.fg_focus))
    end,
    timeout = 0,
})

setmetatable(_M, { __call = function(_, ...) return widget end })

