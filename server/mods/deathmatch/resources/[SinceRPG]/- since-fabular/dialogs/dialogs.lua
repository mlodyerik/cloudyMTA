dialogs = {
    ---------------
    -- Start eventu
    ---------------
    szkielet_poczatek = {
        npcName = 'Szkielet',
        messages = {
            {'npc', 'Ej, Ty.'},
            {'me', 'Yyy.. t-tak?'},
            {'npc', 'Dlaczego szlajasz się sam po lesie, wiesz, że możesz tu zginąć?'},
            {'me', 'Nie wiedziałem, że jestem sam...'},
            {'npc', 'Niewiedza wiele kosztuje..'},
            {'me', 'To znaczy?'},
            {'npc', 'Jeśli chcesz przeżyć musisz wykonać dla mnie jedno zadanie.'},
            {'me', 'Jakie zadanie? O co chodzi..'},
            {'npc', 'Od jakiegoś czasu mam problem z czarownikiem, który ukradł mi moją księgę czarnej magii.'},
            {'me', 'I co mam z tym zrobić?'},
            {'npc', 'Musisz odnaleźć jego chatkę i ukraść księge.'},
            {'me', 'Wiesz chociaż gdzie moge go znaleźć?'},
            {'npc', 'Z tego co wiem jego chatka znajduje się w jednym z lasów obok Los Santos w kierunku Las Venturas.'},
            {'me', 'Dzięki za informacje, postaram się coś zrobić.'},
            {'npc', 'Nie zapomnij o księdze, bez niej nie wracaj bo inaczej zginiesz.'},
            {'npc', 'A i uważaj.. roi się tam od zombie..'},
            
        },

        options = {
            {'Koniec', 'exit'},
        },

        onEnd = function()
            setMissionStatus(2)
        end
    },

    zombie_poczatek = {
        npcName = 'Zombie',
        messages = {

            {'npc', 'Halo.. co ty tutaj robisz..'},
            {'me', 'O boże, ty mówisz!'},
            {'npc', 'Co w tym dziwnego?'},
            {'me', 'Może to, że jesteś martwy? Dlaczego roi się tutaj od zombie i dlaczego są neutralni?'},
            {'npc', 'Ahh te stereotypy.. jesteśmy zombie, owszem.. Tylko jakby ci to powiedzieć, nie jesteśmy tacy źli jak nas opisują..'},
            {'me', 'Okej, dobrze.. już się bałem..'},
            {'npc', 'Co cię tutaj sprowadza?'},
            {'me', 'Przechadzałem się po lesie obok Angel Pine i napotkałem szkieleta w chatce nieopodal, powiedział, że jak nie odnajde jego księgi to mnie zabije...'},
            {'npc', 'Jakiej księgi?'},
            {'me', 'Chodzi tutaj o księge czarnej magii, podobno jakiś czarownik mu ją ukradł a jego chatka powinna znajdować się w tym miejscu'},
            {'npc', 'Czarownik... hmmm...'},
            {'npc', 'Chodzi ci o Mareczka? To żaden czarownik, jest alkoholikiem i ubiera się w jakieś szaty ze śmietnika'},
            {'me', 'Emm.. okej..'},
            {'npc', 'Mogę ogarnąć ci tę księge ale potrzebuje czegoś w zamian..'},
            {'me', 'Czego potrzebujesz?'},
            {'npc', 'Kilka butelek wódki, najlepiej zimnej..'},
            {'me', 'Zombie i wódka?'},
            {'npc', 'To, że jestem zombie nie znaczy że nie lubie walnąc w palnik'},
            {'me', 'Okej, postaram się coś zrobić..'},
            {'npc', 'Tylko jest coś jeszcze'},
            {'me', 'Co?'},
            {'npc', 'To nie może byc byle jaka wódka, to edycja limitowana Żubrówki i znajduje się w jednej z jaskiń na terenie Bone County'},
            {'me', 'Okej, dzięki za informacje..'},
            
        },

        options = {
            {'Koniec', 'exit'},
        },

        onEnd = function()
            setMissionStatus(3)
        end
    },

    zombie_powrot_bez = {
        npcName = 'Zombie',
        messages = {

            {'npc', 'Masz wódkę?'},
            {'me', 'Niestety nie..'},
            {'npc', 'To wracaj jak ją znajdziesz..'},
            
        },

        options = {
            {'Koniec', 'exit'},
        },

        onEnd = function()
            setMissionStatus(3)
        end
    },

    zombie_powrot_podaje = {
        npcName = 'Zombie',
        messages = {

            {'npc', 'Dzięki za wódeczkę, teraz mogę się napić * jebie z gwinta *'},
            {'me', 'Dobra, teraz powiedz mi gdzie jest ta księga..'},
            {'npc', 'Księge ma jeden z kolegów Mareczka, nazywa się Juzek i egzystuje w okolicach Bayside Marina'},
            {'me', 'Masz jakiś kontakt do niego?'},
            {'npc', 'Juzio po ostatnim melanżu zgubił telefon i portfel więc z kontaktem to ciężko..'},
            {'me', 'No dobra..'},
            
        },

        options = {
            {'Koniec', 'exit'},
        },

        onEnd = function()
            setMissionStatus(5)
        end
    },

    zombie_powrot = {
        npcName = 'Zombie',
        messages = {

            {'npc', 'Masz wódkę?'},
            {'me', 'No mam'},
            {'npc', 'Dawaj mi ją bo już mnie trzęsie'},
            
        },

        options = {
            {'Podaj wódke', 'zombie_powrot_podaje'},
        },

        onEnd = function()
        end
    },

    juzek_poczatek = {
        npcName = 'Juzek',
        messages = {

            {'npc', 'Czego chcesz?'},
            {'me', 'Przysłał mnie tutaj jakiś zombie'},
            {'npc', 'Mateuszek? Jebany daje w palnik ile wlezie'},
            {'me', 'Tak, chyba on'},
            {'npc', 'Co chcesz?'},
            {'me', 'Szukam księgi czarnej magii, podobno miał ją Mareczek, wiesz cos o tym?'},
            {'npc', 'Musisz iść do mareczka stoi pewnie pod molo w Los Santos'},
            {'me', 'Dzięki za informacje..'},
            
        },

        options = {
            {'Koniec', 'exit'},
        },

        onEnd = function()
            setMissionStatus(6)
        end
    },

    mareczek_poczatek = {
        npcName = 'Mareczek',
        messages = {

            {'npc', 'Czego chcesz?'},
            {'me', 'Przysłał mnie tutaj Juzek, szukam księgi czarnej magii, masz ją?'},
            {'npc', 'Tak, mam.. Trzymaj.'},

            
        },

        options = {
            {'Koniec', 'exit'},
        },

        onEnd = function()
            setMissionStatus(7)
        end
    },

    szkielet_koniec = {
        npcName = 'Szkielet',
        messages = {
            {'npc', 'I co? Masz moją księge?'},
            {'me', 'Tak, mam..'},
            {'npc', 'Dzięki, teraz mogę znowu rządzić tymi lasami..'},
            {'me', 'A co z obietnicą?'},
            {'npc', 'Obietnica to obietnica..'},
            {'npc', 'Oto twoja nagroda..'},
            {'npc', 'Dzięki za pomoc..'},

        },

        options = {
            {'Odbierz nagrodę', 'exit'},
        },

        onEnd = function()
            setMissionStatus(8)
            triggerServerEvent('event:finish', resourceRoot)
        end
    },
}