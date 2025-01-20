class_name Checkpoint
extends Area3D

static var last_checkpoint_position: Vector3

func _ready() -> void:
	if !body_entered.is_connected(_body_entered):
		body_entered.connect(_body_entered)

func _body_entered(_body: Node3D) -> void:
	Checkpoint.last_checkpoint_position = self.global_position	
