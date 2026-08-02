setDefaultTab("GUILD") -- Garante que os créditos apareçam na aba HP do Healer

-- =============================================================================
-- [PAINEL DE CRÉDITOS E SUPORTE - BRINQUE SCRIPT NATIVO ANIMADO]
-- =============================================================================
local version = "1.1"
local currentVersion
local available = false

storage.checkVersion = storage.checkVersion or 0

-- 1. Rótulo Principal: Nome da Marca Destacado em Amarelo Ouro Original
local labelBrinqueMarca = UI.Label("CENTRAL DE PUXE v" .. version)
if labelBrinqueMarca then
    labelBrinqueMarca:setColor("#ffcc00") -- Cor Ouro de Elite
    labelBrinqueMarca:setFont("verdana-11px-rounded") -- Fonte com contorno limpo
end



-- =============================================================================
-- [MOTOR DE PISCAR SIMPLES] DEGRADE CONTÍNUO EM LOOP DE BACKGROUND (SEM CRASH)
-- =============================================================================
macro(150, function()
    if not labelBrinqueMarca then return end

    -- Coleta o tempo atual em ondas matemáticas (Seno de frequência rápida)
    local tempoOnda = os.clock() * 5
    local pulsoIntensidade = math.abs(math.sin(tempoOnda))

    -- 1. FAZ A LOGO "HEALING BRINQUE" PISCAR EM DEGRADÊ (AMARELO OURO <-> LARANJA WAR)
    local gLogo = math.floor(100 + (105 * pulsoIntensidade)) -- Oscila o tom de Verde do RGB
    local corLogoHex = string.format("#FF%02X00", gLogo)
    labelBrinqueMarca:setColor(corLogoHex)
end)



-- Definir o estilo PushMaxWindow primeiro
g_ui.loadUIFromString([[
PushMaxWindow < MainWindow
  !text: tr('PushMax by Soule Scripts')
  size: 280 450
  padding: 25

  BotLabel
    id: delayText
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Push Delay: 1000ms

  HorizontalScrollBar
    id: delay
    anchors.left: delayText.left
    anchors.right: delayText.right
    anchors.top: delayText.bottom
    margin-top: 5
    minimum: 500
    maximum: 2000
    step: 50

  BotLabel
    id: runeIdLabel
    anchors.top: delay.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 15
    text-align: center
    text: Rune ID para Push

  BotItem
    id: runeId
    anchors.top: runeIdLabel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5

  BotLabel
    id: mwallIdLabel
    anchors.top: runeId.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 15
    text-align: center
    text: MWall ID para Bloqueio

  BotItem
    id: mwallId
    anchors.top: mwallIdLabel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5

  BotLabel
    id: hotkeyLabel
    anchors.top: mwallId.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 15
    text-align: center
    text: Hotkey para PushMax

  TextEdit
    id: hotkey
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: hotkeyLabel.bottom
    margin-top: 5
    text-align: center

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-right: 5
]])

local panelName = "pushmax"
local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('PUSHMAX')

  Button
    id: push
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup

]])
ui:setId(panelName)

if not storage[panelName] then
  storage[panelName] = {
    enabled = true,
    pushDelay = 1060,
    pushMaxRuneId = 3188,
    mwallBlockId = 2128,
    pushMaxKey = "PageUp"
  }
end

local config = storage[panelName]

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
config.enabled = not config.enabled
widget:setOn(config.enabled)
end

ui.push.onClick = function(widget)
  pushWindow:show()
  pushWindow:raise()
  pushWindow:focus()
end

rootWidget = g_ui.getRootWidget()
if rootWidget then
  pushWindow = UI.createWindow('PushMaxWindow', rootWidget)
  pushWindow:hide()

  pushWindow.closeButton.onClick = function(widget)
    pushWindow:hide()
  end

  local updateDelayText = function()
    pushWindow.delayText:setText("Push Delay: ".. config.pushDelay)
  end
  updateDelayText()
  pushWindow.delay.onValueChange = function(scroll, value)
    config.pushDelay = value
    updateDelayText()
  end
  pushWindow.delay:setValue(config.pushDelay)

  pushWindow.runeId.onItemChange = function(widget)
    config.pushMaxRuneId = widget:getItemId()
  end
  pushWindow.runeId:setItemId(config.pushMaxRuneId)
  pushWindow.mwallId.onItemChange = function(widget)
    config.mwallBlockId = widget:getItemId()
  end
  pushWindow.mwallId:setItemId(config.mwallBlockId)

  pushWindow.hotkey.onTextChange = function(widget, text)
    config.pushMaxKey = text
  end
  pushWindow.hotkey:setText(config.pushMaxKey)
end


