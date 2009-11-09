require("awful.util")
-- Inherit default theme

theme = dofile("/usr/local/share/awesome/themes/zenburn/theme.lua")

theme.font          = "terminus 8"

theme.Full        = "#C4C871"
theme.Charging    = "#39C83C"
theme.Discharging = "#C84D4D"

theme.up      = "#39C83C"
theme.down    = "#C84D4D"
theme.unknown = "#C4C871"

theme.wallpaper_cmd = { "awsetbg " .. awful.util.getdir("config") .. "/themes/default/Desktopography-1800x1125.jpg" }

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
