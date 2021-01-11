----------------------- [ MenuV ] -----------------------
-- GitHub: https://github.com/ThymonA/menuv/
-- License: GNU General Public License v3.0
--          https://choosealicense.com/licenses/gpl-3.0/
-- Author: Thymon Arens <contact@arens.io>
-- Name: MenuV
-- Version: 1.4
-- Description: FiveM menu library for creating menu's
----------------------- [ MenuV ] -----------------------
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {

    'client/RageUI/RMenu.lua',
    'client/RageUI/menu/RageUI.lua',
    'client/RageUI/menu/Menu.lua',
    'client/RageUI/menu/MenuController.lua',
    'client/RageUI/components/*.lua',
    'client/RageUI/menu/elements/*.lua',
    'client/RageUI/menu/items/*.lua',
    'client/RageUI/menu/panels/*.lua',
    'client/RageUI/menu/windows/*.lua',

    "client/**/*.lua"
}

server_scripts {
    "server/class/*.lua",
    "server/*.lua",
}