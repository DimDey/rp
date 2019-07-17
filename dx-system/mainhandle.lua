dxElements = {}

local function dxRenderElements()
    for v, elTable in pairs(dxElements) do
        elTable.render(elTable)
    end
end
addEventHandler("onClientRender", root, dxRenderElements)

local function onClickToElement(button, state, aX, aY)
    for v, elTable in pairs(dxElements) do
        if state == "down" then
            if isDxHovered(v) then
                elTable.focused = true
                triggerEvent("onDxClick", source, v, button, aX, aY)
            else
                elTable.focused = false
            end
        else
            if elTable.focused then
                triggerEvent("onDxReleaseClick", source, v, button)
                elTable.focused = false
            end
        end
    end
end
addEventHandler("onClientClick", root, onClickToElement)

local function onCursorMove()
    for v, elTable in pairs(dxElements) do
        if isCursorOnElement(elTable.x, elTable.y, elTable.width, elTable.height) then  
            if not elTable.focused then
                elTable.hovered = true
                triggerEvent("onDxHover", source, v, aX, aY)
            end
        else
            if elTable.hovered then
                elTable.hovered = false
                triggerEvent("onDxLeave", source, v)
            end
            
            
        end
    end
end
addEventHandler("onClientCursorMove", root, onCursorMove)

