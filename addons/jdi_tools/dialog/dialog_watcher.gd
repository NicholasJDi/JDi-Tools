@icon("watcher.png")
class_name DialogWatcher
extends DialogObserver
## A helper node for watching JDiDialog nodes for events and data.
##
## A helper node for watching JDiDialog nodes for events and data.

## 
signal event_requested
signal data_seen


func get_observer_type() -> String:
	return "watcher"
