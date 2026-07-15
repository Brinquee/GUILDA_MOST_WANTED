-- ==========================================================
-- ARQUIVO REMOTO GITHUB: BAIXADORFILA.LUA (EXPORTAÇÃO GLOBAL FIXADA)
-- ==========================================================

local MAPA_MACROS_GUILDA = {
    { nome = "Anti-Push",        key = "antipush",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/ANTIPUSH.lua" },
    { nome = "Configs Extras",   key = "configs",      url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Configs_extras.lua" },
    { nome = "Pot Guild",        key = "potguild",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/PotGuild.lua" },
    { nome = "Filtro Battle",    key = "filtro",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Filtro_batle.lua" },
    { nome = "Rainbow Color",    key = "rainbow",      url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/RainbowColor.lua" },
    { nome = "Skills",           key = "skills",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Skills.lua" },
    { nome = "Bola",             key = "bola",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/bola.lua" },
    { nome = "Combo Lider",      key = "combo",        url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/combolider.lua" },
    { nome = "Energy SSA",       key = "energyssa",    url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/enegy_ssa.lua" },
    { nome = "Stamina",          key = "stamina",      url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/stamin.lua" },
    { nome = "Healing Pro",      key = "healing",      url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/healingpro.lua" },
    { nome = "Exiva",            key = "exiva",        url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/exiva.lua" },
    { nome = "Magias Sem PK",    key = "magias",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Magiasempk.lua" },
    { nome = "FPS",              key = "fps",          url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/FPS.lua" },
    { nome = "Abrir Bag Principal",key = "abrirbag",    url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/AbrirBagPrincipal.lua" }
}

local panelNameStorage = "travaMostWanted"
if type(storage[panelNameStorage].macrosMarcados) ~= "table" then
    storage[panelNameStorage].macrosMarcados = {}
    for _, item in ipairs(MAPA_MACROS_GUILDA) do storage[panelNameStorage].macrosMarcados[item.key] = true end
end

local painelMacrosIndependenteUI = nil
local caixaListaMacros = nil

local function construirPainelDeMacrosProprio()
    local root = g_ui.getRootWidget()
    if not root then return end

    for _, child in pairs(root:getChildren()) do
        if child:getText() == "Painel de Macros - Most Wanted" then child:destroy() end
    end

    painelMacrosIndependenteUI = g_ui.createWidget('MainWindow', root)
    painelMacrosIndependenteUI:setText("Painel de Macros - Most Wanted")
    painelMacrosIndependenteUI:setSize({width = 280, height = 400})
    painelMacrosIndependenteUI:hide()

    caixaListaMacros = g_ui.createWidget("ScrollablePanel", painelMacrosIndependenteUI)
    caixaListaMacros:setSize({width = 240, height = 300})
    caixaListaMacros:addAnchor(AnchorTop, "parent", AnchorTop)
    caixaListaMacros:addAnchor(AnchorLeft, "parent", AnchorLeft)
    caixaListaMacros:setMarginTop(10)
    caixaListaMacros:setMarginLeft(10)

    local layoutVertical = g_ui.createLayout("VerticalLayout")
    layoutVertical:setSpacing(5)
    caixaListaMacros:setLayout(layoutVertical)

    for _, macroObj in ipairs(MAPA_MACROS_GUILDA) do
        local caixaLinha = g_ui.createWidget("CheckBox", caixaListaMacros)
        caixaLinha:setText(macroObj.nome)
        caixaLinha:setFont("verdana-11px-rounded")
        caixaLinha:setHeight(16)
        
        local statusSalvo = storage[panelNameStorage].macrosMarcados[macroObj.key] == true
        caixaLinha:setChecked(statusSalvo)
        
        caixaLinha.onClick = function(widget)
            local novoEstado = not widget:isChecked()
            widget:setChecked(novoEstado)
            storage[panelNameStorage].macrosMarcados[macroObj.key] = novoEstado
        end
    end

    local sepInferior = g_ui.createWidget("HorizontalSeparator", painelMacrosIndependenteUI)
    sepInferior:addAnchor(AnchorLeft, "parent", AnchorLeft)
    sepInferior:addAnchor(AnchorRight, "parent", AnchorRight)
    sepInferior:addAnchor(AnchorBottom, "parent", AnchorBottom)
    sepInferior:setMarginBottom(32)

    local btnDispararBaixador = g_ui.createWidget("Button", painelMacrosIndependenteUI)
    btnDispararBaixador:setText("Injetar Scripts")
    btnDispararBaixador:setFont("verdana-11px-rounded")
    btnDispararBaixador:setSize({width = 120, height = 20})
    btnDispararBaixador:addAnchor(AnchorLeft, "parent", AnchorLeft)
    btnDispararBaixador:addAnchor(AnchorBottom, "parent", AnchorBottom)
    btnDispararBaixador:setMarginBottom(6)
    btnDispararBaixador:setMarginLeft(10)
    btnDispararBaixador:setColor("#44ff44")

    btnDispararBaixador.onClick = function()
        print("[Baixador] Executando atualizacao dos macros marcados...")
        executarFilaCustomizadaHTTP(1)
    end

    local btnFecharPainel = g_ui.createWidget("Button", painelMacrosIndependenteUI)
    btnFecharPainel:setText("Close")
    btnFecharPainel:setFont("cipsoftFont")
    btnFecharPainel:setSize({width = 50, height = 20})
    btnFecharPainel:addAnchor(AnchorRight, "parent", AnchorRight)
    btnFecharPainel:addAnchor(AnchorBottom, "parent", AnchorBottom)
    btnFecharPainel:setMarginBottom(6)
    btnFecharPainel:setMarginRight(10)
    
    btnFecharPainel.onClick = function() painelMacrosIndependenteUI:hide() end
end

function executarFilaCustomizadaHTTP(indice)
    local macroAlvo = MAPA_MACROS_GUILDA[indice]
    if not macroAlvo then
        print("[Baixador] Carga customizada finalizada perfeitamente!")
        return
    end

    local estaMarcado = storage[panelNameStorage].macrosMarcados[macroAlvo.key] == true

    if estaMarcado then
        local urlAntiCache = macroAlvo.url .. "?v=" .. os.time()
        print("[Baixador] [" .. indice .. "/" .. #MAPA_MACROS_GUILDA .. "] Baixando: " .. macroAlvo.nome)

        HTTP.get(urlAntiCache, function(content, err)
            if not err then
                if macroAlvo.url:find("PotGuild.lua") then
                    if partyPotUI then partyPotUI:destroy() partyPotUI = nil end
                    if ppWindow then ppWindow:destroy() ppWindow = nil end
                end
                
                local compilar, syntaxErr = loadstring(content)
                if compilar then pcall(compilar) else print("[Baixador] Erro no slot " .. macroAlvo.nome .. ": " .. tostring(syntaxErr)) end
            end
            schedule(1000, function() executarFilaCustomizadaHTTP(indice + 1) end)
        end)
    else
        executarFilaCustomizadaHTTP(indice + 1)
    end
end

-- EXPORTAÇÃO GLOBAL DA COORDENADA: Liga o clique do botão local ao painel remoto
_G.abrirJanelaDeMacrosGlobal = function()
    if painelMacrosIndependenteUI then
        if painelMacrosIndependenteUI:isVisible() then
            painelMacrosIndependenteUI:hide()
        else
            painelMacrosIndependenteUI:show()
            painelMacrosIndependenteUI:raise()
            painelMacrosIndependenteUI:focus()
        end
    end
end

construirPainelDeMacrosProprio()
executarFilaCustomizadaHTTP(1)
