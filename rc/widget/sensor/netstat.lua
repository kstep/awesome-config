
local progressbar = require("awful.widget.progressbar")
local graph       = require("awful.widget.graph")
local tooltip     = require("awful.tooltip")
local util        = require("awful.util")

local sensual = require("sensual")
local vars = require("rc.vars")

local theme = require("beautiful")

local setmetatable = setmetatable

module("rc.widget.sensor.netstat")

local widgets = {
    graph({ width = 30, height = 17, layout = vars.statbox_layout }),
    sensual.label(" ◊%3d %s "),

    graph({ width = 30, height = 17, layout = vars.statbox_layout }),
    progressbar({ width = 5, layout = vars.statbox_layout }),
    sensual.label(" ᛘ%3d %s "),

    layout = vars.statbox_layout
}
widgets[1]:set_max_value(1024*3000)
widgets[3]:set_max_value(1024*3000)
widgets[4]:set_vertical(true)

widgets[1]:set_stack(true)
widgets[1]:set_color(theme.netstat.ppp)
widgets[1]:set_stack_colors({ theme.down, theme.up })
widgets[1]:set_background_color(theme.netstat.ppp.."33")
widgets[1]:set_border_color(theme.netstat.ppp)

widgets[3]:set_stack(true)
widgets[3]:set_color(theme.netstat.wifi)
widgets[3]:set_stack_colors({ theme.down, theme.up })
widgets[3]:set_background_color(theme.netstat.wifi.."33")
widgets[3]:set_border_color(theme.netstat.wifi)

widgets[4]:set_color(theme.netstat.wifi)
widgets[4]:set_border_color(theme.netstat.wifi)
widgets[4]:set_height(17)

hint = tooltip({
    objects = {
        widgets[1].widget, widgets[2].widget,
        widgets[3].widget, widgets[5].widget,
    },
    timer_function = function ()
        return util.pread("netstat -t -u -e -e | head -n 15")
    end
})

regs = {
    sensual.registermore(sensual.net("ppp0"), { widgets[1], widgets[1], widgets[2], widgets[2] }, {
        { 3, sensual.filters.delta, nil, 1 },
        { 4, sensual.filters.delta, nil, 2 },
        { 3, sensual.filters.velocity },
        { 1, sensual.filters.theme, "set_color" },
    }, 5),
    sensual.registermore(sensual.net("wlan0"), { widgets[3], widgets[3], widgets[5], widgets[5] }, {
        { 3, sensual.filters.delta, nil, 1 },
        { 4, sensual.filters.delta, nil, 2 },
        { 3, sensual.filters.velocity },
        { 1, sensual.filters.theme, "set_color" },
    }, 5),
    sensual.registermore(sensual.wifi("wlan0"), { widgets[4] }, {
        { "link", sensual.filters.scale },
    }, 5)
}

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })


