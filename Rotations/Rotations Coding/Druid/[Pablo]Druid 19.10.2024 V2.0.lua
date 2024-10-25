local TMW                               = _G.TMW
local Action                            = _G.Action
local GetSpellTexture                   = _G.TMW.GetSpellTexture
local A                                 = Action
local Unit                              = Action.Unit
local Create                            = Action.Create
local Player                            = Action.Player
local BurstIsON                         = Action.BurstIsON
local GetToggle                         = Action.GetToggle
local MultiUnits                        = Action.MultiUnits
local AuraIsValid                       = Action.AuraIsValid
local HasBuffs                          = Action.HasBuffs
local GetSpellCharges                   = Action.GetSpellCharges
local IsUnitEnemy                       = Action.IsUnitEnemy
local threatStatus                      = Action.threatStatus
local InCombat                          = Action.InCombat
local InRange                           = Action.InRange
local InMeleeRange                      = Action.InMeleeRange
local UnitThreatSituation               = Action.UnitThreatSituation
local LoC                               = Action.LossOfControl
local GetCurrentGCD                     = Action.GetCurrentGCD
local IsUnitFriendly                    = Action.IsUnitFriendly
local UnitCanAttack                     = Action.UnitCanAttack
local InterruptIsValid                  = Action.InterruptIsValid
local ACTION_CONST_STOPCAST             = Action.Const.STOPCAST
local ACTION_CONST_AUTOTARGET           = Action.Const.AUTOTARGET
local ACTION_CONST_DRUID_GUARDIAN       = Action.Const.DRUID_GUARDIAN
local Utils                             = Action.Utils
local ActiveUnitPlates                  = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit, UnitExists, IsMounted, UnitThreatSituation, UnitCanAttack, IsInRaid, UnitDetailedThreatSituation, IsResting, GetItemCount, debugprofilestop = 
_G.IsIndoors, _G.UnitIsUnit, _G.IsMounted, _G.UnitThreatSituation, _G.UnitCanAttack, _G.IsInRaid, _G.UnitDetailedThreatSituation, _G.IsResting, _G.GetItemCount, _G.debugprofilestop


--###########################################
--############# SPELLS ######################
--###########################################



Action[ACTION_CONST_DRUID_GUARDIAN] = {
    -- Offensive abilities
    Mangle                              = Create({ Type = "Spell", ID = 33917  }),
    Thrash                              = Create({ Type = "Spell", ID = 77758  }),
    Maul                                = Create({ Type = "Spell", ID = 6807   }),
    Swipe                               = Create({ Type = "Spell", ID = 213771 }),
    Moonfire                            = Create({ Type = "Spell", ID = 8921   }),
    
    -- Defensive abilities
    Ironfur                             = Create({ Type = "Spell", ID = 192081 }),
    Barkskin                            = Create({ Type = "Spell", ID = 22812  }),
    SurvivalInstincts                   = Create({ Type = "Spell", ID = 61336  }),
    FrenziedRegeneration                = Create({ Type = "Spell", ID = 22842  }),
    Regrowth                            = Create({ Type = "Spell", ID = 8936   }),
    
    -- Cooldowns
    Berserk                             = Create({ Type = "Spell", ID = 50334  }),
    ConvokeTheSpirits                   = Create({ Type = "Spell", ID = 393414 }),
    RageOfTheSleeper                    = Create({ Type = "Spell", ID = 200851 }),
    Incarnation                         = Create({ Type = "Spell", ID = 102558 }),
    
    -- Utility
    SkullBash                           = Create({ Type = "Spell", ID = 106839 }),
    Growl                               = Create({ Type = "Spell", ID = 6795   }),
    IncapacitatingRoar                  = Create({ Type = "Spell", ID = 99     }),
    
    -- Talents
    GalacticGuardian                    = Create({ Type = "Spell", ID = 203964 }),
    ToothandClaw                        = Create({ Type = "Spell", ID = 135288 }),
    Pulverize                           = Create({ Type = "Spell", ID = 80313  }),
    BristlingFur                        = Create({ Type = "Spell", ID = 155835 }),
    Raze                                = Create({ Type = "Spell", ID = 400254 }),
    ViciousClawscape                    = Create({ Type = "Spell", ID = 391398 }),
    DreamOfCenarius                     = Create({ Type = "Spell", ID = 372152 }),
    LunarBeam                           = Create({ Type = "Spell", ID = 204066 }),
    HeartOfTheWild                      = Create({ Type = "Spell", ID = 319454 }),
    MarkOfTheWild                       = Create({ Type = "Spell", ID = 1126   }),
    Ravage                              = Create({ Type = "Spell", ID = 6785   }),
    Starsurge                           = Create({ Type = "Spell", ID = 78674  }),
    Rip                                 = Create({ Type = "Spell", ID = 1079   }),
    Rake                                = Create({ Type = "Spell", ID = 1822   }),
    FerociousBite                       = Create({ Type = "Spell", ID = 22568  }),
    Shred                               = Create({ Type = "Spell", ID = 5221   }),
    ThornsOfIron                        = Create({ Type = "Spell", ID = 400222 }),
    ReinforcedFur                       = Create({ Type = "Spell", ID = 393618 }),
    PrimalFury                          = Create({ Type = "Spell", ID = 159286 }),
    FluidForm                           = Create({ Type = "Spell", ID = 392762 }),
    WildpowerSurge                      = Create({ Type = "Spell", ID = 393991 }),
    FuryOfNature                        = Create({ Type = "Spell", ID = 370886 }),
    FlashingClaws                       = Create({ Type = "Spell", ID = 393426 }),
    FelinePotential                     = Create({ Type = "Spell", ID = 391872 }),
    FelinePotentialCounter              = Create({ Type = "Spell", ID = 391873 }),
    Gore                                = Create({ Type = "Spell", ID = 210706 }),
    ViciousCycleMaul                    = Create({ Type = "Spell", ID = 372015 }),
    LunarCalling                        = Create({ Type = "Spell", ID = 404321 }),
    FountOfStrength                     = Create({ Type = "Spell", ID = 383058 }),
    SoulOfTheForest                     = Create({ Type = "Spell", ID = 158477 }),
    BoundlessMoonlight                  = Create({ Type = "Spell", ID = 408364 }),
    LunarInsight                        = Create({ Type = "Spell", ID = 408118 }),
    
    -- Forms
    BearForm                            = Create({ Type = "Spell", ID = 5487   }),
    CatForm                             = Create({ Type = "Spell", ID = 768    }),
}

