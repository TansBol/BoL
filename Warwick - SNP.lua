if myHero.charName ~= "Warwick" then return end

require "VPrediction"
require "SOW"

local version = "0.1"
local ts = nil

local AARANGE = 400
local QRANGE = 400
local WRANGE = 250
local RRANGE = 700

function OnLoad()
	PrintChat("<font color = \"#FFFFFF\">Warwick by TANS v"..version.." loaded.</font>")

	Config = scriptConfig("Warwick", "WarwickTANS")

	Config:addSubMenu("Keys", "Key")
		Config.Key:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Config.Key:addParam("Clear", "Lane/Jungleclear", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))

	Config:addSubMenu("Combo", "Combo")
		Config.Combo:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.Combo:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
		Config.Combo:addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)

 	Config:addSubMenu("Lane/Jungleclear", "Clear")
		Config.Clear:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.Clear:addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)

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
	RTarget = GetTarget()

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
	if ValidTarget(RTarget) then
		DrawCircle(RTarget.x, RTarget.y, RTarget.z, 125, ARGB(255, 145, 117, 0))
	end
end

function Combo()
	if ValidTarget(Target) then
		if Config.Combo.Q then
			if GetDistance(Target) <= QRANGE then
				CastSpell(_Q, Target)
			end
		end

		if Config.Combo.W then
			if GetDistance(Target) <= WRANGE then
				CastSpell(_W)
			end
		end
	end

	if ValidTarget(RTarget) then
		if Config.Combo.R then
			if GetDistance(RTarget) <= RRANGE then
				CastSpell(_R, RTarget)
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
				CastSpell(_Q, jminion)
			end

			if GetDistance(jminion) <= WRANGE then
				CastSpell(_W)
			end
		end
	end
end
