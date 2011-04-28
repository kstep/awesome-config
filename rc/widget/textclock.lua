local clock = require("awful.widget.textclock")
local tooltip = require("awful.tooltip")
local os = { popen = io.popen, date = os.date }

local setmetatable = setmetatable

module("rc.widget.textclock")

widget = clock({ align = right })
hint = tooltip({
    objects = { widget },
    timer_function = function ()
        local f = os.popen(os.date('/usr/bin/ncal %Y'))
        local data = f:read('*all')
        f:close(io)
        return data:gsub('_(%d)', '<span bgcolor="#000000" color="#ffffff"><b>%1</b></span>')
    end,
    timeout = 0,
})

setmetatable(_M, { __call = function(_, ...) return widget end })