-- variables for config
local fieldTable = {2118, 105, 2122}
local cleanTile = nil

-- scripts 

local targetTile
local pushTarget

local resetData = function()
  for i, tile in pairs(g_map.getTiles(posz())) do
    if tile:getText() == "TARGET" or tile:getText() == "DEST" or tile:getText() == "CLEAR" then
      tile:setText('')
    end
  end
  pushTarget = nil
  targetTile = nil
  cleanTile = nil
end

local getCreatureById = function(id)
  for i, spec in ipairs(getSpectators()) do
    if spec:getId() == id then
      return spec
    end
  end
  return false
end

local isNotOk = function(t,tile)
  local tileItems = {}

  for i, item in pairs(tile:getItems()) do
    table.insert(tileItems, item:getId())
  end
  for i, field in ipairs(t) do
    if table.find(tileItems, field) then
      return true
    end
  end
  return false
end

local isOk = function(a,b)
  return getDistanceBetween(a,b) == 1
end

-- to mark
local hold = 0
onKeyDown(function(keys)
  if not config.enabled then return end
  if keys ~= config.pushMaxKey then return end
  hold = now
  local tile = getTileUnderCursor()
  if not tile then return end
  if pushTarget and targetTile then
    resetData()
    return
  end
  local creature = tile:getCreatures()[1]
  if not pushTarget and creature then
    pushTarget = creature
    if pushTarget then
      tile:setText('TARGET')
      pushTarget:setMarked('#00FF00')
    end
  elseif not targetTile and pushTarget then
    if pushTarget and getDistanceBetween(tile:getPosition(),pushTarget:getPosition()) ~= 1 then
      resetData()
      return
    else
      tile:setText('DEST')
      targetTile = tile
    end
  end
end)

-- mark tile to throw anything from it
onKeyPress(function(keys)
  if not config.enabled then return end
  if keys ~= config.pushMaxKey then return end
  local tile = getTileUnderCursor()
  if not tile then return end

  if (hold - now) < -2500 then
    if cleanTile and tile ~= cleanTile then
      resetData()
    elseif not cleanTile then
      cleanTile = tile
      tile:setText("CLEAR")
    end
  end
  hold = 0
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
  if not config.enabled then return end
  if creature == player then
    resetData()
  end
  if not pushTarget or not targetTile then return end
  if creature == pushTarget and newPos == targetTile then
    resetData()
  end
end)

macro(50, function()
  if not config.enabled then return end

  local pushDelay = tonumber(config.pushDelay)
  local rune = tonumber(config.pushMaxRuneId)
  local customMwall = config.mwallBlockId

  if cleanTile then
    local tilePos = cleanTile:getPosition()
    local pPos = player:getPosition()
    if not isOk(tilePos, pPos) then
      resetData()
      return
    end

    if not cleanTile:hasCreature() then return end
    local tiles = getNearTiles(tilePos)
    local destTile
    local forbidden = {}
    -- unfortunately double loop
    for i, tile in pairs(tiles) do
      local minimapColor = g_map.getMinimapColor(tile:getPosition())
      local stairs = (minimapColor >= 210 and minimapColor <= 213)
      if stairs then
        table.insert(forbidden, tile:getPosition())
      end
    end
    for i, tile in pairs(tiles) do
      local minimapColor = g_map.getMinimapColor(tile:getPosition())
      local stairs = (minimapColor >= 210 and minimapColor <= 213)
      if tile:isWalkable() and not isNotOk(fieldTable, tile) and not tile:hasCreature() and not stairs then
        local tooClose = false
        if #forbidden ~= 0 then
          for i=1,#forbidden do
            local pos = forbidden[i]
            if isOk(pos, tile:getPosition()) then
              tooClose = true
              break
            end
          end
        end
        if not tooClose then
          destTile = tile
          break
        end
      end
    end

    if not destTile then return end
    local parcel = cleanTile:getCreatures()[1]
    if parcel then
      test()
      g_game.move(parcel,destTile:getPosition())
      delay(2000)
    end
  else
    if not pushTarget or not targetTile then return end
    local tilePos = targetTile:getPosition()
    local targetPos = pushTarget:getPosition()
    if not isOk(tilePos,targetPos) then return end
    
    local tileOfTarget = g_map.getTile(targetPos)
    
    if not targetTile:isWalkable() then
      local topThing = targetTile:getTopUseThing():getId()
      if topThing == 2129 or topThing == 2130 or topThing == customMwall then
        if targetTile:getTimer() < pushDelay+500 then
          vBot.isUsing = true
          schedule(pushDelay+700, function()
            vBot.isUsing = false
          end)
        end
        if targetTile:getTimer() > pushDelay then
          return
        end
      else
        return resetData()
      end
    end

    if not tileOfTarget:getTopUseThing():isNotMoveable() and targetTile:getTimer() < pushDelay+500 then
      return useWith(rune, pushTarget)
    end
    if isNotOk(fieldTable, targetTile) then
      if targetTile:canShoot() then
        return useWith(3148, targetTile:getTopUseThing())
      else
        return
      end
    end
      g_game.move(pushTarget,tilePos)
      delay(2000)
  end
end)
-- Storage para Advanced Push
if not storage.AdvancedPushSystem then
  storage.AdvancedPushSystem = {}
