setDefaultTab("HP")

-- TRAVA SUPREMA ANTI-BUG: Limpa o console de resíduos antigos caso o bot retenha loops
if not updateDropUI then function updateDropUI() end end
if not updateOlheiroUI then function updateOlheiroUI() end end

local widgetRaizDoJogo = g_ui.getRootWidget()
local idPainelBrinqueBuff = "janelaBrinqueBuffSetupVis"
local idPainelEditBrinqueBuff = "janelaBrinqueBuffPopVis"

setDefaultTab("HP") -- Aparece na aba Tools do seu menu lateral

-- =============================================================================
-- [BLOCO 1] ARMAZENAMENTO DE CONFIGURAÇÕES (TOTALMENTE SEPARADO DO COMBO)
-- =============================================================================
if not storage.brinqueBuffSimpleEngine then
    storage.brinqueBuffSimpleEngine = {
        palavraSpell = "utito tempo san",
        tempoCooldown = 2000,
        idDoIcone = 37110,
        posicaoIcone = {x = 320, y = 320}
    }
end

-- Garantia extra contra valores vazios na posição do ícone
if storage.brinqueBuffSimpleEngine and not storage.brinqueBuffSimpleEngine.posicaoIcone then
    storage.brinqueBuffSimpleEngine.posicaoIcone = {x = 320, y = 320}
end

-- =============================================================================
-- [BLOCO 2] DESIGN DO PAINEL PRINCIPAL (FIXADO NO CENTRO DA TELA DO JOGO)
-- =============================================================================
local designPrincipalOTUI = "Window\n" ..
"  id: janelaBrinqueBuffSetupVis\n" ..
"  !text: tr('Painel de Auto Buff - Brinque Script')\n" ..
"  size: 250 260\n" ..
"  anchors.centerIn: parent\n" .. -- CORREÇÃO DEFINITIVA: Força o menu a nascer sempre no centro exato da tela
"  draggable: true\n" ..
"  @onEscape: self:hide()\n" ..
"  Label\n" ..
"    id: lblTituloGeral\n" ..
"    text: == CONFIGURAR BUFF FIXO ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnConfigSpellText\n" ..
"    anchors.top: lblTituloGeral.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 12\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnConfigSpellTimer\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 8\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnConfigSpellIcon\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 8\n" ..
"    height: 24\n" ..
"  Label\n" ..
"    id: lblMarcaDagua\n" ..
"    text: >> BRINQUE SCRIPT v1.0 <<\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 12\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnAcessarUrlLink\n" ..
"    text: Acessar Discord / Link\n" ..
"    color: #55ffff\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 22\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    height: 22\n"

local designPopUpOTUI = "Window\n" ..
"  id: janelaBrinqueBuffPopVis\n" ..
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

brinqueBuffWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
popUpBrinqueBuffEditWindow = setupUI(designPopUpOTUI, widgetRaizDoJogo)
brinqueBuffWindow:hide()
popUpBrinqueBuffEditWindow:hide()

local painelDaAbaTools = getTab("tools")
if painelDaAbaTools:recursiveGetChildById("panelBrinqueBuffBotoesNativos") then
    painelDaAbaTools:recursiveGetChildById("panelBrinqueBuffBotoesNativos"):destroy()
end

botoesBrinqueBuffUI = setupUI([[
Panel
  id: panelBrinqueBuffBotoesNativos
  height: 19
  margin-top: 4

  BotSwitch
    id: btnLigaMacroDireto
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 85
    height: 17
    !text: tr('Auto Buff')

  Button
    id: btnAbrePainelBuff
    anchors.top: parent.top
    anchors.left: prev.right
    margin-left: 3
    text-align: center
    width: 85
    height: 17
    text: Config Buff
]], painelDaAbaTools)

local campoBrinqueBuffEditandoVal = ""

if not updateBrinqueBuffFixoUI then function updateBrinqueBuffFixoUI() end end

local function abrirEditorPopUpBrinqueBuff(chaveStorage, nomeDoCampoNoMenu)
    campoBrinqueBuffEditandoVal = chaveStorage
    if popUpBrinqueBuffEditWindow then
        popUpBrinqueBuffEditWindow:setText("Editar: " .. nomeDoCampoNoMenu)
        popUpBrinqueBuffEditWindow.lblInfo:setText("Digite o novo valor para " .. nomeDoCampoNoMenu .. ":")
        popUpBrinqueBuffEditWindow.txtEntrada:setText(tostring(storage.brinqueBuffSimpleEngine[chaveStorage] or ""))
        popUpBrinqueBuffEditWindow:show()
        popUpBrinqueBuffEditWindow:raise()
        popUpBrinqueBuffEditWindow:focus()
        popUpBrinqueBuffEditWindow.txtEntrada:focus()
    end
end

-- =============================================================================
-- [BLOCO 3] O CÉREBRO DO MACRO CRONOMETRADO DE AUTO BUFF
-- =============================================================================
local macroAutoBuffBrinqueFixo = macro(200, function()
    if isInPz() then return end
    if hasPartyBuff() then return end
    
    local textoMagia = storage.brinqueBuffSimpleEngine.palavraSpell
    local tempoEspera = tonumber(storage.brinqueBuffSimpleEngine.tempoCooldown) or 2000
    
    say(textoMagia)
    delay(tempoEspera)
end)

