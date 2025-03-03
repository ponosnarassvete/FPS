class_name Checkpoint
extends Area3D

signal checkpointed()

@export var probe_related: bool = false
@export var active_probes: Array[TurnableProbe] = []
## Low Priority ones
@export var lp_active_probes: Array[TurnableProbe] = []

static var last_checkpoint_position: Vector3

func _enter_tree() -> void:
	add_to_group(Glob.CHECKPOINT_GROUP)

func _ready() -> void:
	if !body_entered.is_connected(_body_entered):
		body_entered.connect(_body_entered)

func _body_entered(_body: Node3D) -> void:
	Checkpoint.last_checkpoint_position = self.global_position	
	if probe_related:
		checkpointed.emit(active_probes, lp_active_probes)
	else:
		checkpointed.emit()
