extends SubViewport

var screen_size: Vector2

func _ready() -> void:
	
	set_window_size()
	
	get_window().size_changed.connect(set_size)

func set_window_size():
	screen_size = get_window().size
	size = screen_size 
