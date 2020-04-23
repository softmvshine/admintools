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


whVisible = "all"
optionsCommand = "settingswh"
defaultState = false


local ffi = require "ffi"
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
require "lib.moonloader"
local mem = require "memory"

-- Переменные --
local activate = false
imgui.Process = false

-- Админские переменные --
local forma = false
local formb = false
local formc = false
local show_admin_templeader = imgui.ImBool(false)
local show_admin_tp = imgui.ImBool(false)
local show_admin_menu = imgui.ImBool(false)
local show_admin_prav = imgui.ImBool(false)
local show_admin_info = imgui.ImBool(false)
local new_report = false
local user_report_name = nil
local user_report_id = nil
-- Переменные --

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
            local btn_size = imgui.ImVec2(-0.1, 0)
            if imgui.Button(u8'Телепортация', btn_size) then
            show_admin_tp.v = not show_admin_tp.v
            imgui.Process = show_admin_tp.v
            end
            if imgui.Button(u8'Таблица наказний', btn_size) then
            show_admin_prav.v = not show_admin_prav.v
            imgui.Process = show_admin_prav.v
            end
            if imgui.Button(u8'Временное лидество', btn_size) then
            show_admin_templeader.v = not show_admin_templeader.v
            imgui.Process = show_admin_templeader.v
            end
            if imgui.Button(u8'Информация о скрипте', btn_size) then
            show_admin_info.v = not show_admin_info.v
            imgui.Process = show_admin_info.v
            end
            imgui.End()
        end
        if show_admin_info.v then
		    local sw, sh = getScreenResolution()
		    -- center
		    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
		    imgui.Begin(u8'Информация о скрипте', show_admin_info)
			local btn_size = imgui.ImVec2(-0.1, 0)
			imgui.Text(u8('Авторы скрипта: Fernando Miracle | Marchionne Rowtea'))
            imgui.PushItemWidth(530)
            if imgui.Button(u8'Fernando Miracle (VK)') then
                os.execute('explorer "https://vk.com/lisov218"')
            end
            imgui.SameLine()
            imgui.PushItemWidth(530)
            if imgui.Button(u8'Marchionne Rowtea (VK)') then
                os.execute('explorer "https://vk.com/richardski"')
            end
            imgui.Text("\n")
            imgui.Separator()
            imgui.Text(u8'\nКоманды скрипта:\n/am(P) - Открытие меню скрипта\n/gg - Пожелать игроку приятной игры.\n/tppos - Телепортация по координатам.\n/st - Сокращенная команда /stats\n/aesc - Проверка игрока на АФК без еск')
		    imgui.End()
		end
		if show_admin_tp.v then
		    local sw, sh = getScreenResolution()
		    -- center
		    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		    imgui.SetNextWindowSize(imgui.ImVec2(300, 250), imgui.Cond.FirstUseEver)
		    imgui.Begin('Admin TP', show_admin_tp)
		    local btn_size = imgui.ImVec2(-0.1, 0)
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
		    if imgui.CollapsingHeader(u8'Гос') then
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
		    if imgui.CollapsingHeader(u8'Мафии') then
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
		    if imgui.CollapsingHeader(u8'Гетто') then
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
			imgui.End()
        end
        if show_admin_prav.v then
		    local sw, sh = getScreenResolution()
		    -- center
		    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		    imgui.SetNextWindowSize(imgui.ImVec2(700, 450), imgui.Cond.FirstUseEver)
		    imgui.Begin(u8'Таблица наказний', show_admin_prav)
		    local btn_size = imgui.ImVec2(-0.1, 0)
		    if imgui.CollapsingHeader(u8'Общее наказание') then
			imgui.Text(u8'Наказание Бан:\nИгрокам запрещено использовать посторонние чит-программы, программы взлома игрового функционала. Наказание: бан 30 дней.\nИспользование / хранение запрещённых читерских программ: Aim, Speed Hack, Wall Hack, Fly, DGun, Cleo HP, Autorepair/GM Car, Airbreak, Fast Gan, Рванка Собейт - от 10 до 30 дней\nУпоминание родных /Оскорбление в нике - 30 дней бана.\nОскорбление родных - от 10 до 30 дней бана.\nНеадекватное поведение - от 1 до 3 дней бана.\nЗа рекламу других серверов сайтов форумов и прочее нарушителю выдается бан на 7 дней + ban IP.\nЗа оскорбление проекта в любой чат сервера нарушителю выдается бан на 7 дней + ban IP.\nНа сервере запрещено всяческое мошенничество других игроков, обман, и мошенничество в целях кражи личного имущества (Недвижимость,ТС, Вирты) игроков. Наказание: бан 30 дней.\nЗапрещен обман администрации проекта, наказывается: BAN 3 day.\nЗа использования багоюза системы сервера, нарушителю выдается бан до 5 дней.\n\nНаказание Мут:\nИгрокам запрещено оскорблять других игроков, выражаться нецензурной бранью в ООС и IC чаты, оскорблять и унижать честь и достоинства игроков. Наказание: Mute 30 min.\nЗа CAPS в ic чат, в репорт или в /r /f чаты нарушителю выдается бан чата до 10 минут.\nЗа оффтоп в репорт нарушителю выдается бан чата на 20 минут.\nЗа флуд во все чаты включая /b чат нарушителю выдается бан чата от 10 до 20 минут.\nЗа оскорбление игрока или администратора в репорт игрок получает бан чата до 60 минут.\nЗа транслит в ic чат нарушителю выдаётся бан чата от 5 до 10 минут.\n\nНаказние Варн/Деморган:\nЛюбому игроку запрещено нарушать игровой процесс и влезать в него под основанием DM. Убийство без причины//массовое убийство игроков//нарушение игрового процесса...\n...убийство не имея на то Role Play оснований, наказывается: деморган 2 часа.\nИгрокам запрещено использовать в качестве оружия для убийства транспортное средство (DB), не имея на то Role Play оснований наказание: деморган 30 - 60 минут.\nЗа ДМ в ЗЗ нарушителю выдается деморган 15 - 30 минут.\nЗа ДМ нарушителю выдается деморган 15 - 30 минут.\nЗа SpawnKill нарушителю выдается деморган 15 - 20 минут.\nЗа ДБ нарушитель помещается в деморган 15 - 20 минут.\nЗа Team kill нарушителю выдается варн или деморган 30 - 60 минут.\nЗа сбив анимации игроку выдаётся деморган 15 минут.\nЗа использования багоюза +с, выдается деморган 15 минут.. Исключение, гетто.\nЗа ДМ в КПЗ, нарушителю выдается варн.')
			end
			imgui.End()
        end
        if show_admin_templeader.v then
		    local sw, sh = getScreenResolution()
		    -- center
		    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		    imgui.SetNextWindowSize(imgui.ImVec2(350, 450), imgui.Cond.FirstUseEver)
		    imgui.Begin(u8'Временное лидерство', show_admin_templeader)
            local btn_size = imgui.ImVec2(-0.1, 0)
            local list = sampGetCurrentDialogListItem()
            if imgui.CollapsingHeader(u8'Государственные Структуры') then
                if imgui.Button(u8'Правительство', btn_size) then 
                    sampSendChat("/templeader") 
                    sampSendDialogResponse(255, 0, 1)
		        end
		        if imgui.Button(u8'Полиция', btn_size) then 
		        end
		        if imgui.Button(u8'FBI', btn_size) then
		        end
		        if imgui.Button(u8'Больница', btn_size) then
		        end
		        if imgui.Button(u8'СМИ', btn_size) then
		        end
		        if imgui.Button(u8'Армия', btn_size) then
		        end
		        if imgui.Button(u8'Автошкола', btn_size) then
		        end
		    end
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
    sampRegisterChatCommand("amenu", cmd_amenu)
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

        imgui.Process = show_admin_menu.v or show_admin_info.v or show_admin_tp.v or show_admin_templeader.v

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
        if wasKeyPressed(key.VK_P) then
            local chatin = sampIsChatInputActive()
            if chatin == false then show_admin_menu.v = not show_admin_menu.v end
        end
        if wasKeyPressed(key.VK_F2) then
            if new_report == true then
              sampSetChatInputEnabled(true)
              sampSetChatInputText("/pm "..user_report_id.." | Приятной игры на States Role Play <3")
            end
            if new_report == false then
                sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}В данный момент репортов нет", -1)
            end
        end
        if wasKeyPressed(key.VK_F5) then
            if formb == true then
                if formacmd == "warn" or formacmd == "kick" then 
                    sampSendChat("/pm "..formaid.." Если вы не согласны с наказанием напишите жалобу forum.samp-states.ru")
                    wait(500)
                    sampSendChat("/"..formacmd.." "..formaid.." "..formatime2.." • "..formaadm)
                    wait(2000) 
                    sampSendChat("/a [FORMA] +")
                    formb = false
                    formacmd = nil
                    formaid = nil
                    formatime = nil
                
                else
                    sampSendChat("/"..formacmd.." "..formaid.." "..formatime2.." • "..formaadm)
                    wait(1000) 
                    sampSendChat("/a [FORMA] +")
                    formb = false
                    formacmd = nil
                    formaid = nil
                    formatime = nil
                end
            end
            if forma == true then
                if formacmd == "inftime" then
                        sampSendChat("/pm "..formaid.." Если вы не согласны с наказанием напишите жалобу forum.samp-states.ru")
                        wait(500)
                        sampSendChat("/"..formacmd.." "..formaid2.." • "..formaadm)
                        lua_thread.create(function() wait(1000) sampSendChat("/a [FORMA] +") end)
                        forma = false
                        formacmd = nil
                        formaid = nil
                else
                    sampSendChat("/"..formacmd.." "..formaid2.." • "..formaadm)
                    lua_thread.create(function() wait(1000) sampSendChat("/a [FORMA] +") end)
                    forma = false
                    formacmd = nil
                    formaid = nil
                end
			end
            if formc == true then
                if formacmd == "jail" or formacmd == "ban" then
                sampSendChat("/pm "..formaid.." Если вы не согласны с наказанием напишите жалобу forum.samp-states.ru")
                wait(1100)
                sampSendChat("/"..formacmd.." "..formaid3.." "..formatime3.." "..formareason3.." • "..formaadm)
				lua_thread.create(function() wait(1000) sampSendChat("/a [FORMA] +") end)
                formc = false
                formacmd = nil
				formaid3 = nil
				formatime3 = nil
                formareason3 = nil
                end
            end
        end
    end
end

function cmd_amenu()
    show_admin_menu.v = not show_admin_menu.v
    imgui.Process = show_admin_menu.v
end

function sampev.onServerMessage(color, text)
    if string.find(text, "Жалоба от") then
    new_report = true
    user_report_name, user_report_id = string.match(text, "Жалоба от (%a+_%a+)%[(%d+)%]")
    sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Пришёл новый репорт, примите клавишой 'F2'", -1)
end
if string.find(text, "В данный момент нет жалоб") and new_report == true then
    sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}В данный момент репортов нет", -1)
    new_report = false
end
if text:find("[A]", 1, true) then
    if text:find("/(.*) (.*) (.*)") then
        formacmd, formaid, formatime2 = text:match("/(%S+) (%d+) (%S+)")
        if formacmd == "kick" or formacmd == "warn" or formacmd == "sethp" or formacmd == "skick" then
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
        formacmd, formaid3, formatime3, formareason3 = text:match("/(%S+) (%d+) (%d+) (.*)")
        formadm = text:match("^%[A%] (%a+_%a+)")
        local one, two = formadm:match("(.).*_(.*)")
        formaadm = ("%s. %s"):format(one, two)
        if formacmd == "ban" or formacmd == "jail" or formacmd == "givegun" then
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