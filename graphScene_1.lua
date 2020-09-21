local composer = require( "composer" )
local widget = require( "widget" )
local graphLib = require( "modules.graphLib" )
local ioLib = require( "modules.ioLib" )
 
local scene = composer.newScene()
composer.recycleOnSceneChange = true -- clear the graph and view, allows fresh graph data on re-visit if file changed.
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
  
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
 local function homeHandler( event )
	graphFile = "" -- delete the graph file name, to prevent old data from being plotted if new file is erroneous. 
	composer.gotoScene( "openingScene", "fade" )	
 end
 
local function graphScene_2( event )
	composer.gotoScene( "graphScene_2", "slideLeft" )
end

local function zoomIn( event )
	print("Zoom in was pressed")
end
 
local function zoomOut( event )
	print("Zoom out was pressed")
end
 
 local function addOverlay( event )
	print( "Add overlay was pressed" )
 end
 
-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	
	local tabButtons = {
		{ label="Home", defaultFile="artAssets/icons8-home-50.png", overFile="artAssets/icons8-home-50.png", width = 32, height = 32, onPress=homeHandler },
		{ label="Raw", defaultFile="artAssets/icons8-graph-40.png", overFile="artAssets/icons8-graph-40.png", width = 32, height = 32, onPress=graphScene_1, selected=true },
		{ label="form1", defaultFile="artAssets/icons8-graph-40.png", overFile="artAssets/icons8-graph-40.png", width = 32, height = 32, onPress=graphScene_2 },
	}

	-- tabBar widget
	local tabBar = widget.newTabBar{ sceneGroup,
		top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
		buttons = tabButtons
	}
	
	local graphPoints = ioLib.cleanGraphData( graphFile, system.DocumentsDirectory )
	local rawGraph = graphLib.newGraph( graphPoints )
	sceneGroup:insert( rawGraph )
	--------------------------------------------------------------
	-- This can be used to remove a graph if needed
	--rawGraph:removeSelf()
	--rawGraph = nil
	--------------------------------------------------------------
	
	---[[
	local zoomInButton = widget.newButton(
		{
			onRelease = zoomIn,
			shape = "roundedRect",
			width = 70,	height = 20, cornerRadius = 10,
			x = display.actualContentWidth /6,
			y = display.actualContentHeight /1.2,
			label = "Zoom in", fontSize = 14, font = native.systemFont,
			labelColor = { default={.8,.8,.8}, over={0,.5,.8} },
			fillColor = { default={0,0,0,0}, over={1,0.5,0.5,0} },
			strokeColor = { default={1,1,1,.2}, over={0.8,0.8,1,1} },
			strokeWidth = 2,
		})	
	local zoomOutButton = widget.newButton(
		{
			onRelease = zoomOut,
			shape = "roundedRect",
			width = 70,	height = 20, cornerRadius = 10,
			x = display.actualContentWidth /1.2,
			y = display.actualContentHeight /1.2,
			label = "Zoom out", fontSize = 14, font = native.systemFont,
			labelColor = { default={.8,.8,.8}, over={0,.5,.8} },
			fillColor = { default={0,0,0,0}, over={1,0.5,0.5,0} },
			strokeColor = { default={1,1,1,.2}, over={0.8,0.8,1,1} },
			strokeWidth = 2,
		})
	local addOverlayButton = widget.newButton(
		{
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
		})
	--]]
	
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