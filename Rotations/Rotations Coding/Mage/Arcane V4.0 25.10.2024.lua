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
local ActiveUnitPlates                  = MultiUnits:GetActiveUnitPlates()

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
    -- Add steroid trinkets directly to Temp
    SteroidTrinkets                         = {
        [220202] = true,  -- Spymaster's Web
        [203963] = true,  -- Beacon to the Beyond
        [194302] = true,  -- Storm-Eater's Boon
        [194308] = true,  -- Manic Grieftorch
        [202610] = true,  -- Dragonfire Bomb Dispenser
        [203729] = true,  -- Ominous Chromatic Essence
        [207167] = true,  -- Ashes of the Embersoul
        [110999] = true,  -- Witherbark's Branch
    },
}

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
    ShiftingPower                   = Action.Create({ Type = "Spell", ID = 382440   }),
    
    -- Arcane Specific Spells
    ArcaneBlast                     = Action.Create({ Type = "Spell", ID = 30451    }),
    ArcaneBarrage                   = Action.Create({ Type = "Spell", ID = 44425    }),
    ArcaneMissiles                  = Action.Create({ Type = "Spell", ID = 5143     }),
    TouchOfTheMagi                  = Action.Create({ Type = "Spell", ID = 321507   }),
    ArcaneSurge                     = Action.Create({ Type = "Spell", ID = 365350   }),
    ArcaneExplosion                 = Action.Create({ Type = "Spell", ID = 1449     }),
    ArcaneOrb                       = Action.Create({ Type = "Spell", ID = 153626   }),
    PresenceOfMind                  = Action.Create({ Type = "Spell", ID = 205025   }),
    DragonBreath                    = Action.Create({ Type = "Spell", ID = 31661    }),
    Supernova                       = Action.Create({ Type = "Spell", ID = 157980   }), 
    
    -- Talents and Their Effects
    SpellSlinger                    = Action.Create({ Type = "Spell", ID = 443739, Hidden = true, isTalent = true }),
    SunFury                         = Action.Create({ Type = "Spell", ID = 448601, Hidden = true, isTalent = true }),
    ArcingCleave                    = Action.Create({ Type = "Spell", ID = 231564, Hidden = true, isTalent = true }),
    SpellfireSpheres                = Action.Create({ Type = "Spell", ID = 448601, Hidden = true, isTalent = true }),
    ShiftingShards                  = Action.Create({ Type = "Spell", ID = 444675, Hidden = true, isTalent = true }),
    OrbBarrage                      = Action.Create({ Type = "Spell", ID = 384858, Hidden = true, isTalent = true }),
    Impetus                         = Action.Create({ Type = "Spell", ID = 383676, Hidden = true, isTalent = true }),
    UnerringProficiency             = Action.Create({ Type = "Spell", ID = 444974, Hidden = true, isTalent = true }),
    ArcaneTempo                     = Action.Create({ Type = "Spell", ID = 383980, Hidden = true, isTalent = true }),
    AetherAttunement                = Action.Create({ Type = "Spell", ID = 453600, Hidden = true, isTalent = true }),
    Reverberate                     = Action.Create({ Type = "Spell", ID = 281482, Hidden = true, isTalent = true }),
    RadiantSpark                    = Action.Create({ Type = "Spell", ID = 307443, Hidden = true, isTalent = true }),
    Enlightened                     = Action.Create({ Type = "Spell", ID = 321387, Hidden = true, isTalent = true }),
    HighVoltage                     = Action.Create({ Type = "Spell", ID = 461248, Hidden = true, isTalent = true }),
    ArcaneBombardment               = Action.Create({ Type = "Spell", ID = 384581, Hidden = true, isTalent = true }), 
    Aethervision                    = Action.Create({ Type = "Spell", ID = 467633, Hidden = true }),
    
    -- Important Effect IDs (not duplicating spells)
    NetherPrecision                 = Action.Create({ Type = "Spell", ID = 383782, Hidden = true }),
    Clearcasting                    = Action.Create({ Type = "Spell", ID = 276743, Hidden = true }),
    ArcaneSoul                      = Action.Create({ Type = "Spell", ID = 451038, Hidden = true }),
    MagisSpark                      = Action.Create({ Type = "Spell", ID = 454016, Hidden = true }),
    BurdenOfPower                   = Action.Create({ Type = "Spell", ID = 451035, Hidden = true }),
    GloriousIncandescence           = Action.Create({ Type = "Spell", ID = 449394, Hidden = true }),
    Leydrinker                      = Action.Create({ Type = "Spell", ID = 452196, Hidden = true }),
    Intuition                       = Action.Create({ Type = "Spell", ID = 455681, Hidden = true }),
    SiphonStorm                     = Action.Create({ Type = "Spell", ID = 384187, Hidden = true }),
    ArcaneCharges                   = Action.Create({ Type = "Spell", ID = 36032, Hidden = true }),

    --Racials
    QuakingPalm                     = Action.Create({ Type = "Spell", ID = 107079   }),
    WarStomp                        = Action.Create({ Type = "Spell", ID = 20549    }),  
    BullRush                        = Action.Create({ Type = "Spell", ID = 255654   }), 
    
    -- Items
    TreacherousTransmitter          = Action.Create({ Type = "Item", ID = 221023 }),
    SpymastersWeb                   = Action.Create({ Type = "Item", ID = 220202 }),
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


