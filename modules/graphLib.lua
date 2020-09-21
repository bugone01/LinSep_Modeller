graphLib = {}


function graphLib.newGraph( graphPoints, xScale, yScale )
	-----------------------------------------------------------------------------------
	-- Returns a graphGroup with X and Y axis and the 'graphPoints' plotted. 
	-- Scale should be a number between 
	-----------------------------------------------------------------------------------
	local graphGroup = display.newGroup()
	
	
	-- Dividing the Xincrement and Yincrements by 2 will quarter the graph size,
	-- this could be used to scale and add multiple graphs to a single scene
	local Xincrement = display.contentWidth /23
	local Yincrement = display.contentHeight /28 -- leave additional space at bottom for tab bar.
	local Xmin = Xincrement *1
	local Xmax = Xincrement *22 -- one space on left + 21 increments (including 0)
	local Ymin = Yincrement *22 -- Corona co-ordinates go top to bottom
	local Ymax = Yincrement *1
	local Xzero = Xincrement *11.5 -- 1 space at top + 11 increments (including 0)
	local Yzero = Yincrement *11.5

	-- create the axis for the graph
	local Xaxis = display.newLine( graphGroup, Xmin, Yzero, Xmax, Yzero) 
	Xaxis:setStrokeColor( 0, 255, 255 ) -- this is wrong !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	Xaxis.strokeWidth = 2
	local Yaxis = display.newLine( graphGroup, Xzero, Ymin, Xzero, Ymax)
	Yaxis:setStrokeColor( 0, 160, 160 ) 
	Yaxis.strokeWidth = 2
	
	--[[
	print( "X zero", Xzero)
	print( "Display content width", display.contentWidth )	
	-- some dots to test the layout.
	local minDot = display.newCircle( graphGroup, Xmin, Ymin, 3)
	minDot:setFillColor( 1, 0, 0) -- red
	local XmaxDot = display.newCircle( graphGroup, Xmax, Ymin, 3)
	XmaxDot:setFillColor( 0, 0, 1 ) -- Blue
	local YmaxDot = display.newCircle( graphGroup, Xmin, Ymax, 3)
	YmaxDot:setFillColor( 0, 1, 0 ) -- green
	--]]
	
	-- Add increment lines to Y-axis
	local halfLength = 4
	local incPos = 0
	for i=-10, 10 do
		incPos =  i * Yincrement + Yzero
		display.newLine( graphGroup, Xzero-halfLength, incPos, Xzero+halfLength, incPos )
	end
	
	-- Add increment lines to X-axis
	for i=-10, 10 do
		incPos = i * Xincrement + Xzero
		display.newLine( graphGroup, incPos, Yzero-halfLength, incPos, Yzero+halfLength )
	end
	
	-- Add points to the graph
	local radius = 3
	for _, points in ipairs( graphPoints ) do
		local point = display.newCircle( graphGroup,
			points[1] * Xincrement + Xzero,
			-points[2] * Yincrement + Yzero, -- inverse the Y-axis as Corona co-ordinates work from top to bottom.
			radius
		)
		if points[3] == 'M' then
			point:setFillColor( 0, 0.3, 0.9 ) -- blue
		elseif points[3] == 'B' then
			point:setFillColor( 255, 0, 0 ) -- red
		else
			point:setFillColor( 0.3, .8, 0 ) -- green
		end	
	end
	
	return graphGroup;
end

return graphLib