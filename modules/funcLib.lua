funcLib = {}

function funcLib.getHandle( id, view )
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

return funcLib