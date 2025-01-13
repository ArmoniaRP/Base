-- client.lua

local menuOpen = false -- Indique si le menu est ouvert
local selectedOption = 1 -- Option actuellement sélectionnée
local activeSubMenu = nil -- Sous-menu actif (nil = menu principal)

-- Options principales du menu
local mainMenuOptions = {
    "Informations Personnelles",
    "Touches du Serveur",
    "Gestion Factures",
    "Documents officiels",
    "Rejoindre le discord",
    "Logs des factures"
}

-- Sous-menus
local subMenus = {
    ["Informations Personnelles"] = {
        "Nom : Tim Bradford",
        "Âge : 25 ans",
        "Métier : Policier"
    },
    ["Touches du Serveur"] = {
        "F5 : Ouvrir/fermer ce menu",
        "F6 : Ouvrir/fermer menu job",
        "F7 : Ouvrir/fermer menu Gang",
        "TAB : Inventaire",
        "F1 : Téléphone",
        "E : Interagir",
        "X : Ceinture",
        "H : Lever les main "
    },
    ["Gestion Factures"] = {
        "Aucune facture disponible pour le moment."
    },
    ["Documents officiels"] = {
        "Pas de documents disponibles."
    },
    ["Rejoindre le discord"] = {
        "Rejoignez notre Discord : discord.gg/ArmoniaRP"
    },
    ["Logs des factures"] = {
        "Aucun log disponible pour le moment."
    }
}

-- Fonction pour afficher un texte centré
local function DrawTextCentered(text, x, y, scale, color, shadow)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(table.unpack(color))
    if shadow then SetTextDropShadow(1, 0, 0, 0, 255) end -- Ajout d'ombre
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Fonction pour dessiner un rectangle avec bordures arrondies (simulation)
local function DrawRectWithBorder(x, y, width, height, bgColor, borderColor)
    DrawRect(x, y, width, height, table.unpack(borderColor)) -- Bordure
    DrawRect(x, y, width - 0.005, height - 0.005, table.unpack(bgColor)) -- Contenu
end

-- Fonction pour dessiner un arrière-plan semi-transparent
local function DrawBackground()
    DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 150)
end

-- Fonction pour dessiner le menu principal
local function DrawMenu()
    local startX, startY = 0.05, 0.05 -- Position du menu (haut-gauche)
    local width, height = 0.25, 0.05 -- Dimensions ajustées
    local margin = 0.01 -- Espace entre les options

    -- Dessiner le titre
    DrawRectWithBorder(startX + width / 2, startY + height / 2, width, height, {148, 0, 211, 200}, {255, 255, 255, 255})
    DrawTextCentered("Armonia RP", startX + width / 2, startY + height / 4, 0.6, {255, 255, 255, 255}, true)

    -- Dessiner les options
    for i, option in ipairs(mainMenuOptions) do
        local optionY = startY + height + margin + (i - 1) * (height + margin)
        local isSelected = (i == selectedOption)

        -- Dégradé ou couleur pour l'option sélectionnée
        local bgColor = isSelected and {75, 0, 130, 200} or {0, 0, 0, 150}
        local borderColor = isSelected and {255, 255, 255, 255} or {75, 0, 130, 200}

        -- Dessiner l'option avec bordure
        DrawRectWithBorder(startX + width / 2, optionY + height / 2, width, height, bgColor, borderColor)
        DrawTextCentered(option, startX + width / 2, optionY + height / 4, 0.4, {255, 255, 255, 255}, true)
    end
end

-- Fonction pour afficher un sous-menu
local function DrawSubMenu(options)
    local startX, startY = 0.05, 0.12 -- Position du sous-menu (sous le titre)
    local width, height = 0.25, 0.045 -- Dimensions compactes
    local margin = 0.01 -- Espace entre les options

    -- Dessiner les options
    for i, option in ipairs(options) do
        local optionY = startY + (i - 1) * (height + margin)

        -- Fond avec bordure
        DrawRectWithBorder(startX + width / 2, optionY + height / 2, width, height, {0, 0, 0, 150}, {75, 0, 130, 200})

        -- Texte
        DrawTextCentered(option, startX + width / 2, optionY + height / 4, 0.4, {255, 255, 255, 255}, true)
    end

    -- Indication pour revenir au menu principal
    DrawTextCentered("Appuyez sur F5 pour revenir", startX + width / 2, startY + #options * (height + margin) + 0.02, 0.3, {255, 255, 255, 255}, true)
end

-- Boucle principale
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if menuOpen then
            if activeSubMenu then
                -- Afficher le sous-menu actif
                DrawSubMenu(subMenus[activeSubMenu])

                -- Revenir au menu principal avec F5
                if IsControlJustPressed(1, 166) then -- F5
                    activeSubMenu = nil
                end
            else
                -- Afficher le menu principal
                DrawMenu()

                -- Navigation dans le menu principal
                if IsControlJustPressed(1, 173) then -- Flèche Bas
                    selectedOption = selectedOption + 1
                    if selectedOption > #mainMenuOptions then selectedOption = 1 end
                elseif IsControlJustPressed(1, 172) then -- Flèche Haut
                    selectedOption = selectedOption - 1
                    if selectedOption < 1 then selectedOption = #mainMenuOptions end
                elseif IsControlJustPressed(1, 201) then -- Entrée
                    -- Activer le sous-menu correspondant
                    activeSubMenu = mainMenuOptions[selectedOption]
                elseif IsControlJustPressed(1, 166) then -- F5
                    menuOpen = false
                end
            end
        else
            -- Ouvrir le menu avec F5
            if IsControlJustPressed(1, 166) then -- F5
                menuOpen = true
            end
        end
    end
end)
