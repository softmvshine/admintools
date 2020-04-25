script_name("Admin Tools")
script_author("Lisov AND Rowtea")
script_version("26.04.2020")

-- Инклуды --
local encoding = require 'encoding'
local sampev = require 'samp.events'
local key = require 'vkeys'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local notf = import 'lib/imgui_notf.lua'
-- Инклуды --

local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED) -- свой id.
local names = sampGetPlayerNickname(playerid) -- свой ник.

whVisible = "all"
optionsCommand = "settingswh"
defaultState = false


local ffi = require "ffi"
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
require "lib.moonloader"
local mem = require "memory"
local citem = imgui.ImInt(0)

-- Переменные --
local activate = false
imgui.Process = false

-- Админские переменные --
local forma = false
local formb = false
local formc = false
local openmp = true
local vzaimod = imgui.ImBool(false)
local admin_newmenu = imgui.ImBool(false)
local show_admin_templeader = imgui.ImBool(false)
local show_admin_tp = imgui.ImBool(false)
local show_admin_menu = imgui.ImBool(false)
local show_admin_prav = imgui.ImBool(false)
local show_admin_info = imgui.ImBool(false)
local new_report = false
local user_report_name = nil
local user_report_id = nil
local prize = imgui.ImInt(0)
-- Переменные --

local color = 0x00FFFF

local tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
"UtilityTrailer"}
local tCarsTypeName = {"Автомобиль", "Мотоицикл", "Вертолёт", "Самолёт", "Прицеп", "Лодка", "Другое", "Поезд", "Велосипед"}
local tCarsSpeed = {43, 40, 51, 30, 36, 45, 30, 41, 27, 43, 36, 61, 46, 30, 29, 53, 42, 30, 32, 41, 40, 42, 38, 27, 37,
54, 48, 45, 43, 55, 51, 36, 26, 30, 46, 0, 41, 43, 39, 46, 37, 21, 38, 35, 30, 45, 60, 35, 30, 52, 0, 53, 43, 16, 33, 43,
29, 26, 43, 37, 48, 43, 30, 29, 14, 13, 40, 39, 40, 34, 43, 30, 34, 29, 41, 48, 69, 51, 32, 38, 51, 20, 43, 34, 18, 27,
17, 47, 40, 38, 43, 41, 39, 49, 59, 49, 45, 48, 29, 34, 39, 8, 58, 59, 48, 38, 49, 46, 29, 21, 27, 40, 36, 45, 33, 39, 43,
43, 45, 75, 75, 43, 48, 41, 36, 44, 43, 41, 48, 41, 16, 19, 30, 46, 46, 43, 47, -1, -1, 27, 41, 56, 45, 41, 41, 40, 41,
39, 37, 42, 40, 43, 33, 64, 39, 43, 30, 30, 43, 49, 46, 42, 49, 39, 24, 45, 44, 49, 40, -1, -1, 25, 22, 30, 30, 43, 43, 75,
36, 43, 42, 42, 37, 23, 0, 42, 38, 45, 29, 45, 0, 0, 75, 52, 17, 32, 48, 48, 48, 44, 41, 30, 47, 47, 40, 41, 0, 0, 0, 29, 0, 0
}
local tCarsType = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1,
3, 1, 1, 1, 1, 6, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 6, 3, 2, 8, 5, 1, 6, 6, 6, 1,
1, 1, 1, 1, 4, 2, 2, 2, 7, 7, 1, 1, 2, 3, 1, 7, 6, 6, 1, 1, 4, 1, 1, 1, 1, 9, 1, 1, 6, 1,
1, 3, 3, 1, 1, 1, 1, 6, 1, 1, 1, 3, 1, 1, 1, 7, 1, 1, 1, 1, 1, 1, 1, 9, 9, 4, 4, 4, 1, 1, 1,
1, 1, 4, 4, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 1, 1,
1, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 4,
1, 1, 1, 2, 1, 1, 5, 1, 2, 1, 1, 1, 7, 5, 4, 4, 7, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 1, 5, 5
}

