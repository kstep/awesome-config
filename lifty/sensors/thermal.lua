local utils = require("lifty.utils")
local setmetatable = setmetatable

module("lifty.sensors.thermal")

local base_syspath = "/sys/class/thermal"

local function get_temp_value(self)
	local temp
	temp = (utils.fread_num(self.path .. "/temp") or 0)
	return temp
end

local function get_temp_data(self)
	local data = {}
	data["max_value"] = self.max_value
	data["value"] = self:get_value()
	return data
end

function temperature(num)
	local therm = {}
	therm.name = "thermal_zone" .. num
	therm.path = base_syspath .. "/" .. therm.name
	therm.max_value = utils.fread_num(therm.path .. "/trip_point_0_temp")

	therm.get_value = get_temp_value
	therm.get_info = get_temp_data
	therm.humanize = function (self, value) return ("%0.1f°C"):format((value or self:get_value()) / 1000.0) end
	setmetatable(therm, { __call = get_temp_data })

	return therm
end

local function get_cooler_value(self)
	local state
	state = utils.fread_num(self.path .. "/cur_state")
	return state
end

local function get_cooler_data(self)
	local data = {}
	data["max_value"] = self.max_value
	data["value"] = self:get_value()
	return data
end

function cooler(num)
	local fan = {}
	fan.name = "cooling_device" .. num
	fan.path = base_syspath .. "/" .. fan.name
	fan.max_value = utils.fread_num(fan.path .. "/max_state")

	fan.get_value = get_cooler_value
	fan.get_info = get_cooler_data
	setmetatable(fan, { __call = get_cooler_data })

	return fan
end
