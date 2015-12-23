--[[ControlCalefaccion
	Dispositivo virtual
	grabarButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

function calcularTimestamp(hora)
  --local cuando = os.date('*t', os.time())
  --cuando.hour = tonumber(hora)
  --cuando.min = 0
  --cuando.sec = 0
  --return os.time(cuando)
  return os.time()+(hora*3600)
end

-- obtener zona actual
local zona = fibaro:get(_selfId, 'ui.zonaLabel.value')
zona = string.sub(zona, 1, string.find(zona, '-', 1) - 1)

-- obtener temperatura
local temp = fibaro:get(_selfId, 'ui.tempParaLabel.value')
-- obtener hora
local hora = string.sub(temp, -3, -2)
temp = string.sub(temp, 1, 2)
-- obtener modo actual
local modo  = fibaro:get(_selfId, 'ui.modoLabel.value')
fibaro:debug('modo: '..modo..' temp: '..temp)

-- obtener panel correspondiente
if not HC2 then
  HC2 = Net.FHttp("127.0.0.1", 11111)
end
response ,status, errorCode = HC2:GET("/api/panels/heating/"..zona)
local panel = json.decode(response)

-- asignar valores
-- si el modo es "Manual" guardar handTemperature y handTimestamp y poner
-- vacationTemperature a 0
if modo == 'Manual' then
  panel.properties['handTemperature'] = tonumber(temp)
  panel.properties.handTimestamp = tonumber(calcularTimestamp(hora))
  panel.properties['vacationTemperature'] = 0
-- si es "Vacaciones", grabar vacationTemperatur y poner handTemperature a 0
else
  panel.properties['handTemperature'] = 0
  panel.properties['vacationTemperature'] = tonumber(temp)
end

-- guardar valores
HC2:PUT("/api/panels/heating/"..zona, json.encode(panel))

-- actualizar las etiquetas con estado real de temperatura
fibaro:call(_selfId, "pressButton", "13")
