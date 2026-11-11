function setRealTime()
    local realTime = getRealTime()
    local hour = realTime.hour
    local minute = realTime.minute
    setMinuteDuration(60000)
    setTime(hour, minute)
end
setTimer(setRealTime, 500, 1) 
setTimer(setRealTime, 3000000, 0) 