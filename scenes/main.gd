extends Node3D

func _ready() -> void:
	$Level/Checkpoints/Temple_Island/Checkpoint._body_entered($Character)
