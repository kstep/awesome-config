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
    local statdir = basedir .. self.args .. "/statistics/"

    local data = {
        helpers.readfile(statdir .. "../operstate", "*l"),
        tonumber(helpers.readfile(statdir .. "../carrier", "*n")) == 1,
        tonumber(helpers.readfile(statdir .. "rx_bytes", "*n")),
        tonumber(helpers.readfile(statdir .. "tx_bytes", "*n")),
    }

    local d_rx = data[3] - self.cache[1]; self.cache[1] = data[3]
    local d_tx = data[4] - self.cache[2]; self.cache[2] = data[4]
    table.insert(data, d_rx)
    table.insert(data, d_tx)

    -- returns: state (up|down), carrier (bool), total rx & tx bytes, delta rx & tx bytes (since last call)
    return data
end
-- }}}

local function new(iface)
    local sensor = {}
    sensor.args = iface
    sensor.cache = { 0, 0 }
    setmetatable(sensor, { __call = worker })
    return sensor
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
