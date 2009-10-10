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

local max_temp = {}
local basedir = "/sys/class/thermal/thermal_zone"

-- {{{ Thermal widget type
local function worker(format, thermal_zone)
    -- Get thermal zone
    local line = helpers.readfile(basedir .. thermal_zone .. "/temp", "*n")
    local temperature = line / 1000

    if max_temp[thermal_zone] == nil then
        local line = helpers.readfile(basedir .. thermal_zone .. "/trip_point_0_temp", "*n") or 100000
        max_temp[thermal_zone] = line / 1000
    end

    return {temperature, max_temp[thermal_zone]}
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
