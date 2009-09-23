local utils = require("lifty.utils")
local sensor_base = require("lifty.sensors.base")
local setmetatable = setmetatable

module("lifty.sensors.battery")

local base_syspath = "/sys/class/power_supply"

local function get_state(self)
	return utils.fread_num(self.path .. "/status", "*l")
end

local function humanize_charge(self, value)
	return (value or self:get_value()) * 100 / self.max_value
end

function new(self, num)
	local battery = sensor_base()
	battery.name = "BAT" .. num
	battery.path = base_syspath .. "/" .. battery.name
	battery.fname = "charge_now"
	battery.max_value = utils.fread_num(battery.path .. "/charge_full")

	battery.get_state = get_state
	battery.humanize = humanize_charge

	return battery
end

setmetatable(_M, { __call = new })
