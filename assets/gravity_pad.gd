class_name Gravity_Pad
extends Node3D

@export var gravity_force: float = 12
static var standart_gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
static var standart_gravity_vector: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector")

@onready var up_point: Node3D = $Up
var up_vector: Vector3 = Vector3.UP

## Won't trigger gravity_reset
@export var permanent: bool = false
## Won't trigger gravity_change
@export var resetting: bool = false



func _ready() -> void:
	up_vector = self.global_position.direction_to(up_point.global_position)

func _on_gravity_area_body_entered(body: Node3D) -> void:
	if body is Player and !resetting:
		_gravity_change(body)
		if body is Player:
			body.STATE_MACHINE.on_child_transition(State.STATES.Jumping)


func _on_gravity_area_body_exited(body: Node3D) -> void:
	if body is Player and !permanent:
		_gravity_reset(body)

func _gravity_change(body: Node3D):
	if body is Player:
		body.gravity = gravity_force
		body.up_direction = -up_vector
		body.gravity_dir = up_vector
			

func _gravity_reset(body: Node3D):
	if body is Player:
		body.gravity = standart_gravity
		body.up_direction = -standart_gravity_vector
		body.gravity_dir = standart_gravity_vector
