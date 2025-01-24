class_name Jump_Pad
extends Node3D

@export var jump_force: float = 10.0

func _on_jump_area_body_entered(body: Node3D) -> void:
	if body is Player:
		body.velocity.y += jump_force
