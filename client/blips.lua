local QBCore = exports['qb-core']:GetCoreObject()

if Config.GenericStuff.UseBlips then
    local lumberyard = Config.Lumberyard.Foreman.Blip
    local lumberSeller = Config.LumberSelling.Blip

    CreateThread(function()
        local lumberyardBlip = AddBlipForCoord(lumberyard.Location)
        SetBlipSprite (lumberyardBlip, lumberyard.Sprite)
        SetBlipDisplay(lumberyardBlip, lumberyard.Display)
        SetBlipScale  (lumberyardBlip, lumberyard.Scale)
        SetBlipAsShortRange(lumberyardBlip, true)
        SetBlipColour(lumberyardBlip, lumberyard.Color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(lumberyard.Label)
        EndTextCommandSetBlipName(lumberyardBlip)

        local lumberSellerBlip = AddBlipForCoord(lumberSeller.Location)
        SetBlipSprite (lumberSellerBlip, lumberyard.Sprite)
        SetBlipDisplay(lumberSellerBlip, lumberyard.Display)
        SetBlipScale  (lumberSellerBlip, lumberyard.Scale)
        SetBlipAsShortRange(lumberSellerBlip, true)
        SetBlipColour(lumberSellerBlip, lumberyard.Color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(lumberyard.Label)
        EndTextCommandSetBlipName(lumberSellerBlip)
    end)
end