local context = {}
context.chats = {}

function context:get(chat_id, username)
	if not self.chats[chat_id] then
		self.chats[chat_id] = {
			username = username,
			chat_id = chat_id
		}
	end
	return self.chats[chat_id]
end

return context
