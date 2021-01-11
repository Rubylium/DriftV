TextHeight = GetTextScaleHeight(Config.Scale, Config.Font)

function GetCharacterCount(string)
    local len = 0

    -- https://devforum.roblox.com/t/utf8-charpattern-uses-an-invalid-escape-sequence-and-is-incorrect/297078
    for c in string:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        len = len + 1
    end

    return len
end

function GetLineCount(Text, X, Y, X1, X2)
    SetTextFont(Config.Font)
    SetTextScale(Config.Scale, Config.Scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextWrap(X1, X2)

    BeginTextCommandLineCount("STRING")

    local chars = GetCharacterCount(Text)
    if chars < 100 then
        AddTextComponentSubstringPlayerName(Text)
    else
        local len = (chars % 100 == 0) and chars / 100 or (chars / 100) + 1
        for i = 0, len do
            AddTextComponentSubstringPlayerName(Text:sub(i * 100, (i * 100) + 100))
        end
    end

    return EndTextCommandGetLineCount(X, Y)
end

function GetMessageHeight(Message, X, Y)
    local Lines = GetLineCount(Message.Message,
        X,
        Y,
        (Config.Positions[Config.Position].x - (Config.Width / 2)) + Config.Padding, 
        (Config.Positions[Config.Position].x + (Config.Width / 2)) - Config.Padding                            
    ) 

    Message.Lines = Lines  

    return (TextHeight * Lines) + (Config.Padding * 2)
end

function RenderText(Text, X, Y, A, X1, X2)
    SetTextWrap(X1, X2)
    SetTextFont(Config.Font)
    SetTextProportional(true)
    SetTextScale(Config.Scale, Config.Scale)
    SetTextColour(255, 255, 255, A)
    SetTextDropShadow(0, 0, 0, 0, A)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, A)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentSubstringPlayerName(Text)
    DrawText(X, Y)
end