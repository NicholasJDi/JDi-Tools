@tool
extends HBoxContainer

@onready var dialog_edit: CodeEdit = $HSplitContainer/DialogueEdit
@onready var code: CodeEdit = $HSplitContainer/Code
@onready var compiler: Node = $Compiler
@onready var save: Button = $VBoxContainer/save

var file_location : String = ""

func Ready() -> void:
	dialog_edit.text = compiler.Decompile(file_location)
	code.text = compiler.Compile(dialog_edit.text)


func _process(delta: float) -> void:
	save.disabled = !FileAccess.file_exists(file_location)

func _on_new_pressed() -> void:
	get_parent().get_parent().New()

func _on_load_pressed() -> void:
	get_parent().get_parent().Load()

func _on_save_pressed() -> void:
	get_parent().get_parent().Save(compiler.Compile(dialog_edit.text), file_location)

func _on_save_as_pressed() -> void:
	var temp = get_parent().get_parent().get_tab_count()
	await get_parent().get_parent().Save_As(compiler.Compile(dialog_edit.text), file_location)
	if not temp == get_parent().get_parent().get_tab_count():
		queue_free()

func _on_close_pressed() -> void:
	queue_free()

func _on_dialogue_edit() -> void:
	code.text = compiler.Compile(dialog_edit.text)
