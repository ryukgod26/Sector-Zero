extends Control

@export var RETICAL_LINES: Array[Line2D]
@export var PLAYER_CONTROLLER: CharacterBody3D
@export var RETICLE_SPEED := 0.5
@export var RETICLE_DIST := 2.1
@export var DOT_RADIUS := 1.
@export var DOT_COLOR := Color.WHITE

func _ready() -> void:
	queue_redraw()

func _process(_delta: float) -> void:
	adjust_reticle_lines()

func _draw() -> void:
	draw_circle($Reticle.position,DOT_RADIUS,DOT_COLOR)

func adjust_reticle_lines():
	var vel = PLAYER_CONTROLLER.velocity
	var pos = Vector2(0,0)
	var speed = vel.length()
	
	#Top
	RETICAL_LINES[0].position = lerp(RETICAL_LINES[0].position,pos + Vector2(0, -speed*RETICLE_DIST),RETICLE_SPEED)
	#Right
	RETICAL_LINES[1].position = lerp(RETICAL_LINES[1].position,pos + Vector2(speed*RETICLE_DIST, 0),RETICLE_SPEED)
	#Bottom
	RETICAL_LINES[2].position = lerp(RETICAL_LINES[2].position,pos + Vector2(0, speed*RETICLE_DIST),RETICLE_SPEED)
	#Left
	RETICAL_LINES[3].position = lerp(RETICAL_LINES[3].position,pos + Vector2(-speed*RETICLE_DIST,0),RETICLE_SPEED)
