class_name Overlay
extends CanvasLayer

signal eyes_closed()

@export var eye_animation: AnimationPlayer
@export var effects: Array[ColorRect] = []

func _enter_tree() -> void:
	Glob.overlay = self

func respawn_event():
	close_eyes()
	await eye_animation.animation_finished
	
	eyes_closed.emit()
	
	await get_tree().create_timer(0.25).timeout
	open_eyes()

func close_eyes():
	eye_animation.play("close")

func open_eyes():
	eye_animation.play("open")

func turn_effects(state: bool):
	for effect in effects:
		effect.visible = state
