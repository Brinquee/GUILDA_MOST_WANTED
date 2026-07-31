setDefaultTab("GUILD") -- Define a aba onde o painel aparecerá

-- =============================================================================
-- [BLOCO 1] MEMÓRIA E CONFIGURAÇÕES SALVAS (STORAGE)
-- =============================================================================
if not storage.dropSettings then
    storage.dropSettings = {
        enabledMouse = false,  -- Estado do drop no mouse
        enabledChao = false,   -- Estado do drop no chão (pés)
        itemTextList = "3031, 3035, 2981", -- IDs padrões separados por vírgula
        dropSpeed = 100,       -- Velocidade do drop em milissegundos
        hotkeyMouse = "F11",   -- Hotkey para o mouse
        hotkeyChao = "F12"     -- Hotkey para os pés (chão)
    }
end

-- =============================================================================
-- [BLOCO 2] INTERFACE GRÁFICA (PAINEL DE CONFIGURAÇÕES / JANELA)
-- =============================================================================
if dropWindow then dropWindow:destroy() end

dropWindow = setupUI([[
MainWindow
  !text: tr('Painel de Drop War v6.5')
  size: 250 330
  @onEscape: self:hide()

  Label
    text: IDs dos Itens (Separe por virgula):
    anchors.top: parent.top
    anchors.left: parent.left

  TextEdit
    id: dropIdText
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5

  Label
    text: Velocidade (Milissegundos):
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8

  TextEdit
    id: speedText
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5

  Label
    text: HTK 1 - Dropar no Mouse:
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8

  TextEdit
    id: htkMouseText
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5

  Label
    text: HTK 2 - Dropar no Chao (Seus Pes):
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8

  TextEdit
    id: htkChaoText
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5

  Button
    id: closeBtn
    text: Fechar e Salvar
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
]], g_ui.getRootWidget())
dropWindow:hide()

-- =============================================================================
-- [BLOCO EXTRA] BOTÕES LADO A LADO NA MESMA LINHA (MENU LATERAL)
-- =============================================================================
if modules.dropMenuUI then modules.dropMenuUI:destroy() end

UI.Separator()

modules.dropMenuUI = setupUI([[
Panel
  height: 19

  BotSwitch
    id: btnMouse
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 65
    !text: tr('Mouse')

  BotSwitch
    id: btnChao
    anchors.top: parent.top
    anchors.left: prev.right
    margin-left: 3
    text-align: center
    width: 65
    !text: tr('Chao')

  Button
    id: edit
    anchors.top: parent.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
]])
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

-- Variáveis temporárias para controlar a repetição de 2 vezes para cada macro
local countMouse = 0
local currentIndexMouse = 1

local countChao = 0
local currentIndexChao = 1

-- =============================================================================
-- [BLOCO 3] OS DOIS CÉREBROS DOS MACROS COM REPETIÇÃO DE 2 VEZES POR ID
-- =============================================================================

-- MACRO 1: DROP NO MOUSE (Joga o mesmo item 2x antes de mudar)
local macroDropMouse = macro(storage.dropSettings.dropSpeed, "", function()
    if not storage.dropSettings.enabledMouse then return end

    local dropItemsOrder = getActiveItemIdsTable()
    if #dropItemsOrder == 0 then return end

    -- Garante que o índice atual seja válido dentro da lista
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
            
            -- Se já jogou o mesmo item 2 vezes, reseta o contador e avança pro próximo ID
            if countMouse >= 2 then
                countMouse = 0
                currentIndexMouse = currentIndexMouse + 1
                if currentIndexMouse > #dropItemsOrder then
                    currentIndexMouse = 1
                end
            end
            return -- Executa um movimento por delay
        else
            -- Se não achou esse item específico nas bolsas, pula pro próximo ID da lista
            countMouse = 0
            currentIndexMouse = currentIndexMouse + 1
        end
    end
end)

-- MACRO 2: DROP NOS PÉS / CHÃO (Joga o mesmo item 2x antes de mudar)
local macroDropChao = macro(storage.dropSettings.dropSpeed, "", function()
    if not storage.dropSettings.enabledChao then return end

    local dropItemsOrder = getActiveItemIdsTable()
    if #dropItemsOrder == 0 then return end

    -- Garante que o índice atual seja válido dentro da lista
    if currentIndexChao > #dropItemsOrder then currentIndexChao = 1 end
    local itemId = dropItemsOrder[currentIndexChao]

    local targetTile = g_map.getTile(player:getPosition())
    
    if targetTile then
        local tilePos = targetTile:getPosition()
        local dropItem = findItem(itemId)
        
        if dropItem then
            g_game.move(dropItem, tilePos, 1)
            countChao = countChao + 1
            
            -- Se já jogou o mesmo item 2 vezes, reseta o contador e avança pro próximo ID
            if countChao >= 2 then
                countChao = 0
                currentIndexChao = currentIndexChao + 1
                if currentIndexChao > #dropItemsOrder then
                    currentIndexChao = 1
                end
            end
            return -- Executa um movimento por delay
        else
            -- Se não achou esse item específico nas bolsas, pula pro próximo ID da lista
            countChao = 0
            currentIndexChao = currentIndexChao + 1
        end
    end
end)

