class_name SprintPlayerState
extends PlayerMovementState

func enter() -> void:
	PLAYER.speed = sprint_speed
	
	if ANIMATION.is_playing() and (ANIMATION.current_animation == "land_straight" or ANIMATION.current_animation == "land_left" or ANIMATION.current_animation == "land_right"):
		await ANIMATION.animation_finished
		ANIMATION.play("sprint", 0.5, 1.0)
	else:
		ANIMATION.play("sprint", 0.5, 1.0)
	
func update(delta) -> void:
	
	PLAYER.update_gravity(delta)
	PLAYER.update_movement(delta)
	PLAYER.update_velocity()
	
	set_animation_speed(PLAYER.current_speed)
	
	#region Transitions
	
	var moving = Vector2.ZERO
	if !immobile:
		moving = Input.get_vector(LEFT, RIGHT, FORWARD, BACKWARD)
	
	# No movement input
	if !moving:
		transition.emit(STATES.Idle)
		return
	
	# Jump Transition
	if continuous_jumping: # Hold down the jump button
		if Input.is_action_pressed(JUMP) and PLAYER.is_on_floor():
			transition.emit(STATES.Jumping)
			return
	else:	
		if Input.is_action_just_pressed(JUMP) and PLAYER.is_on_floor():
			transition.emit(STATES.Jumping)
			return
	
	# Falling Transition
	if PLAYER.velocity.y < 0 and !PLAYER.is_on_floor():
		jump_amount = max_jump_amount
		transition.emit(STATES.Falling)
		return
	
	# Hold to Sprint
	if sprint_mode == 0 and !Input.is_action_pressed(SPRINT):
		transition.emit(STATES.Walking)
		return
	
	# Press to Sprint
	elif sprint_mode == 1 and Input.is_action_just_pressed(SPRINT):
		transition.emit(STATES.Walking)
		return
	
	#endregion
