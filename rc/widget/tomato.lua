local capi = { timer = timer, widget = widget }
local setmetatable = setmetatable

local button = require("awful.button")
local wiout = require("awful.widget.layout")
local naughty = require("naughty")

module("rc.widget.tomato")

local function stop(widget)
    widget.timer:stop()
    widget.count = widget.timeout
    widget.running = false
    widget:update()
end

local function start(widget)
    widget.timer:start()
    widget.running = true
    widget:update()
end

local function update(widget)
    widget[1].text = ('<span color="white" bgcolor="%s"> %02d </span>'):format(widget.running and "green" or "red", widget.count)
end

local function tick(widget)
    widget.count = widget.count - 1
    if widget.count < 1 then
        widget:stop()
        naughty.notify({ title = "<big>Pomodoro!</big>", text = "Time to get some rest!", preset = widget.preset })
    else
        widget:update()
    end
end

local function new(s, timeout, urgency)
    local widget = {
        start = start,
        stop = stop,
        tick = tick,
        update = update
    }

    widget.timeout = timeout or 25
    widget.count = widget.timeout
    widget.running = false
    widget.preset = naughty.config.presets[urgency or "critical"]
    widget.layout = wiout.horizontal.rightleft

    widget.timer = capi.timer({ timeout = 60 })
    widget.timer:add_signal("timeout", function () widget:tick() end)

    widget[1] = capi.widget({ type = "textbox" })
    widget[1]:buttons(button({ }, 1, function ()
        if widget.running then
            widget:stop()
        else
            widget:start()
        end
    end))

    widget:update()
    return widget
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

