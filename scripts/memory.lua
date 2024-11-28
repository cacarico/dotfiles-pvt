local ffi = require("ffi")

-- Define the C struct sysinfo and the sysinfo function
ffi.cdef([[
    struct sysinfo {
        long uptime;             /* Seconds since boot */
        unsigned long loads[3];  /* 1, 5, and 15 minute load averages */
        unsigned long totalram;  /* Total usable main memory size */
        unsigned long freeram;   /* Available memory size */
        unsigned long sharedram; /* Amount of shared memory */
        unsigned long bufferram; /* Memory used by buffers */
        unsigned long totalswap; /* Total swap space size */
        unsigned long freeswap;  /* Swap space still available */
        unsigned short procs;    /* Number of current processes */
        unsigned short pad;      /* Padding for alignment */
        unsigned long totalhigh; /* Total high memory size */
        unsigned long freehigh;  /* Available high memory size */
        unsigned int mem_unit;   /* Memory unit size in bytes */
    };

    int sysinfo(struct sysinfo *info);
]])

-- Create a sysinfo structure
local info = ffi.new("struct sysinfo")

-- Call the sysinfo function
ffi.C.sysinfo(info)

-- Calculate total memory
local total_ram = tonumber(info.totalram) * tonumber(info.mem_unit)

-- Read cached memory from /proc/meminfo
local function get_cached_memory()
	local meminfo = io.open("/proc/meminfo", "r")
	local cached = 0
  for line in meminfo:lines() do
    if line == nil then
      if line:match("^Cached:") then
        cached = tonumber(line:match("(%d+)"))
        break
      end
    end
  end
	meminfo:close()
	return cached * 1024 -- Convert from KB to bytes
end

local cached_ram = get_cached_memory()

-- Calculate the free memory (free + buffers + cached)
local free_ram = (tonumber(info.freeram) + tonumber(info.bufferram) + cached_ram)

-- Calculate the percentage of used memory
local ram_usage = ((total_ram - free_ram) / total_ram) * 100

-- Print the result
print(string.format("Memory Usage: %.2f%%", ram_usage))
