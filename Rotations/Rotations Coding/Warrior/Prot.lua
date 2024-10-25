local _G, setmetatable, pairs, type, math    = _G, setmetatable, pairs, type, math
local math_random                            = math.random
local huge                                     = math.huge

local TMW                                     = _G.TMW 

local Action                                 = _G.Action

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
local InterruptIsValid                        = Action.InterruptIsValid
local Print                                    = Action.Print
local toStr                                    = Action.toStr

local EnemyTeam                                = Action.EnemyTeam
local FriendlyTeam                            = Action.FriendlyTeam
local LoC                                     = Action.LossOfControl
local Player                                = Action.Player 
local MultiUnits                            = Action.MultiUnits
local UnitCooldown                            = Action.UnitCooldown
local Unit                                    = Action.Unit 
local IsUnitEnemy                            = Action.IsUnitEnemy
local IsUnitFriendly                        = Action.IsUnitFriendly
local ActiveUnitPlates                        = MultiUnits:GetActiveUnitPlates()
local DetermineCountGCDs                     = Action.DetermineCountGCDs

local ShouldDisarm                            = Action.ShouldDisarm
local ShouldSpellReflect                    = Action.ShouldSpellReflect
local GroupNeedPeel                            = Action.GroupNeedPeel
local ToogleBurstZR                            = Action.ToogleBurstZR

local IntervenePvP                            = Action.IntervenePvP

local ACTION_CONST_WARRIOR_PROTECTION        = CONST.WARRIOR_PROTECTION
local ACTION_CONST_AUTOTARGET                = CONST.AUTOTARGET
local ACTION_CONST_SPELLID_FREEZING_TRAP    = CONST.SPELLID_FREEZING_TRAP
local ACTION_CONST_CACHE_DEFAULT_TIMER        = _G.ACTION_CONST_CACHE_DEFAULT_TIMER


local IsIndoors, UnitIsUnit, UnitIsPlayer    = _G.IsIndoors, _G.UnitIsUnit, _G.UnitIsPlayer

