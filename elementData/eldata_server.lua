dataStorage = {}
addEvent("onClientElDataChange",true)
addEvent("onClientGetElData",true)

function setElData(element,key,value)
    if not(dataStorage[element]) then -- если ещё нет элементдаты.
        dataStorage[element] = {} 
    end
    local dataElStorage = dataStorage[element] -- переменная для удобного чтения
    local oldValue = dataElStorage[key] -- дата, которая была до изменения(если есть)
    dataElStorage[key] = value -- обновление данных
    return true
end
addEventHandler("onElDataChange",root,setElData)

function getElData(element,key)
    if getElementType(source) == "player" then
        triggerClientEvent(source,"onServerSendData",element,key,dataStorage[element][key])
    end
    return dataStorage[element][key]
end
addEventHandler("onClientGetElData",root,getElData)