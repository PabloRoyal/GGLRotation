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
local ACTION_CONST_MAGE_ARCANE          = Action.Const.MAGE_ARCANE
local Utils                             = Action.Utils
local ActiveUnitPlates                  = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit, UnitExists, IsMounted, UnitThreatSituation, UnitCanAttack, IsInRaid, UnitDetailedThreatSituation, IsResting, GetItemCount, debugprofilestop = 
_G.IsIndoors, _G.UnitIsUnit, _G.IsMounted, _G.UnitThreatSituation, _G.UnitCanAttack, _G.IsInRaid, _G.UnitDetailedThreatSituation, _G.IsResting, _G.GetItemCount, _G.debugprofilestop

--###########################################
--##### ARCANE MAGE SPELLS #################
--###########################################

Action[ACTION_CONST_MAGE_ARCANE] = {
    -- Offensive spells
    ArcaneBlast = Create({ Type = "Spell", ID = 30451 }),
    ArcaneBarrage = Create({ Type = "Spell", ID = 44425 }),
    ArcaneMissiles = Create({ Type = "Spell", ID = 5143 }),
    ArcaneExplosion = Create({ Type = "Spell", ID = 1449 }),
    ArcaneOrb = Create({ Type = "Spell", ID = 153626 }),
    TouchoftheMagi = Create({ Type = "Spell", ID = 321507 }),
    Supernova = Create({ Type = "Spell", ID = 157980 }),
    
    -- Cooldowns
    ArcaneSurge = Create({ Type = "Spell", ID = 365350 }),
    Evocation = Create({ Type = "Spell", ID = 12051 }),
    ShiftingPower = Create({ Type = "Spell", ID = 382440 }),
    PresenceofMind = Create({ Type = "Spell", ID = 205025 }),
    
    -- Defensive and utility spells
    IceBlock = Create({ Type = "Spell", ID = 45438 }),
    MirrorImage = Create({ Type = "Spell", ID = 55342 }),
    ArcaneIntellect = Create({ Type = "Spell", ID = 1459 }),
    
    -- Interrupts
    Counterspell = Create({ Type = "Spell", ID = 2139 }),
    
    -- Buffs and debuffs
    Clearcasting = Create({ Type = "Spell", ID = 263725 }),
    NetherPrecision = Create({ Type = "Spell", ID = 383782 }),
    ArcaneSoul = Create({ Type = "Spell", ID = 365362 }),
    SiphonStorm = Create({ Type = "Spell", ID = 384195 }),
    BurdenofPower = Create({ Type = "Spell", ID = 383783 }),
    GloriousIncandescence = Create({ Type = "Spell", ID = 400730 }),
    Intuition = Create({ Type = "Spell", ID = 410019 }),
    UnerringProficiency = Create({ Type = "Spell", ID = 422448 }),
    MagisSpark = Create({ Type = "Spell", ID = 384276 }),
    
    -- Talents
    SpellslingerAoe = Create({ Type = "Spell", ID = 394195 }),
    SpellsfireSpheres = Create({ Type = "Spell", ID = 394204 }),
    HighVoltage = Create({ Type = "Spell", ID = 384252 }),
    ArcingCleave = Create({ Type = "Spell", ID = 231564 }),
    ArcaneBombardment = Create({ Type = "Spell", ID = 384581 }),
    Reverberate = Create({ Type = "Spell", ID = 281482 }),
    Impetus = Create({ Type = "Spell", ID = 389628 }),
    ShiftingShards = Create({ Type = "Spell", ID = 382410 }),
    ArcaneHarmony = Create({ Type = "Spell", ID = 384452 }),
    AetherAttunement = Create({ Type = "Spell", ID = 383548 }),
    ArcaneTempo = Create({ Type = "Spell", ID = 383980 }),
    SoulOfTheForest = Create({ Type = "Spell", ID = 158477 }),
}

local A = setmetatable(Action[ACTION_CONST_MAGE_ARCANE], { __index = Action })

local player = "player"
local target = "target"

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

--############################
--##### ROTATION VARS ########
--############################

local function RotationsVariables()
    isMoving = Player:IsMoving()
    isStaying = Player:IsStaying()
    combatTime = Unit(player):CombatTime()
    movingTime = Player:IsMovingTime()
    stayingTime = Player:IsStayingTime()
    PlayerHealth = Unit(player):HealthPercent()
    PlayerMana = Unit(player):PowerPercent()
    ArcaneCharges = Player:ArcaneCharges()
end

--############################
--##### HELPER FUNCTIONS #####
--############################

local function InRange(unitID)
    return A.ArcaneBlast:IsInRange(unitID)
end

local function BurstIsON(unitID)
    return Action.BurstIsON(unitID) or GetToggle(2, "BurstOnCooldown")
end