end

-- Configurações do sistema com persistência
local pushConfig = {
    enabled = storage.AdvancedPushSystem.enabled or false,
    pushDelay = storage.AdvancedPushSystem.pushDelay or 1000,    -- Delay entre empurrões
    lookDelay = storage.AdvancedPushSystem.lookDelay or 500,     -- Delay após look
    maxDistance = storage.AdvancedPushSystem.maxDistance or 3,     -- Distância máxima para empurrar
    autoLook = storage.AdvancedPushSystem.autoLook ~= false      -- Ativar look automático (true por padrão)
}

-- Carregar UI da janela de configuração
g_ui.loadUIFromString([[
PushConfigTextEdit < Panel
  height: 40

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  TextEdit
    id: textEdit
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 5
    minimum: 0
    maximum: 10
    step: 1
    text-align: center

PushConfigWindow < MainWindow
  !text: tr('Advanced Push System Config')
  size: 300 250
  padding: 25

  Label
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    text: "Configuracoes do Push System"
    color: #ffaa00

  VerticalScrollBar
    id: contentScroll
    anchors.top: prev.bottom
    margin-top: 10
    anchors.right: parent.right
    anchors.bottom: separator.top
    step: 28
    pixels-scroll: true
    margin-right: -10
    margin-top: 5
    margin-bottom: 5

  ScrollablePanel
    id: content
    anchors.top: prev.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    vertical-scrollbar: contentScroll
    margin-bottom: 10
      
    Panel
      id: left
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-right: 5
]])

-- Função para adicionar campos de texto
local addTextEdit = function(id, title, defaultValue, dest, tooltip)
  local widget = UI.createWidget('PushConfigTextEdit', dest)
  widget.text:setText(title)
  widget.textEdit:setText(pushConfig[id] or defaultValue or "")
  widget.text:setTooltip(tooltip)
  widget.textEdit.onTextChange = function(widget,text)
    pushConfig[id] = tonumber(text) or defaultValue
    storage.AdvancedPushSystem[id] = pushConfig[id]
  end
  pushConfig[id] = pushConfig[id] or defaultValue
end

-- Criar janela de configuração PRIMEIRO
local pushConfigWindow = UI.createWindow('PushConfigWindow', rootWidget)
pushConfigWindow:hide()
pushConfigWindow.closeButton.onClick = function(widget)
  pushConfigWindow:hide()
end

-- Função para criar janela de configuração (AGORA pode usar pushConfigWindow)
local function createConfigWindow()
  local leftPanel = pushConfigWindow.content.left
  
  -- Limpar painel
  leftPanel:destroyChildren()
  
  -- Adicionar campos de configuração
  addTextEdit("pushDelay", "Push Delay (ms)", 1000, leftPanel, "Delay entre empurrões")
  addTextEdit("lookDelay", "Look Delay (ms)", 500, leftPanel, "Delay após look")
  addTextEdit("maxDistance", "Max Distance", 3, leftPanel, "Distância máxima para empurrar")
  
  -- Checkbox para Auto Look
  local autoLookCheck = UI.createWidget('UICheckBox', leftPanel)
  autoLookCheck:setText("Auto Look")
  autoLookCheck:setChecked(pushConfig.autoLook)
  autoLookCheck.onClick = function()
    pushConfig.autoLook = autoLookCheck:isChecked()
    storage.AdvancedPushSystem.autoLook = pushConfig.autoLook
  end
end

-- UI principal
local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Advanced Push')

  Button
    id: setup
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup

]])

-- Criar o macro PRIMEIRO
local pushSystemMacro = macro(100, function()
    if not pushConfig.enabled then return end
    local attackingTarget = g_game.getAttackingCreature()
    local followingTarget = g_game.getFollowingCreature()
    if attackingTarget then
        currentTarget = attackingTarget
    elseif followingTarget then
        currentTarget = followingTarget
    end
end)

-- Restaurar estado do macro baseado no storage
if pushConfig.enabled then
    pushSystemMacro:setOn()
end

