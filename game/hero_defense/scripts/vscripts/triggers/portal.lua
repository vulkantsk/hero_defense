
function PortalHome( keys )
	local trigger_name = thisEntity:GetName()
	local target = keys.activator
	local team = target:GetTeam()
	local player = target:GetPlayerOwnerID()
	local point_name = "point_portal_home"

	if team == DOTA_TEAM_NEUTRALS then
		return
	end

	local point =  Entities:FindByName( nil, point_name):GetAbsOrigin()
	 
	FindClearSpaceForUnit(target, point, true)
	target:Stop()

	if team == DOTA_TEAM_NEUTRALS then
		return
	end
	
	if target:IsHero() then
		PlayerResource:SetCameraTarget(player, target)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(player, nil) -- Чтобы камера разблочилась, т.к. она начинает следовать за игроком постоянно.
		end)	
	end	
end

function PortalArea( keys )
	local trigger_name = thisEntity:GetName()
	local target = keys.activator
	local team = target:GetTeam()
	local player = target:GetPlayerOwnerID()
	local point_name = "point_home"

	if trigger_name == "portal_1" then
		point_name = "point_portal_1"
	elseif trigger_name == "portal_2" then
		point_name = "point_portal_2"
	end

	if team == DOTA_TEAM_NEUTRALS then
		return
	end

	local point =  Entities:FindByName( nil, point_name):GetAbsOrigin()
	 
	FindClearSpaceForUnit(target, point, true)
	target:Stop()

	if target:IsHero() then
		PlayerResource:SetCameraTarget(player, target)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(player, nil) -- Чтобы камера разблочилась, т.к. она начинает следовать за игроком постоянно.
		end)	
	end
end


function PortalBoss( keys )
	local trigger_name = thisEntity:GetName()
	local target = keys.activator
	local team = target:GetTeam()
	local player = target:GetPlayerOwnerID()
	local point_name = "point_area_boss"

	if team == DOTA_TEAM_NEUTRALS or not target:IsRealHero() then
		return
	end

	local point =  Entities:FindByName( nil, point_name):GetAbsOrigin()
	
	FindClearSpaceForUnit(target, point, true)
	target:Stop()
	
	PlayerResource:SetCameraTarget(player, target)
	Timers:CreateTimer(0.1, function()
		PlayerResource:SetCameraTarget(player, nil) -- Чтобы камера разблочилась, т.к. она начинает следовать за игроком постоянно.
	end)	
end

