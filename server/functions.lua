function VNCore.GetPlayerFromId(source)
    return VNCore.Players[tonumber(source)]
end

function VNCore.GetIdentifier(playerId)
    local fxDk = GetConvarInt("sv_fxdkMode", 0)
    if fxDk == 1 then
        return "ESX-DEBUG-LICENCE"
    end

    playerId = tostring(playerId)

    local identifier = GetPlayerIdentifierByType(playerId, "license")
    return identifier and identifier:gsub("license:", "")
end