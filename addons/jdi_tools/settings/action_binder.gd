class_name ActionBinder
extends FoldableContainer

## The [InputMap] action this [ActionBinder] handles
@export var action: String
## The action used to cancel rebinding, any input mapped to this action will be unable to be bound.
@export var cancel_action := "ui_cancel"
## The max amount of [InputEvent]s this [ActionBinder] allows.
@export_range(1, 32) var event_limit := 10
## When [code]true[/code], prevents this action fom being modified.
@export var locked: bool
## If bind names should be clipped to fit the [ActionBinder]'s size.
@export var clip_text := true

var list := VBoxContainer.new()
var controls := HBoxContainer.new()

var active_bind: HBoxContainer

@onready var default_binds: Array[InputEvent] =\
		_defaults.get(action,InputMap.action_get_events(action))
@onready var binds := SettingsManager.get_value("binds",action,default_binds).duplicate() as Array[InputEvent]
@onready var _defaults: Dictionary = SettingsManager.defaults.get("binds", {})


func _ready() -> void:
	if title.is_empty():
		title = action.to_pascal_case()
	add_child(list)
	# Setup defaults
	if _defaults.is_empty():
		SettingsManager.defaults.binds = {}
	if not _defaults.has(action):
		SettingsManager.defaults.binds[action] = default_binds
	# Add base controls
	var reset := Button.new()
	reset.text = "Reset binds"
	reset.connect("pressed", func():
		if not locked:
			reset_binds()
	)
	reset.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	controls.add_child(reset)
	var new := Button.new()
	new.text = "+"
	new.connect("pressed", func():
		if not locked and list.get_child_count() <= event_limit:
			create_bind()
	)
	controls.add_child(new)
	list.add_child(controls)
	# Add the binds
	for input in binds:
		create_bind(input)


func _input(event: InputEvent) -> void:
	if not active_bind or not event.is_action_type():
		return
	accept_event()
	if event.is_echo():
		return
	elif event.is_released():
		update_bind(active_bind, event)
		active_bind = null
	elif cancel_action and event.is_action(cancel_action):
		update_bind(active_bind)
		active_bind = null
		return


func reset_binds() -> void:
	for index in range(1,list.get_child_count()):
		list.get_child(1).free()
	binds.clear()
	SettingsManager.clear_key("binds",action)
	InputMap.action_erase_events(action)
	for input in default_binds:
		create_bind(input)


func create_bind(input: InputEvent = InputEventKey.new()) -> HBoxContainer:
	var h_box := HBoxContainer.new()
	# rebind button
	var rebind := Button.new()
	rebind.connect("pressed", func():
		if not locked:
			active_bind = h_box
			rebind.text = "..."
	)
	rebind.connect("focus_exited", func():
		if not locked:
			active_bind = null
			update_bind(h_box)
	)
	rebind.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rebind.clip_text = clip_text
	h_box.add_child(rebind)
	# add/remove button
	var remove := Button.new()
	remove.text = "-"
	remove.connect("pressed", func():
		if not locked:
			remove_bind(h_box)
			controls.get_child(1).grab_focus()
	)
	h_box.add_child(remove)
	list.add_child(h_box)
	update_bind(h_box, input)
	return h_box


func remove_bind(bind: HBoxContainer) -> void:
	var index := bind.get_index() - 1
	binds.remove_at(index)
	bind.queue_free()
	if are_binds_default():
		SettingsManager.clear_key("binds",action)
	else:
		SettingsManager.set_value("binds", action, binds)


func update_bind(bind: HBoxContainer, input: InputEvent = null) -> void:
	if bind.get_parent() == null:
		push_warning("Attempted to update a bind while not in the tree")
		return
	# Update the binds for this action
	var index := bind.get_index() - 1
	if input:
		if binds.size() == index:
			binds.append(input)
			InputMap.action_add_event(action, input)
		else:
			InputMap.action_erase_event(action,binds[index])
			binds[index] = input
			InputMap.action_add_event(action,input)
		# Update SettingsManager.config
		if are_binds_default():
			SettingsManager.clear_key("binds",action)
		else:
			SettingsManager.set_value("binds", action, binds)
	bind.get_child(0).text = _get_input_text(binds[index])


func are_binds_default() -> bool:
	var i: int = 0
	for input in default_binds:
		if not binds.size() > i or not input.is_match(binds[i]):
			return false
		i += 1
	return true


func _get_input_text(input: InputEvent) -> String:
	var out := ""
	if input is InputEventKey:
		out = OS.get_keycode_string(input.get_keycode_with_modifiers())
	elif input is InputEventMouseButton:
		out = input.as_text()\
			.replace("Left Mouse Button", "Left Click")\
			.replace("Right Mouse Button", "Right Click")\
			.replace("Middle Mouse Button","Middle Click")\
			.replace("Mouse Wheel Up", "Scroll Up")\
			.replace("Mouse Wheel Down", "Scroll Down")\
			.replace("Mouse Wheel Left", "Scroll Left")\
			.replace("Mouse Wheel Right", "Scroll Right")\
			.replace("Mouse Thumb Button 1", "Backward Click")\
			.replace("Mouse Thumb Button 2", "Forward Click")
	if out.is_empty():
		return input.as_text().replace(" - Physical", "")
	else:
		return out
