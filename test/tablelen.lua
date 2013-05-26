local t = setmetatable({len = 300, 1, 2, 3}, {__len = function(self) return self.len end})
assert(#t == t.len)
assert(rawlen(t) == 3)