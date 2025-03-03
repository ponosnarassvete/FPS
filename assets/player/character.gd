# COPYRIGHT Colormatic Studios
# MIT licence
# Quality Godot First Person Controller v2

class_name Player
extends CharacterBody3D

## The settings for the character's movement and feel.
@export_category("Character")
## The speed that the character moves at without sprinting.
@export var base_speed: float = 5.0
## The speed that the character moves at when sprinting.
@export var sprint_speed: float = 8.0

## How fast the character speeds up and slows down when Motion Smoothing is on.
@export var acceleration: float = 10.0
## How high the player jumps.
@export var jump_velocity: float = 8
## Total amount of possible jumps (0 - no jumoing allowed, 1 - regular, 2 - with double jump and etc.)
@export var max_jump_amount: int = 2
## How far the player turns when the mouse is moved.
@export var mouse_sensitivity: float = 0.1
## Invert the Y input for mouse and joystick
@export var invert_mouse_y: bool = false # Possibly add an invert mouse X in the future
## Wether the player can use movement inputs. Does not stop outside forces or jumping. See Jumping Enabled.
@export var immobile: bool = false
## The reticle file to import at runtime. By default are in res://addons/fpc/reticles/. Set to an empty string to remove.
@export_file var default_reticle

@export_group("Nodes")
## The node that holds the camera. This is rotated instead of the camera for mouse input.
@export var HEAD: Node3D
@export var CAMERA: Camera3D
@export var HEADBOB_ANIMATION: AnimationPlayer
@export var JUMP_ANIMATION: AnimationPlayer
@export var COLLISION_MESH: CollisionShape3D
@export var STATE_MACHINE: StateMachine

@export_group("Controls")
# We are using UI controls because they are built into Godot Engine so they can be used right away
@export var JUMP: String = "ui_accept"
@export var LEFT: String = "ui_left"
@export var RIGHT: String = "ui_right"
@export var FORWARD: String = "ui_up"
@export var BACKWARD: String = "ui_down"
## By default this does not pause the game, but that can be changed in _process.
@export var PAUSE: String = "ui_cancel"
@export var SPRINT: String = "sprint"
@export var SHOOT: String = "shoot"
@export var FULLSCREEN: String = "fullscreen_mode"
@export var RESPAWN: String = "respawn"

#Uncomment if you want controller support
@export var controller_sensitivity : float = 0.035
@export var LOOK_LEFT : String = "look_left"
@export var LOOK_RIGHT : String = "look_right"
@export var LOOK_UP : String = "look_up"
@export var LOOK_DOWN : String = "look_down"

@export_group("Feature Settings")
## Enable or disable jumping. Useful for restrictive storytelling environments.
@export var jumping_enabled: bool = true
## Wether the player can move in the air or not.
@export var in_air_momentum: bool = true
## Smooths the feel of walking.
@export var motion_smoothing: bool = true
@export var shooting_enabled: bool = true
@export var sprint_enabled: bool = true
@export_enum("Hold to Sprint", "Toggle Sprint") var sprint_mode: int = 0
## Wether sprinting should effect FOV.
@export var dynamic_fov: bool = true
## If the player holds down the jump button, should the player keep hopping.
@export var continuous_jumping: bool = true
## Enables the view bobbing animation.
@export var view_bobbing: bool = true
## Enables an immersive animation when the player jumps and hits the ground.
@export var jump_animation: bool = true
## This determines wether the player can use the pause button, not wether the game will actually pause.
@export var pausing_enabled: bool = true
## Use with caution.
@export var gravity_enabled: bool = true


# Member variables
var speed: float = base_speed
var current_speed: float = 0.0
var was_on_floor: bool = true # Was the player on the floor last frame (for landing animation)

# The reticle should always have a Control node as the root
var RETICLE: Control

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") # Don't set this as a const, see the gravity section in _physics_process
var gravity_dir: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector")

# Stores mouse input for rotating the camera in the phyhsics process
var mouseInput: Vector2 = Vector2(0,0)


func _init() -> void:
	Glob.player = self

func _ready():
	#It is safe to comment this line if your game doesn't start with the mouse captured
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# If the controller is rotated in a certain direction for game design purposes, redirect this rotation into the head.
	HEAD.rotation.y = rotation.y
	rotation.y = 0
	
	if default_reticle:
		change_reticle(default_reticle)
	
	# Reset the camera position
	HEADBOB_ANIMATION.play("RESET")
	
	check_controls()

