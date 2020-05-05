script_name("Admin Tools")
script_author("Lisov and Rowtea")

-- Инклуды --
local encoding = require 'encoding'
local sampev = require 'samp.events'
local key = require 'vkeys'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
-- Инклуды --

-- Пользовательские Переменные --
local activate = false
imgui.Process = false
-- Пользовательские Переменные --
-- Переменые Формы --
local forma = false
local formb = false
local formc = false
local show_admin_info = imgui.ImBool(false)
local show_admin_veh = imgui.ImBool(false)
local show_admin_prav = imgui.ImBool(false)
local show_admin_mmenu = imgui.ImBool(false)
local show_admin_tp = imgui.ImBool(false)
local show_admin_menu = imgui.ImBool(false)
local new_report = false
local user_report_name = nil
local user_report_id = nil

-- Переменые Формы --

-- Main --

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
	  		-- center
	  		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	  		imgui.SetNextWindowSize(imgui.ImVec2(400, 350), imgui.Cond.FirstUseEver)
	  		imgui.Begin('Admin Tools', show_admin_menu)
				local btn_size = imgui.ImVec2(-0.1, 0)
				if imgui.Button(u8'Телепортация', btn_size) then
		        show_admin_tp.v = not show_admin_tp.v
    			imgui.Process = show_admin_tp.v   
		        end
		        if imgui.Button(u8'Мероприятия/Лидерство', btn_size) then
		        show_admin_mmenu.v = not show_admin_mmenu.v
    			imgui.Process = show_admin_mmenu.v   
		        end
		        if imgui.Button(u8'ID VEH', btn_size) then
		        show_admin_veh.v = not show_admin_veh.v
    			imgui.Process = show_admin_veh.v   
		        end
		        if imgui.Button(u8'Информация в /msg', btn_size) then
	        	lua_thread.create(function()
	            sampSendChat("/msg Дорогие друзья, вступайте в наш дружелюбный Discord - discord.gg/Tr4F9mu")
	            wait(1000)
	            sampSendChat("/msg Наш сайт - samp-stat23232323232323232es.ru")
	            wait(1000)
	            sampSendChat("/msg Посетите нашу группу по адресу - vk.com/sampstatesrp")
	            wait(1000)
	            sampSendChat("/msg Перейти на наш форум вы можете по ссылке - forum.samp-states.ru")
	            wait(1000)
	            sampSendChat("/msg На этом информация закончилась. Приятной Игры на States Role Play :-)")
	        	end)
			  end
			if imgui.CollapsingHeader(u8'Сообщения в /msg') then 
				if imgui.Button(u8'Написать в Репорт', btn_size) then 
					sampSendChat("/msg Дорогие друзья, если у вас есть вопросы вы может из задать в репорт - /report")
				end
			end 
	      	if imgui.Button(u8'Информация о /spwancars', btn_size) then
	      	lua_thread.create(function()
            sampSendChat("/msg [Спавн Транспорта] Уважаемые Игроки! Через 30 секунд произойдёт респавн транспорта! Займите машины")
            wait(30000)
			sampSendChat("/spawncars")
			wait(1000)
			sampSendChat("/msg [Спавн Транспорта] Транспорт успешно зареспавнен. Приятной игры :-)")
        end)
      end
	      	if imgui.Button(u8'Таблица наказний', btn_size) then
		        show_admin_prav.v = not show_admin_prav.v
    			imgui.Process = show_admin_prav.v   
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
		    imgui.Text(u8'Создатель скрипта: Fernando Miracle.\nДополнял скрипт: Devereaux Montana\n\nКоманды скрипта:\n/am (P(англ)) - Открытие меню скрипта\n/gg - Пожелать игру приятной игры.\n/tppos - Телепортация по координатам.\n/st - Сокращенная команда /stats')
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
		if show_admin_mmenu.v then
		    local sw, sh = getScreenResolution()
		    -- center
		    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		    imgui.SetNextWindowSize(imgui.ImVec2(400, 300), imgui.Cond.FirstUseEver)
		    imgui.Begin('Admin MP | Leader', show_admin_mmenu)
		    local btn_size = imgui.ImVec2(-0.1, 0)
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
		    imgui.Text(u8'\n\n')
		    if imgui.Button(u8'Новый лидер', btn_size) then
		    sampSetChatInputEnabled(true)
          	sampSetChatInputText("/msg Новый лидер организации ")
		    end
		    if imgui.Button(u8'Снятие лидера', btn_size) then
		    sampSetChatInputEnabled(true)
          	sampSetChatInputText("/msg Лидер организации ")
		    end
		    if imgui.Button(u8'Срок лидерства', btn_size) then
		    sampSetChatInputEnabled(true)
          	sampSetChatInputText("/msg Лидер организации ")
		    end
			imgui.End()
		end
		if show_admin_veh.v then
		    local sw, sh = getScreenResolution()
		    -- center
		    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		    imgui.SetNextWindowSize(imgui.ImVec2(700, 300), imgui.Cond.FirstUseEver)
		    imgui.Begin('ID VEH', show_admin_veh)
		    local btn_size = imgui.ImVec2(-0.1, 0)
		    if imgui.CollapsingHeader(u8'Aircraft') then
		    imgui.Text(u8'Vehicle Model ID: 592\nVehicle Name: Andromada\nCategory: Airplane\nModifications: None\nModel name: androm\n\n Vehicle Model ID: 577\nVehicle Name: AT400\nCategory: Airplane\nModifications: None\nModel name: at400\n\n Vehicle Model ID: 511\nVehicle Name: Beagle\nCategory: Airplane\nModifications: None\nModel name: beagle\n\n Vehicle Model ID: 548\nVehicle Name: Cargobob\nCategory: Helicopters\nModifications: None\nModel name: cargobob\n\n Vehicle Model ID: 512\nVehicle Name: Cropduster\nCategory: Airplane\nModifications: None\nModel name: cropdust\n\n Vehicle Model ID: 593\nVehicle Name: Dodo\nCategory: Airplane\nModifications: None\nModel name: dodo\n\n Vehicle Model ID: 425\nVehicle Name: Hunter\nCategory: Helicopters\nModifications: None\nModel name: hunter\n\n Vehicle Model ID: 520\nVehicle Name: Hydra\nCategory: Airplane\nModifications: None\nModel name: hydra\n\n Vehicle Model ID: 417\nVehicle Name: Leviathan\nCategory: Helicopters\nModifications: None\nModel name: leviathn\n\n Vehicle Model ID: 553\nVehicle Name: Nevada\nCategory: Airplane\nModifications: None\nModel name: nevada\n\n Vehicle Model ID: 488\nVehicle Name: SAN News Maverick\nCategory: Helicopters\nModifications: None\nModel name: vcnmav\n\n Vehicle Model ID: 487\nVehicle Name: Maverick\nCategory: Helicopters\nModifications: None\nModel name: maverick\n\n Vehicle Model ID: 497\nVehicle Name: Police Maverick\nCategory: Helicopters\nModifications: None\nModel name: polmav\n\n Vehicle Model ID: 563\nVehicle Name: Raindance\nCategory: Helicopters\nModifications: None\nModel name: raindanc\n\n Vehicle Model ID: 476\nVehicle Name: Rustler\nCategory: Airplane\nModifications: None\nModel name: rustler\n\n Vehicle Model ID: 447\nVehicle Name: Seasparrow\nCategory: Helicopters\nModifications: None\nModel name: seaspar\n\n Vehicle Model ID: 519\nVehicle Name: Shamal\nCategory: Airplane\nModifications: None\nModel name: shamal\n\n Vehicle Model ID: 460\nVehicle Name: Skimmer\nCategory: Airplane\nModifications: None\nModel name: skimmer\n\n Vehicle Model ID: 469\nVehicle Name: Sparrow\nCategory: Helicopters\nModifications: None\nModel name: sparrow\n\n Vehicle Model ID: 513\nVehicle Name: Stuntplane\nCategory: Airplane\nModifications: None\nModel name: stunt\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Boats') then
		    imgui.Text(u8'Vehicle Model ID: 472\nVehicle Name: Coastguard\nCategory: Boats\nModifications: None\nModel name: coastg\n\n Vehicle Model ID: 473\nVehicle Name: Dinghy\nCategory: Boats\nModifications: None\nModel name: dinghy\n\n Vehicle Model ID: 493\nVehicle Name: Jetmax\nCategory: Boats\nModifications: None\nModel name: jetmax\n\n Vehicle Model ID: 595\nVehicle Name: Launch\nCategory: Boats\nModifications: None\nModel name: launch\n\n Vehicle Model ID: 484\nVehicle Name: Marquis\nCategory: Boats\nModifications: None\nModel name: marquis\n\n Vehicle Model ID: 430\nVehicle Name: Predator\nCategory: Boats\nModifications: None\nModel name: predator\n\n Vehicle Model ID: 453\nVehicle Name: Reefer\nCategory: Boats\nModifications: None\nModel name: reefer\n\n Vehicle Model ID: 452\nVehicle Name: Speeder\nCategory: Boats\nModifications: None\nModel name: speeder\n\n Vehicle Model ID: 446\nVehicle Name: Squallo\nCategory: Boats\nModifications: None\nModel name: squalo\n\n Vehicle Model ID: 454\nVehicle Name: Tropic\nCategory: Boats\nModifications: None\nModel name: tropic\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Coupes & Hatchbacks') then
		    imgui.Text(u8'Vehicle Model ID: 496\nVehicle Name: Blista Compact\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: blistac\n\n Vehicle Model ID: 401\nVehicle Name: Bravura\nCategory: Saloons\nModifications: Transfender\nModel name: bravura\n\n Vehicle Model ID: 518\nVehicle Name: Buccaneer\nCategory: Saloons\nModifications: Transfender\nModel name: buccanee\n\n Vehicle Model ID: 527\nVehicle Name: Cadrona\nCategory: Saloons\nModifications: Transfender\nModel name: cadrona\n\n Vehicle Model ID: 542\nVehicle Name: Clover\nCategory: Saloons\nModifications: Transfender\nModel name: clover\n\n Vehicle Model ID: 589\nVehicle Name: Club\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: club\n\n Vehicle Model ID: 419\nVehicle Name: Esperanto\nCategory: Saloons\nModifications: Transfender\nModel name: esperant\n\n Vehicle Model ID: 533\nVehicle Name: Feltzer\nCategory: Convertibles\nModifications: Transfender\nModel name: feltzer\n\n Vehicle Model ID: 526\nVehicle Name: Fortune\nCategory: Saloons\nModifications: Transfender\nModel name: fortune\n\n Vehicle Model ID: 474\nVehicle Name: Hermes\nCategory: Saloons\nModifications: Transfender\nModel name: hermes\n\n Vehicle Model ID: 545\nVehicle Name: Hustler\nCategory: Unique Vehicles\nModifications: Transfender\nModel name: hustler\n\n Vehicle Model ID: 517\nVehicle Name: Majestic\nCategory: Saloons\nModifications: Transfender\nModel name: majestic\n\n Vehicle Model ID: 410\nVehicle Name: Manana\nCategory: Saloons\nModifications: Transfender\nModel name: manana\n\n Vehicle Model ID: 436\nVehicle Name: Previon\nCategory: Saloons\nModifications: Transfender\nModel name: previon\n\n Vehicle Model ID: 475\nVehicle Name: Sabre\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: sabre\n\n Vehicle Model ID: 439\nVehicle Name: Stallion\nCategory: Convertibles\nModifications: Transfender\nModel name: stallion\n\n Vehicle Model ID: 549\nVehicle Name: Tampa\nCategory: Saloons\nModifications: Transfender\nModel name: tampa\n\n Vehicle Model ID: 491\nVehicle Name: Virgo\nCategory: Saloons\nModifications: Transfender\nModel name: virgo\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Government') then
		    imgui.Text(u8'Vehicle Model ID: 416\nVehicle Name: Ambulance\nCategory: Public Service\nModifications: None\nModel name: ambulan\n\n Vehicle Model ID: 433\nVehicle Name: Barracks\nCategory: Public Service\nModifications: None\nModel name: barracks\n\n Vehicle Model ID: 427\nVehicle Name: Enforcer\nCategory: Public Service\nModifications: None\nModel name: enforcer\n\n Vehicle Model ID: 528\nVehicle Name: FBI Truck\nCategory: Public Service\nModifications: None\nModel name: fbitruck\n\n Vehicle Model ID: 490\nVehicle Name: FBI Rancher\nCategory: Public Service\nModifications: None\nModel name: fbiranch\n\n Vehicle Model ID: 544\nVehicle Name: Firetruck LA\nCategory: Public Service\nModifications: None\nModel name: firela\n\n Vehicle Model ID: 523\nVehicle Name: HPV1000\nCategory: Public Service\nModifications: None\nModel name: copbike\n\n Vehicle Model ID: 596\nVehicle Name: Police Car (LSPD)\nCategory: Public Service\nModifications: None\nModel name: copcarla\n\n Vehicle Model ID: 597\nVehicle Name: Police Car (SFPD)\nCategory: Public Service\nModifications: None\nModel name: copcarsf\n\n Vehicle Model ID: 598\nVehicle Name: Police Car (LVPD)\nCategory: Public Service\nModifications: None\nModel name: copcarvg\n\n Vehicle Model ID: 599\nVehicle Name: Police Ranger\nCategory: Public Service\nModifications: None\nModel name: copcarru\n\n Vehicle Model ID: 432\nVehicle Name: Rhino\nCategory: Public Service\nModifications: None\nModel name: rhino\n\n Vehicle Model ID: 601\nVehicle Name: S.W.A.T.\nCategory: Public Service\nModifications: None\nModel name: swatvan\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Industrial') then
		    imgui.Text(u8'Vehicle Model ID: 499\nVehicle Name: Benson\nCategory: Industrial\nModifications: None\nModel name: benson\n\n Vehicle Model ID: 609\nVehicle Name: Boxville\nCategory: Industrial\nModifications: None\nModel name: boxburg\n\n Vehicle Model ID: 524\nVehicle Name: Cement Truck\nCategory: Industrial\nModifications: None\nModel name: cement\n\n Vehicle Model ID: 532\nVehicle Name: Combine Harvester\nCategory: Unique Vehicles\nModifications: None\nModel name: combine\n\n Vehicle Model ID: 578\nVehicle Name: DFT-30\nCategory: Industrial\nModifications: None\nModel name: dft30\n\n Vehicle Model ID: 486\nVehicle Name: Dozer\nCategory: Unique Vehicles\nModifications: None\nModel name: dozer\n\n Vehicle Model ID: 406\nVehicle Name: Dumper\nCategory: Unique Vehicles\nModifications: None\nModel name: dumper\n\n Vehicle Model ID: 455\nVehicle Name: Flatbed\nCategory: Industrial\nModifications: None\nModel name: flatbed\n\n Vehicle Model ID: 530\nVehicle Name: Forklift\nCategory: Unique Vehicles\nModifications: None\nModel name: forklift\n\n Vehicle Model ID: 403\nVehicle Name: Linerunner\nCategory: Industrial\nModifications: None\nModel name: linerun\n\n Vehicle Model ID: 414\nVehicle Name: Mule\nCategory: Industrial\nModifications: None\nModel name: mule\n\n Vehicle Model ID: 443\nVehicle Name: Packer\nCategory: Industrial\nModifications: None\nModel name: packer\n\n Vehicle Model ID: 515\nVehicle Name: Roadtrain\nCategory: Industrial\nModifications: None\nModel name: rdtrain\n\n Vehicle Model ID: 514\nVehicle Name: Tanker\nCategory: Industrial\nModifications: None\nModel name: petro\n\n Vehicle Model ID: 531\nVehicle Name: Tractor\nCategory: Industrial\nModifications: None\nModel name: tractor\n\n Vehicle Model ID: 456\nVehicle Name: Yankee\nCategory: Industrial\nModifications: None\nModel name: yankee\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Lowriders') then
		    imgui.Text(u8'Vehicle Model ID: 536\nVehicle Name: Blade\nCategory: Lowriders\nModifications: Loco Low Co\nModel name: blade\n\n Vehicle Model ID: 575\nVehicle Name: Broadway\nCategory: Lowriders\nModifications: Loco Low Co\nModel name: broadway\n\n Vehicle Model ID: 534\nVehicle Name: Remington\nCategory: Lowriders\nModifications: Loco Low Co\nModel name: remingtn\n\n Vehicle Model ID: 567\nVehicle Name: Savanna\nCategory: Lowriders\nModifications: Loco Low Co\nModel name: savanna\n\n Vehicle Model ID: 535\nVehicle Name: Slamvan\nCategory: Lowriders\nModifications: Loco Low Co\nModel name: slamvan\n\n Vehicle Model ID: 566\nVehicle Name: Tahoma\nCategory: Lowriders\nModifications: Loco Low Co\nModel name: tahoma\n\n Vehicle Model ID: 576\nVehicle Name: Tornado\nCategory: Lowriders\nModifications: Loco Low Co\nModel name: tornado\n\n Vehicle Model ID: 412\nVehicle Name: Voodoo\nCategory: Lowriders\nModifications: Loco Low Co\nModel name: voodoo\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Misc') then
		    imgui.Text(u8'Vehicle Model ID: 504\nVehicle Name: Bloodring Banger\nCategory: Saloons\nModifications: None\nModel name: bloodra / bloodrb\n\n Vehicle Model ID: 503\nVehicle Name: Hotring Racer B\nCategory: Sport Vehicles\nModifications: None\nModel name: hotrinb\n\n Vehicle Model ID: 594\nVehicle Name: RC Cam\nCategory: RC Vehicles\nModifications: None\nModel name: rccam\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Motercycles & Bikes') then
		    imgui.Text(u8'Vehicle Model ID: 581\nVehicle Name: BF-400\nCategory: Bikes\nModifications: None\nModel name: bf400\n\n Vehicle Model ID: 509\nVehicle Name: Bike\nCategory: Bikes\nModifications: None\nModel name: bike\n\n Vehicle Model ID: 481\nVehicle Name: BMX\nCategory: Bikes\nModifications: None\nModel name: bmx\n\n Vehicle Model ID: 462\nVehicle Name: Faggio\nCategory: Bikes\nModifications: None\nModel name: faggio\n\n Vehicle Model ID: 521\nVehicle Name: FCR-900\nCategory: Bikes\nModifications: None\nModel name: fcr900\n\n Vehicle Model ID: 463\nVehicle Name: Freeway\nCategory: Bikes\nModifications: None\nModel name: freeway\n\n Vehicle Model ID: 510\nVehicle Name: Mountain Bike\nCategory: Bikes\nModifications: None\nModel name: mtbike\n\n Vehicle Model ID: 522\nVehicle Name: NRG-500\nCategory: Bikes\nModifications: None\nModel name: nrg500\n\n Vehicle Model ID: 461\nVehicle Name: PCJ-600\nCategory: Bikes\nModifications: None\nModel name: pcj600\n\n Vehicle Model ID: 448\nVehicle Name: Pizzaboy\nCategory: Bikes\nModifications: None\nModel name: pizzaboy\n\n Vehicle Model ID: 468\nVehicle Name: Sanchez\nCategory: Bikes\nModifications: None\nModel name: sanchez\n\n Vehicle Model ID: 586\nVehicle Name: Wayfarer\nCategory: Bikes\nModifications: None\nModel name: wayfarer\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Novelty') then
		    imgui.Text(u8'Vehicle Model ID: 568\nVehicle Name: Bandito\nCategory: Off Road\nModifications: None\nModel name: bandito\n\n Vehicle Model ID: 424\nVehicle Name: BF Injection\nCategory: Off Road\nModifications: None\nModel name: bfinject\n\n Vehicle Model ID: 457\nVehicle Name: Caddy\nCategory: Unique Vehicles\nModifications: None\nModel name: caddy\n\n Vehicle Model ID: 483\nVehicle Name: Camper\nCategory: Unique Vehicles\nModifications: None\nModel name: camper\n\n Vehicle Model ID: 573\nVehicle Name: Dune\nCategory: Off Road\nModifications: None\nModel name: duneride\n\n Vehicle Model ID: 508\nVehicle Name: Journey\nCategory: Unique Vehicles\nModifications: None\nModel name: journey\n\n Vehicle Model ID: 571\nVehicle Name: Kart\nCategory: Unique Vehicles\nModifications: None\nModel name: kart\n\n Vehicle Model ID: 572\nVehicle Name: Mower\nCategory: Unique Vehicles\nModifications: None\nModel name: mower\n\n Vehicle Model ID: 471\nVehicle Name: Quad\nCategory: Bikes\nModifications: None\nModel name: quad\n\n Vehicle Model ID: 539\nVehicle Name: Vortex\nCategory: Unique Vehicles\nModifications: None\nModel name: vortex\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Public Service') then
		    imgui.Text(u8'Vehicle Model ID: 485\nVehicle Name: Baggage\nCategory: Unique Vehicles\nModifications: None\nModel name: baggage\n\n Vehicle Model ID: 431\nVehicle Name: Bus\nCategory: Public Service\nModifications: None\nModel name: bus\n\n Vehicle Model ID: 438\nVehicle Name: Cabbie\nCategory: Public Service\nModifications: Transfender\nModel name: cabbie\n\n Vehicle Model ID: 437\nVehicle Name: Coach\nCategory: Public Service\nModifications: None\nModel name: coach\n\n Vehicle Model ID: 574\nVehicle Name: Sweeper\nCategory: Unique Vehicles\nModifications: None\nModel name: sweeper\n\n Vehicle Model ID: 420\nVehicle Name: Taxi\nCategory: Public Service\nModifications: Transfender\nModel name: taxi\n\n Vehicle Model ID: 525\nVehicle Name: Towtruck\nCategory: Unique Vehicles\nModifications: None\nModel name: towtruck\n\n Vehicle Model ID: 408\nVehicle Name: Trashmaster\nCategory: Industrial\nModifications: None\nModel name: trash\n\n Vehicle Model ID: 583\nVehicle Name: Tug\nCategory: Unique Vehicles\nModifications: None\nModel name: tug\n\n Vehicle Model ID: 552\nVehicle Name: Utility Van\nCategory: Industrial\nModifications: None\nModel name: utility\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Remote Control') then
		    imgui.Text(u8'Vehicle Model ID: 441\nVehicle Name: RC Bandit\nCategory: RC Vehicles\nModifications: None\nModel name: rcbandit\n\n Vehicle Model ID: 464\nVehicle Name: RC Baron\nCategory: RC Vehicles\nModifications: None\nModel name: rcbaron\n\n Vehicle Model ID: 501\nVehicle Name: RC Goblin\nCategory: RC Vehicles\nModifications: None\nModel name: rcgoblin\n\n Vehicle Model ID: 465\nVehicle Name: RC Raider\nCategory: RC Vehicles\nModifications: None\nModel name: rcraider\n\n Vehicle Model ID: 564\nVehicle Name: RC Tiger\nCategory: RC Vehicles\nModifications: None\nModel name: rctiger\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Sedans & Station Wagons') then
		    imgui.Text(u8'Vehicle Model ID: 445\nVehicle Name: Admiral\nCategory: Saloons\nModifications: Transfender\nModel name: admiral\n\n Vehicle Model ID: 507\nVehicle Name: Elegant\nCategory: Saloons\nModifications: Transfender\nModel name: elegant\n\n Vehicle Model ID: 585\nVehicle Name: Emperor\nCategory: Saloons\nModifications: Transfender\nModel name: emperor\n\n Vehicle Model ID: 604\nVehicle Name: Glendale Shit\nCategory: Saloons\nModifications: None\nModel name: glenshit\n\n Vehicle Model ID: 492\nVehicle Name: Greenwood\nCategory: Saloons\nModifications: Transfender\nModel name: greenwoo\n\n Vehicle Model ID: 546\nVehicle Name: Intruder\nCategory: Saloons\nModifications: Transfender\nModel name: intruder\n\n Vehicle Model ID: 551\nVehicle Name: Merit\nCategory: Saloons\nModifications: Transfender\nModel name: merit\n\n Vehicle Model ID: 516\nVehicle Name: Nebula\nCategory: Saloons\nModifications: Transfender\nModel name: nebula\n\n Vehicle Model ID: 467\nVehicle Name: Oceanic\nCategory: Saloons\nModifications: Transfender\nModel name: oceanic\n\n Vehicle Model ID: 404\nVehicle Name: Perennial\nCategory: Station Wagons\nModifications: Transfender\nModel name: peren\n\n Vehicle Model ID: 426\nVehicle Name: Premier\nCategory: Saloons\nModifications: Transfender\nModel name: premier\n\n Vehicle Model ID: 547\nVehicle Name: Primo\nCategory: Saloons\nModifications: Transfender\nModel name: primo\n\n Vehicle Model ID: 479\nVehicle Name: Regina\nCategory: Station Wagons\nModifications: Transfender\nModel name: regina\n\n Vehicle Model ID: 442\nVehicle Name: Romero\nCategory: Unique Vehicles\nModifications: Transfender\nModel name: romero\n\n Vehicle Model ID: 405\nVehicle Name: Sentinel\nCategory: Saloons\nModifications: Transfender\nModel name: sentinel\n\n Vehicle Model ID: 458\nVehicle Name: Solair\nCategory: Station Wagons\nModifications: Transfender\nModel name: solair\n\n Vehicle Model ID: 580\nVehicle Name: Stafford\nCategory: Saloons\nModifications: Transfender\nModel name: stafford\n\n Vehicle Model ID: 409\nVehicle Name: Stretch\nCategory: Unique Vehicles\nModifications: Transfender\nModel name: stretch\n\n Vehicle Model ID: 550\nVehicle Name: Sunrise\nCategory: Saloons\nModifications: Transfender\nModel name: sunrise\n\n Vehicle Model ID: 540\nVehicle Name: Vincent\nCategory: Saloons\nModifications: Transfender\nModel name: vincent\n\n \nVehicle Name: Washington\nCategory: Saloons\nModifications: Transfender\nModel name: washing\n\n Vehicle Model ID: 529\nVehicle Name: Willard\nCategory: Saloons\nModifications: Transfender\nModel name: willard\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Sport') then
		    imgui.Text(u8'Vehicle Model ID: 602\nVehicle Name: Alpha\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: alpha\n\n Vehicle Model ID: 429\nVehicle Name: Banshee\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: banshee\n\n Vehicle Model ID: 402\nVehicle Name: Buffalo\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: buffalo\n\n Vehicle Model ID: 541\nVehicle Name: Bullet\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: bullet\n\n Vehicle Model ID: 415\nVehicle Name: Cheetah\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: cheetah\n\n Vehicle Model ID: 480\nVehicle Name: Comet\nCategory: Convertibles\nModifications: Transfender\nModel name: comet\n\n Vehicle Model ID: 587\nVehicle Name: Euros\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: euros\n\n Vehicle Model ID: 434\nVehicle Name: Hotknife\nCategory: Unique Vehicles\nModifications: None\nModel name: hotknife\n\n Vehicle Model ID: 411\nVehicle Name: Infernus\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: infernus\n\n Vehicle Model ID: 603\nVehicle Name: Phoenix\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: phoenix\n\n Vehicle Model ID: 506\nVehicle Name: Super GT\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: supergt\n\n Vehicle Model ID: 451\nVehicle Name: Turismo\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: turismo\n\n Vehicle Model ID: 555\nVehicle Name: Windsor\nCategory: Convertibles\nModifications: Transfender\nModel name: windsor\n\n Vehicle Model ID: 477\nVehicle Name: ZR-350\nCategory: Sport Vehicles\nModifications: Transfender\nModel name: zr350\n\n')
		    end
		    if imgui.CollapsingHeader(u8'SUVs & Pickup Trucks') then
		    imgui.Text(u8'Vehicle Model ID: 422\nVehicle Name: Bobcat\nCategory: Industrial\nModifications: Transfender\nModel name: bobcat\n\n Vehicle Model ID: 579\nVehicle Name: Huntley\nCategory: Off Road\nModifications: Transfender\nModel name: huntley\n\n Vehicle Model ID: 400\nVehicle Name: Landstalker\nCategory: Off Road\nModifications: Transfender\nModel name: landstal\n\n Vehicle Model ID: 500\nVehicle Name: Mesa\nCategory: Off Road\nModifications: Transfender\nModel name: mesa\n\n Vehicle Model ID: 444\nVehicle Name: Monster\nCategory: Off Road\nModifications: None\nModel name: monster\n\n Vehicle Model ID: 556\nVehicle Name: Monster "A"\nCategory: Off Road\nModifications: None\nModel name: monstera\n\n Vehicle Model ID: 557\nVehicle Name: Monster "B"\nCategory: Off Road\nModifications: None\nModel name: monsterb\n\n Vehicle Model ID: 470\nVehicle Name: Patriot\nCategory: Off Road\nModifications: None\nModel name: patriot\n\n Vehicle Model ID: 600\nVehicle Name: Picador\nCategory: Industrial\nModifications: Transfender\nModel name: picador\n\n Vehicle Model ID: 505\nVehicle Name: Rancher Lure\nCategory: Off Road\nModifications: None\nModel name: rnchlure\n\n Vehicle Model ID: 543\nVehicle Name: Sadler\nCategory: Industrial\nModifications: None\nModel name: sadler\n\n Vehicle Model ID: 495\nVehicle Name: Sandking\nCategory: Off Road\nModifications: None\nModel name: sandking\n\n Vehicle Model ID: 478\nVehicle Name: Walton\nCategory: Industrial\nModifications: Transfender\nModel name: walton\n\n Vehicle Model ID: 554\nVehicle Name: Yosemite\nCategory: Industrial\nModifications: None\nModel name: yosemite\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Trailers') then
		    imgui.Text(u8'Vehicle Model ID: 591\nVehicle Name: Article Trailer 3\nCategory: Trailers\nModifications: None\nModel name: artict3\n\n Vehicle Model ID: 606\nVehicle Name: Baggage Trailer "A"\nCategory: Trailers\nModifications: None\nModel name: bagboxa\n\n Vehicle Model ID: 607\nVehicle Name: Baggage Trailer "B"\nCategory: Trailers\nModifications: None\nModel name: bagboxb\n\n Vehicle Model ID: 590\nVehicle Name: Freight Box Trailer (Train)\nCategory: Trailers\nModifications: None\nModel name: freibox\n\n Vehicle Model ID: 610\nVehicle Name: Farm Trailer\nCategory: Trailers\nModifications: None\nModel name: farmtr1\n\n Vehicle Model ID: 569\nVehicle Name: Freight Flat Trailer (Train)\nCategory: Trailers\nModifications: None\nModel name: freiflat\n\n Vehicle Model ID: 450\nVehicle Name: Article Trailer 2\nCategory: Trailers\nModifications: None\nModel name: artict2\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Trains') then
		    imgui.Text(u8'Vehicle Model ID: 538\nVehicle Name: Brownstreak (Train)\nCategory: Unique Vehicles\nModifications: None\nModel name: streak\n\n Vehicle Model ID: 537\nVehicle Name: Freight (Train)\nCategory: Unique Vehicles\nModifications: None\nModel name: freight\n\n Vehicle Model ID: 449\nVehicle Name: Tram\nCategory: Unique Vehicles\nModifications: None\nModel name: tram\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Tuners') then
		    imgui.Text(u8'Vehicle Model ID: 562\nVehicle Name: Elegy\nCategory: Saloons\nModifications: Wheel Arch Angels\nModel name: elegy\n\n Vehicle Model ID: 565\nVehicle Name: Flash\nCategory: Sport Vehicles\nModifications: Wheel Arch Angels\nModel name: flash\n\n Vehicle Model ID: 559\nVehicle Name: Jester\nCategory: Sport Vehicles\nModifications: Wheel Arch Angels\nModel name: jester\n\n Vehicle Model ID: 561\nVehicle Name: Stratum\nCategory: Station Wagons\nModifications: Wheel Arch Angels\nModel name: stratum\n\n Vehicle Model ID: 560\nVehicle Name: Sultan\nCategory: Saloons\nModifications: Wheel Arch Angels\nModel name: sultan\n\n Vehicle Model ID: 558\nVehicle Name: Uranus\nCategory: Sport Vehicles\nModifications: Wheel Arch Angels\nModel name: uranus\n\n')
		    end
		    if imgui.CollapsingHeader(u8'Vans') then
		    imgui.Text(u8'Vehicle Model ID: 459\nVehicle Name: Topfun Van (Berkleys RC)\nCategory: Industrial\nModifications: None\nModel name: topfun\n\n Vehicle Model ID: 482\nVehicle Name: Burrito\nCategory: Industrial\nModifications: None\nModel name: burrito\n\n Vehicle Model ID: 588\nVehicle Name: Hotdog\nCategory: Unique Vehicles\nModifications: None\nModel name: hotdog\n\n Vehicle Model ID: 418\nVehicle Name: Moonbeam\nCategory: Station Wagons\nModifications: Transfender\nModel name: moonbeam\n\n Vehicle Model ID: 423\nVehicle Name: Mr. Whoopee\nCategory: Unique Vehicles\nModifications: None\nModel name: mrwhoop\n\n Vehicle Model ID: 582\nVehicle Name: Newsvan\nCategory: Industrial\nModifications: None\nModel name: newsvan\n\n Vehicle Model ID: 413\nVehicle Name: Pony\nCategory: Industrial\nModifications: None\nModel name: pony\n\n Vehicle Model ID: 440\nVehicle Name: Rumpo\nCategory: Industrial\nModifications: None\nModel name: rumpo\n\n Vehicle Model ID: 428\nVehicle Name: Securicar\nCategory: Unique Vehicles\nModifications: None\nModel name: securica\n\n')
		    end
			imgui.End()
		end
		if show_admin_prav.v then
		    local sw, sh = getScreenResolution()
		    -- center
		    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		    imgui.SetNextWindowSize(imgui.ImVec2(300, 250), imgui.Cond.FirstUseEver)
		    imgui.Begin(u8'Таблица наказний', show_admin_prav)
		    local btn_size = imgui.ImVec2(-0.1, 0)
		    if imgui.Button(u8'Общее наказния', btn_size) then
		    sampShowDialog(123445, '{ff0000}Правила наказаний{FFFFFF}', '{ff0000}Наказание Бан:\n{FFFFFF}Игрокам запрещено использовать посторонние чит-программы, программы взлома игрового функционала. Наказание: бан 30 дней.\nИспользование / хранение запрещённых читерских программ: Aim, Speed Hack, Wall Hack, Fly, DGun, Cleo HP, Autorepair/GM Car, Airbreak, Fast Gan, Рванка Собейт - от 10 до 30 дней\nУпоминание родных /Оскорбление в нике - 30 дней бана.\nОскорбление родных - от 10 до 30 дней бана.\nНеадекватное поведение - от 1 до 3 дней бана.\nЗа рекламу других серверов сайтов форумов и прочее нарушителю выдается бан на 7 дней + ban IP.\nЗа оскорбление проекта в любой чат сервера нарушителю выдается бан на 7 дней + ban IP.\nНа сервере запрещено всяческое мошенничество других игроков, обман, и мошенничество в целях кражи личного имущества (Недвижимость,ТС, Вирты) игроков. Наказание: бан 30 дней.\nЗапрещен обман администрации проекта, наказывается: BAN 3 day.\nЗа использования багоюза системы сервера, нарушителю выдается бан до 5 дней.\n\n{ff0000}Наказание Мут:{FFFFFF}\nИгрокам запрещено оскорблять других игроков, выражаться нецензурной бранью в ООС и IC чаты, оскорблять и унижать честь и достоинства игроков. Наказание: Mute 30 min.\nЗа CAPS в ic чат, в репорт или в /r /f чаты нарушителю выдается бан чата до 10 минут.\nЗа оффтоп в репорт нарушителю выдается бан чата на 20 минут.\nЗа флуд во все чаты включая /b чат нарушителю выдается бан чата от 10 до 20 минут.\nЗа оскорбление игрока или администратора в репорт игрок получает бан чата до 60 минут.\nЗа транслит в ic чат нарушителю выдаётся бан чата от 5 до 10 минут.\n\n{ff0000}Наказние Варн/Деморган:{FFFFFF}\nЛюбому игроку запрещено нарушать игровой процесс и влезать в него под основанием DM. Убийство без причины//массовое убийство игроков//нарушение игрового процесса...\n...убийство не имея на то Role Play оснований, наказывается: деморган 2 часа.\nИгрокам запрещено использовать в качестве оружия для убийства транспортное средство (DB), не имея на то Role Play оснований наказание: деморган 30 - 60 минут.\nЗа ДМ в ЗЗ нарушителю выдается деморган 15 - 30 минут.\nЗа ДМ нарушителю выдается деморган 15 - 30 минут.\nЗа SpawnKill нарушителю выдается деморган 15 - 20 минут.\nЗа ДБ нарушитель помещается в деморган 15 - 20 минут.\nЗа Team kill нарушителю выдается варн или деморган 30 - 60 минут.\nЗа сбив анимации игроку выдаётся деморган 15 минут.\nЗа использования багоюза +с, выдается деморган 15 минут.. Исключение, гетто.\nЗа ДМ в КПЗ, нарушителю выдается варн.', 'Закрыть', '', 0)
            lua_thread.create(dialog1)
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
        sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Скрипт успешно активирован | Author: Fernando Miracle", -1)
        activate = true
    else
        sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Вы должны находится на States Role Play! Скрипт деактивирован", -1)
    end
    -- Проверка Конфигурационных Файлов --
    sampRegisterChatCommand("tppos", cmd_tppos)
    sampRegisterChatCommand("savepos", cmd_savepos)
    sampRegisterChatCommand("tp", cmd_tp)
	sampRegisterChatCommand("am", cmd_am)
	sampRegisterChatCommand("gg", function(arg)
      args = tonumber(arg)
      if not args then sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Введите ID игрока", -1) return end
      sampSendChat("/pm "..args.." Приятной игры на States Role Play <3")
    end)
    sampRegisterChatCommand("st", function(arg)
      args = tonumber(arg)
      if not args then sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Введите ID игрока", -1) return end
      sampSendChat("/stats "..args)
    end)


    wait(0)

    -- Бесконечный Цикл --
    while true do
        wait(0)
        if activate == false then return end

        imgui.Process = show_admin_menu.v or show_admin_tp.v or show_admin_mmenu.v

        if activate == false then return end
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
				sampSendChat("/"..formacmd.." "..formaid.." "..formatime2.." • "..formaadm)
				lua_thread.create(function() wait(1000) sampSendChat("/a [FORMA] +") end)
                formb = false
                formacmd = nil
                formaid = nil
                formatime = nil
            end
            if forma == true then
				sampSendChat("/"..formacmd.." "..formaid2.." • "..formaadm)
				lua_thread.create(function() wait(1000) sampSendChat("/a [FORMA] +") end)
                forma = false
                formacmd = nil
                formaid = nil
			end
			if formc == true then
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