local function InMeleeRange(unitID)
    -- Melee range for ArcaneExplosion is 8 yards
    return Unit(unitID):GetRange() <= 8
end
InMeleeRange = Action.MakeFunctionCachedDynamic(InMeleeRange)

local function countInterruptGCD(unitID)
    if not A.Counterspell:IsReadyByPassCastGCD(unitID) or not A.Counterspell:AbsentImun(unitID, Temp.TotalAndMagKick, true) then 
        return true
    end
end

local function GetLatency()
    return Action.GetLatency()
end

local function SafeSpellCheck(spell, unitID)
    if not spell then return false end
    return spell:IsReady(unitID)
end

local function GetEnemyCount()
    local count = 0
    for unitID in pairs(ActiveUnitPlates) do
        if InRange(unitID) and not Unit(unitID):IsDead() then
            count = count + 1
        end
    end
    return count
end

local function ShouldSaveResources()
    return Player:ManaPercentage() < GetToggle(2, "OffensiveRage")
end

-- Core Helper Functions

local function GetToggleValue(category, value, default)
    local toggle = GetToggle(category, value)
    if toggle == nil then
        return default
    end
    return toggle
end

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

local function GetKalyzInterruptPriority(spellID)
    local kalyzList = Factory[4].KalyzInterrupts[GameLocale]
    if kalyzList and kalyzList[spellID] then
        return kalyzList[spellID]
    end
    return nil
end

local function InFlightRemains(spell)
    -- Implement flight time tracking for spells
    return 0.5 -- Default value, needs proper implementation
end

local function GetExecuteTime(spell)
    if not spell then return 0 end  -- If the spell is nil, return 0 as execute time

    -- Get the base cast time of the spell
    local castTime = select(4, GetSpellInfo(spell.ID)) or 0

    -- If the spell is instant, cast time is effectively 0
    if castTime == 0 then
        return 0
    end

    -- Get the player latency, which affects the total execute time
    local latency = GetLatency() or 0

    -- Adjust cast time to seconds from milliseconds
    castTime = castTime / 1000

    -- Calculate total execute time by adding latency
    local executeTime = castTime + (latency / 1000)

    return executeTime
end

local function ShouldInterruptChannel(spell)
    return Player:IsChanneling() and 
           ((spell.TickTime > GetCurrentGCD() and Unit(player):HasBuffs(A.AetherAttunement.ID) == 0) or
            Unit(player):HasBuffs(A.ArcaneSoul.ID) > 0)
end

local function IsMissileClipTime()
    return Player:IsChanneling(A.ArcaneMissiles.ID) and 
           Player:ChannelTimeRemains() > GetCurrentGCD() and 
           Unit(player):HasBuffs(A.AetherAttunement.ID) == 0
end

local function GetFightRemains()
    -- For bosses/long fights
    if Unit(target):IsBoss() then
        return 300 -- Default to 5 minutes for bosses
    end
    return Unit(target):TimeToDie()
