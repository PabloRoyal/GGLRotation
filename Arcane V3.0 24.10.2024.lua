local TMW                               = _G.TMW 
local Action                            = _G.Action
local GetSpellTexture                   = _G.TMW.GetSpellTexture
local A                                 = Action
local Unit                              = Action.Unit 
local Player                            = Action.Player
local Pet                               = Action.Pet
local MultiUnits                        = Action.MultiUnits
local UnitCooldown                      = Action.UnitCooldown
local BurstIsON                         = Action.BurstIsON
local TeamCache                         = Action.TeamCache
local EnemyTeam                         = Action.EnemyTeam
local FriendlyTeam                      = Action.FriendlyTeam
local LoC                               = Action.LossOfControl
local GetCurrentGCD                     = Action.GetCurrentGCD
local GetGCD                            = Action.GetGCD
local GetToggle                         = Action.GetToggle
local IsUnitEnemy                       = Action.IsUnitEnemy
local ACTION_CONST_MAGE_ARCANE          = Action.Const.MAGE_ARCANE

-- Lua APIs
local select, pairs, type, math         = select, pairs, type, math
local GetTime                           = GetTime
local GetSpellInfo                      = GetSpellInfo

-- WoW APIs
local IsSpellInRange, IsMounted, UnitExists, UnitCanAttack = 
_G.IsSpellInRange, _G.IsMounted, _G.UnitExists, _G.UnitCanAttack

-- Unit Variables
local player                            = "player"
local target                            = "target"
local mouseover                         = "mouseover"
local focus                             = "focus"

-- Helper Tables
local Temp = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndCC                              = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMagPhys                         = {"TotalImun", "DamageMagicImun", "DamagePhysImun"},
    DisablePhys                             = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    IsSlotTrinketBlocked                    = {},
}

-- Register Spells
Action[ACTION_CONST_MAGE_ARCANE] = {
    -- Racial Abilities
    ArcaneTorrent                   = Action.Create({ Type = "Spell", ID = 50613    }),
    BloodFury                       = Action.Create({ Type = "Spell", ID = 20572    }),
    Fireblood                       = Action.Create({ Type = "Spell", ID = 265221   }),
    AncestralCall                   = Action.Create({ Type = "Spell", ID = 274738   }),
    Berserking                      = Action.Create({ Type = "Spell", ID = 26297    }),
    
    -- Mage General Abilities
    ArcaneIntellect                 = Action.Create({ Type = "Spell", ID = 1459     }),
    Counterspell                    = Action.Create({ Type = "Spell", ID = 2139     }),
    IceBlock                        = Action.Create({ Type = "Spell", ID = 45438    }),
    IceBarrier                      = Action.Create({ Type = "Spell", ID = 11426    }),
    AlterTime                       = Action.Create({ Type = "Spell", ID = 342245   }),
    Evocation                       = Action.Create({ Type = "Spell", ID = 12051    }),
    MirrorImage                     = Action.Create({ Type = "Spell", ID = 55342    }),
    
    -- Arcane Specific Spells
    ArcaneBlast                     = Action.Create({ Type = "Spell", ID = 30451    }),
    ArcaneBarrage                   = Action.Create({ Type = "Spell", ID = 44425    }),
    ArcaneMissiles                  = Action.Create({ Type = "Spell", ID = 5143     }),
    TouchOfTheMagi                  = Action.Create({ Type = "Spell", ID = 321507   }),
    ArcaneSurge                     = Action.Create({ Type = "Spell", ID = 365350   }),
    ArcaneExplosion                 = Action.Create({ Type = "Spell", ID = 1449     }),
    ArcaneOrb                       = Action.Create({ Type = "Spell", ID = 153626   }),
    
    -- Talents
    SpellSlinger                    = Action.Create({ Type = "Spell", ID = 443739, Hidden = true, isTalent = true }),
    SunFury                         = Action.Create({ Type = "Spell", ID = 448601, Hidden = true, isTalent = true }),
    NetherPrecision                 = Action.Create({ Type = "Spell", ID = 383782, Hidden = true }),
    ArcaneTempo                     = Action.Create({ Type = "Spell", ID = 383980, Hidden = true }),
    ArcaneHarmony                   = Action.Create({ Type = "Spell", ID = 384452, Hidden = true }),
    ArcaneBombardment               = Action.Create({ Type = "Spell", ID = 384581, Hidden = true }),
    
    -- Important Buffs/Debuffs
    Clearcasting                    = Action.Create({ Type = "Spell", ID = 263725   }),
    ArcaneSoul                      = Action.Create({ Type = "Spell", ID = 365362   }),
    MagisSpark                      = Action.Create({ Type = "Spell", ID = 337137   }),
    BurdenOfPower                   = Action.Create({ Type = "Spell", ID = 383981   }),
    GloriousIncandescence          = Action.Create({ Type = "Spell", ID = 383935   }),
    
    -- PvP Talents
    MassInvisibility                = Action.Create({ Type = "Spell", ID = 414664   }),
}

