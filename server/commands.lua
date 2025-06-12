VNCore.Cmd('saveall', {
    help = 'Lưu dữ liệu toàn bộ người chơi',
    params = {},
    restricted = 'group.admin'
}, function(source, args)
    Core.SavePlayers()
end)

VNCore.Cmd('save', {
    help = 'Lưu dữ liệu người chơi',
    params = {
        {
            name = 'id',
            type = 'number',
            help = 'Lưu dữ liệu id này',
        },
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    if VNCore.Players[args.id] then
        Core.SavePlayer(VNCore.Players[args.id])

        print('[VNCore] saved data of '..GetPlayerName(args.id))
    end
end)

VNCore.Cmd('setrole', {
    help = 'Thay đổi vai trò , nghề nghiệp của người chơi',
    params = {
        {
            name = 'id',
            type = 'playerId',
            help = 'ID người chơi',
        },
        {
            name = 'name',
            type = 'string',
            help = 'Vai trò ( job, job2 , gang ...)',
        },
        {
            name = 'role',
            type = 'string',
            help = 'Tên nghề',
        },
        {
            name = 'grade',
            type = 'number',
            help = 'Cấp độ nghề',
        },
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    local xPlayer = VNCore.GetPlayerFromId(args.id)

    if xPlayer then
        if Shared.RolesTable[args.name] then
            if Shared.Jobs[args.role] then
                if Shared.Jobs[args.role].grades[tostring(args.grade)] then
                    xPlayer.setRole(args.name, args.role, args.grade)
                else
                    TriggerClientEvent('vncore:Notify', source, 'Cấp độ không hợp lệ', 'error')
                end
            else
                TriggerClientEvent('vncore:Notify', source, 'Tên nghề không hợp lệ', 'error')
            end
        else
            TriggerClientEvent('vncore:Notify', source, 'Vai trò không hợp lệ', 'error')
        end
    else
        TriggerClientEvent('vncore:Notify', source, 'Không tìm thấy người chơi', 'error')
    end
end)