ui.title:setOn(pushConfig.enabled)
ui.title.onClick = function(widget)
  pushConfig.enabled = not pushConfig.enabled
  storage.AdvancedPushSystem.enabled = pushConfig.enabled
  widget:setOn(pushConfig.enabled)
  if pushConfig.enabled then
    pushSystemMacro.setOn()
    modules.game_textmessage.displayGameMessage("Advanced Push System ATIVADO!")
  else
    pushSystemMacro.setOff()
    modules.game_textmessage.displayGameMessage("Advanced Push System DESATIVADO!")
  end
end

ui.setup.onClick = function(widget)
  createConfigWindow()
  pushConfigWindow:show()
  pushConfigWindow:raise()
  pushConfigWindow:focus()
end

-- Direções mapeadas para teclas numéricas
local directionMap = {
    ["1"] = {x = -1, y =  1, name = "SW"}, -- Southwest
    ["2"] = {x =  0, y =  1, name = "S"},  -- South
    ["3"] = {x =  1, y =  1, name = "SE"}, -- Southeast
    ["4"] = {x = -1, y =  0, name = "W"},  -- West
    ["6"] = {x =  1, y =  0, name = "E"},  -- East
    ["7"] = {x = -1, y = -1, name = "NW"}, -- Northwest
    ["8"] = {x =  0, y = -1, name = "N"},  -- North
    ["9"] = {x =  1, y = -1, name = "NE"}  -- Northeast
}

-- Variáveis de estado
local currentTarget = nil
local lastLookName = nil
local lastLookTime = 0
local isLooking = false

-- Função para obter o target atual
local function getCurrentTarget()
    -- Método 1: Target atual (atacando/seguindo)
    local attackingTarget = g_game.getAttackingCreature()
    local followingTarget = g_game.getFollowingCreature()
    
    if attackingTarget then
        return attackingTarget
    elseif followingTarget then
        return followingTarget
    end
    
    -- Método 2: Target via Look (se configurado)
    if pushConfig.autoLook and currentTarget then
        return currentTarget
    end
    
    return nil
end

-- Função para empurrar o target (VERSÃO MELHORADA)
local function pushTarget(target, direction)
    if not target or not direction then
        return false
    end
    
    local targetPos = target:getPosition()
    local playerPos = pos()
    local newPos = {
        x = targetPos.x + direction.x,
        y = targetPos.y + direction.y,
        z = targetPos.z
    }
    
    -- Verificar se a posição de destino é válida
    local destTile = g_map.getTile(newPos)
    if not destTile or not destTile:isWalkable() or #destTile:getCreatures() > 0 then
        modules.game_textmessage.displayGameMessage("Não é possível empurrar para essa direção!")
        return false
    end
    
    -- CALCULAR distância atual do player até o target
    local currentDistance = getDistanceBetween(playerPos, targetPos)
    
    -- Se player está adjacente (distância 1), precisa se afastar ANTES do push
    if currentDistance <= 1 then
        local retreatPos = {
            x = playerPos.x - direction.x,
            y = playerPos.y - direction.y,
            z = playerPos.z
        }
        
        local retreatTile = g_map.getTile(retreatPos)
        if retreatTile and retreatTile:isWalkable() and #retreatTile:getCreatures() == 0 then
            -- Primeiro se afasta, depois empurra
            autoWalk(retreatPos, true, true)
            modules.game_textmessage.displayGameMessage("Posicionando para push eficiente...")
            
            -- Aguarda movimento e depois executa push
            schedule(300, function()
                g_game.move(target, newPos)
                modules.game_textmessage.displayGameMessage("Empurrando " .. target:getName() .. " para " .. direction.name .. " (push otimizado)")
            end)
        else
            -- Se não consegue se afastar, empurra mesmo assim
            g_game.move(target, newPos)
            modules.game_textmessage.displayGameMessage("Empurrando " .. target:getName() .. " para " .. direction.name .. " (sem otimização)")
        end
    else
        -- Player já está na distância ideal, empurra diretamente
        g_game.move(target, newPos)
        modules.game_textmessage.displayGameMessage("Empurrando " .. target:getName() .. " para " .. direction.name .. " (distância ideal)")
    end
    
    return true
end

-- Função para processar o look
local function processLookByName(creatureName)
    if not creatureName then return end
    -- Busca apenas criaturas no mesmo andar do player
    local playerZ = posz()
    local found = nil
    for _, spec in ipairs(getSpectators()) do
        if spec:getName():lower() == creatureName:lower() and spec:getPosition().z == playerZ then
            found = spec
            break
        end
    end
    if found then
        currentTarget = found
        modules.game_textmessage.displayGameMessage("Target definido via Look: " .. found:getName())
    else
        modules.game_textmessage.displayGameMessage("Não foi possível encontrar a criatura '" .. creatureName .. "' no mapa.")
    end
