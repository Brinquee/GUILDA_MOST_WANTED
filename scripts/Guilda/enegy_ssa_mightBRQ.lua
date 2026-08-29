-- =============================================================================
-- [SOULE DEFENSE SYSTEMS V12.2] - PAINEL LADO A LADO (120PX): PARTE 1 DE 2
-- =============================================================================

setDefaultTab("hp")
UI.Separator()

-- 1. ESTRUTURA DE COMPONENTES DA INTERFACE DE BACKPACKS
g_ui.loadUIFromString([[
DefMasterBPItem < Panel
  height: 34
  margin-top: 7
  margin-left: 25
  margin-right: 25

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.verticalCenter: next.verticalCenter
    color: white

  BotItem
    id: item
    anchors.top: parent.top
    anchors.right: parent.right

DefMasterBPSwitch < Panel
  height: 30
  margin-top: 7
  margin-left: 25
  margin-right: 25

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.verticalCenter: next.verticalCenter
    color: white

  Button
    id: switch
    anchors.top: parent.top
    anchors.right: parent.right
    width: 60
    height: 20
    text: OFF
    color: red

DefMasterBPTitle < UIWidget
  height: 30
  margin-top: 20
  margin-bottom: 10
  text-align: center
  color: yellow
  font: verdana-11px-rounded

DefMasterBPWindow < MainWindow
  !text: tr('Defesa Master - Universal BP Settings')
  padding: 25

  VerticalScrollBar
    id: contentScroll
    anchors.top: parent.top
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

-- 2. CONFIGURAÇÕES, STORAGE E GERENCIADORES LOCAIS
local panelName = "Enegy_SSA_PinosDuplos_V12"

if not storage[panelName] or not storage[panelName].bpConfigs then
    storage[panelName] = {
        enabled = false,
        ringEquipId = 3051,
        ringMightId = 3048,
        ringDeffId = 33422,
        ssaId = 3081,
        normalAmuletId = 3057,
        mainBagId = 0,
        ringBagId = 0,
        ssaBagId = 0,
        energyBagId = 0,
        
        energyStop = 15,   
        energyStart = 50,  
        mightStop = 20,    
        mightStart = 75,   
        ssaStop = 10,      
        ssaStart = 60,     
        
        useSSA = false,
        bpConfigs = {
            { name = "BP MIGHT", autoOpen = true, keepSlotFree = false, targetItem = 3048 },
            { name = "BP ENERGY", autoOpen = true, keepSlotFree = false, targetItem = 3051 },
            { name = "BP SSA", autoOpen = true, keepSlotFree = false, targetItem = 3081 }
        }
    }
end
local s = storage[panelName]
local defMasterCooldowns = {}

function findItemInContainer(itemId, containerId)
    if itemId <= 0 then return nil end
    for _, container in pairs(g_game.getContainers()) do
        if containerId == 0 or container:getContainerItem():getId() == containerId then
            for _, item in pairs(container:getItems()) do
                if item:getId() == itemId then return item end
            end
        end
    end
    return nil
end

function getContainerByItemId(bagId)
    if bagId <= 0 then return nil end
    for _, container in pairs(g_game.getContainers()) do
        local containerItem = container:getContainerItem()
        if containerItem and containerItem:getId() == bagId then return container end
    end
    return nil
end

-- 3. INTERFACE PRINCIPAL (Painel Lateral HP NATIVO)
local ui = setupUI([[
Panel
  height: 40

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 125
    text: Defesa Master

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Config

  Button
    id: bpSettings
    anchors.top: title.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    height: 17
    text: BP Settings
    color: #FFA500
]], parent)

-- 4. JANELA DE CONFIGURAÇÕES COMPACTA: BARRAS LADO A LADO DE 120PX
local configWindow = setupUI([[
MainWindow
  text: Public Defense Settings (Range 120px)
  size: 540 350
  @onEscape: self:hide()

  -- COLUNA ESQUERDA: ANEIS
  Label
    id: t1
    text: --- SLOT HP | SLOT MP | SLOT PADRAO ---
    anchors.top: parent.top
    anchors.left: parent.left
    width: 245
    text-align: center
    color: green

  Panel
    id: rSlots
    anchors.top: t1.bottom
    anchors.left: parent.left
    height: 36
    width: 245
    margin-top: 5
    layout:
      type: horizontalBox
      spacing: 50
    BotItem
      id: r1
    BotItem
      id: rM
    BotItem
      id: r2

  -- ENERGY RING: BARRAS LADO A LADO DE 120PX (ESQUERDA PARAR / DIREITA PUXAR)
  Label
    id: lblE_Stop
    text: Stop HP: 15%
    anchors.top: rSlots.bottom
    anchors.left: parent.left
    width: 120
    margin-top: 8
    color: #ff6666

  Label
    id: lblE_Start
    text: Start HP: 50%
    anchors.top: rSlots.bottom
    anchors.left: lblE_Stop.right
    width: 120
    margin-top: 8
    margin-left: 5
    color: #66ff66

  HorizontalScrollBar
    id: scrollE_Stop
    anchors.top: lblE_Stop.bottom
    anchors.left: parent.left
    width: 120
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1

  HorizontalScrollBar
    id: scrollE_Start
    anchors.top: lblE_Start.bottom
    anchors.left: scrollE_Stop.right
    width: 120
    margin-top: 2
    margin-left: 5
    minimum: 1
    maximum: 100
    step: 1

  -- MIGHT RING: BARRAS LADO A LADO DE 120PX (ESQUERDA PARAR / DIREITA PUXAR)
  Label
    id: lblM_Stop
    text: Stop MP: 20%
    anchors.top: scrollE_Stop.bottom
    anchors.left: parent.left
    width: 120
    margin-top: 10
    color: #ff6666

  Label
    id: lblM_Start
    text: Start MP: 75%
    anchors.top: scrollE_Start.bottom
    anchors.left: lblM_Stop.right
    width: 120
    margin-top: 10
    margin-left: 5
    color: #66ff66

  HorizontalScrollBar
    id: scrollM_Stop
    anchors.top: lblM_Stop.bottom
    anchors.left: parent.left
    width: 120
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1

  HorizontalScrollBar
    id: scrollM_Start
    anchors.top: lblM_Start.bottom
    anchors.left: scrollM_Stop.right
    width: 120
    margin-top: 2
    margin-left: 5
    minimum: 1
    maximum: 100
    step: 1


  -- COLUNA DIREITA: AMULETOS (SSA)
  Label
    id: t2
    text: --- SLOT HP | SLOT PADRAO ---
    anchors.top: parent.top
    anchors.right: parent.right
    width: 245
    text-align: center
    color: #00FFFF

  Panel
    id: sSlots
    anchors.top: t2.bottom
    anchors.right: parent.right
    height: 36
    width: 245
    margin-top: 5
    layout:
      type: horizontalBox
      spacing: 30
    BotItem
      id: ssa
    BotItem
      id: amu

  CheckBox
    id: toggleSSA
    text: Ativar SSA
    anchors.top: sSlots.bottom
    anchors.left: sSlots.left
    width: 245
    margin-top: 10

  -- SSA: BARRAS LADO A LADO DE 120PX (ESQUERDA PARAR / DIREITA PUXAR)
  Label
    id: lblS_Stop
    text: Stop HP: 10%
    anchors.top: toggleSSA.bottom
    anchors.left: sSlots.left
    width: 120
    margin-top: 8
    color: #ff6666

  Label
    id: lblS_Start
    text: Start HP: 60%
    anchors.top: toggleSSA.bottom
    anchors.left: lblS_Stop.right
    width: 120
    margin-top: 8
    margin-left: 5
    color: #66ff66

  HorizontalScrollBar
    id: scrollS_Stop
    anchors.top: lblS_Stop.bottom
    anchors.left: sSlots.left
    width: 120
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1

  HorizontalScrollBar
    id: scrollS_Start
    anchors.top: lblS_Start.bottom
    anchors.left: scrollS_Stop.right
    width: 120
    margin-top: 2
    margin-left: 5
    minimum: 1
    maximum: 100
    step: 1


  -- SEÇÃO INFERIOR: CONFIGURAÇÃO DE BOLSAS
  Label
    id: t3
    text: --- CONFIGURACAO DE BAGS ---
    anchors.top: scrollM_Start.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-top: 20
    color: #FFA500

  Panel
    id: bagPanel
    anchors.top: t3.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 36
    margin-top: 8
    layout:
      type: horizontalBox
      spacing: 12

    Panel
      id: mainBagPanel
      width: 115
      height: 36
      layout:
        type: horizontalBox
        spacing: 3
      Label
        text: MAIN:
        margin-top: 10
      BotItem
        id: mBag

    Panel
      id: leftBagPanel
      width: 125
      height: 36
      layout:
        type: horizontalBox
        spacing: 3
      Label
        text: BP MIGHT:
        margin-top: 10
      BotItem
        id: rBag

    Panel
      id: energyBagPanel
      width: 130
      height: 36
      layout:
        type: horizontalBox
        spacing: 3
      Label
        text: BP ENERGY:
        margin-top: 10
      BotItem
        id: eBag

    Panel
      id: rightBagPanel
      width: 110
      height: 36
      layout:
        type: horizontalBox
        spacing: 3
      Label
        text: BP SSA:
        margin-top: 10
      BotItem
        id: sBag

  Button
    id: close
    text: Salvar
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    width: 120
    height: 22
]], g_ui.getRootWidget())
configWindow:hide()
-- =============================================================================
-- [SOULE DEFENSE SYSTEMS V12.2] - PAINEL LADO A LADO: PARTE 2 DE 2 (LETRA A)
-- =============================================================================

local bpSettingsWindow = UI.createWindow('DefMasterBPWindow', rootWidget)
bpSettingsWindow:hide()
bpSettingsWindow.closeButton.onClick = function(widget)
    bpSettingsWindow:hide()
end
bpSettingsWindow:setHeight(450)
bpSettingsWindow:setWidth(400)

local leftPanel = bpSettingsWindow.content.left

local addSwitch = function(id, title, defaultValue, dest, configField)
    local widget = UI.createWidget('DefMasterBPSwitch', dest)
    widget.text:setText(title)
    
    local function updateButtonState(isOn)
        if isOn then
            widget.switch:setText("ON")
            widget.switch:setColor("green")
        else
            widget.switch:setText("OFF")
            widget.switch:setColor("red")
        end
    end
    
    updateButtonState(defaultValue)
    
    widget.switch.onClick = function(button)
        local currentState = s.bpConfigs[id][configField]
        local newState = not currentState
        s.bpConfigs[id][configField] = newState
        updateButtonState(newState)
    end
end

local addItemEdit = function(id, title, defaultItem, dest, configField)
    local widget = UI.createWidget('DefMasterBPItem', dest)
    widget.text:setText(title)
    widget.item:setItemId(defaultItem or 0)
    widget.item.onItemChange = function(w)
        s.bpConfigs[id][configField] = w:getItemId()
    end
end

for i = 1, 3 do
    local bpData = s.bpConfigs[i]
    local titleWidget = UI.createWidget('DefMasterBPTitle', leftPanel)
    titleWidget:setText("=== " .. bpData.name .. " ===")
    addSwitch(i, "Auto-Open Proxima BP", bpData.autoOpen, leftPanel, "autoOpen")
    addSwitch(i, "Manter Slot Livre", bpData.keepSlotFree, leftPanel, "keepSlotFree")
    addItemEdit(i, "Item para Monitorar/Drop", bpData.targetItem, leftPanel, "targetItem")
end

-- =================================================================
-- 5. MOTOR CENTRAL DE COMBATE COM AS CONDICIONAIS DE RANGE COMPACTO
-- =================================================================
macro(100, "Defesa Master", function()
    if not s.enabled then return end
    local hp = hppercent()
    local mp = manapercent()
    local now = os.time()

    local function checkAndOpenBag(bagId, itemId)
        if bagId and bagId > 0 then
            if getContainerByItemId(bagId) then return end
            if itemId and itemId > 0 and findItemInContainer(itemId, 0) then return end
            if defMasterCooldowns[bagId] and (now - defMasterCooldowns[bagId] < 2) then return end

            local bagItem = findItemInContainer(bagId, s.mainBagId)
            if bagItem then
                g_game.use(bagItem)
                defMasterCooldowns[bagId] = now 
                delay(500)
            end
        end
    end

    if s.mainBagId and s.mainBagId > 0 then
        if not getContainerByItemId(s.mainBagId) then
            if not defMasterCooldowns[s.mainBagId] or (now - defMasterCooldowns[s.mainBagId] >= 2) then
                g_game.useInventoryItem(s.mainBagId)
                defMasterCooldowns[s.mainBagId] = now
                delay(500)
            end
        end
    end

    checkAndOpenBag(s.ringBagId, s.ringMightId)
    checkAndOpenBag(s.energyBagId, s.ringEquipId)
    checkAndOpenBag(s.ssaBagId, s.ssaId)

    local bpMapping = { s.ringBagId, s.energyBagId, s.ssaBagId }
    for i = 1, 3 do
        local bpRule = s.bpConfigs[i]
        local actualBagId = bpMapping[i]
        
        if actualBagId and actualBagId > 0 and bpRule.targetItem > 0 then
            local container = getContainerByItemId(actualBagId)
            if container then
                if bpRule.autoOpen then
                    local itemCount = 0
                    for _, item in pairs(container:getItems()) do
                        if item:getId() == bpRule.targetItem then
                            itemCount = itemCount + item:getCount()
                        end
                    end
                    if itemCount == 0 then
                        for _, item in pairs(container:getItems()) do
                            if item:isContainer() then
                                local internalId = item:getId()
                                if not defMasterCooldowns[internalId] or (now - defMasterCooldowns[internalId] >= 2) then
                                    g_game.use(item)
                                    g_game.close(container)
                                    defMasterCooldowns[internalId] = now
                                    delay(600)
                                end
                                break
                            end
                        end
                    end
                end

                if bpRule.keepSlotFree then
                    if container:getItemsCount() >= container:getCapacity() then
                        for _, item in pairs(container:getItems()) do
                            if item:getId() == bpRule.targetItem then
                                g_game.move(item, pos(), item:getCount())
                                delay(300)
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    local function organizeItems(itemId, targetBagId)
        if itemId <= 0 or s.mainBagId <= 0 then return end
        local mainContainer = getContainerByItemId(s.mainBagId)
        if not mainContainer then return end
        
        local currentRing = getFinger()
        local currentNeck = getNeck()
        local isEquipped = (currentRing and currentRing:getId() == itemId) or (currentNeck and currentNeck:getId() == itemId)
        if isEquipped then return end

        if itemId == s.ringDeffId or itemId == s.normalAmuletId then
            for _, container in pairs(g_game.getContainers()) do
                if container:getContainerItem():getId() ~= s.mainBagId then
                    for _, item in pairs(container:getItems()) do
                        if item:getId() == itemId then
                            g_game.move(item, mainContainer:getSlotPosition(mainContainer:getItemsCount()), item:getCount())
                            delay(200)
                            return
                        end
                    end
                end
            end
        else
            if targetBagId <= 0 then return end
            local targetContainer = getContainerByItemId(targetBagId)
            if not targetContainer then return end
            
            for _, container in pairs(g_game.getContainers()) do
                if container:getContainerItem():getId() ~= targetBagId then
                    for _, item in pairs(container:getItems()) do
                        if item:getId() == itemId then
                            g_game.move(item, targetContainer:getSlotPosition(targetContainer:getItemsCount()), item:getCount())
                            delay(200)
                            return
                        end
                    end
                end
            end
        end
    end
-- =============================================================================
-- [SOULE DEFENSE SYSTEMS V12.2] - PAINEL LADO A LADO: PARTE 2 DE 2 (LETRA B)
-- =============================================================================

    organizeItems(s.ringDeffId, 0)
    organizeItems(s.normalAmuletId, 0)
    organizeItems(s.ringMightId, s.ringBagId)   
    organizeItems(s.ringEquipId, s.energyBagId) 
    organizeItems(s.ssaId, s.ssaBagId)         

    local currentNeck = getNeck()
    local usarAmuletAgora = false

    -- Só ativa o SSA se o HP estiver no intervalo correto (Abaixo do Puxar E Acima do Parar)
    if s.useSSA and hp <= (s.ssaStart or 60) and hp > (s.ssaStop or 10) then
        usarAmuletAgora = true
    end

    if usarAmuletAgora then
        if not currentNeck or currentNeck:getId() ~= s.ssaId then
            local item = findItemInContainer(s.ssaId, s.ssaBagId)
            if item then moveToSlot(item, SlotNeck) end
        end
    else
        if s.normalAmuletId > 0 and (not currentNeck or currentNeck:getId() ~= s.normalAmuletId) then
            local item = findItemInContainer(s.normalAmuletId, s.mainBagId)
            if item then moveToSlot(item, SlotNeck) end
        end
    end

    local currentRing = getFinger()
    local targetRing = s.ringDeffId
    local targetBag = s.mainBagId 

    -- 1. ENERGY RING: Verifica se o HP está no intervalo (Abaixo do Puxar E Acima do Parar)
    if hp <= (s.energyStart or 50) and hp > (s.energyStop or 15) then
        targetRing = s.ringEquipId
        targetBag = s.energyBagId 
    -- 2. MIGHT RING: Verifica se a MANA está no intervalo (Abaixo do Puxar E Acima do Parar)
    elseif mp <= (s.mightStart or 75) and mp > (s.mightStop or 20) then
        targetRing = s.ringMightId
        targetBag = s.ringBagId 
    end

    if targetRing > 0 and (not currentRing or currentRing:getId() ~= targetRing) then
        local item = findItemInContainer(targetRing, targetBag)
        if item then moveToSlot(item, SlotFinger) end
    end
end)

-- =================================================================
-- 6. CONEXOES DE ACIONAMENTO DA UI COMPACTA LADO A LADO
-- =================================================================
ui.title:setOn(s.enabled)
ui.title.onClick = function(w)
    s.enabled = not s.enabled
    w:setOn(s.enabled)
end

ui.edit.onClick = function()
    configWindow:show() configWindow:raise() configWindow:focus()
end

ui.bpSettings.onClick = function()
    bpSettingsWindow:show() bpSettingsWindow:raise() bpSettingsWindow:focus()
end

configWindow.rSlots.r1:setItemId(s.ringEquipId)
configWindow.rSlots.r1.onItemChange = function(w) s.ringEquipId = w:getItemId() end

configWindow.rSlots.rM:setItemId(s.ringMightId)
configWindow.rSlots.rM.onItemChange = function(w) s.ringMightId = w:getItemId() end

configWindow.rSlots.r2:setItemId(s.ringDeffId)
configWindow.rSlots.r2.onItemChange = function(w) s.ringDeffId = w:getItemId() end

configWindow.bagPanel.mainBagPanel.mBag:setItemId(s.mainBagId)
configWindow.bagPanel.mainBagPanel.mBag.onItemChange = function(w) s.mainBagId = w:getItemId() end

configWindow.bagPanel.leftBagPanel.rBag:setItemId(s.ringBagId)
configWindow.bagPanel.leftBagPanel.rBag.onItemChange = function(w) s.ringBagId = w:getItemId() end

configWindow.bagPanel.energyBagPanel.eBag:setItemId(s.energyBagId)
configWindow.bagPanel.energyBagPanel.eBag.onItemChange = function(w) s.energyBagId = w:getItemId() end

configWindow.bagPanel.rightBagPanel.sBag:setItemId(s.ssaBagId)
configWindow.bagPanel.rightBagPanel.sBag.onItemChange = function(w) s.ssaBagId = w:getItemId() end

-- EVENTOS DE VALOR PARA AS BARRAS EMPARELHADAS EM LUA NATIVO
configWindow.scrollE_Stop.onValueChange = function(w, v)
    s.energyStop = tonumber(v) or 15
    configWindow.lblE_Stop:setText("Stop HP: " .. s.energyStop .. "%")
end
configWindow.scrollE_Start.onValueChange = function(w, v)
    s.energyStart = tonumber(v) or 50
    configWindow.lblE_Start:setText("Start HP: " .. s.energyStart .. "%")
end

configWindow.scrollM_Stop.onValueChange = function(w, v)
    s.mightStop = tonumber(v) or 20
    configWindow.lblM_Stop:setText("Stop MP: " .. s.mightStop .. "%")
end
configWindow.scrollM_Start.onValueChange = function(w, v)
    s.mightStart = tonumber(v) or 75
    configWindow.lblM_Start:setText("Start MP: " .. s.mightStart .. "%")
end

configWindow.scrollS_Stop.onValueChange = function(w, v)
    s.ssaStop = tonumber(v) or 10
    configWindow.lblS_Stop:setText("Stop HP: " .. s.ssaStop .. "%")
end
configWindow.scrollS_Start.onValueChange = function(w, v)
    s.ssaStart = tonumber(v) or 60
    configWindow.lblS_Start:setText("Start HP: " .. s.ssaStart .. "%")
end

-- Cravamento mecânico inicial sincronizado sem lags de inicialização
configWindow.scrollE_Stop:setValue(s.energyStop or 15)
configWindow.scrollE_Start:setValue(s.energyStart or 50)
configWindow.scrollM_Stop:setValue(s.mightStop or 20)
configWindow.scrollM_Start:setValue(s.mightStart or 75)
configWindow.scrollS_Stop:setValue(s.ssaStop or 10)
configWindow.scrollS_Start:setValue(s.ssaStart or 60)

configWindow.sSlots.ssa:setItemId(s.ssaId)
configWindow.sSlots.ssa.onItemChange = function(w) s.ssaId = w:getItemId() end

configWindow.sSlots.amu:setItemId(s.normalAmuletId)
configWindow.sSlots.amu.onItemChange = function(w) s.normalAmuletId = w:getItemId() end

configWindow.toggleSSA:setChecked(s.useSSA)
configWindow.toggleSSA.onCheckChange = function(w, c) s.useSSA = c end

configWindow.close.onClick = function()
    configWindow:hide()
end
UI.Separator()
