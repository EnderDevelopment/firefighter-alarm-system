local ESX = nil
local PlayerData = {}
local alarmActive = false
local magnetShieldActive = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, fireStation in ipairs(Config.FireStations) do
            local distance = #(playerCoords - fireStation.coords)

            if distance < fireStation.radius then
                if not alarmActive then
                    TriggerServerEvent('ff_alarm_system:startAlarm', fireStation.name)
                    alarmActive = true
                end

                if IsControlJustPressed(0, 38) and PlayerData.job.name == 'firefighter' then
                    TriggerServerEvent('ff_alarm_system:readyForDuty', fireStation.name)
                end

                if IsControlJustPressed(0, 47) and PlayerData.job.name == 'firefighter' and not magnetShieldActive then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    if vehicle ~= 0 then
                        TriggerServerEvent('ff_alarm_system:activateMagnetShield', fireStation.name)
                        magnetShieldActive = true
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('ff_alarm_system:playAlarmSound')
AddEventHandler('ff_alarm_system:playAlarmSound', function()
    PlaySoundFrontend(-1, Config.DMESound, 'HUD_MINI_GAME_SOUNDSET', true)
    Citizen.Wait(Config.AlarmDuration * 1000)
    alarmActive = false
end)

RegisterNetEvent('ff_alarm_system:activateMagnetShield')
AddEventHandler('ff_alarm_system:activateMagnetShield', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 then
        local magnetShield = CreateObject(GetHashKey(Config.MagnetShieldModel), 0, 0, 0, true, true, true)
        AttachEntityToEntity(magnetShield, vehicle, GetEntityBoneIndexByName(vehicle, 'chassis'), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        Citizen.Wait(Config.MagnetShieldDuration * 1000)
        DeleteEntity(magnetShield)
        magnetShieldActive = false
    end
end)