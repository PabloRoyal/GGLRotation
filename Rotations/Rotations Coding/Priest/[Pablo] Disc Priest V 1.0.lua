-- Complete Discipline Priest Rotation V1.0
-- Last Update: 10/22/2024

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
local HealingEngine                     = Action.HealingEngine
local TeamCache                         = Action.TeamCache
local ACTION_CONST_PRIEST_DISCIPLINE    = Action.Const.PRIEST_DISCIPLINE
local Utils                             = Action.Utils
local ActiveUnitPlates                  = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit, UnitExists, IsMounted, UnitThreatSituation, UnitCanAttack, IsInRaid, UnitDetailedThreatSituation, IsResting, GetItemCount, debugprofilestop = 
_G.IsIndoors, _G.UnitIsUnit, _G.IsMounted, _G.UnitThreatSituation, _G.UnitCanAttack, _G.IsInRaid, _G.UnitDetailedThreatSituation, _G.IsResting, _G.GetItemCount, _G.debugprofilestop




Action[ACTION_CONST_PRIEST_DISCIPLINE] = {
    -- Core Abilities
    PowerWordShield                     = Create({ Type = "Spell", ID = 17 }),
    PowerWordRadiance                   = Create({ Type = "Spell", ID = 194509 }),
    Penance                             = Create({ Type = "Spell", ID = 47540 }),
    PurgeTheWicked                      = Create({ Type = "Spell", ID = 204197 }),
    ShadowWordPain                      = Create({ Type = "Spell", ID = 589 }),
    ShadowWordDeath                     = Create({ Type = "Spell", ID = 32379 }),
    MindBlast                           = Create({ Type = "Spell", ID = 8092 }),
    Smite                               = Create({ Type = "Spell", ID = 585 }),
    MindSear                            = Create({ Type = "Spell", ID = 48045 }),
    
    -- Major Cooldowns
    PowerInfusion                       = Create({ Type = "Spell", ID = 10060 }),
    Rapture                             = Create({ Type = "Spell", ID = 47536 }),
    PainSuppression                     = Create({ Type = "Spell", ID = 33206 }),
    PowerWordBarrier                    = Create({ Type = "Spell", ID = 62618 }),
    SpiritShell                         = Create({ Type = "Spell", ID = 109964 }),
    Evangelism                          = Create({ Type = "Spell", ID = 246287 }),
    
    -- AoE Abilities
    DivineStar                          = Create({ Type = "Spell", ID = 110744 }),
    Halo                                = Create({ Type = "Spell", ID = 120517 }),
    DarkReprimand                       = Create({ Type = "Spell", ID = 373137 }),
    HolyNova                            = Create({ Type = "Spell", ID = 132157 }),
    
    -- Talents
    Mindbender                          = Create({ Type = "Spell", ID = 123040 }),
    Shadowfiend                         = Create({ Type = "Spell", ID = 34433 }),
    Schism                              = Create({ Type = "Spell", ID = 214621 }),
    Contrition                          = Create({ Type = "Spell", ID = 197419 }),
    TwilightEquilibrium                 = Create({ Type = "Spell", ID = 373223 }),
    
    -- Utility
    MassDispel                          = Create({ Type = "Spell", ID = 32375 }),
    DispelMagic                         = Create({ Type = "Spell", ID = 528 }),
    PsychicScream                       = Create({ Type = "Spell", ID = 8122 }),
    Fade                                = Create({ Type = "Spell", ID = 586 }),
    LeapOfFaith                         = Create({ Type = "Spell", ID = 73325 }),
    
    -- Buffs/Debuffs
    Atonement                           = Create({ Type = "Spell", ID = 194384, Hidden = true }),
    PowerOfTheDarkSide                  = Create({ Type = "Spell", ID = 198068, Hidden = true }),
    TwilightEquilibriumBuff             = Create({ Type = "Spell", ID = 373223, Hidden = true }),
    SchismDebuff                        = Create({ Type = "Spell", ID = 214621, Hidden = true }),
}

