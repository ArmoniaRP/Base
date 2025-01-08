local MenuConfig = {
    main = {
        {label = "Gestion des joueurs", submenu = "joueurs", submenu = "actionsJoueur"},
        {label = "Gestion Véhicule"},
        {label = "Gestion Entreprise"},
        {label = "Administration"}
    },
    joueurs = {},
    actionsJoueur = { -- Menu des actions disponibles pour un joueur
        {label = "Téléporter à Moi", action = "teleportPlayerToMe"},
        {label = "Téléporter à Lui", action = "teleportToPlayer"},
        {label = "Téléportation Rapide", submenu = "teleportOptions"},
        {label = "Freeze/Unfreeze", action = "freezePlayer"},
        {label = "Spectate", action = "spectatePlayer"},
        {label = "Donner Arme", action = "giveWeapon"},
        {label = "Donner Argent", action = "giveMoney"},
        {label = "Voir Inventaire", action = "viewInventory"},
        {label = "Kick", action = "kickPlayer"},
        {label = "Jail", action = "jailPlayer"},
        {label = "Ban", action = "banPlayer"},
        {label = "Voir Véhicules", action = "viewVehicles"}
    },
    teleportOptions = { -- Options pour la téléportation rapide
        {label = "Parking Central", action = "teleportToParking"},
        {label = "Hôpital", action = "teleportToHospital"},
        {label = "Commissariat", action = "teleportToPoliceStation"}
    }
}

return MenuConfig
