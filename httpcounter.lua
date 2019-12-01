local filename = "head.txt"
local user_agent = {}
user_agent["size"] =0
local sorted = {}
local function readinput(filename)
	local f = assert(io.open(filename,"r"))
	local t = f:read("*all")
	f:close()
	return t
end
-- get all lines from a file, returns an empty
-- list/table if the file does not exist
local function getuseragents(filename)
  for i in io.lines(filename) do
	if user_agent[i] == nil then
			user_agent[i] = 1
			print (i)
			user_agent["size"]=user_agent["size"]+1
		else
			user_agent[i] = user_agent[i] +1
		end
	end
end

local function sorthttpbyval(a,b)
	return user_agent[a] < user_agent[b]
end
--worker function to sort by frequency
local function http_sort(unsorted)
	for name, count in pairs(unsorted) do
		sorted[#sorted+1]= name
	end
	table.sort(sorted,sorthttpbyval)
	for k=#sorted, #sorted do
		if sorted[k]~="size" then
			print(sorted[k] .." -" .. user_agent[sorted[k]])
		end
	end
end

local input =readinput(filename)
getuseragents(filename)
print("\nmost frequent: ")
http_sort(user_agent)
