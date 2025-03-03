@tool
extends Node3D

@export var WEAPON_TYPE: Weapon:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint():
			load_weapon()

@onready var weapon_mesh: MeshInstance3D = $Mesh
@onready var weapon_shadow: MeshInstance3D = $Shadow

var mouseInput: Vector2 = Vector2(0,0)
var random_sway: Vector2
var random_sway_amount: float
var time: float = 1.0
var idle_sway_adjustment
var idle_sway_rotation_strength

func _ready() -> void:
	load_weapon()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouseInput.x = event.relative.x
		mouseInput.y = event.relative.y


func load_weapon():
	weapon_mesh.mesh = WEAPON_TYPE.mesh
	position = WEAPON_TYPE.position
	rotation_degrees = WEAPON_TYPE.rotation
	weapon_shadow.visible = WEAPON_TYPE.shadow
	random_sway_amount = WEAPON_TYPE.idle_random_sway
	idle_sway_adjustment = WEAPON_TYPE.idle_sway_adjustment
	idle_sway_rotation_strength = WEAPON_TYPE.idle_sway_rotation_strength

func sway_weapon(delta):
	
	#var sway_random: float = get_sway_noise()
	
	mouseInput = mouseInput.clamp(WEAPON_TYPE.sway_min, WEAPON_TYPE.sway_max)
	
	position.x = lerp(position.x, WEAPON_TYPE.position.x - (mouseInput.x * WEAPON_TYPE.sway_amount_position) * delta, WEAPON_TYPE.sway_speed_position)
	position.y = lerp(position.x, WEAPON_TYPE.position.y + (mouseInput.y * WEAPON_TYPE.sway_amount_position) * delta, WEAPON_TYPE.sway_speed_position)
	rotation_degrees.x = lerp(rotation.x, WEAPON_TYPE.rotation.x - (mouseInput.x * WEAPON_TYPE.sway_amount_rotation) * delta, WEAPON_TYPE.sway_speed_rotation)
	rotation_degrees.y = lerp(rotation.y, WEAPON_TYPE.rotation.y + (mouseInput.y * WEAPON_TYPE.sway_amount_rotation) * delta, WEAPON_TYPE.sway_speed_rotation)

func _physics_process(delta: float) -> void:
	sway_weapon(delta)
