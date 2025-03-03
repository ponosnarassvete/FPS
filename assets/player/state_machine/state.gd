class_name State
extends Node

@warning_ignore("unused_signal")
signal transition(new_state_name: StringName)

const STATES = Glob.STATES

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
