local _G, setmetatable = _G, setmetatable
local TMW = _G.TMW
local Action = _G.Action
local Create = Action.Create
local Unit = Action.Unit
local Player = Action.Player
local IsUnitEnemy = Action.IsUnitEnemy
local IsUnitFriendly = Action.IsUnitFriendly
local HealingEngine = Action.HealingEngine
local GetToggle = Action.GetToggle

Action[ACTION_CONST_PRIEST_HOLY] = {
    -- Class Spells
    FlashHeal = Create({ Type = "Spell", ID = 2061 }),
    Heal = Create({ Type = "Spell", ID = 2060 }),
    PowerWordShield = Create({ Type = "Spell", ID = 17 }),
    Renew = Create({ Type = "Spell", ID = 139 }),
    PrayerOfMending = Create({ Type = "Spell", ID = 33076 }),
    HolyWordSerenity = Create({ Type = "Spell", ID = 2050 }),
    HolyWordSanctify = Create({ Type = "Spell", ID = 34861 }),
    PrayerOfHealing = Create({ Type = "Spell", ID = 596 }),
    CircleOfHealing = Create({ Type = "Spell", ID = 204883 }),
    GuardianSpirit = Create({ Type = "Spell", ID = 47788 }),
    DivineHymn = Create({ Type = "Spell", ID = 64843 }),
    
    -- Damage Spells
    Smite = Create({ Type = "Spell", ID = 585 }),
    HolyFire = Create({ Type = "Spell", ID = 14914 }),
    HolyWordChastise = Create({ Type = "Spell", ID = 88625 }),
    ShadowWordPain = Create({ Type = "Spell", ID = 589 }),
    
    -- Defensive
    DesperatePrayer = Create({ Type = "Spell", ID = 19236 }),
    
    -- Utilities
    Fade = Create({ Type = "Spell", ID = 586 }),
    LeapOfFaith = Create({ Type = "Spell", ID = 73325 }),
    MassDispel = Create({ Type = "Spell", ID = 32375 }),
    Dispel = Create({ Type = "Spell", ID = 527 }),
    
    -- Talents (assuming all available for leveling)
    DivineStar = Create({ Type = "Spell", ID = 110744 }),
    Halo = Create({ Type = "Spell", ID = 120517 }),
    DivineWord = Create({ Type = "Spell", ID = 372760 }),
    Apotheosis = Create({ Type = "Spell", ID = 200183 }),
    EmpyrealBlaze = Create({ Type = "Spell", ID = 372616 }),
    
    -- Buffs
    SurgeOfLight = Create({ Type = "Spell", ID = 114255 }),
    Apotheosis = Create({ Type = "Spell", ID = 200183 }),
    
    -- UI Variables
    GuardianSpiritHP = 30,
    FlashHealHP = 75,
    RenewHP = 90,
    PowerWordShieldHP = 95,
    
    -- Settings
    Settings = {
        UseGuardianSpirit = true,
        UseDispel = true,
        UseCooldowns = true,
    }
}

local A = setmetatable(Action[ACTION_CONST_PRIEST_HOLY], { __index = Action })
local player = "player"
local target = "target"
local focus = "focus"
local mouseover = "mouseover"

-- Helper Functions
local function HealCalc(spell)
    local healAmount = 0
    local spellDescriptions = {
        [A.FlashHeal] = A.FlashHeal:GetSpellDescription(),
        [A.Heal] = A.Heal:GetSpellDescription(),
        [A.HolyWordSerenity] = A.HolyWordSerenity:GetSpellDescription(),
    }
    
    if spellDescriptions[spell] then
        healAmount = spellDescriptions[spell][1]
    end
    
    return tonumber((tostring(healAmount):gsub("%.", "")))
end

local function isInRange(unit)
    return A.FlashHeal:IsInRange(unit)
end

local function isUnitValid(unit)
    return isInRange(unit) and not Unit(unit):IsDead() and IsUnitFriendly(unit)
end

-- Main Rotation
A[3] = function(icon)
    local getMembersAll = HealingEngine.GetMembersAll()
    local inCombat = Unit(player):CombatTime() > 0
    local isMoving = A.Player:IsMoving()
    
    local function HealingRotation(unit)
        -- Emergency Healing
        if A.GuardianSpirit:IsReady(unit) and Unit(unit):HealthPercent() <= A.GuardianSpiritHP then
            return A.GuardianSpirit:Show(icon)
        end
        
        -- Cooldowns
        if A.Settings.UseCooldowns then
            if A.DivineHymn:IsReady(player) and CheckMembersBelowHealthPercent(getMembersAll, 75, 4) then
                return A.DivineHymn:Show(icon)
            end
            
            if A.Apotheosis:IsReady(player) and CheckMembersBelowHealthPercent(getMembersAll, 80, 3) then
                return A.Apotheosis:Show(icon)
            end
        end
        
        -- Holy Words
        if A.HolyWordSerenity:IsReady(unit) and Unit(unit):HealthPercent() <= 70 then
            return A.HolyWordSerenity:Show(icon)
        end
        
        if A.HolyWordSanctify:IsReady(player) and CheckMembersBelowHealthPercent(getMembersAll, 85, 3) then
            return A.HolyWordSanctify:Show(icon)
        end
        
        -- Regular Healing
        if not isMoving then
            if A.FlashHeal:IsReady(unit) and Unit(unit):HealthPercent() <= A.FlashHealHP then
                return A.FlashHeal:Show(icon)
            end
            
            if A.Heal:IsReady(unit) and Unit(unit):HealthPercent() <= 85 then
                return A.Heal:Show(icon)
            end
        end
        
        -- HoTs and Shields
        if A.Renew:IsReady(unit) and Unit(unit):HealthPercent() <= A.RenewHP 
           and Unit(unit):HasBuffs(A.Renew.ID) == 0 then
            return A.Renew:Show(icon)
        end
        
        if A.PowerWordShield:IsReady(unit) and Unit(unit):HealthPercent() <= A.PowerWordShieldHP 
           and Unit(unit):HasBuffs(A.PowerWordShield.ID) == 0 then
            return A.PowerWordShield:Show(icon)
        end
        
        -- AoE Healing
        if A.CircleOfHealing:IsReady(unit) and CheckMembersBelowHealthPercent(getMembersAll, 90, 3) then
            return A.CircleOfHealing:Show(icon)
        end
        
        -- Damage when healing not needed
        if IsUnitEnemy(target) and Unit(target):IsExists() and Unit(target):IsAttackable() then
            if A.HolyFire:IsReady(target) then
                return A.HolyFire:Show(icon)
            end
            
            if A.Smite:IsReady(target) then
                return A.Smite:Show(icon)
            end
        end
    end
    
    -- Priority targeting
    if isUnitValid(focus) then
        unit = focus
        if HealingRotation(unit) then
            return true
        end
    elseif isUnitValid(target) then
        unit = target
        if HealingRotation(unit) then
            return true
        end
    end
end