local A = setmetatable(Action[ACTION_CONST_DRUID_GUARDIAN], { __index = Action })

local mouseover = "mouseover"
local focus = "focus"
local target = "target"
local player = "player"

local Temp = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndCC                              = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMagAndCCAndStun                 = {"TotalImun", "DamageMagicImun", "CCTotalImun", "StunImun"},
    TotalAndMag                             = {"TotalImun", "DamageMagicImun"},
    TotalAndMagKick                         = {"TotalImun", "DamageMagicImun", "KickImun"},
    DisablePhys                             = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag                              = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
    IsSlotTrinketBlocked                    = {},
}

--############################
--#### Funktionen ############
--############################

local function RotationsVariables()
    isMoving = Player:IsMoving()
    isStaying = Player:IsStaying()
    combatTime = Unit(player):CombatTime()
    movingTime = Player:IsMovingTime()
    stayingTime = Player:IsStayingTime()
    PlayerHealth = Unit(player):HealthPercent()
end

local player, target = "player", "target"
local MultiUnits = Action.MultiUnits
local Unit = Action.Unit
local Player = Action.Player

-- Feindezählung über Nameplates

local function InMeleeRange(unitID)
    return A.Mangle:IsInRange(unitID)
end

local function GetByRange(count, range)
    local c = 0
    for unitID in pairs(ActiveUnitPlates) do
        if not UnitIsUnit(target, unitID) and not Action.Unit(unitID):IsExplosives() and not Action.Unit(unitID):IsTotem() then
            if InMeleeRange(unitID) then
                c = c + 1
            elseif range then
                local r = Action.Unit(unitID):GetRange()
                if r > 0 and r <= range then
                    c = c + 1
                end
            end
            
            if c >= count then
                return true
            end
        end
    end
    return false
end
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)

-- Non GCD spell check

local function countInterruptGCD(unitID)
    -- returns @boolean
    if not A.SkullBash:IsReadyByPassCastGCD(unitID) or not A.SkullBash:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
        return true
    end
    return false
end

--Interrups Basic

local function Interrupts(unit)
    local useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    
    if castRemainsTime >= A.GetLatency() then
        -- Incapacitating Roar (Incapacitate)
        if useCC and A.IncapacitatingRoar:IsReady(player) and Unit(unit):GetRange() <= 10 and A.IncapacitatingRoar:AbsentImun(unit, Temp.TotalAndPhysAndCC, true) and not Unit(unit):IsBoss() then
            return A.IncapacitatingRoar
        end
        
        -- Skull Bash (Interrupt)
        if useKick and A.SkullBash:IsReady(unit) and not notInterruptable and A.SkullBash:AbsentImun(unit, Temp.TotalAndPhysKick, true) then
            return A.SkullBash
        end
    end
