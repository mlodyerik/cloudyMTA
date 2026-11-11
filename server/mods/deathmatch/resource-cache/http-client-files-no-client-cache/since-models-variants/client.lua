getResourceName(getThisResource(), true, 759518291); --if true then return end
local key = "tZFqJFbz7UvbdYjVPDPTVz"

local models = {

    {"models/sadler.txde", 543},
    {"models/sadler.dffe", 543},

    {"models/police_dodge.txde", 596},
    {"models/police_dodge.dffe", 596},

    -- {"models/firetruck.txde", 407},
    -- {"models/firetruck.dffe", 407},

    {"models/comet.txde", 480},
    {"models/comet.dffe", 480},

    {"models/buffalo.dffe", 402},

    {"models/turismo.dffe", 451},

    {"models/cheetah.dffe", 415},
    
    {"models/sentinel.txde", 405},
    {"models/sentinel.dffe", 405},

    {"models/fbiranch.txde", 490},
    {"models/fbiranch.dffe", 490},

    {"models/primo.txde", 547},
    {"models/primo.dffe", 547},

    {"models/sabre.txde", 475},
    {"models/sabre.dffe", 475},

    {"models/manana.dffe", 410},

    {"models/huntley.txde", 579},
    {"models/huntley.dffe", 579},

    {"models/sandking.txde", 495},
    {"models/sandking.dffe", 495},

    {"models/fortune.txde", 526},
    {"models/fortune.dffe", 526},

    {"models/elegant.txde", 507},
    {"models/elegant.dffe", 507},

    {"models/uranus.txde", 558},
    {"models/uranus.dffe", 558},

    {"models/greenwood.txde", 492},
    {"models/greenwood.dffe", 492},
}

function fileDecode(path)
local file = fileOpen(path)
local data = fileRead(file, fileGetSize(file))
fileClose(file)

local data = teaDecode(data, key)
local txt = string.gsub(path, "models/", "")
outputConsole("* Zdekodowano pojazd "..txt)
return data
end
    
function decode()
    for i,v in pairs(models) do
        if string.find(v[1], ".txde") then
            local data = fileDecode(v[1])
            local txd = engineLoadTXD(data)
            engineImportTXD(txd, v[2])
        elseif string.find(v[1], ".dffe") then
            local data = fileDecode(v[1])
            local dff = engineLoadDFF(data)
            engineReplaceModel(dff, v[2])
        end
    end
end
    
addEventHandler("onClientResourceStart", resourceRoot, function()
    decode()
end)