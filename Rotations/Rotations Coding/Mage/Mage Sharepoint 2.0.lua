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
local GetLatency                        = Action.GetLatency
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
local ACTION_CONST_MAGE_FROST           = Action.Const.MAGE_FROST
local Utils                             = Action.Utils
local ActiveUnitPlates                  = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit, UnitExists, IsMounted, UnitThreatSituation, UnitCanAttack, IsInRaid, UnitDetailedThreatSituation, IsResting, GetItemCount, debugprofilestop = 
_G.IsIndoors, _G.UnitIsUnit, _G.IsMounted, _G.UnitThreatSituation, _G.UnitCanAttack, _G.IsInRaid, _G.UnitDetailedThreatSituation, _G.IsResting, _G.GetItemCount, _G.debugprofilestop


--###########################################
--##### ARCANE MAGE SPELLS #################
--###########################################


Action[ACTION_CONST_MAGE_FROST] = {
    -- Racial
    ArcaneTorrent       = Action.Create({ Type = "Spell", ID = 50613     }),
    BloodFury           = Action.Create({ Type = "Spell", ID = 20572     }),
    Fireblood           = Action.Create({ Type = "Spell", ID = 265221    }),
    AncestralCall       = Action.Create({ Type = "Spell", ID = 274738    }),
    Berserking          = Action.Create({ Type = "Spell", ID = 26297     }),
    QuakingPalm         = Action.Create({ Type = "Spell", ID = 107079    }),
    Haymaker            = Action.Create({ Type = "Spell", ID = 287712    }),
    WarStomp            = Action.Create({ Type = "Spell", ID = 20549     }),
    BullRush            = Action.Create({ Type = "Spell", ID = 255654    }),
    GiftofNaaru         = Action.Create({ Type = "Spell", ID = 59544     }),
    Shadowmeld          = Action.Create({ Type = "Spell", ID = 58984     }),
    Stoneform           = Action.Create({ Type = "Spell", ID = 20594     }),
    BlessingOfSummer    = Action.Create({ Type = "Spell", ID = 328620    }),
    BlessingOfAutumn    = Action.Create({ Type = "Spell", ID = 328622    }),
    
    -- Mage General
    ArcaneIntellect     = Action.Create({ Type = "Spell", ID = 1459      }),
    Blink               = Action.Create({ Type = "Spell", ID = 1953      }),
    Shimmer             = Action.Create({ Type = "Spell", ID = 212653    }),
    TimeWarp            = Action.Create({ Type = "Spell", ID = 80353     }),
    SlowFall            = Action.Create({ Type = "Spell", ID = 130       }),
    ShiftingPower       = Action.Create({ Type = "Spell", ID = 382440    }),
    FrostNova           = Action.Create({ Type = "Spell", ID = 122       }),
    FrostBolt           = Action.Create({ Type = "Spell", ID = 116       }),
    GravityLapse        = Action.Create({ Type = "Spell", ID = 449700    }),
    GreaterInvisibility = Action.Create({ Type = "Spell", ID = 110959    }),
    IceBlock            = Action.Create({ Type = "Spell", ID = 45438     }),
    MassBarrier         = Action.Create({ Type = "Spell", ID = 414660    }),
    MirrorImage         = Action.Create({ Type = "Spell", ID = 55342     }),
    Polymorph           = Action.Create({ Type = "Spell", ID = 118       }),
    AlterTime           = Action.Create({ Type = "Spell", ID = 342245    }),
    ArcaneExplosion     = Action.Create({ Type = "Spell", ID = 1449      }),
    BlastWave           = Action.Create({ Type = "Spell", ID = 157981    }),
    ConjureRefreshment  = Action.Create({ Type = "Spell", ID = 190336    }),
    Counterspell        = Action.Create({ Type = "Spell", ID = 2139      }),
    ConeofCold          = Action.Create({ Type = "Spell", ID = 120       }),
    FireBlast           = Action.Create({ Type = "Spell", ID = 319836    }),
    Supernova           = Action.Create({ Type = "Spell", ID = 157980, isTalent = true}),
    DragonBreath        = Action.Create({ Type = "Spell", ID = 31661, isTalent = true}),
    MassInvincibility   = Action.Create({ Type = "Spell", ID = 414664, isTalent = true}),
    IceFloes            = Action.Create({ Type = "Spell", ID = 108839    }),
    RingOfFrost         = Action.Create({ Type = "Spell", ID = 113724    }),
    IceNova             = Action.Create({ Type = "Spell", ID = 157997    }),
    Evocation           = Action.Create({ Type = "Spell", ID = 12051     }),
    
    -- Arcane Spells
    ArcaneBarrage       = Action.Create({ Type = "Spell", ID = 44425     }),
    ArcaneBlast         = Action.Create({ Type = "Spell", ID = 30451     }),
    ArcaneMissiles      = Action.Create({ Type = "Spell", ID = 5143      }),
    ArcaneOrb           = Action.Create({ Type = "Spell", ID = 153626    }),
    ArcaneSurge         = Action.Create({ Type = "Spell", ID = 365350    }),
    CounterSpellGreen   = Create({ Type = "SpellSingleColor", ID = 2139, Color = "GREEN", Desc = "[1] CC", Hidden = true, QueueForbidden = true}),
    IceBarrier          = Action.Create({ Type = "Spell", ID = 11426     }),
    ColdSnap            = Action.Create({ Type = "Spell", ID = 235219    }),
    TouchOfTheMagi      = Action.Create({ Type = "Spell", ID = 321507    }),
    ArcaneBombardment   = Action.Create({ Type = "Spell", ID = 384581, isTalent = true}),
    Reverberate         = Action.Create({ Type = "Spell", ID = 281482, isTalent = true}),
    SpymastersWeb       = Action.Create({ Type = "Item", ID = 220202, Hidden = true}),
    SpymastersWebBuff   = Action.Create({ Type = "Spell", ID = 444959}),
    
    -- Talents
    SpellSlinger        = Action.Create({ Type = "Spell", ID = 443739, isTalent = true}),
    SunFury             = Action.Create({ Type = "Spell", ID = 448601, isTalent = true}),
    HighVoltage         = Action.Create({ Type = "Spell", ID = 260189, isTalent = true}),
    

}


