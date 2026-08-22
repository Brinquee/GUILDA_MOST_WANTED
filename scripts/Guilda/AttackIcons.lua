setDefaultTab("tools")
UI.Separator()
-- 1. DECLARAÇÃO DOS ESTILOS E DA MAINWINDOW COM POPUP TEXTEDIT ATIVO (OTUI)
g_ui.loadUIFromString([[
IconTabButton < Button
  width: 120
  height: 22
  margin-left: 2

LureTextEdit < Panel
  height: 40
  margin-top: 7
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

LureItemSlot < Panel
  height: 36
  margin-top: 5
  margin-left: 10
  margin-right: 10
  UIWidget
    id: text
    anchors.left: parent.left
    anchors.verticalCenter: next.verticalCenter
    font: verdana-11px-rounded
  BotItem
    id: item
    anchors.top: parent.top
    anchors.right: parent.right

LureCheckBox < BotSwitch
  height: 20
  margin-top: 7

IconPanelWindow < MainWindow
  text: Central de Icones - Brinque
  size: 550 500
  padding: 20

  Panel
    id: tabHeader
    height: 24
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    layout:
      type: horizontalBox

  HorizontalSeparator
    id: tabSeparator
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 4

  -- ABA 1: Ocultação (Grid de Checkboxes)
  ScrollablePanel
    id: panelOcultar
    anchors.top: tabSeparator.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    margin-top: 10
    margin-bottom: 5
    vertical-scrollbar: contentScrollOcultar
    layout:
      type: grid
      cell-size: 155 22
      cell-spacing: 4
      num-columns: 3
    padding: 5

  VerticalScrollBar
    id: contentScrollOcultar
    anchors.top: tabSeparator.bottom
    anchors.right: parent.right
    anchors.bottom: separator.top
    margin-top: 10
    step: 28
    pixels-scroll: true

  -- ABA 2: Configuração UP
  ScrollablePanel
    id: panelConfigUP
    anchors.top: tabSeparator.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    margin-top: 10
    margin-bottom: 5
    vertical-scrollbar: contentScrollUP
    Panel
      id: left
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.horizontalCenter
      margin-right: 10
      height: 380
      layout:
        type: verticalBox
    Panel
      id: right
      anchors.top: parent.top
      anchors.left: parent.horizontalCenter
      anchors.right: parent.right
      margin-left: 10
      height: 380
      layout:
        type: verticalBox
    VerticalSeparator
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.horizontalCenter

  VerticalScrollBar
    id: contentScrollUP
    anchors.top: tabSeparator.bottom
    anchors.right: parent.right
    anchors.bottom: separator.top
    margin-top: 10
    step: 28
    pixels-scroll: true

  -- ABA 3: Configuração WAR
  ScrollablePanel
    id: panelConfigWAR
    anchors.top: tabSeparator.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    margin-top: 10
    margin-bottom: 5
    vertical-scrollbar: contentScrollWAR
    Panel
      id: left
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.horizontalCenter
      margin-right: 10
      height: 380
      layout:
        type: verticalBox
    Panel
      id: right
      anchors.top: parent.top
      anchors.left: parent.horizontalCenter
      anchors.right: parent.right
      margin-left: 10
      height: 380
      layout:
        type: verticalBox
    VerticalSeparator
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.horizontalCenter

  VerticalScrollBar
    id: contentScrollWAR
    anchors.top: tabSeparator.bottom
    anchors.right: parent.right
    anchors.bottom: separator.top
    margin-top: 10
    step: 28
    pixels-scroll: true

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8

  Button
    id: closeButton
    text: Fechar Painel
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 90 21
]])
-- =============================================================================
-- [BLOCO 2] INICIALIZAÇÃO DA WINDOW, TABS E NOSSO PRÓPRIO POPUP FLUTUANTE OK/CANCEL
-- =============================================================================

PainelIconManager = {}
local iconWindow = nil
local controleIcones = {}
local painelStorage = "iconPanelVisibilidade"
widgetRaizDoJogo = g_ui.getRootWidget()

-- Criação da estrutura OTUI do nosso próprio mini painel de Ok/Cancel
local popupTextEditOTUI = [[
MainWindow
  id: brinqueTextEditPopup
  size: 260 110
  text: Editar Valor
  anchors.centerIn: parent
  background-color: #1a1a1aef
  @onEscape: self:destroy()

  TextEdit
    id: inputField
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    text-align: center

  Button
    id: okButton
    text: Ok
    width: 60
    anchors.bottom: parent.bottom
    anchors.right: parent.horizontalCenter
    margin-right: 5

  Button
    id: cancelButton
    text: Cancel
    width: 60
    anchors.bottom: parent.bottom
    anchors.left: parent.horizontalCenter
    margin-left: 5
]]

