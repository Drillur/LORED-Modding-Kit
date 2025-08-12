# LORED Modding Kit
Helpful tools for creating mods for LORED

## Creating a mod for LORED
### Get Started
1. Assign a `key` for your mod.
- Test 1
  - Test 2.Come up with a `key` for your mod. `key` is a short identifier which must be unique. If two mods share a key, one will overwrite the other.
2. Create a new project with Godot Engine. You will have a nearly-blank `res://` folder.
3. Copy the `templates > mod` folder into the `res://` folder of your mod. **The `mod` folder has all of the required files that LORED will look for.**
4. Rename the `mod` folder to match the `key` of your mod.
5. Fill out `info.json`.
6. The icons for mods will be displayed in LORED at 32x32. It is recommended to make an icon with the resolution of 16x16, 32x32, or 8x8. Replace the given icon.png with your mod's icon. Make sure it's named icon.png!
	- Test!

### Creating Custom LOREDs
`templates > lored > lored_data.json` is all the information LORED requires to get started. You can customize any of the values there.
If you want to get real crazy, you can replace the Class field of that file with your own script which extends LORED.