end

local function ExecuteCondition(unitID)
    return Unit(unitID):HealthPercent() < 35 and A.ArcaneBombardment:IsTalentLearned()
end

local function IsSteroidTrinket(trinketID)
    return Temp.SteroidTrinkets[trinketID] or false
end

-- Defensives
local function DefensiveCDs()
    if Unit(player):CombatTime() == 0 then return false end
    
    local playerHP = Unit(player):HealthPercent()
    
    if GetToggle(2, "IceBlockHP") and playerHP <= GetToggle(2, "IceBlockHP") and A.IceBlock:IsReady(player) then
        return A.IceBlock
    end
    
    if GetToggle(2, "IceBarrierHP") and playerHP <= GetToggle(2, "IceBarrierHP") and A.IceBarrier:IsReady(player) then
        return A.IceBarrier
    end
    
    if GetToggle(2, "AlterTimeHP") and playerHP <= GetToggle(2, "AlterTimeHP") and A.AlterTime:IsReady(player) then
        return A.AlterTime
    end
end

local function Interrupts(unitID)
    if not GetToggle(2, "UseInterrupts") then return false end
    
    local useKalyz = GetToggle(2, "KalyzInterrupts")
    local useKick, useCC, useRacial, notInterruptable, castRemainsTime
    
    if useKalyz and (IsInRaid() or A.InstanceInfo.KeyStone > 1) then
        useKick, useCC, useRacial, notInterruptable, castRemainsTime = Action.InterruptIsValid(unitID, "KalyzInterrupts", true, countInterruptGCD(unitID))
    else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime = Action.InterruptIsValid(unitID, nil, nil, countInterruptGCD(unitID))
    end
    
    if castRemainsTime >= GetLatency() then
        -- Kick
        if useKick and not notInterruptable and A.Counterspell:IsReady(unitID) and A.Counterspell:AbsentImun(unitID, Temp.TotalAndMagKick, true) then
            return A.Counterspell
        end
        
        -- Dragon's Breath as CC
        if useCC and A.DragonBreath:IsReady(unitID) and A.DragonBreath:AbsentImun(unitID, Temp.TotalAndPhysAndCC, true) then
            return A.DragonBreath
        end
        
        -- Racial Interrupts
        if useRacial then
            if A.QuakingPalm:AutoRacial(unitID) then
                return A.QuakingPalm
            end
            
            if A.WarStomp:AutoRacial(unitID) then
                return A.WarStomp
            end
            
            if A.BullRush:AutoRacial(unitID) then
                return A.BullRush
            end
            
            if A.ArcaneTorrent:AutoRacial(unitID) then
                return A.ArcaneTorrent
            end
        end
    end
    return false
end

-- Rotation Variables
local function RotationVariables()
    -- Basic variables
    local opener = 1
    local aoeTargetCount = (not A.ArcingCleave:IsTalentLearned() and 9 or 2)
    local sunfuryAoeList = 0
    
    -- Trinket checks
    local steroidTrinketEquipped = false
    if A.Trinket1.ID and Temp.SteroidTrinkets[A.Trinket1.ID] then
        steroidTrinketEquipped = true
    elseif A.Trinket2.ID and Temp.SteroidTrinkets[A.Trinket2.ID] then
        steroidTrinketEquipped = true
    end
    
    -- Double on-use check
    local transmitterDoubleOnUse = steroidTrinketEquipped and A.TreacherousTransmitter:IsEquipped()
    
    -- Enemy count
    local activeEnemies = MultiUnits:GetActiveEnemies()
    
    return {
        opener = opener,
        aoeTargetCount = aoeTargetCount,
        sunfuryAoeList = sunfuryAoeList,
        steroidTrinketEquipped = steroidTrinketEquipped,
        transmitterDoubleOnUse = transmitterDoubleOnUse,
        activeEnemies = activeEnemies,
    }
end

local function ShouldSaveForCooldowns()
    return A.TouchOfTheMagi:GetCooldown() < 6 or 
           A.ArcaneSurge:GetCooldown() < GetCurrentGCD() * 3
