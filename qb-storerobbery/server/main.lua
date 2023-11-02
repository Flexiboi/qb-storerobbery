local QBCore = exports['qb-core']:GetCoreObject()
local SafeCodes = {}
local cashA = 250 				--<<how much minimum you can get from a robbery
local cashB = 450				--<< how much maximum you can get from a robbery

QBCore.Functions.CreateCallback("qb-storerobbery:server:GetConfig", function(source, cb)
    cb(Config)
end)

CreateThread(function()
    while true do
        SafeCodes = {
            [1] = math.random(1000, 9999),
            [2] = {math.random(1, 149), math.random(500.0, 600.0), math.random(360.0, 400), math.random(600.0, 900.0), math.random(500.0, 600.0)},
            [3] = {math.random(150, 359), math.random(-300.0, -60.0), math.random(0, 100), math.random(-500.0, -160.0)},
            [4] = math.random(1000, 9999),
            [5] = math.random(1000, 9999),
            [6] = {math.random(1, 149), math.random(500.0, 600.0), math.random(360.0, 400), math.random(600.0, 900.0)},
            [7] = math.random(1000, 9999),
            [8] = math.random(1000, 9999),
            [9] = math.random(1000, 9999),
            [10] = {math.random(1, 149), math.random(500.0, 600.0), math.random(360.0, 400), math.random(600.0, 900.0), math.random(500.0, 600.0)},
            [11] = math.random(1000, 9999),
            [12] = math.random(1000, 9999),
            [13] = math.random(1000, 9999),
            [14] = {math.random(1, 149), math.random(500.0, 600.0), math.random(360.0, 400), math.random(600.0, 900.0)},
            [15] = math.random(1000, 9999),
            [16] = math.random(1000, 9999),
            [17] = math.random(1000, 9999),
            [18] = {math.random(1, 149), math.random(500.0, 600.0), math.random(360.0, 400), math.random(600.0, 900.0)},
            [19] = math.random(1000, 9999),
        }
        Wait((1000 * 60) * 40)
    end
end)

QBCore.Functions.CreateCallback('qb-storerobbery:checkPoliceCount', function(source, cb)
    local src = source
    local players = QBCore.Functions.GetPlayers()
    local policeCount = 0

    for i = 1, #players do
        local player = QBCore.Functions.GetPlayer(players[i])
        if player.PlayerData.job.name == 'police' and player.PlayerData.job.onduty then
            policeCount = policeCount + 1
        end
    end

    if policeCount >= Config.MinimumStoreRobberyPolice then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('qb-storerobbery:server:takeMoney', function(register, isDone)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if isDone then
        local bags = Config.RegisterMoneyAmount
        Player.Functions.AddItem('black_money', bags, false)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['black_money'], "add")
        if math.random(1, 100) <= Config.washcoinChance then
            Player.Functions.AddItem(Config.washcoin, 1, false)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.washcoin], "add")
        end
        local safecoderandom = math.random(1, 100)
        if safecoderandom <= Config.safeCodeChance and Config.Safes[Config.Registers[register].safeKey].type ~= nil then
            -- print('gekregen met kans: '..safecoderandom)
            if Config.Safes[Config.Registers[register].safeKey].type == "keypad" then
                local code = SafeCodes[Config.Registers[register].safeKey]
                info = {
                    label = Lang:t("text.safe_code")..tostring(code)
                }
            else
                info = {
                    label = Lang:t("text.safe_code")..tostring(math.floor((code[1] % 360) / 3.60)).."-"..tostring(math.floor((code[2] % 360) / 3.60)).."-"..tostring(math.floor((code[3] % 360) / 3.60)).."-"..tostring(math.floor((code[4] % 360) / 3.60)).."-"..tostring(math.floor((code[5] % 360) / 3.60))
                }
            end
            Player.Functions.AddItem("stickynote", 1, false, info)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["stickynote"], "add")
        end
    end
end)

RegisterNetEvent('qb-storerobbery:server:sellReward', function()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', Config.deliverMoney)
    if math.random(1, 100) <= 5 then
        Player.Functions.AddItem(Config.washcoin, 1, false)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.washcoin], "add")
    end
end)

RegisterNetEvent('qb-storerobbery:server:setRegisterStatus', function(register)
    Config.Registers[register].robbed = true
    Config.Registers[register].time = Config.resetTime
    TriggerClientEvent('qb-storerobbery:client:setRegisterStatus', -1, register, Config.Registers[register])
end)

