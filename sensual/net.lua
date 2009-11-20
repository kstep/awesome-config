----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
--  * Derived from Wicked, copyright of Lucas de Vries
----------------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local setmetatable = setmetatable
local table = { insert = table.insert }
local helpers = require("sensual.helpers")
-- }}}

-- Net: provides usage statistics for all network interfaces
module("sensual.net")

local basedir = "/sys/class/net/"

-- {{{ Net widget type
function worker(self)
    -- Get /proc/net/dev
    local statdir = basedir .. self.args .. "/"

    local data = {
        helpers.readfile(statdir .. "operstate", "*l"),
        tonumber(helpers.readfile(statdir .. "carrier", "*n") or 0) == 1,
        tonumber(helpers.readfile(statdir .. "statistics/rx_bytes", "*n") or 0),
        tonumber(helpers.readfile(statdir .. "statistics/tx_bytes", "*n") or 0),
    }

    -- returns: state (up|down), carrier (bool), total rx & tx bytes, delta rx & tx bytes (since last call)
    return data
end
-- }}}

local function new(iface)
    local sensor = {}
    sensor.args = iface
    sensor.meta = {}
    setmetatable(sensor, { __call = worker })
    return sensor
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