end

local function HasAnyMajorCooldown()
    return Unit(player):HasBuffs(A.ArcaneSurge.ID) > 0 or
           Unit(player):HasBuffs(A.SiphonStorm.ID) > 0 or
           Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) > 0 or
           Unit(player):HasBuffs(A.ArcaneSoul.ID) > 0
end

-- CD Opener Sequence Implementation
local function ExecuteCDOpener(unitID)
    local vars = RotationVariables()
    
    -- Touch of the Magi conditions from SimC
    if A.TouchOfTheMagi:IsReady(player) and 
        (Player:PrevGCD(1, A.ArcaneBarrage) and
        (GetCurrentGCD() <= 0.5) and
        (Unit(player):HasBuffs(A.ArcaneSurge.ID) > 0 or A.ArcaneSurge:GetCooldown() > 30) or
        (Player:PrevGCD(1, A.ArcaneSurge) and Player:ArcaneCharges() < 4)) then
        return A.TouchOfTheMagi
    end
    
    -- Arcane Blast with PresenceOfMind
    if A.ArcaneBlast:IsReady(unitID) and Unit(player):HasBuffs(A.PresenceOfMind.ID) > 0 then
        return A.ArcaneBlast
    end
    
    -- High Voltage Orb usage in opener
    if A.ArcaneOrb:IsReady(player) and A.HighVoltage:IsTalentLearned() and vars.opener == 1 then
        return A.ArcaneOrb
    end
    
    -- Evocation timing
    if A.Evocation:IsReady(player) and 
       A.ArcaneSurge:GetCooldown() < (GetCurrentGCD() * 3) and 
       A.TouchOfTheMagi:GetCooldown() < (GetCurrentGCD() * 5) then
        return A.Evocation
    end
    
    -- Arcane Missiles in opener
    if A.ArcaneMissiles:IsReady(unitID) and vars.opener == 1 then
        return A.ArcaneMissiles
    end
    
    -- Arcane Surge timing
    if A.ArcaneSurge:IsReady(player) and 
    A.TouchOfTheMagi:GetCooldown() < (A.ArcaneSurge:GetCooldown() + (GetCurrentGCD() * (Player:ArcaneCharges() == 4 and 1 or 0))) then
        return A.ArcaneSurge
    end
end

