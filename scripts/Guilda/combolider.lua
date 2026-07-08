setDefaultTab("HOME")

UI.Label("PVP"):setColor("#00BFFF")
UI.Separator()
UI.Label("Multi-Lider Targeta"):setColor("#FFFFFF")

if not storage.MultiLeaderAttack then
  storage.MultiLeaderAttack = {}
end

local settings = storage.MultiLeaderAttack

if settings.enabled == nil then
  settings.enabled = true
end

-- Inicializar estado da caixinha Amigo Elf
if settings.amigoElf == nil then
  settings.amigoElf = false
end

-- Configurações dos 3 líderes
if not settings.leader1 then settings.leader1 = "Lider 1" end
if not settings.leader2 then settings.leader2 = "Lider 2" end
if not settings.leader3 then settings.leader3 = "Lider 3" end

-- UI do macro
g_ui.loadUIFromString([[
MultiLeaderTextEdit < Panel
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

MultiLeaderWindow < MainWindow
  text: Multi Leader Attack by Souleee
  size: 400 350
  padding: 25

  Label
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    text: "Configurar 3 Lideres com Prioridade"
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
      anchors.right: parent.horizontalCenter
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true
        
      CheckBox
        id: amigoElfBox
        text: Amigo Elf
        margin-bottom: 5

    Panel
      id: right
      anchors.top: parent.top
      anchors.left: parent.horizontalCenter
      anchors.right: parent.right
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true

    VerticalSeparator
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.horizontalCenter

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

-- Criar janela
MultiLeaderWindow = UI.createWindow('MultiLeaderWindow', rootWidget)
MultiLeaderWindow:hide()
MultiLeaderWindow.closeButton.onClick = function(widget)
  MultiLeaderWindow:hide()
end

MultiLeaderWindow:setHeight(350)
MultiLeaderWindow:setWidth(400)
MultiLeaderWindow:setText("Multi Leader Attack by Soule")

-- UI principal
local ui = setupUI([[
Panel
  height: 20

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    text: Multi Leader Attack

  Button
    id: push
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
]])

ui.title:setOn(settings.enabled)
ui.title.onClick = function(widget)
  settings.enabled = not settings.enabled
  widget:setOn(settings.enabled)
end

ui.push.onClick = function(widget)
  MultiLeaderWindow:show()
  MultiLeaderWindow:raise()
  MultiLeaderWindow:focus()
end

-- Painéis
local rightPanel = MultiLeaderWindow.content.right
local leftPanel = MultiLeaderWindow.content.left

-- Configurar funcionalidade e salvamento da caixinha Amigo Elf via Script
leftPanel.amigoElfBox.onCheckChange = function(widget, checked)
  settings.amigoElf = checked
end
leftPanel.amigoElfBox:setChecked(settings.amigoElf)

-- Função para adicionar campos de texto
local addTextEdit = function(id, title, defaultValue, dest, tooltip)
  local widget = UI.createWidget('MultiLeaderTextEdit', dest)
  widget.text:setText(title)
  widget.textEdit:setText(settings[id] or defaultValue or "")
  widget.text:setTooltip(tooltip)
  widget.textEdit.onTextChange = function(w, text)
    settings[id] = text
  end
  settings[id] = settings[id] or defaultValue or ""
end

-- Adicionar campos para os 3 líderes
addTextEdit("leader1", "Lider 1 (Prioridade Alta)", settings.leader1, leftPanel, "Nome do lider com maior prioridade")
addTextEdit("leader2", "Lider 2 (Prioridade Media)", settings.leader2, leftPanel, "Nome do lider com prioridade média")
addTextEdit("leader3", "Lider 3 (Prioridade Baixa)", settings.leader3, leftPanel, "Nome do lider com menor prioridade")

-- Status label
addLabel("", "Status: Aguardando lider...", rightPanel)

-- Label para informações do líder ativo
addLabel("", "Lider Ativo: Nenhum", rightPanel)

-- Variáveis para controle
local toAttack = nil
local currentLeader = nil
local currentLeaderInfo = ""

-- Monitoramento de mísseis
onMissle(function(missle)
  if not settings.enabled then return end
  
  local src = missle:getSource()
  if src.z ~= posz() then return end
  
  local from = g_map.getTile(src)
  local to = g_map.getTile(missle:getDestination())
  if not from or not to then return end
  
  local fromCreatures = from:getCreatures()
  local toCreatures = to:getCreatures()
  if #fromCreatures ~= 1 or #toCreatures ~= 1 then return end
  
  local attacker = fromCreatures[1]
  local target = toCreatures[1]
  local attackerName = attacker:getName():lower()
  
  -- Verificar se o alvo não é um amigo
  if table.find(storage.playerList.friendList, target:getName(), true) then return end
  
  -- Sistema de prioridade dos líderes
  if settings.leader1:len() > 0 and attackerName == settings.leader1:lower() then
    toAttack = target
    currentLeader = "Lider 1"
    currentLeaderInfo = "Lider 1: " .. attacker:getName() .. " ? " .. target:getName()
  elseif settings.leader2:len() > 0 and attackerName == settings.leader2:lower() then
    toAttack = target
    currentLeader = "Lider 2"
    currentLeaderInfo = "Lider 2: " .. attacker:getName() .. " ? " .. target:getName()
  elseif settings.leader3:len() > 0 and attackerName == settings.leader3:lower() then
    toAttack = target
    currentLeader = "Lider 3"
    currentLeaderInfo = "Lider 3: " .. attacker:getName() .. " ? " .. target:getName()
  end
end)

-- Macro principal de ataque
macro(1000, "Attack multi-leader's target", function()
  if not settings.enabled then return end
  
  if toAttack and toAttack ~= g_game.getAttackingCreature() then
    g_game.attack(toAttack)
    toAttack = nil
    currentLeader = nil
    currentLeaderInfo = ""
  end
end)

-- MACRO ADICIONADO: Falar Nome do Alvo (SÓ FUNCIONA COM A CAIXINHA "AMIGO ELF" MARCADA)
macro(2000, "Falar Nome do Alvo", function()
    if not settings.enabled or not settings.amigoElf then return end
    
    local target = g_game.getAttackingCreature()
    if target then
        say("." .. target:getName())
    end
end)

-- Macro para atualizar status
macro(1000, "Update multi-leader status", function()
  local statusLabel = MultiLeaderWindow.content.right:getChildByIndex(1)
  local leaderInfoLabel = MultiLeaderWindow.content.right:getChildByIndex(2)
  
  if not settings.enabled then
    statusLabel:setText("Status: Desativado")
    statusLabel:setColor("#888888")
    leaderInfoLabel:setText("Lider Ativo: Nenhum")
    leaderInfoLabel:setColor("#888888")
  elseif currentLeader then
    statusLabel:setText("Status: Seguindo " .. currentLeader)
    statusLabel:setColor("#00ff00")
    leaderInfoLabel:setText(currentLeaderInfo)
    leaderInfoLabel:setColor("#00ff00")
  else
    statusLabel:setText("Status: Aguardando lider...")
    statusLabel:setColor("#ffff00")
    leaderInfoLabel:setText("Lider Ativo: Nenhum")
    leaderInfoLabel:setColor("#ffff00")
  end
end)

-- Adicionar label na interface principal para mostrar informações do líder
local mainLeaderInfoLabel = addLabel("", "Lider Ativo: Nenhum", nil)
mainLeaderInfoLabel:setColor("#ffff00")

-- Macro para atualizar o label da interface principal
macro(1000, "Update main leader info", function()
  if not settings.enabled then
    mainLeaderInfoLabel:setText("Lider Ativo: Desativado")
    mainLeaderInfoLabel:setColor("#888888")
  elseif currentLeader then
    mainLeaderInfoLabel:setText(currentLeaderInfo)
    mainLeaderInfoLabel:setColor("#00ff00")
  else
    mainLeaderInfoLabel:setText("Lider Ativo: Aguardando...")
    mainLeaderInfoLabel:setColor("#ffff00")
  end
end)