schedule(100, function()
  if not widgetRaizDoJogo then return end
  iconWindow = UI.createWindow('IconPanelWindow', widgetRaizDoJogo)
  iconWindow:hide()
  storage[painelStorage] = storage[painelStorage] or {}

  local header = iconWindow.tabHeader
  local pOcultar = iconWindow.panelOcultar
  local pUP = iconWindow.panelConfigUP
  local pWAR = iconWindow.panelConfigWAR

  local btn1 = g_ui.createWidget('IconTabButton', header)
  btn1:setText('1. Ocultar Icons')
  local btn2 = g_ui.createWidget('IconTabButton', header)
  btn2:setText('2. Config UP')
  local btn3 = g_ui.createWidget('IconTabButton', header)
  btn3:setText('3. Config WAR')

  local function selectTab(tab)
    pOcultar:setVisible(tab == 1)
    iconWindow.contentScrollOcultar:setVisible(tab == 1)
    
    pUP:setVisible(tab == 2)
    iconWindow.contentScrollUP:setVisible(tab == 2)
    
    pWAR:setVisible(tab == 3)
    iconWindow.contentScrollWAR:setVisible(tab == 3)
  end

  btn1.onClick = function() selectTab(1) end
  btn2.onClick = function() selectTab(2) end
  btn3.onClick = function() selectTab(3) end

  selectTab(1)
  iconWindow.closeButton.onClick = function() iconWindow:hide() end
end)

local function getIconPriority(nome)
  local order = {
    "Safe Rune/Spell", "Safe Spells", "Safe Runes", "Attack Rune", "Full Spell",
    "PLYZE", "Exori Gran Con", "Exori Gran Hur", "Exori Gran Frigo"
  }
  for i, iconName in ipairs(order) do if nome == iconName then return i end end
  return 999
end

function reorganizarCheckboxes()
  if not iconWindow or not iconWindow.panelOcultar then return end
  table.sort(controleIcones, function(a, b) return a.priority < b.priority end)
  for _, controle in ipairs(controleIcones) do if controle.checkbox then controle.checkbox:setParent(nil) end end
  for _, controle in ipairs(controleIcones) do if controle.checkbox then controle.checkbox:setParent(iconWindow.panelOcultar) end end
end

function PainelIconManager.registrar(nome, icone, tooltip)
  for _, controle in ipairs(controleIcones) do if controle.name == nome then return end end
  if not iconWindow or not icone then 
    schedule(200, function() PainelIconManager.registrar(nome, icone, tooltip) end) return 
  end

  local checkbox = g_ui.createWidget("CheckBox", iconWindow.panelOcultar)
  checkbox:setText(nome)
  checkbox:setTooltip("Mostrar/Ocultar icone: " .. (tooltip or nome))

  local visivelSalvo = storage[painelStorage][nome]
  local visivel = visivelSalvo == nil and true or visivelSalvo
  
  checkbox:setChecked(visivel)
  icone:setVisible(visivel)

  checkbox.onCheckChange = function(_, marcado)
    icone:setVisible(marcado)
    storage[painelStorage][nome] = marcado
  end
  
  local priority = getIconPriority(nome)
  table.insert(controleIcones, {icon = icone, checkbox = checkbox, name = nome, priority = priority})
  schedule(100, function() reorganizarCheckboxes() end)
end

function addItemSlot(storageKey, titulo, defaultID, destino, tooltip)
  local widget = g_ui.createWidget('LureItemSlot', destino)
  widget.text:setText(titulo)
  if tooltip then widget.text:setTooltip(tooltip) widget.item:setTooltip(tooltip) end
  
  widget.item:setItemId(storage[storageKey] or defaultID)
  widget.item.onItemChange = function(w)
    storage[storageKey] = w:getItemId()
  end
  storage[storageKey] = storage[storageKey] or defaultID
  return widget
end

