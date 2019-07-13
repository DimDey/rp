interactiveData = {}

function onPlayerJoins(ps)
    local peds = createPed ( 295, 0.6654, 0.55122, 5.545 )
    local pedsa = createPed ( 85, 0.6654, 2.55122, 5.545 )
    local object = createObject(1337,2.2456,3.222,5.034)
    local veh = createVehicle( 400, 1.0,3.3,5.2)
    if peds then
        createIntEl(peds,"Jacob Russell")
        createIntEl(pedsa,"Airon Sleft(lox)")
        createIntEl(veh, getVehicleNameFromModel(400))
        createIntEl(object, "Мусорка")
    end
end
addCommandHandler("tesa",onPlayerJoins)

function createIntEl(element,name)
    local intelement = createElement("intelement")
    if intelement ~= root then
        setElementData(intelement,"name",name)
        setElementParent(element,intelement)
    end
end
addEvent("onCreateIntElement",true)
addEventHandler("onCreateIntElement",root,createIntEl)