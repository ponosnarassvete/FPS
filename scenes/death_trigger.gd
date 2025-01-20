class_name Death_Trigger
extends Area3D

## Used to end game immidiently or respawn
@export var perma_death: bool = false
@export var activated: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !body_entered.is_connected(_body_entered):
		body_entered.connect(_body_entered)

func _body_entered(body: Node3D) -> void:
	if !perma_death:
		body.global_position = CheckPoint.last_checkpoint_position
	else: 
		pass
