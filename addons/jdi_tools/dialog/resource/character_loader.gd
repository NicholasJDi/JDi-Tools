@tool
extends ResourceFormatLoader
class_name JDiDialogCharacterLoader


func _get_recognized_extensions() -> PackedStringArray:
	return ["jddc"]


func _handles_type(type: StringName) -> bool:
	return type == "JDiDialogCharacter"


func _get_resource_type(path: String) -> String:
	return "Resource"
