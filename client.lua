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

    RegisterNUICallback('delquest', function(data, cb)
        TriggerServerEvent(Config.scriptname..":delquest",data)
        print("Delete Quest: "..data)
        cb('ok')
    end)

    RegisterNUICallback('addquest', function(data,cb)
        TriggerServerEvent(Config.scriptname..":addquest")
        print("Adding New Quest")
        cb('ok')
    end)

    RegisterNUICallback('editquest', function(data,cb)
        TriggerServerEvent(Config.scriptname..":singlequest",data)
        print("Single Quest")
        cb('ok')
    end)
    RegisterNUICallback('savequest', function(data,cb)
        TriggerServerEvent(Config.scriptname..":savequest",data)
        print("Save Quest")
        cb('ok')
    end)

    RegisterNetEvent(Config.scriptname..":singlequest")
    AddEventHandler(Config.scriptname..":singlequest", function(data)
        print("Single Quest return: "..json.encode(data))
        SendNUIMessage({
            quest_name = data.name,
            quest_desc = data.desc,
            quest_id=data.id,
        })
    end)
    RegisterNUICallback('addquestentry', function(data,cb)
        TriggerServerEvent(Config.scriptname..":addquestentry",data)
        print("Adding New Quest Entry")
        cb('ok')
    end)
    
    RegisterNUICallback('delquestentry', function(data, cb)
        TriggerServerEvent(Config.scriptname..":delquestentry",data)
        print("Delete Quest Entry: "..json.encode(data))
        cb('ok')
    end)

    RegisterNUICallback('editquestentry', function(data,cb)
        TriggerServerEvent(Config.scriptname..":editquestentry",data)
        print("View Quest Entry: "..data)
        cb('ok')
    end)

    RegisterNetEvent(Config.scriptname..":viewentry")
    AddEventHandler(Config.scriptname..":viewentry", function(data)
        print("Single Quest return: "..json.encode(data))
        SendNUIMessage({
            questentry = data,
        })
    end)

    RegisterNUICallback('updateentry', function(data,cb)
        TriggerServerEvent(Config.scriptname..":updateentry",data)
        print("Update Quest Entry: "..data.id.." "..json.encode(data))
        cb('ok')
    end)
end