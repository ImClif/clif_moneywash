local CORES = config.framework
local INV = config.inventory
local MONEYITEM = config.dirtymoney.DirtyMoneyName 
local MARKEDMONEYITEM = config.dirtymoney.MarkedMoneyName
function getCore()
    if CORES == 'esx' then 
        return exports['es_extended']:getSharedObject()
    elseif CORES == 'qb-core' then 
        return exports['qb-core']:GetCoreObject()
    end
end

function getPlayer(source)
    local _CORE = getCore()
    if CORES == 'qb-core' then 
        return _CORE.Functions.GetPlayer(source)
    elseif CORES == 'esx' then 
        return _CORE.GetPlayerFromId(source)
    end
end

function AddMoney(source, amount)
    local xPlayer = getPlayer(source)
    if CORES == 'qb-core' then 
        return xPlayer.Functions.AddMoney('cash', amount, 'Washed Money')
    elseif CORES == 'esx' then 
        return xPlayer.addMoney(amount)
    end
end

function RemoveMoney(source, amount)
    local _CORE = getCore()
    local xPlayer = getPlayer(source)
    if not config.dirtymoney.UsingMarkedMoney then 
        if config.dirtymoney.DirtyMoneyItem then 
            if INV == 'qb-inventory' then 
                exports['qb-inventory']:RemoveItem(source, MONEYITEM, amount)
                if CORES == 'qb-core' then 
                    TriggerClientEvent('inventory:client:ItemBox', source, _CORE.Shared.Items[MONEYITEM], "remove")
                end
            elseif INV == 'qs-inventory' then 
                exports['qs-inventory']:RemoveItem(source, MONEYITEM, amount)
                if CORES == 'qb-core' then 
                    TriggerClientEvent('inventory:client:ItemBox', source, _CORE.Shared.Items[MONEYITEM], "remove")
                end
            elseif INV == 'lj-inventory' then 
                exports['lj-inventory']:RemoveItem(source, MONEYITEM, amount)
                if CORES == 'qb-core' then 
                    TriggerClientEvent('inventory:client:ItemBox', source, _CORE.Shared.Items[MONEYITEM], "remove")
                end
            elseif INV == 'ps-inventory' then 
                exports['ps-inventory']:RemoveItem(source, MONEYITEM, amount)
                if CORES == 'qb-core' then 
                    TriggerClientEvent('inventory:client:ItemBox', source, _CORE.Shared.Items[MONEYITEM], "remove")
                end
            elseif INV == 'ox_inventory' then 
                exports.ox_inventory:RemoveItem(source, MONEYITEM, amount)
            end
        else
            if CORES == 'qb-core' then 
                xPlayer.Functions.RemoveMoney(MONEYITEM, amount, 'Money Wash')
            elseif CORES == 'esx' then 
                xPlayer.removeAccountMoney(MONEYITEM, amount)
            end
        end
    else
        if INV == 'qb-inventory' then 
            local item = exports['qb-inventory']:GetItemsByName(source, MARKEDMONEYITEM)
            for i =1, #item do 
                local markeditem = item[i]
                exports['qb-inventory']:RemoveItem(source, MARKEDMONEYITEM, markeditem.amount)
                if CORES == 'qb-core' then 
                    TriggerClientEvent('inventory:client:ItemBox', source, _CORE.Shared.Items[MARKEDMONEYITEM], "remove")
                end
            end
        elseif INV == 'qs-inventory' then 
            local item = exports['qs-inventory']:GetItemsByName(source, MARKEDMONEYITEM)
            for i =1, #item do 
                local markeditem = item[i]
                exports['qs-inventory']:RemoveItem(source, MARKEDMONEYITEM, markeditem.amount)
                if CORES == 'qb-core' then 
                    TriggerClientEvent('inventory:client:ItemBox', source, _CORE.Shared.Items[MARKEDMONEYITEM], "remove")
                end
            end
        elseif INV == 'lj-inventory' then 
            local item = exports['lj-inventory']:GetItemsByName(source, MARKEDMONEYITEM)
            for i =1, #item do 
                local markeditem = item[i]
                exports['lj-inventory']:RemoveItem(source, MARKEDMONEYITEM, markeditem.amount)
                if CORES == 'qb-core' then 
                    TriggerClientEvent('inventory:client:ItemBox', source, _CORE.Shared.Items[MARKEDMONEYITEM], "remove")
                end
            end
        elseif INV == 'ps-inventory' then 
            local item = exports['ps-inventory']:GetItemsByName(source, MARKEDMONEYITEM)
            for i =1, #item do 
                local markeditem = item[i]
                exports['ps-inventory']:RemoveItem(source, MARKEDMONEYITEM, markeditem.amount)
                if CORES == 'qb-core' then 
                    TriggerClientEvent('inventory:client:ItemBox', source, _CORE.Shared.Items[MARKEDMONEYITEM], "remove")
                end
            end
        end
    end
end

