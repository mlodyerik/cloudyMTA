quests = {
    [1] = {
        text = 'Przenieś 40 paczek na pracy magazyniera',
        progress = 40,
        rewards = {
            {'money', 3500000},
            {'pp', 100},
        },
    },
    [2] = {
        text = 'Zbierz 40 grzybów na pracy grzybiarza',
        progress = 40,
        rewards = {
            {'money', 2000000},
            {'pp', 75},
        },
    },
    [3] = {
        text = 'Zalicz 30 punktów na pracy maszynisty',
        progress = 30,
        rewards = {
            {'money', 500000},
            {'pp', 20},
        },
    },
    [4] = {
        text = 'Dostarcz 30 paczek na pracy kuriera',
        progress = 30,
        rewards = {
            {'money', 400000},
            {'pp', 50},
        },
    },
    [5] = {
        text = 'Przetransportuj 20 klientów za pomocą aplikacji transportowej',
        progress = 20,
        rewards = {
            {'money', 4500000},
            {'pp', 150},
        },
    },
    [6] = {
        text = 'Złów 500 kg ryb',
        progress = 500,
        rewards = {
            {'money', 4500000},
            {'pp', 75},
        },
    },
    [7] = {
        text = 'Wykop 500 kg węgla na pracy górnika',
        progress = 500,
        rewards = {
            {'money', 5500000},
            {'pp', 85},
        },
    },
    [8] = {
        text = 'Wykonaj 15 kursów na pracy lawet',
        progress = 15,
        rewards = {
            {'money', 3500000},
            {'pp', 65},
        },
    },
}

weekRewards = {
    {'money', 15000000},
    {'wpln', 200},
    {'pp', 500},
}

function formatRewardsText()
    for i,v in ipairs(quests) do
        local tbl = {}
        for i,v in ipairs(v.rewards) do
            if v[1] == 'money' then
                table.insert(tbl, formatNumber(v[2])..' $')
            elseif v[1] == 'srp' then
                table.insert(tbl, formatNumber(v[2])..' SRP')
            elseif v[1] == 'wpln' then
                table.insert(tbl, formatNumber(v[2])..' WPLN')
            elseif v[1] == 'pp' then
                table.insert(tbl, formatNumber(v[2])..' PP')
            end
        end
        v.rewardsText = table.concat(tbl, ', ')
    end
end

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1 %2') 
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end

if localPlayer then formatRewardsText() end