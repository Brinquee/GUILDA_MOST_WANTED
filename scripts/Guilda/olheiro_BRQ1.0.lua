-- =============================================================================
-- [TRAVA SUPREMA ANTI-BUG] LIMPA O CONSOLE CASO HAJA RESÍDUOS NA MEMÓRIA DO BOT
-- =============================================================================
if not updateDropUI then
    function updateDropUI()
        -- Função fantasma para blindar o console contra erros antigos de segundos planos
    end
end

local widgetRaizDoJogo = g_ui.getRootWidget()
local idPainelOlheiro = "janelaOlheiroConfig"
local idPainelEditOlheiro = "janelaOlheiroEditPop"

setDefaultTab("Cave")

-- =============================================================================
-- [BLOCO 1] ARMAZENAMENTO DE CONFIGURAÇÕES (STORAGE GLOBAL REVISADO)
-- =============================================================================
if not storage.olheiroConfigEngine then
    storage.olheiroConfigEngine = {
        macroAtiva = false,
        charUpando = "NomeDoCharDaCave", 
        msgAlerta = "pk",                 
        scanSpeed = 200,                 
        webhookUrl = "https://discord.com/api/webhooks/1532615247528067082/M5VE-ZpNbxrpXkRTYl7Xs7k-xXJn_Bq05CMvmUQ1dTPPB10CPJMP2yxNWxOkJfKKz7Yd",
        listaAliadosTexto = "Nome1, Nome2, TagGuilda"
    }
end

-- =============================================================================
-- [BLOCO 2] DESIGN DO PAINEL PRINCIPAL (SISTEMA DE JANELAS WINDOW NATIVO)
-- =============================================================================
local designPrincipalOTUI = "Window\n" ..
"  id: janelaOlheiroConfig\n" ..
"  !text: tr('Painel do Olheiro Avancado v1.0')\n" ..
"  size: 500 240\n" ..
"  @onEscape: self:hide()\n" ..
"  Label\n" ..
"    id: lblColunaEsquerda\n" ..
"    text: == CONFIG ALERTA E SUSSURRO ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 5\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnCharUpando\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 25\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnMsgAlerta\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 8\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnScanSpeed\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 8\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Label\n" ..
"    id: lblColunaDireita\n" ..
"    text: == SEGURANCA E WHITELIST ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnEditAliados\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 25\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditWebhook\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 8\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Label\n" ..
"    id: lblMarcaDagua\n" ..
"    text: >> BRINQUE SCRIPT v2.0 <<\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 15\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnAcessarUrl\n" ..
"    text: Acessar Discord / Link\n" ..
"    color: #55ffff\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 6\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 22\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    height: 22\n"

olheiroWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
olheiroWindow:hide()
-- =============================================================================
-- [BLOCO 3] DESIGN DO POP-UP SEGURO (DEVOLVE O FOCO DO TECLADO)
-- =============================================================================
local designPopUpOTUI = "Window\n" ..
"  id: janelaOlheiroEditPop\n" ..
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

popUpOlheiroEditWindow = setupUI(designPopUpOTUI, widgetRaizDoJogo)
popUpOlheiroEditWindow:hide()

function updateOlheiroUI() end

-- =============================================================================
-- [BLOCO EXTRA] BOTÕES DA ABA CAVE (TEXTURA VERDE ORIGINAL DO BOTSWITCH)
-- =============================================================================
local painelDaAbaCave = getTab("Cave")
if painelDaAbaCave:recursiveGetChildById("panelOlheiroBotoesNativos") then
    painelDaAbaCave:recursiveGetChildById("panelOlheiroBotoesNativos"):destroy()
end

botoesOlheiroUI = setupUI([[
Panel
  id: panelOlheiroBotoesNativos
  height: 19
  margin-top: 4

  BotSwitch
    id: btnLigaOlheiro
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 85
    !text: tr('Olheiro')

  Button
    id: btnAbrePainelOlheiro
    anchors.top: parent.top
    anchors.left: prev.right
    margin-left: 3
    text-align: center
    width: 85
    text: Config Olheiro
]], painelDaAbaCave)
local campoOlheiroEditandoVal = ""
local antiSpamDiscord = {} 

