require("awful.util")
-- Inherit default theme

theme = dofile("/usr/local/share/awesome/themes/zenburn/theme.lua")

theme.font          = "terminus 8"

-- Palette generated with http://www.colorschemer.com/online.html,
-- key color is #F0DFAF, colors taken:
-- 1, 2, 3, 4,
-- 5, 6, 7, 8,
-- 9, 10, 11,
-- 14, 15, 16.
theme.palette = {
    "#EFDEAE", --  1 peach
    "#E0EFAE", --  2 marshal
    "#BFEFAE", --  3 sea green
    "#AEEFBD", --  4 blue green
    "#EFBDAE", --  5 pastel pink
    "#E6C97A", --  6 light brown
    "#DCB447", --  7 dark brown
    "#AEEFDE", --  8 cyan
    "#EFAEBF", --  9 purple
    "#476FDC", -- 10 blue
    "#7A97E6", -- 11 light blue
    "#DEAEEF", -- 12 light violet
    "#BDAEEF", -- 13 violet
    "#AEBFEF", -- 14 gray blue
}

theme.Full        = theme.palette[11]
theme.Charging    = theme.palette[3]
theme.Discharging = theme.palette[5]

theme.up      = theme.palette[3]
theme.down    = theme.palette[5]
theme.unknown = theme.palette[11]
theme.netstat = {
    ["ppp"]  = theme.palette[7],
    ["wifi"] = theme.palette[12],
}

theme.disk = {
    ["root"] = theme.palette[13],
    ["home"] = theme.palette[9],
}

theme.mem = {
    ["ram"]  = theme.palette[4],
    ["swap"] = theme.palette[7],
}

theme.cpu = {
    ["load"]  = theme.palette[1],
    ["therm"] = { theme.palette[1], theme.palette[4] },
}

theme.volume = theme.palette[8]

theme.wallpaper_cmd = { "awsetbg " .. awful.util.getdir('config') .. "/themes/default/Desktopography-1800x1125.jpg" }

theme.icons_dir = "/usr/share/icons/gnome/16x16/actions"
theme.icons = {
    player = {
        ['play']  = theme.icons_dir .. "/player_play.png",
        ['pause'] = theme.icons_dir .. "/player_pause.png",
        ['stop']  = theme.icons_dir .. "/player_stop.png",
        ['next']  = theme.icons_dir .. "/player_fwd.png",
        ['prev']  = theme.icons_dir .. "/player_rew.png",
    }
}

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
