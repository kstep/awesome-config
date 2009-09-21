-- Standard awesome library
require("awful")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Shifty tagging library
require("shifty")
-- Lifty monitoring library
require("lifty")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
theme_path = awful.util.getdir("config") .. "/themes/default/theme.lua"
-- Uncommment this for a lighter theme
-- theme_path = "/usr/local/share/awesome/themes/sky/theme.lua"

-- Actually load theme
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

locker = "xlock"

-- Freedesktop menus support
require("freedesktop.utils")
freedesktop.utils.terminal = terminal
freedesktop.utils.icon_theme = "gnome"
require("freedesktop.menu")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Tags
shifty.config.tags = {
	["term"]   = { position = 1, layout = awful.layout.suit.tile, init = true, },
	["msgs"]   = { position = 2, layout = awful.layout.suit.tile, mwfact = 0.75, },
	["www"]    = { position = 3, layout = awful.layout.suit.max, },
	["edit"]   = { position = 4, layout = awful.layout.suit.tile.bottom, },
	["files"]  = { position = 5, layout = awful.layout.suit.tile, nopopup = false, },
	["view"]   = { position = 6, layout = awful.layout.suit.tile, },
	["graph"]  = { position = 7, layout = awful.layout.suit.tile.left, },
	["video"]  = { position = 8, layout = awful.layout.suit.max, nopopup = false, },
	["design"] = { position = 9, layout = awful.layout.suit.fair, mwfact = 0.7, ncol = 2, },
	["dbms"]   = { layout = awful.layout.suit.max, },
	["other"]  = { position = 0, },
	["notes"]  = { },
}

shifty.config.apps = {
	{ match = {"Qjackctl"}, tag = "audio", float = true, geometry = { width = 550, height = 115 } },
	{ match = {"Rosegarden"}, tag = "audio" },
	{ match = {"Grecord"}, tag = "audio", float = true },
	{ match = {"Gvim", "Vim", "OpenOffice"},  tag = "edit" },
	{ match = {"gimp"},  tag = "graph" },
	{ match = {"Smplayer", "MPlayer", "VLC.*"},  tag = "video" },
	{ match = {"Opera", "Firefox", "Links", "IEXPLORE"},  tag = "www" },
	{ match = {"Rox", "Konqueror", "emelfm2"},  tag = "files" },
	{ match = {"Gliv", "GQview", "Xloadimage", "Kview", "Kpdf"},  tag = "view" },
	{ match = {"Thunderbird.*"},  tag = "msgs" },
	{ match = {"Pidgin", "Skype.*"},  tag = "msgs", slave = true },
	{ match = {"Xterm", "URxvt"},  tag = "term" },
	{ match = {"^Dia$", "designer", "glade"}, tag = "design", slave = true },
	{ match = {"mysql-.*"}, tag = "dbms" },
	{ match = {"xmessage"},  float = true, nopopup = true, geometry = { x = 1000, y = 600 } },
	{ match = {".*calc.*", "screenruler"},  float = true },
	{ match = {"Giggle", "Gitg"}, tag = "git" },
	{ match = {"Gournal", "Xournal"}, tag = "notes" },
}

shifty.config.defaults = {
	layout  = awful.layout.suit.max,
	mwfact  = 0.62,
	nopopup = true,
	tag     = "other",
}

shifty.init()
-- }}}

-- {{{ Wibox
-- Create a textbox widget
mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> " .. awesome.release .. " </small></b>"

-- Create a laucher widget and a main menu
menu_items = freedesktop.menu.new()
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}
table.insert(menu_items, { "awesome", myawesomemenu, beautiful.awesome_icon })
table.insert(menu_items, { "open terminal", terminal, freedesktop.utils.lookup_icon({icon = 'terminal'}) })

mymainmenu = awful.menu.new({ items = menu_items, width = 150 })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })

-- Create a systray
mysystray = widget({ type = "systray", align = "right" })

-- Sensors
battery_sensor = lifty.sensors.battery(0)
cpufreq_sensor = lifty.sensors.cpu.frequency(0)
cpuload_sensors = {
	lifty.sensors.cpu.loadstat(0),
	lifty.sensors.cpu.loadstat(1),
}
thermal_sensors = {
	lifty.sensors.thermal.temperature(0),
	lifty.sensors.thermal.temperature(1),
}

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, function (tag) tag.selected = not tag.selected end),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function (c)
                                              c:kill()
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

