local _G, setmetatable, pairs, type, math    = _G, setmetatable, pairs, type, math
local math_random                            = math.random

local TMW                                     = _G.TMW

local Action                                = _G.Action

local CONST                                 = Action.Const
local Listener                                 = Action.Listener
local Create                                 = Action.Create
local GetToggle                                = Action.GetToggle
local SetToggle                                = Action.SetToggle
local GetLatency                            = Action.GetLatency
local GetGCD                                = Action.GetGCD
local GetCurrentGCD                            = Action.GetCurrentGCD
local BurstIsON                                = Action.BurstIsON
local AuraIsValid                            = Action.AuraIsValid
local AuraIsValidByPhialofSerenity            = Action.AuraIsValidByPhialofSerenity
local InterruptIsValid                        = Action.InterruptIsValid
local Print                                    = Action.Print
local toStr                                    = Action.toStr

local EnemyTeam                                = Action.EnemyTeam
local FriendlyTeam                            = Action.FriendlyTeam

local TeamCache                                = Action.TeamCache
local TeamCacheEnemy                        = TeamCache.Enemy
local TeamCacheEnemyIndexToPLAYERs            = TeamCacheEnemy.IndexToPLAYERs

local LoC                                     = Action.LossOfControl
local Player                                = Action.Player
local MultiUnits                            = Action.MultiUnits
local UnitCooldown                            = Action.UnitCooldown
local Unit                                    = Action.Unit
local IsUnitEnemy                            = Action.IsUnitEnemy
local ActiveUnitPlates                        = MultiUnits:GetActiveUnitPlates()

local ShouldDisarm                            = Action.ShouldDisarm
local ShouldSpellReflect                    = Action.ShouldSpellReflect
local ShouldDuel                            = Action.ShouldDuel
local ProtectTeammate                        = Action.ProtectTeammate
local ShouldWarBanner                        = Action.ShouldWarBanner
local HasPriest                                = Action.HasPriest

local IntervenePvP                            = Action.IntervenePvP

local ACTION_CONST_WARRIOR_ARMS                = CONST.WARRIOR_ARMS
local ACTION_CONST_AUTOTARGET                = CONST.AUTOTARGET
local ACTION_CONST_SPELLID_FREEZING_TRAP    = CONST.SPELLID_FREEZING_TRAP
local ACTION_CONST_CACHE_DEFAULT_TIMER        = _G.ACTION_CONST_CACHE_DEFAULT_TIMER


local IsIndoors, UnitIsUnit, UnitIsPlayer    = _G.IsIndoors, _G.UnitIsUnit, _G.UnitIsPlayer

Action[ACTION_CONST_WARRIOR_ARMS] = {
    -- Racial
    ArcaneTorrent                             = Create({ Type = "Spell", ID = 50613                                                                        }),
    BloodFury                                 = Create({ Type = "Spell", ID = 20572                                                                        }),
    Fireblood                                   = Create({ Type = "Spell", ID = 265221                                                                        }),
    AncestralCall                              = Create({ Type = "Spell", ID = 274738                                                                        }),
    Berserking                                = Create({ Type = "Spell", ID = 26297                                                                        }),
    ArcanePulse                                  = Create({ Type = "Spell", ID = 260364                                                                        }),
    QuakingPalm                                  = Create({ Type = "Spell", ID = 107079                                                                        }),
    Haymaker                                  = Create({ Type = "Spell", ID = 287712                                                                        }),
    WarStomp                                  = Create({ Type = "Spell", ID = 20549                                                                        }),
    BullRush                                  = Create({ Type = "Spell", ID = 255654                                                                        }),
    BagofTricks                               = Create({ Type = "Spell", ID = 312411                                                                        }),
    GiftofNaaru                               = Create({ Type = "Spell", ID = 59544                                                                        }),
    LightsJudgment                               = Create({ Type = "Spell", ID = 255647                                                                        }),
    RocketJump                                = Create({ Type = "Spell", ID = 69070                                                                        }),
    Shadowmeld                                  = Create({ Type = "Spell", ID = 58984                                                                        }), -- usable in Action Core
    Stoneform                                  = Create({ Type = "Spell", ID = 20594                                                                        }),
    WilloftheForsaken                          = Create({ Type = "Spell", ID = 7744                                                                        }), -- usable in Action Core
    EscapeArtist                              = Create({ Type = "Spell", ID = 20589                                                                        }), -- usable in Action Core
    EveryManforHimself                          = Create({ Type = "Spell", ID = 59752                                                                        }), -- usable in Action Core
    Regeneratin                                  = Create({ Type = "Spell", ID = 291944                                                                        }), -- not usable in APL but user can Queue it
    -- CrownControl
    IntimidatingShout                        = Create({ Type = "Spell", ID = 5246, isIntimidatingShout = true                                            }),
    StormBoltGreen                              = Create({ Type = "SpellSingleColor", ID = 107570, Color = "GREEN", Desc = "[1] CC", QueueForbidden = true    }),
    Pummel                                    = Create({ Type = "Spell", ID = 6552, isPummel = true                                                        }),
    PummelGreen                                = Create({ Type = "SpellSingleColor", ID = 6552, Color = "GREEN", Desc = "[2] Kick", QueueForbidden = true    }),
    Disarm                                    = Create({ Type = "Spell", ID = 236077, isTalent = true                                                        }),    -- PvP Talent
    PiercingHowl                            = Create({ Type = "Spell", ID = 12323                                                                        }),
    -- Supportive
    Taunt                                      = Create({ Type = "Spell", ID = 355, Desc = "[6] PvP Pets Taunt", QueueForbidden = true                        }),
    BattleShout                                = Create({ Type = "Spell", ID = 6673                                                                        }),
    Duel                                    = Create({ Type = "Spell", ID = 236273, isTalent = true                                                        }),    -- PvP Talent
    -- Self Defensives
    RallyingCry                                = Create({ Type = "Spell", ID = 97462                                                                        }),
    BerserkerRage                            = Create({ Type = "Spell", ID = 18499                                                                        }),
    IgnorePain                                = Create({ Type = "Spell", ID = 190456                                                                        }),
    ShieldBlock                                = Create({ Type = "Spell", ID = 2565                                                                        }),
    SpellReflection                            = Create({ Type = "Spell", ID = 23920                                                                        }),
    DiebytheSword                            = Create({ Type = "Spell", ID = 118038                                                                        }),
    VictoryRush                                = Create({ Type = "Spell", ID = 34428                                                                        }),
    AbyssalHealingPotion                    = Create({ Type = "Item", ID = 301310, QueueForbidden = true                                                }),
    PhialofSerenity                            = Create({ Type = "Item", ID= 177278                                                                        }),
    -- Burst
    Bladestorm                                = Create({ Type = "Spell", ID = 227847                                                                        }),
    
    -- Rotation
    MortalStrike                            = Create({ Type = "Spell", ID = 12294                                                                        }),
    Overpower                                = Create({ Type = "Spell", ID = 7384                                                                        }),
    ColossusSmash                            = Create({ Type = "Spell", ID = 167105                                                                        }),
    Slam                                    = Create({ Type = "Spell", ID = 1464                                                                        }),
    Hamstring                                = Create({ Type = "Spell", ID = 1715                                                                        }),
    ShatteringThrow                            = Create({ Type = "Spell", ID = 64382                                                                        }),
    ShieldSlam                                = Create({ Type = "Spell", ID = 23922                                                                        }),
    HeroicThrow                                = Create({ Type = "Spell", ID = 57755                                                                        }),
    Execute                                    = Create({ Type = "Spell", ID = 163201                                                                        }),
    Whirlwind                                = Create({ Type = "Spell", ID = 1680                                                                        }),
    SweepingStrikes                            = Create({ Type = "Spell", ID = 260708                                                                        }),
    
    -- Talents
    WarMachine                                = Create({ Type = "Spell", ID = 29725, Hidden = true, isTalent = true                                        }), -- Talent 1/1
    SuddenDeath                                = Create({ Type = "Spell", ID = 29725, Hidden = true, isTalent = true                                        }), -- Talent 1/2
    Skullsplitter                            = Create({ Type = "Spell", ID = 260643, isTalent = true                                                        }),    -- Talent 1/3
    DoubleTime                                = Create({ Type = "Spell", ID = 103827, Hidden = true, isTalent = true                                        }), -- Talent 2/1
    ImpendingVictory                        = Create({ Type = "Spell", ID = 202168, isTalent = true                                                        }),    -- Talent 2/2
    StormBolt                                  = Create({ Type = "Spell", ID = 107570, isTalent = true, isStormBolt = true                                    }),    -- Talent 2/3
    Massacre                                = Create({ Type = "Spell", ID = 281001, Hidden = true, isTalent = true                                        }),    -- Talent 3/1
    FervorofBattle                            = Create({ Type = "Spell", ID = 202316, Hidden = true, isTalent = true                                        }), -- Talent 3/2
    Rend                                    = Create({ Type = "Spell", ID = 772, isTalent = true                                                        }),    -- Talent 3/3
    SecondWind                                = Create({ Type = "Spell", ID = 29838, Hidden = true, isTalent = true                                        }), -- Talent 4/1
    BoundingStride                            = Create({ Type = "Spell", ID = 202163, Hidden = true, isTalent = true                                        }), -- Talent 4/2
    DefensiveStance                            = Create({ Type = "Spell", ID = 197690, isTalent = true                                                        }), -- Talent 4/3
    CollateralDamage                        = Create({ Type = "Spell", ID = 334779, Hidden = true, isTalent = true                                        }), -- Talent 5/1
    Warbreaker                                = Create({ Type = "Spell", ID = 262161, isTalent = true                                                        }),    -- Talent 5/2
    Cleave                                    = Create({ Type = "Spell", ID = 845, isTalent = true                                                        }),    -- Talent 5/3
    InForTheKill                            = Create({ Type = "Spell", ID = 248621, isTalent = true                                                        }),    -- Talent 6/1
    Avatar                                    = Create({ Type = "Spell", ID = 107574, isTalent = true                                                        }),    -- Talent 6/2
    DeadlyCalm                                = Create({ Type = "Spell", ID = 262228, isTalent = true                                                        }),    -- Talent 6/3
    AngerManagement                            = Create({ Type = "Spell", ID = 152278, Hidden = true, isTalent = true                                        }), -- Talent 7/1
    Dreadnaught                                = Create({ Type = "Spell", ID = 262150, Hidden = true, isTalent = true                                        }), -- Talent 7/2
    Ravager                                    = Create({ Type = "Spell", ID = 152277, isTalent = true                                                        }),    -- Talent 7/3
    -- PvP Talents
    SharpenBlade                            = Create({ Type = "Spell", ID = 198817, isTalent = true                                                        }),    -- PvP Talent
    WarBanner                                = Create({ Type = "Spell", ID = 236320, isTalent = true                                                        }),    -- PvP Talent
    Overwatch                                = Create({ Type = "Spell", ID = 329035, Hidden = true, isTalent = true                                        }),    -- PvP Talent
    MasterandCommander                        = Create({ Type = "Spell", ID = 235941, Hidden = true, isTalent = true                                        }),    -- PvP Talent
    DeathSentence                            = Create({ Type = "Spell", ID = 198500, Hidden = true, isTalent = true                                        }), -- PvP Talent
    -- Convenant
    SpearofBastion                            = Create({ Type = "Spell", ID = 307865                                                                        }),
    ConquerorsBanner                        = Create({ Type = "Spell", ID = 324143                                                                        }),
    AncientAftershock                        = Create({ Type = "Spell", ID = 325886                                                                        }),
    Condemn                                    = Create({ Type = "Spell", ID = 317349                                                                        }),
    SummonSteward                            = Create({ Type = "Spell", ID = 324739                                                                        }),
    -- Movememnt
    Charge                                    = Create({ Type = "Spell", ID = 100                                                                            }),
    Intervene                                = Create({ Type = "Spell", ID = 3411                                                                        }),
    HeroicLeap                                = Create({ Type = "Spell", ID = 6544                                                                        }),
    -- Buffs
    SuddenDeathBuff                            = Create({ Type = "Spell", ID = 52437, Hidden = true                                                        }),
    -- Debuffs
    DeepWoundsDebuff                        = Create({ Type = "Spell", ID = 262115, Hidden = true                                                        }),
    ColossusSmashDebuff                        = Create({ Type = "Spell", ID = 208086, Hidden = true                                                        }),
    -- Items
    PotionofUnbridledFury                     = Create({ Type = "Potion",  ID = 169299                                                                    }),
    GalecallersBoon                          = Create({ Type = "Trinket", ID = 159614                                                                    }),
    -- Gladiator Badges/Medallions
    SinfulAspirantsMedallion                 = Create({ Type = "Trinket", ID = 184052                                                                    }),
    -- LegendaryPowers
    Unhinged                                                = Create({ Type = "Spell", ID = 335282, Hidden = true                                                        }),
    SignetofTormentedKings          = Create({ Type = "Spell", ID = 335266, Hidden = true                           }),
    -- Soulbinds Conduit
    CrashtheRamparts                        = Create({ Type = "Spell", ID = 335242, Hidden = true                                                        }),
    -- Hidden
    -- Hidden  PvP Stuffs
    BidingShotDebuff                        = Create({ Type = "Spell", ID = 117405, Hidden = true                                                        }),
    ScatterShotDebuff                        = Create({ Type = "Spell", ID = 213691, Hidden = true                                                        }),
    BlindDebuff                                = Create({ Type = "Spell", ID = 2094, Hidden = true                                                            }),
    MindGamesDebuff                            = Create({ Type = "Spell", ID = 323707, Hidden = true                                                        }),
}

