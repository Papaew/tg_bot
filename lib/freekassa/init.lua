local https = require("https")
local json = require('json')
local sha256 = require("sha256")

local _M = {}

function _M:init(data)
	self.api_url = "https://api.fk.life/v1/"
	self.shopID = data.shopID
	self.token = data.token
end

function _M:request(method, args)
	args.shopId = self.shopID
	args.nonce = os.time()

	local keys = {}
	for k in pairs(args) do table.insert(keys, k) end
	table.sort(keys)

	local sorted_data = {}
	for _,k in ipairs(keys) do
		table.insert(sorted_data, args[k])
	end

	args.signature = sha256.hmac_sha256(self.token, table.concat(sorted_data, "|"))

	local request = table.concat({
		self._api_url,
		method, '?',
		urlencode(args)
	}, '')
	print(request)

	local code, body, headers = https.request(request, {
		method = 'POST',
		data = json.encode(args),
		headers = {
			['Content-Type'] = 'application/json'
		},
	})
	-- local b = json.decode(body)
	-- print(code)
	-- dump(b)

	-- return code, json.decode(body)
end

return _M