func check_controls(): # If you add a control, you might want to add a check for it here.
	# The actions are being disabled so the engine doesn't halt the entire project in debug mode
	if !InputMap.has_action(JUMP):
		push_error("No control mapped for jumping. Please add an input map control. Disabling jump.")
		jumping_enabled = false
	if !InputMap.has_action(LEFT):
		push_error("No control mapped for move left. Please add an input map control. Disabling movement.")
		immobile = true
	if !InputMap.has_action(RIGHT):
		push_error("No control mapped for move right. Please add an input map control. Disabling movement.")
		immobile = true
	if !InputMap.has_action(FORWARD):
		push_error("No control mapped for move forward. Please add an input map control. Disabling movement.")
		immobile = true
	if !InputMap.has_action(BACKWARD):
		push_error("No control mapped for move backward. Please add an input map control. Disabling movement.")
		immobile = true
	if !InputMap.has_action(PAUSE):
		push_error("No control mapped for pause. Please add an input map control. Disabling pausing.")
		pausing_enabled = false
	if !InputMap.has_action(SPRINT):
		push_error("No control mapped for sprint. Please add an input map control. Disabling sprinting.")
		sprint_enabled = false
	if !InputMap.has_action(SHOOT):
		push_error("No control mapped for shoot. Please add an input map control. Disabling shooting")
		shooting_enabled = false


func change_reticle(reticle): # Yup, this function is kinda strange
	if RETICLE:
		RETICLE.queue_free()
	
	RETICLE = load(reticle).instantiate()
	RETICLE.character = self
	$UserInterface.add_child(RETICLE)


func _physics_process(_delta):
	# Big thanks to github.com/LorenzoAncora for the concept of the improved debug values
	current_speed = Vector3.ZERO.distance_to(get_real_velocity())
	$UserInterface/DebugPanel.add_property("Speed", snappedf(current_speed, 0.001), 1)
	$UserInterface/DebugPanel.add_property("Target speed", speed, 2)
	var cv: Vector3 = get_real_velocity()
	var vd: Array[float] = [
		snappedf(cv.x, 0.001),
		snappedf(cv.y, 0.001),
		snappedf(cv.z, 0.001)
	]
	var readable_velocity: String = "X: " + str(vd[0]) + " Y: " + str(vd[1]) + " Z: " + str(vd[2])
	$UserInterface/DebugPanel.add_property("Velocity", readable_velocity, 3)
	
	# Global
	RenderingServer.global_shader_parameter_set("player_position", global_position + Vector3(0,1,0))

	handle_head_rotation()
	
	if dynamic_fov: # This may be changed to an AnimationPlayer
		update_camera_fov()
	
	#if view_bobbing:
		#headbob_animation()
	
	#if jump_animation:
		#if !was_on_floor and is_on_floor(): # The player just landed
			#match randi() % 2: #TODO: Change this to detecting velocity direction
				#0:
					#JUMP_ANIMATION.play("land_left", 0.25)
				#1:
					#JUMP_ANIMATION.play("land_right", 0.25)
	
	was_on_floor = is_on_floor() # This must always be at the end of physics_process

func update_gravity(delta):
	$UserInterface/DebugPanel.add_property("Gravity", gravity, 5)
	$UserInterface/DebugPanel.add_property("Up Vector", up_direction, 6)
	$UserInterface/DebugPanel.add_property("Gravity Vector", gravity_dir, 7)
	$UserInterface/DebugPanel.add_property("Animtion", HEADBOB_ANIMATION.current_animation, 8)

	if not is_on_floor() and gravity and gravity_enabled:
		velocity += gravity_dir.normalized() * gravity * delta

func update_movement(delta, input_multiplayer:float = 1.0):
	
	var input_dir = Vector2.ZERO
	if !immobile: # Immobility works by interrupting user input, so other forces can still be applied to the player
		input_dir = Input.get_vector(LEFT, RIGHT, FORWARD, BACKWARD)
	
	var direction = input_dir.rotated(-HEAD.rotation.y)
	direction = Vector3(direction.x, 0, direction.y) + gravity_dir

	if in_air_momentum:
		if is_on_floor():
			if motion_smoothing:
				velocity.x = lerp(velocity.x, direction.x * speed * input_multiplayer, acceleration * delta)
				velocity.z = lerp(velocity.z, direction.z * speed * input_multiplayer, acceleration * delta)
			else:
				velocity.x = direction.x * speed * input_multiplayer
				velocity.z = direction.z * speed * input_multiplayer
	else:
		if motion_smoothing:
			velocity.x = lerp(velocity.x, direction.x * speed * input_multiplayer, acceleration * delta)
			velocity.z = lerp(velocity.z, direction.z * speed * input_multiplayer, acceleration * delta)
		else:
			velocity.x = direction.x * speed * input_multiplayer
			velocity.z = direction.z * speed * input_multiplayer

