require("awful")
require("beautiful")

require("rc.vars")
beautiful.init(rc.vars.theme_path)

require("rc.tags")
require("rc.keys")

require("rc.widget")

shifty.config.apps          = rc.tags.rules
shifty.config.tags          = rc.tags.tags
shifty.config.defaults      = rc.tags.defaults
shifty.config.clientbuttons = rc.tags.buttons
shifty.config.clientkeys    = rc.keys.client

screens = screen.count()
topwibox  = {}
statwibox = {}
for s = 1, screens do
    topwibox[s]  = rc.widget.topbar(s)
    statwibox[s] = rc.widget.statbar(s)
end

root.buttons(rc.keys.buttons)
root.keys(rc.keys.global)

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

shifty.init()
-- }}}

