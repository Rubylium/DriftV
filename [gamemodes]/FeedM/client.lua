local MESSAGES    = {}
local WAITTIME    = 500
local COUNTER     = 1
local CANQUEUE    = Config.Queue > 0
local QUEUE       = 0
local QUEUED      = {}
local POSITION    = Config.Positions[Config.Position]
local TOP         = string.match(Config.Position, "top") or POSITION.y < 0.5


--====================================================================================================================
--                                                    THREADS                                                      --
--====================================================================================================================

function InitThreads()

    --==================================================================================
    -- MAIN RENDER THREAD
    --==================================================================================
    Citizen.CreateThread(function()
        while true do

            local PosX = POSITION.x - (Config.Width / 2)
            local PosY = 0
            local X1 = PosX + Config.Padding
            local X2 = (POSITION.x + (Config.Width / 2)) - Config.Padding

            for i,Message in ipairs(MESSAGES) do
                if not Message.Hidden then

                    --==================================================================================
                    -- WAIT FOR THE SET INTERVAL TO BEGIN THE FADEOUT ANIMATION
                    --==================================================================================
                    if not Message.Ready then
                        -- Need to find the correct feed message sound to play here
                        -- PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

                        Message.Ready = true
                        Citizen.SetTimeout(Message.Interval, function()
                            --==================================================================================
                            -- FLAG MESSAGE FOR FADEOUT
                            --==================================================================================                            
                            Message.StartHiding = true
                        end)
                    end
                    --==================================================================================
                    -- MESSAGE IS FLAGGED FOR FADEOUT
                    --==================================================================================  
                    if Message.StartHiding then
                        if Config.Animation then
                            Message.Opacity.Box.Current = math.ceil(Message.Opacity.Box.Current - Message.Opacity.Box.Increment)
                            Message.Opacity.Text.Current = math.ceil(Message.Opacity.Text.Current - Message.Opacity.Text.Increment)

                            if Message.Opacity.Box.Current <= 0 or Message.Opacity.Text.Current <= 0 then
                                Message.Opacity.Box.Current = 0
                                Message.Opacity.Text.Current = 0

                                Message.Hidden = true
                            end
                        else
                            Message.Hidden = true
                        end                           
                    end

                    Message.Offset = Message.y + PosY

                    --==================================================================================
                    -- STACKING
                    --==================================================================================  
                    if Config.Animation then
                        if TOP then
                            if Message.ny <= Message.Offset then
                                Message.ny = Message.ny + 0.008
                            end

                            if Message.ny > Message.Offset then
                                Message.ny = Message.Offset
                            end
                        else
                            if Message.ny >= Message.Offset then
                                Message.ny = Message.ny - 0.008
                            end
        
                            if Message.ny < Message.Offset then
                                Message.ny = Message.Offset
                            end
                        end
                    else
                        Message.ny = Message.Offset
                    end                   
  
                    --==================================================================================
                    -- RENDER THE MESSAGE
                    --==================================================================================  
                    if Message.Advanced then -- ADVANCED NOTIFICATION   

                        --==================================================================================
                        -- RENDER THE BACKGROUND
                        --==================================================================================  
                        DrawSprite(
                            'commonmenu',
                            'gradient_bgd',
                            POSITION.x, 
                            Message.ny, 
                            Config.Width, 
                            Message.BoxHeight,
                            -90.0,
                            Message.BG.r, 
                            Message.BG.g, 
                            Message.BG.b,
                            Message.Opacity.Box.Current
                        )                        
                        
                        --==================================================================================
                        -- RENDER THE ICON
                        --==================================================================================                          
                        if Message.Icon.Ready then               
                            -- DRAW ICON
                            DrawSprite(
                                Message.Icon.Thumb,
                                Message.Icon.Thumb,
                                PosX + (Message.Icon.W / 2), 
                                Message.ny - (Message.BoxHeight / 2) + (Message.Icon.H / 2), 
                                Message.Icon.W, 
                                Message.Icon.H, 
                                0.0, 255, 255, 255, Message.Opacity.Box.Current
                            )
                        end                       
                            
                        --==================================================================================
                        -- RENDER THE TITLE
                        --==================================================================================   
                        RenderText(Message.Title,
                            (Config.Padding + POSITION.x - (Config.Width / 2)) + Message.Icon.W,
                            (Message.ny - (Message.BoxHeight / 2) + Config.Padding) - 0.004,
                            Message.Opacity.Text.Current, 
                            X1 + Message.Icon.W, 
                            X2
                        )   

                        --==================================================================================
                        -- RENDER THE SUBJECT
                        --==================================================================================   
                        RenderText(Message.Subject,
                            (Config.Padding + POSITION.x - (Config.Width / 2)) + Message.Icon.W,
                            ((Message.ny - (Message.BoxHeight / 2) + Config.Padding) - 0.004) + TextHeight,
                            Message.Opacity.Text.Current, 
                            X1 + Message.Icon.W, 
                            X2
                        )                       

                        --==================================================================================
                        -- RENDER THE MESSAGE
                        --==================================================================================   
                        RenderText(Message.Message,
                            Config.Padding + POSITION.x - (Config.Width / 2),
                            (Message.ny - (Message.BoxHeight / 2)) + Message.Icon.H + Config.Padding,
                            Message.Opacity.Text.Current, 
                            X1, 
                            X2
                        )    

                        --==================================================================================
                        -- OFFSET THE POSITION BY THE MESSAGE HEIGHT
                        --==================================================================================   
                        if TOP then
                            PosY = PosY + Message.BoxHeight + Config.Spacing
                        else
                            PosY = PosY - Message.BoxHeight - Config.Spacing
                        end

                    else  -- STANDARD NOTIFICATION
                        
                        --==================================================================================
                        -- RENDER THE BACKGROUND
                        --==================================================================================  
                        DrawSprite(
                            'commonmenu',
                            'gradient_bgd',
                            POSITION.x, 
                            Message.ny, 
                            Config.Width, 
                            Message.Height,
                            -90.0, 
                            Message.BG.r, 
                            Message.BG.g, 
                            Message.BG.b, 
                            Message.Opacity.Box.Current
                        )                         

                        --==================================================================================
                        -- RENDER THE MESSAGE
                        --==================================================================================  
                        RenderText(Message.Message,
                            Config.Padding + POSITION.x - (Config.Width / 2),
                            ((Message.ny - (Message.Height / 2)) + Config.Padding) - 0.004,
                            Message.Opacity.Text.Current, 
                            X1, 
                            X2
                        )
                        
                        --==================================================================================
                        -- OFFSET THE POSITION BY THE MESSAGE HEIGHT
                        --==================================================================================   
                        if TOP then
                            PosY = PosY + Message.Height + Config.Spacing
                        else
                            PosY = PosY - Message.Height - Config.Spacing
                        end
                    end

                    --==================================================================================
                    -- FLAG MESSAGE FOR REMOVAL
                    --==================================================================================   
                    if Message.Hidden then
                        Citizen.SetTimeout(2000, function()
                            Message.Remove = true
                        end)
                    end                

                end
            end

            Citizen.Wait(WAITTIME)
        end
    end)

    --==================================================================================
    -- CLEAN-UP THREAD
    --==================================================================================
    Citizen.CreateThread(function()
        while true do
            for i,Message in ipairs(MESSAGES) do
                if Message.Hidden and Message.Remove then

                    --==================================================================================
                    -- UPDATE QUEUE
                    --==================================================================================
                    QUEUE = QUEUE - 1

                    --==================================================================================
                    -- REMOVE THE MESSAGE
                    --==================================================================================
                    table.remove(MESSAGES, i)
                end
            end

            --==================================================================================
            -- INCREASE WAIT TIME IF NO MESSAGES ARE ACTIVE
            --==================================================================================
            if #MESSAGES > 0 then
                WAITTIME = 0
            else
                WAITTIME = 1000
            end

            Citizen.Wait(WAITTIME)
        end
    end)

    --==================================================================================
    -- QUEUE THREAD
    --==================================================================================
    Citizen.CreateThread(function()
        while true do
            for i,Message in ipairs(QUEUED) do
                if QUEUE < Config.Queue then
                    if Message.Advanced then
                        BuildMessage(Message.Message, Message.Interval, Message.Type, true, Message.Title, Message.Subject, Message.Icon)
                    else
                        BuildMessage(Message.Message, Message.Interval, Message.Type)
                    end

                    table.remove(QUEUED, i)
                end
            end

            Citizen.Wait(WAITTIME)
        end
    end)    
