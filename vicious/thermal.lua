----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
----------------------------------------------------------

-- {{{ Grab environment
local io = { open = io.open }
local setmetatable = setmetatable
local helpers = require("vicious.helpers")
-- }}}


-- Thermal: provides temperature levels of ACPI thermal zones
module("vicious.thermal")

local basedir = "/sys/class/thermal/thermal_zone"

-- {{{ Thermal widget type
function worker(self)
    -- Get thermal zone
    local line = helpers.readfile(basedir .. self.args .. "/temp", "*n")
    local temperature = line / 1000

    return { temperature }
end
-- }}}

local function new(thermal_zone)
    local sensor = {}
    local crit_temp = helpers.readfile(basedir .. thermal_zone .. "/trip_point_0_temp", "*n") or 100000
    sensor.meta = { max = crit_temp / 1000 }
    sensor.args = thermal_zone
    setmetatable(sensor, { __call = worker })
    return sensor
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
