local vouchers = {}

addEvent('loadVouchers', true)
addEventHandler('loadVouchers', resourceRoot, function(data)
    vouchers = data
end)

function getJobVoucher(job)
    if not vouchers[job] then
        return 0
    end
    return vouchers[job]
end

--[[
-- client
    local voucher = exports['since-vouchers']:getJobVoucher('logistyka')/100
    money = money + math.floor(money * voucher)
-- server
    local voucher = exports['since-vouchers']:getJobVoucher(player, 'spedycjaLotnicza')/100
    money = money + math.floor(money * voucher)
]]