-- Spellslinger Single Target Implementation
local function ExecuteSpellslinger(unitID)
    local vars = RotationVariables()
    
    -- Shifting Power usage
    if A.ShiftingPower:IsReady(player) and (
        (Unit(player):HasBuffs(A.ArcaneSurge.ID) == 0 and 
        Unit(player):HasBuffs(A.SiphonStorm.ID) == 0 and 
        Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) == 0 and 
        A.Evocation:GetCooldown() > 15 and 
        A.TouchOfTheMagi:GetCooldown() > 10 and 
        not A.ArcaneOrb:IsReady(player)) or 
        (Player:PrevGCD(1, A.ArcaneBarrage) and 
        A.ShiftingShards:IsTalentLearned() and 
        (Unit(player):HasBuffs(A.ArcaneSurge.ID) > 0 or 
        Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) > 0 or 
        A.Evocation:GetCooldown() < 20))) then
        return A.ShiftingPower
    end
    
    -- Cancel PresenceOfMind logic
    if Player:PrevGCD(1, A.ArcaneBlast) and Unit(player):HasBuffsStacks(A.PresenceOfMind.ID) == 1 then
        -- Note: Cancel aura logic would go here if supported
    end
    
    -- PresenceOfMind usage
    if A.PresenceOfMind:IsReady(player) and
       Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) <= GetCurrentGCD() and
       Unit(player):HasBuffs(A.NetherPrecision.ID) > 0 and
       vars.activeEnemies < vars.aoeTargetCount and
       not A.UnerringProficiency:IsTalentLearned() then
        return A.PresenceOfMind
    end
    
    -- Supernova usage
    if A.Supernova:IsReady(player) and
       Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) <= GetCurrentGCD() and
       Unit(player):HasBuffsStacks(A.UnerringProficiency.ID) == 30 then
        return A.Supernova
    end
    
    -- Complex Arcane Barrage conditions
    if A.ArcaneBarrage:IsReady(unitID) and (
        A.TouchOfTheMagi:GetCooldown() == 0 or
        (A.ArcaneTempo:IsTalentLearned() and Unit(player):HasBuffs(A.ArcaneTempo.ID) < GetCurrentGCD()) or
        ((Unit(player):HasBuffsStacks(A.Aethervision.ID) == 2 or Unit(player):HasBuffs(A.Intuition.ID) > 0) and
         (Unit(player):HasBuffs(A.NetherPrecision.ID) > 0 or
          (Unit(unitID):HealthPercent() < 35 and A.ArcaneBombardment:IsTalentLearned() and Unit(player):HasBuffs(A.Clearcasting.ID) == 0) or
          (Player:ManaPercentage() < 70 and A.Enlightened:IsTalentLearned() and Unit(player):HasBuffs(A.Clearcasting.ID) == 0 and Unit(player):HasBuffs(A.ArcaneSurge.ID) == 0))) or
        (A.ArcaneOrb:IsReady(player) and Player:ArcaneCharges() == 4 and Unit(player):HasBuffsStacks(A.Clearcasting.ID) == 0 and Unit(player):HasBuffs(A.NetherPrecision.ID) == 0 and A.OrbBarrage:IsTalentLearned())) then
        return A.ArcaneBarrage
    end

    -- Arcane Missiles usage
    if A.ArcaneMissiles:IsReady(unitID) and
       ((Unit(player):HasBuffs(A.Clearcasting.ID) > 0 and Unit(player):HasBuffs(A.NetherPrecision.ID) == 0) or
        Unit(player):HasBuffsStacks(A.Clearcasting.ID) == 3) then
        return A.ArcaneMissiles
    end
    
    -- Arcane Orb for charge building
    if A.ArcaneOrb:IsReady(player) and Player:ArcaneCharges() < 2 then
        return A.ArcaneOrb
    end
    
    -- Default to Arcane Blast
    if A.ArcaneBlast:IsReady(unitID) then
        return A.ArcaneBlast
    end
    
    -- Final fallback
    if A.ArcaneBarrage:IsReady(unitID) then
        return A.ArcaneBarrage
    end
end

-- Spellslinger AoE Implementation
local function ExecuteSpellslingerAOE(unitID)
    local vars = RotationVariables()
    
    -- Supernova at max stacks
    if A.Supernova:IsReady(player) and Unit(player):HasBuffsStacks(A.UnerringProficiency.ID) == 30 then
        return A.Supernova
    end
    
    -- Shifting Power with Shifting Shards logic
    if A.ShiftingPower:IsReady(player) and (
        (Unit(player):HasBuffs(A.ArcaneSurge.ID) == 0 and 
        Unit(player):HasBuffs(A.SiphonStorm.ID) == 0 and 
        Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) == 0 and 
        A.Evocation:GetCooldown() > 15 and 
        A.TouchOfTheMagi:GetCooldown() > 10 and 
        A.ArcaneOrb:GetCooldown() > 0 and 
        not A.ArcaneOrb:IsReady(player)) or
        (Player:PrevGCD(1, A.ArcaneBarrage) and 
        (Unit(player):HasBuffs(A.ArcaneSurge.ID) > 0 or 
        Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) > 0 or 
        A.Evocation:GetCooldown() < 20) and 
        A.ShiftingShards:IsTalentLearned())) then
        return A.ShiftingPower
    end
    
    -- Arcane Orb for charge generation
    if A.ArcaneOrb:IsReady(player) and Player:ArcaneCharges() < 3 then
        return A.ArcaneOrb
    end
    
    -- Arcane Blast with Magi's Spark or Leydrinker
    if A.ArcaneBlast:IsReady(unitID) and 
       ((Unit(target):HasDeBuffs(A.MagisSpark.ID) > 0 or Unit(player):HasBuffs(A.Leydrinker.ID) > 0) and 
       not Player:PrevGCD(1, A.ArcaneBlast)) then
        return A.ArcaneBlast
    end
    
    -- Arcane Barrage with High Voltage and Aether Attunement
    if A.ArcaneBarrage:IsReady(unitID) and 
       Unit(player):HasBuffs(A.AetherAttunement.ID) > 0 and 
       A.HighVoltage:IsTalentLearned() and 
       Unit(player):HasBuffs(A.Clearcasting.ID) > 0 and 
       Player:ArcaneCharges() > 1 then
        return A.ArcaneBarrage
    end
    
    -- Arcane Missiles with High Voltage or Nether Precision conditions
    if A.ArcaneMissiles:IsReady(unitID) and 
       Unit(player):HasBuffs(A.Clearcasting.ID) > 0 and 
       ((A.HighVoltage:IsTalentLearned() and Player:ArcaneCharges() < 4) or 
        Unit(player):HasBuffs(A.NetherPrecision.ID) == 0) then
        return A.ArcaneMissiles
    end
    
    -- Presence of Mind at low charges
    if A.PresenceOfMind:IsReady(player) and 
       (Player:ArcaneCharges() == 3 or Player:ArcaneCharges() == 2) then
        return A.PresenceOfMind
    end
    
    -- Arcane Barrage at max charges
    if A.ArcaneBarrage:IsReady(unitID) and Player:ArcaneCharges() == 4 then
        return A.ArcaneBarrage
    end
    
    -- Arcane Explosion conditions
    if A.ArcaneExplosion:IsReady(player) and 
       (A.Reverberate:IsTalentLearned() or Player:ArcaneCharges() < 1) then
        return A.ArcaneExplosion
    end
    
    -- Default to Arcane Blast
    if A.ArcaneBlast:IsReady(unitID) then
        return A.ArcaneBlast
    end
