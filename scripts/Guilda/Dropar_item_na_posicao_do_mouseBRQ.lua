setDefaultTab("guild")

-- TRAVA SUPREMA ANTI-BUG: Limpa o console de resíduos antigos caso o bot retenha loops
if not updateDropUI then function updateDropUI() end end
if not updateOlheiroUI then function updateOlheiroUI() end end

local widgetRaizDoJogo = g_ui.getRootWidget()
local idPainelDrop = "janelaDropWarExemplo"
local idPainelEditDrop = "janelaDropWarEditPop"

setDefaultTab("tools") -- Define a aba onde o painel aparecerá

-- =============================================================================
-- [BLOCO 1] ARMAZENAMENTO DE DADOS (STORAGE GLOBAL)
-- =============================================================================
if not storage.dropSettings then
    storage.dropSettings = {
        enabledMouse = false,  -- Estado do drop no mouse
        enabledChao = false,   -- Estado do drop no chão (pés)
        itemTextList = "3031, 3035, 2981", -- IDs padrões separados por vírgula
        dropSpeed = 100,       -- Velocidade do drop em milissegundos
        hotkeyMouse = "F11",   -- Hotkey para o mouse
        hotkeyChao = "F12",    -- Hotkey para os pés (chão)
        useDestroy = false,    -- Estado do Auto Destroy nos pés
        destroyRuneId = 3148   -- ID padrão da runa de Destroy Field
    }
end

-- =============================================================================
-- [BLOCO 2] DESIGN DO PAINEL PRINCIPAL (TOTALMENTE SEGURO COM COLUNAS)
-- =============================================================================
local designPrincipalOTUI = "Window\n" ..
"  id: janelaDropWarExemplo\n" ..
"  !text: tr('Painel de Drop War v15.0')\n" ..
"  size: 500 240\n" ..
"  @onEscape: self:hide()\n" ..
"  Label\n" ..
"    id: lblColunaEsquerda\n" ..
"    text: == CONFIG DROP E VELOCIDADE ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 5\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnEditarIds\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarSpeed\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 8\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarDestroyId\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 8\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Label\n" ..
"    id: lblColunaDireita\n" ..
"    text: == CONFIG TECLAS HOTKEYS ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnEditarHtkMouse\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 10\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarHtkChao\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 8\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: destroyToggleBtn\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 8\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Label\n" ..
"    id: lblMarcaDaguaUniversal\n" ..
"    text: >> CUSTO FREE - BRINQUE <<\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.horizontalCenter: parent.horizontalCenter\n" ..
"    margin-bottom: 35\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-right: 4\n" ..
"    height: 22\n" ..
"  Button\n" ..
"    id: btnAcessarUrl\n" ..
"    text: Acessar Link\n" ..
"    color: #55ffff\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-left: 4\n" ..
"    height: 22\n"

local designPopUpOTUI = "Window\n" ..
"  id: janelaDropWarEditPop\n" ..
"  !text: tr('Editar Campo')\n" ..
"  size: 260 130\n" ..
"  anchors.centerIn: parent\n" ..
"  @onEscape: self:hide()\n" ..
"  Label\n" ..
"    id: lblInfo\n" ..
"    text: Digite o novo valor:\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 5\n" ..
"  TextEdit\n" ..
"    id: txtEntrada\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"  Button\n" ..
"    id: btnConfirmar\n" ..
"    text: CONFIRMAR\n" ..
"    color: green\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-right: 4\n" ..
"  Button\n" ..
"    id: btnCancelar\n" ..
"    text: Cancelar\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-left: 4\n"

dropWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
popUpEditWindow = setupUI(designPopUpOTUI, widgetRaizDoJogo)
dropWindow:hide()
popUpEditWindow:hide()
-- =============================================================================
-- [BLOCO EXTRA] BOTÕES DO MENU LATERAL COMPACTO CLÁSSICO (BOTSWITCH)
-- =============================================================================
local painelDaAbaTools = getTab("tools")
if painelDaAbaTools:recursiveGetChildById("panelDropBotoesNativos") then
    painelDaAbaTools:recursiveGetChildById("panelDropBotoesNativos"):destroy()
