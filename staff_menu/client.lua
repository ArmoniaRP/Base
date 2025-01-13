local ESX = exports['es_extended']:getSharedObject()
local menuData = LoadResourceFile(GetCurrentResourceName(), "menu.lua")
local MenuConfig = assert(load(menuData))() -- Charger et exécuter le fichier
local isOpen = false
local currentOption = 1
local currentMenu = "main"
local selectedPlayer = nil -- Joueur sélectionné
local selectedPlayerName = "" -- Pseudo du joueur sélectionné
local selectedPlayerFullName = "" -- Nom complet RP du joueur sélectionné
local playersList = {} -- Liste des joueurs connectés

-- Fonction pour ouvrir ou fermer le menu
function OpenStaffMenu()
    ESX.TriggerServerCallback('getPlayerGroup', function(group)
        if group == "admin" or group == "fondateur" or group == "mod" then
            isOpen = not isOpen
            if isOpen then
                ESX.ShowNotification("~g~Menu Staff ouvert")
                RefreshPlayersList() -- Rafraîchir la liste des joueurs
                currentMenu = "main"
                currentOption = 1
                selectedPlayer = nil
                selectedPlayerName = ""
                selectedPlayerFullName = ""
            else
                ESX.ShowNotification("~r~Menu Staff fermé")
                currentMenu = "main"
                currentOption = 1
                selectedPlayer = nil
                selectedPlayerName = ""
                selectedPlayerFullName = ""
            end
        else
            ESX.ShowNotification("~r~Vous n'avez pas la permission d'ouvrir ce menu.")
        end
    end)
end

-- Fonction pour rafraîchir la liste des joueurs
function RefreshPlayersList()
    playersList = {}
    MenuConfig.joueurs = {} -- Réinitialiser le menu des joueurs

    for _, player in ipairs(GetActivePlayers()) do
        local playerName = GetPlayerName(player)
        table.insert(playersList, {id = player, name = playerName})
        table.insert(MenuConfig.joueurs, {label = playerName, action = "selectPlayer", playerId = player})
    end
end

function ShowStaffMenu()
    if isOpen then
        -- Dessiner l'en-tête avec du violet
        DrawRect(0.1, 0.08, 0.18, 0.05, 138, 43, 226, 200) -- Violet (RGB: 138, 43, 226)
        DrawText2D(0.1, 0.065, "ArmoniaRP", 0.6, {255, 255, 255}) -- Blanc pour le texte

        -- Dessiner la barre de titre en violet foncé
        DrawRect(0.1, 0.12, 0.18, 0.03, 75, 0, 130, 200) -- Violet foncé (RGB: 75, 0, 130)
        DrawText2D(0.1, 0.11, "MENU STAFF", 0.4, {255, 255, 255}) -- Blanc pour le texte

        -- Vérifie que le menu actuel existe
        local options = MenuConfig[currentMenu]
        if options then
            for i = 1, #options do
                local y = 0.15 + (i - 1) * 0.03
                local backgroundColor = (i == currentOption) and {75, 0, 130, 150} or {138, 43, 226, 150} -- Violet foncé pour la sélection, violet clair pour les options
                DrawRect(0.1, y + 0.015, 0.18, 0.03, table.unpack(backgroundColor))
                local selected = (i == currentOption) and "~w~" or "~w~" -- Blanc pour le texte
                DrawText2D(0.1, y, selected .. options[i].label, 0.35, {255, 255, 255}) -- Blanc pour le texte
            end
        else
            ESX.ShowNotification("Erreur : Menu non trouvé !")
        end

        -- Afficher le pseudo et le nom complet RP sous le menu des actions joueur
        if currentMenu == "actionsJoueur" and selectedPlayerName ~= "" then
            DrawText2D(0.1, 0.45, selectedPlayerName .. " | " .. selectedPlayerFullName, 0.35, {255, 255, 255}) -- Blanc pour le texte
        end
    end
end

