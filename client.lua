local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("lc_construtor")
job = Tunnel.getInterface("lc_construtor")

local servico = false
local locais = 0
local processo = false
local tempo = 0
local animacao = false
local parte = 0 
----------------------------------------------------------------------------------
-- LOCS 
----------------------------------------------------------------------------------
local construtor = {
	[1] = { ['x'] = 83.55, ['y'] = -374.17, ['z'] = 41.51 },
	[2] = { ['x'] = 81.99, ['y'] = -417.63, ['z'] = 37.56 },
	[3] = { ['x'] = 86.31, ['y'] = -442.71, ['z'] = 37.56 },
	[4] = { ['x'] = 77.7, ['y'] = -447.79, ['z'] = 37.56 }, 
	[5] = { ['x'] = 90.72, ['y'] = -465.2, ['z'] = 37.86 },
	[6] = { ['x'] = 109.92, ['y'] = -363.3, ['z'] = 42.68 },
	[7] = { ['x'] = 123.13, ['y'] = -342.69, ['z'] = 42.99 },
	[8] = { ['x'] = 63.68, ['y'] = -336.31, ['z'] = 55.51 },
	[9] = { ['x'] = 73.93, ['y'] = -339.24, ['z'] = 43.25 },
	[10] = { ['x'] = 40.09, ['y'] = -391.12, ['z'] = 39.93 },
	[11] = { ['x'] = 18.5, ['y'] = -447.27, ['z'] = 45.56 },
	[12] = { ['x'] = 30.2, ['y'] = -375.35, ['z'] = 45.51 },
	[13] = { ['x'] = 33.95, ['y'] = -454.65, ['z'] = 45.56 },
	-- [14] = { ['x'] = 17.71, ['y'] = -1300.08, ['z'] = 29.38 },
	[15] = { ['x'] = 60.41, ['y'] = -385.05, ['z'] = 45.69 },
	[16] = { ['x'] = 33.73, ['y'] = -388.9, ['z'] = 45.51 },
	[17] = { ['x'] = 5.54, ['y'] = -445.97, ['z'] = 39.78 },
	[18] = { ['x'] = 40.83, ['y'] = -393.63, ['z'] = 55.29 },
	[19] = { ['x'] = 5.8, ['y'] = -445.29, ['z'] = 55.23 }

}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PEGAR TRABALHO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local balaka = 1000
		local x2,y2,z2 = 141.16,-380.02,43.26
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x2,y2,z2,true)
		if distance < 5 then
			balaka = 5
			DrawText3D(x2,y2,z2 + 0.5,"~g~E~w~   SERVIÇO")
			if not servico then
				if distance < 1 then
					if IsControlJustPressed(0, 38) then
						TriggerEvent("Notify","amarelo","Você entrou em serviço.",3000)
						--ColocarRoupa()
						TriggerEvent("Notify","amarelo","Pegue todos os materias na mesa ao lado para começar a trabalhar!.",5000)
						servico = true
						locais = 1
						parte = 1
						CriandoBlip(construtor,locais)
					end
				end
			end
		end
	Citizen.Wait(balaka)
	end
end)
--- Fim
Citizen.CreateThread(function()
	while true do
		timedistance = 1000
		if servico then
			timedistance = 5
			drawTxt("PRESSIONE ~r~F7 ~w~PARA FINALIZAR O EXPEDIENTE",2,0.260,0.905,0.5,255,255,255,200)
			if IsControlJustPressed(0,168) then
				TriggerEvent("Notify","aviso","Você saiu de servico",8000)			
				servico = false
				RemoveBlip(blips)
			end
		end
		Citizen.Wait(timedistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETAR MATERIAL 
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local balaka = 1000
		if servico and parte == 1 then
			local x,y,z = 139.95,-383.98,43.26
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 5 then 
				balaka = 5
                  DrawText3D(x,y,z + 0.1,"~g~E ~w~ EQUIPAMENTOS")
		        if IsControlJustPressed(0, 38) then
		        	animacao = true
		        	if animacao then
		        		SetEntityHeading(ped,152.54)
		        		vRP._playAnim(false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
		        		Desabilitar()
		            	TriggerEvent("progress",10000,"Coletando Equipamento")
					 	Citizen.Wait(10000)
						vRP.stopAnim(false)
						animacao = false
						if emP.giveFerramenta() then
					 		--print('recebido')		
						end
					end	    
                end
		    end                   
		end
	Citizen.Wait(balaka)
	end
end)	
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSERTAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local balaka = 1000
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))  
			local bowz,cdz = GetGroundZFor_3dCoord(construtor[locais].x,construtor[locais].y,construtor[locais].z)
			local distance = GetDistanceBetweenCoords(construtor[locais].x,construtor[locais].y,cdz,x,y,z,true)
			if distance < 200 then
				DrawText3D(construtor[locais].x,construtor[locais].y,construtor[locais].z + 0.5,"~g~E ~w~   CONSERTAR")
				balaka = 1
				if distance < 5 then
					balaka = 5
					if IsControlJustPressed(0, 38) then
						TriggerEvent("progress",10000,"Consertando")
						RemoveBlip(blips)
						animacao = true
						if animacao then
							vRP._playAnim(false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)
							Desabilitar()
							Citizen.Wait(10000)
							vRP.stopAnim(false)
							emP.checkPayment()
							animacao = false
							if locais == #construtor then
								locais = 1
							else
								locais = math.random(1,19)
							end
						  		CriandoBlip(construtor,locais)
							--end
						end	
					end	
				end
			end
		end
	Citizen.Wait(balaka)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function CriandoBlip(construtor,locais)
	blips = AddBlipForCoord(construtor[locais].x,construtor[locais].y,construtor[locais].z)
	SetBlipSprite(blips,402)
	SetBlipColour(blips,0)
	SetBlipScale(blips,0.5)
	SetBlipAsShortRange(blips,false)
	BeginTextCommandSetBlipName("STRING")
	EndTextCommandSetBlipName(blips)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end

function Fade(time)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESABILITAR F6 NAS ANIMAÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function Desabilitar()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			if animacao then
				BlockWeaponWheelThisFrame()
				DisableControlAction(0,16,true)
				DisableControlAction(0,17,true)
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,38,true)
				DisableControlAction(0,29,true)
				DisableControlAction(0,56,true)
				DisableControlAction(0,57,true)
				DisableControlAction(0,73,true)
				DisableControlAction(0,166,true)
				DisableControlAction(0,167,true)
				DisableControlAction(0,170,true)				
				DisableControlAction(0,182,true)	
				DisableControlAction(0,187,true)
				DisableControlAction(0,188,true)
				DisableControlAction(0,189,true)
				DisableControlAction(0,190,true)
				DisableControlAction(0,243,true)
				DisableControlAction(0,245,true)
				DisableControlAction(0,257,true)
				DisableControlAction(0,288,true)
				DisableControlAction(0,289,true)
				DisableControlAction(0,344,true)		
			end	
		end
	end)
end


