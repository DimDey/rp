screenW, screenH = guiGetScreenSize()
SERVERCOLORS = {
	GENERAL =  tocolor(255,106,19),
	RED     =  tocolor(236,32,32)
}
loadstring(exports.dgs:dgsImportFunction())()

function dxMaskTexture(mask,width,height)
    local mask = dxCreateTexture( mask )
    local texture = dxCreateTexture(width,height)
    local shader = dxCreateShader("Shaders/mask.fx")
    if shader and mask then
        dxSetShaderValue( shader, "Texture0",mask) -- текстура
        dxSetShaderValue( shader, "Texture1",mask) -- маска     

        return shader
    end
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
        return true
    else
        return false
    end
end

function getFont(path,size,bold)
	bold = bold or false
	local fontSize = math.ceil((size * screenH) / 1080) 
	font = dxCreateFont(path, fontSize,bold)
	return font
end

function getFontSize(font)
	return getElementData(font,"pt")
end