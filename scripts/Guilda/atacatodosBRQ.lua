setDefaultTab("GUILD") -- Garante que os créditos apareçam na aba HP do Healer

local targetPanelName = "targetShieldsConfigV2" -- Reset de cache para corrigir as IDs invertidas

-- Inicializa o armazenamento das configurações (Limpo e corrigido)
if type(storage[targetPanelName]) ~= "table" then
  storage[targetPanelName] = {
    attackBlue = true,    -- Caixinha Escudo Azul
    attackGreen = false,  -- Caixinha Escudo Verde
    attackRed = false,    -- Caixinha Escudo Vermelho
    attackNone = false,   -- Caixinha Sem Escudo
    range = 7
  }
end

local tConfig = storage[targetPanelName]

-- ESTRUTURA VISUAL
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
    font: sans-bold-11

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
    font: sans-bold-12

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
    font: sans-bold-12

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

-- Cria o botão principal do Macro no BotPanel
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
]])

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

-- LÓGICA DO MACRO COM AS ID'S TÉCNICAS REAIS DO TIBIA CORRIGIDAS
local attackHpMacro = macro(200, function(macroObj)
    if isInPz() or g_game.isAttacking() then return end

    local localPlayer = g_game.getLocalPlayer()
    local espectadores = g_map.getSpectators(localPlayer:getPosition(), false)
    
    local alvoEscolhido = nil
    local menorHpEncontrado = 101 

    for _, v in pairs(espectadores) do  
        if v:isPlayer() and v ~= localPlayer and getDistanceBetween(pos(), v:getPosition()) <= tConfig.range then
            local alvoEmblem = v:getEmblem()
            local podeAtacar = false

            -- CHECAGEM SINCRO: Vincula os IDs reais do jogo às caixinhas certas do painel
            if (alvoEmblem == 3 or alvoEmblem == 13) and tConfig.attackBlue then
                podeAtacar = true -- ID 3/13 é o Escudo Azul real do jogo
            elseif (alvoEmblem == 1 or alvoEmblem == 11) and tConfig.attackGreen then
                podeAtacar = true -- ID 1/11 é o Escudo Verde real do jogo
            elseif (alvoEmblem == 2 or alvoEmblem == 4 or alvoEmblem == 12 or alvoEmblem == 14) and tConfig.attackRed then
                podeAtacar = true -- ID 2/4 é o Escudo Vermelho real do jogo
            elseif alvoEmblem == 0 and tConfig.attackNone then
                podeAtacar = true -- ID 0 é quem está Sem Escudo
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

targetUi.title:setOn(attackHpMacro:isOn())
targetUi.title.onClick = function(widget)
  attackHpMacro:toggle()
  widget:setOn(attackHpMacro:isOn())
end
