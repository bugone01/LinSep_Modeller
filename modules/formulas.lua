formulas = {}

function formulas.yDouble( dataSets )

	for i=1, #dataSets do
		for x=2, 2 do
			--print( "Before value", dataSets[i][x])
			dataSets[i][x] = dataSets[i][x] *2
			--print( "After value", dataSets[i][x])
		end
	end
	
	return dataSets
end

return formulas