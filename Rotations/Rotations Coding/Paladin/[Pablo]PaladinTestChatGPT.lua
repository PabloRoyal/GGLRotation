local TMW                                   = _G.TMW
local Action                                = _G.Action
local GetSpellTexture                       = _G.TMW.GetSpellTexture
local Unit                                  = Action.Unit
local Create                                = Action.Create
local Player                                = Action.Player
local BurstIsON                             = Action.BurstIsON
local GetToggle                             = Action.GetToggle
local MultiUnits                            = Action.MultiUnits
local AuraIsValid                           = Action.AuraIsValid
local IsUnitEnemy                           = Action.IsUnitEnemy
local LoC                                   = Action.LossOfControl
local GetCurrentGCD                         = Action.GetCurrentGCD
local IsUnitFriendly                        = Action.IsUnitFriendly
local InterruptIsValid                      = Action.InterruptIsValid
local ACTION_CONST_STOPCAST                 = Action.Const.STOPCAST
local ACTION_CONST_AUTOTARGET               = Action.Const.AUTOTARGET
local ACTION_CONST_PALADIN_PROTECTION       = Action.Const.PALADIN_PROTECTION
local Utils                                 = Action.Utils
local ActiveUnitPlates                      = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit, IsMounted, UnitThreatSituation, UnitCanAttack, IsInRaid, UnitDetailedThreatSituation, IsResting, GetItemCount, debugprofilestop = 
_G.IsIndoors, _G.UnitIsUnit, _G.IsMounted, _G.UnitThreatSituation, _G.UnitCanAttack, _G.IsInRaid, _G.UnitDetailedThreatSituation, _G.IsResting, _G.GetItemCount, _G.debugprofilestop

Action[ACTION_CONST_PALADIN_PROTECTION] = {
    --Alliance Racials
    EveryManforHimself                    = Create({ Type = "Spell", ID = 59752     }),
    Stoneform                             = Create({ Type = "Spell", ID = 20594        }),
    Shadowmeld                            = Create({ Type = "Spell", ID = 58984     }),
    EscapeArtist                          = Create({ Type = "Spell", ID = 20589     }),
    GiftofNaaru                           = Create({ Type = "Spell", ID = 28880     }),
    Darkflight                            = Create({ Type = "Spell", ID = 68992        }),
    QuakingPalm                           = Create({ Type = "Spell", ID = 107079    }),
    SpatialRift                           = Create({ Type = "Spell", ID = 256948    }),
    LightsJudgment                        = Create({ Type = "Spell", ID = 255647    }),
    Fireblood                             = Create({ Type = "Spell", ID = 265221    }),
    Haymaker                              = Create({ Type = "Spell", ID = 287712    }),
    HyperOrganicLightOriginator           = Create({ Type = "Spell", ID = 312924    }),
   
    --Horde Racials
    BloodFury                             = Create({ Type = "Spell", ID = 33697        }),
    WilloftheForsaken                     = Create({ Type = "Spell", ID = 7744      }),
    Canibalize                               = Create({ Type = "Spell", ID = 20577     }),
    WarStomp                              = Create({ Type = "Spell", ID = 20549     }),
    Berserking                            = Create({ Type = "Spell", ID = 26297        }),
    ArcaneTorrent                         = Create({ Type = "Spell", ID = 28730        }),
    PackHobGoblin                         = Create({ Type = "Spell", ID = 69046        }),
    RocketBarrage                         = Create({ Type = "Spell", ID = 69041        }),
    RocketJump                               = Create({ Type = "Spell", ID = 69070        }),
    ArcanePulse                           = Create({ Type = "Spell", ID = 260364    }),
    Cantrips                               = Create({ Type = "Spell", ID = 255661    }),
    BullRush                              = Create({ Type = "Spell", ID = 255654    }),
    AncestralCall                         = Create({ Type = "Spell", ID = 274738    }),
    EmbraceoftheLoa                       = Create({ Type = "Spell", ID = 292752    }),
    PterrordaxSwoop                       = Create({ Type = "Spell", ID = 281954    }),
    Regeneratin                           = Create({ Type = "Spell", ID = 291944    }),
    BagofTricks                           = Create({ Type = "Spell", ID = 312411    }),
    MakeCamp                              = Create({ Type = "Spell", ID = 312370    }),
    ReturntoCamp                          = Create({ Type = "Spell", ID = 312372    }),
    RummageyourBag                        = Create({ Type = "Spell", ID = 312425    }),
    
    -- Paladin Spells
    AvengersShield                        = Create({ Type = 'Spell', ID = 31935 }),
    HammerofWrath                         = Create({ Type = 'Spell', ID = 24275 }),
    BlessedHammer                         = Create({ Type = 'Spell', ID = 204019 }),
    CrusaderStrike                        = Create({ Type = 'Spell', ID = 35395 }),
    Consecration                          = Create({ Type = 'Spell', ID = 26573 }),
    Rebuke                                = Create({ Type = 'Spell', ID = 96231 }),
    ShieldoftheRighteous                  = Create({ Type = 'Spell', ID = 53600 }),
    DivineToll                            = Create({ Type = 'Spell', ID = 304971 }),
    EyeofTyr                              = Create({ Type = 'Spell', ID = 387174 }),
    HolyBulwark                           = Create({ Type = 'Spell', ID = 432459, Icon = GetSpellTexture(28880) }), -- Placeholder Icon
    SacredWeapon                          = Create({ Type = 'Spell', ID = 432472, Icon = GetSpellTexture(28880) }), -- Placeholder Icon
    AvengingWrath                         = Create({ Type = 'Spell', ID = 31884 }),
    HandofReckoning                       = Create({ Type = 'Spell', ID = 62124 }),
    DivineShield                          = Create({ Type = 'Spell', ID = 642 }),
    MomentofGlory                         = Create({ Type = 'Spell', ID = 327193 }),
    HammerofLight                         = Create({ Type = 'Spell', ID = 198054 }),

    -- Self Defensive
    FlashofLight                          = Create({ Type = 'Spell', ID = 19750 }),
    GuardianofAncientKings                = Create({ Type = 'Spell', ID = 86659 }),
    ArdentDefender                        = Create({ Type = 'Spell', ID = 31850 }),
    WordofGlory                           = Create({ Type = 'Spell', ID = 85673 }),
    LayonHands                            = Create({ Type = 'Spell', ID = 633 }),
    FinalStand                            = Create({ Type = 'Spell', ID = 204077, isTalent = true }),
}

