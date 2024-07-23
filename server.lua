local VORPcore = {}
local VORPinv

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

VORPinv = exports.vorp_inventory:vorp_inventoryApi()

VORPinv.RegisterUsableItem(Config.mapitem, function(data)
    local _source = data.source
    print("Used item: "..Config.mapitem)
    
    local user = VORPcore.getUser(_source)
    if not user then return end
    local character = user.getUsedCharacter

    VORPinv.CloseInv(data.source)
    questmap = data.item
    if not questmap then
        print("No map found")
		VORPcore.NotifyObjective(_source, "You have no map, which is confusing", 5000)
		return
	end

    if not questmap.metadata.quest then
        questmap=setStep(_source, questmap, nil, nil)
    elseif not questmap.metadata.step then
        questmap=setStep(_source, questmap, questmap.metadata.quest, nil)
	end

    local requirements = questmap.metadata.config.requirements or nil
    local materials = questmap.metadata.config.materials or nil
    local rewards = questmap.metadata.config.rewards or nil
    local passing = true
    

    
    print("Config: "..json.encode(questmap.metadata.config))

    if requirements then
        if requirements.coords and passing then
            if #(GetEntityCoords(GetPlayerPed(_source)) - vector3(requirements.coords.x, requirements.coords.y, requirements.coords.z)) > requirements.coords.r then
                passing = false
            end
        end
        if requirements.items and passing then
            print("Has Requirements: "..json.encode(requirements.items))
            for _,v in pairs(requirements.items) do
                local count= exports.vorp_inventory:getItemCount(_source, nil, v.item,nil)
                print("Item: "..v.item.." Count: "..count.." Required: "..v.count)
                if count < v.count then
                    passing = false
                end
            end
        end
    end
    if materials and passing then
        if materials.items then
            for _,v in pairs(materials.items) do
                print("V: "..json.encode(v))
                if exports.vorp_inventory:getItemCount(_source, nil, v.item,nil) < v.count then
                    passing = false
                end
            end
        end
        if materials.cash then
            if character.money < materials.cash then
                passing = false
            end
        end
    end
    if rewards and passing then
        if rewards.items then
            for k,v in pairs(rewards.items) do
                print("k: "..k.." v: "..json.encode(v))
                if not exports.vorp_inventory:canCarryItem(_source, v.item,v.count,nil) then
                    passing = false
                end
            end
        end
    end

    if passing then
        if materials then
            if materials.items then
                for _,v in pairs(materials.items) do
                    exports.vorp_inventory:subItem(_source, v.item, v.count, nil, nil)
                end
            end
            if materials.cash then
                character.removeCurrency(0, materials.cash)
            end
        end
        if rewards then
            if rewards.items then
                for _,v in pairs(rewards.items) do
                    exports.vorp_inventory:addItem(_source, v.item, v.count, nil,nil)
                end
            end
            if rewards.cash then
                character.addCurrency(0, rewards.cash)
            end
        end
        if questmap.metadata.config.next then
            questmap=setStep(_source, questmap, questmap.metadata.config.quest, questmap.metadata.config.next)
        end

    end


    TriggerClientEvent(Config.scriptname..":displayquest", _source, questmap)
end)

function setStep(_source, questmap, quest, step)
    local looping = false
    local _quest = quest or Config.defaultquest
    local _step = step

    looping = true
    if not _step then
        exports.ghmattimysql:execute("SELECT id,config FROM quests_entries WHERE quest = @quest order by id asc limit 1;", {["@quest"] = _quest}, function(result)
            if result[1] then
                _step = result[1].id
                local meta = { quest = _quest, step = _step }
                if result[1].config then
                    meta.config = json.decode(result[1].config)
                end
                questmap.metadata = meta
            end
            looping=false
        end)
        
    else
        exports.ghmattimysql:execute("SELECT quest,config FROM quests_entries WHERE id = @step limit 1;", {["@step"] = _step}, function(result)
            if result[1] then
                _quest = result[1].quest
                local meta = { quest = _quest, step = _step }
                if result[1].config then
                    meta.config = json.decode(result[1].config)
                end
                questmap.metadata = meta
            end
            looping=false
        end)
    end
    while looping do
        Citizen.Wait(1)
    end
    exports.vorp_inventory:setItemMetadata(_source, questmap.mainid, questmap.metadata, 1)
    return questmap
end

RegisterServerEvent(Config.scriptname..":givemap")
AddEventHandler(Config.scriptname..":givemap", function(quest)
    local _source=source

    exports.vorp_inventory:addItem(_source, Config.mapitem, 1, {quest = quest},nil)
end)

function listquests(_source, data)
    local looping=false

    print("list quests for: ".._source)
    local queststring = ""
    local quests = {}

    if data then
        queststring = " WHERE id = @id"
    end

    looping=true
    exports.ghmattimysql:execute("SELECT * FROM quests"..queststring..";", {["@id"]=data}, function(result)
        if #result>0 then
            for _,v in pairs(result) do
                table.insert(quests, {id = v.id, name = v.name, desc = v.desc, config= json.decode(v.config)})
            end
            
        end
        looping=false
    end)
    while looping do
        Citizen.Wait(1)
    end

    return quests
end

