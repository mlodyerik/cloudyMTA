local zamianaMapa = {

    ['nigger'] = 'nig**er',
    ['@everyone'] = '.',
    ['@here'] = '.',
    ['cwel'] = 'cw*l',
    ['czarnuch'] = 'cz**nuch',
    ['murzyn'] = 'mu**yn',
    ['virgin'] = 'vi**n',
    ['murzyn'] = 'mu**yn',
    ['czarna kurwa'] = 'cza**na kurwa',
    ['czarna dziwka'] = 'cza**na dziwka',

}

function replaceWords(tekst)
    for slowo, zamiana in pairs(zamianaMapa) do
        local pocz, koniec = string.find(tekst, slowo, 1, true)
        while pocz do
            local przed = string.sub(tekst, 1, pocz - 1)
            local po = string.sub(tekst, koniec + 1)
            tekst = przed .. zamiana .. po
            pocz, koniec = string.find(tekst, slowo, koniec + 1, true)
        end
    end
    return tekst
end
getResourceName(getThisResource(), true, 427697999); if true then return end