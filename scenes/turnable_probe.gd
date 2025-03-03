class_name TurnableProbe
extends ReflectionProbe

var state: bool = false

## UM - update mode
@export var um_off: ReflectionProbe.UpdateMode = ReflectionProbe.UPDATE_ONCE
var um: ReflectionProbe.UpdateMode = ReflectionProbe.UPDATE_ONCE

# IM - interior mode
@export var im_off: bool = false
var im: bool = false

# AM - ambient mode
@export var am_off: ReflectionProbe.AmbientMode = ReflectionProbe.AMBIENT_DISABLED
var am: ReflectionProbe.AmbientMode = ReflectionProbe.AMBIENT_ENVIRONMENT

@export var visibility: bool = true

func _enter_tree() -> void:
	add_to_group(Glob.REFLECTION_GROUP)

func _ready() -> void:
	um = update_mode
	im = interior
	am = ambient_mode
	
	disable()

func enable() -> void:
	state = true
	
	update_um()
	update_im()
	update_am()
	
	visible = true

func disable() -> void:
	state = false
	
	update_um()
	update_im()
	update_am()
	
	visible = visibility

func update_um() -> void:
	if state:
		update_mode = um
	else:
		update_mode = um_off

func update_im() -> void:
	if state:
		interior = im
	else:
		interior = im_off
func update_am() -> void:
	if state:
		ambient_mode = am
	else:
		ambient_mode = am_off

func force_um(forced_um: ReflectionProbe.UpdateMode = ReflectionProbe.UPDATE_ONCE) -> void:
	update_mode = forced_um

func force_im(forced_im: bool = false) -> void:
	interior = forced_im

func force_am(forced_am: ReflectionProbe.AmbientMode = ReflectionProbe.AMBIENT_DISABLED) -> void:
	ambient_mode = forced_am
