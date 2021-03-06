local function hex (i)
	return string.format("0x%X", i)
end
print("~0 = " .. hex(~0))

assert(0x54 | 0x55 == 0x55)
assert(0x54 & 0x55 == 0x54)
assert(0x54 & 0x66 == 0x44)
assert(0x03 << 4 == 0x30)
assert(0x30 >> 4 == 0x03)