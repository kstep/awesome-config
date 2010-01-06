local setmetatable = setmetatable
local ipairs = ipairs
local table = { insert = table.insert }
local statfs = assert(package.loadlib("/home/kstep/.config/awesome/sensual/statfs.so", "luaopen_statfs"))()

module("sensual.statfs")

function worker(self)
    local stats = statfs.getstat(self.args)
    stats.total = stats.blocks * stats.bsize
    stats.avail = stats.bavail * stats.bsize
    stats.occup = stats.total - stats.avail
    stats.boccup = stats.blocks - stats.bavail
    return stats
end

local sensors = {}
local function new(root)
    if not sensors[root] then
        local sensor = { args = root }
        local stats = statfs.getstat(root)
        sensor.meta = { min = 0, max = stats['blocks'] }
        setmetatable(sensor, { __call = worker })
        sensors[root] = sensor
    end
    return sensors[root]
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })
