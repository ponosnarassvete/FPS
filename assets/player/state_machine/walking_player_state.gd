class_name WalkingPlayerState
extends PlayerMovementState

func enter() -> void:
	PLAYER.speed = base_speed
	
	if ANIMATION.is_playing() and (ANIMATION.current_animation == "land_straight" or ANIMATION.current_animation == "land_left" or ANIMATION.current_animation == "land_right"):
		await ANIMATION.animation_finished
		print("ive waiteed")
		ANIMATION.play("walk", -1.0, 1.0)
	else:
		ANIMATION.play("walk", -1.0, 1.0)

func update(delta) -> void:
	
	PLAYER.update_gravity(delta)
	PLAYER.update_movement(delta)
	PLAYER.update_velocity()
	
	set_animation_speed(PLAYER.current_speed)
	
	#region Transtitions
	
	var moving = Vector2.ZERO
	if !immobile:
		moving = Input.get_vector(LEFT, RIGHT, FORWARD, BACKWARD)
	
	# Idle Transition
	if !moving:
		if Glob.player.current_speed < 0.1:
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
	
	# Sprint Transition
	if !sprint_enabled:
		return
	
	if Input.is_action_pressed(SPRINT):
		transition.emit(STATES.Sprint)
		return
	
	#endregion
