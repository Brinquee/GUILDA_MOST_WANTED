local widgetRaizDoJogo = g_ui.getRootWidget()

-- 1. ESTRUTURA DO ARMAZENAMENTO (STORAGE)
if not storage.brqAvisoCobrancaConfig then
    storage.brqAvisoCobrancaConfig = {
        janelaFoiFechada = false
    }
end
local configCobranca = storage.brqAvisoCobrancaConfig

-- Link direto para o seu atendimento
local LINK_SUPORTE_WHATSAPP = "https://wa.me/qr/QHQWPAJNPYRDJ1"
local pastaImg = "/bot/CUSTOM_PREMIUM/imagens/"

-- 2. CALCULO DO HWID UNIVERSAL INDIVIDUAL (IDENTICO AO SEU PAINEL GERAL CENTRAL)
local somaModulosFixo = 0
if dink and type(dink) == "table" then somaModulosFixo = somaModulosFixo + #dink end
if m_modules and type(m_modules) == "table" then somaModulosFixo = somaModulosFixo + #m_modules end

local sementesMatematica = tostring(g_resources.getLayout()):lower():trim()
local tokenHardwareNativo = "Desconhecido"
if g_platform and g_platform.getHardwareId then
    tokenHardwareNativo = tostring(g_platform.getHardwareId()):lower():trim()
end

if tokenHardwareNativo == "desconhecido" or tokenHardwareNativo == "" then
    tokenHardwareNativo = "BRQ-FIXO-" .. sementesMatematica
end

local hashCalculadoLocal = somaModulosFixo * 7
for i = 1, #tokenHardwareNativo do 
    hashCalculadoLocal = (hashCalculadoLocal * 31 + string.byte(tokenHardwareNativo, i)) % 100000000 
end
local hwidIdentificado = "BRINQUE-GLOBAL-" .. tostring(hashCalculadoLocal)

-- 3. DESIGN DA JANELA DE COBRANCA EM TEXTO OTUI SEGURO (ANCHOR LAYOUT)
local designAvisoCobrancaOTUI = "MainWindow\n" ..
"  id: janelaAvisoCobrancaUrgente\n" ..
"  !text: tr('ALERTA DE MANUTENCAO - BRINQUE SCRIPTS')\n" ..
"  size: 360 270\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: alpha\n" ..
"  image-border: 0\n" ..
"  border: 0 alpha\n" ..
"  padding: 0\n" ..
"  layout: anchor\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoAvisoCob\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/M_custompremium.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.fill: parent\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #00000050\n" ..
"    anchors.fill: parent\n" ..
"    phantom: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblTituloAviso\n" ..
"    text: ATENCAO: ATUALIZACAO DE SEGURANCA!\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ff4444\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.horizontalCenter: parent.horizontalCenter\n" ..
"    margin-top: 15\n" ..
"    text-align: center\n" ..
"\n" ..
"  Label\n" ..
"    id: lblLinhaUm\n" ..
"    text: Seu acesso sera BLOQUEADO temporariamente\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    anchors.top: lblTituloAviso.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 12\n" ..
"    text-align: center\n" ..
"\n" ..
"  Label\n" ..
"    id: lblLinhaDois\n" ..
"    text: a partir das 20:00 horas de hoje (18/08).\n" ..
"    font: verdana-11px-bold\n" ..
"    color: #FFD700\n" ..
"    anchors.top: lblLinhaUm.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 4\n" ..
"    text-align: center\n" ..
"\n" ..
"  Label\n" ..
"    id: lblLinhaTres\n" ..
"    text: Envie uma FOTO ou PRINT desta tela com o seu ID\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    anchors.top: lblLinhaDois.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 10\n" ..
"    text-align: center\n" ..
"\n" ..
"  Label\n" ..
"    id: lblLinhaQuatro\n" ..
"    text: para o Administrador liberar o seu painel fixo.\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    anchors.top: lblLinhaTres.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 4\n" ..
"    text-align: center\n" ..
"\n" ..
"  Label\n" ..
"    id: lblIDExibido\n" ..
"    text: SEU ID DO PC: ...\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #FFD700\n" ..
"    anchors.top: lblLinhaQuatro.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    height: 16\n" ..
"    text-align: center\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoBtnZap\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: lblIDExibido.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -30\n" ..
"    margin-left: 40\n" ..
"    margin-right: 40\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnMandarPrint\n" ..
"    text: Enviar Print para Administrador\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -24\n" ..
"    phantom: false\n" ..
"    anchors.fill: imgFundoBtnZap\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Entendi\n" ..
"    font: cipsoftFont\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-left: 40\n" ..
"    margin-right: 40\n" ..
"    margin-bottom: 8\n" ..
"    height: 18\n"

-- 4. INICIALIZAÇÃO FÍSICA SEM RESÍDUOS
if widgetRaizDoJogo:recursiveGetChildById("janelaAvisoCobrancaUrgente") then
    widgetRaizDoJogo:recursiveGetChildById("janelaAvisoCobrancaUrgente"):destroy()
end

local cobrancaWindow = setupUI(designAvisoCobrancaOTUI, widgetRaizDoJogo)
cobrancaWindow:hide()

-- Proteção caso a imagem de fundo falhe
if not g_resources.fileExists(pastaImg .. "butaoazulverme.png") then
    if cobrancaWindow.imgFundoBtnZap then cobrancaWindow.imgFundoBtnZap:setImageSource("") end
end

-- Injeta o ID real calculado do usuário na label dourada
if cobrancaWindow and cobrancaWindow.lblIDExibido then
    cobrancaWindow.lblIDExibido:setText("SEU ID DO PC: " .. tostring(hwidIdentificado))
end

-- 5. INTERAÇÕES DE CLIQUES
cobrancaWindow.btnMandarPrint.onClick = function()
    if g_signals and g_signals.openUrl then g_signals.openUrl(LINK_SUPORTE_WHATSAPP)
    elseif g_platform and g_platform.openUrl then g_platform.openUrl(LINK_SUPORTE_WHATSAPP) end
end

cobrancaWindow.closeBtn.onClick = function()
    cobrancaWindow:hide()
    configCobranca.janelaFoiFechada = true
end

-- 6. DISPARADOR AUTOMÁTICO AO DAR RELOAD (TIMEOUT DE ARRANCADA SEGURO)
schedule(1500, function()
    if cobrancaWindow then
        cobrancaWindow:show()
        cobrancaWindow:raise()
        cobrancaWindow:focus()
    end
end)
