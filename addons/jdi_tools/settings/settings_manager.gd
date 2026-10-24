extends Node
## A [ConfigFile] wrapper for loading and saving settings.

signal loaded
signal save_requested
signal saved

## The local path to the [member config] file
const SETTINGS_FILE_PATH := "user://settings.cfg"

## A comtainer for nodes to store defaults globally if required
var defaults: Dictionary

## The settings config
@onready var config := ConfigFile.new()


func _ready() -> void:
	if FileAccess.file_exists(SETTINGS_FILE_PATH):
		print("Loading Settings")
		config.load(SETTINGS_FILE_PATH)
		loaded.emit()
		print("Settings Loaded")


## Returns [code]true[/code] if the [param section] exists in the [member config].
func has_section(section: String) -> bool:
	return config.has_section(section)


## Returns [code]true[/code] if the [param key] exists in the [member config].
func has_key(section: String, key: String) -> bool:
	return config.has_section_key(section, key)


## Returns the section names of the [member config].
func get_sections() -> PackedStringArray:
	return config.get_sections()


## Returns the keys of a [param section] in the [member config] if it exists.[br][br][b]Note:[/b] Returns an empty array if the [param section] does not exist in the [member config].
func get_keys(section: String) -> PackedStringArray:
	if not config.has_section(section):
		return []
	return config.get_section_keys(section)


## Returns the value of a [param key] in the [member config].[br][br][b]Note:[/b] Returns [param default] if the [param key] does not exist in the [member config].
func get_value(section: String, key: String, default: Variant = null) -> Variant:
	if not config.has_section_key(section, key):
		return default
	return config.get_value(section, key)


## Sets the value of a [param key] in the [member config].
func set_value(section: String, key: String, value: Variant) -> void:
	config.set_value(section, key, value)


## Removes and Returns a [param key]'s value from the [member config] if it exists.[br][br][b]Note:[/b] Returns [param default] if the [param key] does not exist in the [member config].
func clear_key(section: String, key: String, default: Variant = null) -> Variant:
	if not config.has_section_key(section,key):
		return default
	var value = config.get_value(section, key)
	config.erase_section_key(section, key)
	return value


## Removes a [param section] and its keys from the [member config] if it exists.
func clear_section(section: String) -> void:
	if not config.has_section(section):
		return
	config.erase_section(section)


## Completely clears the [member config].[br][br]If [param delete] is [code]true[/code], also deletes the [member config] file if it exists.
func clear(delete: bool = true) -> void:
	config.clear()
	if delete:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SETTINGS_FILE_PATH))


## Saves the [member config] to [constant SETTINGS_FILE_PATH].
func save() -> void:
	save_requested.emit()
	print("Saving Settings")
	config.save(SETTINGS_FILE_PATH)
	saved.emit()
	print("Settings Saved")


## Reloads the [member config] from [constant SETTINGS_FILE_PATH].
func reload() -> void:
	if FileAccess.file_exists(SETTINGS_FILE_PATH):
		print("Reloading Settings")
		config.load(SETTINGS_FILE_PATH)
		loaded.emit()
		print("Settings Reloaded")
