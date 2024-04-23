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
            ClearPedTasksImmediately(cache.ped)
            RemoveAnimDict('mini@repair')
        else
            cuttingWood = false
            ClearPedTasksImmediately(cache.ped)
            RemoveAnimDict('mini@repair')
            lib.notify({
                title = "Canceled",
                description = 'Canceled',
                type = 'error'
            })
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

RegisterNetEvent('lumberjack:client:SpawnVehicle', function(data)
    local player = cache.ped
    local lumberVehicle = lib.requestModel(data.Model)

    if not IsAnyVehicleNearPoint(data.SpawnLocation.x, data.SpawnLocation.y, data.SpawnLocation.z, 5.0) then
        local moneyRemoved = lib.callback.await('lumberjack:server:RemoveVehicleSpawnCost', false, data.Cost)

        if not moneyRemoved then
            lib.notify({
                title = 'Unable',
                description = "You don't have the enough cash to rent this vehicle",
                type = 'error'
            })
            return
        end

        QBCore.Functions.SpawnVehicle(lumberVehicle, function(jobVehicle)
            local plate = "LUMB"..tostring(math.random(1000, 9999))
            SetVehicleNumberPlateText(jobVehicle, plate)
            SetEntityHeading(jobVehicle, data.SpawnLocation.w)
            Entity(jobVehicle).state.fuel = 100
            TaskWarpPedIntoVehicle(player, jobVehicle, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(jobVehicle))
            SetVehicleEngineOn(jobVehicle, true, true)
        end, data.SpawnLocation, true)

        local alert = lib.alertDialog({
            header = 'Foreman:',
            content = "Time to get to work!\n\nGrab your axe and start hacking at those trees! Whatever you bring back, I'll buy at a fair price"
            .."or you can process it yourself!",
            centered = true,
            cancel = false
        })
    else
        lib.notify({
            title = "Attention",
            description = "Vehicle blocking depot",
            type = 'inform'
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

RegisterNetEvent("lumberjack:client:RemoveSpawnedVehicle", function(data)
    local currentVehicle = GetLastDrivenVehicle(cache.ped)
	local vehicleCoords = GetEntityCoords(currentVehicle)
	local foremanCoords = GetEntityCoords(data.entity)
	local distance = #(vehicleCoords - foremanCoords)

    if currentVehicle == nil then
        lib.notify({
            title = 'Missing',
            description = "You don't have a vehicle to return",
            type = 'error'
        })
        return
    end

    if distance > 5 then
        lib.notify({
            title = 'Unable',
            description = 'Your vehicle is too far away',
            type = 'error'
        })
        return
    end

    SetVehicleEngineHealth(currentVehicle, 200.0)
    SetVehicleBodyHealth(currentVehicle, 200.0)

    for i = 0, 7 do
        SmashVehicleWindow(currentVehicle, i) Wait(150)
    end
    PopOutVehicleWindscreen(currentVehicle)

    for i = 0, 5 do
        SetVehicleTyreBurst(currentVehicle, i, true, 0) Wait(150)
    end

    for i = 0, 5 do
        SetVehicleDoorBroken(currentVehicle, i, false) Wait(150)
    end

    Wait(800)

	QBCore.Functions.DeleteVehicle(currentVehicle)
end)