RegisterServerEvent(Config.scriptname..":listquests")
AddEventHandler(Config.scriptname..":listquests", function()
    local _source=data or source

    local quests=listquests(_source)
    TriggerClientEvent(Config.scriptname..":listquests", _source, quests)
end)

RegisterServerEvent(Config.scriptname..":singlequest")
AddEventHandler(Config.scriptname..":singlequest", function(data)
    local _source=source

    local quests=listquests(_source,data)
    TriggerClientEvent(Config.scriptname..":singlequest", _source, quests[1])
end)

RegisterServerEvent(Config.scriptname..":viewquest")
AddEventHandler(Config.scriptname..":viewquest", function(quest,id)
    local _source=id or source

    print("View Quest ID: "..quest)
    exports.ghmattimysql:execute("SELECT * FROM quests_entries WHERE quest = @quest order by id asc;", {["@quest"] = quest}, function(result)
        print("After Query")
        local quest_entries = {}
        if #result>0 then
            print("found results")
            
            for _,v in pairs(result) do
                table.insert(quest_entries, {quest = quest, id = v.id, desc = v.desc, config= json.decode(v.config)})
            end
            print("Sending back to client")
        else
            print("No results")
        end
        TriggerClientEvent(Config.scriptname..":viewquest", _source, quest_entries)
    end)
end)

RegisterServerEvent(Config.scriptname..":delquest")
AddEventHandler(Config.scriptname..":delquest", function(quest)
    local _source=source
    local looping = false

    print("Del Quest ID: "..quest)
    looping=true
    exports.ghmattimysql:execute("delete FROM quests WHERE id = @quest limit 1;", {["@quest"] = quest}, function(result)
        if result.affectedRows>0 then
            exports.ghmattimysql:execute("delete FROM quests_entries WHERE quest = @quest;", {["@quest"] = quest}, nil)
        end
        looping=false
    end)
    while looping do
        Citizen.Wait(1)
    end

    local quests=listquests(_source)
    TriggerClientEvent(Config.scriptname..":listquests", _source, quests)
end)

RegisterServerEvent(Config.scriptname..":addquest")
AddEventHandler(Config.scriptname..":addquest", function()
    local _source=source
    local looping = false

    print("Add Quest")
    looping=true
    exports.ghmattimysql:execute("INSERT INTO quests (`name`, `desc`) VALUES (@name, @desc)",
    {
        ["@name"] = "An Exciting Quest",
        ["@desc"] = "You are embarking on a journey",
        ["@config"] = {},
    }, function(result)
        if result.insertId then
            print("Inserted Quest: "..result.insertId)
        end
        looping=false
    end)
    while looping do
        Citizen.Wait(1)
    end

    local quests=listquests(_source)
    TriggerClientEvent(Config.scriptname..":listquests", _source, quests)
end)

RegisterServerEvent(Config.scriptname..":savequest")
AddEventHandler(Config.scriptname..":savequest", function(data)
    local _source=source
    local looping = false

    print("Update Quest")
    looping=true
    exports.ghmattimysql:execute("update quests SET name = @name, `desc` = @desc WHERE id = @id",
    {
        ["@name"] = data.name,
        ["@desc"] = data.desc,
        ["@id"] = data.id
    }, function(result)
        if result.affectedRows>0 then
            print("Success - Updated Quest Rows: "..result.affectedRows)
        else
            print("Failed - Updated Quest Rows: "..result.affectedRows)
        end
        looping=false
    end)
    while looping do
        Citizen.Wait(1)
    end

    local quests=listquests(_source)
    TriggerClientEvent(Config.scriptname..":listquests", _source, quests)
end)

RegisterServerEvent(Config.scriptname..":addquestentry")
AddEventHandler(Config.scriptname..":addquestentry", function(quest)
    local _source=source
    local looping = false

    local config = {}
    config.requirements = { items={}, coords = nil}
    config.materials = { items={}, cash = 0}
    config.rewards = { items={}, cash = 0}

    print("Add Quest")
    looping=true
    exports.ghmattimysql:execute("INSERT INTO quests_entries (`quest`, `config`) VALUES (@quest, @config)",
    {
        ["@quest"] = quest,
        ["@config"] = json.encode(config)
    }, function(result)
        if result.insertId then
            print("Inserted Quest Entry: "..result.insertId)
        end
        looping=false
    end)
    while looping do
        Citizen.Wait(1)
    end

    TriggerEvent(Config.scriptname..":viewquest", quest,_source)
end)

RegisterServerEvent(Config.scriptname..":delquestentry")
AddEventHandler(Config.scriptname..":delquestentry", function(data)
    local _source=source
    local looping = false

    print("Del Quest Entry ID: "..data.entry.." Quest: "..tonumber(data.quest))
    looping=true
    exports.ghmattimysql:execute("delete FROM quests_entries WHERE id = @quest;", {["@quest"] = data.entry}, function(result)
        if result.affectedRows>0 then
            print("Deleted Quest Entry Rows: "..result.affectedRows)
        else
            print("Failed - Deleted Quest Entry Rows: "..result.affectedRows)
        end
        looping=false
    end)

    while looping do
        Citizen.Wait(1)
    end
    TriggerEvent(Config.scriptname..":viewquest", data.quest,_source)
end)