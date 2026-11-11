local serials = {
    ['6892B667ED01261C7857C6196F6934B2'] = true
}

function isPlayerHaveOwnerPermissions(serial)
    return serials[serial]
end