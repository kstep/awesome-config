local setmetatable = setmetatable
local ipairs = ipairs
local table = { insert = table.insert }

module("sensual.mixer")

assert(package.loadlib("mixer.so", "luaopen_mixer"))()

function worker(self)
   local volumes = {}
   for _, dev in ipairs(sensor.devices) do
       table.insert(volumes, dev[1])
       table.insert(volumes, dev.muted)
   end
   return volumes
end

local sensor
local function new(mixno, ...)
    if not sensor then
        sensor = {}
        sensor.meta = {}
        sensor.args = mixno
        sensor.mixer = mixer.open(mixno)
        sensor.devices = {}
        for _, name in ipairs(arg) do
            table.insert(sensor.devices, sensor.mixer[name])
        end
        setmetatable(sensor, { __call = worker })
    end
    return sensor
end

setmetatable(_M, { __call = function(_, ...) new(...) end })
