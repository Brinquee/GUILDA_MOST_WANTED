local forumPanelName = "forumBrinqueScripts"
if type(storage[forumPanelName]) ~= "table" then
    storage[forumPanelName] = {
        abrirNoReload = true -- Deixa ativado por padrao para pular na tela no primeiro reload
    }
end

local forumConfig = storage[forumPanelName]
local widgetRaizDoJogo = g_ui.getRootWidget()

-- =============================================================================
-- [FORUM - PARTE 1 DE 4] TEXTOS DA ABA DE ANUNCIOS DO TOPO
-- =============================================================================
local ANUNCIO_TITULO = "ATUALIZACAO Nos Macros EXIVA e MW no PE!"
local ANUNCIO_TEXTO  = "ATUALIZACAO LANCADA o Macro EXIVA Foi corrigido, A Macro MW no pe agora e uma CENTRAL DE MW e Adicionamos INCOS, o Conflito MW + EXIVA corrigido. O NOVO: Macro de Anuncio/Forum adicionada, Testem e me falem se ta tudo ok"

-- WEBHOOK EXCLUSIVO DO FORUM: Cole a URL do canal do Discord onde quer receber os relatos
local URL_WEBHOOK_FORUM = "COLE_AQUI_A_URL_DO_WEBHOOK_DO_FORUM_DO_DISCORD"
-- =============================================================================
-- [FORUM - PARTE 2 DE 4] INTERFACE GRAFICA CORRIGIDA (RETRO FIX ANCHOR)
-- =============================================================================
local designForumOTUI = "UIWindow\n" ..
"  id: janelaForumBrinque\n" ..
"  size: 540 340\n" ..
"  anchors.horizontalCenter: parent.horizontalCenter\n" .. -- Alinhamento horizontal seguro Retro
"  anchors.verticalCenter: parent.verticalCenter\n" ..     -- Alinhamento vertical seguro Retro
"  layout: anchor\n" ..
"  background-color: #111111ee\n" ..
"  border: 1 #444444\n" ..
"  @onEscape: self:hide()\n" ..
"\n" ..
"  Label\n" ..
"    id: lblTituloGeral\n" ..
"    text: -- FORUM DE SUPORTE INTEGRADO - BRINQUE SCRIPTS --\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #00bfff\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    text-align: center\n" ..
"\n" ..
"  Panel\n" ..
"    id: pnlAnuncios\n" ..
"    size: 500 80\n" ..
"    background-color: #1a1a1a\n" ..
"    border: 1 #222222\n" ..
"    anchors.top: lblTituloGeral.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 15\n" ..
"    margin-left: 20\n" ..
"    layout: anchor\n" ..
"\n" ..
"    Label\n" ..
"      id: lblAnuncioTitulo\n" ..
"      font: verdana-11px-rounded\n" ..
"      color: #ff4444\n" ..
"      anchors.top: parent.top\n" ..
"      anchors.left: parent.left\n" ..
"      margin-top: 8\n" ..
"      margin-left: 10\n" ..
"\n" ..
"    Label\n" ..
"      id: lblAnuncioTexto\n" ..
"      font: verdana-11px-rounded\n" ..
"      color: #cccccc\n" ..
"      anchors.top: lblAnuncioTitulo.bottom\n" ..
"      anchors.left: parent.left\n" ..
"      margin-top: 6\n" ..
"      margin-left: 10\n" ..
"\n" ..
"  Label\n" ..
"    id: lblRelatarProblema\n" ..
"    text: Relatar Problema ou Sugerir Melhorias:\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    anchors.top: pnlAnuncios.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 20\n" ..
"    margin-left: 20\n" ..
"\n" ..
"  TextEdit\n" ..
"    id: txtMensagemForum\n" ..
"    size: 500 60\n" ..
"    background-color: #1a1a1a\n" ..
"    border: 1 #333333\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    anchors.top: lblRelatarProblema.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 8\n" ..
"    margin-left: 20\n" ..
"    text-auto-resize: false\n" ..
"\n" ..
"  Button\n" ..
"    id: btnEnviarMensagem\n" ..
"    text: Enviar Relato para o Discord\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: txtMensagemForum.bottom\n" ..
"    anchors.left: txtMensagemForum.left\n" ..
"    anchors.right: txtMensagemForum.right\n" ..
"    margin-top: 10\n" ..
"    height: 24\n" ..
"\n" ..
"  CheckBox\n" ..
"    id: chkAbrirNoReload\n" ..
"    text: Abrir este Forum automaticamente ao dar Reload\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #e6bc22\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-left: 20\n" ..
"    margin-bottom: 22\n" ..
"    height: 16\n" ..
"\n" ..
"  Button\n" ..
"    id: btnFecharForum\n" ..
"    text: Fechar Forum\n" ..
"    font: cipsoftFont\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.right: parent.right\n" ..
"    margin-right: 20\n" ..
"    margin-bottom: 18\n" ..
"    size: 90 20\n" ..
"    @onClick: self:getParent():hide()\n"
-- =============================================================================
-- [FORUM - PARTE 3 DE 4] ENGINE DE ASSOCIACAO GRAFICA E TRANSMISSAO DISCORD
-- =============================================================================
local setupForumWindow = setupUI(designForumOTUI, widgetRaizDoJogo)
setupForumWindow:hide()

