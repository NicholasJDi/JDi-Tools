extends Node

## Emitted when the current Node changes in a Dialog Tree
signal node_changed(title: String, new_node: Dictionary, node_index: int)
## Emitted when a Dialog Tree stops being processed
signal tree_finished(title: String)

## Emitted by [DialogObserver]'s when they start processing.
signal observer_started(title: String, characters: Array[String], index: int, observer: DialogObserver)
## Emitted by [DialogObserver]'s when they finish processing.[br][br]
## [b]Note:[/b] Every [DialogObserver] that starts processing must finish processing before the tree automatically continues.
signal observer_finished(title: String, characters: Array[String], index: int, observer: DialogObserver)
## Emitted when dialog is skipped in some way[br][br]
## [b]Note:[/b] If [param observer] is [code]null[/code] the skip was due to a instant node.
signal dialog_skipped(title: String, characters: Array[String], index: int, observer: DialogObserver)

## The [JDiDialog]'s currently in use
var resources: Dictionary[String,JDiDialog] = {}
## Runtime data for [JDiDialog]'s currently running
var data: Dictionary[String,Dictionary] = {}


func _ready() -> void:
	observer_started.connect(_on_observer_started)
	observer_finished.connect(_on_observer_finished)


func _on_observer_started(title: String, characters: Array[String], index: int, observer: DialogObserver):
	if not data[title]:
		return
	if not data[title].index == index:
		return
	if not data[title].count:
		data[title].count = 0
		data[title].finished = false
	data[title].count += 1


func _on_observer_finished(title: String, characters: Array[String], index: int, observer: DialogObserver):
	if not data[title]:
		return
	if not data[title].index == index:
		return
	if not data[title].count:
		return
	data[title].count -= 1
	if data[title].count <= 0:
		data[title].finished = true
		data[title].erase("count")


## Runs a [JDiDialog][br][br]
## [b]Note:[/b] Multiple files running at once is supported but not recommended.
func run(tree: JDiDialog):
	var title := tree.title
	if data[title]:
		push_warning("Attempted to run JDiDialog '", title ,"' while an instance of it is already running")
		return
	resources[title] = tree
	data[title] = { "index":-1, "finished":true }
	var index := -1
	for node in resources[title].nodes:
		if not data[title]:
			push_warning("JDiDialog '", title, "' runtime data went missing")
			return
		if data[title].finished == null:
			break
		
		var remove: Array = node.get("remove", [])
		var persistent: Dictionary = data[title].get("persistent", {})
		var default: Dictionary = data[title].get("default", {})
		var new_persistent: Dictionary = node.get("persistent", {})
		var new_default: Dictionary = node.get("default", {})
		for key in remove:
			persistent.erase(key)
			default.erase(key)
		for key in node.keys():
			persistent.erase(key)
		for key in new_default.keys():
			persistent.erase(key)
		
		persistent.merge(new_persistent, true)
		default.merge(new_default, true)
		var compacted := {}
		compacted.merge(node)
		compacted.merge(persistent)
		compacted.merge(default)
		
		index += 1
		data[title] = {
			"index": index,
			"current": compacted,
			"previous": data[title].get("current", {}),
			"persistent":persistent,
			"default":default,
			"finished": false
		}
		
		node_changed.emit(title, compacted, index)
		if compacted.instant:
			var character = compacted.get("character", "")
			if character:
				character = [character]
			else:
				character = []
			dialog_skipped.emit(title, character, index, null)
		
		if compacted.get("continue"):
			continue
		while not (data[title].finished == true or data[title].finished == null) and data[title].count is int:
			await get_tree().process_frame
	data.erase(title)