function HandleMenuInput()
    if IsControlJustPressed(1, 173) then -- Touche flèche bas
        currentOption = currentOption < #MenuConfig[currentMenu] and currentOption + 1 or 1
    elseif IsControlJustPressed(1, 172) then -- Touche flèche haut
        currentOption = currentOption > 1 and currentOption - 1 or #MenuConfig[currentMenu]
    elseif IsControlJustPressed(1, 201) then -- Touche Entrée
        local selectedOption = MenuConfig[currentMenu][currentOption]
        if selectedOption.submenu then
            currentMenu = selectedOption.submenu
            currentOption = 1
        elseif selectedOption.action then
            if selectedOption.action == "selectPlayer" then
                selectedPlayer = selectedOption.playerId
                selectedPlayerName = GetPlayerName(selectedPlayer)
                FetchPlayerInfo(selectedPlayer)
                currentMenu = "actionsJoueur" -- Ouvre le menu des actions du joueur
                currentOption = 1
            else
                ExecuteMenuAction(selectedOption.action)
            end
        else
            ESX.ShowNotification("Option sélectionnée : " .. selectedOption.label)
        end
    elseif IsControlJustPressed(1, 202) then -- Touche Retour (Backspace)
        if currentMenu == "actionsJoueur" then
            currentMenu = "joueurs"
            currentOption = 1
            selectedPlayer = nil
            selectedPlayerName = ""
            selectedPlayerFullName = ""
        elseif currentMenu ~= "main" then
            currentMenu = "main"
            currentOption = 1
            selectedPlayer = nil
            selectedPlayerName = ""
            selectedPlayerFullName = ""
        else
            -- Fermer le menu global
            isOpen = false
            ESX.ShowNotification("~r~Menu Staff fermé")
        end
    end
end

-- Fonction pour récupérer les informations du joueur
function FetchPlayerInfo(playerId)
    -- Ici, tu peux faire un appel serveur pour obtenir des informations comme le job, job2, et l'argent
    ESX.TriggerServerCallback('getPlayerInfo', function(info)
        selectedPlayerInfo = info -- Enregistrer les informations du joueur
    end, GetPlayerServerId(playerId))
end

-- Fonction pour afficher le popup d'informations
function DrawPlayerInfoPopup()
    if selectedPlayerInfo then
        local job = selectedPlayerInfo.job or "N/A"
        local job2 = selectedPlayerInfo.job2 or "N/A"
        local money = selectedPlayerInfo.money or 0
        DrawText2D(0.3, 0.15, "Job : " .. job, 0.35)
        DrawText2D(0.3, 0.18, "Job2 : " .. job2, 0.35)
        DrawText2D(0.3, 0.21, "Argent : $" .. money, 0.35)
    end
end

-- Fonction pour exécuter les actions du menu
function ExecuteMenuAction(action)
    if action == "teleportPlayerToMe" then
        TeleportPlayerToMe(selectedPlayer)
    elseif action == "teleportToPlayer" then
        TeleportToPlayer(selectedPlayer)
    elseif action == "freezePlayer" then
        FreezePlayer(selectedPlayer)
    elseif action == "spectatePlayer" then
        SpectatePlayer(selectedPlayer)
    elseif action == "giveWeapon" then
        GiveWeaponToPlayer(selectedPlayer)
    elseif action == "giveMoney" then
        GiveMoneyToPlayer(selectedPlayer)
    elseif action == "viewInventory" then
        ViewPlayerInventory(selectedPlayer)
    elseif action == "kickPlayer" then
        KickPlayer(selectedPlayer)
    elseif action == "jailPlayer" then
        JailPlayer(selectedPlayer)
    elseif action == "banPlayer" then
        BanPlayer(selectedPlayer)
    elseif action == "viewVehicles" then
        ViewPlayerVehicles(selectedPlayer)
    elseif action == "teleportToParking" then
        TeleportToLocation(selectedPlayer, {x = 215.8, y = -810.1, z = 30.7}) -- Coordonnées fictives pour le Parking Central
    elseif action == "teleportToHospital" then
        TeleportToLocation(selectedPlayer, {x = 299.3, y = -584.3, z = 43.3}) -- Coordonnées fictives pour l'Hôpital
    elseif action == "teleportToPoliceStation" then
        TeleportToLocation(selectedPlayer, {x = 425.1, y = -979.5, z = 30.7}) -- Coordonnées fictives pour le Commissariat
    end
