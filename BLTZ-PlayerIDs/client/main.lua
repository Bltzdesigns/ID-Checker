local display = false
local toggleKey = 303 
local maxDistance = 10.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlPressed(0, toggleKey) then
            display = true
        else
            display = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if display then
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            if DoesEntityExist(playerPed) then
                local coords = GetEntityCoords(playerPed)
                local players = GetActivePlayers()
                
                for _, player in ipairs(players) do
                    local targetPed = GetPlayerPed(player)
                    if DoesEntityExist(targetPed) and targetPed ~= playerPed then
                        local targetCoords = GetEntityCoords(targetPed)
                        local dist = #(coords - targetCoords)
                        
                        if dist <= maxDistance then
                            local serverId = GetPlayerServerId(player)
                            DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.0, tostring(serverId))
                        end
                    end
                end
                local ownServerId = GetPlayerServerId(PlayerId())
                DrawText3D(coords.x, coords.y, coords.z + 1.0, tostring(ownServerId))
            end
        else
            Citizen.Wait(0)
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local camCoords = GetGameplayCamCoords()
        local dist = #(vector3(x, y, z) - camCoords)
        local scale = (1 / dist) * 2 * (1 / GetGameplayCamFov()) * 100
        scale = math.max(0.2, math.min(scale, 3.0))
        SetTextScale(0.7 * scale, 0.7 * scale)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