end

-- Callback para quando o player olha em uma criatura
onTextMessage(function(mode, text)
    if not pushConfig.enabled then return end
    local name = text:match("You see ([^%(]+) %(")
    if name then
        name = name:gsub("^%s*(.-)%s*$", "%1")
        lastLookName = name
        lastLookTime = now
        processLookByName(name)
    end
end)

-- Hotkeys para empurrar (1-9, exceto 5) - SEM NOME VISÍVEL
for key, direction in pairs(directionMap) do
    hotkey(key, "", function() -- Nome vazio para não aparecer na interface
        if not pushConfig.enabled then
            modules.game_textmessage.displayGameMessage("Sistema de Push desativado!")
            return
        end
        
        local target = getCurrentTarget()
        if not target then
            modules.game_textmessage.displayGameMessage("Nenhum target encontrado! Use 'Look' em uma criatura ou ataque-a.")
            return
        end
        
        -- Verificar distância
        local distance = getDistanceBetween(pos(), target:getPosition())
        if distance > pushConfig.maxDistance then
            modules.game_textmessage.displayGameMessage("Target muito distante! Distância: " .. distance)
            return
        end
        
        pushTarget(target, direction)
    end)
end

-- Hotkey para Look (L) - SEM NOME VISÍVEL
hotkey("L", "", function() -- Nome vazio para não aparecer na interface
    if not pushConfig.enabled then
        modules.game_textmessage.displayGameMessage("Sistema de Push desativado!")
        return
    end
    
    local tile = getTileUnderCursor()
    if tile then
        local creatures = tile:getCreatures()
        if #creatures > 0 then
            local creature = creatures[1]
            g_game.look(creature)
            modules.game_textmessage.displayGameMessage("Olhando em " .. creature:getName() .. "...")
        else
            modules.game_textmessage.displayGameMessage("Nenhuma criatura encontrada no tile!")
        end
    else
        modules.game_textmessage.displayGameMessage("Nenhum tile selecionado!")
    end
end)



-- Remover os ícones antigos e usar apenas a interface principal
-- (remover as linhas dos addIcon)

-- Informações iniciais
modules.game_textmessage.displayGameMessage("Advanced Push System carregado!")
modules.game_textmessage.displayGameMessage("Use o botão para ativar/desativar o sistema")
modules.game_textmessage.displayGameMessage("Teclas: 1-9 (empurrar), L (look), Setup (configuraçoes)") 
modules.game_textmessage.displayGameMessage("Você esta usando a Script da Guild MOST WANTED") 


-- TestPush - Sistema de teste para AutoPush sem arquivo .otui
-- Autor: Custom Soule Scripts
-- Data: 31/01/2025
-- Versão: Teste

local panelName = "testpush"
local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('AUTO PUSH')

  Button
    id: setup
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup

]])
ui:setId(panelName)

if not storage[panelName] then
  storage[panelName] = {
    enabled = true,
    pushDelay = 1060,
    mwallBlockId = 2128,
    pushMaxKey = "F12",
    maxDistance = 7
  }
end

local config = storage[panelName]

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  widget:setOn(config.enabled)
end

-- Criar janela de configuração diretamente no Lua (sem depender de .otui)
g_ui.loadUIFromString([[
TestPushWindow < MainWindow
  !text: tr('Autopush by Soule Scripts')
  size: 280 450
  @onEscape: self:hide()

  BotLabel
    id: delayText
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Push Delay: 1000ms

  HorizontalScrollBar
    id: delay
    anchors.left: delayText.left
    anchors.right: delayText.right
    anchors.top: delayText.bottom
    margin-top: 5
    minimum: 500
    maximum: 2000
    step: 50

  BotLabel
    id: distanceText
    anchors.top: delay.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Max Distance: 7
    margin-top: 8

  HorizontalScrollBar
    id: distance
    anchors.left: distanceText.left
    anchors.right: distanceText.right
    anchors.top: distanceText.bottom
    margin-top: 3
    minimum: 2
    maximum: 15
    step: 1

  Label
    id: hotkeyLabel
    anchors.top: distance.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 10
    text-align: center
    text: Hotkey para TestPush

  TextEdit
    id: hotkey
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: hotkeyLabel.bottom
    margin-top: 3
    text-align: center

  Label
    id: instructionsLabel
    anchors.top: hotkey.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 15
    text-align: center
    text: Como usar:
    font: verdana-11px-rounded

  BotLabel
    id: instructions
    anchors.top: instructionsLabel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 8
    margin-left: 10
    margin-right: 10
    text-align: left
    text: 1. Ataque uma criatura (target automatico)\n\n2. OU use a hotkey diretamente sobre a criatura (modo manual)\n\n3. Pressione a hotkey sobre o destino desejado\n\n4. O push sera executado automaticamente\n\n5. O target permanece ativo - pressione ESC para cancelar\n\n6. Voce pode marcar novos destinos no mesmo target
    font: verdana-11px-rounded

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8    

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-top: 15
    margin-right: 5
]])

