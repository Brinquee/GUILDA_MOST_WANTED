-- ==========================================================
-- ARQUIVO REMOTO GITHUB: BAIXADORFILA.LUA (VERSÃO FINAL FIXADA)
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
local function injetarPainelDeEscolhasNaJanela()
    local root = g_ui.getRootWidget()
    local janelaMestra = nil
    for _, child in pairs(root:getChildren()) do
        if child:getText() == "Status da Licenca - Most Wanted" then janelaMestra = child break end
    end

    if not janelaMestra then return end
    
    janelaMestra:setSize({width = 540, height = 420})

    if janelaMestra.painelListaMacros then janelaMestra.painelListaMacros:destroy() end
    if janelaMestra.btnDispararBaixador then janelaMestra.btnDispararBaixador:destroy() end

    local painelListaMacros = g_ui.createWidget("ScrollablePanel", janelaMestra)
    painelListaMacros:setId("painelListaMacros")
    painelListaMacros:setSize({width = 240, height = 300})
    painelListaMacros:addAnchor(AnchorTop, "parent", AnchorTop)
    painelListaMacros:addAnchor(AnchorRight, "parent", AnchorRight)
    painelListaMacros:setMarginTop(35)
    painelListaMacros:setMarginRight(15)

    local layoutVertical = g_ui.createLayout("VerticalLayout")
    layoutVertical:setSpacing(5)
    painelListaMacros:setLayout(layoutVertical)

    -- LOOP 100% CORRIGIDO DE ACORDO COM AS REGRAS DO SEU CLIENT
    for k, macroObj in ipairs(MAPA_MACROS_GUILDA) do
        local caixaLinha = g_ui.createWidget("CheckBox", painelListaMacros)
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

    local btnDispararBaixador = g_ui.createWidget("Button", janelaMestra)
    btnDispararBaixador:setId("btnDispararBaixador")
    btnDispararBaixador:setText("Injetar Scripts Selecionados")
    btnDispararBaixador:setFont("verdana-11px-rounded")
    btnDispararBaixador:setSize({width = 240, height = 22})
    btnDispararBaixador:addAnchor(AnchorTop, painelListaMacros, AnchorBottom)
    btnDispararBaixador:addAnchor(AnchorRight, "parent", AnchorRight)
    btnDispararBaixador:setMarginTop(8)
    btnDispararBaixador:setMarginRight(15)
    btnDispararBaixador:setColor("#44ff44")

    btnDispararBaixador.onClick = function()
        print("[Baixador] Iniciando carga customizada de scripts...")
        executarFilaCustomizadaHTTP(1)
    end
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

-- DISPARO DA INTERFACE
injetarPainelDeEscolhasNaJanela()
executarFilaCustomizadaHTTP(1)
