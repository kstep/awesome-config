
local wiout = require("awful.widget.layout")
local wibox = require("awful.wibox")

--local menu      = require("rc.widget.menu")
local taglist   = require("rc.widget.taglist")
local tasklist  = require("rc.widget.tasklist")
local layoutbox = require("rc.widget.layoutbox")
local systray   = require("rc.widget.systray")
local textclock = require("rc.widget.textclock")
local tomato    = require("rc.widget.tomato")
local uptime    = require("rc.widget.sensor.uptime")
local weather   = require("rc.widget.sensor.weather")
local keyboard  = require("rc.widget.keyboard")

local setmetatable = setmetatable
local print=print

module("rc.widget.topbar")

local cache = {}
local function get(s)
    if cache[s] then return cache[s] end
    local wbox = wibox({ position = "top", screen = s})

    wbox.widgets = {
	{
	    --menu(s),
	    taglist(s),
	    layoutbox(s),
	    
	    layout = wiout.horizontal.leftright
	},

        tomato(s),
	textclock(s),
	uptime(s),
	weather(s),
        keyboard(s),
	systray(s),
	tasklist(s),

	layout = wiout.horizontal.rightleft
    }

    cache[s] = wbox
    return wbox
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

