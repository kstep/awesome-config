local capi = { timer = timer, widget = widget }
local setmetatable = setmetatable
local ipairs = ipairs
local table = { insert = table.insert }

local util = require("awful.util")
local button = require("awful.button")
local wiout = require("awful.widget.layout")
local menu = require("awful.menu")
local naughty = require("naughty")

module("rc.widget.tomato")

config = {
    default = 1,
    timers = {
        { 1,  name = 'Тест',      message = 'Тест окончен!'    , color = '#0000ff', urgency = 'critical' },
        { 25, name = 'Помидорка', message = 'Пора отдохнуть!'  , color = '#ff00ff', urgency = 'critical' }, 
        { 5 , name = 'Перерыв'  , message = 'Перерыв закончен.', color = '#00ff00', urgency = 'critical' }, 
        { 30, name = 'Отдых'    , message = 'Отдых закончен.'  , color = '#00ffff', urgency = 'critical' }, 
    },
    sequences = {
        { 1, 2, 1, 2, 1, 2, 1, 3, name = 'Сессия', loop = true, pause = true },
    }
}

-- stop countdown and reset timer
local function stop(widget)
    widget.timer:stop()
    widget.running = false
    widget:reset()
end

-- start countdown
local function start(widget)
    widget.timer:start()
    widget.running = true
    widget:update()
end

-- reset countdown, don't stop timer
local function reset(widget)
    widget.count = widget.timeout
    widget:update()
end

-- toggle timer
local function toggle(widget)
    if widget.running then
        widget:stop()
    else
        widget:start()
    end
end

-- update widget info
local function update(widget)
    widget[1].text = ('<span color="white" bgcolor="%s"> %02d </span>'):format(widget.running and widget.color or "red", widget.count)
end

-- single timer click
local function tick(widget)
    widget.count = widget.count - 1
    if widget.count < 1 then
        widget:stop()
        naughty.notify({ title = "<big>" .. widget.name .. "</big>", text = widget.message, preset = widget.preset })
    else
        widget:update()
    end
end

-- configure timer widget
local function setup(widget, args)
    args = args or config.timers[config.default or 1] or {}
    widget.timeout = args[1] or 25
    widget.name = args.name or "Tomato!"
    widget.message = args.message or "Time to get some rest!"
    widget.color = args.color or '#00ff00'
    widget.preset = naughty.config.presets[args.urgency or "critical"]
end

-- create time widget
local function new(s, args)
    local widget = {
        start = start,
        stop = stop,
        reset = reset,
        setup = setup,
        toggle = toggle,
        tick = tick,
        update = update,

        running = false,
        layout = wiout.horizontal.rightleft
    }
    local timers = {}

    for _, item in ipairs(config.timers) do
        table.insert(timers, { ("%2d %s"):format(item[1], item.name),
            function ()
                widget:setup(item)
                widget:stop()
            end })
    end
    widget.menu = menu({ items = timers, width = 150 })

    widget.timer = capi.timer({ timeout = 60 })
    widget.timer:add_signal("timeout", function () widget:tick() end)

    widget[1] = capi.widget({ type = "textbox" })
    widget[1]:buttons(util.table.join(
        button({ }, 1, nil, function ()
            widget:toggle()
        end),
        button({ }, 3, nil, function ()
            widget.menu:toggle()
        end)
    ))

    widget:setup(args)
    widget:reset()
    return widget
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

