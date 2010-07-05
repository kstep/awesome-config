local util    = require("awful.util")
local button  = require("awful.button")
local tag     = require("awful.tag")
local client  = require("awful.client")
local taglist = require("awful.widget.taglist")

local vars = require("rc.vars")

local setmetatable = setmetatable

module("rc.widget.taglist")

local buttons = util.table.join(
    button({ }             , 1 , tag.viewonly)     , 
    button({ vars.modkey } , 1 , client.movetotag) , 
    button({ }             , 3 , tag.viewtoggle)   , 
    button({ vars.modkey } , 3 , client.toggletag) , 
    button({ }             , 4 , tag.viewnext)     , 
    button({ }             , 5 , tag.viewprev)
)

function widget(s)
    return taglist(s, taglist.label.all, buttons)
end

setmetatable(_M, { __call = function(_, ...) return widget(...) end })