end

-- Sunfury Single Target Implementation
local function ExecuteSunfury(unitID)
    local vars = RotationVariables()
    
    -- Shifting Power without cooldowns
    if A.ShiftingPower:IsReady(player) and 
       Unit(player):HasBuffs(A.ArcaneSurge.ID) == 0 and 
       Unit(player):HasBuffs(A.SiphonStorm.ID) == 0 and 
       Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) == 0 and 
       A.Evocation:GetCooldown() > 15 and 
       A.TouchOfTheMagi:GetCooldown() > 10 and 
       Unit(player):HasBuffs(A.ArcaneSoul.ID) == 0 then
        return A.ShiftingPower
    end
    
    -- Cancel Presence of Mind logic
    if (Player:PrevGCD(1, A.ArcaneBlast) and Unit(player):HasBuffsStacks(A.PresenceOfMind.ID) == 1) or 
       vars.activeEnemies < 4 then
        -- Note: Cancel aura logic would go here if supported
    end
    
    -- Presence of Mind usage
    if A.PresenceOfMind:IsReady(player) and 
       Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) <= GetCurrentGCD() and 
       Unit(player):HasBuffs(A.NetherPrecision.ID) > 0 and 
       vars.activeEnemies < 4 then
        return A.PresenceOfMind
    end
    
    -- Complex Arcane Barrage conditions
    if A.ArcaneBarrage:IsReady(unitID) then
        -- AOE funnel conditions
        if (Player:ArcaneCharges() == 4 and Unit(player):HasBuffs(A.BurdenOfPower.ID) == 0 and 
            Unit(player):HasBuffs(A.NetherPrecision.ID) > 0 and vars.activeEnemies > 2 and 
            ((A.ArcaneBombardment:IsTalentLearned() and Unit(unitID):HealthPercent() < 35) or vars.activeEnemies > 4) and 
            A.ArcingCleave:IsTalentLearned() and 
            ((A.HighVoltage:IsTalentLearned() and Unit(player):HasBuffs(A.Clearcasting.ID) > 0) or 
            (A.ArcaneOrb:IsReady(player) or A.ArcaneOrb:GetCooldown() < GetCurrentGCD()))) then
            return A.ArcaneBarrage
        end
        
        -- Aether Attunement conditions
        if Unit(player):HasBuffs(A.AetherAttunement.ID) > 0 and 
        A.HighVoltage:IsTalentLearned() and 
        Unit(player):HasBuffs(A.Clearcasting.ID) > 0 and 
        Player:ArcaneCharges() > 1 and 
        vars.activeEnemies > 2 then
            return A.ArcaneBarrage
        end
    end
    
    -- Arcane Missiles with Soul
    if A.ArcaneMissiles:IsReady(unitID) and 
       Unit(player):HasBuffs(A.NetherPrecision.ID) == 0 and 
       Unit(player):HasBuffs(A.Clearcasting.ID) > 0 and 
       Unit(player):HasBuffs(A.ArcaneSoul.ID) > 0 and 
       Unit(player):HasBuffs(A.ArcaneSoul.ID) > GetCurrentGCD() * (4 - Unit(player):HasBuffsStacks(A.Clearcasting.ID)) then
        return A.ArcaneMissiles
    end
    
    -- More Arcane Missiles conditions
    if A.ArcaneMissiles:IsReady(unitID) and 
       Unit(player):HasBuffs(A.Clearcasting.ID) > 0 and 
       (Unit(player):HasBuffs(A.NetherPrecision.ID) == 0 or 
        Unit(player):HasBuffsStacks(A.Clearcasting.ID) == 3 or 
        (A.HighVoltage:IsTalentLearned() and Player:ArcaneCharges() < 3)) then
        return A.ArcaneMissiles
    end
    
    -- Presence of Mind in AOE
    if A.PresenceOfMind:IsReady(player) and 
       (Player:ArcaneCharges() == 3 or Player:ArcaneCharges() == 2) and 
       vars.activeEnemies >= 3 then
        return A.PresenceOfMind
    end
    
    -- Arcane Explosion conditions
    if A.ArcaneExplosion:IsReady(player) and 
       (A.Reverberate:IsTalentLearned() or Player:ArcaneCharges() < 1) and 
       vars.activeEnemies >= 4 then
        return A.ArcaneExplosion
    end
    
    -- Default to Arcane Blast
    if A.ArcaneBlast:IsReady(unitID) then
        return A.ArcaneBlast
    end
