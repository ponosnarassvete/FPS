class_name PlayerMovementState
extends State

@export var animation_speed: float = 2

var ANIMATION: AnimationPlayer
var PLAYER: Player = Glob.player

var immobile = Glob.player.immobile

var LEFT = Glob.player.LEFT
var RIGHT = Glob.player.RIGHT
var FORWARD = Glob.player.FORWARD
var BACKWARD = Glob.player.BACKWARD

var SPRINT = Glob.player.SPRINT
var sprint_mode = Glob.player.sprint_mode
var sprint_speed = Glob.player.sprint_speed
var sprint_enabled = Glob.player.sprint_enabled

var JUMP = Glob.player.JUMP
var continuous_jumping = Glob.player.continuous_jumping
var jump_velocity = Glob.player.jump_velocity
var max_jump_amount = Glob.player.max_jump_amount
static var jump_amount: int = 0

var base_speed = Glob.player.base_speed

var max_linear_velocity = ProjectSettings.get_setting("physics/jolt_3d/limits/max_linear_velocity")

func _ready() -> void:
	await owner.ready
	PLAYER = owner as Player
	ANIMATION = PLAYER.HEADBOB_ANIMATION

func set_animation_speed(speed) -> void:
	var alpha = remap(speed, 0.0, base_speed, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, animation_speed, alpha)
