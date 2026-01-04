class_name  IdlePlayerState
extends State

func update(delta: float) -> void:
	if Globals.player.velocity.length() > 0.0:
		transition.emit("WalkingPlayerState")