end

-- CORREÇÃO VISUAL CLÁSSICA: Mudado de Button para BotSwitch para herdar a luz nativa!
modules.dropMenuUI = setupUI([[
Panel
  id: panelDropBotoesNativos
  height: 19
  margin-top: 4

  BotSwitch
    id: btnMouse
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 65
    height: 17
    !text: tr('Mouse')

  BotSwitch
    id: btnChao
    anchors.top: parent.top
    anchors.left: prev.right
    margin-left: 3
    text-align: center
    width: 65
    height: 17
    !text: tr('Chao')

  Button
    id: edit
    anchors.top: parent.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
]], painelDaAbaTools)

local campoModeloEditandoVal = ""

local function dispararAberturaPopUpSeguro(chaveStorage, nomeDoCampoNoMenu)
    campoModeloEditandoVal = chaveStorage
    if popUpEditWindow then
        popUpEditWindow:setText("Editar: " .. nomeDoCampoNoMenu)
        popUpEditWindow.lblInfo:setText("Digite o novo valor para " .. nomeDoCampoNoMenu .. ":")
        
        local valorAtualNaMemoria = tostring(storage.dropSettings[chaveStorage] or "")
        popUpEditWindow.txtEntrada:setText(valorAtualNaMemoria)
        
        popUpEditWindow:show()
        popUpEditWindow:raise()
        popUpEditWindow:focus()
        popUpEditWindow.txtEntrada:focus()
    end
end
-- =============================================================================
-- [BLOCO AUXILIAR] TRANSFORMA O TEXTO DA LISTA EM UMA TABELA EM ORDEM
-- =============================================================================
local function getActiveItemIdsTable()
    local ids = {}
    if not storage.dropSettings or not storage.dropSettings.itemTextList then return ids end
    
    for idStr in string.gmatch(storage.dropSettings.itemTextList, "%d+") do
        local cleanId = tonumber(idStr)
        if cleanId then
            table.insert(ids, cleanId)
        end
    end
    return ids
end

-- Variáveis temporárias do ponto fixo de repetição 2x
local countMouse = 0
local currentIndexMouse = 1
local countChao = 0
local currentIndexChao = 1

-- MACRO 1: DROP NO MOUSE
local macroDropMouse = macro(storage.dropSettings.dropSpeed, "", function()
    if not storage.dropSettings.enabledMouse then return end

    local dropItemsOrder = getActiveItemIdsTable()
    if #dropItemsOrder == 0 then return end

    if currentIndexMouse > #dropItemsOrder then currentIndexMouse = 1 end
    local itemId = dropItemsOrder[currentIndexMouse]

    local mousePos = g_window.getMousePosition()
    local targetTile = modules.game_interface.gameMapPanel:getTile(mousePos)
    
    if targetTile then
        local tilePos = targetTile:getPosition()
        local dropItem = findItem(itemId)
        
        if dropItem then
            g_game.move(dropItem, tilePos, 1)
            countMouse = countMouse + 1
            
            if countMouse >= 2 then
                countMouse = 0
                currentIndexMouse = currentIndexMouse + 1
                if currentIndexMouse > #dropItemsOrder then currentIndexMouse = 1 end
            end
            return 
        else
            countMouse = 0
            currentIndexMouse = currentIndexMouse + 1
        end
    end
end)

