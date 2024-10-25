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
    RageoftheSleeper                    = Create({ Type = "Spell", ID = 200851 }),
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
    DreamofCenarius                     = Create({ Type = "Spell", ID = 372152 }),
    LunarBeam                           = Create({ Type = "Spell", ID = 204066 }),
    HeartoftheWild                      = Create({ Type = "Spell", ID = 319454 }),
    MarkOfTheWild                       = Create({ Type = "Spell", ID = 1126   }),
    
    -- Forms
    BearForm                            = Create({ Type = "Spell", ID = 5487 }),
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

local function ShouldAoE()
    return GetByRange(3, 8)
end

-- Buff-Checks
local function HasGalacticGuardianProc()
    return Unit(player):HasBuffs(A.GalacticGuardian.ID, true) > 0
end

local function HasToothandClawProc()
    return Unit(player):HasBuffs(A.ToothandClaw.ID, true) > 0
end

-- Sonstige Hilfsfunktionen
local function ShouldUseIronfur()
    return Player:Rage() >= 40 and Unit(player):HasBuffs(A.Ironfur.ID, true) == 0
end

local function AutoBearForm()
    -- Prüft, ob wir im Kampf sind und nicht bereits in Bear Form
    if Unit(player):CombatTime() > 0 and Unit(player):HasBuffs(A.BearForm.ID, true) == 0 then
        return A.BearForm
    end
    return false
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

-- Funktion für die Nutzung des Dream of Cenarius Procs
local function UseDreamOfCenarius()
    -- Prüft, ob der Buff aktiv ist und Regrowth bereit ist
    if Unit(player):HasBuffs(A.DreamofCenarius.ID, true) > 0 and A.Regrowth:IsReady(player) then
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
    local bearForm = AutoBearForm()
    local dreamProc = UseDreamOfCenarius()
    local MarkOfTheWild, targetUnit = CheckMarkOfTheWild()
    local Interrupt = Interrupts(target)


    if MarkOfTheWild then
        return MarkOfTheWild:Show(icon)
    end

    -- Bear Form
    if inCombat then
        if bearForm then
            return bearForm:Show(icon)
        end
        
        --Interrupt
        
        if A.IsUnitEnemy(target) then
            local Interrupt = Interrupts(target)
            if Interrupt then 
                return Interrupt:Show(icon)
            end
        end
        
        -- Regrowth
        
        if dreamProc then
            return dreamProc:Show(icon)
        end
        
        -- Defensiv-CDs
        if inCombat then
            if A.SurvivalInstincts:IsReady(player) and Unit(player):HealthPercent() <= 40 then
                return A.SurvivalInstincts:Show(icon)
            end
            if A.Barkskin:IsReady(player) and Unit(player):HealthPercent() <= 60 then
                return A.Barkskin:Show(icon)
            end
            if A.FrenziedRegeneration:IsReady(player) and Unit(player):HealthPercent() <= 70 then
                return A.FrenziedRegeneration:Show(icon)
            end
        end
    end
    
    
    
    -- Hauptrotation
    local function APL()
        
        --Check mark of the WIld Party
        if markOfTheWild then
            return markOfTheWild:Show(icon)
        end

        --Interrupts
        if Interrupt then
            return Interrupt:Show(icon)
        end
        
        -- Moonfire aufrechterhalten
        if A.Moonfire:IsReady(target) and Unit(target):HasDeBuffs(A.Moonfire.ID, true) <= 2 and (not isAoE or not GetByRange(5, 40)) then
            return A.Moonfire:Show(icon)
        end
        
        -- Thrash
        if A.Thrash:IsReady(player) and InMeleeRange(target) then
            return A.Thrash:Show(icon)
        end
        
        -- Mangle
        if A.Mangle:IsReady(target) and InMeleeRange(target) and (not isAoE or Player:Rage() < 80) then
            return A.Mangle:Show(icon)
        end
        
        -- Cooldowns
        if BurstIsON(target) then
            if A.Incarnation:IsReady(player) then
                return A.Incarnation:Show(icon)
            end
            
            if A.LunarBeam:IsReady(player) then
                return A.LunarBeam:Show(icon)
            end
            
            if A.RageoftheSleeper:IsReady(player) then
                return A.RageoftheSleeper:Show(icon)
            end
        end
        
        -- Rage Dump
        if isAoE then
            if A.Raze:IsReady(player) and Player:Rage() >= 40 then
                return A.Raze:Show(icon)
            end
        else
            if A.Maul:IsReady(target) and Player:Rage() >= 40 then
                return A.Maul:Show(icon)
            end
        end
        
        -- Tooth and Claw proc
        if HasToothandClawProc() then
            if isAoE and A.Raze:IsReady(player) then
                return A.Raze:Show(icon)
            elseif A.Maul:IsReady(target) then
                return A.Maul:Show(icon)
            end
        end
        
        -- Galactic Guardian proc
        if HasGalacticGuardianProc() and A.Moonfire:IsReady(target) and (not isAoE or Unit(player):HasBuffs(A.GalacticGuardian.ID, true) <= 2) then
            return A.Moonfire:Show(icon)
        end
        
        -- Ironfur
        if ShouldUseIronfur() then
            return A.Ironfur:Show(icon)
        end
        
        -- Swipe als Filler
        if A.Swipe:IsReady(player) and InMeleeRange(target) then
            return A.Swipe:Show(icon)
        end
    end
    
    if IsUnitEnemy(target) then
        return APL()
    end
end