--Action:CreateCovenantsFor(ACTION_CONST_WARRIOR_ARMS)
local A = setmetatable(Action[ACTION_CONST_WARRIOR_ARMS], { __index = Action })

local player                                 = "player"
local target                                = "target"
local mouseover                                = "mouseover"
local focus                                    = "focus"

local Temp                                     = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                        = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                 = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMagPhys                            = {"TotalImun", "DamageMagicImun", "DamagePhysImun"},
    DisablePhys                                = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    BerserkerRageLoC                        = {"FEAR", "INCAPACITATE"},
    IsSlotTrinketBlocked                    = {
        [A.GalecallersBoon.ID]                = true,
        [A.SinfulAspirantsMedallion.ID]        = true,
    },
    InterveneInstaIDs                        = {A.BidingShotDebuff.ID, A.ScatterShotDebuff.ID},
    SpellReflectTimer                        = 0,
    CanUseWarBanner                            = false,
    HasPriest                                = false,
}

local partyIDs                                = {
    [1]                                         = { raid = "raid1", party = "party1" },
    [2]                                        = { raid = "raid2", party = "party2" },
    [3]                                        = { raid = "raid3", party = "party3" },
}

-- Buttons
local BurstPhase = {}
local btn_PrepareBurst = false
Action.PrepareBurst = function(self, ...)
    btn_PrepareBurst = not btn_PrepareBurst
    if not btn_PrepareBurst then
        wipe(BurstPhase)
    end
    Print("Prepare  Burst: " .. toStr[btn_PrepareBurst])
end

local btn_ForceBurst = false
Action.ForceBurst = function(self, ...)
    btn_ForceBurst = not btn_ForceBurst
    if not btn_ForceBurst then
        wipe(BurstPhase)
    end
    Print("Force  Burst: " .. toStr[btn_ForceBurst])
end

-- Initialization
Listener:Add("ACTION_EVENT_WARRIOR_SPELL_REFLECT", "UNIT_SPELLCAST_SUCCEEDED", function(...)
        local source, _, spellID = ...
        if source == player and A.SpellReflection.ID == spellID then
            Temp.SpellReflectTimer = (math_random(30, 40) / 100)
        end
        
        if source == player and A.WarBanner.ID == spellID then
            Temp.ShouldWarBanner = false
        end
end)

-- Util functions
local function SpellReflectTimerInit()
    if Temp.SpellReflectTimer == 0 then
        Temp.SpellReflectTimer = (math_random(30, 40) / 100)
    end
end
TMW:RegisterCallback("TMW_ACTION_IS_INITIALIZED", SpellReflectTimerInit)

-- Reset Vars
local function ResetVars()
    if btn_ForceBurst then
        A.ForceBurst("ExecuteProc")
    end
    
    if btn_PrepareBurst then
        A.PrepareBurst("ExecuteProc")
    end
    
    Temp.HasPriest         = false
    Temp.CanUseWarBanner = false
end

TMW:RegisterCallback("TMW_ACTION_ENTERING",                        ResetVars)
TMW:RegisterCallback("TMW_ACTION_IS_INITIALIZED",                ResetVars)
Listener:Add("ACTION_EVENT_WARRIOR", "PLAYER_REGEN_ENABLED",    ResetVars)

function Action:IsSuspended(delay, reset)
    -- @return boolean
    -- Returns true if action should be delayed before use, reset argument is a internal refresh cycle of expiration future time
    if (self.expirationSuspend or 0) + reset <= TMW.time then
        self.expirationSuspend = TMW.time + delay
    end
    
    return self.expirationSuspend > TMW.time
end

local function InMelee(unitID)
    -- @return boolean
    return A.MortalStrike:IsInRange(unitID)
end

local function GetByRange(count, range, isCheckEqual, isCheckCombat)
    -- @return boolean
    local c = 0
    for unitID in pairs(ActiveUnitPlates) do
        if (not isCheckEqual or not UnitIsUnit(target, unitID)) and (not isCheckCombat or Action.Unit(unitID):CombatTime() > 0) and not Action.Unit(unitID):IsExplosives() and not Action.Unit(unitID):IsTotem() then
            if InMelee(unitID) then
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
end
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)