local function abrirEditorPopUpOlheiro(chaveStorage, nomeDoCampoNoMenu)
    campoOlheiroEditandoVal = chaveStorage
    if popUpOlheiroEditWindow then
        popUpOlheiroEditWindow:setText("Editar: " .. nomeDoCampoNoMenu)
        popUpOlheiroEditWindow.lblInfo:setText("Digite o novo valor para " .. nomeDoCampoNoMenu .. ":")
        local valorAtual = tostring(storage.olheiroConfigEngine[chaveStorage] or "")
        popUpOlheiroEditWindow.txtEntrada:setText(valorAtual)
        popUpOlheiroEditWindow:show()
        popUpOlheiroEditWindow:raise()
        popUpOlheiroEditWindow:focus()
        popUpOlheiroEditWindow.txtEntrada:focus()
    end
end

-- =============================================================================
-- CÉREBRO SINCRO: UTILIZA OS IDS REAIS DE EMBLEM DO SEU TARGET PARA FILTRAR
-- =============================================================================
local macroVarreduraOlheiro = macro(storage.olheiroConfigEngine.scanSpeed, "", function()
    if not storage.olheiroConfigEngine.macroAtiva then return end

    local targetChar = storage.olheiroConfigEngine.charUpando
    local alertText = storage.olheiroConfigEngine.msgAlerta
    local webUrl = storage.olheiroConfigEngine.webhookUrl
    
    if targetChar == "" or targetChar == "NomeDoCharDaCave" then return end

    local todosEspectadores = getSpectators()
    for _, creature in ipairs(todosEspectadores) do
        if creature:isPlayer() and creature:getName() ~= player:getName() then
            
            local inimigoNome = creature:getName()
            local inimigoNomeLower = inimigoNome:lower():trim()
            local alvoEmblem = creature:getEmblem() or 0
            
            local deveIgnorar = false

            -- 1. CHECAGEM POR WHITELIST MANUAL DE TEXTO (SE ESTIVER CADASTRADO)
            local textoLista = tostring(storage.olheiroConfigEngine.listaAliadosTexto or ""):lower()
            for aliadoToken in string.gmatch(textoLista, "[^,%s]+") do
                if inimigoNomeLower == aliadoToken or inimigoNomeLower:find(aliadoToken) then
                    deveIgnorar = true
                    break
                end
            end

            -- 2. FILTROS DE GUERRA AUTOMÁTICOS COM OS IDS REAIS DO SEU TARGET
            if alvoEmblem == 1 or alvoEmblem == 1 then
                deveIgnorar = true -- Escudo Verde
          
            elseif alvoEmblem == 2 or alvoEmblem == 4 or alvoEmblem == 12 or alvoEmblem == 14 then
                deveIgnorar = true -- Escudo Vermelho
            end

            if creature:isPartyMember() then
                deveIgnorar = true
            end

            -- SE NÃO FOR ALIADO DE NENHUM ESCUDO -> DISPARA ALERTA IMEDIATO!
            if not deveIgnorar then
                sayPrivate(targetChar, alertText)
                modules.game_textmessage.displayGameMessage("INVASOR DETECTADO: " .. inimigoNome .. "! PM Enviada.")
                
                local tempoAtual = os.time()
                if not antiSpamDiscord[inimigoNome] or (tempoAtual - antiSpamDiscord[inimigoNome]) >= 30 then
                    antiSpamDiscord[inimigoNome] = tempoAtual
                    
                    if webUrl and webUrl:find("http") then
                        local dEmbed = {
                            color = 16711680, 
                            title = "🚨 **ALERTA DE INVASÃO DETECTADO** 🚨",
                            fields = {
                                { name = "👤 Invasor na Entrada:", value = inimigoNome, inline = false },
                                { name = "📍 Status de Defesa:", value = "Fuga automatica acionada no char da cave! 🟢", inline = false }
                            },
                            footer = { ["text"] = "Monitoramento - BRINQUE SCRIPT v2.0" }
                        }
                        HTTP.postJSON(webUrl, { username = "Olheiro de Cave", embeds = { dEmbed } }, function(d, e) end)
                    end
                end
                return 
            end
        end
    end
end)