-- NOSSO PRÓPRIO DISPARADOR DE POPUP INTERNO INDEPENDENTE DE MÓDULOS DO CLIENT
function addTextEditField(storageKey, titulo, defaultText, destino)
  local widget = g_ui.createWidget('LureTextEdit', destino)
  widget.text:setText(titulo)
  
  storage[storageKey] = storage[storageKey] or defaultText
  widget.textEdit:setText(storage[storageKey])
  
  -- Trava as caixinhas pequenas para virarem botões puros e limpos de clique
  widget.textEdit:setEditable(false)
  widget.textEdit:setCursorVisible(false)

  -- GATILHO DO NOSSO POPUP PRIVADO: Força a caixinha cinza a pular na tela na hora!
  widget.textEdit.onClick = function()
    -- Destrói janelas antigas presas para não acumular lixo
    for _, child in pairs(widgetRaizDoJogo:getChildren()) do
      if child:getId() == "brinqueTextEditPopup" then child:destroy() end
    end

    -- Cria o nosso popup flutuante no meio do jogo
    local popup = g_ui.loadUIFromString(popupTextEditOTUI, widgetRaizDoJogo)
    popup:setText(titulo)
    popup.inputField:setText(storage[storageKey] or defaultText)
    popup.inputField:focus()

    -- Ação do Botão OK (Grava as alterações e atualiza a interface)
    popup.okButton.onClick = function()
      local novoTexto = popup.inputField:getText()
      storage[storageKey] = novoTexto
      widget.textEdit:setText(novoTexto)
      popup:destroy()
    end

    -- Ação do Botão Cancel (Fecha sem alterar nada)
    popup.cancelButton.onClick = function()
      popup:destroy()
    end
  end

  return widget
end

-- =============================================================================
-- [BLOCO 3] BOTÕES PvP CORRIGIDOS AMARRADOS DIRETAMENTE ÀS CHAVES DO STORAGE
-- =============================================================================

-- 1. ÍCONE: Safe UE/Rune
local i_safeRuneSpell = addIcon("safeRuneSpellIcon", {item={id=storage.iconIdSafeRuneSpell or 3150, count=1}, text="Safe R/S"}, macro(1500, function()
  local target = g_game.getAttackingCreature() if not target or not target:getPosition() then return end
  local runeID = storage.runeID or 3150 local spellText = storage.spellText or "exevo gran mas flam"
  if isSafe(8) and getDistanceBetween(pos(), target:getPosition()) <= 4 then say(spellText) else g_game.useWith(Item.create(runeID), target) end
end))
i_safeRuneSpell:setWidth(100)
PainelIconManager.registrar("Safe Rune/Spell", i_safeRuneSpell, "Usa spell em area segura, runa em area perigosa.")

-- 2. ÍCONE: Safe Spells
local i_safeSpells = addIcon("safeSpellsIcon", {item={id=storage.iconIdSafeSpells or 3071, count=1}, text="Safe Spl"}, macro(1500, function()
  local target = g_game.getAttackingCreature() if not target or not target:getPosition() then return end
  local spellText1 = storage.spellText1 or "exevo mas san" local spellText2 = storage.spellText2 or "exori con"
  if isSafe(8) and getDistanceBetween(pos(), target:getPosition()) <= 4 then say(spellText1) else say(spellText2) end
end))
i_safeSpells:setWidth(100)
PainelIconManager.registrar("Safe Spells", i_safeSpells, "Alterna entre duas spells baseado na segurança ao redor.")

-- 3. ÍCONE: Full Spell
local i_fullSpell = addIcon("fullSpellIcon", {item={id=storage.iconIdFullSpell or 8078, count=1}, text="Full Spl"}, macro(1500, function() 
  local fullSpell = storage.fullSpell or "exevo gran mas flam" say(fullSpell) 
end))
i_fullSpell:setWidth(100)
PainelIconManager.registrar("Full Spell", i_fullSpell, "Spama continuamente a magia em area configurada.")

-- 4. ÍCONE: Safe Runes Area e Single
local i_safeRunes = addIcon("safeRunesIcon", {item={id=storage.iconIdSafeRunes or 3152, count=1}, text="Safe Rns"}, macro(1500, function()
  local target = g_game.getAttackingCreature() if not target or not target:getPosition() then return end
  local safeRunesID1 = storage.safeRunesID1 or 3150 local safeRunesID2 = storage.safeRunesID2 or 3155
  if isSafe(8) and getDistanceBetween(pos(), target:getPosition()) <= 4 then g_game.useWith(Item.create(safeRunesID1), target) else g_game.useWith(Item.create(safeRunesID2), target) end
end))
i_safeRunes:setWidth(100)
PainelIconManager.registrar("Safe Runes", i_safeRunes, "Alterna entre duas runas de ataque baseado na segurança.")

