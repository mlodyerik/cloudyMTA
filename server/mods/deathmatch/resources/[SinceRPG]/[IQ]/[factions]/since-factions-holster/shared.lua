items = {
    {
        name = "Paralizator",
        weapon = 23,
        fnc = function(player) if (getPedWeapon(player, 2) == 23) then return "Schowaj" else return "Wyciągnij" end end
    },
    {
        name = "Pałka",
        weapon = 3,
        fnc = function(player) if (getPedWeapon(player, 1) == 3) then return "Schowaj" else return "Wyciągnij" end end
    },
    {
        name = "Suszarka",
        weapon = 22,
        fnc = function(player) if (getPedWeapon(player, 2) == 22) then return "Schowaj" else return "Wyciągnij" end end
    },
    {
        name = "Deagle",
        weapon = 24,
        fnc = function(player) if (getPedWeapon(player, 2) == 24) then return "Schowaj" else return "Wyciągnij" end end
    }
}