end

--AoE Definition

local function ShouldAoE()
    return GetByRange(3, 8)
end

local function GetNearbyEnemiesCount()
    return GetByRange(20, 8) -- Check for enemies within 8 yards
end

--Buff Counter

local function GetBuffStacks(unit, spellID)
    local count = select(3, Unit(unit):HasBuffs(spellID))
    return count or 0
end

--Talent Checks

local function IsIfBuild()
    return A.ThornsOfIron:IsSpellLearned() and A.ReinforcedFur:IsSpellLearned()
end

local function IsRipweaving()
    return A.PrimalFury:IsSpellLearned() and A.FluidForm:IsSpellLearned() and A.WildpowerSurge:IsSpellLearned()
end


local function CheckMarkOfTheWild()
    if not A.MarkOfTheWild:IsReady(player) then return false end

    local partyMembers = {"player", "party1", "party2", "party3", "party4"}
    for _, unitID in ipairs(partyMembers) do
        if UnitExists(unitID) and Unit(unitID):HasBuffs(A.MarkOfTheWild.ID, true) == 0 then
            if A.MarkOfTheWild:IsInRange(unitID) then
                return A.MarkOfTheWild, unitID
            end
        end
    end
    return false
end

local function SafeBuffCheck(unit, spellID, checkType)
    local result = checkType == "debuff" and Unit(unit):HasDeBuffs(spellID, true) or GetBuffStacks(unit, spellID)
    return type(result) == "number" and result or 0
end

local thrashDebuff = SafeBuffCheck(target, A.Thrash.ID, "debuff")
local thrashStacks = SafeBuffCheck(target, A.Thrash.ID, "buff")

-- Funktion für die Nutzung des Dream of Cenarius Procs
local function UseDreamOfCenarius()
    -- Prüft, ob der Buff aktiv ist und Regrowth bereit ist
    if Unit(player):HasBuffs(A.DreamOfCenarius.ID, true) > 0 and A.Regrowth:IsReady(player) then
        -- Sucht nach einem Gruppenmitglied mit weniger als 80% Gesundheit
        for _, unitID in ipairs({"player", "party1", "party2", "party3", "party4"}) do
            if Unit(unitID):HealthPercent() < 80 then
                return A.Regrowth
            end
        end
    end
    return false
end