Action[ACTION_CONST_WARRIOR_PROTECTION] = {
    -- Racial
    ArcaneTorrent                             = Create({ Type = "Spell", ID = 50613                                                                             }),
    BloodFury                                 = Create({ Type = "Spell", ID = 20572                                                                              }),
    Fireblood                                   = Create({ Type = "Spell", ID = 265221                                                                             }),
    AncestralCall                              = Create({ Type = "Spell", ID = 274738                                                                             }),
    Berserking                                = Create({ Type = "Spell", ID = 26297                                                                            }),
    ArcanePulse                                  = Create({ Type = "Spell", ID = 260364                                                                            }),
    QuakingPalm                                  = Create({ Type = "Spell", ID = 107079                                                                             }),
    Haymaker                                  = Create({ Type = "Spell", ID = 287712                                                                             }), 
    WarStomp                                  = Create({ Type = "Spell", ID = 20549                                                                             }),
    BullRush                                  = Create({ Type = "Spell", ID = 255654                                                                             }),    
    BagofTricks                               = Create({ Type = "Spell", ID = 312411                                                                             }),    
    GiftofNaaru                               = Create({ Type = "Spell", ID = 59544                                                                            }),
    LightsJudgment                               = Create({ Type = "Spell", ID = 255647                                                                            }),
    Shadowmeld                                  = Create({ Type = "Spell", ID = 58984                                                                            }), -- usable in Action Core 
    Stoneform                                  = Create({ Type = "Spell", ID = 20594                                                                            }), 
    WilloftheForsaken                          = Create({ Type = "Spell", ID = 7744                                                                            }), -- usable in Action Core 
    EscapeArtist                              = Create({ Type = "Spell", ID = 20589                                                                            }), -- usable in Action Core 
    EveryManforHimself                          = Create({ Type = "Spell", ID = 59752                                                                            }), -- usable in Action Core  
    Regeneratin                                  = Create({ Type = "Spell", ID = 291944                                                                            }), -- not usable in APL but user can Queue it
    -- CrownControl    
    IntimidatingShout                        = Create({ Type = "Spell", ID = 5246, isIntimidatingShout = true                                                }),
    StormBolt                                  = Create({ Type = "Spell", ID = 107570, isTalent = true, isStormBolt = true                                        }),
    StormBoltGreen                              = Create({ Type = "SpellSingleColor", ID = 107570, Color = "GREEN", Desc = "[1] CC", QueueForbidden = true         }),
    Pummel                                    = Create({ Type = "Spell", ID = 6552, isPummel = true                                                            }),
    PummelGreen                                = Create({ Type = "SpellSingleColor", ID = 6552, Color = "GREEN", Desc = "[2] Kick", QueueForbidden = true        }),
    Shockwave                                = Create({ Type = "Spell", ID = 46968                                                                            }),
    Disarm                                    = Create({ Type = "Spell", ID = 236077, isTalent = true                                                         }),    -- PvP Talent
    -- Supportive     
    Taunt                                      = Create({ Type = "Spell", ID = 355                                                                                }),
    BattleShout                                = Create({ Type = "Spell", ID = 6673                                                                            }),
    -- Self Defensives
    RallyingCry                                = Create({ Type = "Spell", ID = 97462                                                                             }),
    BerserkerRage                            = Create({ Type = "Spell", ID = 18499                                                                             }),
    IgnorePain                                = Create({ Type = "Spell", ID = 190456                                                                             }),
    ShieldBlock                                = Create({ Type = "Spell", ID = 2565                                                                             }),
    SpellReflection                            = Create({ Type = "Spell", ID = 23920                                                                             }),
    VictoryRush                                = Create({ Type = "Spell", ID = 34428                                                                            }),
    LastStand                                = Create({ Type = "Spell", ID = 12975                                                                            }),
    DemoralizingShout                        = Create({ Type = "Spell", ID = 1160                                                                            }),
    ShieldWall                                = Create({ Type = "Spell", ID = 871                                                                                }),
    -- Burst
    Avatar                                    = Create({ Type = "Spell", ID = 107574                                                                            }),
    -- Rotation
    ShieldSlam                                = Create({ Type = "Spell", ID = 23922                                                                             }),
    Execute                                    = Create({ Type = "Spell", ID = 163201                                                                            }),
    ThunderClap                                = Create({ Type = "Spell", ID = 6343                                                                            }),
    Revenge                                    = Create({ Type = "Spell", ID = 6572                                                                            }),
    Devastate                                = Create({ Type = "Spell", ID = 20243                                                                            }),
    DragonRoar                                = Create({ Type = "Spell", ID = 118000, isTalent = true                                                            }),    -- Talent 3/3
    Ravager                                    = Create({ Type = "Spell", ID = 228920, isTalent = true                                                            }),    -- Talent 6/3
    Hamstring                                = Create({ Type = "Spell", ID = 1715                                                                             }),
    ShatteringThrow                            = Create({ Type = "Spell", ID = 64382                                                                             }),
    HeroicThrow                                = Create({ Type = "Spell", ID = 57755                                                                             }),
    Whirlwind                                = Create({ Type = "Spell", ID = 1680                                                                            }),
    -- Convenant
    SpearofBastion                            = Create({ Type = "Spell", ID = 307865                                                                             }),
    ConquerorsBanner                        = Create({ Type = "Spell", ID = 324143                                                                             }),
    AncientAftershock                        = Create({ Type = "Spell", ID = 325886                                                                             }),
    Condemn                                    = Create({ Type = "Spell", ID = 317349                                                                             }),
    -- Movememnt    
    Charge                                    = Create({ Type = "Spell", ID = 100                                                                                }),
    Intervene                                = Create({ Type = "Spell", ID = 3411                                                                            }),
    HeroicLeap                                = Create({ Type = "Spell", ID = 6544                                                                            }),
    -- Items
    PotionofUnbridledFury                     = Create({ Type = "Potion",  ID = 169299                                                                         }), 
    GalecallersBoon                          = Create({ Type = "Trinket", ID = 159614                                                                         }),    
    LustrousGoldenPlumage                    = Create({ Type = "Trinket", ID = 159617                                                                         }),    
    PocketsizedComputationDevice             = Create({ Type = "Trinket", ID = 167555                                                                         }),    
    AshvanesRazorCoral                       = Create({ Type = "Trinket", ID = 169311                                                                         }),    
    AzsharasFontofPower                      = Create({ Type = "Trinket", ID = 169314                                                                         }),    
    RemoteGuidanceDevice                     = Create({ Type = "Trinket", ID = 169769                                                                         }),    
    WrithingSegmentofDrestagath              = Create({ Type = "Trinket", ID = 173946                                                                         }),    
    DribblingInkpod                          = Create({ Type = "Trinket", ID = 169319                                                                         }),
    CorruptedAspirantsMedallion                = Create({ Type = "Trinket", ID = 184058                                                                         }),
    -- Gladiator Badges/Medallions
    DreadGladiatorsMedallion                 = Create({ Type = "Trinket", ID = 161674                                                                         }),    
    DreadCombatantsInsignia                  = Create({ Type = "Trinket", ID = 161676                                                                         }),    
    DreadCombatantsMedallion                 = Create({ Type = "Trinket", ID = 161811, Hidden = true                                                         }),    -- Game has something incorrect with displaying this
    DreadGladiatorsBadge                     = Create({ Type = "Trinket", ID = 161902                                                                         }),    
    DreadAspirantsMedallion                  = Create({ Type = "Trinket", ID = 162897                                                                         }),    
    DreadAspirantsBadge                      = Create({ Type = "Trinket", ID = 162966                                                                         }),    
    SinisterGladiatorsMedallion              = Create({ Type = "Trinket", ID = 165055                                                                         }),    
    SinisterGladiatorsBadge                  = Create({ Type = "Trinket", ID = 165058                                                                         }),    
    SinisterAspirantsMedallion               = Create({ Type = "Trinket", ID = 165220                                                                         }),    
    SinisterAspirantsBadge                   = Create({ Type = "Trinket", ID = 165223                                                                         }),    
    NotoriousGladiatorsMedallion             = Create({ Type = "Trinket", ID = 167377                                                                         }),    
    NotoriousGladiatorsBadge                 = Create({ Type = "Trinket", ID = 167380                                                                         }),    
    NotoriousAspirantsMedallion              = Create({ Type = "Trinket", ID = 167525                                                                         }),    
    NotoriousAspirantsBadge                  = Create({ Type = "Trinket", ID = 167528                                                                         }),    
    -- LegendaryPowers
    CadenceofFujieda                        = Create({ Type = "Spell", ID = 335555, Hidden = true                                                             }),
    -- Hidden
    ShieldBlockBuff                            = Create({ Type = "Spell", ID = 132404, Hidden = true                                                            }),
    RevengeBuff                                = Create({ Type = "Spell", ID = 5302, Hidden = true                                                                }),
    Overwatch                                = Create({ Type = "Spell", ID = 329035, Hidden = true, isTalent = true                                            }),    -- PvP Talent
    Devastator                                = Create({ Type = "Spell", ID = 236279, Hidden = true, isTalent = true                                            }),    -- Talent 1/3
    BoomingVoice                            = Create({ Type = "Spell", ID = 202743, Hidden = true, isTalent = true                                            }),    -- Talent 3/2
    UnstoppableForce                        = Create({ Type = "Spell", ID = 275336, Hidden = true, isTalent = true                                            }),    -- Talent 6/2
    
    -- Hidden  PvP Debuffs
    BidingShotDebuff                        = Create({ Type = "Spell", ID = 117405, Hidden = true                                                            }),
    ScatterShotDebuff                        = Create({ Type = "Spell", ID = 213691, Hidden = true                                                            }),
}

