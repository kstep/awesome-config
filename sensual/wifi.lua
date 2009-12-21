----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
----------------------------------------------------------

-- {{{ Grab environment
local io = { open = io.open }
local setmetatable = setmetatable
local string = {
    find = string.find,
    match = string.match
}
-- }}}


-- Wifi: provides wireless information for a requested interface
module("sensual.wifi")

local function worker(self)
    -- Get data from iwconfig (where available)
    local f = io.open("/proc/net/wireless")
    local data = {}

    if f then
        for line in f:lines() do
            if line:find(self.iface) then
                local iface, state, link, level, noise, nwid, crypt, frag, retry, misc, beacon =
                    line:match("^%s+([a-z0-9]+):%s+([0-9]+)%s+([0-9.]+)%s+(-[0-9]+)%s+(-[0-9]+)%s+([0-9]+)%s+([0-9]+)%s+([0-9]+)%s+([0-9]+)%s+([0-9]+)%s+([0-9]+)")
                data["state"] = state
                data["link"]  = link
                data["level"] = level
                data["noise"] = noise
                break
            end
        end
        f:close()
    end

    return data
end

local sensors = {}
function new(iface)
    if not sensors[iface] then
        sensor = { iface = iface, meta = {} }
        setmetatable(sensor, { __call = worker })
        sensors[iface] = sensor
    end
    return sensors[iface]
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

