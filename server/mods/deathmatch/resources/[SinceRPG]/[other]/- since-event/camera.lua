local interpolatingCamera = false

function interpolateCameraRender()
    local now = getTickCount()
    local elapsedTime = now - interpolatingCamera.startTime
    local duration = interpolatingCamera.duration
    local easing = interpolatingCamera.easing
    local start = interpolatingCamera.start
    local end_ = interpolatingCamera.end_
    local startLook = interpolatingCamera.startLook
    local endLook = interpolatingCamera.endLook

    if elapsedTime > duration then
        removeEventHandler("onClientRender", root, interpolateCameraRender)
        setCameraMatrix(end_.x, end_.y, end_.z, end_.rx, end_.ry, end_.rz)

        if interpolatingCamera.resetOnEnd then
            setCameraTarget(localPlayer)
        end
        interpolatingCamera = false
        return
    end

    local progress = elapsedTime / duration
    local x, y, z = interpolateBetween(
        start.x, start.y, start.z,
        end_.x, end_.y, end_.z,
        progress, easing
    )

    local lx, ly, lz = interpolateBetween(
        startLook.x, startLook.y, startLook.z,
        endLook.x, endLook.y, endLook.z,
        progress, easing
    )

    setCameraMatrix(x, y, z, lx, ly, lz)
end

function interpolateCamera(start, startLook, end_, endLook, duration, easing, resetOnEnd)
    interpolatingCamera = {
        start = start,
        end_ = end_,
        startLook = startLook,
        endLook = endLook,
        duration = duration,
        easing = easing,
        startTime = getTickCount(),
        resetOnEnd = resetOnEnd
    }

    addEventHandler("onClientRender", root, interpolateCameraRender)
end