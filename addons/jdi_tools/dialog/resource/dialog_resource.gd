@tool
class_name JDiDialog
extends Resource

## The Title of this Dialog Tree
@export var title := ""
## A list of Nodes, each node can include any amount of data and states to use
@export var nodes: Array[Dictionary] = []
## A list of Character ID's and their path's
@export var characters: Dictionary[String,JDiDialogCharacter] = {}
