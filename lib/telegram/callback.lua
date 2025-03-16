local class = require('class')

local Callback = class()

function Callback:init(f)
	self._body = f
end

function Callback:exec(...)
	self._body(...)
end

return Callback