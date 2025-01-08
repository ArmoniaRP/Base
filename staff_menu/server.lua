local ESX = exports['es_extended']:getSharedObject()

-- Serveur-Side Callback pour obtenir le rôle du joueur
ESX.RegisterServerCallback('getPlayerGroup', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        cb(xPlayer.getGroup()) -- Retourne le groupe du joueur
    else
        cb(nil) -- Si xPlayer est nul, retourne nil
    end
end)

ESX.RegisterServerCallback('getPlayerInfo', function(source, cb, playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        -- Récupère les informations du joueur
        local info = {
            job = xPlayer.getJob().label,
            money = xPlayer.getMoney()
        }
        cb(info) -- Retourne les informations
    else
        cb(nil) -- Retourne nil si le joueur n'est pas trouvé
    end
end)
