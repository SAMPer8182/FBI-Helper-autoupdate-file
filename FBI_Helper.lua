script_name('FBI_Helper')
script_author('Matvey_Kapik')
script_version('0.3')
-- {FFA500}

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://github.com/SAMPer8182/FBI-Helper-autoupdate-file/blob/main/auto-update.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/SAMPer8182/FBI-Helper-autoupdate-file/blob/main/"
        end
    end
end


require('lib.moonloader')
local image;
local imgui = require('mimgui')
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local new = imgui.new
local sampev = require("samp.events")
local vk = require('vkeys')
timeh = os.time()

local checkboxone = new.bool()
local WinState = new.bool()

imgui.OnInitialize(function ()
    imgui.GetIO().IniFilename = nil;
    image = imgui.CreateTextureFromFile(getWorkingDirectory().. '\\FBIhelper\\FBI.png');
end)

function imgui.DarkTheme()
    imgui.SwitchContext()
    --==[ STYLE ]==--
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10

    --==[ BORDER ]==--
    imgui.GetStyle().WindowBorderSize = 1
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 1

    --==[ ROUNDING ]==--
    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().ChildRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().PopupRounding = 5
    imgui.GetStyle().ScrollbarRounding = 5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5

    --==[ ALIGN ]==--
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    
    --==[ COLORS ]==--
    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
end

imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500,500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(550, 300), imgui.Cond.Always)
    imgui.Begin('##Window', WinState, imgui.WindowFlags.NoResize)

    imgui.SetCursorPosX((imgui.GetWindowWidth() - 512) /2)
    imgui.Image(image, imgui.ImVec2(512, 107));

    if imgui.BeginTabBar('Tabs') then -- задаём начало вкладок
    
        if imgui.BeginTabItem(u8'Команды') then -- первая вкладка
        
            imgui.TextWrapped(u8'/fbi - открыть меню')
            imgui.TextWrapped(u8'/lic [id] - дать лицензии')
            imgui.TextWrapped(u8'/pas [id] - дать пасспорт')
            imgui.TextWrapped(u8'/mc [id] - дать медкарту')
            imgui.TextWrapped(u8'/time - посмотреть время (по РП)')
            imgui.TextWrapped(u8'/suf [id] - обявить в розыск (по РП)')
            imgui.TextWrapped(u8'/findf [id] - местоположение игрока (по РП)')
            imgui.TextWrapped(u8'/clearf [id] - очистить розыск (по РП)')
            imgui.TextWrapped(u8'/takef [id] - забрать что-то (по РП)')
            imgui.TextWrapped(u8'/friskf [id] - обыскать человека на против (по РП)')

            imgui.EndTabItem() -- конец вкладки
        end
        if imgui.BeginTabItem(u8'Покупка скрипта под заказ') then -- вторая вкладка
     
            imgui.TextWrapped(u8'вы хотите купить скрипт с функциями которые хотите?')
            imgui.TextWrapped(u8'или же можно про рекламировать что бы получить желаемый скрипт бесплатно!')
        
            imgui.EndTabItem() -- конец вкладки
        end

        imgui.EndTabBar() -- конец всех вкладок
    end

    imgui.Separator()
    imgui.Separator()
    imgui.Text(u8'Кто писал скрипт: @Minimotya (актуально) // John_Scandalov Tucson/Mobile I')
    --imgui.Text(u8'Кто редактировал: @danila_scandalov (актуально)')
    imgui.Text(u8'Кто вдохновил: @MTG_mods :)')

    imgui.End()
end)