A[3] = function(icon)
    -- Rotationsvariablen
    RotationsVariables()
    local inCombat = Unit(player):CombatTime() > 0
    local isAoE = ShouldAoE()
    local dreamProc = UseDreamOfCenarius()
    local MarkOfTheWild = CheckMarkOfTheWild()
    local Interrupt = Interrupts(target)
    local isIfBuild = IsIfBuild()
    local isRipweaving = IsRipweaving()
    local thrashDebuff = SafeBuffCheck(target, A.Thrash.ID, "debuff")
    local thrashStacks = SafeBuffCheck(target, A.Thrash.ID, "buff")
    local moonfireDebuff = Unit(target):HasDeBuffs(A.Moonfire.ID, true)
    local enemyCount = GetNearbyEnemiesCount()

    --Bärchen
    if A.BearForm:IsReady(player) and Unit(player):HasBuffs(A.BearForm.ID, true) == 0 then
        return A.BearForm:Show(icon)
    end

    -- Vor dem Kampf
    if not inCombat then
        if A.HeartOfTheWild:IsReady(player) and A.HeartOfTheWild:IsSpellLearned() and not A.Rip:IsSpellLearned() then
            return A.HeartOfTheWild:Show(icon)
        end
    end

    -- Hauptrotation
    local function APL()
        -- Maul mit Ravage-Buff
        if A.Maul:IsReady(target) and Unit(player):HasBuffs(A.Ravage.ID, true) > 0 and MultiUnits:GetActiveEnemies() > 1 then
            return A.Maul:Show(icon)
        end

        -- Heart of the Wild
        if A.HeartOfTheWild:IsReady(player) and ((A.HeartOfTheWild:IsSpellLearned() and not A.Rip:IsSpellLearned()) or 
           (A.HeartOfTheWild:IsSpellLearned() and GetBuffStacks(player, A.FelinePotentialCounter.ID) == 6 and GetNearbyEnemiesCount() < 3)) then
            return A.HeartOfTheWild:Show(icon)
        end

        -- Moonfire
        if A.Moonfire:IsReady(target) and Unit(player):HasBuffs(A.BearForm.ID, true) > 0 then
            if (moonfireDebuff <= 2 and enemyCount < 7 and A.FuryOfNature:IsSpellLearned()) or
               (moonfireDebuff <= 2 and enemyCount < 4 and not A.FuryOfNature:IsSpellLearned()) then
                return A.Moonfire:Show(icon)
            end
        end

        --Trash
        if A.Thrash:IsReady(player) then
            if thrashDebuff <= 2 or
               (A.FlashingClaws:IsSpellLearned() and thrashStacks < 5) or
               (not A.FlashingClaws:IsSpellLearned() and thrashStacks < 3) then
                return A.Thrash:Show(icon)
            end
        end

        -- Bristling Fur
        if A.BristlingFur:IsReady(player) and A.RageoftheSleeper:GetCooldown() > 8 then
            return A.BristlingFur:Show(icon)
        end

        -- Barkskin
        if A.Barkskin:IsReady(player) and Unit(player):HasBuffs(A.BearForm.ID, true) > 0 then
            return A.Barkskin:Show(icon)
        end

        -- Lunar Beam
        if A.LunarBeam:IsReady(player) then
            return A.LunarBeam:Show(icon)
        end

        -- Convoke the Spirits
        if A.ConvokeTheSpirits:IsReady(player) and 
           ((A.WildpowerSurge:IsSpellLearned() and Unit(player):HasBuffs(A.CatForm.ID, true) > 0 and Unit(player):HasBuffs(A.FelinePotential.ID, true) > 0) or
           not A.WildpowerSurge:IsSpellLearned()) then
            return A.ConvokeTheSpirits:Show(icon)
        end

        if BurstIsON(target) then
            if A.Berserk:IsReady(player) and A.Berserk:IsSpellLearned() then
                return A.Berserk:Show(icon)
            end
            if A.Incarnation:IsReady(player) and A.Incarnation:IsSpellLearned() and not Unit(player):HasBuffs(A.Berserk.ID, true) then
                return A.Incarnation:Show(icon)
            end
        end

        -- Rage of the Sleeper
        if A.RageOfTheSleeper:IsReady(player) and Player:Rage() > 40 and
        (not A.ConvokeTheSpirits:IsSpellLearned() or Unit(player):HasBuffs(A.Incarnation.ID, true) > 0 or Unit(player):HasBuffs(A.Berserk.ID, true) > 0) then
         return A.RageOfTheSleeper:Show(icon)
        end

        -- Maul (single target)
        if A.Maul:IsReady(target) and Unit(player):HasBuffs(A.Ravage.ID, true) > 0 and GetNearbyEnemiesCount() > 1 then
            return A.Maul:Show(icon)
        end

        -- Raze
        if A.Raze:IsReady(player) and isIfBuild and MultiUnits:GetActiveEnemies() > 1 and
           ((GetBuffStacks(player, A.ToothandClaw.ID) > 1) or (Unit(player):HasBuffs(A.ToothandClaw.ID, true) < 1 + GetCurrentGCD())) then
            return A.Raze:Show(icon)
        end

        -- Thrash (AoE)
        if A.Thrash:IsReady(player) and MultiUnits:GetActiveEnemies() >= 5 and A.LunarCalling:IsSpellLearned() then
            return A.Thrash:Show(icon)
        end

        -- Ironfur
        if A.Ironfur:IsReady(player) and not Unit(player):HasBuffs(A.Ravage.ID, true) then
            if (isIfBuild and Player:Rage() > 40 and A.RageoftheSleeper:GetCooldown() > 3) or
               ((Unit(player):HasBuffs(A.Incarnation.ID, true) > 0 or Unit(player):HasBuffs(A.Berserk.ID, true) > 0) and Player:Rage() > 20) or
               (Player:Rage() > 90 and not A.FountOfStrength:IsSpellLearned()) or
               (Player:Rage() > 110 and A.FountOfStrength:IsSpellLearned()) then
                return A.Ironfur:Show(icon)
            end
        end

        -- Raze (Vicious Cycle)
        if A.Raze:IsReady(player) and isIfBuild and GetBuffStacks(player, A.ViciousCycleMaul.ID) == 3 and MultiUnits:GetActiveEnemies() > 1 and not A.Ravage:IsSpellLearned() then
            return A.Raze:Show(icon)
        end

        -- Mangle
        if A.Mangle:IsReady(target) and 
           (Unit(player):HasBuffs(A.Gore.ID, true) > 0 and MultiUnits:GetActiveEnemies() < 11 or
           (Unit(player):HasBuffs(A.Incarnation.ID, true) > 0 and GetBuffStacks(player, A.FelinePotentialCounter.ID) < 6 and A.WildpowerSurge:IsSpellLearned())) then
            return A.Mangle:Show(icon)
        end

        -- Raze (AoE)
        if A.Raze:IsReady(player) and not isIfBuild and 
           (MultiUnits:GetActiveEnemies() > 1 or (Unit(player):HasBuffs(A.ToothandClaw.ID, true) > 0 and MultiUnits:GetActiveEnemies() > 1) or
           (GetBuffStacks(player, A.ViciousCycleMaul.ID) == 3 and MultiUnits:GetActiveEnemies() > 1)) then
            return A.Raze:Show(icon)
        end

        -- Maul
        if A.Maul:IsReady(target) and
           ((isIfBuild and ((GetBuffStacks(player, A.ToothandClaw.ID) > 1 or Unit(player):HasBuffs(A.ToothandClaw.ID, true) < 1 + GetCurrentGCD()) and MultiUnits:GetActiveEnemies() <= 5 and not A.Raze:IsSpellLearned()) or
           ((GetBuffStacks(player, A.ToothandClaw.ID) > 1 or Unit(player):HasBuffs(A.ToothandClaw.ID, true) < 1 + GetCurrentGCD()) and MultiUnits:GetActiveEnemies() == 1 and A.Raze:IsSpellLearned())) or
           (not isIfBuild and ((Unit(player):HasBuffs(A.ToothandClaw.ID, true) > 0 and MultiUnits:GetActiveEnemies() <= 5 and not A.Raze:IsSpellLearned()) or
           (Unit(player):HasBuffs(A.ToothandClaw.ID, true) > 0 and MultiUnits:GetActiveEnemies() == 1 and A.Raze:IsSpellLearned()) or
           GetBuffStacks(player, A.ViciousCycleMaul.ID) == 3 and MultiUnits:GetActiveEnemies() <= 5 and not A.Raze:IsSpellLearned()))) then
            return A.Maul:Show(icon)
        end

        -- Thrash (AoE)
        if A.Thrash:IsReady(player) and MultiUnits:GetActiveEnemies() >= 5 then
            return A.Thrash:Show(icon)
        end

        -- Mangle
        if A.Mangle:IsReady(target) and
           ((Unit(player):HasBuffs(A.Incarnation.ID, true) > 0 and MultiUnits:GetActiveEnemies() <= 4) or
           (Unit(player):HasBuffs(A.Incarnation.ID, true) > 0 and A.SoulOfTheForest:IsSpellLearned() and MultiUnits:GetActiveEnemies() <= 5) or
           (Player:Rage() < 88 and MultiUnits:GetActiveEnemies() < 11) or
           (Player:Rage() < 83 and MultiUnits:GetActiveEnemies() < 11 and A.SoulOfTheForest:IsSpellLearned())) then
            return A.Mangle:Show(icon)
        end

        -- Thrash (AoE)
        if A.Thrash:IsReady(player) and MultiUnits:GetActiveEnemies() > 1 then
            return A.Thrash:Show(icon)
        end

        -- Pulverize
        if A.Pulverize:IsReady(target) and GetBuffStacks(target, A.Thrash.ID) > 2 then
            return A.Pulverize:Show(icon)
        end

        -- Thrash
        if A.Thrash:IsReady(player) then
            return A.Thrash:Show(icon)
        end

        -- Moonfire (Galactic Guardian)
        if A.Moonfire:IsReady(target) and Unit(player):HasBuffs(A.GalacticGuardian.ID, true) > 0 and
           Unit(player):HasBuffs(A.BearForm.ID, true) > 0 and A.BoundlessMoonlight:IsSpellLearned() then
            return A.Moonfire:Show(icon)
        end

        -- Starsurge
        if A.Starsurge:IsReady(target) and A.Starsurge:IsSpellLearned() and Player:Rage() < 20 then
            return A.Starsurge:Show(icon)
        end

        -- Swipe
        if A.Swipe:IsReady(player) and
           ((A.LunarInsight:IsSpellLearned() and MultiUnits:GetActiveEnemies() > 4) or
           not A.LunarInsight:IsSpellLearned() or
           (A.LunarInsight:IsSpellLearned() and MultiUnits:GetActiveEnemies() < 2)) then
            return A.Swipe:Show(icon)
        end

        -- Moonfire (Lunar Insight)
        if A.Moonfire:IsReady(target) and A.LunarInsight:IsSpellLearned() and MultiUnits:GetActiveEnemies() > 1 and
           Unit(player):HasBuffs(A.BearForm.ID, true) > 0 then
            return A.Moonfire:Show(icon)
        end
    end

    if IsUnitEnemy(target) and inCombat then
        return APL()
    end
end

