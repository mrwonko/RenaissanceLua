local curried function hello()
	print("Hello")
end
hello()

local curried function simplePrint(str)
	print(str)
end
simplePrint("World!")

local curried function sum(x, y)
	return x + y
end
local add5 = sum(5)
print(add5(10))

local curried function print2(...)
	print(...)
end
print2(1, 2, "hey")

local curried function print3(x, ...)
	print(x, ...)
end
print3(3)(4, "ho")