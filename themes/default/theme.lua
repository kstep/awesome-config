require("awful.util")
-- Inherit default theme

theme = dofile("/usr/share/awesome/themes/zenburn/theme.lua")

-- Zhurazlik theme from https://awesome.naquadah.org/wiki/Zhuravlik_theme
theme.bg_normal     = "#f7f7f7"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#535d6c"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "1"
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"

-- My own config
theme.font          = "terminus 8"

-- Palette generated with http://www.colorschemer.com/online.html,
-- key color is #F0DFAF, colors taken:
-- 1, 2, 3, 4,
-- 5, 6, 7, 8,
-- 9, 10, 11,
-- 14, 15, 16.
--theme.palette = {
    --"#EFDEAE", --  1 peach
    --"#E0EFAE", --  2 marshal
    --"#BFEFAE", --  3 sea green
    --"#AEEFBD", --  4 blue green
    --"#EFBDAE", --  5 pastel pink
    --"#E6C97A", --  6 light brown
    --"#DCB447", --  7 dark brown
    --"#AEEFDE", --  8 cyan
    --"#EFAEBF", --  9 purple
    --"#476FDC", -- 10 blue
    --"#7A97E6", -- 11 light blue
    --"#DEAEEF", -- 12 light violet
    --"#BDAEEF", -- 13 violet
    --"#AEBFEF", -- 14 gray blue
--}
theme.palette = {
    "#A15050", -- 1
    "#408040", -- 2
    "#306060", -- 3
    "#A17550", -- 4
    "#814065", -- 5
    "#949494", -- 6
    "#A05050", -- 7
    "#7C954B", -- 8
    "#306060", -- 9
    "#804064", -- 10
    "#C078A0", -- 11
    "#A07450", -- 12
    "#59386B", -- 13
    "#7C954A", -- 14
}

theme.kbd = {
    [0] = theme.palette[2],
    [1] = theme.palette[5],
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

function map(func, table)
    result = {}
    for k, v in pairs(table) do
        result[k] = func(v)
    end
    return result
end

theme.wallpaper_cmd = map(function (v) return "awsetbg -t " .. awful.util.getdir('config') .. "/themes/default/Cosmosition_" .. v .. ".jpg" end,
    {
        "1280x800",
        "1680x1050",
    })

theme.icons_dir = "/usr/share/icons/oxygenrefit2-black/16x16/actions"
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