func update_velocity():
	move_and_slide()

func handle_head_rotation():
	HEAD.rotation_degrees.y -= mouseInput.x * mouse_sensitivity
	if invert_mouse_y:
		HEAD.rotation_degrees.x -= mouseInput.y * mouse_sensitivity * -1.0
	else:
		HEAD.rotation_degrees.x -= mouseInput.y * mouse_sensitivity
	
	# Uncomment for controller support
	#var controller_view_rotation = Input.get_vector(LOOK_DOWN, LOOK_UP, LOOK_RIGHT, LOOK_LEFT) * controller_sensitivity # These are inverted because of the nature of 3D rotation.
	#HEAD.rotation.x += controller_view_rotation.x
	#if invert_mouse_y:
		#HEAD.rotation.y += controller_view_rotation.y * -1.0
	#else:
		#HEAD.rotation.y += controller_view_rotation.y
	
	
	mouseInput = Vector2(0,0)
	HEAD.rotation.x = clamp(HEAD.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func update_camera_fov():
	if STATE_MACHINE.CURRENT_STATE is SprintPlayerState:
		CAMERA.fov = lerp(CAMERA.fov, 105.0, 0.1)
	else:
		CAMERA.fov = lerp(CAMERA.fov, 90.0, 0.1)


#func headbob_animation():
	#
	#var moving = Vector2.ZERO
	#if !immobile: # Immobility works by interrupting user input, so other forces can still be applied to the player
		#moving = Input.get_vector(LEFT, RIGHT, FORWARD, BACKWARD)
	#
	#if moving and is_on_floor():
		#var use_headbob_animation: String
		#if STATE_MACHINE.CURRENT_STATE is WalkingPlayerState:
				#use_headbob_animation = "walk"
		#elif STATE_MACHINE.CURRENT_STATE is SprintPlayerState:
				#use_headbob_animation = "sprint"
		#
		#var was_playing: bool = false
		#if HEADBOB_ANIMATION.current_animation == use_headbob_animation:
			#was_playing = true
		#
		#HEADBOB_ANIMATION.play(use_headbob_animation, 0.25)
		#HEADBOB_ANIMATION.speed_scale = (current_speed / base_speed) * 1.75
		#if !was_playing:
			#HEADBOB_ANIMATION.seek(float(randi() % 2)) # Randomize the initial headbob direction
			## Let me explain that piece of code because it looks like it does the opposite of what it actually does.
			## The headbob animation has two starting positions. One is at 0 and the other is at 1.
			## randi() % 2 returns either 0 or 1, and so the animation randomly starts at one of the starting positions.
			## This code is extremely performant but it makes no sense.
		#
	#else:
		#if HEADBOB_ANIMATION.current_animation == "sprint" or HEADBOB_ANIMATION.current_animation == "walk":
			#HEADBOB_ANIMATION.speed_scale = 1
			#HEADBOB_ANIMATION.play("RESET", 1)


func _process(_delta):
	$UserInterface/DebugPanel.add_property("FPS", Performance.get_monitor(Performance.TIME_FPS), 0)
	
	if Input.is_action_just_pressed(RESPAWN):
		Glob.overlay.respawn_event()
		await Glob.overlay.eyes_closed
		self.global_position = CheckPoint.last_checkpoint_position
		gravity_dir = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		velocity = Vector3.ZERO
	
	#if Input.is_action_just_pressed("exit"):
		#if !Glob.interfaced:
			#print(Glob.interfaced)
			#get_tree().quit()
	
	if Input.is_action_just_pressed(FULLSCREEN):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if pausing_enabled:
		if Input.is_action_just_pressed(PAUSE):
			# You may want another node to handle pausing, because this player may get paused too.
			match Input.mouse_mode:
				Input.MOUSE_MODE_CAPTURED:
					Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
					#get_tree().paused = false
				Input.MOUSE_MODE_VISIBLE:
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
					#get_tree().paused = false


func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouseInput.x += event.relative.x
		mouseInput.y += event.relative.y
	# Toggle debug menu
	elif event is InputEventKey:
		if event.is_released():
			# Where we're going, we don't need InputMap
			if event.keycode == 4194338: # F7
				$UserInterface/DebugPanel.visible = !$UserInterface/DebugPanel.visible
