local sensual = require("sensual")
local vars = require("rc.vars")
local layouts = require("awful.widget.layout")
local tooltip = require("awful.tooltip")
local setmetatable = setmetatable

module("rc.widget.sensor.weather")

local widget = { sensual.label("%(temp)s°C"), sensual.icon() }
reg = sensual.registermore(sensual.yaweather(), widget, { { 1 }, { 1, function(w, args) data = args; return args and args.icon or "" end } }, 600)
widget.layout = layouts.horizontal.rightleft
hint = tooltip({
    objects = { widget[1].widget, widget[2].widget },
    timer_function = function ()
        data = reg.sensor()
        if not data then return "" end
        result = ("Ветер %s, давление %s мм.рт.ст., влажность %s.\n"):format(data[1].wind, data[1].pressure, data[1].humidity)
        line = "%s %s, %s°C (%s°C ночью)\n"
        for i = 2,5 do
            result = result .. line:format(data[i].date, data[i].desc, data[i].temp, data[i].temp_night)
        end
        return result:sub(1, result:len()-1)
    end
})

local function get(s)
    return s == vars.widgets_screen and widget or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })

