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

function GroupDigits(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. (' ')):reverse())..right
end
