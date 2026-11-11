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
    -- Konfiguracja dla lokalnego XAMPP
    -- Host: 127.0.0.1, Port: 3306, Database: since, User: root, Password: '' (domyślnie puste w XAMPP)
    -- Jeśli zmieniłeś hasło root w XAMPP, zaktualizuj czwarty parametr poniżej
    connection = dbConnect('mysql', 'dbname=since;host=127.0.0.1;port=3306;charset=utf8', 'root', '', 'share=1')
    
    if connection then
        outputServerLog('[since-db] Successfully connected with database')
        print('[since-db] Successfully connected with MySQL database: since')
    else
        outputServerLog('[since-db] [ERROR] Failed to connect with database! Check XAMPP and credentials.')
        print('[since-db] [ERROR] Failed to connect with database!')
        print('[since-db] [INFO] Make sure XAMPP MySQL is running and database "since" exists')
    end
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