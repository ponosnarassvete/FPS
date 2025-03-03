class_name Note_Entry
extends Node3D

@export var entry_num: int = 0
var entry_ui: Entry_UI

func _ready() -> void:
	entry_ui = Glob.entry_ui

func interacted():
	print(entry_num)
	entry_ui.show_up(entry_num)

func cancel_interaction():
	entry_ui.show_down()
