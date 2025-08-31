# LORED Modding Kit
Helpful tools for creating mods for LORED :D

Be sure to read the quickstart section! Beyond that, you don't have to read all this crap at once. Refer to it as you have questions, or somethin.

## Quickstart

### After these steps, your ready-to-download mod will look something like this:
- SteamCuratorTycoon.zip
	- steam_curator_tycoon (folder)
		- data_deletions.json
		- icon.png
		- info.json
		- mod.zip

### Steps
1. Create a `key` for your mod.
	- It should be similar to the name of your mod.
	- This is a short identifier which must be unique. If two mods share a `key`, one mod will overwrite the other.
2. Create a new project with Godot Engine.
	- You will have a nearly-blank `res://` folder.
	- Copy the `quickstart > new_project` folder into the `res://` folder of your mod.
		- This folder contains a series of folders and files, not all of which you may even use.
		- `main.gd` and `main.tscn` are vital!
	- Rename the `new_project` folder in your project to match your mod's `key`.
3. Create the folder you will export your mod to.
	- You can copy the `quickstart > exported_project` to achieve this.
	- The name of this folder must match your mod's `key`.
	- LORED will search this folder for `info.json`. That must be filled out.
		- Do not use any bbcode in json files. It will be stripped from the text and could result in errors.
	- Add an `icon.png` or `icon.svg` representing your mod.
		- 16x16 is the recommended resolution for this icon. It will be displayed in-game at 32x32.

4. **Make your mod!**

5. Export the project!
	- Click `Export PCK/Zip`.
	- Ensure `Export As Patch` is checked on.
	- Name it `mod.zip` and export it to your exported project folder (with your info and icon).
6. (Optional) Set up data manipulation files.
	- In `quickstart > data_manipulation`, you can find `data_overwrites` and `data_deletions`. If appliccable, fill these out.
	- Place these in the exported project folder next to your icon and info.
7. Zip up your exported project folder! It can be named anything.
8. To use your mod, unzip the exported project folder and place it into the LORED `mods` folder.
	- Windows: `%USERPROFILE%/AppData/Roaming/Godot/app_userdata/LORED/mods/`
	- Linux: `~/.local/share/godot/app_userdata/LORED/mods/`
You're done! Yee-haw! Wee-hoo!

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
If you wanted to create an Upgrade which affected Output, Input, Output and Input, or Haste, making use of `Affected Objects` and `Effect` will save you a lot of effort! I already put in the hours for many common Upgrade effects--don't put in the same hours for the same effects!

`Affected Objects`
- The first word is typically the category, and the second will be the object's key, the two separated by a space. If you want an Upgrade to affect Will the Iron LORED, you would write "lored iron"

`Effect`
- This depends on the first word written in `Affected Objects`, and it specifies what will happen to those affected objects. If you want an Upgrade to multiply Schlonky the Honkydonky LORED's Haste by 1,000, you would write "lored schlonky" for the `Affected Objects` and "haste x1000" for the `Effect`.
- For _additive_ Upgrades which have a + or - in the second word (e.g. "+1"), you would write how much they increase per level.
	- For example, if you want an Upgrade with 5 purchase levels to increase Output by +10 (base), you would write "output +2". It will increase by 2 each purchase, resulting in +10.
- As for _multiplicative_ Upgrades which have a x or / in the second word (e.g. "x2"), you write what you want the final value to be, and the game will calculate what the effect will be at each level.
	- For example, if you want an Upgrade with 5 purchase levels to multiply Output by 10, you would write "output x10". The game will run `value ** (1.0 / times_purchased.get_total())` (value being 10 in this example, and total times_purchased being 5), resulting in 10 ^ (1 / 5) = 1.58. That means that each level will multiply Output by 1.58, resulting in 10 after 5 purchases.

Below is a list of the most common `Affected Objects` values with real examples from the base game and what they do.
- "lored coal" - "lored" is the category, and "coal" is the key of the Coal LORED. So, this Upgrade would affect the Coal LORED in some way.
	- The `unlock_coal` Upgrade determines whether the Coal LORED is unlocked or not. `Effect`: "unlock"
- "lored main1" - "main1" is the key for Stage 1 in the base game. This would affect all Stage 1 LOREDs.
	- `how_is_this_an_rpg` adds +10% Crit Chance to every Stage 1 LORED. `Effect`: "crit_chance +10"
- "lored all" - This would affect all LOREDs.
	- `lucky_crit2` adds a total of 5% Lucky Crit to every LORED. `Effect`: "lucky_crit +1"
- "tree 1a" - "tree" is the category for Upgrade Trees, and "1a" is the key for the Firestarter Upgrades in the base game.
	- `so_close` unlocks the Upgrade autobuyer for Firestarter Upgrades. `Effect`: "autobuy"
- "juice" - The developer who originally came up with this as an `Affected Objects` category has been fired. These Upgrades buff any Juice-related stats.
	- `thrush` increased the Juiced Output & Input of LOREDs who are Juiced. `Effect`: "xput +0.05"
- "rage" - "rage" Upgrades affect Enraged stats.
	- `grr_im_mad` increases Maximum Enraged Duration. `Effect`: "max_duration +1"
- "lored iron, lored copper" - An example where the Upgrade applies to two objects (the Iron LORED and the Copper LORED).
	- `its_growin_on_me` multiplies the Maximum Output of both of those two LOREDs. `Effect`: "max_output x1"
	- This Upgrade has a unique Class: ItsGrowinOnMe, which extends Upgrade. Take a look at its _init function below. It still makes use of its `Affected Objects` and `Effect` entries by calling super(), and then it goes on to specify further shit.
		```
		class_name ItsGrowinOnMe extends Upgrade
		func _init(_key: StringName) -> void:
			await super(_key)
			...
		```
		Calling super() is still necessary in cases where neither of these entries are used at all in order to set up its icon and other details.
- "stage main2" - "stage" is the category for Stages, and "main2" is the key for Stage 2 in the base game.
	- `a_new_leaf` unlocks Stage 2. `Effect`: "unlock"
- "deck" - This category affects anything related to Cards and stuff like dat.
	- `snap` increases the Hand Size by 1. `Effect`: "hand_size +1"
- "currency coin" - "currency" is the category for Currencies, and "coin" is the key for Coin.
	- `ADVANTAGE_COIN` grants passive income for Coin per second. `Effect`: "passive_gain +0"
	- This Upgrade has a unique Class: PassiveGain, which extends Upgrade.
- "thingies" - This category affects anything related to Thingies.
	- `DOUBLE_DIP` adds 1 to Crit Rolls for all Thingies. `Effect`: "crit_rolls +1"
