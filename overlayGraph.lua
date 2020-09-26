local composer = require( "composer" )
local formulas = require( "modules.formulas" )
local ioLib = require( "modules.ioLib" )
local graphLib = require( "modules.graphLib" )
local widget = require( "widget" )
local funcLib = require( "modules.funcLib" )
 
local scene = composer.newScene()

local overlayGraph
local overlayPoints
local closeButton
local alpha = 0.5

-- set default scale
local scale = {}
scale.xMin = xMin or -10
scale.xMax = xMax or 10
scale.yMin = yMin or -10
scale.yMax = yMax or 10
scale.zoomLevel = 0
scale.factor = 0.2 -- 20% zoom increments

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function closeOverlay( event )
	composer.hideOverlay( true, "fade", 400 )
 end
 
 local function zoomIn( event )
	if scale.zoomLevel < 4 then
		overlayGraph:removeSelf() 
		scale.zoomLevel = scale.zoomLevel +1
		local factor = ( 0-scale.xMin+scale.xMax +1 ) /2 *0.2
		scale.factor = scale.zoomLevel *0.2 -- 20% zoom increments
		overlayGraph = graphLib.newScrollGraph( overlayPoints , alpha, 
			scale.xMin + factor * scale.zoomLevel,
			scale.xMax - factor * scale.zoomLevel,
			scale.yMin + factor * scale.zoomLevel,
			scale.yMax - factor * scale.zoomLevel
		)
		scene.view:insert( overlayGraph )
		funcLib.getHandle( "closeButton", scene.view ):toFront()
		
	end
	
	return true
end

local function zoomOut( event )
	if scale.zoomLevel > -4 then
		overlayGraph:removeSelf() 
		scale.zoomLevel = scale.zoomLevel -1
		local factor = ( 0-scale.xMin+scale.xMax +1 ) /2 *0.2
		scale.factor = scale.zoomLevel *0.2 -- 20% zoom increments
		overlayGraph = graphLib.newScrollGraph( overlayPoints , alpha, 
			scale.xMin + factor * scale.zoomLevel,
			scale.xMax - factor * scale.zoomLevel,
			scale.yMin + factor * scale.zoomLevel,
			scale.yMax - factor * scale.zoomLevel
		)
		scene.view:insert( overlayGraph )
		funcLib.getHandle( "closeButton", scene.view ):toFront()
	end
	return true
end
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
		
	local graphPoints = composer.getVariable( "graphPoints" )
	overlayPoints = formulas.yDouble( graphPoints )  -- pass by reference, the whole table gets modified
	scale.xMin, scale.xMax, scale.yMin, scale.yMax = graphLib.getScale( overlayPoints )
	overlayGraph = graphLib.newScrollGraph( overlayPoints, alpha, 
		scale.xMin,
		scale.xMax,
		scale.yMin,
		scale.yMax
	)
	sceneGroup:insert( overlayGraph )
		
			-- Close overlay button
	local closeButton = widget.newButton( {
			id = "closeButton",
			shape = "circle",
			radius = 10,
			x = display.contentWidth /20,
			y = display.contentHeight /20, 
			onRelease = closeOverlay,
			label = "X",
			fillcolour = { default={.8,.8,.8}, over={.5,.5,.5} }
			})
		
	local zoomInButton = widget.newButton(
	{
		id = "zoomInButton",
		onRelease = zoomIn,
		shape = "roundedRect",
		width = 70,	height = 20, cornerRadius = 10,
		x = display.actualContentWidth /1.2,
		y = display.actualContentHeight /1.2,
		label = "Zoom in", fontSize = 14, font = native.systemFont,
		labelColor = { default={.8,.8,.8}, over={0,.5,.8} },
		fillColor = { default={0,0,0,0}, over={1,0.5,0.5,0} },
		strokeColor = { default={1,1,1,.2}, over={0.8,0.8,1,1} },
		strokeWidth = 2,
	})
	local zoomOutButton = widget.newButton(
	{
		id = "zoomOutButton",
		onRelease = zoomOut,
		shape = "roundedRect",
		width = 70,	height = 20, cornerRadius = 10,
		x = display.actualContentWidth /6,
		y = display.actualContentHeight /1.2,
		label = "Zoom out", fontSize = 14, font = native.systemFont,
		labelColor = { default={.8,.8,.8}, over={0,.5,.8} },
		fillColor = { default={0,0,0,0}, over={1,0.5,0.5,0} },
		strokeColor = { default={1,1,1,.2}, over={0.8,0.8,1,1} },
		strokeWidth = 2,
	})

	local shadeAddOverlayButton = display.newRoundedRect(
		sceneGroup,
		display.actualContentWidth /2,  -- x
		display.actualContentHeight /1.2, -- y
		80,	-- width
		20, -- height
		10	-- cornerRadius
	)
	shadeAddOverlayButton:setFillColor( 0,0,0,0.3 )
	
	local shadeTabBar = display.newRect(
		sceneGroup,
		display.contentCenterX,
		display.contentHeight -25,
		display.actualContentWidth,
		50
	)
	shadeTabBar:setFillColor( 0,0,0,0.6 )

	sceneGroup:insert( zoomInButton )
	sceneGroup:insert( zoomOutButton )
	sceneGroup:insert( closeButton )
		
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene