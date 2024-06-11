QBCore = exports['qb-core']:GetCoreObject()

-------------
--Variables--
-------------

local placeableItemUsed = false
local placeableItemPlaced = false
cuttingWood = false

RegisterNetEvent('lumberjack:client:ProcessWoodIntoPlanks', function(data)
    local treeLumberAmount = exports.ox_inventory:Search('count', Config.Lumberyard.Processing.Logs.Item)

    if treeLumberAmount < Config.Lumberyard.Processing.Logs.AmountRequiredToMakePlank then
        lib.notify({
            title = 'Unable',
            description = "You don't have enough logs to make any planks",
            type = 'error'
        })
        return
    end

    cuttingWood = true
    CreateThread(function()
        while cuttingWood do
            lib.requestNamedPtfxAsset('core')
            UseParticleFxAsset("core")
            -- StartNetworkedParticleFxLoopedOnEntity(effectName, entity, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, xAxis, yAxis, zAxis)
            local tableSawPTX = StartNetworkedParticleFxLoopedOnEntity("ent_brk_tree_trunk_bark", data.args.entity, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.5)
            Wait(300)
        end
    end)

    lib.requestAnimDict('mini@repair')

    repeat
        TaskPlayAnim(cache.ped, 'mini@repair', 'fixing_a_ped', 8.0, 1.0, -1, 1, 0, 0, 0, 0)
        if lib.progressCircle({
            duration = 5000,
            label = 'Cutting planks',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            -- animation = {
            --     dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            --     clip = "machinic_loop_mechandplayer",
            -- },
        }) then
            TriggerServerEvent('lumberjack:server:ProcessLumber')
            ClearPedTasks(cache.ped)
            RemoveAnimDict('mini@repair')
        else
            cuttingWood = false
            ClearPedTasks(cache.ped)
            RemoveAnimDict('mini@repair')
            lib.notify({
                title = "Canceled",
                description = 'Canceled',
                type = 'error'
            })
        end
        Wait(100)
        treeLumberAmount = exports.ox_inventory:Search('count', Config.Lumberyard.Processing.Logs.Item)

        if treeLumberAmount <= 0 then
            cuttingWood = false
            ClearPedTasks(cache.ped)
            return
        end
    until cuttingWood == false
end)

RegisterNetEvent('lumberjack:client:PackagePlanks', function()
    local plankAmount = exports.ox_inventory:Search('count', Config.Lumberyard.Processing.Planks.Item)

    if plankAmount < Config.Lumberyard.Processing.Planks.AmountOfPlanksPerPallet then
        lib.notify({
            title = 'Unable',
            description = "You don't have enough planks to make a pallet",
            type = 'error'
        })
        return
    end

    if lib.progressCircle({
        duration = 7500,
        label = 'Bundling Planks ...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
			dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			clip = "machinic_loop_mechandplayer",
        },
    }) then
        TriggerServerEvent('lumberjack:server:ProcessPlanks')
    else
        lib.notify({
            title = "Canceled",
            description = 'Canceled',
            type = 'error'
        })
    end
end)

-------------
--Functions--
-------------

RegisterNetEvent('lumberjack:client:HarvestTree', function(data)
    local player = cache.ped
    local playerCoords = GetEntityCoords(player)

    if #(playerCoords - data.coords) > 5 then
        return
    end

    local cooldown = lib.callback.await('lumberjack:server:GetTreeCooldown', false, data.args.treeNumber)

    if cooldown > 0 then 
        lib.notify({
            title = 'Busy',
            description = 'This tree has been harvested already',
            type = 'error'
        })
        return
    end

    local playerWeapon = GetSelectedPedWeapon(cache.ped)

    if playerWeapon ~= Config.ChoppingItem then
        lib.notify({
            title = 'Missing Tools',
            description = "You don't have the right tool for this",
            type = 'error'
        })
        return
    end
    
    TaskTurnPedToFaceEntity(cache.ped, data.entity, 2500)

    if lib.progressCircle({
        duration = 5000,
        label = 'Chopping Tree',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
        },
        anim = {
            dict = 'melee@hatchet@streamed_core',
            clip = 'plyr_rear_takedown_b'
        },
    }) then
        TriggerServerEvent('lumberjack:server:RecieveTreeLumber')
        TriggerServerEvent('lumberjack:server:TreeCooldown', data.args.treeNumber)
    else
        lib.notify({
            title = 'Canceled',
            description = 'Canceled',
            type = 'error'
        })
    end
end)