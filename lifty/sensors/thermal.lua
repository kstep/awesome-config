local utils = require("lifty.utils")
local sensor_base = require("lifty.sensors.base")
local setmetatable = setmetatable

module("lifty.sensors.thermal")

local base_syspath = "/sys/class/thermal"

local function humanize_temp(self, value)
	return ("%0.1f°C"):format((value or self:get_value()) / 1000.0)
end

function temperature(num)
	local therm = sensor_base()
	therm.name = "thermal_zone" .. num
	therm.path = base_syspath .. "/" .. therm.name
	therm.fname = "temp"
	therm.max_value = utils.fread_num(therm.path .. "/trip_point_0_temp")

	therm.humanize = humanize_temp

	return therm
end

function cooler(num)
	local fan = sensor_base()
	fan.name = "cooling_device" .. num
	fan.path = base_syspath .. "/" .. fan.name
	fan.fname = "cur_state"
	fan.max_value = utils.fread_num(fan.path .. "/max_state")

	return fan
end
