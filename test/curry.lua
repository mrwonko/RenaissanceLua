--    local functions

-- useless currying
local curried function hello()
	return "Hello"
end
assert(hello() == "Hello")

-- useless currying
local curried function id(str)
	return str
end
assert(id("World!") == "World!")

-- normal currying
local curried function sum(x, y)
	return x + y
end
local add5 = sum(5)
assert(add5(10) == 15)

-- useless currying with vararg
local curried function concat(...)
	return table.concat{...}
end
assert(concat(1, 2, "hey") == "12hey")

-- currying with vararg
local curried function concat2(x, ...)
	return table.concat{x, ...}
end
assert(concat2(3)(4, "ho") == "34ho")

--    global functions

-- useless currying
curried function g_hello()
	return "Hello"
end
assert(g_hello() == "Hello")

-- useless currying
curried function g_id(str)
	return str
end
assert(g_id("World!") == "World!")

-- normal currying
curried function g_sum(x, y)
	return x + y
end
local add5 = g_sum(5)
assert(add5(10) == 15)

-- useless currying with vararg
curried function g_concat(...)
	return table.concat{...}
end
assert(g_concat(1, 2, "hey") == "12hey")

-- currying with vararg
curried function g_concat2(x, ...)
	return table.concat{x, ...}
end
assert(g_concat2(3)(4, "ho") == "34ho")