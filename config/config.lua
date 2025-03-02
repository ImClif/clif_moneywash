config = {}

config.framework = 'qb-core' -- 'qb-core' or 'esx'

config.inventory = 'ox_inventory' -- 'qb-inventory', 'ox_inventory', 'qs-inventory', 'ps-inventory', or 'lj-inventory'

config.target = 'ox_target' -- 'qb-target', 'ox_target', or 'qtarget'

config.percentage = {
    default = 60,
    jobs = {
        ['police'] = 80,
        ['lawyer'] = 85,
        ['banker'] = 90,
    },
    items = {
        ['laundrycard'] = 70,
        ['laundrycard2'] = 80,
        ['laundrycard3'] = 90,
    }
}

config.dirtymoney = {

    UsingMarkedMoney = false, -- if using Marked Money (QBCore) then set this to true and ignore "DirtyMoneyItem" & "DirtyMoneyName"

    MarkedMoneyName = 'markedbills', -- the name of your Marked Money (QBCore) only change if "UsingMarkedMoney" is true

    DirtyMoneyItem = true, -- (true/false) is dirty money an item

    -- if DirtyMoneyItem = false then put the account name ('cash', 'bank', 'dirtymoney', etc.) for DirtyMoneyName
    -- if DirtyMoneyItem = true then put your dirty money item name for DirtyMoneyName
    DirtyMoneyName = 'black_money' 

}

config.washlocations = {
    -- Public locations (accessible by everyone)
    public = {
        {coords = vector3(1320.0531005859, 1143.4083251953, 13.996887207), heading = 184.1, spawnProp = true},
        {coords = vector3(-804.4303, 1633.1250, 12.7254), heading = 271.86, spawnProp = false},
        {coords = vector3(-801.33111572266, 1624.8060302734, 13.730665588379), heading = 174.3, spawnProp = false},
        {coords = vector3(1265.3048095703, 172.55966186523, 19.216753005981), heading = 94.3, spawnProp = true},
        {coords = vector3(1320.0837402344, 1143.2373046875, 38.713981628418), heading = 1.3},
        {coords = vector3(-83.761726379395, 608.73754882812, 10.177791595459), heading = 88.96},
    },
    
    -- Job-specific locations
    jobs = {
        ['police'] = {
            {coords = vector3(10, 10, 10), heading = 90, spawnProp = true},
            {coords = vector3(20, 20, 20), heading = 180, spawnProp = false},
        },
        ['luchettis'] = {
            {coords = vector3(-83.761726379395, 608.73754882812, 10.177791595459), heading = 88.96},
        },
        -- Add more job-specific locations as needed
    }
}

config.blip_settings  = {
    enable = false, -- enable or disable money wash blip (true/false)
    sprite = 500, -- blip sprite/icon (see ref: https://docs.fivem.net/docs/game-references/blips/#blips)
    color = 2, -- blip color (see ref: https://docs.fivem.net/docs/game-references/blips/#blip-colors)
    scale = 0.7, -- blip scale/size (0.1 - 1.0)
    label = 'Money Wash' -- blip label/name
}
