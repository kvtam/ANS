local dnsarray={}
dnsarray["size"]= 0
local sorted_dns = {}
--function to read the file input and returns a string
local function readinput(filename)
	local f = assert(io.open(filename,"r"))
	local t = f:read("*all")
	f:close()
	return t
end

--extract DNS names from string T
--precondtion: file has ben opened and all input is in T
--Postcondition: return a set of DNS names and their frequency
local function extractdnsnames(T)
	for i in string.gfind(T, "(%S*.%a%a%a?)\n") do
		if dnsarray[i] == nil then
			dnsarray[i] = 1
			dnsarray["size"]=dnsarray["size"]+1
		else
			dnsarray[i] = dnsarray[i] +1
		end
	end
end
-- comparison function to sort array by frequency of DNS names
local function sortdnsbyval(a,b)
	return dnsarray[a] < dnsarray[b]
end

--worker function to sort by frequency
local function dns_sort(unsorted)
	for name, count in pairs(unsorted) do
		sorted_dns[#sorted_dns+1]= name
	end
	table.sort(sorted_dns,sortdnsbyval)
	for k=#sorted_dns-11, #sorted_dns do
		if sorted_dns[k]~="size" then
			print(sorted_dns[k] .." -" .. dnsarray[sorted_dns[k]])
		end
	end
end

local filename = "dnsnames.txt" --Loaded all the DNS names into a file using Tshark
local fileinput= readinput(filename)-- read the input
--todo sort by frequency
 ---first put into an array
 ---print(fileinput)
 extractdnsnames(fileinput)
 print ( "mycompany.com appears: ",dnsarray["mycompany.com"],"Times")
 --todo sort
 dns_sort(dnsarray)


