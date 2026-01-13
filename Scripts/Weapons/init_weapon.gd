@tool
extends Node3D

@export var weapon_type: Weapons:
	set(value):
		weapon_type = value
		if Engine.is_editor_hint():
			load_weapon()

@onready var weapon_mesh: MeshInstance3D = %WeaponMesh
@onready var weapon_shadow: MeshInstance3D = %WeaponShadow

var mouse_movement: Vector2

func _ready() -> void:
	load_weapon()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("weapon1"):
		weapon_type = load("res://assets/Weapons/crowbar1/crowbar.tres")
		load_weapon()
	if Input.is_action_just_pressed("weapon2"):
		weapon_type = load("res://assets/Weapons/crowbar1/crowbar1.tres")
		load_weapon()
	if event is InputEventMouseMotion:
		mouse_movement = event.relative

func load_weapon() -> void:
	weapon_mesh.mesh = weapon_type.mesh
	position = weapon_type.position
	rotation_degrees = weapon_type.rotation
	weapon_shadow.visible = weapon_type.shadow

func sway_weapon(delta) -> void:
	mouse_movement = mouse_movement.clamp(weapon_type.sway_min,weapon_type.sway_max)
	
	position.x = lerp(position.x,weapon_type.position.x - (mouse_movement.x * weapon_type.sway_amount_position) * delta, weapon_type.sway_speed_position)
	position.y = lerp(position.y,weapon_type.position.y + (mouse_movement.y * weapon_type.sway_amount_position) * delta, weapon_type.sway_speed_position)
	
	rotation_degrees.x = lerp(rotation_degrees.x, weapon_type.rotation.x - (mouse_movement.y * weapon_type.sway_speed_rotation) * delta, weapon_type.sway_speed_rotation)
	rotation_degrees.y = lerp(rotation_degrees.y, weapon_type.rotation.y - (mouse_movement.x * weapon_type.sway_speed_rotation) * delta, weapon_type.sway_speed_rotation)
	
func _physics_process(delta: float) -> void:
	sway_weapon(delta)
