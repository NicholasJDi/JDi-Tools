extends Node
##The Dialog Manger From The JDi Dialog Manager Plugin.

var characters : Dictionary
var character
var timer : Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.one_shot = true

func Run(File):
	var script = load(File)
	script.new()
	print("gddialog file %s has been started" % File)

func SelectChar(Char):
	character = characters[str(Char)]
	character.current_text = ""

func Say(Text):
	var char = character
	var loop_timer = Timer.new()
	add_child(loop_timer)
	loop_timer.start(.1)
	for i in Text:
		char.current_text += i
		await loop_timer.timeout
	remove_child(loop_timer)

func Wait(Seconds):
	timer.start(Seconds)
	await timer.timeout

func Reset():
	for i in characters:
		characters[i].current_text = ""
	characters.clear()
