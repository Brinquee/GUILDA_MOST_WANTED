-- =============================================================================
-- [BLOCO 1] DESIGN DO PAINEL PRINCIPAL E POP-UP (LAYOUTS OTUI)
-- =============================================================================

local widgetRaizDoJogo = g_ui.getRootWidget()

-- Design do Painel Flutuante de Configuracao
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaConfigChase\n" ..
"  !text: tr('Configurar Follow Chase')\n" ..
"  size: 260 295\n" ..
"  @onEscape: self:hide()\n" ..
"  Label\n" ..
"    id: lblTituloSeccao\n" ..
"    text: == CONFIGURACOES DO ICONE ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnEditarId\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarX\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 8\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarY\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 8\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarCorLigado\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 8\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarCorDesligado\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 8\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    height: 22\n"

-- Design da Janela Flutuante do Pop-Up Seguro
local designPopUpOTUI = "MainWindow\n" ..
"  id: janelaConfigChasePop\n" ..
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

-- Limpeza preventiva de lixo de memoria
if widgetRaizDoJogo:getChildById("janelaConfigChase") then
    widgetRaizDoJogo:getChildById("janelaConfigChase"):destroy()
end
if widgetRaizDoJogo:getChildById("janelaConfigChasePop") then
    widgetRaizDoJogo:getChildById("janelaConfigChasePop"):destroy()
end

-- Compilacao das telas estruturadas
local principalWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
local popUpWindow = setupUI(designPopUpOTUI, widgetRaizDoJogo)
principalWindow:hide()
popUpWindow:hide()

-- Inicializacao da memoria persistente (Storage Global)
setDefaultTab("GUILD")
if not storage.FollowChaseSetup then storage.FollowChaseSetup = {} end
if not storage.FollowChaseSetup.itemData then storage.FollowChaseSetup.itemData = 37610 end
if not storage.FollowChaseSetup.posX then storage.FollowChaseSetup.posX = 1550 end
if not storage.FollowChaseSetup.posY then storage.FollowChaseSetup.posY = 750 end
if not storage.FollowChaseSetup.corLigado then storage.FollowChaseSetup.corLigado = "green" end
if not storage.FollowChaseSetup.corDesligado then storage.FollowChaseSetup.corDesligado = "red" end

local campoModeloEditandoVal = ""
-- =============================================================================
-- [BLOCO 2] MOTORES LOGICOS E CAPTURA DE EVENTOS (LOGICA LUA) - TAMANHO DO FUNDO
-- =============================================================================

-- Instancia do macro
flwsimp = macro(250, "", function()
    if g_game.isAttacking() then
        g_game.setChaseMode(1)
    end
end)

-- Inicializacao unica do Icone Interativo
if not test1 then
    test1 = addIcon("FollowChase", {
        item = {id = storage.FollowChaseSetup.itemData}, 
        text = "Follow\nChase", 
        movable = true
    }, flwsimp)
    test1:breakAnchors()
    test1:move(storage.FollowChaseSetup.posX, storage.FollowChaseSetup.posY)
    
    -- CONTROLE DE TAMANHO DO FUNDO DO TEXTO
    if test1.text then
        test1.text:setBackgroundColor("#00000022") -- Aumentado para 70% de opacidade (fundo mais escuro)
        test1.text:setTextAutoResize(true)          -- Faz o fundo acompanhar o tamanho das letras
        
        -- AJUSTE DE ESPACAMENTO (PADDING):
        -- O primeiro numero controla o tamanho para os lados (esquerda/direita)
        -- O segundo numero controla o tamanho para cima e para baixo
        test1.text:setPadding(2, 1)                 
        
        -- TAMANHO DA FONTE (OPCIONAL):
        -- Se quiser que a letra e o fundo fiquem maiores no geral, tire os dois tracos (--) da linha abaixo
        -- test1.text:setFont("verdana-11px-rounded")
    end
    
    test1.onGeometryChange = function(widget, oldGeom, newGeom)
        storage.FollowChaseSetup.posX = newGeom.x
        storage.FollowChaseSetup.posY = newGeom.y
        if principalWindow and principalWindow:isVisible() then
            atualizarTextoDosBotoesPainel()
        end
    end
end

local function atualizarIcone()
    if not test1 then return end
    if test1.item then test1.item:setItemId(storage.FollowChaseSetup.itemData) end
    test1:move(storage.FollowChaseSetup.posX, storage.FollowChaseSetup.posY)
end

-- Loop de cores (setColoredText)
macro(400, function()
    if not test1 or not test1.text then return end
    if flwsimp:isOn() then
        test1.text:setColoredText({"\n", "white", "Flw-At", storage.FollowChaseSetup.corLigado})
    else
        test1.text:setColoredText({"\n", "white", "Flw-At", storage.FollowChaseSetup.corDesligado})
    end
end)

test1:setOn(flwsimp:isOn())
atualizarIcone()

-- Criacao do painel de controle na Aba GUILD
local painelDaAbaGUILD = getTab("GUILD")
if painelDaAbaGUILD:recursiveGetChildById("panelBotoesChaseNativos") then
    painelDaAbaGUILD:recursiveGetChildById("panelBotoesChaseNativos"):destroy()
