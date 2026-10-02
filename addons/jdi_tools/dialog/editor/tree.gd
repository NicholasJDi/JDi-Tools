@tool
extends MarginContainer

var resource :
	set(new_resource):
		resource = new_resource
		_update()

@onready var dialog: VBoxContainer = $Dialog
@onready var character: VBoxContainer = $Character


func new(path: String, type: int) -> void:
	if not type:
		return
	clear()
	match type:
		1:
			self.load(JDiDialog.new())
		2:
			self.load(JDiDialogCharacter.new())
	save(path)


func load(new_resource) -> void:
	assert(new_resource is JDiDialog or new_resource is JDiDialogCharacter, "Invalid resource type!")
	resource = new_resource


func save(path: String = "") -> void:
	if not (resource is JDiDialog or resource is JDiDialogCharacter):
		return
	if resource.resource_path or path:
		ResourceSaver.save(resource, path)


func clear() -> void:
	resource = null


func _update() -> void:
	if resource is JDiDialog:
		dialog.show()
		character.hide()
		dialog.update()
	elif resource is JDiDialogCharacter:
		character.show()
		dialog.hide()
		character.update()
	else:
		dialog.hide()
		character.hide()
