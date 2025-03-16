require('love.math')
dump = require('inspect')
local url = require("socket.url")
local t_concat = table.concat

local prng = love.math.newRandomGenerator(os.time())
local charset = {
	"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
	"0","1","2","3","4","5","6","7","8","9"
}

string.random = function(len)
	local str = {}
	for i=1, len do
		local c = prng:random(1, 62)
		str[i] = charset[c]
	end
	return t_concat(str, '')
end

urlencode = function(args)
	if not args or not next(args) then return '' end

	local result = {}
	for k, v in pairs(args) do
		result[#result + 1] = url.escape(tostring(k)).."="..url.escape(tostring(v))
	end
	return t_concat(result, "&")
end

logf = function(pattern, ...)
	local txt = string.format(pattern, ...)
	print(txt)
end