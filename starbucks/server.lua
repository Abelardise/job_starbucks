ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


TriggerEvent('esx_phone:registerNumber', 'starbucks', 'alerte starbucks', true, true)
TriggerEvent('esx_society:registerSociety', 'starbucks', 'starbucks', 'society_starbucks', 'society_starbucks', 'society_starbucks', {type = 'private'})


ESX.RegisterServerCallback('starbucks:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_starbucks', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('starbucks:getStockItem')
AddEventHandler('starbucks:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_starbucks', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Objet retiré', count, inventoryItem.label)
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('starbucks:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('starbucks:putStockItems')
AddEventHandler('starbucks:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_starbucks', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, inventoryItem.name))
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source

	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)

		-- Is it worth telling all clients to refresh?
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'starbucks' then
			Citizen.Wait(5000)
			TriggerClientEvent('esx_starbucksjob:updateBlip', -1)
		end
	end
end)

RegisterServerEvent('esx_starbucksjob:spawned')
AddEventHandler('esx_starbucksjob:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'starbucks' then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_starbucksjob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_starbucksjob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'starbucks')
	end
end)

RegisterServerEvent('esx_starbucksjob:message')
AddEventHandler('esx_starbucksjob:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

RegisterServerEvent('AnnoncestarbucksOuvert')
AddEventHandler('AnnoncestarbucksOuvert', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'starbucks', '~g~Annonce', 'Venez acheter le meilleur café de la ville!', 'CHAR_coffe', 8)
	end
end)

RegisterServerEvent('AnnoncestarbucksFermer')
AddEventHandler('AnnoncestarbucksFermer', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'starbucks', '~g~Annonce', 'La starbucks est désormais fermé à plus tard!', 'CHAR_coffe', 8)
	end
end)

RegisterServerEvent('starbucks:prendreitems')
AddEventHandler('starbucks:prendreitems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_starbucks', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Objet retiré', count, inventoryItem.label)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
		end
	end)
end)


RegisterNetEvent('starbucks:stockitem')
AddEventHandler('starbucks:stockitem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_starbucks', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, "Objet déposé "..count..""..inventoryItem.label.."")
		else
			TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
		end
	end)
end)


ESX.RegisterServerCallback('starbucks:inventairejoueur', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('starbucks:prendreitem', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_starbucks', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('starbucks:getArmoryWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_starbucks', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('starbucks:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_starbucks', function(store)
		local weapons = store.get('weapons') or {}
		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('starbucks:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_starbucks', function(store)
		local weapons = store.get('weapons') or {}

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

RegisterNetEvent('graimedecoffe')
AddEventHandler('graimedecoffe', function()
    local item = "graimedecoffe"
    local limiteitem = 50
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbitemdansinventaire = xPlayer.getInventoryItem(item).count
    

    if nbitemdansinventaire >= limiteitem then
        TriggerClientEvent('esx:showNotification', source, "T\'as pas assez de place dans ton inventaire !")
    else
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "Récolte en cours...")
    end
end)

RegisterNetEvent('coffe')
AddEventHandler('coffe', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local graimedecoffe = xPlayer.getInventoryItem('graimedecoffe').count
    local coffe = xPlayer.getInventoryItem('coffe').count

    if coffe > 50 then
        TriggerClientEvent('esx:showNotification', source, '~r~Il semble que tu ne puisses plus porter de coffe...')
    elseif graimedecoffe < 5 then
        TriggerClientEvent('esx:showNotification', source, '~r~Pas assez de graimedecoffe pour traiter...')
    else
        xPlayer.removeInventoryItem('graimedecoffe', 5)
        xPlayer.addInventoryItem('coffe', 2)    
    end
end)

RegisterNetEvent('ventecoffe')
AddEventHandler('ventecoffe', function()

    local money = math.random(10,50)
	local playerMoney  = math.random(1,5)
    local xPlayer = ESX.GetPlayerFromId(source)
    local societyAccount = nil
    local coffe = 0

    if xPlayer.getInventoryItem('coffe').count <= 0 then
        coffe = 0
    else
        coffe = 1
    end

    if coffe == 0 then
        TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Pas assez de coffe pour vendre...')
        return
    elseif xPlayer.getInventoryItem('coffe').count <= 0 and argent == 0 then
        TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Pas assez de coffe pour vendre...')
        coffe = 0
        return
    elseif coffe == 1 then
            local money = math.random(starbucks.ventemin,starbucks.ventemax)
            xPlayer.removeInventoryItem('coffe', 1)
            local societyAccount = nil

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_starbucks', function(account)
                societyAccount = account
            end)
            if societyAccount ~= nil then
                societyAccount.addMoney(money)
				xPlayer.addAccountMoney('money', starbucks.argentjoueur)
                TriggerClientEvent('esx:showNotification', source, "~g~Vendue avec sucess...")
            end
        end
        end) 
