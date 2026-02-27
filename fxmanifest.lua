fx_version 'cerulean'
game 'gta5'

author 'PlaytimeScript'
description 'QBCore Playtime Rewards System'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/sounds/click.wav',
    'html/sounds/close.wav',
    'html/sounds/open.wav',
    'html/sounds/touch.wav',
    'html/image/*.png',
    'html/image/*.jpg',
    'html/image/*.webp'
}
