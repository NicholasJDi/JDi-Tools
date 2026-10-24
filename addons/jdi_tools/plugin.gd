@tool
extends EditorPlugin

var mainpanel = preload("jdi_tools.tscn").instantiate()


func _enable_plugin() -> void:
	pass


func _disable_plugin() -> void:
	pass


func _enter_tree() -> void:
	EditorInterface.get_editor_main_screen().add_child(mainpanel)
	_make_visible(false)
	add_autoload_singleton("SettingsManager", "settings/settings_manager.gd")
	add_autoload_singleton("DialogManager", "dialog/dialog_manager.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("SettingsManager")
	remove_autoload_singleton("DialogManager")


func _handles(object) -> bool:
	return object is JDiDialog or object is JDiDialogCharacter


func _edit(object) -> void:
	_make_visible(true)
	mainpanel.open(object)


func _make_visible(visible) -> void:
	if mainpanel:
		mainpanel.visible = visible


func _has_main_screen() -> bool:
	return true


func _get_plugin_name() -> String:
	return "JDi Tools"


func _get_plugin_icon() -> Texture2D:
	return preload("icon.svg")
