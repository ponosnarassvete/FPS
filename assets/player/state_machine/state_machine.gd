class_name StateMachine
extends Node

@export var CURRENT_STATE: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("StateMachine contains non-state nodes.")
	
	await owner.ready
	CURRENT_STATE.enter()

func _process(delta: float) -> void:
	CURRENT_STATE.update(delta)
	Glob.debug.add_property("State_Machine_State", CURRENT_STATE.name, 4)

func _physics_process(delta: float) -> void:
	CURRENT_STATE.physics_update(delta)

func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	
	if new_state == null:
		push_error(new_state, " - STATE DOES NOT EXIST.")
		return
	
	if new_state != CURRENT_STATE:
		CURRENT_STATE.exit()
		new_state.enter()
		CURRENT_STATE = new_state