-- =============================================================================
-- GERENCIADOR GRÁFICO: ÍCONE TOTALMENTE FLUTUANTE VINCULADO AO BOTÃO PRINCIPAL
-- =============================================================================
local iconeBuffBrinqueGlobal = addIcon("IconeBuffBrinqueGlobal", {text = "BUFF", item = storage.brinqueBuffSimpleEngine.idDoIcone}, macroAutoBuffBrinqueFixo)
iconeBuffBrinqueGlobal:breakAnchors()
iconeBuffBrinqueGlobal:setDraggable(true)

if storage.brinqueBuffSimpleEngine and storage.brinqueBuffSimpleEngine.posicaoIcone then
    iconeBuffBrinqueGlobal:move(storage.brinqueBuffSimpleEngine.posicaoIcone.x, storage.brinqueBuffSimpleEngine.posicaoIcone.y)
end

-- =============================================================================
-- [BLOCO 4] FUNÇÕES DE LEITURA E SINCRONIZAÇÃO DA INTERFACE VISUAL
-- =============================================================================
function updateBrinqueBuffFixoUI()
    if not storage.brinqueBuffSimpleEngine or not brinqueBuffWindow or not botoesBrinqueBuffUI then return end
    
    local cfg = storage.brinqueBuffSimpleEngine
    brinqueBuffWindow.btnConfigSpellText:setText("Magia: " .. cfg.palavraSpell)
    brinqueBuffWindow.btnConfigSpellTimer:setText("Cooldown: " .. tostring(cfg.tempoCooldown) .. "ms")
    brinqueBuffWindow.btnConfigSpellIcon:setText("ID Icone: " .. tostring(cfg.idDoIcone))
    
    local macroAtivo = macroAutoBuffBrinqueFixo:isOn()
    botoesBrinqueBuffUI.btnLigaMacroDireto:setOn(macroAtivo)
    botoesBrinqueBuffUI.btnLigaMacroDireto:setText(macroAtivo and "Buff: ON" or "Buff: OFF")
    
    if iconeBuffBrinqueGlobal.item then
        iconeBuffBrinqueGlobal.item:setItemId(tonumber(cfg.idDoIcone) or 37063)
    end
end

botoesBrinqueBuffUI.btnLigaMacroDireto.onClick = function()
    macroAutoBuffBrinqueFixo:setOn(not macroAutoBuffBrinqueFixo:isOn())
    updateBrinqueBuffFixoUI()
end

botoesBrinqueBuffUI.btnAbrePainelBuff.onClick = function() brinqueBuffWindow:show() brinqueBuffWindow:raise() brinqueBuffWindow:focus() updateBrinqueBuffFixoUI() end

brinqueBuffWindow.btnConfigSpellText.onClick = function() abrirEditorPopUpBrinqueBuff("palavraSpell", "Palavra da Magia / Spell") end
brinqueBuffWindow.btnConfigSpellTimer.onClick = function() abrirEditorPopUpBrinqueBuff("tempoCooldown", "Tempo Cooldown ms") end
brinqueBuffWindow.btnConfigSpellIcon.onClick = function() abrirEditorPopUpBrinqueBuff("idDoIcone", "ID do Item do Icone") end
brinqueBuffWindow.closeBtn.onClick = function() brinqueBuffWindow:hide() end

brinqueBuffWindow.btnAcessarUrlLink.onClick = function()
    local urlDestino = "https://discord.gg/u6cjGDg3UH"
    if g_signals and g_signals.openUrl then g_signals.openUrl(urlDestino)
    elseif g_platform and g_platform.openUrl then g_platform.openUrl(urlDestino) end
end

if popUpBrinqueBuffEditWindow then
    popUpBrinqueBuffEditWindow.btnCancelar.onClick = function() popUpBrinqueBuffEditWindow:hide() end
    popUpBrinqueBuffEditWindow.btnConfirmar.onClick = function()
        local textoDigitado = popUpBrinqueBuffEditWindow.txtEntrada:getText()
        if campoBrinqueBuffEditandoVal ~= "" then
            if campoBrinqueBuffEditandoVal == "tempoCooldown" or campoBrinqueBuffEditandoVal == "idDoIcone" then
                storage.brinqueBuffSimpleEngine[campoBrinqueBuffEditandoVal] = tonumber(textoDigitado) or 2000
            else
                storage.brinqueBuffSimpleEngine[campoBrinqueBuffEditandoVal] = textoDigitado
            end
        end
        popUpBrinqueBuffEditWindow:hide()
        updateBrinqueBuffFixoUI()
    end
end

-- WATCHER CRONOMETRADO (GRAVAÇÃO DE POSIÇÃO DO ÍCONE FLUTUANTE)
macro(200, function()
    updateBrinqueBuffFixoUI()
    
    if iconeBuffBrinqueGlobal then
        local pos = iconeBuffBrinqueGlobal:getPosition()
        storage.brinqueBuffSimpleEngine.posicaoIcone = {x = pos.x, y = pos.y}
    end

    if brinqueBuffWindow and brinqueBuffWindow:isVisible() and brinqueBuffWindow.lblMarcaDagua then
        local equacaoSeno = math.abs(math.sin(os.clock() * 4))
        local tomDeCinza = math.floor(100 + (155 * equacaoSeno))
        brinqueBuffWindow.lblMarcaDagua:setColor(string.format("#%02X%02X%02X", tomDeCinza, tomDeCinza, tomDeCinza))
    end
end)

updateBrinqueBuffFixoUI()
