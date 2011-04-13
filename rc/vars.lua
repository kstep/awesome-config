
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

terminal     = "xterm"
terminal_cmd = terminal .. " -e tmux"

editor       = getenv("EDITOR") or "vim"
editor_cmd   = terminal .. " -e " .. editor

--browser      = "/usr/bin/firefox"
browser      = "/usr/bin/luakit"
browser_cmd  = browser

player       = "/usr/bin/smplayer"
player_cmd   = player

veditor      = "/usr/bin/gvim"
veditor_cmd  = veditor

locker = "/usr/bin/slimlock"

modkey = "Mod4"

statbox_layout = wiout.horizontal.rightleft
widgets_screen = screen.count()

