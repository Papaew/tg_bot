function love.filesystem.appendRequirePath(paths)
	local p = { love.filesystem.getRequirePath() }
	if type(paths) == "table" then
		for i, path in pairs(paths) do
			table.insert(p, path .. "/?.lua;" .. path .. "/?/init.lua")
		end
	else
		table.insert(p, paths)
	end
	local path = table.concat(p, ";")
	love.filesystem.setRequirePath(path)
	-- package.path = path
end

love.filesystem.appendRequirePath {
	'lib',
	'core'
}

function love.conf(t)
	t.identity = nil
	t.appendidentity = false
	t.version = "12.0"
	t.console = true
	t.externalstorage = false

	t.modules.audio = nil
	t.modules.data = false
	t.modules.event = true
	t.modules.font = nil
	t.modules.graphics = nil
	t.modules.image = nil
	t.modules.joystick = nil
	t.modules.keyboard = nil
	t.modules.math = true
	t.modules.mouse = nil
	t.modules.physics = nil
	t.modules.sound = nil
	t.modules.system = true
	t.modules.thread = true
	t.modules.timer = true
	t.modules.touch = nil
	t.modules.video = nil
	t.modules.window = nil

	io.stdout:setvbuf("no")
end
