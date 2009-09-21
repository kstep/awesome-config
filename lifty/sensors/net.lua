local setmetatable = setmetatable
local utils = require("lifty.utils")

module("lifty.sensors.net")

local base_syspath = "/sys/class/net"

local function get_iface_value(self)
	local value = {}
	value["tx"] = utils.fread_num(self.path .. "/statistics/tx_packets")
	value["rx"] = utils.fread_num(self.path .. "/statistics/rx_packets")
	if self.wireless then
		value["lv"] = utils.fread_num(self.path .. "/wireless/link")
	end
	return value
end

local function get_iface_state(self)
	local isup = utils.fread_num(self.path .. "/operstate", "*l") == "up"
	local iscarrier = isup and (utils.fread_num(self.path .. "/carrier") == 1)
	return iscarrier and "carrier" or (isup and "up" or "down")
end

local function get_iface_data(self)
	local data = {}
	data["value"] = self:get_value()
	data["state"] = self:get_state()
end

function interface(name, wireless)
	local iface = {}

	iface.name = name
	iface.path = base_syspath .. "/" .. name
	iface.wireless = not not wireless

	iface.get_value = get_iface_value
	iface.get_state = get_iface_state
	iface.get_data = get_iface_data

	setmetatable(iface, { __call = get_iface_data })
	return iface
end

