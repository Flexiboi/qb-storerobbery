fx_version 'cerulean'
game 'gta5'

description 'qb-storerobbery Flex edit'
version '0.1'

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

client_script {
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
    'client/main.lua'
}
server_script 'server/main.lua'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/reset.css'
}

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_props_lockpick_pack.ytyp'

lua54 'yes'
