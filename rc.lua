-- Standard awesome library
require("awful")
require("awful.autofocus")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Shifty tagging library
require("shifty")

require("sensual")

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
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

-- }}}

-- {{{ Tags
shifty.config.tags = {
	["term"]   = { position = 1, layout = awful.layout.suit.tile, init = true, },
	["msgs"]   = { position = 2, layout = awful.layout.suit.tile, mwfact = 0.75, },
	["www"]    = { position = 3, layout = awful.layout.suit.max, },
	["git"]    = { position = 4, layout = awful.layout.suit.tile.bottom, },
	["video"]  = { position = 5, layout = awful.layout.suit.max, nopopup = false, },
	["files"]  = { position = 6, layout = awful.layout.suit.tile, nopopup = false, },
	["graph"]  = { position = 7, layout = awful.layout.suit.tile.left, },
	["view"]   = { position = 8, layout = awful.layout.suit.tile, },
	["edit"]   = { position = 9, layout = awful.layout.suit.tile.bottom, },
	["design"] = { layout = awful.layout.suit.fair, mwfact = 0.7, ncol = 2, },
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
	{ match = {"Xterm", "URxvt"},  tag = "term", opacity = 0.8 },
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

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
menu_items = freedesktop.menu.new()
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}
table.insert(menu_items, { "awesome", myawesomemenu, beautiful.awesome_icon })
table.insert(menu_items, { "open terminal", terminal .. " -e screen", freedesktop.utils.lookup_icon({icon = 'terminal'}) })

mymainmenu = awful.menu({ items = menu_items, width = 150 })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
statwibox = {}

mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
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

swibox_layout = awful.widget.layout.horizontal.rightleft
uptime_widget = sensual.label(" [%dd %2d:%02d]")

thermal_widgets = {
    awful.widget.progressbar({ width = 5, layout = swibox_layout }), -- tz1
    awful.widget.progressbar({ width = 5, layout = swibox_layout }), -- tz0
    sensual.label("/%.1f°C "), -- tz1
    sensual.label(" %.1f°C"), -- tz0
    layout = swibox_layout
}
thermal_widgets[1]:set_vertical(true)
thermal_widgets[2]:set_vertical(true)

cpufreq_widgets = {
    awful.widget.progressbar({ width = 10, layout = swibox_layout }), -- cpu0
    sensual.label(" %5.1f %s "), -- cpu0
    layout = swibox_layout
}
cpufreq_widgets[1]:set_vertical(true)

battery_widgets = {
    awful.widget.progressbar({ width = 10, layout = swibox_layout }), -- bat0
    sensual.label("[%(2)2d:%(3)02d] "), -- bat0
    sensual.label(" %3d%% "), -- bat0
    layout = swibox_layout
}
battery_widgets[1]:set_vertical(true)

cpuload_widgets = {
    awful.widget.graph({ width = 15, layout = swibox_layout }), -- bat0
    --awful.widget.graph({ width = 15, layout = swibox_layout }), -- bat0
    layout = swibox_layout--awful.widget.layout.horizontal.rightleft
}
cpuload_widgets[1]:set_max_value(100)

-- method, channels, formatter
sensual.registermore(sensual.uptime(), { uptime_widget }, { { nil, nil, sensual.formatters.hms } }, 60)

sensual.registermore(sensual.thermal(1), { thermal_widgets[1], thermal_widgets[3] }, {
    { nil, nil, sensual.formatters.scale },
    { nil, nil, nil },
},
10)

sensual.registermore(sensual.thermal(0), { thermal_widgets[2], thermal_widgets[4] }, {
    { nil, nil, sensual.formatters.scale },
    { nil, nil, nil },
},
10)

sensual.registermore(sensual.cpufreq("cpu0"), cpufreq_widgets, {
    { nil, nil, sensual.formatters.scale },
    { nil, nil, sensual.formatters.humanize },
},
5)

sensual.registermore(sensual.bat("BAT0"), awful.util.table.join(battery_widgets, battery_widgets), {
    { nil, { 1 }, sensual.formatters.scale },
    { nil, { 2 }, sensual.formatters.hms },
    { nil, { 1 }, sensual.formatters.percent },

    { "set_color", { 3 }, sensual.formatters.theme },
    { "set_color", { 3 }, sensual.formatters.theme },
    { "set_color", { 3 }, sensual.formatters.theme },
},
5)

sensual.registermore(sensual.cpu(), cpuload_widgets, {
    { nil, 1, nil },
    --{ nil, 3, nil },
}, 2)

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.flex })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
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
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mylayoutbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mytextclock,
        uptime_widget,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }

    statwibox[s] = awful.wibox({ position = "bottom", screen = s })
    statwibox[s].widgets = {

        thermal_widgets,
        cpufreq_widgets,
        cpuload_widgets,
        sensual.label(" cpu: "),
        battery_widgets,
        mypromptbox[s],

        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

function find_tags(name)
	if not name or name == "" then return end

	local tags = screen[mouse.screen]:tags()
	local found_tags = {}
	if tags and #tags > 0 then
		for i, tag in ipairs(tags) do
			if tag.name:find(name) then
				table.insert(found_tags, tag)
			end
		end
		if #found_tags > 0 then return found_tags end
	end
end

function find_clients(name)
	if not name or name == "" then return end

	local clients = client.get(mouse.screen)
	local found_clis = {}
	if clients and #clients > 1 then
		for i, cli in ipairs(clients) do
			if cli.name:lower():find(name)
				or cli.class:lower():find(name)
				or cli.instance:lower():find(name) then
				table.insert(found_clis, cli)
			end
		end
		if #found_clis > 0 then return found_clis end
	end
end

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	awful.key({ "Control", "Mod1", "Shift" }, "Escape",
              function ()
                  awful.prompt.run({ prompt = "Keyboard locked" },
                  mypromptbox[mouse.screen].widget,
                  function (c) end)
              end),
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
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Escape",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    awful.key({                   }, "Num_Lock", function () awful.util.spawn("3ddesk --mode=viewmaster") end),

    -- Standard program
    awful.key({ modkey, "Control" }, "Return", function () awful.util.spawn(terminal .. " -e screen") end),
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

    awful.key({ modkey, "Control", "Mod1" }, "space", function ()
        local clients = client.get()
        local opacity = (clients[1].opacity or 1.0)
        opacity = opacity == 1.0 and 0.4 or 1.0

        for k, c in ipairs(clients) do
            c.opacity = opacity
        end
    end),

	awful.key({ modkey }, "Up", function () awful.util.spawn("amixer sset Master 5%+") end),
	awful.key({ modkey }, "Down", function () awful.util.spawn("amixer sset Master 5%-") end),
	awful.key({ modkey, "Mod1" }, "Down", function () awful.util.spawn("amixer sset Master toggle") end),

    -- Prompt
    awful.key({ modkey },            "grave", function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

	awful.key({ modkey }, "apostrophe", function ()
					awful.prompt.run({ prompt = "Tag name: " },
					mypromptbox[mouse.screen].widget,
					function (name)
						local tags = find_tags(name)
						if tags then
							awful.tag.viewonly(tags[1])
						end
					end, nil, nil)
				end),

	awful.key({ modkey, "Shift" }, "apostrophe", function ()
					awful.prompt.run({ prompt = "Tags name: " },
					mypromptbox[mouse.screen].widget,
					function (name)
						local tags = find_tags(name)
						if tags then
							awful.tag.viewmore(tags)
						end
					end, nil, nil)
				end),

	awful.key({ modkey }, "slash", function ()
					awful.prompt.run({ prompt = "Client name: " },
					mypromptbox[mouse.screen].widget,
					function (name)
						local clis = find_clients(name)
						if clis then
							awful.tag.viewonly(clis[1]:tags()[1])
							client.focus = clis[1]
						end
					end, nil, nil)
				end),

	awful.key({ modkey, "Shift" }, "slash", function ()
					awful.prompt.run({ prompt = "Clients name: " },
					mypromptbox[mouse.screen].widget,
					function (name)
						local clis = find_clients(name)
						if clis then
							local current_tags = {}
							local tags = screen[mouse.screen]:tags()
							for i, tag in ipairs(tags) do
								if tag.selected then table.insert(current_tags, tag) end
							end

							for i, cli in ipairs(clis) do
								cli:tags(current_tags)
							end
						end
					end, nil, nil)
				end)
)

shifty.config.clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    awful.key({ modkey, "Mod1" }, "space", function (c) c.opacity = (c.opacity or 1.0) == 1.0 and 0.4 or 1.0 end),
    awful.key({ modkey }, "minus", function (c) c.opacity = c.opacity - 0.1 end),
    awful.key({ modkey }, "equal", function (c) c.opacity = c.opacity + 0.1 end)
)

for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local tag = shifty.getpos(i)
                        if tag then
                            awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local tag = shifty.getpos(i)
                      if tag then
                          tag.selected = not tags.selected
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = shifty.getpos(i)
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
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

shifty.config.clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

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
