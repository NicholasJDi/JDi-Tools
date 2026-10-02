@tool
extends EditorPlugin

var MainPanel = preload("jdi_tools.tscn").instantiate()

func _enter_tree() -> void:
	add_autoload_singleton("DialogManager", "dialog/dialog_manager.gd")
	add_custom_type("DialogBubble", "Control", preload("dialog/dialog_bubble.gd"), preload("dialog/dialog_icon.png"))
	EditorInterface.get_editor_main_screen().add_child(MainPanel)
	_make_visible(false)


func _exit_tree() -> void:
	remove_autoload_singleton("DialogManager")
	remove_custom_type("DialogBubble")

func _has_main_screen():
	return true

func _make_visible(visible):
	if MainPanel:
		MainPanel.visible = visible


func _get_plugin_name():
	return "JDi Tools"


func _get_plugin_icon():
	return preload("icon.png")