-- Destrói fisicamente resíduos visuais se houver
if macroDropMouse and macroDropMouse.switchButton then macroDropMouse.switchButton:destroy() end
if macroDropChao and macroDropChao.switchButton then macroDropChao.switchButton:destroy() end

-- Cliques dos BotSwitches organizados na mesma linha
if modules.dropMenuUI then
    modules.dropMenuUI.btnMouse:setOn(storage.dropSettings.enabledMouse)
    modules.dropMenuUI.btnMouse.onClick = function(widget)
        storage.dropSettings.enabledMouse = not storage.dropSettings.enabledMouse
        widget:setOn(storage.dropSettings.enabledMouse)
    end

    modules.dropMenuUI.btnChao:setOn(storage.dropSettings.enabledChao)
    modules.dropMenuUI.btnChao.onClick = function(widget)
        storage.dropSettings.enabledChao = not storage.dropSettings.enabledChao
        widget:setOn(storage.dropSettings.enabledChao)
    end

    -- Botão Setup para a janela
    modules.dropMenuUI.edit.onClick = function()
        if dropWindow then
            dropWindow:show()
            dropWindow:raise()
            dropWindow:focus()
            updateDropUI()
        end
    end
end

-- =============================================================================
-- [BLOCO 4] HOTKEYS INDEPENDENTES E REFRESH DA INTERFACE
-- =============================================================================

local function pressMouseHotkey()
    storage.dropSettings.enabledMouse = not storage.dropSettings.enabledMouse
    if modules.dropMenuUI and modules.dropMenuUI.btnMouse then
        modules.dropMenuUI.btnMouse:setOn(storage.dropSettings.enabledMouse)
    end
end

local function pressChaoHotkey()
    storage.dropSettings.enabledChao = not storage.dropSettings.enabledChao
    if modules.dropMenuUI and modules.dropMenuUI.btnChao then
        modules.dropMenuUI.btnChao:setOn(storage.dropSettings.enabledChao)
    end
end

local lastMouseHtk = nil
local lastChaoHtk = nil

local function applyDualHotkeys()
    local targetMouseHtk = storage.dropSettings.hotkeyMouse
    local targetChaoHtk = storage.dropSettings.hotkeyChao

    if lastMouseHtk ~= targetMouseHtk then
        if lastMouseHtk and lastMouseHtk ~= "" then
            pcall(function() hotkey(lastMouseHtk, function() end) end)
        end
        if targetMouseHtk and targetMouseHtk ~= "" then
            local success = pcall(function() hotkey(targetMouseHtk, pressMouseHotkey) end)
            if success then lastMouseHtk = targetMouseHtk end
        end
    end

    if lastChaoHtk ~= targetChaoHtk then
        if lastChaoHtk and lastChaoHtk ~= "" then
            pcall(function() hotkey(lastChaoHtk, function() end) end)
        end
        if targetChaoHtk and targetChaoHtk ~= "" then
            local success = pcall(function() hotkey(targetChaoHtk, pressChaoHotkey) end)
            if success then lastChaoHtk = targetChaoHtk end
        end
    end
end

function updateDropUI()
    if not dropWindow then return end
    
    dropWindow.dropIdText:setText(tostring(storage.dropSettings.itemTextList))
    dropWindow.speedText:setText(tostring(storage.dropSettings.dropSpeed))
    dropWindow.htkMouseText:setText(tostring(storage.dropSettings.hotkeyMouse))
    dropWindow.htkChaoText:setText(tostring(storage.dropSettings.hotkeyChao))
    
    if modules.dropMenuUI then
        modules.dropMenuUI.btnMouse:setOn(storage.dropSettings.enabledMouse)
        modules.dropMenuUI.btnChao:setOn(storage.dropSettings.enabledChao)
    end
end

local function removeUIFocus()
    if rootWidget then rootWidget:focus() end
end

-- Sincroniza os eventos de alteração caso a janela esteja pronta
if dropWindow then
    dropWindow.dropIdText.onTextChange = function(w, text)
        storage.dropSettings.itemTextList = text
        -- Reseta os índices para evitar erros se você apagar a lista digitando
        currentIndexMouse = 1
        currentIndexChao = 1
    end

    dropWindow.speedText.onTextChange = function(w, text)
        local newSpeed = tonumber(text) or 100
        storage.dropSettings.dropSpeed = newSpeed
        macroDropMouse.delay = newSpeed 
        macroDropChao.delay = newSpeed 
    end

    -- Salva e fixa as hotkeys apenas no clique do botão de fechar para não desconfigurar jogando
    dropWindow.closeBtn.onClick = function() 
        storage.dropSettings.hotkeyMouse = dropWindow.htkMouseText:getText()
        storage.dropSettings.hotkeyChao = dropWindow.htkChaoText:getText()
        applyDualHotkeys()
        removeUIFocus()
        dropWindow:hide() 
    end
end

-- Inicializa o painel ao carregar o script com as devidas checagens de segurança
updateDropUI()
applyDualHotkeys()
