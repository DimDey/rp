DB = nil

function getDataBaseConnection()
    outputServerLog("GETTING: DataBase connection......")
    if not DB then
        DB = dbConnect("mysql", "dbname=jabkarp;host=127.0.0.1;charset=utf8", "jabka", "root")
        if DB then		
            outputServerLog("SUCCESS: DataBase gets!")
            return DB
        else
            outputServerLog("FAIL: DATABASE ERROR!")
        end
    end
end
addEventHandler("onResourceStart",resourceRoot,getDataBaseConnection)

addEvent("onGetDataBase",true)
addEvent("onDataBase")

function getDB()
    if not DB then
        getDataBaseConnection()
    end
    triggerEvent("onDataBase",source,DB)
end
addEventHandler("onGetDataBase",root,getDB)
