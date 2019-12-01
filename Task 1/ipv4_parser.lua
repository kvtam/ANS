
local src ={}
local dest ={}
local src_sorted = {}
local dest_sorted = {}

src["unique"]=0 --Make my tables metatables
dest["unique"]=0

--load a hashtable with the source IP's
local function sources(str)
	for i in string.gfind(str, " ([%w%-]*%.%w*%.%w*%.%w*)%.?%w* >" ) do --count source addresses
		--count= count+1
		--print (i)
		--table.insert(src,i)
		if src[i] == nil then
			src[i] = 1
			src["unique"]=src["unique"]+1
		else
			src[i] = src[i] +1
		end
	end
end
--load a hashtable with the destination IP's
local function destinations(str)
	for i in string.gfind(str, " ([%w%-]*%.%w*%.%w*%.%w*)%.?%w*:" ) do --count source addresses
		--count= count+1
		--print (i)
		--table.insert(dest,i)
		if dest[i] == nil then
			dest[i] = 1
			dest["unique"]=dest["unique"]+1
		else
			dest[i] = dest[i] +1
		end
	end
end
--Function takes the ouput file resulting from filtering for IPv4 packets
--and it counts each occurance if the string " IP " in each packet
local function countIP4(filename)
	local f = assert(io.open(filename,"r"))
	local t = f:read("*all")

	count = 0
	for i in string.gfind(t, " IP ") do
		count= count+1

	end
	sources(t)
	destinations(t)
	f:close()
	return count
end

--Very simple function to count the number of newline characters in a file
local function countnls(filename)
	local f = assert(io.open(filename,"r"))
	local t = f:read("*all")

	count = 0
	for i in string.gfind(t, "\n") do
		count= count+1
	end
	f:close()
	return count
end
--Function takes the ouput file resulting from filtering for IPv6 packets
--and it counts each occurance if the string "IP6" in each packet
local function countIP6(filename)
	local f = assert(io.open(filename,"r"))
	local t = f:read("*all")

	count = 0
	for i in string.gfind(t, " IP6 ") do
		count= count+1
	end
	f:close()
	return count
end
--for comparing the values of each pair for sorting source array
local function sortsrcbyval(a,b)
	return src[a] < src[b]
end
--for comparing the values of each pair for sorting
local function sortdestbyval(a,b)
	return dest[a] < dest[b]
end
-- function to reset the tables
local function tableclear()
	src,dest = {},{}
	src["unique"]=0
	dest["unique"]=0

end

local file_WARMUP = "output3.txt" --whole pcap as a .txt file

--split the file parsing sections
print ("number of newlines in warmup dump",countnls(file_WARMUP) ) --100,000
print ("\nNUmber of IPv6 packets in warmup" , countIP6(file_WARMUP)) --4171
print ("NUmber of IPv4 packets in warmup" , countIP4(file_WARMUP)) --95860
--The above add to 100,002 pretty close

print ("number of newlines in IPv4 warmup/tcp dump",countIP4("output9.txt") ) --73335
print ("number of newlines in IPv4 warmup/UDP dump",countIP4("IP4UDP.txt") ) -- 6344
print ("number of newlines in IPv6 warmup dump",countIP6("IPV6.txt") ) --4169
tableclear() --clear the table
countIP4(file_WARMUP)
print ("Number of unique IPv4 sources:",src["unique"]) --4989
print ("Number of unique IPv4 destinations:",dest["unique"]) --12692

--SOrt the arrays

print ("Top 10 source IPs:")
--sort and list the top 10 sender IPs

-- load the keys into a separate array
for ip, count in pairs(src) do
	src_sorted[#src_sorted+1]= ip
end
-- then sort the array by value and print the top 10
table.sort(src_sorted,sortsrcbyval)
for k=#src_sorted-11, #src_sorted do
	if src_sorted[k]~="unique" then
		print(src_sorted[k] .." -" .. src[src_sorted[k]])
	end
end

print ("\nTop 10 destination IPs:")
--sort and list the top 10 reciever IPs

-- load the keys into a separate array
for ip, count in pairs(dest) do
	dest_sorted[#dest_sorted+1]= ip
end
-- then sort the array by value and print the top 10
table.sort(dest_sorted,sortdestbyval)
for k=#dest_sorted-11, #dest_sorted do
	if dest_sorted[k]~="unique" then
		print(dest_sorted[k] .." -" .. dest[dest_sorted[k]])
	end
end

