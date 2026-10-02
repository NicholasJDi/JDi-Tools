@tool
extends Control

@onready var tab_container: TabContainer = $TabContainer
@onready var new: FileDialog = $New
@onready var load: FileDialog = $Load
@onready var save_as: FileDialog = $"Save As"

var config = ConfigFile.new()
var save_as_text

func _ready() -> void:
	Add_Default()

func get_tab_count() -> int:
	var count : int = 0
	for i in tab_container.get_children():
		if i.name != "Plugin Settings" and i.name != "Dialog Docs":
			count += 1
	return count

func _process(delta: float) -> void:
	if get_tab_count() == 0:
		Add_Default()

func New() -> void:
	new.current_path = "dialog_file.gd"
	new.show()

func Load() -> void:
	load.show()

func Save(text, file) -> void:
	file = FileAccess.open(file, FileAccess.WRITE)
	file.store_string(str(text))
	file.close()

func Save_As(text, file):
	save_as.current_path = file
	save_as_text = text
	save_as.show()
	await save_as_text.is_empty()

func Add_Default():
	var Dialog_File = preload("dialog_file.tscn").instantiate()
	tab_container.add_child(Dialog_File)
	Dialog_File.name = "Create Or Load A File"
	Dialog_File.get_child(1).get_child(1).visible = false
	Dialog_File.get_child(1).get_child(0).editable = false
	Dialog_File.get_child(1).get_child(0).highlight_current_line = false
	Dialog_File.get_child(1).get_child(0).minimap_draw = false
	Dialog_File.get_child(1).get_child(0).gutters_draw_line_numbers = false
	Dialog_File.get_child(0).get_child(2).disabled = true
	Dialog_File.get_child(0).get_child(3).disabled = true
	Dialog_File.get_child(0).get_child(4).disabled = true


func _on_new_file_selected(path: String) -> void:
	if not path.ends_with(".gd"):
		path = path + ".gd"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(tab_container.get_child(0).get_child(2).Compile(""))
	file.close()
	if get_tab_count() == 1:
		for i in tab_container.get_children():
			if i.name != "Plugin Settings" and i.name != "Dialog Docs":
				if i.name == "Create Or Load A File":
					i.queue_free()
	var Dialog_File = preload("dialog_file.tscn").instantiate()
	tab_container.add_child(Dialog_File)
	Dialog_File.file_location = path
	Dialog_File.name = path.get_file().replace(".gd","")
	Dialog_File.Ready()

func _on_load_file_selected(path: String) -> void:
	if not path.ends_with(".gd"):
		path = path + ".gd"
	for f in tab_container.get_children():
		if f.name != "Plugin Settings" and f.name != "Dialog Docs":
			if f.file_location == path:
				return
	if get_tab_count() == 1:
		for i in tab_container.get_children():
			if i.name != "Plugin Settings" and i.name != "Dialog Docs":
				if i.name == "Create Or Load A File":
					i.queue_free()
	var Dialog_File = preload("dialog_file.tscn").instantiate()
	tab_container.add_child(Dialog_File)
	Dialog_File.file_location = "res://" + path.replace("res://","")
	Dialog_File.name = path.get_file().replace(".gd","")
	Dialog_File.Ready()

func _on_save_as_file_selected(path: String) -> void:
	if not path.ends_with(".gd"):
		path = path + ".gd"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(save_as_text)
	file.close()
	var Dialog_File = preload("dialog_file.tscn").instantiate()
	tab_container.add_child(Dialog_File)
	Dialog_File.file_location = path
	Dialog_File.name = path.get_file().replace(".gd","")
	Dialog_File.Ready()
	save_as_text = ""
