DB = nil
vehicles = {}
addEvent("onVehicleEngineBroke",true)
function onVehicleDamaged(loss)
    local vhp = getElementHealth(source)
    if vhp <= 300 then
        triggerEvent("onVehicleEngineBroke",source)
    end
end
addEventHandler("onVehicleDamage",root,onVehicleDamaged)

function vehicleBrokeEngine()
    setVehicleEngineState(source,false)
    setElementHealth(source,300)
end
addEventHandler("onVehicleEngineBroke",root,vehicleBrokeEngine)

function parseFactionVehicle()
    outputServerLog("Vehicles: Getting DB connection.")
    if getDataBase() then
        outputServerLog("PARSING: Faction vehicles.....")
        local callfunc = function(qh)
            local result = dbPoll(qh,0)
            outputServerLog("Vehicles: Creating faction vehicles....")
            createCars(result)
            outputServerLog("Vehicles: Faction vehicles created")
        end
        local qh = dbQuery(callfunc,DB,"SELECT * FROM vehicles WHERE `frid`")
    end
end
addEventHandler("onResourceStart",resourceRoot,parseFactionVehicle)

function parsePlayerVehicles()
    local playerid = 1--getElementData(source,"playerid")
    outputServerLog("Vehicles: Getting DB connection.")
    if getDataBase() then
        outputServerLog("PARSING: User("..playerid..") vehicles.....")
        local callfunc = function(qh)
            local result = dbPoll(qh,0)
            outputServerLog("Vehicles: Creating User("..playerid..") vehicles....")
            createCars(result)
            outputServerLog("Vehicles: User("..playerid..") vehicles created")
        end
        local qh = dbQuery(callfunc,DB,"SELECT * FROM vehicles WHERE `playerid`='1'")
    end
end
addEventHandler("onPlayerAuth",root,parsePlayerVehicles)

function getDataBase()
    if not DB then
        local func = function(connection)
            DB = connection 
        end
        addEventHandler("onDataBase", resourceRoot, func)
        triggerEvent("onGetDataBase",resourceRoot)
        removeEventHandler("onDataBase", resourceRoot, func)
    end
    return DB
end

function createCars(result)
    for i,row in ipairs(result) do
        local veh = createVehicle(row.modelid,row.sx,row.sy,row.sz)
        if veh then
            outputServerLog("Vehicles: Vehicle("..row.carid..") created successful!")                    
            setElementData(veh,"carid",row.carid)
            setElementData(veh,"frid",row.frid)
            setElementData(veh,"pid",row.playerid)
            setElementData(veh,"fuel",row.fuel)
            setElementData(veh,"broken",row.broken)
            triggerEvent("onCreateIntElement",veh,veh,"test")
        else
            outputServerLog("Vehicles: Vehicle("..row.carid..") creation error!")   
        end
    end
end