fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
name 'VNCore'
author 'VNCore'
version '1.0.0'
repository 'https://github.com/VNCore-Framework/vn-core'
description 'VNCore heart of atomic'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/shared.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

dependencies {
    '/server:6116',
    '/onesync',
    'oxmysql',
    'ox_lib',
}