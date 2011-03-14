
local progressbar = require("awful.widget.progressbar")
local sensual = require("sensual")
local vars = require("rc.vars")

local util   = require("awful.util")
local button = require("awful.button")

local theme = require("beautiful")

local setmetatable = setmetatable

module("rc.widget.sensor.volume")

local widgets = {
    progressbar({ width = 5, layout = vars.statbox_layout }),
    sensual.label(" %d%% "),
    layout = vars.statbox_layout
}
widgets[1]:set_vertical(true)
widgets[1]:set_color(theme.volume)
widgets[1]:set_border_color(theme.volume)
widgets[1]:set_height(17)
widgets[2]:set_color(theme.volume)

set_mute_color = function (w, value, meta) return value and theme.down or theme.up end
reg = sensual.registermore(sensual.mixer(0, "misc.front1", "misc.front-mute"), util.table.join(widgets, widgets), {
    { 1, sensual.filters.scale },
    { 1 },
    { 2, set_mute_color, "set_color" },
    { 2, set_mute_color, "set_color" },
}, 5)

function get_volume()
    return reg.sensor.devices[1].pvalue[1]
end
function set_volume(v)
    reg.sensor.devices[1].pvalue = v
    reg.update()
end

function get_mute()
    return reg.sensor.devices[2].value
end
function set_mute(v)
    reg.sensor.devices[2].value = v
    reg.update()
end

function inc_vol(v)
    return function()
        set_volume(get_volume() + v)
    end
end
function toggle_mute()
    set_mute(not get_mute())
end

widgets[2].widget:buttons(util.table.join(
    button({ }, 3, toggle_mute),
    button({ }, 4, inc_vol(1)),
    button({ }, 5, inc_vol(-1))
))

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

