# LORED Modding Kit
Helpful tools for creating mods for LORED :D

## Quickstart
Copy the `templates > mod` folder into a Godot project, export the project as a zip, and put it into the LORED `mods` folder!
1. Think of `key` for your mod.
	- It should be similar to the name of your mod.
	- This is a short identifier which must be unique. If two mods share a `key`, one mod will overwrite the other.
2. Create a new project with Godot Engine. You will have a nearly-blank `res://` folder.
3. Copy the `templates > mod` folder into the `res://` folder of your mod.
	- The `mod` folder has all of the required files that LORED will look for.
4. Rename the `mod` folder to match your mod's `key`.
5. Fill out `info.json`.
	- Do not use any bbcode in json files!
6. Add your own `icon.png` or `icon.svg`.
	- The icons for mods will be displayed in LORED at 32x32. It is recommended to make an icon with the resolution of 16x16 (best if you're not a pixel art gawd), 32x32 (best if you're a pixel art gawd), or 8x8 (not the best in any way). Or 4x4 (huh?).

# Creating Custom LOREDs
`templates > lored > lored_data.json` is all the information LORED requires to get started. You can customize any of the values there.
If you want to get real crazy, you can replace the Class field of that file with your own script which extends LORED.

## "Jobs" vs "Primary Jobs"
Under `Jobs`, list every Job the LORED will be able to perform.
`Primary Jobs` is used for rate calculations.
- If a LORED only has one currency he attempts to collect but with multiple Jobs to achieve it, list the preferred Job only
- If a LORED does have two currencies he makes with multiple jobs, list all of those Jobs here as well.

# Creating Custom Upgrades
`templates > upgrade` has a few example Upgrades to get you started.
If you wish to achieve something more unique than what the combination of the `Effect` and `Affected Object` fields can achieve, create your own Upgrade class which extends Upgrade and write your own code.

## "Effect" and "Affected Object"
Affected Objects
	- The first word is typically the category, and the second will be the object's key, the two separated by a space. If you want an Upgrade to affect Will the Iron LORED, you would write "lored iron"

Below is a list of `Affected Objects` with examples from the base game.
- "lored coal" - This would affect the Coal LORED.
	- The `unlock_coal` Upgrade determines whether the Coal LORED is unlocked or not. `Effect`: "unlock"
- "lored main1" - "main1" is the key for Stage 1 in the base game. This would affect all Stage 1 LOREDs.
	- `how_is_this_an_rpg` adds +10% Crit Chance to every Stage 1 LORED. `Effect`: "crit_chance +10"
- "tree 1a" - "tree" is the category for Upgrade Trees, and "1a" is the key for the Firestarter Upgrades in the base game.
	- `so_close` unlocks the Upgrade autobuyer for Firestarter Upgrades. `Effect`: "autobuy"
- "juice" - The developer who originally came up with this as an `Affected Objects` category has been fired. These Upgrades buff any Juice-related stats.
	- `thrush` increased the Juiced Output & Input of LOREDs who are Juiced. `Effect`: "xput +0.05"
- "rage" - Similar to "juice", "rage" affects Upgrades which boost Enraged stats.
	- `grr_im_mad` increases Maximum Enraged Duration. `Effect`: "max_duration +1"
- "lored iron, lored copper" - An example where the Upgrade applies to two objects (the Iron LORED and the Copper LORED).
	- `its_growin_on_me` multiplies the Maximum Output of both of those two LOREDs. `Effect`: "max_output x1"
	- This Upgrade has a unique Class: ItsGrowinOnMe, which extends Upgrade. Take a look at its _init function:
		```
		func _init(_key: StringName) -> void:
			growth = LORED.fetch("growth")
			await super(_key)
		```
- "stage main1" - "stage" is the category for Stages, and "main1" is the key for Stage 1 in the base game.
	- 
