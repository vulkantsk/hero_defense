if GameMode == nil then
	_G.GameMode = class({})
end

GameMode.current_units = {}
GameMode.line_interval = {}
GameMode.wave_number = 0

GameMode.wave_list = {
	[1]={reward_gold=250,reward_exp=500,
			units={["npc_line_creep_1"]=6,["npc_line_creep_2"]=2}},
	[2]={reward_gold=500,reward_exp=1000,
			units={["npc_line_creep_3"]=6,["npc_line_creep_4"]=2}},
	[3]={reward_gold=1000,reward_exp=2000,
			units={"npc_line_boss_1",["npc_line_creep_4"]=2}},
}

function GameMode:InitGameMode()
	print("vse ok - ?")
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self, 'OnGameRulesStateChange'), self)
--	ListenToGameEvent("npc_spawned",Dynamic_Wrap( self, 'OnNPCSpawned' ), self )
	ListenToGameEvent('entity_killed', Dynamic_Wrap(self, 'OnEntityKilled'), self)
end

function GameMode:OnGameRulesStateChange()
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameMode:LineBossSpawner()
	end
end


function GameMode:LineBossSpawner()
	 self.wave_number = self.wave_number + 1	
	local current_boss = self.wave_list[self.wave_number]

	if current_boss == nil then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		return
	end

	GameMode:SpawnLineUnits(self.wave_number) 
end

function GameMode:SpawnLineUnits(index)
	local current_wave = self.wave_list[index]
	if current_wave == nil then
		return
	end

	local point = Entities:FindByName( nil, "line_spawner"):GetAbsOrigin() 
	local waypoint = Entities:FindByName( nil, "line_path_1") 

	local units = current_wave.units

--	GameRules:SendCustomMessage("#Game_notification_boss_spawn_"..boss_name,0,0)

	for key, value in pairs (units) do
		local unit_name
		if type(key) == "string" then
			unit_count = value
			unit_name = key
		else
			unit_count =1
			unit_name = value
		end

		for i=1, unit_count do
			local unit = CreateUnitByName( unit_name , point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS ) 
			unit:SetInitialGoalEntity( waypoint )
			unit.reward = true
			local ent_index = unit:entindex()
--			table.insert(self.current_units, ent_index, unit)
			self.current_units[ent_index]= unit
		end
	end 
end

function GameMode:OnEntityKilled(keys)

	local unit = EntIndexToHScript(keys.entindex_killed)
	local unit_name = unit:GetUnitName()
	
	if unit_name == "npc_goodguys_fort" then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)		
	end

	if unit.reward then
		local ent_index = unit:entindex()
		
		self.current_units[ent_index] = nil
		local units = 0
		for key,value in pairs(self.current_units) do
			units = units + 1
		end

		if units == 0 then
			local current_wave = self.wave_list[self.wave_number]
			local reward_gold = current_wave.reward_gold
			local reward_exp = current_wave.reward_exp

			GiveGoldPlayers( reward_gold )
			GiveExperiencePlayers( reward_exp )
			GameMode:LineBossSpawner()
		end
	end
end

function GiveGoldPlayers( gold )
	for index=0 ,4 do
		if PlayerResource:HasSelectedHero(index) then
			local player = PlayerResource:GetPlayer(index)
			local hero = PlayerResource:GetSelectedHeroEntity(index)
			hero:ModifyGold(gold, false, 0)
			SendOverheadEventMessage( player, OVERHEAD_ALERT_GOLD, hero, gold, nil )
		end
	end
end

function GiveExperiencePlayers( experience )
	for index=0 ,4 do
		if PlayerResource:HasSelectedHero(index) then
			local player = PlayerResource:GetPlayer(index)
			local hero = PlayerResource:GetSelectedHeroEntity(index)
			hero:AddExperience(experience, 0, false, true )
		end
	end
end

GameMode:InitGameMode()