local function GetByRange(count, range)
    local c = 0
    for unitID in pairs(ActiveUnitPlates) do
        if (not UnitIsUnit(target, unitID)) and not Unit(unitID):IsExplosives() and not Unit(unitID):IsTotem() then
            if InRange(unitID) then
                c = c + 1
            elseif range then
                local r = Unit(unitID):GetRange()
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
    if not A.Counterspell:IsReadyByPassCastGCD(unitID) or not A.Counterspell:AbsentImun(unitID, Temp.TotalAndMagKick, true) then
        return true
    end
    return false
end

local function Interrupts(unit)
    local useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    
    if castRemainsTime >= A.GetLatency() then
        if useKick and A.Counterspell:IsReady(unit) and not notInterruptable and A.Counterspell:AbsentImun(unit, Temp.TotalAndMagKick, true) then
            return A.Counterspell
        end
    end
end

local function ShouldAoE()
    return GetByRange(3, 10)
end

local function HasClearcasting()
    return Unit(player):HasBuffs(A.Clearcasting.ID, true) > 0
end

local function HasNetherPrecision()
    return Unit(player):HasBuffs(A.NetherPrecision.ID, true) > 0
end

local function HasArcaneSoul()
    return Unit(player):HasBuffs(A.ArcaneSoul.ID, true) > 0
end

local function HasSiphonStorm()
    return Unit(player):HasBuffs(A.SiphonStorm.ID, true) > 0
end

local function HasBurdenofPower()
    return Unit(player):HasBuffs(A.BurdenofPower.ID, true) > 0
end

local function HasGloriousIncandescence()
    return Unit(player):HasBuffs(A.GloriousIncandescence.ID, true) > 0
end

local function HasIntuition()
    return Unit(player):HasBuffs(A.Intuition.ID, true) > 0
end

local function HasMagisSpark()
    return Unit(target):HasDeBuffs(A.MagisSpark.ID, true) > 0
end

local function ShouldUseEvocation()
    return A.Evocation:IsReady(player) and PlayerMana < 20 and 
           A.ArcaneSurge:GetCooldown() < (GetCurrentGCD() * 3) and 
           A.TouchoftheMagi:GetCooldown() < (GetCurrentGCD() * 5)
end

local function ShouldUseArcaneSurge()
    return A.ArcaneSurge:IsReady(player) and 
           A.TouchoftheMagi:GetCooldown() < (A.ArcaneSurge:GetExecuteTime() + (GetCurrentGCD() * (ArcaneCharges == 4 and 1 or 0)))
end

local function OptimizeArcaneMissiles()
    if A.ArcaneMissiles:IsReady(target) and HasClearcasting() then
        if not HasNetherPrecision() or Unit(player):HasBuffsStacks(A.Clearcasting.ID, true) == 3 then
            return A.ArcaneMissiles
        elseif A.AetherAttunement:IsTalentLearned() then
            return A.ArcaneMissiles
        else
            A.ArcaneMissiles:SetInterrupt(true, GetCurrentGCD())
            return A.ArcaneMissiles
        end
    end
    return nil
end

local function HandlePresenceOfMind()
    if A.PresenceofMind:IsReady(player) then
        if A.TouchoftheMagi:GetDebuffRemains() <= GetCurrentGCD() and HasNetherPrecision() and 
           not ShouldAoE() and not A.UnerringProficiency:IsTalentLearned() then
            return A.PresenceofMind
        elseif ShouldAoE() and (ArcaneCharges == 3 or ArcaneCharges == 2) then
            return A.PresenceofMind
        end
    end
    return nil
end

--############################
--##### ROTATION #############
--############################

