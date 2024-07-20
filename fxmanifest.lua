fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
version '1.0'
-- Replace YOURNAME with your user/development name.
author 'JustCait'

client_scripts { 
    'client.lua',
}

server_scripts { 
    'server.lua',
}

shared_scripts {
    'config.lua',
}

---------------- Custom Html/Css/JS UI ----------------------------------------------
---------------- Remove these if you do not wish to have a custom UI ----------------
files {
    'ui/*',
    'ui/vendor/*',
    'ui/assets/*',
    'ui/assets/fonts/*'
}
    
ui_page 'ui/index.html'
--------------------------------------------------------------------------------------

---------------- Dependencies -------------------------------------------------------
---- What other scripts (if any) does your script depend on. REMOVE THIS IF NONE ----
dependencies { 
    'vorp_core',
    'vorp_inventory',
}
--------------------------------------------------------------------------------------

---------------- Exports -------------------------------------------------------------
------------- If you need ------------------------------------------------------------
exports {}
--------------------------------------------------------------------------------------
