VNCore.PlayerData = {}
VNCore.PlayerLoaded = false
VNCore.playerId = PlayerId()
VNCore.serverId = GetPlayerServerId(VNCore.playerId)
VNCore.Game = {}
VNCore.Streaming = {}

Core = {}
Core.Events = {}

CreateThread(function()
    while true do
        Wait(100)
        if NetworkIsPlayerActive(VNCore.playerId) then
            VNCore.DisableSpawnManager()
            DoScreenFadeOut(0)
            Wait(500)
            TriggerServerEvent("vncore:joined")
            break
        end
    end
end)