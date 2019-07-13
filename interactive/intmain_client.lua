intelements = {}

interactiveFunctions = { -- сделать интерфейс
    ["player"] = function()
        outputDebugString("it`s player")
    end,
    ["ped"] = function(x,y)
        outputDebugString("it`s ped")
    end,
    ["object"] = function()
        outputDebugString("it`s object")
    end,
    ["vehicle"] = function()
        outputDebugString("it`s vehicle")
    end
}

function onPlayerStartRes()
    gShader = dxCreateShader("assets/ped-stroke.fx",0,0,true,"all")
    gShaderObj = dxCreateShader("assets/obj-stroke.fx",0,0,true,"object")
    gInteractiveOpened = false
end
addEventHandler("onClientResourceStart",resourceRoot,onPlayerStartRes)

function openHandler()
    if getKeyState("mouse2") and getKeyState("e") then
        if not(gInteractiveOpened) then
            local x,y,z = getElementPosition(localPlayer)
            local elements = getElementsInPlayerRange(x,y,z)
            for i,element in ipairs(elements) do
                if element ~= localPlayer then
                    if getIntElement(element) then
                        intelements[#intelements+1] = element 
                    end
                end
            end
            gInteractiveOpened = true
            if #intelements > 1 then
                addShaderToInt()
                showCursor(true)
                addEventHandler("onClientClick",root,onClickHandler)
                addEventHandler("onClientRender",root,renderHandler)
            else  
                
            end
        else
            closeIntSelector()
        end
    end
end
addEventHandler("onClientKey",root,openHandler)
setDevelopmentMode(true,true)

function closeIntSelector()
    gInteractiveOpened = false
    showCursor(false)
    removeShaderFromInt()
    if isEventHandlerAdded("onClientClick",root,onClickHandler) then
        removeEventHandler("onClientClick",root,onClickHandler)
        removeEventHandler("onClientRender",root,renderHandler)
    end
    intelements = {}
end

function addShaderToInt()
    for i,el in ipairs(intelements) do      
        engineApplyShaderToWorldTexture(gShader,"*",el)
        engineApplyShaderToWorldTexture(gShaderObj,"*",el)
    end
end

function removeShaderFromInt()
    for i,el in ipairs(intelements) do
        engineRemoveShaderFromWorldTexture(gShader,"*",el)
        engineRemoveShaderFromWorldTexture(gShaderObj,"*",el)
    end
end

function onClickHandler(button,state,absoluteX,absoluteY,worldX,worldY,worldZ,clickedWorld) -- обработчик клика на экран
    if(clickedWorld) then
        if clickedWorld ~= localPlayer then
            if button == "left" and state == "down" then
                if getIntElement(clickedWorld) then
                    local x,y,z = getElementPosition(localPlayer)
                    if isElementInPlayerRange(x,y,z,clickedWorld) then
                        closeIntSelector()
                        showCursor(true)
                        interactiveFunctions[getElementType(clickedWorld)](absoluteX,absoluteY)
                    end
                end
            end
        end
    end
end

function renderHandler()
    for i,element in ipairs(intelements) do
        local x,y,z = getElementPosition(element)
        local x1,y1 = getScreenFromWorldPosition(x,y,z)
        local parent = getIntElement(element)
        if x1 and y1 then
            dxDrawText(getElementData(parent,"name"),x1,y1,x1,y1)
        end
    end
end