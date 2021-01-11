fx_version 'cerulean'
games { 'gta5' }

name 'RageUI'


ui_page 'html/index.html'


files {
	'html/index.html',
	'html/jquery.js',
    'html/init.js',
}

client_scripts {
    'client/**/*.lua',
}


server_scripts {
    'server/**/*.lua',
}