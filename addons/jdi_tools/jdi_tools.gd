@tool
extends Control

@onready var dialog: Control = $TabContainer/Dialog


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func open(resource):
	if resource is JDiDialog or resource is JDiDialogCharacter:
		dialog.open(resource)
