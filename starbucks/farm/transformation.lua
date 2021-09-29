ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()
        
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function OpenstarbucksTransformation()
    local starbucksTransformation = RageUI.CreateMenu("Transformer graimedecoffe", "starbucks")
    starbucksTransformation:SetRectangleBanner(0, 150, 0)
    
    RageUI.Visible(starbucksTransformation, not RageUI.Visible(starbucksTransformation))
    
    while starbucksTransformation do
        Citizen.Wait(0)
        RageUI.IsVisible(starbucksTransformation, true, true, true, function()
                RageUI.ButtonWithStyle("Transformer graimedecoffe", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    RageUI.CloseAll()
                    transformationgraimedecoffe()
                    end
                end)
        end)
    
        if not RageUI.Visible(starbucksTransformation) then
            starbucksTransformation = RMenu:DeleteType("starbucksTransformation", true)
            end
        end
    end

local transformationpossible = false
Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        while true do
            local Timer = 500
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local playerCoords = GetEntityCoords(PlayerPedId())
            zoneDistance = GetDistanceBetweenCoords(playerCoords, starbucks.pos.transformation.position.x, starbucks.pos.transformation.position.y, starbucks.pos.transformation.position.z)
                if IsEntityAtCoord(PlayerPedId(), 0.0, -0.0, -0.0, 1.5, 1.5, 1.5, 0, 1, 0) then 
                    Timer = 0
                        if IsControlJustPressed(1, 51) then
                            OpenstarbucksTransformation()
                        end
                    end
                    if zoneDistance ~= nil then
                        if zoneDistance > 1.5 then
                            transformationpossible = false
                        end
                    end
                Wait(Timer)
            end    
        end)

function transformationgraimedecoffe()
    if not transformationpossible then
        transformationpossible = true
    while transformationpossible do
        Citizen.Wait(2000)
        TriggerServerEvent('coffe')
    end
    else
        transformationpossible = false
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'starbucks' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, starbucks.pos.transformation.position.x, starbucks.pos.transformation.position.y, starbucks.pos.transformation.position.z)
        if dist3 <= 10.0 and starbucks.jeveuxmarker then
            Timer = 0
            DrawMarker(20, starbucks.pos.transformation.position.x, starbucks.pos.transformation.position.y, starbucks.pos.transformation.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 150, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 3.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour transformer le graimedecoffe", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            OpenstarbucksTransformation()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)