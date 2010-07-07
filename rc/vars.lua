
local util   = require("awful.util")
local wiout  = require("awful.widget.layout")
local layout = require("awful.layout.suit")
local screen = screen

local getenv = os.getenv

module("rc.vars")

theme_path = util.getdir("config") .. "/themes/default/theme.lua"

layouts =
{
    layout.tile,
    layout.tile.left,
    layout.tile.bottom,
    layout.tile.top,
    layout.fair,
    layout.fair.horizontal,
    layout.spiral,
    layout.spiral.dwindle,
    layout.max,
    layout.max.fullscreen,
    layout.magnifier,
    layout.floating
}

terminal     = "urxvt"
terminal_cmd = terminal .. " -e tmux"
editor       = getenv("EDITOR") or "vim"
editor_cmd   = terminal .. " -e " .. editor

locker = "/usr/bin/slock"

modkey = "Mod4"

statbox_layout = wiout.horizontal.rightleft
widgets_screen = screen.count()

