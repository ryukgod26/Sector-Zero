class_name PlayerMovementState
extends State

var PLAYER: Player
var animation_player: AnimationPlayer

func _ready() -> void:
	await owner.ready
	PLAYER = owner as Player
	animation_player = PLAYER.animation_player
