if GetObjectName(GetMyHero()) ~= "Kalista" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua!") return end

PrintChat("ADC MAIN | Kalista loaded.")
PrintChat("by Noddy")

local mainMenu = Menu("ADC MAIN | Kalista", "Kalista")
mainMenu:Menu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useE", "Use E if killable", true)
mainMenu.Combo:Boolean("useEx", "Use E with reset", true)
mainMenu.Combo:Slider("useExS","E reset on X spears", 5, 1, 20, 1)
mainMenu.Combo:Boolean("useEao", "Use E out of range", true)
mainMenu.Combo:Slider("useExaoS","E out of range on X spears", 10, 1, 40, 1)
mainMenu.Combo:Key("useR", "Semi Auto R", string.byte("T"))
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
---------------------------------------------------------------------------------
mainMenu:Menu("Harass", "Harass")
mainMenu.Harass:Boolean("hQ", "Use Q", true)
mainMenu.Harass:Boolean("hE", "Use E with reset", true)
mainMenu.Harass:Slider("hExS","E reset on X spears", 3, 1, 20, 1)
mainMenu.Harass:Key("Harass1", "Harass", string.byte("C"))
---------------------------------------------------------------------------------
mainMenu:Menu("Killsteal", "Killsteal")
mainMenu.Killsteal:Boolean("ksQ", "Use Q - KS", true)
mainMenu.Killsteal:Boolean("ksE", "Use E - KS", true)
---------------------------------------------------------------------------------
mainMenu:Menu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
---------------------------------------------------------------------------------
mainMenu:Menu("Farm", "Farm")
mainMenu.Farm:Boolean("farmE", "Use E", true)
mainMenu.Farm:Slider("farmEx","Use on X minions", 2 , 1, 10, 1)
mainMenu.Farm:Key("Farm1", "Farm", string.byte("V"))
---------------------------------------------------------------------------------
mainMenu:Menu("Misc", "Misc")
mainMenu.Misc:Boolean("Jungle", "Jungle Steal", true)
mainMenu.Misc:Boolean("saveAlly", "Use R to save your ally", true)
mainMenu.Misc:Slider("AllyHP","Save Ally % HP", 15, 1, 100, 1)
---------------------------------------------------------------------------------
mainMenu:Menu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("drawE", "Draw E-Damage", true)

OnProcessSpell(function(unit, spell)
if unit and unit == myHero and spell then
	   if spell.name:lower():find("kalistadummyspell") then
		minionXe = 0
		minionX = 0
		minionXeh = 0
	end
end
end)

OnDraw(function(myHero)
-- Draw E Damage
if mainMenu.Drawings.drawE:Value() then
for i,enemy in pairs(GetEnemyHeroes()) do
	if GotBuff(enemy,"kalistaexpungemarker") >= 1 and ValidTarget(enemy,2500) then
		local eDMG = CalcDamage(myHero, enemy, (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))) + (((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(enemy,"kalistaexpungemarker")-1)),0)
		DrawDmgOverHpBar(enemy,GetCurrentHP(enemy),eDMG,0,0xff00ff00)
	end
end
end
end)

OnTick(function (myHero)

local target = GetCurrentTarget()
local myHeroPos = GetOrigin(myHero)

-- Items
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)

-- Use Items
if mainMenu.Combo.Combo1:Value() then
	if CutBlade >= 1 and ValidTarget(target,550) and mainMenu.Items.useCut:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3144)) == READY then
			CastTargetSpell(target, GetItemSlot(myHero,3144))
		end	
	elseif bork >= 1 and ValidTarget(target,550) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 and mainMenu.Items.useBork:Value() then 
		if CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY then
			CastTargetSpell(target,GetItemSlot(myHero,3153))
		end
	end

	if ghost >= 1 and ValidTarget(target,550) and mainMenu.Items.useGhost:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
			CastSpell(GetItemSlot(myHero,3142))
		end
	end
	
	if redpot >= 1 and ValidTarget(target,550) and mainMenu.Items.useRedPot:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,2140)) == READY then
			CastSpell(GetItemSlot(myHero,2140))
		end
	end
end

-- [Combo
if mainMenu.Combo.Combo1:Value() then
-- Q
if mainMenu.Combo.useQ:Value() then
useQ()
end
-- E if killable
if mainMenu.Combo.useE:Value() then
ksE()
end
-- Ex
if mainMenu.Combo.useEx:Value() then
useEx()
end
-- E out of range
if mainMenu.Combo.useEao:Value() then
useEao()
end

end -- Combo]

