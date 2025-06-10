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
    'shared/jobs.lua',
}

client_scripts {
    'client/main.lua',
    'client/functions.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
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