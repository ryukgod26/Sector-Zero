@tool
extends Node3D

@export var weapon_type: Weapons:
	set(value):
		weapon_type = value
		if Engine.is_editor_hint():
			load_weapon()

@onready var weapon_mesh: MeshInstance3D = %WeaponMesh
@onready var weapon_shadow: MeshInstance3D = %WeaponShadow

func _ready() -> void:
	load_weapon()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("weapon1"):
		weapon_type = load("res://assets/Weapons/crowbar1/crowbar.tres")
		load_weapon()
	if Input.is_action_just_pressed("weapon2"):
		weapon_type = load("res://assets/Weapons/crowbar1/crowbar1.tres")
		load_weapon()

func load_weapon() -> void:
	weapon_mesh.mesh = weapon_type.mesh
	position = weapon_type.position
	rotation_degrees = weapon_type.rotation
	weapon_shadow.visible = weapon_type.shadow
