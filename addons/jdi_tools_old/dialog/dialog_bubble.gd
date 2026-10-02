@tool
extends Control

var background: NinePatchRect
var text: Label
var sound: AudioStreamPlayer2D

@export var character_name : String 
@export var talk_sound : AudioStream = preload("MI_SFX 17.mp3")
@export var audio_bus : String = "Master"
@export var current_text : String = "Sample Text"

func _init() -> void:
	text = Label.new()
	add_child(text)
	text.custom_minimum_size = Vector2(26,26)
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	background = NinePatchRect.new()
	text.add_child(background)
	background.texture = load("dialog_bubble.png")
	background.patch_margin_left = 13
	background.patch_margin_top = 13
	background.patch_margin_right = 13
	background.patch_margin_bottom = 13
	background.position = Vector2(-13,-8)
	background.show_behind_parent = true
	sound = AudioStreamPlayer2D.new()
	add_child(sound)

func _ready() -> void:
	if not Engine.is_editor_hint():
		DialogManager.characters.merge({character_name:self})

func _process(_delta: float) -> void:
	sound.stream = talk_sound
	sound.bus = audio_bus
	text.text = current_text
	size = Vector2(0,0)
	text.size = Vector2(0,0)
	text.position = Vector2(-(text.size.x / 2), -(text.size.y + 8))
	background.size = Vector2(text.size.x + 26, text.size.y + 16)
