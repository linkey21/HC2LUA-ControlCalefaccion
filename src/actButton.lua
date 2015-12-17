--[[ControlCalefaccion
	Dispositivo virtual
	actButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

-- obtener zona actual
local zona = fibaro:get(_selfId, 'ui.zonaLabel.value')
zona = string.sub(zona, 1, string.find(zona, '-', 1) - 1)
-- obtener modo actual
local modo  = fibaro:get(_selfId, 'ui.modoLabel.value')

-- obtener datos reales del panel
if not HC2 then
  HC2 = Net.FHttp("127.0.0.1", 11111)
end
response ,status, errorCode = HC2:GET("/api/panels/heating/"..zona)
local panel = json.decode(response)

local tempAct, hora
-- si el modo es manual actualizar handTemperature y handTimestamp
if modo == 'Manual' then
  tempAct =  panel.properties.handTemperature
  hora = os.date('%H', panel.properties.handTimestamp)
else -- si el modo es vacaciones actualizar vacationTemperature pero no mostrar
-- handTimestamp
  tempAct =  panel.properties.vacationTemperature
  hora = '__'
end
tempAct = string.format('%02d', tostring(tempAct))

-- actualizar valores
fibaro:debug(tempAct..'ºC / '..hora..'h')
fibaro:call(_selfId, "setProperty", 'ui.tempParaLabel.value',
  tempAct..'ºC / '..hora..'h')
