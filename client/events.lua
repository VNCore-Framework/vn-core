VNCore.SecureNetEvent('vncore:updatePlayerData', function(key, val)
	VNCore.SetPlayerData(key, val)
end)

VNCore.SecureNetEvent("vncore:setAccountMoney", function(account)
    for i = 1, #VNCore.PlayerData.accounts do
        if VNCore.PlayerData.accounts[i].name == account.name then
            VNCore.PlayerData.accounts[i] = account
            break
        end
    end

    VNCore.SetPlayerData("accounts", VNCore.PlayerData.accounts)
end)

VNCore.SecureNetEvent("vncore:setRole", function(name, role, lastRole)
    local currentRole = VNCore.PlayerData

    currentRole[name] = role

    ESX.SetPlayerData("roles", currentRole)
end)

RegisterNetEvent("vncore:loaded", function(xPlayer, _)
    VNCore.PlayerData = xPlayer
    
    VNCore.SpawnPlayer(VNCore.PlayerData.skin, VNCore.PlayerData.position, function()
        TriggerEvent("vncore:onPlayerSpawn")
        TriggerServerEvent("vncore:onPlayerSpawn")
    end)

    while not DoesEntityExist(VNCore.PlayerData.ped) do
        Wait(20)
    end

    VNCore.PlayerLoaded = true

    local timer = GetGameTimer()
    while not HaveAllStreamingRequestsCompleted(VNCore.PlayerData.ped) and (GetGameTimer() - timer) < 2000 do
        Wait(0)
    end

    ClearPedTasksImmediately(VNCore.PlayerData.ped)

    Core.FreezePlayer(false)

    if IsScreenFadedOut() then
        DoScreenFadeIn(500)
    end

    NetworkSetLocalPlayerSyncLookAt(true)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end)

local function onPlayerSpawn()
    VNCore.SetPlayerData("ped", PlayerPedId())
    VNCore.SetPlayerData("dead", false)
end

AddEventHandler("playerSpawned", onPlayerSpawn)
AddEventHandler("vncore:onPlayerSpawn", function()
    onPlayerSpawn()
end)