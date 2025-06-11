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

function VNCore.RegisterUsableItem(item, cb)
    Core.UsableItemsCallbacks[item] = cb
end

function VNCore.UseItem(source, item, ...)
    if VNCore.Items[item] then
        local itemCallback = Core.UsableItemsCallbacks[item]

        if itemCallback then
            local success, result = pcall(itemCallback, source, item, ...)

            if not success then
                return result and print(result) or print(('[^3WARNING^7] An error occured when using item ^5"%s"^7! This was not caused by VNCore.'):format(item))
            end
        end
    else
        print(('[^3WARNING^7] Item ^5"%s"^7 was used but does not exist!'):format(item))
    end
end

function VNCore.GetItems()
    return VNCore.Items
end

function VNCore.GetUsableItems()
    local Usables = {}
    for k in pairs(Core.UsableItemsCallbacks) do
        Usables[k] = true
    end
    return Usables
end

function VNCore.RegisterPlayerFunctionOverrides(index, overrides)
    Core.PlayerFunctionOverrides[index] = overrides
end

function VNCore.SetPlayerFunctionOverride(index)
    if not index or not Core.PlayerFunctionOverrides[index] then
        return print("[^3WARNING^7] No valid index provided.")
    end

    Config.PlayerFunctionOverride = index
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