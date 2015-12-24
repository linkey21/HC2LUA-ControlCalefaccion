--[[ControlCalefaccion
	Dispositivo virtual
	mainLoop.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- NO CAMBIAR EL CODIGO A PARTIR DE AQUI ------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

--[[
getLog()
  parametros: tabla con el panel
	retorno: devuelve el id del icono correspondiente al tipo de programación
------------------------------------------------------------------------------]]
function getLog(panel)
  local tempAct, hora, icono
  if panel.properties.handTemperature ~= 0 then
    -- obtener datos reales del panel
    tempAct =  panel.properties.handTemperature
    hora = math.ceil((panel.properties.handTimestamp - os.time()) / 3600)
    if hora < 0 then hora = 0 end
    hora = string.format('%02d', hora)
  elseif panel.properties.vacationTemperature ~= 0 then
    tempAct =  panel.properties.vacationTemperature
    hora = '__'
  else
    tempAct =  0
    hora = '__'
  end
  tempAct = string.format('%02d', tostring(tempAct))
  return tempAct, hora
end

--[[--------BUCLE DE CONTROL -------------------------------------------------]]
while true do
  --
  fibaro:sleep(1000)
  -- obtener zona
  local zona, zonaId, tempAct, hora
  zona = fibaro:get(_selfId, 'ui.zonaLabel.value')
  zonaId = string.sub(zona, 1, string.find(zona, '-', 1) -1)
  zona = string.sub(zona, string.find(zona, '-', 1) + 1, #zona)
  -- obtener datos reales del panel
  if not HC2 then
    HC2 = Net.FHttp("127.0.0.1", 11111)
  end
  response ,status, errorCode = HC2:GET("/api/panels/heating/"..zonaId)
  local panel = json.decode(response)

  -- obtener temperatura y hora
  tempAct, hora = getLog(panel)

  -- comprobar si el tiempo ha expirado
  if hora == '00' then
    -- poner la temperatura manual a 0
    panel.properties['handTemperature'] = 0
    -- guardar valores
    HC2:PUT("/api/panels/heating/"..zonaId, json.encode(panel))
  end

  --refrescar log
  fibaro:log(zona..' - '..tempAct..'ºC / '..hora..'h')
end
--[[--------------------------------------------------------------------------]]
