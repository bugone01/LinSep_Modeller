module(..., package.seeall) --Add this line to the top of every test module you create


function suite_setup()
	-- Add modules or setup required for the whole suite
end

 function setup()
	local result, err = os.remove(system.pathForFile("test.txt", system.DocumentsDirectory))
	return result
end

function teardown()
	local result, err = os.remove(system.pathForFile("test.txt", system.DocumentsDirectory))
	return result
end


function test_readAndSaveFileServices()
	require "modules.ioLib"
	
	local data = "spam"
	assert_true( ioLib.saveFile( "test.txt", system.DocumentsDirectory, data ), "Failed to save test.txt" )
	
	local contents = ioLib.readFileContents( "test.txt", system.DocumentsDirectory )
	assert_equal( data, contents, "Contents doesn't equal data" )	
end


function test_importingCSV()
	local contents = ioLib.readFileContents( "data.csv", system.DocumentsDirectory )
	local test_data = "1,-2.40,B,,,,,,,,,,,\n2,-2.70,B,,,,,,,,,,,\n3,-2.07,B,,,,,,,,,,,\n4,2.37,B,,,,,,,,,,,\n5,-2.14,B,,,,,,,,,,,\n6,-2.63,B,,,,,,,,,,,\n7,2.07,B,,,,,,,,,,,\n8,2.18,B,,,,,,,,,,,\n9,2.24,B,,,,,,,,,,,\n10,2.52,B,,,,,,,,,,,\n1,2.97,M,,,,,,,,,,,\n2,2.17,M,,,,,,,,,,,\n3,2.36,M,,,,,,,,,,,\n4,-2.33,M,,,,,,,,,,,\n5,2.45,M,,,,,,,,,,,\n6,2.40,M,,,,,,,,,,,\n7,-2.14,M,,,,,,,,,,,\n8,-2.77,M,,,,,,,,,,,\n9,-2.51,M,,,,,,,,,,,\n10,-2.76,M,,,,,,,,,,,\n1,0.25,Z,,,,,,,,,,,\n2,0.01,Z,,,,,,,,,,,\n3,0.22,Z,,,,,,,,,,,\n4,0.76,Z,,,,,,,,,,,\n5,-0.54,Z,,,,,,,,,,,\n6,-0.06,Z,,,,,,,,,,,\n7,-0.33,Z,,,,,,,,,,,\n8,-0.25,Z,,,,,,,,,,,\n9,1.73,Z,,,,,,,,,,,\n10,-0.74,Z,,,,,,,,,,,\n"
	assert_equal(test_data, contents, "\n----------------------------------------------------------imported 'data.csv' file contents doesn't match expected")
	end


function test_cleanedCSVdata()
	local inspect = require( 'unitTests.inspect' )
	-- [ab]uses 'inspect' module to compare two tables which are NOT the same object. (i.e. == doesn't work)
	-- https://stackoverflow.com/questions/20325332/how-to-check-if-two-tablesobjects-have-the-same-value-in-lua
	-- sample useage: assert_equal(inspect({ 1 , b = 30 }), inspect({ b = 30, 1 }))
	
	local testData = {{1,-2.40,'B',}, {2,-2.70,'B'}, {3,-2.07,'B'}, {4,2.37,'B'}, {5,-2.14,'B'}, {6,-2.63,'B'}, {7,2.07,'B'}, {8,2.18,'B'}, {9,2.24,'B'}, {10,2.52,'B'}, {1,2.97,'M'}, {2,2.17,'M'}, {3,2.36,'M'}, {4,-2.33,'M'}, {5,2.45,'M'}, {6,2.40,'M'}, {7,-2.14,'M'}, {8,-2.77,'M'}, {9,-2.51,'M'}, {10,-2.76,'M'}, {1,0.25,'Z'}, {2,0.01,'Z'}, {3,0.22,'Z'}, {4,0.76,'Z'}, {5,-0.54,'Z'}, {6,-0.06,'Z'}, {7,-0.33,'Z'}, {8,-0.25,'Z'}, {9,1.73,'Z'}, {10,-0.74,'Z'}}
	local cleanData = ioLib.cleanGraphData( "data.csv", system.ResourceDirectory )
	
	assert_equal( inspect(testData), inspect(cleanData), "\n---------------------------------------------------------- formatting error: the formatted graph point data doesn't match expected")
	assert_nil( ioLib.cleanGraphData( "noSuchFile", system.DocumentsDirectory ), "\n-----------------------------------non nil value in bad call to cleanGraphData")
end

function test_read_nonExistent_file()
	local contents, errorString = ioLib.readFileContents( "nonExistentFile.txt", system.DocumentsDirectory )
	assert_nil(contents)
	-- this test will fail if sandbox path is different
	assert_equal( "C:\\Users\\bugon\\AppData\\Local\\Corona Labs\\Corona Simulator\\Sandbox\\linsep_modeller-9B9D5D40423572466D78110C44E29E1F\\Documents\\nonExistentFile.txt: No such file or directory", errorString )
end

function test_graphObject()
	local graph = require 'modules.graphLib'
	local graphData = ioLib.cleanGraphData( "data.csv", system.DocumentsDirectory )
	local graphGroup = graphLib.newGraph( graphData )
	assert_not_nil(graphGroup, "\n---------------------------------------------------------------------------------- Graph object should not return nil")
	graphGroup:removeSelf()
	graphGroup = nil
end

function test_write_nonExistent_file()
 --What should the behaviour be?
end

