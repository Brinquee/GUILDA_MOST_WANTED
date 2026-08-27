setDefaultTab("GUILD")

local panelName = "painelBrinqueScripts"
if type(storage[panelName]) ~= "table" then
    storage[panelName] = {
        height = 140,
        macrosMarcados = {
            antipush = true, configs = true, potguild = true, filtro = true,
            rainbow = true, skills = true, bola = true, combo = true,
            energyssa = true, stamina = true, healing = true, exiva = true,
            magias = true, fps = true, abrirbag = true
        }
    }
end

local config = storage[panelName]

-- =============================================================================
-- [PARTE 1 DE 6] BANCO DE DADOS FECHADO E DIRETÓRIO - BRINQUE SCRIPTS
-- =============================================================================
local LINK_RENOVACAO = "https://wa.me/qr/QHQWPAJNPYRDJ1" -- Seu link de atendimento
local pastaImg = "/bot/CUSTOM_PREMIUM/imagens/"

-- BANCO DE DADOS DE CLIENTES RIGIDO (Apenas IDs autorizados entram no bot)
local BANCO_DADOS_CLIENTES = {
    -- Substitua pelo seu ID definitivo "BRINQUE-GLOBAL-XXXXXXXX" que chegar no seu Discord
    ["BRINQUE-GLOBAL-8405406"] = {
        nome = "Dono Brinque Scripts",
        compra = "01/08/2026",
        vence = "ilimitado"
    },
    ["BRINQUE-GLOBAL-11111111"] = {
        nome = "Patrocinador Oficial",
        compra = "01/08/2026",
        vence = "ilimitado"
    },
	
	["BRINQUE-GLOBAL-45525429"] = {
        nome = "Marcos",
        compra = "11/08/2026",
        vence = "12/09/2026"
    },
	
    ["BRINQUE-GLOBAL-73518479"] = {
        nome = "Luiz Henrique",
        compra = "11/08/2026",
        vence = "12/09/2026"
    },
	    ["BRINQUE-GLOBAL-8481060"] = {
        nome = "Kyan Rodrigo",
        compra = "11/08/2026",
        vence = "12/09/2026"
    },
		    ["BRINQUE-GLOBAL-53228478"] = {
        nome = "Adriiano",
        compra = "11/08/2026",
        vence = "12/09/2026"
    },
		    ["BRINQUE-GLOBAL-38396807"] = {
        nome = "Matheus",
        compra = "11/08/2026",
        vence = "12/09/2026"
    },
	
    ["BRINQUE-GLOBAL-17988101"] = {
        nome = "Helio",
        compra = "11/08/2026",
        vence = "12/09/2026"
    },
    ["BRINQUE-GLOBAL-10949865"] = {
        nome = "Wesley",
        compra = "11/08/2026",
        vence = "12/09/2026"
    }
}

local LINK_INSTAGRAM = "https://www.instagram.com/brinquescriptsgamer?igsh=dXhhN2MxNWhxMm9m"
local LINK_WHATSAPP  = "https://chat.whatsapp.com/D4WHVuAy41t6uQ6QZ3ibtR"
local LINK_DISCORD   = "https://discord.gg/BRNzJ7cZjq"
local LINK_YOUTUBE   = "https://youtube.com"

local script_path = "/scripts_storage/"
-- =============================================================================
-- [PARTE 2 DE 6] STRINGS OTUI ENGENHARIZADAS (JANELAS A E B COM ANCHOR LAYOUT)
-- =============================================================================
local widgetRaizDoJogo = g_ui.getRootWidget()