function cmd_savepos()
    x, y, z = getCharCoordinates(playerPed)
    print(x..", "..y..", "..z)
end

function cmd_tppos()
    setCharCoordinates(PLAYER_PED, x, y, z)
    sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Вы телепортированы на X: "..x.." Y: "..y.." Z: "..z, -1)
end

function cmd_tp()
    show_admin_tp.v = not show_admin_tp.v
    imgui.Process = show_admin_tp.v
end

function cmd_am()
    show_admin_menu.v = not show_admin_menu.v
    imgui.Process = show_admin_menu.v
end

-- Main --
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
            if formacmd == "kick" or formacmd == "warn" then
                formaadm = text:match("^%[A%] (%a+_%a+)")
                formb = true
                lua_thread.create(function()
                    wait(100)
                    sampAddChatMessage("{ff0000}[Admin Tools] {FFFFFF}Пришла форма, для выполнения нажмите 'F5'", -1)
                end)
            end
        end
        if text:find("/(.*) (.*)") then
            formacmd, formaid2 = text:match("/(%S+) (.*)")
            formaadm = text:match("^%[A%] (%a+_%a+)")
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
            formaadm = text:match("^%[A%] (%a+_%a+)")
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
				sampSendChat("/a {ff0000}[Admin Tools] {FFFFFF}Форма была выполнена другим администратором", -1)
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



function dialog1()
    while sampIsDialogActive() do wait(0)
	    local result, button, list, input = sampHasDialogRespond(123445)
	end
end
