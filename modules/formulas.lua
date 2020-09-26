formulas = {}

function formulas.yDouble( dataSets )
	local returnSets = {}
	for i=1, #dataSets do
		local set = {}
		
		set[1] = dataSets[i][1]
		set[2] = dataSets[i][2] *-2+5
		set[3] = dataSets[i][3]
		
		returnSets[i] = set
	end
	
	return returnSets
end

return formulas