end

-- Fonctions pour les actions
function TeleportPlayerToMe(playerId)
    local playerPed = GetPlayerPed(-1)
    local myCoords = GetEntityCoords(playerPed)
    TriggerServerEvent('esx_teleport:teleportPlayer', playerId, myCoords)
end

function TeleportToPlayer(playerId)
    local playerPed = GetPlayerPed(-1)
    local targetCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId)))
    SetEntityCoords(playerPed, targetCoords.x, targetCoords.y, targetCoords.z)
end

function FreezePlayer(playerId)
    ESX.ShowNotification("Freeze non implémenté")
end

function SpectatePlayer(playerId)
    -- Logique pour spectate un joueur
    ESX.ShowNotification("Spectate non implémenté")
end

function GiveWeaponToPlayer(playerId)
    -- Exemple simple pour donner une arme
    ESX.ShowNotification("give weapon non implémenté")
end

function GiveMoneyToPlayer(playerId)
    -- Exemple simple pour donner de l'argent
    ESX.ShowNotification("give money non implémenté")
end

function ViewPlayerInventory(playerId)
    -- Logique pour voir l'inventaire du joueur
    ESX.ShowNotification("Voir inventaire non implémenté")
end

function KickPlayer(playerId)
    -- Exemple simple pour kicker un joueur
    ESX.ShowNotification("Kick non implémenté")
end

function JailPlayer(playerId)
    -- Exemple simple pour mettre un joueur en prison
    ESX.ShowNotification("Jail non implémenté")
end

function BanPlayer(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then
        ESX.ShowNotification("~r~Le joueur est introuvable.")
        return
    end

    -- Demande la raison et la durée au staff
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ban_reason', {
        title = "Raison du bannissement"
    }, function(data, menu)
        local reason = data.value
        if not reason or reason == "" then
            ESX.ShowNotification("~r~Veuillez entrer une raison valide.")
            menu.close()
            return
        end

        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ban_duration', {
            title = "Durée du ban (en heures, 0 pour permanent)"
        }, function(data2, menu2)
            local duration = tonumber(data2.value)
            if not duration or duration < 0 then
                ESX.ShowNotification("~r~Veuillez entrer une durée valide.")
                menu2.close()
                return
            end

            -- Calcul du temps d'expiration
            local banTime = (duration == 0) and 0 or (os.time() + (duration * 60 * 60))
            local identifier = xPlayer.getIdentifier()
            local playerName = GetPlayerName(playerId)

            -- Enregistrement dans la base de données
            MySQL.Async.execute(
                'INSERT INTO bans (identifier, name, reason, expire) VALUES (@identifier, @name, @reason, @expire)',
                {
                    ['@identifier'] = identifier,
                    ['@name'] = playerName,
                    ['@reason'] = reason,
                    ['@expire'] = banTime
                },
                function(rowsChanged)
                    if rowsChanged > 0 then
                        -- Expulsion immédiate du joueur banni
                        DropPlayer(playerId, "Vous avez été banni pour : " .. reason .. ". Durée : " .. (duration == 0 and "permanent" or duration .. " heure(s)."))
                        ESX.ShowNotification("~g~" .. playerName .. " a été banni avec succès.")
                    else
                        ESX.ShowNotification("~r~Erreur lors de l'ajout du ban.")
                    end
                end
            )

            menu2.close()
        end, function(data2, menu2)
            menu2.close()
        end)

        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end


function ViewPlayerVehicles(playerId)
    -- Logique pour voir les véhicules du joueur
    ESX.ShowNotification("Voir véhicules non implémenté")
end

function TeleportToLocation(playerId, coords)
    local playerPed = GetPlayerPed(-1)
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
end

-- Fonction pour afficher du texte 2D avec une couleur personnalisée
function DrawText2D(x, y, text, scale, color)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(color[1], color[2], color[3], 255) -- Couleur personnalisée
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Détection de la touche F10 pour ouvrir/fermer le menu
CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustReleased(0, 57) then -- Touche F10
            OpenStaffMenu()
        end
        
        if isOpen then
            ShowStaffMenu()
            HandleMenuInput()
        end
    end
end)
