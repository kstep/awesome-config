local key     = require("awful.key")
local button  = require("awful.button")
local util    = require("awful.util")
local prompt  = require("awful.prompt")
local tag     = require("awful.tag")

local shifty  = require("shifty")

local ascreen = require("awful.screen")
local aclient = require("awful.client")

local screen  = screen
local client  = client
local mouse   = mouse
local awesome = awesome
local tinsert = table.insert

local promptbox = require("rc.widget.promptbox")
local volume    = require("rc.widget.sensor.volume")

local vars  = require("rc.vars")
local rutil = require("rc.util")
local menu  = require("rc.menu")

local modkey = vars.modkey

module("rc.keys")

-- {{{ actions

local function lock_keys()
    prompt.run({ prompt = "Keyboard locked" },
	promptbox(mouse.screen).widget,
	function (c) end)
end

local function toggle_screen()
    ascreen.focus_relative(1)
    if not client.focus then
	client.focus = client.get(mouse.screen)[1]
    end
end

local function next_client()
    aclient.focus.byidx(1)
    if client.focus then client.focus:raise() end
end

local function prev_client()
    aclient.focus.byidx(-1)
    if client.focus then client.focus:raise() end
end

local function toggle_client()
    aclient.focus.history.previous()
    if client.focus then
	client.focus:raise()
    end
end

local function toggle_opacity()
    local clients = client.get()
    local opacity = (clients[1].opacity or 1.0)
    opacity = opacity == 1.0 and 0.4 or 1.0

    for k, c in ipairs(clients) do
	c.opacity = opacity
    end
end

local mixer_reg = volume.reg
local function inc_vol(v)
    return function ()
	mixer_reg.sensor.devices[1]:both(mixer_reg.sensor.devices[1][1] + v)
	mixer_reg.update()
    end
end
local function toggle_vol()
    mixer_reg.sensor.devices[1].muted = not mixer_reg.sensor.devices[1].muted
    mixer_reg.update()
end

local function run_lua_code()
    prompt.run({ prompt = "Run Lua code: " },
    promptbox(mouse.screen).widget,
    util.eval, nil,
    util.getdir("cache") .. "/history_eval")
end

local function find_tag_by_name(multi)
    return function()
	prompt.run({ prompt = "Tag name: " },
	promptbox(mouse.screen).widget,
	function (name)
	    local tags = rutil.find_tags(name)
	    if tags then
		if multi then
		    tag.viewmore(tags)
		else
		    tag.viewonly(tags[1])
		end
	    end
	end, nil, nil)
    end
end

local function find_client_by_name(multi)
    return function ()
	prompt.run({ prompt = "Client name: " },
	promptbox(mouse.screen).widget,
	function (name)
	    local clis = rutil.find_clients(name)
	    if clis then
		if multi then
		    local current_tags = {}
		    local tags = screen[mouse.screen]:tags()
		    for i, t in ipairs(tags) do
			if t.selected then tinsert(current_tags, t) end
		    end

		    for i, cli in ipairs(clis) do
			cli:tags(current_tags)
		    end
		else
		    tag.viewonly(clis[1]:tags()[1])
		    client.focus = clis[1]
		end
	    end
	end, nil, nil)
    end
end

local function cmus_cmd(cmd)
    return function()
	util.spawn("cmus-remote --"..cmd)
    end
end

local function switch_tag(i)
    return function()
        local t = shifty.getpos(i)
        if t then
            ascreen.focus(t.screen)
            tag.viewonly(t)
        end
    end
end

local function toggle_tag(i)
    return function()
        local t = shifty.getpos(i)
        if t then
            t.selected = not t.selected
        end
    end
end

local function move_client_to_tag(i)
    return function()
        local t = shifty.getpos(i)
        if client.focus and t then
            aclient.movetotag(t)
        end
    end
end

local function toggle_client_tag(i)
    return function()
        local t = shifty.getpos(i)
        if client.focus and t then
            aclient.toggletag(t)
        end
    end
end

local function move_marked_to_tag(i)
    return function()
        local t = shifty.getpos(i)
        if t then
            for k, c in pairs(aclient.getmarked()) do
                aclient.movetotag(t, c)
            end
        end
    end
end

-- }}}