-- Injeta os textos de anuncio configurados na Parte 1 dentro do painel
if setupForumWindow.pnlAnuncios then
    if setupForumWindow.pnlAnuncios.lblAnuncioTitulo then setupForumWindow.pnlAnuncios.lblAnuncioTitulo:setText(ANUNCIO_TITULO) end
    if setupForumWindow.pnlAnuncios.lblAnuncioTexto then setupForumWindow.pnlAnuncios.lblAnuncioTexto:setText(ANUNCIO_TEXTO) end
end

-- Sincroniza o estado do CheckBox com a memoria do vBot
if setupForumWindow.chkAbrirNoReload then
    setupForumWindow.chkAbrirNoReload:setChecked(forumConfig.abrirNoReload == true)
    setupForumWindow.chkAbrirNoReload.onClick = function(w)
        local statusMarcado = not w:isChecked()
        w:setChecked(statusMarcado)
        forumConfig.abrirNoReload = statusMarcado
    end
end

-- Funcao mestre que envia o relato do jogador formatado direto para o seu Discord
local function enviarRelatoForumParaDiscord(nickChar, textoMensagem, hwidMaquina)
    if not URL_WEBHOOK_FORUM or URL_WEBHOOK_FORUM == "" or URL_WEBHOOK_FORUM:find("COLE_AQUI") then 
        print(">>> [FORUM] Erro: Link do Webhook do Forum nao configurado na Parte 1.")
        return 
    end
    
    local payloadForum = {
        username = "Brinque Scripts - Suporte Integrado",
        embeds = {
            {
                title = "Novo Relato Recebido no Forum",
                color = 3447003, -- Cor azul padrao do Discord em decimal
                fields = {
                    { name = "Jogador (Nick):", value = nickChar, inline = true },
                    { name = "ID do Computador (HWID):", value = "`" .. hwidMaquina .. "`", inline = true },
                    { name = "Mensagem / Sugestao:", value = "```\n" .. textoMensagem .. "\n```", inline = false }
                },
                footer = { text = "Sistema de Ticket Integrado - Brinque Scripts" }
            }
        }
    }
    
    HTTP.postJSON(URL_WEBHOOK_FORUM, payloadForum, function(res, err)
        if not err then
            print("[Forum] Mensagem enviada com sucesso para o Administrador!")
        else
            print("[Forum] Falha ao transmitir dados para o servidor do Discord.")
        end
    end)
end

-- Acao do botao de envio de mensagem
setupForumWindow.btnEnviarMensagem.onClick = function()
    local caixaTexto = setupForumWindow.txtMensagemForum
    if not caixaTexto then return end
    
    local textoDigitado = tostring(caixaTexto:getText()):trim()
    if #textoDigitado < 5 then
        print("[Forum] Mensagem muito curta! Digite um problema ou sugestao real.")
        return
    end
    
    local localPlayer = g_game.getLocalPlayer()
    local nickBoneco = localPlayer and localPlayer:getName() or "Desconhecido"
    local idPC = hwidDaMaquinaDoCliente or "BRINQUE-GLOBAL-DESCONHECIDO"
    
    -- Dispara a transmissao em segundo plano
    enviarRelatoForumParaDiscord(nickBoneco, textoDigitado, idPC)
    
    -- Limpa a caixa de digitacao na mesma hora para impedir spam do mesmo ticket
    caixaTexto:setText("")
    print("[Forum] Enviando relato... Aguarde a confirmacao.")
end

-- Criador do botao de abertura rapida no menu lateral da aba Guild
local uiBotaoForumLateral = nil
local function renderizarBotaoForumNoMenuLateral()
    if uiBotaoForumLateral then uiBotaoForumLateral:destroy() end
    
    uiBotaoForumLateral = setupUI([[
Panel
  height: 22
  Button
    id: btnAbrirPainelForum
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 2
    height: 18
    text: Abrir Forum
    font: verdana-11px-rounded
    color: #e6bc22
  ]], getTab("main"))
    
    uiBotaoForumLateral.btnAbrirPainelForum.onClick = function()
        if setupForumWindow:isVisible() then 
            setupForumWindow:hide() 
        else 
            setupForumWindow:show() 
            setupForumWindow:raise() 
            setupForumWindow:focus() 
        end
    end
end
-- =============================================================================
-- [FORUM - PARTE 4 DE 4] GATILHO DE ARRANCADA DO MODULO SUPORTE
-- =============================================================================

-- Inicializa o botao no menu lateral do vBot de forma estavel
renderizarBotaoForumNoMenuLateral()

-- Temporizador inteligente sincronizado com a arrancada principal do bot (3 segundos)
schedule(3000, function()
    -- Garante a criacao e atualizacao do botao na interface lateral
    renderizarBotaoForumNoMenuLateral()
    
    -- Se a caixinha estiver marcada, pula o painel na tela do cliente de forma automatica
    if forumConfig.abrirNoReload == true and computadorEstaAutorizado then
        if setupForumWindow then
            setupForumWindow:show()
            setupForumWindow:raise()
            setupForumWindow:focus()
            print("[Forum] Painel de suporte aberto automaticamente (Configuracao de Reload Ativa).")
        end
    end
end)
