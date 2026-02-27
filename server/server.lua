local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `playtime_points` (
            `citizenid`     VARCHAR(50) NOT NULL,
            `points`        INT         DEFAULT 0,
            `total_minutes` INT         DEFAULT 0,
            `last_updated`  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`citizenid`)
        )
    ]])
end)

local function GeneratePlate()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    return result and GeneratePlate() or plate:upper()
end

local function IsAdmin(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    local permission = Player.PlayerData.permission
    local group      = Player.PlayerData.group
    for _, g in ipairs(Config.AdminGroups) do
        if permission == g or group == g then return true end
    end
    if QBCore.Functions.HasPermission then
        for _, g in ipairs(Config.AdminGroups) do
            if QBCore.Functions.HasPermission(source, g) then return true end
        end
    end
    return false
end

local function GetOrCreatePlayer(citizenid)
    local result = MySQL.query.await('SELECT * FROM playtime_points WHERE citizenid = ?', { citizenid })
    if result and #result > 0 then return result[1] end
    MySQL.insert('INSERT INTO playtime_points (citizenid, points, total_minutes) VALUES (?, 0, 0)', { citizenid })
    return { citizenid = citizenid, points = 0, total_minutes = 0 }
end

local builtItems = nil

local function BuildItemsForUI()
    if builtItems then return builtItems end
    local result = {}
    for i, v in ipairs(Config.ShopItems) do
        local item = {}
        for k, val in pairs(v) do item[k] = val end
        if not item.id then
            item.id = (item.action or 'item') .. '_' .. i
        end
        if not item.image or item.image == '' then
            local itemName = item.item
            if itemName then
                local sharedItem = QBCore.Shared.Items[itemName]
                if sharedItem and sharedItem.image then
                    local img = sharedItem.image
                    item.image = (string.find(img, 'nui://') or string.find(img, 'http')) and img or (Config.InventoryImagePath .. img)
                else
                    item.image = Config.InventoryImagePath .. itemName .. '.png'
                end
            else
                item.image = ''
            end
        end
        result[#result + 1] = item
    end
    builtItems = result
    return builtItems
end

local itemLookup = nil

local function GetItemLookup()
    if itemLookup then return itemLookup end
    itemLookup = {}
    for i, v in ipairs(Config.ShopItems) do
        local id = v.id or ((v.action or 'item') .. '_' .. i)
        itemLookup[id] = v
    end
    return itemLookup
end

QBCore.Functions.CreateCallback('playtime:getPlayerData', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(nil) end
    local data = GetOrCreatePlayer(Player.PlayerData.citizenid)
    cb({ points = data.points, total_minutes = data.total_minutes, intervalMinutes = Config.PointInterval })
end)

QBCore.Functions.CreateCallback('playtime:getShopItems', function(source, cb)
    cb(BuildItemsForUI(), Config.Categories)
end)

QBCore.Functions.CreateCallback('playtime:purchase', function(source, cb, itemId)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false, 'Player not found') end

    local citizenid = Player.PlayerData.citizenid
    local data      = GetOrCreatePlayer(citizenid)
    local item      = GetItemLookup()[itemId]

    if not item then return cb(false, 'Item not found') end
    if data.points < item.price then return cb(false, 'Not enough points') end

    local newPoints = data.points - item.price
    MySQL.update('UPDATE playtime_points SET points = ? WHERE citizenid = ?', { newPoints, citizenid })

    if item.action == 'money' then
        Player.Functions.AddMoney('cash', item.amount)
        TriggerClientEvent('QBCore:Notify', source, 'Successfully purchased ' .. item.label .. '!', 'success')
    elseif item.action == 'bank' then
        Player.Functions.AddMoney('bank', item.amount)
        TriggerClientEvent('QBCore:Notify', source, 'Successfully purchased ' .. item.label .. '!', 'success')
    elseif item.action == 'weapon' then
        local weaponItem = item.item
        Player.Functions.AddItem(weaponItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[weaponItem], 'add')
        TriggerClientEvent('QBCore:Notify', source, 'Successfully purchased ' .. item.label .. '!', 'success')
    elseif item.action == 'item' then
        Player.Functions.AddItem(item.item, item.amount or 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item.item], 'add')
        TriggerClientEvent('QBCore:Notify', source, 'Successfully purchased ' .. item.label .. '!', 'success')
    elseif item.action == 'vehicle' then
        local plate = GeneratePlate()
        MySQL.insert(
            'INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            { Player.PlayerData.license, citizenid, item.model, GetHashKey(item.model), '{}', plate, item.garage or 'pillboxgarage', 0 }
        )
        TriggerClientEvent('QBCore:Notify', source, 'Vehicle added to your garage! Plate: [' .. plate .. ']', 'success')
    end

    cb(true, newPoints)
end)

CreateThread(function()
    while true do
        Wait(Config.PointInterval * 60 * 1000)
        local players = QBCore.Functions.GetPlayers()
        for _, src in ipairs(players) do
            local Player = QBCore.Functions.GetPlayer(src)
            if Player then
                local citizenid = Player.PlayerData.citizenid
                MySQL.update([[
                    INSERT INTO playtime_points (citizenid, points, total_minutes) VALUES (?, ?, ?)
                    ON DUPLICATE KEY UPDATE points = points + ?, total_minutes = total_minutes + ?
                ]], { citizenid, Config.PointsPerInterval, Config.PointInterval, Config.PointsPerInterval, Config.PointInterval })
                TriggerClientEvent('playtime:pointsUpdated', src)
            end
        end
    end
end)

RegisterCommand('addp', function(source, args)
    if not IsAdmin(source) then
        TriggerClientEvent('QBCore:Notify', source, 'You do not have permission to use this command.', 'error')
        return
    end
    local targetId = tonumber(args[1])
    local amount   = tonumber(args[2])
    if not targetId or not amount then
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /addp [Player ID] [Points]', 'error')
        return
    end
    local Target = QBCore.Functions.GetPlayer(targetId)
    if not Target then
        TriggerClientEvent('QBCore:Notify', source, 'Player not found.', 'error')
        return
    end
    local citizenid = Target.PlayerData.citizenid
    MySQL.update([[
        INSERT INTO playtime_points (citizenid, points, total_minutes) VALUES (?, ?, 0)
        ON DUPLICATE KEY UPDATE points = points + ?
    ]], { citizenid, amount, amount })
    TriggerClientEvent('QBCore:Notify', targetId, 'You received ' .. amount .. ' points!', 'success')
    TriggerClientEvent('QBCore:Notify', source, 'Added ' .. amount .. ' points to player ' .. targetId .. '.', 'success')
    TriggerClientEvent('playtime:pointsUpdated', targetId)
end, false)

-- https://discord.gg/zx0
--[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]