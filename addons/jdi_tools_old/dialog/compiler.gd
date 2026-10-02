@tool
extends Node


func Decompile(file):
	file = FileAccess.open(file, FileAccess.READ)
	var f = file.get_as_text()
	file.close()
	f = f.split('"')
	return f[1]


func Compile(text):
	var code : String = 'extends DialogManager\n\nvar raw = "' + text + '"\n\n\nfunc _init() -> void:\n\tDialogManager.Wait(.1)'
	for line in text.split("\n"):
		var code_line = ""
		if line.contains(":"):
			var arr = line.split(":")
			var char = arr[0]
			var string = ""
			for i in arr:
				string = string + ":" +i
			line = string.replace(":" + char + ":","")
			code_line = "DialogManager.SelectChar(" + char + ")"
		elif line.begins_with("Wait["):
			code_line = "await DialogManager.Wait(" + line.replace("Wait[","").replace("]","") + ")"
			line = ""
		if not line.is_empty():
			if code_line.begins_with("DialogManager.SelectChar"):
				code_line = code_line + "\n\t"
			code_line = code_line + 'await DialogManager.Say("' + line + '")'
		code = code + "\n\t" + code_line
	return code
