local root   = root
local screen = screen
local ipairs = ipairs
local table = { insert = table.insert }

local awful = require("awful")

module("rc.util")

function sendkey(...)
    local keys = {}
    for _, keycode in ipairs(arg) do
        root.fake_input("key_press", keycode)
        table.insert(keys, 1, keycode)
    end
    for _, keycode in ipairs(keys) do
        root.fake_input("key_release", keycode)
    end
end

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

	local clients = {}
        for i = 1, screen.count() do clients = awful.util.table.join(clients, client.get(i)) end
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

