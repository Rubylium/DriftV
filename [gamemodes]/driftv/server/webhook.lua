local driftAttack = Config.DriftAttackWebhook
local driftAttackAvatar = Config.DriftAttackWebhookAvatar

local driftPictures = Config.driftPictures


local webhooks = {
    ["crew_war"] = Config.CrewWarWebhook,
}

function SendTextToWebhook(webhook, color, title, text)
    if webhooks[webhook] == nil then
        debugPrint("Error! the webhook " ..tostring(webhook).." do not exist/is not registered!")
        return
    end
    
    local content = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] = text,
            ["footer"] = {
                ["text"] = "DriftV - Competitive FiveM drift server",
            },
        }
    }

    PerformHttpRequest(webhooks[webhook], function(err, text, headers) end, 'POST', json.encode({embeds = content, avatar_url = driftAttackAvatar}), { ['Content-Type'] = 'application/json' })
end

function SendDriftAttackScore(source, oldPlayer, scores, OldScore, place, race, car)
    local connect = {
        {
            ["color"] = 0x00ff44,
            ["title"] = "**Drift Attack!**",
            ["description"] = "[**#"..place.."**] *"..race.."* New scores!\n ``"..oldPlayer.."`` got beaten by ``"..GetPlayerName(source).."`` with "..GroupDigits(math.floor(scores)).." points with ``".. car .."``!\n\n```diff\n".. oldPlayer .." old score: "..GroupDigits(math.floor(OldScore)).."\n"..GetPlayerName(source).." new score: " .. GroupDigits(math.floor(scores)) .. "\n+ ".. GroupDigits(math.floor(scores - OldScore)) .."```",
            ["footer"] = {
                ["text"] = "DriftV - "..race,
            },
        }
    }
    if driftPictures[race] ~= nil then
        connect[1]["thumbnail"] = {
            ["url"] = driftPictures[race]
        }
    end
    PerformHttpRequest(driftAttack, function(err, text, headers) end, 'POST', json.encode({embeds = connect, avatar_url = driftAttackAvatar}), { ['Content-Type'] = 'application/json' })
end