end

local botoesLateraisUI = setupUI([[
Panel
  id: panelBotoesChaseNativos
  height: 18
  margin-top: 5
  layout:
    type: horizontalBox
    spacing: 4
  Button
    id: btnAbrePainel
    text: Setup Chase
    width: 174
]], painelDaAbaGUILD)

function dispararAberturaPopUpSeguro(chaveStorage, nomeDoCampoNoMenu)
    campoModeloEditandoVal = chaveStorage
    popUpWindow:setText("Editar: " .. nomeDoCampoNoMenu)
    local lblInfo = popUpWindow:getChildById("lblInfo")
    if lblInfo then lblInfo:setText("Digite o novo valor para " .. nomeDoCampoNoMenu .. ":") end
    local txtEntrada = popUpWindow:getChildById("txtEntrada")
    if txtEntrada then
        txtEntrada:setText(tostring(storage.FollowChaseSetup[chaveStorage] or ""))
    end
    popUpWindow:show()
    popUpWindow:raise()
    popUpWindow:focus()
    if txtEntrada then txtEntrada:focus() end
end

function atualizarTextoDosBotoesPainel()
    if not storage.FollowChaseSetup or not principalWindow then return end
    local bId = principalWindow:getChildById("btnEditarId")
    local bX = principalWindow:getChildById("btnEditarX")
    local bY = principalWindow:getChildById("btnEditarY")
    local bCL = principalWindow:getChildById("btnEditarCorLigado")
    local bCD = principalWindow:getChildById("btnEditarCorDesligado")
    if bId then bId:setText("ID do Item: " .. storage.FollowChaseSetup.itemData) end
    if bX then bX:setText("Posicao X: " .. storage.FollowChaseSetup.posX) end
    if bY then bY:setText("Posicao Y: " .. storage.FollowChaseSetup.posY) end
    if bCL then bCL:setText("Cor Ativo: " .. storage.FollowChaseSetup.corLigado) end
    if bCD then bCD:setText("Cor Inativo: " .. storage.FollowChaseSetup.corDesligado) end
end

-- Vinculacao dos cliques com getChildById
botoesLateraisUI.btnAbrePainel.onClick = function() 
    principalWindow:show() 
    principalWindow:raise() 
    principalWindow:focus() 
    atualizarTextoDosBotoesPainel() 
end

if principalWindow:getChildById("btnEditarId") then
    principalWindow:getChildById("btnEditarId").onClick = function() dispararAberturaPopUpSeguro("itemData", "ID do Item") end
end
if principalWindow:getChildById("btnEditarX") then
    principalWindow:getChildById("btnEditarX").onClick = function() dispararAberturaPopUpSeguro("posX", "Posicao X") end
end
if principalWindow:getChildById("btnEditarY") then
    principalWindow:getChildById("btnEditarY").onClick = function() dispararAberturaPopUpSeguro("posY", "Posicao Y") end
end
if principalWindow:getChildById("btnEditarCorLigado") then
    principalWindow:getChildById("btnEditarCorLigado").onClick = function() dispararAberturaPopUpSeguro("corLigado", "Cor Ativo") end
end
if principalWindow:getChildById("btnEditarCorDesligado") then
    principalWindow:getChildById("btnEditarCorDesligado").onClick = function() dispararAberturaPopUpSeguro("corDesligado", "Cor Inativo") end
end
if principalWindow:getChildById("closeBtn") then
    principalWindow:getChildById("closeBtn").onClick = function() principalWindow:hide() end
end

if popUpWindow:getChildById("btnCancelar") then
    popUpWindow:getChildById("btnCancelar").onClick = function() popUpWindow:hide() end
end
if popUpWindow:getChildById("btnConfirmar") then
    popUpWindow:getChildById("btnConfirmar").onClick = function()
        local txtEntrada = popUpWindow:getChildById("txtEntrada")
        local entradaDigitada = txtEntrada and txtEntrada:getText() or ""
        if campoModeloEditandoVal ~= "" and entradaDigitada ~= "" then
            if campoModeloEditandoVal == "itemData" then
                local valNum = tonumber(entradaDigitada)
                if valNum and valNum > 0 then storage.FollowChaseSetup.itemData = valNum end
            elseif campoModeloEditandoVal == "posX" then
                storage.FollowChaseSetup.posX = tonumber(entradaDigitada) or storage.FollowChaseSetup.posX
            elseif campoModeloEditandoVal == "posY" then
                storage.FollowChaseSetup.posY = tonumber(entradaDigitada) or storage.FollowChaseSetup.posY
            elseif campoModeloEditandoVal == "corLigado" or campoModeloEditandoVal == "corDesligado" then
                storage.FollowChaseSetup[campoModeloEditandoVal] = string.lower(entradaDigitada)
            end
        end
        popUpWindow:hide() 
        atualizarIcone()
        atualizarTextoDosBotoesPainel()
    end
end

atualizarTextoDosBotoesPainel()
