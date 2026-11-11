function getTime()
    local time = getRealTime();
    return time.hour..":"..time.minute
end

function getDate()
    local time = getRealTime();
    return (time.monthday).."-"..(time.month+1).."-"..(time.year+1900)
end
    
function saveInFile(name, text)
    local file = nil
    if fileExists("files/"..name..".txt") then
        file = fileOpen("files/"..name..".txt")
    else
        file = fileCreate("files/"..name..".txt")
    end
    fileSetPos(file, fileGetSize(file))
    fileWrite(file, "["..getDate().." "..getTime().."] "..text:gsub("#%x%x%x%x%x%x", "").."\r")
    fileFlush(file)
    fileClose(file)
end

local connection;

function connectWithDatabase()
    connection = dbConnect('mysql', 'dbname=since;host=127.0.0.1;port=3306;charset=utf8mb4', 'root', '', 'share=1')
    
    if connection then
        print('[SinceRPG] Successfully connected with database')
        print('[SinceRPG] Database: since | Host: 127.0.0.1:3306')
    else
        print('[SinceRPG] ERROR: Failed to connect with database!')
        print('[SinceRPG] Check if MySQL is running and database "since" exists')
    end
    
    return connection
end

function status()
    return not not connection
end

function query(...)
	saveInFile(getDate(), getResourceName(sourceResource).." - "..(...))

    local q = dbQuery(connection, ...)

    return dbPoll(q, -1)
end
addEventHandler('onResourceStart', resourceRoot, connectWithDatabase)