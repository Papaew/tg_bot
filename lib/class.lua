return function(baseclass)
	local class = {}
	local base = baseclass or {}
	-- copy base class contents into the new class
	for key, value in pairs(base) do
		class[key] = value
	end

	class.__index = class
	class.baseclass = base

	setmetatable(class, {
		__call = function(c, ...)
			local instance = setmetatable({}, c)
			local init = instance.init
			if init then init(instance, ...) end
			return instance
		end
	})

	return class
end
