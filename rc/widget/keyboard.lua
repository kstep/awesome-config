
local capi = { widget = widget, dbus = dbus }
local theme = require("beautiful")
local setmetatable = setmetatable

module("rc.widget.keyboard")

widget = capi.widget({ type = "textbox" })
layouts = { [0] = "<span color='#000000' bgcolor='" .. theme.kbd[0] .. "'> En </span>", [1] = "<span color='#000000' bgcolor='" .. theme.kbd[1] .. "'> Ru </span>" }
widget.text = layouts[0]

capi.dbus.request_name("session", "ru.gentoo.kbdd")
capi.dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
capi.dbus.add_signal("ru.gentoo.kbdd", function (src, layout)
    widget.text = layouts[layout]
    widget.background_color = theme.kbd[layout]
end)

setmetatable(_M, { __call = function (_, ...) return widget end })

