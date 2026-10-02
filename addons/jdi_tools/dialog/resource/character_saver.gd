@tool
extends ResourceFormatSaver
class_name  JDiDialogCharacterSaver

func _recognize(resource):
	return resource is JDiDialogCharacter

func _get_recognized_extensions(resourse) -> PackedStringArray:
	return PackedStringArray(["jddc"])
