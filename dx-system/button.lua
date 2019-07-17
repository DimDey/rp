function dxDrawButton(elTable)
    dxDrawRectangle(elTable.x, elTable.y, elTable.width, elTable.height, elTable.colors.active)
    dxDrawText(elTable.text, elTable.x, elTable.y, elTable.width+elTable.x, elTable.height+elTable.y, white, 1, "sans", "center", "center")
end

function dxCreateButton(x, y, width, height, text, colors)
    local id = #dxElements + 1
    local colors = colors or {}
    colors[1] = colors[1] or tocolor(255,155,0,255)
    colors[2] = colors[2] or tocolor(50,50,255,155)
    colors[3] = colors[3] or tocolor(255,255,255)
    
    local t = {
        x = x,
        y = y,
        width = width,
        height = height,
        text = text,
        render = dxDrawButton,
        colors = {
            normal = colors[1],
            hover = colors[2],
            click = colors[3],
            active = colors[1]
        }
    }
    dxElements[id] = t
    return id
end

btn1 = dxCreateButton(0, 0, 300, 200, "СОСАТЬ ЛЕЖАТЬ", {tocolor(255,155,0,255), tocolor(50,50,255,155),tocolor(155,155,155,255)})
btn2 = dxCreateButton(500, 200, 300, 200, "КЛИКНИ НА МЕНЯ")
btn3 = dxCreateButton(500, 500, 300, 200, "АЙРОН СОСАТЬ") 
showCursor(true)

function onClickToElement(id)
    if id == btn2 then -- после удаления btn2 == btn1
        outputDebugString(id)
        destroyDxElement(id)
    end
end
addEventHandler("onDxClick",root,onClickToElement)