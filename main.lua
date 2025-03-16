require('common')

local tg = require('telegram')
local fk = require('freekassa')
local nfs = require('nativefs')
local json = require('json')

local root = nfs.getWorkingDirectory()

function love.load()
	do
		local success, result = json.read(root..'/data/telegram.json')
		if not success then error(result) end

		local Bot = require('data.bot')
		result.bot = Bot()

		tg:init(result)
	end
	do
		local success, result = json.read(root..'/data/freekassa.json')
		if not success then error(result) end
		fk:init(result)
	end

	-- local code, body = tg:request('getMe')
	-- print(code)
	-- dump(body)

	-- fk:request('currencies', {})
end

function love.update(dt)
	tg:poll_events()
end

function love.exit(code, body)
	if code then
		logf("Error: %d - %s", code, body.description)
	end
	love.event.quit()
end
