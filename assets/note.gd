class_name Note_Entry
extends Node3D

@export var entry_num: int = 0
var entry_ui: Entry_UI

func _enter_tree() -> void:
	entry_ui = get_tree().get_first_node_in_group(ProjectGlobals.ui_group_name)

func interacted():
	print(entry_num)
	entry_ui.show_up(entry_num)

func cancel_interaction():
	entry_ui.show_down()
