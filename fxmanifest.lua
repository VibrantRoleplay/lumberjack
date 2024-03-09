fx_version 'cerulean'
game 'gta5'

author 'Vibrant'
description 'Lumberjack job'
version '1.0.0'

client_scripts {
    'client/*.lua',
    'menus/*.lua',
}

server_scripts {
    'server/*.lua',
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

lua54 'yes'