--Action:CreateCovenantsFor(ACTION_CONST_WARRIOR_PROTECTION)
--Action:CreateEssencesFor(ACTION_CONST_WARRIOR_PROTECTION)
local A = setmetatable(Action[ACTION_CONST_WARRIOR_PROTECTION], { __index = Action })

local player                                 = "player"
local target                                = "target"
local IsBurst                                = ToogleBurstZR()
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
        [A.AshvanesRazorCoral.ID]            = true,
        [A.CorruptedAspirantsMedallion.ID]    = true,
    },
    InterveneInstaIDs                        = {A.BidingShotDebuff.ID, A.ScatterShotDebuff.ID},
    BigDeff                                    = {A.ShieldWall.ID},
    SpellReflectTimer                        = 0,
    BurstPhase                                = 0,
    IsRallyngCrySupportive                    = false,
}
-- Initialization
Listener:Add("ACTION_EVENT_WARRIOR_SPELL_REFLECT", "UNIT_SPELLCAST_SUCCEEDED", function(...)
        local source, _, spellID = ...
        if source == player and A.SpellReflection.ID == spellID then 
            Temp.SpellReflectTimer = (math_random(25, 50) / 100)
        end
        
        if source == player and A.StormBolt.ID == spellID and GetToggle(2, "QueueStormBoltFocus") then
            SetToggle({2, "QueueStormBoltFocus", A.StormBolt:Info() .." Focus (Arena): "}, nil)
        end
end)

-- Util functions
local function SpellReflectTimerInit()
    if Temp.SpellReflectTimer == 0 then
        Temp.SpellReflectTimer = (math_random(25, 50) / 100)
    end
end
TMW:RegisterCallback("TMW_ACTION_IS_INITIALIZED", SpellReflectTimerInit)

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
    return A.ShieldSlam:IsInRange(unitID)
end 

local function GetByRange(count, range, isCheckEqual, isCheckCombat)
    -- @return boolean
    local c = 0
    for unitID in pairs(ActiveUnitPlates) do
        if (not isCheckEqual or not UnitIsUnit(target, unitID)) and (not isCheckCombat or Unit(unitID):CombatTime() > 0) and not Unit(unitID):IsExplosives() and not Unit(unitID):IsTotem() then
            if InMelee(unitID) then
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
end
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)

local function GetByRangeTTD(self, count, range)
    -- @return number
    local total, total_ttd = 0, 0
    
    for unitID in pairs(ActiveUnitPlates) do 
        if not range or Unit(unitID):CanInterract(range) then 
            total = total + 1
            total_ttd = total_ttd + Unit(unitID):TimeToDie()
        end 
        
        if count and total >= count then 
            break 
        end 
    end 
    
    if total > 0 then 
        return total_ttd / total     
    else  
        return huge
    end
end 
GetByRangeTTD = A.MakeFunctionCachedDynamic(GetByRangeTTD)

local function isCurrentlyTanking()
    -- return @boolean
    return (Unit(player):IsTankingAoE(16) or Unit(player):IsTanking("target", 16))
end

local function ShouldPressShieldBlock()
    -- return @boolean
    return isCurrentlyTanking() and A.ShieldBlock:IsReady(player) and ((Unit(player):HasBuffs(A.ShieldBlockBuff.ID, true) <= 1.5 * GetGCD()) and Unit(player):HasBuffs(A.LastStand.ID, true) == 0 and Player:Rage() >= 30)
end

local function SuggestRageDump(rageFromSpell)
    local rageMax                 = 80
    local shouldPreRageDump     = false
    local rage                    = Player:Rage()
    
    if rage >= 40 and A.IgnorePain:IsReady(player) and ShouldPressShieldBlock() then
        shouldPreRageDump = (rage + rageFromSpell >= rageMax) or shouldPreRageDump
    end
    
    if rage >= 40 and A.DemoralizingShout:IsReady(target, true) and InMelee(target) and not ShouldPressShieldBlock() then
        shouldPreRageDump = true
    end
    
    return shouldPreRageDump
end


local function CanIgnorePain(variation) 
    -- returns @boolean
    if Unit(player):HasBuffs(A.IgnorePain.ID, true) > 0 then
        local description     = A.IgnorePain:GetSpellDescription()
        local summary         = description[1]
        local total         = summary * variation
        
        if Unit(player):HasBuffs(A.IgnorePain.ID, true) < (0.5 * total) then
            return true
        else
            return false
        end
    else
        return true
    end
end

local function countInterruptGCD(unitID)
    -- returns @boolean
    if not A.Pummel:IsReadyByPassCastGCD(unitID) or not A.Pummel:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then 
        return true 
    end 
end

-- Reset Vars
local function ResetVars()
    Temp.BurstPhase = 0
    if Temp.IsRallyngCrySupportive then
        Temp.IsRallyngCrySupportive = false
    end
    
    if GetToggle(2, "QueueStormBoltFocus") then
        SetToggle({2, "QueueStormBoltFocus", A.StormBolt:Info() .." Focus (Arena): "}, nil)
    end
end
TMW:RegisterCallback("TMW_ACTION_ENTERING", ResetVars)


