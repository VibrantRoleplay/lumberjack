RegisterNetEvent('lumberjack:client:BarkMenu', function()
    local barkAmount = exports.ox_inventory:Search('count', Config.Lumberyard.Processing.Bark.Item)
	local headerMenu = {}

    headerMenu[#headerMenu + 1] = {
        title = "Process bark",
        description = "Add your bark to the pile",
        metadata = {
            "Shovel 2 pieces of bark at a time",
        },
        event = 'lumberjack:client:ProcessBark',
        icon = 'fa-solid fa-hammer',
        iconColor = "yellow",
        disabled = barkAmount <= 0 or sellingBark,
    }

    headerMenu[#headerMenu + 1] = {
        title = "Stop Processing",
        description = "Stop processing your bark",
        event = 'lumberjack:client:ProcessBark',
        icon = 'fa-solid fa-truck',
        iconColor = "yellow",
        disabled = not sellingBark,
    }

    lib.registerContext({
        id = 'bark_selling',
        title = "Bark Processing",
        options = headerMenu,
    })

    lib.showContext('bark_selling')
end)