-- MACRO 2: DROP NOS PÉS / CHÃO + INTELIGÊNCIA DESTROY FIELD EXATAMENTE NO SEU BONECO
local macroDropChao = macro(storage.dropSettings.dropSpeed, "", function()
    if not storage.dropSettings.enabledChao then return end

    local playerPos = player:getPosition()
    local targetTile = g_map.getTile(playerPos)
    if not targetTile then return end

    if storage.dropSettings.useDestroy then
        local topThing = targetTile:getTopThing()
        local topThingId = topThing and topThing:getId() or 0
        
        local isWarField = (topThingId >= 1487 and topThingId <= 1500) or 
                           (topThingId >= 2118 and topThingId <= 2127) or
                           topThingId == 2128 or topThingId == 2129 or topThingId == 2130

        if isWarField then
            local rune = findItem(storage.dropSettings.destroyRuneId)
            if rune then
                useWith(rune, player)
                return 
            end
        end
    end

    local dropItemsOrder = getActiveItemIdsTable()
    if #dropItemsOrder == 0 then return end

    if currentIndexChao > #dropItemsOrder then currentIndexChao = 1 end
    local itemId = dropItemsOrder[currentIndexChao]
    local tilePos = targetTile:getPosition()
    local dropItem = findItem(itemId)
    
    if dropItem then
        g_game.move(dropItem, tilePos, 1)
        countChao = countChao + 1
        
        if countChao >= 2 then
            countChao = 0
            currentIndexChao = currentIndexChao + 1
            if currentIndexChao > #dropItemsOrder then currentIndexChao = 1 end
        end
        return 
    else
        countChao = 0
        currentIndexChao = currentIndexChao + 1
    end
end)

if macroDropMouse and macroDropMouse.switchButton then macroDropMouse.switchButton:hide() end
if macroDropChao and macroDropChao.switchButton then macroDropChao.switchButton:hide() end

local function refreshDestroyBtnState(isActive)
    if not dropWindow or not dropWindow.destroyToggleBtn then return end
    if isActive then
        dropWindow.destroyToggleBtn:setText("Auto Destroy: ON")
        dropWindow.destroyToggleBtn:setColor("green")
    else
        dropWindow.destroyToggleBtn:setText("Auto Destroy: OFF")
        dropWindow.destroyToggleBtn:setColor("red")
    end
end

-- CORREÇÃO VISUAL: Usa o método nativo :setOn() para ligar e desligar os BotSwitches clássicos
local function updateMenuButtonsVisual()
    if not modules.dropMenuUI then return end
    modules.dropMenuUI.btnMouse:setOn(storage.dropSettings.enabledMouse)
    modules.dropMenuUI.btnChao:setOn(storage.dropSettings.enabledChao)
end

if modules.dropMenuUI then
    modules.dropMenuUI.btnMouse.onClick = function()
        storage.dropSettings.enabledMouse = not storage.dropSettings.enabledMouse
        updateDropUI()
    end
    modules.dropMenuUI.btnChao.onClick = function()
        storage.dropSettings.enabledChao = not storage.dropSettings.enabledChao
        updateDropUI()
    end
    modules.dropMenuUI.edit.onClick = function()
        if dropWindow then
            dropWindow:show()
            dropWindow:raise()
            dropWindow:focus()
            updateDropUI()
        end
    end
end

local function pressMouseHotkey()
    storage.dropSettings.enabledMouse = not storage.dropSettings.enabledMouse
    updateDropUI()
end

local function pressChaoHotkey()
    storage.dropSettings.enabledChao = not storage.dropSettings.enabledChao
    updateDropUI()
end

local lastMouseHtk = nil
local lastChaoHtk = nil

local function applyDualHotkeys()
    local targetMouseHtk = storage.dropSettings.hotkeyMouse
    local targetChaoHtk = storage.dropSettings.hotkeyChao

    if lastMouseHtk ~= targetMouseHtk then
        if lastMouseHtk and lastMouseHtk ~= "" then pcall(function() hotkey(lastMouseHtk, function() end) end) end
        if targetMouseHtk and targetMouseHtk ~= "" then
            local success = pcall(function() hotkey(targetMouseHtk, pressMouseHotkey) end)
            if success then lastMouseHtk = targetMouseHtk end
        end
    end

    if lastChaoHtk ~= targetChaoHtk then
        if lastChaoHtk and lastChaoHtk ~= "" then pcall(function() hotkey(lastChaoHtk, function() end) end) end
        if targetChaoHtk and targetChaoHtk ~= "" then
            local success = pcall(function() hotkey(targetChaoHtk, pressChaoHotkey) end)
            if success then lastChaoHtk = targetChaoHtk end
        end
    end
end

