local _G, setmetatable, pairs, type, math = _G, setmetatable, pairs, type, math
local TMW = _G.TMW
local Action = _G.Action
local GetToggle = Action.GetToggle
local GetGCD = Action.GetGCD
local GetCurrentGCD = Action.GetCurrentGCD
local BurstIsON = Action.BurstIsON
local EnemyTeam = Action.EnemyTeam
local Player = Action.Player
local MultiUnits = Action.MultiUnits
local Unit = Action.Unit
local CONST = Action.Const
local ACTION_CONST_ROGUE_OUTLAW = CONST.ROGUE_OUTLAW
local IsMounted = _G.IsMounted
local UnitCanAttack = _G.UnitCanAttack
local UnitDetailedThreatSituation = _G.UnitDetailedThreatSituation
local IsResting = _G.IsResting
local InCombatLockdown = _G.InCombatLockdown
local IsUsableSpell = _G.IsUsableSpell
local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
local UnitGUID = _G.UnitGUID
local player = "player"
local target = "target"
local A = setmetatable(Action[ACTION_CONST_ROGUE_OUTLAW], { __index = Action })
local ryan = A.Ryan
local ryanRogue = ryan.Rogue
local boolnumber = function (value)
    --@number 1 or 0
    --converts a boolean to 1=true 0=false for use in math operations
    return value and 1 or 0
end
local Temp = {
    TotalAndPhys = {"TotalImun", "DamagePhysImun"},
    TotalAndPhysKick = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMagPhys = {"TotalImun", "DamageMagicImun", "DamagePhysImun"},
    DisablePhys = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    BerserkerRageLoC = {"FEAR", "INCAPACITATE"},
    CCed = {"Silenced", "Stuned", "Sleep", "Fear", "Disoriented", "Incapacitated", 360806, 20066, A.CheapShot.ID},
    IsSlotTrinketBlocked = {
        [A.EruptingSpearFragment.ID] = true, --requires manual aiming
        [A.GlobeofJaggedIce.ID] = true, --requires debuff on enemies
        [A.PrimalRitualShell.ID] = true, --Requires Specific Location
        [A.ManicGrieftorch.ID] = true, --requires casting and different logic
        [A.StormEatersBoon.ID] = true, --Roots player and should have some minimum count of targets
        [A.BeacontotheBeyond.ID] = true, --special logic like Manic
        [A.DragonfireBombDispenser.ID] = true, --needs to ignore TTD, check other trinket, and AOE logic
        [A.OminousChromaticEssence.ID] = true, -- no on use
    },
}
local actionTable = Action[ACTION_CONST_ROGUE_OUTLAW]
for i = 1, #actionTable do
    local val = actionTable[i]
    if type(val) == "table" and val.Type == "Trinket" then
    Temp.IsSlotTrinketBlocked[val.ID] = true
    end
end
local stealthLikeBuffs = {A.SubterfugeBuff.ID, A.VanishStealth.ID, A.ShadowDanceBuff.ID, A.Shadowmeld.ID, A.Vanish.ID, A.Stealth.ID, A.SubterfugeStealth.ID, A.Sepsis.ID}
local stealthedBasic = {A.Stealth.ID, A.SubterfugeStealth.ID, A.VanishStealth.ID}
------------------------------------------------------------
--Ryan Generic Functions
------------------------------------------------------------
-- energy.base_time_to_max
function Player.BaseEnergyTimeToMax()
	return (Player:EnergyDeficit() - 50*boolnumber(Unit(player):HasBuffs(A.AdrenalineRushBuff.ID) ~= 0)) / Player:EnergyRegen()
end
--actions+="/variable,name=base_energy_deficit,value=energy.deficit-(buff.adrenaline_rush.up*50)"
--actions+="/variable,name=base_energy_time_to_max,value=variable.base_energy_deficit%energy.regen"
local function UseItems(unitID, icon)
    if  Unit(player):HasBuffs(A.BetweenTheEyes.ID) == 0 or A.Shiv:ShouldStopByGCD() -- this is to force OGCD abilities to wait for hire priorites (should work well since outlaw doest not stack OGCD)
    then return false
    end
    if A.Trinket1:IsReady() and A.Trinket1:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] and A.Trinket1:AbsentImun(unitID, Temp.TotalAndMagPhys)
        then
            return A.Trinket1:Show(icon)
    end
    if A.Trinket2:IsReady() and A.Trinket2:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] and A.Trinket2:AbsentImun(unitID, Temp.TotalAndMagPhys)
        then
            return A.Trinket2:Show(icon)
    end
end
--FanTheHammer CP correction
local function RyanComboPointCorrection()
    --if you dont have Fan the hammer no correction needed
    local fTHRank = A.FanTheHammer:GetTalentTraits()
    if fTHRank == 0 then return Player:ComboPoints() end
    local opportunityBuffStacks = Unit(player):HasBuffsStacks(A.Opportunity.ID) -- Determine how many stacks we have
    local broadsideActive = Unit(player):HasBuffs(A.Broadside.ID) ~= 0
    if A.FanTheHammer:GetTalentTraits() == 2 then
        -- If you are between Pistol shots, should make the rotation more confident in finisher after builder
        if opportunityBuffStacks == 5 or opportunityBuffStacks == 2 then return math.min(Player:ComboPoints() + 2 + 2*boolnumber(broadsideActive), Player:ComboPointsMax()) end
        if opportunityBuffStacks == 4 or opportunityBuffStacks == 1 then return math.min(Player:ComboPoints() + 1 + 1*boolnumber(broadsideActive), Player:ComboPointsMax()) end
    end
    if A.FanTheHammer:GetTalentTraits() == 1 then
        -- If you are between Pistol shots, should make the rotation more confident in finisher after builder
        if opportunityBuffStacks == 5 or opportunityBuffStacks == 3 or opportunityBuffStacks == 1 then return math.min(Player:ComboPoints() + 1 + 1*boolnumber(broadsideActive), Player:ComboPointsMax()) end
    end
    return Player:ComboPoints()