mystatwibox = {}
battery_widget = {}
thermal_widgets = {}
cpufreq_widgets = {}
cpuload_widgets = {}

bar_widget_params = { align = "right", vertical = true, width = 10, height = 0.66 }

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", align = "left" })
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = wibox({ position = "top", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = { mylauncher,
                           mytaglist[s],
                           mylayoutbox[s],
                           mytasklist[s],
                           mytextbox,
                           s == 1 and mysystray or nil }
    mywibox[s].screen = s

	bar_widget_params.title = "bat:"
	battery_widget[s] =
		lifty.widgets.common.progressbar(bar_widget_params, {
			["bat0"] = { sensor = battery_sensor },
		}).widgets

	bar_widget_params.title = "therm:"
	thermal_widgets[s] =
		lifty.widgets.common.progressbar(bar_widget_params, {
			["therm0"] = { sensor = thermal_sensors[1] },
			["therm1"] = { sensor = thermal_sensors[2] },
		}).widgets
	bar_widget_params.title = "freq:"
	cpufreq_widgets[s] =
		lifty.widgets.common.progressbar(bar_widget_params, {
			["cpufreq0"] = { sensor = cpufreq_sensor, period = 2, humanize = { base = 1000, postfixes = { "Hz", "MHz", "GHz" } } },
		}).widgets
	bar_widget_params.title = "load:"
	cpuload_widgets[s] =
		lifty.widgets.common.graph(bar_widget_params, {
			["cpuload0"] = { sensor = cpuload_sensors[1], period = 2 },
			["cpuload1"] = { sensor = cpuload_sensors[2], period = 2 },
		}).widgets

	mystatwibox[s] = wibox({ position = "bottom", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
	mystatwibox[s].widgets = {
		mypromptbox[s],
		battery_widget[s],
		thermal_widgets[s],
		cpufreq_widgets[s],
		cpuload_widgets[s],
	}
	mystatwibox[s].screen = s
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Tab", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus( 1)       end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus(-1)       end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Escape",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({                   }, "Scroll_Lock", function () awful.util.spawn(locker) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "space", function ()
        local clients = client.get()
        local opacity = (clients[1].opacity or 1.0)
        opacity = opacity == 1.0 and 0.4 or 1.0

        for k, c in ipairs(clients) do
            c.opacity = opacity
        end
    end),

    -- Prompt
    awful.key({ modkey },            "grave", function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey }, "t", awful.client.togglemarked),
    awful.key({ modkey,}, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, i,
                  function ()
                        local tag = shifty.getpos(i)
                        if tag then
                            awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, i,
                  function ()
                      local tag = shifty.getpos(i)
                      if tag then
                          tag.selected = not tags.selected
                      end
                  end),
        awful.key({ modkey, "Shift" }, i,
                  function ()
                      local tag = shifty.getpos(i)
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, i,
                  function ()
                      local tag = shifty.getpos(i)
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "F" .. i,
                  function ()
                      local tag = shifty.getpos(i)
                      if tag then
                          for k, c in pairs(awful.client.getmarked()) do
                              awful.client.movetotag(tag, c)
                          end
                      end
                   end))
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client.
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c, startup)
    -- If we are not managing this application at startup,
    -- move it to the screen where the mouse is.
    -- We only do it for filtered windows (i.e. no dock, etc).
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end

    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons(awful.util.table.join(
        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({ modkey }, 1, awful.mouse.client.move),
        awful.button({ modkey }, 3, awful.mouse.client.resize)
    ))
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
    client.focus = c

    -- Set key bindings
    c:keys(clientkeys)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.size_hints_honor = false
end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.getname(awful.layout.get(screen))
    if layout and beautiful["layout_" ..layout] then
        mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
    else
        mylayoutbox[screen].image = nil
    end

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)

-- Hook called every minute
function hook_clock()
	mytextbox.text = os.date(" %a %b %d, %H:%M ")
end
awful.hooks.timer.register(60, hook_clock)
hook_clock()
-- }}}