-- JANELA A: AVISO DE LICENÇA (PARA CLIENTES ATIVOS COM DIAS)
local designAvisoLicencaOTUI = "MainWindow\n" ..
"  id: janelaAvisoLicenca\n" ..
"  !text: tr('Painel de Acesso - Brinque Scripts')\n" ..
"  size: 320 200\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: alpha\n" ..
"  image-border: 0\n" ..
"  border: 0 alpha\n" ..
"  padding: 0\n" ..
"  layout: anchor\n" .. -- Injeção mestre para destravar as âncoras no tema Retro
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoAviso\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/M_custompremium.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.fill: parent\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #00000030\n" ..
"    anchors.fill: parent\n" ..
"    phantom: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblNomeCliente\n" ..
"    text: Cliente: Carregando...\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 15\n" ..
"    margin-left: 20\n" ..
"\n" ..
"  Label\n" ..
"    id: lblDiasRestantes\n" ..
"    text: Status do Acesso: Calculando...\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: lblNomeCliente.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 12\n" ..
"    margin-left: 20\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoBtnRenovar\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: lblDiasRestantes.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -40\n" ..
"    margin-left: 30\n" ..
"    margin-right: 30\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnRenovar\n" ..
"    text: Renovar / Prolongar Dias\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -24\n" ..
"    phantom: false\n" ..
"    anchors.fill: imgFundoBtnRenovar\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    font: cipsoftFont\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-left: 20\n" ..
"    margin-right: 20\n" ..
"    margin-bottom: 8\n" ..
"    height: 18\n"

-- JANELA B: TELA DE BLOQUEIO PARA QUANDO O MODO LIVRE FOR DESLIGADO NO FUTURO
local designBloqueioHWIDOTUI = "MainWindow\n" ..
"  id: janelaBloqueioHWID\n" ..
"  !text: tr('Acesso Negado - Brinque Scripts')\n" ..
"  size: 340 230\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: alpha\n" ..
"  image-border: 0\n" ..
"  border: 0 alpha\n" ..
"  padding: 0\n" ..
"  layout: anchor\n" .. -- Destrava o alinhamento das imagens e caixas de texto
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoBloqueio\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/M_custompremium.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.fill: parent\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #00000040\n" ..
"    anchors.fill: parent\n" ..
"    phantom: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblMsgBloqueio\n" ..
"    text: Seu computador nao esta registrado!\\nEnvie o codigo abaixo para o Administrador.\\nPara liberar o seu acesso de forma imediata.\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ff4444\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    margin-left: 10\n" ..
"    margin-right: 10\n" ..
"    height: 50\n" ..
"\n" ..
"  Label\n" ..
"    id: lblCodigoPC\n" ..
"    text: ID DO PC: ...\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #FFD700\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    anchors.top: lblMsgBloqueio.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    height: 16\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoBtnSuporte\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: lblCodigoPC.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -20\n" ..
"    margin-left: 40\n" ..
"    margin-right: 40\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnFalarAdmin\n" ..
"    text: Enviar ID para o Suporte\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -23\n" ..
"    phantom: false\n" ..
"    anchors.fill: imgFundoBtnSuporte\n"
-- =============================================================================
-- [PARTE 3 DE 6] STRING OTUI - PAINEL PRINCIPAL DE MACROS (ANCHOR LAYOUT)
-- =============================================================================
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaEscolhaMacros\n" ..
"  size: 560 380\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: alpha\n" ..
"  image-border: 0\n" ..
"  border: 0 alpha\n" ..
"  padding: 0\n" ..
"  layout: anchor\n" .. -- Destrava o alinhamento das redes sociais e painéis de rolagem
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoCustomCelestiais\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/M_custompremium.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #00000025\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  ScrollablePanel\n" ..
"    id: listaScroll\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: barraRolagem.left\n" ..
"    anchors.bottom: sepInf.top\n" ..
"    margin-top: 10\n" ..
"    margin-left: 10\n" ..
"    margin-right: 2\n" ..
"    margin-bottom: 5\n" ..
"    vertical-scrollbar: barraRolagem\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 6\n" ..
"\n" ..
"  VerticalScrollBar\n" ..
"    id: barraRolagem\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.bottom: sepInf.top\n" ..
"    anchors.right: lblRedesTitulo.left\n" ..
"    margin-top: 10\n" ..
"    margin-bottom: 5\n" ..
"    margin-right: 5\n" ..
"    step: 20\n" ..
"    pixels-scroll: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblRedesTitulo\n" ..
"    text: -- REDES SOCIAIS DA GUILDA --\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #00bfff\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 20\n" ..
"    margin-left: 15\n" ..
"    text-align: center\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoInsta\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: lblRedesTitulo.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -50\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnInstagram\n" ..
"    text: Acessar Instagram\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -13\n" ..
"    phantom: false\n" ..
"    anchors.centerIn: imgFundoInsta\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoWhats\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: imgFundoInsta.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -160\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnWhatsApp\n" ..
"    text: Grupo do WhatsApp\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -13\n" ..
"    phantom: false\n" ..
"    anchors.centerIn: imgFundoWhats\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoDiscord\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: imgFundoWhats.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -160\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 200\n" .. 
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnDiscord\n" ..
"    text: Servidor do Discord\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -13\n" ..
"    phantom: false\n" ..
"    anchors.centerIn: imgFundoDiscord\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoYoutube\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: imgFundoDiscord.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -160\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnYouTube\n" ..
"    text: Canal do YouTube\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -13\n" ..
"    phantom: false\n" ..
"    anchors.centerIn: imgFundoYoutube\n" ..
"\n" ..
"  HorizontalSeparator\n" ..
"    id: sepInf\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: closeBtn.top\n" ..
"    margin-bottom: 8\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    font: cipsoftFont\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 60 20\n" ..
"    margin-bottom: 5\n" ..
"    margin-right: 15\n" ..
"    @onClick: self:getParent():hide()\n"
-- =============================================================================
-- [PARTE 4 DE 6] INICIALIZAÇÃO DE PANÉIS, LINKS E WEBHOOK DISCORD PROTEGIDO
-- =============================================================================
-- 1. FUNÇÃO ANCORADA NO TOPO: Registra a leitura do navegador na memória primeiro
local function abrirLinkNoNavegadorReal(urlDestino)
    if g_signals and g_signals.openUrl then g_signals.openUrl(urlDestino)
    elseif g_platform and g_platform.openUrl then g_platform.openUrl(urlDestino)
    else print(">>> [BRINQUE] Link para copiar: " .. urlDestino) end
