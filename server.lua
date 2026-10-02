local ESX = nil
local alarms = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('ff_alarm_system:getFireStations', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM ff_fire_stations', {}, function(result)
        cb(result)
    end)
end)

RegisterServerEvent('ff_alarm_system:startAlarm')
AddEventHandler('ff_alarm_system:startAlarm', function(fireStationName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'firefighter' then
        local alarmId = #alarms + 1
        alarms[alarmId] = {
            playerId = source,
            fireStationName = fireStationName,
            alarmTime = os.time(),
            status = 'active'
        }

        TriggerClientEvent('ff_alarm_system:playAlarmSound', source)

        Citizen.SetTimeout(Config.AlarmDuration * 1000, function()
            if alarms[alarmId] and alarms[alarmId].status == 'active' then
                alarms[alarmId].status = 'failed'
                TriggerClientEvent('esx:showNotification', source, 'Alarm failed: Not enough firefighters ready for duty.')
            end
        end)
    end
end)

RegisterServerEvent('ff_alarm_system:readyForDuty')
AddEventHandler('ff_alarm_system:readyForDuty', function(fireStationName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'firefighter' then
        for _, alarm in ipairs(alarms) do
            if alarm.fireStationName == fireStationName and alarm.status == 'active' then
                alarm.status = 'completed'
                TriggerClientEvent('esx:showNotification', source, 'You are now ready for duty.')
                break
            end
        end
    end
end)

RegisterServerEvent('ff_alarm_system:activateMagnetShield')
AddEventHandler('ff_alarm_system:activateMagnetShield', function(fireStationName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'firefighter' then
        TriggerClientEvent('ff_alarm_system:activateMagnetShield', source)
    end
end)