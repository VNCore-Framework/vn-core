VNCore.Cmd('saveall', {
    help = 'Lưu dữ liệu toàn bộ người chơi',
    params = {},
    restricted = 'group.admin'
}, function(source, args)
    print('[VNCore] saved all players')
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