function main()
    while not isSampAvailable() do wait(100) end

    sampAddChatMessage('{FFA500}[FBI]: скрипт запущен!')
    sampAddChatMessage('{FFA500}[FBI]: версия скрипта: 0.3')
    sampAddChatMessage('{FFA500}[FBI]: команда: /fbi <3')

    sampRegisterChatCommand('fbi', function() WinState[0] = not WinState[0] end)

    
    sampRegisterChatCommand('lic', function(id) -- регаем команду
        if id == '' then -- если айди игрока равно пустоте, то
            sampAddChatMessage('{FFA500}[Ошибка]: Введите ID игрока!') -- "ошибка"
            return
        end
        id = id:match('(.+)') -- получаем аргументы, и записываем в перменные
        lua_thread.create(function()
            sampProcessChatInput('/do Лицензии в кармане.')
            wait(1000)
            sampProcessChatInput('/me лёгким движением руки достал лицензии из кармана')
            wait(1000)
            sampProcessChatInput('/do Лицензии в руке.')
            wait(1000)
            sampProcessChatInput('/me передал лицензию человеку на против')
            wait(1000)
            sampProcessChatInput('/showlic '..id) -- отправляем в чат луа команду с аргументами получеными выше
        end)
    end)


    sampRegisterChatCommand('pas', function(id) -- регаем команду
        if id == '' then -- если айди игрока равно пустоте, то
            sampAddChatMessage('{FFA500}[Ошибка]: Введите ID игрока!') -- "ошибка"
            return
        end
        id = id:match('(.+)') -- получаем аргументы, и записываем в перменные
        lua_thread.create(function()
            sampProcessChatInput('/do Паспорт в кармане.')
            wait(1000)
            sampProcessChatInput('/me лёгким движением руки достал паспорт из кармана')
            wait(1000)
            sampProcessChatInput('/do Паспорт в руке.')
            wait(1000)
            sampProcessChatInput('/me передал паспорт человеку на против')
            wait(1000)
            sampProcessChatInput('/showpass '..id) -- отправляем в чат луа команду с аргументами получеными выше
        end)
    end)

    sampRegisterChatCommand('mc', function(id) -- регаем команду
        if id == '' then -- если айди игрока равно пустоте, то
            sampAddChatMessage('{FFA500}[Ошибка]: Введите ID игрока!') -- "ошибка"
            return
        end
        id = id:match('(.+)') -- получаем аргументы, и записываем в перменные
        lua_thread.create(function()
            sampProcessChatInput('/do Мед. карта в кармане.')
            wait(1000)
            sampProcessChatInput('/me лёгким движением руки достал мед. карту из кармана')
            wait(1000)
            sampProcessChatInput('/do Мед. карта в руке.')
            wait(1000)
            sampProcessChatInput('/me передал мед. карту человеку на против')
            wait(1000)
            sampProcessChatInput('/showlic '..id) -- отправляем в чат луа команду с аргументами получеными выше
        end)
    end)

