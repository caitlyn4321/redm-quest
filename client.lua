RegisterNetEvent(Config.scriptname..":displayquest")
AddEventHandler(Config.scriptname..":displayquest", function(quest)
    SendNUIMessage({
        type = 'display',
        meta = quest.metadata
    })
    SetNuiFocus(true, true) -- Sets the focus of the player view to NUI
end)

RegisterNUICallback('close', function(data,cb)
    SetNuiFocus(false, false) -- Sets the focus of the player view away from NUI
    cb('ok')
end)

RegisterCommand("givemap", function(source, args, rawCommand)
    print("Give Map: "..args[1])

    TriggerServerEvent(Config.scriptname..":givemap", args[1])
end, false)

if permissions_check() then
    RegisterCommand("listquests", function(source, args, rawCommand)
        print("Quest Editor")

        SendNUIMessage({
            type = "questlist",
        })
        SetNuiFocus(true, true)
        TriggerServerEvent(Config.scriptname..":listquests")
    end, false)

    RegisterNetEvent(Config.scriptname..":listquests")
    AddEventHandler(Config.scriptname..":listquests", function(quests)
        SendNUIMessage({
            quests = quests,
        })
    end)

    RegisterNUICallback('selectquest', function(data, cb)
        TriggerServerEvent(Config.scriptname..":viewquest",data)
        print("Sending View Quest: "..json.encode(data))
        cb('ok')
    end)

    RegisterNetEvent(Config.scriptname..":viewquest")
    AddEventHandler(Config.scriptname..":viewquest", function(quest)
        print("View Quest: "..json.encode(quest))
        SendNUIMessage({
            questentries = quest,
        })
    end)
end