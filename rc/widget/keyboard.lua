
local capi = { widget = widget, dbus = dbus }
local theme = require("beautiful")
local dbus = require("simpledbus")
local setmetatable = setmetatable

module("rc.widget.keyboard")

widget = capi.widget({ type = "textbox" })
layouts = { [0] = "<span color='#FFFFFF' bgcolor='" .. theme.kbd[0] .. "'> En </span>", [1] = "<span color='#FFFFFF' bgcolor='" .. theme.kbd[1] .. "'> Ru </span>" }
widget.text = layouts[0]

capi.dbus.request_name("session", "ru.gentoo.kbdd")
capi.dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
capi.dbus.add_signal("ru.gentoo.kbdd", function (src, layout)
    widget.text = layouts[layout]
    widget.background_color = theme.kbd[layout]
end)

local bus = dbus.SessionBus()
function set_layout(layout)
    return bus:call_method('ru.gentoo.KbddService', '/ru/gentoo/KbddService', 'ru.gentoo.kbdd', 'set_layout', true, 'u', layout or 0)
end
function prev_layout()
    return bus:call_method('ru.gentoo.KbddService', '/ru/gentoo/KbddService', 'ru.gentoo.kbdd', 'prev_layout', true)
end

setmetatable(_M, { __call = function (_, ...) return widget end })