local A = setmetatable(Action[ACTION_CONST_MAGE_FROST], { __index = Action })

local player = "player"
local target = "target"
local mouseover = "mouseover"
local focus = "focus"

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
--##### ROTATION VARS ########
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

--############################
--##### HELPER FUNCTIONS #####
--############################

local function BurstIsON(unitID)
    return Action.BurstIsON(unitID) or GetToggle(2, "BurstOnCooldown")
end

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
            if not notKickAble and A.CounterSpellGreen:IsReady(unitID, nil, nil, true) and A.CounterSpellGreen:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
                return A.CounterSpellGreen:Show(icon)
            end
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

local function InRange(unitID)
    return A.ArcaneBlast:IsInRange(unitID)
end

InRange = A.MakeFunctionCachedDynamic(InRange)


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

local function SelfDefensives()

    local inCombat = Unit(player):CombatTime()
    if Unit(player):CombatTime() == 0 then
        return
    end
    local unitID
    if A.IsUnitEnemy("target") then
        unitID = "target"
    elseif A.IsUnitEnemy("mouseover") then
        unitID = "mouseover"
    end
    
    local playerHP = Unit(player):HealthPercent()
    local playerMaxHP = Unit(player):HealthMax()
    local playerDMG = Unit(player):GetDMG() * 100 / playerMaxHP
    local realTimeDMG = Unit(player):GetRealTimeDMG() >= playerMaxHP * 0.10
    local timeToDie = Unit(player):TimeToDieX(25)
    local noDefensiveActive = Unit(player):HasBuffs(A.IceBlock.ID) == 0 and Unit(player):HasBuffs(A.IceBarrier.ID) == 0
    local inCombat = Unit(player):CombatTime() > 0

    if A.IceBarrier:IsReady(player) and inCombat and Unit(player):HasBuffs(A.IceBarrier.ID) == 0 then
        return A.IceBarrier
    end
    if A.AlterTime:IsReady(player) and playerHP <= 60 and 
        (playerDMG >= 10 or realTimeDMG or timeToDie < 15) then
        return A.AlterTime
    end
    if noDefensiveActive and A.MirrorImage:IsReady(player) and (playerHP <= 60 or MultiUnits:GetByRangeCasting(60, 1) >= 1) then
        return A.MirrorImage
    end
    if A.ColdSnap:IsReady(player) and A.IceBlock:GetCooldown() > 60 and Unit(player):HealthPercent() <= 45 then
        return A.ColdSnap
    end
    if A.IceBlock:IsReady(player) and playerHP <= 20 then
        return A.IceBlock
    end
    if A.Healthstone:IsReady(player) and playerHP <= GetToggle(2, "Healthstone") then
        return A.Healthstone
    end
