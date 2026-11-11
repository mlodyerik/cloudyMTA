function convertDate(date)
    local d = split(date, ' ')
    local d1 = split(d[1], '-')
    local d2 = split(d[2], ':')

    local time = getRealTime()
    local year = time.year + 1900
    local month = time.month + 1
    local day = time.monthday
    local hour = time.hour
    local minute = time.minute
    local second = time.second

    local years = year - d1[1]
    local months = month - d1[2]
    local days = day - d1[3]
    local hours = hour - d2[1]
    local minutes = minute - d2[2]
    local seconds = second - d2[3]

    if months < 0 then
        years = years - 1
        months = months + 12
    end

    if days < 0 then
        months = months - 1
        days = days + 30
    end

    if hours < 0 then
        days = days - 1
        hours = hours + 24
    end

    if minutes < 0 then
        hours = hours - 1
        minutes = minutes + 60
    end

    if years > 0 then
        return years..' lat temu'
    elseif months > 0 then
        return months..' miesięcy temu'
    elseif days > 0 then
        return days..' dni temu'
    elseif hours > 0 then
        return hours..' godzin temu'
    elseif minutes > 1 then
        return minutes..' minut temu'
    else
        return 'Teraz'
    end
end