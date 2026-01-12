extends SubViewport

@export var screem_size: Vector2

func _ready() -> void:
	screem_size = get_window().size
	size = screem_size  
