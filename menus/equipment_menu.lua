RegisterNetEvent('lumberjack:client:EquipmentMenu', function()
	local headerMenu = {}

    headerMenu[#headerMenu + 1] = {
        title = "Cutting axe",
        description = "Purchase a wood cutting Axe",
        serverEvent = 'lumberjack:server:PurchaseEquipment',
        args = Config.Lumberyard.EquipmentBuying.TreeChoppingItem,
        icon = 'fa-solid fa-tree',
        iconColor = "yellow",
    }

    headerMenu[#headerMenu + 1] = {
        title = "Table Saw",
        description = "Purcahse a table saw to help you cut your logs into planks",
        serverEvent = 'lumberjack:server:PurchaseEquipment',
        args = Config.Lumberyard.EquipmentBuying.TableSawItem,
        icon = 'fa-solid fa-fan',
        iconColor = "yellow",
    }

    lib.registerContext({
        id = 'equipment_menu',
        title = "Lumberjacking Equipment",
        options = headerMenu,
    })

    lib.showContext('equipment_menu')
end)