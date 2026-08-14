local widgetRaizDoJogo = g_ui.getRootWidget()

setDefaultTab("guild")

if not storage.mwallPainelConfig then
    storage.mwallPainelConfig = {}
end

local config = storage.mwallPainelConfig

-- BLINDAGEM DE STORAGE: Valores padroes limpos de acentos e prontos para o Modo 4
if config.mwMacroPeAtivo == nil then config.mwMacroPeAtivo = false end
if config.mwAutoTargetAtivo == nil then config.mwAutoTargetAtivo = false end
if config.modoCerco == nil then config.modoCerco = 0 end -- 0=Frente, 1=Parcial, 2=Total, 3=Rastro, 4=Pe Target
if not config.runeIdMwall then config.runeIdMwall = 3180 end
if not config.squaresThreshold then config.squaresThreshold = 2 end
if not config.delayTargetMw then config.delayTargetMw = 100 end

-- PAINEL LIMPO: Removidos os BotSwitches repetidos de dentro do Setup
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaMwallPainel\n" ..
"  size: 280 340\n" .. -- Reduzido o tamanho vertical pois o painel ficou limpo e compacto
"  @onEscape: self:hide()\n" ..
"  layout: anchor\n" ..
"  Label\n" ..
"    id: lblSecaoUm\n" ..
"    text: == CONFIGURACOES DE HARDWARE ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnEditarHotkey\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarRuneId\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  Label\n" ..
"    id: lblSecaoDois\n" ..
"    text: == REGRAS DO MOTOR DE ALVO ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnEditarHotkeyTarget\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarDistancia\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarDelayTarget\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnMudarModoCerco\n" .. -- Convertido para botao normal simples
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  Label\n" ..
"    id: lblMarcaDaguaUniversal\n" ..
"    text: >> BRINQUE MACROS <<\n" ..
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
"    anchors.right: parent.right\n" ..
"    height: 22\n"

local designPopUpOTUI = "MainWindow\n" ..
"  id: javaMwallPop\n" ..
"  !text: tr('Editar Campo')\n" ..
"  size: 260 130\n" ..
"  anchors.centerIn: parent\n" ..
"  @onEscape: self:hide()\n" ..
"  layout: anchor\n" ..
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

local principalWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
local mwallPopWindow = setupUI(designPopUpOTUI, widgetRaizDoJogo)
principalWindow:hide()
mwallPopWindow:hide()
local painelDaAbaGuild = getTab("guild")
if painelDaAbaGuild:recursiveGetChildById("panelBotoesMwallNativos") then
    painelDaAbaGuild:recursiveGetChildById("panelBotoesMwallNativos"):destroy()
end

-- CORRECAO RETRO: Removido anchors.fill para se ajustar de forma automatica ao menu lateral
local botoesLateraisUI = setupUI([[
Panel
  id: panelBotoesMwallNativos
  height: 22
  margin-top: 5
  layout:
    type: verticalBox

  Button
    id: btnAbrePainel
    text: Setup MW
    height: 20
    font: verdana-11px-rounded
]], painelDaAbaGuild)

local campoModeloEditandoVal = ""
local ultimoDisparoMw = 0
local ultimaPosicaoDoTarget = nil
local ultimoTargetIdRastreado = 0

local function tacarMwNaPos(pos)
    if not pos then return end
    local tile = g_map.getTile(pos)
    if tile then useWith(config.runeIdMwall or 3180, tile:getTopUseThing()) end
end

-- =============================================================================
-- [MWALL - PARTE 3 DE 4] MOTORES DE COMBATE 20MS COM O NOVO MODO 4 (PE TARGET)
-- =============================================================================