end
local function isBurstCheck(unitID)
    local _, _, _, _, _, npcID         = Unit(unitID):InfoGUID() --@number npcID from wowhead/evlui, better than using strings for other languages
    --local spellName,  castStartedTime, castEndTime,   notInterruptable,  spellID, isChanneling = Unit(unitID):IsCasting() not sure why i defined this her
    if npcID ==  174773 then return false end -- @boolean stop burst on Spitefuls in M+
       if BurstIsON(unitID) then return true end
end
local rtbSpellIDs = {
    [315508] = "roll_the_bones",
    [381989] = "keep_it_rolling",
    [193356] = "broadside",
    [199600] = "buried_treasure",
    [193358] = "grand_melee",
    [193357] = "ruthless_precision",
    [199603] = "skull_and_crossbones",
    [193359] = "true_bearing",
}
local function RollTheBonesContainerUpdate()
        local _, subevent, _, sourceGUID, _, _, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo() -- full CLEU
        if sourceGUID == UnitGUID("player") then
            if spellID == 315508 then -- RTB_CONTAINER
                if subevent == "SPELL_AURA_APPLIED" then
                    ryanRogue.rtb_container_duration = 30
                    ryanRogue.rtb_container_start_time =  TMW.time
                    --ryanRogue.rtb_container_remaining_time = 30
                    return
                elseif subevent == "SPELL_AURA_REFRESH" then
                    ryanRogue.rtb_container_duration = 30 + math.min(ryanRogue.rtb_container_duration - math.abs(TMW.time - ryanRogue.rtb_container_start_time), 9)
                    ryanRogue.rtb_container_start_time = TMW.time
                    --ryanRogue.rtb_container_remaining_time = math.max(ryanRogue.rtb_container_duration - math.abs(TMW.time - ryanRogue.rtb_container_start_time), 0)
                    return
                end
            elseif (subevent == "SPELL_CAST_SUCCESS" and spellID == 381989) then -- KIR
                return
            end
        end
end
A.Listener:Add("ACTION_EVENT_RYAN_RTB_CONTAINER", "COMBAT_LOG_EVENT_UNFILTERED", RollTheBonesContainerUpdate)
--all buffs longer than 30s
local function rtb_buffs_longer()
    --@integer
    local n = 0
    for index, _ in pairs( rtbSpellIDs ) do
        local remaining, duration = Unit(player):HasBuffs(index)
        if remaining ~= 0 and duration > ryanRogue.rtb_container_duration + 0.1 then n = n + 1 end
    end
    return n
end
--all buffs only from rtb
local function rtb_buffs_normal()
    --@integer
    local n = 0
    for index, _ in pairs( rtbSpellIDs ) do
        local remaining, duration = Unit(player):HasBuffs(index)
        if remaining ~= 0 and duration >= ryanRogue.rtb_container_duration - 0.1
        and remaining ~= 0 and duration <= ryanRogue.rtb_container_duration + 0.1  then n = n + 1 end
    end
    return n
end
--count all buffs up (all sources)
local function rtb_buffs()
    --@integer
    local n = 0
    for index, _ in pairs( rtbSpellIDs ) do
        if Unit(player):HasBuffs(index) >= 1 then n = n + 1 end
    end
    return n
end
local function rtb_buffs_will_lose_buff(spellID)
    --@boolean
    local remaining, _ = Unit(player):HasBuffs(spellID)
    local rtbContainerDuration = math.max(ryanRogue.rtb_container_start_time+ryanRogue.rtb_container_duration-TMW.time ,0)
    if remaining ~= 0 and remaining <= rtbContainerDuration + 0.1 then return true end
end
local function rtb_buffs_will_lose()
    --@integer
    local n = 0
    local rtbContainerDuration = math.max(ryanRogue.rtb_container_start_time+ryanRogue.rtb_container_duration-TMW.time ,0)
    for index, _ in pairs( rtbSpellIDs ) do
        local remaining, _ = Unit(player):HasBuffs(index)
        if remaining ~= 0 and remaining <= rtbContainerDuration + 0.1 then n = n + 1 end
    end
    return n