-- 5. ÍCONE: Attack Rune
local i_attackRune = addIcon("attackRuneIcon", {item={id=storage.iconIdAttackRune or 3155, count=1}, text="Atk Rune"}, macro(200, function() 
  local target = g_game.getAttackingCreature() if not target then return end 
  local targetRune = storage.localName or 3155 useWith(targetRune, target)
end))
i_attackRune:setWidth(100)
PainelIconManager.registrar("Attack Rune", i_attackRune, "Usa continuamente a runa configurada no alvo.")

-- 6. ÍCONE: PLYZE (Paralyze)
local lyzeIcon = addIcon("Lyzeicon", {item={id=storage.iconIdParalyze or 11630, count=1}, text="PLYZE"}, macro(200, function()
  if g_game.isAttacking() then
    local target = g_game.getAttackingCreature()
    if target then local targetRune = storage.paralyzeRuneID or 3165 useWith(targetRune, target) delay(200) end
  end
end))
PainelIconManager.registrar("PLYZE", lyzeIcon, "Usa a runa de Paralyze configurada no alvo.")

-- 7. ÍCONE: Exori Gran Con
local i_exoriGranCon = addIcon("ExoriGranConIcon", {item={id=storage.iconIdExoriGranCon or 3239, count=1}, text="Gran Con"}, macro(200, function()
  if g_game.isAttacking() then say(storage.spellExoriGranCon or "exori gran con") delay(200) end
end))
PainelIconManager.registrar("Exori Gran Con", i_exoriGranCon, "Lança a magia de Paladin configurada.")

-- 8. ÍCONE: Exori Gran Hur
local i_exorihurCon = addIcon("Exorihuricon", {item={id=storage.iconIdExoriGranHur or 3271, count=1}, text="GranHur"}, macro(200, function()
  if g_game.isAttacking() then say(storage.spellExoriGranHur or "exori gran hur") delay(200) end
end))
PainelIconManager.registrar("Exori Gran Hur", i_exorihurCon, "Lança a magia de Knight configurada.")

-- 9. ÍCONE: Exori Gran Frigo
local i_exoriGranFrigo = addIcon("ExoriGranFrigoIcon", {item={id=storage.iconIdExoriGranFrigo or 3156, count=1}, text="GranFrig"}, macro(200, function()
  if g_game.isAttacking() then say(storage.spellExoriGranFrigo or "exori gran frigo") delay(200) end
end))
-- FIXED: Substituido 'registrarIconeLocal' por chamada direta do Gerenciador Unificado
PainelIconManager.registrar("Exori Gran Frigo", i_exoriGranFrigo, "Lança a magia de Druid configurada.")
-- =============================================================================
-- [BLOCO 4] COLUNAS FUSÃO COM TEXTEDITS E SLOTS DE RUNAS PROTEGIDOS (ERRO ZERO)
-- =============================================================================

