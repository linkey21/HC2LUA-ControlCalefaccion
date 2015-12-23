--[[ControlCalefaccion
	Dispositivo virtual
	mainLoop.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

while true do
  --
  fibaro:sleep(1000)
  --fibaro:call(_selfId, "setProperty", 'ui.tempParaLabel.value',  'Para Hora:')

  -- obtener zona actual
  local zona = fibaro:get(_selfId, 'ui.zonaLabel.value')
  zona = string.sub(zona, 1, string.find(zona, '-', 1) - 1)
  -- obtener datos reales del panel
  if not HC2 then
    HC2 = Net.FHttp("127.0.0.1", 11111)
  end
  response ,status, errorCode = HC2:GET("/api/panels/heating/"..zona)
  local panel = json.decode(response)
  local iconoRecomendado
  if panel.properties.handTemperature ~= 0 then
    -- icono de temperatura manual
    iconoRecomendado = 1062
  elseif panel.properties.vacationTemperature ~= 0 then
    -- icono de temperatura vacaciones
    iconoRecomendado = 1050
  else
    -- icono de temperatura programada
    iconoRecomendado = 1061
  end
  --refrescar icono recomendacion
  fibaro:call(_selfId, 'setProperty', "currentIcon", iconoRecomendado)

end
