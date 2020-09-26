local composer = require( "composer" )
local widget = require( "widget" )
local graphLib = require( "modules.graphLib" )
local ioLib = require( "modules.ioLib" )
local formulas = require( "modules.formulas" )
local funcLib = require( "modules.funcLib" )
 
local scene = composer.newScene()
composer.recycleOnSceneChange = true -- clear the graph and view, allows fresh graph data on re-visit if file changed.

-- set default scale
local scale = {}
scale.xMin = xMin or -10
scale.xMax = xMax or 10
scale.yMin = yMin or -10
scale.yMax = yMax or 10
scale.zoomLevel = 0
scale.factor = 0.2 -- 20% zoom increments

local mainGraph
local overlayGraph
local graphPoints = composer.getVariable( "graphPoints" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
  
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
 local function getHandle( id, view )
	local view = view or scene.view
	
	local success = false
	for i=1, view.numChildren do
		local child = view[i]
		if child.id == id then
			success = true
			return child
		end
	end
	
	if not success then
		return nil, "Child not found"
	end 
	
end
	
 
--local alert = native.showAlert( "You are in scene1!", "Congratulations!", { "OK" }, onComplete )
local function mySelection( event )
	print( "This is the selection", event.target.index )
	
end
	 
 local function homeHandler( event )
	graphFile = "" -- delete the graph file name, to prevent old data from being plotted if new file is erroneous. 
	composer.gotoScene( "openingScene", "fade" )	
 end
 
local function graphScene_2( event )
	composer.gotoScene( "graphScene_2", "slideLeft" )
end

 local function zoomIn( event )
	if scale.zoomLevel < 4 then
		mainGraph:removeSelf() 
		scale.zoomLevel = scale.zoomLevel +1
		local factor = ( 0-scale.xMin+scale.xMax +1 ) /2 *0.2
		scale.factor = scale.zoomLevel *0.2 -- 20% zoom increments
		mainGraph = graphLib.newScrollGraph( graphPoints , alpha, 
			scale.xMin + factor * scale.zoomLevel,
			scale.xMax - factor * scale.zoomLevel,
			scale.yMin + factor * scale.zoomLevel,
			scale.yMax - factor * scale.zoomLevel
		)
		scene.view:insert( mainGraph )
	end
	
	return true
end

local function zoomOut( event )
	if scale.zoomLevel > -4 then
		mainGraph:removeSelf() 
		scale.zoomLevel = scale.zoomLevel -1
		local factor = ( 0-scale.xMin+scale.xMax +1 ) /2 *0.2
		scale.factor = scale.zoomLevel *0.2 -- 20% zoom increments
		mainGraph = graphLib.newScrollGraph( graphPoints , alpha, 
			scale.xMin + factor * scale.zoomLevel,
			scale.xMax - factor * scale.zoomLevel,
			scale.yMin + factor * scale.zoomLevel,
			scale.yMax - factor * scale.zoomLevel
		)		
		scene.view:insert( mainGraph )
	end
	return true
end
 
 local function addOverlay( event )
	
	local options = {
		effect = "fade",
		time = 500,
		isModal = true
	}
	
	composer.showOverlay( "overlayGraph", options )
	
	
	--[[
	local inspect = require( "unitTests.inspect" )
	
	print( "Add overlay was pressed" )
	local selectionMenu = widget.newTableView( {
		id = myTableView,
		x = 10,
		y = 10,
		width = 100,
		height = 200,
		onRowTouch = mySelection
	})
	
	scene.view:insert( selectionMenu )
	
	selectionMenu:insertRow( {
		id = "TheFirstSelection"
	} )
	
	local overlayPoints = formulas.yDouble( graphPoints )
	--local xMin, xMax, yMin, yMax = graphLib.getScale( overlayPoints )
	overlayGraph = graphLib.newGraph( overlayPoints, .5, 
			scale.xMin * scale.factor,
			scale.xMax * scale.factor,
			scale.yMin * scale.factor,
			scale.yMax * scale.factor
		)
	--scene.view:insert( overlayGraph )
	mainGraph:insert( overlayGraph )
	
	overButton = getHandle( "overlayButton" )
	overButton:setEnabled( false )
	
	--event.target:setEnabled( false ) -- disable the button
	--]]
	return true
 end
 
 
-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

	local tabButtons = {
		{ label="Home", defaultFile="artAssets/icons8-home-50.png", overFile="artAssets/icons8-home-50.png", width = 32, height = 32, onPress=homeHandler },
		{ label="Raw", defaultFile="artAssets/icons8-graph-40.png", overFile="artAssets/icons8-graph-40.png", width = 32, height = 32, onPress=graphScene_1, selected=true },
		{ label="doubleY", defaultFile="artAssets/icons8-graph-40.png", overFile="artAssets/icons8-graph-40.png", width = 32, height = 32, onPress=graphScene_2 },
	}

	-- tabBar widget
	local tabBar = widget.newTabBar{ sceneGroup,
		top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
		buttons = tabButtons
	}
		
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
	local addOverlayButton = widget.newButton(
		{
			id = "overlayButton",
			onRelease = addOverlay,
			shape = "roundedRect",
			width = 80,	height = 20, cornerRadius = 10,
			x = display.actualContentWidth /2,
			y = display.actualContentHeight /1.2,
			label = "Add overlay", fontSize = 14, font = native.systemFont,
			labelColor = { default={.8,.8,.8}, over={0,.5,.8} },
			fillColor = { default={0,0,0,0}, over={1,0.5,0.5,0} },
			strokeColor = { default={1,1,1,.2}, over={0.8,0.8,1,1} },
			strokeWidth = 2,
			isEnabled = true
		})
		
	sceneGroup:insert( tabBar )
	sceneGroup:insert( zoomInButton )
	sceneGroup:insert( zoomOutButton )
	sceneGroup:insert( addOverlayButton )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
		scale.xMin, scale.xMax, scale.yMin, scale.yMax = graphLib.getScale( graphPoints )
		mainGraph = graphLib.newScrollGraph( graphPoints , nil, scale.xMin, scale.xMax, scale.yMin, scale.yMax )
		sceneGroup:insert( mainGraph )
		
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
		mainGraph:removeSelf()
		mainGraph = nil
 
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