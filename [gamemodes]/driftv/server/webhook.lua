local driftAttack = "https://discord.com/api/webhooks/801884401541316678/0Qe7tOnU7WvZ5LGsEUwd44j1q6IVnboXITWxkUchNVhMNLO6Hh9XxuvpZjneCjZzhyVJ"
local driftAttackAvatar = "https://cdn.discordapp.com/attachments/582120765923524619/801897092871225404/ned-souris-rx-rdrift.png"

local driftPictures = {
    ["Ebisu Drift race"] = "https://media.discordapp.net/attachments/582120765923524619/801903880848932934/image1.png?width=810&height=456",
    ["Haruna Drift Race"] = "https://cdn.discordapp.com/attachments/582120765923524619/801910205092069426/YVFnj-8pQidSspuOsP0rpw.png",
    ["Iro Drift Race"] = "https://cdn.discordapp.com/attachments/582120765923524619/801910684346482789/Screenshot_d1nz_jesse_sost_irohazaka_11-8-120-12-34-14-1024x576.png",
    ["Hakone Ohiradai"] = "https://cdn.discordapp.com/attachments/582120765923524619/801910885501239336/maxresdefault.png",
    ["Hakone Nanamagari"] = "https://cdn.discordapp.com/attachments/582120765923524619/801911015226605618/Hakone-Nanamagari3.png",
}


local webhooks = {
    ["general_fr"] = "https://discordapp.com/api/webhooks/803641935901229066/Xtb1JEzDZ7EYMG8q1fGMFgpZHNKWRGXCnWCbhoVhS7m5RBjF7HbUyt2nkSH7muuLqRPn",
    ["general_en"] = "https://discordapp.com/api/webhooks/803642071403331584/Hn3oC7wjtBGwUt_nBN32HjTzX-aMdhXGua3O9F-APVsOxsPswKTXZBzN7v1tIUVq7Ozp",
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
                ["text"] = "DriftV",
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