end
local function rtbReroll()
    --Gather RTB buff info
    local BroadsideRemaing, _              = Unit(player):HasBuffs(A.Broadside.ID)
    local BuriedTreasureRemaing, _          = Unit(player):HasBuffs(A.BuriedTreasure.ID)
    local GrandMeleeRemaing, _              = Unit(player):HasBuffs(A.GrandMelee.ID)
    local RuthlessPrecisionRemaing, _       = Unit(player):HasBuffs(A.RuthlessPrecision.ID)
    local TrueBearingRemaing, _             = Unit(player):HasBuffs(A.TrueBearing.ID)
    local SkullAndCrossbonesRemaing, _      = Unit(player):HasBuffs(A.SkullAndCrossbones.ID)
    local rtb_buffs_max_remains = math.max (BroadsideRemaing,BuriedTreasureRemaing,GrandMeleeRemaing,RuthlessPrecisionRemaing,TrueBearingRemaing,SkullAndCrossbonesRemaing)
    -- Default Roll the Bones reroll rule: reroll for any buffs that aren't Buried Treasure, excluding Grand Melee in single target
    local rtb_reroll = rtb_buffs_will_lose() ==( boolnumber(rtb_buffs_will_lose_buff(A.BuriedTreasure.ID)) + boolnumber(rtb_buffs_will_lose_buff(A.GrandMelee.ID) and MultiUnits:GetBySpell(A.Kick)<2))
    -- Crackshot builds without T31 should reroll for True Bearing (or Broadside without Hidden Opportunity) if we won't lose over 1 buff
    if A.Crackshot:GetTalentTraits() ~= 0
        and  Player:GetTier("Tier31") < 4
    then
        rtb_reroll=( not  rtb_buffs_will_lose_buff(A.TrueBearing.ID)
        and  A.HiddenOpportunity:GetTalentTraits() ~= 0 or not  rtb_buffs_will_lose_buff(A.Broadside.ID)
        and  A.HiddenOpportunity:GetTalentTraits() == 0 )
        and  rtb_buffs_will_lose() <=1
    end
    -- Crackshot builds with T31 should reroll if we won't lose over 1 buff (2 with Loaded Dice), and if Broadside is not active for builds without Hidden Opportunity
    if A.Crackshot:GetTalentTraits() ~= 0
        and  Player:GetTier("Tier31") >= 4
    then
        rtb_reroll=( rtb_buffs_will_lose() <=1+ boolnumber(Unit(player):HasBuffs(A.LoadedDiceBuff.ID) ~= 0) )
    end
        -- Hidden Opportunity builds without Crackshot should reroll for Skull and Crossbones or any 2 buffs excluding Grand Melee in single target
    if A.Crackshot:GetTalentTraits() == 0
        and A.HiddenOpportunity:GetTalentTraits() ~= 0
    then
        rtb_reroll= not rtb_buffs_will_lose_buff(A.SkullAndCrossbones.ID)
        and ( rtb_buffs_will_lose() <2+ boolnumber(rtb_buffs_will_lose_buff(A.GrandMelee.ID) and MultiUnits:GetBySpell(A.Kick)<2))
    end
    -- Additional reroll rules if all active buffs will not be rolled away and we don't already have 5+ buffs
    rtb_reroll= rtb_reroll
    and rtb_buffs_longer() == 0 or rtb_buffs_normal()==0
    and rtb_buffs_longer()>=1
    and rtb_buffs()<6
    and rtb_buffs_max_remains<=39
    and Unit(player):HasBuffs(stealthLikeBuffs) == 0
    and Unit(player):HasBuffs(A.LoadedDiceBuff.ID) ~= 0
    -- Avoid rerolls when we will not have time remaining on the fight or add wave to recoup the opportunity cost of the global
    --rtb_reroll,op=reset:IsReady(unitID)
    --   and  not (raid_event.adds.remains>12 or raid_event.adds.up
    --   and (raid_event.adds.in-raid_event.adds.remains)<6 or Unit(unitID):TimeToDie() >12) or fight_remains<12
    return rtb_reroll
end
local stopVanishBuffs = {A.ShadowDanceBuff.ID,
                            A.SubterfugeBuff.ID,
                            404141, --/chrono-faded,
                            428668, --/cleansing-flux
                        }
local function safeToVanish(unitID)
    local _, _, threatpct = UnitDetailedThreatSituation(player, unitID)
    threatpct = threatpct or 100 -- if threatpct is nil, set to 100
    local _, _, _, _, _, npcID         = Unit(unitID):InfoGUID() --@number npcID from wowhead/evlui, better than using strings for other languages
    local eightYardTTD = Unit(unitID):TimeToDie() --@number average time to die of all targets in melee
    return (threatpct ~= 100 or Unit(unitID):IsDummy() or npcID == 209333 ) --threatpct is 100 if we are the only target, otherwise it is some other number and it is safe to vanish. Dummys return nil
            and (eightYardTTD > 6 or Unit(unitID):IsBoss())
            and Unit(player):HasBuffs(stopVanishBuffs) == 0
end
local function safeToBladeFlurry(npcID)
    return GetToggle(2, "AoE")
    and (not A.IsInPvP or not EnemyTeam():IsBreakAble(12))
    and npcID ~= 40925 --tainted sentry in TOTT / swell caster