-- Criar janela
testPushWindow = UI.createWindow('TestPushWindow', rootWidget)
testPushWindow:hide()
testPushWindow.closeButton.onClick = function(widget)
  testPushWindow:hide()
end

-- Configurar elementos da janela
local updateDelayText = function()
  testPushWindow.delayText:setText("Push Delay: ".. config.pushDelay .. "ms")
end
updateDelayText()
testPushWindow.delay.onValueChange = function(scroll, value)
  config.pushDelay = value
  updateDelayText()
end
testPushWindow.delay:setValue(config.pushDelay)

local updateDistanceText = function()
  testPushWindow.distanceText:setText("Max Distance: " .. config.maxDistance)
end
updateDistanceText()
testPushWindow.distance.onValueChange = function(scroll, value)
  config.maxDistance = value
  updateDistanceText()
end
testPushWindow.distance:setValue(config.maxDistance)



testPushWindow.hotkey.onTextChange = function(widget, text)
  config.pushMaxKey = text
end
testPushWindow.hotkey:setText(config.pushMaxKey)



ui.setup.onClick = function(widget)
  testPushWindow:show()
  testPushWindow:raise()
  testPushWindow:focus()
end

-- Variables do sistema (igual ao pushmax)
local fieldTable = {2118, 105, 2122}
local targetTile
local pushTarget

-- Variáveis para push progressivo
local pushPath = {}
local currentPathStep = 0
local isProgressivePush = false

-- Variável para controlar se target foi definido manualmente
local isManualTarget = false

local resetData = function()
  -- Limpar textos dos tiles
  for i, tile in pairs(g_map.getTiles(posz())) do
    if tile:getText() == "TARGET" or tile:getText() == "DEST" then
      tile:setText('')
    end
  end
  
  -- Remover marcação visual do target
  if pushTarget then
    pushTarget:setMarked(nil)
  end
  
  -- Reset das variáveis
  pushTarget = nil
  targetTile = nil
  pushPath = {}
  currentPathStep = 0
  isProgressivePush = false
  isManualTarget = false
end

local isNotOk = function(t,tile)
  local tileItems = {}
  for i, item in pairs(tile:getItems()) do
    table.insert(tileItems, item:getId())
  end
  for i, field in ipairs(t) do
    if table.find(tileItems, field) then
      return true
    end
  end
  return false
end

local isOk = function(a,b)
  return getDistanceBetween(a,b) == 1
end

-- Função para calcular caminho progressivo
local function calculateProgressivePath(startPos, endPos)
  local path = {}
  local current = {x = startPos.x, y = startPos.y, z = startPos.z}
  
  while getDistanceBetween(current, endPos) > 0 do
    local next = {x = current.x, y = current.y, z = current.z}
    
    if current.x < endPos.x then
      next.x = current.x + 1
    elseif current.x > endPos.x then
      next.x = current.x - 1
    end
    
    if current.y < endPos.y then
      next.y = current.y + 1
    elseif current.y > endPos.y then
      next.y = current.y - 1
    end
    
    table.insert(path, next)
    current = next
    
    if #path > 20 then break end -- safety
  end
  
  return path
end

-- Verificar automaticamente se há target de ataque
macro(100, function()
  if not config.enabled then return end
  
  local attackingTarget = g_game.getAttackingCreature()
  
  -- Se tem target de ataque mas não tem pushTarget E não foi definido manualmente
  if attackingTarget and not pushTarget and not isManualTarget then
    local targetPos = attackingTarget:getPosition()
    -- Verificar se target está no mesmo andar
    if targetPos and targetPos.z == posz() then
      pushTarget = attackingTarget
      pushTarget:setMarked('#00FF00')
      -- Marcar tile inicial apenas uma vez
      local targetTilePos = g_map.getTile(targetPos)
      if targetTilePos then
        targetTilePos:setText('TARGET')
      end
    end
  end
  
  -- Manter marcação visual do target mesmo quando se move
  if pushTarget then
    -- Verificar se target ainda existe e está válido
    local currentPos = pushTarget:getPosition()
    if not currentPos or currentPos.z ~= posz() then
      -- Target perdido (mudou de andar, desconectou, etc) - resetar
      resetData()
      return
    end
    
    pushTarget:setMarked('#00FF00')
    -- Manter texto TARGET sempre visível na posição atual do alvo
    local currentTile = g_map.getTile(currentPos)
    if currentTile then
      currentTile:setText('TARGET')
    end
  end
  
  -- REMOVIDO: Sistema não reseta automaticamente mais - só com ESC
end)