-- Create the Action Table
local A = setmetatable(Action[ACTION_CONST_MAGE_ARCANE], { __index = Action })

-- Cache Frequently Used Functions
local function InRange(unitID)
    return A.ArcaneBlast:IsInRange(unitID)
end
InRange = Action.MakeFunctionCachedDynamic(InRange)

local function GetByRange(count, range)
    local c = 0
    for unitID in pairs(ActiveUnitPlates) do
        if not Unit(unitID):IsDead() and not Unit(unitID):IsTotem() then
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
GetByRange = Action.MakeFunctionCachedDynamic(GetByRange)

-- Core Helper Functions
local function BurstIsON(unitID)
    return Action.BurstIsON(unitID) or GetToggle(2, "BurstOnCooldown")
end

local function ShouldAoE()
    if not GetToggle(2, "AoE") then return false end
    local activeEnemies = MultiUnits:GetActiveEnemies()
    return activeEnemies >= (A.SpellSlinger:IsTalentLearned() and 2 or 3)
end

local function IsSpellslingerBuild()
    return A.SpellSlinger:IsTalentLearned()
end

local function IsSunfuryBuild()
    return A.SunFury:IsTalentLearned()
end

-- Defensives
local function DefensiveCDs()
    if Unit(player):CombatTime() == 0 then return false end
    
    local playerHP = Unit(player):HealthPercent()
    
    if playerHP <= GetToggle(2, "IceBlockHP") and A.IceBlock:IsReady(player) then
        return A.IceBlock
    end
    
    if playerHP <= GetToggle(2, "IceBarrierHP") and A.IceBarrier:IsReady(player) then
        return A.IceBarrier
    end
    
    if playerHP <= GetToggle(2, "AlterTimeHP") and A.AlterTime:IsReady(player) then
        return A.AlterTime
    end
end

-- Interrupts
local function Interrupts(unitID)
    local useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID, nil, nil, countInterruptGCD(unitID))
    
    if castRemainsTime >= GetLatency() then
        if useKick and not notInterruptable and A.Counterspell:IsReady(unitID) and not A.Counterspell:IsBlocked() then
            return A.Counterspell
        end
    end
end


-- Rotation Variables
local function RotationVariables()
    local isMoving = Player:IsMoving()
    local isStaying = Player:IsStaying()
    local combatTime = Unit(player):CombatTime()
    local manaPercent = Player:ManaPercentage()
    local currentCharges = Player:ArcaneCharges()
    local activeEnemies = MultiUnits:GetActiveEnemies()
end

-- Buff Management
local function GetBuffStack(unit, spellID)
    return Unit(unit):HasBuffsStacks(spellID) or 0
end

local function GetBuffRemains(unit, spellID)
    return Unit(unit):HasBuffs(spellID, true) or 0
