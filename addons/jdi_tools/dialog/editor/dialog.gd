@tool
extends Control

@onready var tree: MarginContainer = $HSplitContainer/Tree


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func open(resource) -> void:
	if resource is JDiDialog:
		show()
		tree.save()
		tree.clear()
		tree.load(resource)
	elif resource is JDiDialogCharacter:
		show()
		tree.save()
		tree.clear()
		tree.load(resource)
