local QBCore = exports['qb-core']:GetCoreObject()
local currentRegister = 0
local currentSafe = 0
local copsCalled = false
local PlayerJob = {}
local onDuty = false
local usingAdvanced = false
local canInetract = false
local deliverblip = nil
local inRegRange, isstealing, registerobject, registerpos, isregdropped, currentwire, sellped = false, false, nil, nil, false, 'red', nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('qb-storerobbery:server:GetConfig', function(cfg)
        Config = cfg
    end)
end)

CreateThread(function()
    Wait(1000)
    if QBCore.Functions.GetPlayerData().job ~= nil and next(QBCore.Functions.GetPlayerData().job) then
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end
end)

CreateThread(function()
    while true do
        Wait(1000 * 60 * 5)
        if copsCalled then
            copsCalled = false
        end
    end
end)

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end

if Config.target then
    exports['qb-target']:AddTargetModel(Config.registerProps, {
        options = {
            {
                icon = 'fa fa-unlock',
                label = Lang:t("text.stealreg"),
                action = function(entity)
                    TriggerEvent("qb-storerobbery:StealReg", entity)
                end,
                canInteract = function()
                    for k in pairs(Config.Registers) do
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local dist = #(pos - Config.Registers[k][1].xyz)
                        if dist <= 3 then
                            return not isstealing
                        end
                    end
                end,
            }
        },
        distance = 2.5,
    })
else
    CreateThread(function()
        while true do
            Wait(1)
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            for k in pairs(Config.Registers) do
                local dist = #(pos - Config.Registers[k][1].xyz)
                if dist <= 3 and not Config.Registers[k].stolen then
                    DrawText3Ds(Config.Registers[k][1].xyz, '[~o~E~w~] '..Lang:t("text.stealreg"))
                    if dist <= 2 then
                        if IsControlJustReleased(0, 38) then
                            if not isstealing then
                                local entity = nil
                                for k, v in pairs(Config.registerProps) do
                                    entity = GetClosestObjectOfType(pos.x, pos.y, pos.z, 2.0, v, 0, 0, 0)
                                    if entity > 0 then
                                        break
                                    end
                                end
                                TriggerEvent("qb-storerobbery:StealReg", entity)
                            else
                                QBCore.Functions.Notify(Lang:t("error.alreadystealing"), "error")
                            end
                        end
                    end
                end
            end
        end
    end)
end

CreateThread(function()
    while true do
        Wait(1)
        if QBCore ~= nil then
            local pos = GetEntityCoords(PlayerPedId())
            for safe,_ in pairs(Config.Safes) do
                local dist = #(pos - Config.Safes[safe][1].xyz)
                if dist < 4 then
                    inRegRange = true
                    if dist < 1.0 then
                        if not Config.Safes[safe].robbed then
                            DrawText3Ds(Config.Safes[safe][1].xyz, Lang:t("text.try_combination"))
                            if IsControlJustPressed(0, 38) then
                                QBCore.Functions.TriggerCallback('djkms-jobtracker:GetJobCount', function(CurrentCops)
                                    if CurrentCops >= QBCore.Shared.IllegalActions["storerobbery"].minimum then
                                        currentSafe = safe
                                        if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
                                            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                                        end
                                        if math.random(100) <= 50 then
                                            TriggerServerEvent('hud:server:GainStress', Config.safestress)
                                        end
                                        if Config.Safes[safe].type == "keypad" then
                                            SendNUIMessage({
                                                action = "openKeypad",
                                            })
                                            SetNuiFocus(true, true)
                                        else
                                            QBCore.Functions.TriggerCallback('qb-storerobbery:server:getPadlockCombination', function(combination)
                                                TriggerEvent("SafeCracker:StartMinigame", combination)
                                            end, safe)
                                            -- TriggerEvent('qb-storerobbery:client:Minigame')
                                        end

                                        if not copsCalled then
                                            -- pos = GetEntityCoords(PlayerPedId())
                                            -- local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                                            -- local street1 = GetStreetNameFromHashKey(s1)
                                            -- local street2 = GetStreetNameFromHashKey(s2)
                                            -- local streetLabel = street1
                                            -- if street2 ~= nil then
                                            --     streetLabel = streetLabel .. " " .. street2
                                            -- end
                                            -- TriggerServerEvent("qb-storerobbery:server:callCops", "safe", Safes, streetLabel, pos)
                                            exports['ps-dispatch']:StoreRobbery(Config.Safes[Safes].camId)
                                            copsCalled = true
                                        end
                                    else
                                        QBCore.Functions.Notify(Lang:t("error.minimum_store_robbery_police", { MinimumStoreRobberyPolice = QBCore.Shared.IllegalActions["storerobbery"].minimum}), "error")
                                    end
                                end, "police")
                            end
                        else
                            DrawText3Ds(Config.Safes[safe][1].xyz, Lang:t("text.safe_opened"))
                        end
                    end
                end
            end
        end

        if not inRegRange then
            Wait(2000)
        end
    end
end)

