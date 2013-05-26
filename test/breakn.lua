local i, j
for i2 = 1, 5 do
	j = 1
	while j <= 5 do
		i = i2
		if i == 3 and j == 3 then
			break 2
		end
		j = j + 1
	end
end
assert(i == 3 and j == 3)