local function GetByRangePvP(count, range)
    -- @return boolean
    local c = 0
    for unitID in pairs(ActiveUnitPlates) do
        if UnitIsPlayer(unitID) then--and (not Action.Unit(unitID):IsHealer() or not Action.Unit(unitID):IsBreakAble()) then
            if InMelee(unitID) then
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
end
GetByRangePvP = A.MakeFunctionCachedDynamic(GetByRangePvP)

local function countInterruptGCD(unitID)
    -- returns @boolean
    if not A.Pummel:IsReadyByPassCastGCD(unitID) or not A.Pummel:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
        return true
    end
end

local function isCurrentlyTanking()
    -- return @boolean
    return (Unit("player"):IsTankingAoE(8) or Unit("player"):IsTanking(target, 8))
end

local function CanIgnorePain(variation)
    -- returns @boolean
    if Unit("player"):HasBuffs(A.IgnorePain.ID, true) > 0 then
        local description     = A.IgnorePain:GetSpellDescription()
        local summary         = description[1]
        local total         = summary * variation
        
        if Unit("player"):HasBuffs(A.IgnorePain.ID, true) < (0.5 * total) then
            return true
        else
            return false
        end
    else
        return true
    end
end

-- [1] CC AntiFake Rotation
local function AntiFakeStun(unitID)
    return
    IsUnitEnemy(unitID) and
    Action.Unit(unitID):GetRange() <= 20 and
    not Action.Unit(unitID):IsBoss() and
    A.StormBoltGreen:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true) and
    (not A.IsInPvP or UnitIsPlayer(unitID))
end

A[1] = function(icon)
    if     A.StormBoltGreen:IsReady(nil, true, nil, true) and AntiFakeStun(target)
    then
        return A.StormBoltGreen:Show(icon)
    end
end

-- [2] Kick AntiFake Rotation
A[2] = function(icon)
    local unitID
    if IsUnitEnemy(mouseover) then
        unitID = mouseover
    elseif IsUnitEnemy(target) then
        unitID = target
    end
    
    if unitID then
        local castLeft, _, _, _, notKickAble = Action.Unit(unitID):IsCastingRemains()
        if castLeft > 0 then
            if not notKickAble and A.PummelGreen:IsReady(unitID, nil, nil, true) and A.PummelGreen:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
                return A.PummelGreen:Show(icon)
            end
            
            if A.StormBoltGreen:IsReady(unitID, nil, nil, true) and Action.Unit(unitID):IsControlAble("stun") and A.StormBoltGreen:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true) then
                return A.StormBoltGreen:Show(icon)
            end
            
            -- Racials
            if A.QuakingPalm:IsRacialReadyP(unitID, nil, nil, true) then
                return A.QuakingPalm:Show(icon)
            end
            
            if A.Haymaker:IsRacialReadyP(unitID, nil, nil, true) then
                return A.Haymaker:Show(icon)
            end
            
            if A.WarStomp:IsRacialReadyP(unitID, nil, nil, true) then
                return A.WarStomp:Show(icon)
            end
            
            if A.BullRush:IsRacialReadyP(unitID, nil, nil, true) then
                return A.BullRush:Show(icon)
            end
        end
    end
end

-- Usage of RallyingCry, Diebythesword, Ignore pain and stoneform
local function SelfDefensives()
    
end

-- What and how to interrupt
local function Interrupts(unitID)
    local useKick, useCC, useRacial, notInterruptable, castRemainsTime
    local isMythicPlus    = false
    if GetToggle(2, "ZakLLInterrupts") and (IsInRaid() or A.InstanceInfo.KeyStone > 1) then
        isMythicPlus = true
        useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID, "ZakLLInterrupts", true, countInterruptGCD(unitID))
    else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID, nil, nil, countInterruptGCD(unitID))
    end
    
    -- Can waste interrupt action due delays caused by ping, interface input
    if castRemainsTime < GetLatency() then
        return
    end
    
    if useKick and not notInterruptable and A.Pummel:IsReady(unitID) and A.Pummel:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
        return A.Pummel
    end
    
    if useRacial and A.QuakingPalm:AutoRacial(unitID) then
        return A.QuakingPalm
    end
    
    if useRacial and A.Haymaker:AutoRacial(unitID) then
        return A.Haymaker
    end
    
    if useRacial and A.WarStomp:AutoRacial(unitID) then
        return A.WarStomp
    end
    
    if useRacial and A.BullRush:AutoRacial(unitID) then
        return A.BullRush
    end
    
    if useCC and A.StormBolt:IsReady(unitID) and (Action.Unit(unitID):IsControlAble("stun") or isMythicPlus) and A.StormBolt:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true) then
        return A.StormBolt
    end
    
    if useCC and A.IntimidatingShout:IsReady(unitID, true) and Action.Unit(unitID):GetRange() <= 8 and (Action.Unit(unitID):IsControlAble("fear") or isMythicPlus) and A.IntimidatingShout:AbsentImun(unitID, Temp.TotalAndPhysAndCC, true) then
        return A.IntimidatingShout
    end
end

-- Usage of trinkets
local function UseItems(unitID)
    if A.Trinket1:IsReadyByPassCastGCD(unitID) and A.Trinket1:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] and A.Trinket1:AbsentImun(unitID, Temp.TotalAndMagPhys) then
        return A.Trinket1
    end
    
    if A.Trinket2:IsReadyByPassCastGCD(unitID) and A.Trinket2:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] and A.Trinket2:AbsentImun(unitID, Temp.TotalAndMagPhys) then
        return A.Trinket2
    end
end