local BurstPhase = {}
local btn_PrepareBurst = false
Action.PrepareBurst = function(self, ...)
    btn_PrepareBurst = not btn_PrepareBurst
    if not btn_PrepareBurst then 
        wipe(BurstPhase)
    end
    Print("Prepare  Burst: " .. toStr[btn_PrepareBurst])
end


-- [1] CC AntiFake Rotation
local function AntiFakeStun(unitID) 
    return 
    IsUnitEnemy(unitID) and  
    Unit(unitID):GetRange() <= 20 and 
    Unit(unitID):IsControlAble("stun") and 
    A.StormBoltGreen:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true)          
end 
A[1] = function(icon)    
    if     A.StormBoltGreen:IsReady(nil, true, nil, true) and AntiFakeStun("target")
    then 
        return A.StormBoltGreen:Show(icon)         
    end                                                                     
end

-- [2] Kick AntiFake Rotation
A[2] = function(icon)        
    local unitID
    if IsUnitEnemy("mouseover") then 
        unitID = "mouseover"
    elseif IsUnitEnemy("target") then 
        unitID = "target"
    end 
    
    if unitID then         
        local castLeft, _, _, _, notKickAble = Unit(unitID):IsCastingRemains()
        if castLeft > 0 then             
            if not notKickAble and A.PummelGreen:IsReady(unitID, nil, nil, true) and A.PummelGreen:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
                return A.PummelGreen:Show(icon)                                                  
            end 
            
            if A.StormBoltGreen:IsReady(unitID, nil, nil, true) and Unit(unitID):IsControlAble("stun") and A.StormBoltGreen:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true) then
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
    -- RallyingCry
    local RallyingCry = GetToggle(2, "RallyingCry")
    if     RallyingCry >= 0 and A.RallyingCry:IsReady(player) and 
    (
        (     -- Auto 
            RallyingCry >= 100 and 
            (
                (
                    not A.IsInPvP and 
                    Unit(player):HealthPercent() < 25 and 
                    Unit(player):TimeToDieX(5) < 6 
                ) or 
                (
                    A.IsInPvP and Unit(player):HealthPercent() < 25 and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused(nil, true)                                 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs") == 0
        ) or 
        (    -- Custom
            RallyingCry < 100 and 
            Unit(player):HealthPercent() <= RallyingCry
        )
    ) 
    then 
        return A.RallyingCry
    end
    
    -- DiebytheSword
    local DiebytheSword = GetToggle(2, "DiebytheSword")
    if     DiebytheSword >= 0 and A.DiebytheSword:IsReady(player) and 
    (
        (     -- Auto 
            DiebytheSword >= 100 and 
            (
                (
                    not A.IsInPvP and 
                    Unit(player):HealthPercent() < 40 and 
                    Unit(player):TimeToDieX(20) < 6 
                ) or 
                (
                    A.IsInPvP and Unit(player):HealthPercent() < 40 and
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused(nil, true)                                 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs") == 0
        ) or 
        (    -- Custom
            DiebytheSword < 100 and 
            Unit(player):HealthPercent() <= DiebytheSword
        )
    ) 
    then 
        return A.DiebytheSword
    end
    
    -- Stoneform (On Deffensive)
    local Stoneform = GetToggle(2, "Stoneform")
    if     Stoneform >= 0 and A.Stoneform:IsRacialReadyP(player) and 
    (
        (     -- Auto 
            Stoneform >= 100 and 
            (
                (
                    not A.IsInPvP and                         
                    Unit(player):TimeToDieX(65) < 3 
                ) or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused()                                 
                        )
                    )
                )
            ) 
        ) or 
        (    -- Custom
            Stoneform < 100 and 
            Unit(player):HealthPercent() <= Stoneform
        )
    ) 
    then 
        return A.Stoneform
    end
    
    -- Ignore Pain 
    local IgnorePain = GetToggle(2, "IgnorePain")        
    if IgnorePain >= 0 and A.IgnorePain:IsReady(player) and CanIgnorePain(1.3) and
    (
        (    -- Auto
            IgnorePain >= 100 and
            ( 
                A.IsInPvP and
                (
                    Player:Rage() > 80 or
                    Player:Rage() >= 50 and
                    Unit(player):IsFocused() or 
                    Unit(player):HealthPercent() < 70
                ) or
                not A.IsInPvP and isCurrentlyTanking() and
                (
                    Unit(player):TimeToDieX(60) < 2 or
                    Unit(player):HealthPercent() < 70
                )
            ) 
        ) or -- Custom
        (
            IgnorePain < 100 and
            Unit(player):HealthPercent() < IgnorePain
        )
    )
    then 
        return A.IgnorePain
    end
    
    -- VictoryRush 
    local VictoryRush = GetToggle(2, "VictoryRush")
    if VictoryRush >= 0 and IsUnitEnemy("target") and A.VictoryRush:IsReady("target") and Unit(player):HealthPercent() <= VictoryRush and A.VictoryRush:AbsentImun("target", Temp.TotalAndPhys) then
        return A.VictoryRush
    end
    
    -- Stoneform (Self Dispel)
    if not A.IsInPvP and A.Stoneform:IsRacialReady(player, true) and AuraIsValid(player, "UseDispel", "Dispel") then 
        return A.Stoneform
    end
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
    
    if useCC and A.StormBolt:IsReady(unitID) and (Unit(unitID):IsControlAble("stun") or isMythicPlus) and A.StormBolt:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true) then
        return A.StormBolt     
    end
    
    if useCC and A.IntimidatingShout:IsReady(unitID, true) and Unit(unitID):GetRange() <= 8 and (Unit(unitID):IsControlAble("fear") or isMythicPlus) and A.IntimidatingShout:AbsentImun(unitID, Temp.TotalAndPhysAndCC, true) then 
        return A.IntimidatingShout              
    end 
end

