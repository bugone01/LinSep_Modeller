-----------------------------------------------------------------------
-- Displays the opening scene where users can select a data file, 

-----------------------------------------------------------------------


local composer = require( "composer" )
local widget = require( "widget" )
local lfs = require( "lfs" )
local ioLib = require( "modules.ioLib" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
  
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local userDir = system.pathForFile( nil, system.DocumentsDirectory )

local textColor = { 0.8, 0.8, 0.2 } -- mustard,  American spelling for consistency with Corona SDK APIs
local font = native.systemFont
local fontSize = 16
local lineSpacing = 1.7
local xCnt = display.contentCenterX
local left = xCnt /4
local currentLine = display.contentHeight /6 -- set the line first line origin


 -- returns next Y position for line of text.
local function nextLine()
	currentLine = currentLine + fontSize*lineSpacing
	return currentLine
end
 
 local function gotoGraph( event )
	graphFile = event.target:getLabel() -- get the filename, for graph plot data. 
	composer.gotoScene( "graphScene_1", "fade" )
 end
 
 local function createFileButton( fileName, yLocation)
 	local fileButtonGroup = display.newGroup()
	local image = display.newImage( fileButtonGroup, "artAssets/icons8-heat-map-100(1).png", 100, 100 )-- (reference) !!!!!!!!!!!!!!!!!!!
	image.x = display.actualContentWidth /20
	image.y = yLocation
	image.xScale = 0.2
	image.yScale = 0.2

	local myButton = widget.newButton( 
		{	
			label = fileName,
			onRelease = gotoGraph,
			shape = "roundedRect",
			x = display.actualContentWidth /3,
			y = yLocation,
			width = display.actualContentWidth,
			height = fontSize *1.5,
			fontSize = fontSize,
			cornerRadius = 12,
			labelColor = { default={0,.5,.8}, over={0,.5,.8} },
			fillColor = { default={0,0,0,0}, over={1,0.5,0.5,0} },
			strokeColor = { default={1,1,1,.2}, over={0.8,0.8,1,1} },
			strokeWidth = 2,
			labelAlign = "left",
			labelXOffset = display.actualContentWidth /4,
		})
		
	fileButtonGroup:insert( myButton )
	return fileButtonGroup
 end
 
-- create()
function scene:create( event )
	
	-- initialise a[the] sample data.csv file to user directory
	ioLib.copyFile( "data.csv", nil, "data.csv", system.DocumentsDirectory, false )
	
    local sceneGroup = self.view
	
	local background = display.newImageRect( sceneGroup, "artAssets/background.png", 641, 640 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	
	-- add the welcome text information
	local appName = display.newText( sceneGroup, "Linear Separability Modeller", 
		xCnt, currentLine, font, fontSize )
	appName:setFillColor( unpack( textColor ) )
	
	local byWord = display.newText( sceneGroup, "By", 
		xCnt, nextLine(), font, fontSize )
	byWord:setFillColor( unpack( textColor ) )
	
	local authorText = display.newText( sceneGroup, "Robert Herren", 
		xCnt, nextLine(), font, fontSize )
	authorText:setFillColor( unpack( textColor ) )

	nextLine() -- bit of extra space for asthetics
	local recentFilesText = display.newText( sceneGroup, "Open file ...", -- or "Recent files" ??
		left, nextLine(), font, fontSize /1.2 )
	recentFilesText:setFillColor( 1,1,1,.7 )
		
	-- create a file button for each file in user directory
	local recentFiles = {}	
	local limit = 6
	
	 -- select the *.csv files from the user's documents directory and create buttons from them
	for fileName in lfs.dir( userDir ) do
		if string.ends( fileName, ".csv" ) then
			table.insert( recentFiles, createFileButton( fileName, nextLine() ) )
			if #recentFiles == limit then
				break
			end
		end
	end

    for _, buttonGroup in pairs( recentFiles ) do
			sceneGroup:insert( buttonGroup )
    end
	
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