local macroTargetMw = macro(20, "MW Target", function()
    if modules.game_console:isChatEnabled() then return end
    
    local agora = os.clock() * 1000
    local delayConfigurado = config.delayTargetMw or 100
    
    if agora - ultimoDisparoMw >= delayConfigurado then
        local target = g_game.getAttackingCreature()
        if target then
            local targetPos = target:getPosition()
            local targetId = target:getId()
            
            -- MODO 4: PE DO TARGET (Taca Mwall continuamente embaixo do inimigo)
            if config.modoCerco == 4 then
                local posPeInimigo = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
                tacarMwNaPos(posPeInimigo)
                ultimoDisparoMw = agora
                
            -- MODO 3: RASTRO (Taca Mwall onde o alvo estava antes de dar o passo)
            elseif config.modoCerco == 3 then
                if ultimoTargetIdRastreado == targetId and ultimaPosicaoDoTarget then
                    if ultimaPosicaoDoTarget.x ~= targetPos.x or ultimaPosicaoDoTarget.y ~= targetPos.y or ultimaPosicaoDoTarget.z ~= targetPos.z then
                        local posAnteriorAlvo = {x = ultimaPosicaoDoTarget.x, y = ultimaPosicaoDoTarget.y, z = ultimaPosicaoDoTarget.z}
                        tacarMwNaPos(posAnteriorAlvo)
                        ultimoDisparoMw = agora
                    end
                end
                ultimaPosicaoDoTarget = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
                ultimoTargetIdRastreado = targetId
                
            else
                -- MODOS ANTERIORES (0, 1 e 2)
                local targetDir = target:getDirection()
                local threshold = config.squaresThreshold or 2
                
                if config.modoCerco == 2 then
                    -- Cerco Total: 8 SQMs ao redor
                    local direcoes8 = {
                        {x=-1, y=-1}, {x=0, y=-1}, {x=1, y=-1},
                        {x=-1, y=0},               {x=1, y=0},
                        {x=-1, y=1},  {x=0, y=1},  {x=1, y=1}
                    }
                    for _, offset in ipairs(direcoes8) do
                        local posAlvoBox = {x = targetPos.x + offset.x, y = targetPos.y + offset.y, z = targetPos.z}
                        tacarMwNaPos(posAlvoBox)
                    end
                else
                    -- Modo 0 (Frente) e Modo 1 (Parcial)
                    local posCentro = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
                    local posLadoA = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
                    local posLadoB = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
                    
                    if targetDir == 0 then
                        posCentro.y = posCentro.y - threshold
                        posLadoA.x, posLadoA.y = posLadoA.x - 1, posLadoA.y - threshold
                        posLadoB.x, posLadoB.y = posLadoB.x + 1, posLadoB.y - threshold
                    elseif targetDir == 1 then
                        posCentro.x = posCentro.x + threshold
                        posLadoA.x, posLadoA.y = posLadoA.x + threshold, posLadoA.y - 1
                        posLadoB.x, posLadoB.y = posLadoB.x + threshold, posLadoB.y + 1
                    elseif targetDir == 2 then
                        posCentro.y = posCentro.y + threshold
                        posLadoA.x, posLadoA.y = posLadoA.x - 1, posLadoA.y + threshold
                        posLadoB.x, posLadoB.y = posLadoB.x + 1, posLadoB.y + threshold
                    elseif targetDir == 3 then
                        posCentro.x = posCentro.x - threshold
                        posLadoA.x, posLadoA.y = posLadoA.x - threshold, posLadoA.y - 1
                        posLadoB.x, posLadoB.y = posLadoB.x - threshold, posLadoB.y + 1
                    end
                    
                    tacarMwNaPos(posCentro)
                    if config.modoCerco == 1 then
                        tacarMwNaPos(posLadoA)
                        tacarMwNaPos(posLadoB)
                    end
                end
                ultimoDisparoMw = agora
            end
        else
            ultimaPosicaoDoTarget = nil
            ultimoTargetIdRastreado = 0
        end
    end
end)

-- MOTOR DE MOVIMENTO (MW NO SEU PE)
local macroPeMw = macro(100, "MW Pe", function() end)

onPlayerPositionChange(function(newPos, oldPos)
    if not oldPos or oldPos.z ~= posz() then return end
    local tile = g_map.getTile(oldPos)
    if macroPeMw:isOn() and tile and tile:isWalkable() then
        useWith(config.runeIdMwall or 3180, tile:getTopUseThing())
    end
end)

-- INJEÇÃO UNIVERSAL DOS 2 ÍCONES FLUTUANTES DIRETAMENTE NA TELA (ID 3180)
local iconePe = addIcon("MwallIconPe", {item = 3180, text = "MW Pe"}, macroPeMw)
iconePe:breakAnchors()
iconePe:move(300, 290)

local iconeTarget = addIcon("MwallIconTarget", {item = 3180, text = "MW Target"}, macroTargetMw)
iconeTarget:breakAnchors()
iconeTarget:move(340, 290)
-- =============================================================================
-- [MWALL - PARTE 4 DE 4] INTERFACES DE POP-UP E ATUALIZADOR DOS MODOS DOS BOTOES
-- =============================================================================

function mwallComboBrq_abrirPopUp(chaveStorage, nomeDoCampoNoMenu)
    campoModeloEditandoVal = chaveStorage
    mwallPopWindow:setText("Editar: " .. nomeDoCampoNoMenu)
    mwallPopWindow.lblInfo:setText("Digite o novo valor para " .. nomeDoCampoNoMenu .. ":")
    mwallPopWindow.txtEntrada:setText(tostring(config[chaveStorage] or ""))
    mwallPopWindow:show() mwallPopWindow:raise() mwallPopWindow:focus() mwallPopWindow.txtEntrada:focus()
end