end

-- Burst Conditions
local function UseCooldowns(unitID)
    local isBurst = BurstIsON(unitID)
    if not isBurst then return false end
    
    -- Mirror Image Usage
    if A.MirrorImage:IsReady(player) then
        return A.MirrorImage
    end

    -- Racial Abilities
    if A.Berserking:IsReady(player) and Unit(player):HasBuffs(A.ArcaneSurge.ID) > 0 then
        return A.Berserking
    end
    
    if A.BloodFury:IsReady(player) and Unit(player):HasBuffs(A.ArcaneSurge.ID) > 0 then
        return A.BloodFury
    end
    
    if A.Fireblood:IsReady(player) and Unit(player):HasBuffs(A.ArcaneSurge.ID) > 0 then
        return A.Fireblood
    end

    -- Main Cooldowns
    if A.ArcaneSurge:IsReady(player) and A.TouchOfTheMagi:GetCooldown() < GetCurrentGCD() then
        return A.ArcaneSurge
    end

    if A.TouchOfTheMagi:IsReady(player) and 
       (Unit(player):HasBuffs(A.ArcaneSoul.ID) > 0 or A.ArcaneSurge:GetCooldown() > 30) then
        return A.TouchOfTheMagi
    end
end

-- Spellslinger Build Implementation
local function ExecuteSpellslingerST(unitID)
    local currentCharges = Player:ArcaneCharges()
    local manaPercent = Player:ManaPercentage()
    
    -- Use CDs first
    local cooldown = UseCooldowns(unitID)
    if cooldown then return cooldown end

    -- Shifting Power
    if A.ShiftingPower:IsReady(player) and 
       Unit(player):HasBuffs(A.ArcaneSurge.ID) == 0 and 
       Unit(player):HasBuffs(A.SiphonStorm.ID) == 0 and 
       Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) == 0 and 
       A.Evocation:GetCooldown() > 15 and 
       A.TouchOfTheMagi:GetCooldown() > 10 then
        return A.ShiftingPower
    end

    -- Presence of Mind with Nether Precision
    if A.PresenceOfMind:IsReady(player) and 
       Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) <= GetCurrentGCD() and 
       Unit(player):HasBuffs(A.NetherPrecision.ID) > 0 then
        return A.PresenceOfMind
    end

    -- Arcane Barrage Conditions
    if A.ArcaneBarrage:IsReady(unitID) then
        if (Unit(player):HasBuffs(A.NetherPrecision.ID) == 1 and Player:PrevGCD(1, A.ArcaneBlast)) or
           A.TouchOfTheMagi:IsReady(player) or
           (A.ArcaneTempo:IsTalentLearned() and Unit(player):HasBuffs(A.ArcaneTempo.ID) < GetCurrentGCD()) then
            return A.ArcaneBarrage
        end
    end

    -- Arcane Missiles Management
    if A.ArcaneMissiles:IsReady(unitID) then
        if (Unit(player):HasBuffs(A.Clearcasting.ID) > 0 and Unit(player):HasBuffs(A.NetherPrecision.ID) == 0) or
           Unit(player):HasBuffsStacks(A.Clearcasting.ID) == 3 then
            return A.ArcaneMissiles
        end
    end

    -- Arcane Orb for Charge Generation
    if A.ArcaneOrb:IsReady(player) and currentCharges < 2 then
        return A.ArcaneOrb
    end

    -- Default Filler
    if A.ArcaneBlast:IsReady(unitID) then
        return A.ArcaneBlast
    end
end

