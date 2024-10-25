local TMW = _G.TMW
local Action = _G.Action
local GetSpellTexture = _G.TMW.GetSpellTexture
local A = Action
local Unit = Action.Unit
local Create = Action.Create
local Player = Action.Player
local BurstIsON = Action.BurstIsON
local GetToggle = Action.GetToggle
local MultiUnits = Action.MultiUnits
local AuraIsValid = Action.AuraIsValid
local HasBuffs = Action.HasBuffs
local GetSpellCharges = Action.GetSpellCharges
local IsUnitEnemy = Action.IsUnitEnemy
local InCombat = Action.InCombat
local InRange = Action.InRange
local GetCurrentGCD = Action.GetCurrentGCD
local IsUnitFriendly = Action.IsUnitFriendly
local UnitCanAttack = Action.UnitCanAttack
local InterruptIsValid = Action.InterruptIsValid
local ACTION_CONST_STOPCAST = Action.Const.STOPCAST
local ACTION_CONST_AUTOTARGET = Action.Const.AUTOTARGET
local ACTION_CONST_HUNTER_BEASTMASTERY = Action.Const.HUNTER_BEASTMASTERY
local Utils = Action.Utils
local ActiveUnitPlates = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit, IsMounted, UnitThreatSituation, UnitCanAttack, IsInRaid, UnitDetailedThreatSituation, IsResting, GetItemCount, debugprofilestop = 
_G.IsIndoors, _G.UnitIsUnit, _G.IsMounted, _G.UnitThreatSituation, _G.UnitCanAttack, _G.IsInRaid, _G.UnitDetailedThreatSituation, _G.IsResting, _G.GetItemCount, _G.debugprofilestop


--##################################################################################################################################################################################################################

--##############################
--########## Spells ############
--##############################


Action[ACTION_CONST_HUNTER_BEASTMASTERY] = {
    -- Offensive abilities
    BarbedShot                  = Create({ Type = "Spell", ID = 217200 }),
    KillCommand                 = Create({ Type = "Spell", ID = 34026 }),
    CobraShot                   = Create({ Type = "Spell", ID = 193455 }),
    MultiShot                   = Create({ Type = "Spell", ID = 2643 }),
    KillShot                    = Create({ Type = "Spell", ID = 53351 }),
    ExplosiveShot               = Create({ Type = "Spell", ID = 212431 }),
    DireBeast                   = Create({ Type = "Spell", ID = 120679 }),
    
    -- Defensive abilities
    Exhilaration                = Create({ Type = "Spell", ID = 109304 }),
    AspectoftheTurtle           = Create({ Type = "Spell", ID = 186265 }),
    
    -- Cooldowns
    BestialWrath                = Create({ Type = "Spell", ID = 19574 }),
    CalloftheWild               = Create({ Type = "Spell", ID = 359844 }),
    Bloodshed                   = Create({ Type = "Spell", ID = 321530 }),
    
    -- Utility
    CounterShot                 = Create({ Type = "Spell", ID = 147362 }),
    HuntersMark                 = Create({ Type = "Spell", ID = 257284 }),
    Misdirection                = Create({ Type = "Spell", ID = 34477 }),
    
    -- Talents and Passives
    Frenzy                      = Create({ Type = "Spell", ID = 272790 }),
    BeastCleave                 = Create({ Type = "Spell", ID = 115939 }),
    KillerInstinct              = Create({ Type = "Spell", ID = 273887 }),
    BloodyFrenzy                = Create({ Type = "Spell", ID = 407412 }),
    ExplosiveVenom              = Create({ Type = "Spell", ID = 400456 }),
}

--##################################################################################################################################################################################################################

--##############################
--########## Locals ############
--##############################

local A = setmetatable(Action[ACTION_CONST_HUNTER_BEASTMASTERY], { __index = Action })

local mouseover = "mouseover"
local focus = "focus"
local target = "target"
local player = "player"
local pet = "pet"

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
}


--##################################################################################################################################################################################


--######################
--#### Funktionen ######
--######################

local function RotationsVariables()
    isMoving = Player:IsMoving()
    isStaying = Player:IsStaying()
    combatTime = Unit(player):CombatTime()
    movingTime = Player:IsMovingTime()
    stayingTime = Player:IsStayingTime()
    PlayerHealth = Unit(player):HealthPercent()
end

local function InRange(unitID)
    return A.CobraShot:IsInRange(unitID)
end