end
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

local function countInterruptGCD(unitID)
    if not A.CounterSpell:IsReadyByPassCastGCD(unitID) or not A.CounterSpell:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then 
        return true
    end
end

local function Interrupts(unitID)
    local useKick, useCC, useRacial, notInterruptable, castRemainsTime
    local isMythicPlus    = false
    if GetToggle(2, "KalyzInterrupts") and (IsInRaid() or A.InstanceInfo.KeyStone > 1) then
        isMythicPlus = true
        useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID, "KalyzInterrupts", true, countInterruptGCD(unitID))
    else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID, nil, nil, countInterruptGCD(unitID))
    end
    if castRemainsTime < GetLatency() then
        return
    end
    if useKick and not notInterruptable and Unit("target"):TimeToDie() > 2 and A.CounterSpell:IsReady(unitID) and A.CounterSpell:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then 
        return A.CounterSpell
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
    if useCC and A.Supernova:IsReady(unitID) and (Unit(unitID):IsControlAble("stun") or isMythicPlus) and A.Supernova:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true) then
        return A.Supernova
    end
    if useCC and A.DragonsBreath:IsReady(unitID, true) and A.DragonsBreath:IsTalentLearned() and Unit(unitID):GetRange() <= 8 and A.DragonsBreath:AbsentImun(unitID, Temp.TotalAndPhysAndCC, true) then 
        return A.DragonsBreath
    end
end

local function UseItems(unitID)
    if A.Trinket1:IsReady(unitID) and A.Trinket1:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] and A.Trinket1:AbsentImun(unitID, Temp.TotalAndMagPhys) then 
        return A.Trinket1
    end

    if A.Trinket2:IsReady(unitID) and A.Trinket2:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] and A.Trinket2:AbsentImun(unitID, Temp.TotalAndMagPhys) then 
        return A.Trinket2
    end
end

local function CheckArcaneIntellect()
    if not A.ArcaneIntellect:IsReady(player) then return false end

    local partyMembers = {"player", "party1", "party2", "party3", "party4"}
    for _, unitID in ipairs(partyMembers) do
        if UnitExists(unitID) and Unit(unitID):HasBuffs(A.ArcaneIntellect.ID, true) == 0 then
            if A.ArcaneIntellect:IsInRange(unitID) then
                return A.ArcaneIntellect, unitID
            end
        end
    end
    return false
end

--############################
--##### ROTATION #############
--############################

