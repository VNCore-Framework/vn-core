RegisterNetEvent("vncore:onPlayerSpawn", function()
    VNCore.Players[source].spawned = true
end)

AddEventHandler("vncore:setRole", function(_, name, role, lastRole)

end)

AddEventHandler("txAdmin:events:scheduledRestart", function(eventData)
    if eventData.secondsRemaining == 60 then
        CreateThread(function()
            Wait(50000)
            Core.SavePlayers()
        end)
    end
end)

AddEventHandler("txAdmin:events:serverShuttingDown", function()
    Core.SavePlayers()
end)