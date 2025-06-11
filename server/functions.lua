function VNCore.GetPlayerFromId(source)
    return VNCore.Players[tonumber(source)]
end

function VNCore.GetPlayerFromIdentifier(identifier)
    return Core.playersByIdentifier[identifier]
end

function VNCore.GetIdentifier(playerId)
    local fxDk = GetConvarInt("sv_fxdkMode", 0)
    if fxDk == 1 then
        return "VNCORE-DEBUG-LICENCE"
    end

    playerId = tostring(playerId)

    local identifier = GetPlayerIdentifierByType(playerId, "license")
    return identifier and identifier:gsub("license:", "")
end

function Core.SavePlayer(xPlayer, cb)
    if not xPlayer.spawned then
        return cb and cb()
    end

    MySQL.prepare(
        "UPDATE `users` SET `name` = ?, `accounts` = ?, `position` = ?, `inventory` = ?, `metadata` = ?, `skin` = ? WHERE `identifier` = ?",
        {
            xPlayer.getName(),
            json.encode(xPlayer.getAccounts(true)),
            json.encode(xPlayer.getCoords(false, true)),
            json.encode(xPlayer.getInventory(true)),
            json.encode(xPlayer.getMeta()),
            json.encode(xPlayer.getSkin()),
            xPlayer.identifier,
        },
        function(affectedRows)
            if affectedRows == 1 then
                print(('[^2INFO^7] Saved player ^5"%s^7"'):format(xPlayer.name))
            end
            if cb then
                cb()
            end
        end
    )
end