-- [3] Single Rotation
A[3] = function(icon)
    local EnemyRotation, EnemyRotationPvP
    local isMoving                            = Player:IsMoving()                -- @boolean
    local combatTime                        = Unit("player"):CombatTime()        -- @integer
    local inCombat                            = combatTime > 0                -- @boolean
    local inAoE                                = GetToggle(2, "AoE")            -- @boolean
    local rage                                = Player:Rage()                    -- @integer
    local rageDeficit                        = Player:RageDeficit()            -- @integer
    local delaySpells                        = math_random(20, 35) / 100        -- @double
    local covenantID, covenantName            = Player:GetCovenant()
    
    -- DEFENSIVES
    -- RallyingCry
    local RallyingCrySelfSliderValue = GetToggle(2, "RallyingCry") -- Returns value of slider. Off = -1
    if RallyingCrySelfSliderValue >= 0 and A.RallyingCry:IsReady("player") and
    (
        ( 
            RallyingCrySelfSliderValue == 100 and -- Slider is on 'Auto'
            (
                (
                    not A.IsInPvP and
                    Unit("player"):HealthPercent() < 25 and
                    Unit("player"):TimeToDieX(5) < 6
                ) or
                (
                    A.IsInPvP and Unit("player"):HealthPercent() < 25 and
                    (
                        Unit("player"):UseDeff() or
                        (
                            Action.Unit(player, 5):HasFlags() and
                            Unit("player"):GetRealTimeDMG() > 0 and
                            Unit("player"):IsFocused(nil, true)
                        )
                    )
                )
            ) and
            Unit("player"):HasBuffs("DeffBuffs") == 0
        ) or
        (    -- Custom
            RallyingCrySelfSliderValue < 100 and
            Unit("player"):HealthPercent() <= RallyingCrySelfSliderValue
        )
    )
    then
        return A.RallyingCry:Show(icon)
    end
    
    -- DiebytheSword
    local DiebytheSword = GetToggle(2, "DiebytheSword")
    if     DiebytheSword >= 0 and A.DiebytheSword:IsReady("player") and
    (
        (     -- Auto
            DiebytheSword >= 100 and
            (
                (
                    not A.IsInPvP and
                    Unit("player"):HealthPercent() < 40 and
                    Unit("player"):TimeToDieX(20) < 6
                ) or
                (
                    A.IsInPvP and Unit("player"):HealthPercent() < 40 and
                    (
                        Unit("player"):UseDeff() or
                        (
                            Action.Unit(player, 5):HasFlags() and
                            Unit("player"):GetRealTimeDMG() > 0 and
                            Unit("player"):IsFocused(nil, true)
                        )
                    )
                )
            ) and
            Unit("player"):HasBuffs("DeffBuffs") == 0
        ) or
        (    -- Custom
            DiebytheSword < 100 and
            Unit("player"):HealthPercent() <= DiebytheSword
        )
    )
    then
        return A.DiebytheSword:Show(icon)
    end
    
    -- Stoneform (On Deffensive)
    local Stoneform = GetToggle(2, "Stoneform")
    if     Stoneform >= 0 and A.Stoneform:IsRacialReadyP("player") and
    (
        (     -- Auto
            Stoneform >= 100 and
            (
                (
                    not A.IsInPvP and
                    Unit("player"):TimeToDieX(65) < 3
                ) or
                (
                    A.IsInPvP and
                    (
                        Unit("player"):UseDeff() or
                        (
                            Action.Unit(player, 5):HasFlags() and
                            Unit("player"):GetRealTimeDMG() > 0 and
                            Unit("player"):IsFocused()
                        )
                    )
                )
            )
        ) or
        (    -- Custom
            Stoneform < 100 and
            Unit("player"):HealthPercent() <= Stoneform
        )
    )
    then
        return A.Stoneform:Show(icon)
    end
    
    -- Ignore Pain
    local IgnorePain = GetToggle(2, "IgnorePain")
    if IgnorePain >= 0 and A.IgnorePain:IsReady("player") and CanIgnorePain(1.3) and
    (
        (    -- Auto
            IgnorePain >= 100 and
            (
                A.IsInPvP and Unit("player"):IsFocused() and
                (
                    Player:Rage() > 80 or
                    Unit("player"):HealthPercent() < 70
                ) or
                not A.IsInPvP and isCurrentlyTanking() and
                (
                    Unit("player"):TimeToDieX(60) < 2 or
                    Unit("player"):HealthPercent() < 70
                )
            )
        ) or -- Custom
        (
            IgnorePain < 100 and
            Unit("player"):HealthPercent() < IgnorePain
        )
    )
    then
        return A.IgnorePain:Show(icon)
    end
    
    -- [Shared] [Util] [Cov Signature]
    -- Summon steward when you enter arena && not in combat
    if A.SummonSteward:IsReady("player") and A.Zone == "arena" and not inCombat then
        return A.SummonSteward:Show(icon)
    end
    
    -- PhialofSerenity
    local PhialofSerenityHP, PhialofSerenityOperator, PhialofSerenityTTD = GetToggle(2, "PhialofSerenityHP"), GetToggle(2, "PhialofSerenityOperator"), GetToggle(2, "PhialofSerenityTTD")
    
    if (A.PhialofSerenity:IsReady("player") or (A.Zone == "arena" and GetItemCooldown(177278) == 0 and _G.IsUsableItem(177278))) and Unit("player"):HasDeBuffs(A.MindGamesDebuff.ID) == 0 then
        if PhialofSerenityOperator == "AND" then
            if (PhialofSerenityHP <= 0 or Unit("player"):HealthPercent() <= PhialofSerenityHP) and (PhialofSerenityTTD <= 0 or Unit("player"):TimeToDie() <= PhialofSerenityTTD) then
                return A.PhialofSerenity:Show(icon)
            end
        elseif PhialofSerenityOperator == "OR" then
            if (PhialofSerenityHP > 0 and Unit("player"):HealthPercent() <= PhialofSerenityHP) or (PhialofSerenityTTD > 0 and Unit("player"):TimeToDie() <= PhialofSerenityTTD) then
                return A.PhialofSerenity:Show(icon)
            end
        end
    end
    
    -- Dispel
    if A.PhialofSerenity:IsReady("player") and AuraIsValidByPhialofSerenity() then
        return A.PhialofSerenity:Show(icon)
    end
    
    -- VictoryRush
    local VictoryRush = GetToggle(2, "VictoryRush")
    if VictoryRush >= 0 and IsUnitEnemy("target") and A.VictoryRush:IsReady("target") and Unit("player"):HealthPercent() <= VictoryRush and A.VictoryRush:AbsentImun("target", Temp.TotalAndPhys) then
        return A.VictoryRush:Show(icon)
    end
    
    -- Stoneform (Self Dispel)
    if not A.IsInPvP and A.Stoneform:IsRacialReady(player, true) and AuraIsValid(player, "UseDispel", "Dispel") then
        return A.Stoneform:Show(icon)
    end
    
    if A.IsInPvP and A.DefensiveStance:IsReadyByPassCastGCD("player") and combatTime == 0 and Unit("player"):HasBuffs(A.DefensiveStance.ID) == 0 then
        return A.DefensiveStance:Show(icon)
    end
    
    if not Temp.CanUseWarBanner then
        Temp.CanUseWarBanner = ShouldWarBanner()
    end
    
    -- WarBanner + SAP
    if A.WarBanner:IsReadyByPassCastGCD("player") and Temp.CanUseWarBanner then
        if LoC:IsValid(Temp.BerserkerRageLoC) and A.BerserkerRage:IsReadyByPassCastGCD("player") and not A.BerserkerRage:IsSuspended(delaySpells, 6) then
            return A.BerserkerRage:Show(icon)
        end
        
        return A.WarBanner:Show(icon)
    end
    -- [Shared] [Util] [Berserker Rage] - Break fear /w delay
    if LoC:IsValid(Temp.BerserkerRageLoC) and GetToggle(2, "UseBerserkerRage-LoC") and A.BerserkerRage:IsReadyP("player") and not A.BerserkerRage:IsSuspended(delaySpells, 6) then
        return A.BerserkerRage:Show(icon)
    end
    
    -- [Shared] [Util] [Battle Shout]
    if A.BattleShout:IsReady("player") and (Unit("player"):HasBuffs(A.BattleShout.ID) == 0) then
        return A.BattleShout:Show(icon)
    end
    
    -- Defensive
    if inCombat then
        local SelfDefensive = SelfDefensives()
        if SelfDefensive then
            return SelfDefensive:Show(icon)
        end
        -- Spell Reflection
        if ShouldSpellReflect(player, Temp.SpellReflectTimer) then
            return A.SpellReflection:Show(icon)
        end
    end
    
    -- [✔️- Defensive] [Rallying Cry: Team]
    local RallyingCryParty = GetToggle(2, "RallyingCryParty")
    if A.IsInPvP and RallyingCryParty and A.RallyingCry:IsReadyByPassCastGCD("player") and (A.MasterandCommander:IsSpellLearned() and ProtectTeammate(45) or ProtectTeammate(RallyingCryParty)) then
        return A.RallyingCry:Show(icon)
    end
    
    function EnemyRotation(unitID)
        local isBurst                        = BurstIsON(unitID)
        
        -- Interrupts
        local Interrupt = Interrupts(unitID)
        if Interrupt then
            return Interrupt:Show(icon)
        end
        
        -- [[ EXECUTE ]]
        local function ExecuteRotation()
            local WbSoon = (A.ColossusSmash:GetCooldown() < 1 or A.Warbreaker:GetCooldown() < 1)
            local InMelee = InMelee(unitID)
            local CanBeDamaged = A.MortalStrike:AbsentImun(unitID, Temp.TotalAndPhys)
            local DeadlyCalmDown = Unit("player"):HasBuffs(A.DeadlyCalm.ID) == 0
            local SSUp = Unit("player"):HasBuffs(A.SweepingStrikes.ID) > 0.5
            
            if InMelee and CanBeDamaged then
                -- deadly_calm
                if isBurst and A.DeadlyCalm:IsReady("player") then
                    return A.DeadlyCalm:Show(icon)
                end
                -- rend,if=remains<=duration*0.3
                if A.Rend:IsReady("player") and Action.Unit(unitID):HasDeBuffs(A.Rend.ID, true) <= 4.5 then
                    return A.Rend:Show(icon)
                end
                -- skullsplitter,if=rage<60&(!talent.deadly_calm.enabled|buff.deadly_calm.down)
                if A.Skullsplitter:IsReady("player") and Player:Rage() < 60 and DeadlyCalmDown then
                    return A.Skullsplitter:Show(icon)
                end
                -- avatar,if=cooldown.colossus_smash.remains<1
                if isBurst and A.Avatar:IsReady("player") and WbSoon then
                    return A.Avatar:Show(icon)
                end
                -- cleave,if=spell_targets.whirlwind>1&dot.deep_wounds.remains<gcd
                if A.Cleave:IsReady("player") and GetByRange(2, 8) and Action.Unit(unitID):HasDeBuffs(A.DeepWoundsDebuff.ID, true) <= 1.2 then
                    return A.Cleave:Show(icon)
                end
                -- warbreaker
                if isBurst and A.Warbreaker:IsReady("player") then
                    return A.Warbreaker:Show(icon)
                end
                -- colossus_smash
                if isBurst and A.ColossusSmash:IsReady("player") then
                    return A.ColossusSmash:Show(icon)
                end
                -- bladestorm
                if isBurst and A.Bladestorm:IsReady("player") and Player:Rage() < 80 then
                    return A.Bladestorm:Show(icon)
                end
                -- ravager
                if isBurst and A.Ravager:IsReady("player") and Player:Rage() < 80 then
                    return A.Ravager:Show(icon)
                end
                -- mortal_strike,if=dot.deep_wounds.remains<gcd
                if A.MortalStrike:IsReady("player") and Action.Unit(unitID):HasDeBuffs(A.DeepWoundsDebuff.ID, true) <= 1.5 then
                    return A.MortalStrike:Show(icon)
                end
                -- condemn
                if A.Condemn:IsReady("player") and covenantName == "Venthyr" then
                    return A.Condemn:Show(icon)
                end
                -- execute
                if A.Execute:IsReady("player") then
                    return A.Execute:Show(icon)
                end
                -- skullsplitter,if=rage<40
                if A.Skullsplitter:IsReady("player") and Player:Rage() < 40 then
                    return A.Skullsplitter:Show(icon)
                end
                -- overpower
                if A.Overpower:IsReady("player") then
                    return A.Overpower:Show(icon)
                end
            end
        end
        
        -- [[ HAC ]]
        local function HAC()
            local WbSoon = (A.ColossusSmash:GetCooldown() < 1 or A.Warbreaker:GetCooldown() < 1)
            local InMelee = InMelee(unitID)
            local CanBeDamaged = A.MortalStrike:AbsentImun(unitID, Temp.TotalAndPhys)
            local DeadlyCalmDown = Unit("player"):HasBuffs(A.DeadlyCalm.ID) == 0
            local SSUp = Unit("player"):HasBuffs(A.SweepingStrikes.ID) > 0.5
            local DWUp = Action.Unit(unitID):HasDeBuffs(A.DeepWoundsDebuff.ID, true) <= 1.2
            
            if InMelee and CanBeDamaged then
                -- skullsplitter,if=rage<60&buff.deadly_calm.down
                if A.Skullsplitter:IsReady("player") and Player:Rage() < 60 and DeadlyCalmDown then
                    return A.Skullsplitter:Show(icon)
                end
                -- avatar,if=cooldown.colossus_smash.remains<1
                if isBurst and A.Avatar:IsReady("player") and WbSoon then
                    return A.Avatar:Show(icon)
                end
                -- cleave,if=dot.deep_wounds.remains<=gcd
                if A.Cleave:IsReady("player") and GetByRange(2, 8) and DWUp then
                    return A.Cleave:Show(icon)
                end
                -- warbreaker
                if isBurst and A.Warbreaker:IsReady("player") then
                    return A.Warbreaker:Show(icon)
                end
                -- bladestorm
                if isBurst and A.Bladestorm:IsReady("player") then
                    return A.Bladestorm:Show(icon)
                end
                -- ravager
                if isBurst and A.Ravager:IsReady("player") then
                    return A.Ravager:Show(icon)
                end
                -- colossus_smash
                if isBurst and A.ColossusSmash:IsReady("player") then
                    return A.ColossusSmash:Show(icon)
                end
                -- rend,if=remains<=duration*0.3&buff.sweeping_strikes.up
                if A.Rend:IsReady("player") and Action.Unit(unitID):HasDeBuffs(A.Rend.ID, true) <= 4.5 and SSUp then
                    return A.Rend:Show(icon)
                end
                -- cleave
                if A.Cleave:IsReady("player") then
                    return A.Cleave:Show(icon)
                end
                -- mortal_strike,if=buff.sweeping_strikes.up|dot.deep_wounds.remains<gcd&!talent.cleave.enabled
                if A.MortalStrike:IsReady("player") and SSUp and UDWUp and not A.Cleave:IsSpellLearned() then
                    return A.MortalStrike:Show(icon)
                end
                -- condemn
                if A.Condemn:IsReady("player") and covenantName == "Venthyr" then
                    return A.Condemn:Show(icon)
                end
                -- overpower,if=talent.dreadnaught.enabled
                if A.Overpower:IsReady("player") and A.Dreadnaught:IsSpellLearned() then
                    return A.Overpower:Show(icon)
                end
                -- Ancient Aftershock
                if isBurst and A.AncientAftershock:IsReady("player") then
                    return A.AncientAftershock:Show(icon)
                end
                -- execute,if=buff.sweeping_strikes.up
                if A.Execute:IsReady("player") and SSUp then
                    return A.Execute:Show(icon)
                end
                -- overpower
                if A.Overpower:IsReady("player") and SSUp then
                    return A.Overpower:Show(icon)
                end
                -- whirlwind
                if A.Whirlwind:IsReady("player") then
                    return A.Whirlwind:Show(icon)
                end
            end
        end
        
        -- [[ SINGLE TARGET ]]
        local function SingleTarget()
            local WbSoon = (A.ColossusSmash:GetCooldown() < 1 or A.Warbreaker:GetCooldown() < 1)
            local WbDebuff = Action.Unit(unitID):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0
            local InMelee = InMelee(unitID)
            local CanBeDamaged = A.MortalStrike:AbsentImun(unitID, Temp.TotalAndPhys)
            local DeadlyCalmDown = Unit("player"):HasBuffs(A.DeadlyCalm.ID) == 0
            
            if InMelee and CanBeDamaged then
                -- avatar,if=cooldown.colossus_smash.remains<1
                if isBurst and A.Avatar:IsReady("player") and WbSoon then
                    return A.Avatar:Show(icon)
                end
                -- rend,if=remains<=duration*0.3
                if A.Rend:IsReady("player") and Action.Unit(unitID):HasDeBuffs(A.Rend.ID, true) <= 4.5 then
                    return A.Rend:Show(icon)
                end
                -- cleave,if=spell_targets.whirlwind>1&dot.deep_wounds.remains<gcd
                if A.Cleave:IsReady("player") and GetByRange(2, 8) and Action.Unit(unitID):HasDeBuffs(A.DeepWoundsDebuff.ID, true) <= 1.2 then
                    return A.Cleave:Show(icon)
                end
                -- warbreaker
                if isBurst and A.Warbreaker:IsReady("player") then
                    return A.Warbreaker:Show(icon)
                end
                -- colossus_smash
                if isBurst and A.ColossusSmash:IsReady("player") then
                    return A.ColossusSmash:Show(icon)
                end
                --SpearofBastion
                if isBurst and A.SpearofBastion:IsReady(unitID, true) and Action.Unit(unitID):GetRange() <= 3 then
                    return A.SpearofBastion:Show(icon)
                end
                -- bladestorm,if=debuff.colossus_smash.up&!covenant.venthyr
                if isBurst and A.Bladestorm:IsReady("player") and WbDebuff and (covenantName ~= "Venthyr" or A.SignetofTormentedKings:HasLegendaryCraftingPower()) then
                    return A.Bladestorm:Show(icon)
                end
                -- ravager,if=debuff.colossus_smash.up&!covenant.venthyr
                if isBurst and A.Ravager:IsReady("player") and WbDebuff then
                    return A.Ravager:Show(icon)
                end
                -- overpower,if=charges=2
                if A.Overpower:IsReady("player") and A.Overpower:GetSpellCharges() == 2 then
                    return A.Overpower:Show(icon)
                end
                -- mortal_strike,if=buff.overpower.stack>=2&buff.deadly_calm.down|dot.deep_wounds.remains<=gcd
                if A.MortalStrike:IsReady("player") and Unit("player"):HasBuffsStacks(A.Overpower.ID, true) == 2 and DeadlyCalmDown and Action.Unit(unitID):HasDeBuffs(A.DeepWoundsDebuff.ID, true) <= 1.5 then
                    return A.MortalStrike:Show(icon)
                end
                -- condemn,if=buff.sudden_death.react
                if A.Condemn:IsReady("player") and covenantName == "Venthyr" then
                    return A.Condemn:Show(icon)
                end
                -- execute,if=buff.sudden_death.react
                if A.Execute:IsReady("player") then
                    return A.Execute:Show(icon)
                end
                -- deadly_calm
                if isBurst and A.DeadlyCalm:IsReady("player") then
                    return A.DeadlyCalm:Show(icon)
                end
                -- skullsplitter,if=rage<60&buff.deadly_calm.down
                if A.Skullsplitter:IsReady("player") and Player:Rage() < 60 and DeadlyCalmDown then
                    return A.Skullsplitter:Show(icon)
                end
                -- overpower
                if A.Overpower:IsReady("player") then
                    return A.Overpower:Show(icon)
                end
                -- Ancient Aftershock
                if isBurst and A.AncientAftershock:IsReady("player") then
                    return A.AncientAftershock:Show(icon)
                end
                -- mortal_strike
                if A.MortalStrike:IsReady("player") then
                    return A.MortalStrike:Show(icon)
                end
                -- bladestorm,if=debuff.colossus_smash.up&covenant.venthyr
                if isBurst and A.Bladestorm:IsReady("player") and WbDebuff and covenantName == "Venthyr" then
                    return A.Bladestorm:Show(icon)
                end
                -- whirlwind,if=talent.fervor_of_battle.enabled&rage>60
                if A.Whirlwind:IsReady("player") and A.FervorofBattle:IsSpellLearned() and Player:Rage() > 60 then
                    return A.Whirlwind:Show(icon)
                end
                -- slam,if=rage>50
                if A.Slam:IsReady("player") and Player:Rage() > 50 then
                    return A.Slam:Show(icon)
                end
            end
        end
        
        -- [[ Actions CDS ]]
        --blood_fury,if=debuff.colossus_smash.up
        if isBurst and A.BloodFury:IsReadyByPassCastGCD("player") and Action.Unit(unitID):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 2 then
            return A.BloodFury:Show(icon)
        end
        
        --berserking,if=debuff.colossus_smash.remains>6
        if isBurst and A.Berserking:IsReadyByPassCastGCD("player") and Action.Unit(unitID):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 2 then
            return A.Berserking:Show(icon)
        end
        
        -- Trinkets
        local Item = UseItems(unitID)
        if (not A.Avatar:IsSpellLearned() and Action.Unit(unitID):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 2 or Unit("player"):HasBuffs(A.Avatar.ID) > 0) and Item then
            return Item:Show(icon)
        end
        
        --sweeping_strikes,if=spell_targets.whirlwind>1&cooldown.bladestorm.remains>12
        if inAoE and A.SweepingStrikes:IsReady(unitID, true) and InMelee(unitID) and GetByRange(2, 8) and (not isBurst or A.Bladestorm:GetCooldown() > 12) then
            return A.SweepingStrikes:Show(icon)
        end
        
        -- [[ EXECUTE ]]
        --execute,if=(talent.massacre.enabled&target.health.pct<35)|target.health.pct<20|(target.health.pct>80&covenant.venthyr)
        if ((A.Massacre:IsSpellLearned() and Action.Unit(unitID):HealthPercent() < 35 or Action.Unit(unitID):HealthPercent() < 20) or (Action.Unit(unitID):HealthPercent() > 80 and covenantName == "Venthyr")) and ExecuteRotation() then
            return true
        end
        
        -- [[ HAC ]]
        if inAoE and GetByRange(3, 8) and HAC() then
            return true
        end
        
        -- [[ SINGLE TARGET ]]
        if (not inAoE or not GetByRange(3, 8)) and SingleTarget() then
            return true
        end
    end
    
    function EnemyRotationPvP(unitID)
        local forceKill                        = Unit("player"):HasBuffs(A.Avatar.ID) > 1 or Action.Unit(unitID):TimeToDie() < 6
        local manageBurst                    = GetToggle(2, "ManageBurstPvP")
        local isBurst                        = BurstIsON(unitID) and not manageBurst
        local holdCD                        = (btn_ForceBurst or btn_PrepareBurst) and manageBurst
        local BattleStancePvP                = GetToggle(2, "BattleStancePvP")
        local DefensiveStancePvP            = GetToggle(2, "DefensiveStancePvP")
        local ignoreKarma                    = GetToggle(2, "IgnoreKarma")
        local _, _, _, notInterruptable, spellID, _ = A.Action.Unit(unitID):IsCasting()
        local targetLowHealth                = Action.Unit(unitID):HealthPercent() < 35
        
        -- Interrupts
        local Interrupt = Interrupts(unitID)
        if Interrupt then
            return Interrupt:Show(icon)
        end
        
        -- [🚧- Defensive] [Convoke], interrupts convoke with pummel or stun depending on range
        if spellID == 337433 or spellID == 323764 then -- If casting convoke
            if A.Pummel:IsReady(unitID) and InMelee(unitID) and not notInterruptable then
                return A.Pummel:Show(icon)
            elseif A.StormBolt:IsReady(unitID) and not Action.Unit(unitID):InLOS() and A.StormBolt:AbsentImun(unitID, Temp.DisablePhys, true) then
                return A.StormBolt:Show(icon)
            end
        end
        
        -- [🚧- Defensive] [PvP talent - Duel]
        if ShouldDuel(unitID, target, player) then
            return A.Duel:Show(icon)
        end
        
        -- [✔️- Defensive] [PvP talent - Disarm]
        if ShouldDisarm(unitID) and A.Disarm:IsSuspended(delaySpells, 6) then
            return A.Disarm:Show(icon)
        end
        
        -- [✔️- Util] [Hamstring]
        if A.Hamstring:IsReady(unitID) and not targetLowHealth and Action.Unit(unitID):GetMaxSpeed() >= 100 and not holdCD and UnitIsPlayer(unitID) and Action.Unit(unitID):HasDeBuffs("Slowed") == 0 and A.Hamstring:AbsentImun(unitID, Temp.DisablePhys, true) then
            return A.Hamstring:Show(icon)
        end
        
        -- [🚧- Util] [Piercing Howl] - TODO FIX WAS ONLY DOING WHEN IN MELEE?
        -- Improve usage for peeling enemy untargetted melee
        -- if A.PiercingHowl:IsReady(unitID, true) and InMelee(unitID) and not holdCD and Action.Unit(unitID):GetMaxSpeed() >= 100 and UnitIsPlayer(unitID) and (not forceKill or Action.Unit(unitID):TimeToDie() > 12) and Action.Unit(unitID):HasDeBuffs("Slowed") == 0 and A.PiercingHowl:AbsentImun(unitID, Temp.DisablePhys, true) then
        -- return A.PiercingHowl:Show(icon)
        -- end
        
        -- [✔️- Util] [Heroic Throw] - Get in combat /w enemy stealther
        if A.Zone == "arena" and not inCombat and A.HeroicThrow:IsReady(unitID) and not Action.Unit(unitID):IsTotem() and EnemyTeam():HasInvisibleUnits() and A.HeroicThrow:AbsentImun(unitID, Temp.TotalAndPhys, ignoreKarma) and not Player:IsMounted() then
            return A.HeroicThrow:Show(icon)
        end
        
        -- [[ FORCE BURST ]]
        if (btn_ForceBurst or btn_PrepareBurst) then
            
            if btn_ForceBurst then
                BurstPhase["startBursting"] = true
            else
                BurstPhase["startBursting"] = Unit("player"):HasBuffsStacks(A.Overpower.ID, true) >= 2
            end
            
            if BurstPhase["startBursting"] then
                --SpearofBastion
                if A.SpearofBastion:IsReady(unitID, true) and A.SpearofBastion:AbsentImun(unitID, Temp.TotalAndPhys, ignoreKarma) then
                    return A.SpearofBastion:Show(icon)
                end
                
                if A.AbsentImun(nil, unitID, Temp.TotalAndPhys) and InMelee(unitID) then
                    -- Trinkets
                    local Item = UseItems(unitID)
                    if Item then
                        return Item:Show(icon)
                    end
                    
                    -- Battle stance (Off GCD - if health > 50%)
                    if A.DefensiveStance:IsReadyByPassCastGCD("player") and Unit("player"):HealthPercent() > 50 and Unit("player"):HasBuffs(A.DefensiveStance.ID) > 0 then
                        return A.DefensiveStance:Show(icon)
                    end
                    
                    -- Half Global
                    if A.SweepingStrikes:IsReadyByPassCastGCD("player") and inAoE and GetByRangePvP(2, 6) and Action.Unit(unitID):HealthPercent() > 50 and not EnemyTeam():IsBreakAble(8) then
                        return A.SweepingStrikes:Show(icon)
                    end
                    
                    if A.Avatar:IsReadyByPassCastGCD("player") then
                        return A.Avatar:Show(icon)
                    end
                    
                    --blood_fury
                    if A.BloodFury:IsReadyByPassCastGCD("player") then
                        return A.BloodFury:Show(icon)
                    end
                    
                    -- Ignore Pain Rage >= 70
                    if A.IgnorePain:IsReadyByPassCastGCD("player") and rage >= 70 then
                        return A.IgnorePain:Show(icon)
                    end
                    
                    -- Warbreaker (1.5GCD - Increase DMG by 30%)
                    if A.Warbreaker:IsReadyByPassCastGCD(unitID) and InMelee(unitID) then
                        return A.Warbreaker:Show(icon)
                    end
                    
                    -- MS
                    if A.MortalStrike:IsReady(unitID) then
                        -- Pré SharpenBlade MS
                        if A.SharpenBlade:IsReadyByPassCastGCD("player") then
                            return A.SharpenBlade:Show(icon)
                        end
                        return A.MortalStrike:Show(icon)
                    end
                    
                    --execute
                    if A.Execute:IsReady(unitID) and inAoE and GetByRangePvP(2, 6) and A.Execute:AbsentImun(unitID, Temp.TotalAndPhys, ignoreKarma) then
                        return A.Execute:Show(icon)
                    end
                    
                    if A.Bladestorm:IsReady(unitID, true) and InMelee(unitID) then
                        -- Pré SharpenBlade BS
                        if A.SharpenBlade:IsReadyByPassCastGCD("player") then
                            return A.SharpenBlade:Show(icon)
                        end
                        return A.Bladestorm:Show(icon)
                    end
                    
                    
                    -- END burst phase
                    if A.MortalStrike:GetCooldown() > 0 and (A.SharpenBlade:GetCooldown() > 0 or not A.SharpenBlade:IsSpellLearned()) and A.Bladestorm:GetCooldown() > 0 then
                        if btn_ForceBurst then
                            A.ForceBurst("ExecuteProc")
                        end
                        
                        if btn_PrepareBurst then
                            A.PrepareBurst("ExecuteProc")
                        end
                    end
                end
            end
        end
        
        -- [✔️- Offensive] [PvP Talent - Sharpen Blade]
        --         Buffing Mortal Strike properly is very important. Two overpower stacks will give your next Mortal Strike 40% extra damage.
        --         Adding a Sharpen Blade on top of that will increase it with another 15% and increase the healing reduction to 50%.
        --         It can be used off GCD so it's perfect to cast just before Mortal Strike.
        -- When to use?
        --      Primary checks: I have Sharpen AND MS is ready AND I'm not mounted AND target is a player
        --        To set up a big Mortal Strike (2x overpower buff) or
        --         To increase burst dmg (avatar up) or
        --        Target is low (<60%HP)
        if A.SharpenBlade:IsReadyByPassCastGCD(unitID) and not holdCD and
        (
            A.MortalStrike:GetCooldown() == 0 and
            combatTime > 0 and
            not Player:IsMounted() and
            UnitIsPlayer(unitID) and
            A.Warbreaker:GetCooldown() > 20 and
            (
                Unit("player"):HasBuffsStacks(A.Overpower.ID, true) == 2 or
                Unit("player"):HasBuffs(A.Avatar.ID, true) > 0 or
                Action.Unit(unitID):HealthPercent() < 60
            )
        ) then
            return A.SharpenBlade:Show(icon)
        end
        
        -- [✔️- Offensive] [Mortal Strike] - Use with prio if Sharpen Blade is up
        if Unit("player"):HasBuffs(A.SharpenBlade.ID, true) > 0 and A.MortalStrike:IsReady(unitID) then
            return A.MortalStrike:Show(icon)
        end
        
        -- [[ EXECUTE ]]
        local function ExecuteRotation()
            -- PvP execute rotation (<=35% health)
            -- 1) Sharpen MS
            -- 2) Keep MS uptime
            -- 3) Burst CD's if enabled
            -- 4) Execute
            
            -- Use sharpen & MS if it's ready
            if A.MortalStrike:IsReady(unitID) and A.SharpenBlade:IsReadyByPassCastGCD("player") and A.MortalStrike:AbsentImun(unitID, Temp.TotalAndPhys, ignoreKarma) then
                return A.SharpenBlade:Show(icon)
            end
            
            if Unit("player"):HasBuffs(A.SharpenBlade.ID, true) > 0 and A.MortalStrike:IsReady(unitID) and A.MortalStrike:AbsentImun(unitID, Temp.TotalAndPhys, ignoreKarma)then
                return A.MortalStrike:Show(icon)
            end
            
            -- Keep Mortal Strike effect up
            if Action.Unit(unitID):HasDeBuffs(A.MortalStrike.ID, true) <= GetGCD() and A.MortalStrike:IsReady(unitID) and A.MortalStrike:AbsentImun(unitID, Temp.TotalAndPhys, ignoreKarma) then
                return A.MortalStrike:Show(icon)
            end
            
            -- Bust CD's
            if isBurst and A.Warbreaker:IsReady(unitID, true) and InMelee(unitID) and A.Warbreaker:AbsentImun(unitID, Temp.TotalAndPhys, ignoreKarma) then
                --avatar,if=cooldown.colossus_smash.remains<1
                if A.Avatar:IsReadyByPassCastGCD("player") then
                    return A.Avatar:Show(icon)
                end
                return A.Warbreaker:Show(icon)
            end
            
            if isBurst and A.ColossusSmash:IsReady(unitID) and not A.Warbreaker:IsSpellLearned() and A.ColossusSmash:AbsentImun(unitID, Temp.TotalAndPhys, ignoreKarma) then
                --avatar,if=cooldown.colossus_smash.remains<1
                if A.Avatar:IsReadyByPassCastGCD("player") then
                    return A.Avatar:Show(icon)
                end
                return A.ColossusSmash:Show(icon)
            end
            
            --SpearofBastion
            if isBurst and A.SpearofBastion:IsReady(unitID, true) and Action.Unit(unitID):GetRange() <= 3 and A.SpearofBastion:AbsentImun(unitID, Temp.TotalAndPhys, ignoreKarma) then
                return A.SpearofBastion:Show(icon)
            end
            
            --bladestorm,if=rage<80
            if isBurst and A.Bladestorm:IsReady(unitID, true) and InMelee(unitID) and rage < 80 and A.Bladestorm:AbsentImun(unitID, Temp.TotalAndPhys, ignoreKarma) then
                return A.Bladestorm:Show(icon)
            end
            
            -- Spam execute
            if A.Execute:IsReady(unitID) and A.Execute:AbsentImun(unitID, Temp.TotalAndPhys, ignoreKarma) then
                return A.Execute:Show(icon)
            end
            
            --overpower
            if A.Overpower:IsReady(unitID) and A.Overpower:AbsentImun(unitID, Temp.TotalAndPhys, ignoreKarma) then
                return A.Overpower:Show(icon)
            end
        end
        
        -- [[ SINGLE TARGET ]]
        local function SingleTarget()
            local WbSoon = (A.ColossusSmash:GetCooldown() < 1 or A.Warbreaker:GetCooldown() < 1)
            local InMelee = InMelee(unitID) or (A.DeathSentence:IsSpellLearned() and (A.Condemn:IsReady("player") or A.Execute:IsReady(player)) and Action.Unit(unitID):GetRange() <= 15)
            -- or venthyr with execute and its bop
            local CanBeDamaged = A.MortalStrike:AbsentImun(unitID, Temp.TotalAndPhys) or (A.Condemn:IsReady("player") and covenantName == "Venthyr" and Action.Unit(unitID):HasBuffs(1022) > 0)
            local DeadlyCalmDown = Unit("player"):HasBuffs(A.DeadlyCalm.ID) == 0
            local SSUp = Unit("player"):HasBuffs(A.SweepingStrikes.ID) > 0.5
            
            if InMelee and CanBeDamaged  then
                -- Burst=ON, avatar,if=cooldown.colossus_smash.remains<1
                if isBurst and A.Avatar:IsReady("player") and WbSoon then
                    return A.Avatar:Show(icon)
                end
                -- Burst=ON,warbreaker
                if isBurst and A.Warbreaker:IsReady("player") then
                    return A.Warbreaker:Show(icon)
                end
                -- Burst=ON,colossus_smash
                if isBurst and A.ColossusSmash:IsReady("player") then
                    return A.ColossusSmash:Show(icon)
                end
                -- Burst=ON,SpearofBastion
                if isBurst and A.SpearofBastion:IsReady(unitID, true) and Action.Unit(unitID):GetRange() <= 3 then
                    return A.SpearofBastion:Show(icon)
                end
                -- Burst=ON,bladestorm,if=debuff.colossus_smash.up&!covenant.venthyr
                if isBurst and A.Bladestorm:IsReady("player") and WbDebuff and (covenantName ~= "Venthyr" or A.SignetofTormentedKings:HasLegendaryCraftingPower()) then
                    return A.Bladestorm:Show(icon)
                end
                -- Burst=ON,ravager,if=debuff.colossus_smash.up&!covenant.venthyr
                if isBurst and A.Ravager:IsReady("player") and WbDebuff then
                    return A.Ravager:Show(icon)
                end
                
                --  Use Mortal Strike if Mortal Wounds is about to fall off on your target.
                if A.MortalStrike:IsReady("player") and Action.Unit(unitID):HasDeBuffs(A.DeepWoundsDebuff.ID, true) <= 1.5 then
                    return A.MortalStrike:Show(icon)
                end
                
                -- Condemn (Venthyr)
                if A.Condemn:IsReady("player") and covenantName == "Venthyr" then
                    return A.Condemn:Show(icon)
                end
                
                -- Execute (Procs)
                if A.Execute:IsReady("player") then
                    return A.Execute:Show(icon)
                end
                
                if A.MortalStrike:IsReady("player") then
                    return A.MortalStrike:Show(icon)
                end
                
                -- overpower
                if A.Overpower:IsReady("player") then
                    return A.Overpower:Show(icon)
                end
                
                -- slam,if=rage>50
                if A.Slam:IsReady("player") and Player:Rage() > 50 then
                    return A.Slam:Show(icon)
                end
                
                -- Burst=ON,deadly_calm
                if isBurst and A.DeadlyCalm:IsReady("player") then
                    return A.DeadlyCalm:Show(icon)
                end
                
                -- skullsplitter,if=rage<60
                if A.Skullsplitter:IsReady("player") and Player:Rage() < 60 then
                    return A.Skullsplitter:Show(icon)
                end
                
                -- Burst=ON,Ancient Aftershock
                if isBurst and A.AncientAftershock:IsReady("player") then
                    return A.AncientAftershock:Show(icon)
                end
                
                -- Burst=ON,bladestorm,if=debuff.colossus_smash.up&covenant.venthyr
                if isBurst and A.Bladestorm:IsReady("player") and WbDebuff and covenantName == "Venthyr" then
                    return A.Bladestorm:Show(icon)
                end
                
                -- whirlwind,if=talent.fervor_of_battle.enabled&rage>60
                if A.Whirlwind:IsReady("player") and A.FervorofBattle:IsSpellLearned() and Player:Rage() > 60 then
                    return A.Whirlwind:Show(icon)
                end
            end
        end
        
        -- [✔️- Misc] [Battle Stance] & [Defensive Stance]
        if A.DefensiveStance:IsReadyByPassCastGCD("player") and
        (
            ( -- go def
                (combatTime > 0 and -- In combat
                    Unit("player"):HasBuffs(A.DefensiveStance.ID) == 0 and -- I'm battle stance
                    Unit("player"):HealthPercent() <= DefensiveStancePvP) or
                EnemyTeam():HasInvisibleUnits() -- I'm lower than def stance HP
            )
            or
            ( -- Swap to battle if I have been in combat for > 4 seconds and I am high enough HP or I am bursting with more than 50% HP)
                Unit("player"):HasBuffs(A.DefensiveStance.ID) > 0 and not
                EnemyTeam():HasInvisibleUnits() and
                (combatTime > 4 and Unit("player"):HealthPercent() >= BattleStancePvP) or 
                (Action.Unit(unitID):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 2 and Unit("player"):HealthPercent() >= 50)
            )
        ) then
            return A.DefensiveStance:Show(icon)
        end
        
        -- [✔️- Misc - racial] [Arcane Torrent] - Blood Elf racial (purge)
        if A.ArcaneTorrent:AutoRacial(unitID) then
            return A.ArcaneTorrent:Show(icon)
        end
        
        -- [[ EXECUTE ]]
        --execute,if=(talent.massacre.enabled&target.health.pct<35)|target.health.pct<20|(target.health.pct>80&covenant.venthyr)
        if ((A.Massacre:IsSpellLearned() and Action.Unit(unitID):HealthPercent() < 35 or Action.Unit(unitID):HealthPercent() < 20) or Action.Unit(unitID):HealthPercent() > 80 and covenantName == "Venthyr") and ExecuteRotation() then
            return true
        end
        
        -- Half Global
        if A.SweepingStrikes:IsReadyByPassCastGCD("player") and inAoE and GetByRangePvP(2, 6) and Action.Unit(unitID):HealthPercent() > 50 and not EnemyTeam():IsBreakAble(8) then
            return A.SweepingStrikes:Show(icon)
        end
        
        -- [[ SINGLE TARGET ]]
        if SingleTarget() then
            return true
        end
    end
    
    -- Target
    if IsUnitEnemy(target) and not Action.Unit(target):IsDead() then
        if A.IsInPvP then
            if EnemyRotationPvP(target) then
                return true
            end
        else
            if EnemyRotation(target) then
                return true
            end
        end
    end