A[3] = function(icon)
    -- Rotation variables
    RotationsVariables()
    local inCombat = Unit(player):CombatTime() > 0
    local isAoE = GetToggle(2, "AutoAoE") and ShouldAoE()
    local isBurst = BurstIsON(target)

    -- Pre-combat actions
    if not inCombat then
        if A.ArcaneIntellect:IsReady(player) and Unit(player):HasBuffs(A.ArcaneIntellect.ID, true) == 0 then
            return A.ArcaneIntellect:Show(icon)
        end
        if A.MirrorImage:IsReady(player) then
            return A.MirrorImage:Show(icon)
        end
        if A.Evocation:IsReady(player) and Unit(player):HasBuffs(A.SiphonStorm.ID, true) == 0 then
            return A.Evocation:Show(icon)
        end
        if A.ArcaneMissiles:IsReady(player) then
            return A.ArcaneMissiles:Show(icon)
        end
    end

    -- Main rotation
    local function APL()
        -- Interrupt
        if GetToggle(2, "AutoInterrupt") then
            local Interrupt = Interrupts(target)
            if Interrupt then 
                return Interrupt:Show(icon)
            end
        end

        -- Cooldowns
        if ShouldUseEvocation() then
            return A.Evocation:Show(icon)
        end
        
        if ShouldUseArcaneSurge() then
            return A.ArcaneSurge:Show(icon)
        end
        
        if A.TouchoftheMagi:IsReady(player) and (HasArcaneSoul() or A.ArcaneSurge:GetCooldown() > 30) then
            return A.TouchoftheMagi:Show(icon)
        end
        
        if A.ShiftingPower:IsReady(player) and not HasArcaneSoul() and not HasSiphonStorm() and
           A.TouchoftheMagi:GetCooldown() > 10 and A.Evocation:GetCooldown() > 15 then
            return A.ShiftingPower:Show(icon)
        end
        
        local pomSpell = HandlePresenceOfMind()
        if pomSpell then
            return pomSpell:Show(icon)
        end

        -- AoE rotation
        if isAoE then
            if A.Supernova:IsReady(player) and Unit(player):HasBuffsStacks(A.UnerringProficiency.ID, true) == 30 then
                return A.Supernova:Show(icon)
            end
            
            if A.ShiftingPower:IsReady(player) and A.ShiftingShards:IsTalentLearned() and
               (Unit(player):HasBuffs(A.ArcaneSurge.ID, true) > 0 or A.TouchoftheMagi:GetDebuffRemains() > 0 or A.Evocation:GetCooldown() < 20) then
                return A.ShiftingPower:Show(icon)
            end
            
            if A.ArcaneOrb:IsReady(player) and ArcaneCharges < 2 then
                return A.ArcaneOrb:Show(icon)
            end
            
            if A.ArcaneBlast:IsReady(target) and HasMagisSpark() then
                return A.ArcaneBlast:Show(icon)
            end
            
            if A.ArcaneBarrage:IsReady(target) and 
               ((A.ArcaneTempo:IsTalentLearned() and Unit(player):HasBuffs(A.ArcaneTempo.ID, true) < GetCurrentGCD()) or
               ((HasIntuition() and (ArcaneCharges == 4 or not A.HighVoltage:IsTalentLearned())) and HasNetherPrecision()) or
               (HasNetherPrecision() and A.ArcaneBlast:GetLastCastTime() < 0.1)) then
                return A.ArcaneBarrage:Show(icon)
            end
            
            local optimizedMissiles = OptimizeArcaneMissiles()
            if optimizedMissiles then
                return optimizedMissiles:Show(icon)
            end
            
            if A.PresenceofMind:IsReady(player) and (ArcaneCharges == 3 or ArcaneCharges == 2) then
                return A.PresenceofMind:Show(icon)
            end
            
            if A.ArcaneBarrage:IsReady(target) and ArcaneCharges == 4 then
                return A.ArcaneBarrage:Show(icon)
            end
            
            if A.ArcaneExplosion:IsReady(player) then
                return A.ArcaneExplosion:Show(icon)
            end
        else
            -- Single target rotation
            if A.ArcaneBarrage:IsReady(target) and 
               ((HasNetherPrecision() == 1 and A.ArcaneBlast:GetLastCastTime() < 0.015) or
               A.TouchoftheMagi:IsReady(player) or
               (A.ArcaneTempo:IsTalentLearned() and Unit(player):HasBuffs(A.ArcaneTempo.ID, true) < GetCurrentGCD())) then
                return A.ArcaneBarrage:Show(icon)
            end
            
            local optimizedMissiles = OptimizeArcaneMissiles()
            if optimizedMissiles then
                return optimizedMissiles:Show(icon)
            end
            
            if A.ArcaneOrb:IsReady(player) and ArcaneCharges < 2 then
                return A.ArcaneOrb:Show(icon)
            end
            
            if A.ArcaneBlast:IsReady(target) then
                return A.ArcaneBlast:Show(icon)
            end
            
            if A.ArcaneBarrage:IsReady(target) then
                return A.ArcaneBarrage:Show(icon)
            end
        end
    end

    if IsUnitEnemy(target) and (inCombat or Unit(player):IsCastingRemains() < 0.5) then
        return APL()
    end
end

-- PvP specific functions
A[6] = function(icon)
    if A.IsInPvP then
        -- Add PvP-specific abilities here
        if GetToggle(2, "UseCounterspellPvP") and A.Counterspell:IsReady(target) and A.Counterspell:AbsentImun(target, Temp.TotalAndMagKick, true) then
            return A.Counterspell:Show(icon)
        end
    end
end

-- Utility functions
A[7] = function(icon)
    if GetToggle(2, "UseArcaneIntellect") and A.ArcaneIntellect:IsReady(player) then
        for _, unitID in ipairs({"player", "party1", "party2", "party3", "party4"}) do
            if UnitExists(unitID) and Unit(unitID):HasBuffs(A.ArcaneIntellect.ID, true) == 0 then
                return A.ArcaneIntellect:Show(icon)
            end
        end
    end

    -- Add more utility functions as needed
end

-- Auto-target function
A[8] = function(icon)
    if GetToggle(2, "AutoTarget") and Unit(target):IsEnemy() and Unit(target):GetRange() <= 40 then
        return A:Show(icon, ACTION_CONST_AUTOTARGET)
    end
end