local A = setmetatable(Action[ACTION_CONST_PRIEST_DISCIPLINE], { __index = Action })

-- Local Variables
local player = "player"
local target = "target"
local focus = "focus"
local mouseover = "mouseover"

local Temp = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndCC                              = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMagPhys                         = {"TotalImun", "DamageMagicImun", "DamagePhysImun"},
}


-- Helper Functions
local function GetBuffStacks(unit, spellID)
    local count = select(3, Unit(unit):HasBuffs(spellID))
    return count or 0
end

local function isInRange(unit)
    return A.PowerWordShield:IsInRange(unit)
end

local function isUnitValid(unit)
    return isInRange(unit) and not Unit(unit):IsDead() and IsUnitFriendly(unit)
end

A[3] = function(icon)
    -- Basic variables
    local getMembersAll = HealingEngine.GetMembersAll()
    local inCombat = Unit(player):CombatTime() > 0
    local isMoving = Player:IsMoving()
    local isBurst = Action.BurstIsON(target)

    -- Core rotation function
    local function HealingRotation(unit)
        -- Check if unit is valid for healing
        if not isUnitValid(unit) then return false end

        -- Emergency Pain Suppression
        if A.PainSuppression:IsReady(unit) and Unit(unit):HealthPercent() <= 30 then
            return A.PainSuppression:Show(icon)
        end

        -- Power Word: Shield for Atonement
        if A.PowerWordShield:IsReady(unit) and Unit(unit):HasBuffs(A.Atonement.ID) == 0 then
            return A.PowerWordShield:Show(icon)
        end

        -- Power Word: Radiance for group Atonement
        if A.PowerWordRadiance:IsReady(unit) and A.PowerWordRadiance:GetSpellCharges() > 0 then
            local needsAtonement = 0
            for _, member in pairs(getMembersAll) do
                if Unit(member):HasBuffs(A.Atonement.ID) == 0 then
                    needsAtonement = needsAtonement + 1
                end
            end
            if needsAtonement >= 3 then
                return A.PowerWordRadiance:Show(icon)
            end
        end

        -- Damage dealing for healing
        if IsUnitEnemy(target) then
            -- Schism when available
            if A.Schism:IsReady(target) then
                return A.Schism:Show(icon)
            end

            -- Penance for damage/healing
            if A.Penance:IsReady(target) then
                return A.Penance:Show(icon)
            end

            -- Keep up Purge the Wicked
            if A.PurgeTheWicked:IsReady(target) and Unit(target):HasDeBuffs(A.PurgeTheWicked.ID) <= 2 then
                return A.PurgeTheWicked:Show(icon)
            end

            -- Mind Blast for damage
            if A.MindBlast:IsReady(target) then
                return A.MindBlast:Show(icon)
            end

            -- Smite as filler
            if A.Smite:IsReady(target) then
                return A.Smite:Show(icon)
            end
        end

        -- Halo if talented and needed
        if A.Halo:IsReady(player) and MultiUnits:GetByRange(30, 4) then
            return A.Halo:Show(icon)
        end

        -- Divine Star if close range healing needed
        if A.DivineStar:IsReady(player) and MultiUnits:GetByRange(10, 3) then
            return A.DivineStar:Show(icon)
        end
    end

    -- Main rotation logic
    if IsUnitFriendly(focus) then
        unit = focus
        if HealingRotation(unit) then
            return true
        end
    elseif IsUnitFriendly(target) then
        unit = target
        if HealingRotation(unit) then
            return true
        end
    end

    if IsUnitEnemy(target) then
        unit = target
        if HealingRotation(unit) then
            return true
        end
    end
end

-- Interrupts
A[4] = function(icon)
    if A.PsychicScream:IsReady(player) and MultiUnits:GetByRange(8, 3) then
        return A.PsychicScream:Show(icon)
    end
end

-- Emergency Buttons
A[5] = function(icon)
    if Unit(player):HealthPercent() <= 40 then
        if A.PainSuppression:IsReady(player) then
            return A.PainSuppression:Show(icon)
        end
    end
end