local function GetByRange(count, range)
    local c = 0
    for unitID in pairs(ActiveUnitPlates) do
        if not UnitIsUnit(target, unitID) and not Action.Unit(unitID):IsExplosives() and not Action.Unit(unitID):IsTotem() then
            if Unit(pet):GetRange(unitID) <= range then
                c = c + 1
            end
            
            if c >= count then
                return true
            end
        end
    end
    return false
end
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)

local function countInterruptGCD(unitID)
    if not A.CounterShot:IsReadyByPassCastGCD(unitID) or not A.CounterShot:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
        return true
    end
    return false
end

local function Interrupts(unit)
    local useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    
    if castRemainsTime >= A.GetLatency() then
        if useKick and A.CounterShot:IsReady(unit) and not notInterruptable and A.CounterShot:AbsentImun(unit, Temp.TotalAndPhysKick, true) then
            return A.CounterShot
        end
    end
end

local function ShouldAoE()
    return GetByRange(3, 8)
end

-- Buff-Checks
local function HasFrenzy()
    return Unit(pet):HasBuffs(A.Frenzy.ID, true) > 0
end

local function HasBeastCleave()
    return Unit(pet):HasBuffs(A.BeastCleave.ID, true) > 0
end

-- Helper Functions
local function ShouldRefreshFrenzy()
    return HasFrenzy() and Unit(pet):HasBuffsStacks(A.Frenzy.ID, true) < 3 or Unit(pet):HasBuffs(A.Frenzy.ID, true) <= 1.5
end

local function Defensive()
    if Unit(player):HealthPercent() <= 30 and A.Exhilaration:IsReady(player) then
        return A.Exhilaration
    end
    
    if Unit(player):HealthPercent() <= 20 and A.AspectoftheTurtle:IsReady(player) then
        return A.AspectoftheTurtle
    end
end

A[3] = function(icon)
    -- Rotationsvariablen
    RotationsVariables()
    local inCombat = Unit(player):CombatTime() > 0
    local isAoE = ShouldAoE()

    -- Defensives
    local defensiveSpell = Defensive()
    if defensiveSpell then
        return defensiveSpell:Show(icon)
    end

    -- Interrupt
    if A.IsUnitEnemy(target) then
        local Interrupt = Interrupts(target)
        if Interrupt then 
            return Interrupt:Show(icon)
        end
    end

    -- Hunter's Mark
    if A.HuntersMark:IsReady(target) and Unit(target):HasDeBuffs(A.HuntersMark.ID, true) == 0 then
        return A.HuntersMark:Show(icon)
    end

    -- Main Rotation
    local function APL()
        -- Maintain Frenzy
        if ShouldRefreshFrenzy() and A.BarbedShot:IsReady(target) then
            return A.BarbedShot:Show(icon)
        end

        -- AoE: Maintain Beast Cleave
        if isAoE and not HasBeastCleave() and A.MultiShot:IsReady(target) then
            return A.MultiShot:Show(icon)
        end

        -- Use Dire Beast
        if A.DireBeast:IsReady(target) then
            return A.DireBeast:Show(icon)
        end

        -- Use Call of the Wild
        if A.CalloftheWild:IsReady(player) and BurstIsON(target) then
            return A.CalloftheWild:Show(icon)
        end

        -- Use Bestial Wrath
        if A.BestialWrath:IsReady(player) and BurstIsON(target) then
            return A.BestialWrath:Show(icon)
        end

        -- Use Kill Command
        if A.KillCommand:IsReady(target) then
            return A.KillCommand:Show(icon)
        end

        -- Use Barbed Shot
        if A.BarbedShot:IsReady(target) then
            return A.BarbedShot:Show(icon)
        end

        -- Use Cobra Shot during Bestial Wrath
        if A.CobraShot:IsReady(target) and Unit(player):HasBuffs(A.BestialWrath.ID, true) > 0 then
            return A.CobraShot:Show(icon)
        end

        -- Use Explosive Shot when not in Bestial Wrath
        if A.ExplosiveShot:IsReady(target) and Unit(player):HasBuffs(A.BestialWrath.ID, true) == 0 then
            return A.ExplosiveShot:Show(icon)
        end

        -- Use Kill Shot
        if A.KillShot:IsReady(target) then
            return A.KillShot:Show(icon)
        end

        -- Use Cobra Shot as filler
        if A.CobraShot:IsReady(target) then
            return A.CobraShot:Show(icon)
        end
    end

    if IsUnitEnemy(target) then
        return APL()
    end
end