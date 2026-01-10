class_name DoubleJumpingPlayerState
extends PlayerMovementState

@export var SPEED := 6.
@export var ACCELERATION := 0.1
@export var DEACCELERATION := 0.25

@export var double_jump_velocity := 4.5
@export_range(0.5,1.,0.01) var input_multiplier := 0.85

func enter(previous_state) -> void:
	PLAYER.velocity.y = double_jump_velocity
	animation_player.pause()

func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED * input_multiplier,ACCELERATION,DEACCELERATION)
	PLAYER.update_velocity()
	
	if PLAYER.is_on_floor():
		transition.emit("IdlePlayerState")
