setDefaultTab("GUILD")
------------------------------------------------------
local secondsToIdle = 5
local activeFPS = 60
---------------------------------------------------------

local afkFPS = 0

local function isSameMousePos(p1, p2)
  return p1.x == p2.x and p1.y == p2.y
end

local function setAfk()
  modules.client_options.setOption("backgroundFrameRate", afkFPS)
  modules.game_interface.gameMapPanel:hide()
end

local function setActive()
  modules.client_options.setOption("backgroundFrameRate", activeFPS)
  modules.game_interface.gameMapPanel:show()
end

local lastMousePos = nil
local finalMousePos = nil
local idleCount = 0
local maxIdle = secondsToIdle * 4

-- Salva o macro em uma variável para podermos monitorar quando ele é desligado
local idleMacro = macro(250, "Idle Mode", function()
  local currentMousePos = g_window.getMousePosition()

  if finalMousePos then
    if isSameMousePos(finalMousePos, currentMousePos) then return end
    setActive()
    finalMousePos = nil
  end

  if lastMousePos and isSameMousePos(lastMousePos, currentMousePos) then
    idleCount = idleCount + 1
  else
    lastMousePos = currentMousePos
    idleCount = 0
  end

  if idleCount == maxIdle then
    setAfk()
    finalMousePos = currentMousePos
    idleCount = 0
  end
end)

-- FUNÇÃO DE SEGURANÇA: Se você desligar o botão do macro, a tela acende automaticamente
idleMacro.onOff = function(macroRef, enabled)
  if not enabled then
    setActive()
    finalMousePos = nil
    idleCount = 0
  end
end