end

A[4] = nil
A[5] = nil

-- Passive
local function FreezingTrapUsedByEnemy()
    if     UnitCooldown:GetCooldown("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) > UnitCooldown:GetMaxDuration("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) - 2 and
    UnitCooldown:IsSpellInFly("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) and
    Unit("player"):GetDR("incapacitate") > 0
    then
        local Caster = UnitCooldown:GetUnitID("arena", ACTION_CONST_SPELLID_FREEZING_TRAP)
        if Caster and Action.Unit(Caster):GetRange() <= 40 then
            return true
        end
    end
end

local function ArenaRotation(icon, unitID)
    local _, _, _, notInterruptable, spellID, _ = A.Action.Unit(unitID):IsCasting()
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsMounted() then
        -- Disarm
        if ShouldDisarm(unitID) then
            return A.Disarm:Show(icon)
        end
        
        -- [🚧- Defensive] [Convoke], interrupts convoke with pummel or stun depending on range
        if spellID == 337433 or spellID == 323764 then -- If casting convoke
            if A.Pummel:IsReady(unitID) and InMelee(unitID) and not notInterruptable then
                return A.Pummel:Show(icon)
            elseif A.StormBolt:IsReady(unitID) and not Action.Unit(unitID):InLOS() and A.StormBolt:AbsentImun(unitID, Temp.DisablePhys, true) then
                return A.StormBolt:Show(icon)
            end
        end
        
        -- TODO: Uncomment when duel1,2,3 is available
        --if ShouldDuel(unitID, target, player) then
        --return A.Duel:Show(icon)
        --end
        
        -- Note: "arena1" is just identification of meta 6
        if unitID == "arena1" and (Unit("player"):GetDMG() == 0 or not Unit("player"):IsFocused("DAMAGER")) then
            -- PvP Pet Taunt
            if A.Taunt:IsReady() and EnemyTeam():IsTauntPetAble(A.Taunt.ID) then
                -- Freezing Trap
                if FreezingTrapUsedByEnemy() then
                    return A.Taunt:Show(icon)
                end
                
                -- Casting BreakAble CC
                if EnemyTeam():IsCastingBreakAble(0.25) then
                    return A.Taunt:Show(icon)
                end
                
                -- Try avoid something totally random at opener (like sap / blind)
                if Unit("player"):CombatTime() <= 5 and (Unit("player"):CombatTime() > 0 or Unit("target"):CombatTime() > 0 or MultiUnits:GetByRangeInCombat(40, 1) >= 1) then
                    return A.Taunt:Show(icon)
                end
                
                -- Roots if not available freedom
                if LoC:Get("ROOT") > 0 then
                    return A.Taunt:Show(icon)
                end
            end
        end
        
        -- Heroic Throw with Rend Pixel (Arena1-3) for get unit invisible in arena or keep rogue in combat if dont have target in melee
        if A.HeroicThrow:IsReadyByPassCastGCD(unitID) and not Action.Unit(unitID):InLOS() and
        (
            not Action.Unit(unitID):IsVisible() or
            Action.Unit(unitID):Class() == "ROGUE" and
            Action.Unit(target):GetRange() > 8 and
            (
                A.Charge:GetCooldown() > 0 or
                LoC:Get("ROOT") > 0
            )
        )
        then
            return A.Rend:Show(icon)
        end
        
        -- Interrupt - Pummel (checkbox "useKick" for Interrupts tab in "PvP" and "Heal" categories)
        if A.Pummel:CanInterruptPassive(unitID) then
            return A.Pummel:Show(icon)
        end
        
        -- Interrupt - StormBolt (checkbox "useCC" for Interrupts tab in "PvP" and "Heal" categories)
        if A.StormBolt:CanInterruptPassive(unitID, countInterruptGCD(unitID)) then
            return A.StormBolt:Show(icon)
        end
    end
end

local function PartyRotation(icon, unitID)
    if unitID and A.IsInPvP then
        -- Intevene is ready and unit not in LOS
        if A.Intervene:IsReadyByPassCastGCD(unitID) and not Action.Unit(unitID):InLOS() and
        -- Don't intervene if I have Avatar & intervene target > 5 yards away
        (
            (
                Unit("player"):HasBuffs(A.Avatar.ID, true) == 0 and Action.Unit(target):HealthPercent() > 25
            ) or
            Action.Unit(unitID):GetRange() <= 5
        ) and
        (
            -- Intervene when passes logic from ProfileUI or it is a scatter shot / binding shot
            A.Overwatch:IsSpellLearned() and
            (IntervenePvP(unitID, Temp.SpellReflectTimer, Temp.HasPriest) or Action.Unit(unitID):HasDeBuffs(A.BlindDebuff.ID) > 0 and Action.Unit(unitID):HasDeBuffs(A.BlindDebuff.ID) < 2) or --or Action.Unit(unitID):HasDeBuffs(Temp.InterveneInstaIDs) > 0
            -- Peel teamate if hp less then 25%
            Action.Unit(unitID):HealthPercent() > 0 and
            Action.Unit(unitID):HealthPercent() < 25 or
            -- Peel teamate if not overwatch talent and enemy burst
            not A.Overwatch:IsSpellLearned() and
            Action.Unit(unitID):IsFocused(nil, true) and
            Action.Unit(unitID):IsHealer()
        )
        then
            return A.Intervene:Show(icon)
        end
    end
end

A[6] = function(icon)
    if PartyRotation(icon, "party1") then
        return true
    end
    
    return ArenaRotation(icon, "arena1")
end

A[7] = function(icon)
    if PartyRotation(icon, "party2") then
        return true
    end
    
    if ArenaRotation(icon, "arena2") then
        return true
    end
    
    if A.StormBoltGreen:IsReady(nil, true, nil, true) and AntiFakeStun(focus) then
        return A.StormBoltGreen:Show(icon)
    end
end

A[8] = function(icon)
    if ArenaRotation(icon, "arena3") then
        return true
    end
    
    if IsUnitEnemy(focus) then
        local castLeft, _, _, _, notKickAble = Action.Unit(focus):IsCastingRemains()
        
        if castLeft > 0 then
            if not notKickAble and A.PummelGreen:IsReady(focus, nil, nil, true) and A.PummelGreen:AbsentImun(focus, Temp.TotalAndPhysKick, true) then
                return A.PummelGreen:Show(icon)
            end
        end
    end
end