if macroVarreduraOlheiro and macroVarreduraOlheiro.switchButton then macroVarreduraOlheiro.switchButton:hide() end
function updateOlheiroUI()
    if not storage.olheiroConfigEngine or not olheiroWindow or not botoesOlheiroUI then return end
    
    olheiroWindow.btnCharUpando:setText("Char Cave: " .. storage.olheiroConfigEngine.charUpando)
    olheiroWindow.btnMsgAlerta:setText("Texto da PM: " .. storage.olheiroConfigEngine.msgAlerta)
    olheiroWindow.btnScanSpeed:setText("Velocidade: " .. tostring(storage.olheiroConfigEngine.scanSpeed) .. "ms")
    olheiroWindow.btnEditAliados:setText("Editar Lista Whitelist")
    olheiroWindow.btnEditWebhook:setText("Configurar Webhook Discord")
    
    botoesOlheiroUI.btnLigaOlheiro:setOn(storage.olheiroConfigEngine.macroAtiva)
    botoesOlheiroUI.btnLigaOlheiro:setText(storage.olheiroConfigEngine.macroAtiva and "Olheiro: ON" or "Olheiro: OFF")
end

botoesOlheiroUI.btnLigaOlheiro.onClick = function() storage.olheiroConfigEngine.macroAtiva = not storage.olheiroConfigEngine.macroAtiva updateOlheiroUI() end
botoesOlheiroUI.btnAbrePainelOlheiro.onClick = function() olheiroWindow:show() olheiroWindow:raise() olheiroWindow:focus() updateOlheiroUI() end

olheiroWindow.btnCharUpando.onClick = function() abrirEditorPopUpOlheiro("charUpando", "Nome do Char na Cave") end
olheiroWindow.btnMsgAlerta.onClick = function() abrirEditorPopUpOlheiro("msgAlerta", "Texto do Alerta") end
olheiroWindow.btnScanSpeed.onClick = function() abrirEditorPopUpOlheiro("scanSpeed", "Velocidade de Scan ms") end
olheiroWindow.btnEditAliados.onClick = function() abrirEditorPopUpOlheiro("listaAliadosTexto", "Lista de Aliados (separe por virgula)") end
olheiroWindow.btnEditWebhook.onClick = function() abrirEditorPopUpOlheiro("webhookUrl", "URL Webhook do Discord") end
olheiroWindow.closeBtn.onClick = function() olheiroWindow:hide() end

olheiroWindow.btnAcessarUrl.onClick = function()
    local urlDestino = "https://discord.gg/u6cjGDg3UH"
    if g_signals and g_signals.openUrl then g_signals.openUrl(urlDestino)
    elseif g_platform and g_platform.openUrl then g_platform.openUrl(urlDestino) end
end

if popUpOlheiroEditWindow then
    popUpOlheiroEditWindow.btnCancelar.onClick = function() popUpOlheiroEditWindow:hide() end
    popUpOlheiroEditWindow.btnConfirmar.onClick = function()
        local textoDigitado = popUpOlheiroEditWindow.txtEntrada:getText()
        if campoOlheiroEditandoVal ~= "" then
            if campoOlheiroEditandoVal == "scanSpeed" then
                local speedNum = tonumber(textoDigitado) or 200
                storage.olheiroConfigEngine.scanSpeed = speedNum
                macroVarreduraOlheiro.delay = speedNum
            else
                storage.olheiroConfigEngine[campoOlheiroEditandoVal] = textoDigitado
            end
        end
        popUpOlheiroEditWindow:hide()
        updateOlheiroUI()
    end
end

macro(100, function()
    updateOlheiroUI()
    if olheiroWindow and olheiroWindow:isVisible() and olheiroWindow.lblMarcaDagua then
        local equacaoSeno = math.abs(math.sin(os.clock() * 4))
        local tomDeCinza = math.floor(100 + (155 * equacaoSeno))
        olheiroWindow.lblMarcaDagua:setColor(string.format("#%02X%02X%02X", tomDeCinza, tomDeCinza, tomDeCinza))
    end
end)

updateOlheiroUI()
