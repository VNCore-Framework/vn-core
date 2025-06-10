VNCore.Players = {}
VNCore.Jobs = Shared.Jobs

RegisterNetEvent("vncore:joined", function()
    local _source = source
    while not next(VNCore.Jobs) do
        Wait(50)
    end

    if not VNCore.Players[_source] then
        
    end
end)