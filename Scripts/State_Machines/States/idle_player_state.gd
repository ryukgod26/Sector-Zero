class_name  IdlePlayerState
extends PlayerMovementState


func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_input()
	PLAYER.update_velocity()
	
	if Globals.player.velocity.length() > 0.0 and Globals.player.is_on_floor():
		transition.emit("WalkingPlayerState")

func enter() -> void:
	animation_player.pause()
