class_name PlayerMovementState
extends State

var PLAYER: Player
var animation_player: AnimationPlayer
var weapon: WeaponController

func _ready() -> void:
	await owner.ready
	PLAYER = owner as Player
	animation_player = PLAYER.animation_player
	weapon = PLAYER.WEAPON_CONTROLLER
