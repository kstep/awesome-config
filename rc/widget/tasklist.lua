
local client = client

local util    = require("awful.util")
local tag     = require("awful.tag")
local button  = require("awful.button")
local aclient = require("awful.client")

local tasklist = require("awful.widget.tasklist")

local setmetatable = setmetatable

module("rc.widget.tasklist")

local buttons = util.table.join(
    button({ }, 1, function (c)
	if not c:isvisible() then
	    tag.viewonly(c:tags()[1])
	end
	client.focus = c
	c:raise()
    end),
    button({ }, 3, function (c)
	c:kill()
    end),
    button({ }, 4, function ()
	aclient.focus.byidx(1)
	if client.focus then client.focus:raise() end
    end),
    button({ }, 5, function ()
	aclient.focus.byidx(-1)
	if client.focus then client.focus:raise() end
    end)
)

function widget(s)
    return tasklist(function(c)
	return tasklist.label.currenttags(c, s)
    end, buttons)
end

setmetatable(_M, { __call = function(_, ...) return widget(...) end })