A[3] = function(icon)
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit(player):CombatTime() > 0
    local combatTime = Unit(player):CombatTime()
    local Pull = Action.BossMods_Pulling()
    local DBM = Action.GetToggle(1, "DBM")
    local Racial = Action.GetToggle(1, "Racial")
    local Potion = Action.GetToggle(1, "Potion")
    local ArcaneIntellect = CheckArcaneIntellect()
    local fightRemains = MultiUnits.GetByRangeAreaTTD()
    local opener = (combatTime < 10)
    local manaPercent = Player:ManaPercentage()

    
    function EnemyRotation(unitID)
        if not IsUnitEnemy(unitID) then return end
        if Unit(unitID):IsDead() then return end
        local isBurst            = BurstIsON(unitID)
        local isBoss = Unit(unitID):IsBoss()
        local timeToDie = Unit(unitID):TimeToDie()    
        if UnitCanAttack(player, unitID) == false then return end
        local defensive = SelfDefensives(unitID)

        if not inCombat then
            if ArcaneIntellect then
                return ArcaneIntellect:Show(icon)
            end
        end
        if defensive then
            return defensive:Show(icon)
        end
        for Unit_Nameplates in pairs(MultiUnits:GetActiveUnitPlates()) do
            local _, _, _, _, notInterruptable = Unit(Unit_Nameplates):IsCastingRemains()
            if Unit_Nameplates 
                and Interrupts(Unit_Nameplates) 
                and not Interrupts("target") 
                and not notInterruptable  -- Verifica se o alvo não é não-interrompível
            then
                return A:Show(icon, ACTION_CONST_AUTOTARGET)
            end
        end
        local Interrupt = Interrupts(unitID)
        if Interrupt then 
            return Interrupt:Show(icon)
        end
        --------------------------- Habilidades ---------------------------
        local function BurstRotation()
            if A.MirrorImage:IsReady(player) then
                return A.MirrorImage:Show(icon)
            end

            if A.Evocation:IsReady(player) and A.Evocation:IsTalentLearned() then
                return A.Evocation:Show(icon)
            end

            if A.LightsJudgment:IsReady(player) and Unit(player):HasBuffs(A.ArcaneSurge.ID) == 0 and Unit("target"):HasDeBuffs(A.TouchOfTheMagi.ID) == 0 and MultiUnits:GetActiveEnemies() >= 2 then
                return A.LightsJudgment:Show(icon)
            end

            if A.Berserking:IsReady(player) and ((Player:PrevGCD(1, A.ArcaneSurge.ID) and opener == 1) or (Player:PrevGCD(1, A.ArcaneSurge.ID) 
            and (fightRemains < 80 or Unit("target"):HealthPercent() < 35 or not A.ArcaneBombardment:IsTalentLearned() or Unit(player):HasBuffs(A.SpymastersWebBuff.ID) > 0)) or (Player:PrevGCD(1, A.ArcaneSurge.ID) 
            and not A.SpymastersWeb:IsEquipped())) then
                return A.Berserking:Show(icon)
            end

            if A.Fireblood:IsReady(player) and ((Player:PrevGCD(1, A.ArcaneSurge.ID) and opener == 1) or (Player:PrevGCD(1, A.ArcaneSurge.ID) 
            and (fightRemains < 80 or Unit("target"):HealthPercent() < 35 or not A.ArcaneBombardment:IsTalentLearned() or Unit(player):HasBuffs(A.SpymastersWebBuff.ID) > 0)) or (Player:PrevGCD(1, A.ArcaneSurge.ID) 
            and not A.SpymastersWeb:IsEquipped())) then
                return A.Fireblood:Show(icon)
            end

            if A.AncestralCall:IsReady(player) and ((Player:PrevGCD(1, A.ArcaneSurge.ID) and opener == 1) or (Player:PrevGCD(1, A.ArcaneSurge.ID) 
            and (fightRemains < 80 or Unit("target"):HealthPercent() < 35 or not A.ArcaneBombardment:IsTalentLearned() or Unit(player):HasBuffs(A.SpymastersWebBuff.ID) > 0)) or (Player:PrevGCD(1, A.ArcaneSurge.ID) 
            and not A.SpymastersWeb:IsEquipped())) then
                return A.AncestralCall:Show(icon)
            end

            if A.BlessingOfSummer:IsReady(player) and Player:PrevGCD(1, A.ArcaneSurge.ID) then
                return A.BlessingOfSummer:Show(icon)
            end

            if A.BlessingOfAutumn:IsReady(player) and A.TouchOfTheMagi:GetCooldown() > 5 then
                return A.BlessingOfAutumn:Show(icon)
            end

            if A.ArcaneBarrage:IsReady(player) and fightRemains < 2 then
                return A.ArcaneBarrage:Show(icon)
            end
        end

        local function SpellSlinger()
            if MultiUnits:GetByRange(40) <= 1 and A.SpellSlinger:IsTalentLearned() then
                -- Single Target Spellslinger Rotation
                if A.TouchOfTheMagi:IsReady(player) and (Unit(player):HasBuffs(A.ArcaneSoul.ID) > 0 or A.ArcaneSurge:GetCooldown() > 30) then
                    return A.TouchOfTheMagi:Show(icon)
                end
            
                if A.ShiftingPower:IsReady(player) and Unit(player):HasBuffs(A.ArcaneSurge.ID) == 0 and Unit(player):HasBuffs(A.SiphonStorm.ID) == 0 and 
                Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) == 0 and A.Evocation:GetCooldown() > 15 and A.TouchOfTheMagi:GetCooldown() > 10 and
                A.ArcaneOrb:GetCooldown() > 0 and A.ArcaneOrb:GetCharges() == 0 then
                    return A.ShiftingPower:Show(icon)
                end
            
                if A.PresenceOfMind:IsReady(player) and Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) <= GetCurrentGCD() and 
                Unit(player):HasBuffs(A.NetherPrecision.ID) > 0 and MultiUnits:GetActiveEnemies() < A.ArcaneExplosion.Rank and not A.UnerringProficiency:IsTalentLearned() then
                    return A.PresenceOfMind:Show(icon)
                end
            
                if A.Supernova:IsReady(player) and Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) <= GetCurrentGCD() and 
                Unit(player):HasBuffsStacks(A.UnerringProficiency.ID) == 30 then
                    return A.Supernova:Show(icon)
                end
            
                if A.ArcaneBarrage:IsReady(target) and (Unit(player):HasBuffs(A.NetherPrecision.ID) == 1 and Player:PrevGCD(1, A.ArcaneBlast)) or 
                A.TouchOfTheMagi:IsReady(player) or (A.ArcaneTempo:IsTalentLearned() and Unit(player):HasBuffs(A.ArcaneTempo.ID) < GetCurrentGCD()) then
                    return A.ArcaneBarrage:Show(icon)
                end
            
                if A.ArcaneMissiles:IsReady(target) and (Unit(player):HasBuffs(A.Clearcasting.ID) > 0 and Unit(player):HasBuffs(A.NetherPrecision.ID) == 0) or 
                Unit(player):HasBuffsStacks(A.Clearcasting.ID) == 3 then
                    return A.ArcaneMissiles:Show(icon)
                end
            
                if A.ArcaneOrb:IsReady(player) and Player:ArcaneCharges() < 2 then
                    return A.ArcaneOrb:Show(icon)
                end
            
                if A.ArcaneBlast:IsReady(target) then
                    return A.ArcaneBlast:Show(icon)
                end
                if A.ArcaneBarrage:IsReady(target) and manaPercent < 10 then
                    return A.ArcaneBarrage
                end
            end
        end
            
        local function SpellSlingerAOE()
            if MultiUnits:GetActiveUnitPlates() >= 2 and A.SpellSlinger:IsTalentLearned() then

                if A.Supernova:IsReady(player) and Unit(player):HasBuffsStacks(A.UnerringProficiency.ID) == 30 then
                    return A.Supernova:Show(icon)
                end
            
                if A.ShiftingPower:IsReady(player) and Player:PrevGCD(1, A.ArcaneBarrage) and (Unit(player):HasBuffs(A.ArcaneSurge.ID) > 0 or Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) > 0 or A.Evocation:GetCooldown() < 20) 
                and A.ShiftingShards:IsTalentLearned() then
                    return A.ShiftingPower:Show(icon)
                end
            
                if A.ArcaneOrb:IsReady(player) and Player:ArcaneCharges() < 2 then
                    return A.ArcaneOrb:Show(icon)
                end
            
                if A.ArcaneBlast:IsReady(target) and Unit(target):HasDeBuffs(A.MagisSpark.ID) > 0 then
                    return A.ArcaneBlast:Show(icon)
                end
            
                if A.ArcaneBarrage:IsReady(target) and ((A.ArcaneTempo:IsTalentLearned() and Unit(player):HasBuffs(A.ArcaneTempo.ID) < GetCurrentGCD()) or ((Unit(player):HasBuffs(A.Intuition.ID) > 0 
                and (Player:ArcaneCharges() == 4 or not A.HighVoltage:IsTalentLearned())) and Unit(player):HasBuffs(A.NetherPrecision.ID) > 0) or (Unit(player):HasBuffs(A.NetherPrecision.ID) > 0 and Player:PrevGCD(1, A.ArcaneBlast))) then
                    return A.ArcaneBarrage:Show(icon)
                end
            
                if A.ArcaneMissiles:IsReady(target) and Unit(player):HasBuffs(A.Clearcasting.ID) > 0 and ((A.HighVoltage:IsTalentLearned() and Player:ArcaneCharges() < 4) or Unit(player):HasBuffs(A.NetherPrecision.ID) == 0) then
                    return A.ArcaneMissiles:Show(icon)
                end
            
                if A.PresenceOfMind:IsReady(player) and (Player:ArcaneCharges() == 3 or Player:ArcaneCharges() == 2) then
                    return A.PresenceOfMind:Show(icon)
                end
            
                if A.ArcaneBarrage:IsReady(target) and Player:ArcaneCharges() == 4 then
                    return A.ArcaneBarrage:Show(icon)
                end
            
                return A.ArcaneExplosion
            end
        end
        
        local function SunFury()
            if MultiUnits:GetByRange(40) <= 1 and A.SunFury:IsTalentLearned() then
                -- Single Target Sunfury Rotation
                if A.ShiftingPower:IsReady(player) and Unit(player):HasBuffs(A.ArcaneSurge.ID) == 0 and Unit(player):HasBuffs(A.SiphonStorm.ID) == 0 and 
                Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) == 0 and A.Evocation:GetCooldown() > 15 and A.TouchOfTheMagi:GetCooldown() > 10 then
                    return A.ShiftingPower:Show(icon)
                end
            
                if A.PresenceOfMind:IsReady(player) and Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) <= GetCurrentGCD() and 
                Unit(player):HasBuffs(A.NetherPrecision.ID) > 0 and MultiUnits:GetActiveEnemies() < 4 then
                    return A.PresenceOfMind:Show(icon)
                end
            
                if A.ArcaneBarrage:IsReady(target) and Player:ArcaneCharges() == 4 and 
                (Unit(player):HasBuffs(A.BurdenOfPower.ID) > 0 or Unit(player):HasBuffs(A.GloriousIncandescence.ID) > 0 or Unit(player):HasBuffs(A.Intuition.ID) > 0) and 
                ((Player:PrevGCD(1, A.ArcaneBlast) and Unit(player):HasBuffsStacks(A.NetherPrecision.ID) == 1) or 
                (not Player:PrevGCD(1, A.ArcaneBlast) and Unit(player):HasBuffsStacks(A.NetherPrecision.ID) == 2) or 
                (Unit(player):HasBuffs(A.NetherPrecision.ID) == 0 and Unit(player):HasBuffs(A.Clearcasting.ID) == 0)) then
                    return A.ArcaneBarrage:Show(icon)
                end
            
                if A.ArcaneMissiles:IsReady(target) and Unit(player):HasBuffs(A.Clearcasting.ID) > 0 and 
                (Unit(player):HasBuffs(A.NetherPrecision.ID) == 0 or Unit(player):HasBuffsStacks(A.Clearcasting.ID) == 3 or 
                (A.HighVoltage:IsTalentLearned() and Player:ArcaneCharges() < 3) or 
                (Unit(player):HasBuffsStacks(A.NetherPrecision.ID) == 1 and Player:PrevGCD(1, A.ArcaneBlast))) then
                    return A.ArcaneMissiles:Show(icon)
                end
            
                if A.ArcaneOrb:IsReady(player) and Player:ArcaneCharges() < 2 then
                    return A.ArcaneOrb:Show(icon)
                end
            
                if A.ArcaneBlast:IsReady(target) then
                    return A.ArcaneBlast:Show(icon)
                end
            
                if A.ArcaneBarrage:IsReady(target) and manaPercent < 10 then
                    return A.ArcaneBarrage
                end
            end
        end

        local function SunFuryAOE()
            if MultiUnits:GetActiveUnitPlates() >= 2 and A.SunFury:IsTalentLearned() then
                -- AoE Sunfury Rotation
                if A.ArcaneBarrage:IsReady(target) and Unit(player):HasBuffs(A.ArcaneSoul.ID) > 0 and 
                (Unit(player):HasBuffsStacks(A.Clearcasting.ID) < 3 or Unit(player):HasBuffs(A.ArcaneSoul.ID) < GetCurrentGCD()) then
                    return A.ArcaneBarrage:Show(icon)
                end
            
                if A.ArcaneMissiles:IsReady(target) and Unit(player):HasBuffs(A.ArcaneSoul.ID) > 0 then
                    return A.ArcaneMissiles:Show(icon)
                end
            
                if A.ShiftingPower:IsReady(player) and Unit(player):HasBuffs(A.ArcaneSurge.ID) == 0 and Unit(player):HasBuffs(A.SiphonStorm.ID) == 0 and 
                Unit(target):HasDeBuffs(A.TouchOfTheMagi.ID) == 0 and A.Evocation:GetCooldown() > 15 and A.TouchOfTheMagi:GetCooldown() > 15 then
                    return A.ShiftingPower:Show(icon)
                end
            
                if A.ArcaneOrb:IsReady(player) and Player:ArcaneCharges() < 2 and (not A.HighVoltage:IsTalentLearned() or Unit(player):HasBuffs(A.Clearcasting.ID) == 0) then
                    return A.ArcaneOrb:Show(icon)
                end
            
                if A.ArcaneBlast:IsReady(target) and Unit(target):HasDeBuffs(A.MagisSpark.ID) > 0 then
                    return A.ArcaneBlast:Show(icon)
                end
            
                if A.ArcaneBarrage:IsReady(target) and Player:ArcaneCharges() == 4 then
                    return A.ArcaneBarrage:Show(icon)
                end
            
                if A.ArcaneMissiles:IsReady(target) and Unit(player):HasBuffs(A.Clearcasting.ID) > 0 and 
                (Unit(player):HasBuffs(A.AetherAttunement.ID) > 0 or A.ArcaneHarmony:IsTalentLearned()) then
                    return A.ArcaneMissiles:Show(icon)
                end
            
                if A.PresenceOfMind:IsReady(player) and (Player:ArcaneCharges() == 3 or Player:ArcaneCharges() == 2) then
                    return A.PresenceOfMind:Show(icon)
                end
            
                if A.ArcaneExplosion:IsReady(player) and (A.Reverberate:IsTalentLearned() or Player:ArcaneCharges() < 1) then
                    return A.ArcaneExplosion:Show(icon)
                end
            
                if A.ArcaneBlast:IsReady(target) then
                    return A.ArcaneBlast
                end
            end
        end


        if BurstRotation() and isBurst then
            return true
        end
        if SpellSlinger() then
            return true
        end
        if SunFury() then
            return true
        end
        if SpellSlingerAOE() then
            return true
        end
        if SunFuryAOE() then
            return true
        end
        
        
        if IsUnitEnemy("target") and EnemyRotation("target") then
            return true
        end
    end
end

local function PartyRotation(icon, UnitID)
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

A[9] = function(icon)
    if UnitExists("raid4") or UnitExists("party4") then
        return PartyRotation(icon, UnitExists("raid4") and "raid4" or "party4")
    end
end

A[10] = function(icon)
    if UnitExists("raid5") or UnitExists("party5") then
        return PartyRotation(icon, UnitExists("raid5") and "raid5" or "party5")
    end
end
