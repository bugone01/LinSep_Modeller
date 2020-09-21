local composer = require( "composer" )
local widget = require( "widget" )
local graphLib = require( "modules.graphLib" )
local ioLib = require( "modules.ioLib" )
local formulas = require( "modules.formulas" )
 
local scene = composer.newScene()
composer.recycleOnSceneChange = true -- clear the graph and view, allows new graph data on re-visit
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
  
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
 local function homeHandler( event )
	graphFile = ""
	composer.gotoScene( "openingScene", "fade" )
 end
 
 local function graphScene_1( event )
	composer.gotoScene( "graphScene_1", "slideRight" )
end
 
-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	local tabButtons = {
		{ label="Home", defaultFile="artAssets/icons8-home-50.png", overFile="artAssets/icons8-home-50.png", width = 32, height = 32, onPress=homeHandler },
		{ label="Raw", defaultFile="artAssets/icons8-graph-40.png", overFile="artAssets/icons8-graph-40.png", width = 32, height = 32, onPress=graphScene_1 },
		{ label="form1", defaultFile="artAssets/icons8-graph-40.png", overFile="artAssets/icons8-graph-40.png", width = 32, height = 32, onPress=graphScene_2, selected=true },
	}

	-- tabBar widget
	local tabBar = widget.newTabBar{ sceneGroup,
		top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
		buttons = tabButtons
	}
	---[[
	local graphPoints = ioLib.cleanGraphData( graphFile, system.DocumentsDirectory )
	graphPoints = formulas.yDouble( graphPoints )
	local rawGraph = graphLib.newGraph( graphPoints )
	sceneGroup:insert( rawGraph )
	--------------------------------------------------------------
	-- This can be used to remove a graph if needed
	--rawGraph:removeSelf()
	--rawGraph = nil
	--------------------------------------------------------------
	--]]
	--[[
	local backButton = widget.newButton(
		{
			shape = "roundedRect",
			cornerRadius = 10,
			x = display.actualContentWidth /10,
			y = display.actualContentHeight /20,
			label = "back",
			onRelease = backHandler,
			width = 50,
			height = 20,
			fontSize = 14, 
			font = native.systemFont,
			fillColor = { default={ 1,0,0 }, over={ 1,0,0 } },
			strokeColor = { default={ 0 }, over={ 0,1,0 } },
			strokeWidth = 2,
		})
	--]]
	
	sceneGroup:insert( tabBar )
	--sceneGroup:insert( backButton )
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