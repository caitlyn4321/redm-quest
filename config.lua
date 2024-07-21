Config = {}

-- Active language/locale
Config.scriptname = GetCurrentResourceName()
Config.mapitem = "quest_map"
Config.defaultquest = 1


function permissions_check()
-- This is where you implement your own permission system.  By default everyone is allowed.

    return true
end