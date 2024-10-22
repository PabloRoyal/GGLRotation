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
local ACTION_CONST_HUNTER_MARKSMANSHIP = Action.Const.HUNTER_MARKSMANSHIP
local Utils = Action.Utils
local ActiveUnitPlates = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit, IsMounted, UnitThreatSituation, UnitCanAttack, IsInRaid, UnitDetailedThreatSituation, IsResting, GetItemCount, debugprofilestop = 
_G.IsIndoors, _G.UnitIsUnit, _G.IsMounted, _G.UnitThreatSituation, _G.UnitCanAttack, _G.IsInRaid, _G.UnitDetailedThreatSituation, _G.IsResting, _G.GetItemCount, _G.debugprofilestop

--##################################################################################################################################################################################################################

--##############################
--########## Spells ############
--##############################

Action[ACTION_CONST_HUNTER_MARKSMANSHIP] = {
    -- Offensive abilities
    AimedShot                       = Create({ Type = "Spell", ID = 19434 }),
    RapidFire                       = Create({ Type = "Spell", ID = 257044 }),
    ArcaneShot                      = Create({ Type = "Spell", ID = 185358 }),
    MultiShot                       = Create({ Type = "Spell", ID = 257620 }),
    SteadyShot                      = Create({ Type = "Spell", ID = 56641 }),
    KillShot                        = Create({ Type = "Spell", ID = 53351 }),
    ExplosiveShot                   = Create({ Type = "Spell", ID = 212431 }),
    
    -- Defensive abilities
    Exhilaration                    = Create({ Type = "Spell", ID = 109304 }),
    AspectoftheTurtle               = Create({ Type = "Spell", ID = 186265 }),
    
    -- Cooldowns
    Trueshot                        = Create({ Type = "Spell", ID = 288613 }),
    Volley                          = Create({ Type = "Spell", ID = 260243 }),
    
    -- Utility
    CounterShot                     = Create({ Type = "Spell", ID = 147362 }),
    HuntersMark                     = Create({ Type = "Spell", ID = 257284 }),
    
    -- Talents
    SteadyFocus                     = Create({ Type = "Spell", ID = 193533 }),
    Salvo                           = Create({ Type = "Spell", ID = 400456 }),
    UnerringVision                  = Create({ Type = "Spell", ID = 386878 }),
    Streamline                      = Create({ Type = "Spell", ID = 260367 }),
    EagletalonsTrue                 = Create({ Type = "Spell", ID = 389449 }),
    SurgingShots                    = Create({ Type = "Spell", ID = 391559 }),
    
    -- Buffs and Debuffs
    PreciseShots                    = Create({ Type = "Spell", ID = 260242 }),
    TrickShots                      = Create({ Type = "Spell", ID = 257621 }),
}

--##################################################################################################################################################################################################################

--##############################
--########## Locals ############
--##############################

local A = setmetatable(Action[ACTION_CONST_HUNTER_MARKSMANSHIP], { __index = Action })

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
}

--##################################################################################################################################################################################


--######################
--#### Funktionen ######
--######################

local function RotationsVariables()
    isMoving        = Player:IsMoving()
    isStaying       = Player:IsStaying()
    combatTime      = Unit(player):CombatTime()
    movingTime      = Player:IsMovingTime()
    stayingTime     = Player:IsStayingTime()
    PlayerHealth    = Unit(player):HealthPercent()
end

local function InRange(unitID)
    return A.ArcaneShot:IsInRange(unitID)
end

local function GetByRange(count, range)
    local c = 0
    for unitID in pairs(ActiveUnitPlates) do
        if not UnitIsUnit(target, unitID) and not Action.Unit(unitID):IsExplosives() and not Action.Unit(unitID):IsTotem() then
            if InRange(unitID) then
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
    return GetByRange(3, 40)
end

-- Buff-Checks
local function HasPreciseShots()
    return Unit(player):HasBuffs(A.PreciseShots.ID, true) > 0
end

local function HasTrickShots()
    return Unit(player):HasBuffs(A.TrickShots.ID, true) > 0
end

local function HasUnerringVision()
    return Unit(player):HasBuffsStacks(A.UnerringVision.ID, true) == 10
end

-- Helper Functions
local function ShouldRefreshSteadyFocus()
    return A.SteadyFocus:IsTalentLearned() and Unit(player):HasBuffs(A.SteadyFocus.ID, true) <= 8
end

local function UseSalvo()
    return A.Salvo:IsTalentLearned() and A.Salvo:IsReady(player) and HasUnerringVision()
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
        -- Steady Focus
        if A.SteadyShot:IsReady(target) then
            return A.SteadyShot:Show(icon)
        end

        -- Volley
        if A.Volley:IsReady(player) then
            return A.Volley:Show(icon)
        end

        -- Salvo
        if UseSalvo() then
            return A.Salvo:Show(icon)
        end

        -- Rapid Fire
        if A.RapidFire:IsReady(target) and (not isAoE or HasTrickShots()) then
            return A.RapidFire:Show(icon)
        end

        -- Trueshot
        if A.Trueshot:IsReady(player) and BurstIsON(target) then
            return A.Trueshot:Show(icon)
        end

        -- Aimed Shot
        if A.AimedShot:IsReady(target) and (not isAoE or HasTrickShots()) then
            return A.AimedShot:Show(icon)
        end

        -- Kill Shot
        if A.KillShot:IsReady(target) then
            return A.KillShot:Show(icon)
        end

        -- Arcane Shot / Multi-Shot
        if HasPreciseShots() then
            if isAoE and A.MultiShot:IsReady(target) then
                return A.MultiShot:Show(icon)
            elseif A.ArcaneShot:IsReady(target) then
                return A.ArcaneShot:Show(icon)
            end
        end

        -- Explosive Shot
        if A.ExplosiveShot:IsReady(target) then
            return A.ExplosiveShot:Show(icon)
        end

        -- Focus Dump
        if Player:Focus() > 55 then
            if isAoE and A.MultiShot:IsReady(target) then
                return A.MultiShot:Show(icon)
            elseif A.ArcaneShot:IsReady(target) then
                return A.ArcaneShot:Show(icon)
            end
        end

        -- Steady Shot as filler
        if A.SteadyShot:IsReady(target) then
            return A.SteadyShot:Show(icon)
        end
    end

    if IsUnitEnemy(target) then
        return APL()
    end
end

