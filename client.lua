RegisterNetEvent(Config.scriptname..":displayquest")
AddEventHandler(Config.scriptname..":displayquest", function(quest)
    SendNUIMessage({
        type = 'display',
        meta = quest.metadata
    })
    SetNuiFocus(true, true) -- Sets the focus of the player view to NUI
end)

RegisterNUICallback('close', function(args, cb)
    SetNuiFocus(false, false) -- Sets the focus of the player view away from NUI
    cb('ok')
end)

RegisterCommand("givemap", function(source, args, rawCommand)
    print("Give Map: "..args[1])

    TriggerServerEvent(Config.scriptname..":givemap", args[1])
end, false)

RegisterCommand("editquest", function(source, args, rawCommand)
    print("Give Map: "..args[1])

    TriggerServerEvent(Config.scriptname..":givemap", args[1])
end, false)