CreateThread(function()
    Wait(1000)
    setupRegister()
    setupSafes()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for k in pairs(Config.Registers) do
            local dist = #(pos - Config.Registers[k][1].xyz)
            if dist <= 2 and Config.Registers[k].robbed then
                inRegRange = true
                DrawText3Ds(Config.Registers[k][1].xyz, Lang:t("text.the_cash_register_is_empty"))
            elseif dist <= 2 and Config.Registers[k].stolen then
                inRegRange = true
                DrawText3Ds(Config.Registers[k][1].xyz, Lang:t("text.the_cash_register_is_stolen"))
            elseif dist >= 6 and Config.Registers[k].stolen then
                inRegRange = false
            end
        end
        if not inRegRange then
            Wait(2000)
        end
        Wait(3)
    end
end)

function ResetDroppedRegister()
    SetTimeout(1000 * 60 * Config.StolenRegisterResetTime, function()
        if isregdropped then
            if DoesEntityExist(registerobject) then
                DetachEntity(registerobject,true,false)
                SetEntityAsMissionEntity(registerobject, false, false)
                DeleteObject(registerobject)
            end
            if DoesBlipExist(deliverblip) then
                RemoveBlip(deliverblip)
            end
            SetEntityAsNoLongerNeeded(registerobject)
            canInetract = false
            inRegRange, isstealing, registerobject, registerpos, isregdropped, currentwire, sellped = false, false, nil, nil, false, 'red', nil
        end
    end)
end

