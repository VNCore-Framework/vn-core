function createPlayerData(source, identifier, name, money, metadata, position)
    local self = {}

    self.source = source
    self.identifier = identifier
    self.name = name
    self.money = money
    self.metadata = metadata
    self.position = position

    function self.getIdentifier()
        return self.identifier
    end
    
    return self
end