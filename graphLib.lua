graphLib = {}


function graphLib.newGraph( graphPoints, alpha, xMin, xMax, yMin, yMax )
	-----------------------------------------------------------------------------------
	-- Returns a graphGroup with X and Y axis and the 'graphPoints' plotted. 
	-- Scale should be a number between 
	-----------------------------------------------------------------------------------
	local graphGroup = display.newGroup()
	
	-- set default scale
	local xMin = xMin or -10
	local xMax = xMax or 10
	local yMin = yMin or -10
	local yMax = yMax or 10
	
	local alpha = alpha or 1
	
	-- calculate some constants
	------------------------------------------------------------------------------------------------
	-- calculate how many increments are between min and max (including 1 increment for zero position). 
	xTotalIncrements = 0-xMin+xMax +1
	yTotalIncrements = 0-yMin+yMax +1
		
	-- Define the graph border
	local xBorderWidth = display.contentWidth /23 *1
	local yTopBorder = display.contentHeight /28 *1
	local yBottomBorder = display.contentHeight /28 *22 -- Remember: co-ordinates work from top to bottom
	
	-- Divide the viewable area into increments
	local xInc = (display.contentWidth - xBorderWidth*2) /xTotalIncrements 
	local yInc = (yBottomBorder - yTopBorder) / yTotalIncrements
	
	local xZero = (xTotalIncrements - 0.5 - xMax)*xInc + xBorderWidth -- These points may be off screen
	local yZero = yBottomBorder - (yTotalIncrements - 0.5 - yMax)*yInc-- These points may be off screen
	------------------------------------------------------------------------------------------------

	-- create the axis for the graph
	axisColor = { .44,.82,.94 } --Cyan
	
	local xAxis = display.newLine( graphGroup, xBorderWidth, yZero, display.contentWidth - xBorderWidth, yZero) 
	xAxis:setStrokeColor( unpack( axisColor ) ) -- this is wrong !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	xAxis.strokeWidth = 2
	local yAxis = display.newLine( graphGroup, xZero, yTopBorder, xZero, yBottomBorder)
	yAxis:setStrokeColor( unpack( axisColor ) ) 
	yAxis.strokeWidth = 2
	
	-- add increment marks to axis
	local halfLength = 4
	local incPos
	local marker
	-- X-axis
	for i=xMin, xMax do
		incPos = xZero + i * xInc
		marker = display.newLine( graphGroup, incPos, yZero-halfLength, incPos, yZero+halfLength )
		marker:setStrokeColor( unpack( axisColor ) )
	end	
	-- Y-axis
	for i=yMin, yMax do
		incPos =  yZero - (i * yInc) -- '-i' because co-ordinates go from top to bottom
		marker = display.newLine( graphGroup, xZero-halfLength, incPos, xZero+halfLength, incPos )
		marker:setStrokeColor( unpack( axisColor ) )
	end
	
	-- Plot the points on the graph
	local radius = 3
	local x
	local y
	for _, point in ipairs( graphPoints ) do
		x = point[1] * xInc + xZero
		y = -point[2] * yInc + yZero -- inverse the Y-axis as Corona co-ordinates work from top to bottom.
		-- only plot points which are within the graph borders
		if x > xBorderWidth and x < display.contentWidth - xBorderWidth and y > yTopBorder and y < yBottomBorder then
			local dot = display.newCircle( graphGroup, x, y, radius )
			
			if point[3] == 'M' then
				dot:setFillColor( 0, 0.3, 0.9, alpha ) -- blue
			elseif point[3] == 'B' then
				dot:setFillColor( 255, 0, 0, alpha ) -- red
			else
				dot:setFillColor( 0.3, .8, 0, alpha ) -- green
			end
		end
	end
	
	return graphGroup;
end

return graphLib