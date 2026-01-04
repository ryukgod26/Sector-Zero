class_name WalkingPlayerState
extends State

func update(delta: float) -> void:
	if Globals.player.velocity.length() == 0:
		transition.emit("IdlePlayerState")
