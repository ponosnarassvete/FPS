class_name Entry_UI
extends CanvasLayer

@onready var text_field: RichTextLabel = $TextureRect/MarginContainer/RichTextLabel

func _enter_tree() -> void:
	Glob.entry_ui = self
	
	visible = false

func show_up(text_num: int = 0):
	visible = true
	
	Glob.interfaced = true
	
	text_field.text = Glob.entries.get(text_num)

func show_down():
	
	Glob.interfaced = false
	
	visible = false
