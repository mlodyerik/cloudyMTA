  

data = {
    ['ranks'] = {
        
        ['SAPD'] = {
        	[1] = 'Cadet',
        	[2] = 'Police Officer I',
        	[3] = 'Police Officer II',
        	[4] = 'Police Officer III',
        	[5] = 'Police Officer III+I',
        	[6] = 'Sergeant I',
        	[7] = 'Sergeant II',
        	[8] = 'Detective I',
        	[9] = 'Detective II',
        	[10] = 'Detective III',
        	[11] = 'Lieutenant',
        	[12] = 'Captain I',
        	[13] = 'Captain II',
        	[14] = 'Captain III',
        	[15] = 'Commander',
        	[16] = 'Deputy Chief',
        	[17] = 'Assistant Chief Of Police',
        	[18] = 'Chief Of Police',
        },
        
        ['SAFD'] = {
            [1] = 'Fire Cadet',
            [2] = 'Firefighter I',
            [3] = 'Firefighter II',
            [4] = 'Firefighter III',
            [5] = 'Senior Firefighter',
            [6] = 'Sectional I',
            [7] = 'Sectional II',
            [8] = 'Senior Section Officer',
            [9] = 'Junior Firemaster I',
            [10] = 'Junior Firemaster II',
            [11] = 'Senior Firemaster I',
            [12] = 'Senior Firemaster II',
            [13] = 'Aspirant I',
            [14] = 'Aspirant II',
            [15] = 'Senior Aspirant',
            [16] = 'Lieutenant',
            [17] = 'Captain',
            [18] = 'Paramedic',
            [19] = 'Deputy Chief Paramedic',
            [20] = 'Paramedic Chief',
            [21] = 'Battalion Chief',
            [22] = 'District Chief',
            [23] = 'Assistant Of Deputy Chief',
            [24] = 'Deputy Chief',
            [25] = 'Fire Chief',
        },

        ['SARA'] = {
            [1] = 'Adept',
            [2] = 'Worker',
            [3] = 'Employee',
            [4] =  'Senior Employee',
            [5] = 'Experienced Employee',
            [6] = 'Specialist',
            [7] = 'Experienced Specialist',
            [8] =  'Operator',
            [9] = 'Chief Operator',
            [10] = 'Assistant Manager',
            [11] = 'Manager',
            [12] = 'Assistant Engineer',
            [13] = 'Engineer',
            [14] = 'Main Engineer'
        },

        ['TSA'] = {

            [1] = 'Rekrut',
            [2] = 'Młodszy Kierowca',
            [3] = 'Kierowca',
            [4] = 'Doświadczony Kierowca',
            [5] = 'Starszy Kierowca',
            [6] = 'Specjalista',
            [7] = 'Doświadczony Specjalista',
            [8] = 'Starszy Specjalista',
            [9] = 'Szofer',
            [10] = 'Doświadczony Szofer',
            [11] = 'Starszy Szofer',
            [12] = 'Menadżer',
            [13] = 'Zastępca Kierownika',
            [14] = 'Kierownik',
            
        },
    },

    ['colors'] = {

        ['SAPD'] = '#005eff',
        ['SAFD'] = '#ff0000',
        ['SARA'] = '#ff962e',
        ['TSA'] = '#ffee00',

    },
}

function getMaxRank(faction)
    return data['ranks'][faction] and #data['ranks'][faction] or 0
end

function getRankData(faction, rank)
    return data['ranks'][faction] and data['ranks'][faction][rank] or 0
end

getResourceName(getThisResource(), true, 112736644); if true then return end