local shifty = require("shifty")
local layout = require("awful.layout.suit")
local button = require("awful.button")
local util   = require("awful.util")
local mouse  = require("awful.mouse")
local client = client
local vars   = require("rc.vars")

module("rc.tags")

tags = {
    ["term"]   = { position = 1, layout = layout.tile.bottom, init = true, screen = 1 },
    ["msgs"]   = { position = 2, layout = layout.tile, mwfact = 0.75, screen = 1 },
    ["skype"]  = { layout = layout.fair, screen = 1 },
    ["www"]    = { position = 3, layout = layout.max, screen = 2 },
    ["git"]    = { position = 4, layout = layout.tile.bottom, screen = 2 },
    ["video"]  = { position = 5, layout = layout.max, nopopup = false, },
    ["files"]  = { position = 6, layout = layout.tile, nopopup = false, },
    ["graph"]  = { position = 7, layout = layout.tile.left, },
    ["view"]   = { position = 8, layout = layout.tile, screen = 2 },
    ["edit"]   = { position = 9, layout = layout.tile.bottom, screen = 2 },
    ["design"] = { layout = layout.fair, mwfact = 0.7, ncol = 2, screen = 2 },
    ["dbms"]   = { layout = layout.max, },
    ["other"]  = { position = 0, },
    ["vbox"]   = { layout = layout.max, screen = 2 },
    ["notes"]  = { },
    ["sql"]    = { screen = 2 },
}

rules = {
    { match = {"Qjackctl"}, tag = "audio", float = true, geometry = { width = 550, height = 115 } },
    { match = {"Rosegarden"}, tag = "audio" },
    { match = {"Grecord"}, tag = "audio", float = true },
    { match = {"Gvim", "Vim", "OpenOffice", "Pida"},  tag = "edit" },
    { match = {"gimp"},  tag = "graph" },
    { match = {"Smplayer", "MPlayer", "VLC.*"},  tag = "video" },
    { match = {"Opera", "Firefox", "Links", "IEXPLORE", "Google-chrome", "Uzbl"},  tag = "www" },
    { match = {"Rox", "Konqueror", "emelfm2"},  tag = "files" },
    { match = {"Gliv", "Mirage", "GQview", "Xloadimage", "Kview", "Kpdf"},  tag = "view" },
    { match = {"Thunderbird.*"},  tag = "msgs" },
    { match = {"Skype.*"},  tag = "skype" },
    { match = {"Pidgin"},  tag = "msgs", slave = true },
    { match = {"Xterm", "URxvt"},  tag = "term", opacity = 0.8, slave = true },
    { match = {"^Dia$", "designer", "glade"}, tag = "design", slave = true },
    { match = {"mysql-.*"}, tag = "dbms" },
    { match = {"xmessage"},  float = true, nopopup = true, geometry = { x = 1000, y = 600 } },
    { match = {".*calc.*", "screenruler", "Airappinstaller"},  float = true },
    { match = {"Giggle", "Gitg"}, tag = "git" },
    { match = {"^freemind", "Gournal", "Xournal"}, tag = "notes" },
    { match = {"Pgadmin3"}, tag = "sql" },
    { match = {"VirtualBox"}, tag = "vbox" },
}

defaults = {
	layout  = layout.max,
	mwfact  = 0.62,
	nopopup = true,
	tag     = "other",
}

buttons = util.table.join(
    button({ }, 1, function (c) client.focus = c; c:raise() end),
    button({ vars.modkey }, 1, mouse.client.move),
    button({ vars.modkey }, 3, mouse.client.resize)
)

