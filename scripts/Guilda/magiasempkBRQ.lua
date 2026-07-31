-- =============================================================================
-- [BLOCO 1] MEMÓRIA E CONFIGURAÇÕES SALVAS (STORAGE)
-- =============================================================================
setDefaultTab("tools") -- Define a aba onde o botão aparecerá

-- Inicializa a tabela de perfis por vocação se ela não existir
if not storage.comboProfiles then
    storage.comboProfiles = {
        current = "ED",
        ED = {area = "exevo gran mas frigo", single = "exori gran mort"},
        MS = {area = "exevo gran mas vis", single = "exori max vis"},
        EK = {area = "exori gran ico", single = "exori gran hur"},
        RP = {area = "exevo mas san", single = "exori gran con"}
    }
end

-- Variáveis de controle que você edita na interface (UI)
if not storage.spellCooldown then storage.spellCooldown = 2 end -- Tempo entre magias
if not storage.scanRange then storage.scanRange = 7 end          -- Distância de detecção
if not storage.globalIconId then storage.globalIconId = 37110 end -- ID do item do ícone
if not storage.iconPos then storage.iconPos = {x = 300, y = 300} end -- Posição do ícone na tela

-- =============================================================================
-- [BLOCO 2] INTERFACE GRÁFICA (DESENHO DA JANELA)
-- =============================================================================
local comboWindow = setupUI([[
MainWindow
  !text: tr('Painel de Spells v3.0')
  size: 250 380
  @onEscape: self:hide()

  Label
    text: Selecionar Perfil:
    anchors.top: parent.top
    anchors.left: parent.left

  ComboBox
    id: profileSelect
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5

  Label
    text: Magia de Area:
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8

  TextEdit
    id: areaText
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right

  Label
    text: Cooldown (Segundos):
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8

  TextEdit
    id: cooldownText
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right

  Label
    text: Distancia Scan (Range):
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8

  TextEdit
    id: rangeText
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right

  Label
    text: ID do Icone:
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8

  TextEdit
    id: iconIdText
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right

  Button
    id: closeBtn
    text: Fechar
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
]], g_ui.getRootWidget())
comboWindow:hide()

-- Texto amarelo que indica a vocação no painel lateral do bot
local statusLabel = addLabel("vocaStatus", "Perfil: " .. storage.comboProfiles.current)
statusLabel:setColor("yellow")

-- Botão principal para abrir as configurações
addButton("openSetup", "Config Spells", function()
    comboWindow:show()
    comboWindow:raise()
    comboWindow:focus()
    updateUI()
end)

-- =============================================================================
-- [BLOCO 3] O CÉREBRO DO MACRO (LÓGICA E REGRAS)
-- =============================================================================
local lastSpell = 0 -- Variável temporária para controlar o tempo do próximo cast

local comboMacro = macro(100, "Auto Combo Ajustavel", function()
    -- REGRA 1: Se a mana for menor que 30%, para tudo.
    if manapercent() < 30 then return end
    
    -- REGRA 2: Só funciona se você estiver atacando algo.
    if not g_game.isAttacking() then return end
    
    -- REGRA 3: Verifica se o tempo de espera (cooldown) já passou.
    if lastSpell > os.time() then return end 

    local p = storage.comboProfiles[storage.comboProfiles.current]
    local estranhoNaTela = false
    
    -- REGRA 4: SCAN DE SEGURANÇA (Verifica players na distância definida)
    for _, spec in ipairs(getSpectators()) do
        if spec:isPlayer() and spec ~= player then
            -- Calcula a distância entre você e o outro player
            local dist = getDistanceBetween(player:getPosition(), spec:getPosition())
            
            -- Se o player estiver dentro do Range configurado:
            if dist <= storage.scanRange then
                -- Se o player NÃO for da sua Party E NÃO for da sua Guild (Shield)
                if not spec:isPartyMember() and spec:getShield() <= 2 then
                    estranhoNaTela = true
                    break
                end
            end
        end
    end
    
    -- Se detectou alguém que não é aliado, interrompe a execução aqui.
    if estranhoNaTela then return end

    -- EXECUÇÃO FINAL: Solta a magia e define o tempo de espera para a próxima.
    if p.area ~= "" then 
        say(p.area)
        -- Soma o tempo atual + os segundos definidos na interface
        lastSpell = os.time() + storage.spellCooldown 
    end
end)

-- =============================================================================
-- [BLOCO 4] FUNÇÕES DE SINCRO (CONECTA A TELA AO CÓDIGO)
-- =============================================================================

-- Cria o ícone flutuante que liga/desliga o macro
local comboIcon = addIcon("ComboIcon", {item = storage.globalIconId, text = "SPELLS"}, comboMacro)
comboIcon:breakAnchors()
comboIcon:move(storage.iconPos.x, storage.iconPos.y)

-- Salva a posição do ícone se você arrastar ele na tela
comboIcon.onGeometryChange = function(widget, oldRect, newRect)
    storage.iconPos = {x = newRect.x, y = newRect.y}
end

-- Função que atualiza os campos da janela com os valores salvos
function updateUI()
    local current = storage.comboProfiles.current
    local data = storage.comboProfiles[current]
    
    comboWindow.areaText:setText(data.area)
    comboWindow.cooldownText:setText(tostring(storage.spellCooldown))
    comboWindow.rangeText:setText(tostring(storage.scanRange))
    comboWindow.iconIdText:setText(tostring(storage.globalIconId))
    statusLabel:setText("Perfil: " .. current)
    
    if comboIcon.item then
        comboIcon.item:setItemId(tonumber(storage.globalIconId) or 37110)
    end
end

-- Configura as opções da lista de vocações (ComboBox)
comboWindow.profileSelect:addOption("EK")
comboWindow.profileSelect:addOption("RP")
comboWindow.profileSelect:addOption("ED")
comboWindow.profileSelect:addOption("MS")
comboWindow.profileSelect:setCurrentOption(storage.comboProfiles.current)

-- Eventos que salvam os dados assim que você digita ou muda algo na janela
comboWindow.profileSelect.onOptionChange = function(w, option)
    storage.comboProfiles.current = option
    updateUI()
end

comboWindow.areaText.onTextChange = function(w, text) 
    storage.comboProfiles[storage.comboProfiles.current].area = text 
end

comboWindow.cooldownText.onTextChange = function(w, text)
    storage.spellCooldown = tonumber(text) or 1
end

comboWindow.rangeText.onTextChange = function(w, text)
    storage.scanRange = tonumber(text) or 7
end

comboWindow.iconIdText.onTextChange = function(w, text) 
    storage.globalIconId = tonumber(text) or 0
    updateUI()
end

comboWindow.closeBtn.onClick = function() comboWindow:hide() end

-- Inicializa a interface ao carregar o script
updateUI()
