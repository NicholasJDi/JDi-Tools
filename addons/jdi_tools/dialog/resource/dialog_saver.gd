@tool
extends ResourceFormatSaver
class_name  JDiDialogSaver

func _recognize(resource):
	return resource is JDiDialog

func _get_recognized_extensions(resourse) -> PackedStringArray:
	return PackedStringArray(["jdd"])
