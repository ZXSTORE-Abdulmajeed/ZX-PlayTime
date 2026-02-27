local QBCore = exports['qb-core']:GetCoreObject()
local isOpen = false
local sessionStart = GetGameTimer()

local function CloseUI()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
end

local function OpenUI()
    if isOpen then return end
    isOpen = true
    SetNuiFocus(true, true)
    QBCore.Functions.TriggerCallback('playtime:getPlayerData', function(data)
        if not data then
            isOpen = false
            SetNuiFocus(false, false)
            return
        end
        QBCore.Functions.TriggerCallback('playtime:getShopItems', function(items, categories)
            SendNUIMessage({
                type            = 'open',
                points          = data.points,
                total_minutes   = data.total_minutes,
                intervalMinutes = data.intervalMinutes,
                items           = items,
                categories      = categories,
                sessionSeconds  = math.floor((GetGameTimer() - sessionStart) / 1000)
            })
        end)
    end)
end

RegisterNUICallback('close', function(_, cb)
    isOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('purchase', function(data, cb)
    QBCore.Functions.TriggerCallback('playtime:purchase', function(success, result)
        cb(success and { success = true, newPoints = result } or { success = false, reason = result })
    end, data.itemId)
end)

RegisterCommand('playtime', function()
    if isOpen then
        SendNUIMessage({ type = 'forceClose' })
    else
        OpenUI()
    end
end, false)

TriggerEvent('chat:addSuggestion', '/playtime', 'Open the Playtime Reward Shop')
TriggerEvent('chat:addSuggestion', '/addp', 'Add points to a player (Admin only)', {
    { name = 'id',     help = 'Player Server ID' },
    { name = 'amount', help = 'Amount of points'  }
})

RegisterNetEvent('playtime:pointsUpdated', function()
    QBCore.Functions.TriggerCallback('playtime:getPlayerData', function(data)
        if data then
            SendNUIMessage({ type = 'syncPoints', points = data.points })
        end
    end)
end)

local nextPoint = Config.PointInterval * 60

CreateThread(function()
    while true do
        Wait(1000)
        nextPoint = nextPoint - 1
        if nextPoint <= 0 then nextPoint = Config.PointInterval * 60 end
        if isOpen then
            SendNUIMessage({ type = 'countdown', remaining = nextPoint })
        end
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        if isOpen then
            SendNUIMessage({ type = 'updateSession', sessionSeconds = math.floor((GetGameTimer() - sessionStart) / 1000) })
        end
    end
end)

-- https://discord.gg/zx0
--[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]----[ZXSTORE]