end
------------------------------------------------------------
--Icon Rotation Functions
------------------------------------------------------------
-- [1] CC AntiFake Rotation
A[1] = nil
-- [2] Kick AntiFake Rotation
A[2] = nil
-- [3] Single Rotation
A[3] = function(icon)
    --locals used in ooc/enemy/friendly/defensives
    local inCombat = InCombatLockdown()
    local function EnemyRotation(unitID)
        local _, _, _, _, _, npcID         = Unit(unitID):InfoGUID() --@number npcID from wowhead/evlui, better than using strings for other languages
        local isBurst = isBurstCheck(unitID)
        local inMelee = A.Kick:IsSpellInRange(unitID) -- @boolean
        local extraBSCP = boolnumber(Unit(player):HasBuffs(A.Broadside.ID) > 0)
        local eightYardTTD = Unit(unitID):TimeToDie()
        local BroadsideRemaing              = Unit(player):HasBuffs(A.Broadside.ID)
        local BuriedTreasureRemaing         = Unit(player):HasBuffs(A.BuriedTreasure.ID)
        local GrandMeleeRemaing             = Unit(player):HasBuffs(A.GrandMelee.ID)
        local RuthlessPrecisionRemaing      = Unit(player):HasBuffs(A.RuthlessPrecision.ID)
        local TrueBearingRemaing            = Unit(player):HasBuffs(A.TrueBearing.ID)
        local SkullAndCrossbonesRemaing     = Unit(player):HasBuffs(A.SkullAndCrossbones.ID)
        local rtb_buffs_max_remains = math.max (BroadsideRemaing,BuriedTreasureRemaing,GrandMeleeRemaing,RuthlessPrecisionRemaing,TrueBearingRemaing,SkullAndCrossbonesRemaing)
        local rtb_reroll = rtbReroll()
        --This is my fix for the shitty Fan The Hammer implemnetation from blizz
        local combo_points = RyanComboPointCorrection()
        local combo_points_deficit = Player:ComboPointsMax() - combo_points
        local ambush_condition = (A.HiddenOpportunity:GetTalentTraits() ~= 0 or combo_points_deficit >= 2+ A.ImprovedAmbush:GetTalentTraits() + boolnumber(BroadsideRemaing ~= 0) ) and Player:Energy() >= 50
        local effective_combo_points = ((Action.EchoingBuffMatch() and 7) or combo_points)
        -- Use finishers if at -1 from max combo points, or -2 in Stealth with Crackshot
        local finish_condition = effective_combo_points >= Player:ComboPointsMax() - 1 - (boolnumber(Unit(player):HasBuffs(stealthLikeBuffs) ~= 0 and A.Crackshot:GetTalentTraits() ~= 0))
        ------------------------------------------
        --Function Definitions                  --
        ------------------------------------------
        local function Stealth()
            --actions.stealth=blade_flurry,if=talent.subterfuge&talent.hidden_opportunity&spell_targets>=2&!buff.blade_flurry.up
            if A.BladeFlurry:IsReady(player, true)
                and safeToBladeFlurry(npcID)
                and (eightYardTTD > 4 or Unit(unitID):IsBoss())
                and inMelee -- this is to prevent opening on mobs with a far one targeted
                --apl
                and A.Subterfuge:GetTalentTraits() ~= 0
                and A.HiddenOpportunity:GetTalentTraits() ~= 0
                and MultiUnits:GetBySpell(A.Kick)>=2
                and Unit(player):HasBuffs(A.BladeFlurry.ID) < GetCurrentGCD() + 0.300
            then
                return A.BladeFlurry:Show(icon)
            end
            if A.ColdBlood:IsReady(player)
                and not A.Shiv:ShouldStopByGCD() -- this is to force OGCD abilities to wait for higher priorites (should work well since outlaw doest not stack OGCD)
                and inMelee
                --APL
                and finish_condition
            then
                return A.ColdBlood:Show(icon)
            end
            --actions.build+=/pool_resource,for_next=1
            local _, betweenTheEyesNoEnergy = IsUsableSpell(A.Ambush.ID)
            if betweenTheEyesNoEnergy
                and inMelee
                --APL
                and finish_condition
                and A.Crackshot:GetTalentTraits() ~= 0
            then
                return A.Vigor:Show(icon)
            end
            if A.BetweenTheEyes:IsReady(unitID)
                and inMelee
                --APL
                and finish_condition
                and A.Crackshot:GetTalentTraits() ~= 0
            then
                return A.BetweenTheEyes:Show(icon)
            end
            if A.Dispatch:IsReady(unitID)
                and inMelee
                and finish_condition
            then
                return A.Dispatch:Show(icon)
            end
            if A.PistolShot:IsReady(unitID)
                and inMelee
                and Unit(player):HasBuffs({A.Stealth.ID, A.SubterfugeStealth.ID}) == 0
                --APL
                and A.Crackshot:GetTalentTraits() ~= 0
                and A.FanTheHammer:GetTalentTraits() >=2
                and Unit(player):HasBuffsStacks(A.Opportunity.ID) >=6
                and ( Unit(player):HasBuffs(A.Broadside.ID) ~= 0 and combo_points <=1 or Unit(player):HasBuffs(A.GreenskinsWickersBuff.ID) ~= 0 )
            then
                return A.PistolShot:Show(icon)
            end
            if A.Ambush:IsReady(unitID)
                and A.HiddenOpportunity:GetTalentTraits() ~= 0
            then
                return A.Ambush:Show(icon)
            end
            --Low level Ambush, if you dont have any of the capstones
            if A.Ambush:IsReady(unitID)
                and A.HiddenOpportunity:GetTalentTraits() == 0
                and A.Crackshot:GetTalentTraits() == 0
                and A.KeepItRolling:GetTalentTraits() == 0
            then
                return A.Ambush:Show(icon)
            end
        end
        local function StealthCDs()
            if not isBurst then return false end
            if A.SinisterStrike:ShouldStopByGCD() and GetGCD() ~= 0 then return false end
            --if GetCurrentGCD() > 0.300 + A.GetPing() then return false end -- this is to force OGCD abilities to wait for hire priorites (should work well since outlaw doest not stack OGCD)
            --if GetCurrentGCD() <= 0.05 + A.GetPing() then return false end --dont Off GCD in the last MSs
            if not inMelee then return false end
            if not inCombat then return false end
            --variable,name=vanish_opportunity_condition,value=!talent.shadow_dance&talent.fan_the_hammer.rank+talent.quick_draw+talent.audacity<talent.count_the_odds+talent.keep_it_rolling
            local vanish_opportunity_condition = A.ShadowDance:GetTalentTraits() == 0 and A.FanTheHammer:GetTalentTraits() + A.QuickDraw:GetTalentTraits() + A.Audacity:GetTalentTraits() < A.CountTheOdds:GetTalentTraits() + A.KeepItRolling:GetTalentTraits()
            if A.Vanish:IsReady(player, true)
                and safeToVanish(unitID) -- my Logic to prevent stupid vanishes
                --begin API logic
                and
                (
                    --vanish,if=talent.hidden_opportunity&!buff.audacity.up&(variable.vanish_opportunity_condition|buff.opportunity.stack<buff.opportunity.max_stack)&variable.ambush_condition&variable.vanish_condition
                    (
                    A.HiddenOpportunity:GetTalentTraits() ~= 0
                    and A.Crackshot:GetTalentTraits() == 0
                    and Unit(player):HasBuffs(A.AudacityBuff.ID) == 0
                    and (vanish_opportunity_condition or Unit(player):HasBuffsStacks(A.Opportunity.ID) < 3 * A.FanTheHammer:GetTalentTraits())
                    and ambush_condition
                    )
                )
                then
                        return A.Vanish:Show(icon)
            end
            if A.Vanish:IsReady(player, true)
                and safeToVanish(unitID) -- my Logic to prevent stupid vanishes
                --begin API logic
                and
            (
                --vanish,if=(!talent.find_weakness|talent.audacity)&!talent.hidden_opportunity&variable.finish_condition&variable.vanish_condition
                ((A.HiddenOpportunity:GetTalentTraits() == 0 or A.Crackshot:GetTalentTraits() ~= 0 ) and finish_condition)
            )
            then
                    return A.Vanish:Show(icon)
            end
            if A.ShadowDance:IsReady(player, true)
                and (eightYardTTD > 7 or Unit(unitID):IsBoss())
                --apl
                and A.Crackshot:GetTalentTraits() ~= 0
                and finish_condition
            then
                return A.ShadowDance:Show(icon)
            end
            --adds apl checks to action checks
            local shadow_dance_condition =
                inMelee
                and (eightYardTTD > 7 or Unit(unitID):IsBoss())
                and Unit(player):HasBuffs(A.BetweenTheEyes.ID) ~= 0
                and ( A.HiddenOpportunity:GetTalentTraits() == 0 or Unit(player):HasBuffs(A.AudacityBuff.ID) == 0 and ( A.FanTheHammer:GetTalentTraits() < 2 or Unit(player):HasBuffs(A.Opportunity.ID) == 0 ))
                and A.Crackshot:GetTalentTraits() == 0
            if A.ShadowDance:IsReady(player, true)
            and A.KeepItRolling:GetTalentTraits() == 0
            and shadow_dance_condition
            and Unit(player):HasBuffs(A.SliceAndDice.ID) ~= 0
            and (finish_condition or A.HiddenOpportunity:GetTalentTraits() ~= 0)
            and (A.HiddenOpportunity:GetTalentTraits() == 0 or (A.Vanish:GetCooldown() > 0 or A.Vanish:IsBlocked())) --vanish blocked
            then
                return A.ShadowDance:Show(icon)
            end
            -- KIR builds without Crackshot use Dance at finish condition but hold it for an upcoming KIR
            if A.ShadowDance:IsReady(player, true)
            and A.KeepItRolling:GetTalentTraits() ~= 0
            and shadow_dance_condition
            and (A.KeepItRolling:GetCooldown() <= 30 or A.KeepItRolling:GetCooldown() > 120 and (finish_condition or A.HiddenOpportunity:GetTalentTraits() ~= 0))
            then
                return A.ShadowDance:Show(icon)
            end
        end
        local function CDs()
            if A.AdrenalineRush:IsReady(unitID, true)
            and isBurst
            and inMelee
            and not A.Shiv:ShouldStopByGCD() -- this is to force OGCD abilities to wait for hire priorites (should work well since outlaw doest not stack OGCD)
            --apl
            and (
                Unit(player):HasBuffs(A.AdrenalineRushBuff.ID) == 0
                and ( not finish_condition or A.ImprovedAdrenalineRush:GetTalentTraits() == 0 ) or Unit(player):HasBuffs(stealthLikeBuffs) ~= 0
                and  A.Crackshot:GetTalentTraits() ~= 0
                and  A.ImprovedAdrenalineRush:GetTalentTraits() ~= 0
                and combo_points<=2
            )
            then
                return A.AdrenalineRush:Show(icon)
            end
            if A.BladeFlurry:IsReady(player, true)
                and safeToBladeFlurry(npcID)
                --APL
                and (
                    MultiUnits:GetBySpell(A.Kick) >=2 - boolnumber(A.UnderhandedUpperHand:GetTalentTraits() ~= 0
                                                                    and Unit(player):HasBuffs(stealthLikeBuffs) == 0
                                                                    and Unit(player):HasBuffs(A.AdrenalineRushBuff.ID) ~= 0)
                and Unit(player):HasBuffs(A.BladeFlurry.ID) < GetGCD()
                )
            then
                return A.BladeFlurry:Show(icon)
            end
            if A.BladeFlurry:IsReady(player, true)
                and safeToBladeFlurry(npcID)
                --APL
                and ( A.DeftManeuvers:GetTalentTraits() ~= 0
                        and not finish_condition
                        and (MultiUnits:GetBySpell(A.Kick) >= 3 and combo_points_deficit == MultiUnits:GetBySpell(A.Kick)+ boolnumber(Unit(player):HasBuffs(A.Broadside.ID) ~= 0)
                            or MultiUnits:GetBySpell(A.Kick)>=5)
                )
            then
                return A.BladeFlurry:Show(icon)
            end
            if A.RollTheBones:IsReady(player, true)
                and (inMelee)
                --APL
                and (rtb_reroll
                or rtb_buffs() == 0
                or rtb_buffs_max_remains<=2 and Player:GetTier("Tier31") >= 4
                or rtb_buffs_max_remains<=7 and (A.ShadowDance:GetCooldown() == 0 or A.Vanish:GetCooldown() == 0)
                )
            then
                return A.RollTheBones:Show(icon)
            end
            if A.KeepItRolling:IsReady(player, true)
            and isBurst
            --APL
            and not rtb_reroll
            and rtb_buffs() >= 3 + boolnumber(Player:GetTier("Tier31") >= 4 )
            and ( Unit(player):HasBuffs(A.ShadowDanceBuff.ID) == 0 or rtb_buffs() >=6)
            then
                return A.KeepItRolling:Show(icon)
            end
            if A.GhostlyStrike:IsReady(unitID)
                and not A.Shiv:ShouldStopByGCD() --wait for GCD correctly
                and npcID ~=  174773
                and (Unit(unitID):TimeToDie() > 7 or Unit(unitID):IsBoss() )
                and effective_combo_points < Player:ComboPointsMax()
            then
                return A.GhostlyStrike:Show(icon)
            end
            if A.Sepsis:IsReady(unitID)
                and (A.Crackshot:GetTalentTraits() ~= 0
                and A.BetweenTheEyes:GetCooldown() == 0
                and finish_condition
                and Unit(player):HasBuffs(stealthLikeBuffs) == 0
                or
                A.Crackshot:GetTalentTraits() == 0
                and (Unit(unitID):TimeToDie() >11 or Unit(unitID):IsBoss())
                and Unit(player):HasBuffs(A.BetweenTheEyes.ID) ~= 0 )
                --or fight_remains<11
            then
                return A.Sepsis:Show(icon)
            end
            if Unit(player):HasBuffs(stealthLikeBuffs) <= 0
                and (A.Crackshot:GetTalentTraits() == 0
                    or A.BetweenTheEyes:GetCooldown() <= GetCurrentGCD())
            and StealthCDs() then return true end
            if A.ThistleTea:IsReady(player, true)
                and Unit(player):HasBuffs(A.ThistleTea.ID) == 0
                and (Player:EnergyDeficit() >= 100 or Unit(unitID):IsBoss() and Unit(unitID):TimeToDie() < A.ThistleTea:GetSpellChargesFrac() * 6)
            then
                return A.ThistleTea:Show(icon)
            end
            if A.BladeRush:IsReady(unitID)
                --apl
                and Player.BaseEnergyTimeToMax() > 4
                and Unit(player):HasBuffs(stealthLikeBuffs) == 0
            then
                return A.BladeRush:Show(icon)
            end
            if A.Fireblood:IsReady(unitID, true) and inMelee and Player:Energy() < 44 then return A.Fireblood:Show(icon) end
            if A.Berserking:IsReady(unitID, true) and inMelee and Player:Energy() < 44 then return A.Berserking:Show(icon) end
            if A.BloodFury:IsReady(unitID, true) and inMelee and Player:Energy() < 44 then return A.BloodFury:Show(icon) end
            if A.LightsJudgment:IsReady(unitID) and Player:Energy() < 44 then return A.LightsJudgment:Show(icon) end
            if A.BagofTricks:IsReady(player) and inMelee and Player:Energy() < 44 then return A.BagofTricks:Show(icon) end
            if A.AncestralCall:IsReady(player) and inMelee and Player:Energy() < 44 then return A.AncestralCall:Show(icon) end
            if inMelee and isBurst and Unit(player):HasBuffs(stealthedBasic) == 0  and UseItems(unitID, icon) then return true end --prevent all items in stealth and BTE sync
        end
        local function Finishers()
            if A.BetweenTheEyes:IsReady(unitID)
                and inMelee
                --apl
                and A.Crackshot:GetTalentTraits() == 0
                and (Unit(player):HasBuffs(A.BetweenTheEyes.ID) <4 or A.ImprovedBetweenTheEyes:GetTalentTraits() ~= 0 or A.GreenskinsWickers:GetTalentTraits() ~= 0 or Player:GetTier("Tier30") >= 4)
                and Unit(player):HasBuffs(A.GreenskinsWickersBuff.ID) == 0
            then
                return A.BetweenTheEyes:Show(icon)
            end
            if A.BetweenTheEyes:IsReady(unitID)
                and inMelee
                --apl
                and A.Crackshot:GetTalentTraits() ~= 0
                and A.Vanish:GetCooldown() > 45
                and A.ShadowDance:GetCooldown() >12
            then
                return A.BetweenTheEyes:Show(icon)
            end
            if A.SliceAndDice:IsReady(player, true)
                and not Action.EchoingBuffMatch() --can't SND with ER
                and Unit(player):HasBuffs(stealthLikeBuffs) == 0  --I added this to prevent wasting crackshot windows on SnD
                --APL
                and Unit(player):HasBuffs(A.SliceAndDice.ID) <= (1.8 + (combo_points) * 1.8) --PT functions bug out when extending duration with RTB buffs
                and Unit(player):HasBuffs(A.SliceAndDice.ID) < eightYardTTD
            then
                return A.SliceAndDice:Show(icon)
            end
            if A.KillingSpree:IsReady(unitID)
                and isBurst
                and Player:IsStayingTime() > 0.3
                and inMelee
                --apl
                and (Unit(unitID):HasDeBuffs(A.GhostlyStrike.ID, true) ~= 0 or A.GhostlyStrike:GetTalentTraits() == 0)
            then
                return A.KillingSpree:Show(icon)
            end
            if A.ColdBlood:IsReady(player, true)
                and not A.Shiv:ShouldStopByGCD() -- this is to force OGCD abilities to wait for higher priorites (should work well since outlaw doest not stack OGCD)
            then
                return A.ColdBlood:Show(icon)
            end
            if A.Dispatch:IsReady(unitID)
            then
                return A.Dispatch:Show(icon)
            end
            --evicerate is low level ability, not in loader, defined to show Dispatch icon instead
            if A.Eviscerate:IsReady(unitID) then
                return A.Eviscerate:Show(icon)
            end
            --pool until we can finish
            return A.RogueClass:Show(icon)
        end
        local function Builders()
            if A.EchoingReprimand:IsReady(unitID)
                --and (eightYardTTD > 4 or Unit(unitID):IsBoss())
            then
                return A.EchoingReprimand:Show(icon)
            end
            if A.Ambush:IsReady(unitID)
                and A.HiddenOpportunity:GetTalentTraits() ~= 0
                and ( Unit(player):HasBuffs(A.AudacityBuff.ID) ~= 0)
            then
                return A.Ambush:Show(icon)
            end
            if A.PistolShot:IsReady(unitID)
                and inMelee
                and Unit(player):HasBuffs(stealthedBasic) == 0
                and
                --apl
                    (
                    A.FanTheHammer:GetTalentTraits() ~= 0
                    and  A.Audacity:GetTalentTraits() ~= 0
                    and  A.HiddenOpportunity:GetTalentTraits() ~= 0
                    and  Unit(player):HasBuffs(A.Opportunity.ID) ~= 0
                    and  Unit(player):HasBuffs(A.AudacityBuff.ID) == 0
                    )
            then
                return A.PistolShot:Show(icon)
            end
            if A.PistolShot:IsReady(unitID)
            and inMelee
            and Unit(player):HasBuffs(stealthedBasic) == 0
            and
            --apl
            (
            (
                A.FanTheHammer:GetTalentTraits() ~= 0
                and  Unit(player):HasBuffs(A.Opportunity.ID) ~= 0
                and ( Unit(player):HasBuffsStacks(A.Opportunity.ID) >= 6 or Unit(player):HasBuffs(A.Opportunity.ID) <2)
                )
            )
            then
                return A.PistolShot:Show(icon)
            end
            if A.PistolShot:IsReady(unitID)
            and inMelee
            and Unit(player):HasBuffs(stealthedBasic) == 0
            --apl
            and(
                A.FanTheHammer:GetTalentTraits() ~= 0
                and  Unit(player):HasBuffs(A.Opportunity.ID) ~= 0
                and (
                    combo_points_deficit >=(1+( A.QuickDraw:GetTalentTraits() + boolnumber(Unit(player):HasBuffs(A.Broadside.ID) ~= 0) )*( A.FanTheHammer:GetTalentTraits() +1))
                or combo_points<= A.Ruthlessness:GetTalentTraits() ~= 0
            )
            )
            then
                return A.PistolShot:Show(icon)
            end
            if A.PistolShot:IsReady(unitID)
            and inMelee
            and Unit(player):HasBuffs(stealthedBasic) == 0
            --apl
            and(
            (
                A.FanTheHammer:GetTalentTraits() == 0
                and  Unit(player):HasBuffs(A.Opportunity.ID) ~= 0
                and (Player:EnergyDeficit() > Player:EnergyRegen()*1.5
                     or combo_points_deficit <=1 + extraBSCP
                     or A.QuickDraw:GetTalentTraits() ~= 0
                     or A.Audacity:GetTalentTraits() ~= 0 and  Unit(player):HasBuffs(A.AudacityBuff.ID) == 0 )
                )
            )
            then
                return A.PistolShot:Show(icon)
            end
            --actions.build+=/pool_resource,for_next=1
            local _, AmbushNoEnergy = IsUsableSpell(A.Ambush.ID)
            if AmbushNoEnergy and (A.HiddenOpportunity:GetTalentTraits() ~= 0) then return A.Vigor:Show(icon) end
            --actions.build+=/ambush,if=talent.hidden_opportunity
            if A.Ambush:IsReady(unitID)
                and A.HiddenOpportunity:GetTalentTraits() ~= 0
            then
                return A.Ambush:Show(icon)
            end
            if A.SinisterStrike:IsReady(unitID) then return A.SinisterStrike:Show(icon) end
            --In combat ranged GCD filler
            if A.PistolShot:IsReady(unitID)
                and inCombat --added to prevent OOC pulling
                and Player:EnergyPercentage() >=95
                and Unit(unitID):HealthPercent() < 100
                and not inMelee
                and Unit(player):HasBuffs(stealthedBasic) == 0
            then
                return A.PistolShot:Show(icon)
            end
            -- GiftofNaaru this will never be called, but i can say i have it!
            if A.GiftofNaaru:AutoRacial(player) then return A.GiftofNaaru:Show(icon) end
        end
        ------------------------------------------
        --EnemyRotation() Stops                 --
        ------------------------------------------
        if Unit(unitID):IsDead() then return false end --stop on dead enemy
        if not UnitCanAttack(player, unitID) then return false end --Stop Rotation if Target can not attack back (yellow enemies)
        -----------------------------------------
        --Enemy Rotation Calls
        -----------------------------------------
        if CDs() then return true end -- CDs
        if Unit(player):HasBuffs(stealthLikeBuffs) - GetCurrentGCD() - A.GetPing() >= 0.200 and Stealth() then return true end --Lower priority Stealth list for Shadow Dance
        if finish_condition and Finishers() then return true end -- Finishers
        if Builders() then return true end -- Builders
    end -- end of EnemyRotation()
    local function OOC()
        if Unit(target):CombatTime() > 0 or InCombatLockdown() then return false end --dont do OOC actions if target or player is in combat
        --logic for no target? yeah, so if im incombatlockdown with no target WTF happens, nothing! and this is how its been a long time
        --Unit(player):HasBuffs(stealthLikeBuffs)
        if Player:CastTimeSinceStart() < 1.6 + (2*A.GetPing()) then return false end --Delay for poisons, mounts, buffs, etc. and other out of combat casts
        --OOC Stealth
        if GetToggle(2, "OOCStealth")
        and A.Stealth:IsReady(player, true)
        and not IsResting()
        and Player:GetStance() == 0
        and not IsMounted()
        and Unit(player):HasBuffs(A.ShroudofConcealment.ID, true) == 0
        then
            return A.Stealth:Show(icon)
        end
        --Poisons use UI settings to check if poison selected is ready, already applied and ooc
        if Player:IsStayingTime() < 0.2  or Unit(player):HasBuffs(A.VanishStealth.ID) ~= 0  then  return false end
        --LethalPosion Toggle is 1, select Instant Posion otherwise Select Wound Poison
        local LethalPoison = GetToggle(2,"LethalPoison") == 1 and A.InstantPoison or A.WoundPoison
        if LethalPoison:IsReady(player, true)
        and (Unit(player):HasBuffs(LethalPoison.ID) == 0 --nobuff
            or A.LeechingPoison:GetTalentTraits() ~= 0 and Unit(player):HasBuffs(A.LeechingPoisonBuff.ID) == 0 --missing leeching poison buff
            )
        then
            return LethalPoison:Show(icon)
        end
        --NonlethalPosion Toggle is 1, select Crippling Poison, If toggle is 2, check which Talent is learned and update variable
        local NonLethalPoison
        if GetToggle(2,"NonLethalPoison") == 1 or A.NumbingPoison:GetTalentTraits() == 0 and A.AtrophicPoison:GetTalentTraits() == 0 then NonLethalPoison =  A.CripplingPoison
        elseif A.NumbingPoison:GetTalentTraits() ~= 0 then NonLethalPoison = A.NumbingPoison
        elseif A.AtrophicPoison:GetTalentTraits() ~= 0 then NonLethalPoison = A.AtrophicPoison
        end
        if NonLethalPoison:IsReady(player, true) and Unit(player):HasBuffs(NonLethalPoison.ID) == 0  --nobuff
        then
            return NonLethalPoison:Show(icon)
        end
    end --end of OOC()
    ------------------------------------------
    --Full Rotation Stops
    ------------------------------------------
    if IsMounted() then return A.RogueClass:Show(icon) end --Stop Rotation if Mounted. Action has check for this but can lag after stealthing
    if Player:IsCasting() or Player:IsChanneling() then return A.RogueClass:Show(icon) end --Don't interrupt casts
    ------------------------------------------
    --Call Rotations
    ------------------------------------------
    if not inCombat and OOC() then return true end --out of combat checks
    if Unit(target):IsEnemy() and EnemyRotation(target) then return true end --run enemy target rotation
end --end of A[3]
A[4] = nil
A[5] = nil
A[6] = nil
A[7] = nil
A[8] = nil