-- Usage of trinkets
local function UseItems(unitID)
    if A.Trinket1:IsReady(unitID) and A.Trinket1:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] and A.Trinket1:AbsentImun(unitID, Temp.TotalAndMagPhys) then 
        return A.Trinket1
    end 
    
    if A.Trinket2:IsReady(unitID) and A.Trinket2:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] and A.Trinket2:AbsentImun(unitID, Temp.TotalAndMagPhys) then 
        return A.Trinket2
    end     
end

-- [3] Single Rotation
A[3] = function(icon)
    local EnemyRotation
    local isMoving                = Player:IsMoving()                    -- @boolean 
    local inCombat                = Unit(player):CombatTime()            -- @number 
    local inAoE                    = GetToggle(2, "AoE")                -- @boolean
    local refreshTime            = (GetGCD() + GetCurrentGCD() + GetLatency() + (TMW.UPD_INTV or 0) + ACTION_CONST_CACHE_DEFAULT_TIMER)
    local rage                    = Player:Rage()
    local rageDeficit            = Player:RageDeficit()
    local offensiveRage            = GetToggle(2, "offensiveRage")
    local offensiveShieldBlock    = GetToggle(2, "offensiveShieldBlock")
    
    
    -- [Shared] [Util] [Berserker Rage] - Break fear /w delay
    if LoC:IsValid(Temp.BerserkerRageLoC) and GetToggle(2, "UseBerserkerRage-LoC") and A.BerserkerRage:IsReadyP(player) and not A.BerserkerRage:IsSuspended((math_random(15, 35) / 100), 6) then
        return A.BerserkerRage:Show(icon)
    end
    
    -- [Shared] [Util] [Battle Shout]
    if A.BattleShout:IsReady(player) and (Unit(player):HasBuffs(A.BattleShout.ID) == 0) then
        return A.BattleShout:Show(icon)
    end
    
    -- [[ SELF DEFENSE ]] 
    if inCombat > 0 then             
        -- Shield Wall
        if A.ShieldWall:IsReadyByPassCastGCD(player, nil, nil, true) then 
            local SW_HP                    = GetToggle(2, "ShieldWallHP")
            local SW_TTD                = GetToggle(2, "ShieldWallTTD")
            
            if  (    
                ( SW_HP     >= 0     or SW_TTD                              >= 0                                        ) and 
                ( SW_HP     <= 0     or Unit(player):HealthPercent()     <= SW_HP                                    ) and 
                ( SW_TTD     <= 0     or Unit(player):TimeToDie()         <= SW_TTD                                      ) 
            ) or 
            (
                GetToggle(2, "ShieldWallCatchKillStrike") and 
                inCombat > 4 and 
                (
                    ( Unit(player):GetDMG()            >= Unit(player):Health() and Unit(player):HealthPercent() <= 20 ) or 
                    Unit(player):GetRealTimeDMG()    >= Unit(player):Health() or 
                    Unit(player):TimeToDie()        <= GetGCD()
                )
            )                
            then                
                return A.ShieldWall:Show(icon)
            end 
        end
        
        -- Last Stand
        if A.LastStand:IsReadyByPassCastGCD(player, nil, nil, true) and Unit(player):HasBuffs(Temp.BigDeff) == 0 then 
            local LS_HP                    = GetToggle(2, "LastStandHP")
            local LS_TTD                = GetToggle(2, "LastStandTTD")
            
            if  (    
                ( LS_HP     >= 0     or LS_TTD                              >= 0                                        ) and 
                ( LS_HP     <= 0     or Unit(player):HealthPercent()     <= LS_HP                                    ) and 
                ( LS_TTD     <= 0     or Unit(player):TimeToDie()         <= LS_TTD                                      ) 
            ) or 
            (
                GetToggle(2, "LastStandCatchKillStrike") and 
                inCombat > 4 and 
                (
                    ( Unit(player):GetDMG()            >= Unit(player):Health() and Unit(player):HealthPercent() <= 20 ) or 
                    Unit(player):GetRealTimeDMG()    >= Unit(player):Health() or 
                    Unit(player):TimeToDie()        <= GetGCD()
                )
            )                
            then                
                return A.LastStand:Show(icon)
            end 
        end 
        
        -- Rallying Cry
        if A.RallyingCry:IsReady(player) and Unit(player):HasBuffs(Temp.BigDeff) == 0 then 
            local RC_HP                    = GetToggle(2, "RallyingCryHP")
            local RC_TTD                = GetToggle(2, "RallyingCryTTD")
            
            if  (    
                ( RC_HP     >= 0     or RC_TTD                              >= 0                                        ) and 
                ( RC_HP     <= 0     or Unit(player):HealthPercent()     <= RC_HP                                    ) and 
                ( RC_TTD     <= 0     or Unit(player):TimeToDie()         <= RC_TTD                                      ) 
            ) or 
            (
                GetToggle(2, "RallyingCryCatchKillStrike") and 
                inCombat > 4 and 
                (
                    ( Unit(player):GetDMG()            >= Unit(player):Health() and Unit(player):HealthPercent() <= 20 ) or 
                    Unit(player):GetRealTimeDMG()    >= Unit(player):Health() or 
                    Unit(player):TimeToDie()        <= GetGCD()
                )
            )                
            then                
                return A.RallyingCry:Show(icon)
            end 
        end 
        
        local IgnorePainHP            = GetToggle(2, "IgnorePain")        
        -- Ignore Pain 
        if A.IgnorePain:IsReady(player, nil, nil, true) and rage >= A.IgnorePain:GetSpellPowerCostCache() and isCurrentlyTanking() and CanIgnorePain(1.3) and
        (
            Unit(player):HealthPercent() <= IgnorePainHP
        ) and 
        (
            rageDeficit < 25 + 25 * (A.BoomingVoice:IsSpellLearned() and 1 or 0) * (A.DemoralizingShout:GetCooldown() == 0 and 1 or 0)
        ) then
            return A.IgnorePain:Show(icon)
        end
        
        local ShieldBlockHP            = GetToggle(2, "ShieldBlockHP")
        local ShieldBlockHits        = GetToggle(2, "ShieldBlockHits")
        local ShieldBlockPhys        = GetToggle(2, "ShieldBlockPhys")            
        local Hits, Phys             = Unit(player):GetRealTimeDMG(2)
        -- Shield Block
        if A.ShieldBlock:IsReadyByPassCastGCD(player, nil, nil, true) and rage >= A.ShieldBlock:GetSpellPowerCostCache() and isCurrentlyTanking() and 
        (
            Unit(player):HealthPercent() <= ShieldBlockHP and
            Hits  >= ShieldBlockHits and 
            Phys * 100 / Unit(player):HealthMax() >= ShieldBlockPhys
        ) and 
        (
            (
                Unit(player):HasBuffs(A.ShieldBlockBuff.ID) == 0 or 
                Unit(player):HasBuffs(A.ShieldBlockBuff.ID) <= refreshTime
            ) and 
            Unit(player):HasBuffs(A.LastStand.ID) == 0
        ) then
            return A.ShieldBlock:Show(icon)
        end
        
        --Reflection
        if ShouldSpellReflect(player, Temp.SpellReflectTimer) then
            return A.SpellReflection:Show(icon)
        end
    end
    
    function EnemyRotation(unitID)
        -- Variables
        local canCleave         = true
        local isBurst            = BurstIsON(unitID)
        
        -- Check if target is explosive or totem for dont use AoE spells 
        if not Unit(unitID):IsExplosives() and not Unit(unitID):IsTotem() then
            canCleave = true
        end
        
        -- Purge
        if A.ArcaneTorrent:AutoRacial(unitID) then 
            return A.ArcaneTorrent:Show(icon)
        end             
        
        -- Interrupts
        local Interrupt = Interrupts(unitID)
        if Interrupt then 
            return Interrupt:Show(icon)
        end
        
        -- PvP CrownControl 
        -- Disarm
        if ShouldDisarm(unitID) then 
            return A.Disarm:Show(icon)
        end
        
        -- [[ BURST ]]
        local function CD()
            -- blood_fury
            if A.BloodFury:AutoRacial(unitID) then
                return A.BloodFury:Show(icon)
            end
            
            -- berserking
            if A.Berserking:AutoRacial(unitID) then
                return A.Berserking:Show(icon)
            end
            
            -- lights_judgment
            if A.LightsJudgment:IsReady(unitID) then
                return A.LightsJudgment:Show(icon)
            end
            
            -- fireblood
            if A.Fireblood:AutoRacial(unitID) then
                return A.Fireblood:Show(icon)
            end
            
            -- ancestral_call
            if A.AncestralCall:AutoRacial(unitID) then
                return A.AncestralCall:Show(icon)
            end
            
            -- bag_of_tricks
            if A.BagofTricks:AutoRacial(unitID) then
                return A.BagofTricks:Show(icon)
            end
            
            -- Avatar
            if A.Avatar:IsReadyByPassCastGCD(player) and Unit(player):HasBuffs(A.Avatar.ID) == 0 then
                return A.Avatar:Show(icon)
            end
            
            if A.SpearofBastion:IsReady(unitID, true) and InMelee(unitID) and A.SpearofBastion:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.SpearofBastion:Show(icon)
            end
            
            if A.ConquerorsBanner:IsReady(player) and InMelee(unitID) and Unit(player):HasBuffs(A.Recklessness.ID, true) > 0 then
                return A.ConquerorsBanner:Show(icon)
            end
            
            if A.AncientAftershock:IsReady(player) and InMelee(unitID) and Unit(player):HasBuffs(A.Avatar.ID) > 0 then
                return A.AncientAftershock:Show(icon)
            end
            
            
            if A.Trinket1:IsReady(unitID) and A.Trinket1:GetItemCategory() ~= "DEFF" and A.Trinket1:AbsentImun(unitID, Temp.TotalAndMagPhys) and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] and Unit(player):HasBuffs(A.Avatar.ID) > 0 then
                return A.Trinket1:Show(icon)    
            end
            
            if A.Trinket2:IsReady(unitID) and A.Trinket2:GetItemCategory() ~= "DEFF" and A.Trinket2:AbsentImun(unitID, Temp.TotalAndMagPhys) and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] and Unit(player):HasBuffs(A.Avatar.ID) > 0 then
                return A.Trinket2:Show(icon)    
            end
        end
        
        -- [[ AoE ]] 
        local function AoE() 
            -- Thunder Clap
            if A.ThunderClap:IsReady(unitID, true) and Unit(unitID):GetRange() <= 10 and canCleave and A.ThunderClap:AbsentImun(unitID, Temp.AttackTypes) then
                return A.ThunderClap:Show(icon)
            end
            
            -- [[ BURST ]]  
            if isBurst and InMelee(unitID) and Unit(unitID):TimeToDie() > 6 then
                -- Dragon Roar
                if A.DragonRoar:IsReady(unitID, true) and A.DragonRoar:AbsentImun(unitID, Temp.AttackTypes) then 
                    return A.DragonRoar:Show(icon)
                end
                
                -- Ravager
                if A.Ravager:IsReady(unitID, true) and A.Ravager:AbsentImun(unitID, Temp.AttackTypes) then 
                    return A.Ravager:Show(icon)
                end
            end
            
            -- Demoralizing Shout
            if A.DemoralizingShout:IsReady(unitID, true) and InMelee(unitID) and canCleave and (A.BoomingVoice:IsSpellLearned() and rageDeficit >= 40 or not A.BoomingVoice:IsSpellLearned()) and A.DemoralizingShout:AbsentImun(unitID, Temp.AttackTypes) then
                return A.DemoralizingShout:Show(icon)
            end
            
            -- Revenge
            if A.Revenge:IsReady(unitID, true) and InMelee(unitID) and canCleave and (Unit(player):HasBuffs(A.RevengeBuff.ID) > 0 or offensiveRage or rage >= 75 or (not isCurrentlyTanking() and rage >= 50)) and A.Revenge:AbsentImun(unitID, Temp.AttackTypes) then
                return A.Revenge:Show(icon)
            end
            
            -- Shield Block Offensive
            if A.ShieldBlock:IsReady(player) and InMelee(unitID) and (A.ShieldSlam:GetCooldown() == 0 and Unit(player):HasBuffs(A.ShieldBlockBuff.ID) == 0 and offensiveShieldBlock) then
                return A.ShieldBlock:Show(icon)
            end
            
            -- Shield Slam
            if A.ShieldSlam:IsReady(unitID) and A.ShieldSlam:AbsentImun(unitID, Temp.AttackTypes) then 
                return A.ShieldSlam:Show(icon)
            end
            
            -- Devastate
            if A.Devastate:IsReady(unitID) and not A.Devastator:IsSpellLearned() and A.Devastate:AbsentImun(unitID, Temp.AttackTypes) then 
                return A.Devastate:Show(icon)
            end
        end
        
        -- [[ SINGLE TARGET ]] 
        local function ST()
            -- Thunder Clap
            if A.ThunderClap:IsReady(unitID, true) and Unit(unitID):GetRange() <= 10 and canCleave and (inAoE and GetByRange(2, 10) and A.UnstoppableForce:IsSpellLearned() and Unit(player):HasBuffs(A.Avatar.ID) > 0) and A.ThunderClap:AbsentImun(unitID, Temp.AttackTypes) then
                --if SuggestRageDump(5) then
                --    return A.IgnorePain:Show(icon)
                --end
                return A.ThunderClap:Show(icon)
            end
            
            -- Shield Slam
            if A.ShieldSlam:IsReady(unitID) and Unit(player):HasBuffs(A.ShieldBlockBuff.ID) > 0 and A.ShieldSlam:AbsentImun(unitID, Temp.AttackTypes) then 
                --if SuggestRageDump(15) then
                --    return A.IgnorePain:Show(icon)
                --end
                return A.ShieldSlam:Show(icon)
            end
            
            -- Thunder Clap
            if A.ThunderClap:IsReady(unitID, true) and Unit(unitID):GetRange() <= 10 and canCleave and (A.UnstoppableForce:IsSpellLearned() and Unit(player):HasBuffs(A.Avatar.ID) > 0) and A.ThunderClap:AbsentImun(unitID, Temp.AttackTypes) then
                --if SuggestRageDump(5) then
                --    return A.IgnorePain:Show(icon)
                --end
                return A.ThunderClap:Show(icon)
            end
            
            -- Demoralizing Shout
            if A.DemoralizingShout:IsReady(unitID, true) and InMelee(unitID) and canCleave and (A.BoomingVoice:IsSpellLearned() and rageDeficit >= 40 or not A.BoomingVoice:IsSpellLearned()) and A.DemoralizingShout:AbsentImun(unitID, Temp.AttackTypes) then
                --if SuggestRageDump(40) then
                --    return A.IgnorePain:Show(icon)
                --end
                return A.DemoralizingShout:Show(icon)
            end
            
            -- Shield Slam
            if A.ShieldSlam:IsReady(unitID) and A.ShieldSlam:AbsentImun(unitID, Temp.AttackTypes) then 
                return A.ShieldSlam:Show(icon)
            end
            
            -- Dragon Roar
            if A.DragonRoar:IsReady(unitID, true) and InMelee(unitID) and A.DragonRoar:AbsentImun(unitID, Temp.AttackTypes) then
                return A.DragonRoar:Show(icon)
            end
            
            -- Thunder Clap
            if A.ThunderClap:IsReady(unitID, true) and Unit(unitID):GetRange() <= 10 and canCleave and A.ThunderClap:AbsentImun(unitID, Temp.AttackTypes) then
                --if SuggestRageDump(5) then
                --    return A.IgnorePain:Show(icon)
                --end
                return A.ThunderClap:Show(icon)
            end
            
            -- Execute
            if A.Execute:IsReady(unitID) and offensiveRage and A.Execute:AbsentImun(unitID, Temp.AttackTypes) then
                return A.Execute:Show(icon)
            end
            
            -- Revenge
            if A.Revenge:IsReady(unitID, true) and InMelee(unitID) and canCleave and (Unit(player):HasBuffs(A.RevengeBuff.ID) > 0 or offensiveRage or rage >= 75 or (not isCurrentlyTanking() and rage >= 50)) and A.Revenge:AbsentImun(unitID, Temp.AttackTypes) then
                return A.Revenge:Show(icon)
            end
            
            -- Ravager
            if A.Ravager:IsReady(unitID, true) and InMelee(unitID) and A.Ravager:AbsentImun(unitID, Temp.AttackTypes) then
                return A.Ravager:Show(icon)
            end
            
            -- Devastate
            if A.Devastate:IsReady(unitID) and not A.Devastator:IsSpellLearned() and A.Devastate:AbsentImun(unitID, Temp.AttackTypes) then 
                return A.Devastate:Show(icon)
            end
        end
        
        -- VictoryRush Defensives
        local VictoryRush    = GetToggle(2, "VictoryRush")
        if VictoryRush >= 0 and A.VictoryRush:IsReady(unitID) and
        (
            (
                VictoryRush >= 100 and
                Unit(player):HealthPercent() <= 80
            ) or
            (
                VictoryRush < 100 and
                Unit(player):HealthPercent() <= VictoryRush
            )
        ) and A.VictoryRush:AbsentImun(unitID, Temp.TotalAndPhys) then
            return A.VictoryRush:Show(icon)
        end
        
        -- [[ BURST ]]
        if isBurst and InMelee(unitID) and Unit(unitID):TimeToDie() > 6 and CD() then
            return true
        end
        
        -- [[ AoE ]] 
        if inAoE and GetByRange(3, 8) and AoE() then
            return true
        end
        
        -- [[ SINGLE TARGET ]]
        if ST() then
            return true
        end
    end
    
    -- Target     
    if IsUnitEnemy("target") and EnemyRotation("target") then 
        return true 
    end
