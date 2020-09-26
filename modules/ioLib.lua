ioLib = {}

function ioLib.saveFile( fileName, path, content ) -- This needs error checking. Is there a corona function for this?
	local fullPath = system.pathForFile( fileName, path )
	local fileHandle, errorString = io.open( fullPath, "w" )
		
		if fileHandle then
			fileHandle:write( content )  -- does this return status to the caller?
			io.close( fileHandle )
		else
			print("An error occured, while saving file : "..errorString)
		end 
		
	return true
end
	
function ioLib.doesFileExist( fname, path ) -- Add references here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	local results = false
 
	-- Path for the file
	local filePath = system.pathForFile( fname, path )
 
	if ( filePath ) then
		local file, errorString = io.open( filePath, "r" )
 
		if not file then
			-- Error occurred; output the cause
			print( "File error: " .. errorString )
		else
			results = true
			-- Close the file handle
			file:close()
		end
	end
 
	return results
end
	
function ioLib.copyFile( srcName, srcPath, dstName, dstPath, overwrite ) -- Add reference here!!!!!!!!!!!!!!!!
 
    local results = false
 
    local fileExists = ioLib.doesFileExist( srcName, srcPath )
    if ( fileExists == false ) then
        return nil  -- nil = Source file not found
    end
 
    -- Check to see if destination file already exists
    if not ( overwrite ) then
        if ( ioLib.doesFileExist( dstName, dstPath ) ) then
            return 1  -- 1 = File already exists (don't overwrite)
        end
    end
 
    -- Copy the source file to the destination file
    local rFilePath = system.pathForFile( srcName, srcPath )
    local wFilePath = system.pathForFile( dstName, dstPath )
 
    local rfh = io.open( rFilePath, "rb" )
    local wfh, errorString = io.open( wFilePath, "wb" )
 
    if not ( wfh ) then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Read the file and write to the destination directory
        local data = rfh:read( "*a" )
        if not ( data ) then
            print( "Read error!" )
            return false
        else
            if not ( wfh:write( data ) ) then
                print( "Write error!" )
                return false
            end
        end
    end
 
    results = 2  -- 2 = File copied successfully!
 
    -- Close file handles
    rfh:close()
    wfh:close()
 
    return results
end

function ioLib.readFileContents( fileName, path )
	local fullPath = system.pathForFile( fileName, path )
	local fileHandle, strError = io.open( fullPath, "r" )	
		if fileHandle then
			local contents = fileHandle:read( "*a" )
			io.close( fileHandle )
			fileHandle = nil
			return contents
		else
			return nil, strError
		end 
end 

-- Read users file and split into sub-tables, each with x, y and a group reference (used for colour association)
-- { { x, y, "C" } }
function ioLib.__parseGraphData( fileName, path )
	local data = ioLib.readFileContents( fileName, path )
	local cleaned = {}
	local sub = {}
	for str in string.gmatch(data, "([^,]+)") do
		str = tonumber(str) or str
		table.insert(sub, str)
		if #sub == 3 then
			table.insert(cleaned, sub)
			sub = {}
		end
	end
	return cleaned
end

	--tis easier to ask forgivness than permission.
function ioLib.parseGraphData( fileName, path )
	-- protected call to __cleanGraphData to capture any errors with data format
	local result, cleaned = pcall( ioLib.__parseGraphData, fileName, path )
	if result == true then
		return cleaned
	else
		return nil, "Error in call to cleanGraphData : is data correct format? : "
	end
end

return ioLib