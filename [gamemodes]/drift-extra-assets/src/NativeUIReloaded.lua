print("Loaded extra assets")
---@type table
UIResText = setmetatable({}, UIResText)

---@type table
UIResText.__index = UIResText

---@type table
---@return string
UIResText.__call = function()
    return "Text"
end

---GetCharacterCount
---@param str string
function GetCharacterCount(str)
    local characters = 0
    for c in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        local a = c:byte(1, -1)
        if a ~= nil then
            characters = characters + 1
        end
    end
    return characters
end

---GetByteCount
---@param str string
function GetByteCount(str)
    local bytes = 0
    for c in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        local a, b, c, d = c:byte(1, -1)
        if a ~= nil then
            bytes = bytes + 1
        end
        if b ~= nil then
            bytes = bytes + 1
        end
        if c ~= nil then
            bytes = bytes + 1
        end
        if d ~= nil then
            bytes = bytes + 1
        end
    end
    return bytes
end

---AddLongStringForAscii
---@param str string
function AddLongStringForAscii(str)
    local maxbytelength = 99
    for i = 0, GetCharacterCount(str), 99 do
        AddTextComponentSubstringPlayerName(string.sub(str, i, math.min(maxbytelength, GetCharacterCount(str) - i))) --needs changed
    end
end

---AddLongStringForUtf8
---@param str string
function AddLongStringForUtf8(str)
    local maxbytelength = 99
    local bytecount = GetByteCount(str)
    if bytecount < maxbytelength then
        AddTextComponentSubstringPlayerName(str)
        return
    end
    local startIndex = 0
    for i = 0, GetCharacterCount(str), 1 do
        local length = i - startIndex
        if GetByteCount(string.sub(str, startIndex, length)) > maxbytelength then
            AddTextComponentSubstringPlayerName(string.sub(str, startIndex, length - 1))
            i = i - 1
            startIndex = startIndex + (length - 1)
        end
    end
    AddTextComponentSubstringPlayerName(string.sub(str, startIndex, GetCharacterCount(str) - startIndex))
end

---AddLongString
---@param str string
function AddLongString(str)
    local bytecount = GetByteCount(str)
    if bytecount == GetCharacterCount(str) then
        AddLongStringForAscii(str)
    else
        AddLongStringForUtf8(str)
    end
end

---MeasureStringWidthNoConvert
---@param str string
---@param font number
---@param scale number
function MeasureStringWidthNoConvert(str, font, scale)
    BeginTextCommandWidth("STRING")
    AddLongString(str)
    SetTextFont(font or 0)
    SetTextScale(1.0, scale or 0)
    return EndTextCommandGetWidth(true)
end

---MeasureStringWidth
---@param str string
---@param font number
---@param scale number
function MeasureStringWidth(str, font, scale)
    local W, H = GetResolution()
    return MeasureStringWidthNoConvert(str, font, scale) * W
end

---New
---@param Text string
---@param X number
---@param Y number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Font number
---@param Alignment number
---@param DropShadow number
---@param Outline number
---@param WordWrap number
---@return table
---@public
function UIResText.New(Text, X, Y, Scale, R, G, B, A, Font, Alignment, DropShadow, Outline, WordWrap)
    local _UIResText = {
        _Text = tostring(Text) or "",
        X = tonumber(X) or 0,
        Y = tonumber(Y) or 0,
        Scale = tonumber(Scale) or 0,
        _Colour = { R = tonumber(R) or 255, G = tonumber(G) or 255, B = tonumber(B) or 255, A = tonumber(A) or 255 },
        Font = tonumber(Font) or 0,
        Alignment = Alignment or nil,
        DropShadow = DropShadow or nil,
        Outline = Outline or nil,
        WordWrap = tonumber(WordWrap) or 0,
    }
    return setmetatable(_UIResText, UIResText)
end

---Position
---@param X number
---@param Y number
---@return table
---@public
function UIResText:Position(X, Y)
    if tonumber(X) and tonumber(Y) then
        self.X = tonumber(X)
        self.Y = tonumber(Y)
    else
        return { X = self.X, Y = self.Y }
    end
end

---Colour
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function UIResText:Colour(R, G, B, A)
    if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
        self._Colour.R = tonumber(R)
        self._Colour.B = tonumber(B)
        self._Colour.G = tonumber(G)
        self._Colour.A = tonumber(A)
    else
        return self._Colour
    end
end

---Text
---@param Text string
---@return string
---@public
function UIResText:Text(Text)
    if tostring(Text) and Text ~= nil then
        self._Text = tostring(Text)
    else
        return self._Text
    end
end

---Draw
---@return nil
---@public
function UIResText:Draw()
    local Position = self:Position()
    Position.X, Position.Y = FormatXWYH(Position.X, Position.Y)

    SetTextFont(self.Font)
    SetTextScale(1.0, self.Scale)
    SetTextColour(self._Colour.R, self._Colour.G, self._Colour.B, self._Colour.A)

    if self.DropShadow then
        SetTextDropShadow()
    end
    if self.Outline then
        SetTextOutline()
    end

    if self.Alignment ~= nil then
        if self.Alignment == 1 or self.Alignment == "Center" or self.Alignment == "Centre" then
            SetTextCentre(true)
        elseif self.Alignment == 2 or self.Alignment == "Right" then
            SetTextRightJustify(true)
            SetTextWrap(0, Position.X)
        end
    end

    if tonumber(self.WordWrap) then
        if tonumber(self.WordWrap) ~= 0 then
            SetTextWrap(Position.X, Position.X + (tonumber(self.WordWrap) / Resolution.Width))
        end
    end

    BeginTextCommandDisplayText("STRING")
    AddLongString(self._Text)
    EndTextCommandDisplayText(Position.X, Position.Y)
end
---@type table
UIVisual = setmetatable({}, UIVisual)

---@type table
UIVisual.__index = UIVisual

---Popup
---@param array table
---@public
function UIVisual:Popup(array)
    ClearPrints()
    if (array.colors == nil) then
        SetNotificationBackgroundColor(140)
    else
        SetNotificationBackgroundColor(array.colors)
    end
    SetNotificationTextEntry("STRING")
    if (array.message == nil) then
        error("Missing arguments, message")
    else
        AddTextComponentString(tostring(array.message))
    end
    DrawNotification(false, true)
    if (array.sound ~= nil) then
        if (array.sound.audio_name ~= nil) then
            if (array.sound.audio_ref ~= nil) then
                PlaySoundFrontend(-1, array.sound.audio_name, array.sound.audio_ref, true)
            else
                error("Missing arguments, audio_ref")
            end
        else
            error("Missing arguments, audio_name")
        end
    end
end

---PopupChar
---@param array table
---@public
function UIVisual:PopupChar(array)
    if (array.colors == nil) then
        SetNotificationBackgroundColor(140)
    else
        SetNotificationBackgroundColor(array.colors)
    end
    SetNotificationTextEntry("STRING")
    if (array.message == nil) then
        error("Missing arguments, message")
    else
        AddTextComponentString(tostring(array.message))
    end
    if (array.request_stream_texture_dics ~= nil) then
        RequestStreamedTextureDict(array.request_stream_texture_dics)
    end
    if (array.picture ~= nil) then
        if (array.iconTypes == 1) or (array.iconTypes == 2) or (array.iconTypes == 3) or (array.iconTypes == 7) or (array.iconTypes == 8) or (array.iconTypes == 9) then
            SetNotificationMessage(tostring(array.picture), tostring(array.picture), true, array.iconTypes, array.sender, array.title)
        else
            SetNotificationMessage(tostring(array.picture), tostring(array.picture), true, 4, array.sender, array.title)
        end
    else
        if (array.iconTypes == 1) or (array.iconTypes == 2) or (array.iconTypes == 3) or (array.iconTypes == 7) or (array.iconTypes == 8) or (array.iconTypes == 9) then
            SetNotificationMessage('CHAR_ALL_PLAYERS_CONF', 'CHAR_ALL_PLAYERS_CONF', true, array.iconTypes, array.sender, array.title)
        else
            SetNotificationMessage('CHAR_ALL_PLAYERS_CONF', 'CHAR_ALL_PLAYERS_CONF', true, 4, array.sender, array.title)
        end
    end
    if (array.sound ~= nil) then
        if (array.sound.audio_name ~= nil) then
            if (array.sound.audio_ref ~= nil) then
                PlaySoundFrontend(-1, array.sound.audio_name, array.sound.audio_ref, true)
            else
                error("Missing arguments, audio_ref")
            end
        else
            error("Missing arguments, audio_name")
        end
    end
    DrawNotification(false, true)
end

---Text
---@param array table
---@public
function UIVisual:Text(array)
    ClearPrints()
    SetTextEntry_2("STRING")
    if (array.message ~= nil) then
        AddTextComponentString(tostring(array.message))
    else
        error("Missing arguments, message")
    end
    if (array.time_display ~= nil) then
        DrawSubtitleTimed(tonumber(array.time_display), 1)
    else
        DrawSubtitleTimed(6000, 1)
    end
    if (array.sound ~= nil) then
        if (array.sound.audio_name ~= nil) then
            if (array.sound.audio_ref ~= nil) then
                PlaySoundFrontend(-1, array.sound.audio_name, array.sound.audio_ref, true)
            else
                error("Missing arguments, audio_ref")
            end
        else
            error("Missing arguments, audio_name")
        end
    end
end

---FloatingHelpText
---@param array table
---@public
function UIVisual:FloatingHelpText(array)
    BeginTextCommandDisplayHelp("STRING")
    if (array.message ~= nil) then
        AddTextComponentScaleform(array.message)
    else
        error("Missing arguments, message")
    end
    EndTextCommandDisplayHelp(0, 0, 1, -1)
    if (array.sound ~= nil) then
        if (array.sound.audio_name ~= nil) then
            if (array.sound.audio_ref ~= nil) then
                PlaySoundFrontend(-1, array.sound.audio_name, array.sound.audio_ref, true)
            else
                error("Missing arguments, audio_ref")
            end
        else
            error("Missing arguments, audio_name")
        end
    end
end