-- Hotkey ESC para cancelar target
onKeyDown(function(keys)
  if not config.enabled then return end
  
  -- ESC cancela target
  if keys == "Escape" then
    resetData()
    return
  end
  

  
  -- Hotkey principal do sistema
  if keys ~= config.pushMaxKey then return end
  
  local tile = getTileUnderCursor()
  if not tile then return end
  
  local creature = tile:getCreatures()[1]
  
  -- Se não tem pushTarget e clicou em uma criatura
  if not pushTarget and creature then
    pushTarget = creature
    isManualTarget = true  -- Marcar como target manual
    if pushTarget then
      tile:setText('TARGET')
      pushTarget:setMarked('#00FF00')
    end
  -- Se já tem pushTarget e clicou no destino
  elseif pushTarget and not targetTile then
    -- Verificar distância máxima
    local distance = getDistanceBetween(tile:getPosition(), pushTarget:getPosition())
    if distance > config.maxDistance then
      return -- Não faz nada se muito distante, mantém target
    end
    
    tile:setText('DEST')
    targetTile = tile
    
    -- Se distância > 1, ativar push progressivo
    if distance > 1 then
      pushPath = calculateProgressivePath(pushTarget:getPosition(), targetTile:getPosition())
      currentPathStep = 1
      isProgressivePush = true
    end
  -- Se já tem target e destino, permite marcar novo destino
  elseif pushTarget and targetTile then
    -- Limpar destino anterior
    for i, tile_clear in pairs(g_map.getTiles(posz())) do
      if tile_clear:getText() == "DEST" then
        tile_clear:setText('')
      end
    end
    
    -- Verificar distância máxima para novo destino
    local distance = getDistanceBetween(tile:getPosition(), pushTarget:getPosition())
    if distance > config.maxDistance then
      return -- Não faz nada se muito distante
    end
    
    -- Definir novo destino
    tile:setText('DEST')
    targetTile = tile
    
    -- Recalcular caminho se necessário
    if distance > 1 then
      pushPath = calculateProgressivePath(pushTarget:getPosition(), targetTile:getPosition())
      currentPathStep = 1
      isProgressivePush = true
    else
      isProgressivePush = false
    end
  end
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
  if not config.enabled then return end
  
  -- REMOVIDO: Não resetar mais quando player se move
  
  -- Se o pushTarget se moveu, manter a marcação e texto
  if pushTarget and creature == pushTarget then
    -- Verificar se newPos é válido e está no mesmo andar
    if not newPos or newPos.z ~= posz() then
      -- Target mudou de andar ou posição inválida - resetar
      resetData()
      return
    end
    
    pushTarget:setMarked('#00FF00')
    -- Atualizar texto TARGET na nova posição (com verificação)
    local newTile = g_map.getTile(newPos)
    if newTile then
      newTile:setText('TARGET')
    end
    
    -- Limpar texto da posição anterior (com verificações)
    if oldPos and oldPos.z == posz() then
      local oldTile = g_map.getTile(oldPos)
      if oldTile and oldTile:getText() == 'TARGET' then
        oldTile:setText('')
      end
    end
  end
  
  -- Quando alvo chegar no destino, limpar apenas o destino (mantém target)
  if pushTarget and creature == pushTarget and targetTile and newPos then
    local targetPos = targetTile:getPosition()
    if targetPos and newPos.z == targetPos.z and getDistanceBetween(newPos, targetPos) == 0 then
    -- Limpar apenas o texto do destino
    for i, tile in pairs(g_map.getTiles(posz())) do
      if tile:getText() == "DEST" then
        tile:setText('')
      end
    end
    
    -- Reset apenas das variáveis de destino
    targetTile = nil
    pushPath = {}
    currentPathStep = 0
    isProgressivePush = false
    
    -- MANTÉM o pushTarget para permitir novos destinos
    end
  end
end)

