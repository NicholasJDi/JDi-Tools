@tool
extends ResourceFormatLoader
class_name JDiDialogLoader

func _get_recognized_extensions() -> PackedStringArray:
	return PackedStringArray(["jdd"])

func _handles_type(type: StringName) -> bool:
	return type == "JDiDialog"

func _get_resource_type(path: String) -> String:
	return "Resource"