local A = setmetatable(Action[ACTION_CONST_PALADIN_PROTECTION], { __index = Action })

local mouseover                             = "mouseover"
local focus                                 = "focus"
local target                                = "target"
local player                                = "player"

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
    -- Default Variables
    isMoving                         = Player:IsMoving()
    isStaying                        = Player:IsStaying()
    combatTime                       = Unit(player):CombatTime()
    movingTime                       = Player:IsMovingTime()
    stayingTime                      = Player:IsStayingTime()
    PlayerHealth                     = Unit(player):HealthPercent()
    InMeleeRange                     = Unit(target):GetRange() < 5
    DivinePurpose                    = Unit(player):HasBuffs(223817) > 0 -- Divine Purpose Proc
    ShiningLight                     = Unit(player):HasBuffs(321136) > 0 -- Shining Light Proc
end

A[3] = function(icon)
    RotationsVariables()
    
    -- Procs Handling: Divine Purpose or Shining Light
    if DivinePurpose or ShiningLight then
    -- Use Word of Glory at 90% health with Procs
        if Unit(player):HealthPercent() <= 90 and A.WordofGlory:IsReady(player) then
            return A.WordofGlory:Show(icon)
        end
    else
    -- Use Word of Glory at 40% health without Procs
        if Unit(player):HealthPercent() <= 60 and A.WordofGlory:IsReady(player) then
            return A.WordofGlory:Show(icon)
        end
    end


    -- Proper defensive cooldown usage
    if combatTime > 0 then
        if A.DivineShield:IsReady(player) and PlayerHealth <= 20 then
            return A.DivineShield:Show(icon)
        end
        if A.LayonHands:IsReady(player) and PlayerHealth <= 20 then
            return A.LayonHands:Show(icon)
        end
        if A.GuardianofAncientKings:IsReady(player) and Unit(player):HealthPercent() <= 35 then
            return A.GuardianofAncientKings:Show(icon)
        end

    -- Ensure Guardian of the Ancient Kings is not stuck in the rotation
        if not A.GuardianofAncientKings:IsReady(player) and A.GuardianofAncientKings:GetCooldown() > 0 then
    -- Proceed with next defensive ability or rotation
            if A.ArdentDefender:IsReady(player) and Unit(player):HealthPercent() <= 55 then
                return A.ArdentDefender:Show(icon)
            end
        end
        if A.ArdentDefender:IsReady(player) and PlayerHealth <= 55 then
            return A.ArdentDefender:Show(icon)
        end
        if A.WordofGlory:IsReady(player) and PlayerHealth <= 50 and Player:HolyPower() >= 3 then
            return A.WordofGlory:Show(icon)
        end
    end

    -- Offensive rotation
    local function APL()
       --Holy Power Generator
        if A.ShieldoftheRighteous:IsReady(player) and Player:HolyPower() >= 3 then
            return A.ShieldoftheRighteous:Show(icon)
        end
        
        -- Single Target and Multi Target Priority
        if A.Consecration:IsReady(player) and InMeleeRange then
            return A.Consecration:Show(icon)
        end
        if A.AvengersShield:IsReady(target) then
            return A.AvengersShield:Show(icon)
        end
        if A.HammerofWrath:IsReady(target) then
            return A.HammerofWrath:Show(icon)
        end
        if A.BlessedHammer:IsReady(player) and InMeleeRange then
            return A.BlessedHammer:Show(icon)
        end
        if A.CrusaderStrike:IsReady(target) then
            return A.CrusaderStrike:Show(icon)
        end
        if A.DivineToll:IsReady(player) then
            return A.DivineToll:Show(icon)
        end
        if A.HammerofLight:IsReady(target) then
            return A.HammerofLight:Show(icon)
        end
    end

    if IsUnitEnemy(target) then
        if APL() then
            return true
        end
    end
end
