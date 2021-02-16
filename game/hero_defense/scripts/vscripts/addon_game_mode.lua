require ("timers")
require ("game_settings")
require ("gamemode")
require ("item_drop")

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_troll_warlord.vsndevts", context )

end

-- Create the game mode when we activate
function Activate()

--[[	
	local GM = GameRules:GetGameModeEntity()
	GM:SetCustomGameForceHero("npc_dota_hero_axe")
	GameRules:SetHeroSelectionTime(0)
	GameRules:SetStrategyTime(0)
	GameRules:SetShowcaseTime(0)
	GameRules:SetCustomGameSetupAutoLaunchDelay(0)
]]
end
