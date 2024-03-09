RegisterNetEvent('lumberjack:client:ForemanMenu', function(data)
    PlayPedAmbientSpeechNative(data.entity, 'GENERIC_HOWS_IT_GOING', 'Speech_Params_Force')
	local headerMenu = {}

    headerMenu[#headerMenu + 1] = {
        title = "Lumbering Vehicles",
        description = "Request a vehicle from the lumberyard depot",
        event = 'lumberjack:client:VehicleMenu',
        icon = 'fa-solid fa-hammer',
        iconColor = "yellow",
        args = data,
    }

    headerMenu[#headerMenu + 1] = {
        title = "Lumbering Equipment",
        description = "See what equipment is available to you as a Lumberjack",
        event = 'lumberjack:client:EquipmentMenu',
        icon = 'fa-solid fa-toolbox',
        iconColor = "yellow",
        args = data,
    }

    lib.registerContext({
        id = 'foreman_menu',
        title = "Foremans Clipboard",
        options = headerMenu
    })

    lib.showContext('foreman_menu')
end)