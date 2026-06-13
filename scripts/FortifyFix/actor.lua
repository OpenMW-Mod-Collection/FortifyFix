---@diagnostic disable: missing-parameter
---@omw-context local
local self = require("openmw.self")
local core = require("openmw.core")
local types = require("openmw.types")

if types.Actor.isDead(self) then return end

local activeEffects = self.type.activeEffects(self)
local activeSpells = self.type.activeSpells(self)
local EXPIRY_THRESHOLD = 0.1

---@class FortifyProtection
---@field buffer number
---@field frameCounter number

---@class FortifyEffectEntry
---@field type number
---@field stat any
---@field last number
---@field protection FortifyProtection|nil
local fortifyEffects = {
    {
        type = core.magic.EFFECT_TYPE.FortifyHealth,
        stat = types.Actor.stats.dynamic.health(self),
        last = 0,
        protection = {
            buffer = 0,
            frameCounter = 0,
        }
    },
    {
        type = core.magic.EFFECT_TYPE.FortifyFatigue,
        stat = types.Actor.stats.dynamic.fatigue(self),
        last = 0,
        protection = {
            buffer = 0,
            frameCounter = 0,
        }
    },
    {
        type = core.magic.EFFECT_TYPE.FortifyMagicka,
        stat = types.Actor.stats.dynamic.magicka(self),
        last = 0,
    },
}

---@param entry FortifyEffectEntry
---@param delta number
local function applyDelta(entry, delta)
    entry.stat.base = entry.stat.base + delta
    if entry.protection and delta < 0 then
        if entry.stat.current + delta < 1 then
            -- if in danger zone, give the actor a 1 frame stat buffer
            entry.stat.current = 1 - delta
            entry.protection.frameCounter = 1
            entry.protection.buffer = -delta
        end
    end
end

local function onUpdate()
    if types.Actor.isDead(self) then return end

    -- danger zone handling
    if fortifyEffects[1].last ~= 0 or fortifyEffects[2].last ~= 0 then
        for _, spell in pairs(activeSpells) do
            for _, effect in pairs(spell.effects) do
                if effect.durationLeft and effect.durationLeft < EXPIRY_THRESHOLD then
                    for i = 1, 2 do
                        local entry = fortifyEffects[i]
                        if effect.id == entry.type then
                            local mag = effect.magnitudeThisFrame
                            applyDelta(entry, -mag)
                            entry.last = entry.last - mag
                            activeSpells:remove(spell.activeSpellId)
                        end
                    end
                end
            end
        end
    end

    for i = 1, 3 do
        -- max stat handling
        local entry = fortifyEffects[i]
        local magnitude = activeEffects:getEffect(entry.type).magnitude
        if magnitude ~= entry.last then
            applyDelta(entry, magnitude - entry.last)
            entry.last = magnitude
        end

        -- removing health and fatigue back after survivng the fortify removal
        -- with 1 frame delay
        -- if it's dumb and it works, it ain't dumb
        if entry.protection.frameCounter == 1 then
            entry.protection.frameCounter = 2
        elseif entry.protection.frameCounter == 2 then
            entry.stat.current = entry.stat.current - entry.protection.buffer
            entry.protection.frameCounter = 0
        end
    end
end

local function onSave()
    return {
        h = fortifyEffects[1].last,
        m = fortifyEffects[2].last,
        f = fortifyEffects[3].last,
    }
end

local function onLoad(data)
    if not data then return end
    fortifyEffects[1].last = data.h or fortifyEffects[1].last
    fortifyEffects[2].last = data.m or fortifyEffects[2].last
    fortifyEffects[3].last = data.f or fortifyEffects[3].last
end

return {
    engineHandlers = {
        onUpdate = onUpdate,
        onSave = onSave,
        onLoad = onLoad,
    }
}
