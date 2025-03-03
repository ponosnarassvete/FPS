class_name IdlePlayerState
extends PlayerMovementState

func enter() -> void:
	if ANIMATION.is_playing() and (ANIMATION.current_animation == "land_straight" or ANIMATION.current_animation == "land_left" or ANIMATION.current_animation == "land_right"):
		await ANIMATION.animation_finished
		ANIMATION.pause()
	else:
		ANIMATION.pause()

func update(delta) -> void:
	
	PLAYER.update_gravity(delta)
	PLAYER.update_movement(delta)
	PLAYER.update_velocity()
	
	#region Transitions
	
	var moving = Vector2.ZERO
	if !immobile:
		moving = Input.get_vector(LEFT, RIGHT, FORWARD, BACKWARD)
	
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
		transition.emit(STATES.Falling)
		return
	
	# Movement Transition
	if moving:
		transition.emit(STATES.Walking)
		return
	
	#endregion
