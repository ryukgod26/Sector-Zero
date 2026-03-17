@tool
class_name PickUpComponent
extends Node

@export var pickup_distance := Vector3(0,0,-1)

var parent
var object: Node3D
var picked_up := false

const pickup_lerp := .3

func _ready() -> void:
	parent = get_parent()
	if parent is InteractionComponent:
		parent.player_interacted.connect(update_state)

func _physics_process(_delta: float) -> void:
	if picked_up:
		var camera_transform = Globals.player.CAMERA_CONTROLLER.global_transform
		object.global_transform = object.global_transform.interpolate_with(camera_transform.translated_local(pickup_distance),pickup_lerp)

func _get_configuration_warnings() -> PackedStringArray:
	if parent is not InteractionComponent:
		return ["Node parent must be a Interaction Component."]
	else:
		return []

func _notification(what: int) -> void:
	if what == NOTIFICATION_ENTER_TREE:
		parent = get_parent()
		update_configuration_warnings()

func update_state(interactable: Node3D) -> void:
	if picked_up:
		picked_up = false
		if interactable is RigidBody3D:
			interactable.freeze = false
		object = null
	else:
		object = interactable
		picked_up = true
		if object is RigidBody3D:
			interactable.freeze = true
