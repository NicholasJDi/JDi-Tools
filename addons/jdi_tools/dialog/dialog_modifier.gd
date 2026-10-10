@icon("modifier.png")
class_name DialogModifier
extends DialogObserver
## A helper node for modifying how JDiDialog acts.
##
## A helper node for modifying how JDiDialog acts.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_observer_type() -> String:
	return "modifier"
