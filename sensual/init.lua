---------------------------------------------------------------------------
-- Vicious widgets for the awesome window manager
---------------------------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
--  * Derived from Wicked, copyright of Lucas de Vries <lucas_glacicle_com>
---------------------------------------------------------------------------

-- {{{ Grab environment
require("awful")
require("sensual.helpers")
require("sensual.filters")
require("sensual.label")

local type = type
local pairs = pairs
local ipairs = ipairs
local unpack = unpack
local awful = awful
local tonumber = tonumber
local os = { time = os.time }
local table = {
    insert = table.insert,
    remove = table.remove
}

-- Grab C API
local capi = { timer = timer, widget = widget }
-- }}}


-- {{{ Configure widgets
require("sensual.cpu")
-- require("sensual.cpuinf")
require("sensual.cpufreq")
require("sensual.thermal")
-- require("sensual.load")
require("sensual.uptime")
require("sensual.bat")
-- require("sensual.batat")
require("sensual.mem")
-- require("sensual.fs")
require("sensual.dio")
-- require("sensual.hddtemp")
require("sensual.net")
require("sensual.wifi")
-- require("sensual.mbox")
-- require("sensual.mboxc")
-- require("sensual.mdir")
-- require("sensual.gmail")
-- require("sensual.entropy")
-- require("sensual.org")
-- require("sensual.pacman")
-- require("sensual.mpd")
require("sensual.mixer")
-- require("sensual.volume")
-- require("sensual.weather")
-- require("sensual.date")
require("sensual.statfs")
-- }}}

-- Vicious: widgets for the awesome window manager
module("sensual")


-- {{{ Initialise tables
local timers       = {}
local registered   = {}
local widget_cache = {}

-- Initialise the function table
widgets = {}
-- }}}

-- {{{ Widget types
for w, i in pairs(_M) do
    -- Ensure we don't call ourselves
    if i and i ~= _M and type(i) == "table" then
        -- Ignore the function table and helpers
        if w ~= "widgets" and w ~= "helpers" then
            -- Place widgets in the namespace table
            widgets[w] = i
            -- Enable caching for all widget types
            widget_cache[i] = {}
        end
    end
end
-- }}}

-- {{{ Main functions
-- {{{ Register a widget
function registermore(sensor, widgets, params, timer)
    local reg = {}

    -- Set properties
    reg.sensor  = sensor
    reg.widgets = widgets
    reg.params  = params
    reg.timer   = timer

    -- 1:channels, 2:formatter, 3:method, 4:stack
    for i, widget in ipairs(reg.widgets) do
        if type(reg.params[i][3]) == "string" then
            reg.params[i][3] = widget[reg.params[i][3]]
        end
        if type(reg.params[i][3]) ~= "function" then
            reg.params[i][3] = widget.set_value or widget.add_value
        end
    end

    -- Update function
    reg.update = function ()
        update(reg)
    end

    -- Default to 2s timer
    if reg.timer == nil then
        reg.timer = 2
    end

    -- Register a reg object
    regregister(reg)

    -- Return a reg object for reuse
    return reg
end

function register(widget, method, sensor, channels, format, timer)
    return registermore(sensor, { widget }, { { method, channels, format } }, timer)
end
-- }}}

-- {{{ Register from reg object
function regregister(reg)
    if not reg.running then
        for i, widget in ipairs(reg.widgets) do
            if registered[widget] == nil then
                registered[widget] = {}
                table.insert(registered[widget], reg)
            else
                local already = false

                for w, i in pairs(registered) do
                    if w == widget then
                        for _, v in pairs(i) do
                            if v == reg then
                                already = true
                                break
                            end
                        end

                        if already then
                            break
                        end
                    end
                end

                if not already then
                    table.insert(registered[widget], reg)
                end
            end
        end

        -- Start the timer
        if reg.timer > 0 then
            timers[reg.update] = {
                timer = capi.timer({ timeout = reg.timer })
            }
            timers[reg.update].timer:add_signal("timeout", reg.update)
            timers[reg.update].timer:start()
        end

        -- Initial update
        reg.update()
        reg.running = true
    end
end
-- }}}

-- {{{ Unregister a widget
function unregister(widget, keep, reg)
    if reg == nil then
        for w, i in pairs(registered) do
            if w == widget then
                for _, v in pairs(i) do
                    reg = unregister(w, keep, v)
                end
            end
        end

        return reg
    end

    if not keep then
        for w, i in pairs(registered) do
            if w == widget then
                for k, v in pairs(i) do
                    if v == reg then
                        table.remove(registered[w], k)
                    end
                end
            end
        end
    end

    -- Stop the timer
    if timers[reg.update].timer.started then
        timers[reg.update].timer:stop()
    end
    reg.running = false

    return reg
end
-- }}}

-- {{{ Suspend sensual
function suspend()
    for w, i in pairs(registered) do
        for _, v in pairs(i) do
            unregister(w, true, v)
        end
    end
end
-- }}}

-- {{{ Activate sensual
function activate(widget)
    for w, i in pairs(registered) do
        if widget == nil or w == widget then
            for _, v in pairs(i) do
                regregister(v)
            end
        end
    end
end
-- }}}

-- {{{ Update a widget
local function get_cache(reg)
    if widget_cache[reg.sensor] ~= nil then
        local t = os.time()
        local c = widget_cache[reg.sensor]

        if c.time == nil or c.time <= t - reg.timer then
            c.time = t
            c.data = reg.sensor()
        end

        return c.data, reg.sensor.meta
    end
end

local function update_widget(widget, params, data, meta)
    local method = params[3]
    local channels = params[1]
    local format = params[2]
    local stack = params[4]

    if type(data) == "table" and channels ~= nil then
        if type(channels) == "table" then
            data = helpers.slice(data, channels)
        else
            data = data[channels]
        end
    end

    if type(format) == "function" then
        data = format(widget, data, meta)
    end

    if method ~= nil then
        method(widget, data, stack)
    else
        widget.text = data
    end
end

function update(reg, disablecache)
    local data
    local meta
    if not disablecache then data, meta = get_cache(reg) end
    if not data then data, meta = reg.sensor(), reg.sensor.meta end

    for i, widget in ipairs(reg.widgets) do
        update_widget(widget, reg.params[i], data, meta)
    end
end

-- }}}
-- }}}
