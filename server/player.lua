function createPlayerData(source, identifier, name, accounts, roles, inventory, metadata, position, skin)
    local self = {}

    self.source = source
    self.identifier = identifier
    self.name = name
    self.accounts = accounts
    self.roles = roles
    self.metadata = metadata
    self.position = position
    self.inventory = inventory
    self.skin = skin
    self.maxWeight = Shared.MaxWeight
    
    function self.getIdentifier()
        return self.identifier
    end

    function self.triggerEvent(eventName, ...)
        assert(type(eventName) == "string", "eventName should be string!")
        TriggerClientEvent(eventName, self.source, ...)
    end

    function self.getName()
        return self.name
    end

    function self.getAccounts(minimal)
        if not minimal then
            return self.accounts
        end
        local minimalAccounts = {}
        for i = 1, #self.accounts do
            minimalAccounts[self.accounts[i].name] = self.accounts[i].money
        end
        return minimalAccounts
    end

    function self.getAccount(account)
        account = string.lower(account)
        for i = 1, #self.accounts do
            local accountName = string.lower(self.accounts[i].name)
            if accountName == account then
                return self.accounts[i]
            end
        end
        return nil
    end

    function self.setAccountMoney(accountName, money, reason)
        reason = reason or "unknown"
        if not tonumber(money) then
            error(("Tried To Set Account ^5%s^1 For Player ^5%s^1 To An Invalid Number -> ^5%s^1"):format(accountName, self.playerId, money))
            return
        end
        if money >= 0 then
            local account = self.getAccount(accountName)

            if account then
                money = account.round and VNCore.Math.Round(money) or money
                self.accounts[account.index].money = money

                self.triggerEvent("vncore:setAccountMoney", account)
                TriggerEvent("vncore:setAccountMoney", self.source, accountName, money, reason)
            else
                error(("Tried To Set Invalid Account ^5%s^1 For Player ^5%s^1!"):format(accountName, self.playerId))
            end
        else
            error(("Tried To Set Account ^5%s^1 For Player ^5%s^1 To An Invalid Number -> ^5%s^1"):format(accountName, self.playerId, money))
        end
    end

    function self.addAccountMoney(accountName, money, reason)
        reason = reason or "Unknown"
        if not tonumber(money) then
            error(("Tried To Set Account ^5%s^1 For Player ^5%s^1 To An Invalid Number -> ^5%s^1"):format(accountName, self.playerId, money))
            return
        end
        if money > 0 then
            local account = self.getAccount(accountName)
            if account then
                money = account.round and VNCore.Math.Round(money) or money
                self.accounts[account.index].money = self.accounts[account.index].money + money

                self.triggerEvent("vncore:setAccountMoney", account)
                TriggerEvent("vncore:addAccountMoney", self.source, accountName, money, reason)
            else
                error(("Tried To Set Add To Invalid Account ^5%s^1 For Player ^5%s^1!"):format(accountName, self.playerId))
            end
        else
            error(("Tried To Set Account ^5%s^1 For Player ^5%s^1 To An Invalid Number -> ^5%s^1"):format(accountName, self.playerId, money))
        end
    end

    function self.removeAccountMoney(accountName, money, reason)
        reason = reason or "Unknown"
        if not tonumber(money) then
            error(("Tried To Set Account ^5%s^1 For Player ^5%s^1 To An Invalid Number -> ^5%s^1"):format(accountName, self.playerId, money))
            return
        end
        if money > 0 then
            local account = self.getAccount(accountName)

            if account then
                money = account.round and VNCore.Math.Round(money) or money
                if self.accounts[account.index].money - money > self.accounts[account.index].money then
                    error(("Tried To Underflow Account ^5%s^1 For Player ^5%s^1!"):format(accountName, self.playerId))
                    return
                end
                self.accounts[account.index].money = self.accounts[account.index].money - money

                self.triggerEvent("vncore:setAccountMoney", account)
                TriggerEvent("vncore:removeAccountMoney", self.source, accountName, money, reason)
            else
                error(("Tried To Set Add To Invalid Account ^5%s^1 For Player ^5%s^1!"):format(accountName, self.playerId))
            end
        else
            error(("Tried To Set Account ^5%s^1 For Player ^5%s^1 To An Invalid Number -> ^5%s^1"):format(accountName, self.playerId, money))
        end
    end

    function self.getCoords(vector, heading)
        local ped = GetPlayerPed(self.source)
        local entityCoords = GetEntityCoords(ped)
        local entityHeading = GetEntityHeading(ped)

        local coordinates = { x = entityCoords.x, y = entityCoords.y, z = entityCoords.z }

        if vector then
            coordinates = (heading and vector4(entityCoords.x, entityCoords.y, entityCoords.z, entityHeading) or entityCoords)
        else
            if heading then
                coordinates.heading = entityHeading
            end
        end

        return coordinates
    end

    function self.getInventory(minimal)
        if minimal then
            local minimalInventory = {}

            for _, v in ipairs(self.inventory) do
                if v.count > 0 then
                    minimalInventory[v.name] = v.count
                end
            end

            return minimalInventory
        end

        return self.inventory
    end

    function self.getInventoryItem(itemName)
        for _, v in ipairs(self.inventory) do
            if v.name == itemName then
                return v
            end
        end
        return nil
    end

    function self.getMeta(index, subIndex)
        if not index then
            return self.metadata
        end

        if type(index) ~= "string" then
            error("xPlayer.getMeta ^5index^1 should be ^5string^1!")
            return
        end

        local metaData = self.metadata[index]
        if metaData == nil then
            return Config.EnableDebug and error(("xPlayer.getMeta ^5%s^1 not exist!"):format(index)) or nil
        end

        if subIndex and type(metaData) == "table" then
            local _type = type(subIndex)

            if _type == "string" then
                local value = metaData[subIndex]
                return value
            end

            if _type == "table" then
                local returnValues = {}

                for i = 1, #subIndex do
                    local key = subIndex[i]
                    if type(key) == "string" then
                        returnValues[key] = self.getMeta(index, key)
                    else
                        error(("xPlayer.getMeta subIndex should be ^5string^1 or ^5table^1! that contains ^5string^1, received ^5%s^1!, skipping..."):format(type(key)))
                    end
                end

                return returnValues
            end

            error(("xPlayer.getMeta subIndex should be ^5string^1 or ^5table^1!, received ^5%s^1!"):format(_type))
            return
        end

        return metaData
    end

    function self.setMeta(index, value, subValue)
        if not index then
            return error("xPlayer.setMeta ^5index^1 is Missing!")
        end

        if type(index) ~= "string" then
            return error("xPlayer.setMeta ^5index^1 should be ^5string^1!")
        end

        if value == nil then
            return error("xPlayer.setMeta value is missing!")
        end

        local _type = type(value)

        if not subValue then
            if _type ~= "number" and _type ~= "string" and _type ~= "table" then
                return error(("xPlayer.setMeta ^5%s^1 should be ^5number^1 or ^5string^1 or ^5table^1!"):format(value))
            end

            self.metadata[index] = value
        else
            if _type ~= "string" then
                return error(("xPlayer.setMeta ^5value^1 should be ^5string^1 as a subIndex!"):format(value))
            end

            if not self.metadata[index] or type(self.metadata[index]) ~= "table" then
                self.metadata[index] = {}
            end

            self.metadata[index] = type(self.metadata[index]) == "table" and self.metadata[index] or {}
            self.metadata[index][value] = subValue
        end
        self.triggerEvent('vncore:updatePlayerData', 'metadata', self.metadata)
    end

    function self.clearMeta(index, subValues)
        if not index then
            return error("xPlayer.clearMeta ^5index^1 is Missing!")
        end

        if type(index) ~= "string" then
            return error("xPlayer.clearMeta ^5index^1 should be ^5string^1!")
        end

        local metaData = self.metadata[index]
        if metaData == nil then
            return Config.EnableDebug and error(("xPlayer.clearMeta ^5%s^1 does not exist!"):format(index)) or nil
        end

        if not subValues then
            -- If no subValues is provided, we will clear the entire value in the metaData table
            self.metadata[index] = nil
        elseif type(subValues) == "string" then
            -- If subValues is a string, we will clear the specific subValue within the table
            if type(metaData) == "table" then
                metaData[subValues] = nil
            else
                return error(("xPlayer.clearMeta ^5%s^1 is not a table! Cannot clear subValue ^5%s^1."):format(index, subValues))
            end
        elseif type(subValues) == "table" then
            -- If subValues is a table, we will clear multiple subValues within the table
            for i = 1, #subValues do
                local subValue = subValues[i]
                if type(subValue) == "string" then
                    if type(metaData) == "table" then
                        metaData[subValue] = nil
                    else
                        error(("xPlayer.clearMeta ^5%s^1 is not a table! Cannot clear subValue ^5%s^1."):format(index, subValue))
                    end
                else
                    error(("xPlayer.clearMeta subValues should contain ^5string^1, received ^5%s^1, skipping..."):format(type(subValue)))
                end
            end
        else
            return error(("xPlayer.clearMeta ^5subValues^1 should be ^5string^1 or ^5table^1, received ^5%s^1!"):format(type(subValues)))
        end
        self.triggerEvent('vncore:updatePlayerData', 'metadata', self.metadata)
    end

    function self.setMoney(money)
        assert(type(money) == "number", "money should be number!")
        money = VNCore.Math.Round(money)
        self.setAccountMoney("money", money)
    end

    function self.getMoney()
        return self.getAccount("money").money
    end

    function self.addMoney(money, reason)
        money = VNCore.Math.Round(money)
        self.addAccountMoney("money", money, reason)
    end

    function self.removeMoney(money, reason)
        money = VNCore.Math.Round(money)
        self.removeAccountMoney("money", money, reason)
    end

    function self.getSkin()
        return self.skin
    end

    function self.setMaxWeight(newWeight)
        self.maxWeight = newWeight
        self.triggerEvent("vncore:setMaxWeight", self.maxWeight)
    end

    function self.getRoles()
        return self.roles
    end

    function self.getRole(name)
        return self.roles[name]
    end

    function self.setRole(name, role, grade)
        local newRole = Shared.Jobs[role]
        if newRole then
            if newRole.grades[tostring(grade)] then
                local lastRole = self.roles[name]
                self.roles[name].name = role
                self.roles[name].grade = tonumber(grade)
                self.roles[name].label = newRole.label
                self.roles[name].grade_label = newRole.grades[tostring(grade)].name
                self.roles[name].isduty = newRole.grades[tostring(grade)].isduty
                self.roles[name].isboss = newRole.grades[tostring(grade)].isboss
                TriggerEvent("vncore:setRole", self.source, name, self.roles[name], lastRole)
                self.triggerEvent("vncore:setRole", name, self.roles[name], lastRole)
                return true
            else
                return false 
            end
        else
            return false 
        end
    end

    function self.setDuty(name, status)
        if self.roles[name] then
            self.roles[name].isduty = status

            return true
        else
            return false
        end
    end

    function self.Notify(msg, notifyType, time, title)
        self.triggerEvent("vncore:Notify", msg, notifyType, time, title)
    end

    for _, funcs in pairs(Core.PlayerFunctionOverrides) do
        for fnName, fn in pairs(funcs) do
            self[fnName] = fn(self)
        end
    end

    return self
end