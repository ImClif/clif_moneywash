local Callback = C_CALLBACK()
local QBCore = exports['qb-core']:GetCoreObject() 
local percentage = config.percentage

RegisterNUICallback('WashMoney', function(money)
    Callback('wash:GetAccountBalance', function(balance, zero, washPercentage)
        if washPercentage == 0 then
            Notify('You need the correct laundry card to wash this type of money', 'error')
            return
        end
        
        if zero == 'notzero' then 
            if balance then 
                SendNUIMessage({
                    start = 'MoneyWash',
                    washed = 'Amount Washed $'..tostring(math.floor(washPercentage / 100 * money.amount)),
                    take = math.floor(washPercentage / 100 * money.amount)
                })
            else
                Notify('You dont have enough money', 'error')
            end
        elseif zero == 'zero' then 
            Notify('You must put an amount greater than 0', 'error')
        end
    end, money.amount)
end)

RegisterNUICallback('TakeMoney', function(cash)
    Callback('wash:AddAccountBalance', function(finished)
        if finished then 
            Notify('You recieved $'..tostring(cash.money) , 'success')
        end
    end, cash.money)
end)

RegisterNUICallback('FocusToggle', function(switch)
    local toggle = switch.toggle
    if toggle then 
        SetNuiFocus(true, true)
    else
        SetNuiFocus(false, false)
    end
end)

function Notify(msg, types)
    lib.notify({
        id = 'browns_moneywash',
        title = 'Money Wash',
        description = msg,
        duration = 5000,
        position = 'top',
        type = types,
        style = {
            backgroundColor = '#000000',
            color = '#008000',
            ['.description'] = {
              color = '#008000'
            }
        },
    })
end

Citizen.CreateThread(function()

    local QBCore = exports['qb-core']:GetCoreObject()

    while not LocalPlayer.state.isLoggedIn do
        Citizen.Wait(100)
    end


    local playerData = QBCore.Functions.GetPlayerData()
    local playerJob = playerData.job.name


    for _, machines in ipairs(config.washlocations.public) do 
        SpawnWashMachine(machines)
    end


    if config.washlocations.jobs[playerJob] then
        for _, machines in ipairs(config.washlocations.jobs[playerJob]) do 
            SpawnWashMachine(machines)
        end
    end
end)


function SpawnWashMachine(machine)
    if machine.spawnProp then
        local model = GetHashKey('prop_washer_02')
        if not HasModelLoaded(model) then 
            RequestModel(model)
            while not HasModelLoaded(model) do 
                Citizen.Wait(0) 
            end
        end 
        local object = CreateObject(model, machine.coords.x, machine.coords.y, machine.coords.z, false, false, false)
        SetEntityInvincible(object, true)
        SetEntityHeading(object, machine.heading)
        FreezeEntityPosition(object, true)
        AddTarget({
            entity = object,
            type = 'entity'
        })
    else
        AddTarget({
            coords = machine.coords,
            type = 'coords'
        })
    end
end

function AddTarget(data)
    local target = config.target
    local options = {
        {
            icon = 'fas fa-dollar-sign',
            label = 'Wash Money', 
            onSelect = function()
                Callback('wash:StartAccountBalance', function(bal)
                    SetNuiFocus(true, true)
                    local thisBal = bal if thisBal == nil then thisBal = 0 end
                    SendNUIMessage({
                        start = 'UI',
                        text = 'Washable Amount $'..tostring(thisBal),
                        marked = config.dirtymoney.UsingMarkedMoney
                    })
                end)
            end
        }
    }

    if data.type == 'coords' then
        -- Coordinate-based targeting
        if target == 'qb-target' then 
            exports['qb-target']:AddBoxZone('moneywash_'..math.random(1000), data.coords, 1.0, 1.0, {
                name = 'moneywash',
                heading = 0,
                debugPoly = false,
                minZ = data.coords.z - 1,
                maxZ = data.coords.z + 1,
            }, {
                options = options,
                distance = 2.5
            })
        elseif target == 'qtarget' then 
            exports.qtarget:AddBoxZone('moneywash_'..math.random(1000), data.coords, 1.0, 1.0, {
                name = 'moneywash',
                heading = 0,
                debugPoly = false,
                minZ = data.coords.z - 1,
                maxZ = data.coords.z + 1,
            }, {
                options = options,
                distance = 2.5
            })
        elseif target == 'ox_target' then 
            exports.ox_target:addBoxZone({
                coords = data.coords,
                size = vec3(1, 1, 2),
                rotation = 0,
                debug = false,
                distance = 3.5,
                options = {
                    {
                        icon = 'fas fa-dollar-sign',
                        label = 'Wash Money',
                        distance = 3.5,
                        onSelect = function()
                            Callback('wash:StartAccountBalance', function(bal)
                                SetNuiFocus(true, true)
                                local thisBal = bal if thisBal == nil then thisBal = 0 end
                                SendNUIMessage({
                                    start = 'UI',
                                    text = 'Washable Amount $'..tostring(thisBal),
                                    marked = config.dirtymoney.UsingMarkedMoney
                                })
                            end)
                        end
                    }
                }
            })
        end
    else
        -- Entity/prop-based targeting
        if target == 'qb-target' then 
            exports['qb-target']:AddTargetEntity(data.entity, {
                options = options,
                distance = 2.5
            })
        elseif target == 'qtarget' then 
            exports.qtarget:AddTargetEntity(data.entity, {
                options = options,
                distance = 2.5
            })
        elseif target == 'ox_target' then 
            exports.ox_target:addLocalEntity(data.entity, {
                {
                    icon = 'fas fa-dollar-sign',
                    label = 'Wash Money',
                    distance = 3.5,
                    onSelect = function()
                        Callback('wash:StartAccountBalance', function(bal)
                            SetNuiFocus(true, true)
                            local thisBal = bal if thisBal == nil then thisBal = 0 end
                            SendNUIMessage({
                                start = 'UI',
                                text = 'Washable Amount $'..tostring(thisBal),
                                marked = config.dirtymoney.UsingMarkedMoney
                            })
                        end)
                    end
                }
            })
        end
    end
end



Citizen.CreateThread(function()
    local blipsettings = config.blip_settings
    if blipsettings.enable then 

        for _, loc in ipairs(config.washlocations.public) do
            CreateWashBlip(loc, blipsettings)
        end


        while not LocalPlayer.state.isLoggedIn do
            Citizen.Wait(100)
        end


        local playerData = QBCore.Functions.GetPlayerData()
        if not playerData or not playerData.job then
            print("Error: Failed to retrieve player job data")
            return
        end
        
        local playerJob = playerData.job.name

        if config.washlocations.jobs[playerJob] then
            for _, loc in ipairs(config.washlocations.jobs[playerJob]) do
                CreateWashBlip(loc, blipsettings)
            end
        end
    end
end)


function CreateWashBlip(loc, settings)
    local blip = AddBlipForCoord(loc.coords.x, loc.coords.y, loc.coords.z)
    SetBlipSprite(blip, settings.sprite)
    SetBlipColour(blip, settings.color)
    SetBlipDisplay(blip, 4)
    SetBlipAlpha(blip, 250)
    SetBlipScale(blip, settings.scale)
    SetBlipAsShortRange(blip, true)
    PulseBlip(blip)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(settings.label)
    EndTextCommandSetBlipName(blip)
end