function stealingreg()
    CreateThread(function()
        while true do
            Wait(1)
            if isstealing then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local heading = GetEntityHeading(ped)
                local data = QBCore.Functions.GetPlayerData()
                if IsPedInAnyVehicle(ped) then
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    if GetPedInVehicleSeat(vehicle, -1) == ped and not isregdropped then
                        TaskLeaveVehicle(ped, vehicle, 0)
                        -- QBCore.Functions.Notify(Lang:t("error.vehicle_driver"), "error")
                    end
                elseif exports["qb-policejob"]:IsHandcuffed() then
                    if DoesEntityExist(registerobject) then
                        DetachEntity(registerobject,true,false)
                        SetEntityAsMissionEntity(registerobject, false, false)
                        DeleteObject(registerobject)
                    end
                    if DoesBlipExist(deliverblip) then
                        RemoveBlip(deliverblip)
                    end
                    SetEntityAsNoLongerNeeded(registerobject)
                    canInetract = false
                    inRegRange, isstealing, registerobject, registerpos, isregdropped, currentwire, sellped = false, false, nil, nil, false, 'red', nil
                elseif data and data.metadata['isdead'] or data.metadata['inlaststand'] or data.metadata['ishandcuffed'] then 
                    if DoesEntityExist(registerobject) then
                        DetachEntity(registerobject,true,false)
                        SetEntityAsMissionEntity(registerobject, false, false)
                        DeleteObject(registerobject)
                    end
                    if DoesBlipExist(deliverblip) then
                        RemoveBlip(deliverblip)
                    end
                    SetEntityAsNoLongerNeeded(registerobject)
                    canInetract = false
                    inRegRange, isstealing, registerobject, registerpos, isregdropped, currentwire, sellped = false, false, nil, nil, false, 'red', nil
                elseif not isregdropped then
                    DrawText3Ds(pos, '[~o~G~w~] '..Lang:t("text.dropreg"))
                    if not IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "idle", 49) or IsPedRagdoll(ped) then 
                        TaskPlayAnim(ped, "anim@heists@box_carry@", "idle" ,2.0, 2.0, -1, 51, 0, false, false, false)
                    end
                    if IsControlJustReleased(0, 47) then
                        isregdropped = true
                        LoadAnimDict('random@domestic')
                        TaskPlayAnim(ped, "random@domestic", "pickup_low" ,2.0, 2.0, -1, 51, 0, false, false, false)
                        if DoesEntityExist(registerobject) then
                            DetachEntity(registerobject,true,true)
                            SetEntityAsMissionEntity(registerobject, false, false)
                            DeleteObject(registerobject)
                            registerobject = CreateObject(joaat('prop_till_01_dam'), pos.x, pos.y, pos.z + 0.2, true, true, true)
                            SetEntityCollision(registerobject, false, false)
                            SetEntityHeading(registerobject, heading)
                            PlaceObjectOnGroundProperly(registerobject)
                            ResetDroppedRegister()
                        end
                        registerpos = GetEntityCoords(registerobject)
                        ClearPedTasks(ped)
                    end
                elseif isregdropped then
                    local dist = #(pos - registerpos)
                    if dist <= 4 then
                        DrawText3Ds(registerpos, '[~o~G~w~] '..Lang:t("text.pickreg"))
                        if dist <= 1 then
                            if IsControlJustReleased(0, 47) then
                                LoadAnimDict('random@domestic')
                                TaskPlayAnim(ped, "random@domestic", "pickup_low" ,2.0, 2.0, -1, 51, 0, false, false, false)
                                if DoesEntityExist(registerobject) then
                                    SetEntityAsMissionEntity(registerobject, false, false)
                                    DeleteObject(registerobject)
                                    Wait(1500)
                                    LoadAnimDict('anim@heists@box_carry@')
                                    TaskPlayAnim(ped, "anim@heists@box_carry@", "idle" ,2.0, 2.0, -1, 51, 0, false, false, false)
                                    registerobject = CreateObject(joaat('prop_till_01_dam'), pos.x, pos.y, pos.z + 0.2, true, true, true)
                                    SetEntityCollision(registerobject, false, false)
                                    AttachEntityToEntity(registerobject, ped, GetPedBoneIndex(ped, 60309), 0.138000, 0.200000, 0.200000, -50.000000, 290.000000, 0.000000, true, true, false, true, 1, true)
                                end
                                isregdropped = false
                            end
                        end
                    end
                end
            else
                break
            end
        end
    end)
end