----------------------------------------------------------------FBI CMD---------------------------------------------------------------------

    sampRegisterChatCommand('suf', function(arg) -- регаем команду
        local id, s, p = arg:match('^(%S+)%s+(%S+)%s+(.+)$') -- получаем аргументы, и записываем в перменные
            lua_thread.create(function ()
                if id and s and p then
                
                sampProcessChatInput('/do КПК в кармане.')
                    wait(1500)
                    sampProcessChatInput('/me лёгким движением руки достал КПК из кармана')
                    wait(1500)
                    sampProcessChatInput('/do КПК в руке.')
                    wait(1500)
                    sampProcessChatInput('/me вошёл в базу данных, затем зашёл в раздел "Нарушители"')
                    wait(1500)
                    sampProcessChatInput('/me выбрал '..sampGetPlayerNickname(id)..' в списке добавления и нажал кнопку "Объявить в розыск"')
                    wait(1500)
                    sampProcessChatInput('/su '..id..' '..s..' '..p) -- отправляем в чат луа команду с аргументами получеными выше
                    wait(1500)
                    sampProcessChatInput('/me выключил КПК и положил его в карман')
                    wait(1500)
                    sampProcessChatInput('/do КПК в кармане.')
                else
                    sampAddChatMessage('{FFA500}[Ошибка]: Введите /su [id] [уровень розыска] [причина]')
                end

            end)
    end)
    
    sampRegisterChatCommand('findf', function(id) -- регаем команду
        if id == '' then -- если айди игрока равно пустоте, то
            sampAddChatMessage('{FFA500}[Ошибка]: Введите ID игрока!') -- "ошибка"
            return
        end
        id = id:match('(.+)') -- получаем аргументы, и записываем в перменные
        lua_thread.create(function()
            sampProcessChatInput('/do КПК в кармане.')
            wait(1000)
            sampProcessChatInput('/me лёгким движением руки достал КПК из кармана')
            wait(1000)
            sampProcessChatInput('/do КПК в руке.')
            wait(1000)
            sampProcessChatInput('/me зашёл в базу данных, затем узнал координаты телефона маркировки "'..id..'"')
            wait(1000)
            sampProcessChatInput('/find '..id) -- отправляем в чат луа команду с аргументами получеными выше
            wait(1000)
            sampProcessChatInput('/me выключил и положил КПК в карман')
            wait(1000)
            sampProcessChatInput('/do КПК в кармане.')
        end)
    end)

    sampRegisterChatCommand('clearf', function(id) -- регаем команду
        if id == '' then -- если айди игрока равно пустоте, то
            sampAddChatMessage('{FFA500}[Ошибка]: Введите ID игрока!') -- "ошибка"
            return
        end
        id = id:match('(.+)') -- получаем аргументы, и записываем в перменные
        lua_thread.create(function()
            sampProcessChatInput('/do КПК в кармане.')
            wait(1000)
            sampProcessChatInput('/me лёгким движением руки достал КПК из кармана')
            wait(1000)
            sampProcessChatInput('/do КПК в руке.')
            wait(1000)
            sampProcessChatInput('/me вошёл в базу данных, затем зашёл в раздел "Нарушители"')
            wait(1000)
            sampProcessChatInput('/me выбрал '..sampGetPlayerNickname(id)..' в списке и нажал кнопку "Очистить розыск"')
            wait(1000)
            sampProcessChatInput('/clear '..id) -- отправляем в чат луа команду с аргументами получеными выше
            wait(1000)
            sampProcessChatInput('/me выключил КПК и положил его в карман')
            wait(1000)
            sampProcessChatInput('/do КПК в кармане.')
        end)
    end)

    sampRegisterChatCommand('takef', function(id) -- регаем команду
        if id == '' then -- если айди игрока равно пустоте, то
            sampAddChatMessage('{FFA500}[Ошибка]: Введите ID игрока!') -- "ошибка"
            return
        end
        id = id:match('(.+)') -- получаем аргументы, и записываем в перменные
        lua_thread.create(function ()
            sampProcessChatInput('/me надел латексные перчатки, затем обыскав, изъял запрещённые в штате вещи')
            wait(1000)
            sampProcessChatInput('/take '..id)
        end)
    end)

    sampRegisterChatCommand('friskf', function(id) -- регаем команду
        if id == '' then -- если айди игрока равно пустоте, то
            sampAddChatMessage('{FFA500}[Ошибка]: Введите ID игрока!') -- "ошибка"
            return
        end
        id = id:match('(.+)') -- получаем аргументы, и записываем в перменные
        lua_thread.create(function ()
            sampProcessChatInput('/me надел латексные перчатки, затем начал обыскивать верхнюю часть тела')
            wait(2000)
            sampProcessChatInput('/me обыскивает нижнюю часть тела')
            wait(1000)
            sampProcessChatInput('/frisk '..id)
            wait(1000)
            sampProcessChatInput('/do Обыскал человека на против и убрал перчатки.')
        end)
    end)

    while true do
        wait(0)
    end
end
--[[

lua_thread.create(function()

end)


sampRegisterChatCommand('pass', function(id) -- регаем команду /pass
    id = id:match('(.+) (.+)') -- получаем аргументы, в данном случае примером команды будет "/pass 91", и записываем в перменные
    sampProcessChatInput('/showpass '..id) -- отправляем в чат луа команду с аргументами получеными выше
end)]]
