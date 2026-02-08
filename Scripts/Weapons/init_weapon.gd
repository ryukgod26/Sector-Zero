@tool
class_name WeaponController
extends Node3D

@export var weapon_type: Weapons:
	set(value):
		weapon_type = value
		if Engine.is_editor_hint():
			load_weapon()
@export var sway_noise: NoiseTexture2D
@export var sway_speed := 1.2

@onready var weapon_mesh: MeshInstance3D = %WeaponMesh
@onready var weapon_shadow: MeshInstance3D = %WeaponShadow

signal weapon_fired

var mouse_movement: Vector2
var random_sway_x
var random_sway_y
var random_sway_amount: float
var time := 0.
var idle_sway_adjustment
var idle_sway_rotation_strength
var weapon_bob_amount := Vector2(0,0)

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
	idle_sway_adjustment = weapon_type.idle_sway_adjustment
	idle_sway_rotation_strength = weapon_type.idle_sway_rotation_strength
	random_sway_amount = weapon_type.random_sway_amount

func sway_weapon(delta, isIdle: bool) -> void:
	mouse_movement = mouse_movement.clamp(weapon_type.sway_min,weapon_type.sway_max)
	
	if isIdle:
		var sway_random := get_sway_noise()
		var sway_random_adjusted :float = sway_random * idle_sway_adjustment
		
		time += delta * (sway_speed + sway_random)
		random_sway_x = sin(time * 1.5 + sway_random_adjusted) / random_sway_amount
		random_sway_y = sin(time - sway_random_adjusted) / random_sway_amount
	
		position.x = lerp(position.x,weapon_type.position.x - (mouse_movement.x * weapon_type.sway_amount_position + random_sway_x) * delta, weapon_type.sway_speed_position)
		position.y = lerp(position.y,weapon_type.position.y + (mouse_movement.y * weapon_type.sway_amount_position + random_sway_y) * delta, weapon_type.sway_speed_position)
		
		rotation_degrees.x = lerp(rotation_degrees.x, weapon_type.rotation.x - (mouse_movement.y * weapon_type.sway_speed_rotation + (random_sway_x * idle_sway_rotation_strength)) * delta, weapon_type.sway_speed_rotation)
		rotation_degrees.y = lerp(rotation_degrees.y, weapon_type.rotation.y - (mouse_movement.x * weapon_type.sway_speed_rotation + (random_sway_x * idle_sway_rotation_strength)) * delta, weapon_type.sway_speed_rotation)

	else:
		position.x = lerp(position.x,weapon_type.position.x - (mouse_movement.x * weapon_type.sway_amount_position + weapon_bob_amount.x) * delta, weapon_type.sway_speed_position)
		position.y = lerp(position.y,weapon_type.position.y + (mouse_movement.y * weapon_type.sway_amount_position + weapon_bob_amount.y) * delta, weapon_type.sway_speed_position)
		
		rotation_degrees.x = lerp(rotation_degrees.x, weapon_type.rotation.x - (mouse_movement.y * weapon_type.sway_speed_rotation) * delta, weapon_type.sway_speed_rotation)
		rotation_degrees.y = lerp(rotation_degrees.y, weapon_type.rotation.y - (mouse_movement.x * weapon_type.sway_speed_rotation) * delta, weapon_type.sway_speed_rotation)

func get_sway_noise() -> float:
	var player_pos := Vector3(0,0,0)
	
	if not Engine.is_editor_hint():
		player_pos = Globals.player.global_position
	var noise_loc := sway_noise.noise.get_noise_2d(player_pos.x, player_pos.y)
	return noise_loc

func weapon_bob(delta, bob_speed: float, hbob_amount: float, vbob_amount: float) -> void:
	time += delta
	
	weapon_bob_amount.x = sin(time * bob_speed) * hbob_amount
	weapon_bob_amount.y = abs(cos(time * bob_speed) * vbob_amount)
	
#func _physics_process(delta: float) -> void:
	#weapon_bob(delta,5,0.02,0.01)

func _attack() -> void:
	weapon_fired.emit()
	var camera = Globals.player.CAMERA_CONTROLLER
	var space_state = camera.get_world_3d().direct_space_state
	var screen_center = get_viewport().size / 2
	var origin = camera.project_ray_origin(screen_center)
	var end = origin + camera.project_ray_normal(screen_center) * 1000
	var query = PhysicsRayQueryParameters3D.create(origin,end)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	#print(result)
	if result:
		apply_decal(result.get("position"), result.get("normal"))

func apply_decal(pos: Vector3, normal: Vector3) -> void:
	var decal = weapon_type.weapon_decal.instantiate()
	get_tree().root.add_child(decal)
	decal.global_position = pos
	decal.global_transform = decal.global_transform.looking_at(pos + normal, Vector3.UP)
	decal.rotate_object_local(Vector3.RIGHT, -PI/2)  # Rotate -90 degrees on X
	
	await get_tree().create_timer(2).timeout
	var fade_tween = create_tween()
	fade_tween.tween_property(decal,"modulate:a",0,1.5)
	await get_tree().create_timer(1.5).timeout
	decal.queue_free()
