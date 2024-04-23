--------------------
--Standard Targets--
--------------------

CreateThread(function()
    for index, tree in pairs(Config.Trees) do
        exports.ox_target:addSphereZone({
            coords = tree,
            radius = 1.5,
            debug = Config.GenericStuff.Debug,
            options = {
                {
                    label = "Chop down tree",
                    event = 'lumberjack:client:HarvestTree',
                    args = {
                        tree = tree,
                        treeNumber = index,
                    },
                    icon = "fa-solid fa-tree",
                    iconColor = 'green',
                }
            }
        })
    end

    for index, lumber in pairs(Config.Lumberyard.Processing.Pallets.PalletTargets) do
        exports.ox_target:addBoxZone({
            coords = lumber,
            size = vec(4, 2, 2),
            rotation = 250.0,
            debug = Config.GenericStuff.Debug,
            options = {
                {
                    label = "Package Planks",
                    event = 'lumberjack:client:PackagePlanks',
                    icon = 'fa-solid fa-box',
                    iconColor = "red",
                }
            }
        })
    end
end)

----------------------------------
--Target for table saw placement--
----------------------------------

RegisterNetEvent('lumberjack:client:CreateEntityTarget', function(newEntity, objectPlaced)
    Wait(500)
    local newEntityNetwork = NetworkGetEntityFromNetworkId(newEntity)

    local entityTarget = exports.ox_target:addLocalEntity(newEntityNetwork, {
        {
            label = "Table Saw",
            event = 'lumberjack:client:TableSawMenu',
            icon = 'fa-solid fa-fan',
            iconColor = "green",
            distance = 2.0,
            args = {
                entity = newEntityNetwork,
                object = objectPlaced,
            },
        },
    })
end)