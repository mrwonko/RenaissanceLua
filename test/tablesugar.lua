local t =
{
	-- anonymous function
	function(x, y)
		return x + y
	end,
	
	-- anonymous curried function
	curried function(x, y)
		return x + y
	end,
	
	-- member function
	function f(x)
		return self, x
	end,
	
	-- curried member function
	curried function c(x)
		return self, x
	end
}

assert(t[1](1, 2) == 1 + 2)
assert(t[2](1)(2) == 1 + 2)
local x, y = t:f(1)
assert(x == t and y == 1)
local x, y = t:c()(1)
assert(x == t and y == 1)