function VNCore.DisableSpawnManager()
    if GetResourceState("spawnmanager") == "started" then
        exports.spawnmanager:setAutoSpawn(false)
    end
end