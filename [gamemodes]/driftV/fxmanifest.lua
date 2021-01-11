fx_version "cerulean"
game "gta5"
lua54 "yes"

ui_page "client/web/hud.html"

files {
    "client/web/hud.html",
    "client/web/js/hud.js",
    "client/web/css/hud.css",
    "client/web/fonts/Oswald-Light.eot",
    "client/web/fonts/Oswald-Light.svg",
    "client/web/fonts/Oswald-Light.ttf",
    "client/web/fonts/Oswald-Light.woff",
    "client/web/fonts/Oswald-Light.woff2",
    "client/web/fonts/Oswald-Regular.eot",
    "client/web/fonts/Oswald-Regular.svg",
    "client/web/fonts/Oswald-Regular.ttf",
    "client/web/fonts/Oswald-Regular.woff",
    "client/web/fonts/Oswald-Regular.woff2",
    "client/web/images/drifting.png"
}

client_scripts {
    "client/RageUI/RMenu.lua",
    "client/RageUI/menu/RageUI.lua",
    "client/RageUI/menu/Menu.lua",
    "client/RageUI/menu/MenuController.lua",
    "client/RageUI/components/*.lua",
    "client/RageUI/menu/elements/*.lua",
    "client/RageUI/menu/items/*.lua",
    "client/RageUI/menu/panels/*.lua",
    "client/RageUI/menu/windows/*.lua",
    "client/**/*.lua"
}

server_scripts {
    "server/class/*.lua",
    "server/*.lua"
}