end

-- Main Rotation Function
A[3] = function(icon)
    -- Basic Variables
    local vars = RotationVariables()
    
    -- Check valid target
    if not UnitExists(target) or Unit(target):IsDead() then return end
    if not IsUnitEnemy(target) then return end
    
    -- Fight remains check
    if Unit(target):TimeToDie() < 2 and A.ArcaneBarrage:IsReady(target) then
        return A.ArcaneBarrage:Show(icon)
    end
    
    -- Check defensives
    local defensive = DefensiveCDs()
    if defensive then return defensive:Show(icon) end
    
    -- Check interrupts
    local interrupt = Interrupts(target)
    if interrupt then return interrupt:Show(icon) end
    
    -- Reset opener variable
    if Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) > 0 and vars.opener == 1 then
        vars.opener = 0
    end
    
    -- Execute rotation based on conditions
    local spell
    
    -- CD Opener sequence
    spell = ExecuteCDOpener(target)
    if spell then return spell:Show(icon) end
    
    -- Check for Sunfury AOE
    if A.SpellfireSpheres:IsTalentLearned() and vars.sunfuryAoeList then
        spell = ExecuteSunfuryAOE(target)
        if spell then return spell:Show(icon) end
    end
    
    -- Check for Spellslinger AOE
    if vars.activeEnemies >= (vars.aoeTargetCount + (A.Impetus:IsTalentLearned() and 1 or 0)) and 
       not A.SpellfireSpheres:IsTalentLearned() then
        spell = ExecuteSpellslingerAOE(target)
        if spell then return spell:Show(icon) end
    end
    
    -- Check for Sunfury ST
    if A.SpellfireSpheres:IsTalentLearned() then
        spell = ExecuteSunfury(target)
        if spell then return spell:Show(icon) end
    end
    
    -- Default to Spellslinger ST
    if not A.SpellfireSpheres:IsTalentLearned() then
        spell = ExecuteSpellslinger(target)
        if spell then return spell:Show(icon) end
    end
    
    -- Final fallback
    if A.ArcaneBarrage:IsReady(target) then
        return A.ArcaneBarrage:Show(icon)
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