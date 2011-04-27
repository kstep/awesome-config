local capi = { timer = timer, widget = widget, image = image }
local setmetatable = setmetatable
local pairs = pairs
local ipairs = ipairs
local type = type
local table = { insert = table.insert, concat = table.concat }

local util = require("awful.util")
local button = require("awful.button")
local wiout = require("awful.widget.layout")
local menu = require("awful.menu")
local naughty = require("naughty")

module("rc.widget.tomato")

config = {
    default = 'Помидорка',
    timers = {
        { 25, name = 'Помидорка', message = 'Пора отдохнуть!'  , color = '#ff00ff', urgency = 'critical' },
        { 10, name = 'Перерыв'  , message = 'Перерыв закончен.', color = '#00ff00', urgency = 'critical' },
        { 30, name = 'Отдых'    , message = 'Отдых закончен.'  , color = '#00ffff', urgency = 'critical' },
    },
    series = {
        ["Pomidoro"] = {
            "Помидорка", "Перерыв",
            "Помидорка", "Перерыв",
            "Помидорка", "Перерыв",
            "Помидорка", "Отдых",
            loop = true, pause = true
        },
    }
}
counts = {}
timers_index = {}
for i, item in ipairs(config.timers) do
    timers_index[item.name] = i
end

-- update widget info
local function update(widget)
    widget[1].text = ('<span color="#FFFFFF"> %s %02d [×%d] </span>'):format(widget.running and "▶" or "■", widget.count, counts[widget.name] or 0)
    widget[1].bg = widget.color or "green"
end

-- show widget specific notification
start_icon = capi.image("/usr/share/icons/oxygenrefit2-black/48x48/apps-extra/chronometer.png")
stop_icon = capi.image("/usr/share/icons/oxygenrefit2-black/48x48/apps-extra/gazpacho.png")
local function notify(widget, message)
    icon = message and start_icon or stop_icon
    message = message or widget.message
    naughty.notify({ title = "<big>" .. widget.name .. "</big>", text = message, preset = naughty.config.presets[widget.urgency], icon = icon })
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
    notify(widget, "Отсчёт пошёл.")
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
    args = args or config.timers[timers_index[config.default]] or {}
    widget.timeout = args[1] or 25
    widget.name = args.name or "Tomato!"
    widget.message = args.message or "Time to get some rest!"
    widget.color = args.color or '#00ff00'
    widget.urgency = args.urgency or "critical"
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
    local name = series[widget.current]
    setup(widget, config.timers[timers_index[name]])
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
        notify(widget)
        counts[widget.name] = (counts[widget.name] or 0) + 1
        next_series(widget)
    else
        update(widget)
    end
end


-- create time widget
local function new(s, args)
    local widget = {}

    local timers = {}
    for i, item in ipairs(config.timers) do
        table.insert(timers, { ("%2d %s"):format(item[1], item.name),
            function ()
                set_series(widget, nil)
                setup(widget, item)
                stop(widget)
            end })
    end
    for name, item in pairs(config.series) do
        local times = {}
        for _, t in ipairs(item) do
            table.insert(times, config.timers[timers_index[t]][1])
        end
        if item.loop then
            table.insert(times, "…")
        end
        table.insert(timers, { ("%s %s"):format(table.concat(times, item.pause and "→" or "»"), name),
            function ()
                set_series(widget, name)
                next_series(widget)
            end })
    end
    local timers_menu = menu({ items = timers, width = 230 })

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