RegisterNetEvent('qb-storerobbery:server:setRegisterStolenStatus', function(register)
    TriggerClientEvent('qb-storerobbery:client:setRegisterStatus', -1, register, Config.Registers[register])
    Config.Registers[register].stolen = true
    Config.Registers[register].time = Config.resetTime
end)

RegisterNetEvent('qb-storerobbery:server:setSafeStatus', function(safe)
    Config.Safes[safe].robbed = true
    TriggerClientEvent('qb-storerobbery:client:setSafeStatus', -1, safe, true)

    SetTimeout(math.random(40, 80) * (60 * 1000), function()
        Config.Safes[safe].robbed = false
        TriggerClientEvent('qb-storerobbery:client:setSafeStatus', -1, safe, false)
    end)
end)

RegisterNetEvent('qb-storerobbery:server:SafeReward', function(safe)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    if #(playerCoords - Config.Safes[safe][1].xyz) > 3.0 or Config.Safes[safe].robbed then
        return DropPlayer(src, "Attempted exploit abuse")
    end

    local r = math.random(1, #Config.safeRewardItems)
    local item = Config.safeRewardItems[r].rewards[math.random(1, #Config.safeRewardItems[r].rewards)]
    Player.Functions.AddItem(item, Config.safeRewardItems[r].amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
    if math.random(0,100) <= Config.RareSafeRewardChance then
        local rr = math.random(1, #Config.RareSafeReward)
        local item = Config.RareSafeReward[rr].rewards[math.random(1, #Config.RareSafeReward[rr].rewards)]
        Player.Functions.AddItem(item, Config.RareSafeReward[rr].amount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
    end
end)

RegisterNetEvent('qb-storerobbery:server:callCops', function(type, safe, streetLabel, coords)
    local cameraId
    if type == "safe" then
        cameraId = Config.Safes[safe].camId
    else
        cameraId = Config.Registers[safe].camId
    end
    local alertData = {
        title = "66-73 | Winkeloverval",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = Lang:t("email.someone_is_trying_to_rob_a_store",{street = streetLabel, cameraId1 = cameraId})
    }
    
    TriggerClientEvent("qb-storerobbery:client:robberyCall", source, cameraId)
    TriggerClientEvent("jpr-newphone:client:addPoliceAlert", -1, alertData)
end)

RegisterNetEvent('qb-storerobbery:server:removeAdvancedLockpick', function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('advancedlockpick', 1)
end)

RegisterNetEvent('qb-storerobbery:server:removeLockpick', function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('lockpick', 1)
end)

CreateThread(function()
    while true do
        local toSend = {}
        for k in ipairs(Config.Registers) do

            if Config.Registers[k].time > 0 and (Config.Registers[k].time - Config.tickInterval) >= 0 then
                Config.Registers[k].time = Config.Registers[k].time - Config.tickInterval
            else
                if Config.Registers[k].robbed then
                    Config.Registers[k].time = 0
                    Config.Registers[k].robbed = false
                    toSend[#toSend+1] = Config.Registers[k]
                    --print('sending robbed')
                end
                if Config.Registers[k].stolen then
                    Config.Registers[k].time = 0
                    Config.Registers[k].stolen = false
                    toSend[#toSend+1] = Config.Registers[k]
                    --print('sending stolen: '..tostring(Config.Registers[k].stolen))
                end
            end
        end

        if #toSend > 0 then
            --The false on the end of this is redundant
            TriggerClientEvent('qb-storerobbery:client:setRegisterStatus', -1, toSend, false)
        end

        Wait(Config.tickInterval)
    end
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:isCombinationRight', function(_, cb, safe)
    cb(SafeCodes[safe])
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:getPadlockCombination', function(_, cb, safe)
    cb(SafeCodes[safe])
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:getRegisterStatus', function(_, cb)
    cb(Config.Registers)
end)

QBCore.Functions.CreateCallback('qb-storerobbery:server:getSafeStatus', function(_, cb)
    cb(Config.Safes)
end)


--USABLE
QBCore.Functions.CreateUseableItem("lockpick", function(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, false)
end)

QBCore.Functions.CreateUseableItem("advancedlockpick", function(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, true)
end)