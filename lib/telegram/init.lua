local https = require('https')
local json = require('json')

local function errorHandler(x)
	return "Error: " .. debug.traceback(x, 2)
end

local _M = {}

function _M:init(data)
	self.api_url = string.format("https://api.telegram.org/bot%s/", data.token)
	self.update_query = json.encode(data.update_query)
	self.update_id = data.update_id
	self.timeout = data.update_timeout
	self.limit = data.update_limit
	self.bot = data.bot
end

function _M:request(method, args)
	local request = table.concat({
		self.api_url,
		method, '?',
		urlencode(args)
	}, '')
	-- print(request)

	local code, body = https.request(request, {
		method = 'GET'
	})
	return code, json.decode(body)
end

function _M:poll_events()
	self.update_id = self.update_id and self.update_id+1 or nil
	local code, body = self:request('getUpdates', {
		allowed_updates = self.update_query,
		offset = self.update_id,
		timeout = self.timeout,
		limit = self.limit,
	})

	if body.ok then
		for _,result in ipairs(body.result) do
			local success, errmsg
			if result.message then -- @todo replace with map
				success, errmsg = xpcall(self.bot.process_message, errorHandler, self.bot, result.message)
			elseif result.callback_query then
				success, errmsg = xpcall(self.bot.process_callback, errorHandler, self.bot, result.callback_query)
			elseif result.inline_query then
				success, errmsg = xpcall(self.bot.process_inline, errorHandler, self.bot, result.inline_query)
			end
			if not success then
				logf("Error poll events: %s", errmsg)
			end
		end

		if code == 200 and #body.result > 0 then
			self.update_id = body.result[#body.result].update_id
		end

		return
	end

	logf("Error %d: poll events %s", code, body.description)
end

return _M
