if myHero.charName ~= "XinZhao" then return end

require "VPrediction"
require "SOW"

local version = "0.1"
local ts = nil

--ScriptStatus--
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("UHKIJKOILIO") 
--ScriptStatus

local AARANGE = 200
local QRANGE = 250
local WRANGE = 250
local ERANGE = 600
local RRANGE = 187.5

function OnLoad()
	PrintChat("<font color = \"#FFFFFF\">XinZhao by TANS v"..version.." loaded.</font>")

	Config = scriptConfig("XinZhao", "XinZhaoTANS")

	Config:addSubMenu("Keys", "Key")
		Config.Key:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Config.Key:addParam("Clear", "Lane/Jungleclear", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))

	Config:addSubMenu("Combo", "Combo")
		Config.Combo:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.Combo:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
		Config.Combo:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
		Config.Combo:addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)

	Config:addSubMenu("Killsteal", "Killsteal")
		Config.Killsteal:addParam("E", "Killsteal with E", SCRIPT_PARAM_ONOFF, true)
		Config.Killsteal:addParam("R", "Killsteal with R", SCRIPT_PARAM_ONOFF, true)

 	Config:addSubMenu("Jungleclear", "Clear")
		Config.Clear:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.Clear:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
		Config.Clear:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)

	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000)
	ts.name = "Focus"
	Config:addTS(ts)

	Config:addSubMenu("Orbwalker", "SOW")
	VP = VPrediction(true)
	SOW = SOW(VP)
	SOW:LoadToMenu(Config.SOW)


	Minions = minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_MAXHEALTH_ASC)
	JMinions = minionManager(MINION_JUNGLE, 1000, myHero, MINION_SORT_MAXHEALTH_DEC)

end

function OnTick()
	ts:update()
	Target = ts.target
	KS()

	if Config.Key.Combo then
		if ValidTarget(Target) and GetDistance(Target) <= AARANGE then
			SOW.Move = false
			myHero:Attack(Target)
		else
			SOW.Move = true
		end
	end

	if Config.Key.Combo then
		Combo()
	end

	if Config.Key.Clear then
		Clear()
	end
end

function OnDraw()
	if ValidTarget(Target) then
		DrawCircle(Target.x, Target.y, Target.z, 125, ARGB(255, 145, 117, 0))
	end
end

function Combo()
	if ValidTarget(Target) then
		if Config.Combo.Q then
			if GetDistance(Target) <= QRANGE then
				CastSpell(_Q)
			end
		end
	end
		
	if ValidTarget(Target) then
		if Config.Combo.W then
			if GetDistance(Target) <= WRANGE then
				CastSpell(_W)
			end
		end
	end

	if ValidTarget(Target) then
		if Config.Combo.E then
			if GetDistance(Target) <= ERANGE then
				CastSpell(_E, Target)
			end
		end
	end
end

function Clear()
	JMinions:update()
	for i, jminion in pairs(JMinions.objects) do
		if ValidTarget(jminion) then
			if GetDistance(jminion) <= 500 then
				myHero:Attack(jminion)
			end

			if GetDistance(jminion) <= QRANGE then
				if Config.Clear.Q then
					CastSpell(_Q)
				end
			end

			if GetDistance(jminion) <= WRANGE then
				if Config.Clear.W then
					CastSpell(_W)
				end
			end

			if	GetDistance(jminion) <= ERANGE then
				if Config.Clear.E then
					CastSpell(_E, jminion)
				end
			end		
		end
	end
end

function KS()
	for i, enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) and not enemy.dead then
			EDMG = getDmg("E", enemy, myHero)
			RDMG = getDmg("R", enemy, myHero)

			if enemy.health <= EDMG then
				if GetDistance(enemy) <= ERANGE then
					if Config.Killsteal.E then
						CastSpell(_E, enemy)
					end
				end
			end

			if enemy.health <= RDMG then
				if GetDistance(enemy) <= RRANGE then
					if Config.Killsteal.R then
						CastSpell(_R)
					end
				end
			end
		end
	end
end
