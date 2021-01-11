function GetLicense(id)
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            return v
        end
    end
end

function debugPrint(text)
    print("^3DriftV: ^7"..text)
end

RegisterNetEvent("DeleteEntity")
AddEventHandler("DeleteEntity", function(ent)
    DeleteEntity(NetworkGetEntityFromNetworkId(ent)) 
end)