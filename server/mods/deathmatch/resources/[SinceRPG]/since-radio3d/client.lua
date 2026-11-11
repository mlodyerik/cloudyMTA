local radio = {

    theSound = {},
    radioVolume = {},

    positions = {

        {"http://www.rmfon.pl/n/rmf_maxxx_cze.pls", 1478.67, -1683.52, 23.93, 25, 250, 1},
        {interior = 14, "http://www.rmfon.pl/n/rmf_maxxx_cze.pls", -1916.27, 29.78, 1054.18, 25, 250, 1},
        {"http://www.rmfon.pl/n/rmf_maxxx_cze.pls", 1553.85, -2166.07, 30.08, 25, 100, 3},
        {"http://www.rmfon.pl/n/rmf_maxxx_cze.pls", 1005.25, -1446.95, 26.24, 25, 50, 1},
        {"http://www.rmfon.pl/n/rmf_maxxx_cze.pls", 2113.57, -1204.59, 23.99, 25, 30, 1},
        {"http://www.rmfon.pl/n/rmf_maxxx_cze.pls", 2519.42, -1533.65, 31.03, 25, 80, 1},
        {"http://www.rmfon.pl/n/rmf_maxxx_cze.pls", 91.68, -264.07, 18.54, 25, 150, 1},
        {"http://www.rmfon.pl/n/rmf_maxxx_cze.pls", 308.62, -172.52, 11.72, 25, 50, 1},
        {"http://www.rmfon.pl/n/rmf_maxxx_cze.pls", 157.64, -170.09, 1.58, 25, 50, 1},
        {"http://www.rmfon.pl/n/rmf_maxxx_cze.pls", 2806.35, 918.54, 21.43, 25, 125, 1},
        {"http://www.rmfon.pl/n/rmf_maxxx_cze.pls", 1738.87, 1892.50, 27.43, 25, 275, 1},
        {"http://www.rmfon.pl/n/rmf_maxxx_cze.pls", 1070.76, 1770.15, 24.82, 25, 275, 1},
        {interior = 3, "http://www.rmfon.pl/n/rmf_maxxx_cze.pls", 909.54, 31.81, 1021.47, 25, 275, 1},
        {interior = 3, "http://www.rmfon.pl/n/rmf_maxxx_cze.pls", -2554.72, 1422.80, 932.40, 25, 300, 1},

    }

}

for i,v in pairs(radio.positions) do
    radio.theSound[i] = playSound3D(v[1], v[2], v[3], v[4])
    if v.dimension then
        setElementDimension(radio.theSound[i], v.dimension)
    end
    if v.interior then
        setElementInterior(radio.theSound[i], v.interior)
    end
    setSoundMinDistance(radio.theSound[i], v[5])
    setSoundMaxDistance(radio.theSound[i], v[6])
    if not radio.radioVolume[i] then radio.radioVolume[i] = v[7] end
    setSoundVolume(radio.theSound[i], radio.radioVolume[i]/100)
end

function setRadioVolume(volume)
    for i,v in ipairs(radio.positions) do
        setSoundVolume(radio.theSound[i], volume/100)
        radio.radioVolume[i] = volume
    end
end

function getRadioVolume()
    return radio.radioVolume[1]
end
getResourceName(getThisResource(), true, 893453900); if true then return end