-- Semi Auto R
if mainMenu.Combo.useR:Value() then
for _, ally in pairs(GetAllyHeroes()) do
	if CanUseSpell(myHero,_R) == READY and GotBuff(ally,"kalistacoopstrikeally") == 1 and ValidTarget(target, 1200) then
		local extraDelay = (GetDistance(ally) / 1500) * 1000
		local RPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1500,100+extraDelay,1250,150,false,true)
		if RPred.HitChance == 1 then
			CastSpell(_R)	
		end	
	end
end
end

-- [Harass
if mainMenu.Harass.Harass1:Value() then
-- Q
if mainMenu.Harass.hQ:Value() then
useQ()
end
if mainMenu.Harass.hE:Value() then
hEx()
end
end -- Harass]

-- Q KillSteal
if mainMenu.Killsteal.ksQ:Value() then
ksQ()
end
-- E KillSteal
if mainMenu.Killsteal.ksE:Value() then
ksE()
end
-- E Farm
if mainMenu.Farm.Farm1:Value() and mainMenu.Farm.farmE.Value() then
farmE()
end
-- Save Ally
if mainMenu.Misc.saveAlly:Value() then
	for _, ally in pairs(GetAllyHeroes()) do
		for i,enemy in pairs(GetEnemyHeroes()) do
			if CanUseSpell(myHero,_R) == READY and GotBuff(ally,"kalistacoopstrikeally") == 1 and 100*GetCurrentHP(ally)/GetMaxHP(ally) <= mainMenu.Misc.AllyHP:Value() and GetDistance(ally, enemy) <= 700 then
				CastSpell(_R)
			end
		end
	end
end
-- JungleSteal
if mainMenu.Misc.Jungle:Value() then
for _,mob in pairs(MinionsAround(myHeroPos(),GetCastRange(myHero,_E),MINION_JUNGLE)) do
	if CanUseSpell(myHero,_E) == READY and GotBuff(mob,"kalistaexpungemarker") >= 1 and ValidTarget(mob,GetCastRange(myHero,_E)) and GetCurrentHP(mob) < CalcDamage(myHero, mob, (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))) + (((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(mob,"kalistaexpungemarker")-1)),0) then
		CastSpell(_E)
	end
end
end

end)

-- Use Q
function useQ()
for i,enemy in pairs(GetEnemyHeroes()) do
if CanUseSpell(myHero,_Q) == READY and IsTargetable(enemy) and ValidTarget(enemy,GetCastRange(myHero,_Q)) and GetCurrentMana(myHero) > GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + 40 then
	
	if IsInDistance(enemy,GetRange(myHero)+100) then
		OnProcessSpell(function(unit, spell)
			if unit and unit == myHero and spell then
				if spell.name:lower():find("attack") then
						DelayAction(function()
						local QPred = GetPredictionForPlayer(myHeroPos(),enemy,GetMoveSpeed(enemy),2000,350,1150,70,true,false)
							if QPred.HitChance == 1 and CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() and mainMenu.Combo.Combo1:Value() and IsTargetable(enemy) and ValidTarget(enemy,GetCastRange(myHero,_Q)) then
								CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
							end
							if QPred.HitChance == 1 and CanUseSpell(myHero,_Q) == READY and mainMenu.Harass.hQ:Value() and mainMenu.Harass.Harass1:Value() and IsTargetable(enemy) and ValidTarget(enemy,GetCastRange(myHero,_Q)) then
								CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
							end								
					end , spell.windUpTime*1000 + GetLatency())
				end
			end
		end)
		
	elseif not IsInDistance(enemy,GetRange(myHero)) then
	local QPred = GetPredictionForPlayer(myHeroPos(),enemy,GetMoveSpeed(enemy),2000,350,1150,70,true,false)
		if QPred.HitChance == 1 and CanUseSpell(myHero,_Q) == READY then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end	
	end	
	
end
end
end

-- KillSteal E
function ksE()
for i,enemy in pairs(GetEnemyHeroes()) do
	if CanUseSpell(myHero,_E) == READY and GotBuff(enemy,"kalistaexpungemarker") >= 1 and IsTargetable(enemy) and ValidTarget(enemy,GetCastRange(myHero,_E)) and GetCurrentHP(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))) + (((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(enemy,"kalistaexpungemarker")-1)),0) then
		CastSpell(_E)
	end
end
end

