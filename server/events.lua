RegisterNetEvent("vncore:onPlayerSpawn", function()
    VNCore.Players[source].spawned = true
    print('VNCore.Players[source].spawned', VNCore.Players[source].spawned)
end)