function atualizarTextoDosBotoesPainel()
    if not config or not principalWindow or not botoesLateraisUI then return end
    
    principalWindow.btnEditarHotkey:setText("Hotkey do Pe: " .. (config.hotkeyMwall or "F10"))
    principalWindow.btnEditarRuneId:setText("ID da Runa (MW): " .. tostring(config.runeIdMwall or 3180))
    
    principalWindow.btnEditarHotkeyTarget:setText("Hotkey Alvo: " .. (config.hotkeyTargetMw or "F5"))
    principalWindow.btnEditarDistancia:setText("Bloquear a Frente: " .. tostring(config.squaresThreshold or 2) .. " SQM")
    principalWindow.btnEditarDelayTarget:setText("Delay do Target: " .. tostring(config.delayTargetMw or 100) .. " ms")
    
    -- ATUALIZACAO DO CICLO: Adicionado o novo Modo 4 de forma limpa e estatica
    if config.modoCerco == 0 then 
        principalWindow.btnMudarModoCerco:setText("Modo Cerco: FRENTE (1 MW)")
    elseif config.modoCerco == 1 then 
        principalWindow.btnMudarModoCerco:setText("Modo Cerco: PARCIAL (3 MW)")
    elseif config.modoCerco == 2 then 
        principalWindow.btnMudarModoCerco:setText("Modo Cerco: TOTAL (8 MW)") 
    elseif config.modoCerco == 3 then 
        principalWindow.btnMudarModoCerco:setText("Modo Cerco: RASTRO (Onde estava)") 
    elseif config.modoCerco == 4 then 
        principalWindow.btnMudarModoCerco:setText("Modo Cerco: PE DO TARGET (Continuo)") 
    end
end

-- CLIQUES E SINCRONIZACOES DO PAINEL PRINCIPAL DE SETUP
botoesLateraisUI.btnAbrePainel.onClick = function() 
    principalWindow:show() principalWindow:raise() principalWindow:focus() 
    atualizarTextoDosBotoesPainel() 
end

principalWindow.btnEditarHotkey.onClick = function() mwallComboBrq_abrirPopUp("hotkeyMwall", "Hotkey do Pe") end
principalWindow.btnEditarRuneId.onClick = function() mwallComboBrq_abrirPopUp("runeIdMwall", "ID da Runa") end

principalWindow.btnEditarHotkeyTarget.onClick = function() mwallComboBrq_abrirPopUp("hotkeyTargetMw", "Hotkey do Target") end
principalWindow.btnEditarDistancia.onClick = function() mwallComboBrq_abrirPopUp("squaresThreshold", "Quantidade de SQM") end
principalWindow.btnEditarDelayTarget.onClick = function() mwallComboBrq_abrirPopUp("delayTargetMw", "Delay em Milissegundos") end

-- CICLO DE CLIQUES ATE O MODO 4 DO PE DO TARGET
principalWindow.btnMudarModoCerco.onClick = function()
    config.modoCerco = config.modoCerco + 1 
    if config.modoCerco > 4 then config.modoCerco = 0 end -- Ampliado o teto do ciclo para 4
    atualizarTextoDosBotoesPainel()
end

principalWindow.closeBtn.onClick = function() principalWindow:hide() end
mwallPopWindow.btnCancelar.onClick = function() mwallPopWindow:hide() end

mwallPopWindow.btnConfirmar.onClick = function()
    local ent = mwallPopWindow.txtEntrada:getText()
    if campoModeloEditandoVal ~= "" then
        if campoModeloEditandoVal == "runeIdMwall" or campoModeloEditandoVal == "squaresThreshold" or campoModeloEditandoVal == "delayTargetMw" then
            local valNum = tonumber(ent)
            if campoModeloEditandoVal == "delayTargetMw" then config[campoModeloEditandoVal] = valNum or 100 else config[campoModeloEditandoVal] = valNum or 2 end
        elseif campoModeloEditandoVal == "hotkeyMwall" or campoModeloEditandoVal == "hotkeyTargetMw" then
            local formattedKey = ent:trim() if formattedKey ~= "" then config[campoModeloEditandoVal] = formattedKey end
        end
    end
    mwallPopWindow:hide() atualizarTextoDosBotoesPainel()
end

macro(100, function()
    if principalWindow and principalWindow:isVisible() and principalWindow.lblMarcaDaguaUniversal then
        local eq = math.abs(math.sin(os.clock() * 4)) 
        local tom = math.floor(100 + (155 * eq))
        principalWindow.lblMarcaDaguaUniversal:setColor(string.format("#%02X%02X%02X", tom, tom, tom))
    end
end)

-- VARREDURA DE LIMPEZA RAM EXCLUSIVA DA MWALL CONTRA ELEMENTOS FANTASMAS
for _, child in pairs(widgetRaizDoJogo:getChildren()) do 
    if child:getId() == "janelaMwallPainel" and child ~= principalWindow then child:destroy() end 
    if child:getId() == "janelaMwallPop" and child ~= mwallPopWindow then child:destroy() end
end

atualizarTextoDosBotoesPainel()