end

--==================================================================================
-- START THREADS IF ENABLED
--==================================================================================
if Config.Enabled then
    InitThreads()
end


--====================================================================================================================
--                                                   FUNCTIONS                                                      --
--====================================================================================================================

function BuildMessage(Message, Interval, Type, Advanced, Title, Subject, Icon)

    if Message == nil then
        Message = '~r~ERROR : ~s~The text of the notification is nil.'
    end

    if type(Message) ~= "string" and type(Message) ~= "number" then
        print("NOT A STRING", Message)
        return false
    end
    
    
    --==================================================================================
    -- DUPLICATE CHECK
    --==================================================================================
    if Config.FilterDuplicates then
        for k, v in ipairs(MESSAGES) do
            if Advanced then
                if v.Title == Title and v.Message == Message and v.Subject == Subject and v.Icon.Thumb == Icon then
                    return false
                end
            else
                if v.Message == Message then
                    return false
                end
            end
        end    
    end    

    WAITTIME = 0

    Interval = Interval or 5000

    local BG = Config.Types.primary

    if Type ~= nil then
        BG = Config.Types[Type]

        if BG == nil then
            print("======================================================")
            print("FeedM ERROR: Invalid notification type (".. Type ..")!")
            print("======================================================")
            return
        end
    end    

    if type(Icon) == "number" then
        -- User player headshot as icon
        Citizen.CreateThread(function()
            local hs = RegisterPedheadshot(Icon)
            while not IsPedheadshotReady(hs) or not IsPedheadshotValid(hs) do
                Citizen.Wait(0)
            end
            Icon = GetPedheadshotTxdString(hs)
            AddMessage(Message, Interval, BG, Advanced, Title, Subject, Icon) 
        end)
    else
        AddMessage(Message, Interval, BG, Advanced, Title, Subject, Icon) 
    end