-- =============================================================================
-- EVENTOS DE CLIQUES E ATUALIZAÇÃO DOS POP-UPS DO SEU SCRIPT ORIGINAL
-- =============================================================================
if popUpEditWindow then
    popUpEditWindow.btnCancelar.onClick = function() popUpEditWindow:hide() end
    popUpEditWindow.btnConfirmar.onClick = function()
        local entradaDigitada = popUpEditWindow.txtEntrada:getText()
        if campoModeloEditandoVal ~= "" then
            if campoModeloEditandoVal == "dropSpeed" then
                local s = tonumber(entradaDigitada) or 100
                storage.dropSettings.dropSpeed = s
                macroDropMouse.delay = s
                macroDropChao.delay = s
            elseif campoModeloEditandoVal == "destroyRuneId" then
                storage.dropSettings.destroyRuneId = tonumber(entradaDigitada) or 3148
            elseif campoModeloEditandoVal == "itemTextList" then
                storage.dropSettings.itemTextList = entradaDigitada
                currentIndexMouse = 1
                currentIndexChao = 1
            else
                storage.dropSettings[campoModeloEditandoVal] = entradaDigitada
            end
        end
        popUpEditWindow:hide() 
        applyDualHotkeys()
        updateDropUI()
    end
end

if dropWindow then
    dropWindow.btnEditarIds.onClick = function() dispararAberturaPopUpSeguro("itemTextList", "IDs do Drop") end
    dropWindow.btnEditarSpeed.onClick = function() dispararAberturaPopUpSeguro("dropSpeed", "Velocidade ms") end
    dropWindow.btnEditarDestroyId.onClick = function() dispararAberturaPopUpSeguro("destroyRuneId", "ID Runa Destroy") end
    dropWindow.btnEditarHtkMouse.onClick = function() dispararAberturaPopUpSeguro("hotkeyMouse", "Hotkey Mouse") end
    dropWindow.btnEditarHtkChao.onClick = function() dispararAberturaPopUpSeguro("hotkeyChao", "Hotkey Chao") end
    dropWindow.destroyToggleBtn.onClick = function() storage.dropSettings.useDestroy = not storage.dropSettings.useDestroy updateDropUI() end
    dropWindow.closeBtn.onClick = function() dropWindow:hide() end

    dropWindow.btnAcessarUrl.onClick = function()
        local urlDestino = "https://discord.gg/u6cjGDg3UH"
        if g_signals and g_signals.openUrl then g_signals.openUrl(urlDestino)
        elseif g_platform and g_platform.openUrl then g_platform.openUrl(urlDestino) end
    end
end

function updateDropUI()
    if not storage.dropSettings or not dropWindow or not modules.dropMenuUI then return end
    
    dropWindow.btnEditarIds:setText("IDs Ativos: " .. storage.dropSettings.itemTextList)
    dropWindow.btnEditarSpeed:setText("Velocidade: " .. storage.dropSettings.dropSpeed .. "ms")
    dropWindow.btnEditarDestroyId:setText("ID Runa Destroy: " .. storage.dropSettings.destroyRuneId)
    dropWindow.btnEditarHtkMouse:setText("Hotkey Mouse: " .. storage.dropSettings.hotkeyMouse)
    dropWindow.btnEditarHtkChao:setText("Hotkey Chao: " .. storage.dropSettings.hotkeyChao)
    
    dropWindow.destroyToggleBtn:setOn(storage.dropSettings.useDestroy)
    dropWindow.destroyToggleBtn:setText(storage.dropSettings.useDestroy and "Auto Destroy: ON" or "Auto Destroy: OFF")
    if storage.dropSettings.useDestroy then dropWindow.destroyToggleBtn:setColor("green") else dropWindow.destroyToggleBtn:setColor("red") end

    updateMenuButtonsVisual()
end

macro(100, function()
    updateDropUI()
    if dropWindow and dropWindow:isVisible() and dropWindow.lblMarcaDaguaUniversal then
        local equacaoSeno = math.abs(math.sin(os.clock() * 4))
        local tomDeCinza = math.floor(100 + (155 * equacaoSeno))
dropWindow.lblMarcaDaguaUniversal:setColor(string.format("#%02X%02X%02X",
 tomDeCinza, tomDeCinza, tomDeCinza))
 end
 end)
 updateDropUI()
 applyDualHotkeys()
