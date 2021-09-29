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

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)


Citizen.CreateThread(function()
    if starbucks.jeveuxblips then
    local starbucksmap = AddBlipForCoord(starbucks.pos.blips.position.x, starbucks.pos.blips.position.y, starbucks.pos.blips.position.z)

    SetBlipSprite(starbucksmap, 93)
    SetBlipColour(starbucksmap, 2)
    SetBlipScale(starbucksmap, 0.65)
    SetBlipAsShortRange(starbucksmap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("starbucks")
    EndTextCommandSetBlipName(starbucksmap)
end
end)


function Menuf6starbucks()
    local starbucksf6 = RageUI.CreateMenu("starbucks", "Interactions")
    local starbucksf6sub = RageUI.CreateSubMenu(starbucksf6, "starbucks", "Interactions")
    starbucksf6:SetRectangleBanner(0, 150, 0)
    starbucksf6sub:SetRectangleBanner(0, 150, 0)
    RageUI.Visible(starbucksf6, not RageUI.Visible(starbucksf6))
    while starbucksf6 do
        Citizen.Wait(0)
            RageUI.IsVisible(starbucksf6, true, true, true, function()

                RageUI.Separator("↓ Facture ↓")

                RageUI.ButtonWithStyle("Facture",nil, {RightLabel = "→"}, true, function(_,_,s)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if s then
                        local raison = ""
                        local montant = 0
                        AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                raison = result
                                result = nil
                                AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0)
                                    Wait(0)
                                end
                                if (GetOnscreenKeyboardResult()) then
                                    result = GetOnscreenKeyboardResult()
                                    if result then
                                        montant = result
                                        result = nil
                                        if player ~= -1 and distance <= 3.0 then
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_starbucks', ('starbucks'), montant)
                                            TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                        else
                                            ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)


                RageUI.Separator("↓ Annonce ↓")



                RageUI.ButtonWithStyle("Annonces d'ouverture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        TriggerServerEvent('AnnoncestarbucksOuvert')
                    end
                end)
        
                RageUI.ButtonWithStyle("Annonces de fermeture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then      
                        TriggerServerEvent('AnnoncestarbucksFermer')
                    end
                end)

                RageUI.Separator("")

                RageUI.ButtonWithStyle("Menu travail", nil,  {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, starbucksf6sub)


                end, function() 
                end)
    
                RageUI.IsVisible(starbucksf6sub, true, true, true, function()

                RageUI.ButtonWithStyle("Récolte graimedecoffe",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        SetNewWaypoint(starbucks.pos.recolte.position.x, starbucks.pos.recolte.position.y)
                    end
                end)

                RageUI.ButtonWithStyle("Transformation graimedecoffe",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        SetNewWaypoint(starbucks.pos.transformation.position.x, starbucks.pos.transformation.position.y)
                    end
                end)

                RageUI.ButtonWithStyle("Vente coffe",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        SetNewWaypoint(starbucks.pos.vente.position.x, starbucks.pos.vente.position.y)
                    end
                end)
            end, function() 
            end)
    
                if not RageUI.Visible(starbucksf6) and not RageUI.Visible(starbucksf6sub) then
                    starbucksf6 = RMenu:DeleteType("starbucksf6", true)
        end
    end
end


Keys.Register('F6', 'starbucks', 'Ouvrir le menu starbucks', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'starbucks' then
    	Menuf6starbucks()
	end
end)




function Coffrestarbucks()
    local starbucks = RageUI.CreateMenu("Coffre", "starbucks")
    starbucks:SetRectangleBanner(0, 150, 0)
        RageUI.Visible(starbucks, not RageUI.Visible(starbucks))
            while starbucks do
            Citizen.Wait(0)
            RageUI.IsVisible(starbucks, true, true, true, function()

                RageUI.Separator("↓ Objet / Arme ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            starbucksRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            starbucksDeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.Separator("↓ Vêtements ↓")

                    RageUI.ButtonWithStyle("starbucks",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            tenuestarbucks()
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.ButtonWithStyle("Remettre sa tenue",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            vcivil()
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

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'starbucks' then
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, starbucks.pos.coffre.position.x, starbucks.pos.coffre.position.y, starbucks.pos.coffre.position.z)
            if jobdist <= 10.0 and starbucks.jeveuxmarker then
                Timer = 0
                DrawMarker(20, starbucks.pos.coffre.position.x, starbucks.pos.coffre.position.y, starbucks.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 150, 0, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        Coffrestarbucks()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)


function Garagestarbucks()
    local starbucks = RageUI.CreateMenu("Garage", "starbucks")
    starbucks:SetRectangleBanner(0, 150, 0)
      RageUI.Visible(starbucks, not RageUI.Visible(starbucks))
          while starbucks do
              Citizen.Wait(0)
                  RageUI.IsVisible(starbucks, true, true, true, function()
                      RageUI.ButtonWithStyle("Ranger la voiture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                          if (Selected) then   
                          local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                          if dist4 < 4 then
                              DeleteEntity(veh)
                              RageUI.CloseAll()
                              end 
                          end
                      end) 
  
                      for k,v in pairs(starbucksvoiture) do
                      RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                          if (Selected) then
                          Citizen.Wait(1)  
                              spawnuniCarstarbucks(v.modele)
                              RageUI.CloseAll()
                              end
                          end)
                      end
                  end, function()
                  end)
              if not RageUI.Visible(starbucks) then
              Gstarbucks = RMenu:DeleteType("Garage", true)
          end
      end
  end
  
  Citizen.CreateThread(function()
          while true do
              local Timer = 500
              if ESX.PlayerData.job and ESX.PlayerData.job.name == 'starbucks' then
              local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
              local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, starbucks.pos.garage.position.x, starbucks.pos.garage.position.y, starbucks.pos.garage.position.z)
              if dist3 <= 10.0 and starbucks.jeveuxmarker then
                  Timer = 0
                  DrawMarker(20, starbucks.pos.garage.position.x, starbucks.pos.garage.position.y, starbucks.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 150, 0, 255, 0, 1, 2, 0, nil, nil, 0)
                  end
                  if dist3 <= 3.0 then
                  Timer = 0   
                      RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au garage", time_display = 1 })
                      if IsControlJustPressed(1,51) then           
                          Garagestarbucks()
                      end   
                  end
              end 
          Citizen.Wait(Timer)
       end
  end)
  
  function spawnuniCarstarbucks(car)
      local car = GetHashKey(car)
  
      RequestModel(car)
      while not HasModelLoaded(car) do
          RequestModel(car)
          Citizen.Wait(0)
      end
  
      local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
      local vehicle = CreateVehicle(car, starbucks.pos.spawnvoiture.position.x, starbucks.pos.spawnvoiture.position.y, starbucks.pos.spawnvoiture.position.z, starbucks.pos.spawnvoiture.position.h, true, false)
      SetEntityAsMissionEntity(vehicle, true, true)
      local plaque = "starbucks"..math.random(1,9)
      SetVehicleNumberPlateText(vehicle, plaque) 
      SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
  end



function tenuestarbucks()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = starbucks.Uniforms.male
        else
            uniformObject = starbucks.Uniforms.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end


function vcivil()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        TriggerEvent('skinchanger:loadSkin', skin)
       end)
    end

itemstock = {}
function starbucksRetirerobjet()
    local Stockstarbucks = RageUI.CreateMenu("Coffre", "starbucks")
    Stockstarbucks:SetRectangleBanner(0, 150, 0)
    ESX.TriggerServerCallback('starbucks:getStockItems', function(items) 
    itemstock = items
    RageUI.Visible(Stockstarbucks, not RageUI.Visible(Stockstarbucks))
        while Stockstarbucks do
            Citizen.Wait(0)
                RageUI.IsVisible(Stockstarbucks, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count ~= 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", '' , 8)
                                    TriggerServerEvent('starbucks:getStockItem', v.name, tonumber(count))
                                    starbucksRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(Stockstarbucks) then
            Stockstarbucks = RMenu:DeleteType("Coffre", true)
        end
    end
end)
end

local PlayersItem = {}
function starbucksDeposerobjet()
    local Depositstarbucks = RageUI.CreateMenu("Coffre", "starbucks")
    Depositstarbucks:SetRectangleBanner(0, 150, 0)
    ESX.TriggerServerCallback('starbucks:getPlayerInventory', function(inventory)
        RageUI.Visible(Depositstarbucks, not RageUI.Visible(Depositstarbucks))
    while Depositstarbucks do
        Citizen.Wait(0)
            RageUI.IsVisible(Depositstarbucks, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                            local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('starbucks:putStockItems', item.name, tonumber(count))
                                            starbucksDeposerobjet()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(Depositstarbucks) then
                Depositstarbucks = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end
