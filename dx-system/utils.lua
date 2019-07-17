local eventColorsTable = {
	["onDxHover"] = "hover",
	["onDxLeave"] = "normal",
	["onDxClick"] = "click",
	["onDxReleaseClick"] = "hover"
}
function dxGetTable(id)
	return dxElements[id]
end

function isDxFocused(id)
    local elTable = dxElements[id]
    return elTable.focused
end

function isDxHovered(id)
    local elTable = dxElements[id]
    return elTable.hovered
end

function destroyDxElement(id)
	dxElements[id] = nil
    return true
end

function isCursorOnElement( posX, posY, width, height )
	if isCursorShowing( ) then
		local mouseX, mouseY = getCursorPosition( )
		local clientW, clientH = guiGetScreenSize( )
		local mouseX, mouseY = mouseX * clientW, mouseY * clientH
		if ( mouseX > posX and mouseX < ( posX + width ) and mouseY > posY and mouseY < ( posY + height ) ) then
			return true
		end
	end
	return false
end

function dxSetColor(id,color)
	local elTable = dxGetTable(id)
	if color == "normal" then
		elTable.colors.active = elTable.colors.normal
		return
	end
	if color == "hover" then
		elTable.colors.active = elTable.colors.hover
		return
	end
	if color == "click" then
		elTable.colors.active = elTable.colors.click
		return
	end
end

function updateColorDxEl(id)
	dxSetColor(id,eventColorsTable[eventName])
end
addEventHandler("onDxHover",root,updateColorDxEl)
addEventHandler("onDxLeave",root,updateColorDxEl)
addEventHandler("onDxClick",root,updateColorDxEl)
addEventHandler("onDxReleaseClick",root,updateColorDxEl)