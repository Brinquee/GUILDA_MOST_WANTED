macro(500, "Mudar Perfil do Target", function()
    -- CONFIGURAÇÃO: Altere os nomes abaixo conforme a sua necessidade
    local monstroEspecial = "Minishabaal"   -- Nome do monstro que ativa a mudança
    local perfilEspecial = "ataca_seguindo"     -- Nome do perfil de target para o monstro
    local perfilPadrao = "Todos_sem_Folow"    -- Nome do seu perfil de target padrão

    local monstroNaTela = false
    local specs = getSpectators(false)
    
    if specs then
        for _, spec in ipairs(specs) do
            if spec and spec:isMonster() and spec:getName() == monstroEspecial then
                monstroNaTela = true
                break
            end
        end
    end

    -- SE O MONSTRO ESTIVER NA TELA: Ativa o perfil especial
    if monstroNaTela then
        TargetBot.setCurrentProfile(perfilEspecial)
    -- SE NÃO ESTIVER: Retorna para o perfil padrão
    else
        TargetBot.setCurrentProfile(perfilPadrao)
    end
end)

-- O próprio addIcon agora gerencia o loop de 500ms e se está ativado ou não
addIcon("AntiPlayer", {
    item = 22890, -- ID do item visual (Crystal Coin)
    text = "Anti-Player",
    name = "Anti-Player Auto Toggle"
}, macro(500, function()
    local playersOnScreen = false
    local specs = getSpectators(false)
    
    if specs then
        for _, spec in ipairs(specs) do
            -- Ignora você mesmo e verifica se há outros players na tela
            if spec and spec:isPlayer() and spec:getName() ~= name() then
                playersOnScreen = true
                break
            end
        end
    end

    -- Gerenciamento do TargetBot com base no resultado da tela
    if playersOnScreen then
        if TargetBot.isOn() then
            TargetBot.setOff()
        end
    else
        if TargetBot.isOff() then
            TargetBot.setOn()
        end
    end
end))