end

-- 2. DESTRUIÇÃO DE COMPONENTES ANTIGOS DUPLICADOS
if widgetRaizDoJogo:recursiveGetChildById("janelaAvisoLicenca") then widgetRaizDoJogo:recursiveGetChildById("janelaAvisoLicenca"):destroy() end
if widgetRaizDoJogo:recursiveGetChildById("janelaBloqueioHWID") then widgetRaizDoJogo:recursiveGetChildById("janelaBloqueioHWID"):destroy() end
if widgetRaizDoJogo:recursiveGetChildById("janelaEscolhaMacros") then widgetRaizDoJogo:recursiveGetChildById("janelaEscolhaMacros"):destroy() end

-- 3. CRIAÇÃO FÍSICA SEGURA DOS COMPONENTES OTUI
local setupAvisoWindow    = setupUI(designAvisoLicencaOTUI, widgetRaizDoJogo)
local setupBloqueioWindow = setupUI(designBloqueioHWIDOTUI, widgetRaizDoJogo)
local setupMacrosWindow   = setupUI(designPrincipalOTUI, widgetRaizDoJogo)

setupAvisoWindow:hide()
setupBloqueioWindow:hide()
setupMacrosWindow:hide()

-- 4. TRAVA DE IMAGENS FANTASMAS
if not g_resources.fileExists(pastaImg .. "butaoazulverme.png") then
    if setupMacrosWindow.imgFundoInsta then setupMacrosWindow.imgFundoInsta:setImageSource("") end
    if setupMacrosWindow.imgFundoWhats then setupMacrosWindow.imgFundoWhats:setImageSource("") end
    if setupMacrosWindow.imgFundoDiscord then setupMacrosWindow.imgFundoDiscord:setImageSource("") end
    if setupMacrosWindow.imgFundoYoutube then setupMacrosWindow.imgFundoYoutube:setImageSource("") end
    if setupAvisoWindow.imgFundoBtnRenovar then setupAvisoWindow.imgFundoBtnRenovar:setImageSource("") end
    if setupBloqueioWindow.imgFundoBtnSuporte then setupBloqueioWindow.imgFundoBtnSuporte:setImageSource("") end