-- KillSteal Q
function ksQ()
for i,enemy in pairs(GetEnemyHeroes()) do
	if CanUseSpell(myHero,_Q) == READY and IsTargetable(enemy) and ValidTarget(enemy,GetCastRange(myHero,_Q)) and GetCurrentHP(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 60*GetCastLevel(myHero,_Q)-50+(GetBaseDamage(myHero)+GetBonusDmg(myHero)),0) then
		local QPred = GetPredictionForPlayer(myHeroPos(),enemy,GetMoveSpeed(enemy),2000,350,1150,70,true,false)
			if QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
			end	
	end
end
end

-- E Farm
function farmE()
	local minionX = 0
	
    for _,minion in pairs(MinionsAround(myHeroPos(),GetCastRange(myHero,_E),MINION_ENEMY)) do
		if CanUseSpell(myHero,_E) == READY and GotBuff(minion,"kalistaexpungemarker") >= 1 and ValidTarget(minion,GetCastRange(myHero,_E)) and GetCurrentHP(minion) + GetDmgShield(minion) < CalcDamage(myHero, minion, (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))) + (((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(minion,"kalistaexpungemarker")-1)),0) then
			minionX = minionX + 1
			
		end
				if CanUseSpell(myHero,_E) == READY and minionX >= mainMenu.Farm.farmEx:Value() then
					CastSpell(_E)
					minionX = 0
				end		
	end
end

-- E if Minion killable + Target
function useEx()
local minionXe = 0
    for _,minion in pairs(MinionsAround(myHeroPos(),GetCastRange(myHero,_E),MINION_ENEMY)) do
		if CanUseSpell(myHero,_E) == READY and GotBuff(minion,"kalistaexpungemarker") >= 1 and ValidTarget(minion,GetCastRange(myHero,_E)) and GetCurrentHP(minion) + GetDmgShield(minion) < CalcDamage(myHero, minion, (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))) + (((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(minion,"kalistaexpungemarker")-1)),0) then
			minionXe = minionXe + 1
		end
			for i,enemy in pairs(GetEnemyHeroes()) do
				if CanUseSpell(myHero,_E) == READY and minionXe >= 1 and IsTargetable(enemy) and ValidTarget(enemy,GetRange(myHero)) and GotBuff(enemy,"kalistaexpungemarker") >= mainMenu.Combo.useExS:Value() then
					CastSpell(_E)
					minionXe = 0
				end
				if CanUseSpell(myHero,_E) == READY and minionXe >= 1 and IsTargetable(enemy) and not IsInDistance(enemy,GetRange(myHero)) and ValidTarget(enemy,GetCastRange(myHero,_E)) and GotBuff(enemy,"kalistaexpungemarker") >= 1 then
					CastSpell(_E)
					minionXe = 0
				end			
			end		
	end
end

-- E Harass
function hEx()
local minionXeh = 0
    for _,minion in pairs(MinionsAround(myHeroPos(),GetCastRange(myHero,_E),MINION_ENEMY)) do
		if CanUseSpell(myHero,_E) == READY and GotBuff(minion,"kalistaexpungemarker") >= 1 and ValidTarget(minion,GetCastRange(myHero,_E)) and GetCurrentHP(minion) + GetDmgShield(minion) < CalcDamage(myHero, minion, (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))) + (((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(minion,"kalistaexpungemarker")-1)),0) then
			minionXeh = minionXeh + 1
		end
			for i,enemy in pairs(GetEnemyHeroes()) do
				if CanUseSpell(myHero,_E) == READY and minionXeh >= 1 and IsTargetable(enemy) and ValidTarget(enemy,GetRange(myHero)) and GotBuff(enemy,"kalistaexpungemarker") >= mainMenu.Harass.hExS:Value() then
					CastSpell(_E)
					minionXeh = 0
				end			
			end		
	end
end

-- E if out of range
function useEao()
local target = GetCurrentTarget()
if ValidTarget(target,GetCastRange(myHero,_E)) then
if CanUseSpell(myHero,_E) == READY and GetMoveSpeed(myHero) < GetMoveSpeed(target) and not IsInDistance(target,GetRange(myHero)+200) and IsTargetable(target) and ValidTarget(target,GetCastRange(myHero,_E)) and GotBuff(target,"kalistaexpungemarker") >= mainMenu.Combo.useExaoS:Value() then
	CastSpell(_E)
elseif CanUseSpell(myHero,_E) == READY and GetMoveSpeed(myHero) >= GetMoveSpeed(target) and not IsInDistance(target,GetCastRange(myHero,_E)-100) and IsTargetable(target) and ValidTarget(target,GetCastRange(myHero,_E)) and GotBuff(target,"kalistaexpungemarker") >= mainMenu.Combo.useExaoS:Value() then		
	CastSpell(_E)
end
end
end
