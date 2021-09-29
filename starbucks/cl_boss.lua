ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societystarbucksmoney = nil

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


---------------- FONCTIONS ------------------

function Bossstarbucks()
    local starbucks = RageUI.CreateMenu("Actions Patron", "starbucks")
    starbucks:SetRectangleBanner(0, 150, 0)

      RageUI.Visible(starbucks, not RageUI.Visible(starbucks))
  
              while starbucks do
                  Citizen.Wait(0)
                      RageUI.IsVisible(starbucks, true, true, true, function()
  
            if societystarbucksmoney ~= nil then
                RageUI.ButtonWithStyle("Argent société :", nil, {RightLabel = "$" .. societystarbucksmoney}, true, function()
                end)
            end

            RageUI.ButtonWithStyle("Retirer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "Montant invalide"})
                    else
                        TriggerServerEvent('esx_society:withdrawMoney', 'starbucks', amount)
                        RefreshstarbucksMoney()
                    end
                end
            end)

            RageUI.ButtonWithStyle("Déposer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "Montant invalide"})
                    else
                        TriggerServerEvent('esx_society:depositMoney', 'starbucks', amount)
                        RefreshstarbucksMoney()
                    end
                end
            end) 

           RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    aboss()
                    RageUI.CloseAll()
                end
            end)


        end, function()
        end)
        if not RageUI.Visible(starbucks) then
        starbucks = RMenu:DeleteType("starbucks", true)
    end
end
end

----------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'starbucks' and ESX.PlayerData.job.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, starbucks.pos.boss.position.x, starbucks.pos.boss.position.y, starbucks.pos.boss.position.z)
        if dist3 <= 7.0 and starbucks.jeveuxmarker then
            Timer = 0
            DrawMarker(20, starbucks.pos.boss.position.x, starbucks.pos.boss.position.y, starbucks.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 150, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            RefreshstarbucksMoney()           
                            Bossstarbucks()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshstarbucksMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietystarbucksMoney(money)
        end, ESX.PlayerData.job.name)
    end
end

function UpdateSocietystarbucksMoney(money)
    societystarbucksmoney = ESX.Math.GroupDigits(money)
end

function aboss()
    TriggerEvent('esx_society:openBossMenu', 'starbucks', function(data, menu)
        menu.close()
    end, {wash = false})
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

