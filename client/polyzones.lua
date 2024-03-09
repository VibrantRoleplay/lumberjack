CreateThread(function()
    for _, zoneCoords in pairs(Config.Lumberyard.Processing.Bark.BarkSellingAreas) do
        lib.zones.poly({
            points = zoneCoords,
            thickness = 5,
            debug = Config.GenericStuff.Debug,
            inside = function()
                local barkAmount = exports.ox_inventory:Search('count', Config.Lumberyard.Processing.Bark.Item)

                if IsControlJustPressed(0, 38) then
                    if barkAmount < Config.Lumberyard.Processing.Bark.ProcessAmountPerTick then
                        lib.notify({
                            title = 'Unable',
                            description = "Why don't you leave and comeback when you have enough bark to shovel off",
                            type = 'error'
                        })
                        lib.hideTextUI()

                        StopAnimTask(cache.ped, 'random@burial', 'a_burial')
                        ClearPedTasksImmediately(cache.ped)
                        DeleteObject(shovel)
                        return
                    end
                    
                    AttachShovelToPed()

                    Wait(4500)
                    TriggerServerEvent('lumberjack:server:ProcessBark', Config.Lumberyard.Processing.Bark)
                    StopAnimTask(cache.ped, 'random@burial', 'a_burial')
                    ClearPedTasksImmediately(cache.ped)
                    DeleteObject(shovel)
                end
            end,
            onEnter = function()
                lib.showTextUI("[E] - To start shovelling bark")
            end,
            onExit = function()
                DeleteObject(shovel)
                lib.hideTextUI()
            end,
        })
    end
end)

function AttachShovelToPed()
    local playerCoords = GetEntityCoords(cache.ped)

    lib.requestAnimDict('random@burial')
    lib.RequestModel('prop_tool_shovel')
    TaskPlayAnim(cache.ped, 'random@burial', 'a_burial', 1.0, 1.0, -1, 01, 0, true, true, true)
    shovel = CreateObject('prop_tool_shovel', playerCoords.x, playerCoords.y, playerCoords.z, true, true, false)
    AttachEntityToEntity(shovel, cache.ped, GetPedBoneIndex(cache.ped, 28422), 0.0, 0.0, 0.240, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
end