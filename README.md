# Fortify Fix and Max - Health, Magicka and Fatigue (OpenMW)

Makes Fortify Health, Magicka and Fatigue boost max values as well as current ones. Prevents you from dying or collapsing when Health or Fatigue fortification expires.

This mod does two distinct things for Fortify Health, Magicka and Fatigue effects:

1. It makes them increase not only the current stat, but also its maximum value.
2. It prevents you from dying or collapsing when the Health or Fatigue fortification expires and you're left with a negative current value.

It comes in two flavors:

1. Player-only - affects only the player, very performance-friendly **(recommended)**
2. Every actor - affects everyone, may negatively affect performance, especially in crowded places

**Don't enable both versions at the same time.**

### Caveats

To prevent dying or collapsing from an expiring effect, the mod manually removes whole spells containing a Fortify Health or Fortify Fatigue effect that is close to expiring AND would put you in the danger zone. If such a spell also has other effects, those will be removed along with it.

Which is to say, it's really minor.

## Compatibility

Should be compatible with about any mod.

Don't use together with [Fortify Health Fix](https://www.nexusmods.com/morrowind/mods/56523) by ownlyme. This mod is meant as a successor to it, since:

- Everything from Fortify Health Fix is already included here
- It performs way better
- It covers Magicka and Fatigue
- It can affect non-player actors

## Credits

**Sosnoviy Bor** - Author  
**Varlothen and Necrolesian** - Initial idea ([Fortify MAX](https://www.nexusmods.com/morrowind/mods/49825))  
**ownlyme** - Inspiration ([Fortify Health Fix](https://www.nexusmods.com/morrowind/mods/56523))
