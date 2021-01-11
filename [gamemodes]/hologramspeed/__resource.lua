resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

description "Forza Horizon 4 Speedometer"
author "Akkariin"
url "https://www.zerodream.net/"

ui_page "html/hud.html"

files {
	"html/hud.html",
	"html/js/gauge.min.js",
	"html/js/hud.js",
	"html/css/hud.css",
	"html/fonts/Oswald-Light.eot",
	"html/fonts/Oswald-Light.svg",
	"html/fonts/Oswald-Light.ttf",
	"html/fonts/Oswald-Light.woff",
	"html/fonts/Oswald-Light.woff2",
	"html/fonts/Oswald-Regular.eot",
	"html/fonts/Oswald-Regular.svg",
	"html/fonts/Oswald-Regular.ttf",
	"html/fonts/Oswald-Regular.woff",
	"html/fonts/Oswald-Regular.woff2",
	"html/images/speedcircle.png",
}

client_script "client.lua"