global = util.table.join(

key({ "Control", "Mod1", "Shift" }, "Escape", lock_keys ),

key({ modkey } , "Left"  , tag.viewprev)        , 
key({ modkey } , "Right" , tag.viewnext)        , 
key({ modkey } , "Tab"   , tag.history.restore) , 
key({ modkey } , "q"     , toggle_screen)       , 

key({ modkey } , "j" , next_client)                                   , 
key({ modkey } , "k" , prev_client)                                   , 
key({ modkey } , "w" , function () menu.mainmenu:show(true) end) , 

-- Layout manipulation
key({ modkey , "Shift"   } , "j" , function () aclient.swap.byidx( 1) end) , 
key({ modkey , "Shift"   } , "k" , function () aclient.swap.byidx(-1) end) , 
key({ modkey , "Control" } , "j" , function () ascreen.focus_relative( 1) end) , 
key({ modkey , "Control" } , "k" , function () ascreen.focus_relative(-1) end) , 

key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),

key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

key({ modkey } , "u"      , aclient.urgent.jumpto) , 
key({ modkey } , "Escape" , toggle_client)         , 

-- Standard programs
key({ modkey , "Control" } , "Return", function () util.spawn(vars.terminal_cmd) end) , 
key({ } , "XF86Tools" , function () util.spawn(vars.terminal_cmd) end) , 
key({ } , "Pause"     , function () util.spawn(vars.locker) end)       , 

key({ modkey, "Control" }, "r", awesome.restart),
key({ modkey, "Shift"   }, "q", awesome.quit),

key({ modkey, "Control", "Mod1" }, "space", toggle_opacity),

key({ modkey }, "F5", inc_vol( 1)),
key({ modkey }, "F4", inc_vol(-1)),
key({ modkey }, "F3", toggle_vol),

key({ }, "XF86AudioRaiseVolume", inc_vol( 15)),
key({ }, "XF86AudioLowerVolume", inc_vol(-15)),
key({ }, "XF86AudioMute", function () cmus_cmd("pause")() toggle_vol() end),

key({ }, "XF86AudioPrev", cmus_cmd("prev")),
key({ }, "XF86AudioNext", cmus_cmd("next")),
key({ }, "XF86AudioPlay", cmus_cmd("pause")),
key({ }, "XF86AudioStop", cmus_cmd("stop")),

-- Prompt
key({ modkey }, "grave", function () promptbox(mouse.screen):run() end),
key({ modkey }, "x", run_lua_code),

key({ modkey          } , "apostrophe" , find_tag_by_name(false)), 
key({ modkey, "Shift" } , "apostrophe" , find_tag_by_name(true)), 

key({ modkey          }, "slash", find_client_by_name(false)),
key({ modkey, "Shift" }, "slash", find_client_by_name(true))

)

for i = 1, 9 do
    global = util.table.join(global,
        key({ modkey                     }, "#" .. i + 9, switch_tag(i)),
        key({ modkey, "Control"          }, "#" .. i + 9, toggle_tag(i)),
        key({ modkey, "Shift"            }, "#" .. i + 9, move_client_to_tag(i)),
        key({ modkey, "Control", "Shift" }, "#" .. i + 9, toggle_client_tag(i)),
        key({ modkey, "Shift"            }, "F" .. i,     move_marked_to_tag(i)))
end

client = util.table.join(
    key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    key({ modkey, "Control" }, "space",  aclient.floating.toggle                     ),
    key({ modkey,           }, "Return", function (c) c:swap(aclient.getmaster()) end),
    key({ modkey,           }, "o",      aclient.movetoscreen                        ),
    key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    key({ modkey, "Mod1" }, "space", function (c) c.opacity = (c.opacity or 1.0) == 1.0 and 0.4 or 1.0 end),
    key({ modkey }, "minus", function (c) c.opacity = c.opacity - 0.1 end),
    key({ modkey }, "equal", function (c) c.opacity = c.opacity + 0.1 end)
)

buttons = util.table.join(
    button({ }, 3, function () menu.mainmenu:toggle() end),
    button({ }, 4, tag.viewnext),
    button({ }, 5, tag.viewprev)
)

