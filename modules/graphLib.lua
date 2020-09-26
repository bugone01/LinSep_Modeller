local widget = require( "widget" )
graphLib = {}

function graphLib.newGraph( graphPoints, alpha, xMin, xMax, yMin, yMax )
	-----------------------------------------------------------------------------------
	-- Returns a graphGroup with X and Y axis and the 'graphPoints' plotted. 
	-- Scale should be a number between 
	-----------------------------------------------------------------------------------
	local graphGroup = display.newGroup()
	
	-- initialise the viewable area
	local xMin = xMin or -10
	local xMax = xMax or 10
	local yMin = yMin or -10
	local yMax = yMax or 10
	
	-- limits for the axis (also sets scrollable area)
	local xAxisMin, xAxisMax, yAxisMin, yAxisMax = graphLib.getScale( graphPoints )
	
	--Set the axis lengths to either the data points or set scale - which ever is furthest from zero
	print( "xMin here", xMin)
	
	if xMin < xAxisMin then
		xAxisMin = xMin
	end
	if xMax > xAxisMax then
		xAxisMax = xMax
	end
	if yMin < yAxisMin then
		yAxisMin = yMin
	end
	if yMax > yAxisMax then
		yAxisMax = yMax
	end
		
	-- Can I make this work?
	--[[
	xAxisMin = (xAxisMin < xMin) or xAxisMin and xMin
	xAxisMax = (xAxisMax > xMax) and xAxisMax or xMax
	yAxisMin = (yAxisMin < yMin) or yAxisMin and yMin
	yAxisMax = (yAxisMax > yMax) and yAxisMax or yMax
	--]]
	
	local alpha = alpha or 1
	
	-- calculate some constants for reference
	------------------------------------------------------------------------------------------------
	-- calculate how many increments are between min and max (including 1 increment for zero position). 
	local xTotalIncrements = 0-xMin+xMax +1
	local yTotalIncrements = 0-yMin+yMax +1
		
	-- Define the graph border
	local xBorderWidth = display.contentWidth /23 *1
	local yTopBorder = display.contentHeight /28 *1
	local yBottomBorder = display.contentHeight /28 *21 -- Remember: co-ordinates work from top to bottom
	
	-- Divide the viewable area into increments
	local xInc = (display.contentWidth - xBorderWidth*2) /xTotalIncrements 
	local yInc = (yBottomBorder - yTopBorder) / yTotalIncrements
	
	local xZero = (xTotalIncrements - xMax)*xInc
	local yZero = yBottomBorder - (yTotalIncrements - 0.5 - yMax)*yInc
	------------------------------------------------------------------------------------------------
	-- create the axis for the graph
	axisColor = { .44,.82,.94, alpha } --Cyan	
	
	--local xScreenMin = xZero - xAxisMin * xInc
	local xScreenMin = xZero + xAxisMin * xInc
	local xScreenMax = xZero + xAxisMax * xInc
	local yScreenMin = yZero - yAxisMin * yInc
	local yScreenMax = yZero - yAxisMax * yInc
	
	
	local xAxis = display.newLine( graphGroup, xScreenMin, yZero, xScreenMax, yZero) 
	xAxis:setStrokeColor( unpack( axisColor ) )
	xAxis.strokeWidth = 2
	local yAxis = display.newLine( graphGroup, xZero, yScreenMin, xZero, yScreenMax )
	yAxis:setStrokeColor( unpack( axisColor ) )
	yAxis.strokeWidth = 2
	--]]
	-- add increment marks to axis
	local halfLength = 4
	local incPos
	local marker
	-- X-axis
	for i=xAxisMin, xAxisMax do
		incPos = xZero + i * xInc
		marker = display.newLine( graphGroup, incPos, yZero-halfLength, incPos, yZero+halfLength )
		marker:setStrokeColor( unpack( axisColor ) )
	end	
	-- Y-axis
	for i=yAxisMin, yAxisMax do
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
			local dot = display.newCircle( graphGroup, x, y, radius )
			if point[3] == 'M' then
				dot:setFillColor( 0, 0.3, 0.9, alpha ) -- blue
			elseif point[3] == 'B' then
				dot:setFillColor( 255, 0, 0, alpha ) -- red
			else
				dot:setFillColor( 0.3, .8, 0, alpha ) -- green
			end
	end

	return graphGroup
end

-----------------------------------------
-- return a graph group inside a scrollable view widget.
-----------------------------------------
function graphLib.newScrollGraph( graphPoints, alpha, xMin, xMax, yMin, yMax ) -- add option to supply an ID?

	local graph = graphLib.newGraph( graphPoints, alpha, xMin, xMax, yMin, yMax )
	
	
	-- calculate some constants for reference
	------------------------------------------------------------------------------------------------
	-- calculate how many increments are between min and max (including 1 increment for zero position). 
	local xTotalIncrements = 0-xMin+xMax +1
	local yTotalIncrements = 0-yMin+yMax +1
		
	-- Define the graph border
	local xBorderWidth = display.contentWidth /23 *1
	local yTopBorder = display.contentHeight /28 *1
	local yBottomBorder = display.contentHeight /28 *21 -- Remember: co-ordinates work from top to bottom
	
	-- Divide the viewable area into increments
	local xInc = (display.contentWidth - xBorderWidth*2) /xTotalIncrements 
	local yInc = (yBottomBorder - yTopBorder) / yTotalIncrements
	
	local xZero = (xTotalIncrements - 0.5 - xMax)*xInc + xBorderWidth
	local yZero = yBottomBorder - (yTotalIncrements - 0.5 - yMax)*yInc
	------------------------------------------------------------------------------------------------
	
	local graphId = "scrollableGraph"

	local scrollView = widget.newScrollView(
		{
			id = graphId,
			top = yTopBorder,
			left = xBorderWidth,
			width = display.contentWidth - xBorderWidth*2,
			height = yBottomBorder,
			scrollWidth = 1000, --xMax * xInc *1.2,
			scrollHeight = 1000, --yMax * yInc *1.2,
			backgroundColor = { 0,0,0,.3 }
			--listener = scrollListener
		}
	)
	scrollView:insert( graph )
	
	return scrollView, graphId

end

function graphLib.getScale( ... )

	local factor = 1.2 -- don't plot points right on edge of graph
	local xMin = 0
	local xMax = 0
	local yMin = 0
	local yMax = 0
	local x = 1
	local y = 2
	
	for i=1, #arg do
		for _, set in ipairs(arg[i]) do
			if set[x] < xMin then
				xMin = set[x]
			elseif set[x] > xMax then
				xMax = set[x]
			end
			
			if set[y] < yMin then
				yMin = set[y]
			elseif set[y] > yMax then
				yMax = set[y]
			end
		end
	end
	
	return xMin*factor, xMax*factor, yMin*factor, yMax*factor
		
end


return graphLib