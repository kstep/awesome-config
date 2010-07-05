
local util   = require("awful.util")
local wiout  = require("awful.widget.layout")
local screen = screen

local getenv = os.getenv

module("rc.vars")

theme_path = util.getdir("config") .. "/themes/default/theme.lua"

terminal     = "urxvt"
terminal_cmd = terminal .. " -e tmux"
editor       = getenv("EDITOR") or "vim"
editor_cmd   = terminal .. " -e " .. editor

locker = "/usr/bin/slock"

modkey = "Mod4"

statbox_layout = wiout.horizontal.rightleft
widgets_screen = screen.count()

