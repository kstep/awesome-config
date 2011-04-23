local capi = { timer = timer, widget = widget }
local setmetatable = setmetatable
local ipairs = ipairs
local table = { insert = table.insert, concat = table.concat }

local util = require("awful.util")
local button = require("awful.button")
local wiout = require("awful.widget.layout")
local menu = require("awful.menu")
local naughty = require("naughty")

module("rc.widget.tomato")

config = {
    default = 1,
    timers = {
        { 25, name = 'Помидорка', message = 'Пора отдохнуть!'  , color = '#ff00ff', urgency = 'critical' }, 
        { 5 , name = 'Перерыв'  , message = 'Перерыв закончен.', color = '#00ff00', urgency = 'critical' }, 
        { 30, name = 'Отдых'    , message = 'Отдых закончен.'  , color = '#00ffff', urgency = 'critical' }, 
    },
    series = {
        { 1, 2, 1, 2, 1, 2, 1, 3, name = 'Pomidoro', loop = true, pause = false },
    }
}

-- update widget info
local function update(widget)
    widget[1].text = ('<span color="white" bgcolor="%s"> %02d </span>'):format(widget.running and widget.color or "red", widget.count)
end

-- reset countdown, don't stop timer
local function reset(widget)
    widget.count = widget.timeout
    update(widget)
end

-- stop countdown and reset timer
local function stop(widget)
    widget.timer:stop()
    widget.running = false
    reset(widget)
end

-- start countdown
local function start(widget)
    widget.timer:start()
    widget.running = true
    update(widget)
end

-- toggle timer
local function toggle(widget)
    if widget.running then
        stop(widget)
    else
        start(widget)
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

local function set_series(widget, series)
    widget.series = series
    widget.current = 0
end

local function next_series(widget)
    if not widget.series then stop(widget) return end
    local series = config.series[widget.series]
    widget.current = widget.current + 1
    if widget.current > #series then
        if series.loop then
            widget.current = 1
        else
            widget.current = #series
        end
    end
    setup(widget, config.timers[series[widget.current]])
    if series.pause then
        stop(widget)
    else
        reset(widget)
    end
end

-- single timer click
local function tick(widget)
    widget.count = widget.count - 1
    if widget.count < 1 then
        naughty.notify({ title = "<big>" .. widget.name .. "</big>", text = widget.message, preset = widget.preset })
        next_series(widget)
    else
        widget:update()
    end
end


-- create time widget
local function new(s, args)
    local widget = {}

    local timers = {}
    for _, item in ipairs(config.timers) do
        table.insert(timers, { ("%2d %s"):format(item[1], item.name),
            function ()
                set_series(widget, nil)
                setup(widget, item)
                stop(widget)
            end })
    end
    for i, item in ipairs(config.series) do
        local times = {}
        for _, t in ipairs(item) do
            table.insert(times, config.timers[t][1])
        end
        if item.loop then
            table.insert(times, "…")
        end
        table.insert(timers, { ("%s %s"):format(table.concat(times, "→"), item.name),
            function ()
                set_series(widget, i)
                next_series(widget)
            end })
    end
    local timers_menu = menu({ items = timers, width = 200 })

    widget.running = false
    widget.timer = capi.timer({ timeout = 60 })
    widget.timer:add_signal("timeout", function () tick(widget) end)

    widget[1] = capi.widget({ type = "textbox" })
    widget[1]:buttons(util.table.join(
        button({ }, 1, nil, function ()
            toggle(widget)
        end),
        button({ }, 3, nil, function ()
            timers_menu:toggle()
        end)
    ))
    widget.layout = wiout.horizontal.rightleft

    setup(widget, args)
    reset(widget)
    return widget
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

