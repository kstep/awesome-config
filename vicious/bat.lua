----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
----------------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local io = { open = io.open }
local setmetatable = setmetatable
local math = { floor = math.floor }
local helpers = require("vicious.helpers")
local string = {
    find = string.find,
    match = string.match,
    format = string.format
}
-- }}}


-- Bat: provides state, charge, and remaining time for a requested battery
module("vicious.bat")

local basedir = "/sys/class/power_supply/"
local max_capacity = {}

function meta(batid)
    local capacity = helpers.readfile(basedir .. batid .. "/charge_full", "*n")
    max_capacity[batid] = capacity
    return { max = capacity }
end

-- {{{ Battery widget type
local function worker(format, batid)
    local remaining = helpers.readfile(basedir .. batid .. "/charge_now", "*n")
    local status = helpers.readfile(basedir .. batid .. "/status", "*l")
    local current = helpers.readfile(basedir .. batid .. "/current_now", "*n")
    local timeleft = 86400
    if current > 0 then
        timeleft = (status == "Charging" and (max_capacity[batid] - remaining) or remaining) * 3600 / current
    end

    return { remaining, timeleft, status } --battery_state[status] }
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
