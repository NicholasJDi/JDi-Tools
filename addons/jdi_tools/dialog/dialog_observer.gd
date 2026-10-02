@abstract
class_name DialogObserver
extends Control
## Abstract base class for anything that observes JDiDialog events.
##
## Abstract base class for anything that observes JDiDialog events, resolves and responds to node events and allows skipping.

## What [member JDiDialogCharacter.name]'s this observer handles.[br][br]
## [b]Note:[/b] When empty accepts all events
@export var characters: Array[String]
## When [code]true[/code] makes any checks against [member characters] require all checks to be met instead of just one.
@export var enforce_characters: bool
## When a node is received bind to that [param title] until the matching [signal DialogManager.tree_finished]
@export var title_locked := true

# 0 = failed
# 1 = running
# 2 = success
# 3 = skipped
var _states: Dictionary[String, int]
var _title: String


func _ready() -> void:
	DialogManager.node_changed.connect(_on_node_changed)
	DialogManager.dialog_skipped.connect(_on_dialog_skipped)
	DialogManager.tree_finished.connect(_on_tree_finished)


func _on_node_changed(title: String, new_node: Dictionary, node_index: int) -> void:
	var character = new_node.get("character")
	if not characters.is_empty() and not characters.has(character):
		return
	if not _title:
		_title = title
	if title_locked and _title != title:
			return
	var state := title + str(node_index)
	_states[state] = 1
	DialogManager.observer_started.emit(title, characters, node_index, self)
	_node_changed(title, new_node, DialogManager.resources[title].characters.get(character), node_index)
	while _states[state] == 1:
		await get_tree().process_frame
	_states.erase(state)
	DialogManager.observer_finished.emit(title, characters, node_index, self)


func _on_dialog_skipped(title: String, related_characters: Array[String], index: int, observer: DialogObserver) -> void:
	if title_locked and title != _title:
		return
	if not characters.is_empty() and not related_characters.is_empty():
		var has = false
		for character in related_characters:
			if characters.has(character):
				has = true
			elif enforce_characters:
				return
		if not has:
			return
	_states[title + str(index)] = 3
	_dialog_skipped(title, characters, index, observer)


func _on_tree_finished(title: String) -> void:
	if title_locked and title != _title:
		return
	_title = ""
	_tree_finished(title)


## Run whenever a JDiDialog node changes
func _node_changed(title: String, node: Dictionary, character: JDiDialogCharacter, index: int) -> void:
	_states[title + str(index)] = 2


## Run whenever dialog is skipped in some way (see [signal DialogManager.dialog_skipped])
func _dialog_skipped(title: String, related_characters: Array[String], index: int, observer: DialogObserver) -> void:
	pass


## Run whenever a JDiDialog tree ends
func _tree_finished(title: String) -> void:
	pass


## Gets the type name of this observer. (e.g. "bubble")
@abstract func get_observer_type() -> String
