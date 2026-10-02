Config = {}

-- Alarm settings
Config.AlarmDuration = 300 -- Duration of the alarm in seconds
Config.AlarmCooldown = 600 -- Cooldown between alarms in seconds

-- Fire station settings
Config.FireStations = {
    {
        name = 'Los Santos Fire Station',
        coords = vector3(1202.3, -1465.2, 34.8),
        radius = 50.0
    },
    {
        name = 'Sandy Shores Fire Station',
        coords = vector3(1857.6, 3683.1, 34.2),
        radius = 50.0
    },
    {
        name = 'Paleto Bay Fire Station',
        coords = vector3(-449.6, 6013.3, 31.7),
        radius = 50.0
    }
}

-- DME settings
Config.DMESound = 'dme_alarm'
Config.DMEVolume = 0.5

-- Magnet shield settings
Config.MagnetShieldModel = 'prop_magnet_01'
Config.MagnetShieldDuration = 300 -- Duration of the magnet shield in seconds