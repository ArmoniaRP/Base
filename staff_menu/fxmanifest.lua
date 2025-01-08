fx_version 'cerulean'
game 'gta5'

author 'Armonia Team'
description 'Menu Staff pour Armonia Rp'
version '1.0.0'

-- Fichiers côté client et serveur
client_scripts {
    '@RageUI/RMenu.lua',
    '@RageUI/menu/RageUI.lua',
    '@RageUI/menu/Menu.lua',
    '@RageUI/menu/MenuController.lua',
    '@RageUI/components/*.lua',
    '@RageUI/menu/elements/*.lua',
    '@RageUI/menu/items/*.lua',
    '@RageUI/menu/panels/*.lua',
    '@RageUI/menu/windows/*.lua',
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