---ShowFreemodeMessage
---@param array table
---@public
function UIVisual:ShowFreemodeMessage(array)
    if (array.sound ~= nil) then
        if (array.sound.audio_name ~= nil) then
            if (array.sound.audio_ref ~= nil) then
                PlaySoundFrontend(-1, array.sound.audio_name, array.sound.audio_ref, true)
            else
                error("Missing arguments, audio_ref")
            end
        else
            error("Missing arguments, audio_name")
        end
    end
    if (array.request_scaleform ~= nil) then
        scaleform = Pyta.Request.Scaleform({
            movie = array.request_scaleform.movie
        })
        if (array.request_scaleform.scale ~= nil) then
            PushScaleformMovieFunction(scaleform, array.request_scaleform.scale)
        else
            PushScaleformMovieFunction(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
        end
    else
        scaleform = Pyta.Request.Scaleform({
            movie = 'MP_BIG_MESSAGE_FREEMODE'
        })
        if (array.request_scaleform.scale ~= nil) then
            PushScaleformMovieFunction(scaleform, array.request_scaleform.scale)
        else
            PushScaleformMovieFunction(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
        end
    end
    if (array.title ~= nil) then
        PushScaleformMovieFunctionParameterString(array.title)
    else
        ConsoleLog({
            message = 'Missing arguments { title = "Nice title" } '
        })
    end
    if (array.message ~= nil) then
        PushScaleformMovieFunctionParameterString(array.message)
    else
        ConsoleLog({
            message = 'Missing arguments { message = "Yeah display message right now" } '
        })
    end
    if (array.shake_gameplay ~= nil) then
        ShakeGameplayCam(array.shake_gameplay, 1.0)
    end
    if (array.screen_effect_in ~= nil) then
        StartScreenEffect(array.screen_effect_in, 0, 0)
    end
    PopScaleformMovieFunctionVoid()
    while array.time > 0 do
        Citizen.Wait(1)
        array.time = array.time - 1.0
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end
    if (array.screen_effect_in ~= nil) then
        StopScreenEffect(array.screen_effect_in)
    end
    if (array.screen_effect_out ~= nil) then
        StartScreenEffect(array.screen_effect_out, 0, 0)
    end
    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

---@type table
MenuPool = setmetatable({}, MenuPool)

---@type table
MenuPool.__index = MenuPool

---New
---@return table
---@public
function MenuPool.New()
    local _MenuPool = {
        Menus = {}
    }
    return setmetatable(_MenuPool, MenuPool)
end

---AddSubMenu
---@param Menu table
---@param Text string
---@param Description string
---@param KeepPosition boolean
---@param KeepBanner boolean
---@return table
---@public
function MenuPool:AddSubMenu(Menu, Text, Description, KeepPosition, KeepBanner)
    if Menu() == "UIMenu" then
        local Item = UIMenuItem.New(tostring(Text), Description or "")
        Menu:AddItem(Item)
        local SubMenu
        if KeepPosition then
            SubMenu = UIMenu.New(Menu.Title:Text(), Text, Menu.Position.X, Menu.Position.Y)
        else
            SubMenu = UIMenu.New(Menu.Title:Text(), Text)
        end
        if KeepBanner then
            if Menu.Logo ~= nil then
                SubMenu.Logo = Menu.Logo
            else
                SubMenu.Logo = nil
                SubMenu.Banner = Menu.Banner
            end
        end
        self:Add(SubMenu)
        Menu:BindMenuToItem(SubMenu, Item)
        return {
            SubMenu = SubMenu,
            Item = Item
        }
    end
end

---Add
---@param Menu table
---@return nil
---@public
function MenuPool:Add(Menu)
    if Menu() == "UIMenu" then
        table.insert(self.Menus, Menu)
    end
end

---MouseEdgeEnabled
---@param bool boolean
---@return nil
---@public
function MenuPool:MouseEdgeEnabled(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.MouseEdgeEnabled = tobool(bool)
        end
    end
end

---ControlDisablingEnabled
---@param bool boolean
---@return nil
---@public
function MenuPool:ControlDisablingEnabled(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.ControlDisablingEnabled = tobool(bool)
        end
    end
end

---ResetCursorOnOpen
---@param bool boolean
---@return nil
---@public
function MenuPool:ResetCursorOnOpen(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.ResetCursorOnOpen = tobool(bool)
        end
    end
end

---MultilineFormats
---@param bool boolean
---@return nil
---@public
function MenuPool:MultilineFormats(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.MultilineFormats = tobool(bool)
        end
    end
end

---Audio
---@param Attribute number
---@param Setting table
---@return nil
---@public
function MenuPool:Audio(Attribute, Setting)
    if Attribute ~= nil and Setting ~= nil then
        for _, Menu in pairs(self.Menus) do
            if Menu.Settings.Audio[Attribute] then
                Menu.Settings.Audio[Attribute] = Setting
            end
        end
    end
end

---WidthOffset
---@param offset number
---@return nil
---@public
function MenuPool:WidthOffset(offset)
    if tonumber(offset) then
        for _, Menu in pairs(self.Menus) do
            Menu:SetMenuWidthOffset(tonumber(offset))
        end
    end
end

---CounterPreText
---@param str string
---@return nil
---@public
function MenuPool:CounterPreText(str)
    if str ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.PageCounter.PreText = tostring(str)
        end
    end
end

---DisableInstructionalButtons
---@param bool boolean
---@return nil
---@public
function MenuPool:DisableInstructionalButtons(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.InstructionalButtons = tobool(bool)
        end
    end
end

---MouseControlsEnabled
---@param bool boolean
---@return nil
---@public
function MenuPool:MouseControlsEnabled(bool)
    if bool ~= nil then
        for _, Menu in pairs(self.Menus) do
            Menu.Settings.MouseControlsEnabled = tobool(bool)
        end
    end
end

---RefreshIndex
---@return nil
---@public
function MenuPool:RefreshIndex()
    for _, Menu in pairs(self.Menus) do
        Menu:RefreshIndex()
    end
end

---ProcessMenus
---@return nil
---@public
function MenuPool:ProcessMenus()
    self:ProcessControl()
    self:ProcessMouse()
    self:Draw()
end

---ProcessControl
---@return nil
---@public
function MenuPool:ProcessControl()
    for _, Menu in pairs(self.Menus) do
        if Menu:Visible() then
            Menu:ProcessControl()
        end
    end
end

---ProcessMouse
---@return nil
---@public
function MenuPool:ProcessMouse()
    for _, Menu in pairs(self.Menus) do
        if Menu:Visible() then
            Menu:ProcessMouse()
        end
    end
end

---Draw
---@return nil
---@public
function MenuPool:Draw()
    for _, Menu in pairs(self.Menus) do
        if Menu:Visible() then
            Menu:Draw()
        end
    end
end

---IsAnyMenuOpen
---@return boolean
---@public
function MenuPool:IsAnyMenuOpen()
    local open = false
    for _, Menu in pairs(self.Menus) do
        if Menu:Visible() then
            open = true
            break
        end
    end
    return open
end

---CloseAllMenus
---@return nil
---@public
function MenuPool:CloseAllMenus()
    for _, Menu in pairs(self.Menus) do
        if Menu:Visible() then
            Menu:Visible(false)
            Menu.OnMenuClosed(Menu)
        end
    end
end

---SetBannerSprite
---@param Sprite table
---@return nil
---@public
function MenuPool:SetBannerSprite(Sprite)
    if Sprite() == "Sprite" then
        for _, Menu in pairs(self.Menus) do
            Menu:SetBannerSprite(Sprite)
        end
    end
end

---SetBannerRectangle
---@param Rectangle table
---@return nil
---@public
function MenuPool:SetBannerRectangle(Rectangle)
    if Rectangle() == "Rectangle" then
        for _, Menu in pairs(self.Menus) do
            Menu:SetBannerRectangle(Rectangle)
        end
    end
end

---TotalItemsPerPage
---@param Value table
---@return nil
---@public
function MenuPool:TotalItemsPerPage(Value)
    if tonumber(Value) then
        for _, Menu in pairs(self.Menus) do
            Menu.Pagination.Total = Value - 1
        end
    end
end
---@type table
BadgeStyle = {
    None = 0,
    BronzeMedal = 1,
    GoldMedal = 2,
    SilverMedal = 3,
    Alert = 4,
    Crown = 5,
    Ammo = 6,
    Armour = 7,
    Barber = 8,
    Clothes = 9,
    Franklin = 10,
    Bike = 11,
    Car = 12,
    Gun = 13,
    Heart = 14,
    Makeup = 15,
    Mask = 16,
    Michael = 17,
    Star = 18,
    Tattoo = 19,
    Trevor = 20,
    Lock = 21,
    Tick = 22
}

---@type table
BadgeTexture = {
    [0] = function()
        return ""
    end,
    [1] = function()
        return "mp_medal_bronze"
    end,
    [2] = function()
        return "mp_medal_gold"
    end,
    [3] = function()
        return "mp_medal_silver"
    end,
    [4] = function()
        return "mp_alerttriangle"
    end,
    [5] = function()
        return "mp_hostcrown"
    end,
    [6] = function(Selected)
        if Selected then
            return "shop_ammo_icon_b"
        else
            return "shop_ammo_icon_a"
        end
    end,
    [7] = function(Selected)
        if Selected then
            return "shop_armour_icon_b"
        else
            return "shop_armour_icon_a"
        end
    end,
    [8] = function(Selected)
        if Selected then
            return "shop_barber_icon_b"
        else
            return "shop_barber_icon_a"
        end
    end,
    [9] = function(Selected)
        if Selected then
            return "shop_clothing_icon_b"
        else
            return "shop_clothing_icon_a"
        end
    end,
    [10] = function(Selected)
        if Selected then
            return "shop_franklin_icon_b"
        else
            return "shop_franklin_icon_a"
        end
    end,
    [11] = function(Selected)
        if Selected then
            return "shop_garage_bike_icon_b"
        else
            return "shop_garage_bike_icon_a"
        end
    end,
    [12] = function(Selected)
        if Selected then
            return "shop_garage_icon_b"
        else
            return "shop_garage_icon_a"
        end
    end,
    [13] = function(Selected)
        if Selected then
            return "shop_gunclub_icon_b"
        else
            return "shop_gunclub_icon_a"
        end
    end,
    [14] = function(Selected)
        if Selected then
            return "shop_health_icon_b"
        else
            return "shop_health_icon_a"
        end
    end,
    [15] = function(Selected)
        if Selected then
            return "shop_makeup_icon_b"
        else
            return "shop_makeup_icon_a"
        end
    end,
    [16] = function(Selected)
        if Selected then
            return "shop_mask_icon_b"
        else
            return "shop_mask_icon_a"
        end
    end,
    [17] = function(Selected)
        if Selected then
            return "shop_michael_icon_b"
        else
            return "shop_michael_icon_a"
        end
    end,
    [18] = function()
        return "shop_new_star"
    end,
    [19] = function(Selected)
        if Selected then
            return "shop_tattoos_icon_b"
        else
            return "shop_tattoos_icon_a"
        end
    end,
    [20] = function(Selected)
        if Selected then
            return "shop_trevor_icon_b"
        else
            return "shop_trevor_icon_a"
        end
    end,
    [21] = function()
        return "shop_lock"
    end,
    [22] = function()
        return "shop_tick_icon"
    end,
    [23] = function(Selected)
        if Selected then
            return "mp_specitem_coke_black"
        else
            return "mp_specitem_coke"
        end
    end,
}

---@type table
BadgeDictionary = {
    [0] = function(Selected)
        if Selected then
            return "commonmenu"
        else
            return "commonmenu"
        end
    end,
    [1] = function(Selected)
        if Selected then
            return "mpinventory"
        else
            return "mpinventory"
        end
    end,
}

---@type table
BadgeColour = {
    [5] = function(Selected)
        if Selected then
            return 0, 0, 0, 255
        else
            return 255, 255, 255, 255
        end
    end,
    [21] = function(Selected)
        if Selected then
            return 0, 0, 0, 255
        else
            return 255, 255, 255, 255
        end
    end,
    [22] = function(Selected)
        if Selected then
            return 0, 0, 0, 255
        else
            return 255, 255, 255, 255
        end
    end,
}

---GetBadgeTexture
---@param Badge number
---@param Selected table
---@return string
function GetBadgeTexture(Badge, Selected)
    if BadgeTexture[Badge] then
        return BadgeTexture[Badge](Selected)
    else
        return ""
    end
end

---GetBadgeDictionary
---@param Badge number
---@param Selected table
---@return string
function GetBadgeDictionary(Badge, Selected)
    if BadgeDictionary[Badge] then
        return BadgeDictionary[Badge](Selected)
    else
        return "commonmenu"
    end
end

---GetBadgeColour
---@param Badge number
---@param Selected table
---@return number
function GetBadgeColour(Badge, Selected)
    if BadgeColour[Badge] then
        return BadgeColour[Badge](Selected)
    else
        return 255, 255, 255, 255
    end
end

---@type table
UIMenuCheckboxItem = setmetatable({}, UIMenuCheckboxItem)

---@type table
UIMenuCheckboxItem.__index = UIMenuCheckboxItem

---@type table
---@return string
UIMenuCheckboxItem.__call = function()
    return "UIMenuItem", "UIMenuCheckboxItem"
end

---New
---@param Text string
---@param Check boolean
---@param Description string
---@param CheckboxStyle number
---@return table
---@public
function UIMenuCheckboxItem.New(Text, Check, Description, CheckboxStyle)
    if CheckboxStyle ~= nil then
        CheckboxStyle = tonumber(CheckboxStyle)
    else
        CheckboxStyle = 1
    end
    local _UIMenuCheckboxItem = {
        Base = UIMenuItem.New(Text or "", Description or ""),
        CheckboxStyle = CheckboxStyle,
        CheckedSprite = Sprite.New("commonmenu", "shop_box_blank", 410, 95, 50, 50),
        Checked = tobool(Check),
        CheckboxEvent = function(menu, item, checked)
        end,
    }
    return setmetatable(_UIMenuCheckboxItem, UIMenuCheckboxItem)
end

---SetParentMenu
---@param Menu table
---@return table
---@public
function UIMenuCheckboxItem:SetParentMenu(Menu)
    if Menu() == "UIMenu" then
        self.Base.ParentMenu = Menu
    else
        return self.Base.ParentMenu
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuCheckboxItem:Position(Y)
    if tonumber(Y) then
        self.Base:Position(Y)
        self.CheckedSprite:Position(380 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 138 + self.Base._Offset.Y)
    end
end

---Selected
---@param bool boolean
---@return boolean
---@public
function UIMenuCheckboxItem:Selected(bool)
    if bool ~= nil then
        self.Base._Selected = tobool(bool)
    else
        return self.Base._Selected
    end
end

---Hovered
---@param bool boolean
---@return boolean
---@public
function UIMenuCheckboxItem:Hovered(bool)
    if bool ~= nil then
        self.Base._Hovered = tobool(bool)
    else
        return self.Base._Hovered
    end
end

---Enabled
---@param bool boolean
---@return boolean
---@public
function UIMenuCheckboxItem:Enabled(bool)
    if bool ~= nil then
        self.Base._Enabled = tobool(bool)
    else
        return self.Base._Enabled
    end
end

---Description
---@param str string
---@return string
---@public
function UIMenuCheckboxItem:Description(str)
    if tostring(str) and str ~= nil then
        self.Base._Description = tostring(str)
    else
        return self.Base._Description
    end
end

---Offset
---@param X number
---@param Y number
---@return table
---@public
function UIMenuCheckboxItem:Offset(X, Y)
    if tonumber(X) or tonumber(Y) then
        if tonumber(X) then
            self.Base._Offset.X = tonumber(X)
        end
        if tonumber(Y) then
            self.Base._Offset.Y = tonumber(Y)
        end
    else
        return self.Base._Offset
    end
end

---Text
---@param Text string
---@return string
---@public
function UIMenuCheckboxItem:Text(Text)
    if tostring(Text) and Text ~= nil then
        self.Base.Text:Text(tostring(Text))
    else
        return self.Base.Text:Text()
    end
end

---SetLeftBadge
---@return function
---@public
function UIMenuCheckboxItem:SetLeftBadge()
    error("This item does not support badges")
end

---SetRightBadge
---@return function
---@public
function UIMenuCheckboxItem:SetRightBadge()
    error("This item does not support badges")
end

---RightLabel
---@return function
---@public
function UIMenuCheckboxItem:RightLabel()
    error("This item does not support a right label")
end

---Draw
---@return nil
---@public
function UIMenuCheckboxItem:Draw()
    self.Base:Draw()
    self.CheckedSprite:Position(380 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, self.CheckedSprite.Y)
    if self.CheckboxStyle == nil or self.CheckboxStyle == tonumber(1) then
        if self.Base:Selected() then
            if self.Checked then
                self.CheckedSprite.TxtName = "shop_box_tickb"
            else
                self.CheckedSprite.TxtName = "shop_box_blankb"
            end
        else
            if self.Checked then
                self.CheckedSprite.TxtName = "shop_box_tick"
            else
                self.CheckedSprite.TxtName = "shop_box_blank"
            end
        end
    elseif self.CheckboxStyle == tonumber(2) then
        if self.Base:Selected() then
            if self.Checked then
                self.CheckedSprite.TxtName = "shop_box_crossb"
            else
                self.CheckedSprite.TxtName = "shop_box_blankb"
            end
        else
            if self.Checked then
                self.CheckedSprite.TxtName = "shop_box_cross"
            else
                self.CheckedSprite.TxtName = "shop_box_blank"
            end
        end
    end
    self.CheckedSprite:Draw()
end

---@type table
Sprite = setmetatable({}, Sprite)

---@type table
Sprite.__index = Sprite

---@type table
---@return string
Sprite.__call = function()
    return "Sprite"
end

---New
---@param TxtDictionary string
---@param TxtName string
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function Sprite.New(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
    local _Sprite = {
        TxtDictionary = tostring(TxtDictionary),
        TxtName = tostring(TxtName),
        X = tonumber(X) or 0,
        Y = tonumber(Y) or 0,
        Width = tonumber(Width) or 0,
        Height = tonumber(Height) or 0,
        Heading = tonumber(Heading) or 0,
        _Colour = { R = tonumber(R) or 255, G = tonumber(G) or 255, B = tonumber(B) or 255, A = tonumber(A) or 255 },
    }
    return setmetatable(_Sprite, Sprite)
end

---Position
---@param X number
---@param Y number
---@return table
---@public
function Sprite:Position(X, Y)
    if tonumber(X) and tonumber(Y) then
        self.X = tonumber(X)
        self.Y = tonumber(Y)
    else
        return { X = self.X, Y = self.Y }
    end
end

---Size
---@param Width number
---@param Height number
---@return table
---@public
function Sprite:Size(Width, Height)
    if tonumber(Width) and tonumber(Width) then
        self.Width = tonumber(Width)
        self.Height = tonumber(Height)
    else
        return { Width = self.Width, Height = self.Height }
    end
end

---Colour
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function Sprite:Colour(R, G, B, A)
    if tonumber(R) or tonumber(G) or tonumber(B) or tonumber(A) then
        self._Colour.R = tonumber(R) or 255
        self._Colour.B = tonumber(B) or 255
        self._Colour.G = tonumber(G) or 255
        self._Colour.A = tonumber(A) or 255
    else
        return self._Colour
    end
end

---Draw
---@return nil
---@public
function Sprite:Draw()
    if not HasStreamedTextureDictLoaded(self.TxtDictionary) then
        RequestStreamedTextureDict(self.TxtDictionary, true)
    end
    local Position = self:Position()
    local Size = self:Size()
    Size.Width, Size.Height = FormatXWYH(Size.Width, Size.Height)
    Position.X, Position.Y = FormatXWYH(Position.X, Position.Y)
    DrawSprite(self.TxtDictionary, self.TxtName, Position.X + Size.Width * 0.5, Position.Y + Size.Height * 0.5, Size.Width, Size.Height, self.Heading, self._Colour.R, self._Colour.G, self._Colour.B, self._Colour.A)
end

---@type table
UIResRectangle = setmetatable({}, UIResRectangle)

---@type table
UIResRectangle.__index = UIResRectangle

---@type table
---@return string
UIResRectangle.__call = function()
    return "Rectangle"
end

---New
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function UIResRectangle.New(X, Y, Width, Height, R, G, B, A)
    local _UIResRectangle = {
        X = tonumber(X) or 0,
        Y = tonumber(Y) or 0,
        Width = tonumber(Width) or 0,
        Height = tonumber(Height) or 0,
        _Colour = { R = tonumber(R) or 255, G = tonumber(G) or 255, B = tonumber(B) or 255, A = tonumber(A) or 255 },
    }
    return setmetatable(_UIResRectangle, UIResRectangle)
end

---Position
---@param X number
---@param Y number
---@return table
---@public
function UIResRectangle:Position(X, Y)
    if tonumber(X) and tonumber(Y) then
        self.X = tonumber(X)
        self.Y = tonumber(Y)
    else
        return { X = self.X, Y = self.Y }
    end
end

---Size
---@param Width number
---@param Height number
---@return table
---@public
function UIResRectangle:Size(Width, Height)
    if tonumber(Width) and tonumber(Height) then
        self.Width = tonumber(Width)
        self.Height = tonumber(Height)
    else
        return { Width = self.Width, Height = self.Height }
    end
end

---Colour
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function UIResRectangle:Colour(R, G, B, A)
    if tonumber(R) or tonumber(G) or tonumber(B) or tonumber(A) then
        self._Colour.R = tonumber(R) or 255
        self._Colour.B = tonumber(B) or 255
        self._Colour.G = tonumber(G) or 255
        self._Colour.A = tonumber(A) or 255
    else
        return self._Colour
    end
end

---Draw
---@return table
---@public
function UIResRectangle:Draw()
    local Position = self:Position()
    local Size = self:Size()
    Size.Width, Size.Height = FormatXWYH(Size.Width, Size.Height)
    Position.X, Position.Y = FormatXWYH(Position.X, Position.Y)
    DrawRect(Position.X + Size.Width * 0.5, Position.Y + Size.Height * 0.5, Size.Width, Size.Height, self._Colour.R, self._Colour.G, self._Colour.B, self._Colour.A)
end

---@type table
UIMenuColouredItem = setmetatable({}, UIMenuColouredItem)

---@type table
UIMenuColouredItem.__index = UIMenuColouredItem

---@type table
---@return string
UIMenuColouredItem.__call = function()
    return "UIMenuItem", "UIMenuColouredItem"
end

---New
---@param Text string
---@param Description string
---@param MainColour table
---@param HighlightColour table
---@return table
---@public
function UIMenuColouredItem.New(Text, Description, MainColour, HighlightColour)
    if type(Colour) ~= "table" then
        Colour = { R = 0, G = 0, B = 0, A = 255 }
    end
    if type(HighlightColour) ~= "table" then
        Colour = { R = 255, G = 255, B = 255, A = 255 }
    end
    local _UIMenuColouredItem = {
        Base = UIMenuItem.New(Text or "", Description or ""),
        Rectangle = UIResRectangle.New(0, 0, 431, 38, MainColour.R, MainColour.G, MainColour.B, MainColour.A),
        MainColour = MainColour,
        HighlightColour = HighlightColour,
        ParentMenu = nil,
        Activated = function(menu, item)
        end,
    }
    _UIMenuColouredItem.Base.SelectedSprite:Colour(HighlightColour.R, HighlightColour.G, HighlightColour.B, HighlightColour.A)
    return setmetatable(_UIMenuColouredItem, UIMenuColouredItem)
end

---SetParentMenu
---@param Menu table
---@return table
---@public
function UIMenuColouredItem:SetParentMenu(Menu)
    if Menu() == "UIMenu" then
        self.Base.ParentMenu = Menu
        self.ParentMenu = Menu
    else
        return self.Base.ParentMenu
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuColouredItem:Position(Y)
    if tonumber(Y) then
        self.Base:Position(Y)
        self.Rectangle:Position(self.Base._Offset.X, Y + 144 + self.Base._Offset.Y)
    end
end

---Selected
---@param bool boolean
---@return boolean
---@public
function UIMenuColouredItem:Selected(bool)
    if bool ~= nil then
        self.Base._Selected = tobool(bool)
    else
        return self.Base._Selected
    end
end

---Hovered
---@param bool boolean
---@return boolean
---@public
function UIMenuColouredItem:Hovered(bool)
    if bool ~= nil then
        self.Base._Hovered = tobool(bool)
    else
        return self.Base._Hovered
    end
end

---Enabled
---@param bool boolean
---@return boolean
---@public
function UIMenuColouredItem:Enabled(bool)
    if bool ~= nil then
        self.Base._Enabled = tobool(bool)
    else
        return self.Base._Enabled
    end
end

---Description
---@param str string
---@return string
---@public
function UIMenuColouredItem:Description(str)
    if tostring(str) and str ~= nil then
        self.Base._Description = tostring(str)
    else
        return self.Base._Description
    end
end

---Offset
---@param X number
---@param Y number
---@return table
---@public
function UIMenuColouredItem:Offset(X, Y)
    if tonumber(X) or tonumber(Y) then
        if tonumber(X) then
            self.Base._Offset.X = tonumber(X)
        end
        if tonumber(Y) then
            self.Base._Offset.Y = tonumber(Y)
        end
    else
        return self.Base._Offset
    end
end

---Text
---@param Text string
---@return string
---@public
function UIMenuColouredItem:Text(Text)
    if tostring(Text) and Text ~= nil then
        self.Base.Text:Text(tostring(Text))
    else
        return self.Base.Text:Text()
    end
end

---SetTextSelectedColor
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function UIMenuColouredItem:SetTextSelectedColor(R, G, B, A)
    if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
        self.Base._Text.Colour.Selected.R = R
        self.Base._Text.Colour.Selected.G = G
        self.Base._Text.Colour.Selected.B = B
        self.Base._Text.Colour.Selected.A = A
    else
        return { R = self.Base._Text.Colour.Selected.R, G = self.Base._Text.Colour.Selected.G, B = self.Base._Text.Colour.Selected.B, A = self.Base._Text.Colour.Selected.A, }
    end
end

---SetTextHoveredColor
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function UIMenuColouredItem:SetTextHoveredColor(R, G, B, A)
    if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
        self.Base._Text.Colour.Hovered.R = R
        self.Base._Text.Colour.Hovered.G = G
        self.Base._Text.Colour.Hovered.B = B
        self.Base._Text.Colour.Hovered.A = A
    else
        return { R = self.Base._Text.Colour.Hovered.R, G = self.Base._Text.Colour.Hovered.G, B = self.Base._Text.Colour.Hovered.B, A = self.Base._Text.Colour.Hovered.A, }
    end
end

---RightLabel
---@param Text string
---@param MainColour table
---@param HighlightColour table
---@return table
---@public
function UIMenuColouredItem:RightLabel(Text, MainColour, HighlightColour)
    if tostring(Text) and Text ~= nil then
        if type(MainColour) == "table" then
            self.Base.Label.MainColour = MainColour
        end
        if type(HighlightColour) == "table" then
            self.Base.Label.HighlightColour = HighlightColour
        end
        self.Base.Label.Text:Text(tostring(Text))
    else
        self.Label.MainColour = { R = 0, G = 0, B = 0, A = 0 }
        self.Label.HighlightColour = { R = 0, G = 0, B = 0, A = 0 }
        return self.Base.Label.Text:Text()
    end
end

---SetLeftBadge
---@param Badge number
---@return nil
---@public
function UIMenuColouredItem:SetLeftBadge(Badge)
    if tonumber(Badge) then
        self.Base.LeftBadge.Badge = tonumber(Badge)
    end
end

---SetRightBadge
---@param Badge number
---@return nil
---@public
function UIMenuColouredItem:SetRightBadge(Badge)
    if tonumber(Badge) then
        self.Base.RightBadge.Badge = tonumber(Badge)
    end
end

---Draw
---@return nil
---@public
function UIMenuColouredItem:Draw()
    self.Rectangle:Size(431 + self.ParentMenu.WidthOffset, self.Rectangle.Height)
    self.Rectangle:Draw()
    self.Base:Draw()
end

---@type table
ColoursPanel = {}

---@type table
ColoursPanel.HairCut = {
    { 22, 19, 19 }, -- 0
    { 30, 28, 25 }, -- 1
    { 76, 56, 45 }, -- 2
    { 69, 34, 24 }, -- 3
    { 123, 59, 31 }, -- 4
    { 149, 68, 35 }, -- 5
    { 165, 87, 50 }, -- 6
    { 175, 111, 72 }, -- 7
    { 159, 105, 68 }, -- 8
    { 198, 152, 108 }, -- 9
    { 213, 170, 115 }, -- 10
    { 223, 187, 132 }, -- 11
    { 202, 164, 110 }, -- 12
    { 238, 204, 130 }, -- 13
    { 229, 190, 126 }, -- 14
    { 250, 225, 167 }, -- 15
    { 187, 140, 96 }, -- 16
    { 163, 92, 60 }, -- 17
    { 144, 52, 37 }, -- 18
    { 134, 21, 17 }, -- 19
    { 164, 24, 18 }, -- 20
    { 195, 33, 24 }, -- 21
    { 221, 69, 34 }, -- 22
    { 229, 71, 30 }, -- 23
    { 208, 97, 56 }, -- 24
    { 113, 79, 38 }, -- 25
    { 132, 107, 95 }, -- 26
    { 185, 164, 150 }, -- 27
    { 218, 196, 180 }, -- 28
    { 247, 230, 217 }, -- 29
    { 102, 72, 93 }, -- 30
    { 162, 105, 138 }, -- 31
    { 171, 174, 11 }, -- 32
    { 239, 61, 200 }, -- 33
    { 255, 69, 152 }, -- 34
    { 255, 178, 191 }, -- 35
    { 12, 168, 146 }, -- 36
    { 8, 146, 165 }, -- 37
    { 11, 82, 134 }, -- 38
    { 118, 190, 117 }, -- 39
    { 52, 156, 104 }, -- 40
    { 22, 86, 85 }, -- 41
    { 152, 177, 40 }, -- 42
    { 127, 162, 23 }, -- 43
    { 241, 200, 98 }, -- 44
    { 238, 178, 16 }, -- 45
    { 224, 134, 14 }, -- 46
    { 247, 157, 15 }, -- 47
    { 243, 143, 16 }, -- 48
    { 231, 70, 15 }, -- 49
    { 255, 101, 21 }, -- 50
    { 254, 91, 34 }, -- 51
    { 252, 67, 21 }, -- 52
    { 196, 12, 15 }, -- 53
    { 143, 10, 14 }, -- 54
    { 44, 27, 22 }, -- 55
    { 80, 51, 37 }, -- 56
    { 98, 54, 37 }, -- 57
    { 60, 31, 24 }, -- 58
    { 69, 43, 32 }, -- 59
    { 8, 10, 14 }, -- 60
    { 212, 185, 158 }, -- 61
    { 212, 185, 158 }, -- 62
    { 213, 170, 115 }, -- 63
}

---@type table
ColoursPanel.Makeup = {
    { 153,37,50 },
    { 200,57,93 },
    { 189,81,108 },
    { 184,99,122 },
    { 166,82,107 },
    { 177,67,76 },
    { 127,49,51 },
    { 164,100,93 },
    { 193,135,121 },
    { 203,160,150 },
    { 198,145,143 },
    { 171,111,99 },
    { 176,96,80 },
    { 168,76,51 },
    { 180,113,120 },
    { 202,127,146 },
    { 237,156,190 },
    { 231,117,164 },
    { 222,62,129 },
    { 179,76,110 },
    { 113,39,57 },
    { 79,31,42 },
    { 170,34,47 },
    { 222,32,52 },
    { 207,8,19 },
    { 229,84,112 },
    { 220,63,181 },
    { 194,39,178 },
    { 160,28,169 },
    { 110,24,117 },
    { 115,20,101 },
    { 86,22,92 },
    { 109,26,157 },
    { 27,55,113 },
    { 29,78,167 },
    { 30,116,187 },
    { 33,163,206 },
    { 37,194,210 },
    { 35,204,165 },
    { 39,192,125 },
    { 27,156,50 },
    { 20,134,4 },
    { 112,208,65 },
    { 197,234,52 },
    { 225,227,47 },
    { 255,221,38 },
    { 250,192,38 },
    { 247,138,39 },
    { 254,89,16 },
    { 190,110,25 },
    { 247,201,127 },
    { 251,229,192 },
    { 245,245,245 },
    { 179,180,179 },
    { 145,145,145 },
    { 86,78,78 },
    { 24,14,14 },
    { 88,150,158 },
    { 77,111,140 },
    { 26,43,85 },
    { 160,126,107 },
    { 130,99,85 },
    { 109,83,70 },
    { 62,45,39 }
}

---@type table
CharacterMap = {
    [' '] = 6,
    ['!'] = 6,
    ['"'] = 6,
    ['#'] = 11,
    ['$'] = 10,
    ['%'] = 17,
    ['&'] = 13,
    ['\\'] = 4,
    ['('] = 6,
    [')'] = 6,
    ['*'] = 7,
    ['+'] = 10,
    [','] = 4,
    ['-'] = 6,
    ['.'] = 4,
    ['/'] = 7,
    ['0'] = 12,
    ['1'] = 7,
    ['2'] = 11,
    ['3'] = 11,
    ['4'] = 11,
    ['5'] = 11,
    ['6'] = 12,
    ['7'] = 10,
    ['8'] = 11,
    ['9'] = 11,
    [':'] = 5,
    [';'] = 4,
    ['<'] = 9,
    ['='] = 9,
    ['>'] = 9,
    ['?'] = 10,
    ['@'] = 15,
    ['A'] = 12,
    ['B'] = 13,
    ['C'] = 14,
    ['D'] = 14,
    ['E'] = 12,
    ['F'] = 12,
    ['G'] = 15,
    ['H'] = 14,
    ['I'] = 5,
    ['J'] = 11,
    ['K'] = 13,
    ['L'] = 11,
    ['M'] = 16,
    ['N'] = 14,
    ['O'] = 16,
    ['P'] = 12,
    ['Q'] = 15,
    ['R'] = 13,
    ['S'] = 12,
    ['T'] = 11,
    ['U'] = 13,
    ['V'] = 12,
    ['W'] = 18,
    ['X'] = 11,
    ['Y'] = 11,
    ['Z'] = 12,
    ['['] = 6,
    [']'] = 6,
    ['^'] = 9,
    ['_'] = 18,
    ['`'] = 8,
    ['a'] = 11,
    ['b'] = 12,
    ['c'] = 11,
    ['d'] = 12,
    ['e'] = 12,
    ['f'] = 5,
    ['g'] = 13,
    ['h'] = 11,
    ['i'] = 4,
    ['j'] = 4,
    ['k'] = 10,
    ['l'] = 4,
    ['m'] = 18,
    ['n'] = 11,
    ['o'] = 12,
    ['p'] = 12,
    ['q'] = 12,
    ['r'] = 7,
    ['s'] = 9,
    ['t'] = 5,
    ['u'] = 11,
    ['v'] = 10,
    ['w'] = 14,
    ['x'] = 9,
    ['y'] = 10,
    ['z'] = 9,
    ['{'] = 6,
    ['|'] = 3,
    ['}'] = 6,
}

---MeasureString
---@param str string
---@return string
function MeasureString(str)
    local output = 0
    for i = 1, GetCharacterCount(str), 1 do
        if CharacterMap[string.sub(str, i, i)] then
            output = output + CharacterMap[string.sub(str, i, i)] + 1
        end
    end
    return output
end

---@type table
UIMenuListItem = setmetatable({}, UIMenuListItem)

---@type table
UIMenuListItem.__index = UIMenuListItem

---@type table
---@return string
UIMenuListItem.__call = function()
    return "UIMenuItem", "UIMenuListItem"
end

---New
---@param Text string
---@param Items table
---@param Index number
---@param Description string
---@return table
---@public
function UIMenuListItem.New(Text, Items, Index, Description)
    if type(Items) ~= "table" then
        Items = {}
    end
    if Index == 0 then
        Index = 1
    end
    local _UIMenuListItem = {
        Base = UIMenuItem.New(Text or "", Description or ""),
        Items = Items,
        LeftArrow = Sprite.New("commonmenu", "arrowleft", 110, 105, 30, 30),
        RightArrow = Sprite.New("commonmenu", "arrowright", 280, 105, 30, 30),
        ItemText = UIResText.New("", 290, 104, 0.35, 255, 255, 255, 255, 0, "Right"),
        _Index = tonumber(Index) or 1,
        Panels = {},
        OnListChanged = function(menu, item, newindex)
        end,
        OnListSelected = function(menu, item, newindex)
        end,
    }
    return setmetatable(_UIMenuListItem, UIMenuListItem)
end

---UpdateItems
---@param Items table
---@public
function UIMenuListItem:UpdateItems(Items)
    if #Items > 0 then
        self.Items = Items
    end
end

---SetParentMenu
---@param Menu table
---@return table
---@public
function UIMenuListItem:SetParentMenu(Menu)
    if Menu ~= nil and Menu() == "UIMenu" then
        self.Base.ParentMenu = Menu
    else
        return self.Base.ParentMenu
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuListItem:Position(Y)
    if tonumber(Y) then
        self.LeftArrow:Position(300 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 147 + Y + self.Base._Offset.Y)
        self.RightArrow:Position(400 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 147 + Y + self.Base._Offset.Y)
        self.ItemText:Position(300 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 147 + Y + self.Base._Offset.Y)
        self.Base:Position(Y)
    end
end

---Selected
---@param bool boolean
---@return boolean
---@public
function UIMenuListItem:Selected(bool)
    if bool ~= nil then
        self.Base._Selected = tobool(bool)
    else
        return self.Base._Selected
    end
end

---Hovered
---@param bool boolean
---@return boolean
---@public
function UIMenuListItem:Hovered(bool)
    if bool ~= nil then
        self.Base._Hovered = tobool(bool)
    else
        return self.Base._Hovered
    end
end

---Enabled
---@param bool boolean
---@return boolean
---@public
function UIMenuListItem:Enabled(bool)
    if bool ~= nil then
        self.Base._Enabled = tobool(bool)
    else
        return self.Base._Enabled
    end
end

---Description
---@param str string
---@return string
---@public
function UIMenuListItem:Description(str)
    if tostring(str) and str ~= nil then
        self.Base._Description = tostring(str)
    else
        return self.Base._Description
    end
end

---Offset
---@param X number
---@param Y number
---@return table
---@public
function UIMenuListItem:Offset(X, Y)
    if tonumber(X) or tonumber(Y) then
        if tonumber(X) then
            self.Base._Offset.X = tonumber(X)
        end
        if tonumber(Y) then
            self.Base._Offset.Y = tonumber(Y)
        end
    else
        return self.Base._Offset
    end
end

---Text
---@param Text string
---@return string
---@public
function UIMenuListItem:Text(Text)
    if tostring(Text) and Text ~= nil then
        self.Base.Text:Text(tostring(Text))
    else
        return self.Base.Text:Text()
    end
end

---Index
---@param Index table
---@return number
---@public
function UIMenuListItem:Index(Index)
    if tonumber(Index) then
        if tonumber(Index) > #self.Items then
            self._Index = 1
        elseif tonumber(Index) < 1 then
            self._Index = #self.Items
        else
            self._Index = tonumber(Index)
        end
    else
        return self._Index
    end
end

---ItemToIndex
---@param Item table
---@return table
---@public
function UIMenuListItem:ItemToIndex(Item)
    for i = 1, #self.Items do
        if type(Item) == type(self.Items[i]) and Item == self.Items[i] then
            return i
        elseif type(self.Items[i]) == "table" and (type(Item) == type(self.Items[i].Name) or type(Item) == type(self.Items[i].Value)) and (Item == self.Items[i].Name or Item == self.Items[i].Value) then
            return i
        end
    end
end

---IndexToItem
---@param Index table
---@return table
---@public
function UIMenuListItem:IndexToItem(Index)
    if tonumber(Index) then
        if tonumber(Index) == 0 then
            Index = 1
        end
        if self.Items[tonumber(Index)] then
            return self.Items[tonumber(Index)]
        end
    end
end

---SetLeftBadge
---@return function
---@public
function UIMenuListItem:SetLeftBadge()
    error("This item does not support badges")
end

---SetRightBadge
---@return function
---@public
function UIMenuListItem:SetRightBadge()
    error("This item does not support badges")
end

---RightLabel
---@return function
---@public
function UIMenuListItem:RightLabel()
    error("This item does not support a right label")
end

---AddPanel
---@param Panel table
---@return nil
---@public
function UIMenuListItem:AddPanel(Panel)
    if Panel() == "UIMenuPanel" then
        table.insert(self.Panels, Panel)
        Panel:SetParentItem(self)
    end
end

---RemovePanelAt
---@param Index table
---@return nil
---@public
function UIMenuListItem:RemovePanelAt(Index)
    if tonumber(Index) then
        if self.Panels[Index] then
            table.remove(self.Panels, tonumber(Index))
        end
    end
end

---FindPanelIndex
---@param Panel table
---@return number
---@public
function UIMenuListItem:FindPanelIndex(Panel)
    if Panel() == "UIMenuPanel" then
        for Index = 1, #self.Panels do
            if self.Panels[Index] == Panel then
                return Index
            end
        end
    end
    return nil
end

---FindPanelItem
---@return number
---@public
function UIMenuListItem:FindPanelItem()
    for Index = #self.Items, 1, -1 do
        if self.Items[Index].Panel then
            return Index
        end
    end
    return nil
end

---Draw
---@return nil
---@public
function UIMenuListItem:Draw()
    self.Base:Draw()

    if self:Enabled() then
        if self:Selected() then
            self.ItemText:Colour(0, 0, 0, 255)
            self.LeftArrow:Colour(0, 0, 0, 255)
            self.RightArrow:Colour(0, 0, 0, 255)
        else
            self.ItemText:Colour(245, 245, 245, 255)
            self.LeftArrow:Colour(245, 245, 245, 255)
            self.RightArrow:Colour(245, 245, 245, 255)
        end
    else
        self.ItemText:Colour(163, 159, 148, 255)
        self.LeftArrow:Colour(163, 159, 148, 255)
        self.RightArrow:Colour(163, 159, 148, 255)
    end

    local Text = (type(self.Items[self._Index]) == "table") and tostring(self.Items[self._Index].Name) or tostring(self.Items[self._Index])
    local Offset = MeasureStringWidth(Text, 0, 0.35)

    self.ItemText:Text(Text)
    self.LeftArrow:Position(378 - Offset + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, self.LeftArrow.Y)

    self.LeftArrow:Draw()
    self.RightArrow:Draw()
    self.ItemText:Position(403 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, self.ItemText.Y)

    self.ItemText:Draw()
end
---@type table
UIMenuSliderItem = setmetatable({}, UIMenuSliderItem)

---@type table
UIMenuSliderItem.__index = UIMenuSliderItem

---@type table
---@return string
UIMenuSliderItem.__call = function()
    return "UIMenuItem", "UIMenuSliderItem"
end

---New
---@param Text string
---@param Items table
---@param Index number
---@param Description string
---@param Divider boolean
---@param SliderColors table
---@param BackgroundSliderColors table
---@return table
---@public
function UIMenuSliderItem.New(Text, Items, Index, Description, Divider, SliderColors, BackgroundSliderColors)
    if type(Items) ~= "table" then
        Items = {}
    end
    if Index == 0 then
        Index = 1
    end
    if type(SliderColors) ~= "table" or SliderColors == nil then
        _SliderColors = { R = 57, G = 119, B = 200, A = 255 }
    else
        _SliderColors = SliderColors
    end
    if type(BackgroundSliderColors) ~= "table" or BackgroundSliderColors == nil then
        _BackgroundSliderColors = { R = 4, G = 32, B = 57, A = 255 }
    else
        _BackgroundSliderColors = BackgroundSliderColors
    end
    local _UIMenuSliderItem = {
        Base = UIMenuItem.New(Text or "", Description or ""),
        Items = Items,
        ShowDivider = tobool(Divider),
        LeftArrow = Sprite.New("commonmenu", "arrowleft", 0, 105, 25, 25),
        RightArrow = Sprite.New("commonmenu", "arrowright", 0, 105, 25, 25),
        Background = UIResRectangle.New(0, 0, 150, 10, _BackgroundSliderColors.R, _BackgroundSliderColors.G, _BackgroundSliderColors.B, _BackgroundSliderColors.A),
        Slider = UIResRectangle.New(0, 0, 75, 10, _SliderColors.R, _SliderColors.G, _SliderColors.B, _SliderColors.A),
        Divider = UIResRectangle.New(0, 0, 4, 20, 255, 255, 255, 255),
        _Index = tonumber(Index) or 1,
        OnSliderChanged = function(menu, item, newindex)
        end,
        OnSliderSelected = function(menu, item, newindex)
        end,
    }
    return setmetatable(_UIMenuSliderItem, UIMenuSliderItem)
end

---SetParentMenu
---@param Menu table
---@return table
---@public
function UIMenuSliderItem:SetParentMenu(Menu)
    if Menu() == "UIMenu" then
        self.Base.ParentMenu = Menu
    else
        return self.Base.ParentMenu
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuSliderItem:Position(Y)
    if tonumber(Y) then
        self.Background:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
        self.Slider:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
        self.Divider:Position(323.5 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 153 + self.Base._Offset.Y)
        self.LeftArrow:Position(225 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 150.5 + Y + self.Base._Offset.Y)
        self.RightArrow:Position(400 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 150.5 + Y + self.Base._Offset.Y)
        self.Base:Position(Y)
    end
end

---Selected
---@param bool table
---@return boolean
---@public
function UIMenuSliderItem:Selected(bool)
    if bool ~= nil then

        self.Base._Selected = tobool(bool)
    else
        return self.Base._Selected
    end
end

---Hovered
---@param bool boolean
---@return boolean
---@public
function UIMenuSliderItem:Hovered(bool)
    if bool ~= nil then
        self.Base._Hovered = tobool(bool)
    else
        return self.Base._Hovered
    end
end

---Enabled
---@param bool boolean
---@return boolean
---@public
function UIMenuSliderItem:Enabled(bool)
    if bool ~= nil then
        self.Base._Enabled = tobool(bool)
    else
        return self.Base._Enabled
    end
end

---Description
---@param str string
---@return string
---@public
function UIMenuSliderItem:Description(str)
    if tostring(str) and str ~= nil then
        self.Base._Description = tostring(str)
    else
        return self.Base._Description
    end
end

---Offset
---@param X number
---@param Y number
---@return table
---@public
function UIMenuSliderItem:Offset(X, Y)
    if tonumber(X) or tonumber(Y) then
        if tonumber(X) then
            self.Base._Offset.X = tonumber(X)
        end
        if tonumber(Y) then
            self.Base._Offset.Y = tonumber(Y)
        end
    else
        return self.Base._Offset
    end
end

---Text
---@param Text string
---@return string
---@public
function UIMenuSliderItem:Text(Text)
    if tostring(Text) and Text ~= nil then
        self.Base.Text:Text(tostring(Text))
    else
        return self.Base.Text:Text()
    end
end

---Index
---@param Index number
---@return number
---@public
function UIMenuSliderItem:Index(Index)
    if tonumber(Index) then
        if tonumber(Index) > #self.Items then
            self._Index = 1
        elseif tonumber(Index) < 1 then
            self._Index = #self.Items
        else
            self._Index = tonumber(Index)
        end
    else
        return self._Index
    end
end

---ItemToIndex
---@param Item number
---@return number
---@public
function UIMenuSliderItem:ItemToIndex(Item)
    for i = 1, #self.Items do
        if type(Item) == type(self.Items[i]) and Item == self.Items[i] then
            return i
        end
    end
end

---IndexToItem
---@param Index number
---@return table
---@public
function UIMenuSliderItem:IndexToItem(Index)
    if tonumber(Index) then
        if tonumber(Index) == 0 then
            Index = 1
        end
        if self.Items[tonumber(Index)] then
            return self.Items[tonumber(Index)]
        end
    end
end

---SetLeftBadge
---@return function
---@public
function UIMenuSliderItem:SetLeftBadge()
    error("This item does not support badges")
end

---SetRightBadge
---@return function
---@public
function UIMenuSliderItem:SetRightBadge()
    error("This item does not support badges")
end

---RightLabel
---@return function
---@public
function UIMenuSliderItem:RightLabel()
    error("This item does not support a right label")
end

---Draw
---@return nil
---@public
function UIMenuSliderItem:Draw()
    self.Base:Draw()

    if self:Enabled() then
        if self:Selected() then
            self.LeftArrow:Colour(0, 0, 0, 255)
            self.RightArrow:Colour(0, 0, 0, 255)
        else
            self.LeftArrow:Colour(245, 245, 245, 255)
            self.RightArrow:Colour(245, 245, 245, 255)
        end
    else
        self.LeftArrow:Colour(163, 159, 148, 255)
        self.RightArrow:Colour(163, 159, 148, 255)
    end

    local Offset = ((self.Background.Width - self.Slider.Width) / (#self.Items - 1)) * (self._Index - 1)

    self.Slider:Position(250 + self.Base._Offset.X + Offset + self.Base.ParentMenu.WidthOffset, self.Slider.Y)

    if self:Selected() then
        self.LeftArrow:Draw()
        self.RightArrow:Draw()
    end

    self.Background:Draw()
    self.Slider:Draw()
    if self.ShowDivider then
        self.Divider:Draw()
    end
end

---@type table
UIMenuSliderProgressItem = setmetatable({}, UIMenuSliderProgressItem)

---@type table
UIMenuSliderProgressItem.__index = UIMenuSliderProgressItem

---@type table
---@return string
UIMenuSliderProgressItem.__call = function()
    return "UIMenuItem", "UIMenuSliderProgressItem"
end

---New
---@param Text string
---@param Items string
---@param Index number
---@param Description string
---@param SliderColors thread
---@param BackgroundSliderColors thread
---@return table
---@public
function UIMenuSliderProgressItem.New(Text, Items, Index, Description, SliderColors, BackgroundSliderColors)
    if type(Items) ~= "table" then
        Items = {}
    end
    if Index == 0 then
        Index = 1
    end
    if type(SliderColors) ~= "table" or SliderColors == nil then
        _SliderColors = { R = 57, G = 119, B = 200, A = 255 }
    else
        _SliderColors = SliderColors
    end
    if type(BackgroundSliderColors) ~= "table" or BackgroundSliderColors == nil then
        _BackgroundSliderColors = { R = 4, G = 32, B = 57, A = 255 }
    else
        _BackgroundSliderColors = BackgroundSliderColors
    end
    local _UIMenuSliderProgressItem = {
        Base = UIMenuItem.New(Text or "", Description or ""),
        Items = Items,
        LeftArrow = Sprite.New("commonmenu", "arrowleft", 0, 105, 25, 25),
        RightArrow = Sprite.New("commonmenu", "arrowright", 0, 105, 25, 25),
        Background = UIResRectangle.New(0, 0, 150, 10, _BackgroundSliderColors.R, _BackgroundSliderColors.G, _BackgroundSliderColors.B, _BackgroundSliderColors.A),
        Slider = UIResRectangle.New(0, 0, 75, 10, _SliderColors.R, _SliderColors.G, _SliderColors.B, _SliderColors.A),
        Divider = UIResRectangle.New(0, 0, 4, 20, 255, 255, 255, 255),
        _Index = tonumber(Index) or 1,
        OnSliderChanged = function(menu, item, newindex)
        end,
        OnSliderSelected = function(menu, item, newindex)
        end,
    }

    local Offset = ((_UIMenuSliderProgressItem.Background.Width) / (#_UIMenuSliderProgressItem.Items - 1)) * (_UIMenuSliderProgressItem._Index - 1)
    _UIMenuSliderProgressItem.Slider.Width = Offset

    return setmetatable(_UIMenuSliderProgressItem, UIMenuSliderProgressItem)
end

---SetParentMenu
---@param Menu table
---@return table
---@public
function UIMenuSliderProgressItem:SetParentMenu(Menu)
    if Menu() == "UIMenu" then
        self.Base.ParentMenu = Menu
    else
        return self.Base.ParentMenu
    end
end

---Position
---@param Y number
---@return table
---@public
function UIMenuSliderProgressItem:Position(Y)
    if tonumber(Y) then
        self.Background:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
        self.Slider:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
        self.Divider:Position(323.5 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 153 + self.Base._Offset.Y)
        self.LeftArrow:Position(225 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 150.5 + Y + self.Base._Offset.Y)
        self.RightArrow:Position(400 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 150.5 + Y + self.Base._Offset.Y)
        self.Base:Position(Y)
    end
end

---Selected
---@param bool table
---@return table
---@public
function UIMenuSliderProgressItem:Selected(bool)
    if bool ~= nil then

        self.Base._Selected = tobool(bool)
    else
        return self.Base._Selected
    end
end

---Hovered
---@param bool boolean
---@return boolean
---@public
function UIMenuSliderProgressItem:Hovered(bool)
    if bool ~= nil then
        self.Base._Hovered = tobool(bool)
    else
        return self.Base._Hovered
    end
end

---Enabled
---@param bool number
---@return boolean
---@public
function UIMenuSliderProgressItem:Enabled(bool)
    if bool ~= nil then
        self.Base._Enabled = tobool(bool)
    else
        return self.Base._Enabled
    end
end

---Description
---@param str string
---@return string
---@public
function UIMenuSliderProgressItem:Description(str)
    if tostring(str) and str ~= nil then
        self.Base._Description = tostring(str)
    else
        return self.Base._Description
    end
end

---Offset
---@param X number
---@param Y number
---@return table
---@public
function UIMenuSliderProgressItem:Offset(X, Y)
    if tonumber(X) or tonumber(Y) then
        if tonumber(X) then
            self.Base._Offset.X = tonumber(X)
        end
        if tonumber(Y) then
            self.Base._Offset.Y = tonumber(Y)
        end
    else
        return self.Base._Offset
    end
end

---Text
---@param Text string
---@return string
---@public
function UIMenuSliderProgressItem:Text(Text)
    if tostring(Text) and Text ~= nil then
        self.Base.Text:Text(tostring(Text))
    else
        return self.Base.Text:Text()
    end
end

---Index
---@param Index number
---@return number
---@public
function UIMenuSliderProgressItem:Index(Index)
    if tonumber(Index) then
        if tonumber(Index) > #self.Items then
            self._Index = #self.Items
        elseif tonumber(Index) < 1 then
            self._Index = 1
        else
            self._Index = tonumber(Index)
        end
    else
        local Offset = ((self.Background.Width) / (#self.Items - 1)) * (self._Index - 1)
        self.Slider.Width = Offset
        return self._Index
    end
end

---ItemToIndex
---@param Item number
---@return number
---@public
function UIMenuSliderProgressItem:ItemToIndex(Item)
    for i = 1, #self.Items do
        if type(Item) == type(self.Items[i]) and Item == self.Items[i] then
            return i
        end
    end
end

---IndexToItem
---@param Index number
---@return number
---@public
function UIMenuSliderProgressItem:IndexToItem(Index)
    if tonumber(Index) then
        if tonumber(Index) == 0 then
            Index = 1
        end
        if self.Items[tonumber(Index)] then
            return self.Items[tonumber(Index)]
        end
    end
end

---SetLeftBadge
---@return nil
---@public
function UIMenuSliderProgressItem:SetLeftBadge()
    error("This item does not support badges")
end

---SetRightBadge
---@return nil
---@public
function UIMenuSliderProgressItem:SetRightBadge()
    error("This item does not support badges")
end

---RightLabel
---@return nil
---@public
function UIMenuSliderProgressItem:RightLabel()
    error("This item does not support a right label")
end

---Draw
---@return nil
---@public
function UIMenuSliderProgressItem:Draw()
    self.Base:Draw()

    if self:Enabled() then
        if self:Selected() then
            self.LeftArrow:Colour(0, 0, 0, 255)
            self.RightArrow:Colour(0, 0, 0, 255)
        else
            self.LeftArrow:Colour(245, 245, 245, 255)
            self.RightArrow:Colour(245, 245, 245, 255)
        end
    else
        self.LeftArrow:Colour(163, 159, 148, 255)
        self.RightArrow:Colour(163, 159, 148, 255)
    end

    if self:Selected() then
        self.LeftArrow:Draw()
        self.RightArrow:Draw()
    end

    self.Background:Draw()
    self.Slider:Draw()
end

---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Dylan Malandain.
--- DateTime: 10/02/2019 17:07
---
UIMenuSeparatorItem = setmetatable({}, UIMenuSeparatorItem)
UIMenuSeparatorItem.__index = UIMenuSeparatorItem
UIMenuSeparatorItem.__call = function()
    return "UIMenuItem", "UIMenuSeparatorItem"
end

function UIMenuSeparatorItem.New()
    local _UIMenuSeparatorItem = {
        Base = UIMenuItem.New(Text or "N/A", Description or ""),

    }

    _UIMenuSeparatorItem.Base.Label.Text.Alignment = "Center"
    return setmetatable(_UIMenuSeparatorItem, UIMenuSeparatorItem)
end

---SetParentMenu
---@param Menu table
function UIMenuSeparatorItem:SetParentMenu(Menu)
    if Menu() == "UIMenu" then
        self.Base.ParentMenu = Menu
    else
        return self.Base.ParentMenu
    end
end

---Position
---@param Y number
function UIMenuSeparatorItem:Position(Y)
    if tonumber(Y) then
        self.Base:Position(Y)
    end
end

---Selected
---@param bool number
function UIMenuSeparatorItem:Selected(bool)
    if bool ~= nil then
        self.Base._Selected = tobool(bool)
    else
        return self.Base._Selected
    end
end

---Hovered
---@param bool boolean
function UIMenuSeparatorItem:Hovered(bool)
    if bool ~= nil then
        self.Base._Hovered = tobool(bool)
    else
        return self.Base._Hovered
    end
end

---Enabled
---@param bool boolean
function UIMenuSeparatorItem:Enabled(bool)
    if bool ~= nil then
        self.Base._Enabled = tobool(bool)
    else
        return self.Base._Enabled
    end
end

---Description
---@param str string
function UIMenuSeparatorItem:Description(str)
    if tostring(str) and str ~= nil then
        self.Base._Description = tostring(str)
    else
        return self.Base._Description
    end
end

---Offset
---@param X number
---@param Y number
function UIMenuSeparatorItem:Offset(X, Y)
    if tonumber(X) or tonumber(Y) then
        if tonumber(X) then
            self.Base._Offset.X = tonumber(X)
        end
        if tonumber(Y) then
            self.Base._Offset.Y = tonumber(Y)
        end
    else
        return self.Base._Offset
    end
end

---Text
---@param Text string
function UIMenuSeparatorItem:Text(Text)
    if tostring(Text) and Text ~= nil then
        self.Base.Text:Text(tostring(Text))
    else
        return self.Base.Text:Text()
    end
end

function UIMenuSeparatorItem:Draw()
    self.Base:Draw()

    if self.Base._Selected then
    else
    end

end

---@type table
UIMenuStatisticsPanel = setmetatable({}, UIMenuStatisticsPanel)

---@type table
UIMenuStatisticsPanel.__index = UIMenuStatisticsPanel

---@type table
---@return string
UIMenuStatisticsPanel.__call = function()
    return "UIMenuPanel", "UIMenuStatisticsPanel"
end

---New
---@return table
---@public
function UIMenuStatisticsPanel.New()
    local _UIMenuStatisticsPanel = {
        Background = UIResRectangle.New(0, 0, 431, 47, 0, 0, 0, 170),
        Divider = true,
        ParentItem = nil,
        Items = {},
    }
    return setmetatable(_UIMenuStatisticsPanel, UIMenuStatisticsPanel)
end

---AddStatistics
---@param Name string
---@return nil
---@public
function UIMenuStatisticsPanel:AddStatistics(Name)
    local Items = {
        Text = UIResText.New(Name or "", 0, 0, 0.35, 255, 255, 255, 255, 0, "Left"),
        BackgroundProgressBar = UIResRectangle.New(0, 0, 200, 10, 255, 255, 255, 100),
        ProgressBar = UIResRectangle.New(0, 0, 100, 10, 255, 255, 255, 255),
        Divider = {
            [1] = UIResRectangle.New(0, 0, 2, 10, 0, 0, 0, 255),
            [2] = UIResRectangle.New(0, 0, 2, 10, 0, 0, 0, 255),
            [3] = UIResRectangle.New(0, 0, 2, 10, 0, 0, 0, 255),
            [4] = UIResRectangle.New(0, 0, 2, 10, 0, 0, 0, 255),
            [5] = UIResRectangle.New(0, 0, 2, 10, 0, 0, 0, 255),
        },
    }
    table.insert(self.Items, Items)
end

---SetParentItem
---@param Item number
---@return table
---@public
function UIMenuStatisticsPanel:SetParentItem(Item)
    if Item() == "UIMenuItem" then
        self.ParentItem = Item
    else
        return self.ParentItem
    end
end

---SetPercentage
---@param ItemID number
---@param Number number
---@return nil
---@public
function UIMenuStatisticsPanel:SetPercentage(ItemID, Number)
    if ItemID ~= nil then
        if Number <= 0 then
            self.Items[ItemID].ProgressBar.Width = 0
        else
            if Number <= 100 then
                self.Items[ItemID].ProgressBar.Width = Number * 2.0
            else
                self.Items[ItemID].ProgressBar.Width = 100 * 2.0
            end
        end
    else
        error("Missing arguments, ItemID")
    end
end

---GetPercentage
---@param ItemID number
---@return number
---@public
function UIMenuStatisticsPanel:GetPercentage(ItemID)
    if ItemID ~= nil then
        return self.Items[ItemID].ProgressBar.Width * 2.0
    else
        error("Missing arguments, ItemID")
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuStatisticsPanel:Position(Y)
    if tonumber(Y) then
        local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
        self.Background:Position(ParentOffsetX, Y)
        for i = 1, #self.Items do
            local OffsetItemCount = 40 * i
            self.Items[i].Text:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 13, Y - 34 + OffsetItemCount)
            self.Items[i].BackgroundProgressBar:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 200, Y - 22 + OffsetItemCount)
            self.Items[i].ProgressBar:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 200, Y - 22 + OffsetItemCount)
            if self.Divider ~= false then
                for _ = 1, #self.Items[i].Divider, 1 do
                    local DividerOffsetWidth = _ * 40
                    self.Items[i].Divider[_]:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 200 + DividerOffsetWidth, Y - 22 + OffsetItemCount)
                    self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 47 + OffsetItemCount - 39)
                end
            end
        end
    end
end

---Draw
---@return nil
---@public
function UIMenuStatisticsPanel:Draw()
    self.Background:Draw()
    for i = 1, #self.Items do
        self.Items[i].Text:Draw()
        self.Items[i].BackgroundProgressBar:Draw()
        self.Items[i].ProgressBar:Draw()
        for _ = 1, #self.Items[i].Divider do
            self.Items[i].Divider[_]:Draw()
        end
    end
end

---@type table
UIMenuHeritageWindow = setmetatable({}, UIMenuHeritageWindow)

---@type table
UIMenuHeritageWindow.__index = UIMenuHeritageWindow

---@type table
---@return string
UIMenuHeritageWindow.__call = function()
    return "UIMenuWindow", "UIMenuHeritageWindow"
end

---New
---@param Mum number
---@param Dad number
---@return table
---@public
function UIMenuHeritageWindow.New(Mum, Dad)
    if not tonumber(Mum) then
        Mum = 0
    end
    if not (Mum >= 0 and Mum <= 21) then
        Mum = 0
    end
    if not tonumber(Dad) then
        Dad = 0
    end
    if not (Dad >= 0 and Dad <= 23) then
        Dad = 0
    end
    local _UIMenuHeritageWindow = {
        Background = Sprite.New("pause_menu_pages_char_mom_dad", "mumdadbg", 0, 0, 431, 228), -- Background is required, must be a sprite or a rectangle.
        MumSprite = Sprite.New("char_creator_portraits", ((Mum < 21) and "female_" .. Mum or "special_female_" .. (tonumber(string.sub(Mum, 2, 2)) - 1)), 0, 0, 228, 228),
        DadSprite = Sprite.New("char_creator_portraits", ((Dad < 21) and "male_" .. Dad or "special_male_" .. (tonumber(string.sub(Dad, 2, 2)) - 1)), 0, 0, 228, 228),
        Mum = Mum,
        Dad = Dad,
        _Offset = { X = 0, Y = 0 },
        ParentMenu = nil,
    }
    return setmetatable(_UIMenuHeritageWindow, UIMenuHeritageWindow)
end

---SetParentMenu
---@param Menu table
---@return table
---@public
function UIMenuHeritageWindow:SetParentMenu(Menu)
    -- required
    if Menu() == "UIMenu" then
        self.ParentMenu = Menu
    else
        return self.ParentMenu
    end
end

---Offset
---@param X number
---@param Y number
---@return table
---@public
function UIMenuHeritageWindow:Offset(X, Y)
    if tonumber(X) or tonumber(Y) then
        if tonumber(X) then
            self._Offset.X = tonumber(X)
        end
        if tonumber(Y) then
            self._Offset.Y = tonumber(Y)
        end
    else
        return self._Offset
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuHeritageWindow:Position(Y)
    if tonumber(Y) then
        self.Background:Position(self._Offset.X, 144 + Y + self._Offset.Y)
        self.MumSprite:Position(self._Offset.X + (self.ParentMenu.WidthOffset / 2) + 25, 144 + Y + self._Offset.Y)
        self.DadSprite:Position(self._Offset.X + (self.ParentMenu.WidthOffset / 2) + 195, 144 + Y + self._Offset.Y)
    end
end

---@param Dad number
---@return nil
---@public
function UIMenuHeritageWindow:Index(Mum, Dad)
    if not tonumber(Mum) then
        Mum = self.Mum
    end
    if not (Mum >= 0 and Mum <= 21) then
        Mum = self.Mum
    end
    if not tonumber(Dad) then
        Dad = self.Dad
    end
    if not (Dad >= 0 and Dad <= 23) then
        Dad = self.Dad
    end
    self.Mum = Mum
    self.Dad = Dad
    self.MumSprite.TxtName = ((self.Mum < 21) and "female_" .. self.Mum or "special_female_" .. (tonumber(string.sub(Mum, 2, 2)) - 1))
    self.DadSprite.TxtName = ((self.Dad < 21) and "male_" .. self.Dad or "special_male_" .. (tonumber(string.sub(Dad, 2, 2)) - 1))
end

---Draw
---@return nil
---@public
function UIMenuHeritageWindow:Draw()
    self.Background:Size(431 + self.ParentMenu.WidthOffset, 228)
    self.Background:Draw()
    self.DadSprite:Draw()
    self.MumSprite:Draw()
end

---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Dylan Malandain.
--- DateTime: 26/01/2019 17:36
---
UITimerBarPool = setmetatable({}, UITimerBarPool)
UITimerBarPool.__index = UITimerBarPool

---New
---@return table
---@public
function UITimerBarPool.New()
    local _UITimerBarPool = {
        TimerBars = {},
    }
    return setmetatable(_UITimerBarPool, UITimerBarPool)
end

---Add
---@param TimerBar table
---@return table
---@public
function UITimerBarPool:Add(TimerBar)
    if TimerBar() == "UITimerBarProgressItem" or "UITimerBarItem" then
        table.insert(self.TimerBars, TimerBar)
        return #self.TimerBars
    end
end

---Remove
---@param id number
---@return number
---@public
function UITimerBarPool:Remove(id)
    table.remove(self.TimerBars, id)
    return self.TimerBars
end

---Draw
---@return nil
---@public
function UITimerBarPool:Draw()
    for _, TimerBar in pairs(self.TimerBars) do
        TimerBar:Draw(38 * _)
    end
    if (#self.TimerBars > 0) then
        for i = 6, 9, 1 do
            HideHudComponentThisFrame(i)
        end
    end
end


---@type table
UITimerBarItem = setmetatable({}, UITimerBarItem)

---@type table
UITimerBarItem.__index = UITimerBarItem

---@type table
UITimerBarItem.__call = function()
    return "UITimerBarItem"
end

---New
---@param Text string
---@param TxtDictionary string
---@param TxtName string
---@param X number
---@param Y number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function UITimerBarItem.New(Text, TxtDictionary, TxtName, X, Y, Heading, R, G, B, A)
    local X, Y = tonumber(X) or 0, tonumber(Y) or 0
    if TxtDictionary ~= nil then
        TxtDictionary = tostring(TxtDictionary) or "timerbars"
    else
        TxtDictionary = "timerbars"
    end
    if TxtName ~= nil then
        TxtName = tostring(TxtName) or "all_black_bg"
    else
        TxtName = "all_black_bg"
    end
    if Heading ~= nil then
        Heading = tonumber(Heading) or 0
    else
        Heading = 0
    end
    if R ~= nil then
        R = tonumber(R) or 255
    else
        R = 255
    end
    if G ~= nil then
        G = tonumber(G) or 255
    else
        G = 255
    end
    if B ~= nil then
        B = tonumber(B) or 255
    else
        B = 255
    end
    if A ~= nil then
        A = tonumber(A) or 200
    else
        A = 200
    end
    local _UITimerBarItem = {
        Background = Sprite.New(TxtDictionary, TxtName, 0, 0, 350, 35, Heading, R, G, B, A),
        Text = UIResText.New(Text or "N/A", 0, 0, 0.35, 255, 255, 255, 255, 0, "Right"),
        TextTimerBar = UIResText.New("N/A", 0, 0, 0.45, 255, 255, 255, 255, 0, "Right"),
        Position = { X = 1540, Y = 1060 },
    }
    return setmetatable(_UITimerBarItem, UITimerBarItem)
end

---SetTextTimerBar
---@param Text string
---@return nil
---@public
function UITimerBarItem:SetTextTimerBar(Text)
    self.TextTimerBar:Text(Text)
end

---SetText
---@param Text string
---@return nil
---@public
function UITimerBarItem:SetText(Text)
    self.Text:Text(Text)
end

---SetTextTimerBarColor
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
---@public
function UITimerBarItem:SetTextTimerBarColor(R, G, B, A)
    self.TextTimerBar:Colour(R, G, B, A)
end

---SetTextColor
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
---@public
function UITimerBarItem:SetTextColor(R, G, B, A)
    self.Text:Colour(R, G, B, A)
end

---Draw
---@param Interval number
---@return nil
---@public
function UITimerBarItem:Draw(Interval)
    self.Background:Position(self.Position.X, self.Position.Y - Interval)
    self.Text:Position(self.Position.X + 170.0, self.Position.Y - Interval + 7.0)
    self.TextTimerBar:Position(self.Position.X + 340.0, self.Position.Y - Interval)
    self.Background:Draw()
    self.TextTimerBar:Draw()
    self.Text:Draw()
end

---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Dylan Malandain.
--- DateTime: 27/02/2019 12:49
---

---@type table
UIProgressBarItem = setmetatable({}, UIProgressBarItem)

---@type table
UIProgressBarItem.__index = UIProgressBarItem

---@type table
UIProgressBarItem.__call = function()
    return "UIProgressBarItem"
end

---New
---@param Text string
---@param X number
---@param Y number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
function UIProgressBarItem.New(Text, X, Y, Heading, R, G, B, A)
    local X, Y = tonumber(X) or 800, tonumber(Y) or 1030
    if Heading ~= nil then
        Heading = tonumber(Heading) or 0
    else
        Heading = 0
    end
    if R ~= nil then
        R = tonumber(R) or 255
    else
        R = 255
    end
    if G ~= nil then
        G = tonumber(G) or 255
    else
        G = 255
    end
    if B ~= nil then
        B = tonumber(B) or 255
    else
        B = 255
    end
    if A ~= nil then
        A = tonumber(A) or 100
    else
        A = 100
    end

    local _UIProgressBarItem = {
        Background = UIResRectangle.New(0, 0, 350, 40, 0, 0, 0, 100),
        Text = UIResText.New(Text or "N/A", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
        ProgressBar = UIResRectangle.New(0, 0, 0, 30, R, G, B, A),
        Position = { X = X, Y = Y },
    }
    return setmetatable(_UIProgressBarItem, UIProgressBarItem)
end

---SetPercentage
---@param Number number
function UIProgressBarItem:SetPercentage(Number)
    if (Number <= 100) then
        self.ProgressBar.Width = Number * 3.4
    else
        self.ProgressBar.Width = 100 * 3.4
    end
end

function UIProgressBarItem:GetPercentage()
    return math.floor(self.ProgressBar.Width * 1 / 3.4)
end

---SetText
---@param String string
function UIProgressBarItem:SetText(String)
    self.Text:Text(String)
end

---SetTextColors
---@param R number
---@param G number
---@param B number
---@param A number
function UIProgressBarItem:SetTextColor(R, G, B, A)
    if R ~= nil then
        R = tonumber(R) or 255
    else
        R = 255
    end
    if G ~= nil then
        G = tonumber(G) or 255
    else
        G = 255
    end
    if B ~= nil then
        B = tonumber(B) or 255
    else
        B = 255
    end
    if A ~= nil then
        A = tonumber(A) or 255
    else
        A = 255
    end
    self.Text:Colour(R, G, B, A)
end

---SetBackgroundProgressColor
---@param R number
---@param G number
---@param B number
---@param A number
function UIProgressBarItem:SetBackgroundProgressColor(R, G, B, A)
    if R ~= nil then
        R = tonumber(R) or 0
    else
        R = 0
    end
    if G ~= nil then
        G = tonumber(G) or 0
    else
        G = 0
    end
    if B ~= nil then
        B = tonumber(B) or 0
    else
        B = 0
    end
    if A ~= nil then
        A = tonumber(A) or 100
    else
        A = 100
    end
    self.Background:Colour(R, G, B, A)
end

---SetProgressColor
---@param R number
---@param G number
---@param B number
---@param A number
function UIProgressBarItem:SetProgressColor(R, G, B, A)
    if R ~= nil then
        R = tonumber(R) or 32
    else
        R = 32
    end
    if G ~= nil then
        G = tonumber(G) or 120
    else
        G = 120
    end
    if B ~= nil then
        B = tonumber(B) or 32
    else
        B = 32
    end
    if A ~= nil then
        A = tonumber(A) or 150
    else
        A = 150
    end
    self.ProgressBar:Colour(R, G, B, A)
end

---Draw
function UIProgressBarItem:Draw()
    self.Background:Position(self.Position.X, self.Position.Y)
    self.Text:Position(self.Position.X + 170.0, self.Position.Y + 5)
    self.ProgressBar:Position(self.Position.X + 5.0, self.Position.Y + 5)
    self.Background:Draw()
    self.Text:Draw()
    self.ProgressBar:Draw()
end

---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Dylan Malandain.
--- DateTime: 27/02/2019 12:49
---

---@type table
UIProgressBarPool = setmetatable({}, UIProgressBarPool)

---@type table
UIProgressBarPool.__index = UIProgressBarPool

---New
---@return table
---@public
function UIProgressBarPool.New()
    local _UIProgressBarPool = {
        ProgressBar = {},
    }
    return setmetatable(_UIProgressBarPool, UIProgressBarPool)
end

---Add
---@param TimerBar table
---@return table
---@public
function UIProgressBarPool:Add(TimerBar)
    if TimerBar() == "UIProgressBarItem" then
        table.insert(self.ProgressBar, TimerBar)
        return #self.ProgressBar
    end
end

---Draw
---@return nil
---@public
function UIProgressBarPool:Draw()
    for _, ProgressBar in pairs(self.ProgressBar) do
        ProgressBar:Draw()
    end
end

print("Github download : https://github.com/iTexZoz/NativeUILua-Reloaded/releases")
print("[Feature Suggestions] and [Frequently asked question] : https://github.com/iTexZoz/NativeUILua-Reloaded/issues/9")
print("NativeUILua-Reloaded wiki : https://github.com/iTexZoz/NativeUILua-Reloaded/wiki")

---@type table
NativeUI = {}

---CreatePool
---@return table
---@public
function NativeUI.CreatePool()
    return MenuPool.New()
end

---CreateMenu
---@param Title string
---@param Subtitle string
---@param X number
---@param Y number
---@param TxtDictionary string
---@param TxtName string
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function NativeUI.CreateMenu(Title, Subtitle, X, Y, TxtDictionary, TxtName, Heading, R, G, B, A)
    return UIMenu.New(Title, Subtitle, X, Y, TxtDictionary, TxtName, Heading, R, G, B, A)
end

---CreateItem
---@param Text string
---@param Description string
---@return table
---@public
function NativeUI.CreateItem(Text, Description)
    return UIMenuItem.New(Text, Description)
end

---CreateColouredItem
---@param Text string
---@param Description string
---@param MainColour table
---@param HighlightColour table
---@return table
---@public
function NativeUI.CreateColouredItem(Text, Description, MainColour, HighlightColour)
    return UIMenuColouredItem.New(Text, Description, MainColour, HighlightColour)
end

---CreateCheckboxItem
---@param Text string
---@param Check boolean
---@param Description string
---@return table
---@public
function NativeUI.CreateCheckboxItem(Text, Check, Description, CheckboxStyle)
    return UIMenuCheckboxItem.New(Text, Check, Description, CheckboxStyle)
end

---CreateListItem
---@param Text string
---@param Items number
---@param Index table
---@param Description string
---@return table
---@public
function NativeUI.CreateListItem(Text, Items, Index, Description)
    return UIMenuListItem.New(Text, Items, Index, Description)
end

---CreateSliderItem
---@param Text string
---@param Items number
---@param Index table
---@param Description string
---@param Divider boolean
---@param SliderColors table
---@param BackgroundSliderColors table
---@return table
---@public
function NativeUI.CreateSliderItem(Text, Items, Index, Description, Divider, SliderColors, BackgroundSliderColors)
    return UIMenuSliderItem.New(Text, Items, Index, Description, Divider, SliderColors, BackgroundSliderColors)
end

---CreateSliderHeritageItem
---@param Text string
---@param Items number
---@param Index table
---@param Description string
---@param SliderColors table
---@param BackgroundSliderColors table
---@return table
---@public
function NativeUI.CreateSliderHeritageItem(Text, Items, Index, Description, SliderColors, BackgroundSliderColors)
    return UIMenuSliderHeritageItem.New(Text, Items, Index, Description, SliderColors, BackgroundSliderColors)
end

---CreateSliderProgressItem
---@param Text string
---@param Items number
---@param Index number
---@param Description string
---@param SliderColors table
---@param BackgroundSliderColors table
---@return table
---@public
function NativeUI.CreateSliderProgressItem(Text, Items, Index, Description, SliderColors, BackgroundSliderColors)
    return UIMenuSliderProgressItem.New(Text, Items, Index, Description, SliderColors, BackgroundSliderColors)
end

---CreateProgressItem
---@param Text string
---@param Items number
---@param Index table
---@param Description number
---@param Counter boolean
---@return table
---@public
function NativeUI.CreateProgressItem(Text, Items, Index, Description, Counter)
    return UIMenuProgressItem.New(Text, Items, Index, Description, Counter)
end

---CreateHeritageWindow
---@param Mum number
---@param Dad number
---@return table
---@public
function NativeUI.CreateHeritageWindow(Mum, Dad)
    return UIMenuHeritageWindow.New(Mum, Dad)
end

---CreateGridPanel
---@param TopText string
---@param LeftText string
---@param RightText string
---@param BottomText string
---@param CirclePositionX number
---@param CirclePositionY number
---@return table
---@public
function NativeUI.CreateGridPanel(TopText, LeftText, RightText, BottomText, CirclePositionX, CirclePositionY)
    return UIMenuGridPanel.New(TopText, LeftText, RightText, BottomText, CirclePositionX, CirclePositionY)
end

---CreateHorizontalGridPanel
---@param LeftText string
---@param RightText string
---@param RightText number
---@return table
---@public
function NativeUI.CreateHorizontalGridPanel(LeftText, RightText, CirclePositionX)
    return UIMenuHorizontalOneLineGridPanel.New(LeftText, RightText, CirclePositionX)
end

---CreateVerticalGridPanel
---@param TopText string
---@param BottomText string
---@param CirclePositionY number
---@return table
---@public
function NativeUI.CreateVerticalGridPanel(TopText, BottomText, CirclePositionY)
    return UIMenuVerticalOneLineGridPanel.New(TopText, BottomText, CirclePositionY)
end

---CreateColourPanel
---@param Title string
---@param Colours table
---@return table
---@public
function NativeUI.CreateColourPanel(Title, Colours)
    return UIMenuColourPanel.New(Title, Colours)
end

---CreatePercentagePanel
---@param MinText string
---@param MaxText string
---@return table
---@public
function NativeUI.CreatePercentagePanel(MinText, MaxText)
    return UIMenuPercentagePanel.New(MinText, MaxText)
end

---CreateStatisticsPanel
---@return table
---@public
function NativeUI.CreateStatisticsPanel()
    return UIMenuStatisticsPanel.New()
end

---CreateSprite
---@param TxtDictionary string
---@param TxtName string
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function NativeUI.CreateSprite(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
    return Sprite.New(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
end

---CreateRectangle
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function NativeUI.CreateRectangle(X, Y, Width, Height, R, G, B, A)
    return UIResRectangle.New(X, Y, Width, Height, R, G, B, A)
end

---CreateText
---@param Text string
---@param X number
---@param Y number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Font number
---@param Alignment number
---@param DropShadow number
---@param Outline number
---@param WordWrap number
---@return table
---@public
function NativeUI.CreateText(Text, X, Y, Scale, R, G, B, A, Font, Alignment, DropShadow, Outline, WordWrap)
    return UIResText.New(Text, X, Y, Scale, R, G, B, A, Font, Alignment, DropShadow, Outline, WordWrap)
end

---CreateTimerBarProgress
---@param Text string
---@param TxtDictionary string
---@param TxtName string
---@param X number
---@param Y number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function NativeUI.CreateTimerBarProgress(Text, TxtDictionary, TxtName, X, Y, Heading, R, G, B, A)
    return UITimerBarProgressItem.New(Text, TxtDictionary, TxtName, X, Y, Heading, R, G, B, A)
end

---CreateTimerBar
---@param Text string
---@param TxtDictionary string
---@param TxtName string
---@param X number
---@param Y number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function NativeUI.CreateTimerBar(Text, TxtDictionary, TxtName, X, Y, Heading, R, G, B, A)
    return UITimerBarItem.New(Text, TxtDictionary, TxtName, X, Y, Heading, R, G, B, A)
end

---CreateTimerBarProgressWithIcon
---@param TxtDictionary string
---@param TxtName string
---@param IconDictionary string
---@param IconName string
---@param X number
---@param Y number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
function NativeUI.CreateTimerBarProgressWithIcon(TxtDictionary, TxtName, IconDictionary, IconName, X, Y, Heading, R, G, B, A)
    return UITimerBarProgressWithIconItem.New(TxtDictionary, TxtName, IconDictionary, IconName, X, Y, Heading, R, G, B, A)
end

---TimerBarPool
---@return table
---@public
function NativeUI.TimerBarPool()
    return UITimerBarPool.New()
end

---ProgressBarPool
function NativeUI.ProgressBarPool()
    return UIProgressBarPool.New()
end

---CreateProgressBarItem
---@param Text string
---@param X number
---@param Y number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
function NativeUI.CreateProgressBarItem(Text, X, Y, Heading, R, G, B, A)
    return UIProgressBarItem.New(Text, X, Y, Heading, R, G, B, A)
end

---@type table
UITimerBarProgressItem = setmetatable({}, UITimerBarProgressItem)

---@type table
UITimerBarProgressItem.__index = UITimerBarProgressItem

---@type table
UITimerBarProgressItem.__call = function()
    return "UITimerBarProgressItem"
end

---New
---@param Text string
---@param TxtDictionary string
---@param TxtName string
---@param X number
---@param Y number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function UITimerBarProgressItem.New(Text, TxtDictionary, TxtName, X, Y, Heading, R, G, B, A)
    local X, Y = tonumber(X) or 0, tonumber(Y) or 0
    if TxtDictionary ~= nil then
        TxtDictionary = tostring(TxtDictionary) or "timerbars"
    else
        TxtDictionary = "timerbars"
    end
    if TxtName ~= nil then
        TxtName = tostring(TxtName) or "all_black_bg"
    else
        TxtName = "all_black_bg"
    end
    if Heading ~= nil then
        Heading = tonumber(Heading) or 0
    else
        Heading = 0
    end
    if R ~= nil then
        R = tonumber(R) or 255
    else
        R = 255
    end
    if G ~= nil then
        G = tonumber(G) or 255
    else
        G = 255
    end
    if B ~= nil then
        B = tonumber(B) or 255
    else
        B = 255
    end
    if A ~= nil then
        A = tonumber(A) or 200
    else
        A = 200
    end
    local _UITimerBarProgressItem = {
        Background = Sprite.New(TxtDictionary, TxtName, 0, 0, 350, 35, Heading, R, G, B, A),
        Text = UIResText.New(Text or "N/A", 0, 0, 0.35, 255, 255, 255, 255, 0, "Right"),
        BackgroundProgressBar = UIResRectangle.New(0, 0, 150, 17, 255, 0, 0, 100),
        ProgressBar = UIResRectangle.New(0, 0, 0, 17, 255, 0, 0, 255),
        Position = { X = 1540, Y = 1060 },
    }
    return setmetatable(_UITimerBarProgressItem, UITimerBarProgressItem)
end

---SetTextColor
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
---@public
function UITimerBarProgressItem:SetTextColor(R, G, B, A)
    self.Text:Colour(R, G, B, A)
end

---GetPercentage
---@return nil
---@public
function UITimerBarProgressItem:GetPercentage()
    return math.floor(self.ProgressBar.Width * 1 / 1.5)
end

---SetPercentage
---@param Number number
---@return nil
---@public
function UITimerBarProgressItem:SetPercentage(Number)
    if (Number <= 100) then
        self.ProgressBar.Width = Number * 1.5
    else
        self.ProgressBar.Width = 100 * 1.5
    end
end

---Draw
---@param Interval number
---@return nil
---@public
function UITimerBarProgressItem:Draw(Interval)
    self.Background:Position(self.Position.X, self.Position.Y - Interval)
    self.Text:Position(self.Position.X + 170.0, self.Position.Y - Interval + 7.0)
    self.BackgroundProgressBar:Position(self.Position.X + 190.0, self.Position.Y - Interval + 10.0)
    self.ProgressBar:Position(self.Position.X + 190.0, self.Position.Y - Interval + 10.0)
    self.Background:Draw()
    self.Text:Draw()
    self.BackgroundProgressBar:Draw()
    self.ProgressBar:Draw()
end

---GetResolution
---@return table
function GetResolution()
    local W, H = GetActiveScreenResolution()
    if (W / H) > 3.5 then
        W, H = GetScreenResolution()
    end
    if W < 1920 then W = 1920 end
    if H < 1080 then H = 1080 end
    return W, H
end

---FormatXWYH
---@param Value number
---@param Value2 number
---@return table
--function FormatXWYH(Value, Value2)
--    return Value / 1920, Value2 / 1080
--end
function FormatXWYH(Value, Value2)
    local W, H = GetScreenResolution()
    local AW, AH = GetResolution()
    local XW = Value/W - ((Value / W) - (Value / AW))
    local YH = Value2/H - ((Value2 / H) - (Value2 / AH))
    return XW, YH
end

-- Converts normalized position to pixel position
function ConvertToPixel(x, y)
    local AW, AH = GetResolution()
    return math.round(x * AW), math.round(y * AH)
end

---round
---@param num number
---@param numDecimalPlaces number
---@return number
function math.round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

---tobool
---@param input boolean
---@return boolean
function tobool(input)
    if input == "true" or tonumber(input) == 1 or input == true then
        return true
    else
        return false
    end
end

---split
---@param inputstr string
---@param sep string
---@return string
function string.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {};
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

---starts
---@param String string
---@param Start string
---@return string
function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

---IsMouseInBounds
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@return number
function IsMouseInBounds(X, Y, Width, Height, DrawOffset)
    local W, H = GetResolution()
    local MX, MY = math.round(GetControlNormal(0, 239) * W), math.round(GetControlNormal(0, 240) * H)
    MX, MY = FormatXWYH(MX, MY)
    X, Y = FormatXWYH(X, Y)
    if DrawOffset then
        X = X + DrawOffset.X
        Y = Y + DrawOffset.Y
    end
    Width, Height = FormatXWYH(Width, Height)
    return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end

---TableDump
---@param o table
---@return string
function TableDump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. TableDump(v) .. ','
        end
        return s .. '} '
    else
        return print(tostring(o))
    end
end

---Controller
---@return nil
function Controller()
    return not IsInputDisabled(2)
end

---RenderText
---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Alignment number
---@param DropShadow number
---@param Outline number
---@param WordWrap number
---@return nil
function RenderText(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
    Text = tostring(Text)
    X, Y = FormatXWYH(X, Y)
    SetTextFont(Font or 0)
    SetTextScale(1.0, Scale or 0)
    SetTextColour(R or 255, G or 255, B or 255, A or 255)

    if DropShadow then
        SetTextDropShadow()
    end
    if Outline then
        SetTextOutline()
    end

    if Alignment ~= nil then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            SetTextCentre(true)
        elseif Alignment == 2 or Alignment == "Right" then
            SetTextRightJustify(true)
            SetTextWrap(0, X)
        end
    end

    if tonumber(WordWrap) then
        if tonumber(WordWrap) ~= 0 then
            WordWrap, _ = FormatXWYH(WordWrap, 0)
            SetTextWrap(WordWrap, X - WordWrap)
        end
    end

    BeginTextCommandDisplayText("STRING")
    AddLongString(Text)
    EndTextCommandDisplayText(X, Y)
end

---DrawRectangle
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
function DrawRectangle(X, Y, Width, Height, R, G, B, A)
    X, Y, Width, Height = X or 0, Y or 0, Width or 0, Height or 0
    X, Y = FormatXWYH(X, Y)
    Width, Height = FormatXWYH(Width, Height)
    DrawRect(X + Width * 0.5, Y + Height * 0.5, Width, Height, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
end

---DrawTexture
---@param TxtDictionary string
---@param TxtName string
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
function DrawTexture(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
    if not HasStreamedTextureDictLoaded(tostring(TxtDictionary) or "") then
        RequestStreamedTextureDict(tostring(TxtDictionary) or "", true)
    end
    X, Y, Width, Height = X or 0, Y or 0, Width or 0, Height or 0
    X, Y = FormatXWYH(X, Y)
    Width, Height = FormatXWYH(Width, Height)
    DrawSprite(tostring(TxtDictionary) or "", tostring(TxtName) or "", X + Width * 0.5, Y + Height * 0.5, Width, Height, tonumber(Heading) or 0, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
end

function print_table(node)
    -- to make output beautiful
    local function tab(amt)
        local str = ""
        for i = 1, amt do
            str = str .. "\t"
        end
        return str
    end

    local cache, stack, output = {}, {}, {}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k, v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k, v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str, "}", output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str, "\n", output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output, output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "[" .. tostring(k) .. "]"
                else
                    key = "['" .. tostring(k) .. "']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. tab(depth) .. key .. " = " .. tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. tab(depth) .. key .. " = {\n"
                    table.insert(stack, node)
                    table.insert(stack, v)
                    cache[node] = cur_index + 1
                    break
                else
                    output_str = output_str .. tab(depth) .. key .. " = '" .. tostring(v) .. "'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth - 1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth - 1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. tab(depth - 1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output, output_str)
    output_str = table.concat(output)

    print(output_str)
end

---@type table
Colours = {
    DefaultColors = { R = 0, G = 0, B = 0, A = 0 },
    PureWhite = { R = 255, G = 255, B = 255, A = 255 },
    White = { R = 240, G = 240, B = 240, A = 255 },
    Black = { R = 0, G = 0, B = 0, A = 255 },
    Grey = { R = 155, G = 155, B = 155, A = 255 },
    GreyLight = { R = 205, G = 205, B = 205, A = 255 },
    GreyDark = { R = 77, G = 77, B = 77, A = 255 },
    Red = { R = 224, G = 50, B = 50, A = 255 },
    RedLight = { R = 240, G = 153, B = 153, A = 255 },
    RedDark = { R = 112, G = 25, B = 25, A = 255 },
    Blue = { R = 93, G = 182, B = 229, A = 255 },
    BlueLight = { R = 174, G = 219, B = 242, A = 255 },
    BlueDark = { R = 47, G = 92, B = 115, A = 255 },
    Yellow = { R = 240, G = 200, B = 80, A = 255 },
    YellowLight = { R = 254, G = 235, B = 169, A = 255 },
    YellowDark = { R = 126, G = 107, B = 41, A = 255 },
    Orange = { R = 255, G = 133, B = 85, A = 255 },
    OrangeLight = { R = 255, G = 194, B = 170, A = 255 },
    OrangeDark = { R = 127, G = 66, B = 42, A = 255 },
    Green = { R = 114, G = 204, B = 114, A = 255 },
    GreenLight = { R = 185, G = 230, B = 185, A = 255 },
    GreenDark = { R = 57, G = 102, B = 57, A = 255 },
    Purple = { R = 132, G = 102, B = 226, A = 255 },
    PurpleLight = { R = 192, G = 179, B = 239, A = 255 },
    PurpleDark = { R = 67, G = 57, B = 111, A = 255 },
    Pink = { R = 203, G = 54, B = 148, A = 255 },
    RadarHealth = { R = 53, G = 154, B = 71, A = 255 },
    RadarArmour = { R = 93, G = 182, B = 229, A = 255 },
    RadarDamage = { R = 235, G = 36, B = 39, A = 255 },
    NetPlayer1 = { R = 194, G = 80, B = 80, A = 255 },
    NetPlayer2 = { R = 156, G = 110, B = 175, A = 255 },
    NetPlayer3 = { R = 255, G = 123, B = 196, A = 255 },
    NetPlayer4 = { R = 247, G = 159, B = 123, A = 255 },
    NetPlayer5 = { R = 178, G = 144, B = 132, A = 255 },
    NetPlayer6 = { R = 141, G = 206, B = 167, A = 255 },
    NetPlayer7 = { R = 113, G = 169, B = 175, A = 255 },
    NetPlayer8 = { R = 211, G = 209, B = 231, A = 255 },
    NetPlayer9 = { R = 144, G = 127, B = 153, A = 255 },
    NetPlayer10 = { R = 106, G = 196, B = 191, A = 255 },
    NetPlayer11 = { R = 214, G = 196, B = 153, A = 255 },
    NetPlayer12 = { R = 234, G = 142, B = 80, A = 255 },
    NetPlayer13 = { R = 152, G = 203, B = 234, A = 255 },
    NetPlayer14 = { R = 178, G = 98, B = 135, A = 255 },
    NetPlayer15 = { R = 144, G = 142, B = 122, A = 255 },
    NetPlayer16 = { R = 166, G = 117, B = 94, A = 255 },
    NetPlayer17 = { R = 175, G = 168, B = 168, A = 255 },
    NetPlayer18 = { R = 232, G = 142, B = 155, A = 255 },
    NetPlayer19 = { R = 187, G = 214, B = 91, A = 255 },
    NetPlayer20 = { R = 12, G = 123, B = 86, A = 255 },
    NetPlayer21 = { R = 123, G = 196, B = 255, A = 255 },
    NetPlayer22 = { R = 171, G = 60, B = 230, A = 255 },
    NetPlayer23 = { R = 206, G = 169, B = 13, A = 255 },
    NetPlayer24 = { R = 71, G = 99, B = 173, A = 255 },
    NetPlayer25 = { R = 42, G = 166, B = 185, A = 255 },
    NetPlayer26 = { R = 186, G = 157, B = 125, A = 255 },
    NetPlayer27 = { R = 201, G = 225, B = 255, A = 255 },
    NetPlayer28 = { R = 240, G = 240, B = 150, A = 255 },
    NetPlayer29 = { R = 237, G = 140, B = 161, A = 255 },
    NetPlayer30 = { R = 249, G = 138, B = 138, A = 255 },
    NetPlayer31 = { R = 252, G = 239, B = 166, A = 255 },
    NetPlayer32 = { R = 240, G = 240, B = 240, A = 255 },
    SimpleBlipDefault = { R = 159, G = 201, B = 166, A = 255 },
    MenuBlue = { R = 140, G = 140, B = 140, A = 255 },
    MenuGreyLight = { R = 140, G = 140, B = 140, A = 255 },
    MenuBlueExtraDark = { R = 40, G = 40, B = 40, A = 255 },
    MenuYellow = { R = 240, G = 160, B = 0, A = 255 },
    MenuYellowDark = { R = 240, G = 160, B = 0, A = 255 },
    MenuGreen = { R = 240, G = 160, B = 0, A = 255 },
    MenuGrey = { R = 140, G = 140, B = 140, A = 255 },
    MenuGreyDark = { R = 60, G = 60, B = 60, A = 255 },
    MenuHighlight = { R = 30, G = 30, B = 30, A = 255 },
    MenuStandard = { R = 140, G = 140, B = 140, A = 255 },
    MenuDimmed = { R = 75, G = 75, B = 75, A = 255 },
    MenuExtraDimmed = { R = 50, G = 50, B = 50, A = 255 },
    BriefTitle = { R = 95, G = 95, B = 95, A = 255 },
    MidGreyMp = { R = 100, G = 100, B = 100, A = 255 },
    NetPlayer1Dark = { R = 93, G = 39, B = 39, A = 255 },
    NetPlayer2Dark = { R = 77, G = 55, B = 89, A = 255 },
    NetPlayer3Dark = { R = 124, G = 62, B = 99, A = 255 },
    NetPlayer4Dark = { R = 120, G = 80, B = 80, A = 255 },
    NetPlayer5Dark = { R = 87, G = 72, B = 66, A = 255 },
    NetPlayer6Dark = { R = 74, G = 103, B = 83, A = 255 },
    NetPlayer7Dark = { R = 60, G = 85, B = 88, A = 255 },
    NetPlayer8Dark = { R = 105, G = 105, B = 64, A = 255 },
    NetPlayer9Dark = { R = 72, G = 63, B = 76, A = 255 },
    NetPlayer10Dark = { R = 53, G = 98, B = 95, A = 255 },
    NetPlayer11Dark = { R = 107, G = 98, B = 76, A = 255 },
    NetPlayer12Dark = { R = 117, G = 71, B = 40, A = 255 },
    NetPlayer13Dark = { R = 76, G = 101, B = 117, A = 255 },
    NetPlayer14Dark = { R = 65, G = 35, B = 47, A = 255 },
    NetPlayer15Dark = { R = 72, G = 71, B = 61, A = 255 },
    NetPlayer16Dark = { R = 85, G = 58, B = 47, A = 255 },
    NetPlayer17Dark = { R = 87, G = 84, B = 84, A = 255 },
    NetPlayer18Dark = { R = 116, G = 71, B = 77, A = 255 },
    NetPlayer19Dark = { R = 93, G = 107, B = 45, A = 255 },
    NetPlayer20Dark = { R = 6, G = 61, B = 43, A = 255 },
    NetPlayer21Dark = { R = 61, G = 98, B = 127, A = 255 },
    NetPlayer22Dark = { R = 85, G = 30, B = 115, A = 255 },
    NetPlayer23Dark = { R = 103, G = 84, B = 6, A = 255 },
    NetPlayer24Dark = { R = 35, G = 49, B = 86, A = 255 },
    NetPlayer25Dark = { R = 21, G = 83, B = 92, A = 255 },
    NetPlayer26Dark = { R = 93, G = 98, B = 62, A = 255 },
    NetPlayer27Dark = { R = 100, G = 112, B = 127, A = 255 },
    NetPlayer28Dark = { R = 120, G = 120, B = 75, A = 255 },
    NetPlayer29Dark = { R = 152, G = 76, B = 93, A = 255 },
    NetPlayer30Dark = { R = 124, G = 69, B = 69, A = 255 },
    NetPlayer31Dark = { R = 10, G = 43, B = 50, A = 255 },
    NetPlayer32Dark = { R = 95, G = 95, B = 10, A = 255 },
    Bronze = { R = 180, G = 130, B = 97, A = 255 },
    Silver = { R = 150, G = 153, B = 161, A = 255 },
    Gold = { R = 214, G = 181, B = 99, A = 255 },
    Platinum = { R = 166, G = 221, B = 190, A = 255 },
    Gang1 = { R = 29, G = 100, B = 153, A = 255 },
    Gang2 = { R = 214, G = 116, B = 15, A = 255 },
    Gang3 = { R = 135, G = 125, B = 142, A = 255 },
    Gang4 = { R = 229, G = 119, B = 185, A = 255 },
    SameCrew = { R = 252, G = 239, B = 166, A = 255 },
    Freemode = { R = 45, G = 110, B = 185, A = 255 },
    PauseBg = { R = 0, G = 0, B = 0, A = 255 },
    Friendly = { R = 93, G = 182, B = 229, A = 255 },
    Enemy = { R = 194, G = 80, B = 80, A = 255 },
    Location = { R = 240, G = 200, B = 80, A = 255 },
    Pickup = { R = 114, G = 204, B = 114, A = 255 },
    PauseSingleplayer = { R = 114, G = 204, B = 114, A = 255 },
    FreemodeDark = { R = 22, G = 55, B = 92, A = 255 },
    InactiveMission = { R = 154, G = 154, B = 154, A = 255 },
    Damage = { R = 194, G = 80, B = 80, A = 255 },
    PinkLight = { R = 252, G = 115, B = 201, A = 255 },
    PmMitemHighlight = { R = 252, G = 177, B = 49, A = 255 },
    ScriptVariable = { R = 0, G = 0, B = 0, A = 255 },
    Yoga = { R = 109, G = 247, B = 204, A = 255 },
    Tennis = { R = 241, G = 101, B = 34, A = 255 },
    Golf = { R = 214, G = 189, B = 97, A = 255 },
    ShootingRange = { R = 112, G = 25, B = 25, A = 255 },
    FlightSchool = { R = 47, G = 92, B = 115, A = 255 },
    NorthBlue = { R = 93, G = 182, B = 229, A = 255 },
    SocialClub = { R = 234, G = 153, B = 28, A = 255 },
    PlatformBlue = { R = 11, G = 55, B = 123, A = 255 },
    PlatformGreen = { R = 146, G = 200, B = 62, A = 255 },
    PlatformGrey = { R = 234, G = 153, B = 28, A = 255 },
    FacebookBlue = { R = 66, G = 89, B = 148, A = 255 },
    IngameBg = { R = 0, G = 0, B = 0, A = 255 },
    Darts = { R = 114, G = 204, B = 114, A = 255 },
    Waypoint = { R = 164, G = 76, B = 242, A = 255 },
    Michael = { R = 101, G = 180, B = 212, A = 255 },
    Franklin = { R = 171, G = 237, B = 171, A = 255 },
    Trevor = { R = 255, G = 163, B = 87, A = 255 },
    GolfP1 = { R = 240, G = 240, B = 240, A = 255 },
    GolfP2 = { R = 235, G = 239, B = 30, A = 255 },
    GolfP3 = { R = 255, G = 149, B = 14, A = 255 },
    GolfP4 = { R = 246, G = 60, B = 161, A = 255 },
    WaypointLight = { R = 210, G = 166, B = 249, A = 255 },
    WaypointDark = { R = 82, G = 38, B = 121, A = 255 },
    PanelLight = { R = 0, G = 0, B = 0, A = 255 },
    MichaelDark = { R = 72, G = 103, B = 116, A = 255 },
    FranklinDark = { R = 85, G = 118, B = 85, A = 255 },
    TrevorDark = { R = 127, G = 81, B = 43, A = 255 },
    ObjectiveRoute = { R = 240, G = 200, B = 80, A = 255 },
    PausemapTint = { R = 0, G = 0, B = 0, A = 255 },
    PauseDeselect = { R = 100, G = 100, B = 100, A = 255 },
    PmWeaponsPurchasable = { R = 45, G = 110, B = 185, A = 255 },
    PmWeaponsLocked = { R = 240, G = 240, B = 240, A = 255 },
    EndScreenBg = { R = 0, G = 0, B = 0, A = 255 },
    Chop = { R = 224, G = 50, B = 50, A = 255 },
    PausemapTintHalf = { R = 0, G = 0, B = 0, A = 255 },
    NorthBlueOfficial = { R = 0, G = 71, B = 133, A = 255 },
    ScriptVariable2 = { R = 0, G = 0, B = 0, A = 255 },
    H = { R = 33, G = 118, B = 37, A = 255 },
    HDark = { R = 37, G = 102, B = 40, A = 255 },
    T = { R = 234, G = 153, B = 28, A = 255 },
    TDark = { R = 225, G = 140, B = 8, A = 255 },
    HShard = { R = 20, G = 40, B = 0, A = 255 },
    ControllerMichael = { R = 48, G = 255, B = 255, A = 255 },
    ControllerFranklin = { R = 48, G = 255, B = 0, A = 255 },
    ControllerTrevor = { R = 176, G = 80, B = 0, A = 255 },
    ControllerChop = { R = 127, G = 0, B = 0, A = 255 },
    VideoEditorVideo = { R = 53, G = 166, B = 224, A = 255 },
    VideoEditorAudio = { R = 162, G = 79, B = 157, A = 255 },
    VideoEditorText = { R = 104, G = 192, B = 141, A = 255 },
    HbBlue = { R = 29, G = 100, B = 153, A = 255 },
    HbYellow = { R = 234, G = 153, B = 28, A = 255 },
    VideoEditorScore = { R = 240, G = 160, B = 1, A = 255 },
    VideoEditorAudioFadeout = { R = 59, G = 34, B = 57, A = 255 },
    VideoEditorTextFadeout = { R = 41, G = 68, B = 53, A = 255 },
    VideoEditorScoreFadeout = { R = 82, G = 58, B = 10, A = 255 },
    HeistBackground = { R = 37, G = 102, B = 40, A = 255 },
    VideoEditorAmbient = { R = 240, G = 200, B = 80, A = 255 },
    VideoEditorAmbientFadeout = { R = 80, G = 70, B = 34, A = 255 },
    Gb = { R = 255, G = 133, B = 85, A = 255 },
    G = { R = 255, G = 194, B = 170, A = 255 },
    B = { R = 255, G = 133, B = 85, A = 255 },
    LowFlow = { R = 240, G = 200, B = 80, A = 255 },
    LowFlowDark = { R = 126, G = 107, B = 41, A = 255 },
    G1 = { R = 247, G = 159, B = 123, A = 255 },
    G2 = { R = 226, G = 134, B = 187, A = 255 },
    G3 = { R = 239, G = 238, B = 151, A = 255 },
    G4 = { R = 113, G = 169, B = 175, A = 255 },
    G5 = { R = 160, G = 140, B = 193, A = 255 },
    G6 = { R = 141, G = 206, B = 167, A = 255 },
    G7 = { R = 181, G = 214, B = 234, A = 255 },
    G8 = { R = 178, G = 144, B = 132, A = 255 },
    G9 = { R = 0, G = 132, B = 114, A = 255 },
    G10 = { R = 216, G = 85, B = 117, A = 255 },
    G11 = { R = 30, G = 100, B = 152, A = 255 },
    G12 = { R = 43, G = 181, B = 117, A = 255 },
    G13 = { R = 233, G = 141, B = 79, A = 255 },
    G14 = { R = 137, G = 210, B = 215, A = 255 },
    G15 = { R = 134, G = 125, B = 141, A = 255 },
    Adversary = { R = 109, G = 34, B = 33, A = 255 },
    DegenRed = { R = 255, G = 0, B = 0, A = 255 },
    DegenYellow = { R = 255, G = 255, B = 0, A = 255 },
    DegenGreen = { R = 0, G = 255, B = 0, A = 255 },
    DegenCyan = { R = 0, G = 255, B = 255, A = 255 },
    DegenBlue = { R = 0, G = 0, B = 255, A = 255 },
    DegenMagenta = { R = 255, G = 0, B = 255, A = 255 },
    Stunt1 = { R = 38, G = 136, B = 234, A = 255 },
    Stunt2 = { R = 224, G = 50, B = 50, A = 255 },
}

---@type table
UITimerBarProgressWithIconItem = setmetatable({}, UITimerBarProgressWithIconItem)

---@type table
UITimerBarProgressWithIconItem.__index = UITimerBarProgressWithIconItem

---@type table
UITimerBarProgressWithIconItem.__call = function()
    return "UITimerBarProgressWithIconItem"
end

---New
---@param Text string
---@param TxtDictionary string
---@param TxtName string
---@param IconDictionary string
---@param IconName string
---@param X number
---@param Y number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
function UITimerBarProgressWithIconItem.New(TxtDictionary, TxtName, IconDictionary, IconName, X, Y, Heading, R, G, B, A)
    local X, Y = tonumber(X) or 0, tonumber(Y) or 0
    if TxtDictionary ~= nil then
        TxtDictionary = tostring(TxtDictionary) or "timerbars"
    else
        TxtDictionary = "timerbars"
    end
    if TxtName ~= nil then
        TxtName = tostring(TxtName) or "all_black_bg"
    else
        TxtName = "all_black_bg"
    end
    if IconDictionary ~= nil then
        IconDictionary = tostring(IconDictionary) or "mpinventory"
    else
        IconDictionary = "mpinventory"
    end
    if IconName ~= nil then
        IconName = tostring(IconName) or "team_deathmatch"
    else
        IconName = "team_deathmatch"
    end

    if Heading ~= nil then
        Heading = tonumber(Heading) or 0
    else
        Heading = 0
    end
    if R ~= nil then
        R = tonumber(R) or 255
    else
        R = 255
    end
    if G ~= nil then
        G = tonumber(G) or 255
    else
        G = 255
    end
    if B ~= nil then
        B = tonumber(B) or 255
    else
        B = 255
    end
    if A ~= nil then
        A = tonumber(A) or 200
    else
        A = 200
    end
    local _UITimerBarProgressWithIconItem = {
        Background = Sprite.New(TxtDictionary, TxtName, 0, 0, 350, 35, Heading, R, G, B, A),
        Icon = Sprite.New(IconDictionary, IconName, 0, 0, 30, 30, 0, 255, 255, 255, 255),
        BackgroundProgressBar = UIResRectangle.New(0, 0, 200, 17, 255, 0, 0, 100),
        ProgressBar = UIResRectangle.New(0, 0, 0, 17, 255, 0, 0, 255),
        Position = { X = 1540, Y = 1060 },
    }
    return setmetatable(_UITimerBarProgressWithIconItem, UITimerBarProgressWithIconItem)
end

---SetTextColor
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
---@public
function UITimerBarProgressWithIconItem:SetTextColor(R, G, B, A)
    self.Text:Colour(R, G, B, A)
end

---GetPercentage
---@return nil
---@public
function UITimerBarProgressWithIconItem:GetPercentage()
    return math.floor(self.ProgressBar.Width * 1 / 2)
end

---SetPercentage
---@param Number number
---@return nil
---@public
function UITimerBarProgressWithIconItem:SetPercentage(Number)
    if (Number <= 100) then
        self.ProgressBar.Width = Number * 2
    else
        self.ProgressBar.Width = 100 * 2
    end
end

---Draw
---@param Interval number
---@return nil
---@public
function UITimerBarProgressWithIconItem:Draw(Interval)
    self.Background:Position(self.Position.X, self.Position.Y - Interval)
    self.Icon:Position(self.Position.X + 80.0, self.Position.Y - Interval + 2.0)
    self.BackgroundProgressBar:Position(self.Position.X + 142.0, self.Position.Y - Interval + 10.0)
    self.ProgressBar:Position(self.Position.X + 142.0, self.Position.Y - Interval + 10.0)
    self.Background:Draw()
    self.Icon:Draw()
    self.BackgroundProgressBar:Draw()
    self.ProgressBar:Draw()
end

---@type table
UIMenuItem = setmetatable({}, UIMenuItem)

---@type table
UIMenuItem.__index = UIMenuItem

---@type table
---@return string
UIMenuItem.__call = function()
    return "UIMenuItem", "UIMenuItem"
end

---New
---@param Text string
---@param Description string
---@return table
---@public
function UIMenuItem.New(Text, Description)
    local _UIMenuItem = {
        Rectangle = UIResRectangle.New(0, 0, 431, 38, 255, 255, 255, 20),
        Text = UIResText.New(tostring(Text) or "", 8, 0, 0.33, 245, 245, 245, 255, 0),
        _Text = {
            Padding = { X = 8, },
            Colour = {
                Selected = { R = 0, G = 0, B = 0, A = 255 },
                Hovered = { R = 245, G = 245, B = 245, A = 255 },
            }
        },
        _Description = tostring(Description) or "";
        SelectedSprite = Sprite.New("commonmenu", "gradient_nav", 0, 0, 431, 38),
        LeftBadge = { Sprite = Sprite.New("commonmenu", "", 0, 0, 40, 40), Badge = 0 },
        RightBadge = { Sprite = Sprite.New("commonmenu", "", 0, 0, 40, 40), Badge = 0 },
        Label = {
            Text = UIResText.New("", 0, 0, 0.35, 245, 245, 245, 255, 0, "Right"),
            MainColour = { R = 255, G = 255, B = 255, A = 255 },
            HighlightColour = { R = 0, G = 0, B = 0, A = 255 },
        },
        _Selected = false,
        _Hovered = false,
        _Enabled = true,
        _Offset = { X = 0, Y = 0 },
        ParentMenu = nil,
        Panels = {},
        Activated = function(menu, item)
        end,
        ActivatedPanel = function(menu, item, panel, panelvalue)
        end,
    }
    return setmetatable(_UIMenuItem, UIMenuItem)
end

---SetParentMenu
---@param Menu table
---@return table
---@public
function UIMenuItem:SetParentMenu(Menu)
    if Menu ~= nil and Menu() == "UIMenu" then
        self.ParentMenu = Menu
    else
        return self.ParentMenu
    end
end

---Selected
---@param bool boolean
---@return boolean
---@public
function UIMenuItem:Selected(bool)
    if bool ~= nil then
        self._Selected = tobool(bool)
    else
        return self._Selected
    end
end

---Hovered
---@param bool boolean
---@return boolean
---@public
function UIMenuItem:Hovered(bool)
    if bool ~= nil then
        self._Hovered = tobool(bool)
    else
        return self._Hovered
    end
end

---Enabled
---@param bool boolean
---@return boolean
---@public
function UIMenuItem:Enabled(bool)
    if bool ~= nil then
        self._Enabled = tobool(bool)
    else
        return self._Enabled
    end
end

---Description
---@param str string
---@return string
---@public
function UIMenuItem:Description(str)
    if tostring(str) and str ~= nil then
        self._Description = tostring(str)
    else
        return self._Description
    end
end

---Offset
---@param X number
---@param Y number
---@return thread
---@public
function UIMenuItem:Offset(X, Y)
    if tonumber(X) or tonumber(Y) then
        if tonumber(X) then
            self._Offset.X = tonumber(X)
        end
        if tonumber(Y) then
            self._Offset.Y = tonumber(Y)
        end
    else
        return self._Offset
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuItem:Position(Y)
    if tonumber(Y) then
        self.Rectangle:Position(self._Offset.X, Y + 144 + self._Offset.Y)
        self.SelectedSprite:Position(0 + self._Offset.X, Y + 144 + self._Offset.Y)
        self.Text:Position(self._Text.Padding.X + self._Offset.X, Y + 147 + self._Offset.Y)
        self.LeftBadge.Sprite:Position(0 + self._Offset.X, Y + 142 + self._Offset.Y)
        self.RightBadge.Sprite:Position(385 + self._Offset.X, Y + 142 + self._Offset.Y)
        self.Label.Text:Position(420 + self._Offset.X, Y + 148 + self._Offset.Y)
    end
end

---RightLabel
---@param Text string
---@param MainColour table
---@param HighlightColour table
---@return table
---@public
function UIMenuItem:RightLabel(Text, MainColour, HighlightColour)
    if MainColour ~= nil then
        labelMainColour = MainColour
    else
        labelMainColour = { R = 255, G = 255, B = 255, A = 255 }
    end
    if HighlightColour ~= nil then
        labelHighlightColour = HighlightColour
    else
        labelHighlightColour = { R = 0, G = 0, B = 0, A = 255 }
    end
    if tostring(Text) and Text ~= nil then
        if type(labelMainColour) == "table" then
            self.Label.MainColour = labelMainColour
        end
        if type(labelHighlightColour) == "table" then
            self.Label.HighlightColour = labelHighlightColour
        end
        self.Label.Text:Text(tostring(Text))
    else
        self.Label.MainColour = { R = 0, G = 0, B = 0, A = 0 }
        self.Label.HighlightColour = { R = 0, G = 0, B = 0, A = 0 }
        return self.Label.Text:Text()
    end
end

---SetLeftBadge
---@param Badge number
---@return nil
---@public
function UIMenuItem:SetLeftBadge(Badge)
    if tonumber(Badge) then
        self.LeftBadge.Badge = tonumber(Badge)
    end
end

---SetRightBadge
---@param Badge number
---@return nil
---@public
function UIMenuItem:SetRightBadge(Badge)
    if tonumber(Badge) then
        self.RightBadge.Badge = tonumber(Badge)
    end
end

---Text
---@param Text string
---@return string
---@public
function UIMenuItem:Text(Text)
    if tostring(Text) and Text ~= nil then
        self.Text:Text(tostring(Text))
    else
        return self.Text:Text()
    end
end

---SetTextSelectedColor
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function UIMenuItem:SetTextSelectedColor(R, G, B, A)
    if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
        self._Text.Colour.Selected.R = R
        self._Text.Colour.Selected.G = G
        self._Text.Colour.Selected.B = B
        self._Text.Colour.Selected.A = A
    else
        return { R = self._Text.Colour.Selected.R, G = self._Text.Colour.Selected.G, B = self._Text.Colour.Selected.B, A = self._Text.Colour.Selected.A, }
    end
end

---SetTextHoveredColor
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function UIMenuItem:SetTextHoveredColor(R, G, B, A)
    if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
        self._Text.Colour.Hovered.R = R
        self._Text.Colour.Hovered.G = G
        self._Text.Colour.Hovered.B = B
        self._Text.Colour.Hovered.A = A
    else
        return { R = self._Text.Colour.Hovered.R, G = self._Text.Colour.Hovered.G, B = self._Text.Colour.Hovered.B, A = self._Text.Colour.Hovered.A, }
    end
end

---AddPanel
---@param Panel table
---@return nil
---@public
function UIMenuItem:AddPanel(Panel)
    if Panel() == "UIMenuPanel" then
        table.insert(self.Panels, Panel)
        Panel:SetParentItem(self)
    end
end

---RemovePanelAt
---@param Index table
---@return nil
---@public
function UIMenuItem:RemovePanelAt(Index)
    if tonumber(Index) then
        if self.Panels[Index] then
            table.remove(self.Panels, tonumber(Index))
        end
    end
end

---FindPanelIndex
---@param Panel table
---@return number
---@public
function UIMenuItem:FindPanelIndex(Panel)
    if Panel() == "UIMenuPanel" then
        for Index = 1, #self.Panels do
            if self.Panels[Index] == Panel then
                return Index
            end
        end
    end
    return nil
end

---FindPanelItem
---@return number
---@public
function UIMenuItem:FindPanelItem()
    for Index = #self.Items, 1, -1 do
        if self.Items[Index].Panel then
            return Index
        end
    end
    return nil
end

---Draw
---@return nil
---@public
function UIMenuItem:Draw()
    self.Rectangle:Size(431 + self.ParentMenu.WidthOffset, self.Rectangle.Height)
    self.SelectedSprite:Size(431 + self.ParentMenu.WidthOffset, self.SelectedSprite.Height)

    if self._Hovered and not self._Selected then
        self.Rectangle:Draw()
    end

    if self._Selected then
        self.SelectedSprite:Draw()
    end

    if self._Enabled then
        if self._Selected then
            self.Text:Colour(self._Text.Colour.Selected.R, self._Text.Colour.Selected.G, self._Text.Colour.Selected.B, self._Text.Colour.Selected.A)
            self.Label.Text:Colour(self.Label.HighlightColour.R, self.Label.HighlightColour.G, self.Label.HighlightColour.B, self.Label.HighlightColour.A)
        else
            self.Text:Colour(self._Text.Colour.Hovered.R, self._Text.Colour.Hovered.G, self._Text.Colour.Hovered.B, self._Text.Colour.Hovered.A)
            self.Label.Text:Colour(self.Label.MainColour.R, self.Label.MainColour.G, self.Label.MainColour.B, self.Label.MainColour.A)
        end
    else
        self.Text:Colour(163, 159, 148, 255)
        self.Label.Text:Colour(163, 159, 148, 255)
    end

    if self.LeftBadge.Badge == BadgeStyle.None then
        self.Text:Position(self._Text.Padding.X + self._Offset.X, self.Text.Y)
    else
        self.Text:Position(35 + self._Offset.X, self.Text.Y)
        self.LeftBadge.Sprite.TxtDictionary = GetBadgeDictionary(self.LeftBadge.Badge, self._Selected)
        self.LeftBadge.Sprite.TxtName = GetBadgeTexture(self.LeftBadge.Badge, self._Selected)
        self.LeftBadge.Sprite:Colour(GetBadgeColour(self.LeftBadge.Badge, self._Selected))
        self.LeftBadge.Sprite:Draw()
    end

    if self.RightBadge.Badge ~= BadgeStyle.None then
        self.RightBadge.Sprite:Position(385 + self._Offset.X + self.ParentMenu.WidthOffset, self.RightBadge.Sprite.Y)
        self.RightBadge.Sprite.TxtDictionary = GetBadgeDictionary(self.RightBadge.Badge, self._Selected)
        self.RightBadge.Sprite.TxtName = GetBadgeTexture(self.RightBadge.Badge, self._Selected)
        self.RightBadge.Sprite:Colour(GetBadgeColour(self.RightBadge.Badge, self._Selected))
        self.RightBadge.Sprite:Draw()
    end

    if self.Label.Text:Text() ~= "" and string.len(self.Label.Text:Text()) > 0 then
        if self.RightBadge.Badge ~= BadgeStyle.None then
            self.Label.Text:Position(385 + self._Offset.X + self.ParentMenu.WidthOffset, self.Label.Text.Y)
            self.Label.Text:Draw()
        else
            self.Label.Text:Position(420 + self._Offset.X + self.ParentMenu.WidthOffset, self.Label.Text.Y)
            self.Label.Text:Draw()
        end
    end

    self.Text:Draw()
end

---@type table
UIMenuColourPanel = setmetatable({}, UIMenuColourPanel)

---@type table
UIMenuColourPanel.__index = UIMenuColourPanel

---@type table
---@return string
UIMenuColourPanel.__call = function()
    return "UIMenuPanel", "UIMenuColourPanel"
end

---New
---@param Title string
---@param Colours number
---@return table
---@public
function UIMenuColourPanel.New(Title, Colours)
    local _UIMenuColourPanel = {
        Data = {
            Pagination = {
                Min = 1,
                Max = 8,
                Total = 8,
            },
            Index = 1000,
            Items = Colours,
            Title = Title or "Title",
            Enabled = true,
            Value = 1,
        },
        Background = Sprite.New("commonmenu", "gradient_bgd", 0, 0, 431, 112),
        Bar = {},
        EnableArrow = true,
        LeftArrow = Sprite.New("commonmenu", "arrowleft", 0, 0, 30, 30),
        RightArrow = Sprite.New("commonmenu", "arrowright", 0, 0, 30, 30),
        SelectedRectangle = UIResRectangle.New(0, 0, 44.5, 8),
        Text = UIResText.New(Title .. " [1 / " .. #Colours .. "]" or "Title" .. " [1 / " .. #Colours .. "]", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
        ParentItem = nil
    }

    for Index = 1, #Colours do
        if Index < 10 then
            table.insert(_UIMenuColourPanel.Bar, UIResRectangle.New(0, 0, 44.5, 44.5, table.unpack(Colours[Index])))
        else
            break
        end
    end

    if #_UIMenuColourPanel.Data.Items ~= 0 then
        _UIMenuColourPanel.Data.Index = 1000 - (1000 % #_UIMenuColourPanel.Data.Items)
        _UIMenuColourPanel.Data.Pagination.Max = _UIMenuColourPanel.Data.Pagination.Total + 1
        _UIMenuColourPanel.Data.Pagination.Min = 0
    end
    return setmetatable(_UIMenuColourPanel, UIMenuColourPanel)
end

---SetParentItem
---@param Item table
---@return table
---@public
function UIMenuColourPanel:SetParentItem(Item)
    -- required
    if Item() == "UIMenuItem" then
        self.ParentItem = Item
    else
        return self.ParentItem
    end
end

---Enabled
---@param Enabled boolean
---@return boolean
---@public
function UIMenuColourPanel:Enabled(Enabled)
    if type(Enabled) == "boolean" then
        self.Data.Enabled = Enabled
    else
        return self.Data.Enabled
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuColourPanel:Position(Y)
    if tonumber(Y) then
        local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
        self.Background:Position(ParentOffsetX, Y)
        for Index = 1, #self.Bar do
            self.Bar[Index]:Position(15 + (44.5 * (Index - 1)) + ParentOffsetX + (ParentOffsetWidth / 2), 55 + Y)
        end
        self.SelectedRectangle:Position(15 + (44.5 * ((self:CurrentSelection() - self.Data.Pagination.Min) - 1)) + ParentOffsetX + (ParentOffsetWidth / 2), 47 + Y)
        if self.EnableArrow ~= false then
            self.LeftArrow:Position(7.5 + ParentOffsetX + (ParentOffsetWidth / 2), 15 + Y)
            self.RightArrow:Position(393.5 + ParentOffsetX + (ParentOffsetWidth / 2), 15 + Y)
        end
        self.Text:Position(215.5 + ParentOffsetX + (ParentOffsetWidth / 2), 15 + Y)
    end
end

---CurrentSelection
---@param value number
---@param PreventUpdate table
---@return number
---@public
function UIMenuColourPanel:CurrentSelection(value, PreventUpdate)
    if tonumber(value) then
        if #self.Data.Items == 0 then
            self.Data.Index = 0
        end

        self.Data.Index = 1000000 - (1000000 % #self.Data.Items) + tonumber(value)

        if self:CurrentSelection() > self.Data.Pagination.Max then
            self.Data.Pagination.Min = self:CurrentSelection() - (self.Data.Pagination.Total + 1)
            self.Data.Pagination.Max = self:CurrentSelection()
        elseif self:CurrentSelection() < self.Data.Pagination.Min then
            self.Data.Pagination.Min = self:CurrentSelection() - 1
            self.Data.Pagination.Max = self:CurrentSelection() + (self.Data.Pagination.Total + 1)
        end

        self:UpdateSelection(PreventUpdate)
    else
        if #self.Data.Items == 0 then
            return 1
        else
            if self.Data.Index % #self.Data.Items == 0 then
                return 1
            else
                return self.Data.Index % #self.Data.Items + 1
            end
        end
    end
end

---UpdateParent
---@param Colour table
---@return nil
---@public
function UIMenuColourPanel:UpdateParent(Colour)
    local _, ParentType = self.ParentItem()
    if ParentType == "UIMenuListItem" then
        local PanelItemIndex = self.ParentItem:FindPanelItem()
        local PanelIndex = self.ParentItem:FindPanelIndex(self)
        if PanelItemIndex then
            self.ParentItem.Items[PanelItemIndex].Value[PanelIndex] = Colour
            self.ParentItem:Index(PanelItemIndex)
            self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
        else
            for Index = 1, #self.ParentItem.Items do
                if type(self.ParentItem.Items[Index]) == "table" then
                    if not self.ParentItem.Items[Index].Panels then
                        self.ParentItem.Items[Index].Panels = {}
                    end
                    self.ParentItem.Items[Index].Panels[PanelIndex] = Colour
                else
                    self.ParentItem.Items[Index] = { Name = tostring(self.ParentItem.Items[Index]), Value = self.ParentItem.Items[Index], Panels = { [PanelIndex] = Colour } }
                end
            end
            self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
        end
    elseif ParentType == "UIMenuItem" then
        self.ParentItem.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, Colour)
    end
end

---UpdateSelection
---@param PreventUpdate table
---@return nil
---@public
function UIMenuColourPanel:UpdateSelection(PreventUpdate)
    local CurrentSelection = self:CurrentSelection()
    if not PreventUpdate then
        self:UpdateParent(CurrentSelection)
    end
    self.SelectedRectangle:Position(15 + (44.5 * ((CurrentSelection - self.Data.Pagination.Min) - 1)) + self.ParentItem:Offset().X, self.SelectedRectangle.Y)
    for Index = 1, 9 do
        self.Bar[Index]:Colour(table.unpack(self.Data.Items[self.Data.Pagination.Min + Index]))
    end
    self.Text:Text(self.Data.Title .. " [" .. CurrentSelection .. " / " .. #self.Data.Items .. "]")
end

---Functions
---@return nil
---@public
function UIMenuColourPanel:Functions()
    local DrawOffset = { X = 0, Y = 0}
    if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
        DrawOffset = self.ParentItem:SetParentMenu().DrawOffset
    end

    --@Key Process
    if IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 174) then
        self:GoLeft()
    end
    if IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 175) then
        self:GoRight()
    end

    --@Mouse Process
    if IsMouseInBounds(self.LeftArrow.X, self.LeftArrow.Y, self.LeftArrow.Width, self.LeftArrow.Height, DrawOffset) then
        if IsDisabledControlJustPressed(0, 24) then
            self:GoLeft()
        end
    end
    if IsMouseInBounds(self.RightArrow.X, self.RightArrow.Y, self.RightArrow.Width, self.RightArrow.Height, DrawOffset) then
        if IsDisabledControlJustPressed(0, 24) then
            self:GoRight()
        end
    end

    for Index = 1, #self.Bar do
        if IsMouseInBounds(self.Bar[Index].X, self.Bar[Index].Y, self.Bar[Index].Width, self.Bar[Index].Height, DrawOffset) then
            if IsDisabledControlJustPressed(0, 24) then
                self:CurrentSelection(self.Data.Pagination.Min + Index - 1)
            end
        end
    end
end

---GoLeft
---@return nil
---@private
function UIMenuColourPanel:GoLeft()
    if #self.Data.Items > self.Data.Pagination.Total + 1 then
        if self:CurrentSelection() <= self.Data.Pagination.Min + 1 then
            if self:CurrentSelection() == 1 then
                self.Data.Pagination.Min = #self.Data.Items - (self.Data.Pagination.Total + 1)
                self.Data.Pagination.Max = #self.Data.Items
                self.Data.Index = 1000 - (1000 % #self.Data.Items)
                self.Data.Index = self.Data.Index + (#self.Data.Items - 1)
                self:UpdateSelection()
            else
                self.Data.Pagination.Min = self.Data.Pagination.Min - 1
                self.Data.Pagination.Max = self.Data.Pagination.Max - 1
                self.Data.Index = self.Data.Index - 1
                self:UpdateSelection()
            end
        else
            self.Data.Index = self.Data.Index - 1
            self:UpdateSelection()
        end
    else
        self.Data.Index = self.Data.Index - 1
        self:UpdateSelection()
    end
end

---GoRight
---@return nil
---@private
function UIMenuColourPanel:GoRight()
    if #self.Data.Items > self.Data.Pagination.Total + 1 then
        if self:CurrentSelection() >= self.Data.Pagination.Max then
            if self:CurrentSelection() == #self.Data.Items then
                self.Data.Pagination.Min = 0
                self.Data.Pagination.Max = self.Data.Pagination.Total + 1
                self.Data.Index = 1000 - (1000 % #self.Data.Items)
                self:UpdateSelection()
            else
                self.Data.Pagination.Max = self.Data.Pagination.Max + 1
                self.Data.Pagination.Min = self.Data.Pagination.Max - (self.Data.Pagination.Total + 1)
                self.Data.Index = self.Data.Index + 1
                self:UpdateSelection()
            end
        else
            self.Data.Index = self.Data.Index + 1
            self:UpdateSelection()
        end
    else
        self.Data.Index = self.Data.Index + 1
        self:UpdateSelection()
    end
end

---Draw
---@return nil
---@public
function UIMenuColourPanel:Draw()
    if self.Data.Enabled then
        self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 112)
        self.Background:Draw()
        if self.EnableArrow ~= false then
            self.LeftArrow:Draw()
            self.RightArrow:Draw()
        end
        self.Text:Draw()
        self.SelectedRectangle:Draw()
        for Index = 1, #self.Bar do
            self.Bar[Index]:Draw()
        end
        self:Functions()
    end
end

---@type table
UIMenuGridPanel = setmetatable({}, UIMenuGridPanel)

---@type table
UIMenuGridPanel.__index = UIMenuGridPanel

---@type table
---@return string
UIMenuGridPanel.__call = function()
    return "UIMenuPanel", "UIMenuGridPanel"
end

---New
---@param TopText string
---@param LeftText string
---@param RightText string
---@param BottomText string
---@return table
---@public
function UIMenuGridPanel.New(TopText, LeftText, RightText, BottomText, CirclePositionX, CirclePositionY)
    local _UIMenuGridPanel = {
        Data = {
            Enabled = true,
        },
        Background = Sprite.New("commonmenu", "gradient_bgd", 0, 0, 431, 275),
        Grid = Sprite.New("pause_menu_pages_char_mom_dad", "nose_grid", 0, 0, 200, 200, 0, 255, 255, 255, 255),
        Circle = Sprite.New("mpinventory", "in_world_circle", 0, 0, 20, 20, 0),
        Audio = { Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil },
        ParentItem = nil,
        Text = {
            Top = UIResText.New(TopText or "Top", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
            Left = UIResText.New(LeftText or "Left", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
            Right = UIResText.New(RightText or "Right", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
            Bottom = UIResText.New(BottomText or "Bottom", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
        },
        SetCirclePosition = { X = CirclePositionX or 0.5, Y = CirclePositionY or 0.5 }
    }
    return setmetatable(_UIMenuGridPanel, UIMenuGridPanel)
end

---SetParentItem
---@param Item table
---@return table
---@public
function UIMenuGridPanel:SetParentItem(Item)
    -- required
    if Item() == "UIMenuItem" then
        self.ParentItem = Item
    else
        return self.ParentItem
    end
end

---Enabled
---@param Enabled boolean
---@return boolean
---@public
function UIMenuGridPanel:Enabled(Enabled)
    if type(Enabled) == "boolean" then
        self.Data.Enabled = Enabled
    else
        return self.Data.Enabled
    end
end

---CirclePosition
---@param X number
---@param Y number
---@return table
---@public
function UIMenuGridPanel:CirclePosition(X, Y)
    if tonumber(X) and tonumber(Y) then
        self.Circle.X = (self.Grid.X + 20) + ((self.Grid.Width - 40) * ((X >= 0.0 and X <= 1.0) and X or 0.0)) - (self.Circle.Width / 2)
        self.Circle.Y = (self.Grid.Y + 20) + ((self.Grid.Height - 40) * ((Y >= 0.0 and Y <= 1.0) and Y or 0.0)) - (self.Circle.Height / 2)
    else
        return math.round((self.Circle.X - (self.Grid.X + 20) + (self.Circle.Width / 2)) / (self.Grid.Width - 40), 2), math.round((self.Circle.Y - (self.Grid.Y + 20) + (self.Circle.Height / 2)) / (self.Grid.Height - 40), 2)
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuGridPanel:Position(Y)
    if tonumber(Y) then
        local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
        self.Background:Position(ParentOffsetX, Y)
        self.Grid:Position(ParentOffsetX + 115.5 + (ParentOffsetWidth / 2), 37.5 + Y)
        self.Text.Top:Position(ParentOffsetX + 215.5 + (ParentOffsetWidth / 2), 5 + Y)
        self.Text.Left:Position(ParentOffsetX + 57.75 + (ParentOffsetWidth / 2), 120 + Y)
        self.Text.Right:Position(ParentOffsetX + 373.25 + (ParentOffsetWidth / 2), 120 + Y)
        self.Text.Bottom:Position(ParentOffsetX + 215.5 + (ParentOffsetWidth / 2), 240 + Y)
        if not self.CircleLocked then
            self.CircleLocked = true
            self:CirclePosition(self.SetCirclePosition.X, self.SetCirclePosition.Y)
        end
    end
end

---UpdateParent
---@param X number
---@param Y number
---@return nil
---@public
function UIMenuGridPanel:UpdateParent(X, Y)
    local _, ParentType = self.ParentItem()
    self.Data.Value = { X = X, Y = Y }
    if ParentType == "UIMenuListItem" then
        local PanelItemIndex = self.ParentItem:FindPanelItem()
        if PanelItemIndex then
            self.ParentItem.Items[PanelItemIndex].Value[self.ParentItem:FindPanelIndex(self)] = { X = X, Y = Y }
            self.ParentItem:Index(PanelItemIndex)
            self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
        else
            local PanelIndex = self.ParentItem:FindPanelIndex(self)
            for Index = 1, #self.ParentItem.Items do
                if type(self.ParentItem.Items[Index]) == "table" then
                    if not self.ParentItem.Items[Index].Panels then
                        self.ParentItem.Items[Index].Panels = {}
                    end
                    self.ParentItem.Items[Index].Panels[PanelIndex] = { X = X, Y = Y }
                else
                    self.ParentItem.Items[Index] = { Name = tostring(self.ParentItem.Items[Index]), Value = self.ParentItem.Items[Index], Panels = { [PanelIndex] = { X = X, Y = Y } } }
                end
            end
            self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.Base.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, { X = X, Y = Y })
        end
    elseif ParentType == "UIMenuItem" then
        self.ParentItem.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, { X = X, Y = Y })
    end
end

---Functions
---@return nil
---@public
function UIMenuGridPanel:Functions()
    local DrawOffset = { X = 0, Y = 0 }
    if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
        DrawOffset = self.ParentItem:SetParentMenu().DrawOffset
    end
    if IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) then
        if IsDisabledControlJustPressed(0, 24) then
            if not self.Pressed then
                self.Pressed = true
                Citizen.CreateThread(function()
                    self.Audio.Id = GetSoundId()
                    PlaySoundFrontend(self.Audio.Id, self.Audio.Slider, self.Audio.Library, 1)
                    while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) do
                        Citizen.Wait(0)
                        local CursorX, CursorY = ConvertToPixel(GetControlNormal(0, 239) - DrawOffset.X, GetControlNormal(0, 240) - DrawOffset.Y)
                        CursorX, CursorY = CursorX - (self.Circle.Width / 2), CursorY - (self.Circle.Height / 2)
                        self.Circle:Position(((CursorX > (self.Grid.X + 10 + self.Grid.Width - 40)) and (self.Grid.X + 10 + self.Grid.Width - 40) or ((CursorX < (self.Grid.X + 20 - (self.Circle.Width / 2))) and (self.Grid.X + 20 - (self.Circle.Width / 2)) or CursorX)), ((CursorY > (self.Grid.Y + 10 + self.Grid.Height - 40)) and (self.Grid.Y + 10 + self.Grid.Height - 40) or ((CursorY < (self.Grid.Y + 20 - (self.Circle.Height / 2))) and (self.Grid.Y + 20 - (self.Circle.Height / 2)) or CursorY)))
                    end
                    StopSound(self.Audio.Id)
                    ReleaseSoundId(self.Audio.Id)
                    self.Pressed = false
                end)
                Citizen.CreateThread(function()
                    while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) do
                        Citizen.Wait(75)
                        local ResultX, ResultY = math.round((self.Circle.X - (self.Grid.X + 20) + (self.Circle.Width / 2)) / (self.Grid.Width - 40), 2), math.round((self.Circle.Y - (self.Grid.Y + 20) + (self.Circle.Height / 2)) / (self.Grid.Height - 40), 2)

                        self:UpdateParent((((ResultX >= 0.0 and ResultX <= 1.0) and ResultX or ((ResultX <= 0) and 0.0) or 1.0) * 2) - 1, (((ResultY >= 0.0 and ResultY <= 1.0) and ResultY or ((ResultY <= 0) and 0.0) or 1.0) * 2) - 1)
                    end
                end)
            end
        end
    end
end

---Draw
---@return nil
---@public
function UIMenuGridPanel:Draw()
    if self.Data.Enabled then
        self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 275)
        self.Background:Draw()
        self.Grid:Draw()
        self.Circle:Draw()
        self.Text.Top:Draw()
        self.Text.Left:Draw()
        self.Text.Right:Draw()
        self.Text.Bottom:Draw()
        self:Functions()
    end
end

---@type table
UIMenuHorizontalOneLineGridPanel = setmetatable({}, UIMenuHorizontalOneLineGridPanel)

---@type table
UIMenuHorizontalOneLineGridPanel.__index = UIMenuHorizontalOneLineGridPanel

---@type table
---@return string
UIMenuHorizontalOneLineGridPanel.__call = function()
    return "UIMenuPanel", "UIMenuHorizontalOneLineGridPanel"
end

---New
---@param LeftText string
---@param RightText string
---@return table
---@public
function UIMenuHorizontalOneLineGridPanel.New(LeftText, RightText, CirclePositionX)
    local _UIMenuHorizontalOneLineGridPanel = {
        Data = {
            Enabled = true,
        },
        Background = Sprite.New("commonmenu", "gradient_bgd", 0, 0, 431, 275),
        Grid = Sprite.New("NativeUI", "horizontal_grid", 0, 0, 200, 200, 0, 255, 255, 255, 255),
        Circle = Sprite.New("mpinventory", "in_world_circle", 0, 0, 20, 20, 0),
        Audio = { Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil },
        ParentItem = nil,
        Text = {
            Left = UIResText.New(LeftText or "Left", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
            Right = UIResText.New(RightText or "Right", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
        },
        SetCirclePosition = { X = CirclePositionX or 0.5, Y = 0.5 }
    }
    return setmetatable(_UIMenuHorizontalOneLineGridPanel, UIMenuHorizontalOneLineGridPanel)
end

---SetParentItem
---@param Item table
---@return table
---@public
function UIMenuHorizontalOneLineGridPanel:SetParentItem(Item)
    -- required
    if Item() == "UIMenuItem" then
        self.ParentItem = Item
    else
        return self.ParentItem
    end
end

---Enabled
---@param Enabled boolean
---@return boolean
---@public
function UIMenuHorizontalOneLineGridPanel:Enabled(Enabled)
    if type(Enabled) == "boolean" then
        self.Data.Enabled = Enabled
    else
        return self.Data.Enabled
    end
end

---CirclePosition
---@param X number
---@param Y number
---@return table
---@public
function UIMenuHorizontalOneLineGridPanel:CirclePosition(X, Y)
    if tonumber(X) and tonumber(Y) then
        self.Circle.X = (self.Grid.X + 20) + ((self.Grid.Width - 40) * ((X >= 0.0 and X <= 1.0) and X or 0.0)) - (self.Circle.Width / 2)
        self.Circle.Y = (self.Grid.Y + 20) + ((self.Grid.Height - 40) * ((Y >= 0.0 and Y <= 1.0) and Y or 0.0)) - (self.Circle.Height / 2)
    else
        return math.round((self.Circle.X - (self.Grid.X + 20) + (self.Circle.Width / 2)) / (self.Grid.Width - 40), 2), math.round((self.Circle.Y - (self.Grid.Y + 10) + (self.Circle.Height / 2)) / (self.Grid.Height - 40), 2)
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuHorizontalOneLineGridPanel:Position(Y)
    if tonumber(Y) then
        local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
        self.Background:Position(ParentOffsetX, Y)
        self.Grid:Position(ParentOffsetX + 115.5 + (ParentOffsetWidth / 2), 37.5 + Y)
        self.Text.Left:Position(ParentOffsetX + 57.75 + (ParentOffsetWidth / 2), 120 + Y)
        self.Text.Right:Position(ParentOffsetX + 373.25 + (ParentOffsetWidth / 2), 120 + Y)
        if not self.CircleLocked then
            self.CircleLocked = true
            self:CirclePosition(self.SetCirclePosition.X, self.SetCirclePosition.Y)
        end
    end
end

---UpdateParent
---@param X number
---@return nil
---@public
function UIMenuHorizontalOneLineGridPanel:UpdateParent(X)
    local _, ParentType = self.ParentItem()
    self.Data.Value = { X = X }
    if ParentType == "UIMenuListItem" then
        local PanelItemIndex = self.ParentItem:FindPanelItem()
        if PanelItemIndex then
            self.ParentItem.Items[PanelItemIndex].Value[self.ParentItem:FindPanelIndex(self)] = { X = X }
            self.ParentItem:Index(PanelItemIndex)
            self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
        else
            local PanelIndex = self.ParentItem:FindPanelIndex(self)
            for Index = 1, #self.ParentItem.Items do
                if type(self.ParentItem.Items[Index]) == "table" then
                    if not self.ParentItem.Items[Index].Panels then
                        self.ParentItem.Items[Index].Panels = {}
                    end
                    self.ParentItem.Items[Index].Panels[PanelIndex] = { X = X }
                else
                    self.ParentItem.Items[Index] = { Name = tostring(self.ParentItem.Items[Index]), Value = self.ParentItem.Items[Index], Panels = { [PanelIndex] = { X = X } } }
                end
            end
            self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.Base.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, { X = X })
        end
    elseif ParentType == "UIMenuItem" then
        self.ParentItem.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, { X = X })
    end
end

---Functions
---@return nil
---@public
function UIMenuHorizontalOneLineGridPanel:Functions()
    local DrawOffset = { X = 0, Y = 0}
    if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
        DrawOffset = self.ParentItem:SetParentMenu().DrawOffset
    end
    if IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) then
        if IsDisabledControlJustPressed(0, 24) then
            if not self.Pressed then
                self.Pressed = true
                Citizen.CreateThread(function()
                    self.Audio.Id = GetSoundId()
                    PlaySoundFrontend(self.Audio.Id, self.Audio.Slider, self.Audio.Library, 1)
                    while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 10, self.Grid.Height - 10, DrawOffset) do
                        Citizen.Wait(0)
                        local CursorX, CursorY = ConvertToPixel(GetControlNormal(0, 239) - DrawOffset.X, GetControlNormal(0, 240) - DrawOffset.Y)
                        CursorX, CursorY = CursorX - (self.Circle.Width / 2), CursorY - (self.Circle.Height / 2)
                        local moveCursorX = (CursorX > (self.Grid.X + 10 + self.Grid.Width - 40)) and (self.Grid.X + 10 + self.Grid.Width - 40) or ((CursorX < (self.Grid.X + 20 - (self.Circle.Width / 2))) and (self.Grid.X + 20 - (self.Circle.Width / 2)) or CursorX)
                        local moveCursorY = (CursorY > (self.Grid.Y + 10 + self.Grid.Height - 120)) and (self.Grid.Y + 10 + self.Grid.Height - 120) or ((CursorY < (self.Grid.Y + 100 - (self.Circle.Height / 2))) and (self.Grid.Y + 100 - (self.Circle.Height / 2)) or CursorY)
                        self.Circle:Position(moveCursorX, moveCursorY)
                    end
                    StopSound(self.Audio.Id)
                    ReleaseSoundId(self.Audio.Id)
                    self.Pressed = false
                end)
                Citizen.CreateThread(function()
                    while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) do
                        Citizen.Wait(75)
                        local ResultX = math.round((self.Circle.X - (self.Grid.X + 20) + (self.Circle.Width / 2)) / (self.Grid.Width - 40), 2)
                        self:UpdateParent((((ResultX >= 0.0 and ResultX <= 1.0) and ResultX or ((ResultX <= 0) and 0.0) or 1.0) * 2) - 1)
                    end
                end)
            end
        end
    end
end

---Draw
---@return nil
---@public
function UIMenuHorizontalOneLineGridPanel:Draw()
    if self.Data.Enabled then
        self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 275)
        self.Background:Draw()
        self.Grid:Draw()
        self.Circle:Draw()
        self.Text.Left:Draw()
        self.Text.Right:Draw()
        self:Functions()
    end
end

---@type table
UIMenuVerticalOneLineGridPanel = setmetatable({}, UIMenuVerticalOneLineGridPanel)

---@type table
UIMenuVerticalOneLineGridPanel.__index = UIMenuVerticalOneLineGridPanel

---@type table
---@return string
UIMenuVerticalOneLineGridPanel.__call = function()
    return "UIMenuPanel", "UIMenuVerticalOneLineGridPanel"
end

---New
---@param TopText string
---@param BottomText string
---@return table
---@public
function UIMenuVerticalOneLineGridPanel.New(TopText, BottomText, CirclePositionY)
    local _UIMenuVerticalOneLineGridPanel = {
        Data = {
            Enabled = true,
        },
        Background = Sprite.New("commonmenu", "gradient_bgd", 0, 0, 431, 275),
        Grid = Sprite.New("NativeUI", "vertical_grid", 0, 0, 200, 200, 0, 255, 255, 255, 255),
        Circle = Sprite.New("mpinventory", "in_world_circle", 0, 0, 20, 20, 0),
        Audio = { Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil },
        ParentItem = nil,
        Text = {
            Top = UIResText.New(TopText or "Top", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
            Bottom = UIResText.New(BottomText or "Bottom", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
        },
        SetCirclePosition = { X = 0.5, Y = CirclePositionY or 0.5 }
    }
    return setmetatable(_UIMenuVerticalOneLineGridPanel, UIMenuVerticalOneLineGridPanel)
end

---SetParentItem
---@param Item table
---@return table
---@public
function UIMenuVerticalOneLineGridPanel:SetParentItem(Item)
    if Item() == "UIMenuItem" then
        self.ParentItem = Item
    else
        return self.ParentItem
    end
end

---Enabled
---@param Enabled boolean
---@return boolean
---@public
function UIMenuVerticalOneLineGridPanel:Enabled(Enabled)
    if type(Enabled) == "boolean" then
        self.Data.Enabled = Enabled
    else
        return self.Data.Enabled
    end
end

---CirclePosition
---@param X number
---@param Y number
---@return table
---@public
function UIMenuVerticalOneLineGridPanel:CirclePosition(X, Y)
    if tonumber(X) and tonumber(Y) then
        self.Circle.X = (self.Grid.X + 20) + ((self.Grid.Width - 40) * ((X >= 0.0 and X <= 1.0) and X or 0.0)) - (self.Circle.Width / 2)
        self.Circle.Y = (self.Grid.Y + 20) + ((self.Grid.Height - 40) * ((Y >= 0.0 and Y <= 1.0) and Y or 0.0)) - (self.Circle.Height / 2)
    else
        return math.round((self.Circle.X - (self.Grid.X + 20) + (self.Circle.Width / 2)) / (self.Grid.Width - 40), 2), math.round((self.Circle.Y - (self.Grid.Y + 20) + (self.Circle.Height / 2)) / (self.Grid.Height - 40), 2)
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuVerticalOneLineGridPanel:Position(Y)
    if tonumber(Y) then
        local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
        self.Background:Position(ParentOffsetX, Y)
        self.Grid:Position(ParentOffsetX + 115.5 + (ParentOffsetWidth / 2), 37.5 + Y)
        self.Text.Top:Position(ParentOffsetX + 215.5 + (ParentOffsetWidth / 2), 5 + Y)
        self.Text.Bottom:Position(ParentOffsetX + 215.5 + (ParentOffsetWidth / 2), 240 + Y)
        if not self.CircleLocked then
            self.CircleLocked = true
            self:CirclePosition(self.SetCirclePosition.X, self.SetCirclePosition.Y)
        end
    end
end

---UpdateParent
---@param Y number
---@return nil
---@public
function UIMenuVerticalOneLineGridPanel:UpdateParent(Y)
    local _, ParentType = self.ParentItem()
    self.Data.Value = { Y = Y }
    if ParentType == "UIMenuListItem" then
        local PanelItemIndex = self.ParentItem:FindPanelItem()
        if PanelItemIndex then
            self.ParentItem.Items[PanelItemIndex].Value[self.ParentItem:FindPanelIndex(self)] = { Y = Y }
            self.ParentItem:Index(PanelItemIndex)
            self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
        else
            local PanelIndex = self.ParentItem:FindPanelIndex(self)
            for Index = 1, #self.ParentItem.Items do
                if type(self.ParentItem.Items[Index]) == "table" then
                    if not self.ParentItem.Items[Index].Panels then
                        self.ParentItem.Items[Index].Panels = {}
                    end
                    self.ParentItem.Items[Index].Panels[PanelIndex] = { Y = Y }
                else
                    self.ParentItem.Items[Index] = { Name = tostring(self.ParentItem.Items[Index]), Value = self.ParentItem.Items[Index], Panels = { [PanelIndex] = { Y = Y } } }
                end
            end
            self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.Base.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, { Y = Y })
        end
    elseif ParentType == "UIMenuItem" then
        self.ParentItem.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, { Y = Y })
    end
end

---Functions
---@return nil
---@public
function UIMenuVerticalOneLineGridPanel:Functions()
    local DrawOffset = { X = 0, Y = 0}
    if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
        DrawOffset = self.ParentItem:SetParentMenu().DrawOffset
    end

    if IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) then
        if IsDisabledControlJustPressed(0, 24) then
            if not self.Pressed then
                self.Pressed = true
                Citizen.CreateThread(function()
                    self.Audio.Id = GetSoundId()
                    PlaySoundFrontend(self.Audio.Id, self.Audio.Slider, self.Audio.Library, 1)
                    while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) do
                        Citizen.Wait(0)
                        local CursorX, CursorY = ConvertToPixel(GetControlNormal(0, 239) - DrawOffset.X, GetControlNormal(0, 240) - DrawOffset.Y)
                        CursorX, CursorY = CursorX - (self.Circle.Width / 2), CursorY - (self.Circle.Height / 2)
                        local moveCursorX = ((CursorX > (self.Grid.X + 10 + self.Grid.Width - 120)) and (self.Grid.X + 10 + self.Grid.Width - 120) or ((CursorX < (self.Grid.X + 100 - (self.Circle.Width / 2))) and (self.Grid.X + 100 - (self.Circle.Width / 2)) or CursorX))
                        local moveCursorY = ((CursorY > (self.Grid.Y + 10 + self.Grid.Height - 40)) and (self.Grid.Y + 10 + self.Grid.Height - 40) or ((CursorY < (self.Grid.Y + 20 - (self.Circle.Height / 2))) and (self.Grid.Y + 20 - (self.Circle.Height / 2)) or CursorY))
                        self.Circle:Position(moveCursorX, moveCursorY)
                    end
                    StopSound(self.Audio.Id)
                    ReleaseSoundId(self.Audio.Id)
                    self.Pressed = false
                end)
                Citizen.CreateThread(function()
                    while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.Grid.X + 20, self.Grid.Y + 20, self.Grid.Width - 40, self.Grid.Height - 40, DrawOffset) do
                        Citizen.Wait(75)
                        local ResultY = math.round((self.Circle.Y - (self.Grid.Y + 20) + (self.Circle.Height / 2)) / (self.Grid.Height - 40), 2)
                        self:UpdateParent((((ResultY >= 0.0 and ResultY <= 1.0) and ResultY or ((ResultY <= 0) and 0.0) or 1.0) * 2) - 1)
                    end
                end)
            end
        end
    end
end

---Draw
---@return nil
---@public
function UIMenuVerticalOneLineGridPanel:Draw()
    if self.Data.Enabled then
        self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 275)
        self.Background:Draw()
        self.Grid:Draw()
        self.Circle:Draw()
        self.Text.Top:Draw()
        self.Text.Bottom:Draw()
        self:Functions()
    end
end
---@type table
UIMenuPercentagePanel = setmetatable({}, UIMenuPercentagePanel)

---@type table
UIMenuPercentagePanel.__index = UIMenuPercentagePanel

---@type table
---@return string
UIMenuPercentagePanel.__call = function()
    return "UIMenuPanel", "UIMenuPercentagePanel"
end

---New
---@param MinText number
---@param MaxText number
---@return table
---@public
function UIMenuPercentagePanel.New(MinText, MaxText)
    local _UIMenuPercentagePanel = {
        Data = {
            Enabled = true,
        },
        Background = Sprite.New("commonmenu", "gradient_bgd", 0, 0, 431, 76),
        ActiveBar = UIResRectangle.New(0, 0, 413, 10, 245, 245, 245, 255),
        BackgroundBar = UIResRectangle.New(0, 0, 413, 10, 87, 87, 87, 255),
        Text = {
            Min = UIResText.New(MinText or "0%", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
            Max = UIResText.New("100%", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
            Title = UIResText.New(MaxText or "Opacity", 0, 0, 0.35, 255, 255, 255, 255, 0, "Centre"),
        },
        Audio = { Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil },
        ParentItem = nil,
    }

    return setmetatable(_UIMenuPercentagePanel, UIMenuPercentagePanel)
end

---SetParentItem
---@param Item table
---@return table
---@public
function UIMenuPercentagePanel:SetParentItem(Item)
    if Item() == "UIMenuItem" then
        self.ParentItem = Item
    else
        return self.ParentItem
    end
end

---Enabled
---@param Enabled boolean
---@return boolean
---@public
function UIMenuPercentagePanel:Enabled(Enabled)
    if type(Enabled) == "boolean" then
        self.Data.Enabled = Enabled
    else
        return self.Data.Enabled
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuPercentagePanel:Position(Y)
    if tonumber(Y) then
        local ParentOffsetX, ParentOffsetWidth = self.ParentItem:Offset().X, self.ParentItem:SetParentMenu().WidthOffset
        self.Background:Position(ParentOffsetX, Y)
        self.ActiveBar:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 9, 50 + Y)
        self.BackgroundBar:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 9, 50 + Y)
        self.Text.Min:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 25, 15 + Y)
        self.Text.Max:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 398, 15 + Y)
        self.Text.Title:Position(ParentOffsetX + (ParentOffsetWidth / 2) + 215.5, 15 + Y)
    end
end

---Percentage
---@param Value number
---@return number
---@public
function UIMenuPercentagePanel:Percentage(Value)
    if tonumber(Value) then
        local Percent = ((Value < 0.0) and 0.0) or ((Value > 1.0) and 1.0 or Value)
        self.ActiveBar:Size(self.BackgroundBar.Width * Percent, self.ActiveBar.Height)
    else
        local DrawOffset = { X = 0, Y = 0}
        if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
            DrawOffset = self.ParentItem:SetParentMenu().DrawOffset
        end

        local W, H = GetResolution()
        local Progress = (math.round((GetControlNormal(0, 239) - DrawOffset.X) * W)) - self.ActiveBar.X
        return math.round(((Progress >= 0 and Progress <= 413) and Progress or ((Progress < 0) and 0 or 413)) / self.BackgroundBar.Width, 2)
    end
end

---UpdateParent
---@param Percentage number
---@return nil
---@public
function UIMenuPercentagePanel:UpdateParent(Percentage)
    local _, ParentType = self.ParentItem()
    if ParentType == "UIMenuListItem" then
        local PanelItemIndex = self.ParentItem:FindPanelItem()
        if PanelItemIndex then
            self.ParentItem.Items[PanelItemIndex].Value[self.ParentItem:FindPanelIndex(self)] = Percentage
            self.ParentItem:Index(PanelItemIndex)
            self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
        else
            local PanelIndex = self.ParentItem:FindPanelIndex(self)
            for Index = 1, #self.ParentItem.Items do
                if type(self.ParentItem.Items[Index]) == "table" then
                    if not self.ParentItem.Items[Index].Panels then
                        self.ParentItem.Items[Index].Panels = {}
                    end
                    self.ParentItem.Items[Index].Panels[PanelIndex] = Percentage
                else
                    self.ParentItem.Items[Index] = { Name = tostring(self.ParentItem.Items[Index]), Value = self.ParentItem.Items[Index], Panels = { [PanelIndex] = Percentage } }
                end
            end
            self.ParentItem.Base.ParentMenu.OnListChange(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
            self.ParentItem.OnListChanged(self.ParentItem.Base.ParentMenu, self.ParentItem, self.ParentItem._Index)
        end
    elseif ParentType == "UIMenuItem" then
        self.ParentItem.ActivatedPanel(self.ParentItem.ParentMenu, self.ParentItem, self, Percentage)
    end
end

---Functions
---@return nil
---@public
function UIMenuPercentagePanel:Functions()
    local DrawOffset = { X = 0, Y = 0}
    if self.ParentItem:SetParentMenu().Settings.ScaleWithSafezone then
        DrawOffset = self.ParentItem:SetParentMenu().DrawOffset
    end
    if IsMouseInBounds(self.BackgroundBar.X, self.BackgroundBar.Y - 4, self.BackgroundBar.Width, self.BackgroundBar.Height + 8, DrawOffset) then
        if IsDisabledControlJustPressed(0, 24) then
            if not self.Pressed then
                self.Pressed = true
                Citizen.CreateThread(function()
                    self.Audio.Id = GetSoundId()
                    PlaySoundFrontend(self.Audio.Id, self.Audio.Slider, self.Audio.Library, 1)
                    while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.BackgroundBar.X, self.BackgroundBar.Y - 4, self.BackgroundBar.Width, self.BackgroundBar.Height + 8, DrawOffset) do
                        Citizen.Wait(0)
                        local Progress, ProgressY = ConvertToPixel(GetControlNormal(0, 239) - DrawOffset.X, 0)
                        Progress = Progress - self.ActiveBar.X
                        self.ActiveBar:Size(((Progress >= 0 and Progress <= 413) and Progress or ((Progress < 0) and 0 or 413)), self.ActiveBar.Height)
                    end
                    StopSound(self.Audio.Id)
                    ReleaseSoundId(self.Audio.Id)
                    self.Pressed = false
                end)
                Citizen.CreateThread(function()
                    while IsDisabledControlPressed(0, 24) and IsMouseInBounds(self.BackgroundBar.X, self.BackgroundBar.Y - 4, self.BackgroundBar.Width, self.BackgroundBar.Height + 8, DrawOffset) do
                        Citizen.Wait(75)
                        local Progress, ProgressY = ConvertToPixel(GetControlNormal(0, 239) - DrawOffset.X, 0)
                        Progress = Progress - self.ActiveBar.X
                        self:UpdateParent(math.round(((Progress >= 0 and Progress <= 413) and Progress or ((Progress < 0) and 0 or 413)) / self.BackgroundBar.Width, 2))
                    end
                end)
            end
        end
    end
end

---Draw
---@return nil
---@public
function UIMenuPercentagePanel:Draw()
    if self.Data.Enabled then
        self.Background:Size(431 + self.ParentItem:SetParentMenu().WidthOffset, 76)
        self.Background:Draw()
        self.BackgroundBar:Draw()
        self.ActiveBar:Draw()
        self.Text.Min:Draw()
        self.Text.Max:Draw()
        self.Text.Title:Draw()
        self:Functions()
    end
end

---@type table
UIMenuSliderHeritageItem = setmetatable({}, UIMenuSliderHeritageItem)

---@type table
UIMenuSliderHeritageItem.__index = UIMenuSliderHeritageItem

---@type table
---@return string
UIMenuSliderHeritageItem.__call = function()
    return "UIMenuItem", "UIMenuSliderHeritageItem"
end

---New
---@param Text string
---@param Items table
---@param Index boolean
---@param Description string
---@param SliderColors table
---@param BackgroundSliderColors table
---@return table
---@public
function UIMenuSliderHeritageItem.New(Text, Items, Index, Description, SliderColors, BackgroundSliderColors)
    if type(Items) ~= "table" then
        Items = {}
    end
    if Index == 0 then
        Index = 1
    end

    if type(SliderColors) ~= "table" or SliderColors == nil then
        _SliderColors = { R = 57, G = 119, B = 200, A = 255 }
    else
        _SliderColors = SliderColors
    end

    if type(BackgroundSliderColors) ~= "table" or BackgroundSliderColors == nil then
        _BackgroundSliderColors = { R = 4, G = 32, B = 57, A = 255 }
    else
        _BackgroundSliderColors = BackgroundSliderColors
    end

    local _UIMenuSliderHeritageItem = {
        Base = UIMenuItem.New(Text or "", Description or ""),
        Items = Items,
        LeftArrow = Sprite.New("mpleaderboard", "leaderboard_female_icon", 0, 0, 40, 40, 0, 255, 255, 255, 255),
        RightArrow = Sprite.New("mpleaderboard", "leaderboard_male_icon", 0, 0, 40, 40, 0, 255, 255, 255, 255),
        Background = UIResRectangle.New(0, 0, 150, 10, _BackgroundSliderColors.R, _BackgroundSliderColors.G, _BackgroundSliderColors.B, _BackgroundSliderColors.A),
        Slider = UIResRectangle.New(0, 0, 75, 10, _SliderColors.R, _SliderColors.G, _SliderColors.B, _SliderColors.A),
        Divider = UIResRectangle.New(0, 0, 4, 20, 255, 255, 255, 255),
        _Index = tonumber(Index) or 1,
        Audio = { Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil },
        OnSliderChanged = function(menu, item, newindex)
        end,
        OnSliderSelected = function(menu, item, newindex)
        end,
    }
    return setmetatable(_UIMenuSliderHeritageItem, UIMenuSliderHeritageItem)
end

---SetParentMenu
---@param Menu table
---@return table
---@public
function UIMenuSliderHeritageItem:SetParentMenu(Menu)
    if Menu() == "UIMenu" then
        self.Base.ParentMenu = Menu
    else
        return self.Base.ParentMenu
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuSliderHeritageItem:Position(Y)
    if tonumber(Y) then
        self.Background:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
        self.Slider:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
        self.Divider:Position(323.5 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 153 + self.Base._Offset.Y)
        self.LeftArrow:Position(217 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 143.5 + Y + self.Base._Offset.Y)
        self.RightArrow:Position(395 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 143.5 + Y + self.Base._Offset.Y)
        self.Base:Position(Y)
    end
end

---Selected
---@param bool boolean
---@return boolean
---@public
function UIMenuSliderHeritageItem:Selected(bool)
    if bool ~= nil then
        self.Base._Selected = tobool(bool)
    else
        return self.Base._Selected
    end
end

---Hovered
---@param bool boolean
---@return boolean
---@public
function UIMenuSliderHeritageItem:Hovered(bool)
    if bool ~= nil then
        self.Base._Hovered = tobool(bool)
    else
        return self.Base._Hovered
    end
end

---Enabled
---@param bool boolean
---@return boolean
---@public
function UIMenuSliderHeritageItem:Enabled(bool)
    if bool ~= nil then
        self.Base._Enabled = tobool(bool)
    else
        return self.Base._Enabled
    end
end

---Description
---@param str string
---@return string
---@public
function UIMenuSliderHeritageItem:Description(str)
    if tostring(str) and str ~= nil then
        self.Base._Description = tostring(str)
    else
        return self.Base._Description
    end
end

---Offset
---@param X number
---@param Y number
---@return table
---@public
function UIMenuSliderHeritageItem:Offset(X, Y)
    if tonumber(X) or tonumber(Y) then
        if tonumber(X) then
            self.Base._Offset.X = tonumber(X)
        end
        if tonumber(Y) then
            self.Base._Offset.Y = tonumber(Y)
        end
    else
        return self.Base._Offset
    end
end

---Text
---@param Text string
---@return string
---@public
function UIMenuSliderHeritageItem:Text(Text)
    if tostring(Text) and Text ~= nil then
        self.Base.Text:Text(tostring(Text))
    else
        return self.Base.Text:Text()
    end
end

---Index
---@param Index number
---@return number
---@public
function UIMenuSliderHeritageItem:Index(Index)
    if tonumber(Index) then
        if tonumber(Index) > #self.Items then
            self._Index = 1
        elseif tonumber(Index) < 1 then
            self._Index = #self.Items
        else
            self._Index = tonumber(Index)
        end
    else
        return self._Index
    end
end

---ItemToIndex
---@param Item table
---@return table
---@public
function UIMenuSliderHeritageItem:ItemToIndex(Item)
    for i = 1, #self.Items do
        if type(Item) == type(self.Items[i]) and Item == self.Items[i] then
            return i
        end
    end
end

---IndexToItem
---@param Index number
---@return table
---@public
function UIMenuSliderHeritageItem:IndexToItem(Index)
    if tonumber(Index) then
        if tonumber(Index) == 0 then
            Index = 1
        end
        if self.Items[tonumber(Index)] then
            return self.Items[tonumber(Index)]
        end
    end
end

---SetLeftBadge
---@return function
---@public
function UIMenuSliderHeritageItem:SetLeftBadge()
    error("This item does not support badges")
end

---SetRightBadge
---@return function
---@public
function UIMenuSliderHeritageItem:SetRightBadge()
    error("This item does not support badges")
end

---RightLabel
---@return function
---@public
function UIMenuSliderHeritageItem:RightLabel()
    error("This item does not support a right label")
end

---Draw
---@return nil
---@public
function UIMenuSliderHeritageItem:Draw()
    self.Base:Draw()
    if self:Enabled() then
        if self:Selected() then
            self.LeftArrow:Colour(0, 0, 0, 255)
            self.RightArrow:Colour(0, 0, 0, 255)
        else
            self.LeftArrow:Colour(255, 255, 255, 255)
            self.RightArrow:Colour(255, 255, 255, 255)
        end
    else
        self.LeftArrow:Colour(255, 255, 255, 255)
        self.RightArrow:Colour(255, 255, 255, 255)
    end
    local Offset = ((self.Background.Width - self.Slider.Width) / (#self.Items - 1)) * (self._Index - 1)
    self.Slider:Position(250 + self.Base._Offset.X + Offset + self.Base.ParentMenu.WidthOffset, self.Slider.Y)
    self.LeftArrow:Draw()
    self.RightArrow:Draw()
    self.Background:Draw()
    self.Slider:Draw()
    self.Divider:Draw()
    self.Divider:Colour(255, 255, 255, 255)
end

---@type table
UIMenuProgressItem = setmetatable({}, UIMenuProgressItem)

---@type table
UIMenuProgressItem.__index = UIMenuProgressItem

---@type table
---@return string
UIMenuProgressItem.__call = function()
    return "UIMenuItem", "UIMenuProgressItem"
end

---New
---@param Text string
---@param Items table
---@param Index number
---@param Description string
---@param Counter boolean
---@return table
---@public
function UIMenuProgressItem.New(Text, Items, Index, Description, Counter)
    if type(Items) ~= "table" then
        Items = {}
    end
    if Index == 0 then
        Index = 1
    end
    local _UIMenuProgressItem = {
        Base = UIMenuItem.New(Text or "", Description or ""),
        Data = {
            Items = Items,
            Counter = tobool(Counter),
            Max = 407.5,
            Index = tonumber(Index) or 1,
        },
        Audio = { Slider = "CONTINUOUS_SLIDER", Library = "HUD_FRONTEND_DEFAULT_SOUNDSET", Id = nil },
        Background = UIResRectangle.New(0, 0, 415, 20, 0, 0, 0, 255),
        Bar = UIResRectangle.New(0, 0, 407.5, 12.5),
        OnProgressChanged = function(menu, item, newindex)
        end,
        OnProgressSelected = function(menu, item, newindex)
        end,
    }

    _UIMenuProgressItem.Base.Rectangle.Height = 60
    _UIMenuProgressItem.Base.SelectedSprite.Height = 60

    if _UIMenuProgressItem.Data.Counter then
        _UIMenuProgressItem.Base:RightLabel(_UIMenuProgressItem.Data.Index .. "/" .. #_UIMenuProgressItem.Data.Items)
    else
        _UIMenuProgressItem.Base:RightLabel((type(_UIMenuProgressItem.Data.Items[_UIMenuProgressItem.Data.Index]) == "table") and tostring(_UIMenuProgressItem.Data.Items[_UIMenuProgressItem.Data.Index].Name) or tostring(_UIMenuProgressItem.Data.Items[_UIMenuProgressItem.Data.Index]))
    end

    _UIMenuProgressItem.Bar.Width = _UIMenuProgressItem.Data.Index / #_UIMenuProgressItem.Data.Items * _UIMenuProgressItem.Data.Max

    return setmetatable(_UIMenuProgressItem, UIMenuProgressItem)
end

---SetParentMenu
---@param Menu table
---@return table
---@public
function UIMenuProgressItem:SetParentMenu(Menu)
    if Menu() == "UIMenu" then
        self.Base.ParentMenu = Menu
    else
        return self.Base.ParentMenu
    end
end

---Position
---@param Y number
---@return nil
---@public
function UIMenuProgressItem:Position(Y)
    if tonumber(Y) then
        self.Base:Position(Y)
        self.Data.Max = 407.5 + self.Base.ParentMenu.WidthOffset
        self.Background:Size(415 + self.Base.ParentMenu.WidthOffset, 20)
        self.Background:Position(8 + self.Base._Offset.X, 177 + Y + self.Base._Offset.Y)
        self.Bar:Position(11.75 + self.Base._Offset.X, 180.75 + Y + self.Base._Offset.Y)
    end
end

---Selected
---@param bool number
---@return boolean
---@public
function UIMenuProgressItem:Selected(bool)
    if bool ~= nil then
        self.Base._Selected = tobool(bool)
    else
        return self.Base._Selected
    end
end

---Hovered
---@param bool boolean
---@return boolean
---@public
function UIMenuProgressItem:Hovered(bool)
    if bool ~= nil then
        self.Base._Hovered = tobool(bool)
    else
        return self.Base._Hovered
    end
end

---Enabled
---@param bool boolean
---@return boolean
---@public
function UIMenuProgressItem:Enabled(bool)
    if bool ~= nil then
        self.Base._Enabled = tobool(bool)
    else
        return self.Base._Enabled
    end
end

---Description
---@param str string
---@return string
---@public
function UIMenuProgressItem:Description(str)
    if tostring(str) and str ~= nil then
        self.Base._Description = tostring(str)
    else
        return self.Base._Description
    end
end

---Offset
---@param X number
---@param Y number
---@return table
---@public
function UIMenuProgressItem:Offset(X, Y)
    if tonumber(X) or tonumber(Y) then
        if tonumber(X) then
            self.Base._Offset.X = tonumber(X)
        end
        if tonumber(Y) then
            self.Base._Offset.Y = tonumber(Y)
        end
    else
        return self.Base._Offset
    end
end

---Text
---@param Text string
---@return string
---@public
function UIMenuProgressItem:Text(Text)
    if tostring(Text) and Text ~= nil then
        self.Base.Text:Text(tostring(Text))
    else
        return self.Base.Text:Text()
    end
end

---Index
---@param Index table
---@return number
---@public
function UIMenuProgressItem:Index(Index)
    if tonumber(Index) then
        if tonumber(Index) > #self.Data.Items then
            self.Data.Index = 1
        elseif tonumber(Index) < 1 then
            self.Data.Index = #self.Data.Items
        else
            self.Data.Index = tonumber(Index)
        end

        if self.Data.Counter then
            self.Base:RightLabel(self.Data.Index .. "/" .. #self.Data.Items)
        else
            self.Base:RightLabel((type(self.Data.Items[self.Data.Index]) == "table") and tostring(self.Data.Items[self.Data.Index].Name) or tostring(self.Data.Items[self.Data.Index]))
        end

        self.Bar.Width = self.Data.Index / #self.Data.Items * self.Data.Max
    else
        return self.Data.Index
    end
end

---ItemToIndex
---@param Item table
---@return table
---@public
function UIMenuProgressItem:ItemToIndex(Item)
    for i = 1, #self.Data.Items do
        if type(Item) == type(self.Data.Items[i]) and Item == self.Data.Items[i] then
            return i
        elseif type(self.Data.Items[i]) == "table" and (type(Item) == type(self.Data.Items[i].Name) or type(Item) == type(self.Data.Items[i].Value)) and (Item == self.Data.Items[i].Name or Item == self.Data.Items[i].Value) then
            return i
        end
    end
end

---IndexToItem
---@param Index table
---@return table
---@public
function UIMenuProgressItem:IndexToItem(Index)
    if tonumber(Index) then
        if tonumber(Index) == 0 then
            Index = 1
        end
        if self.Data.Items[tonumber(Index)] then
            return self.Data.Items[tonumber(Index)]
        end
    end
end

---SetLeftBadge
---@return function
---@public
function UIMenuProgressItem:SetLeftBadge()
    error("This item does not support badges")
end

---SetRightBadge
---@return function
---@public
function UIMenuProgressItem:SetRightBadge()
    error("This item does not support badges")
end

---RightLabel
---@return function
---@public
function UIMenuProgressItem:RightLabel()
    error("This item does not support a right label")
end

---CalculateProgress
---@param CursorX number
---@return nil
---@public
function UIMenuProgressItem:CalculateProgress(CursorX)
    local Progress = CursorX - self.Bar.X
    self:Index(math.round(#self.Data.Items * (((Progress >= 0 and Progress <= self.Data.Max) and Progress or ((Progress < 0) and 0 or self.Data.Max)) / self.Data.Max)))
end

---Draw
---@return nil
---@public
function UIMenuProgressItem:Draw()
    self.Base:Draw()

    if self.Base._Selected then
        self.Background:Colour(table.unpack(Colours.Black))
        self.Bar:Colour(table.unpack(Colours.White))
    else
        self.Background:Colour(table.unpack(Colours.White))
        self.Bar:Colour(table.unpack(Colours.Black))
    end

    self.Background:Draw()
    self.Bar:Draw()
end

---@type table
UIMenu = setmetatable({}, UIMenu)

---@type table
UIMenu.__index = UIMenu

---@type table
---@return string
UIMenu.__call = function()
    return "UIMenu"
end

---New
---@param Title string
---@param Subtitle string
---@param X number
---@param Y number
---@param TxtDictionary string
---@param TxtName string
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return table
---@public
function UIMenu.New(Title, Subtitle, X, Y, TxtDictionary, TxtName, Heading, R, G, B, A)
    local X, Y = tonumber(X) or 0, tonumber(Y) or 0
    if Title ~= nil then
        Title = tostring(Title) or ""
    else
        Title = ""
    end
    if Subtitle ~= nil then
        Subtitle = tostring(Subtitle) or ""
    else
        Subtitle = ""
    end
    if TxtDictionary ~= nil then
        TxtDictionary = tostring(TxtDictionary) or "commonmenu"
    else
        TxtDictionary = "commonmenu"
    end
    if TxtName ~= nil then
        TxtName = tostring(TxtName) or "interaction_bgd"
    else
        TxtName = "interaction_bgd"
    end
    if Heading ~= nil then
        Heading = tonumber(Heading) or 0
    else
        Heading = 0
    end
    if R ~= nil then
        R = tonumber(R) or 255
    else
        R = 255
    end
    if G ~= nil then
        G = tonumber(G) or 255
    else
        G = 255
    end
    if B ~= nil then
        B = tonumber(B) or 255
    else
        B = 255
    end
    if A ~= nil then
        A = tonumber(A) or 255
    else
        A = 255
    end
    local _UIMenu = {
        Logo = Sprite.New(TxtDictionary, TxtName, 0 + X, 0 + Y, 431, 107, Heading, R, G, B, A),
        Banner = nil,
        Title = UIResText.New(Title, 215 + X, 20 + Y, 1.15, 255, 255, 255, 255, 1, 1, 0),
        BetterSize = true,
        Subtitle = { ExtraY = 0 },
        WidthOffset = 0,
        Position = { X = X, Y = Y },
        DrawOffset = { X = 0, Y = 0 },
        Pagination = { Min = 0, Max = 10, Total = 9 },
        PageCounter = {
            isCustom = false,
            PreText = "",
        },
        Extra = {},
        Description = {},
        Items = {},
        Windows = {},
        Children = {},
        Controls = {
            Back = {
                Enabled = true,
            },
            Select = {
                Enabled = true,
            },
            Left = {
                Enabled = true,
            },
            Right = {
                Enabled = true,
            },
            Up = {
                Enabled = true,
            },
            Down = {
                Enabled = true,
            },
        },
        ParentMenu = nil,
        ParentItem = nil,
        _Visible = false,
        ActiveItem = 1000,
        Dirty = false;
        ReDraw = true,
        InstructionalScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS"),
        InstructionalButtons = {},
        OnIndexChange = function(menu, newindex)
        end,
        OnListChange = function(menu, list, newindex)
        end,
        OnSliderChange = function(menu, slider, newindex)
        end,
        OnProgressChange = function(menu, progress, newindex)
        end,
        OnCheckboxChange = function(menu, item, checked)
        end,
        OnListSelect = function(menu, list, index)
        end,
        OnSliderSelect = function(menu, slider, index)
        end,
        OnProgressSelect = function(menu, progress, index)
        end,
        OnItemSelect = function(menu, item, index)
        end,
        OnMenuChanged = function(menu, newmenu, forward)
        end,
        OnMenuClosed = function(menu)
        end,
        Settings = {
            InstructionalButtons = true,
            MultilineFormats = true,
            ScaleWithSafezone = true,
            ResetCursorOnOpen = true,
            MouseControlsEnabled = true,
            MouseEdgeEnabled = true,
            ControlDisablingEnabled = true,
            DrawOrder = nil,
            Audio = {
                Library = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                UpDown = "NAV_UP_DOWN",
                LeftRight = "NAV_LEFT_RIGHT",
                Select = "SELECT",
                Back = "BACK",
                Error = "ERROR",
            },
            EnabledControls = {
                Controller = {
                    { 0, 2 }, -- Look Up and Down
                    { 0, 1 }, -- Look Left and Right
                    { 0, 25 }, -- Aim
                    { 0, 24 }, -- Attack
                },
                Keyboard = {
                    { 0, 201 }, -- Select
                    { 0, 195 }, -- X axis
                    { 0, 196 }, -- Y axis
                    { 0, 187 }, -- Down
                    { 0, 188 }, -- Up
                    { 0, 189 }, -- Left
                    { 0, 190 }, -- Right
                    { 0, 202 }, -- Back
                    { 0, 217 }, -- Select
                    { 0, 242 }, -- Scroll down
                    { 0, 241 }, -- Scroll up
                    { 0, 239 }, -- Cursor X
                    { 0, 240 }, -- Cursor Y
                    { 0, 31 }, -- Move Up and Down
                    { 0, 30 }, -- Move Left and Right
                    { 0, 21 }, -- Sprint
                    { 0, 22 }, -- Jump
                    { 0, 23 }, -- Enter
                    { 0, 75 }, -- Exit Vehicle
                    { 0, 71 }, -- Accelerate Vehicle
                    { 0, 72 }, -- Vehicle Brake
                    { 0, 59 }, -- Move Vehicle Left and Right
                    { 0, 89 }, -- Fly Yaw Left
                    { 0, 9 }, -- Fly Left and Right
                    { 0, 8 }, -- Fly Up and Down
                    { 0, 90 }, -- Fly Yaw Right
                    { 0, 76 }, -- Vehicle Handbrake
                },
            },
        }
    }

    if Subtitle ~= "" and Subtitle ~= nil then
        _UIMenu.Subtitle.Rectangle = UIResRectangle.New(0 + _UIMenu.Position.X, 107 + _UIMenu.Position.Y, 431, 37, 0, 0, 0, 255)
        _UIMenu.Subtitle.Text = UIResText.New(Subtitle, 8 + _UIMenu.Position.X, 110 + _UIMenu.Position.Y, 0.35, 245, 245, 245, 255, 0)
        _UIMenu.Subtitle.BackupText = Subtitle
        _UIMenu.Subtitle.Formatted = false
        if string.starts(Subtitle, "~") then
            _UIMenu.PageCounter.PreText = string.sub(Subtitle, 1, 3)
        end
        _UIMenu.PageCounter.Text = UIResText.New("", 425 + _UIMenu.Position.X, 110 + _UIMenu.Position.Y, 0.35, 245, 245, 245, 255, 0, "Right")
        _UIMenu.Subtitle.ExtraY = 37
    end

    _UIMenu.ArrowSprite = Sprite.New("commonmenu", "shop_arrows_upanddown", 190 + _UIMenu.Position.X, 147 + 37 * (_UIMenu.Pagination.Total + 1) + _UIMenu.Position.Y - 37 + _UIMenu.Subtitle.ExtraY, 40, 40)
    _UIMenu.Extra.Up = UIResRectangle.New(0 + _UIMenu.Position.X, 144 + 38 * (_UIMenu.Pagination.Total + 1) + _UIMenu.Position.Y - 37 + _UIMenu.Subtitle.ExtraY, 431, 18, 0, 0, 0, 200)
    _UIMenu.Extra.Down = UIResRectangle.New(0 + _UIMenu.Position.X, 144 + 18 + 38 * (_UIMenu.Pagination.Total + 1) + _UIMenu.Position.Y - 37 + _UIMenu.Subtitle.ExtraY, 431, 18, 0, 0, 0, 200)

    _UIMenu.Description.Bar = UIResRectangle.New(_UIMenu.Position.X, 123, 431, 4, 0, 0, 0, 255)
    _UIMenu.Description.Rectangle = Sprite.New("commonmenu", "gradient_bgd", _UIMenu.Position.X, 127, 431, 30)
    _UIMenu.Description.Text = UIResText.New("Description", _UIMenu.Position.X + 5, 125, 0.35)

    _UIMenu.Background = Sprite.New("commonmenu", "gradient_bgd", _UIMenu.Position.X, 144 + _UIMenu.Position.Y - 37 + _UIMenu.Subtitle.ExtraY, 290, 25)

    if _UIMenu.BetterSize == true then
        _UIMenu.WidthOffset = math.floor(tonumber(69))
        _UIMenu.Logo:Size(431 + _UIMenu.WidthOffset, 107)
        _UIMenu.Title:Position(((_UIMenu.WidthOffset + 431) / 2) + _UIMenu.Position.X, 20 + _UIMenu.Position.Y)
        if _UIMenu.Subtitle.Rectangle ~= nil then
            _UIMenu.Subtitle.Rectangle:Size(431 + _UIMenu.WidthOffset + 100, 37)
            _UIMenu.PageCounter.Text:Position(425 + _UIMenu.Position.X + _UIMenu.WidthOffset, 110 + _UIMenu.Position.Y)
        end
        if _UIMenu.Banner ~= nil then
            _UIMenu.Banner:Size(431 + _UIMenu.WidthOffset, 107)
        end
    end

    Citizen.CreateThread(function()
        if not HasScaleformMovieLoaded(_UIMenu.InstructionalScaleform) then
            _UIMenu.InstructionalScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
            while not HasScaleformMovieLoaded(_UIMenu.InstructionalScaleform) do
                Citizen.Wait(0)
            end
        end
    end)
    return setmetatable(_UIMenu, UIMenu)
end

---SetMenuWidthOffset
---@param Offset number
---@return number
---@public
function UIMenu:SetMenuWidthOffset(Offset)
    if tonumber(Offset) then
        self.WidthOffset = math.floor(tonumber(Offset) + tonumber(70))
        self.Logo:Size(431 + self.WidthOffset, 107)
        self.Title:Position(((self.WidthOffset + 431) / 2) + self.Position.X, 20 + self.Position.Y)
        if self.Subtitle.Rectangle ~= nil then
            self.Subtitle.Rectangle:Size(431 + self.WidthOffset + 100, 37)
            self.PageCounter.Text:Position(425 + self.Position.X + self.WidthOffset, 110 + self.Position.Y)
        end
        if self.Banner ~= nil then
            self.Banner:Size(431 + self.WidthOffset, 107)
        end
    end
end

---DisEnableControls
---@param bool boolean
---@return nil
---@public
function UIMenu:DisEnableControls(bool)
    if bool then
        EnableAllControlActions(2)
    else
        DisableAllControlActions(2)
    end
    if bool then
        return
    else
        if Controller() then
            for Index = 1, #self.Settings.EnabledControls.Controller do
                EnableControlAction(self.Settings.EnabledControls.Controller[Index][1], self.Settings.EnabledControls.Controller[Index][2], true)
            end
        else
            for Index = 1, #self.Settings.EnabledControls.Keyboard do
                EnableControlAction(self.Settings.EnabledControls.Keyboard[Index][1], self.Settings.EnabledControls.Keyboard[Index][2], true)
            end
        end
    end
end

---InstructionalButtons
---@param bool boolean
---@return nil
---@public
function UIMenu:InstructionalButtons(bool)
    if bool ~= nil then
        self.Settings.InstrucitonalButtons = tobool(bool)
    end
end

---SetBannerSprite
---@param Sprite string
---@param IncludeChildren boolean
---@return nil
---@public
function UIMenu:SetBannerSprite(Sprite, IncludeChildren)
    if Sprite() == "Sprite" then
        self.Logo = Sprite
        self.Logo:Size(431 + self.WidthOffset, 107)
        self.Logo:Position(self.Position.X, self.Position.Y)
        self.Banner = nil
        if IncludeChildren then
            for Item, Menu in pairs(self.Children) do
                Menu.Logo = Sprite
                Menu.Logo:Size(431 + self.WidthOffset, 107)
                Menu.Logo:Position(self.Position.X, self.Position.Y)
                Menu.Banner = nil
            end
        end
    end
end

---SetBannerRectangle
---@param Rectangle string
---@param IncludeChildren boolean
---@return nil
---@public
function UIMenu:SetBannerRectangle(Rectangle, IncludeChildren)
    if Rectangle() == "Rectangle" then
        self.Banner = Rectangle
        self.Banner:Size(431 + self.WidthOffset, 107)
        self.Banner:Position(self.Position.X, self.Position.Y)
        self.Logo = nil
        if IncludeChildren then
            for Item, Menu in pairs(self.Children) do
                Menu.Banner = Rectangle
                Menu.Banner:Size(431 + self.WidthOffset, 107)
                Menu:Position(self.Position.X, self.Position.Y)
                Menu.Logo = nil
            end
        end
    end
end

---CurrentSelection
---@param value number
---@return number
---@public
function UIMenu:CurrentSelection(value)
    if tonumber(value) then
        if #self.Items == 0 then
            self.ActiveItem = 0
        end
        self.Items[self:CurrentSelection()]:Selected(false)
        self.ActiveItem = 1000000 - (1000000 % #self.Items) + tonumber(value)
        if self:CurrentSelection() > self.Pagination.Max then
            self.Pagination.Min = self:CurrentSelection() - self.Pagination.Total
            self.Pagination.Max = self:CurrentSelection()
        elseif self:CurrentSelection() < self.Pagination.Min then
            self.Pagination.Min = self:CurrentSelection()
            self.Pagination.Max = self:CurrentSelection() + self.Pagination.Total
        end
    else
        if #self.Items == 0 then
            return 1
        else
            if self.ActiveItem % #self.Items == 0 then
                return 1
            else
                return self.ActiveItem % #self.Items + 1
            end
        end
    end
end

---CalculateWindowHeight
---@return number
---@public
function UIMenu:CalculateWindowHeight()
    local Height = 0
    for i = 1, #self.Windows do
        Height = Height + self.Windows[i].Background:Size().Height
    end
    return Height
end

---CalculateItemHeightOffset
---@param Item table
---@return number
---@public
function UIMenu:CalculateItemHeightOffset(Item)
    if Item.Base then
        return Item.Base.Rectangle.Height
    else
        return Item.Rectangle.Height
    end
end

---CalculateItemHeight
---@return number
---@public
function UIMenu:CalculateItemHeight()
    local ItemOffset = 0 + self.Subtitle.ExtraY - 37
    for i = self.Pagination.Min + 1, self.Pagination.Max do
        local Item = self.Items[i]
        if Item ~= nil then
            ItemOffset = ItemOffset + self:CalculateItemHeightOffset(Item)
        end
    end

    return ItemOffset
end

---RecalculateDescriptionPosition
---@return nil
---@public
function UIMenu:RecalculateDescriptionPosition()
    local WindowHeight = self:CalculateWindowHeight()
    self.Description.Bar:Position(self.Position.X, 149 + self.Position.Y + WindowHeight)
    self.Description.Rectangle:Position(self.Position.X, 149 + self.Position.Y + WindowHeight)
    self.Description.Text:Position(self.Position.X + 8, 155 + self.Position.Y + WindowHeight)
    self.Description.Bar:Size(431 + self.WidthOffset, 4)
    self.Description.Rectangle:Size(431 + self.WidthOffset, 30)
    self.Description.Bar:Position(self.Position.X, self:CalculateItemHeight() + ((#self.Items > (self.Pagination.Total + 1)) and 37 or 0) + self.Description.Bar:Position().Y)
    self.Description.Rectangle:Position(self.Position.X, self:CalculateItemHeight() + ((#self.Items > (self.Pagination.Total + 1)) and 37 or 0) + self.Description.Rectangle:Position().Y)
    self.Description.Text:Position(self.Position.X + 8, self:CalculateItemHeight() + ((#self.Items > (self.Pagination.Total + 1)) and 37 or 0) + self.Description.Text:Position().Y)
end

---CaclulatePanelPosition
---@param HasDescription boolean
---@return number
---@public
function UIMenu:CaclulatePanelPosition(HasDescription)
    local Height = self:CalculateWindowHeight() + 149 + self.Position.Y
    if HasDescription then
        Height = Height + self.Description.Rectangle:Size().Height + 5
    end
    return self:CalculateItemHeight() + ((#self.Items > (self.Pagination.Total + 1)) and 37 or 0) + Height
end

---AddWindow
---@param Window table
---@return nil
---@public
function UIMenu:AddWindow(Window)
    if Window() == "UIMenuWindow" then
        Window:SetParentMenu(self)
        Window:Offset(self.Position.X, self.Position.Y)
        table.insert(self.Windows, Window)
        self.ReDraw = true
        self:RecalculateDescriptionPosition()
    end
end

---RemoveWindowAt
---@param Index table
---@return nil
---@public
function UIMenu:RemoveWindowAt(Index)
    if tonumber(Index) then
        if self.Windows[Index] then
            table.remove(self.Windows, Index)
            self.ReDraw = true
            self:RecalculateDescriptionPosition()
        end
    end
end

---AddItem
---@param Item table
---@return nil
---@public
function UIMenu:AddItem(Item)
    Items = Item
    if #Items == 0 then
        if Item() == "UIMenuItem" then
            local SelectedItem = self:CurrentSelection()
            Item:SetParentMenu(self)
            Item:Offset(self.Position.X, self.Position.Y)
            Item:Position((#self.Items * 25) - 37 + self.Subtitle.ExtraY)
            table.insert(self.Items, Item)
            self:RecalculateDescriptionPosition()
            self:CurrentSelection(SelectedItem)
        end
    end
    for i = 1, #Items, 1 do
        Item = Items[i]
        if Item() == "UIMenuItem" then
            local SelectedItem = self:CurrentSelection()
            Item:SetParentMenu(self)
            Item:Offset(self.Position.X, self.Position.Y)
            Item:Position((#self.Items * 25) - 37 + self.Subtitle.ExtraY)
            table.insert(self.Items, Item)
            self:RecalculateDescriptionPosition()
            self:CurrentSelection(SelectedItem)
        end
    end
end

---GetItemAt
---@param Index table
---@return table
---@public
function UIMenu:GetItemAt(index)
    return self.Items[index]
end

---RemoveItemAt
---@param Index table
---@return nil
---@public
function UIMenu:RemoveItemAt(Index)
    if tonumber(Index) then
        if self.Items[Index] then
            local SelectedItem = self:CurrentSelection()
            if #self.Items > self.Pagination.Total and self.Pagination.Max == #self.Items - 1 then
                self.Pagination.Min = self.Pagination.Min - 1
                self.Pagination.Max = self.Pagination.Max + 1
            end
            table.remove(self.Items, tonumber(Index))
            self:RecalculateDescriptionPosition()
            self:CurrentSelection(SelectedItem)
        end
    end
end

---RefreshIndex
---@return nil
---@public
function UIMenu:RefreshIndex()
    if #self.Items == 0 then
        self.ActiveItem = 1000
        self.Pagination.Max = self.Pagination.Total + 1
        self.Pagination.Min = 0
        return
    end
    self.Items[self:CurrentSelection()]:Selected(false)
    self.ActiveItem = 1000 - (1000 % #self.Items)
    self.Pagination.Max = self.Pagination.Total + 1
    self.Pagination.Min = 0
    self.ReDraw = true
end

---Clear
---@return nil
---@public
function UIMenu:Clear()
    self.Items = {}
    self.ReDraw = true
    self:RecalculateDescriptionPosition()
end

---MultilineFormat
---@param str string
---@return string
---@public
function UIMenu:MultilineFormat(str)
    if tostring(str) then
        local PixelPerLine = 425 + self.WidthOffset
        local AggregatePixels = 0
        local output = ""
        local words = string.split(tostring(str), " ")
        for i = 1, #words do
            local offset = MeasureStringWidth(words[i], 0, 0.30)
            AggregatePixels = AggregatePixels + offset
            if AggregatePixels > PixelPerLine then
                output = output .. "\n" .. words[i] .. " "
                AggregatePixels = offset + MeasureString(" ")
            else
                output = output .. words[i] .. " "
                AggregatePixels = AggregatePixels + MeasureString(" ")
            end
        end

        return output
    end
end

---DrawCalculations
---@return nil
---@public
function UIMenu:DrawCalculations()
    local WindowHeight = self:CalculateWindowHeight()
    if self.Settings.MultilineFormats then
        if self.Subtitle.Rectangle and not self.Subtitle.Formatted then
            self.Subtitle.Formatted = true
            self.Subtitle.Text:Text(self:MultilineFormat(self.Subtitle.Text:Text()))
            local Linecount = #string.split(self.Subtitle.Text:Text(), "\n")
            self.Subtitle.ExtraY = ((Linecount == 1) and 37 or ((Linecount + 1) * 22))
            self.Subtitle.Rectangle:Size(431 + self.WidthOffset, self.Subtitle.ExtraY)
        end
    elseif self.Subtitle.Formatted then
        self.Subtitle.Formatted = false
        self.Subtitle.ExtraY = 37
        self.Subtitle.Rectangle:Size(431 + self.WidthOffset, self.Subtitle.ExtraY)
        self.Subtitle.Text:Text(self.Subtitle.BackupText)
    end

    self.Background:Size(431 + self.WidthOffset, self:CalculateItemHeight() + WindowHeight + ((self.Subtitle.ExtraY > 0) and 0 or 37))

    self.Extra.Up:Size(431 + self.WidthOffset, 18)
    self.Extra.Down:Size(431 + self.WidthOffset, 18)

    local offsetExtra = 4
    self.Extra.Up:Position(self.Position.X, 144 + self:CalculateItemHeight() + self.Position.Y + WindowHeight + offsetExtra)
    self.Extra.Down:Position(self.Position.X, 144 + 18 + self:CalculateItemHeight() + self.Position.Y + WindowHeight + offsetExtra)

    if self.WidthOffset > 0 then
        self.ArrowSprite:Position(190 + self.Position.X + (self.WidthOffset / 2), 141 + self:CalculateItemHeight() + self.Position.Y + WindowHeight + offsetExtra)
    else
        self.ArrowSprite:Position(190 + self.Position.X + self.WidthOffset, 141 + self:CalculateItemHeight() + self.Position.Y + WindowHeight + offsetExtra)
    end

    self.ReDraw = false

    if #self.Items ~= 0 and self.Items[self:CurrentSelection()]:Description() ~= "" then
        self:RecalculateDescriptionPosition()
        local description = self.Items[self:CurrentSelection()]:Description()
        if self.Settings.MultilineFormats then
            self.Description.Text:Text(self:MultilineFormat(description))
        else
            self.Description.Text:Text(description)
        end
        local Linecount = #string.split(self.Description.Text:Text(), "\n")
        self.Description.Rectangle:Size(431 + self.WidthOffset, ((Linecount == 1) and 37 or ((Linecount + 1) * 22)))
    end
end

---Visible
---@param bool boolean
---@return boolean
---@public
function UIMenu:Visible(bool)
    if bool ~= nil then
        self._Visible = tobool(bool)
        self.JustOpened = tobool(bool)
        self.Dirty = tobool(bool)
        self:UpdateScaleform()
        if self.ParentMenu ~= nil or tobool(bool) == false then
            return
        end
        if self.Settings.ResetCursorOnOpen then
            local W, H = GetActiveScreenResolution()
            SetCursorLocation(W / 2, H / 2)
            SetCursorSprite(1)
        end
    else
        return self._Visible
    end
end

---ProcessControl
---@return nil
---@public
function UIMenu:ProcessControl()
    if not self._Visible then
        return
    end
    if self.JustOpened then
        self.JustOpened = false
        return
    end
    if self.Controls.Back.Enabled and (IsDisabledControlJustReleased(0, 177) or IsDisabledControlJustReleased(1, 177) or IsDisabledControlJustReleased(2, 177) or IsDisabledControlJustReleased(0, 199) or IsDisabledControlJustReleased(1, 199) or IsDisabledControlJustReleased(2, 199)) then
        self:GoBack()
    end
    if #self.Items == 0 then
        return
    end
    if not self.UpPressed then
        if self.Controls.Up.Enabled and (IsDisabledControlJustPressed(0, 172) or IsDisabledControlJustPressed(1, 172) or IsDisabledControlJustPressed(2, 172) or IsDisabledControlJustPressed(0, 241) or IsDisabledControlJustPressed(1, 241) or IsDisabledControlJustPressed(2, 241) or IsDisabledControlJustPressed(2, 241)) then
            Citizen.CreateThread(function()
                self.UpPressed = true
                if #self.Items > self.Pagination.Total + 1 then
                    self:GoUpOverflow()
                else
                    self:GoUp()
                end
                self:UpdateScaleform()
                Citizen.Wait(175)
                while self.Controls.Up.Enabled and (IsDisabledControlPressed(0, 172) or IsDisabledControlPressed(1, 172) or IsDisabledControlPressed(2, 172) or IsDisabledControlPressed(0, 241) or IsDisabledControlPressed(1, 241) or IsDisabledControlPressed(2, 241) or IsDisabledControlPressed(2, 241)) do
                    if #self.Items > self.Pagination.Total + 1 then
                        self:GoUpOverflow()
                    else
                        self:GoUp()
                    end
                    self:UpdateScaleform()
                    Citizen.Wait(125)
                end
                self.UpPressed = false
            end)
        end
    end
    if not self.DownPressed then
        if self.Controls.Down.Enabled and (IsDisabledControlJustPressed(0, 173) or IsDisabledControlJustPressed(1, 173) or IsDisabledControlJustPressed(2, 173) or IsDisabledControlJustPressed(0, 242) or IsDisabledControlJustPressed(1, 242) or IsDisabledControlJustPressed(2, 242)) then
            Citizen.CreateThread(function()
                self.DownPressed = true
                if #self.Items > self.Pagination.Total + 1 then
                    self:GoDownOverflow()
                else
                    self:GoDown()
                end
                self:UpdateScaleform()
                Citizen.Wait(175)
                while self.Controls.Down.Enabled and (IsDisabledControlPressed(0, 173) or IsDisabledControlPressed(1, 173) or IsDisabledControlPressed(2, 173) or IsDisabledControlPressed(0, 242) or IsDisabledControlPressed(1, 242) or IsDisabledControlPressed(2, 242)) do
                    if #self.Items > self.Pagination.Total + 1 then
                        self:GoDownOverflow()
                    else
                        self:GoDown()
                    end
                    self:UpdateScaleform()
                    Citizen.Wait(125)
                end
                self.DownPressed = false
            end)
        end
    end
    if not self.LeftPressed then
        if self.Controls.Left.Enabled and (IsDisabledControlJustPressed(0, 174) or IsDisabledControlJustPressed(1, 174) or IsDisabledControlJustPressed(2, 174)) then
            local type, subtype = self.Items[self:CurrentSelection()]()
            Citizen.CreateThread(function()
                if (subtype == "UIMenuSliderHeritageItem") then
                    self.LeftPressed = true
                    self:GoLeft()
                    Citizen.Wait(40)
                    while self.Controls.Left.Enabled and (IsDisabledControlPressed(0, 174) or IsDisabledControlPressed(1, 174) or IsDisabledControlPressed(2, 174)) do
                        self:GoLeft()
                        Citizen.Wait(20)
                    end
                    self.LeftPressed = false
                else
                    self.LeftPressed = true
                    self:GoLeft()
                    Citizen.Wait(175)
                    while self.Controls.Left.Enabled and (IsDisabledControlPressed(0, 174) or IsDisabledControlPressed(1, 174) or IsDisabledControlPressed(2, 174)) do
                        self:GoLeft()
                        Citizen.Wait(125)
                    end
                    self.LeftPressed = false
                end
            end)
        end
    end
    if not self.RightPressed then
        if self.Controls.Right.Enabled and (IsDisabledControlJustPressed(0, 175) or IsDisabledControlJustPressed(1, 175) or IsDisabledControlJustPressed(2, 175)) then
            Citizen.CreateThread(function()
                local type, subtype = self.Items[self:CurrentSelection()]()
                if (subtype == "UIMenuSliderHeritageItem") then
                    self.RightPressed = true
                    self:GoRight()
                    Citizen.Wait(40)
                    while self.Controls.Right.Enabled and (IsDisabledControlPressed(0, 175) or IsDisabledControlPressed(1, 175) or IsDisabledControlPressed(2, 175)) do
                        self:GoRight()
                        Citizen.Wait(20)
                    end
                    self.RightPressed = false
                else
                    self.RightPressed = true
                    self:GoRight()
                    Citizen.Wait(175)
                    while self.Controls.Right.Enabled and (IsDisabledControlPressed(0, 175) or IsDisabledControlPressed(1, 175) or IsDisabledControlPressed(2, 175)) do
                        self:GoRight()
                        Citizen.Wait(125)
                    end
                    self.RightPressed = false
                end
            end)
        end
    end
    if self.Controls.Select.Enabled and (IsDisabledControlJustPressed(0, 201) or IsDisabledControlJustPressed(1, 201) or IsDisabledControlJustPressed(2, 201)) then
        self:SelectItem()
    end
end

---GoUpOverflow
---@return nil
---@public
function UIMenu:GoUpOverflow()
    if #self.Items <= self.Pagination.Total + 1 then
        return
    end
    if self:CurrentSelection() <= self.Pagination.Min + 1 then
        if self:CurrentSelection() == 1 then
            self.Pagination.Min = #self.Items - (self.Pagination.Total + 1)
            self.Pagination.Max = #self.Items
            self.Items[self:CurrentSelection()]:Selected(false)
            self.ActiveItem = 1000 - (1000 % #self.Items)
            self.ActiveItem = self.ActiveItem + (#self.Items - 1)
            self.Items[self:CurrentSelection()]:Selected(true)
        else
            self.Pagination.Min = self.Pagination.Min - 1
            self.Pagination.Max = self.Pagination.Max - 1
            self.Items[self:CurrentSelection()]:Selected(false)
            self.ActiveItem = self.ActiveItem - 1
            self.Items[self:CurrentSelection()]:Selected(true)
        end
    else
        self.Items[self:CurrentSelection()]:Selected(false)
        self.ActiveItem = self.ActiveItem - 1
        self.Items[self:CurrentSelection()]:Selected(true)
    end
    PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
    self.OnIndexChange(self, self:CurrentSelection())
    self.ReDraw = true
end

---GoUp
---@return nil
---@public
function UIMenu:GoUp()
    if #self.Items > self.Pagination.Total + 1 then
        return
    end
    self.Items[self:CurrentSelection()]:Selected(false)
    self.ActiveItem = self.ActiveItem - 1
    self.Items[self:CurrentSelection()]:Selected(true)
    PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
    self.OnIndexChange(self, self:CurrentSelection())
    self.ReDraw = true
end

---GoDownOverflow
---@return nil
---@public
function UIMenu:GoDownOverflow()
    if #self.Items <= self.Pagination.Total + 1 then
        return
    end

    if self:CurrentSelection() >= self.Pagination.Max then
        if self:CurrentSelection() == #self.Items then
            self.Pagination.Min = 0
            self.Pagination.Max = self.Pagination.Total + 1
            self.Items[self:CurrentSelection()]:Selected(false)
            self.ActiveItem = 1000 - (1000 % #self.Items)
            self.Items[self:CurrentSelection()]:Selected(true)
        else
            self.Pagination.Max = self.Pagination.Max + 1
            self.Pagination.Min = self.Pagination.Max - (self.Pagination.Total + 1)
            self.Items[self:CurrentSelection()]:Selected(false)
            self.ActiveItem = self.ActiveItem + 1
            self.Items[self:CurrentSelection()]:Selected(true)
        end
    else
        self.Items[self:CurrentSelection()]:Selected(false)
        self.ActiveItem = self.ActiveItem + 1
        self.Items[self:CurrentSelection()]:Selected(true)
    end
    PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
    self.OnIndexChange(self, self:CurrentSelection())
    self.ReDraw = true
end

---GoDown
---@return nil
---@public
function UIMenu:GoDown()
    if #self.Items > self.Pagination.Total + 1 then
        return
    end

    self.Items[self:CurrentSelection()]:Selected(false)
    self.ActiveItem = self.ActiveItem + 1
    self.Items[self:CurrentSelection()]:Selected(true)
    PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
    self.OnIndexChange(self, self:CurrentSelection())
    self.ReDraw = true
end

---GoLeft
---@return number
---@public
function UIMenu:GoLeft()
    local type, subtype = self.Items[self:CurrentSelection()]()
    if subtype ~= "UIMenuListItem" and
            subtype ~= "UIMenuSliderItem" and
            subtype ~= "UIMenuProgressItem" and
            subtype ~= "UIMenuSliderHeritageItem" and
            subtype ~= "UIMenuSliderProgressItem" then
        return
    end

    if not self.Items[self:CurrentSelection()]:Enabled() then
        PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
        return
    end

    if subtype == "UIMenuListItem" then
        local Item = self.Items[self:CurrentSelection()]
        Item:Index(Item._Index - 1)
        self.OnListChange(self, Item, Item._Index)
        Item.OnListChanged(self, Item, Item._Index)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuSliderItem" then
        local Item = self.Items[self:CurrentSelection()]
        Item:Index(Item._Index - 1)
        self.OnSliderChange(self, Item, Item:Index())
        Item.OnSliderChanged(self, Item, Item._Index)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuSliderProgressItem" then
        local Item = self.Items[self:CurrentSelection()]
        Item:Index(Item._Index - 1)
        self.OnSliderChange(self, Item, Item:Index())
        Item.OnSliderChanged(self, Item, Item._Index)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuProgressItem" then
        local Item = self.Items[self:CurrentSelection()]
        Item:Index(Item.Data.Index - 1)
        self.OnProgressChange(self, Item, Item.Data.Index)
        Item.OnProgressChanged(self, Item, Item.Data.Index)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuSliderHeritageItem" then
        local Item = self.Items[self:CurrentSelection()]
        Item:Index(Item._Index - 0.1)
        self.OnSliderChange(self, Item, Item:Index())
        Item.OnSliderChanged(self, Item, Item._Index)
        if not Item.Pressed then
            Item.Pressed = true
            Citizen.CreateThread(function()
                Item.Audio.Id = GetSoundId()
                PlaySoundFrontend(Item.Audio.Id, Item.Audio.Slider, Item.Audio.Library, 1)
                Citizen.Wait(100)
                StopSound(Item.Audio.Id)
                ReleaseSoundId(Item.Audio.Id)
                Item.Pressed = false
            end)
        end

    end
end

---GoRight
---@return nil
---@public
function UIMenu:GoRight()
    local type, subtype = self.Items[self:CurrentSelection()]()
    if subtype ~= "UIMenuListItem" and
            subtype ~= "UIMenuSliderItem" and
            subtype ~= "UIMenuProgressItem" and
            subtype ~= "UIMenuSliderHeritageItem" and
            subtype ~= "UIMenuSliderProgressItem" then
        return
    end
    if not self.Items[self:CurrentSelection()]:Enabled() then
        PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
        return
    end
    if subtype == "UIMenuListItem" then
        local Item = self.Items[self:CurrentSelection()]
        Item:Index(Item._Index + 1)
        self.OnListChange(self, Item, Item._Index)
        Item.OnListChanged(self, Item, Item._Index)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuSliderItem" then
        local Item = self.Items[self:CurrentSelection()]
        Item:Index(Item._Index + 1)
        self.OnSliderChange(self, Item, Item:Index())
        Item.OnSliderChanged(self, Item, Item._Index)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuSliderProgressItem" then
        local Item = self.Items[self:CurrentSelection()]
        Item:Index(Item._Index + 1)
        self.OnSliderChange(self, Item, Item:Index())
        Item.OnSliderChanged(self, Item, Item._Index)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuProgressItem" then
        local Item = self.Items[self:CurrentSelection()]
        Item:Index(Item.Data.Index + 1)
        self.OnProgressChange(self, Item, Item.Data.Index)
        Item.OnProgressChanged(self, Item, Item.Data.Index)
        PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
    elseif subtype == "UIMenuSliderHeritageItem" then
        local Item = self.Items[self:CurrentSelection()]
        Item:Index(Item._Index + 0.1)
        self.OnSliderChange(self, Item, Item:Index())
        Item.OnSliderChanged(self, Item, Item._Index)
        if not Item.Pressed then
            Item.Pressed = true
            Citizen.CreateThread(function()
                Item.Audio.Id = GetSoundId()
                PlaySoundFrontend(Item.Audio.Id, Item.Audio.Slider, Item.Audio.Library, 1)
                Citizen.Wait(100)
                StopSound(Item.Audio.Id)
                ReleaseSoundId(Item.Audio.Id)
                Item.Pressed = false
            end)
        end
    end
end

---SelectItem
---@return nil
---@public
function UIMenu:SelectItem()
    if not self.Items[self:CurrentSelection()]:Enabled() then
        PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
        return
    end
    local Item = self.Items[self:CurrentSelection()]
    local type, subtype = Item()
    if subtype == "UIMenuCheckboxItem" then
        Item.Checked = not Item.Checked
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnCheckboxChange(self, Item, Item.Checked)
        Item.CheckboxEvent(self, Item, Item.Checked)
    elseif subtype == "UIMenuListItem" then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnListSelect(self, Item, Item._Index)
        Item.OnListSelected(self, Item, Item._Index)
    elseif subtype == "UIMenuSliderItem" then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnSliderSelect(self, Item, Item._Index)
        Item.OnSliderSelected(Item._Index)
    elseif subtype == "UIMenuSliderProgressItem" then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnSliderSelect(self, Item, Item._Index)
        Item.OnSliderSelected(Item._Index)
    elseif subtype == "UIMenuProgressItem" then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnProgressSelect(self, Item, Item.Data.Index)
        Item.OnProgressSelected(Item.Data.Index)
    elseif subtype == "UIMenuSliderHeritageItem" then
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnSliderSelect(self, Item, Item._Index)
        Item.OnSliderSelected(Item._Index)
    else
        PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
        self.OnItemSelect(self, Item, self:CurrentSelection())
        Item.Activated(self, Item)
        if not self.Children[Item] then
            return
        end
        self:Visible(false)
        self.Children[Item]:Visible(true)
        self.OnMenuChanged(self, self.Children[self.Items[self:CurrentSelection()]], true)
    end
end

---GoBack
---@return nil
---@public
function UIMenu:GoBack()
    PlaySoundFrontend(-1, self.Settings.Audio.Back, self.Settings.Audio.Library, true)
    self:Visible(false)
    if self.ParentMenu ~= nil then
        self.ParentMenu:Visible(true)
        self.OnMenuChanged(self, self.ParentMenu, false)
        if self.Settings.ResetCursorOnOpen then
            local W, H = GetActiveScreenResolution()
            SetCursorLocation(W / 2, H / 2)
        end
    end
    self.OnMenuClosed(self)
end

---BindMenuToItem
---@param Menu table
---@param Item table
---@return nil
---@public
function UIMenu:BindMenuToItem(Menu, Item)
    if Menu() == "UIMenu" and Item() == "UIMenuItem" then
        Menu.ParentMenu = self
        Menu.ParentItem = Item
        self.Children[Item] = Menu
    end
end

---ReleaseMenuFromItem
---@param Item table
---@return boolean
---@public
function UIMenu:ReleaseMenuFromItem(Item)
    if Item() == "UIMenuItem" then
        if not self.Children[Item] then
            return false
        end
        self.Children[Item].ParentMenu = nil
        self.Children[Item].ParentItem = nil
        self.Children[Item] = nil
        return true
    end
end

---PageCounterName
---@param text string
---@return nil
---@public
function UIMenu:PageCounterName(String)
    self.PageCounter.isCustom = true
    self.PageCounter.PreText = String
    self.PageCounter.Text:Text(self.PageCounter.PreText)
    self.PageCounter.Text:Draw()
end

---Draw
---@return nil
---@public
function UIMenu:Draw()
    if not self._Visible then
        return
    end
    HideHudComponentThisFrame(19)
    if self.Settings.ControlDisablingEnabled then
        self:DisEnableControls(false)
    end
    if self.Settings.InstructionalButtons then
        DrawScaleformMovieFullscreen(self.InstructionalScaleform, 255, 255, 255, 255, 0)
    end
    if self.Settings.ScaleWithSafezone then
        SetScriptGfxAlign(76, 84)
        SetScriptGfxAlignParams(0, 0, 0, 0)
        if self.Settings.DrawOrder ~= nil then
            SetScriptGfxDrawOrder(tonumber(self.Settings.DrawOrder))
        end
        self.DrawOffset.X, self.DrawOffset.Y = GetScriptGfxPosition(0,0)
    end
    if self.ReDraw then
        self:DrawCalculations()
    end
    if self.Logo then
        self.Logo:Draw()
    elseif self.Banner then
        self.Banner:Draw()
    end
    self.Title:Draw()
    if self.Subtitle.Rectangle then
        self.Subtitle.Rectangle:Draw()
        self.Subtitle.Text:Draw()
    end
    if #self.Items ~= 0 or #self.Windows ~= 0 then
        self.Background:Draw()
    end
    if #self.Windows ~= 0 then
        local WindowOffset = 0
        for index = 1, #self.Windows do
            if self.Windows[index - 1] then
                WindowOffset = WindowOffset + self.Windows[index - 1].Background:Size().Height
            end
            local Window = self.Windows[index]
            Window:Position(WindowOffset + self.Subtitle.ExtraY - 37)
            Window:Draw()
        end
    end
    if #self.Items == 0 then
        if self.Settings.ScaleWithSafezone then
            ResetScriptGfxAlign()
        end
        return
    end

    local CurrentSelection = self:CurrentSelection()
    self.Items[CurrentSelection]:Selected(true)

    if self.Items[CurrentSelection]:Description() ~= "" then
        self.Description.Bar:Draw()
        self.Description.Rectangle:Draw()
        self.Description.Text:Draw()
    end

    if self.Items[CurrentSelection].Panels ~= nil then
        if #self.Items[CurrentSelection].Panels ~= 0 then
            local PanelOffset = self:CaclulatePanelPosition(self.Items[CurrentSelection]:Description() ~= "")
            for index = 1, #self.Items[CurrentSelection].Panels do
                if self.Items[CurrentSelection].Panels[index - 1] then
                    PanelOffset = PanelOffset + self.Items[CurrentSelection].Panels[index - 1].Background:Size().Height + 5
                end
                self.Items[CurrentSelection].Panels[index]:Position(PanelOffset)
                self.Items[CurrentSelection].Panels[index]:Draw()
            end
        end
    end

    local WindowHeight = self:CalculateWindowHeight()

    if #self.Items <= self.Pagination.Total + 1 then
        local ItemOffset = self.Subtitle.ExtraY - 37 + WindowHeight
        for index = 1, #self.Items do
            local Item = self.Items[index]
            Item:Position(ItemOffset)
            Item:Draw()
            ItemOffset = ItemOffset + self:CalculateItemHeightOffset(Item)
        end
    else
        local ItemOffset = self.Subtitle.ExtraY - 37 + WindowHeight
        for index = self.Pagination.Min + 1, self.Pagination.Max, 1 do
            if self.Items[index] then
                local Item = self.Items[index]
                Item:Position(ItemOffset)
                Item:Draw()
                ItemOffset = ItemOffset + self:CalculateItemHeightOffset(Item)
            end
        end

        self.Extra.Up:Draw()
        self.Extra.Down:Draw()
        self.ArrowSprite:Draw()

        if self.PageCounter.isCustom ~= true then
            if self.PageCounter.Text ~= nil then
                local Caption = self.PageCounter.PreText .. CurrentSelection .. " / " .. #self.Items
                self.PageCounter.Text:Text(Caption)
                self.PageCounter.Text:Draw()
            end
        end
    end

    if self.PageCounter.isCustom ~= false then
        if self.PageCounter.Text ~= nil then
            self.PageCounter.Text:Text(self.PageCounter.PreText)
            self.PageCounter.Text:Draw()
        end
    end

    if self.Settings.ScaleWithSafezone then
        ResetScriptGfxAlign()
    end
end

---ProcessMouse
---@return nil
---@public
function UIMenu:ProcessMouse()
    if not self._Visible or self.JustOpened or #self.Items == 0 or tobool(Controller()) or not self.Settings.MouseControlsEnabled then
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 25, true)
        EnableControlAction(0, 24, true)
        if self.Dirty then
            for _, Item in pairs(self.Items) do
                if Item:Hovered() then
                    Item:Hovered(false)
                end
            end
        end
        return
    end

    local WindowHeight = self:CalculateWindowHeight()
    local Limit = #self.Items
    local ItemOffset = 0

    ShowCursorThisFrame()

    if #self.Items > self.Pagination.Total + 1 then
        Limit = self.Pagination.Max
    end

    local W, H = GetResolution()

    if IsMouseInBounds(0, 0, 30, H) and self.Settings.MouseEdgeEnabled then
        SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() + 5)
        SetCursorSprite(6)
    elseif IsMouseInBounds(W - 30, 0, 30, H) and self.Settings.MouseEdgeEnabled then
        SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() - 5)
        SetCursorSprite(7)
    elseif self.Settings.MouseEdgeEnabled then
        SetCursorSprite(1)
    end

    for i = self.Pagination.Min + 1, Limit, 1 do
        local X, Y = self.Position.X, self.Position.Y + 144 - 37 + self.Subtitle.ExtraY + ItemOffset + WindowHeight
        local Item = self.Items[i]
        local Type, SubType = Item()
        local Width, Height = 431 + self.WidthOffset, self:CalculateItemHeightOffset(Item)

        if IsMouseInBounds(X, Y, Width, Height, self.DrawOffset) then
            Item:Hovered(true)
            if not self.Controls.MousePressed then
                if IsDisabledControlJustPressed(0, 24) then
                    Citizen.CreateThread(function()
                        local _X, _Y, _Width, _Height = X, Y, Width, Height
                        self.Controls.MousePressed = true
                        if Item:Selected() and Item:Enabled() then
                            if SubType == "UIMenuListItem" then
                                if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height, self.DrawOffset) then
                                    self:GoLeft()
                                elseif not IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height, self.DrawOffset) then
                                    self:SelectItem()
                                end
                                if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height, self.DrawOffset) then
                                    self:GoRight()
                                elseif not IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height, self.DrawOffset) then
                                    self:SelectItem()
                                end
                            elseif SubType == "UIMenuSliderItem" then
                                if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height, self.DrawOffset) then
                                    self:GoLeft()
                                elseif not IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height, self.DrawOffset) then
                                    self:SelectItem()
                                end
                                if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height, self.DrawOffset) then
                                    self:GoRight()
                                elseif not IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height, self.DrawOffset) then
                                    self:SelectItem()
                                end
                            elseif SubType == "UIMenuSliderProgressItem" then
                                if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height, self.DrawOffset) then
                                    self:GoLeft()
                                elseif not IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height, self.DrawOffset) then
                                    self:SelectItem()
                                end
                                if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height, self.DrawOffset) then
                                    self:GoRight()
                                elseif not IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height, self.DrawOffset) then
                                    self:SelectItem()
                                end
                            elseif SubType == "UIMenuSliderHeritageItem" then
                                if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height, self.DrawOffset) then
                                    self:GoLeft()
                                elseif not IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height, self.DrawOffset) then
                                    self:SelectItem()
                                end
                                if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height, self.DrawOffset) then
                                    self:GoRight()
                                elseif not IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height, self.DrawOffset) then
                                    self:SelectItem()
                                end
                            elseif SubType == "UIMenuProgressItem" then
                                if IsMouseInBounds(Item.Bar.X, Item.Bar.Y - 12, Item.Data.Max, Item.Bar.Height + 24, self.DrawOffset) then
                                    local CursorX, CursorY = ConvertToPixel(GetControlNormal(0, 239), 0)
                                    Item:CalculateProgress(CursorX)
                                    self.OnProgressChange(self, Item, Item.Data.Index)
                                    Item.OnProgressChanged(self, Item, Item.Data.Index)
                                    if not Item.Pressed then
                                        Item.Pressed = true
                                        Citizen.CreateThread(function()
                                            Item.Audio.Id = GetSoundId()
                                            PlaySoundFrontend(Item.Audio.Id, Item.Audio.Slider, Item.Audio.Library, 1)
                                            Citizen.Wait(100)
                                            StopSound(Item.Audio.Id)
                                            ReleaseSoundId(Item.Audio.Id)
                                            Item.Pressed = false
                                        end)
                                    end
                                else
                                    self:SelectItem()
                                end
                            else
                                self:SelectItem()
                            end
                        elseif not Item:Selected() then
                            self:CurrentSelection(i - 1)
                            PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
                            self.OnIndexChange(self, self:CurrentSelection())
                            self.ReDraw = true
                            self:UpdateScaleform()
                        elseif not Item:Enabled() and Item:Selected() then
                            PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
                        end
                        Citizen.Wait(175)
                        while IsDisabledControlPressed(0, 24) and IsMouseInBounds(_X, _Y, _Width, _Height, self.DrawOffset) do
                            if Item:Selected() and Item:Enabled() then
                                if SubType == "UIMenuListItem" then
                                    if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height, self.DrawOffset) then
                                        self:GoLeft()
                                    end
                                    if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height, self.DrawOffset) then
                                        self:GoRight()
                                    end
                                elseif SubType == "UIMenuSliderItem" then
                                    if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height, self.DrawOffset) then
                                        self:GoLeft()
                                    end
                                    if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height, self.DrawOffset) then
                                        self:GoRight()
                                    end
                                elseif SubType == "UIMenuSliderProgressItem" then
                                    if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height, self.DrawOffset) then
                                        self:GoLeft()
                                    end
                                    if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height, self.DrawOffset) then
                                        self:GoRight()
                                    end
                                elseif SubType == "UIMenuSliderHeritageItem" then
                                    if IsMouseInBounds(Item.LeftArrow.X, Item.LeftArrow.Y, Item.LeftArrow.Width, Item.LeftArrow.Height, self.DrawOffset) then
                                        self:GoLeft()
                                    end
                                    if IsMouseInBounds(Item.RightArrow.X, Item.RightArrow.Y, Item.RightArrow.Width, Item.RightArrow.Height, self.DrawOffset) then
                                        self:GoRight()
                                    end
                                elseif SubType == "UIMenuProgressItem" then
                                    if IsMouseInBounds(Item.Bar.X, Item.Bar.Y - 12, Item.Data.Max, Item.Bar.Height + 24, self.DrawOffset) then
                                        local CursorX, CursorY = ConvertToPixel(GetControlNormal(0, 239), 0)
                                        Item:CalculateProgress(CursorX)
                                        self.OnProgressChange(self, Item, Item.Data.Index)
                                        Item.OnProgressChanged(self, Item, Item.Data.Index)
                                        if not Item.Pressed then
                                            Item.Pressed = true
                                            Citizen.CreateThread(function()
                                                Item.Audio.Id = GetSoundId()
                                                PlaySoundFrontend(Item.Audio.Id, Item.Audio.Slider, Item.Audio.Library, 1)
                                                Citizen.Wait(100)
                                                StopSound(Item.Audio.Id)
                                                ReleaseSoundId(Item.Audio.Id)
                                                Item.Pressed = false
                                            end)
                                        end
                                    else
                                        self:SelectItem()
                                    end
                                end
                            elseif not Item:Selected() then
                                self:CurrentSelection(i - 1)
                                PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
                                self.OnIndexChange(self, self:CurrentSelection())
                                self.ReDraw = true
                                self:UpdateScaleform()
                            elseif not Item:Enabled() and Item:Selected() then
                                PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
                            end
                            Citizen.Wait(125)
                        end
                        self.Controls.MousePressed = false
                    end)
                end
            end
        else
            Item:Hovered(false)
        end
        ItemOffset = ItemOffset + self:CalculateItemHeightOffset(Item)
    end

    local ExtraX, ExtraY = self.Position.X, 144 + self:CalculateItemHeight() + self.Position.Y + WindowHeight

    if #self.Items <= self.Pagination.Total + 1 then
        return
    end

    if IsMouseInBounds(ExtraX, ExtraY, 431 + self.WidthOffset, 18, self.DrawOffset) then
        self.Extra.Up:Colour(30, 30, 30, 255)
        if not self.Controls.MousePressed then
            if IsDisabledControlJustPressed(0, 24) then
                Citizen.CreateThread(function()
                    local _ExtraX, _ExtraY = ExtraX, ExtraY
                    self.Controls.MousePressed = true
                    if #self.Items > self.Pagination.Total + 1 then
                        self:GoUpOverflow()
                    else
                        self:GoUp()
                    end
                    Citizen.Wait(175)
                    while IsDisabledControlPressed(0, 24) and IsMouseInBounds(_ExtraX, _ExtraY, 431 + self.WidthOffset, 18, self.DrawOffset) do
                        if #self.Items > self.Pagination.Total + 1 then
                            self:GoUpOverflow()
                        else
                            self:GoUp()
                        end
                        Citizen.Wait(125)
                    end
                    self.Controls.MousePressed = false
                end)
            end
        end
    else
        self.Extra.Up:Colour(0, 0, 0, 200)
    end

    if IsMouseInBounds(ExtraX, ExtraY + 18, 431 + self.WidthOffset, 18, self.DrawOffset) then
        self.Extra.Down:Colour(30, 30, 30, 255)
        if not self.Controls.MousePressed then
            if IsDisabledControlJustPressed(0, 24) then
                Citizen.CreateThread(function()
                    local _ExtraX, _ExtraY = ExtraX, ExtraY
                    self.Controls.MousePressed = true
                    if #self.Items > self.Pagination.Total + 1 then
                        self:GoDownOverflow()
                    else
                        self:GoDown()
                    end
                    Citizen.Wait(175)
                    while IsDisabledControlPressed(0, 24) and IsMouseInBounds(_ExtraX, _ExtraY + 18, 431 + self.WidthOffset, 18, self.DrawOffset) do
                        if #self.Items > self.Pagination.Total + 1 then
                            self:GoDownOverflow()
                        else
                            self:GoDown()
                        end
                        Citizen.Wait(125)
                    end
                    self.Controls.MousePressed = false
                end)
            end
        end
    else
        self.Extra.Down:Colour(0, 0, 0, 200)
    end
end

---AddInstructionButton
---@param button table
---@return nil
---@public
function UIMenu:AddInstructionButton(button)
    if type(button) == "table" and #button == 2 then
        table.insert(self.InstructionalButtons, button)
    end
end

---RemoveInstructionButton
---@param button table
---@return nil
---@public
function UIMenu:RemoveInstructionButton(button)
    if type(button) == "table" then
        for i = 1, #self.InstructionalButtons do
            if button == self.InstructionalButtons[i] then
                table.remove(self.InstructionalButtons, i)
                break
            end
        end
    else
        if tonumber(button) then
            if self.InstructionalButtons[tonumber(button)] then
                table.remove(self.InstructionalButtons, tonumber(button))
            end
        end
    end
end

---AddEnabledControl
---@param Inputgroup number
---@param Control number
---@param Controller table
---@return nil
---@public
function UIMenu:AddEnabledControl(Inputgroup, Control, Controller)
    if tonumber(Inputgroup) and tonumber(Control) then
        table.insert(self.Settings.EnabledControls[(Controller and "Controller" or "Keyboard")], { Inputgroup, Control })
    end
end

---RemoveEnabledControl
---@param Inputgroup number
---@param Control number
---@param Controller table
---@return nil
---@public
function UIMenu:RemoveEnabledControl(Inputgroup, Control, Controller)
    local Type = (Controller and "Controller" or "Keyboard")
    for Index = 1, #self.Settings.EnabledControls[Type] do
        if Inputgroup == self.Settings.EnabledControls[Type][Index][1] and Control == self.Settings.EnabledControls[Type][Index][2] then
            table.remove(self.Settings.EnabledControls[Type], Index)
            break
        end
    end
end

---UpdateScaleform
---@return nil
---@public
function UIMenu:UpdateScaleform()
    if not self._Visible or not self.Settings.InstructionalButtons then
        return
    end

    PushScaleformMovieFunction(self.InstructionalScaleform, "CLEAR_ALL")
    PopScaleformMovieFunction()

    PushScaleformMovieFunction(self.InstructionalScaleform, "TOGGLE_MOUSE_BUTTONS")
    PushScaleformMovieFunctionParameterInt(0)
    PopScaleformMovieFunction()

    PushScaleformMovieFunction(self.InstructionalScaleform, "CREATE_CONTAINER")
    PopScaleformMovieFunction()

    PushScaleformMovieFunction(self.InstructionalScaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, 176, 0))
    PushScaleformMovieFunctionParameterString(GetLabelText("HUD_INPUT2"))
    PopScaleformMovieFunction()

    if self.Controls.Back.Enabled then
        PushScaleformMovieFunction(self.InstructionalScaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(1)
        PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, 177, 0))
        PushScaleformMovieFunctionParameterString(GetLabelText("HUD_INPUT3"))
        PopScaleformMovieFunction()
    end

    local count = 2

    for i = 1, #self.InstructionalButtons do
        if self.InstructionalButtons[i] then
            if #self.InstructionalButtons[i] == 2 then
                PushScaleformMovieFunction(self.InstructionalScaleform, "SET_DATA_SLOT")
                PushScaleformMovieFunctionParameterInt(count)
                PushScaleformMovieMethodParameterButtonName(self.InstructionalButtons[i][1])
                PushScaleformMovieFunctionParameterString(self.InstructionalButtons[i][2])
                PopScaleformMovieFunction()
                count = count + 1
            end
        end
    end

    PushScaleformMovieFunction(self.InstructionalScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PushScaleformMovieFunctionParameterInt(-1)
    PopScaleformMovieFunction()
end

