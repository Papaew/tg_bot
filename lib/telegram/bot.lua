local class = require('class')
local tg = require('telegram')

local context = require('telegram.context')

local Callback = require('telegram.callback')

local Bot = class()

function Bot:init()
	self._commands = {}
end

function Bot:sendMessage(ctx, data)
	tg:request('sendMessage', {
		chat_id = ctx.chat_id,
		text = data.text,
	})
end

function Bot:register_command(name, body)
	if self._commands[name] then error("Command "..name.."already registered!", 2) end
	self._commands[name] = Callback(body)
end

function Bot:process_message(message)
	if self._commands[message.text] then
		local ctx = context:get(message.chat.id, message.chat.username)
		self._commands[message.text]:exec(ctx, message)
		return
	end
end

function Bot:process_callback(message)
end

function Bot:process_inline(message)
end

return Bot