-- Spellslinger AOE Implementation
local function ExecuteSpellslingerAOE(unitID)
    local currentCharges = Player:ArcaneCharges()
    local activeEnemies = MultiUnits:GetActiveEnemies()

    -- Use CDs first
    local cooldown = UseCooldowns(unitID)
    if cooldown then return cooldown end

    -- Arcane Orb for Multiple Targets
    if A.ArcaneOrb:IsReady(player) and currentCharges < 3 then
        return A.ArcaneOrb
    end

    -- Arcane Explosion at low charges or with Reverberate
    if A.ArcaneExplosion:IsReady(player) and 
       (A.Reverberate:IsTalentLearned() or currentCharges < 1) then
        return A.ArcaneExplosion
    end

    -- Clearcasting Missiles
    if A.ArcaneMissiles:IsReady(unitID) and Unit(player):HasBuffs(A.Clearcasting.ID) > 0 and 
       ((A.HighVoltage:IsTalentLearned() and currentCharges < 4) or Unit(player):HasBuffs(A.NetherPrecision.ID) == 0) then
        return A.ArcaneMissiles
    end

    -- Arcane Barrage at max charges
    if A.ArcaneBarrage:IsReady(unitID) and currentCharges == 4 then
        return A.ArcaneBarrage
    end

    -- Arcane Blast with Magi's Spark
    if A.ArcaneBlast:IsReady(unitID) and Unit(target):HasDeBuffs(A.MagisSpark.ID) > 0 then
        return A.ArcaneBlast
    end
end

-- Sunfury Build Implementation
local function ExecuteSunfuryST(unitID)
    local currentCharges = Player:ArcaneCharges()
    local manaPercent = Player:ManaPercentage()
    
    -- Use CDs first
    local cooldown = UseCooldowns(unitID)
    if cooldown then return cooldown end

    -- Shifting Power Usage
    if A.ShiftingPower:IsReady(player) and
       Unit(player):HasBuffs(A.ArcaneSurge.ID) == 0 and
       Unit(player):HasBuffs(A.ArcaneSoul.ID) == 0 then
        return A.ShiftingPower
    end

    -- Arcane Barrage Conditions
    if A.ArcaneBarrage:IsReady(unitID) and currentCharges == 4 then
        if Unit(player):HasBuffs(A.BurdenOfPower.ID) > 0 or
           Unit(player):HasBuffs(A.GloriousIncandescence.ID) > 0 then
            return A.ArcaneBarrage
        end
    end

    -- Arcane Missiles Management
    if A.ArcaneMissiles:IsReady(unitID) and Unit(player):HasBuffs(A.Clearcasting.ID) > 0 then
        if Unit(player):HasBuffs(A.NetherPrecision.ID) == 0 or
           Unit(player):HasBuffsStacks(A.Clearcasting.ID) == 3 then
            return A.ArcaneMissiles
        end
    end

    -- Arcane Orb Usage
    if A.ArcaneOrb:IsReady(player) and currentCharges < 2 then
        return A.ArcaneOrb
    end

    -- Default Filler
    if A.ArcaneBlast:IsReady(unitID) then
        return A.ArcaneBlast
    end
end

local function ExecuteBasicSingleTarget(unitID)
    -- Get basic variables
    local currentCharges = Player:ArcaneCharges()
    local manaPercent = Player:ManaPercentage()
    
    -- Touch of the Magi
    if A.TouchOfTheMagi:IsReady(player) then
        return A.TouchOfTheMagi
    end
    
    -- Arcane Orb at low charges
    if A.ArcaneOrb:IsReady(player) and currentCharges <= 1 then
        return A.ArcaneOrb
    end
    
    -- Arcane Missiles with Clearcasting
    if A.ArcaneMissiles:IsReady(unitID) and Unit(player):HasBuffs(A.Clearcasting.ID) > 0 then
        return A.ArcaneMissiles
    end
    
    -- Spend at 4 charges or if low mana
    if currentCharges == 4 or manaPercent < 15 then
        if A.ArcaneBarrage:IsReady(unitID) then
            return A.ArcaneBarrage
        end
    end
    
    -- Builder
    if A.ArcaneBlast:IsReady(unitID) then
        return A.ArcaneBlast
    end
    
    -- Emergency Barrage if nothing else is available
    if A.ArcaneBarrage:IsReady(unitID) then
        return A.ArcaneBarrage
    end
