-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD( 'vmaff1.txd' ) 
engineImportTXD( txd, 124 ) 
dff = engineLoadDFF('vmaff1.dff', 124) 
engineReplaceModel( dff, 124 )
end)