function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    style.WindowPadding = imgui.ImVec2(9, 5)
    style.WindowRounding = 10
    style.ChildWindowRounding = 10
    style.FramePadding = imgui.ImVec2(5, 3)
    style.FrameRounding = 6.0
    style.ItemSpacing = imgui.ImVec2(9.0, 3.0)
    style.ItemInnerSpacing = imgui.ImVec2(9.0, 3.0)
    style.IndentSpacing = 21
    style.ScrollbarSize = 6.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 17.0
    style.GrabRounding = 16.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)


    colors[clr.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00)
    colors[clr.TextDisabled]           = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.ChildWindowBg]          = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.PopupBg]                = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.Border]                 = ImVec4(0.82, 0.77, 0.78, 1.00)
    colors[clr.BorderShadow]           = ImVec4(0.35, 0.35, 0.35, 0.66)
    colors[clr.FrameBg]                = ImVec4(1.00, 1.00, 1.00, 0.28)
    colors[clr.FrameBgHovered]         = ImVec4(0.68, 0.68, 0.68, 0.67)
    colors[clr.FrameBgActive]          = ImVec4(0.79, 0.73, 0.73, 0.62)
    colors[clr.TitleBg]                = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.46, 0.46, 0.46, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.MenuBarBg]              = ImVec4(0.00, 0.00, 0.00, 0.80)
    colors[clr.ScrollbarBg]            = ImVec4(0.00, 0.00, 0.00, 0.60)
    colors[clr.ScrollbarGrab]          = ImVec4(1.00, 1.00, 1.00, 0.87)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(1.00, 1.00, 1.00, 0.79)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.80, 0.50, 0.50, 0.40)
    colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 0.99)
    colors[clr.CheckMark]              = ImVec4(0.99, 0.99, 0.99, 0.52)
    colors[clr.SliderGrab]             = ImVec4(1.00, 1.00, 1.00, 0.42)
    colors[clr.SliderGrabActive]       = ImVec4(0.76, 0.76, 0.76, 1.00)
    colors[clr.Button]                 = ImVec4(0.51, 0.51, 0.51, 0.60)
    colors[clr.ButtonHovered]          = ImVec4(0.68, 0.68, 0.68, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.67, 0.67, 0.67, 1.00)
    colors[clr.Header]                 = ImVec4(0.72, 0.72, 0.72, 0.54)
    colors[clr.HeaderHovered]          = ImVec4(0.92, 0.92, 0.95, 0.77)
    colors[clr.HeaderActive]           = ImVec4(0.82, 0.82, 0.82, 0.80)
    colors[clr.Separator]              = ImVec4(0.73, 0.73, 0.73, 1.00)
    colors[clr.SeparatorHovered]       = ImVec4(0.81, 0.81, 0.81, 1.00)
    colors[clr.SeparatorActive]        = ImVec4(0.74, 0.74, 0.74, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.80, 0.80, 0.80, 0.30)
    colors[clr.ResizeGripHovered]      = ImVec4(0.95, 0.95, 0.95, 0.60)
    colors[clr.ResizeGripActive]       = ImVec4(1.00, 1.00, 1.00, 0.90)
    colors[clr.CloseButton]            = ImVec4(0.45, 0.45, 0.45, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.70, 0.70, 0.90, 0.60)
    colors[clr.CloseButtonActive]      = ImVec4(0.70, 0.70, 0.70, 1.00)
    colors[clr.PlotLines]              = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(1.00, 1.00, 1.00, 0.35)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.88, 0.88, 0.88, 0.35)
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
        if admin_newmenu.v then
		    local iScreenWidth, iScreenHeight = getScreenResolution()
			local tLastKeys = {}
            local btn_size = imgui.ImVec2(-0.1, 0)
        	imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        	imgui.SetNextWindowSize(imgui.ImVec2(800, 400), imgui.Cond.FirstUseEver)
        	imgui.Begin(u8"Admin Tools | Главное меню", admin_newmenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.ShowBorders + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
            imgui.BeginChild('left', imgui.ImVec2(200, 0), true) 
		
	
        if not selected then selected = 1 end
            if imgui.Selectable(u8'Информация', false) then selected = 1 end
            if imgui.Selectable(u8'Список команд', false) then selected = 2 end
			if imgui.Selectable(u8'Основные функции', false) then selected = 3 end
            if imgui.Selectable(u8'Телепортация', false) then selected = 4 end
            if imgui.Selectable(u8'Мероприятия', false) then selected = 5 end
			if imgui.Selectable(u8'Настройки скрипта', false) then selected = 6 end
            if imgui.Selectable(u8'О скрипте', false) then selected = 7 end
            imgui.EndChild()
            imgui.SameLine()

			imgui.BeginChild('right', imgui.ImVec2(0, 0), true)
            if selected == 1 then
			imgui.Text(u8('Информация / Авторы скипта: Fernando Miracle | Marchionne Rowtea'))
			imgui.Separator()
			if imgui.Button(u8'Правила наказаний', btn_size) then
                show_admin_prav.v = not show_admin_prav.v
                imgui.Process = show_admin_prav.v
            end
		end	
		if selected == 2 then
			imgui.Text(u8('Список команд / Авторы скипта: Fernando Miracle | Marchionne Rowtea'))
			imgui.Separator()
			imgui.Text(u8('/afk [ID игрока] -- Опрашивает игрока на АФК без esc.'))
		  end
		if selected == 3 then
			imgui.Text(u8('Основные функции / Авторы скипта: Fernando Miracle | Marchionne Rowtea'))
			imgui.Separator()
			if imgui.CollapsingHeader(u8'Сообщения /msg') then
							if imgui.Button(u8'Информация в /msg', btn_size) then
							lua_thread.create(function()
							sampSendChat("/msg Дорогие друзья, вступайте в наш дружелюбный Discord - discord.gg/Tr4F9mu")
							wait(1000)
							sampSendChat("/msg Наш сайт - samp-states.ru / Наша группа - vk.com/sampstatesrp")
							wait(1000)
							sampSendChat("/msg Посетите нашу информационную группу по адресу - vk.com/news.statesrp")
							wait(1000)
							sampSendChat("/msg На форуме можете оформить себе Амнистию 'Форум - Курилка - Амнистия'.")
							wait(1000)
							sampSendChat("/msg Перейти на наш форум вы можете по ссылке - forum.samp-states.ru")
							wait(1000)
							sampSendChat("/msg На этом информация закончилась. Приятной Игры на States Role Play :-)")
							end)
						end
						if imgui.Button(u8'Информация о /spwancars', btn_size) then
						lua_thread.create(function()
						sampSendChat("/msg Уважаемые Игроки! Через 30 секунд произойдёт респавн транспорта! Займите машины")
						wait(30000)
						sampSendChat("/spawncars")
					end)
				end
				if imgui.Button(u8'Ждем ваших репортов (msg)', btn_size) then
				sampSendChat("/msg Уважаемые игроки, администрация ждет ваших репортов - /report.")
				end
			end
			if imgui.CollapsingHeader(u8'Мероприятие') then
				if imgui.Button(u8'Прятки', btn_size) then
					sampSendChat("/msg Уважаемые игроки проходит мероприятие 'Прятки', желающие - /gotomp")
					end
					if imgui.Button(u8'Король Дигла', btn_size) then
					sampSendChat("/msg Уважаемые игроки проходит мероприятие 'Король Дигла', желающие - /gotomp")
					end
					if imgui.Button(u8'Поливалка', btn_size) then
					sampSendChat("/msg Уважаемые игроки проходит мероприятие 'Поливалка', желающие - /gotomp")
					end
					if imgui.Button(u8'Русская Рулетка', btn_size) then
					sampSendChat("/msg Уважаемые игроки проходит мероприятие 'Русская Рулетка', желающие - /gotomp")
					end
			end
			if imgui.CollapsingHeader(u8'Лидерство') then
				if imgui.Button(u8'Новый лидер', btn_size) then
					sampSetChatInputEnabled(true)
					  sampSetChatInputText("/msg Новый лидер организации 'фрак' - nickname")
					end
					if imgui.Button(u8'Снятие лидера', btn_size) then
					sampSetChatInputEnabled(true)
					  sampSetChatInputText("/msg Лидер организации 'фрак' nickname, был снят с поста.")
					end
					if imgui.Button(u8'Срок лидерства', btn_size) then
					sampSetChatInputEnabled(true)
					  sampSetChatInputText("/msg Лидер организации 'фрак' - nickname, успешно отстоял срок.")
				end
			end
		end
		if selected == 4 then
			imgui.Text(u8('Телепортация / Авторы скипта: Fernando Miracle | Marchionne Rowtea'))
			imgui.Separator()
			if imgui.CollapsingHeader(u8'Общественные Места') then
		        if imgui.Button(u8'Автовокзал', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1763.1560058594, -1896.3155517578, 13.560709953308)
		        end
		        if imgui.Button(u8'Мэрия', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1477.7521972656, -1738.6071777344, 13.546875)
		        end
		        if imgui.Button(u8'Банк', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1576.1254882813, -1327.3795166016, 16.484375)
		        end
		        if imgui.Button(u8'ВайнВуд', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1447.4411621094, -783.56854248047, 93.964134216309)
		        end
		        if imgui.Button(u8'Казино', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1021.2512207031, -1129.4576416016, 23.867818832397)
		        end
		    end
		    if imgui.CollapsingHeader(u8'Государственные Структуры') then
		        if imgui.Button(u8'Правительство', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1481.0541, -1743.6437, 13.5469)
		        end
		        if imgui.Button(u8'Полиция', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1548.2714, -1675.6670, 14.4509)
		        end
		        if imgui.Button(u8'Полиция(Гараж)', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1575.0139, -1696.7513, 6.2188)
		        end
		        if imgui.Button(u8'FBI', btn_size) then
		            setCharCoordinates(PLAYER_PED, -2436.6685, 507.1047, 29.9308)
		        end
		        if imgui.Button(u8'Больница', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1181.7573, -1323.5408, 13.5824)
		        end
		        if imgui.Button(u8'СМИ', btn_size) then
		            setCharCoordinates(PLAYER_PED, 430.2165, -1787.6193, 5.6046)
		        end
		        if imgui.Button(u8'Армия', btn_size) then
		            setCharCoordinates(PLAYER_PED, 219.1929, 1902.0972, 17.6406)
		        end
		        if imgui.Button(u8'Автошкола', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1160.6288, -1186.3669, 20.0469)
		        end
		    end
		    if imgui.CollapsingHeader(u8'Преступные структуры') then
		        if imgui.Button(u8'LCN', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1040.8848876953, 1066.1143798828, 10.170858383179)
		        end
		        if imgui.Button(u8'RM', btn_size) then
		            setCharCoordinates(PLAYER_PED, 947.60089111328, 1733.1422119141, 8.8515625)
		        end
		        if imgui.Button(u8'Yakuza', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1462.2647705078, 2788.2216796875, 10.8203125)
		        end
		    end
		    if imgui.CollapsingHeader(u8'Нелегальные структуры') then
		        if imgui.Button(u8'Ballas', btn_size) then
		            setCharCoordinates(PLAYER_PED, 2000.8017578125, -1127.4362792969, 25.484676361084)
		        end
		        if imgui.Button(u8'Rifa', btn_size) then
		            setCharCoordinates(PLAYER_PED, 2180.5029296875, -1797.7971191406, 13.363551139832)
		        end
		        if imgui.Button(u8'Groove', btn_size) then
		            setCharCoordinates(PLAYER_PED, 2488.2199707031, -1671.5731201172, 13.335947036743)
		        end
		        if imgui.Button(u8'Vagos', btn_size) then
		            setCharCoordinates(PLAYER_PED, 2831.4533691406, -1183.0113525391, 24.829055786133)
		        end
		        if imgui.Button(u8'Aztec', btn_size) then
		            setCharCoordinates(PLAYER_PED, 1722.9276123047, -2117.9775390625, 13.546875)
		        end
			end
        end
        if selected == 5 then
            local gids = {24,31}
            local gnames ={u8"Не выбрано", u8"Король Дигла", u8"Поливалка", u8"Русская Рулетка", u8"Прятки"}
            imgui.PushItemWidth(190)
            imgui.Combo(u8"Выберите Мероприятие", citem, gnames)
            imgui.PushItemWidth(190)
            imgui.InputInt(u8"Введите Приз", prize, 0)
            if imgui.Button(u8"Опубликовать") then
                lua_thread.create(function()
                    sampSendChat("/msg Уважаемые игроки проходит мероприятие: "..u8:decode(gnames[citem.v + 1]))
                    wait(1000)
                    sampSendChat("/msg Приз мероприятия составляет: "..u8:decode(prize.v).."$")
                    wait(1000)
                    sampSendChat("/msg Для телепортации введите: /gotomp")
                    wait(1000)
                    sampSendChat("/mp")
                end)
            end
            imgui.Separator()
            imgui.Text(u8("Примерный Текст Оповещения\nУважаемые игроки проходит мероприятие: "..u8:decode(gnames[citem.v + 1]).."\nПриз Мероприятия составляет: "..prize.v.."\nДля телепортации введите: /gotomp"))
            imgui.Separator()
            if imgui.Button(u8"Правила Мероприятия", btn_size) then
                lua_thread.create(function() 
                    sampSendChat("/msg [МП] Правила Мероприятия:")
                    wait(1000)
                    sampSendChat("/msg [МП] На мероприятии запрещены: Аптечки, Маски, Анимации, Наркотики")
                    wait(1000)
                    sampSendChat("/msg [МП] Администратор в праве разрешить использовать данные функции")
                    wait(1000)
                    sampSendChat("/msg [МП] Всем желаю удачи <3")
                end)
            end 
        end
		if selected == 6 then
			imgui.Text(u8('Настройки скрипта / Авторы скипта: Fernando Miracle | Marchionne Rowtea'))
			imgui.Separator()	
			imgui.Text(u8('Название\t\t\t\t\t\t\t\t\t\t\t\tАктивация'))
			imgui.Text(u8('WallHack\t\t\t\t\t\t\t\t\t\t\t\t ALT+3(/settingswh)'))
        end
		if selected == 7 then
			imgui.Text(u8('О скрипте'))
			imgui.Separator()	
			imgui.Text(u8('Авторы скипта: Fernando Miracle | Marchionne Rowtea'))
			imgui.PushItemWidth(530)
            if imgui.Button(u8'Fernando Miracle (VK)') then
                os.execute('explorer "https://vk.com/lisov218"')
			end
            imgui.SameLine()
            imgui.PushItemWidth(530)
            if imgui.Button(u8'Marchionne Rowtea (VK)') then
                os.execute('explorer "https://vk.com/richardski"')
			end
			imgui.SameLine()
			imgui.TextQuestion(u8'Внимание откроется ваш браузер, который стоит по умолчанию!')
			imgui.Text(u8('Уважаемый администратор, если вы нашли баг/ошибку отпишите одному из авторов скрипта.'))
		end
			imgui.EndChild()
			imgui.End()
        end
        if show_admin_prav.v then
		    local sw, sh = getScreenResolution()
		    -- center
		    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		    imgui.SetNextWindowSize(imgui.ImVec2(1190, 400), imgui.Cond.FirstUseEver)
		    imgui.Begin(u8'', show_admin_prav, imgui.WindowFlags.NoResize + imgui.WindowFlags.ShowBorders + imgui.WindowFlags.NoCollapse)
		    local btn_size = imgui.ImVec2(-0.1, 0)
			imgui.Text(u8'Наказание Бан:\nИгрокам запрещено использовать посторонние чит-программы, программы взлома игрового функционала. Наказание: бан 30 дней.\nИспользование / хранение запрещённых читерских программ: Aim, Speed Hack, Wall Hack, Fly, DGun, Cleo HP, Autorepair/GM Car, Airbreak, Fast Gan, Рванка Собейт - от 10 до 30 дней\nУпоминание родных /Оскорбление в нике - 30 дней бана.\nОскорбление родных - от 10 до 30 дней бана.\nНеадекватное поведение - от 1 до 3 дней бана.\nЗа рекламу других серверов сайтов форумов и прочее нарушителю выдается бан на 7 дней + ban IP.\nЗа оскорбление проекта в любой чат сервера нарушителю выдается бан на 7 дней + ban IP.\nНа сервере запрещено всяческое мошенничество других игроков, обман, и мошенничество в целях кражи личного имущества (Недвижимость,ТС, Вирты) игроков. Наказание: бан 30 дней.\nЗапрещен обман администрации проекта, наказывается: BAN 3 day.\nЗа использования багоюза системы сервера, нарушителю выдается бан до 5 дней.\n\nНаказание Мут:\nИгрокам запрещено оскорблять других игроков, выражаться нецензурной бранью в ООС и IC чаты, оскорблять и унижать честь и достоинства игроков. Наказание: Mute 30 min.\nЗа CAPS в ic чат, в репорт или в /r /f чаты нарушителю выдается бан чата до 10 минут.\nЗа оффтоп в репорт нарушителю выдается бан чата на 20 минут.\nЗа флуд во все чаты включая /b чат нарушителю выдается бан чата от 10 до 20 минут.\nЗа оскорбление игрока или администратора в репорт игрок получает бан чата до 60 минут.\nЗа транслит в ic чат нарушителю выдаётся бан чата от 5 до 10 минут.\n\nНаказние Варн/Деморган:\nЛюбому игроку запрещено нарушать игровой процесс и влезать в него под основанием DM. Убийство без причины//массовое убийство игроков//нарушение игрового процесса...\n...убийство не имея на то Role Play оснований, наказывается: деморган 2 часа.\nИгрокам запрещено использовать в качестве оружия для убийства транспортное средство (DB), не имея на то Role Play оснований наказание: деморган 30 - 60 минут.\nЗа ДМ в ЗЗ нарушителю выдается деморган 15 - 30 минут.\nЗа ДМ нарушителю выдается деморган 15 - 30 минут.\nЗа SpawnKill нарушителю выдается деморган 15 - 20 минут.\nЗа ДБ нарушитель помещается в деморган 15 - 20 минут.\nЗа Team kill нарушителю выдается варн или деморган 30 - 60 минут.\nЗа сбив анимации игроку выдаётся деморган 15 минут.\nЗа использования багоюза +с, выдается деморган 15 минут.. Исключение, гетто.\nЗа ДМ в КПЗ, нарушителю выдается варн.')
			imgui.End()
        end
        if vzaimod.v then
            local name = sampGetPlayerNickname(vzID)
            local btn_size = imgui.ImVec2(-0.1, 0)
            imgui.Begin(u8"Меню взаимодействий",vzaimod,imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
            imgui.SetCursorPosX((imgui.GetWindowWidth() - 290) / 2)
            imgui.Text(string.format(u8"Взаимодействие с игроком %s[%s]", name, vzID))
            imgui.Separator()
            imgui.Text(u8("Command function"))
            imgui.BeginChild("##g_sexbar", imgui.ImVec2(370, 187), true, imgui.WindowFlags.NoScrollbar)
            if imgui.Button(u8'Статистика игрока', btn_size) then
                lua_thread.create(function()
                sampSendChat(string.format(u8"/stats %s", vzID))
                end)
            end
            if imgui.Button(u8'Деньги игрока', btn_size) then
                lua_thread.create(function()
                sampSendChat(string.format(u8"/money %s", vzID))
                end)
            end
            if imgui.Button(u8'Отправить игрока на спавн', btn_size) then
                lua_thread.create(function()
                sampSendChat(string.format(u8"/spawn %s", vzID))
                end)
            end
            if imgui.Button(u8'Подкинуть Игрока', btn_size) then
                lua_thread.create(function()
                sampSendChat(string.format(u8"/slap %s", vzID))
                end)
            end
            if imgui.Button(u8'Телепортироваться к игроку', btn_size) then
                lua_thread.create(function()
                sampSendChat(string.format(u8"/goto %s", vzID))
                end)
            end
            if imgui.Button(u8'Телепортировать игрока к себе', btn_size) then
                lua_thread.create(function()
                sampSendChat(string.format(u8"/gethere %s", vzID))
                end)
            end
            if imgui.Button(u8'Заморозить игрока', btn_size) then
                lua_thread.create(function()
                sampSendChat(string.format(u8"/freeze %s", vzID))
                end)
            end
            if imgui.Button(u8'Разаморозить игрока', btn_size) then
                lua_thread.create(function()
                sampSendChat(string.format(u8"/unfreeze %s", vzID))
                end)
            end
            imgui.EndChild()
            imgui.Text(u8("Recon function"))
            imgui.BeginChild("##g_sear", imgui.ImVec2(370, 155), true, imgui.WindowFlags.NoScrollbar)
            if imgui.Button(u8'Проверка игрока на АФК без esc', btn_size) then
                lua_thread.create(function()
                sampSendChat("/ans ".. vzID .." ".. name .."[".. vzID .."] Вы тут? Ответ в любой чат.")
                wait(900)
                sampSendChat("/ans ".. vzID .." ".. name .."[".. vzID .."] Вы тут? Ответ в любой чат.")
                wait(1000)
                sampSendChat("/ans ".. vzID .." ".. name .."[".. vzID .."] Вы тут? Ответ в любой чат.")
                end)
            end
            if imgui.Button(u8'ИП игрока', btn_size) then
                lua_thread.create(function()
                sampSendChat(string.format(u8"/checkip %s", vzID))
                end)
            end
            if imgui.Button(u8'Выдать игроку здоровье', btn_size) then
                lua_thread.create(function()
                sampSendChat("/sethp ".. vzID .." 100")
                wait(700)
                sampSendChat("/a [Admin Tools] Выдал 100 HP игроку ".. name .."[".. vzID .."]")
                end)
            end
            imgui.EndChild()
            if imgui.Button(u8'Закрыть',imgui.ImVec2(370,20)) then
                vzaimod.v = false
            end
            imgui.End()
        end
    end
end

function main()
    -- Загрузка SAMP --
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(0) end
    notf.addNotification(string.format("Проверка Обновлений Скрипта", 115, os.date()), 15)
    autoupdate("https://raw.githubusercontent.com/softmvshine/admintools/master/checking.json", '{ff0000}[Admin Tools]{FFFFFF} ', "http://forum.samp-states.ru/threads/123/")
    -- Загрузка SAMP --
    

    -- Команды --
	sampRegisterChatCommand("amenu", cmd_amenu)
    sampRegisterChatCommand("afk", cmd_afk)
    sampRegisterChatCommand("check", function()
        print(forma)
        print(formb)
        print(formc)
    end)
    sampRegisterChatCommand(optionsCommand, function(param)
		if param == "bones" then whVisible = param; nameTagOff()
		elseif param == "names" or param == "all" then whVisible = param if not nameTag then nameTagOn() end
		else sampAddChatMessage("{ff0000}[Admin Tools]{FFFFFF} Введите корректный режим: names/bones/all", 0xFF4444FF) end
    end)
	while not sampIsLocalPlayerSpawned() do wait(100) end
	if defaultState and not nameTag then nameTagOn() end
    -- Команды --

    wait(0)

    while true do
        wait(0)
        if activate == false then return end

        imgui.Process = admin_newmenu.v or show_admin_prav.v or vzaimod.v

        if wasKeyPressed(key.VK_P) then
            local chatin = sampIsChatInputActive()
            if chatin == false then admin_newmenu.v = not admin_newmenu.v end
        end
        if wasKeyPressed(key.VK_F5) then
            if formb == true then
                if formacmd == "warn" or formacmd == "kick" then sampSendChat("/pm "..formaid.." Если вы не согласны с наказанием напишите жалобу forum.samp-states.ru") end
                    sampSendChat("/"..formacmd.." "..formaid.." "..formatime2.." • "..formaadm)
                    wait(1000) 
                    sampSendChat("/a [FORMA] +")
                    formb = false
                    formacmd = nil
                    formaid = nil
                    formatime = nil
            end
            if forma == true then
                    --if formacmd == "inftime" then sampSendChat("/pm "..formaid.." Если вы не согласны с наказанием напишите жалобу forum.samp-states.ru") end
                    sampSendChat("/"..formacmd.." "..formaid2.." • "..formaadm)
                    lua_thread.create(function() wait(1000) sampSendChat("/a [FORMA] +") end)
                    forma = false
                    formacmd = nil
                    formaid = nil
			end
            if formc == true then
                if formacmd == "jail" or formacmd == "ban" then sampSendChat("/pm "..formaid.." Если вы не согласны с наказанием напишите жалобу forum.samp-states.ru") end
                sampSendChat("/"..formacmd.." "..formaid3.." "..formatime3.." "..formareason3.." • "..formaadm)
                lua_thread.create(function() wait(1000) sampSendChat("/a [FORMA] +") end)
                formc = false
                formacmd = nil
                formaid3 = nil
                formatime3 = nil
                formareason3 = nil
            end
        end
        if isKeyJustPressed(VK_J) then
            local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
            if valid and doesCharExist(ped) then
                local result, id = sampGetPlayerIdByCharHandle(ped) 
                if result then 
                    vzaimod.v = true
                    vzID = id
                end
            end
        end
        if isKeyJustPressed(key.VK_3) and wasKeyPressed(key.VK_LMENU) then; 
            if defaultState then
                sampAddChatMessage("{ff0000}[Admin Tools]{FFFFFF} WallHack {ff0000}выключен{ffffff}", 0xFFFFFFFF)
                defaultState = false; 
				nameTagOff(); 
				while isKeyDown(KEY) do wait(100) end 
			else
                defaultState = true;
                sampAddChatMessage("{ff0000}[Admin Tools]{FFFFFF} WallHack {20ed15}включен{ffffff}", 0xFFFFFFFF)
				if whVisible ~= "bones" and not nameTag then nameTagOn() end
				while isKeyDown(KEY) do wait(100) end 
			end 
		end
		if defaultState and whVisible ~= "names" then
			if not isPauseMenuActive() and not isKeyDown(VK_F8) then
				for i = 0, sampGetMaxPlayerId() do
				if sampIsPlayerConnected(i) then
					local result, cped = sampGetCharHandleBySampPlayerId(i)
					local color = sampGetPlayerColor(i)
					local aa, rr, gg, bb = explode_argb(color)
					local color = join_argb(255, rr, gg, bb)
					if result then
						if doesCharExist(cped) and isCharOnScreen(cped) then
							local t = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
							for v = 1, #t do
								pos1X, pos1Y, pos1Z = getBodyPartCoordinates(t[v], cped)
								pos2X, pos2Y, pos2Z = getBodyPartCoordinates(t[v] + 1, cped)
								pos1, pos2 = convert3DCoordsToScreen(pos1X, pos1Y, pos1Z)
								pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
								renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
							end
							for v = 4, 5 do
								pos2X, pos2Y, pos2Z = getBodyPartCoordinates(v * 10 + 1, cped)
								pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
								renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
							end
							local t = {53, 43, 24, 34, 6}
							for v = 1, #t do
								posX, posY, posZ = getBodyPartCoordinates(t[v], cped)
								pos1, pos2 = convert3DCoordsToScreen(posX, posY, posZ)
							end
						end
					end
				end
			end
			else
				nameTagOff()
				while isPauseMenuActive() or isKeyDown(VK_F8) do wait(0) end
				nameTagOn()
			end
		end
    end
end

function cmd_amenu()
    admin_newmenu.v = not admin_newmenu.v
    imgui.Process = admin_newmenu.v
end

function imgui.TextQuestion(text)
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function sampev.onServerMessage(color, text)
if text:find("[A]", 1, true) then
    if text:find("/(.*) (.*) (.*)") then
        formacmd, formaid, formatime2 = text:match("/(%S+) (%d+) (%S+)")
        if formacmd == "kick" or formacmd == "warn" or formacmd == "sethp" or formacmd == "skick" or formacmd == "setskin" or formacmd == "givegun" then
            formadm = text:match("^%[A%] (%a+_%a+)")
            local one, two = formadm:match("(.).*_(.*)")
            formaadm = ("%s. %s"):format(one, two)
            formb = true
            lua_thread.create(function()
                wait(100)
                sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Пришла форма, для выполнения нажмите 'F5'", -1)
            end)
        end
    end
    if text:find("/(.*) (.*)") then
        formacmd, formaid2 = text:match("/(%S+) (.*)")
        formadm = text:match("^%[A%] (%a+_%a+)")
        local one, two = formadm:match("(.).*_(.*)")
        formaadm = ("%s. %s"):format(one, two)
        if formacmd == "slap" or formacmd == "uval" or formacmd == "msg" or formacmd == "inftime" then
            forma = true
            lua_thread.create(function()
                wait(100)
                sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Пришла форма, для выполнения нажмите 'F5'", -1)
            end)
        end
    end
    if text:find("/(.*) (%d+) (%d+) (.*)") then
        formacmd, formaid3, formatime3, formareason3 = text:match("/(%S+) (%d+) (%d+) (%d+)")
        formadm = text:match("^%[A%] (%a+_%a+)")
        local one, two = formadm:match("(.).*_(.*)")
        formaadm = ("%s. %s"):format(one, two)
        if formacmd == "ban" or formacmd == "jail" then
            formc = true
            lua_thread.create(function()
                wait(100)
                sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Пришла форма, для выполнения нажмите 'F5'", -1)
            end)
        end
    end
end
if forma == true then
    local formaname = sampGetPlayerNickname(formaid2)
    if text:find("пнул игрока "..formaname) then
        lua_thread.create(function()
            wait(100)
            sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Форма была выполнена другим администратором", -1)
        end)
        forma = false
    end
end
if formc == true then
    local formaname2 = sampGetPlayerNickname(formaid3)
    if text:find("забанил "..formaname2) then
        lua_thread.create(function()
            wait(100)
            sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Форма была выполнена другим администратором", -1)
        end)
        formc = false
    end
end
if formb == true then
    local formaname3 = sampGetPlayerNickname(formaid)
    if text:find("кикнул игрока "..formaname3) then
        lua_thread.create(function()
            wait(100)
            sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Форма была выполнена другим администратором", -1)
        end)
        formb = false
         end
    end
end

function getBodyPartCoordinates(id, handle)
    local pedptr = getCharPointer(handle)
    local vec = ffi.new("float[3]")
    getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
    return vec[0], vec[1], vec[2]
  end
  
  function nameTagOn()
      local pStSet = sampGetServerSettingsPtr();
      NTdist = mem.getfloat(pStSet + 39)
      NTwalls = mem.getint8(pStSet + 47)
      NTshow = mem.getint8(pStSet + 56)
      mem.setfloat(pStSet + 39, 1488.0)
      mem.setint8(pStSet + 47, 0)
      mem.setint8(pStSet + 56, 1)
      nameTag = true
  end
  
  function nameTagOff()
      local pStSet = sampGetServerSettingsPtr();
      mem.setfloat(pStSet + 39, NTdist)
      mem.setint8(pStSet + 47, NTwalls)
      mem.setint8(pStSet + 56, NTshow)
      nameTag = false
  end
  
  function join_argb(a, r, g, b)
    local argb = b  -- b
    argb = bit.bor(argb, bit.lshift(g, 8))  -- g
    argb = bit.bor(argb, bit.lshift(r, 16)) -- r
    argb = bit.bor(argb, bit.lshift(a, 24)) -- a
    return argb
  end
  
  function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
  end

function sampev.onShowDialog(dialogId, style, tittle, button1, button2, text)
end

function cmd_afk(arg)
	lua_thread.create(function()
		args = tonumber(arg)
		if not args then sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Введите ID игрока", -1) return end
        sampSendChat("/ans "..arg.." Вы тут? Ответ в любой чат.")
        wait(900)
		sampSendChat("/ans "..arg.." Вы тут? Ответ в любой чат.")
		wait(1000)
        sampSendChat("/ans "..arg.." Вы тут? Ответ в любой чат.")
    end)
end
function autoupdate(json_url, prefix, url)
    local dlstatus = require('moonloader').download_status
    local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile(json_url, json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, 'r')
            if f then
              local info = decodeJson(f:read('*a'))
              updatelink = info.updateurl
              updateversion = info.latest
              f:close()
              os.remove(json)
              if updateversion ~= thisScript().version then
                lua_thread.create(function(prefix)
                  local dlstatus = require('moonloader').download_status
                  local color = -1
                  notf.addNotification(string.format("Обновляюсь на версию: "..thisScript().updateversion, 115, os.date()), 15)
                  wait(250)
                  downloadUrlToFile(updatelink, thisScript().path,
                    function(id3, status1, p13, p23)
                      if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                        print(string.format('Загружено %d из %d.', p13, p23))
                      elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                        notf.addNotification(string.format(u8"Скрипт успешно обновлён\nВерсия скрипта: "..thisScript().version, 115, os.date()), 15)
                        notf.addNotification(string.format(u8"Помощник администратора, включен! Меню - /amenu", 115, os.date()), 15)
                        goupdatestatus = true
                        lua_thread.create(function() wait(500) thisScript():reload() end)
                      end
                      if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                        if goupdatestatus == nil then
                            notf.addNotification(string.format("Не удалось обновиться. Отпишите в ВК\nvk.com/lisov218\nvk.com/richardski", 115, os.date()), 15)
                          update = false
                        end
                      end
                    end
                  )
                  end, prefix
                )
              else
                update = false
                notf.addNotification(string.format("Помощник администратора, включен!\nВерсия за: "..thisScript().version.."\nОбновления не требуются", 115, os.date()), 15)
              end
            end
          else
            notf.addNotification(string.format(u8"Не могу проверить обновления. Отпишите в ВК\nvk.com/lisov218\nvk.com/richardski", 115, os.date()), 15)
            update = false
          end
        end
      end
    )
    while update ~= false do wait(100) end
  end