-- client.lua

local menuOpen = false -- Indique si le menu est ouvert
local selectedOption = 1 -- Option actuellement sélectionnée

-- Options principales du menu
local mainMenuOptions = {
    "Informations Personnelles",
    "Touches du Serveur",
    "Quitter"
}

-- Sous-menus
local personalInfo = {
    "Nom : John Doe",
    "Âge : 25 ans",
    "Métier : Policier"
}

local serverKeys = {
    "F5 : Ouvrir ce menu",
    "F1 : Téléphone",
    "E : Interagir",
    "Z : Voir le statut"
}

-- Fonction pour dessiner un texte
local function DrawText3D(text, x, y, scale, color)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(table.unpack(color))
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Fonction pour dessiner le menu principal
local function DrawMenu()
    local startX, startY = 0.05, 0.05 -- Position du menu
    local width, height = 0.3, 0.05 -- Dimensions

    -- Dessiner le titre
    DrawRect(startX + width / 2, startY + height / 2, width, height, 148, 0, 211, 200) -- Fond violet
    DrawText3D("Armonia RP", startX + width / 2, startY + height / 4, 0.6, {255, 255, 255, 255})

    -- Dessiner les options
    for i, option in ipairs(mainMenuOptions) do
        local optionY = startY + height + (i - 1) * height
        local isSelected = (i == selectedOption)

        -- Couleur de fond (différente si sélectionnée)
        local bgColor = isSelected and {75, 0, 130, 200} or {0, 0, 0, 150}
        DrawRect(startX + width / 2, optionY + height / 2, width, height, table.unpack(bgColor))

        -- Texte de l'option
        DrawText3D(option, startX + width / 2, optionY + height / 4, 0.4, {255, 255, 255, 255})
    end
end

-- Fonction pour afficher un sous-menu
local function DrawSubMenu(options)
    local startX, startY = 0.05, 0.15 -- Position du sous-menu
    local width, height = 0.3, 0.05 -- Dimensions

    for i, option in ipairs(options) do
        local optionY = startY + (i - 1) * height

        -- Fond
        DrawRect(startX + width / 2, optionY + height / 2, width, height, 0, 0, 0, 150)

        -- Texte
        DrawText3D(option, startX + width / 2, optionY + height / 4, 0.4, {255, 255, 255, 255})
    end

    -- Indication pour revenir en arrière
    DrawText3D("Appuyez sur Echap pour revenir", startX + width / 2, startY + #options * height + 0.02, 0.3, {255, 255, 255, 255})
end

-- Gestion des actions pour le menu principal
local function HandleMainMenuAction()
    if selectedOption == 1 then
        -- Informations Personnelles
        DrawSubMenu(personalInfo)
    elseif selectedOption == 2 then
        -- Touches du Serveur
        DrawSubMenu(serverKeys)
    elseif selectedOption == 3 then
        -- Quitter le menu
        menuOpen = false
    end
end

-- Boucle principale
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if menuOpen then
            DrawMenu()

            -- Navigation dans le menu principal
            if IsControlJustPressed(1, 173) then -- Flèche Bas
                selectedOption = selectedOption + 1
                if selectedOption > #mainMenuOptions then selectedOption = 1 end
            elseif IsControlJustPressed(1, 172) then -- Flèche Haut
                selectedOption = selectedOption - 1
                if selectedOption < 1 then selectedOption = #mainMenuOptions end
            elseif IsControlJustPressed(1, 201) then -- Entrée
                HandleMainMenuAction()
            elseif IsControlJustPressed(1, 177) then -- Echap
                menuOpen = false
            end
        else
            -- Ouvrir le menu avec F5
            if IsControlJustPressed(1, 166) then -- F5
                menuOpen = true
            end
        end
    end
end)
