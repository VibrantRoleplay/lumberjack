CreateThread(function()
    local foremanModel = lib.requestModel(Config.Lumberyard.Foreman.Model)

    local foreman = CreatePed(1, foremanModel, Config.Lumberyard.Foreman.Location, false, true)
    SetEntityInvincible(foreman, true)
    FreezeEntityPosition(foreman, true)
    SetBlockingOfNonTemporaryEvents(foreman, true)

    exports.ox_target:addSphereZone({
        coords = vector3(Config.Lumberyard.Foreman.Location.x, Config.Lumberyard.Foreman.Location.y, Config.Lumberyard.Foreman.Location.z+1),
        radius = 0.7,
        debug = Config.GenericStuff.Debug,
        options = {
            {
                label = "Speak to Foreman",
                event = 'lumberjack:client:ForemanMenu',
                icon = "fa-solid fa-basket-shopping",
                iconColor = "white",
                distance = 2,
            },
        },
    })

    local lumberSellingModel = lib.requestModel(Config.LumberSelling.Ped.Model)

    local salesPed = CreatePed(1, lumberSellingModel, Config.LumberSelling.Ped.Location, false, true)
    SetEntityInvincible(salesPed, true)
    FreezeEntityPosition(salesPed, true)
    SetBlockingOfNonTemporaryEvents(salesPed, true)

    exports.ox_target:addSphereZone({
        coords = vector3(Config.LumberSelling.Ped.Location.x, Config.LumberSelling.Ped.Location.y, Config.LumberSelling.Ped.Location.z+1),
        radius = 0.7,
        debug = Config.GenericStuff.Debug,
        options = {
            {
                label = "Speak to Lumber Buyer",
                event = 'lumberjack:client:SellMenu',
                icon = "fa-solid fa-basket-shopping",
                args = salesPed,
                iconColor = "green",
                distance = 2,
            },
        },
    })
end)