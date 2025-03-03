class_name LandingPlayerState
extends PlayerMovementState

var high_fall: bool = false

func enter():
	
	jump_amount = -1
	
	if ANIMATION.current_animation == "long_fall":
		high_fall = true
	
	if Input.is_action_pressed(LEFT):
		ANIMATION.play("land_left", 0.5, 0.5)
	elif Input.is_action_pressed(RIGHT):
		ANIMATION.play("land_right", 0.5, 0.5)
	else:
		ANIMATION.play("land_straight", 0.5, 0.5)
	
	PLAYER.velocity.y = clamp(PLAYER.velocity.y, -max_linear_velocity, max_linear_velocity) 

func exit():
	high_fall = false

func update(_delta) -> void:
	
	if !high_fall:
		transition.emit(STATES.Idle)
		return
	
	if ANIMATION.current_animation == "land_left" or ANIMATION.current_animation == "land_right" or ANIMATION.current_animation == "land_straight":
		await ANIMATION.animation_finished
		transition.emit(STATES.Idle)
	else:
		transition.emit(STATES.Idle)
