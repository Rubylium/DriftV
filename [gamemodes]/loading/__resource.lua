description "A simple loading screen!"

loadscreen_manual_shutdown "yes"

files {
    "index.html",
    "css/*.css",
    "fonts/gravity.otf",
    "fonts/icomoon.ttf",
    "img/*.png",
    "img/*.svg",
    "js/*.js",
    "sounds/*.ogg"
}

client_script "client.lua"
loadscreen "index.html"
