local Callback = S_CALLBACK()

Callback('wash:GetAccountBalance', function(source, cb, input)
    local src = source
    local balance = false
    local zero = 'zero'
    
    -- First check if player can wash this type of money
    if not CanWashMoney(src) then
        cb(false, 'zero', 0)
        return
    end
    
    if math.floor(tonumber(input)) ~= 0 then
        zero = 'notzero'
        if GetMoney(src) >= math.floor(tonumber(input)) then 
            balance = true
            RemoveMoney(src, math.floor(tonumber(input)))
        end
    end
    local percentage = GetWashPercentage(src)
    cb(balance, zero, percentage)
end)

Callback('wash:AddAccountBalance', function(source, cb, returns)
    local src = source 
    AddMoney(src, tonumber(returns))
    cb(true)
end)

Callback('wash:StartAccountBalance', function(source, cb)
    local src = source 
    cb(GetMoney(src))
end)