local function buildUnifiedPanelSlots()
  -- 1. VERIFICAÇÃO EM CASCATA DA JANELA MESTRE
  if not iconWindow then
    schedule(150, buildUnifiedPanelSlots)
    return
  end

  -- 2. VERIFICAÇÃO DOS PAINÉIS DAS ABAS SECUNDÁRIAS
  local panelOcultar = iconWindow.panelOcultar
  local pUP = iconWindow.panelConfigUP
  local pWAR = iconWindow.panelConfigWAR

  if not panelOcultar or not pUP or not pWAR then
    schedule(150, buildUnifiedPanelSlots)
    return
  end

  -- 3. VERIFICAÇÃO DIRETAS DAS COLUNAS INTERNAS FÍSICAS
  local upLeft = pUP.left
  local upRight = pUP.right
  local warLeft = pWAR.left
  local warRight = pWAR.right

  if not upLeft or not upRight or not warLeft or not warRight then
    schedule(150, buildUnifiedPanelSlots)
    return
  end

  -- 4. INJEÇÃO COM FILTRAGEM LINEAR UTILIZANDO UI.CREATEWIDGET NATIVO DO BOT
  local sucesso, erro = pcall(function()
    upLeft:destroyChildren()
    upRight:destroyChildren()
    warLeft:destroyChildren()
    warRight:destroyChildren()

    -- ===========================================================================
    -- INSTANCIAÇÃO DA ABA 2: CONFIGURACAO ICONS UP (LADO ESQUERDO)
    -- ===========================================================================
    local upLabel = UI.createWidget('Label', upLeft)
    upLabel:setText("Ferramentas de Caca (UP)")
    upLabel:setColor("#00BFFF")

    -- 1. Safe UE/Rune
    addTextEditField("iconIdSafeRuneSpell", "ID Imagem Safe R/S:", "3150", upLeft)
    addItemSlot("runeID", "Runa no Alvo (ID Slot):", 3150, upLeft, "Arraste a runa single-target real para caçar em área perigosa")
    addTextEditField("spellText", "Magia de Area (UE):", "exevo gran mas flam", upLeft)

    -- 2. Safe Spells
    addTextEditField("iconIdSafeSpells", "ID Imagem Safe Spells:", "8080", upLeft)
    addTextEditField("spellText1", "Magia de Area (Seguro):", "exevo mas san", upLeft)
    addTextEditField("spellText2", "Magia Single (Alvo):", "exori con", upLeft)

    -- 3. Full Spell
    addTextEditField("iconIdFullSpell", "ID Imagem Full Spell:", "8077", upRight)
    addTextEditField("fullSpell", "Magia para Spammar:", "exevo gran mas frigo", upRight)

    -- 4. Safe Runes Area e Single
    addTextEditField("iconIdSafeRunes", "ID Imagem Safe Runes:", "11624", upRight)
    addItemSlot("safeRunesID1", "Runa Area (ID Slot):", 3161, upRight, "Arraste a runa de área para usar em SQMs seguros")
    addItemSlot("safeRunesID2", "Runa Single (ID Slot):", 3155, upRight, "Arraste a runa single para usar em SQMs perigosos")

    -- ===========================================================================
    -- INSTANCIAÇÃO DA ABA 3: CONFIGURACAO ICONS WAR (LADO DIREITO)
    -- ===========================================================================
    local warLabel = UI.createWidget('Label', warLeft)
    warLabel:setText("Ferramentas de Combate (WAR)")
    warLabel:setColor("#00BFFF")

    -- 1. Attack Rune
    addTextEditField("iconIdAttackRune", "ID Imagem Attack Rune:", "11610", warLeft)
    addItemSlot("localName", "Runa Atk no Alvo (ID Slot):", 3155, warLeft, "Arraste a runa de ataque contínuo que vai no target")

    -- 2. PLYZE (Paralyze)
    addTextEditField("iconIdParalyze", "ID Imagem PLYZE:", "11630", warLeft)
    addItemSlot("paralyzeRuneID", "Runa Paralyze (ID Slot):", 3165, warLeft, "Arraste a sua runa de Paralyze verdadeira")

    -- 3. Exori Gran Con (Paladin)
    addTextEditField("iconIdExoriGranCon", "ID Imagem Gran Con:", "8081", warRight)
    addTextEditField("spellExoriGranCon", "Magia Paladin Name:", "exori gran con", warRight)

    -- 4. Exori Gran Hur (Knight)
    addTextEditField("iconIdExoriGranHur", "ID Imagem Gran Hur:", "8078", warRight)
    addTextEditField("spellExoriGranHur", "Magia Knight Name:", "exori gran hur", warRight)

    -- 5. Exori Gran Frigo (Druid)
    addTextEditField("iconIdExoriGranFrigo", "ID Imagem Gran Frigo:", "8079", warRight)
    addTextEditField("spellExoriGranFrigo", "Magia Druid Name:", "exori gran frigo", warRight)
  end)

  if not sucesso then
    schedule(150, buildUnifiedPanelSlots)
    return
  end
end

-- Dispara o inicializador seguro
schedule(400, buildUnifiedPanelSlots)

-- Varredura de segurança contra cópias na memória RAM
if widgetRaizDoJogo then
    for _, child in pairs(widgetRaizDoJogo:getChildren()) do 
        if child:getId() == "janelaEscolhaImagensDesignMestre" then child:destroy() end
    end
end

-- =============================================================================
-- BOTÃO SUPREMO E ÚNICO CENTRALIZADO NA ABA MAIN DO BOT DO SEU PERSONAGEM
-- =============================================================================
local openUnifiedPanelButton = UI.Button("Central De Icones", function()
  if iconWindow then
    if iconWindow:isVisible() then
      iconWindow:hide()
    else
      iconWindow:show()
      iconWindow:raise()
      iconWindow:focus()
    end
  end
end)

UI.Separator()
