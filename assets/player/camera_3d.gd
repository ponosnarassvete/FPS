extends Camera3D

@export var MAIN_CAMERA: Camera3D

func _ready() -> void:
	fov = MAIN_CAMERA.fov

func _process(_delta: float) -> void:
	global_transform = MAIN_CAMERA.global_transform
