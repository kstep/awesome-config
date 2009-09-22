local utils = require("lifty.utils")
local setmetatable = setmetatable

module("lifty.sensors.base")

function get_value(self)
	return utils.fread_num(self.path .. "/" .. self.fname) or 0
end

function get_state(self)
	return nil
end

function get_data(self)
	return self:get_value(), self:get_state()
end

function get_info(self)
	return {
		min_value = self.min_value or 0,
		max_value = self.max_value or 100,
	}
end

function humanize(self, value)
	return value or self:get_value()
end

function new_sensor()
	local sensor = {}
	sensor.get_data = get_data
	sensor.get_state = get_state
	sensor.get_value = get_value
	sensor.get_info = get_info
	sensor.humanize = humanize
	return sensor
end

setmetatable(_M, { __call = new_sensor })
