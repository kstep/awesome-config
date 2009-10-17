----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
----------------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local io = { open = io.open }
local setmetatable = setmetatable
local math = { floor = math.floor }
local helpers = require("sensual.helpers")
local string = {
    find = string.find,
    match = string.match,
    format = string.format
}
-- }}}

-- Bat: provides state, charge, and remaining time for a requested battery
module("sensual.bat")

local basedir = "/sys/class/power_supply/"
local max_capacity = {}

-- {{{ Battery widget type
function worker(self)
    local remaining = helpers.readfile(basedir .. self.args .. "/charge_now", "*n")
    local status = helpers.readfile(basedir .. self.args .. "/status", "*l")
    local current = helpers.readfile(basedir .. self.args .. "/current_now", "*n")
    local timeleft = 86400
    if current > 0 then
        timeleft = (status == "Charging" and (self.meta.max - remaining) or remaining) * 3600 / current
    end

    return { remaining, timeleft, status } --battery_state[status] }
end
-- }}}

local function new(batid)
    local sensor = {}
    local capacity = helpers.readfile(basedir .. batid .. "/charge_full", "*n")
    sensor.args = batid
    sensor.meta = { max = capacity }
    setmetatable(sensor, { __call = worker })
    return sensor
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