end

-- 5. ATRIBUIÇÃO DOS EVENTOS DE CLIQUE (AGORA ENXERGANDO A FUNÇÃO PERFEITAMENTE)
if setupMacrosWindow.btnInstagram then setupMacrosWindow.btnInstagram.onClick = function() abrirLinkNoNavegadorReal(LINK_INSTAGRAM) end end
if setupMacrosWindow.btnWhatsApp then setupMacrosWindow.btnWhatsApp.onClick  = function() abrirLinkNoNavegadorReal(LINK_WHATSAPP) end end
if setupMacrosWindow.btnDiscord then setupMacrosWindow.btnDiscord.onClick   = function() abrirLinkNoNavegadorReal(LINK_DISCORD) end end
if setupMacrosWindow.btnYouTube then setupMacrosWindow.btnYouTube.onClick   = function() abrirLinkNoNavegadorReal(LINK_YOUTUBE) end end

if setupAvisoWindow.btnRenovar then setupAvisoWindow.btnRenovar.onClick = function() abrirLinkNoNavegadorReal(LINK_RENOVACAO) end end
if setupAvisoWindow.closeBtn then setupAvisoWindow.closeBtn.onClick   = function() setupAvisoWindow:hide() end end
if setupBloqueioWindow.btnFalarAdmin then setupBloqueioWindow.btnFalarAdmin.onClick = function() abrirLinkNoNavegadorReal(LINK_RENOVACAO) end end

local uiTravaAba = nil
local function renderizarBotaoMenuLateral(maquinaValida, mensagemStatus, corStatus)
    if uiTravaAba then uiTravaAba:destroy() end
    if maquinaValida then
        uiTravaAba = setupUI([[
Panel
  height: 40
  Button
    id: btnChecar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    margin-right: 2
    height: 17
    text: Ver Licenca
    font: verdana-11px-rounded
  Button
    id: btnMacrosMenu
    anchors.top: parent.top
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-left: 2
    height: 17
    text: Escolher Macros
    font: verdana-11px-rounded
  ]], getTab("GUILD"))

        uiTravaAba.btnChecar.onClick = function()
            if setupAvisoWindow:isVisible() then setupAvisoWindow:hide() else setupAvisoWindow:show() setupAvisoWindow:raise() setupAvisoWindow:focus() end
        end
        uiTravaAba.btnMacrosMenu.onClick = function()
            if setupMacrosWindow:isVisible() then setupMacrosWindow:hide() else setupMacrosWindow:show() setupMacrosWindow:raise() setupMacrosWindow:focus() end
        end
    else
        uiTravaAba = setupUI([[
Panel
  height: 20
  Label
    id: lblAvisoBloqueio
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    font: verdana-11px-rounded
  ]], getTab("GUILD"))
        
        if uiTravaAba and uiTravaAba.lblAvisoBloqueio then
            uiTravaAba.lblAvisoBloqueio:setText(tostring(mensagemStatus))
            uiTravaAba.lblAvisoBloqueio:setColor(corStatus or "#ff4444")
        end
        setupMacrosWindow:hide()
    end
end

-- 💥 INSTALE SEU WEBHOOK COPIADO DO DISCORD AQUI DENTRO
local URL_WEBHOOK_DISCORD = "https://discord.com/api/webhooks/1536100384785834064/31bfP1tvqS7nx_s99Vzr6NxAFvGcAf2MGdpPbezQ1hocXHc_DgiGaTDxkTpMyC_lU1NL"

local jaEnviouNotificacao = false