end 

A[4] = nil
A[5] = nil 

-- Passive 
local function FreezingTrapUsedByEnemy()
    if     UnitCooldown:GetCooldown("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) > UnitCooldown:GetMaxDuration("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) - 2 and 
    UnitCooldown:IsSpellInFly("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) and 
    Unit(player):GetDR("incapacitate") > 0 
    then 
        local Caster = UnitCooldown:GetUnitID("arena", ACTION_CONST_SPELLID_FREEZING_TRAP)
        if Caster and Unit(Caster):GetRange() <= 40 then 
            return true 
        end 
    end 
end 

local function ArenaRotation(icon, unitID)
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then             
        -- Note: "arena1" is just identification of meta 6
        if unitID == "arena1" and (Unit(player):GetDMG() == 0 or not Unit(player):IsFocused("DAMAGER")) then                 
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
                if Unit(player):CombatTime() <= 5 and (Unit(player):CombatTime() > 0 or Unit("target"):CombatTime() > 0 or MultiUnits:GetByRangeInCombat(40, 1) >= 1) then 
                    return A.Taunt:Show(icon) 
                end 
                
                -- Roots if not available freedom 
                if LoC:Get("ROOT") > 0 then 
                    return A.Taunt:Show(icon) 
                end 
            end 
        end
        
        -- StormBolt Focus
        if GetToggle(2, "QueueStormBoltFocus") then
            if not Unit("focus"):IsExists() or A.StormBolt:GetCooldown() > 0 then
                SetToggle({2, "QueueStormBoltFocus", A.StormBolt:Info() .." Focus (Arena): "}, nil)
                return true
            end
            
            if UnitIsUnit(unitID,"focus") and A.StormBolt:IsReadyByPassCastGCD(unitID) then
                return A.StormBolt:Show(icon)
            end
        end
        
        -- Interrupt - Pummel (checkbox "useKick" for Interrupts tab in "PvP" and "Heal" categories)
        if A.Pummel:CanInterruptPassive(unitID) then 
            return A.Pummel:Show(icon) 
        end 
        
        -- Interrupt - StormBolt (checkbox "useCC" for Interrupts tab in "PvP" and "Heal" categories)
        if A.StormBolt:CanInterruptPassive(unitID, countInterruptGCD(unitID)) then 
            return A.StormBolt:Show(icon) 
        end 
        
        -- Disarm
        if ShouldDisarm(unitID) and A.Disarm:IsSuspended((math_random(10, 30) / 100), 6) then
            if A.Disarm:IsReady(unitID) then
                return A.Disarm:Show(icon)
            end
        end        
        
        -- AutoSwitcher
        if unitID == "arena1" and GetToggle(1, "AutoTarget") and IsUnitEnemy(target) and not A.AbsentImun(nil, target, Temp.TotalAndPhys) and MultiUnits:GetByRangeInCombat(12, 2) >= 2 then 
            return A:Show(icon, ACTION_CONST_AUTOTARGET)
        end
    end 
end 

local function PartyRotation(icon, unitID)
    -- Intevene is ready and unit not in LOS
    if A.Intervene:IsReadyByPassCastGCD(unitID) and not Unit(unitID):InLOS() and not
    -- Don't intervene if I have Avatar & intervene target > 5 yards away
    (
        (
            Unit(player):HasBuffs(A.Avatar.ID, true) > 0 or Unit(target):HealthPercent() < 25 
        ) and 
        Unit(unitID):GetRange() >= 5    
    ) and
    ( 
        -- Intervene when passes logic from ProfileUI or it is a scatter shot / binding shot
        A.Overwatch:IsSpellLearned() and
        (IntervenePvP(unitID, Temp.SpellReflectTimer) or Unit(unitID):HasDeBuffs(Temp.InterveneInstaIDs) > 0) or
        -- Peel teamate if hp less then 25%
        Unit(player):HealthPercent() < 25 or 
        -- Peel teamate if not overwatch talent and enemy burst
        --not A.Overpower:IsSpellLearned() and 
        Unit(unitID):IsFocused(nil, true)        
    )
    then
        return A.Intervene:Show(icon)
    end
    
    -- RallyingCry PvP Supportive
    if A.IsInPvP and A.RallyingCry:IsReady(player) and Unit(unitID):GetRange() < 35 and Unit(unitID):HealthPercent() > 0 and Unit(unitID):HealthPercent() < GetToggle(2, "RallyingCryParty") then
        Temp.IsRallyngCrySupportive = true
    end
end

A[6] = function(icon)        
    return ArenaRotation(icon, "arena1")
end

A[7] = function(icon)
    
    return ArenaRotation(icon, "arena2")
end

A[8] = function(icon)
    return ArenaRotation(icon, "arena3")
end

