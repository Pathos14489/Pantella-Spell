# PantellaNV
> Bring Skyrim NPCs to life with AI

<img src="./img/pantella_logo_github.png" align="left" alt="Pantella logo" width="150" height="auto">

This repository is for the Pantella Spell mod, which handles the Skyrim-side logic of Pantella. For the main Pantella repository, see [here](https://github.com/art-from-the-machine/Mantella).

The source code for the subtitles plugin can be found [here](https://github.com/swwu/Mantella-Subtitles-Plugin-NG).

The .esp is converted to version-control-friendly .yaml files using [Spriggit](https://github.com/Mutagen-Modding/Spriggit).

The SkyUI SDK is required to work with MCM menu code, which can be found [here](https://github.com/schlangster/skyui/wiki).

### Compatibility
- Some users have reported that Skyrim crashes when Pantella is used with Fuz Ro D'oh. A possible fix is to disable and re-enable Fuz Ro D'oh. I do not know if this is the case with Pantella or not, do let me know if you find out.
- The mod VR Keyboard conflicts with Pantella. It is recommended to use Speech-To-Text instead of Text Input if you are using VR at this time.
- Pantella needs to be loaded after the Unofficial Skyrim Special Edition Patch (USSEP) mod in your load order

## Required Skyrim Mods
**NB:** Always ensure you are downloading the right version of each mod for your version of Skyrim. **This is the #1 reason for installation problems.** You can check your Skyrim version by right-clicking its exe file in your Skyrim folder and going to Properties -> Details -> File version. VR users can just download the VR version of each mod if available, or SE if not.

Please follow the installation instructions on each of the linked pages:

- [SKSE](http://skse.silverlock.org/) (once installed by following the included readme.txt, run SKSE instead of the Skyrim exe. Note that there is a separate VR version of SKSE)
- [VR Address Library for SKSEVR](https://www.nexusmods.com/skyrimspecialedition/mods/58101  )
  or [Address Library for SKSE Plugins](https://www.nexusmods.com/skyrimspecialedition/mods/32444)
- [PapyrusUtil SE]( https://www.nexusmods.com/skyrimspecialedition/mods/13048) (the VR version can be found under "Miscellaneous Files")
- [UIExtensions](https://www.nexusmods.com/skyrimspecialedition/mods/17561) (if using text input instead of mic)

If you're using a Skyrim version older than 1.6.1130, please use this mod as well for your flavor of Skyrim
[Backported Extended ESL Support](https://www.nexusmods.com/skyrimspecialedition/mods/106441) or [Skyrim VR ESL Support](https://www.nexusmods.com/skyrimspecialedition/mods/106712/)

## Optional Recommended Skyrim Mods
These mods aren't strictly necessary for Pantella to work, but they do improve the experience.

- [No NPC Greetings](https://www.nexusmods.com/skyrim/mods/746) (recommended so that Pantella voicelines are not interrupted by vanilla voicelines)
- [World Encounter Hostility Fix - Performance Version](https://www.nexusmods.com/skyrimspecialedition/mods/91403  ) (stops certain NPCs from turning hostile when you cast the Pantella spell on them). Note that this mod requires the [Unofficial Skyrim Special Edition Patch (USSEP)](https://www.nexusmods.com/skyrimspecialedition/mods/266). Pantella needs to be loaded after USSEP in your load order.

# How to Install

I do not recommend manually installing this mod, instead please use the [launcher](https://github.com/Pathos14489/Pantella-Launcher). However if you must, all the scripts on this repo are precompiled, merely download by clcking the Code button, then Download ZIP. The zip downloaded will contain the mod plugin. The zip downloaded will contain the mod plugin. Install it using your mod manager of choice.