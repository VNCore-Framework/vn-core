function onPlayerJoined(playerId)
    local identifier = VNCore.GetIdentifier(playerId)
    if not identifier then
        return DropPlayer(playerId, "Không tìm thấy mã định danh tài khoản")
    end

    if VNCore.GetPlayerFromIdentifier(identifier) then
        DropPlayer(playerId, "Có ai đó đang sử dụng tài khoản của bạn")
    else
        local result = MySQL.scalar.await("SELECT 1 FROM vn_users WHERE identifier = ?", { identifier })
        if result then
            LoadAccount(playerId, identifier)
        else
            CreateAccount(playerId, identifier)
        end
    end
end

function LoadAccount(source, identifier, isNew)
    local userData = {
        source = source,
        identifier = identifier,
        name = GetPlayerName(source),
        accounts = {},
        roles = {},
        inventory = {},
        metadata = {},
    }

    local result = MySQL.prepare.await("SELECT `name`, `accounts`, `roles`, `inventory`, `metadata`, `position`, `skin` FROM `vn_users` WHERE identifier = ?", { identifier })

    local accounts = result.accounts
    accounts = (accounts and accounts ~= "") and json.decode(accounts) or {}

    for account, data in pairs(Shared.Accounts) do
        data.round = data.round or data.round == nil
        local index = #userData.accounts + 1
        userData.accounts[index] = {
            name = account,
            money = accounts[account] or Shared.StartingAccountMoney[account] or 0,
            label = data.label,
            index = index,
        }
    end

    userData.roles = json.decode(result.roles)

    userData.name = result.name ~= "" and result.name or GetPlayerName(source)
    userData.inventory = json.decode(result.inventory) or {}
    userData.metadata = (result.metadata and result.metadata ~= "") and json.decode(result.metadata) or {}
    userData.position = result.position and json.decode(result.position) or Shared.DefaultSpawns[math.random(1, #Shared.DefaultSpawns)]
    userData.skin = result.skin and json.decode(result.skin) or {
        sex = 0
    }

    local xPlayer = createPlayerData(source, identifier, userData.name, userData.accounts, userData.roles, userData.inventory, userData.metadata, userData.position, userData.skin)

    VNCore.Players[source] = xPlayer
    Core.playersByIdentifier[identifier] = xPlayer

    TriggerEvent("vncore:loaded", source, xPlayer, isNew)
    xPlayer.triggerEvent("vncore:loaded", userData, isNew)

    if setPlayerInventory then
        setPlayerInventory(source, xPlayer, userData.inventory, isNew)
    end
    print(('[^2INFO^0] Player ^5"%s"^0 has connected to the server. ID: ^5%s^7'):format(xPlayer.getName(), source))
end

function CreateAccount(source, identifier)
    local accounts = {}
    local roles = Shared.RolesTable

    for account, money in pairs(Shared.StartingAccountMoney) do
        accounts[account] = money
    end

    for k, v in pairs(roles) do
        roles[k].name = v.name
        roles[k].grade = v.grade
        roles[k].label = Shared.Jobs[v.name].label
        roles[k].grade_label = Shared.Jobs[v.name].grades[tostring(v.grade)].name
        roles[k].isduty = false
        roles[k].isboss = false
    end

    local parameters = { 
        GetPlayerName(source), 
        json.encode(accounts), 
        json.encode(roles),
        identifier 
    }

    MySQL.prepare("INSERT INTO `vn_users` SET `name` = ?, `accounts` = ?, `roles` = ?, `identifier` = ?", parameters, function()
        LoadAccount(source, identifier, true)
    end)
end

RegisterNetEvent("vncore:joined", function()
    local _source = source
    while not next(VNCore.Jobs) do
        Wait(50)
    end

    if not VNCore.Players[_source] then
        onPlayerJoined(_source)
    end
end)

AddEventHandler("vncore:loaded", function(_, xPlayer)

end)

AddEventHandler("onResourceStop", function(resource)
    if Core.Events[resource] then
        for i = 1, #Core.Events[resource] do
            RemoveEventHandler(Core.Events[resource][i])
        end
    end
end)

AddEventHandler("playerDropped", function(reason)
    local playerId = source
    local xPlayer = VNCore.GetPlayerFromId(playerId)

    if xPlayer then
        TriggerEvent("vncore:logout", playerId, reason)

        Core.playersByIdentifier[xPlayer.identifier] = nil

        Core.SavePlayer(xPlayer, function()
            VNCore.Players[playerId] = nil
        end)
    end
end)