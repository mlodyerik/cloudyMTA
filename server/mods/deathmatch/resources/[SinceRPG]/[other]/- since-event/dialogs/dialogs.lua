dialogs = {
    ---------------
    -- Start eventu
    ---------------
    first = {
        npcName = 'Zajonc',
        messages = {
            {'me', 'Co się dzieje? Dlaczego płaczesz?', '7.mp3'},
            {'npc', 'Wczoraj z kumplami popiłem i głupi wiąłem ze sobą koszyk jaj wielkanocnych..', '1.mp3'},
            {'me', 'No i co dalej?', '4.mp3'},
            {'npc', 'No tak sie najebałem, że wszystkie zgubiłem..', '2.mp3'},
            {'me', 'Gdzie je zgubiłeś?', '5.mp3'},
            {'npc', 'Nie wiem, rychu bedzie wiedział na pewno bo mu żona zabrania pic a ten debil sie jej boi', '3.mp3'},
            {'me', 'Ok, pójdę do niego', '6.mp3'},
        },
        options = {
            {'Koniec', 'exit'},
        },
        onEnd = function()
            setMissionStatus(2)
        end
    },

    ---------------
    -- Zapytaj o jajka
    ---------------
    pomocnik = {
        npcName = 'Rychu',
        messages = {
        },
        options = {
            {'Zajonc debil jajka zgubił', 'pomocnik2'},
        },
        onEnd = function()
            setMissionStatus(3)
        end
    },
    pomocnik2 = {
        npcName = 'Rychu',
        messages = {
            {'npc', 'Japierdole co za idiota, znowu walił denaturat...'},
            {'me', 'Nie wiem czym sie najebał ale zgubił jajka, wiesz gdzie je zgubił?'},
            {'npc', 'Nie wiem, ale znam kolesia co wie bo on też się boi swojej zony'},
            {'me', 'Kto to?'},
            {'npc', 'Czarek, taki niski, łysy debil, zawsze chodzi w czapce z daszkiem'},
            {'me', 'Gdzie go znajde?'},
            {'npc', 'Włuczy się po wsi jakieś, nie wiem, może w palimino creek albo gdzieś w okolicach'},
        },
        options = {
            {'jakies dokladne miejsce?', 'pomocnik3'},
        }
    },
    pomocnik3 = {
        npcName = 'Pomocnik',
        messages = {
            {'npc', 'Wioski typu Blueberry, Palimino Creek, Montgomery, takie tam'},
            {'me', 'Dzieki'},
        },
        options = {
            {'Koniec', 'exit'},
        }
    },

    ---------------
    -- Zapytaj o jajko
    ---------------
    przyjaciel = {
        npcName = 'Przyjaciel pomocnika',
        messages = {
        },
        options = {
            {'brakuje jednego jajka kurwa', 'przyjaciel2'},
        },
        onEnd = function()
            setMissionStatus(5)
        end
    },
    przyjaciel2 = {
        npcName = 'Przyjaciel pomocnika',
        messages = {
            {'me', 'brakuje jednego jajka kurwa'},
            {'npc', 'mam je ale chuja ci dam cwelu xd'},
            {'me', 'co za nie chcesz?'},
            {'npc', 'zrób mi loda lub przynies mi ziolko'},
        },
        options = {
            {'rozpinaj rozporek', 'przyjaciel3'},
            {'przyniose ziolko', 'przyjaciel4'},
        }
    },
    przyjaciel3 = {
        npcName = 'Przyjaciel pomocnika',
        messages = {
            {'me', 'rozpinaj rozporek'},
            {'npc', 'nie no spierdalaj zartowalem xddd'},
        },
        options = {
            {'przyniose ziolko', 'przyjaciel4'},
        }
    },
    przyjaciel4 = {
        npcName = 'Przyjaciel pomocnika',
        messages = {
            {'me', 'przyniose ziolko'},
            {'npc', 'ok, to dawaj'},
        },
        options = {
            {'koniec', 'exit'},
        },
        onEnd = function()
            setMissionStatus(6)
        end
    },

    ---------------
    -- Oddaj ziolko
    ---------------
    oddajziolo = {
        npcName = 'Przyjaciel pomocnika',
        messages = {
            {'me', 'mam ziolko'},
            {'npc', 'ok, to dawaj'},
        },
        options = {
            {'pierw oddaj jajko', 'oddajziolo2'},
            {'masz te ziolo', 'oddajziolo3'},
        },
        onEnd = function()
            setMissionStatus(7)
        end
    },
    oddajziolo2 = {
        npcName = 'Przyjaciel pomocnika',
        messages = {
            {'me', 'pierw oddaj jajko'},
            {'npc', 'nie kurwa, dawaj ziolo'},
        },
        options = {
            {'masz te ziolo', 'oddajziolo3'},
        }
    },
    oddajziolo3 = {
        npcName = 'Przyjaciel pomocnika',
        messages = {
            {'me', 'masz te ziolo'},
            {'npc', 'dzieki, masz jajko'},
            {'me', 'dzięki'},
        },
        options = {
            {'koniec', 'exit'},
        },
    },

    ---------------
    -- Oddaj jajka
    ---------------
    oddajjajka = {
        npcName = 'Zajonc',
        messages = {
            {'me', 'mam jajka'},
            {'npc', 'dobra ale nie dam rady sam ich zaniesc, pomozesz mi?'},
        },
        options = {
            {'nie, spierdalaj', 'oddajjajka2'},
            {'pomoge ci, wezme polowe', 'oddajjajka3'},
        },
        onEnd = function()
            setMissionStatus(8)
        end
    },
    oddajjajka2 = {
        npcName = 'Zajonc',
        messages = {
            {'me', 'nie, spierdalaj'},
            {'npc', 'to nie bylo pytanie cwelu'},
        },
        options = {
            {'pomoge ci, wezme polowe', 'oddajjajka3'},
        }
    },
    oddajjajka3 = {
        npcName = 'Zajonc',
        messages = {
            {'me', 'pomoge ci, wezme polowe'},
            {'npc', 'ok, to dawaj'},
        },
        options = {
            {'koniec', 'exit'},
        },
    },

    ---------------
    -- Zanies jajka do magazynu
    ---------------
    zawiezjajka = {
        npcName = 'Właściciel magazynu',
        messages = {
            {'me', 'mam jajka'},
            {'npc', 'dobra, to dawaj'},
        },
        options = {
            {'koniec', 'exit'},
        },
        onEnd = function()
            setMissionStatus(9)
        end
    },

    ---------------
    -- Okradli zajaca
    ---------------
    okradlizajaca = {
        npcName = 'Zając',
        messages = {
            {'me', 'co sie stalo?'},
            {'npc', 'okradli mnie, pomozesz mi?'},
        },
        options = {
            {'okradli cie z jajek?', 'okradlizajaca2'},
        },
        onEnd = function()
            setMissionStatus(10)
        end
    },
    okradlizajaca2 = {
        npcName = 'Zając',
        messages = {
            {'me', 'okradli cie z jajek?'},
            {'npc', 'tak, zabrał mi je jakis zjeb'},
            {'me', 'gdzie to sie stalo?'},
            {'npc', 'w tym magazynie'},
        },
        options = {
            {'pomoge ci', 'okradlizajaca3'},
        },
    },
    okradlizajaca3 = {
        npcName = 'Zając',
        messages = {
            {'me', 'pomoge ci'},
            {'npc', 'dobra tylko uwazaj bo maja bron'},
            {'me', 'jakbys nie mogl mi o tym wczesniej powiedziec ty kurwo'},
        },
        options = {
            {'ide ich szukać', 'exit'},
        },
    },

    ---------------
    -- Finish
    ---------------
    finish = {
        npcName = 'Zajonc',
        messages = {
            {'me', 'zrobilem to'},
            {'npc', 'dzieki, jestes zajebisty'},
            {'npc', 'masz tutaj jakies gowno, wez to sobie'},
        },
        options = {
            {'dzieki', 'exit'},
        },
        onEnd = function()
            setMissionStatus(12)
            triggerServerEvent('event:finish', resourceRoot)
        end
    },
}