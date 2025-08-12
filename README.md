# LORED Modding Kit
Helpful tools for creating mods for LORED

## Creating a mod for LORED
### Get Started
1. Create a new project with Godot Engine. You will have a nearly-blank `res://` folder.
2. Copy the `templates > mod` folder into the `res://` folder of your mod.
3. Rename the `mod` folder to match the `key` of your mod. `key` is a short identifier for your mod. It must be unique to all other mods!
4. Fill out the info.json file.
5. The icons for mods will be displayed in LORED at 32x32. It is recommended to make an icon with the resolution of 16x16, 32x32, or 8x8. Replace the given icon.png with your mod's icon. Make sure it's named icon.png!

### Creating Custom LOREDs
`templates > lored > lored_data.json` is all the information LORED requires to get started. You can customize any of the values there.
If you want to get real crazy, you can replace the Class field of that file with your own script which extends LORED.
