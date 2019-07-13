addEvent("onServerSendData",true)

function setElData(element,key,value)
    triggerServerEvent("onClientElDataChange",source,key,value)
end

function getElData(element,key)
    triggerServerEvent("onClientGetElData",source,element,key)
    local funchandler = function(keyName,data)
        if keyName == key then
            removeEventHandler("onServerSendData",element,funchandler)
            return data
        end
    end
    addEventHandler("onServerSendData",element,funchandler)
end