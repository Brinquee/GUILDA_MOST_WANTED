setDefaultTab("GUILD")

local targetPanelName = "targetShieldsConfigV2"

-- Inicializa o armazenamento das configuracoes
if type(storage[targetPanelName]) ~= "table" then
  storage[targetPanelName] = {
    attackBlue = true,
    attackGreen = false,
    attackRed = false,
    attackNone = false,
    range = 7
  }
end

local tConfig = storage[targetPanelName]

-- ESTRUTURA VISUAL DA JANELA SEGURO
g_ui.loadUIFromString([[
TargetHpRow < FlatPanel
  height: 25
  margin-bottom: 3
  padding: 3

  CheckBox
    id: check
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16

  Label
    id: label
    anchors.left: check.right
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    font: verdana-11px-rounded

TargetSetupWindow < MainWindow
  !text: tr('Targeting HP Config')
  size: 340 260
  draggable: true
  @onEscape: self:hide()

  Label
    id: rangeLabel
    text: Distancia de Ataque:
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 5
    width: 140
    font: verdana-11px-rounded

  TextEdit
    id: rangeEdit
    anchors.top: parent.top
    anchors.left: rangeLabel.right
    anchors.right: parent.right
    margin-top: 3
    height: 18

  Label
    id: modeLabel
    text: Marque quais Escudos deseja ATACAR:
    anchors.top: rangeLabel.bottom
    anchors.left: parent.left
    margin-top: 12
    font: verdana-11px-rounded

  ScrollablePanel
    id: modeList
    anchors.top: modeLabel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    margin-top: 5
    margin-bottom: 5
    layout:
      type: verticalBox

  HorizontalSeparator
    id: separator
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: closeButton.top
    margin-bottom: 8

  Button
    id: closeButton
    text: Close
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    width: 90
]])

-- Cria o botao principal do Macro no BotPanel de forma segura
UI.Separator()
local targetUi = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Attack Lowest HP')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
]], getTab("GUILD"))

local targetSetupWindow = nil

local function createTargetRow(parentWidget, labelText, storageKey)
  local row = UI.createWidget("TargetHpRow", parentWidget)
  row.label:setText(labelText)
  row.check:setChecked(tConfig[storageKey])
  
  local function toggleCheck()
    tConfig[storageKey] = not tConfig[storageKey]
    row.check:setChecked(tConfig[storageKey])
  end
  
  row.check.onClick = toggleCheck
  row.onClick = toggleCheck
end

targetUi.edit.onClick = function()
  if targetSetupWindow then
    targetSetupWindow:show()
    targetSetupWindow:raise()
    targetSetupWindow:focus()
    return
  end

  targetSetupWindow = UI.createWindow("TargetSetupWindow", g_ui.getRootWidget())
  
  targetSetupWindow.rangeEdit:setText(tostring(tConfig.range))
  targetSetupWindow.rangeEdit.onTextChange = function(widget, text)
    local num = tonumber(text:trim())
    if num then tConfig.range = num end
  end

  createTargetRow(targetSetupWindow.modeList, "Atacar Escudo Azul", "attackBlue")
  createTargetRow(targetSetupWindow.modeList, "Atacar Escudo Verde", "attackGreen")
  createTargetRow(targetSetupWindow.modeList, "Atacar Escudo Vermelho", "attackRed")
  createTargetRow(targetSetupWindow.modeList, "Atacar Sem Escudo", "attackNone")

  targetSetupWindow.closeButton.onClick = function()
    targetSetupWindow:hide()
  end
end

-- LOGICA DO MACRO COM AS ID'S TECNICAS REAIS DO TIBIA
local attackHpMacro = macro(200, function(macroObj)
    if isInPz() or g_game.isAttacking() then return end

    local localPlayer = g_game.getLocalPlayer()
    if not localPlayer then return end
    
    local espectadores = g_map.getSpectators(localPlayer:getPosition(), false)
    local alvoEscolhido = nil
    local menorHpEncontrado = 101 

    for _, v in pairs(espectadores) do  
        if v:isPlayer() and v ~= localPlayer and getDistanceBetween(localPlayer:getPosition(), v:getPosition()) <= tConfig.range then
            local alvoEmblem = v:getEmblem()
            local podeAtacar = false

            -- Vincula os IDs reais do jogo as caixinhas certas do painel
            if (alvoEmblem == 3 or alvoEmblem == 13) and tConfig.attackBlue then
                podeAtacar = true 
            elseif (alvoEmblem == 1 or alvoEmblem == 11) and tConfig.attackGreen then
                podeAtacar = true 
            elseif (alvoEmblem == 2 or alvoEmblem == 4 or alvoEmblem == 12 or alvoEmblem == 14) and tConfig.attackRed then
                podeAtacar = true 
            elseif alvoEmblem == 0 and tConfig.attackNone then
                podeAtacar = true 
            end

            if podeAtacar then
                local hpDoAlvo = v:getHealthPercent()
                if hpDoAlvo < menorHpEncontrado then
                    menorHpEncontrado = hpDoAlvo
                    alvoEscolhido = v
                end
            end
        end
    end

    if alvoEscolhido then
        g_game.attack(alvoEscolhido)
    end
end)

-- CORREÇÃO: Força o macro a sempre iniciar DESLIGADO (setOff) ao abrir ou dar reload
attackHpMacro.setOff()
targetUi.title:setOn(false)

targetUi.title.onClick = function(widget)
  attackHpMacro:toggle()
  widget:setOn(attackHpMacro:isOn())
end
