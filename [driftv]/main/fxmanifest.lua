fx_version 'cerulean'
game 'common'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

name 'oxmysql'
author 'Overextended'
version '2.10.1'

client_scripts {
	"client/**/*.lua"
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	"server/**/*.lua"
}
