local function f()
	for msg in coroutine.yield do
		print(msg)
	end
end

local c = coroutine.create(f)
coroutine.resume(c)
coroutine.resume(c, "Hello")
coroutine.resume(c, "World")
coroutine.resume(c)
assert(coroutine.status(c) == "dead")