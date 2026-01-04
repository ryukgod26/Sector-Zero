class_name  IdlePlayerState
extends State

@export var animation_player:AnimationPlayer

func update(delta: float) -> void:
	if Globals.player.velocity.length() > 0.0 and Globals.player.is_on_floor():
		transition.emit("WalkingPlayerState")

func enter() -> void:
	animation_player.pause()
