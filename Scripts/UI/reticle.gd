extends CenterContainer

@export var DOT_RADIUS := 1.
@export var DOT_COLOR := Color.WHITE

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2(0,0),DOT_RADIUS,DOT_COLOR)
