class_name FallingPlayerState
extends PlayerMovementState

func enter():
	
	if jump_amount == -1:
		jump_amount = max_jump_amount
	
	ANIMATION.play("fall", 0.5, 1.0)
	
	PLAYER.velocity.y = clamp(PLAYER.velocity.y, -max_linear_velocity, max_linear_velocity) 

func update(delta) -> void:
	
	PLAYER.update_gravity(delta)
	PLAYER.update_movement(delta, 0.85)
	PLAYER.update_velocity()
	
	if PLAYER.velocity.y < -jump_velocity*2:
		ANIMATION.play("long_fall", -0.5, 1.0)
	
	if Input.is_action_just_pressed(JUMP) and jump_amount > 0:
		transition.emit(STATES.Jumping)
	
	if Input.is_action_just_released(JUMP) and PLAYER.velocity.y > 0:
		PLAYER.velocity.y /= 2
	
	if PLAYER.is_on_floor():
		transition.emit(STATES.Landing)
