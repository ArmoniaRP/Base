fx_version 'cerulean'
game 'gta5'

author 'Armonia Team'
description 'Menu Staff pour Armonia Rp'
version '1.0.0'

-- Fichiers côté client et serveur
client_scripts {
    '@es_extended/locale.lua',
    'client.lua',
    'menu.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server.lua'
}

dependencies {
    'es_extended',
    'mysql-async'
}
