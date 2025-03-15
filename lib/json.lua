local rxi_json = require('rxi-json')
local nativefs = require('nativefs')

local json = {}
json.encode = rxi_json.encode
json.decode = rxi_json.decode

love.filesystem.exists = function(filename)
	local info = nativefs.getInfo(filename, 'file')
	return type(info) == 'table'
end

love.filesystem.openFile = function(filename, mode)
	local file = nativefs.newFile(filename)
	file:open(mode)
	return file
end

function json.read(filename)
	if not love.filesystem.exists(filename) then
		return false, 'Error: Json read error! File '..filename..' does not exist.'
	end

	local file, errorstr = love.filesystem.openFile(filename, 'r')
	if errorstr then
		print(errorstr)
		return false
	end
	local content = file:read()
	file:close()
	local success, result = pcall(rxi_json.decode, content)
	return success, result
end

function json.write(filename, data)
	if not love.filesystem.exists(filename) then
		nativefs.write(filename, '')
	end

	local file, errorstr = love.filesystem.openFile(filename, 'w')
	if errorstr then error(errorstr) end

	local success, result = pcall(rxi_json.encode, data)
	if success then
		success = file:write(result)
	end
	file:close()
	return success, result
end

return json
