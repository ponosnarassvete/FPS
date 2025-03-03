class_name JumpingPlayerState
extends PlayerMovementState

func enter():
	ANIMATION.play("jump", 1.0, 1.0)
	
	if jump_amount == -1:
		jump_amount = max_jump_amount
	
	if Input.is_action_pressed(JUMP):
		jump_event()
	
	PLAYER.velocity.y = clamp(PLAYER.velocity.y, -max_linear_velocity, max_linear_velocity) 

func update(delta) -> void:
	
	PLAYER.update_gravity(delta)
	PLAYER.update_movement(delta, 0.85)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed(JUMP) and jump_amount > 0:
		jump_event()
	
	if Input.is_action_just_released(JUMP) and PLAYER.velocity.y > 0:
		PLAYER.velocity.y /= 2
	
	if PLAYER.velocity.y < 0:
		transition.emit(STATES.Falling)
		return
	
	if PLAYER.is_on_floor():
		transition.emit(STATES.Landing)
		return

func jump_event():
	jump_amount -= 1
	
	if PLAYER.velocity.y < jump_velocity:
		PLAYER.velocity.y = jump_velocity
	else:
		PLAYER.velocity.y += jump_velocity