local function registrarNovoUsuarioNoDiscord(nickChar, idCapturado, statusLicenca)
    if jaEnviouNotificacao then return end
    if not URL_WEBHOOK_DISCORD or URL_WEBHOOK_DISCORD == "" or URL_WEBHOOK_DISCORD:find("COLE_AQUI") then return end
    
    jaEnviouNotificacao = true
    
    local estruturaPayload = {
        username = "Brinque Scripts Alerta",
        embeds = {
            {
                title = "🔒 Verificacao de Licenca de Hardware",
                color = 16711680,
                fields = {
                    { name = "👤 Personagem (Nick):", value = nickChar, inline = true },
                    { name = "🖥️ Codigo da Maquina (HWID):", value = "`" .. idCapturado .. "`", inline = true },
                    { name = "⚙️ Status do Acesso:", value = statusLicenca, inline = true }
                },
                footer = { text = "Controle de Vendas Automatizado - Brinque Scripts" }
            }
        }
    }
    HTTP.postJSON(URL_WEBHOOK_DISCORD, estruturaPayload, function(res, err) end)
end

-- =============================================================================
-- [PARTE 5 DE 6] ENGINE DE DATAS E ASSINATURA RIGIDA RAM - BRINQUE SCRIPTS
-- =============================================================================
local MAPA_MACROS_GUILDA = {
    -- ==========================================
    -- MACROS COM PRIORIDADE (HEALING)
    -- ==========================================
    { nome = "HEALING BRQ",          key = "healingBRQ",         cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/healingBRQ.lua" },
    { nome = "OPEN BAG MAIN BRQ",    key = "openbagmainBRQ",     cat = "EXTRAS",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/openbagmainBRQ.lua" },
    { nome = "BLESSED HP/MP BRQ",    key = "blessedhpmpBRQ",     cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/blessed_hpmpBRQ.lua" },
    { nome = "ENEGY-SSA-MIGHT BRQ",  key = "energyssamightBRQ",  cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/enegy_ssa_mightBRQ.lua" },
	{ nome = "Painel",    key = "painel",     cat = "EXTRAS",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Painel.lua" },
    { nome = "POT GUILD BRQ",        key = "potguildBRQ",        cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/potguildBRQ.lua" },
	{ nome = "STAMINA BRQ",          key = "staminaBRQ",         cat = "HEALING",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/staminaBRQ.lua" },
	{ nome = "BUFF BRQ",          key = "BUFFBRQ",         cat = "HEALING",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/BRQ_buff_v1.0.lua" },
	{ nome = "Food BRQ",          key = "Food",         cat = "HEALING",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Food.lua" },


    -- ==========================================
    -- MACROS SEM PRIORIDADE (CAVE/TARGET)
    -- ==========================================
    { nome = "FUGA COMPLETA BRQ",    key = "fugacompletaBRQ",    cat = "CAVE/TARGET",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/fugacompletaBRQ.lua" },
    { nome = "OLHEIRO_BRQ",          key = "olheiroBRQ",         cat = "CAVE/TARGET",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/olheiro_BRQ1.0.lua" },
    { nome = "COMBO LIDER BRQ",      key = "comboliderBRQ",      cat = "CAVE/TARGET", url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/comboliderBRQ.lua" },
    { nome = "OUTFIT VISUAL BRQ",    key = "outfitvisualBRQ",    cat = "EXTRAS", url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/outfitvisualBRQ.lua" },
    { nome = "TARGET PLAY OFF",      key = "targetplayoffBRQ",   cat = "CAVE/TARGET",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/targetplayoffBRQ.lua" },
    -- ==========================================
    -- MACROS DA AUTOMATICO GUILDA (WAR)
    -- ==========================================

	{ nome = "PUSHE BRQ",          key = "pusheBRQ",          cat = "WAR",         url = "https://raw.githubusercontent.com/zedojavascripts/javaserver/refs/heads/main/scripts/sv_ilusion/war/pushmouse-obfuscated.lua" },
    { nome = "3 PUSHE BRQ",          key = "3pusheBRQ",          cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/3pusheBRQ.lua" },
	{ nome = "Central de Icones BRQ",          key = "centralicones",          cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/AttackIcons.lua" },
    { nome = "ANTPUSHE MOUSE-PE BRQ", key = "antpushemousepeBRQ", cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Dropar_item_na_posicao_do_mouseBRQ.lua" },
    { nome = "MW NO PE",             key = "MWPE",               cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/mwnopeBRQ.lua" },
    { nome = "PUXAR AO REDOR BRQ",   key = "puxaraoredorBRQ",    cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/puxaraoredorBRQ.lua" },
    { nome = "EXIVA BRQ",            key = "exivaBRQ",           cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/exivaBRQ.lua" },

    -- ==========================================
    -- MACROS EXTRAS (EXTRAS)
    -- ==========================================
	{ nome = "FILTRO BATTLE BRQ",    key = "filtrobatleBRQ",     cat = "WAR",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/filtrobatleBRQ.lua" },
	{ nome = "SKILLS BRQ",           key = "skillsBRQ",          cat = "EXTRAS", url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/skillsBRQ.lua" },
    { nome = "FPS BRQ",              key = "fpsBRQ",             cat = "EXTRAS",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/fpsBRQ.lua" },
	{ nome = "FOLLOW ATTACK BRQ",              key = "followattackBRQ",             cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/followattackBRQ.lua" },
	{ nome = "BUGMAP BRQ",              key = "bugmapBRQ",             cat = "EXTRAS",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/bugmap.lua" },
    { nome = "RAINBOW COLOR BRQ",    key = "rainbowcolorBRQ",    cat = "EXTRAS",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/rainbowcolorBRQ.lua" },
    { nome = "HUND COLOR BRQ",       key = "hundcolorBRQ",       cat = "EXTRAS",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/hundcolorBRQ.lua" },
    { nome = "OPEN BAG CHEIA BRQ",   key = "openbagcheiaBRQ",    cat = "EXTRAS",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/openbagcheiaBRQ.lua" },
	{ nome = "MAGIAS S/PK BRQ",      key = "magiasempkBRQ",      cat = "EXTRAS",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/magiasempkBRQ.lua" },
	{ nome = "FORUM BRQ",      key = "forumBRQ",      cat = "EXTRAS",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/forum.lua" }
}

local function converterDataParaTimestamp(dataTexto)
    local dia, mes, ano = dataTexto:match("(%d+)/(%d+)/(%d+)")
    if dia and mes and ano then return os.time({year = tonumber(ano), month = tonumber(mes), day = tonumber(dia), hour = 23, min = 59, sec = 59}) end
    return nil
end

-- EXTRAÇÃO DE MEMÓRIA DO EXECUTÁVEL: ID travado por hardware que ignora OTServers
local somaModulosFixo = 0
if dink and type(dink) == "table" then somaModulosFixo = somaModulosFixo + #dink end
if m_modules and type(m_modules) == "table" then somaModulosFixo = somaModulosFixo + #m_modules end

local sementesMatematica = tostring(g_resources.getLayout()):lower():trim()
local hashCalculadoLocal = somaModulosFixo * 7
for i = 1, #sementesMatematica do 
    hashCalculadoLocal = (hashCalculadoLocal * 31 + string.byte(sementesMatematica, i)) % 100000000 
end
hwidDaMaquinaDoCliente = "BRINQUE-GLOBAL-" .. tostring(hashCalculadoLocal)

-- 🔒 ACESSO FECHADO SEGURO: Modo livre totalmente desativado para proteção comercial
local MODO_LIVRE_RASTREADOR = false

computadorEstaAutorizado = false
stringAvisoAba = "PC NAO REGISTRADO"
corAvisoAba = "#ff4444"

-- Validador de chaves e prazos com proteção estrita de interface
local function processarSegurancaEVerificacaoDeDatas()
    local dadosDestePC = BANCO_DADOS_CLIENTES[hwidDaMaquinaDoCliente]
    
    if dadosDestePC then
        if setupAvisoWindow and setupAvisoWindow.lblNomeCliente then
            setupAvisoWindow.lblNomeCliente:setText("Cliente: " .. dadosDestePC.nome)
        end
        
        if dadosDestePC.vence == "ilimitado" then
            computadorEstaAutorizado = true
            stringAvisoAba = "ACESSO PERMANENTE"
            corAvisoAba = "#00bfff"
            if setupAvisoWindow and setupAvisoWindow.lblDiasRestantes then
                setupAvisoWindow.lblDiasRestantes:setText("Status do Acesso: Permanente")
                setupAvisoWindow.lblDiasRestantes:setColor("#00bfff")
            end
            print("[BRINQUE SCRIPTS] Administrador verificado! Acesso ilimitado concedido.")
        else
            local timestampVencimento = converterDataParaTimestamp(dadosDestePC.vence)
            if timestampVencimento then
                local segundosRestantes = timestampVencimento - os.time()
                local diasRestantes = math.ceil(segundosRestantes / 86400)
                if diasRestantes > 0 then
                    computadorEstaAutorizado = true
                    stringAvisoAba = "PC AUTORIZADO"
                    corAvisoAba = "#44ff44"
                    if setupAvisoWindow and setupAvisoWindow.lblDiasRestantes then
                        setupAvisoWindow.lblDiasRestantes:setText("Dias Restantes: " .. diasRestantes .. " dias")
                        if diasRestantes <= 7 then
                            setupAvisoWindow.lblDiasRestantes:setColor("#ff4444")
                            stringAvisoAba = "RENOVAR EM BREVE"
                            corAvisoAba = "#ff4444"
                        else
                            setupAvisoWindow.lblDiasRestantes:setColor("#44ff44")
                        end
                    end
                    if setupAvisoWindow then setupAvisoWindow:show() end
                else
                    stringAvisoAba = "ACESSO EXPIRADO"
                    if setupAvisoWindow and setupAvisoWindow.lblDiasRestantes then
                        setupAvisoWindow.lblDiasRestantes:setText("Acesso Expirado! Bloqueado.")
                        setupAvisoWindow.lblDiasRestantes:setColor("#ff4444")
                    end
                    if setupAvisoWindow and setupAvisoWindow.closeBtn then setupAvisoWindow.closeBtn:hide() end
                    if setupAvisoWindow then setupAvisoWindow:show() end
                    MAPA_MACROS_GUILDA = {}
                end
            end
        end
    else
        if setupBloqueioWindow and setupBloqueioWindow.lblCodigoPC then
            setupBloqueioWindow.lblCodigoPC:setText("ID DO PC: " .. hwidDaMaquinaDoCliente)
        end
        if setupBloqueioWindow then setupBloqueioWindow:show() end
        MAPA_MACROS_GUILDA = {}
    end
end
local ORDEM_CATEGORIAS = { "HEALING", "CAVE/TARGET", "WAR", "EXTRAS" }
local CORES_CATEGORIAS = { ["HEALING"] = "#44ff44", ["CAVE/TARGET"] = "#00bfff", ["WAR"] = "#ff4444", ["EXTRAS"] = "#e6bc22" }

for _, nomeCat in ipairs(ORDEM_CATEGORIAS) do
    local div = g_ui.createWidget("Label", setupMacrosWindow.listaScroll)
    div:setText("-- " .. nomeCat .. " --")
    div:setFont("verdana-11px-rounded")
    div:setColor(CORES_CATEGORIAS[nomeCat])
    div:setMarginTop(5)
    div:setMarginBottom(2)

    for _, item in ipairs(MAPA_MACROS_GUILDA) do
        if item.cat == nomeCat then
            if config.macrosMarcados[item.key] == nil then config.macrosMarcados[item.key] = true end
            local box = g_ui.createWidget("CheckBox", setupMacrosWindow.listaScroll)
            box:setText(item.nome)
            box:setFont("verdana-11px-rounded")
            box:setHeight(16)
            box:setChecked(config.macrosMarcados[item.key] == true)
            box.onClick = function(w)
                local val = not w:isChecked()
                w:setChecked(val)
                config.macrosMarcados[item.key] = val
            end
        end
    end
end

-- =============================================================================
-- [PARTE 6 DE 6] FILA ULTRA RÁPIDA (200MS) E ARRANCADA DO COMPILADOR
-- =============================================================================
local loteJaEstaSendoBaixado = false
local function executarFilaCustomizadaHTTP(indice)
    if not computadorEstaAutorizado then return end
    if indice == 1 then if loteJaEstaSendoBaixado then return end loteJaEstaSendoBaixado = true end
    
    local macroAlvo = MAPA_MACROS_GUILDA[indice]
    if not macroAlvo then 
        print("[Brinque Scripts] Todos os macros ativos injetados via nuvem com sucesso.")
        loteJaEstaSendoBaixado = false 
        return 
    end
    
    if config.macrosMarcados[macroAlvo.key] == true then
        HTTP.get(macroAlvo.url .. "?v=" .. os.time(), function(content, err)
            if not err then
                if macroAlvo.url:find("PotGuild.lua") then 
                    if partyPotUI then partyPotUI:destroy() partyPotUI = nil end 
                    if ppWindow then ppWindow:destroy() ppWindow = nil end 
                end
                local script, syntaxErr = loadstring(content)
                if script then pcall(script) else print("[Erro Script] Slot falhou: " .. tostring(syntaxErr)) end
            end
            -- VELOCIDADE PERFORMANCE: Carrega a fila em escada a cada 200 milissegundos
            schedule(10, function() executarFilaCustomizadaHTTP(indice + 1) end)
        end)
    else
        schedule(10, function() executarFilaCustomizadaHTTP(indice + 1) end)
    end
end

macro(600000, function() 
    if processarSegurancaEVerificacaoDeDatas then processarSegurancaEVerificacaoDeDatas() end
    renderizarBotaoMenuLateral(computadorEstaAutorizado, stringAvisoAba, corAvisoAba)
    if not computadorEstaAutorizado then reload() end 
end)

onTextMessage(function(m, t)
    if m ~= 20 then return end
    local d = t:match("is to the ([a-z-]+)%.") or t:match("is .- to the ([a-z-]+)%.")
    if d then showExivaArrow(d) end
end)

-- TIMEOUT DE ARRANCADA SEGURO: Roda estritamente após todas as estruturas estarem na RAM
schedule(1000, function()
    -- 1. Processa a segurança, injeta as strings e analisa o calendário
    if processarSegurancaEVerificacaoDeDatas then processarSegurancaEVerificacaoDeDatas() end
    
    -- 2. Renderiza o botão lateral correspondente na aba lateral do vBot
    renderizarBotaoMenuLateral(computadorEstaAutorizado, stringAvisoAba, corAvisoAba)
    
    local localPlayer = g_game.getLocalPlayer()
    local nomeVerdadeiroDoChar = localPlayer and localPlayer:getName() or "Desconhecido"
    
    -- 3. Dispara a notificação sem duplicações (Lê a trava da Parte 4) para o seu Discord
    if BANCO_DADOS_CLIENTES[hwidDaMaquinaDoCliente] then
        local dadosLicenca = BANCO_DADOS_CLIENTES[hwidDaMaquinaDoCliente]
        registrarNovoUsuarioNoDiscord(nomeVerdadeiroDoChar, hwidDaMaquinaDoCliente, "Acesso Permitido para: " .. dadosLicenca.nome)
    else
        registrarNovoUsuarioNoDiscord(nomeVerdadeiroDoChar, hwidDaMaquinaDoCliente, "Acesso Negado (Bloqueado em Tela)")
    end

    -- 4. Inicia as injeções em nuvem se o computador constar nos autorizados da Parte 1
    if computadorEstaAutorizado then
        print("[Brinque Scripts] Identidade confirmada. Carregando macros via nuvem em alta performance...")
        executarFilaCustomizadaHTTP(1)
    else
        print(">>> [BRINQUE SCRIPTS] Bloqueado. Maquina invalida ou licenca vencida.")
    end
end)