function GetMoney(source)
    local xPlayer = getPlayer(source)
    if not config.dirtymoney.UsingMarkedMoney then 
        if config.dirtymoney.DirtyMoneyItem then 
            if INV == 'qb-inventory' then 
                local item = exports['qb-inventory']:GetItemByName(source, MONEYITEM)
                if item == nil then return 0 else return item.amount end
            elseif INV == 'qs-inventory' then 
                local item = exports['qs-inventory']:GetItemByName(source, MONEYITEM)
                if item == nil then return 0 else return item.amount end
            elseif INV == 'lj-inventory' then 
                local item = exports['lj-inventory']:GetItemByName(source, MONEYITEM)
                if item == nil then return 0 else return item.amount end
            elseif INV == 'ps-inventory' then 
                local item = exports['ps-inventory']:GetItemByName(source, MONEYITEM)
                if item == nil then return 0 else return item.amount end
            elseif INV == 'ox_inventory' then 
                local item = exports.ox_inventory:GetItemCount(source, MONEYITEM)
                if item == nil then return 0 else return item end
            end
        else
            if CORES == 'qb-core' then 
                return xPlayer.Functions.GetMoney(MONEYITEM)
            elseif CORES == 'esx' then 
                local account = xPlayer.getAccount(MONEYITEM)
                return account.money
            end
        end
    else
        if INV == 'qb-inventory' then 
            local item = exports['qb-inventory']:GetItemsByName(source, MARKEDMONEYITEM)
            local markedmoney = 0
            if item == nil then 
                return 0 
            else 
                for i = 1, #item do 
                    local money = item[i]
                    if tonumber(money.amount) > 1 then 
                        markedmoney = markedmoney + tonumber(money.info.worth) * tonumber(money.amount)
                    else
                        markedmoney = markedmoney + tonumber(money.info.worth) 
                    end
                end
                return markedmoney
            end
        elseif INV == 'qs-inventory' then 
            local item = exports['qs-inventory']:GetItemsByName(source, MARKEDMONEYITEM)
            local markedmoney = 0
            if item == nil then 
                return 0 
            else 
                for i = 1, #item do 
                    local money = item[i]
                    if tonumber(money.amount) > 1 then 
                        markedmoney = markedmoney + tonumber(money.info.worth) * tonumber(money.amount)
                    else
                        markedmoney = markedmoney + tonumber(money.info.worth) 
                    end
                end
                return markedmoney
            end
        elseif INV == 'lj-inventory' then 
            local item = exports['lj-inventory']:GetItemsByName(source, MARKEDMONEYITEM)
            local markedmoney = 0
            if item == nil then 
                return 0 
            else 
                for i = 1, #item do 
                    local money = item[i]
                    if tonumber(money.amount) > 1 then 
                        markedmoney = markedmoney + tonumber(money.info.worth) * tonumber(money.amount)
                    else
                        markedmoney = markedmoney + tonumber(money.info.worth) 
                    end
                end
                return markedmoney
            end
        elseif INV == 'ps-inventory' then 
            local item = exports['ps-inventory']:GetItemsByName(source, MARKEDMONEYITEM)
            local markedmoney = 0
            if item == nil then 
                return 0 
            else 
                for i = 1, #item do 
                    local money = item[i]
                    if tonumber(money.amount) > 1 then 
                        markedmoney = markedmoney + tonumber(money.info.worth) * tonumber(money.amount)
                    else
                        markedmoney = markedmoney + tonumber(money.info.worth) 
                    end 
                end
                return markedmoney
            end
        end
    end     
end

function GetWashPercentage(source)
    local xPlayer = getPlayer(source)
    local percentage = config.percentage.default
    
    -- Check for job-based percentage
    if CORES == 'qb-core' then
        local job = xPlayer.PlayerData.job.name
        if config.percentage.jobs[job] then
            percentage = config.percentage.jobs[job]
        end
    elseif CORES == 'esx' then
        local job = xPlayer.job.name
        if config.percentage.jobs[job] then
            percentage = config.percentage.jobs[job]
        end
    end
    
    -- Check for laundry card percentage
    for item, itemPercentage in pairs(config.percentage.items) do
        if HasItem(source, item) then
            -- Use the highest percentage found from any laundry card
            if itemPercentage > percentage then
                percentage = itemPercentage
            end
        end
    end
    
    return percentage
end

function CanWashMoney(source)
    if config.dirtymoney.DirtyMoneyItem and not config.dirtymoney.UsingMarkedMoney then
        local itemConfig = config.percentage.items[MONEYITEM]
        if itemConfig then
            return HasItem(source, itemConfig.required_card)
        end
    end
    return true
end

function C_CALLBACK()
    local _CORE = getCore()
    if CORES == 'qb-core' then 
        return _CORE.Functions.TriggerCallback
    elseif CORES == 'esx' then
        return _CORE.TriggerServerCallback
    end 
end

function S_CALLBACK()
    local _CORE = getCore()
    if CORES == 'qb-core' then 
        return _CORE.Functions.CreateCallback
    elseif CORES == 'esx' then 
        return _CORE.RegisterServerCallback
    end 
end

function HasItem(source, item)
    local _CORE = getCore()
    local xPlayer = getPlayer(source)
    
    if CORES == 'qb-core' then
        if INV == 'qb-inventory' then
            local hasItem = exports['qb-inventory']:GetItemByName(source, item)
            return hasItem and hasItem.amount > 0
        elseif INV == 'qs-inventory' then
            local hasItem = exports['qs-inventory']:GetItemByName(source, item)
            return hasItem and hasItem.amount > 0
        elseif INV == 'lj-inventory' then
            local hasItem = exports['lj-inventory']:GetItemByName(source, item)
            return hasItem and hasItem.amount > 0
        elseif INV == 'ps-inventory' then
            local hasItem = exports['ps-inventory']:GetItemByName(source, item)
            return hasItem and hasItem.amount > 0
        elseif INV == 'ox_inventory' then
            local count = exports.ox_inventory:GetItemCount(source, item)
            return count and count > 0
        end
    elseif CORES == 'esx' then
        local item = xPlayer.getInventoryItem(item)
        return item and item.count > 0
    end
    return false
end
