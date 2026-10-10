@tool
class_name DialogBubble
extends DialogBox
## A Text Bubble that can interface with JDiDialog.
##
## A Text Bubble that can interface with JDiDialog, and play sounds.[br][br]
## [b]Note:[/b] To add visuals to the actual bubble add them to the [member DialogBox.label]


func _init() -> void:
	add_child(timer, false, Node.INTERNAL_MODE_FRONT)
	connect("child_entered_tree",_child_changed)
	connect("child_exiting_tree",_child_changed)


func _ready() -> void:
	update_configuration_warnings()
	if Engine.is_editor_hint():
		return
	label = get_label()
	if not label:
		printerr("DialogBubble '" + name + "' could not find valid RichTextLabel")
	stream_player = get_stream_player()
	if not stream_player:
		printerr("DialogBubble '" + name + "' could not find valid AudioStreamPlayer")
	else:
		default_volume = stream_player.volume_linear
		default_pitch = stream_player.pitch_scale


func _process(delta: float) -> void:
	size = Vector2.ZERO


func _node_changed(title: String, node: Dictionary, character: JDiDialogCharacter, index: int) -> void:
	var text: String = node.text
	if node.text_type == "add":
		label.text += text
	else:
		label.visible_characters = 0
		label.text = text
	
	var time: float = talk_time / node.get("talk_speed", 1)
	var rate: int = speak_rate + node.get("speak_rate", 1)
	var volume: float = default_volume * node.get("speak_volume", 1)
	var pitch: float = default_pitch * node.get("speak_pitch", 1)
	var emotion: String = node.get("emotion", "default")
	var voice: String = node.get("voice", emotion)
	
	stream_player.volume_linear = volume
	stream_player.pitch_scale = pitch
	if character:
		var sound: AudioStream = character.sounds.get(voice, character.sounds.get(emotion, character.sounds.get("default")))
		if sound and sound != stream_player.stream:
			stream_player.stream = sound
	
	var rate_pos := 0
	timer.start(time)
	while label.visible_ratio < 1:
		label.visible_characters += 1
		rate_pos += 1
		if rate_pos == rate:
			stream_player.play()
			rate_pos = 0
		await timer.timeout
	if timer.is_stopped():
		return
	timer.stop()
	if stop_sounds_on_end:
		stream_player.stop()
	_states[title + str(index)] = 2


func _dialog_skipped(title: String, related_characters: Array[String], index: int, observer: DialogObserver) -> void:
	timer.stop()
	label.visible_ratio = 1
	timer.timeout.emit()


func _tree_finished(title: String) -> void:
	timer.stop()
	label.visible_ratio = 1
	timer.timeout.emit()
	label.text = ""


## Gets the type name of this observer.
func get_observer_type() -> String:
	return "bubble"


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	var labels := find_children("*", "RichTextLabel", false, false)
	if labels.is_empty():
		warnings.append("DialogBubble requires a direct RichTextLabel child.")
	elif labels.size() > 1:
		warnings.append("DialogBubble can only have one direct RichTextLabel child.")
	var players := find_children("*", "AudioStreamPlayer", false, false)
	if players.is_empty():
		warnings.append("DialogBubble requires a direct AudioStreamPlayer child.")
	elif players.size() > 1:
		warnings.append("DialogBubble can only have one direct AudioStreamPlayer child.")
	return warnings