end

function QueueMessage(Message, Interval, Type, Advanced, Title, Subject, Icon)
    local Data = {
        Title = Title, Subject = Subject, Icon = Icon, Message = Message, Interval = Interval, Type = Type, Advanced = Advanced
    }

    table.insert(QUEUED, Data)
end

function AddMessage(Message, Interval, BG, Advanced, Title, Subject, Icon)

    local Data = {
        Advanced = Advanced,
        Title = Title,
        Subject = Subject,
        Icon = {
            Thumb = Icon,
            Ready = false,
            W = 0,
            H = 0
        },
        Index = COUNTER,
        Message = Message,
        Interval = Interval,
        BG = BG,
        Hiding = false,
        y = POSITION.y,
        ny = POSITION.y,
        Opacity = {
            Text = { Current = 255, Increment = 255 / 20},
            Box = { Current = BG.a, Increment = BG.a / 20},
        }
    }

    -- GET MESSAGE HEIGHT
    Data.Height = GetMessageHeight(Data, Config.Padding + POSITION.x - (Config.Width / 2), POSITION.y)   

    -- ADVANCED NOTIFICATION ICON
    if Advanced then
        local width, height = GetActiveScreenResolution()
        local size = 0.028
        Data.Icon.W = (size * width) / width
        Data.Icon.H = (size * width) / height 
        
        Data.BoxHeight = Data.Icon.H + Data.Height + Config.Padding

        -- LOAD TEXTURE DICTIONARY
        if not HasStreamedTextureDictLoaded(Icon) then
            RequestStreamedTextureDict(Icon)

            while not HasStreamedTextureDictLoaded(Icon) do
                Citizen.Wait(1)
            end
        end

        Data.Icon.Ready = true

        if TOP then
            Data.y = Data.y + (Data.BoxHeight / 2)
            Data.ny = Data.ny + (Data.BoxHeight / 2)
        else
            Data.y = Data.y - (Data.BoxHeight / 2)
            Data.ny = Data.ny - (Data.BoxHeight / 2)
        end 
    else
        if TOP then
            Data.y = Data.y + (Data.Height / 2)
            Data.ny = Data.ny + (Data.Height / 2)
        else
            Data.y = Data.y - (Data.Height / 2)
            Data.ny = Data.ny - (Data.Height / 2)
        end      
    end


    -- ENABLE MESSAGE DISPLAY
    table.insert(MESSAGES, 1, Data)

    -- UPDATE QUEUE
    QUEUE = QUEUE + 1

    -- UPDATE COUNTER
    COUNTER = COUNTER + 1    
end

function ShowNotification(Message, Interval, Type)
    if Config.Enabled then
        if CANQUEUE and QUEUE > Config.Queue - 1 then
            QueueMessage(Message, Interval, Type)
        else
            BuildMessage(Message, Interval, Type)
        end
    end
end

function ShowAdvancedNotification(Title, Subject, Message, Icon, Interval, Type)
    if Config.Enabled then
        if not Icon then
            Icon = 'CHAR_BLANK_ENTRY'
        end
        if CANQUEUE and QUEUE > Config.Queue - 1 then
            QueueMessage(Message, Interval, Type, true, Title, Subject, Icon)
        else
            BuildMessage(Message, Interval, Type, true, Title, Subject, Icon)
        end        
    end
end


--====================================================================================================================
--                                                    EXPORTS                                                      --
--====================================================================================================================

exports('ShowNotification', ShowNotification)
exports('ShowAdvancedNotification', ShowAdvancedNotification)


--====================================================================================================================
--                                                     EVENTS                                                      --
--====================================================================================================================

RegisterNetEvent('FeedM:showNotification')
AddEventHandler("FeedM:showNotification", function(Message, Interval, Type)
    ShowNotification(Message, Interval, Type)
end)

RegisterNetEvent('FeedM:showAdvancedNotification')
AddEventHandler("FeedM:showAdvancedNotification", function(Title, Subject, Message, Icon, Interval, Type)
    ShowAdvancedNotification(Title, Subject, Message, Icon, Interval, Type)
end)