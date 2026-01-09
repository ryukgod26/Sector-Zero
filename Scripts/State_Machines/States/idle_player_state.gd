class_name  IdlePlayerState
extends PlayerMovementState

@export var SPEED := 5.
@export var ACCELERATION := 0.1
@export var DEACCELERATION := 0.25

func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DEACCELERATION)
	PLAYER.update_velocity()
	
	if Globals.player.velocity.length() > 0.0 and Globals.player.is_on_floor():
		transition.emit("WalkingPlayerState")

func enter() -> void:
	animation_player.pause()
