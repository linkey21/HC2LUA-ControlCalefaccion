--[[ControlCalefaccion
	Dispositivo virtual
	borrarButton.lua
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

-- si el modo es vacaciones grabar vacationTemperature y no grabar
-- handTimestamp
local claveTemp = 'vacationTemperature'
local handTimestamp = false
-- si el modo es manual guardar handTemperature y handTimestamp
if modo == 'Manual' then
  claveTemp = 'handTemperature'
  handTimestamp = os.time()
end

if not HC2 then
  HC2 = Net.FHttp("127.0.0.1", 11111)
end
response ,status, errorCode = HC2:GET("/api/panels/heating/"..zona)
local panel = json.decode(response)

-- asignar valores
if handTimestamp then
  panel.properties.handTimestamp = tonumber(handTimestamp)
end
panel.properties[claveTemp] = 0

fibaro:debug("/api/panels/heating/"..zona)
fibaro:debug(panel.properties.handTimestamp)
fibaro:debug(panel.properties[claveTemp])

-- guardar valores
local json = json.encode(panel)
esponse ,status, errorCode = HC2:PUT("/api/panels/heating/"..zona, json)