-- Macro principal (baseada no pushmax)
macro(50, function()
  if not config.enabled then return end
  if not pushTarget or not targetTile then return end

  -- Verificar se target ainda existe antes de executar
  local targetPos = pushTarget:getPosition()
  if not targetPos or targetPos.z ~= posz() then
    -- Target perdido - resetar
    resetData()
    return
  end

  local pushDelay = tonumber(config.pushDelay)
  local customMwall = config.mwallBlockId
  
  local finalDestPos = targetTile:getPosition()
  
  -- Se push progressivo está ativo
  if isProgressivePush then
    -- Verificar se chegou no destino final
    if getDistanceBetween(targetPos, finalDestPos) == 0 then

      resetData()
      return
    end
    
    -- Recalcular caminho se necessário
    local distanceToFinal = getDistanceBetween(targetPos, finalDestPos)
    if distanceToFinal > 1 then
      pushPath = calculateProgressivePath(targetPos, finalDestPos)
      currentPathStep = 1
    end
    
    -- Se está a 1 SQM do destino final, usar push direto
    if distanceToFinal == 1 then
      local playerPos = player:getPosition()
      local playerToCreatureDistance = getDistanceBetween(playerPos, targetPos)
      
      -- Se player está muito próximo, afastar primeiro
      if playerToCreatureDistance <= 1 then
        local idealPos = {
          x = targetPos.x - (finalDestPos.x - targetPos.x),
          y = targetPos.y - (finalDestPos.y - targetPos.y), 
          z = targetPos.z
        }
        
        local idealTile = g_map.getTile(idealPos)
        if idealTile and idealTile:isWalkable() and not idealTile:hasCreature() then
          autoWalk(idealPos, true, true)
          return
        else
          return -- Não usar runa, apenas retornar
        end
      end
      
      -- Se player está bem posicionado, executar push final
      if playerToCreatureDistance >= 2 and targetTile:isWalkable() and not targetTile:hasCreature() then
        if not isNotOk(fieldTable, targetTile) then
          g_game.move(pushTarget, finalDestPos)
          return
        end
      end
      
      -- Se não conseguiu empurrar diretamente, aguardar
      if targetTile:getTimer() < pushDelay + 500 then
        return -- Aguardar timer
      end
      return
    end
    
    -- Para distâncias maiores, empurrar para o próximo passo
    if #pushPath > 0 and currentPathStep <= #pushPath then
      local nextStepPos = pushPath[currentPathStep]
      
      -- NOVA LÓGICA: Verificar posição do player em relação à criatura
      local playerPos = player:getPosition()
      local playerToCreatureDistance = getDistanceBetween(playerPos, targetPos)
      
      -- Se player está muito próximo da criatura (distância 1), afastar primeiro
      if playerToCreatureDistance <= 1 then
        -- Calcular posição ideal: na direção oposta ao destino
        local idealPos = {
          x = targetPos.x - (nextStepPos.x - targetPos.x),
          y = targetPos.y - (nextStepPos.y - targetPos.y), 
          z = targetPos.z
        }
        
        -- Verificar se a posição ideal é válida
        local idealTile = g_map.getTile(idealPos)
        if idealTile and idealTile:isWalkable() and not idealTile:hasCreature() then
          autoWalk(idealPos, true, true)
          return -- Aguardar movimento antes de tentar push
        else
          return -- Não usar runa, apenas retornar
        end
      end
      
      -- Se está a 1 SQM do próximo passo E player está bem posicionado, empurrar
      local distanceToNext = getDistanceBetween(targetPos, nextStepPos)
      if distanceToNext == 1 and playerToCreatureDistance >= 2 then
        local nextTile = g_map.getTile(nextStepPos)
        if nextTile and nextTile:isWalkable() and not nextTile:hasCreature() then
          if not isNotOk(fieldTable, nextTile) then
            g_game.move(pushTarget, nextStepPos)
            return
          end
        end
      end
      
      -- Se não conseguiu empurrar para o próximo passo, aguardar
      if targetTile:getTimer() < pushDelay + 500 then
        return -- Aguardar timer
      end
    end
    
  else
    -- Lógica original do pushmax para distância = 1
    local tilePos = targetTile:getPosition()
    if not isOk(tilePos, targetPos) then return end
    
    local tileOfTarget = g_map.getTile(targetPos)
    
    if not targetTile:isWalkable() then
      local topThing = targetTile:getTopUseThing():getId()
      if topThing == 2129 or topThing == 2130 or topThing == customMwall then
        if targetTile:getTimer() < pushDelay+500 then
          vBot.isUsing = true
          schedule(pushDelay+700, function()
            vBot.isUsing = false
          end)
        end
        if targetTile:getTimer() > pushDelay then
          return
        end
      else
        return resetData()
      end
    end

    if not tileOfTarget:getTopUseThing():isNotMoveable() and targetTile:getTimer() < pushDelay+500 then
      return -- Aguardar timer em vez de usar runa
    end
    if isNotOk(fieldTable, targetTile) then
      if targetTile:canShoot() then
        return useWith(3148, targetTile:getTopUseThing())
      else
        return
      end
    end
    g_game.move(pushTarget, tilePos)
    delay(2000)
  end
end)

