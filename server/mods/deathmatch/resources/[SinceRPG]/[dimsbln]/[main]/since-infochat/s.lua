local wiadomki = {
    {"#48f542★ #FFFFFFDiscord serwera znajdziesz pod adresem: https://discord.gg/qyrq2DzJ6Q"},
    {"#48f542★ #FFFFFFForum serwera znajdziesz pod adresem: https://sincerpg.pl/"},
    {"#48f542★ #FFFFFFZapraszaj swoich znajomych do gry na serwerze!"},
    {"#48f542★ #FFFFFFSzukasz podwózki? Wpisz /taxi i wyślij zgłoszenie do frakcji TSA"},
    {"#48f542★ #FFFFFFJesteś tutaj po raz pierwszy? Kliknij F1!"},
    {"#48f542★ #FFFFFFAby sprawdzić lokalizację pojazdów na mapie wejdź w zakładkę ''pojazdy'' pod F2."},
    {"#48f542★ #FFFFFFPotrzebujesz pomocy lub ktoś przeszkadza ci w rozgrywce? /report [Nick/ID] [Powód]"},
    {"#48f542★ #FFFFFFInterakcje z otoczeniem znajdziesz pod przyciskiem 'N'"},
    {"#48f542★ #FFFFFFAby skorzystać z panelu wymian użyj interakcji z otoczeniem"},
    {"#48f542★ #FFFFFFJeśli jesteś zainteresowany zakupem prywatnej podmianki lub innych usług, zapraszam do kontaktu z zevy, tworix lub xelvor"},
    {"#48f542★ #FFFFFFCzy wiesz, że: możesz połączyć swoje konto z naszym botem na discordzie? Napisz do naszego bota na discordzie wiadomość o treści: ''/polacz''."},
}

function wiadomkaCzas ()
   losujWiadomke = math.random(1, #wiadomki)
   outputChatBox(""..wiadomki[losujWiadomke][1].."", getRootElement(), 255, 255, 255, true )
end

setTimer(wiadomkaCzas, 60000 * 5, 0)