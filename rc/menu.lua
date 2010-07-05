
local awesome = awesome
local table   = table

local freedesktop = {
    menu  = require("freedesktop.menu"),
    utils = require("freedesktop.utils")
}

local menu  = require("awful.menu")
local theme = require("beautiful")
local util  = require("awful.util")

local vars = require("rc.vars")

module("rc.menu")

freedesktop.utils.terminal = vars.terminal
freedesktop.utils.icon_theme = "gnome"

local menu_items = freedesktop.menu.new()
local awesomemenu = {
   { "manual"      , vars.terminal .. " -e man awesome" }                           , 
   { "edit config" , vars.editor_cmd .. " " .. util.getdir("config") .. "/rc.lua" } , 
   { "restart"     , awesome.restart }                                              , 
   { "quit"        , awesome.quit }
}
table.insert(menu_items, { "awesome", awesomemenu, theme.awesome_icon })
table.insert(menu_items, { "open terminal", vars.terminal_cmd, freedesktop.utils.lookup_icon({icon = 'terminal'}) })

mainmenu = menu({ items = menu_items, width = 150 })

