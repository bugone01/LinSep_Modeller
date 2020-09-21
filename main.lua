-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
require ( "unitTests.lunatest" )
local composer = require( "composer" )
composer.gotoScene( "openingScene" )

local graphFile = ""

require( "unitTests.myTestSuites" )