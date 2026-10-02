@tool
class_name JDiDialogCharacter
extends Resource

## The Name of this character, also used as the ID
@export var name := ""
## The description of this character
@export_multiline var description := ""
## A list of Expression IDs and their Paths, 'default' is what will be initially loaded by icons.
@export var expressions: Dictionary[String, Texture2D] = {"default":preload("res://icon.svg")}
## A list of Sound IDs and their Paths, 'default' is what will be played by default.
@export var sounds: Dictionary[String,AudioStream] = {}
