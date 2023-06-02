--FEITO POR Balaka#9918
--FEITO POR Balaka#9918
--FEITO POR Balaka#9918

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
emP = {}
job = {}
Tunnel.bindInterface("lc_construtor",emP)
Tunnel.bindInterface("lc_construtor",job)

----------------------------------------------------------------------------------
------- PEGAR FERRAMENTAS 
----------------------------------------------------------------------------------
function emP.giveFerramenta()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.computeInvWeight(user_id) + 5 > vRP.getBackpack(user_id) then
			TriggerClientEvent("Notify",source,"vermelho","Espaço insuficiente.",5000)
			Wait(1)
		else
			vRP.giveInventoryItem(user_id,"kitferr",1)
			return true
		end
	end
end
----------------------------------------------------------------------------------
------- PAGAMENTO E CHECK 
----------------------------------------------------------------------------------
local quantidade = {}
function emP.Quantidade()
	local source = source
	if quantidade[source] == nil then
	   quantidade[source] = math.random(1,2)	
	end
	   TriggerClientEvent("quantidade-ferramenta",source,parseInt(quantidade[source]))
end

local ferramenta = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(ferramenta) do
            if v > 0 then
                ferramenta[k] = v - 1
            end
        end
    end
end)

function emP.checkPayment()
	emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if ferramenta[user_id] == 0 or not ferramenta[user_id] then
			if vRP.tryGetInventoryItem(user_id,"kitferr",quantidade[source]) then
				randmoney = (math.random(85,145)*quantidade[source])
		        vRP.giveMoney(user_id,parseInt(randmoney))
		        TriggerClientEvent("sounds:source",source,'coins',0.5)
		        TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b>.")
				quantidade[source] = nil
				emP.Quantidade()
				ferramenta[user_id] = 15
				return true
			else
				TriggerClientEvent("Notify",source,"negado","Suas ferramentas quebraram,volte até a bancada!",5000)
				Wait(800)
				TriggerClientEvent("Notify",source,"negado","Você vai precisar de <b>"..quantidade[source].."x Ferramentas</b>.",5000)
			end
		end
	end
	return false
end