function createped(loc)
    local model = GetHashKey(Config.pedmodels[math.random(1, #Config.pedmodels)])
    loadModel(model)
    sellped = CreatePed(0, model, loc.x, loc.y, loc.z - 1.0, loc.w, true, true)
    FreezeEntityPosition(sellped, true)
    SetEntityCollision(sellped, true)
    SetEntityHeading(sellped, loc.w)
end

function randomdeliverloc()
    QBCore.Functions.Notify(Lang:t("success.checkgps"), "success")
    local deliverloc = Config.RegiterDeliverLocs[math.random(1, #Config.RegiterDeliverLocs)]
    local deliverlocvec3 = vec3(deliverloc.x, deliverloc.y, deliverloc.z)
    deliverblip = AddBlipForCoord(deliverlocvec3)
    SetBlipSprite(deliverblip, 270)
    SetBlipColour(deliverblip, 6)
    SetBlipScale(deliverblip, 0.6)
    SetBlipAsShortRange(deliverblip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Lang:t("blip.blipname"))
    EndTextCommandSetBlipName(deliverblip)
    SetBlipRoute(deliverblip, true)
    SetBlipRouteColour(deliverblip, 6)
    createped(deliverloc)
    CreateThread(function()
        while true do
            Wait(1)
            if isstealing then
                if not isregdropped then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    local dist = #(pos - deliverlocvec3)
                    if dist <= 5 then
                        DrawText3Ds(deliverlocvec3, '[~o~E~w~] '..Lang:t("text.deliverreg"))
                        if dist <= 3 then
                            if IsControlJustReleased(0, 38) then
                                TaskLookAtEntity(sellped, ped, 5500.0, 2048, 3)
                                TaskTurnPedToFaceEntity(sellped, ped, 5500)
                                TaskStartScenarioInPlace(sellped, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, false)
                                LoadAnimDict("gestures@f@standing@casual")
                                TaskPlayAnim(ped, "gestures@f@standing@casual", "gesture_point", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                                TaskPlayAnim(sellped, "gestures@f@standing@casual", "gesture_point", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                                Wait(650)
                                ClearPedTasks(ped)
                                ClearPedTasks(sellped)
                                if DoesEntityExist(registerobject) then
                                    DetachEntity(registerobject,true,false)
                                    SetEntityAsMissionEntity(registerobject, false, false)
                                    DeleteObject(registerobject)
                                end
                                FreezeEntityPosition(sellped, false)
                                TaskWanderStandard(sellped, 10.0, 10.0)
                                SetEntityAsNoLongerNeeded(sellped)
                                ClearPedTasks(ped)
                                SetEntityAsNoLongerNeeded(registerobject)
                                QBCore.Functions.Notify(Lang:t("success.deliveredreg"), "success")
                                TriggerServerEvent('qb-storerobbery:server:sellReward')
                                if DoesBlipExist(deliverblip) then
                                    RemoveBlip(deliverblip)
                                end
                                canInetract = false
                                inRegRange, isstealing, registerobject, registerpos, isregdropped, currentwire, sellped = false, false, nil, nil, false, 'red', nil
                            end
                        end
                    end
                end
            else
                break
            end
        end
    end)
end

CreateThread(function()
    Wait(1000)
    while true do
        Wait(1)
        for k in pairs(Config.Registers) do
            if not inRegRange then
                if Config.Registers[k].stolen then
                    register1 = GetClosestObjectOfType(Config.Registers[k][1].xyz, 1.0, GetHashKey('prop_till_01'), false, true ,true)
                    register2 = GetClosestObjectOfType(Config.Registers[k][1].xyz, 1.0, GetHashKey('prop_till_01_dam'), false, true ,true)
                    if DoesEntityExist(register1) then
                        SetEntityAsMissionEntity(register1, false, false)
                        DeleteObject(register1)
                    end
                    if DoesEntityExist(register2) then
                        SetEntityAsMissionEntity(register2, false, false)
                        DeleteObject(register2)
                    end
                end
            end
        end
        Wait(1000)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('qb-storerobbery:server:GetConfig', function(cb)
        Config = cb
    end)
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
end)

RegisterNetEvent('lockpicks:UseLockpick', function(isAdvanced)
    usingAdvanced = isAdvanced
    for k in pairs(Config.Registers) do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - Config.Registers[k][1].xyz)
        if dist <= 1 and not Config.Registers[k].robbed and not Config.Registers[k].stolen then
            QBCore.Functions.TriggerCallback('djkms-jobtracker:GetJobCount', function(CurrentCops)
                if CurrentCops >= QBCore.Shared.IllegalActions["storerobbery"].minimum then
                    if usingAdvanced then
                        lockpick(true)
                        currentRegister = k
                        print(currentRegister)
                        if not IsWearingHandshoes() then
                            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                        end
                        if not copsCalled then
                            -- local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                            -- local street1 = GetStreetNameFromHashKey(s1)
                            -- local street2 = GetStreetNameFromHashKey(s2)
                            -- local streetLabel = street1
                            -- if street2 ~= nil then
                            --     streetLabel = streetLabel .. " " .. street2
                            -- end
                            -- TriggerServerEvent("qb-storerobbery:server:callCops", "cashier", currentRegister, streetLabel, pos)
                            exports['ps-dispatch']:StoreRobbery(Config.Registers[currentRegister].camId)
                            copsCalled = true
                        end
                    else
                        lockpick(true)
                        currentRegister = k
                        if not IsWearingHandshoes() then
                            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                        end
                        if not copsCalled then
                            -- local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                            -- local street1 = GetStreetNameFromHashKey(s1)
                            -- local street2 = GetStreetNameFromHashKey(s2)
                            -- local streetLabel = street1
                            -- if street2 ~= nil then
                            --     streetLabel = streetLabel .. " " .. street2
                            -- end
                            -- TriggerServerEvent("qb-storerobbery:server:callCops", "cashier", currentRegister, streetLabel, pos)
                            exports['ps-dispatch']:StoreRobbery(Config.Registers[currentRegister].camId)
                            copsCalled = true
                        end

                    end

                else
                    QBCore.Functions.Notify(Lang:t("error.minimum_store_robbery_police", { MinimumStoreRobberyPolice = QBCore.Shared.IllegalActions["storerobbery"].minimum}), "error")
                end
            end, "police")
        end
    end
end)

RegisterNetEvent('qb-storerobbery:StealReg', function(ent)
    if QBCore.Functions.HasItem(Config.RegisterStealItem, 1) then
        for k in pairs(Config.Registers) do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = #(pos - Config.Registers[k][1].xyz)
            if dist <= 2 and not Config.Registers[k].stolen then
                QBCore.Functions.TriggerCallback('djkms-jobtracker:GetJobCount', function(CurrentCops)
                    if CurrentCops >= QBCore.Shared.IllegalActions["storerobbery"].minimum then
                        if math.random(0,100) <= 50 then
                            currentwire = 'red'
                        else
                            currentwire = 'blue'
                        end
                        currentRegister = k
                        inRegRange = true
                        cutwires(k, ent)
                    else
                        QBCore.Functions.Notify(Lang:t("error.minimum_store_robbery_police", { MinimumStoreRobberyPolice = QBCore.Shared.IllegalActions["storerobbery"].minimum}), "error")
                    end
                end, "police")
            end
        end
    else
        QBCore.Functions.Notify(Lang:t("error.missingstealitem")..QBCore.Shared.Items[Config.RegisterStealItem].label, "error")
    end
end)

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true

    if model == `mp_m_freemode_01` then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function setupRegister()
    QBCore.Functions.TriggerCallback('qb-storerobbery:server:getRegisterStatus', function(Registers)
        for k in pairs(Registers) do
            Config.Registers[k].robbed = Registers[k].robbed
            Config.Registers[k].stolen = Registers[k].stolen
        end
    end)
end

function setupSafes()
    QBCore.Functions.TriggerCallback('qb-storerobbery:server:getSafeStatus', function(Safes)
        for k in pairs(Safes) do
            Config.Safes[k].robbed = Safes[k].robbed
        end
    end)
end

DrawText3Ds = function(coords, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function cutwires(registerid, entity)
    local wires = {
    }
    wires[#wires + 1] = { header = Lang:t('menu.header'), txt = "", isMenuHeader = true }
    wires[#wires+1] = {
        header = Lang:t('menu.redwire'),
        params = {
            type = "client", 
            event = 'qb-storerobbery:CutWires',
            args = { wire = 'red', id = registerid, ent = entity }
        }
    }
    wires[#wires+1] = {
        header = Lang:t('menu.bluewire'),
        txt = "",
        params = {
            type = "client", 
            event = "qb-storerobbery:CutWires",
            args = { wire = 'blue', id = registerid, ent = entity }
        }
    }
    wires[#wires+1] = {
        header = Lang:t('menu.back'),
        txt = "",
        params = {
            event = "qb-menu:closeMenu",
            args = {}
        }
    }
    exports['qb-menu']:openMenu(wires)
end

RegisterNetEvent('qb-storerobbery:CutWires', function(data)
    exports['ps-dispatch']:StoreRobbery(Config.Registers[data.id].camId)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if data.wire == currentwire then
        local lockpickTime = Config.registerstealtime * 1000
        LockpickDoorAnim(lockpickTime)
        QBCore.Functions.Progressbar("search_register", Lang:t("text.steal_the_register"), lockpickTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "veh@break_in@0h@p_m_one@",
            anim = "low_force_entry_ds",
            flags = 16,
        }, {}, {}, function() -- Done
            isstealing = true
            if DoesEntityExist(data.ent) then
                QBCore.Functions.Notify(Lang:t("error.vehicle_driver"), "info")
                SetEntityAsMissionEntity(data.ent, false, false)
                DeleteObject(data.ent)
                Wait(1500)
                LoadAnimDict('anim@heists@box_carry@')
                TaskPlayAnim(ped, "anim@heists@box_carry@", "idle" ,2.0, 2.0, -1, 51, 0, false, false, false)
                registerobject = CreateObject(joaat('prop_till_01_dam'), pos.x, pos.y, pos.z + 0.2, true, true, true)
                SetEntityCollision(registerobject, false, false)
                AttachEntityToEntity(registerobject, ped, GetPedBoneIndex(ped, 60309), 0.138000, 0.200000, 0.200000, -50.000000, 290.000000, 0.000000, true, true, false, true, 1, true)
                stealingreg()
                randomdeliverloc()
            end
            if not IsWearingHandshoes() then
                TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
            end
            openingDoor = false
            TriggerServerEvent('qb-storerobbery:server:setRegisterStolenStatus', data.id)
        end, function() -- Cancel
            openingDoor = false
            ClearPedTasks(PlayerPedId())
            QBCore.Functions.Notify(Lang:t("error.process_canceled"), "error")
            currentRegister = 0
        end)
        CreateThread(function()
            while openingDoor do
                TriggerServerEvent('hud:server:GainStress', Config.stealRegisterStress)
                Wait(10000)
            end
        end)
    else
        local healt = GetEntityHealth(ped)
        LoadAnimDict( "stungun@standing" ) 
        TaskPlayAnim(ped, "stungun@standing", "damage", 8.0, 1.0, 7000, 1, 0, false, false, false)
        setHealth(healt-Config.FailWireHEalthLoss)
        if not copsCalled then
            local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            local streetLabel = street1
            if street2 ~= nil then
                streetLabel = streetLabel .. " " .. street2
            end
            TriggerServerEvent("qb-storerobbery:server:callCops", "cashier", currentRegister, streetLabel, pos)
            copsCalled = true
        end
    end
end)

function lockpick(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    SetCursorLocation(0.5, 0.2)
end

function takeAnim()
    local ped = PlayerPedId()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Wait(100)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Wait(2500)
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

function setHealth(health)
    local n = math.floor(health)
    SetEntityHealth(GetPlayerPed(-1),n)
end

local openingDoor = false

RegisterNUICallback('success', function(_, cb)
    if currentRegister > 0 then
        lockpick(false)
        TriggerServerEvent('qb-storerobbery:server:setRegisterStatus', currentRegister)
        local lockpickTime = Config.lockpicktime * 1000
        LockpickDoorAnim(lockpickTime)
        QBCore.Functions.Progressbar("search_register", Lang:t("text.emptying_the_register"), lockpickTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "veh@break_in@0h@p_m_one@",
            anim = "low_force_entry_ds",
            flags = 16,
        }, {}, {}, function() -- Done
            openingDoor = false
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('qb-storerobbery:server:takeMoney', currentRegister, true)
        end, function() -- Cancel
            openingDoor = false
            ClearPedTasks(PlayerPedId())
            QBCore.Functions.Notify(Lang:t("error.process_canceled"), "error")
            currentRegister = 0
        end)
        CreateThread(function()
            while openingDoor do
                TriggerServerEvent('hud:server:GainStress', Config.lockpickStress)
                Wait(10000)
            end
        end)
    else
        SendNUIMessage({
            action = "kekw",
        })
    end
    cb('ok')
end)

function LockpickDoorAnim(time)
    isstealing = true
    time = time / 1000
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    LoadAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
    TaskPlayAnim(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" ,3.0, 3.0, -1, 16, 0, false, false, false)
    local lockpickprop = CreateObject(joaat('bzzz_props_lockpick_01'), pos.x, pos.y, pos.z + 0.2, true, true, true)
    SetEntityCollision(lockpickprop, false, false)
    AttachEntityToEntity(lockpickprop, ped, GetPedBoneIndex(ped, 18905), 0.12, 0.08, -0.01, -36.0, -46.0, 0.0, true, true, false, true, 1, true)
    openingDoor = true
    CreateThread(function()
        while openingDoor do
            TaskPlayAnim(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Wait(2000)
            time = time - 2
            TriggerServerEvent('qb-storerobbery:server:takeMoney', currentRegister, false)
            if time <= 0 then
                openingDoor = false
                StopAnimTask(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                if DoesEntityExist(lockpickprop) then
                    DetachEntity(lockpickprop,true,false)
                    SetEntityAsMissionEntity(lockpickprop, false, false)
                    DeleteObject(lockpickprop)
                end
                isstealing = false
            end
        end
        -- currentRegister = 0
    end)
end

RegisterNUICallback('callcops', function(_, cb)
    exports['ps-dispatch']:StoreRobbery(Config.Registers[currentRegister].camId)
    cb('ok')
end)

RegisterNetEvent('qb-storerobbery:client:Minigame', function()
    local won = exports["pd-safe"]:createSafe({math.random(0,99), math.random(0,99)})
    if won then
        if currentSafe ~= 0 then
            if won then
                if currentSafe ~= 0 then
                    if not Config.Safes[currentSafe].robbed then
                        SetNuiFocus(false, false)
                        TriggerServerEvent("qb-storerobbery:server:SafeReward", currentSafe)
                        TriggerServerEvent("qb-storerobbery:server:setSafeStatus", currentSafe)
                        currentSafe = 0
                        takeAnim()
                    end
                else
                    SendNUIMessage({
                        action = "kekw",
                    })
                end
            end
        end
    else
        QBCore.Functions.Notify(Lang:t("error.failedsafe"))
    end
    copsCalled = false
end)

RegisterNetEvent('SafeCracker:EndMinigame', function(won)
    if currentSafe ~= 0 then
        if won then
            if currentSafe ~= 0 then
                if not Config.Safes[currentSafe].robbed then
                    SetNuiFocus(false, false)
                    TriggerServerEvent("qb-storerobbery:server:SafeReward", currentSafe)
                    TriggerServerEvent("qb-storerobbery:server:setSafeStatus", currentSafe)
                    currentSafe = 0
                    takeAnim()
                end
            else
                SendNUIMessage({
                    action = "kekw",
                })
            end
        end
    end
    copsCalled = false
end)

RegisterNUICallback('PadLockSuccess', function(_, cb)
    if currentSafe ~= 0 then
        if not Config.Safes[currentSafe].robbed then
            SendNUIMessage({
                action = "kekw",
            })
        end
    else
        SendNUIMessage({
            action = "kekw",
        })
    end
    cb('ok')
end)

RegisterNUICallback('PadLockClose', function(_, cb)
    SetNuiFocus(false, false)
    copsCalled = false
    cb('ok')
end)

RegisterNUICallback("CombinationFail", function(_, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    cb("ok")
end)

RegisterNUICallback('fail', function(_ ,cb)
    if usingAdvanced then
        if math.random(1, 100) < 20 then
            TriggerServerEvent("qb-storerobbery:server:removeAdvancedLockpick")
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["advancedlockpick"], "remove")
        end
    else
        if math.random(1, 100) < 40 then
            TriggerServerEvent("qb-storerobbery:server:removeLockpick")
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["lockpick"], "remove")
        end
    end
    if (IsWearingHandshoes() and math.random(1, 100) <= 25) then
        local pos = GetEntityCoords(PlayerPedId())
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
        QBCore.Functions.Notify(Lang:t("error.you_broke_the_lock_pick"))
    end
    lockpick(false)
    cb('ok')
end)

RegisterNUICallback('exit', function(_, cb)
    lockpick(false)
    cb('ok')
end)

RegisterNUICallback('TryCombination', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-storerobbery:server:isCombinationRight', function(combination)
        if tonumber(data.combination) ~= nil then
            if tonumber(data.combination) == combination then
                TriggerServerEvent("qb-storerobbery:server:SafeReward", currentSafe)
                TriggerServerEvent("qb-storerobbery:server:setSafeStatus", currentSafe)
                SetNuiFocus(false, false)
                SendNUIMessage({
                    action = "closeKeypad",
                    error = false,
                })
                currentSafe = 0
                takeAnim()
            else
                SetNuiFocus(false, false)
                SendNUIMessage({
                    action = "closeKeypad",
                    error = true,
                })
                currentSafe = 0
            end
        end
        cb("ok")
    end, currentSafe)
end)

RegisterNetEvent('qb-storerobbery:client:setRegisterStatus', function(batch, val)
    -- Has to be a better way maybe like adding a unique id to identify the register
    if(type(batch) ~= "table") then
        Config.Registers[batch] = val
    else
        for k in pairs(batch) do
            Config.Registers[k] = batch[k]
        end
    end
end)

RegisterNetEvent('qb-storerobbery:client:updateConfig', function(conf)
    Config = conf
end)
RegisterNetEvent('qb-storerobbery:client:setSafeStatus', function(safe, bool)
    Config.Safes[safe].robbed = bool
end)

RegisterNetEvent('qb-storerobbery:client:robberyCall', function(cam)
    exports['ps-dispatch']:StoreRobbery(cam)
    -- if (PlayerJob.name == "police" or PlayerJob.type == "leo") and onDuty then
    --     PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    --     TriggerServerEvent('police:server:policeAlert', Lang:t("email.storerobbery_progress"))

    --     local transG = 250
    --     local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    --     SetBlipSprite(blip, 458)
    --     SetBlipColour(blip, 1)
    --     SetBlipDisplay(blip, 4)
    --     SetBlipAlpha(blip, transG)
    --     SetBlipScale(blip, 1.0)
    --     BeginTextCommandSetBlipName('STRING')
    --     AddTextComponentString(Lang:t("email.shop_robbery"))
    --     EndTextCommandSetBlipName(blip)
    --     while transG ~= 0 do
    --         Wait(180 * 4)
    --         transG = transG - 1
    --         SetBlipAlpha(blip, transG)
    --         if transG == 0 then
    --             SetBlipSprite(blip, 2)
    --             RemoveBlip(blip)
    --             return
    --         end
    --     end
    -- end
end)