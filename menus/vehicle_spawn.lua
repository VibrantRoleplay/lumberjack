RegisterNetEvent('lumberjack:client:VehicleMenu', function(data)
	local headerMenu = {}
    local moneyAmount = exports.ox_inventory:Search('count', 'money')
    local description = nil

    for k, v in pairs(Config.Lumberyard.Vehicles) do
        if moneyAmount >= v.Cost then
            description = "Rent "..v.Model.." for $"..v.Cost
        else
            description = "You can't afford to rent this "..v.Model
        end

        headerMenu[#headerMenu + 1] = {
            title = v.Model,
            description = description,
            event = 'lumberjack:client:SpawnVehicle',
            icon = 'fa-solid fa-hammer',
            iconColor = "yellow",
            args = v,
            readOnly = v.Cost > moneyAmount,
        }
    end

    headerMenu[#headerMenu + 1] = {
        title = "Return Vehicle",
        description = "Return depot vehicle",
        event = 'lumberjack:client:RemoveSpawnedVehicle',
        icon = 'fa-solid fa-truck',
        iconColor = "yellow",
        args = data,
    }

    lib.registerContext({
        id = 'vehicles_menu',
        title = "Vehicles Depot",
        options = headerMenu,
        menu = 'foreman_menu',
    })

    lib.showContext('vehicles_menu')
end)