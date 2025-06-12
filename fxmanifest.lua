fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
name 'VNCore'
author 'VNCore Team'
version '1.0.0'
repository 'https://github.com/VNCore-Framework/vn-core'
description 'VNCore Framework - A simple and powerful FiveM framework'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/shared.lua',
    'shared/main.lua',
    'shared/modules/*.lua',
    'shared/functions.lua',
    'shared/jobs.lua',
}

client_scripts {
    'client/main.lua',
    'client/functions.lua',
    'client/events.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/common.lua',
    'server/bridge/ox_inventory.lua',
    'server/functions.lua',
    'server/player.lua',
    'server/modules/*.lua',
    'server/main.lua',
    'server/events.lua',
}

files {
    'imports.lua',
}

dependencies {
    '/server:6116',
    '/onesync',
    'oxmysql',
    'ox_lib',
}