script_name("Admin Tools")
script_author("Lisov AND Rowtea")

-- Инклуды --
local encoding = require 'encoding'
local sampev = require 'samp.events'
local key = require 'vkeys'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
-- Инклуды --

-- Переменные --
local activate = false
imgui.Process = false
local show_admin_menu = imgui.ImBool(false)
-- Переменные --

function cmd_amenu()
    show_admin_menu.v = not show_admin_menu.v
    imgui.Process = show_admin_menu.v
end

function apply_custom_style()
    imgui.SwitchContext()
      local style = imgui.GetStyle()
      local colors = style.Colors
      local clr = imgui.Col
      local ImVec4 = imgui.ImVec4
    
      style.WindowPadding = imgui.ImVec2(15, 15)
      style.WindowRounding = 1.5
      style.FramePadding = imgui.ImVec2(5, 5)
      style.FrameRounding = 4.0
      style.ItemSpacing = imgui.ImVec2(12, 8)
      style.ItemInnerSpacing = imgui.ImVec2(8, 6)
      style.IndentSpacing = 25.0
      style.ScrollbarSize = 15.0
      style.ScrollbarRounding = 9.0
      style.GrabMinSize = 5.0
      style.GrabRounding = 3.0
    
      colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
      colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
      colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
      colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
      colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
      colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
      colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
      colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
      colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
      colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
      colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
      colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
      colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
      colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
      colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
      colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
      colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
      colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
      colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
      colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
      colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
      colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
      colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
      colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
      colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
      colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
      colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
      colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
      colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
      colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
      colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
      colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
      colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
      colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
      colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
      colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
      colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
      colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
      colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
      colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
    end
    
    do
    
    apply_custom_style()
    
    
    local slider_float = imgui.ImFloat(0.0)
    local clear_color = imgui.ImVec4(0.45, 0.55, 0.60, 1.00)
    local show_moon_imgui_tutorial = {imgui.ImBool(false), imgui.ImBool(false), imgui.ImBool(false)}
    local moonimgui_text_buffer = imgui.ImBuffer('test', 256)
    local sampgui_texture = nil
    local cb_render_in_menu = imgui.ImBool(imgui.RenderInMenu)
    local cb_lock_player = imgui.ImBool(imgui.LockPlayer)
    local cb_show_cursor = imgui.ImBool(imgui.ShowCursor)
    local glyph_ranges_cyrillic = nil

function imgui.OnDrawFrame()
        if show_admin_menu.v then
            local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(400, 350), imgui.Cond.FirstUseEver)
            imgui.Begin('Admin Tools', show_admin_menu)
            imgui.Text(u8'Работает')
            imgui.End()
        end
    end
end

function main()
    -- Загрузка SAMP --
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(0) end
    -- Загрузка SAMP --

    -- Проверка Конфигурационных Файлов --
    local ip, port = sampGetCurrentServerAddress()
    if ip == '176.32.39.179' then
        sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Скрипт успешно активирован | Author: Fernando Miracle | Marchionne Rowtea", -1)
        activate = true
    else
        sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Вы должны находится на States Role Play! Скрипт деактивирован", -1)
    end

    -- Команды --
    sampRegisterChatCommand("/amenu", cmd_amenu)
    -- Команды --

    wait(0)

    while true do
        wait(0)
        if activate == false then return end

        imgui.Process = show_admin_menu.v
    end
end