end

local function ExecuteBasicAOE(unitID)
    -- Get basic variables
    local currentCharges = Player:ArcaneCharges()
    local activeEnemies = MultiUnits:GetActiveEnemies()
    
    -- Touch of the Magi
    if A.TouchOfTheMagi:IsReady(player) then
        return A.TouchOfTheMagi
    end
    
    -- Arcane Orb for AOE and charges
    if A.ArcaneOrb:IsReady(player) and currentCharges <= 2 then
        return A.ArcaneOrb
    end
    
    -- Spend charges with Arcane Barrage
    if currentCharges == 4 then
        if A.ArcaneBarrage:IsReady(unitID) then
            return A.ArcaneBarrage
        end
    end
    
    -- Arcane Explosion for AOE damage
    if A.ArcaneExplosion:IsReady(player) then
        return A.ArcaneExplosion
    end
    
    -- Build with Blast if out of range or low enemy count
    if A.ArcaneBlast:IsReady(unitID) and (not InMeleeRange(unitID) or activeEnemies <= 2) then
        return A.ArcaneBlast
    end
end

-- Main Rotation Function
A[3] = function(icon)
    -- Basic Variables
    local isMoving = Player:IsMoving()
    local inCombat = Unit(player):CombatTime() > 0
    local manaPercent = Player:ManaPercentage()

    -- Check for valid target
    if not UnitExists(target) then return end
    if not IsUnitEnemy(target) then return end
    if Unit(target):IsDead() then return end
    
    -- Get current build type
    local isSpellslinger = IsSpellslingerBuild()
    local isSunfury = IsSunfuryBuild()
    local shouldAoE = ShouldAoE()
    
    -- Check defensives
    local defensive = DefensiveCDs()
    if defensive then return defensive:Show(icon) end
    
    -- Check interrupts
    local interrupt = Interrupts(target)
    if interrupt then return interrupt:Show(icon) end
    
    if isSpellslinger then
        if shouldAoE then
            local spell = ExecuteSpellslingerAOE(target)
            if spell then return spell:Show(icon) end
        else
            local spell = ExecuteSpellslingerST(target)
            if spell then return spell:Show(icon) end
        end
    elseif isSunfury then
        if shouldAoE then
            local spell = ExecuteSunfuryAOE(target)
            if spell then return spell:Show(icon) end
        else
            local spell = ExecuteSunfuryST(target)
            if spell then return spell:Show(icon) end
        end
    else
        -- Basic rotation fallback for leveling/no major talents
        if shouldAoE then
            local spell = ExecuteBasicAOE(target)
            if spell then return spell:Show(icon) end
        else
            local spell = ExecuteBasicSingleTarget(target)
            if spell then return spell:Show(icon) end
        end
    end
end

-- Additional Icon Functions
A[4] = nil -- Movement abilities if needed
A[5] = nil -- Additional utilities if needed

-- PvP Functions
A[6] = function(icon)
    if A.IsInPvP then
        -- Add PvP specific logic
    end
end

-- Utility Functions
A[7] = function(icon)
    -- Buffer checks, etc.
    if A.ArcaneIntellect:IsReady(player) then
        for _, unitID in ipairs({"player", "party1", "party2", "party3", "party4"}) do
            if UnitExists(unitID) and Unit(unitID):HasBuffs(A.ArcaneIntellect.ID, true) == 0 then
                return A.ArcaneIntellect:Show(icon)
            end
        end
    end
end

-- Auto-target function
A[8] = function(icon)
    if GetToggle(2, "AutoTarget") and Unit(target):IsEnemy() and Unit(target):GetRange() <= 40 then
        return A:Show(icon, ACTION_CONST_AUTOTARGET)
    end
end