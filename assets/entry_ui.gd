class_name Entry_UI
extends CanvasLayer

@onready var text_field: RichTextLabel = $TextureRect/MarginContainer/RichTextLabel

func _enter_tree() -> void:
	add_to_group(ProjectGlobals.ui_group_name)
	
	visible = false

func show_up(text_num: int = 0):
	visible = true
	text_field.text = ProjectGlobals.entries.get(text_num)

func show_down():
	visible = false
