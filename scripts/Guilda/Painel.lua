-- main tab
setDefaultTab("main")

local ui = setupUI([[
Panel
  height: 20

  Label
    id: editDonator
    background-color: #00000088
    color: pink
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20
    text-align: center
    text: =================================================================
]], parent)

-- Tabela de cores RGB completa
local colors = { 
    "#FF0000", "#FF4000", "#FF8000", "#FFBF00",
    "#FFFF00", "#BFFF00", "#80FF00", "#40FF00",
    "#00FF00", "#00FF40", "#00FF80", "#00FFBF",
    "#00FFFF", "#00BFFF", "#0080FF", "#0040FF",
    "#0000FF", "#4000FF", "#8000FF", "#BF00FF",
    "#FF00FF", "#FF00BF", "#FF0080", "#FF0040" 
}

local colorIndex = 1

macro(100, function()
    if not ui or not ui.editDonator then return end

    ui.editDonator:setColor(colors[colorIndex])
    colorIndex = colorIndex + 1
    if colorIndex > #colors then
        colorIndex = 1
    end
end)

local botWindow = modules.game_bot.botWindow
local contents = botWindow:recursiveGetChildById("contentsPanel")

-- Configuração dos caminhos das imagens
local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text
local pathBase = "/bot/" .. configName .. "/Imagens/"


local imgFixa = pathBase .. "brinquecustom" 

-- Função para aplicar a imagem
local function changeBotImage(path)
    if contents then
        contents:setImageSource(path)
        contents:setImageFixedRatio(false)
        contents:setImageRepeated(false)
    end
end

-- Configurações visuais da janela (por Brinque)
botWindow:setWidth(216)
botWindow.closeButton:setImageColor("#363434")
botWindow.minimizeButton:setImageColor("#363434")

-- Carrega a imagem fixa ao iniciar o bot
changeBotImage(imgFixa)

local function updateButtonsBot()
  modules.game_bot.botWindow.closeButton:setImageColor("#363434")
  modules.game_bot.botWindow.minimizeButton:setImageColor("#363434")
  modules.game_bot.botWindow.lockButton:setImageColor("#363434")
  modules.game_bot.botWindow:setImageSource()
  modules.game_bot.botWindow:setBackgroundColor("black")
  modules.game_bot.botWindow:setBorderWidth(1)
  modules.game_bot.botWindow:setBorderColor("black")
  modules.game_bot.botWindow:setText("BRINQUE")
  modules.game_bot.botWindow:setFont("verdana-11px-rounded")
  modules.game_bot.botWindow:setColor("red")
end
updateButtonsBot()

UI.Separator()
