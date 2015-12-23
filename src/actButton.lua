--[[ControlCalefaccion
	Dispositivo virtual
	actButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION DE USUARIO -------------------------------------------]]
iconoProgra = 1061  -- id del icono de temperatura programada
iconoManual = 1062  -- id del icono de temperatura manual
iconoVacaci = 1050  -- id del icono de temperatura vacaciones
--[[----- FIN CONFIGURACION DE USUARIO ---------------------------------------]]

--[[----- NO CAMBIAR EL CODIGO A PARTIR DE AQUI ------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

--[[
getIcon()
  parametros: tabla con el panel
	retorno: devuelve el id del icono correspondiente al tipo de programación
------------------------------------------------------------------------------]]
function getIcon(panel)
  -- obtener datos reales del panel
  local tempAct, hora, icono
  if panel.properties.handTemperature ~= 0 then
    -- obtener datos reales del panel
    tempAct =  panel.properties.handTemperature
    hora = math.ceil((panel.properties.handTimestamp - os.time()) / 3600)
    if hora < 0 then hora = 0 end
    hora = string.format('%02d', hora)
    -- icono de temperatura manual
    icono = iconoManual
  elseif panel.properties.vacationTemperature ~= 0 then
    -- icono de temperatura vacaciones
    icono = iconoVacaci
    tempAct =  panel.properties.vacationTemperature
    hora = '__'
  else
    -- icono de temperatura programada
    icono = iconoProgra
    tempAct =  0
    hora = '__'
  end
  tempAct = string.format('%02d', tostring(tempAct))
  return icono, tempAct..'ºC / '..hora..'h'
end

-- obtener zona actual
local zona = fibaro:get(_selfId, 'ui.zonaLabel.value')
local textoZona = string.sub(zona, string.find(zona, '-', 1) + 1, #zona)
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
  -- hora = os.date('%H', panel.properties.handTimestamp)
  hora = math.ceil((panel.properties.handTimestamp - os.time()) / 3600)
  if hora < 0 then hora = 0 end
  hora = string.format('%02d', hora)
else -- si el modo es vacaciones actualizar vacationTemperature pero no mostrar
-- handTimestamp
  tempAct =  panel.properties.vacationTemperature
  hora = '__'
end
tempAct = string.format('%02d', tostring(tempAct))

-- actualizar valores de etiquetas
fibaro:debug(tempAct..'ºC / '..hora..'h')
fibaro:call(_selfId, "setProperty", 'ui.tempParaLabel.value',
  tempAct..'ºC / '..hora..'h')

local iconoId, tempHora =  getIcon(panel)
-- refrescar icono
fibaro:call(_selfId, 'setProperty', "currentIcon", iconoId)

--refrescar log
fibaro:debug(textoZona..' - '..tempHora)
--fibaro:log(textoZona..' - '..tempAct..'ºC / '..hora..'h')
fibaro:log(textoZona..' - '..tempHora)
