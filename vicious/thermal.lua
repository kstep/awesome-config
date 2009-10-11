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

function meta(thermal_zone)
    local crit_temp = helpers.readfile(basedir .. thermal_zone .. "/trip_point_0_temp", "*n") or 100000
    return { max = crit_temp / 1000 }
end

-- {{{ Thermal widget type
local function worker(format, thermal_zone)
    -- Get thermal zone
    local line = helpers.readfile(basedir .. thermal_zone .. "/temp", "*n")
    local temperature = line / 1000

    return temperature
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
